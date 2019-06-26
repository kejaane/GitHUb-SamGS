/*########################################################################################################################
Class        :   Enrollment_2_50_Account_Process
Author       :   Tom Barrett and Ashish Ojha
Created Date :   8/15/2014
Description  :  This class is used upsert data from Enrollment_2_50__c to Accounts object based 
                Facets_Account_Number__c as the Key. The batch will run through all the records in 
                Enrollment_2_50__c object and populate Account type as customer, Account Record type
                AccountName, Fascets_account_number__c, SIC__c and also Status field with either 'Termed' 
                or 'Active' Based on if Term_Date__c is filled in the import object                               
Instantiate  :   Enrollment_2_50_Account_Process ep = new Enrollment_2_50_Account_Process();  
          OR :   Enrollment_2_50_Account_Process ep = new Enrollment_2_50_Account_Process(TRUE);  
Execution    :   Enrollment_2_50_Account_Process bc = new Enrollment_2_50_Account_Process(FALSE);
                 database.executeBatch(bc);
11/03/15 AO  :  Updates to make RecType_Facets_Account_Number__c as the unique key. 
*/
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
// 11/11/2015    Ashish Ojha    Added SIC, Rating_State__c and Account_Effective_date__c into the mapping 
// 11/03/2015    Ashish Ojha    Updates to make RecType_Facets_Account_Number__c as the unique key. 
// 03/28/2016    Tom Barrett    Made changes to handle a new custom setting field that will allow for
//                              muliple email addresses to be entered dynamically without changing code 
// 06/21/2016    Ashsih Ojha    mapped the EIN__c from Enrollment object onto the Account Object 
//====================================================================================================
global class Enrollment_2_50_Account_Process implements Database.Batchable<SObject>,database.stateful{
    Integer totfailure = 0;
    Integer totUpserts = 0;
    Integer totprocessed = 0;
    // This variable is used to when we are passing the query from the developer console
    private Boolean ForTestingOnly = False;
    private String entType = null;
    private String EmailBody = '';
    private integer BatchCount = 0; 
    private static final String Subject = 'Apex: Enrollment_2_50_Account_Process'; 
    private String NonTrappableErrorMsg = '';
    private Boolean NonTrappableError = FALSE; 
    private String failedRecordIds = '';
    public class Enrollment_2_50_Account_ProcessException extends Exception{}
    //Constructor for the batch : to pass the query from developer console.
    // Also for testing purpose only, we are passing a boolean value to be false
    public Enrollment_2_50_Account_Process(boolean ForTestingOnly) {
        this.ForTestingOnly = ForTestingOnly;        
    }
    global database.querylocator start(Database.BatchableContext bc) {     
       String Query = 'Select id, Name, Term_Date__c, Account_Name__c, Account_Number__c,EIN__c, sic__c,Rating_State__c, Account_Effective_date__c ' +
                       'FROM Enrollment_Import_2_50__c ' + 
                       'WHERE Processed__c = false ';                        //'ORDER BY Entity_ID__c';  
                       
          
       
        return Database.getQueryLocator(query);   
    }
    
    global void execute(Database.BatchableContext bc, Enrollment_Import_2_50__c[] EnrollmentImpList) { 
        BatchCount += 1;
        string RtId = querybase.getRecordtypeId('Account', 'X2_50');
        List<Account>   accListToUpsert = new List<Account>();
        Map<String, Account> accountMap = new Map<String, Account>();
        Account acc;         
            
        /******************* Iterating on all the Enrollment 2-50 Import Records ***********************************/   
         
        //List of Enrollment 2-50 import object which we are getting from Start method 
        if(EnrollmentImpList != null && EnrollmentImpList.size() > 0){         
            for(Enrollment_Import_2_50__c enrl: EnrollmentImpList){
                totprocessed += 1;
                // If account has not been put into the map then put it there
                // for the first time
                acc = new Account();
                if( accountMap.get(enrl.Account_Number__c) == NULL ){                   
                    // Map enrollment 2-50 import fields with account fields
                    acc.Type = 'Customer';
                    acc.recordtypeid =  RtId;
                    acc.Account_Effective_Date__c = enrl.Account_Effective_Date__c;
                    acc.sic = enrl.Sic__c;
                    acc.Rating_State__c = enrl.Rating_State__c; 
                    //AO Changes Begin 06/21/2016 
                    acc.EIN__c = enrl.EIN__c;
                    //AO Changes end 06/21/2016
                    // if we are not testing then we assign the account name from enrollment import 2-50  
                    // that is when the senario is not false we assign Account Name and facets account number
                    //
                    if(!ForTestingOnly){
                        acc.Name = enrl.Account_Name__c;                 
                        acc.Facets_Account_Number__c = enrl.Account_Number__c; 
                     // AO Changes 11/03/15 Begin
                     // Map the new Rectype_facets_account_number with the hardcoded '2_50_' appended to Enrollment import record
                        acc.RecType_Facets_Account_Number__c =  '2-50_' + enrl.Account_Number__c; 
                     // AO Changes End     
                    }
                    if ( enrl.Term_Date__c != NULL ) {
                        acc.Status__c = 'TERMED';
                    } else {
                        acc.Status__c = 'Active'; 
                    }                
                    // AO Changes 11/03/15 Begin 
                    //accountMap.put(acc.Facets_Account_Number__c,acc); 
                    accountMap.put(acc.RecType_Facets_Account_Number__c, acc); 
                    // AO Changes End               
                }                 
                // After processing each record we check off the processed field on the enrollment 2-50 import object 
                // so we do not reprocess the record again should we have to run again due to some batch failures  
                enrl.Processed__c = true;
            }             
        }
        // put all map data into a list          
        accListToUpsert = accountMap.values();
         
        // upsert the account data
        if(accListToUpsert != null && accListToUpsert.size() > 0) {
        
        Savepoint sp = Database.setSavepoint(); 
                
        try{
           // AO Changes 11/03/15 Begin 
           // upsert accListToUpsert Facets_Account_Number__c;
           upsert accListToUpsert RecType_Facets_Account_Number__c; 
           // AO Changes End    
            if(EnrollmentImpList != null && EnrollmentImpList.size() > 0){
                update EnrollmentImpList;
            }                              
         }catch(System.Exception e){
             Database.rollback(sp);
             System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_2_50_Account_Process.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
             NonTrappableErrorMsg += '<b>Exception in Enrollment_2_50_Account_Process.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>'; 
             NonTrappableErrorMsg += '<b>Error occured during batch #</b>' + BatchCount + '<br/>';  
             NonTrappableError     = true; 
             totfailure += accListToUpsert.size();                  
             throw new Enrollment_2_50_Account_ProcessException(NonTrappableErrorMsg);      
            }                            
         }
         totupserts = totprocessed - totfailure;
         /***************************************************End Variable Declaration*********************************************/
     }
     
    global void finish(Database.BatchableContext bc) {
        // Query the AsyncApexJob object to retrieve the current job's information.
        try {
            AsyncApexJob a = [ SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                               FROM AsyncApexJob 
                               WHERE Id = :BC.getJobId() and JobType <> 'BatchApexWorker' ];
            //Build email message                             
            EmailBody += '<b>The Batch Apex job</b> ' + a.Status + '.<br/>';               
            EmailBody += '<b>The Batch Apex job processed</b> ' + a.TotalJobItems + ' <b>batches with</b> ' + a.NumberOfErrors + ' <b>failures.</b><br/>';
            EmailBody += '<b>The job was executed by:</b> ' + a.CreatedBy.Email + '.<br/><br/>';
            EmailBody += '<b>Begin Main Process</b><br/>';
            EmailBody += '<b>Total Enrollment 2-50 Account Import Records Processed: </b> ' + totprocessed + '<br/>';                
            EmailBody += '<b>Total Enrollment 2-50 Account Record Upserts: </b> ' + totUpserts + '<br/>';
            EmailBody += '<b>Total Enrollment 2-50 Account Records Failure: </b> ' + totfailure + '<br/>';
                               
            // EmailBody += '<b>Total Enrollment 2-50 Import Records Failures: </b> ' + totFailures + '<br/>';
            //EmailBody += '<b>Total Enrollment 2-50 Import Records Failures Record Ids: </b> ' + failedRecordIds + '<br/>';
            if (NonTrappableError || Test.isRunningTest()) {
                EmailBody += '<br/><b>*** SERIOUS ISSUE OCCURED ***</b><br/>';
                EmailBody += NonTrappableErrorMsg + '<br/><br/>';
                EmailBody += '<b>Check the logs for details.</b><br/>';
            }
                
//BEGIN CHANGE TPB 03/26/2016 
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
// END CHANGE TPB 03/26/2016                                          
                             
        } catch(System.Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_2_50_Account_Process.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                     
        }   
    }    
}