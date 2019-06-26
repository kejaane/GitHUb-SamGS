/*=====================================================================================================================
 * Date         : 10/03/2017
 * Developer    : Satya Tirumalasetti
 * Purpose      : This class is used to send Email Notifications to AccountTeam Members depending on diff conditions
 *=====================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer            Tag   Description
 *============+=====================+=====+=============================================================================
 * 10/03/2017 | satya               |     | Initial Version 
 * 21/05/2018 | Satya/Gayathri      | T01 | Notifications to users as a part of US1728 and US2861
 * 10/07/2018 | Gayathri            | T02 | Added Account name in the email template as part of Ticket 0010 
 * 01/28/2019 | Chaithra            | T03 | Added as part of Us1702 and Us1730     
 * 01/29/2019 | Satya T             | T04 | Replaced standard Account Team Member with Custom Account Team Member.                                
 *===========+=================+=====+==================================================================================
 */

public without sharing class  AIA_SendEmail_Notification
{    
    public static final string DEAD = 'Dead';
    public static final string SOLD = 'Sold';
    public static final string DEADOPPNOTIFY = 'AIA_Dead_Opp_Notification';
    public static final string SOLDOPPNOTIFY = 'AIA_Sold_Opp_Notification';
    public static final string TWOHUNDPLUS = '200+';
    public static final string AIADOC = 'AiaDoc';
    public static final string AccExec = 'Account Executive';
    public static final string PharOpe = 'Pharmacy Operations';//T03 added
    public static final string SalesAssistant = 'Sales Assistant';
    public static final string Opportunity = 'Opportunity';
    public static final string AiaDocument = 'AIA Document';
    public static final string BDesign = 'Benefit Design';
    public static final string BDesignNonDrug = 'Benefit Design Non Drug';//T03 added
    public static final string FEEDSTRING = 'Opportunity has been marked as ';
    public static final string ImpSub = 'Implementation is set to Progress';
    public static final string AiaDocSubject = 'Quote document has been uploaded to AIA Document';
    public static final string ImpStateprogress= 'In-Progress';
    public static final string Imp = 'Implementation';
    public static final string ImpDoc ='Implementation Doc';
    public static final string QuoteUpload = 'Quote document has been uploaded to AIA Document';
    public static final string ReviewTheRecord = 'Please click the Record link and review the ';
    public static final string WPTCompleted = 'Workplan Tasks are Completed';
    public static final string WPTInprogress = 'In Progress';
    public static final string WPTNStarted = 'Not Started';
    public static final string WPTBlocked ='Blocked';
    public static final string AIAApproved = 'Approved';
    public static final string WpTask = 'Workplan task';
    public static final string BDApproved = 'Benefit Design is Approved';
    public static final string Quote = 'Quote';
    public static final string IMP_INPROGRESS = 'In-Progress';
    public static final String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
    Map<Id,Integer> taskCount = new Map<Id,Integer>();
    
    /**
    * @This will be called in After Update event of OpportunityTriggerHandler class
    * @This method - It takes List of opportunity and check if opportunity is dead or sold. If so, will send a notification to entire Acc Team.
    * @param List of opportunities
    * @Output - Send Notification to Account team;.
    */
    //This method takes a list of opps and create an Acc team to pass it onto send email method.
    public static void sendNotificationToAccTeam(List<opportunity> lstNewopps, Map<id,opportunity> oldmap)
    {
        set<id> AccountIDSet = new set<id>(); //to hold Acc Ids
        set<id> soldAccountIDSet = new set<id>(); 
        /* T04  --- Start*/
        /*map<string,set<AccountTeamMember>> AccTeamMap = new map<string,set<AccountTeamMember>>(); //Map of Account ID and Associated account team
        List<AccountTeamMember> ATM = new List<AccountTeamMember>();*/
        map<string,set<Account_Team__c>> AccTeamMap = new map<string,set<Account_Team__c>>(); //Map of Account ID and Associated account team
        List<Account_Team__c> ATM = new List<Account_Team__c>();
        /*--T04 -- End*/
        Map<Id,Id> oppDeadMap = new Map<Id,Id>();
        Map<Id,Id> oppSoldMap = new Map<Id,Id>();
         Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get(TWOHUNDPLUS).RecordTypeId; // Record Id for the 200+ Opportunity
         
        //Loop through all Opp and get the Account Ids
        for(opportunity opp:lstNewopps){
           if(opp.RecordTypeId == opptwohundredplusId){
           
           //get a map of AccoutId to opp record if opp status is changed to Dead
            if(oldmap.get(opp.id).StageName != DEAD && opp.StageName == DEAD){
                AccountIDSet.add(opp.AccountID);
                oppDeadMap.put(opp.AccountID,opp.id);
              }
              //get a map of AccoutId to opp record if opp status is changed to sold
             if(oldmap.get(opp.id).StageName != SOLD && opp.StageName == SOLD){
                 
                soldAccountIDSet.add(opp.AccountID);
                oppSoldMap.put(opp.AccountID,opp.id);
              }
            }
        }
        
                
        /*If we have accId set, get the accountteam members by calling the getAccountTeamMembers method and send 
        chatter notification to those users*/
        
        if(!oppDeadMap.isEmpty()){
          //map<string,set<AccountTeamMember>> teamMembers = getAccountTeammembers(AccountIDSet,Opportunity); T04
            map<string,set<Account_Team__c>> teamMembers = getAccountTeammembers(AccountIDSet,Opportunity);
            sendChatterNotification(teamMembers,oppDeadMap,DEADOPPNOTIFY,DEAD);
         }
         if(!oppSoldMap.isEmpty()){
          //map<string,set<AccountTeamMember>> teamMembers = getAccountTeammembers(soldAccountIDSet,Opportunity); T04
            map<string,set<Account_Team__c>> teamMembers = getAccountTeammembers(soldAccountIDSet,Opportunity);
            sendChatterNotification(teamMembers,oppSoldMap,SOLDOPPNOTIFY,SOLD);
         }
        
    }
    
       
    //This method takes map of account ids to account team and send chatter notification to individual team members
  // public static void sendChatterNotification(map<string,set<AccountTeamMember>> AccTeamMap,Map<Id,Id> oppMap,string Oppstatus, string status){ T04  
     public static void sendChatterNotification(map<string,set<Account_Team__c>> AccTeamMap,Map<Id,Id> oppMap,string Oppstatus, string status){
       
        List<FeedItem> fItems = new List<FeedItem>();
        string userid;
        String body;
        set<id> UidSet = new set<id>();
       
        if(!AccTeamMap.isEmpty()){
            //Iteraing Account keyset
            for(string accId:AccTeamMap.keySet()){
                //post the chatter feed onto user's record
              //for(AccountTeamMember usid:AccTeamMap.get(accId)){   T04
                for(Account_Team__c usid:AccTeamMap.get(accId)){              
                   if(!UidSet.contains(usid.UserId__c)){
                        UidSet.add(usid.UserId__c);
                        FeedItem post = new FeedItem();
                      //post.ParentId = usid.UserId; T04  
                        post.ParentId = usid.UserId__c;
                        post.Body = FEEDSTRING + status +'\n'+'\n'+'Link for '+ Opportunity + ' :'+'\n' +sfdcBaseURL+'/'+oppMap.get(accId) ;
                        fItems.add(post);
                        }
                }  
            }
            if(!fItems.isEmpty()){
                system.debug('Error Is here');
               insert fItems;
            }
        }
    }
    
    //T01 changes start
    /*This method will be called from implementation trigger and will notify the Account Team Members
      that Implementation status has been changed from Not-started to In-Progress */  
    public void notifyAccTeamMember(List<AIA_Implementation__c> lstNewImp, Map<id,AIA_Implementation__c> oldmap)
    {
        Set<Id> impId = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        Set<Id> accIds1 = new Set<Id>();
        Map<Id,Id> accImpMap = new Map<Id,Id>();
        Map<Id,Id> accImpMap1 = new Map<Id,Id>();
        //for(AIA_Implementation__c imp:lstNewImp)
        //{
        //    impId.add(imp.Id);
        //}
        
        //Get the Implementation record and check the status if it has been changed to In-Progress
        //for(AIA_Implementation__c imp: [select id, status__c,Account__c from aia_implementation__c where id IN:impId]){        
        for(AIA_Implementation__c imp: lstNewImp){        
            if(imp.Status__c == ImpStateprogress && imp.Status__c != oldmap.get(imp.Id).status__c)
            {
                accIds.add(imp.Account__c);
                accImpMap.put(imp.Id,imp.Account__c);
            }
        }
        //If we have the accountid set, get the account team roles and send the email notification regarding the status
        if(accIds.size()>0)
        {
          //map<string,set<AccountTeamMember>> teamMembers = getAccountTeammembers(accIds,ImpDoc);T04  
            map<string,set<Account_Team__c>> teamMembers = getAccountTeammembers(accIds,ImpDoc);
            sendNotification(teamMembers,accImpMap,ImpSub ,Imp);
        }
        
                
    }
    
    
    /*This method is used to Notify the Account team members when all workplan tasks of the implementation are completed*/
    public void notifyCompletedTasksATM(List<AIA_Implementation__c> lstNewImp, Map<id,AIA_Implementation__c> oldmap)
    {
        Set<Id> impId = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        Map<Id,Id> accImpMap = new Map<Id,Id>();
        Set<Id> activeImp = new Set<Id>();
        Boolean hasWpTask = false;
        //get the set of Implementation Id's in trigger context
        for(AIA_Implementation__c imp:lstNewImp)
        {
            impId.add(imp.Id);
        }
        
        //Check if all the workplan tasks related to the implementation record are completed. If so, get the set of implementation Id's 
        for(Workplan_Task__c task:[Select Id,name,status__c,Implementation__c 
                                  from Workplan_Task__c 
                                  where Implementation__c IN:impId])//AND (status__c=:WPTInprogress OR status__c = :WPTNStarted OR status__c=:WPTBlocked)
        {
            hasWpTask = true; 
            if(task.status__c == WPTInprogress || task.status__c == WPTNStarted || task.status__c == WPTBlocked) 
                activeImp.add(task.Implementation__c);
            
        }
        
        /*For the records in trigger context, check if they exist in the activeImp map. If exists, then update the All tasks completed
        field as true*/
        for(AIA_Implementation__c imp:lstNewImp)
        {
           if(hasWpTask && !activeImp.contains(imp.Id) && !imp.All_tasks_are_completed__c && imp.Status__c == IMP_INPROGRESS)
           {
               accIds.add(imp.Account__c);
               accImpMap.put(imp.Id,imp.Account__c);
               imp.All_tasks_are_completed__c = true;
               
            }
        }
        
        /*If we have accId set, get the accountteam members by calling the getAccountTeamMembers method and send 
        email notification to those users*/
        if(accIds.size()>0)
        {
          //map<string,set<AccountTeamMember>> teamMembers = getAccountTeammembers(accIds,WpTask);T04  
            map<string,set<Account_Team__c>> teamMembers = getAccountTeammembers(accIds,WpTask);
            sendNotification(teamMembers,accImpMap,WPTCompleted,Imp);
            
        }
 
    }
    
    
    
    /*This method is used to Notify the Account team members when Benefit Design is approved*/
    public void notifyBDAccTeamMember(List<AIA_Benefit_Design__c> lstNewBD, Map<id,AIA_Benefit_Design__c> oldmap)
    {
        Set<Id> accIds = new Set<Id>();
        Map<Id,Id> accImpMap = new Map<Id,Id>();
        integer drugCount=0;//T03 added
        
        //Loop through the updated records and if status is approved, get the accId set and map of RecordId's to accountId
        for(AIA_Benefit_Design__c bd:lstNewBD)
        {
            if(bd.Status__c == AIAApproved && bd.Status__c != oldmap.get(bd.Id).status__c)
            {
                accIds.add(bd.Account__c);
                accImpMap.put(bd.Id,bd.Account__c);
            }
             //T03 Starts
            if(bd.Count_of_BD_Drug_Products__c >0 ){
                
                drugCount++;
                
            }//T03 ends
        }
        
        /*If we have accId set, get the accountteam members by calling the getAccountTeamMembers method and send 
        email notification to those users*/
       /* if(accIds.size()>0)
        {
            map<string,set<Account_Team__c>> teamMembers = getAccountTeammembers(accIds,BDesign);
            sendNotification(teamMembers,accImpMap,BDApproved,BDesign);
        }*/
        
         if(accIds.size()>0 && drugCount > 0 )//T03 added drugCount>0 condition
        {
            system.debug('inside if');
         // map<string,set<AccountTeamMember>> teamMembers = getAccountTeammembers(accIds,BDesign);  T04
            map<string,set<Account_Team__c>> teamMembers = getAccountTeammembers(accIds,BDesign);
            sendNotification(teamMembers,accImpMap,BDApproved,BDesign);
        }
        //T03 starts
        else if(accIds.size()>0 && drugCount < 1)
        {
            system.debug('inside else if');
        //map<string,set<AccountTeamMember>> teamMembers = getAccountTeammembers(accIds,BDesignNonDrug);T04  
          map<string,set<Account_Team__c>> teamMembers = getAccountTeammembers(accIds,BDesignNonDrug);
            sendNotification(teamMembers,accImpMap,BDApproved,BDesign);  
        }
        //T03 ends
          
    }
    
     
    /*This method is used to Notify the Account team members if Quote Document is uploaded to AIA Documents*/ 
    public void notifyQuoteToAccMem(List<AIA_Document__c> lstAIADoc)
    {
        Set<Id> accIds = new Set<Id>();
        Map<Id,Id> accDocMap = new Map<Id,Id>();
        
        //Loop through the inserted records and if document type is Quote, then get a map of RecordId to accountID
        for(AIA_Document__c doc:lstAIADoc)
        {
            if(doc.Document_Type__c== Quote)
            {
                accIds.add(doc.Account__c);
                accDocMap.put(doc.Id,doc.Account__c);
            }
        }
        system.debug('entered once');
        /*If we have accId set, get the accountteam members by calling the getAccountTeamMembers method and send 
        email notification to those users*/
        if(accIds.size()>0)
        {
          //map<string,set<AccountTeamMember>> teamMembers = getAccountTeammembers(accIds,AIADOC); T04 
            map<string,set<Account_Team__c>> teamMembers = getAccountTeammembers(accIds,AIADOC);
            if(teamMembers.size()>0){
            sendNotification(teamMembers,accDocMap,AiaDocSubject,AiaDocument);
            }
        }
          
    }
    
    
    
    
    /*This method will return the Account Team Members by taking AccountID and Obj Name as input parameters */ 
    /* T04 -- Start*/
    /*
     public static map<string,set<AccountTeamMember>>  getAccountTeammembers(Set<Id> accountId,string obj)
    {
       List<AccountTeamMember> teamMemLst = new List<AccountTeamMember>();
       map<string,set<AccountTeamMember>> AccTeamMap = new map<string,set<AccountTeamMember>>(); 
       List<AccountTeamMember> ATM = new List<AccountTeamMember>();
       
       
       if(obj==AIADOC ){
           ATM = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId,User.email,User.Name 
                 FROM AccountTeamMember 
                  where AccountId in:accountId and (TeamMemberRole = :AccExec or TeamMemberRole = :SalesAssistant)];
       }
       //T03 Starts
        else if (obj==BDesignNonDrug){
            system.debug('inside else if in line 305');
            ATM = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId,User.email,User.Name 
                 FROM AccountTeamMember 
                  where AccountId in:accountId and (TeamMemberRole != :PharOpe)];
            
        }
        //T03 Ends
       else{
           ATM = [SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId,User.email,User.Name 
                 FROM AccountTeamMember 
                 where AccountId in:accountId];
       }
       
       //Get the account Id and account team members into the map to return back to the calling method/class. 
        if(!ATM.isEmpty()){
            for(AccountTeamMember acteam:ATM){
                if(!AccTeamMap.containsKey(acteam.AccountId)){
                    AccTeamMap.put(acteam.AccountId, new set<AccountTeamMember>{acteam});
                }else if(AccTeamMap.containsKey(acteam.AccountId)){
                    AccTeamMap.get(acteam.AccountId).add(acteam);
                }
            }
        }
       return AccTeamMap;
    }
    */
    public static map<string,set<Account_Team__c>>  getAccountTeammembers(Set<Id> accountId,string obj)
    {
       List<Account_Team__c> teamMemLst = new List<Account_Team__c>();
       map<string,set<Account_Team__c>> AccTeamMap = new map<string,set<Account_Team__c>>(); 
       List<Account_Team__c> ATM = new List<Account_Team__c>();
       
       /*If the object is AIA Document, then this method will only return Account Executive and Sales Assistant else
        this method will return all the team members of the Account*/
       if(obj==AIADOC ){
           ATM = [SELECT AccountId__c,Id,TeamMemberRole__c,UserId__c,UserId__r.email,UserId__r.Name 
                 FROM Account_Team__c
                  where AccountId__c in:accountId and (TeamMemberRole__c= :AccExec or TeamMemberRole__c = :SalesAssistant)];
       }
       //T03 Starts
        else if (obj==BDesignNonDrug){
            system.debug('inside else if in line 305');
            ATM = [SELECT AccountId__c,Id,TeamMemberRole__c,UserId__c,UserId__r.email,UserId__r.Name 
                 FROM Account_Team__c
                  where AccountId__c in:accountId and (TeamMemberRole__c!= :PharOpe)];
            
        }
        //T03 Ends
       else{
           ATM = [SELECT AccountId__c,Id,TeamMemberRole__c,UserId__c,UserId__r.email,UserId__r.Name 
                 FROM Account_Team__c
                 where AccountId__c in:accountId];
       }
       
       //Get the account Id and account team members into the map to return back to the calling method/class. 
        if(!ATM.isEmpty()){
            for(Account_Team__c acteam:ATM){
                if(!AccTeamMap.containsKey(acteam.AccountId__c)){
                    AccTeamMap.put(acteam.AccountId__c, new set<Account_Team__c>{acteam});
                }else if(AccTeamMap.containsKey(acteam.AccountId__c)){
                    AccTeamMap.get(acteam.AccountId__c).add(acteam);
                }
            }
        }
        system.debug('AccTeamMap-->'+AccTeamMap);
       return AccTeamMap;
    }
    /* T04 -- End*/
    
    /* This method will send email Notifications and chatter feeds to users */
    public static void sendNotification(map<string,set<Account_Team__c>> AccTeamMap,Map<Id,Id> accountRecordMap,String subject,String objectType){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        string userid;
        string body;
        List<FeedItem> fItems = new List<FeedItem>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //get the prefix of the implementation object
        String objectPrefix = AIA_Implementation__c.SObjectType.getDescribe().getKeyPrefix();
        //T02 Start
        Map<Id,String> impAccName = new Map<Id,String>();
        if(objectType==Imp)
                    {
                        List<AIA_Implementation__c> impRecords =[Select id,Account__r.Name from AIA_Implementation__c where id IN:accountRecordMap.keySet()]; 
                        for(AIA_Implementation__c rec:impRecords)
                        {
                            impAccName.put(rec.Id,rec.Account__r.Name);
                        }
                    }
        //T02 End
        /*Loop through the Account map. For each and every account, get the related account team members 
        and send a email as per the conditions and the object. */
        if(!AccTeamMap.isEmpty()){
        
            //Iteraing AccountRecordMap keyset, get the user id's from the map
            for(string recId:accountRecordMap.keySet()){
               set<String> sendTo = new set<String>();
               list<string> addLst = new list<string>();
             // for(AccountTeamMember usid:AccTeamMap.get(accountRecordMap.get(recId))){ T04  
                for(Account_Team__c usid:AccTeamMap.get(accountRecordMap.get(recId))){              
                                       
                //If the object is AIA Document, post a chatter feed onto the user's profile
                if(objectType==AiaDocument){
                    FeedItem post = new FeedItem();
                    post.ParentId = usid.UserId__c;
                    post.Body = QuoteUpload +'\n'+'\n'+'Link for '+ AiaDocument + ' :'+'\n' +sfdcBaseURL+'/'+recId ;
                    fItems.add(post);
                    system.debug('fItems-->'+fItems);
                  } else{
                    sendTo.add(usid.UserId__r.email);
                    /*mail = new Messaging.SingleEmailMessage();
                    string Link = '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+recId+'">'+'Click Here</a>'; 
                    body= ReviewTheRecord +objectType+'\r\n'+'\r\n'+Link+'\r\n';
                    mail.setHtmlBody(body);
                    mail.setSubject(Subject);
                    mail.setToAddresses(sendTo);
                    mails.add(mail);*/
                }
            }
                addLst.addAll(sendTo);
                if(addLst.size()>0)
                {
                    mail = new Messaging.SingleEmailMessage();
                    string Link = '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+recId+'">'+'Click Here</a>'; 
                    body= ReviewTheRecord +objectType+'\r\n'+'\r\n'+Link+'\r\n';
                    //T02 Start
                    if(objectType==Imp)
                    {
                        body='Implementation of '+impAccName.get(recId)+' account is set to progress. '+body;
                    }
                    //T02 End
                    mail.setHtmlBody(body);
                    mail.setSubject(Subject);
                    mail.setToAddresses(addLst);
                    mails.add(mail);
                }
          }
           
            //check if List size is greater than zero, then send the emails
            if(mails.size() > 0){   
               Messaging.sendEmail(mails);
            }
             //check if List size is greater than zero, post the chatter feed
             if(!fItems.isEmpty()){
               insert fItems;
            }
        }
    }
    //T01 Changes Ends
}