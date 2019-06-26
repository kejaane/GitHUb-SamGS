/*****************************************************************************************************
*Date: 05-20-2017 
*Developer: Satya Tirumalasetti
*Purpose: This class will be used to send email to the MAST Tech for approval
*=========================================================================================
* Update History
* Date         Developer          Tag                   Description 
*==================================================================================
* 05-20-2017  |  Satya        | Initial Development
* 01/29/2019  |  Satya T      | T01                  | Changed the Account Team member references  
*                                                      from Standard to Custom object
*==================================================================================

*******************************************************************************************************/


//This class will be invoked from IDCardTriggerHandler 
public with sharing class AIA_IDCardTriggerHelper{
    
     Public static Boolean TestText;
     public static Boolean isRecursive = false; 
/* @Author: Satya 
* @This method will be called from IDCardTriggerHandler when any new record is inserted or updated in ID Card record
* @param -  List<ID_Card__c>
* @Output - Send email to MAST Tech.
*/
    
    Public static void sendEmail(List<ID_Card__c> idCardNewList){
   
    
        Set<id> idcardidSet = new Set<id>();
        if(!isRecursive){
            //Looping through all the records coming from trigger
            for(ID_Card__c idcrd : idCardNewList){
                if(idcrd.Status__c == 'In Progress' && idcrd.products_selected_count__c != null && idcrd.Member_level_Products__c == 'Yes' && idcrd.sent_to_approval__c == true){
                    idcardidSet.add(idcrd.id);
                }
            }
            
            //get the list of IDCard records from the trigger
            Map<id, ID_Card__c> idCardMap = new Map<id, ID_Card__c>([select id, Name,Implementation__r.Account__c from ID_Card__c where id in : idcardidSet]);
            List<ID_Card__c> idcardList = [select id, Name,Implementation__r.Account__c,Mast_Tech_Approver__c from ID_Card__c where id in : idcardidSet];
            Set<Id> accIds = new Set<Id>();
            Map<id, ID_Card__c> idCardMapAcc = new Map<id, ID_Card__c>();
            for(ID_Card__c idc : idcardList){
                idCardMapAcc.put(idc.Implementation__r.Account__c,idc);
            }
            Map<id, Id> idCardMapUser = new Map<id, Id>();
            Set<Id> userIDSet = new Set<Id>();
            system.debug('idCardMapAcc>>>'+idCardMapAcc);
            
           //T01 changes start
           /*  //get the accountTeam member role (MAST Tech) and assign it to the set and map
            List<AccountTeamMember> accntTeamMeberList = [select accountId,UserId,TeamMemberRole from AccountTeamMember where accountId in : idCardMapAcc.keySet()];
            for(AccountTeamMember accTM : accntTeamMeberList){
                if (accTM.TeamMemberRole=='MAST Tech'){
                    idCardMapUser.put(accTM.accountId,accTM.UserId);
                    userIDSet.add(accTM.UserId);
                }
            }*/
            
             //get the accountTeam member role (MAST Tech) and assign it to the set and map
            List<Account_Team__c> accntTeamMeberList = [select AccountId__c,UserId__c,TeamMemberRole__c from Account_Team__c where AccountId__c in : idCardMapAcc.keySet()];
            for(Account_Team__c accTM : accntTeamMeberList){
                if (accTM.TeamMemberRole__c =='MAST Tech'){
                    idCardMapUser.put(accTM.AccountId__c,accTM.UserId__c);
                    userIDSet.add(accTM.UserId__c);
                }
            }
            //T01 changes End
            
            //get the emailTemplate, loop through the idcardlist, prepare the emailmessage to be sent
            Map<Id,User> userMap = new Map<Id,User>([Select id,Email,Name From User where id in : userIDSet]);
            List<Contact> cnt = [select id from Contact limit 1];
            EmailTemplate emailTemplate = [Select id from EmailTemplate where name=:'AIA ID Card sent for approvals'];
            for(ID_Card__c idc : idcardList){
                if(idCardMapUser.containsKey(idc.Implementation__r.Account__c)){
                    Id userId = idCardMapUser.get(idc.Implementation__r.Account__c);
                    String emailId = userMap.get(userId).Email;
                    system.debug('emailId>>>>'+emailId);
                    List<String> sendTo = new List<String>();
                    sendTo.add(emailId);
                    
                    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
                    Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
                    singleMail.setTargetObjectId(cnt[0].Id);
                     
                    singleMail.setWhatId(idc.id);
                    singleMail.setTemplateId(emailTemplate.Id);
                    singleMail.setSaveAsActivity(false);                
                    singleMail.setTreatTargetObjectAsRecipient(false);

                    singleMail.setToAddresses(sendTo);
                    emails.add(singleMail); 
                    
                    Messaging.SendEmailResult[] result = Messaging.sendEmail(emails);
                    TestText=result[0].isSuccess(); 
                    idc.Mast_Tech_Approver__c = userMap.get(userId).Name;  
                    idc.MAST_Tech_Approver_Id__c = userMap.get(userId).Id;
                }
            }
            isRecursive = true;
            if(idcardList.size() > 0){
                update idcardList;
            }       
        }      
    }
    
    //This method is used to prevent users from editing the record when status is in "In Review" except for AIA MAST grp and MAST TECH role.
    public static void validateBeforeUpdate(List<ID_Card__c> idCardNewList, Map<id,ID_Card__c> oldMap,Map<id,ID_Card__c> newMap){
        Set<id> idcardidSet = new Set<id>();
        for(ID_Card__c idcrd : idCardNewList){
            idcardidSet.add(idcrd.id);
           // }
        }
        
        //get the list of IDCard records from the trigger
        Map<id, ID_Card__c> idCardMap = new Map<id, ID_Card__c>([select id, Name,Implementation__r.Account__c from ID_Card__c where id in : idcardidSet]);
        List<ID_Card__c> idcardList = [select id, Name,Status__c,Implementation__r.Account__c,Mast_Tech_Approver__c from ID_Card__c where id in : idcardidSet];
        Set<Id> accIds = new Set<Id>();
        Map<id, Id> idCardMapIdAcc = new Map<id, Id>();
        Map<id, ID_Card__c> idCardMapAcc = new Map<id, ID_Card__c>();
        for(ID_Card__c idc : idcardList){
            idCardMapAcc.put(idc.Implementation__r.Account__c,idc);
            idCardMapIdAcc.put(idc.id,idc.Implementation__r.Account__c);
        }
        Map<id, Id> idCardMapUser = new Map<id, Id>();
        Set<Id> userIDSet = new Set<Id>();
        system.debug('idCardMapAcc>>>'+idCardMapAcc);
        
        //T01 changes start
       /* //get the accountTeam member role (MAST Tech) and assign it to the set and map
        List<AccountTeamMember> accntTeamMeberList = [select accountId,UserId,TeamMemberRole from AccountTeamMember where accountId in : idCardMapAcc.keySet()];
        for(AccountTeamMember accTM : accntTeamMeberList){
            if (accTM.TeamMemberRole=='MAST Tech'){
                idCardMapUser.put(accTM.accountId,accTM.UserId);
                userIDSet.add(accTM.UserId);
            }
        }*/
        
        //get the accountTeam member role (MAST Tech) and assign it to the set and map
        List<Account_Team__c> accntTeamMeberList = [select AccountId__c,UserId__c,TeamMemberRole__c from Account_Team__c where AccountId__c in : idCardMapAcc.keySet()];
        for(Account_Team__c accTM : accntTeamMeberList){
            if (accTM.TeamMemberRole__c=='MAST Tech'){
                idCardMapUser.put(accTM.AccountId__c,accTM.UserId__c);
                userIDSet.add(accTM.UserId__c);
            }
        }
        //T01 changes End
        
        //Get the users of AIA Mast group
        Map<Id,User> userMap = new Map<Id,User>([select id, name, email from user where id in (select userorgroupid from groupmember where group.name = 'AIA MAST')]);
        for(ID_Card__c idc : idCardNewList){
            Id accid = idCardMapIdAcc.get(idc.id);
            
            //If ID Card record status is In Review, throw error except for Mast tech role and MAST grp members
            if(oldMap.get(idc.id).Status__c == 'In Review' && (!userMap.Containskey(UserInfo.getUserID()) && (accid != null && !idCardMapUser.containsKey(accid)))){
                idc.addError('Record cannot be updated when status is In Review');
            }
        }
    }
 }