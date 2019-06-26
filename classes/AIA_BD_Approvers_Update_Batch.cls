/*=================================================================================================================
* Date         : 08/13/2018
* Developer    : Phanishankar P
* Purpose      : Update Benefit Design Record level approvers as per Account Team Members 
*=================================================================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 08/13/2018 | Phani          |     | Initial Version
* 11/28/2018 | Gayathri       | T01 | Replaced Nasco Benefit Coder with Benefit Tester and Benefit Coder as part of US 1730
* 12/04/2018 | Chaithra       | T02 | Replaced Ancillary Analyst with Vision Analyst or Pharmacy Operations as part of US1702
* 01/30/2019 | Satya T        | T03 | Replaced standard Account Team Member with Custom Account Team Member.
*===========+=================+=====+=============================================================================*/

public class AIA_BD_Approvers_Update_Batch implements Database.Batchable<sobject>,Database.Stateful,Schedulable{
    Map<Id,Map<String,Id>> accIdTeamMap;
    //Public static final String Ancillary_Analyst = 'Ancillary Analyst';//T02
    Public static final String Vision_Analyst='Vision Analyst';//T02
    Public static final String Pharmacy_Operations='Pharmacy Operations';//T02
    Public static final String Contract_Tech  = 'Contract Tech';
    //Public static final String NASCO_Benefit_Coder = 'NASCO Benefit Coder';//T01
    Public static final String Benefact_Coder = 'BeneFact Coder';
    Public static final String MAST_Tech = 'MAST Tech';
    Public static final String QA_Auditor = 'QA Auditor';
    Public static final String Approved = 'Approved';
    Public static final String Rejected = 'Rejected';
    Public static final String inProgress = 'In Progress';
    Public static final String inReview = 'In Review';
    Public static final String BENEFIT_TESTER = 'Benefit Tester';//T01
    public static final String BENEFIT_CODER = 'Benefit Coder';//T01
    
