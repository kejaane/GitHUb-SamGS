//=========================================================================================
//      Date: 02/17/2013
// Developer: Tom Barrett (TPB)
//   Purpose: To delete enrollment related data in batch apex way.
//
//     Usage: Enrollment_DeleteData eid = new Enrollment_DeleteData();
//            eid.query = 'SELECT id FROM Enrollment_Import__c';   
//            database.executeBatch(eid);                      
//
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
// 03/29/2016    Tom Barrett    Made changes to handle a new custom setting field that will allow for
//                              muliple email addresses to be entered dynamically without changing code  
//====================================================================================================
global without sharing class Enrollment_DeleteData implements Database.Batchable<sObject>, Database.Stateful {
    public String query;
    private static final String Subject = 'Apex: Enrollment_DeleteData'; 
    private String EmailBody = ''; 
    private Integer DeletedDataCount = 0;
    private Integer RecycleBinDeleteCount = 0;
    private integer BatchCount = 0;
    // Action Needed Detector
    private Boolean DeleteProcessFailed = FALSE;
    private Boolean ActionNeeded = FALSE;  
    private Boolean NonTrappableError = FALSE; 
    private String NonTrappableErrorMsg = '';
    // Custom Exception Class
    private class EnrollmentException extends Exception{}  

    global Database.QueryLocator start(Database.BatchableContext BC){  
        if ( Test.isRunningTest() ) {
            query += ' LIMIT 100';
        }    
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        try {
            BatchCount += 1;
            delete scope;
            DeletedDataCount += scope.size();            
            DataBase.emptyRecycleBin(scope);
            RecycleBinDeleteCount += scope.size();
        } catch (System.Exception e) {
            System.debug('Exception in Enrollment_DeleteData.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
            NonTrappableErrorMsg += '<b>Exception in Enrollment_DeleteData.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>'; 
            NonTrappableErrorMsg += '<b>Error occured during batch #</b>' + BatchCount + '<br/>';
            ActionNeeded = TRUE;
            throw new EnrollmentException(NonTrappableErrorMsg);         
        }
    }
    
    global void finish(Database.BatchableContext BC){
        // Query the AsyncApexJob object to retrieve the current job's information.
        try {
            AsyncApexJob a = [ SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                               FROM AsyncApexJob 
                               WHERE Id = :BC.getJobId() and JobType <> 'BatchApexWorker' ];    
    
            EmailBody += '<b>The Batch Apex job</b> ' + a.Status + '.<br/>';
            EmailBody += '<b>The Batch Apex job processed</b> ' + a.TotalJobItems + ' <b> batches with</b> ' + a.NumberOfErrors + ' <b>failures.</b><br/>';
            EmailBody += '<b>The job was executed by:</b> ' + a.CreatedBy.Email + '.<br/><br/>';
            EmailBody += '<b>Begin Delete Process</b><br/>';
            EmailBody += '<b>Total Records Deleted:</b> ' + DeletedDataCount + '<br/>';
            EmailBody += '<b>Total Records Deleted From Recycle Bin:</b> ' + RecycleBinDeleteCount + '<br/>'; 

            if ( DeletedDataCount - RecycleBinDeleteCount <> 0 || Test.isRunningTest() ) {
                ActionNeeded = TRUE;
                DeleteProcessFailed = TRUE;
            }            
            if ( a.NumberOfErrors > 0 || Test.isRunningTest() ) {
                ActionNeeded = TRUE; 
            }
            if ( ActionNeeded || Test.isRunningTest() ) {                
                EmailBody += '<br/><b>*** ACTION NEEDED ***</b><br/><br/>';
            }
            if ( a.NumberOfErrors > 0 || Test.isRunningTest() ) {
                EmailBody += '<b>Total batch failures:</b> ' + a.NumberOfErrors + '<br/>';   
            }     
            if ( DeleteProcessFailed || Test.isRunningTest() ) {
                EmailBody += '<b>Enrollment Delete Process issue!  Check counts above.</b><br/>';
            }       
            if ( NonTrappableError || Test.isRunningTest() ) {
                EmailBody += '<br/><b>*** SERIOUS ISSUE OCCURED ***</b><br/>';
                EmailBody += NonTrappableErrorMsg + '<br/><br/>';
                EmailBody += '<b>Check the logs for details.</b><br/>';
            }               
//BEGIN CHANGE TPB 03/29/2016 
//NOTE: Before 03/26/2016 update the testEmail was used.
//      this is no longer needed.  Go to the DynamicCodeDataStore record 'EmailSupportTeams' when testing       
    // BEGIN: THIS CODE SHOULD ONLY BE UNCOMMENTED DURING TESTING       
                /*
                Utils.EmailUtil testEmail = new Utils.EmailUtil(new List<String>{UserInfo.getUserEmail()}); 
                testEmail.subject(subject);
                testEmail.replyTo(UserInfo.getUserEmail());
                testEmail.htmlBody(emailBody);
                testEmail.sendEmail();     
                */              
    // END: THIS CODE SHOULD ONLY BE UNCOMMENTED DURING TESTING   
    // BEFORE MOVING TO PRODUCTION COMMENT OUT THE CODE ABOVE AND UNCOMMENT THE LINE BELOW
    //         EmailAlerts.emailAdmins(subject, emailBody);  
           DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
           string[] toAddresses = cs.Text_255__c.Split(',');
           Utils.EmailUtil Email = new Utils.EmailUtil(toAddresses); 
           Email.subject(subject);
           Email.replyTo(UserInfo.getUserEmail());
           Email.htmlBody(emailBody);
           Email.sendEmail();                                       
// END CHANGE TPB 03/29/2016  
           
        } catch(System.Exception e) {
            System.debug('Exception in Enrollment_DeleteData.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                     
        } 
    }
}