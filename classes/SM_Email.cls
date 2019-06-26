//=========================================================================================
//      Date: 08/22/2018     
// Developer: Tom Barrett (TPB)
//   Purpose: This class sends emails by reading the log activity.
//            Currently it is only utilized by the SM_QueueableDispatch class.  Because this 
//            class reads the log and the logs are written in a Queueable context it was
//            necessary to utilize Queueable in the SM_Email class since it reads the logs
//            to build the email content.
//=========================================================================================
//                                 Update History
// Date       Developer     Tag     Description
//=========================================================================================
//
//=========================================================================================
public class SM_Email implements Queueable {    
    //The word Completed means that the job completed and not necessarily success or fail
    //so that is why we have additional words to clarify as listed below.
    enum JobStatus {AllSuccessThatCompleted, AllFailure, SuccessAndFailure, NoneCompleted, SuccessButSomeNotCompleted, NoneCompletedAndFailure}   
    //Get SM_Support Info          
    SM_Support sms = new SM_Support();
    static List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();  
    String EmailGrouping;
    Set<Id> JobIdSet;
    SM_Support.ModuleName ModuleName;    
    Boolean PossibleMultipleTriggers;
    List<String> RecipientList = new List<String>();
    List<String> ProfileAuditProfileList = new List<String>();
    String EmailBody = '';
    String Subject = 'Sandbox Manager :: ';   
    Decimal EmailLogDelay;
    final String TIME_ISSUE_MSG = '<br/><br/><b>NOTE: All or some Queueable job(s) did not complete in time to collect the complete activity in this email.  Consider increasing the delay time for the \'Email Log Delay\' record on the SM Settings if you keep receiving this message. </b><br/>  ';
    final String IN_THE_MEAN_TIME = '<br/>' + 'In the meantime review the log for the latest Sandbox Manager Activity for Email Grouping ';
    final String IN_ADDITION = 'In addition, go to the Apex Jobs and evaluate the final status of the jobs shown below.';
    final String MAY_BE_MORE_THAN_200_RECORDS = '<br/><br/><b>' + '200 or more records were detected to process, look for possible multiple emails or check the logs for more details' + '</b>';
    final String LOG_INTO_PROD_LINK = '<br/><br/><b>' + 'Log into the <a href="' +  URL.getSalesforceBaseUrl().toExternalForm() + '">PRODUCTION</a> org and review the Sandbox Manager Logs for more details.' + '</b><br/><br/>';
    String JobResults = '';
    
    public SM_EMail(List<String> RecipientList, List<String> ProfileAuditProfileList, String EmailGrouping, Set<Id> JobIdSet, 
                    SM_Support.ModuleName ModuleName, Boolean PossibleMultipleTriggers, Decimal EmailLogDelay) {  
        System.debug('---SM_EMail---'); 
		this.RecipientList = RecipientList;
        this.ProfileAuditProfileList = ProfileAuditProfileList;
		this.EmailGrouping = EmailGrouping;
        this.JobIdSet = JobIdSet;
        this.ModuleName = ModuleName;
        this.PossibleMultipleTriggers = PossibleMultipleTriggers;
        this.EmailLogDelay = EmailLogDelay;
    }  
    
    public void execute(QueueableContext context) {  
        SM_Support sms = new SM_Support();
	    JobStatus js = checkJobStatus();   
	    System.debug('SM_Email.execute - JobStatus: ' + js);

        //all Successful
        if (js != JobStatus.AllFailure) {        
        	buildEmailContent(js);           
        } 

        //All Failed
        //Unfortunately, there is now way to force a job to fail so the 
        //Test.isRunningTest method was used to get code coverage.
        if (js == JobStatus.AllFailure || Test.isRunningTest()) { 
            System.debug('No Queueable Jobs were successful; Notifying via email!');  
            Subject = 'FAILURE: ' + Subject + this.ModuleName;
            EmailBody = 'All Queueable jobs failed.' + '<br/>' + JobResults + LOG_INTO_PROD_LINK;
            packageEmails(this.RecipientList, Subject, EmailBody);
            sendEmails();
        }
    }
    
