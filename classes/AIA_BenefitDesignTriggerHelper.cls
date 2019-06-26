/*=====================================================================================================================
* Date         : 08/08/2016
* Developer    : Sree Harsha
* Purpose      : BenefitDesign TriggerHelper to copy over the proposed products & groupers 
*                and Benefits into BD products when you create a Benefit Design. *              
*=====================================================================================================================
*                                 Update History
* -----------------------------------------------------------------------------------------------------------------
* Date       | Developer      | Tag |     Description
*============+============+===========================================================================================
* 08/08/2016 | Sree Harsha    |     | Initial Version                                         
* 10/15/2016 | Sree Harsha    | T00 | Updates the status of AIA Documents upon Benefit Design Approval.   
* 11/21/2016 | Asif Kutagulla | T01 | Added method to update revision number&date on associated implementation record. 
* 11/21/2016 | Indira Das     | T02 | Added changes for Custom Field check and default fields valies while cloning.
* 01/05/2017 | Asif Kutagulla | T03 | Removed reference to wellness__c & replaced it with Core_DM_Wellness__c. B-03445 
* 01/19/2017 | Asif Kutagulla | T04 | Story 3364.Auto-default field values from PCS operation 1 data in plan object for Drug.
* 12/13/2016 | Asif Kutagulla | T05 | Story3416.Changes to ensure only those Proposed Products are copied into Benefit 
*                                     Design Products which have Sub Group Account Same as corresponding implmentation
* 03/06/2017 | Rajesh Pennam  | T06 | User Story 3481. Included the field Identity Protection Mandate to copy over from
*                                     Medical PP to Medical BDP
* 03/06/2017 | Goutham Rapolu | T07 | StoryB-03711.Changes to Copy over fields from PP & Plan for Vision Products  
* 03/16/2017 | Goutham Rapolu | T08 | StoryB-03729.Copy over RxMandate fields from PP to BDP.                                      
* 03/17/2017 | Sree Harsha    | T09 | Story B-03681: Add additional fields on the BRF proposed products Dental Layout 
*                                       and those need to be copied over to BD Products while creation of BD Products.
* 03/31/2017 | Asif Kutagulla | T10 | Story B-03718. Changes to copy over Rider_Comments__c field. 
* 04/13/2017 | Rajesh Pennam  | T11 | User Story B-03436. Updated the fields "Non-MaintenanceDaysSupply&&MaintenanceDaysSupply"
*                                     to be copied from PP to BDP 
* 04/13/2017 | Asif Kutagulla |     | Removed references to changes for T06 as part B-03894 
* 04/16/2017 | RamaKrishna    | T13 | Added dental realted fields to copy from PP to BDP.
* 04/16/2017 | Asif Kutagulla | T14 | Added method setRevisionNumber.This is called when Benefit Design record is 
*                                     created. Removed changes related to T01.
* 05/05/2017 | Ramakrishna    | T15 | Added 'Stand_Alone_Disease_Management__c', 'Stand_Alone_Wellness__c' fields 
*                                       in the mapping to copy values from PP to BDP
* 05/19/2017 | Satya          | T16 | Added for drawloop
* 06/26/2017 | Satya          | T17 | Added Medical related fields as part of B-05109 US
* 08/21/2017 | Rajesh Pennam  | T18 | Added recursive check to insert and delete functionality
* 08/30/2017 | Sajitha Y      | T19 | Populating Fully Insured value from Plan US126
* 10/04/2017 | Asif Kutagulla | T20 | Added logic to update Ready for Filenet flag when Benefit Design associated with
*                                     the document is approved/rejected or when document itself is archived
* 10/04/2017 | Goutham Rapolu | T21 | Added a method to update the BD Status to In-Review US148 - BD Package
* 10/24/2017 | Goutham Rapolu | T22 | Added new mapping of fields from Proposed Product & Plan to BDP. 
* 11/13/2017 | Rajesh Pennam  | T24 | Added a new mapping of fields from BRF to BDP
* 11/30/2017 | Goutham Rapolu | T25 | Added logic to default field to N/A as per US 265.
* 12/28/2017 | satya          | T26 | Added logic as per US254
* 03/22/2018 | Raviteja		  | T27 | Story US479. Changes to copy over Non-Standard Fee Schedule,
									  Non-Standard Fee Schedule Comments field. 
* 09/5/2017  | Arshia G       | T28 |  Updated MHP section for US771
*============+============+===========================================================================================
*/