    public Database.QueryLocator start(Database.BatchableContext bc){ 
        
        //String query ='SELECT Id,Account__c,Approver_Ancillary_Analyst__c,Approval_Status_Analyst__c,Approver_Contract_Tech__c,AIA_Approval_Status_Contract_Tech__c,Approver_Benefit_Coder__c,AIA_Approval_Status_NASCO_Benefit_Coder__c,AIA_Approver_Benefact_Coder__c,AIA_Approval_Status_Benefact_Coder__c,AIA_Approver_MAST_Tech__c,Approval_Status_MAST_Tech__c,Approver_QA_Auditor__c FROM AIA_Benefit_Design__c WHERE Status__c='+'\'In Progress\'';
        //T01 -- Start -- Updated the approver and approval status of NASCO Benefit Coder with Benefit Tester and Benefit coder
        //T02 --Start -- Updated the approver and approval status of Ancillary Analyst with Vision Analyst or Pharmacy Operations
        String query ='SELECT Id,Account__c,Approver_Vision_Analyst__c,Approval_Status_Vision_Analyst__c,'+
            'Approver_Pharmacy_Operations__c,Approval_Status_Pharmacy_Operations__c,Approver_Contract_Tech__c,'+
            'AIA_Approval_Status_Contract_Tech__c,AIA_Approver_Benefit_Tester__c,AIA_Approval_Status_Benefit_Tester__c,'+
            'AIA_Approver_Benefact_Coder__c,AIA_Approval_Status_Benefact_Coder__c,AIA_Approver_MAST_Tech__c,'+
            'Approval_Status_MAST_Tech__c,Approver_QA_Auditor__c,Approver_QA_Auditor__r.isActive,AIA_Approver_MAST_Tech__r.isActive,'+
            'AIA_Approver_Benefact_Coder__r.isActive,Approver_Benefit_Coder__r.isActive,Approver_Contract_Tech__r.isActive,'+
            'Approver_Vision_Analyst__r.isActive,Approver_Pharmacy_Operations__r.isActive,AIA_Approver_Benefit_Coder__c,'+
            'AIA_Approval_Status_Benefit_Coder__c,AIA_Approver_Benefit_Coder__r.isActive,'+
            'AIA_Approver_Benefit_Tester__r.isActive FROM AIA_Benefit_Design__c    WHERE  status__c IN (\'' +inProgress+'\',\''+inReview+'\')';
        //T01 and T02-- End 
        System.debug(query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<AIA_Benefit_Design__c> scope) {
        
        Map<Id,String> bdAccMap = new Map<Id,String>();
        accIdTeamMap = new Map<Id,Map<String,Id>>();
        AIA_Utils errLogExp = new AIA_Utils();
        List<AIA_Benefit_Design__c> updatableBDs = new List<AIA_Benefit_Design__c>();
        try{
        for(AIA_Benefit_Design__c BD : scope ){
            bdAccMap.put(BD.Id,BD.Account__c);
        }
        getExistingTeam(bdAccMap.values());
        
        for(AIA_Benefit_Design__c bDesign: scope){
            String accId = bdAccMap.get(bDesign.Id);
            Map<String,Id> roleUsrIdMap = new Map<String,Id>();
           roleUsrIdMap = accIdTeamMap.get(accId);
            
            Boolean updateBD = false;
            if(roleUsrIdMap != null && roleUsrIdMap.size() > 0){
            /*T02 Start
            if(roleUsrIdMap.keySet().contains(Ancillary_Analyst)){
                if(bDesign.Approver_Ancillary_Analyst__c != NULL && bDesign.Approver_Ancillary_Analyst__c != roleUsrIdMap.get(Ancillary_Analyst) 
                   && bDesign.Approval_Status_Analyst__c != Approved 
                   && bDesign.Approval_Status_Analyst__c != Rejected && 
                   bDesign.Approver_Ancillary_Analyst__r.isActive == false){
                bDesign.Approver_Ancillary_Analyst__c = roleUsrIdMap.get(Ancillary_Analyst);
                updateBD =true;
                }
            }
            T02 End */
            //T02 Start    
            if(roleUsrIdMap.keySet().contains(Vision_Analyst)){
                if(bDesign.Approver_Vision_Analyst__c != NULL && bDesign.Approver_Vision_Analyst__c != roleUsrIdMap.get(Vision_Analyst) 
                   && bDesign.Approval_Status_Vision_Analyst__c != Approved 
                   && bDesign.Approval_Status_Vision_Analyst__c != Rejected && 
                   bDesign.Approver_Vision_Analyst__r.isActive == false){
                bDesign.Approver_Vision_Analyst__c = roleUsrIdMap.get(Vision_Analyst);
                updateBD =true;
                }
            }
            if(roleUsrIdMap.keySet().contains(Pharmacy_Operations)){
                if(bDesign.Approver_Pharmacy_Operations__c != NULL && bDesign.Approver_Pharmacy_Operations__c != roleUsrIdMap.get(Pharmacy_Operations) 
                   && bDesign.Approval_Status_Pharmacy_Operations__c != Approved 
                   && bDesign.Approval_Status_Pharmacy_Operations__c != Rejected && 
                   bDesign.Approver_Pharmacy_Operations__r.isActive == false){
                bDesign.Approver_Pharmacy_Operations__c = roleUsrIdMap.get(Pharmacy_Operations);
                updateBD =true;
                }
            }
            //T02 Ends    
            if(roleUsrIdMap.keySet().contains(Contract_Tech)){
                if(bDesign.Approver_Contract_Tech__c != NULL && bDesign.Approver_Contract_Tech__c != roleUsrIdMap.get(Contract_Tech) 
                   && bDesign.AIA_Approval_Status_Contract_Tech__c != Approved 
                   && bDesign.AIA_Approval_Status_Contract_Tech__c != Rejected 
                   && bDesign.Approver_Contract_Tech__r.isActive ==false){
                bDesign.Approver_Contract_Tech__c = roleUsrIdMap.get(Contract_Tech);
                updateBD =true;
                   }
            }
           //T01 -- Start
           /* if(roleUsrIdMap.keySet().contains(NASCO_Benefit_Coder)){
                if(bDesign.Approver_Benefit_Coder__c != NULL && bDesign.Approver_Benefit_Coder__c != roleUsrIdMap.get(NASCO_Benefit_Coder) 
                   && bDesign.AIA_Approval_Status_NASCO_Benefit_Coder__c != Approved && bDesign.AIA_Approval_Status_NASCO_Benefit_Coder__c != Rejected
                  && bDesign.Approver_Benefit_Coder__r.isActive ==false){
                bDesign.Approver_Benefit_Coder__c = roleUsrIdMap.get(NASCO_Benefit_Coder);
                updateBD =true;
                   }
            }*/
            if(roleUsrIdMap.keySet().contains(BENEFIT_TESTER)){
                if(bDesign.AIA_Approver_Benefit_Tester__c != NULL && bDesign.AIA_Approver_Benefit_Tester__c != roleUsrIdMap.get(BENEFIT_TESTER) 
                   && bDesign.AIA_Approval_Status_Benefit_Tester__c != Approved && bDesign.AIA_Approval_Status_Benefit_Tester__c != Rejected
                  && bDesign.AIA_Approver_Benefit_Tester__r.isActive ==false){
                bDesign.AIA_Approver_Benefit_Tester__c = roleUsrIdMap.get(BENEFIT_TESTER);
                updateBD =true;
                   }
            }
                 if(roleUsrIdMap.keySet().contains(BENEFIT_CODER)){
                if(bDesign.AIA_Approver_Benefit_Coder__c != NULL && bDesign.AIA_Approver_Benefit_Coder__c != roleUsrIdMap.get(BENEFIT_CODER) 
                   && bDesign.AIA_Approval_Status_Benefit_Coder__c != Approved && bDesign.AIA_Approval_Status_Benefit_Coder__c != Rejected
                  && bDesign.AIA_Approver_Benefit_Coder__r.isActive ==false){
                bDesign.AIA_Approver_Benefit_Coder__c = roleUsrIdMap.get(BENEFIT_CODER);
                updateBD =true;
                   }
            }
            //T01 -- End
                
            if(roleUsrIdMap.keySet().contains(Benefact_Coder)){
                if(bDesign.AIA_Approver_Benefact_Coder__c != NULL && bDesign.AIA_Approver_Benefact_Coder__c != roleUsrIdMap.get(Benefact_Coder) 
                   && bDesign.AIA_Approval_Status_Benefact_Coder__c != Approved 
                   && bDesign.AIA_Approval_Status_Benefact_Coder__c != Rejected
                  && bDesign.AIA_Approver_Benefact_Coder__r.isActive == false){
                bDesign.AIA_Approver_Benefact_Coder__c = roleUsrIdMap.get(Benefact_Coder);
                updateBD =true;
                   }
            }
            if(roleUsrIdMap.keySet().contains(MAST_Tech)){
                if(bDesign.AIA_Approver_MAST_Tech__c != NULL && bDesign.AIA_Approver_MAST_Tech__c != roleUsrIdMap.get(MAST_Tech) 
                   && bDesign.Approval_Status_MAST_Tech__c != Approved 
                   && bDesign.Approval_Status_MAST_Tech__c != Rejected
                  && bDesign.AIA_Approver_MAST_Tech__r.isActive == false){
                bDesign.AIA_Approver_MAST_Tech__c = roleUsrIdMap.get(MAST_Tech);
                updateBD =true;
                   }
            }
                
            if(bDesign.Approver_QA_Auditor__c != NULL && roleUsrIdMap.keySet().contains(QA_Auditor) && bDesign.Approver_QA_Auditor__r.isActive == false){
                
                bDesign.Approver_QA_Auditor__c = roleUsrIdMap.get(QA_Auditor);
                updateBD =true;
            }
            }
            if(updateBD){
                updatableBDs.add(bDesign);
                System.debug('BD ID '+bDesign.Id);
                                System.debug('BD rec '+bDesign);
            }
            
        }
        
        Database.SaveResult[] updateResult =Database.update(updatableBDs,false);
                System.debug('Error updateResult'+updateResult);

            for (Database.SaveResult r : updateResult)

{
if (!r.isSuccess())

{
for (Database.Error e : r.getErrors()) { System.debug('ErrorMsg'+e.getMessage()); }

}

}
        }
        Catch(Exception e){ errLogExp.logException(e);}
    }
    
    public void finish(Database.BatchableContext bc) {
        if(!Test.isRunningTest()){
        AIA_Workplan_BatchClass updateworkplans = new AIA_Workplan_BatchClass();
        Database.executeBatch(updateworkplans,50);
        }
    }        
    
    public void execute(SchedulableContext SC){
        AIA_BD_Approvers_Update_Batch updateBD = new AIA_BD_Approvers_Update_Batch();
        Database.executeBatch(updateBD, 50);
    }
    public void getExistingTeam(List<String> selectedAccs){           
        Map<Id,Map<Id,String>> accIdRoleMap = new Map<Id,Map<Id,String>>();
        System.debug('selectedAccs'+selectedAccs);
          /* T03 -- Start*/
      /*  List<AccountTeamMember> existingAccTeamMemList = new List<AccountTeamMember>();
        //Map<Id,Map<String,Id>> roleTeamMemRecIdMap = new Map<Id,Map<String,Id>>();
        Id accId;        
        existingAccTeamMemList = [SELECT Id,User.Name,user.id,TeamMemberRole,AccountId
                                  FROM AccountTeamMember 
                                  where AccountId IN :selectedAccs Order by AccountId];
        for(AccountTeamMember existMem : existingAccTeamMemList){ 
            accId = existMem.AccountId;
            //System.debug('accId'+accId);
            if(accIdTeamMap.get(accId) == NULL){
                Map<String,Id> accTeamMap = new Map<String,Id>();
                //Map<String,Id> roleTeamMemIdMap = new Map<String,Id>();
                accTeamMap.put(existMem.TeamMemberRole,existMem.user.Id);
                accIdTeamMap.put(accId,accTeamMap);                    
            }
            else{
                accIdTeamMap.get(accId).put(existMem.TeamMemberRole,existMem.user.Id);
            }
        }*/
        List<Account_Team__c> existingAccTeamMemList = new List<Account_Team__c>();
        //Map<Id,Map<String,Id>> roleTeamMemRecIdMap = new Map<Id,Map<String,Id>>();
        Id accId;        
        existingAccTeamMemList = [SELECT Id,UserId__r.Name,UserId__c,TeamMemberRole__c,AccountId__c
                                  FROM Account_Team__c
                                  where AccountId__c IN :selectedAccs Order by AccountId__c];
        for(Account_Team__c existMem : existingAccTeamMemList){ 
            accId = existMem.AccountId__c;
            //System.debug('accId'+accId);
            if(accIdTeamMap.get(accId) == NULL){
                Map<String,Id> accTeamMap = new Map<String,Id>();
                //Map<String,Id> roleTeamMemIdMap = new Map<String,Id>();
                accTeamMap.put(existMem.TeamMemberRole__c,existMem.UserId__c);
                accIdTeamMap.put(accId,accTeamMap);                    
            }
            else{
                accIdTeamMap.get(accId).put(existMem.TeamMemberRole__c,existMem.UserId__c);
            }
        }
          /*T03 --- End*/
        System.debug('accIdTeamMap'+accIdTeamMap);
    }

}