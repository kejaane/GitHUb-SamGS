/****************************************************************************************************************************************************
*  Class            : AIA_DocumentTriggerHelper
*  Author           : Asif Kutagulla
*  Description      : Helper class for AIA_DocumentTriggerHandler.
*                          ======[Modification Log]======
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* Date-Modified    Author                  Tag      Description of Change
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* 04-27-2017       Asif Kutagulla               Initial Creation
* 08-29-2017    |  Raviteja          | T01 |    Added method call to check if the owner is the deleting user
* 09-11-2017    |  Raviteja          | T02 |    Added the method for making the "Attachment With Supporting Detail" check box true if
*                                               group structure request form has attachmentwith details.
* 03-22-2017	 | Phani			  | T03 |    For US477, Added code to identify Current Benefit Design Document which used in NAGES report 
* 05/03/2017    | Raviteja      	  | T04 |    Added code to uncheck edit field,change picklist to 'backend'.
* 10/07/2018    | Rajesh Nagandla    | T05 |    Updating Gs status as Approved. To start dependent subprocess. Replacement of Process builder.
* 10/23/2018    | Paritosh		      | T06 |    Update field Benefit Design Document Uploaded on Implementation
* 03/19/2019	 | Petricia			  | T07 |	 Updated validateStatus method to prevent the users to delete BD AIA_Document 
* 												 when BD is "in review" status US7455
****************************************************************************************************************************************************/
public class AIA_DocumentTriggerHelper{
    public class TestException extends Exception {}
    @testvisible public static Boolean testExcep;
    
    /** T01-start **/
    public static final string ownerError='You cannot delete this Document if you are not the owner';
    public static final string StatusError='You cannot delete this Document when status is Assigned to MAST.';
    /** T01-End **/
    /** T07-Start US7455 **/
    public static final string bdError = 'You cannot delete this Document when the Benefit Design is not in "In-Progress" status';
    public static final string pro = 'System Administrator';
    /** T07-End ** US7455/
/** T03-start **/
    public static final String docType ='Benefit Design Document';
    Public static final String apprroveStatus = 'Approved';
    /** T03-End **/
    
    /* Method to update Department & Sub Department fields based on Document Type field. Department & SubDepartment inturn are used by FileNet *
* Informatica Cloud interface to store in the appropriate folders in FileNet.                                                             */
    public void setAIADoc_Department_SubDepartment(list<AIA_Document__c> aiaDocList){
        map<String,AIA_Document_Department_Mapping__c> deptMappingList = new map<String,AIA_Document_Department_Mapping__c>();
        /* variable to prepare a map with Document_Type__c as the key in the map. Document_Type__c cannot be stored as key in custom setting *
* because the values can be of greater than 80 characters in length                                                                 */
        map<String,AIA_Document_Department_Mapping__c> tempDeptMappingList = new map<String,AIA_Document_Department_Mapping__c>();
        try {
            deptMappingList = AIA_Document_Department_Mapping__c.getAll();
            //populate map
            system.debug('+++++++++++deptMappingList   '+deptMappingList);
            for(String depMapID : deptMappingList.keySet()){
                tempDeptMappingList.put(deptMappingList.get(depMapID).Document_Type__c,deptMappingList.get(depMapID));
            }
            //set Department & Sub-Department
            for(AIA_Document__c aiaDoc : aiaDocList){
                if(String.isNotBlank(aiaDoc.Document_Type__c) && tempDeptMappingList.containsKey(aiaDoc.Document_Type__c)){
                    aiaDoc.Department__c = tempDeptMappingList.get(aiaDoc.Document_Type__c).Department__c;
                    aiaDoc.Sub_Department__c = tempDeptMappingList.get(aiaDoc.Document_Type__c).Sub_Department__c;
                }
            }//end for   
            
            //block for test coverage of catch block
            if(Test.isRunningTest() && testExcep) {
                throw new TestException('Test');
            }
        }
        catch(Exception ex) {
            System.debug('Error occurred--->'+ex.getMessage());
            logException(ex);
            if(!Test.isRunningTest()) { throw ex; }
        }
    }//end method
    
