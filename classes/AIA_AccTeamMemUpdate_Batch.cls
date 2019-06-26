/*=================================================================================================================
* Date         : 08/13/2018
* Developer    : Phanishankar P
* Purpose      : Batch class to replace Account team members with their manager if team member(user) moved to inactive status 
*=================================================================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 08/13/2018 | Phani          |     | Initial Version 
* 01/30/2019 | Satya T        | T01 | Replaced standard Account Team Member with Custom Account Team Member.                                   
*===========+=================+=====+=============================================================================
*/ 
public class AIA_AccTeamMemUpdate_Batch implements Database.Batchable<sobject>,Database.Stateful,Schedulable{    
   Map<Id,Map<Id,String>> accIdTeamMap;   
    public Database.QueryLocator start(Database.BatchableContext bc){        
      String query = 'SELECT Id, Name FROM User WHERE IsActive=false'; 
        if (Test.isRunningTest()) query+=' AND lastname=\'Testing\'';
       /* String query = 'SELECT Id, Name FROM User WHERE IsActive=false and Id IN ('+'\'005600000015W7TAAU'+'\','
            +'\'005600000015XDvAAM'+'\')';*/
        //String query = 'SELECT Id, Name FROM User WHERE IsActive=false and Id IN ('+'\'005600000073g23AAA'+'\')';
        return Database.getQueryLocator(query);
    }
    public void execute(SchedulableContext SC){
        AIA_AccTeamMemUpdate_Batch memUpdateBatch = new AIA_AccTeamMemUpdate_Batch();
        Database.executeBatch(memUpdateBatch, 200);
    }
    public void execute(Database.BatchableContext bc, List<User> scope) {
        AIA_Utils errLogExp = new AIA_Utils();
       accIdTeamMap = new Map<Id,Map<Id,String>>();
        Map<Id,List<String>> usrIdAccRoleMap = new Map<Id,List<String>>();
        Map<Id,List<String>> IMIdAccRoleMap = new Map<Id,List<String>>();
        Map<Id,Id> usrManagerMap = new Map<Id,Id>();
        List<Id> informIMList = new List<Id>();
        //List<AccountTeamMember> teamMemList; T01
        //AccountTeamMember mem1; T01
        List<Account_Team__c> teamMemList; //T01
        Account_Team__c mem1; //T01
        Set<String> impactedAccounts = new Set<String>();
        Map<Id,Id> accountIMMap = new Map<Id,Id>();
        
        //T01 Changes start        
        //List<AccountTeamMember> insMemList = new List<AccountTeamMember>();
        //List<AccountTeamMember> deleteMemList = new List<AccountTeamMember>();
        List<Account_Team__c> insMemList = new List<Account_Team__c>();
        List<Account_Team__c> deleteMemList = new List<Account_Team__c>();
        
        /*for(AccountTeamMember mem :[SELECT Id,AccountId FROM AccountTeamMember WHERE UserID IN :scope]){
        impactedAccounts.add(mem.AccountId__c);
        } */
        for(Account_Team__c mem :[SELECT Id,AccountId__c FROM Account_Team__c WHERE UserId__c IN :scope]){
            impactedAccounts.add(mem.AccountId__c);
        }
         //T01 Changes end
         
        //System.debug('impactedAccounts@@'+impactedAccounts);
        getExistingTeam(impactedAccounts);
        List<AIA_Area_Manager__c> userMappingList = [SELECT ID,Area_Manager__c,Delegated_Manager_1__c,Delegated_Manager_2__c,Delegated_Manager_1__r.email,
                                                     Delegated_Manager_1__r.isActive,Delegated_Manager_2__r.isActive,Delegated_Manager_2__r.email
                                                     FROM AIA_Area_Manager__c 
                                                     WHERE Area_Manager__c IN:scope ];
        
        //If user is inactive then delete corresponding Account team member and 
        //    Create Account Team Member with same details but assign to Manager1/Manager2
        for (AIA_Area_Manager__c usrRec: userMappingList){            
            if(usrRec.Delegated_Manager_1__c != NULL && usrRec.Delegated_Manager_1__r.isActive){
                usrManagerMap.put(usrRec.Area_Manager__c,usrRec.Delegated_Manager_1__c);
            }
            else if(usrRec.Delegated_Manager_2__c != NULL && usrRec.Delegated_Manager_2__r.isActive){
                usrManagerMap.put(usrRec.Area_Manager__c,usrRec.Delegated_Manager_2__c);
            }
            else{
                informIMList.add(usrRec.Area_Manager__c);
            }
        }
              
        if(!informIMList.isEmpty()){
            accountIMMap =getIMDetailsVer1(informIMList);
        } 
        //If user is deactivated and Manager1/Manager2 are inactive then inform Implementation Manager after deleting 
        //corresponding 'account team member'
        /*T01 -- Start*/
       /* List<AccountTeamMember> teamMemListIM = [SELECT Id,UserId,AccountId,Account.Name,TeamMemberRole,user.Name 
                                                 FROM AccountTeamMember 
                                                 WHERE UserID IN :informIMList]; 
        for(AccountTeamMember member:teamMemListIM){
           Id ImID = accountIMMap.get(member.AccountId);
            //system.debug('Line 77 IMID'+ImID);
            if(ImID != null){
            if(!IMIdAccRoleMap.isEmpty() && IMIdAccRoleMap.containsKey(ImID)){
                    String accRole_If = member.TeamMemberRole+':'+member.Account.Name;
                    IMIdAccRoleMap.get(ImID).add(accRole_If); 
                }
                else{
                    List<String> accRoleList = new List<String>();
                    String accRole = member.TeamMemberRole+':'+member.Account.Name;
                    accRoleList.add(accRole);
                    IMIdAccRoleMap.put(ImID,accRoleList);
                }  
            }
        }*/
         List<Account_Team__c> teamMemListIM = [SELECT Id,UserId__c,AccountId__c,AccountId__r.Name,TeamMemberRole__c,userId__r.Name 
                                                 FROM Account_Team__c
                                                 WHERE UserId__c IN :informIMList]; 
        for(Account_Team__c member:teamMemListIM){
           Id ImID = accountIMMap.get(member.AccountId__c);
            //system.debug('Line 77 IMID'+ImID);
            if(ImID != null){
            if(!IMIdAccRoleMap.isEmpty() && IMIdAccRoleMap.containsKey(ImID)){
                    String accRole_If = member.TeamMemberRole__c+':'+member.AccountId__r.Name;
                    IMIdAccRoleMap.get(ImID).add(accRole_If); 
                }
                else{
                    List<String> accRoleList = new List<String>();
                    String accRole = member.TeamMemberRole__c+':'+member.AccountId__r.Name;
                    accRoleList.add(accRole);
                    IMIdAccRoleMap.put(ImID,accRoleList);
                }  
            }
        }
        
        /*T01 -- End*/
        
        if(teamMemListIM != NULL){
            try{
            delete teamMemListIM;
            }
            Catch(Exception e){
                
                errLogExp.logException(e);
            }
        }
        /*T01 -- Start*/
        /*
        teamMemList = [SELECT Id,UserId,AccountId,Account.Name,TeamMemberRole,user.Name 
                       FROM AccountTeamMember 
                       WHERE UserID IN :usrManagerMap.keySet()];         
        //System.debug('teamMemList@@'+teamMemList);
        for(AccountTeamMember mem:teamMemList){  
            String mgrId = usrManagerMap.get(mem.UserId);
            if(!((accIdTeamMap.get(mem.AccountId)).keySet()).contains(mgrId)){
                mem1 =  mem.clone();
                mem1.userId = mgrId;
                insMemList.add(mem1);
                
                (accIdTeamMap.get(mem.AccountId)).put(mem1.UserId,mem.TeamMemberRole);                         
            }
               //Capturing inactive user role & account to send email
                if(!usrIdAccRoleMap.isEmpty() && usrIdAccRoleMap.containsKey(mgrId)){
                    String accRole_If = mem.TeamMemberRole+':'+mem.Account.Name;
                    usrIdAccRoleMap.get(mgrId).add(accRole_If); 
                }
                else{
                    List<String> accRoleList = new List<String>();
                    String accRole = mem.TeamMemberRole+':'+mem.Account.Name;
                    accRoleList.add(accRole);
                    usrIdAccRoleMap.put(mgrId,accRoleList);
                }
            deleteMemList.add(mem);
        } */
        
          teamMemList = [SELECT Id,UserId__c,AccountId__c,AccountId__r.Name,TeamMemberRole__c,userId__r.Name 
                       FROM Account_Team__c
                       WHERE UserId__c IN :usrManagerMap.keySet()];         
        //System.debug('teamMemList@@'+teamMemList);
        for(Account_Team__c mem:teamMemList){  
            String mgrId = usrManagerMap.get(mem.UserId__c);
            if(!((accIdTeamMap.get(mem.AccountId__c)).keySet()).contains(mgrId)){
                mem1 =  mem.clone();
                mem1.userId__c = mgrId;
                insMemList.add(mem1);
                
                (accIdTeamMap.get(mem.AccountId__c)).put(mem1.UserId__c,mem.TeamMemberRole__c);                         
            }
               //Capturing inactive user role & account to send email
                if(!usrIdAccRoleMap.isEmpty() && usrIdAccRoleMap.containsKey(mgrId)){
                    String accRole_If = mem.TeamMemberRole__c+':'+mem.AccountId__r.Name;
                    usrIdAccRoleMap.get(mgrId).add(accRole_If); 
                }
                else{
                    List<String> accRoleList = new List<String>();
                    String accRole = mem.TeamMemberRole__c+':'+mem.AccountId__r.Name;
                    accRoleList.add(accRole);
                    usrIdAccRoleMap.put(mgrId,accRoleList);
                }
            deleteMemList.add(mem);
        }  
         /*T01 -- End*/ 
    //System.debug('insMemList'+insMemList);
        try{
        Database.insert(insMemList,false);
        delete deleteMemList;        
        sendAccTeamUpdateMail(usrIdAccRoleMap);
        sendIMUpdateMail(IMIdAccRoleMap);
        }
        
        Catch(Exception e){
                
                errLogExp.logException(e);
            }
    }
    public void finish(Database.BatchableContext bc) {
        if(!Test.isRunningTest()){
        AIA_BD_Approvers_Update_Batch updateBDApprovers = new AIA_BD_Approvers_Update_Batch();
        Database.executeBatch(updateBDApprovers,1);
        }
        
    }        
    private void sendIMUpdateMail(Map<Id,List<String>> IMIdAccRoleMap){
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        //System.debug('IMIdAccRoleMap###'+IMIdAccRoleMap);
        for(Id uid: IMIdAccRoleMap.keySet()){
            String body='';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> emailList = new List<String>();
            //System.debug('uid@@@'+uid);
            emailList.add(uid);
            mail.setToAddresses(emailList);            
            //mail.setSubject('Account Team Update for Account');
            mail.setSubject('URGENT ACTION REQUIRED: Account Team Updates');
            for(String roleAcc : IMIdAccRoleMap.get(uid)){
                String role = roleAcc.substringBefore(':');
                String acc = roleAcc.substringAfter(':');
                // body = body +' '+role+'->'+ acc+'\n';
                body=body+'In Account '+acc+', '+role+' role is deleted.  Please reassign.'+'<br></br>';
            }
            mail.setHtmlBody(body);
            mails.add(mail);
        }       
        Messaging.sendEmail(mails);
    }
    private void sendAccTeamUpdateMail(Map<Id,List<String>> usrIdAccRoleMap){   
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        //System.debug('usrIdAccRoleMap###'+usrIdAccRoleMap);
        for(Id uid: usrIdAccRoleMap.keySet()){
            String body='';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> emailList = new List<String>();
            emailList.add(uid);
            mail.setToAddresses(emailList);            
            //mail.setSubject('Account Team Update for Account');
            mail.setSubject('URGENT ACTION REQUIRED: Account Team Updates');
            for(String roleAcc : usrIdAccRoleMap.get(uid)){
                String role = roleAcc.substringBefore(':');
                String acc = roleAcc.substringAfter(':');
                // body = body +' '+role+'->'+ acc+'\n';
                body=body+'In Account '+acc+', '+role+' role is assigned to you or deleted.  Please reassign.'+'<br></br>';
            }
            mail.setHtmlBody(body);
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
    }    
    private Map<Id,Id> getIMDetailsVer1(List<Id> userIds){
        Map<Id,Id> accIMMap = new Map<Id,Id>();
        Set<Id> accIds = new Set<Id>();
         /*T01 -- Start*/
       /* List<AccountTeamMember>  memList = [SELECT Id,AccountId,userId 
                                            FROM AccountTeamMember 
                                            WHERE userId IN :userIds];
        for(AccountTeamMember mem : memList){
            accIds.add(mem.AccountId);
        }
        List<AccountTeamMember> accTeamMemList =[SELECT Id,AccountId,UserId,Account.Name 
                                                 FROM AccountTeamMember 
                                                 WHERE AccountId IN:accIds and TeamMemberRole=:AIA_Constants.IMP_MANAGER];
        for(AccountTeamMember member : accTeamMemList){
            accIMMap.put(member.AccountId,member.UserId);
        }*/
        List<Account_Team__c>  memList = [SELECT Id,AccountId__c,userId__c 
                                            FROM Account_Team__c
                                            WHERE userId__c IN :userIds];
        for(Account_Team__c mem : memList){
            accIds.add(mem.AccountId__c);
        }
        List<Account_Team__c> accTeamMemList =[SELECT Id,AccountId__c,UserId__c,AccountId__r.Name 
                                                 FROM Account_Team__c
                                                 WHERE AccountId__c IN:accIds and TeamMemberRole__c=:AIA_Constants.IMP_MANAGER];
        for(Account_Team__c member : accTeamMemList){
            accIMMap.put(member.AccountId__c,member.UserId__c);
        }
         /*T01 -- End*/
        return accIMMap;
    }  
    public void getExistingTeam(Set<String> selectedAccs){           
        Map<Id,Map<Id,String>> accIdRoleMap = new Map<Id,Map<Id,String>>();
        System.debug('selectedAccs'+selectedAccs);
        /*T01 -- Start*/
      /*  List<AccountTeamMember> existingAccTeamMemList = new List<AccountTeamMember>();
        //Map<Id,Map<String,Id>> roleTeamMemRecIdMap = new Map<Id,Map<String,Id>>();
        Id accId;        
        existingAccTeamMemList = [SELECT Id,User.Name,user.id,TeamMemberRole,AccountId
                                  FROM AccountTeamMember 
                                  where AccountId IN :selectedAccs Order by AccountId];
        for(AccountTeamMember existMem : existingAccTeamMemList){ 
            accId = existMem.AccountId;
           // System.debug('accId'+accId);
            if(accIdTeamMap.get(accId) == NULL){
                Map<Id,String> accTeamMap = new Map<Id,String>();
                //Map<String,Id> roleTeamMemIdMap = new Map<String,Id>();
                accTeamMap.put(existMem.user.Id,existMem.TeamMemberRole);
                accIdTeamMap.put(accId,accTeamMap);                    
            }
            else{
                accIdTeamMap.get(accId).put(existMem.user.Id,existMem.TeamMemberRole);
            }
        }*/
        List<Account_Team__c> existingAccTeamMemList = new List<Account_Team__c>();
        //Map<Id,Map<String,Id>> roleTeamMemRecIdMap = new Map<Id,Map<String,Id>>();
        Id accId;        
        existingAccTeamMemList = [SELECT Id,UserId__r.Name,userId__c,TeamMemberRole__c,AccountId__c
                                  FROM Account_Team__c
                                  where AccountId__c IN :selectedAccs Order by AccountId__c];
        for(Account_Team__c existMem : existingAccTeamMemList){ 
            accId = existMem.AccountId__c;
           // System.debug('accId'+accId);
            if(accIdTeamMap.get(accId) == NULL){
                Map<Id,String> accTeamMap = new Map<Id,String>();
                //Map<String,Id> roleTeamMemIdMap = new Map<String,Id>();
                accTeamMap.put(existMem.userId__c,existMem.TeamMemberRole__c);
                accIdTeamMap.put(accId,accTeamMap);                    
            }
            else{
                accIdTeamMap.get(accId).put(existMem.userId__c,existMem.TeamMemberRole__c);
            }
        }
        /*T01 -- End*/
        //System.debug('accIdTeamMap'+accIdTeamMap);
    }
    
}