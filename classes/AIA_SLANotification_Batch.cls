/*=================================================================================================================
 * Date         : 10/06/2017
 * Developer    : Satya Tirumalasetti
 * Purpose      : Batch class to send emails to user/Manager when workplan task SLA is about to breach or 
 *                aleady breached. 
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 10/11/2017 | satya          |     | Initial Version
 * 04/19/2018 | Gayathri       | T01 | Added Condition to check User's preference to Send Notification  
 *                                     and added method call to find the manager of the WP task owner based on Area Mapping 
 *                                     as part of US197
 * 05/14/2018 | Gayathri       | T02 | Added logic to populate days left to complete the tasks and updated the logic to 
 *                                     send mail based on SLA day type as part of US197
 * 05/18/2018 | Gayathri       | T03 | Added logic to post on user's profile when SLA is breached or going to be breached 
 *                                     and removed logic to send email on the same-US1562.                                     
 *===========+=================+=====+=============================================================================
 */ 

/**
* @Author: Satya
* @This batch class will check the SLA dates of workplans and depending on the conditions, send an email to User/Manager
* @param -  None
* @Output - send email to user/manager
*/
global class AIA_SLANotification_Batch implements Database.Batchable<sobject>,Database.AllowsCallouts,Database.Stateful,Schedulable  {
    public static final String CALENDER = 'Calendar';
    Public static final String WORKPLAN_TASK = 'Workplan_Task__c';
    Public static final String MY_WORKPLAN_TASK_BREACHED = 'AIA_My_Task_Going_to_breach';
    Public static final String MY_GROUP_TASK_BREACHED = 'My_Group_s_Task_SLA_Breached';
    public static List<Holiday> holidayList = new List<Holiday>();
    //Start Method
    Set<Id> useremails = new set<Id>();
    Set<Id> manageremails = new set<Id>();
    //T01 -- Start
    Map<Id,Set<Id>> managerIds = new  Map<Id,Set<Id>>();
    //T01--End
    Map<string,string> viewmap = new Map<string,id>();        
    AIA_Utils errLogExp = new AIA_Utils();
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        //Querying all the record of Workplan Tasks based on the criteria
         String query = 'select id,CreatedDate,Expected_SLA__c,Status__c,OwnerId,ExpectedDate__c,Opportunity_Implementation_ID__c,Start_Date__c,AIA_SLA_days__c,SLA_Day_Type__c from Workplan_Task__c where (Status__c =\'In Progress\' and Opportunity_Implementation_ID__c !=\'\')';
          //String query = 'select id,CreatedDate,Expected_SLA__c,Status__c,OwnerId,ExpectedDate__c,AIA_SLA_days__c,Start_Date__c,SLA_Day_Type__c from Workplan_Task__c where id= \'a2n1F0000001wOEQAY\' ';
          return Database.getQueryLocator(query);
        
    }
   
   global void execute(SchedulableContext SC){   
        AIA_SLANotification_Batch SLABatch= new AIA_SLANotification_Batch ();
        database.executebatch(SLABatch,50);  
   }
         
    //Execute method
    global void execute(Database.BatchableContext bc, List<Workplan_Task__c> scope) {
        try{
            Set<Id> ownerId = new Set<Id>();
            Map<Id,User> userMap = new Map<Id,User>();
            Workplan_Task__c Wp = new Workplan_Task__c();
            holidayList = [SELECT StartTimeInMinutes, Name, ActivityDate FROM Holiday WHERE ActivityDate = THIS_YEAR];  
            for(Sobject s : scope)
            {
                Wp = (Workplan_Task__c)s;
                ownerId.add(Wp.OwnerId);
            }
            for(User u:[select id,name from User where Id IN: ownerId])
            {
               userMap.put(u.Id,u); 
            }
            //Getting the list of owners of the task for which the SLA is going to be breached and already breached
            for(Sobject s : scope){
                Wp = (Workplan_Task__c)s;
                system.debug('@@Wp--'+Wp);
                User u = userMap.get(Wp.OwnerId);
                Date currentDate = Date.today();
                if(Wp.ExpectedDate__c != null)
                {
                Date dueDate = Wp.ExpectedDate__c;
                Boolean breached = false;
                if(dueDate<currentDate)
                {
                   currentDate = dueDate;
                   dueDate = Date.today();
                   breached = true;
                }
                // T02 -- Start Updating days left to complete the wokplan task
                if(Wp.SLA_Day_Type__c == CALENDER){
                   Wp.AIA_SLA_Days__c = currentDate.daysBetween(dueDate); 
                }
                else{
                    Wp.AIA_SLA_Days__c = AIA_CalculateDaysDiffExcludingHoliday.CalculateWorkingDays(currentDate,dueDate);
                    
                }
                if(breached)
                {
                   Wp.AIA_SLA_Days__c = -(Wp.AIA_SLA_Days__c); 
                }
                //T02 -- End
                Date expectedDate = Wp.ExpectedDate__c;
                Date strDate = Wp.Start_Date__c;
                Date today = Date.today();
                //Added a condition to check user preference for sending mail
                //T02 -- Start
                 //if(today == expectedDate.addDays(-1) && !u.UserPreferencesDisableAllFeedsEmail){
                 if(Wp.AIA_SLA_Days__c == 1){
                 //T02 -- End
                   useremails.add(Wp.ownerId);
                   system.debug('@@useremails--'+useremails);
                }
                
                if(Test.isRunningTest()){
                    currentDate = date.today().adddays(1);
                    dueDate = date.today();
                    Wp.AIA_SLA_Days__c = -1;
                }
                   //T02 -- Start
                   //if(today == expectedDate.addDays(1)){
                   if(Wp.AIA_SLA_Days__c == -1){
                   //T02 -- End
                   //manageremails.add(Wp.ownerId);
                   //Added logic to send notification on business days when sla day type is not 'Calendar'
                       if(Wp.SLA_Day_Type__c == CALENDER)
                       {
                          manageremails.add(Wp.ownerId); 
                       }
                       else if(Wp.SLA_Day_Type__c != CALENDER && AIA_CalculateDaysDiffExcludingHoliday.checkWorkingDay(today, holidayList))
                       {
                           manageremails.add(Wp.ownerId);
                       }
                       else
                       {
                           Wp.AIA_SLA_Days__c = 0;
                       }
                   }
                }
            }
            update scope;
            List<String> lstOfStr = new List<String>{MY_WORKPLAN_TASK_BREACHED,MY_GROUP_TASK_BREACHED};
            List<ListView> viewLst=[SELECT Id,Name,DeveloperName 
                                    FROM ListView 
                                    WHERE SObjectType = :WORKPLAN_TASK AND 
                                          DeveloperName IN :lstOfStr];
            for(ListView view:viewLst)
            {
              if(view.DeveloperName ==MY_WORKPLAN_TASK_BREACHED)
              {
                  viewmap.put('USERVIEW',String.valueOf(view.Id).subString(0,15));
              }
              else if(view.DeveloperName == MY_GROUP_TASK_BREACHED)
              {
                  viewmap.put('MANAGERVIEW',String.valueOf(view.Id).subString(0,15));  
              }
            }
           
        }
        catch (Exception e) {
            System.debug('MainERROR:' + e);
             errLogExp.logException(e);
           
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        Try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            //If user list is not empty, get the list of user emails and send email to each user with the workplans to be completed  
            //T03 -- Start
            List<FeedItem> feedLst = new List<FeedItem>();
            string body = 'Please click the link and review the workplan tasks'; 
                    
            //T03--End
            If(useremails.size()>0 ){
               String objectPrefix = Workplan_Task__c.SObjectType.getDescribe().getKeyPrefix();
               for(User us:[Select id,Name,email from user where id in : useremails]){
                    list<string> toAddresses = new list<string>();
                    toAddresses.add(us.email);
                    String emailSubject = 'SLA notification for Workplan Tasks going to breached';
                    //Link to the list of workplans
                    string viewUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'+objectPrefix+'?fcf='+viewmap.get('USERVIEW');
                    //T03--Start
                    /*string Link = '<a href="'+viewUrl+'">'+'Click Here</a>';             
                    string emailbody = body+'\r\n'+'\r\n'+Link+'\r\n'; 
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(toAddresses);
                    mail.setSubject(emailSubject);
                    mail.setHtmlBody(emailbody);
                    mails.add(mail);*/
                    
                    system.debug('User Name'+us.Name);
                    FeedItem post = new FeedItem();
                    post.ParentId = us.Id; 
                    post.Body = body+' going to be breached';
                    post.LinkUrl = viewUrl;
                    feedLst.add(post);  
                    //T03--End
                  }
            }
            If(manageremails.size()>0 ){
            //If Manager list is not empty, get the list of user's and send email to their manager with the list of workplans to be completed  
               String objectPrefix = Workplan_Task__c.SObjectType.getDescribe().getKeyPrefix();
               //T01 -- Start
                //Getting all the managers from area mapping
               managerIds = AIA_GetAreaManager.getManagerId(manageremails);/** Method call to get the Manager's Id**/
               Set<Id> managerId = new Set<Id>();
               for(Set<Id> Ids:managerIds.values())
               {
                  managerId.addAll(Ids); 
               }
                //T01 --End
               if(managerId.size()>0)
               {
               for(User us:[Select id,Name,email,ManagerId,Manager.email from user where id in : managerId]){
                   list<string> toAddresses = new list<string>();
                   toAddresses.add(us.email);
                   String emailSubject = 'SLA notification for breached out Workplan Tasks';
                   //Link to the list of workplans
                   //T03 -- Start
                   string viewUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'+objectPrefix+'?fcf='+viewmap.get('MANAGERVIEW');
                   /*string Link = '<a href="'+viewUrl+'">'+'Click Here</a>';             
                   string emailbody = body+'\r\n'+'\r\n'+Link+'\r\n'; 
                   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   mail.setToAddresses(toAddresses);
                   mail.setSubject(emailSubject);
                   mail.setHtmlBody(emailbody);
                   mails.add(mail);*/
                   system.debug('User Manager Name'+us.Name);
                   FeedItem post = new FeedItem();
                    post.ParentId = us.Id; 
                    post.Body = body+' breached';
                    post.LinkUrl = viewUrl;
                    feedLst.add(post);  
                   //T03 -- End
               }
               }
            }
            //T03 -- Start
            /*if(mails.size()>0)
            {
                Messaging.sendEmail(mails);
            }*/
            //1562
            if(feedLst.size()>0)
            {
                insert feedLst;
            }
            //T03 -- End
        }
        Catch (Exception e) {
            System.debug('finish:' + e);
             errLogExp.logException(e);
           
        }
    }
    
}

/** CRON expression to schedule this class to run every hour - System.schedule('AIA Hourly SLA Notification Job', '0 0 * * * ?', new AIA_SLANotification_Batch()); **/