public without sharing class AIA_BenefitDesignTriggerHelper{
    //T14-Start
    public static boolean   AIARelatedAncDrawloop=false; // T18 Added By Rajesh
    
    public static void setRevisionNumber(list<AIA_Benefit_Design__c> lstBD) {
        try{
            list<Id> lstAcntID = new list<Id>();
            list<Account> lstAccountsToUpdate = new list<Account>();
            for(AIA_Benefit_Design__c bd : lstBD) {
                if(String.isNotBlank(bd.Account__c)) { lstAcntID.add(bd.Account__c); }
            }
            for(Account acc : [SELECT Id, AIA_BD_Revision_Number__c FROM Account WHERE Id IN :lstAcntID]) {
                if(acc.AIA_BD_Revision_Number__c == null){
                    acc.AIA_BD_Revision_Number__c = 1;
                }
                else{
                    acc.AIA_BD_Revision_Number__c = acc.AIA_BD_Revision_Number__c + 1; 
                }
                lstAccountsToUpdate.add(acc);   
            }
            if(!lstAccountsToUpdate.isEmpty()) { Database.update(lstAccountsToUpdate,False); }
        }
        catch(exception e){
        }
    }
    //T14-End
    
    //T00 - Start
    public static void updateAIADocument(List<AIA_Benefit_Design__c> BDList){
        list<AIA_Document__c> relatedDocumentList = [select id,Benefit_Design__c,Benefit_Design__r.Status__c, 
                                                     Benefit_Design__r.Approval_Status__c,Approval_Status__c    
                                                     from AIA_Document__c 
                                                     where Benefit_Design__c in:BDList and Benefit_Design__r.Status__c != 'In Review'];
        for(AIA_Document__c doc: relatedDocumentList){
            if(doc.Approval_Status__c!='Rejected'){
                if(doc.Benefit_Design__r.Status__c=='Rejected'){
                    doc.Approval_Status__c='Rejected';
                }
                if(doc.Benefit_Design__r.Status__c=='Approved'){
                    doc.Approval_Status__c='Approved';
                }
            }
            
        }
        if(relatedDocumentList.size()>0)
            update relatedDocumentList;
    }
    //T00 - End
    
    /*
    * @Author: Sree Harsha 
    * @This Method is called from BenefitDesignTriggerHandler during insertion of Benefit Design
    * @This method - The method copies the proposed products associated with BRF and creates respective BD products.
    * @param -  Map<id,AIA_Benefit_Design__c> 
    * @Output - Creates BD products based off of proposed products.
    */  
    public static void createBenefitDesignProduct(Map<id,AIA_Benefit_Design__c> BDmap){
        List<AIA_Benefit_Design__c> newBDList = BDmap.values();
        map<Id,AIA_Benefit_Design__c> mapBRFid_BD = new map<Id,AIA_Benefit_Design__c>();//T05-map of brf id vs bd record
        // try{
        set<id> brfIdSet = new set<id>();
        for(AIA_Benefit_Design__c bd:newBDList){
            brfIdSet.add(bd.Benefit_Request_Form__c);
            mapBRFid_BD.put(bd.Benefit_Request_Form__c,bd);//T05-populate map
        }
        system.debug('@@ brfIDSet'+brfIdSet);
        
        String QueryString=QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c', 'Benefit_Request_Form__c in :brfIdSet');
        
        List<Proposed_Products__c> PPList = Database.query(QueryString);
        list<Proposed_Products__c> relatedPPList = new list<Proposed_Products__c>();
        list<Proposed_Products__c> parentPPList = new list<Proposed_Products__c>();
        
        for(Proposed_Products__c pp: PPList){
            /* T05 - Added if check to compare proposed product record's sub group account is same as benefit design record's as Account. *
            * This ensures only those Proposed Products are copied into Benefit Design Products which have Account Same as corresponding *
            * Proposed Products Sub Group Account. When implementation is created Proposed Product Sub Group Account becomes             *
            * Implementation & Benefit Design's Account. This if check also ensures that this rule does not apply when Benefit Design's  *
            * account is empty */
            if(pp.Account_Has_Sub_Groups__c && String.isNotBlank(pp.Sub_Group_Account__c)) {
                if(mapBRFid_BD.get(pp.Benefit_Request_Form__c).Account__c != null && pp.Sub_Group_Account__c == mapBRFid_BD.get(pp.Benefit_Request_Form__c).Account__c) {
                    if(pp.Related_Medical_Product__c!=null){
                        relatedPPList.add(pp);
                    }
                    else{
                        parentPPList.add(pp); 
                    }                          
                }
            }
            else {
                if(pp.Related_Medical_Product__c!=null) {
                    relatedPPList.add(pp);
                }
                else {
                    parentPPList.add(pp); 
                }  
            }
        }
        list<AIA_Benefit_Design_Product__c> newBDPList = new list<AIA_Benefit_Design_Product__c>();
        list<AIA_Benefit_Design_Product__c> newParentBDPList = new list<AIA_Benefit_Design_Product__c>();
        list<AIA_Benefit_Design_Product__c> newRelatedBDPList = new list<AIA_Benefit_Design_Product__c>();
        newParentBDPList = getBDPList(parentPPList,false,null,newBDList);
        
        if(newParentBDPList.size()>0)
            insert newParentBDPList;
        
        newRelatedBDPList = getBDPList(relatedPPList,true,newParentBDPList,newBDList);
        if(newRelatedBDPList.size()>0)
            insert newRelatedBDPList;
        newBDPList.addAll(newParentBDPList);
        newBDPList.addAll(newRelatedBDPList);
        system.debug('@@ newBDPList'+newBDPList);
        
        //if(pp.Related_Medical_Product__c!=null){
        
        //Copying over Benefits attached to the BRF to BDP. 
        
        //Adding associated Proposed Products to a set      
        set<id> ppIdSet = new set<id>();
        for(AIA_Benefit_Design_Product__c bdp:newBDPList){
            ppIdSet.add(bdp.Proposed_Products__c);
        }
        system.debug('@@ppIdSet'+ppIdSet);
        
        
        //Querying the existing groupers & associated Benefits
        list<AIA_Grouper__c> existingGrouperList = new list<AIA_Grouper__c>();
        list<AIA_Benefits__c> existingBenefits = new list<AIA_Benefits__c>();
        Id PPRTypeId = Schema.SObjectType.AIA_Grouper__c.RecordTypeInfosByName.get('Proposed Product').RecordTypeId;
        Id benefitPPRTypeId = Schema.SObjectType.AIA_Benefits__c.RecordTypeInfosByName.get('Proposed Product').RecordTypeId;
        List<String> lstchildObjects = new List<string>();
        lstchildObjects.add('AIA_Benefits__c');
        String qry = QueryBase2.getSobjectAllFieldsSOQL('AIA_Grouper__c', 'recordTypeId=:PPRTypeId and Proposed_Products__c in: PPIdSet');
        System.debug('qry+++'+qry);        
        //query all the fields for clone to work
        existingGrouperList = Database.query(qry);
        
        
        Map<id,List<AIA_Benefits__c>> GrouperBenefitMap = new Map<id,List<AIA_Benefits__c>>();
        Map<id,List<Limitations__c>> BeneLimitationMap = new Map<id,List<Limitations__c>>();
        Map<string,List<Limitations__c>> BeneNameLimitationMap = new Map<string,List<Limitations__c>>(); 
        Map<string,Proposed_Products__c> BeneNameToPPMap = new Map<string,Proposed_Products__c>(); 
        Set<String> setNewBenefits = new Set<String>();  
        Map<string,AIA_Benefits__c> BeneNameToBenefit = new Map<string,AIA_Benefits__c>();        
        system.debug('&&&&&&&&&&&&&&&&&&&&&&& existingGrouperList'+existingGrouperList);
        Set<string> setGrpIds = new Set<String>();
        for(AIA_Grouper__c grouper : existingGrouperList){
            setGrpIds.add(grouper.id);            
        }
        String qry1 = QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefits__c', 'Grouper__c in: setGrpIds');
        System.debug('qry+++'+qry1);        
        //query all the fields for clone to work
        existingBenefits = Database.query(qry1);
        for(AIA_Benefits__c benefit : existingBenefits){
            if(GrouperBenefitMap.containsKey(benefit.Grouper__c))
            {
                GrouperBenefitMap.get(benefit.Grouper__c).add(benefit);  
            }
            else
            {
                GrouperBenefitMap.put(benefit.Grouper__c ,new List<AIA_Benefits__c> { benefit });
            }           
            
            
        }
        
        //T02 start added fields in query 
        List<Limitations__c> lmtsn = new List<Limitations__c>([SELECT Id, Name, Benefit__c, Benefit__r.benefit_name__C,comment_codes__c, IsSelected__c, Jurisdiction__c, 
                                                               MaxAge_Selected__c, MaxDuration_Selected__c, TierAge_Selected__c, TierLimit_Selected__c,
                                                               MandateIndicator__c, MandateName__c, MaxAgeFrom__c, MaxAgeTo__c, MaxAgeType__c, MaxApply__c, ParentBenefitName__c,
                                                               MaxDuration__c, MaxDurationType__c, MaxRow_Mandate_Description__c, MaxType__c, MaxValue__c, 
                                                               MaxDuration_High__c, MaxDuration_Increment__c, MaxDuration_Low__c, MaxDuration_Range__c, MaxDuration_Valid_Ranges__c, MaxRange_Type__c, 
                                                               MaxValue_High__c, MaxValue_Increment__c, MaxValue_Low__c, MaxValue_Range__c, MaxValue_Valid_Ranges__c, MaxRow_InValid_Ranges__c,  
                                                               TierLimit_Selected_Value__c, MaxAge_Selected_Value__c, MaxDuration_Selected_Value__c, TierAge_Selected_Value__c,
                                                               TierAgeFrom__c, TierAgeTo__c, TierAgeType__c, TierLimitDurationType__c, TierLimitFrom__c, RecordType__c ,
                                                               TierLimitTo__c, TierLimitType__c,IS_ASO_Only__c, Type__c, MaxRow_Value__c, Tier_Value__c, Code__c, IsRequired__c, Effective_Date__c, Term_Date__c  
                                                               FROM Limitations__c where Benefit__r.Grouper__c   in:GrouperBenefitMap.keySet()]);
        for(Limitations__c obj:lmtsn){
            List<Limitations__c> lmts=new List<Limitations__c>();
            if(BeneLimitationMap.containsKey(obj.Benefit__c)){
                lmts=BeneLimitationMap.get(obj.Benefit__c);
            }
            lmts.add(obj);
            BeneLimitationMap.put(obj.Benefit__c,lmts);
        }
        
        system.debug('@@GrouperBenefitMap'+GrouperBenefitMap);
        //Creating a Map between BDP & Grouper
        Map<id,List<AIA_Grouper__c>> BDPGrouperMap = new Map<id,list<AIA_Grouper__c>>();
        for(AIA_Benefit_Design_Product__c bdp:newBDPList){
            list<AIA_Grouper__c> tempGrouperList = new list<AIA_Grouper__c>();
            for(AIA_Grouper__c grouper : existingGrouperList){
                if(bdp.Proposed_Products__c ==grouper.Proposed_Products__c){
                    tempGrouperList.add(grouper);
                    BDPGrouperMap.put(bdp.id,tempGrouperList);
                    //continue;
                }
            }
        }
        system.debug('@@BDPGrouperMap'+BDPGrouperMap);
        Id BDRTypeId = Schema.SObjectType.AIA_Grouper__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
        Id benefitBDRTypeId = Schema.SObjectType.AIA_Benefits__c.RecordTypeInfosByName.get('BD Product').RecordTypeId;
        
        //Cloning Groupers
        list<AIA_Grouper__c> clonedGrouperList = new list<AIA_Grouper__c>();
        for(AIA_Benefit_Design_Product__c bdp:newBDPList){
            if(BDPGrouperMap.get(bdp.id)!=null){
                list<AIA_Grouper__c> tempclonedGrouperList = BDPGrouperMap.get(bdp.id);
                for(AIA_Grouper__c parentGrouper:tempclonedGrouperList){
                    AIA_Grouper__c clonedGrouper = new AIA_Grouper__c();
                    
                    clonedGrouper=parentGrouper.clone();
                    clonedGrouper.Benefit_Design_Product__c = bdp.id;
                    clonedGrouper.Cloned_From__c = parentGrouper.id;
                    clonedGrouper.recordTypeId=BDRTypeId;
                    clonedGrouper.Grouper_Record_Type__c = 'BRF';
                    clonedGrouper.Sequence_Number__c = parentGrouper.Sequence_Number__c;
                    clonedGrouperList.add(clonedGrouper);
                }
            }
        }
        if(clonedGrouperList.size()>0)
            insert clonedGrouperList;
        system.debug('@@clonedGrouperList'+clonedGrouperList);
        
        //------------------Clone Rx Mandates---T08--------------------------/
        //Querying the existing RxMandates 
        List<AIA_RxMandate__c> ExistingRxList = New List<AIA_RxMandate__c>();
        
        //query all the fields for clone to work
        String QSExistingRxList=QueryBase2.getSobjectAllFieldsSOQL('AIA_RxMandate__c','BRF_ID__c =:brfIdSet');
        ExistingRxList = database.query(QSExistingRxList);
        
        //Creating a Map between BDP & RxMandate
        Map<id,List<AIA_RxMandate__c>> BDPRxMap = new Map<id,list<AIA_RxMandate__c>>();
        for(AIA_Benefit_Design_Product__c bdp:newBDPList){
            list<AIA_RxMandate__c> tempRxList = new list<AIA_RxMandate__c>();
            for(AIA_RxMandate__c RxMan : ExistingRxList){
                if(bdp.Proposed_Products__c ==RxMan.Proposed_Products__c){
                    tempRxList.add(RxMan);
                    BDPRxMap.put(bdp.id,tempRxList);
                }
            }
        }
        system.debug('@@BDPRxMap'+BDPRxMap);
        
        
        //Cloning RxMandate
        list<AIA_RxMandate__c> clonedRxManList = new list<AIA_RxMandate__c>();
        for(AIA_Benefit_Design_Product__c bdp:newBDPList){
            if(BDPRxMap.get(bdp.id)!=null){
                list<AIA_RxMandate__c> tempclonedRxList = BDPRxMap.get(bdp.id);
                for(AIA_RxMandate__c parentRx:tempclonedRxList){
                    AIA_RxMandate__c clonedRx = new AIA_RxMandate__c();
                    
                    clonedRx=parentRx.clone();
                    
                    clonedRx.Mandate_Effective_Date__c= parentRx.Mandate_Effective_Date__c;
                    clonedRx.Mandate_Jurisdiction__c= parentRx.Mandate_Jurisdiction__c;
                    clonedRx.Mandate_Name__c= parentRx.Mandate_Name__c;
                    clonedRx.Mandate_Term_Date__c= parentRx.Mandate_Term_Date__c ;
                    If(parentRx.Mandate_Apply__c == true){
                        clonedRx.Mandate_Apply__c = True;
                    }
                    clonedRx.Mandate_Description__c = parentRx.Mandate_Description__c ;
                    clonedRx.Proposed_Products__c = null;
                    clonedRx.Benefit_Design_Product__c = BDP.id;
                    
                    //Add ClonedRxMandate record to List      
                    clonedRxManList.add(clonedRx);
                }
            }
        }
        //Insert Cloned List if List contains records
        if(clonedRxManList.size()>0)
            insert clonedRxManList;
        system.debug('@@clonedRxManList'+clonedRxManList);
        
        
        
        //-------------------Clone Rx Mandates------T08----------------------//
        
        //Cloning associated Benefits
        List<AIA_Benefits__c> clonedBenefitList = new list<AIA_Benefits__c>();
        if(clonedGrouperList.size()>0){
            for(AIA_Grouper__c clonedGrouper:clonedGrouperList){
                if(GrouperBenefitMap.get(clonedGrouper.Cloned_From__c)!=null){
                    list<AIA_Benefits__c> tempBenefitList = GrouperBenefitMap.get(clonedGrouper.Cloned_From__c);
                    system.debug('@@tempBenefitList'+tempBenefitList);
                    for(AIA_Benefits__c benefit:tempBenefitList){
                        AIA_Benefits__c clonedBenefit = new AIA_Benefits__c();
                        clonedBenefit=benefit.clone();
                        clonedBenefit.Grouper__c=clonedGrouper.id;
                        clonedBenefit.recordTypeId=benefitBDRTypeId;
                        clonedBenefit.Benefit_Record_Type__c = 'BRF';
                        clonedBenefit.Cloned_From_Benefit__c=benefit.id;
                        clonedBenefitList.add(clonedBenefit);
                        
                    }
                }
            }
        }
        system.debug('@@clonedBenefitList'+clonedBenefitList);
        if(clonedBenefitList.size()>0)
            insert clonedBenefitList;   
        
        //Cloning associated Benefits Limitations
        List<Limitations__c> clonedLimitList = new list<Limitations__c>();
        if(clonedBenefitList.size()>0){
            for(AIA_Benefits__c clonedBen:clonedBenefitList){
                if(BeneLimitationMap.get(clonedBen.Cloned_From_Benefit__c)!=null){
                    list<Limitations__c> tempLimitList = BeneLimitationMap.get(clonedBen.Cloned_From_Benefit__c);
                    system.debug('@@tempLimitList'+tempLimitList);
                    for(Limitations__c limi:tempLimitList){
                        Limitations__c clonedLimi = new Limitations__c();
                        clonedLimi=limi.clone();
                        clonedLimi.Benefit__c =clonedBen.id;
                        clonedLimitList.add(clonedLimi);
                        
                    }
                }
            }
        }            
        
        insert clonedLimitList;
        
        /*  }
        catch(exception e){
        system.debug('@@ in exception'+e.getMessage());
        }*/
        
    }
    
    public static  list<AIA_Benefit_Design_Product__c> getBDPList(list<Proposed_Products__c> ppList,boolean isRelated,list<AIA_Benefit_Design_Product__c> parentBDPList,List<AIA_Benefit_Design__c>  newBDList){
        //  try{
        list<AIA_Benefit_Design_Product__c> newBDPList = new list<AIA_Benefit_Design_Product__c>();
        Schema.DescribeSObjectResult d = Schema.SObjectType.AIA_Benefit_Design_Product__c; 
        Map<String,Schema.RecordTypeInfo> rtMapByNam  = d.getRecordTypeInfosByName();
        
        system.debug('@@ PPList '+PPList );
        Set<ID> ppPlanId= new Set<ID>();
        Set<ID> BRFID = new Set<ID>();
        for(Proposed_Products__c pp: PPList){
            ppPlanId.add(pp.Plan_Name__c);
            BRFID.add(pp.Benefit_Request_Form__c);
        }
        string QueryString=QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c', 'id in :ppPlanId');
        List<AIA_Plan__c> PlanList= Database.query(QueryString);
        Map<id,AIA_Plan__c> PPPlanMap= new Map<id,AIA_Plan__c>(PlanList);
        system.debug('@@ parentBDPList'+parentBDPList);
        
        string QueryStringBRF=QueryBase2.getSobjectAllFieldsSOQL('Benfit_Request_Form__c', 'id in :BRFID');
        List<Benfit_Request_Form__c> BRFList= Database.query(QueryStringBRF);
        Map<id,Benfit_Request_Form__c> PPBRFMap= new Map<id,Benfit_Request_Form__c>(BRFList);
        
        for(Proposed_Products__c pp: PPList){
            AIA_Plan__C ppPlan=new AIA_Plan__C();
            Benfit_Request_Form__c BRF = new Benfit_Request_Form__c();
            AIA_Benefit_Design_Product__c bdp = new AIA_Benefit_Design_Product__c();
            if(rtMapByNam.get(pp.PP_REcordtypeDeveloperName__c)!=null){
                ID bdpRecTypeId = (rtMapByNam.get(pp.PP_REcordtypeDeveloperName__c)).getRecordTypeId();
                bdp.RecordTypeId= bdpRecTypeId;
            }
            if(isRelated){
                
                for(AIA_Benefit_Design_Product__c parentBDP: parentBDPList){
                    system.debug('@@@ parentBDP Proposed_Products__c'+parentBDP.Proposed_Products__c);
                    if(parentBDP.Proposed_Products__c==pp.Related_Medical_Product__c){
                        system.debug('@@ in if');
                        bdp.Related_Medical_Product__c = parentBDP.id;
                        break;
                    }
                }
            }
            
            if(pp.Plan_Name__c!=null && PPPlanMap.containsKey(pp.Plan_Name__c))
                ppPlan=PPPlanMap.get(pp.Plan_Name__c);
            
            if(pp.Benefit_Request_Form__c!=null && PPBRFMap.containsKey(pp.Benefit_Request_Form__c))
                BRF=PPBRFMap.get(pp.Benefit_Request_Form__c);
            
            bdp.Proposed_Products__c = pp.id;
            
            bdp.Custom_New__c = pp.Custom_New__c;
            system.debug(Logginglevel.INFO,'@@bdp.Custom_New__c@@' + bdp.Custom_New__c );
            system.debug(Logginglevel.INFO,'@@pp.Custom_New__c@@' + pp.Custom_New__c);
            bdp.Benefit_Design__c=newBDList[0].id;
            bdp.Proposed_Products__c = pp.id;
            if(pp.Comments__c!=null)
                bdp.Comments__c=pp.Comments__c;
            if(pp.Account_Specified_Drug_Product_Name__c!=null)
                bdp.Account_Specified_Drug_Product_Name__c = pp.Account_Specified_Drug_Product_Name__c;
            if(pp.Account_Specified_Medical_Product_Name__c!=null)
                bdp.Account_Specified_Medical_Product_Name__c = pp.Account_Specified_Medical_Product_Name__c;
            if(pp.Account_Specified_Dental_Product_Name__c!=null)
                bdp.Account_Specific_Dental_Product_Name__c= pp.Account_Specified_Dental_Product_Name__c;
            if(pp.ARC_Approved__c!=null)
                bdp.ARC_Approved__c= pp.ARC_Approved__c;
            if(pp.Blue_Rewards__c!=null)
                bdp.Blue_Rewards__c = pp.Blue_Rewards__c;
            if(pp.BlueVision_Plus_Comments__c!=null)
                bdp.BlueVision_Plus_Comments__c = pp.BlueVision_Plus_Comments__c;
            if(pp.Cafeteria__c!=null)
                bdp.Cafeteria__c = pp.Cafeteria__c;
            if(pp.CDH__c!=null)
                bdp.CDH__c = pp.CDH__c;
            if(pp.CDH_Fund_Type__c!=null)
                bdp.CDH_Fund_Type__c = pp.CDH_Fund_Type__c;
            if(pp.CDH_Type__c!=null)
                bdp.CDH_Type__c = pp.CDH_Type__c;
            if(pp.Custom__c!=null)
                bdp.Custom__c = pp.Custom__c;
            if(pp.Custom_Wellness__c!=null)
                bdp.Custom_Wellness__c= pp.Custom_Wellness__c;
            if(pp.Deductible__c!=null)
                bdp.Deductible__c = pp.Deductible__c;
            // T09 - Start Here
            if(pp.Benefits_Renew__c!=null)
                bdp.Benefits_Renew__c = pp.Benefits_Renew__c;
            if(pp.Deductible_Applies__c!=null)
                bdp.Deductible_Applies__c = pp.Deductible_Applies__c;
            if(pp.Orthodontia_Endorsement__c!=null)
                bdp.Othrodontia_Endrosement__c = pp.Orthodontia_Endorsement__c;
            if(pp.Product_Parent_Name__c!=null)
                bdp.Product_Full_Name__c= pp.Product_Parent_Name__c;
            if(pp.PDPD_ID__c!=null)
                bdp.PDPD_ID__c = pp.PDPD_ID__c;
            // T09 - End Here
            if(pp.Dental_Product_Name__c!=null)
                bdp.Dental_Product_Name__c = pp.Dental_Product_Name__c;
            if(pp.Dental_Product_Options__c!=null)
                bdp.Dental_Product_Options__c = pp.Dental_Product_Options__c;
            if(pp.Dental_Variables_by_Product__c!=null)
                bdp.Dental_Variables_by_Product__c = pp.Dental_Variables_by_Product__c;
            if(pp.Drug_Product_Options__c!=null)
                bdp.Drug_Product_Options__c = pp.Drug_Product_Options__c;
            if(pp.Effective_Date__c!=null)
                bdp.Effective_Date__c = pp.Effective_Date__c;
            if(pp.Employer_Arrangement__c!=null)
                bdp.Employer_Arrangement__c = pp.Employer_Arrangement__c;
            if(pp.Exchange_CDH_Fund_Type__c!=null)
                bdp.Exchange_CDH_Fund_Type__c = pp.Exchange_CDH_Fund_Type__c;
            if(pp.Exchange_CDH_Type__c!=null)
                bdp.Exchange_CDH_Type__c = pp.Exchange_CDH_Type__c;
            if(pp.Exchange_Package_Option__c!=null)
                bdp.Exchange_Package_Option__c = pp.Exchange_Package_Option__c;
            if(pp.FSA_BlueFund__c!=null)
                bdp.FSA_BlueFund__c = pp.FSA_BlueFund__c;
            if(pp.Formulary_Picklist__c!=null)
                bdp.Formulary__c= pp.Formulary_Picklist__c;            
            if(pp.MailOrdDispnsNMaintDaysSupp__c!=null) //T11
                bdp.X1_Non_Maintenance_Days_Supply__c = pp.MailOrdDispnsNMaintDaysSupp__c; //T11
            if(pp.Funding_Arrangement__c!=null)
                bdp.Funding_Arrangement__c = pp.Funding_Arrangement__c;
            if(pp.Product_Financial_Arrangement__c!=null){
                bdp.Financial_Arrangement__c= pp.Product_Financial_Arrangement__c;
                /*    if(pp.Product_Financial_Arrangement__c == 'ASO'){
                bdp.Payment_Required__c = 'Risk 100% of Allowed Benefit';
                
                } else if(pp.Product_Financial_Arrangement__c == 'Risk'){
                bdp.Payment_Required__c = 'Non-Risk Percent of Allowed Benefit';
                } */
            }
            if(pp.Generic_Drugs_Tier_1__c!=null)
                bdp.Generic_Drugs_Tier_1__c= pp.Generic_Drugs_Tier_1__c;
            
            if(pp.Grandfathered_Status__c!=null)
                bdp.Grandfathered_Status__c = pp.Grandfathered_Status__c;
            //T17 CHANGES
            if(pp.INN_and_OON_Annual_Maximum_combined__c!=null)
                bdp.INN_and_OON_Annual_Maximum_combined__c= pp.INN_and_OON_Annual_Maximum_combined__c;
            if(pp.INN_and_OON_Lifetime_Maximum_combined__c!=null)
                bdp.INN_and_OON_Lifetime_Maximum_combined__c= pp.INN_and_OON_Lifetime_Maximum_combined__c;
            if(pp.INN_and_OON_OOP_Contribute_To_Each_Other__c!=null)
                bdp.INN_and_OON_OOP_Contribute_To_Each_Other__c= pp.INN_and_OON_OOP_Contribute_To_Each_Other__c;
            if(pp.Three_Month_Deductible__c !=null)    
                bdp.Three_Month_Deductible__c = pp.Three_Month_Deductible__c;
            //T17 CHANGES ENDS
            if(pp.Integrated_Care_Out_Vendor__c!=null)
                bdp.Integrated_Carved_Out_Vendor__c = pp.Integrated_Care_Out_Vendor__c;
            if(pp.Integrated_Deductible_Integrator__c!=null)
                bdp.Integrated_Deductibles__c= pp.Integrated_Deductible_Integrator__c;
            if(pp.Integrated_Deductibles_and_OOPs1__c!=null)
                bdp.Integrated_Deductibles_and_OOPs__c= pp.Integrated_Deductibles_and_OOPs1__c;
            if(pp.Jurisdiction__c!=null)
                bdp.Jurisdiction__c= pp.Jurisdiction__c;
            if(pp.Maintenance_Drugs__c!=null)
                bdp.Maintenance_Drugs__c= pp.Maintenance_Drugs__c;
            if(pp.Maintenance_Choice__c!=null)
                bdp.Maintenance_Choice__c= pp.Maintenance_Choice__c;
            if(pp.Maintenance_Choic_Comments__c!=null)
                bdp.Maintenance_Choic_Comments__c = pp.Maintenance_Choic_Comments__c;
            if(pp.Medical_Plan_Comments__c!=null)
                bdp.Medical_Plan_Comments__c = pp.Medical_Plan_Comments__c;
            if(pp.Medical_Product_Name__c!=null)
                bdp.Medical_Product_Name__c=pp.Medical_Product_Name__c;
            if(pp.Medical_Product_Option__c!=null)
                bdp.Medical_Product_Option__c=pp.Medical_Product_Option__c;
            //T28-Start
            /*
            if(pp.MHP_Test_Comments__c!=null)
                bdp.MHP_Test_Comments__c=pp.MHP_Test_Comments__c;
            if(pp.MHP_Test_Completed_Date__c!=null)
                bdp.MHP_Test_Completed_Date__c=pp.MHP_Test_Completed_Date__c;
            if(pp.MHP_Test_Completed_By__c!=null)
                bdp.MHP_Test_Completed_By__c=pp.MHP_Test_Completed_By__r.Name;
            if(pp.MHP_Test_Result__c!=null)
                bdp.MHP_Test_Result__c=pp.MHP_Test_Result__c;
			*/
            //T28-End
            if(pp.Network__c!=null)
                bdp.Network__c=pp.Network__c;
            if(pp.Non_preferred_Brand_Drugs_Tier_3__c!=null)
                bdp.Non_preferred_Brand_Drugs_Tier_3__c=pp.Non_preferred_Brand_Drugs_Tier_3__c;
            if(pp.Plan_Name__c!=null)
                bdp.Plan_Name__c=pp.Plan_Name__c;
            if(pp.Out_of_Pocket_Max__c!=null)
                bdp.Out_of_Pocket_Max__c=pp.Out_of_Pocket_Max__c;
            if(pp.Other_Requirements__c!=null)
                bdp.Other_Requirements__c=pp.Other_Requirements__c;
            if(pp.OralChemoMandateApply__c!=null)
                bdp.OralChemoMandateApply__c=pp.OralChemoMandateApply__c;
            if(pp.Product_Category__c!=null)
                bdp.Product_Category__c=pp.Product_Category__c;
            if(pp.Preferred_Brand_Drugs_Tier_2__c!=null)
                bdp.Preferred_Brand_Drugs_Tier_2__c=pp.Preferred_Brand_Drugs_Tier_2__c;
            if(pp.Preventive_Drugs_Affordable_Care_Act__c!=null)
                bdp.Preventive_Drugs_Affordable_Care_Act__c=pp.Preventive_Drugs_Affordable_Care_Act__c;
            if(pp.Product_Parent_Name__c!=null)
                bdp.Product_Full_Name__c=pp.Product_Parent_Name__c;
            if(pp.Product_Line__c!=null)
                bdp.Product_Line__c=pp.Product_Line__c;
            if(pp.Rider__c!=null)
                bdp.Rider__c=pp.Rider__c;
            bdp.Rider_Comments__c = pp.Rider_Comments__c;//T10
            if(pp.Type__c !=null)
                bdp.Type__c = pp.Type__c;
            //	T27 starts
            if(pp.Non_Standard_Fee_Schedule__c !=null)
                bdp.Non_Standard_Fee_Schedule__c = pp.Non_Standard_Fee_Schedule__c;
            if(pp.Non_Standard_Fee_Schedule_Comments__c !=null)
                bdp.Non_Standard_Fee_Schedule_Comments__c = pp.Non_Standard_Fee_Schedule_Comments__c;
            //	T27 end	
            if(pp.Product_Option__c!=null)
                bdp.Product_Option__c=pp.Product_Option__c;
            if(pp.Integrated_Non_Integrated__c!=null)
                bdp.Integrated_Non_Integrated__c=pp.Integrated_Non_Integrated__c;
            if(pp.RX_OOP_Max_Integration__c!=null)
                bdp.RX_OOP_Max_Integration__c=pp.RX_OOP_Max_Integration__c;
            if(pp.RXIntegration__c!=null)
                bdp.RX_Integration__c=pp.RXIntegration__c;
            if(pp.Standard_Network1__c!=null)
                bdp.Standard_Network__c=pp.Standard_Network1__c;
            if(pp.Self_administered_Injectable_Tier_4__c!=null)
                bdp.Self_administered_Injectable_Tier_4__c=pp.Self_administered_Injectable_Tier_4__c;
            if(pp.Integrated_OOP_Integration__c!=null)
                bdp.Integrated_OOP_Integration__c=pp.Integrated_OOP_Integration__c;
            bdp.Out_of_Pocket_Integrated__c=pp.Integrated_OOP_Integration__c;
            if(pp.Rebates_Withheld_by_CareFirstF1__c!=null)
                bdp.Rebates_Withheld_by_CareFirst__c=pp.Rebates_Withheld_by_CareFirstF1__c;
            if(pp.Vision_Product_Name__c!=null)
                bdp.Vision_Product_Name__c=pp.Vision_Product_Name__c;
            if(pp.Vision_Product_Options__c!=null)
                bdp.Vision_Product_Options__c=pp.Vision_Product_Options__c;
            // T07- Start             
            if(pp.X05_Options__c !=null)
                bdp.X05_Options__c = pp.X05_Options__c ;
            if(pp.X06_Renewal_Period__c  !=null)
                bdp.X06_Renewal_Period__c  = pp.X06_Renewal_Period__c ;
            if(pp.X07_Benefit_Renews__c !=null)
                bdp.X07_Benefit_Renews__c = pp.X07_Benefit_Renews__c ;
            if(pp.X08_Renewal_Type__c !=null)
                bdp.X08_Renewal_Type__c = pp.X08_Renewal_Type__c ;
            if(ppPlan.X05OptionsString__c !=null)
                bdp.X05_Options_String__c = ppPlan.X05OptionsString__c;
            if(ppPlan.X06RenewalPeriodString__c !=null)
                bdp.X06_Renewal_Period_String__c = ppPlan.X06RenewalPeriodString__c ;
            if(ppPlan.X07BenefitRenewsString__c !=null)
                bdp.X07_Benefit_Renews_String__c = ppPlan.X07BenefitRenewsString__c ;   
            if(pp.Vision_Comments__c !=null)
                bdp.Vision_Comments__c = pp.Vision_Comments__c ;        
            if(pp.Account_Specified_Vision_Product_Name__c !=null)
                bdp.Account_Specified_Vision_Product_Name__c = pp.Account_Specified_Vision_Product_Name__c ; 
            if(pp.Type__c !=null)
                bdp.Type__c = pp.Type__c ;
            if(pp.Vision_Benefit_Period__c !=null)
                bdp.Vision_Benefit_Period__c = pp.Vision_Benefit_Period__c ;
            //T-16 Added for drawloop
            if(pp.Service_Rep_Name_Phone_Drawloop__c  !=null)
                //bdp.Service_Rep_Name_Drawloop__c = pp.Service_Rep_Name_Phone_Drawloop__c  ;
                
                // T07 - END           
                
                bdp.custom_new__c = pp.custom_new__c;    
            bdp.Core_DM_Wellness__c = pp.Core_DM_Wellness__c;//T03
            //Added for RX -- By indira
            bdp.AIA_Magellan_Behavioral_Health__c=ppPlan.Magellan_Behavioral_Health__c;
            // T19 - Start          
            if(pp.PP_REcordtypeDeveloperName__c=='Medical' && pp.Funding_Arrangement__c =='Risk' && ( !ppPlan.Plan_Name__c.contains('PPO') || !ppPlan.Plan_Name__c.contains('Traditional')))
            {
                bdp.Fully_Insured__c=ppPlan.OON_Fully_Insured__c;
            }
            // T19- End
            bdp.AIA_INN_Contracted_Provider_Penalty__c=ppplan.INN_or_Contracted_Provider_Penalty__c;
            bdp.Addition_of_Platform_Indicator__c= pp.Addition_to_Platform_Indicator__c; // as per defect 35625
            
            //if(pp.PP_REcordtypeDeveloperName__c=='Drug'){
            bdp.AllergySerums__c= ppPlan.AllergySerums__c;
            bdp.DiabeticSuppCopayApply__c=ppPlan.DiabeticSuppCopayApply__c;
            bdp.DiabeticSuppDedApply__c=ppPlan.DiabeticSuppDedApply__c;
            bdp.DiabeticSuppMandateApply__c=pp.DiabeticSuppMandateApply__c;
            bdp.ErectileDysfunc_c__c=ppPlan.ErectileDysfunc__c;
            bdp.FertilityAgents__c=ppPlan.FertilityAgents__c;
            bdp.Generic_Dispensing__c=pp.Generic_Dispensing__c;
            bdp.HBSelectGeneric__c=ppPlan.HBSelectGeneric__c;
            bdp.GrowthHormone__c=ppPlan.GrowthHormone__c;//T04
            bdp.MailOrdDispnsMaintDaysSupp__c=ppPlan.MailOrdDispnsMaintDaysSupp__c;
            bdp.MailOrdDispnsNMaintDaysSupp__c=ppPlan.MailOrdDispnsNMaintDaysSupp__c;
            bdp.MailOrderAllDrugs__c=ppPlan.MailOrderAllDrugs__c;
            bdp.OralChemoCopayApply__c=ppPlan.OralChemoCopayApply__c;
            bdp.OralChemoDedApply__c=ppPlan.OralChemoDedApply__c;
            //bdp.OralChemoMandateApply__c=ppPlan.OralChemoMandateApply__c; Takes value from PP not Plan
            bdp.OTCCovered__c=ppPlan.OTCCovered__c;
            bdp.PrevntvCovrd__c=ppPlan.PrevntvCovrd__c;
            bdp.PrevntvDrugCopayAmount__c=ppPlan.PrevntvDrugCopayAmount__c;
            bdp.Prior_Authorization__c=string.valueof(pp.Prior_Authorization__c);
            bdp.RetDispnsMaintDaysSupp__c=ppPlan.RetDispnsMaintDaysSupp__c;
            bdp.RetDispnsNMaintDaysSupp__c=ppPlan.RetDispnsNMaintDaysSupp__c;
            bdp.RxFundamentalApply__c=ppPlan.RxFundamentalApply__c;
            bdp.RxFundamentalDedCopayRule__c=ppPlan.RxFundamentalDedCopayRule__c;
            bdp.TierCount__c=ppPlan.TierCount__c;
            bdp.Prescribed_Oral_Contraceptives_Devic__c=ppPlan.PrscrbdOrlContrcptvAndDevc__c;
            bdp.Carve_Out_Integration__c=pp.Carve_Out_Integration__c;
            bdp.Rebates_Withheld_by_CareFirst__c=pp.Rebates_Withheld_by_CareFirst__c;
            //T04 - Start Auto-default field values from PCS operation 1 data in plan object for Drug.
            bdp.Allergy_Serums_Limitation_Others__c = ppPlan.AllergySerumsComment__c;
            bdp.Erectile_Dysfunction_Limitation_Others__c = ppPlan.ErectileDysfuncComment__c;
            bdp.Fertility_Agents_Limitation_Others__c = ppPlan.FertilityAgentsComment__c;
            bdp.GeneriStepTherapy__c = pp.Generic_Step_Therapy__c;
            bdp.Notes__c = ppPlan.Notes__c;
            //bdp.Other_Requirements__c = ppPlan.Other_Requirements__c;
            bdp.Exclusive_Specialty_Provider_Network__c = pp.Exclusive_Specialty_Provider_Network__c;
            bdp.RetMailDispnsMaint__c = ppPlan.RetMailDispnsMaint__c;
            bdp.RetMailDispnsMaintLimitation__c = ppPlan.RetMailDispnsMaintLimitation__c;
            bdp.DeductibleAccumulatorMethod__c = pp.DeductibleAccumulatorMethod__c;
            bdp.OOPAccumulatorMethod__c = pp.Out_of_Pocket_Accumulator_Method__c;
            bdp.Accumulation_Period1__c = pp.Accumulation_Period__c;
            bdp.CareFirst_Formulary_Selection1__c = pp.CareFirst_Formulary_Selection__c;
            bdp.ExtraCare_Health_Care_Card1__c = pp.ExtraCare_Health_Care_Card__c;
            bdp.Product_Financial_Arrangement1__c = pp.Product_Financial_Arrangement__c;
            
            
            bdp.Plan__c = pp.Plan__c;
            bdp.Integrated_DM_Wellness__c = pp.Custom_Core_DM_Wellness__c ;
            bdp.All_Market_Segments__c = pp.All_Market_Segments__c;
            bdp.X01_Program__c = pp.X01_Program__c;
            bdp.Three_Month_Deductible__c = pp.Three_Month_Deductible__c;
            
            // T15 start
            bdp.Stand_Alone_Disease_Management__c = pp.Stand_Alone_Disease_Management__c  ;  
            bdp.Stand_Alone_Wellness__c = pp.Stand_Alone_Wellness__c  ;                                           
            // T15 End
            
            bdp.Maintenance_Days_Supply__c = pp.MailOrdDispnsMaintDaysSupp__c;
            bdp.X1_Non_Maintenance_Days_Supply__c = pp.MailOrdDispnsNMaintDaysSupp__c ;
            bdp.PrevntvDrugCopayAmount__c = pp.Preventive_Drugs_Copay_Amount__c ;
            bdp.Integrated_Ded_Indicator__c= pp.Integrated_Deductible_Integrator__c;
            //T22 - START          
            if(pp.funding_arrangement__c == 'Risk' && (pp.Jurisdiction__c == 'MD' || pp.Jurisdiction__c == 'VA')){
                bdp.General_Referrals__c = 'Yes';
            }else{bdp.General_Referrals__c= '';}
            if(pp.funding_arrangement__c == 'Risk' && (pp.Jurisdiction__c == 'MD' || pp.Jurisdiction__c == 'VA')){
                bdp.Referrals_Referral_to_a_Spl_or_N_Phy_Spl__c = 'Yes';
            }else{bdp.Referrals_Referral_to_a_Spl_or_N_Phy_Spl__c = '';}
            
            if(pp.funding_arrangement__c == 'Risk'){
                bdp.of_Allowed_for_Global_Procedures__c = '100% of Allowed Benefit';
                bdp.Payment_Required__c = '100% of Allowed Benefit';
                bdp.Common_Accident_Deductible__c = 'No';
                
            }
            bdp.BRCA__c = 'Yes';
            bdp.Religions_Exemption_Prerequisites1__c = 'Yes';
            bdp.Women_s_Preventive_Health_Services__c = 'Yes';
            bdp.Intimate_Partner_Violence_Screening__c = 'Yes';
            bdp.Global_Maternity_Services__c = 'Yes';
            bdp.Fall_Prevention__c = 'Yes';
            bdp.Enrollment__c = pp.Enrollment_Type__c;
            bdp.Family_Deductible_Calculation__c = pp.Family_Deductible_Calculation__c;
            BDP.Family_Deductible_CalculationPicklist__c = pp.Family_Deductible_Calculation__c;
            
            bdp.Religious_Exemption_Benefit_Selection__c=AIA_Constants.Religious_Exemption_Benefit_Selection;
            bdp.Benefit_Selection_Description__c = AIA_Constants.Benefit_Selection_Description;
            bdp.Emergency_Contraception_Exclusion_Desc__c = AIA_Constants.Emergency_Contraception_Exclusion_Desc;
            bdp.Full_Exclusion_Description__c = AIA_Constants.Full_Exclusion_Description;
            bdp.Integrated_OOP_Max_Carved_Out_Vendor__c = pp.Integrated_OOP_Max_Carved_Out_Vendor__c;
            
            bdp.Benefit_Period__c = BRF.Benefit_Period__c;
            bdp.Enrollment__c = BRF.Enrollment_Type__c;
            bdp.Grandfathered_PPACA_Status__c = BRF.Grandfathered_PPACA_Status__c;
            //T22 - END
            //T24 Starts Here
            bdp.ARC_Approval_Date1__c = BRF.ARC_Approval_Date__c;
            //T24 Ends Here
            if(ppPlan.INN_OON_Ded_Contribute_To_Each_Other__c!=null)
                bdp.INN_OON_Ded_Contribute_To_Each_Other__c= pp.INN_OON_Ded_Contribute_To_Each_Other__c;
            //T25 - Start
            if(ppPlan.Count_of_Networks__c == 1 && pp.product_category__c == 'Medical'){
               bdp.Common_Accident_Deductible__c = 'N/A';
               bdp.INN_OON_Ded_Contribute_To_Each_Other__c = 'N/A';
            } 
            //T25 - End.
            newBDPList.add(bdp);
            
        }
        return newBDPList;
        /*  }
        catch(exception e){
        system.debug('@@ in exception'+e.getMessage());
        return new List<AIA_Benefit_Design_Product__c>();
        }*/
    }
    
}