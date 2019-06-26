//=========================================================================================
//      Date: 08/20/2014
// Developer: Ashish Ojha
// Purpose  : To delete Sobject related data in batch using a batch job.
//            This batch job allow us to enter three parameters 
//            1.Sobject Api name 
//            2.A Optional Boolean parameter where false will. Default Is False
//            Delete data from the object table and True will delete data
//            from Recycle Bin As well
//            3. It will hold an optional where clause inside quotes.
//                not to use the actual word 'Where'
//
//  Usage: query = 'Select id from' +ObjectName+' +WhereClause ; 
//            example= 'Broker_Import_2_50__c',false,'Processed__c = true';  
//  Execution:SObject_Records_Delete_Process bc = new SObject_Records_Delete_Process('Broker_Import_2_50__c',True,'Processed__c = true');
//     database.executeBatch(bc);                      
//
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
// 03/30/2016    Tom Barrett    Made changes to handle a new custom setting field that will allow for
//                              multiple email addresses to be entered dynamically without changing code  
//====================================================================================================
global without sharing class SObject_Records_Delete_Process implements Database.Batchable<sObject>, Database.Stateful {
    private integer BatchCount = 0;
    private static final String Subject = 'Apex: SObject_Records_Delete_Process'; 
    private Boolean NonTrappableError = FALSE; 
    private String NonTrappableErrorMsg = '';
    private Boolean ActionNeeded = FALSE;
    private String EmailBody = ''; 
    Public String ObjectName = '';
    Public String WhereClause = '';
    public Boolean RecycleBinFlag = FALSE;
    private Integer DeletedDataCount = 0;
    private Integer DeleteRecycleBinCount = 0;
    private Boolean DeleteProcessFailed = FALSE;
    // Custom Exception Class
    private class SObject_Records_Delete_ProcessException extends Exception{}
    //Need to pass the Object Name and a boolean value as a parameter 
    public SObject_Records_Delete_Process(String ObjectName,Boolean RecycleBinFlag, String WhereClause){
        this.ObjectName = ObjectName;
        this.RecycleBinFlag = RecycleBinFlag;
        this.WhereClause = WhereClause;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){  
        String query = 'Select id from '+ObjectName; 
        if ( WhereClause != '' || WhereClause != NULL ) {
            WhereClause = ' Where ' + WhereClause;
            query +=  WhereClause;
        }   
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        try {
            system.debug('*************'+RecycleBinFlag);
            BatchCount += 1;
            delete scope;
            DeletedDataCount += scope.size(); 
            system.debug('%%%%%.......'+scope);
            if(RecycleBinFlag == true){
               DataBase.emptyRecycleBin(scope);
               DeleteRecycleBinCount += scope.size();
            }
        }
        catch (System.Exception e) {
            System.debug('Exception in SObject_Records_Delete_Process.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
            NonTrappableErrorMsg += '<b>Exception in SObject_Records_Delete_Process.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>'; 
            NonTrappableErrorMsg += '<b>Error occurred during batch #</b>' + BatchCount + '<br/>';
            ActionNeeded = TRUE;
            throw new SObject_Records_Delete_ProcessException(NonTrappableErrorMsg);
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
            
            if( RecycleBinFlag = True){
            EmailBody += '<b>Total Records Deleted From Recycle Bin:</b> ' + DeleteRecycleBinCount + '<br/>'; 
                }
            if ( DeletedDataCount - DeleteRecycleBinCount < 0 || Test.isRunningTest() ) {
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
                EmailBody += '<b>Broker Delete Process issue!  Check counts above.</b><br/>';
            }       
            if ( NonTrappableError || Test.isRunningTest() ) {
                EmailBody += '<br/><b>*** SERIOUS ISSUE OCCURED ***</b><br/>';
                EmailBody += NonTrappableErrorMsg + '<br/><br/>';
                EmailBody += '<b>Check the logs for details.</b><br/>';
            }  
            
//BEGIN CHANGE TPB 03/30/2016 
//NOTE: Before 03/30/2016 update the testEmail was used.
//      this is no longer needed.  Go to the DynamicCodeDataStore record 'EmailSupportTeams' when testing                           
            // Email the results
/* BEGIN: THIS CODE SHOULD ONLY BE UNCOMMENTED DURING TESTING
            Utils.EmailUtil email = new Utils.EmailUtil(new List<String>{UserInfo.getUserEmail()}); 
            email.subject(subject);
            email.replyTo(UserInfo.getUserEmail());
            email.htmlBody(emailBody);
            email.sendEmail();  
   END: THIS CODE SHOULD ONLY BE UNCOMMENTED DURING TESTING
*/        
//   BEFORE MOVING TO PRODUCTION COMMENT OUT THE CODE ABOVE AND UNCOMMENT BELOW
         // EmailAlerts.emailAdmins(subject, emailBody); 
           
           // Build out Parm List into EmailBody
           emailBody += '<br/><b>*** PAREMETERS SUPPLIED TO CLASS***</b><br/><br/>';
           emailBody += 'Object Name   : ' + this.ObjectName + '<br/>';
           emailBody += 'RecycleBinFlag: ' + this.RecycleBinFlag + '<br/>';
           emailBody += 'WhereClause   : ' + this.WhereClause + '<br/>';
           DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
           string[] toAddresses = cs.Text_255__c.Split(',');
           Utils.EmailUtil Email = new Utils.EmailUtil(toAddresses); 
           Email.subject(subject);
           Email.replyTo(UserInfo.getUserEmail());
           Email.htmlBody(emailBody);
           Email.sendEmail();                                       
// END CHANGE TPB 03/30/2016           
                    
        } catch(System.Exception e) {
            System.debug('Exception in Broker_DeleteData.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                     
        } 
    }
}