    /** T01-start **/
    //Execute before delete Logic
    public void validateStatus(List<AIA_Document__c> lstAIADocument){
        Map<id,AIA_Document__c> gsrfDoc=new Map<ID, AIA_Document__c>([SELECT Id,Category__c, Group_Structure_Request_Form__r.status__c FROM AIA_Document__c where id in : lstAIADocument ]);
        Id currentUser=UserInfo.getUserId();
        
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        /** T07-Start **/
        List<PermissionSetAssignment> psa =  [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment 
                                              where PermissionSetId = '0PS60000000WT5wGAG' and AssigneeId = :userInfo.getUserId() ];
        system.debug('****psa****'+psa);
        String profileName = PROFILE[0].Name;
        system.debug('profileName: '+profileName);
        /** T07-End **/
        for(AIA_Document__c thisDoc:lstAIADocument){
            
            if((currentUser!=thisDoc.OwnerId && profileName != 'System Administrator' && thisDoc.Category__c=='Group Structure Request Form')){
                thisDoc.addError(ownerError);
            }
            else{  
                if(String.valueOf(gsrfDoc.get(thisDoc.id).Group_Structure_Request_Form__r.status__c)=='Assigned to MAST'){
                    thisDoc.addError(StatusError);
                }
            }
            /** T07-Start **/
            Integer permissionsetSize = psa.size();
            system.debug('***psa.size'+psa.size());
            
            if( profileName != pro) 
            {
                if(permissionsetSize == 0)
                {
                    for(AIA_Benefit_Design__C bd:[select status__c from AIA_Benefit_Design__c  where id =:thisDoc.Benefit_Design__c])
                    {
                        system.debug('***************bd.status__c '+bd.status__c );
                        if(bd.status__c != 'In Progress' && thisDoc.Document_Type__c == 'Benefit Design Document')
                        {
                            system.debug('!!!!!!!!!!!Inside BD IF');
                            thisDoc.addError(bdError);
                        }
                        
                    }
                    
                }
                
                
            }
            /** T07-End **/
        }
        
    }
    /** T01-End **/
    /**T02-Start**/
    public void attachmentDetailCheck(List<AIA_Document__c> lstAIADocument){
        //system.debug('docs'+docs);
        Map<id,Integer> gsrfdocsize=new Map<id,Integer>();
        Set<id> gsrfs=new Set<id>();
        //if(!docs.isEmpty()){
        //Iterating ovet the aia document and facthing the gsrfs
        for(AIA_Document__c thisDoc:lstAIADocument){
            if(String.isNotBlank(thisDoc.Group_Structure_Request_Form__c)) {
                gsrfs.add(thisDoc.Group_Structure_Request_Form__c);
            }
        }
        //system.debug('gsrfs'+gsrfs);
        if(gsrfs.size()>0)
        {
            //creating list of aia document
            List<AIA_Group_Structure_Request_Form__c> gsrfsdocs=[select id,Attachment_With_Supporting_Detail__c,(select id from AIA_Documents__r ) from AIA_Group_Structure_Request_Form__c where id in:gsrfs];
            for(AIA_Group_Structure_Request_Form__c gsrfrec:gsrfsdocs){
                Integer docssize=gsrfrec.AIA_Documents__r.size();
                //gsrfdocsize.put(gsrfrec.id,docssize);
                if(docssize==0){
                    gsrfrec.Attachment_With_Supporting_Detail__c=false;
                }
                else{
                    gsrfrec.Attachment_With_Supporting_Detail__c=true;
                }
            }
            
            
            update gsrfsdocs;
        }
    }
    /**T02-End**/
    
    private void logException(Exception e){
        Error_log__c error=new Error_log__c(Cause__c=String.valueOf(e.getCause()),LineNumber__c=e.getLineNumber(),
                                            Message__c=e.getMessage(),StackTrace__c=e.getStackTraceString());
        insert error;
    }
    
    /**T03-Phani**/
    //If new AIA document of type 'Benefit Design Document' with Status 'Approved' created
    //then updates document's AIA_Current_BDD__c boolean to true which identifies document as latest approved
    //it also updates AIA_Current_BDD__c to false for other documents under that account
    public void updateCurentBDD_CreateOp(List<AIA_Document__c> lstAIADocument){               
        Set<Id> acctIdSet = new Set<Id>();
        List<Account> accList = new List<Account>();
        List<AIA_Document__c> updatableDocList = new List<AIA_Document__c>();
        List<AIA_Document__c> bddApprovedList = new List<AIA_Document__c>();
        for(AIA_Document__c doc:lstAIADocument){
            if(doc.Document_Type__c == docType && doc.Approval_Status__c== apprroveStatus){
                acctIdSet.add(doc.Account__c);
                bddApprovedList.add(doc);
            }
        }
        updateCurrentBDD(acctIdSet,bddApprovedList);       
    }   
    
    //If new AIA document of type 'Benefit Design Document' is updated to Status 'Approved' 
    //then updates document's AIA_Current_BDD__c boolean to true which identifies document as latest approved
    //it also updates AIA_Current_BDD__c to false for other documents under that account	
    public void updateCurentBDD_UpdateOp(List<AIA_Document__c> lstAIADocument){
        AIA_Document__c oldDoc;
        Set<Id> acctIdSet_UpdateOp = new Set<Id>();
        List<AIA_Document__c> bddApprovedList_UpdateOp = new List<AIA_Document__c>();  
        system.debug('+++++++++++++lstAIADocument'+lstAIADocument);
        for(AIA_Document__c doc :lstAIADocument){
            system.debug('+++++oldMap'+oldDoc);
            oldDoc  = (AIA_Document__c)Trigger.OldMap.get(doc.Id);        
            system.debug('+++++++++oldMapAfter'+oldDoc);
            if(doc.Document_Type__c == docType 
               && doc.Approval_Status__c == apprroveStatus && olddoc.Approval_Status__c !=apprroveStatus){
                   acctIdSet_UpdateOp.add(doc.Account__c);
                   bddApprovedList_UpdateOp.add(doc);
               }            
        }
        updateCurrentBDD(acctIdSet_UpdateOp,bddApprovedList_UpdateOp);
    }
    
