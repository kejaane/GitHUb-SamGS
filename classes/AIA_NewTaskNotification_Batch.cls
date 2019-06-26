/*=================================================================================================================
 * Date         : 04/20/2018
 * Developer    : Gayathri Palanisamy
 * Purpose      : Batch class to send emails to user when workplan task is assigned to them as part of US197.
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 04/20/2018   Gayathri P             Initial version
 * 05/01/2018   Asif Kutagulla         Updated reasons why this cannot be a out of the box scheduled report
 * 05/18/2018   Gayathri P       T01   Added logic to post on user's profile when SLA is breached or going to be breached 
 * 									   and removed logic to send email on the same-US1562.
 *============+================+=====+=============================================================================
 */
global class AIA_NewTaskNotification_Batch implements Database.Batchable<sobject>,Database.AllowsCallouts,Database.Stateful,Schedulable {
	Public static final String WORKPLAN_TASK = 'Workplan_Task__c';
    Public static final String MY_WORKPLAN_TASK = 'My_Workplan_Assignment';
    AIA_Utils errLogExp = new AIA_Utils();
    Set<Id> useremails = new set<Id>();
    Map<Id,Integer> taskCount = new Map<Id,Integer>();
    String viewId='';
    //Start Method
    global Database.QueryLocator start(Database.BatchableContext bc){
        //Querying all the record of Workplan Tasks based on the criteria
         String query = 'select id,Status__c,Start_Date__c,AIA_Task_Assigned_Date__c,OwnerId,Owner.email '+
                        'from Workplan_Task__c '+
                        'where Status__c =\'In Progress\' AND  AIA_Task_Assigned_Date__c = TODAY';
         return Database.getQueryLocator(query);
        
    }
    global void execute(SchedulableContext SC){   
         AIA_NewTaskNotification_Batch taskBatch= new AIA_NewTaskNotification_Batch ();
         database.executebatch(taskBatch,50);
   }
         
    //Execute method
    global void execute(Database.BatchableContext bc, List<Workplan_Task__c> scope) {
      try{
          Set<Id> ownerId = new Set<Id>();
          Workplan_Task__c Wp = new Workplan_Task__c();
          Map<Id,User> userMap = new Map<Id,User>();
          List<Workplan_Task__c> wpLst = scope;
          set<ID> wpId = new set<ID>();
          Map<Id,List<String>> wpMap = new Map<Id,List<String>>();
          for (Workplan_Task__c wpTask : wpLst)
          {
              wpId.add(wpTask.Id);
              ownerId.add(wpTask.OwnerId);
          }
          //T01 -- Start
          
          List<User> usrLst = [select id,name from User where Id IN: ownerId];
          for(User u:usrLst)
            {
               userMap.put(u.Id,u); 
            }
            
          //Iterating the list of data fatched by query
            for(Sobject s : scope){
            	Wp = (Workplan_Task__c)s;
                User u = userMap.get(Wp.OwnerId);
                system.debug('user map@@@@'+u);
                //Checking the user preference from chatter settings to send notification
                //T01 -- Start
                //if(u.UserPreferencesDisableAllFeedsEmail == false)
                //   {
                //T01 -- End	
                        useremails.add(u.Id);
                   		//To Calculate the number of tasks assigned to the user
                		if(taskCount.containsKey(u.Id)){
                    	taskCount.put(u.Id,taskCount.get(u.Id)+1);
                		}
                		else
               			{
                    	taskCount.put(u.Id,1);
                		}
                      
                //   }
            }
          //My_Workplan_Assignment
          ListView viewRec=[SELECT Id,Name,DeveloperName FROM ListView WHERE SObjectType =: WORKPLAN_TASK AND DeveloperName =: MY_WORKPLAN_TASK Limit 1];
          if(viewRec!=null)
          {
              viewId = String.valueOf(viewRec.Id).subString(0,15);  
          }
            
          }
        catch (Exception e) {
            System.debug('MainERROR:' + e);
             errLogExp.logException(e);
           
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        try{
        //If user list is not empty, get the list of user emails and send email to each user with the workplans assigned 
            If(useremails.size()>0 ){
				String objectPrefix = Workplan_Task__c.SObjectType.getDescribe().getKeyPrefix();
                List<User> userRecList = [Select id,Name,email from user where id in : useremails];
                String emailSubject = 'Notification for Workplan Assignments';
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                //T01 -- Start
                List<FeedItem> feedLst = new List<FeedItem>();
                //T01 -- End
                for(User us:userRecList){
                    list<string> toAddresses = new list<string>();
            		toAddresses.add(us.email);
                   	string body = 'Number of tasks assigned to you today = '+taskCount.get(us.Id)+'.Please click the link and review the workplan assignments';
                    //T01 -- Start
                    //Link to the list view of My Workplan Assignments. 
                    /*string Link = '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+objectPrefix+'?fcf='+viewId+'">'+'Click Here</a>'; */            
                   	/*string emailbody = body+'\r\n'+'\r\n'+Link+'\r\n'; 
                   	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   	mail.setToAddresses(toAddresses);
                   	mail.setSubject(emailSubject);
                    mail.setHtmlBody(emailbody);
                    mails.add(mail);*/
                    
                    FeedItem post = new FeedItem();
					post.ParentId = us.Id; 
					post.Body = body;
					post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'+objectPrefix+'?fcf='+viewId;
					feedLst.add(post);	
                    
                   
                }
                /*if(mails.size()>0)
                {
                Messaging.sendEmail(mails);
                }*/
                if(feedLst.size()>0)
                {
                    insert feedLst;
                }
                //T01 -- End
                }
            }
       
        Catch (Exception e) {
            System.debug('finish:' + e);
             errLogExp.logException(e);
           
        }
    }
}

/** 
 * Reasons why this batch notification cannot be done as a scheduled report:
 * 1.This involves querying data across multiple objects to get manager information from aia user area mapping object
 * 2.Stop email generation based on chatter preferences
 * 3.Report schedules can be changed in classic only
 * 4.Report generates an excel export of tasks. we dont want users to use this report as reference of work
 *      to be done, instead they should always use custom list views for tracking their work and use it
 *      consistently across all channels for task tracking
**/