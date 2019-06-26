/*########################################################################################################################
Class        :   Enrollment_2_50_Account_Mgrn_Process
Author       :   Ashish Ojha
Created Date :  06/28/2016
Description  :  This class is used update 2-50 Account Data from Enrollment_Import_2_50__c object based 
                Facets_Account_Number__c as the Key. The batch will run through all the records in 
                Enrollment_Import_2_50__c object  data that have reason code 'GRHX' and Processed__c = False
                and only update the matching Account Status To "Migrated".                               
Instantiate  :   Enrollment_2_50_Account_Mgrn_Process ep = new Enrollment_2_50_Account_Mgrn_Process();  
          OR :   Enrollment_2_50_Account_Mgrn_Process ep = new Enrollment_2_50_Account_Mgrn_Process(TRUE);  
Execution    :   Enrollment_2_50_Account_Mgrn_Process bc = new Enrollment_2_50_Account_Mgrn_Process(FALSE);
                 database.executeBatch(bc);
*/
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
//
//====================================================================================================
global class Enrollment_2_50_Account_Mgrn_Process implements Database.Batchable<SObject>,database.stateful{
    Integer totfailure = 0;
    Integer totUpdates = 0;
    Integer totprocessed = 0;
    // This variable is used to when we are passing the query from the developer console
    private Boolean ForTestingOnly = False;
    private String entType = null;
    private String EmailBody = '';
    private integer BatchCount = 0; 
    private static final String Subject = 'Apex: Enrollment_2_50_Account_Mgrn_Process'; 
    private String NonTrappableErrorMsg = '';
    private Boolean NonTrappableError = FALSE; 
    private String failedRecordIds = '';
    public class Enrollment_2_50_Account_Mgrn_ProcessException extends Exception{}
    //Constructor for the batch : to pass the query from developer console.
    // Also for testing purpose only, we are passing a boolean value to be false
    public Enrollment_2_50_Account_Mgrn_Process(boolean ForTestingOnly) {
        this.ForTestingOnly = ForTestingOnly;        
    }
    global database.querylocator start(Database.BatchableContext bc) {     
       String Query = 'Select id,Account_Number__c ' +
                       'FROM Enrollment_Import_2_50__c ' + 
                       'WHERE Processed__c = false and Term_Reason__c = \'GRHX\'';                        
   
        return Database.getQueryLocator(query);   
    }
    
    global void execute(Database.BatchableContext bc, Enrollment_Import_2_50__c[] EnrollmentImpList) { 
        BatchCount += 1;
        System.debug(Enrollmentimplist.size());
        string RtId = querybase.getRecordtypeId('Account', 'X2_50');
        List<Account>   accListToUpdate = new List<Account>();
        Map<String, Account> accountMap = new Map<String, Account>();
        Set<string>AccNumSet = New Set<string>();
            
        /******************* Iterating on all the Enrollment 2-50 Import Records ***********************************/   
         
        //List of Enrollment 2-50 import object which we are getting from Start method 
        if(EnrollmentImpList != null && EnrollmentImpList.size() > 0){         
            for(Enrollment_Import_2_50__c enrl: EnrollmentImpList){
            // add all Account Numbers into a set 
                AccNumSet.add(enrl.Account_number__c);
                
                totprocessed += 1;
                enrl.Processed__c = true;
                }
                if( AccNumSet.Size()>0 ){   
            //Create a map of id and account where we select only 2-50 Account that 
            //have Facets Account Number that match the Account number in the set we created above                  
                    AccountMap = new map<String, Account>([select id, Status__c from Account where Facets_Account_Number__c in: AccNumSet and recordtypeid =: Rtid ]);
            //Iterate though the values in the map and update only the Status field and add it to a list
                    for(Account acc : AccountMap.values()){                       
                        acc.Status__c = 'Migrated';
                        accListToUpdate.add(acc);
                           
                    }               
                }
            } 
          
        
        if(accListToUpdate != null && accListToUpdate.size() > 0) {
        
        Savepoint sp = Database.setSavepoint(); 
                
        try{           
           
           update accListToUpdate; 
           //totupdates += accListToUpdate.size(); 
           System.debug('acc update list size at update1:  ' +accListToUpdate.size());
           System.debug('acc update list size at update1:  ' + totupdates);
            if(EnrollmentImpList != null && EnrollmentImpList.size() > 0){
                update EnrollmentImpList;
            }                              
         }catch(System.Exception e){
             Database.rollback(sp);
             System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_2_50_Account_Mgrn_Process.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
             NonTrappableErrorMsg += '<b>Exception in Enrollment_2_50_Account_Mgrn_Process.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>'; 
             NonTrappableErrorMsg += '<b>Error occured during batch #</b>' + BatchCount + '<br/>';  
             NonTrappableError     = true; 
             totfailure += accListToUpdate.size();                  
             throw new Enrollment_2_50_Account_Mgrn_ProcessException(NonTrappableErrorMsg);      
            }                            
         }
         
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
          //EmailBody += '<b>Total Enrollment 2-50 Account Record updates: </b> ' + totUpdates + '<br/>';
            EmailBody += '<b>Total Enrollment 2-50 Account Records Failure: </b> ' + totfailure + '<br/>';
                               
            // EmailBody += '<b>Total Enrollment 2-50 Import Records Failures: </b> ' + totFailures + '<br/>';
            //EmailBody += '<b>Total Enrollment 2-50 Import Records Failures Record Ids: </b> ' + failedRecordIds + '<br/>';
            if (NonTrappableError || Test.isRunningTest()) {
                EmailBody += '<br/><b>*** SERIOUS ISSUE OCCURED ***</b><br/>';
                EmailBody += NonTrappableErrorMsg + '<br/><br/>';
                EmailBody += '<b>Check the logs for details.</b><br/>';
            }
                

           DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
           string[] toAddresses = cs.Text_255__c.Split(',');
           Utils.EmailUtil Email = new Utils.EmailUtil(toAddresses); 
           Email.subject(subject);
           Email.replyTo(UserInfo.getUserEmail());
           Email.htmlBody(emailBody);
           Email.sendEmail();                                       
                                        
                             
        } catch(System.Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_2_50_Account_Mgrn_Process.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                     
        }   
    }    
}