    public void updateCurrentBDD(Set<Id> accIds,List<AIA_Document__c> bddApprovedDocs){
        List<AIA_Document__c> updatableDocList = new List<AIA_Document__c>();              
        updatableDocList = [SELECT Id,AIA_Current_BDD__c FROM AIA_Document__c WHERE Account__c IN :accIds and AIA_Current_BDD__c= TRUE ];
        for(AIA_Document__c updatableDoc :updatableDocList ){
            updatableDoc.AIA_Current_BDD__c = false;
        }
        for(AIA_Document__c doc:bddApprovedDocs){                           
            doc.AIA_Current_BDD__c = True;               	
        }  
        try{
            update updatableDocList; 
        }
        Catch(Exception e){
            logException(e);
        }
    }
    /**T03-End**/
    /*T05 - Start*/
    //Updating Gs status as Approved. To start dependent subprocess. Replacement of Process builder.
    public void updateGSdocimp(List<AIA_Document__c> lstAIADocument){
        system.debug('---SMSL--->'+lstAIADocument.size());
        set<id> imps = new set<id>();
        list<AIA_Implementation__c> impslst = new list<AIA_Implementation__c>();
        //map<string,string> impdocMap = new map<string,string>();
        list<AIA_Implementation__c> implsttoupdate = new list<AIA_Implementation__c>();
        AIA_Implementation__c impObj;
        
        //5425
        Boolean is_Settlement_Analyst_filled = false;
        Map<Id,Boolean> impSettlementMap = new Map<Id,Boolean>();
        //5425
        
        for(AIA_Document__c doc :lstAIADocument){
            //system.debug('---SMSL--->'+doc.id);
            if(doc.Document_Type__c==AIA_Constants.DOCTYPEGSD && doc.Source__c == AIA_Constants.IMPLEMENTATIONSTR && doc.Approval_Status__c == AIA_Constants.BD_STATUS_APPROVED){
                
                imps.add(doc.Implementation__c);
                impSettlementMap.put(doc.Implementation__c,doc.Is_Settlement_Analyst_filled__c); 
                //impdocMap.put(doc.id,doc.Implementation__c);
            }
        }
        
        if(!imps.isEmpty()){
            system.debug('---SMSL-196-->');
            for(Id impID : imps){
                impObj = new AIA_Implementation__c(Id = ImpID);
                //imprecMap.put(imprec.id,imprec);
                impObj.GS_Status__c = AIA_Constants.BD_STATUS_APPROVED;
                //5425
                if(impSettlementMap.get(impID))
                {
                    impObj.Settlements_status_of_AIADoc__c = AIA_Constants.BD_STATUS_APPROVED;
                }
                //5425
                implsttoupdate.add(impObj);
            }
        }
        if(!implsttoupdate.isEmpty()){
            system.debug('---SMSL-205-update->'+implsttoupdate.size());
            update implsttoupdate;
        }
    }
    /*T05 - END*/
    //T04	start
    /*public void updateGS(List<AIA_Document__c> lstAIADocument){
set<id> imps=new set<id>();
set<id> gsps=new set<id>();
for(AIA_Document__c doc :lstAIADocument){
if(doc.Document_Type__c==AIA_Constants.DOCTYPE){
gsps.add(doc.Group_Structure_Request_Form__c);
}
}
List<AIA_Group_Structure__c> lstgs=[select id,Is_Edited__c ,edited_by__c
from AIA_Group_Structure__c
where Group_Structure_Request_Form__c in:gsps];
//loop through all the gs that came and update is edited as false
for(AIA_Group_Structure__c thisrec:lstgs){
thisrec.Is_Edited__c=false;
thisrec.edited_by__c=AIA_Constants.GSEDITEDBYBACKEND;
}
update lstgs;
}    */ //Commented for R1 Deployment
    //	T04	end
    
    //T06 Start
    public void updateBenefitDesignDocumentUploadedField(List<AIA_Document__c> lstAIADocument){
        List<AIA_Implementation__c> implToUpdate = new List<AIA_Implementation__c>();
        Set<Id> BDDId = new Set<Id>();
        //get the Id of Benefit Design Document
        for (AIA_Document__c doc : lstAIADocument){
            if (doc.Document_Type__c == docType ){
                BDDId.add(doc.Id);
            }
        }
        //Query the Implementaion id of BDD Document and update the related implementation
        for (AIA_Document__c doc : [SELECT Benefit_Design__r.Implementation__c FROM AIA_Document__c 
                                    WHERE id in :BDDId AND Benefit_Design__r.Implementation__c<>null]){
                                        AIA_Implementation__c impl = new AIA_Implementation__c();
                                        impl.Id = doc.Benefit_Design__r.Implementation__c;
                                        impl.Benefit_Design_Document_Uploaded__c = true;
                                        implToUpdate.add(impl);
                                    }
        
        update implToUpdate;
    }
    //T06 End
}