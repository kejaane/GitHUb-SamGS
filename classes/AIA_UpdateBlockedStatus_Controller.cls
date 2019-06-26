/*===================================================================================================================
* Date       : 5/22/2018
* Developer  : Arshia Gulati
* Purpose    : This is the controller class for VF page "AIA_UpdateBlockedStatus" that is invoked to change status to Blocked for 
*               a list of tasks US-2254
*
*                                 Update History
*                                 ---------------
* Date       |     Developer       | Tag |   Description
*============+============+=========================================================================================
* 5/22/2018  | Arshia Gulati       |     | Initial Creation
* 6/18/2018  | Arshia Gulati       | T01 | Updated to populate Subprocess within the Implementation
*============+============+=========================================================================================*/

public without sharing class AIA_UpdateBlockedStatus_Controller {
    public String SubProcess_selected{get; set;}
    public String BlockerTask_selected{get; set;}    
    public List<Sub_Process__c> SubProcessList = new List<Sub_Process__c>();
    public List<SelectOption> lstSubProcess{get; set;}
    public List<SelectOption> lstWPTask{get; set;}
    public List<WorkPlan_Task__c> tskLst = new List<WorkPlan_Task__c>();   
    List<WorkPlan_Task__c> WPTaskList = new List<WorkPlan_Task__c>();   
    public Boolean ShowMainPanel{get; set;}   
    public String strMessage{get; set;}
    Map<Id,String> SubProcessMap;
    public ID currentUser;
    public WorkPlan_Task__c objTask{get; set;}
    public Set<String> tskIds_Selcted;
    public Set<String> impIds_Selcted;    //T01
 
    public AIA_UpdateBlockedStatus_Controller(ApexPages.StandardSetController controller){
        tskLst = (WorkPlan_Task__c[])controller.getSelected(); 
        SubProcessMap = new Map<Id,String>();
        CurrentUser = UserInfo.getUserId();          
        objTask = new WorkPlan_Task__c();
        tskIds_Selcted = new Set<String>();  
        impIds_Selcted = new Set<String>();      //T01
        ShowMainPanel = true;
        if(tskLst.size()==0)
        {            
            ShowMainPanel = false;
            strMessage = AIA_Constants.ERRMESSAGE_SELECTTASKS;
        }
        else
        {
            if(tskLst.size()>1)
            {            
                ShowMainPanel = false;
                strMessage = AIA_Constants.ERRMESSAGE_MORETHANONE;
            }
            else
            {   for(WorkPlan_Task__c tsk :tskLst){
                tskIds_Selcted.add(tsk.id);
                }
            }
        }
         WPTaskList = [select Id,OwnerId,Status__c,Implementation__c         //T01
                          from workPlan_Task__c 
                          where Id in :tskIds_Selcted]; 
        for(workPlan_Task__c temp : WPTaskList)
            {      
                impIds_Selcted.add(temp.Implementation__c);      //T01
                if((currentUser != temp.OwnerId) || (temp.Status__c != AIA_Constants.WPTask_STATUS_INPROGRESS))             
                {
                    System.Debug('currentUser: '+currentUser + ' temp.OwnerId: ' + temp.OwnerId);
                    ShowMainPanel = false;
                    strMessage = AIA_Constants.ERRMESSAGE_SELFOWNED;
                }
            }
        WPTaskList = [select Id,Task_Name__c,OwnerId,Sub_Process__r.Id,Sub_Process__r.Stage__c
                          from workPlan_Task__c 
                          where Status__c in (:AIA_CONSTANTS.WPTask_STATUS_COMPLETED,:AIA_CONSTANTS.WPTask_STATUS_NOTREQUIRED)
                          and Task_Name__c != null and Implementation__c IN :impIds_Selcted      //T01
                      ];         
            
        lstSubProcess = new List<SelectOption>();   
        lstSubProcess.add(new SelectOption('', '--Select--'));       
            for(workPlan_Task__c temp : WPTaskList)
            {  
               if(!SubProcessMap.containsKey(temp.Sub_Process__r.Id)){
                    SubProcessMap.put(temp.Sub_Process__r.Id,temp.Sub_Process__r.Stage__c);
                }
            }
            for (ID idKey : SubProcessMap.keyset()) 
            {       
                    lstSubProcess.add(new SelectOption(idKey,SubProcessMap.get(idKey)));                
            } 
        if(lstSubProcess.size() > 0)
                SubProcess_selected = (lstSubProcess.get(0)).getValue();
        lstWPTask = new List<SelectOption>();            
        lstWPTask.add(new SelectOption('', '--Select--'));       
    }
    public void  changeSubprocess()
    {
        System.Debug('AG SubProcess_selected'+SubProcess_selected);
        
        lstWPTask = new List<SelectOption>();       
        lstWPTask.add(new SelectOption('', '--Select--'));   
            for(workPlan_Task__c temp : WPTaskList)
            {        
                if(temp.Sub_Process__r.Id == SubProcess_selected){
                    System.Debug('AG temp : ' + temp);
                    System.Debug('AG temp.WPTask'+temp.Id + ' ' + temp.Task_Name__c);
                    if(temp.Id != null && temp.Task_Name__c != null)
                    lstWPTask.add(new SelectOption(temp.Id,temp.Task_Name__c));
                }
            } 
        if(lstWPTask.size() > 0)
        BlockerTask_selected = (lstWPTask.get(0)).getValue();
        System.Debug('AG BlockerTask_selected ' + BlockerTask_selected);
   }
    //Display List view on click of Cancel Button
    public PageReference CancelUpdate() {
        
        return new ApexPages.Action('{!List}').invoke();       
    }
   //Method to be called to block status
    public PageReference UpdateTaskStatus() {
        try
        {
            if (String.isBlank(SubProcess_selected)){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AIA_Constants.ERRMESSAGE_SUBPROCESS));  
             return ApexPages.currentPage();
         }
        if (String.isBlank(BlockerTask_selected)){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AIA_Constants.ERRMESSAGE_TASK));  
             return ApexPages.currentPage();
         }
        for(workPlan_Task__c temp : tskLst)
            {      
                temp.Blocker_Task__c = BlockerTask_selected;
                temp.Comments__c = objTask.Comments__c;
                temp.Status__c = AIA_Constants.WPTask_STATUS_BLOCKED;
                temp.IsUpdateFromVF__c = true;
            }
        update tskLst;           
            sendNotificationToTaskOwner(tskLst);
            
        return new ApexPages.Action('{!List}').invoke();  
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));  
            return null;
        }
    }
    //Method to send Notification to Task Owner and Implementation PM
    public void sendNotificationToTaskOwner(List<WorkPlan_Task__c> lstBlockedTask)
    {   
        System.Debug('Inside sendNotificationToTaskOwner');
        WorkPlan_Task__c objTask;
        AIA_Implementation__c objImp;
        string link,blockedTaskLink,msgBody,msgSubject;
        list<string> replaceVars,repVars;
        for(WorkPlan_Task__c objBlockedTask: lstBlockedTask){        
            objTask = new WorkPlan_Task__c();
            objTask = [Select Owner.FirstName,Owner.LastName,AccountID__c,Owner.email,Description__c,RelatedObjectId__c,Implementation__c from WorkPlan_Task__c where id = :objBlockedTask.Blocker_Task__c limit 1];
            objImp = [Select Owner.email,Account_Legal_Name__c from AIA_Implementation__c where id = :objTask.Implementation__c limit 1];
            link = '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+objTask.Id+'">'+'Click Here</a>';
            blockedTaskLink = '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+objBlockedTask.Id+'">'+'Click Here</a>';
        
        replaceVars = new list<string>{objTask.Owner.FirstName,objTask.Owner.LastName,objImp.Account_Legal_Name__c,
                                       objTask.Description__c,objBlockedTask.Comments__c,link,blockedTaskLink}; 
        msgBody = string.format(system.label.AIA_Workplan_Blocking_Task_Notification,replaceVars);
        msgSubject = 'Blocked Task Notification for ' + objImp.Account_Legal_Name__c;
            
        List<String> sendTo = new List<String>();
        system.debug('taskid>>>>'+objTask);
        sendTo.add(objTask.Owner.email);
        sendTo.add(objImp.Owner.email);
        System.Debug('AG sendTo' + sendTo);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(sendTo);
            email.setSubject(msgSubject);
            email.setHtmlBody(msgBody);       
        system.debug('@@mails--'+email);
        mails.add(email);
        Messaging.sendEmail(mails);      
        System.Debug('Email sent');
        
             link = URL.getSalesforceBaseUrl().toExternalForm()+'/'+objTask.Id;
            blockedTaskLink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+objBlockedTask.Id;
        
         repVars = new list<string>{objTask.Owner.FirstName,objTask.Owner.LastName,objImp.Account_Legal_Name__c,
                                    objTask.Description__c,objBlockedTask.Comments__c,link,blockedTaskLink}; 
        msgBody = string.format(system.label.AIA_Workplan_Blocking_Task_Notification,repVars);
        msgSubject = 'Blocked Task Notification for ' + objImp.Account_Legal_Name__c;
          
        List<FeedItem> lstFeedItems = new List<FeedItem>();
        FeedItem post = new FeedItem();
        post.ParentId = objTask.Owner.Id;
        post.Body = msgBody.replace('<br/>','\n').replace('<b>','').replace('</b>','');
        lstFeedItems.add(post);
        post = new FeedItem();
        post.ParentId = objImp.Owner.Id;
        post.Body = msgBody.replace('<br/>','\n').replace('<b>','').replace('</b>','');
        lstFeedItems.add(post);
        insert lstFeedItems;        
        }
    }
}