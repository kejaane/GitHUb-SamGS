/*=================================================================================================================
* Date         : 08/13/2018
* Developer    : Phanishankar P
* Purpose      : Update Owner of in progress workplan tasks to his Manager1/Manager2 
*=================================================================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 08/13/2018 | Phani          |     | Initial Version   
* 02/01/2019 | Satya T        | T01 | Replaced standard Account Team Member with Custom Account Team Member.                                  
*===========+=================+=====+=============================================================================*/
public class AIA_Workplan_BatchClass implements Database.Batchable<sobject>,Database.Stateful,Schedulable{    
    Map<Id,Map<Id,String>> accIdTeamMap;     
    Map<Id,Id> usrManagerMap;
    Map<Id,String> mangerIdNameMap;
    List<Workplan_Task__c> wptsks;
    public Database.QueryLocator start(Database.BatchableContext bc){        
        String query = 'SELECT Id, Name FROM User WHERE IsActive=false'; 
        if (Test.isRunningTest()) query+=' AND lastname=\'Testing\'';
        return Database.getQueryLocator(query);
    }
    public void execute(SchedulableContext SC){
        AIA_AccTeamMemUpdate_Batch memUpdateBatch = new AIA_AccTeamMemUpdate_Batch();
        Database.executeBatch(memUpdateBatch, 200);
    }
    public void execute(Database.BatchableContext bc, List<User> scope) {
        AIA_Utils errLogExp = new AIA_Utils();
        accIdTeamMap = new Map<Id,Map<Id,String>>();
        usrManagerMap = new Map<Id,Id>();
        mangerIdNameMap = new Map<Id,String>();
        List<Id> informIMList = new List<Id>();
        /*T01 start*/
        //List<AccountTeamMember> teamMemList;
        //AccountTeamMember mem1;
        List<Account_Team__c> teamMemList;
        Account_Team__c mem1;
        /* T01 End*/

        List<AIA_Area_Manager__c> userMappingList = [SELECT ID,Area_Manager__c,Delegated_Manager_1__c,Delegated_Manager_2__c,Delegated_Manager_1__r.email,
                                                     Delegated_Manager_1__r.isActive,Delegated_Manager_2__r.isActive,Delegated_Manager_2__r.email,
                                                     Delegated_Manager_2__r.Name,Delegated_Manager_1__r.Name
                                                     FROM AIA_Area_Manager__c 
                                                     WHERE Area_Manager__c IN:scope ];
        
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
        
        List<Workplan_Task__c> wptsks=[select id,OwnerId
                                       from Workplan_Task__c where (Status__c= :AIA_Constants.NOTSTARTED_STATUS or Status__c=:AIA_Constants.INPROGRESS_STATUS) and OwnerId in:usrManagerMap.keyset()];
        for(Workplan_Task__c thisWptsk:wptsks){
            if(usrManagerMap.containsKey(thisWptsk.OwnerId)&& usrManagerMap.get(thisWptsk.OwnerId)!=null){
                
                thisWptsk.OwnerId=usrManagerMap.get(thisWptsk.OwnerId);
            }
        }
       /* List<GSM_Approval_Response__c> GSMApprovals = [SELECT ID,User__c 
                                                       FROM GSM_Approval_Response__c 
                                                       WHERE Response__c =:AIA_Constants.INPENDING_STATUS AND User__c IN :usrManagerMap.keyset()];
        for(GSM_Approval_Response__c thisGSMAppr :GSMApprovals){
            if(usrManagerMap.containsKey(thisGSMAppr.User__c) && usrManagerMap.get(thisGSMAppr.User__c) != null){                
                thisGSMAppr.User__c=usrManagerMap.get(thisGSMAppr.User__c);
            }
        } */
        List<ID_Card__c> idCards = [SELECT Id,Status__c,Mast_Tech_Approver__c,MAST_Tech_Approver_Id__c 
                                    FROM ID_Card__c 
                                    WHERE MAST_Tech_Approver_Id__c IN :usrManagerMap.keyset() and (Status__c=:AIA_Constants.INREVIEW_STATUS)];
        for(ID_Card__c idCard : idCards){
            idCard.MAST_Tech_Approver_Id__c = usrManagerMap.get(idCard.MAST_Tech_Approver_Id__c);
            idCard.Mast_Tech_Approver__c = mangerIdNameMap.get(idCard.MAST_Tech_Approver_Id__c);
        }

            if(wptsks != NULL){
            Database.update(wptsks,false);
            }
            if(idCards != NULL){
               Database.update(idCards,false);
            }  
            /*if(GSMApprovals != NULL){
               Database.update(GSMApprovals,false);
            }   */      
    }
    public void finish(Database.BatchableContext bc) {        
        AIA_GSDoc_Approvers_update_Batch updateGSDocs = new AIA_GSDoc_Approvers_update_Batch();
        Database.executeBatch(updateGSDocs,200);
    }   
    private void getIMDetailsVer1(List<Id> userIds){
        Map<Id,Id> userIMMap = new Map<Id,Id>();
        Map<Id,List<Id>> accUserMap = new Map<Id,List<Id>>();
        /* T01 Start*/
       /* List<AccountTeamMember>  memList = [SELECT Id,AccountId,userId 
                                            FROM AccountTeamMember 
                                            WHERE userId IN :userIds];*/
         List<Account_Team__c>  memList = [SELECT Id,AccountId__c,userId__c 
                                            FROM Account_Team__c
                                            WHERE userId__c IN :userIds];
       /* for(AccountTeamMember mem : memList){
            if(accUserMap.containskey(mem.AccountId)){              
                accUserMap.get(mem.AccountId).add(mem.userId);
            }
            else{
                List<Id> Ids = new List<Id>();
                Ids.add(mem.userId);
                accUserMap.put(mem.AccountId,Ids);
            }
        }*/
        for(Account_Team__c mem : memList){
            if(accUserMap.containskey(mem.AccountId__c)){              
                accUserMap.get(mem.AccountId__c).add(mem.userId__c);
            }
            else{
                List<Id> Ids = new List<Id>();
                Ids.add(mem.userId__c);
                accUserMap.put(mem.AccountId__c,Ids);
            }
        }
       /* List<AccountTeamMember> accTeamMemList =[SELECT Id,AccountId,UserId,Account.Name,User.Name 
                                                 FROM AccountTeamMember 
                                                 WHERE AccountId IN:accUserMap.keySet() and TeamMemberRole=:AIA_Constants.IMP_MANAGER];*/
        List<Account_Team__c> accTeamMemList =[SELECT Id,AccountId__c,UserId__c,AccountId__r.Name,UserId__r.Name 
                                                 FROM Account_Team__c
                                                 WHERE AccountId__c IN:accUserMap.keySet() and TeamMemberRole__c=:AIA_Constants.IMP_MANAGER];
       /* for(AccountTeamMember member : accTeamMemList){
           List<Id> usrIds = accUserMap.get(member.AccountId);
            for(Id usrId :usrIds){
                usrManagerMap.put(usrId,member.UserId);
                mangerIdNameMap.put(member.UserId,member.User.Name);
            }
        }*/
        for(Account_Team__c member : accTeamMemList){
           List<Id> usrIds = accUserMap.get(member.AccountId__c);
            for(Id usrId :usrIds){
                usrManagerMap.put(usrId,member.UserId__c);
                mangerIdNameMap.put(member.UserId__c,member.UserId__r.Name);
            }
        }
    }  
  /*T01 End*/  
}