    /*********************************************
     * Checks the associated apex queueable job(s)
     * and return the proper status of the job(s)
     *********************************************/
    private JobStatus checkJobStatus() {
        System.debug('---SM_EMail.CheckJobStatus---'); 
        JobStatus js = JobStatus.NoneCompleted; 
        String JobMsg = '';
        Integer Failure = 0;
        Integer Success = 0;
        Integer NotCompleted = 0;
  
        //Convert the seconds value from SM_Settings (Email_Log_Delay) to milliseconds        
   		Integer millisec = (EmailLogDelay * 1000).intValue(); 
//For testing only
//Integer millisec = 300;
   		Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        //Plugged in a delay so job(s) have a chance to complete
        while ((finishTime - startTime) < millisec) {
            //sleep for parameter x millisecs
            finishTime = DateTime.now().getTime();
        }
        
        List<AsyncApexJob> jobInfo = [SELECT id, Status,NumberOfErrors FROM AsyncApexJob WHERE Id=:JobIdSet];
        System.debug('Limits.getQueueableJobs(): ' + Limits.getQueueableJobs());   

        for (AsyncApexJob job : JobInfo) {
        	If (job.Status == 'Failed' || job.NumberOfErrors != 0) Failure++;
            if (job.Status == 'Completed' && job.NumberOfErrors == 0) Success++;
            if (job.Status != 'Completed') NotCompleted++;   
            JobMsg += 'Job Id: ' + job.Id + ' - status: ' + job.status + ' - Number of Errors: ' + job.NumberOfErrors + '<br/>';             
        }
        JobResults = '<br/><b>' + 'Job Results:' + '</b><br/>' + JobMsg;
        
        System.debug(JobResults);
        
        if (Failure == 0 && Success > 0) js = JobStatus.AllSuccessThatCompleted;
        if (Failure > 0  && Success > 0) js = JobStatus.SuccessAndFailure;
        if (Failure > 0  && Success == 0) js = JobStatus.AllFailure; 
        if (Failure > 0 &&  Success == 0 && NotCompleted > 0) js = JobStatus.NoneCompletedAndFailure;
        if (js == JobStatus.AllSuccessThatCompleted && NotCompleted > 0) js = JobStatus.SuccessButSomeNotCompleted;
        if (NotCompleted == JobInfo.size()) js = JobStatus.NoneCompleted; 
   
        return js;
    }
   
