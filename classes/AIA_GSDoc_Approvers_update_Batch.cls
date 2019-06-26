public class AIA_GSDoc_Approvers_update_Batch implements Database.Batchable<sobject>,Database.Stateful,Schedulable{
    Map<Id,Map<String,Id>> accIdTeamMap;
     
    Public static final String MAST_Tech = 'MAST Tech';
    Public static final String Billing_Tech = 'Billing Tech';
    Public static final String Settlements_Analyst = 'Settlements Analyst';
	Public static final String QA_Auditor = 'QA Auditor';    
    Public static final String IManager = 'Implementation Manager';
    Public static final String Account_Manager='Account Manager';
    Public static final String rep ='Account Dedicated Representative';
    Map<Id,Id> usrManagerMap;
    Map<Id,String> mangerIdNameMap;
	public Database.QueryLocator start(Database.BatchableContext bc){ 
        
        //String query ='SELECT Id,Account__c,Approver_Ancillary_Analyst__c,Approval_Status_Analyst__c,Approver_Contract_Tech__c,AIA_Approval_Status_Contract_Tech__c,Approver_Benefit_Coder__c,AIA_Approval_Status_NASCO_Benefit_Coder__c,AIA_Approver_Benefact_Coder__c,AIA_Approval_Status_Benefact_Coder__c,AIA_Approver_MAST_Tech__c,Approval_Status_MAST_Tech__c,Approver_QA_Auditor__c FROM AIA_Benefit_Design__c WHERE Status__c='+'\'In Progress\'';
        String query ='SELECT Id,Account__c,Approver_Billing_Tech__c,Approver_Settlements_Tech__c,Approver_QA_Auditor__c,LGIT_Tech__c,Approver_Implementation_Team__c,Approver_Sales_Service_Rep__c,Approver_Account_Dedicated_Rep__c FROM AIA_Document__c WHERE Document_Type__c=\'Group Structure Document\' and (Document_Status__c !=\'Approved\' OR Document_Status__c !=\'Rejected\')';
        System.debug(query);
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<AIA_Document__c> scope) {
        //start usmanager map
         usrManagerMap = new Map<Id,Id>();
        List<AIA_Document__c> updatableDocs = new List<AIA_Document__c>();
        mangerIdNameMap = new Map<Id,String>();
        List<Id> informIMList = new List<Id>();
        List<AccountTeamMember> teamMemList;
        AccountTeamMember mem1;

        List<AIA_Area_Manager__c> userMappingList = [SELECT ID,Area_Manager__c,Delegated_Manager_1__c,Delegated_Manager_2__c,Delegated_Manager_1__r.email,
                                                     Delegated_Manager_1__r.isActive,Delegated_Manager_2__r.isActive,Delegated_Manager_2__r.email,
                                                     Delegated_Manager_2__r.Name,Delegated_Manager_1__r.Name
                                                     FROM AIA_Area_Manager__c 
                                                     WHERE AIA_isActive__c=false];
        
        //If user is inactive then delete corresponding Account team member and 
        //    Create Account Team Member with same details but assign to Manager1/Manager2
        for (AIA_Area_Manager__c usrRec: userMappingList){            
            if(usrRec.Delegated_Manager_1__c != NULL && usrRec.Delegated_Manager_1__r.isActive){
                usrManagerMap.put(usrRec.Area_Manager__c,usrRec.Delegated_Manager_1__c);
                mangerIdNameMap.put(usrRec.Delegated_Manager_1__c,usrRec.Delegated_Manager_1__r.Name);
            }
            else if(usrRec.Delegated_Manager_2__c != NULL && usrRec.Delegated_Manager_2__r.isActive){
                usrManagerMap.put(usrRec.Area_Manager__c,usrRec.Delegated_Manager_2__c);
                mangerIdNameMap.put(usrRec.Delegated_Manager_2__c,usrRec.Delegated_Manager_2__r.Name);
            }
            else{
                informIMList.add(usrRec.Area_Manager__c);                
            }
        }
        
        if(!informIMList.isEmpty()){
            getIMDetailsVer1(informIMList);
        } 
        
        
        //end
        
        
        Map<Id,String> docAccMap = new Map<Id,String>();
        accIdTeamMap = new Map<Id,Map<String,Id>>();
        for(AIA_Document__c doc : scope ){
            docAccMap.put(doc.Id,doc.Account__c);
        }
        getExistingTeam(docAccMap.values());
        List<Id> targetDocs=new List<Id>();
        for(AIA_Document__c aiaDoc: scope){
            String accId = docAccMap.get(aiaDoc.Id);
            Map<String,Id> roleUsrIdMap = new Map<String,Id>();
           roleUsrIdMap = accIdTeamMap.get(accId);
            
            Boolean updateDoc = false;
            if(roleUsrIdMap != null && roleUsrIdMap.size() > 0){
            if(roleUsrIdMap.keySet().contains(Billing_Tech)){
                if(aiaDoc.Approver_Billing_Tech__c != roleUsrIdMap.get(Billing_Tech)){
                    aiaDoc.Approver_Billing_Tech__c = roleUsrIdMap.get(Billing_Tech);
                    updateDoc = true;
                }
            }
            if(roleUsrIdMap.keySet().contains(Settlements_Analyst)){
                if(aiaDoc.Approver_Settlements_Tech__c != roleUsrIdMap.get(Settlements_Analyst)){
                    aiaDoc.Approver_Settlements_Tech__c = roleUsrIdMap.get(Settlements_Analyst);
                    updateDoc = true;
                }
                
            }
                
            if(roleUsrIdMap.keySet().contains(QA_Auditor)){
                if(aiaDoc.Approver_QA_Auditor__c != roleUsrIdMap.get(QA_Auditor)){
                    aiaDoc.Approver_QA_Auditor__c = roleUsrIdMap.get(QA_Auditor);
                    updateDoc = true;
                }
            }
            if(roleUsrIdMap.keySet().contains(MAST_Tech)){
                if(aiaDoc.LGIT_Tech__c != roleUsrIdMap.get(MAST_Tech)){
                    aiaDoc.LGIT_Tech__c = roleUsrIdMap.get(MAST_Tech);
                    updateDoc = true;
                }
            }
            if(roleUsrIdMap.keySet().contains(IManager)){
                if(aiaDoc.Approver_Implementation_Team__c != roleUsrIdMap.get(IManager)){
                    aiaDoc.Approver_Implementation_Team__c = roleUsrIdMap.get(IManager);
                    updateDoc = true;
                }
            }
            if(roleUsrIdMap.keySet().contains(Account_Manager)){
                if(aiaDoc.Approver_Sales_Service_Rep__c != roleUsrIdMap.get(Account_Manager)){
                    aiaDoc.Approver_Sales_Service_Rep__c = roleUsrIdMap.get(Account_Manager);
                    updateDoc = true;
                }
            }
			if(roleUsrIdMap.keySet().contains(rep)){
                if(aiaDoc.Approver_Account_Dedicated_Rep__c != roleUsrIdMap.get(rep)){
                    aiaDoc.Approver_Account_Dedicated_Rep__c = roleUsrIdMap.get(rep);
                    updateDoc = true;
                }
            }
            }
        
            if(updateDoc){
                updatableDocs.add(aiaDoc);
                targetDocs.add(aiaDoc.id);
            }
        }
            system.debug('updatableDocs@@'+updatableDocs);
            if(updatableDocs != NULL){
                Database.update(updatableDocs,false);
            }
            string s='';
            List<id> piid=new List<id>();
            system.debug('targetDocs'+targetDocs);
            system.debug('updatableDocs'+updatableDocs);
            system.debug('usrManagerMap'+usrManagerMap.keySet());
            
            List<ProcessInstanceWorkitem> pswi=[ SELECT id,ActorId 
                                                FROM ProcessInstanceWorkitem 
                                                where processInstance.targetObjectid in:targetDocs 
                                               and ActorId IN : usrManagerMap.keySet()
                                               ]; 
                            system.debug('pswi'+pswi);
            for(ProcessInstanceWorkitem thispswi:pswi){
                if(usrManagerMap.containsKey(thispswi.ActorId)){
                thispswi.ActorId=usrManagerMap.get(thispswi.ActorId);
                            system.debug('ps'+thispswi);

                }
            }
            system.debug('pswi'+pswi);
                update pswi;
            
    
            }
    public void finish(Database.BatchableContext bc) {
    }
    public void execute(SchedulableContext SC){
        AIA_GSDoc_Approvers_update_Batch updateGSDoc = new AIA_GSDoc_Approvers_update_Batch();
        Database.executeBatch(updateGSDoc, 200);
    }
    public void getExistingTeam(List<String> selectedAccs){           
        Map<Id,Map<Id,String>> accIdRoleMap = new Map<Id,Map<Id,String>>();
        System.debug('selectedAccs'+selectedAccs);
        List<AccountTeamMember> existingAccTeamMemList = new List<AccountTeamMember>();
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
        }
        System.debug('accIdTeamMap'+accIdTeamMap);
    }
    @TestVisible
    private void getIMDetailsVer1(List<Id> userIds){
        Map<Id,Id> userIMMap = new Map<Id,Id>();
        Map<Id,List<Id>> accUserMap = new Map<Id,List<Id>>();
        List<AccountTeamMember>  memList = [SELECT Id,AccountId,userId 
                                            FROM AccountTeamMember 
                                            WHERE userId IN :userIds];
        for(AccountTeamMember mem : memList){
            if(accUserMap.containskey(mem.AccountId)){              
                accUserMap.get(mem.AccountId).add(mem.userId);
            }
            else{
                List<Id> Ids = new List<Id>();
                Ids.add(mem.userId);
                accUserMap.put(mem.AccountId,Ids);
            }
        }
        List<AccountTeamMember> accTeamMemList =[SELECT Id,AccountId,UserId,Account.Name,User.Name 
                                                 FROM AccountTeamMember 
                                                 WHERE AccountId IN:accUserMap.keySet() and TeamMemberRole=:AIA_Constants.IMP_MANAGER];
        for(AccountTeamMember member : accTeamMemList){
           List<Id> usrIds = accUserMap.get(member.AccountId);
            for(Id usrId :usrIds){
                usrManagerMap.put(usrId,member.UserId);
                mangerIdNameMap.put(member.UserId,member.User.Name);
            }
        }
    }     
}