    /******************************************
     * Build the appropriate conent for the 
     * emails that will be sent out.
     ******************************************/
    private void buildEmailContent(JobStatus js) { 
        System.debug('---SM_EMail.BuildEmailContent---'); 
        String ModuleTypeMsg = '';  
        Integer LoopCount = 1;
        //Used to handle not showing 'null' in emails
        String PermSets = '';
        String SourceLastModifiedDate = '';
        //Error detected
        Boolean SeverityCritical = false;
        //Build HTML Table header
        String Header = '<!DOCTYPE html><html><head><title>Profile Audit User</title><style>table {border-collapse: collapse; width: 100%;}';
        Header += 'th, td {border: 1px solid #ccc; padding: 10px;}';
        Header += 'table.alt tr:nth-child(even) {background-color: #eee;}';
        Header += 'table.alt tr:nth-child(odd) {background-color: #fff;}</style></table></header>';
        Header += '<body><table class="alt">';
        Header += '<tr><th>Email Grouping</th><th>Message Source</th><th>Severity</th><th>Message</th>';
        Header += '<th>Username</th><th>Profile Name</th><th>Permission Set(s)</th><th>Org Name</th><th>Last LogIn Date</th><th>Source Last Modified Date</th></tr>';  
        Subject += this.ModuleName;
        
		for (SM_Log__c l : [SELECT Email_Grouping__c, Sandbox_Name__c, Username__c, Profile_Name__c, Permission_Sets__c, Severity__c, 
                                   Message_Source__c, Message__c, Source_Last_Modified_Date__c, Last_Login_Date__c, LastModifiedDate
                            FROM SM_Log__c
                            WHERE Email_Grouping__c = :EmailGrouping ORDER BY Username__c, Log_Grouping_2__c DESC LIMIT 9999]) {
                                
            //Have to do this because SF seems to show blank on the screen but 'null' in the email!
            PermSets = l.Permission_Sets__c == null ? 'n/a' : l.Permission_Sets__c;
            SourceLastModifiedDate = l.Source_Last_Modified_Date__c == null ? 'n/a' : String.valueOfGmt(l.Source_Last_Modified_Date__c);
                                
            EmailBody += '<tr><td>' + l.Email_Grouping__c + '</td><td>' + l.Message_Source__c + '</td><td>' + l.Severity__c + '</td><td>' + l.Message__c + '</td>';
            EmailBody += '<td>' + l.Username__c  + '</td><td>' + l.Profile_Name__c + '</td><td>' + PermSets + '</td><td>' + l.Sandbox_Name__c + '</td>';
            EmailBody += '<td>' + l.Last_Login_Date__c + '</td><td>' + SourceLastModifiedDate + '</td></tr>';	                         
            if (l.Severity__c == 'Critical') SeverityCritical = true;   
            //Only build email for 200 records to reduce possible email failure and over sized information
            if (LoopCount == 200) break;
            LoopCount++;
        }
        
        
      	//Close the HTML Table Tags
		EmailBody += '</table></body></html>';
        
        System.debug('SM_Email.sendEmails - ModuleName = \'' + ModuleName + '\'');  
        
        if (this.ModuleName == SM_Support.ModuleName.Deprovision_User) {
			ModuleTypeMsg = this.ModuleName + ' action occurred for user(s).' + '<br/>';	        
        } else if (this.ModuleName == SM_Support.ModuleName.Provision_User) {
        	ModuleTypeMsg = this.ModuleName + ' action occurred for user(s).' + '<br/>';
        } else if (this.ModuleName == SM_Support.ModuleName.Profile_Audit) {
        	ModuleTypeMsg = this.ModuleName + ' action occurred for user(s), with the following profiles ' + ProfileAuditProfileList  + '.';  
        }
        
        If (LoopCount == 200) ModuleTypeMsg += MAY_BE_MORE_THAN_200_RECORDS;
        
        //If critical issues detected from the FOR LOOP of SM_Log__c above or Job Failures...
        if(SeverityCritical || js == JobStatus.SuccessAndFailure || js == JobStatus.NoneCompletedAndFailure ) {
            Subject = 'FAILURE: ' + Subject;       
            ModuleTypeMsg += TIME_ISSUE_MSG + IN_THE_MEAN_TIME + '\'' + '<b>' + EmailGrouping + '\'.  ' + '</b>' + IN_ADDITION;
        }
        
        if (js == JobStatus.NoneCompleted || js == JobStatus.SuccessButSomeNotCompleted || Test.isRunningTest()) {
            //If subject was not set to FAILURE above we can set to WARNING
            if(!Subject.startsWith('FAILURE')) Subject = 'WARNING: ' + Subject;
            ModuleTypeMsg += TIME_ISSUE_MSG + IN_THE_MEAN_TIME + '\'' + '<b>' + EmailGrouping + '\'.  ' + '</b>' + IN_ADDITION;
            ModuleTypeMsg += '<br/>' + JobResults;
        }
        
        if (PossibleMultipleTriggers) ModuleTypeMsg += MAY_BE_MORE_THAN_200_RECORDS; 
        ModuleTypeMsg += LOG_INTO_PROD_LINK;
        EmailBody = ModuleTypeMsg + Header + EmailBody; 

        packageEmails(this.RecipientList, Subject, EmailBody);
        sendEmails();
    }
    
    /**************************************************
     * Package Emails together and store in a list 
     * to allow  single sendEmail from the method below      
     **************************************************/
    private void packageEmails(List<String> Recipients, String Subject, String Body) {
        System.debug('---SM_EMail.PackageEmails---'); 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        System.debug('---SM_Support.BuildEMails---');
        if (Recipients != NULL) {
            mail.setToAddresses(Recipients);
            mail.setReplyTo('noreply@salesforce.com');
            mail.setSenderDisplayName('Sandbox Manager');
            mail.setSubject(Subject);
            mail.setHtmlBody(Body);
            mails.add(mail);  
        }
    }  
    
    /*************************************************
     * Sends out emails.  This method requires at 
     * least one call to the BuildEmails method above
     *************************************************/
    private void sendEmails() {  
        System.debug('---SM_EMail.SendEmails---'); 
        if (mails != NULL || !mails[0].getToAddresses().isEmpty()) {
            Messaging.sendEmail(mails);    
        }
    }
}