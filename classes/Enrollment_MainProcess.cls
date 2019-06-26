//=========================================================================================
//      Date: 02/17/2013
// Developer: Tom Barrett (TPB)
//   Purpose: This class is the enrollment main processing class.
//         1. The process assumes input records come from the Enrollment_Import__c object
//            It is a catch one error per record process.  In otherwords, it does not continue 
//            processing a record if it is found to have a predefined error.  It collects that 
//            record and stores it in the error recycle Map and continues to the next input record.  
//            At the end of processing, all input records detected to have predefined errors are
//            inserted into the the Enrollment_Recycle__c object. The term error in this context is 
//            not a system error.  These are errors due to some kind of data missing and when the 
//            user resolves the missing data they can recycle.  Refer to the Recycle Process for 
//            details about the recycling of error.  
//         2. For all input records found to not have a predefined error issues they are collected 
//            and stored in a Map.  At the end of the process they are written to the Enrollment__c object.  
//         3. As each input record is processed as described above a third collection collects the 
//            Enrollment_Import__c id and stores it in a Set.  At the end of the process the Set is used
//            to update the Processed__c field to TRUE.
//         4. The Enrollment__c object has a Master/Child relationship with the Opportunity 
//            object where the Opportunity object is the master and the Enrollment__c object is the child.
//
//     Usage: Enrollment_MainProcess emp = new Enrollment_MainProcess();
//            emp.query = 'SELECT id, Rpt_Dt__c, Run_Dt__c, Account_Name__c, Account_Number__c, 
//                                SFDC_Product__c, Contracts__c, System__c, Sales_Rep__c, Risk__c 
//                         FROM Enrollment_Import__c 
//                         WHERE Processed__c = FALSE;
//            emp.EmailUsers = TRUE;    // TRUE = users are emailed, FALSE means users are not emailed    
//                                      // The default is FALSE if you do not set it                 
//            ID batchprocessId = Database.executeBatch(emp);
//
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
// 09/19/2013 Tom Barrett    Making changes to accomodate the consolidation of
//                           the enrollment_history__c object data into the Enrollment__c
//                           object.  This effort impacted the following:
//                           Classes: Enrollment_MainProcess, Enrollment_QueryBase,
//                                    and Enrollment_Recycle_Controllerext. 
//  
// 12/04/2014 Tom Barrett    Added code to include the Rating_State__c and 
//                           New_Business_Indicator__c fields and the 51+ record type logic                                                           
// 04/15/2015 Ashish Ojha    Updated the wording of the email being sent after process completion    
//
// 03/26/2016 Tom Barrett    Made changes to handle a new custom setting field that will allow for 
//                           muliple email addresses to be entered dynamically without changing code                   
//=========================================================================================
global without sharing class Enrollment_MainProcess implements Database.Batchable<sObject>, Database.Stateful {
    public String Query; 
    // Used to identify if user is emailed
    public boolean EmailUsers = FALSE;
    private String EmailBody = '';
    private static final String Subject = 'Apex: Enrollment_MainProcess';  
    // Counters used to track processed/insert/update/misc
    private Integer InsertedEnrollmentCount = 0;
    private Integer EnrollmentImportProcessedCount = 0;
    private Integer InsertedEnrollmentErrorRecycleCount = 0;
    
// BEGIN CHANGE TPB 09/19/2013    
//    private Integer InsertedEnrollmentHistoryCount = 0;
    private Integer UpdatedToEnrollmentHistoryCount = 0;
//    private Integer DeletedEnrollmentCount = 0;  
// END CHANGE TPB 09/19/2013

    private integer ProductMissingCount = 0;
    private integer BatchCount = 0; 
    // Current Record Count In the batch 
    private static integer RecordCountInBatch = 0;  
    // Action Needed Detector
    private Boolean ActionNeeded = FALSE;  
    private Boolean NonTrappableError = FALSE; 
    private String NonTrappableErrorMsg = '';
    private Boolean ArchiveProcessFailed = FALSE;
    // Custom Exception Class
    public class EnrollmentException extends Exception{}
    // Build a list to hold recyclable errors for inserting into the Enrollment_Recycle__c
    // object at the end of the process
    private static List<Enrollment_Recycle__c> erInsertList = new List<Enrollment_Recycle__c>();  
    // Build a list of records that will be inserted into the Enrollment__c object
    private static List<Enrollment__c> enrollmentInsertList = new List<Enrollment__c>();          
    // Build a set of Enrollment_Import__c records that were written to the Enrollment__c
    // object or Enrollment_Recycle__c object.  This will be used to set the 
    private static Set<Id> importRecIdsSet = new Set<Id>();
    // Build a set of opp ids that had enrollment data inserted
    private static Set<Id> oppIdsWithEnrollmentInsertedSet = new Set<Id>();
    // Build map of active products 
    private static Map<String, Id> sfProductsMap = QueryBase.getAllPricebookEntryIds('Standard Price Book');
    // Build map of Enrollment_Error_Message__c error messages
    private static Map<String, Error_Message__c> eemMap = Enrollment_QueryBase.getErrorMessageMap(); 
    // Holds the Rpt_dt__c value.  This helps assist in getting the correct data to 
    // archive to the Enrollment_History__C object
    private static String RptDtYYYYMM = '';
    
    // BEGIN ADD TPB 12/04/2014
    // Build a list of records that will be updated into Account object
    private static Map<id, Account> accountToUpdateMap = new Map<Id, Account>();
    private integer updatedAccountCount = 0;
    // Get the Enrollment 51+ record type id
    Id RtIdEnrX51 = Enrollment_QueryBase.RtIdEnrX51;
    // END ADD TPB 12/04/2014
            
    global Database.querylocator start(Database.BatchableContext BC) {
        // Check to make sure the process is called properly.
        try {
            if ( Query == null || !Query.ContainsIgnoreCase('Enrollment_Import__c') ) 
                    throw new EnrollmentException('The Query property must query the Enrollment_Import__c object only!');                                                         
        } catch ( EnrollmentException e ) {
            String ErrorMsg = 'Apex Class Enrollment_MainProcess.Start Threw an Error: ' +  e.getLineNumber() + ' - ' + e.getMessage();
            System.debug(LoggingLevel.ERROR, ErrorMsg);                                 
            throw new EnrollmentException(ErrorMsg, e);           
        }
        if ( Test.isRunningTest() ) {
            query += ' LIMIT 100';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        RecordCountInBatch = scope.size();         
        BatchCount += 1;
        // Build map of Facets #s found on the Opportunities
        Map<String, Opportunity> facetsOppsMap = Enrollment_QueryBase.FacetsOppsMap;
        // Build map of Luminex #s found on the Opportunities
        Map<String, Opportunity> luminexOppsMap = Enrollment_QueryBase.LuminexOppsMap;
        // Build map of Nasco #s found on the Opportunities
        Map<String, Opportunity> NascoOppsMap = Enrollment_QueryBase.NascoOppsMap; 
        // Build map of Network Leasing Types found on the Opportunities 
        Map<String, Opportunity> nwlOppsMap = Enrollment_QueryBase.NwlOppsMap;
        // Build map of National Alliance #s found on the Opportunities
        Map<String, Opportunity> naOppsMap = Enrollment_QueryBase.NaOppsMap;
        // Build Opportunity System field data
        Enrollment_QueryBase.BuildOppSystemKeyMaps();           
        // Error message record
        Error_Message__c eem; 
        // Holds current Error Number
        String ErrorNumber = 'NONE';    
        // Holds current Error Message
        String ErrorMessage = 'NONE';        
        // Holds Opportunity record in main loop process
        Opportunity OppRecord;   
        // Holds Opportunity Id
        String OppId = ''; 
        
        /// Begin Main Process Loop
         // Loop through the Enrollment_Import__c records and process per business rules    
        for ( sObject enrolled : scope ) {            
            Enrollment_Import__c e = (Enrollment_Import__c)enrolled;  
            RptDtYYYYMM = e.Rpt_Dt__c; 
            OppId = '';            
            /// Begin checking if Facets System is found on input record
            if ( e.System__c == 'Facets' ) {
                /// Begin Check if Facets account number is found on an opportunity
                oppRecord = facetsOppsMap.get(e.Account_Number__c.toUpperCase());
                if ( OppRecord <> NULL ) {
                    OppId = OppRecord.Id;   
                    System.debug('Facets: ' + OppId);  
                } else {                
                    // Error Number 0004 - Facets account number not found
                    eem = eemMap.get('0004');
                    addToErInsertList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                       e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                       eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                       e.Rating_State__c, e.New_Business_Indicator__c );   
                    Continue;                    
                } /// End Check if Facets account number is found on an opportunity
            } /// End checking Facets System if found on input record        
            
            /// Begin checking if Luminex System is found on input record
            if ( e.System__c == 'LuminX' ) {                
                oppRecord = luminexOppsMap.get(e.Account_Number__c.toUpperCase());
                /// Begin Check if Luminex account number is found on an opportunity
                if ( OppRecord <> NULL ) {
                    OppId = OppRecord.Id;   
                    System.debug('Luminex: ' + OppId);  
                } else {                
                    // Error Number 0005 - Luminex account number not found
                    eem = eemMap.get('0005');
                    addToErInsertList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                       e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                       eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                       e.Rating_State__c, e.New_Business_Indicator__c );   
                    Continue;                    
                } /// End Check if Luminex account number is found on an opportunity
            } /// End checking Luminex System if found on input record
            
            /// Begin checking if Nasco System is found on input record
            if ( e.System__c == 'NASCO' ) {                
                oppRecord = nascoOppsMap.get(e.Account_Number__c.toUpperCase());
                /// Begin Check if Nasco account number is found on an opportunity
                if ( OppRecord <> NULL ) {
                    OppId = OppRecord.Id;   
                    System.debug('NASCO: ' + OppId);  
                } else {                
                    // Error Number 0006 - Nasco account number not found
                    eem = eemMap.get('0006');
System.debug('zz: ' + e);                    
                    addToErInsertList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                       e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                       eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                       e.Rating_State__c, e.New_Business_Indicator__c );   
                    Continue;                    
                } /// End Check if Nasco account number is found on an opportunity
            } /// End checking if Nasco System is found on input record    
            
            /// Begin checking if Network Leasing System is found on input record            
            if ( e.System__c == 'Network Lease' ) {
                /// Begin Checking if Network Leasing account number is found on an opportunity
                oppRecord = nwlOppsMap.get(e.Account_Number__c.toUpperCase());
                if ( OppRecord <> NULL ) {
                    OppId = OppRecord.Id;   
                    System.debug('NWL: ' + OppId);  
                } else {                 
                    // Error Number 0007 - Network Leasing account name not found
                    eem = eemMap.get('0007');                     
                    addToErInsertList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                       e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                       eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                       e.Rating_State__c, e.New_Business_Indicator__c );   
                    Continue;                    
                } /// End Checking if Network Leasing account number is found on an opportunity
            } /// End checking Network Leasing System is found on input record            
            
            /// Begin checking if National Alliance System is found on input record            
            if ( e.System__c == 'National Alliance' ) {
                /// Begin Checking if National Alliance account number is found on an opportunity
                oppRecord = naOppsMap.get(e.Account_Number__c.toUpperCase());
                if ( OppRecord <> NULL ) {
                    OppId = OppRecord.Id;   
                    System.debug('National Alliance: ' + OppId);  
                } else {                 
                    // Error Number 0008 - National Alliance account name not found
                    eem = eemMap.get('0008');                     
                    addToErInsertList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                       e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                       eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                       e.Rating_State__c, e.New_Business_Indicator__c );   
                    Continue;                    
                } /// End Checking if National Alliance account number is found on an opportunity
            } /// End checking National Alliance System is found on input record  
                             
            
            // OK!  If we made it this far and could not find a known System on the input data
            // write it to the Enrollment_Recycle__c object a support error type
            if ( OppId == NULL || OppId == '' ) {
                // Error Number 0002 - System not found 
                eem = eemMap.get('0002');
                addToErInsertList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                   e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                   eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                   e.Rating_State__c, e.New_Business_Indicator__c ); 
                System.debug('System Not Found: ' + OppId); 
                Continue;
            }
            
            /// Begin Check if product exists in SF
            If ( sfProductsMap.get(e.SFDC_Product__c.toUpperCase()) == null ) {
                // Error Number 0001 - Product Not Found - write to the Error Recycle List
                eem = eemMap.get('0001');  
                ActionNeeded = TRUE;
                ProductMissingCount += 1;                
                addToErInsertList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                   e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                   eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, OppId,
                                   e.Rating_State__c, e.New_Business_Indicator__c );   
                System.debug('Product Not Found: ' + OppId);
                Continue;                          
            } /// End Check if product exists in SF
            
            
            // Write to a list that will be used to update the new Enrollment Related List        
            addToEnrollmentInsertList( e.id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Number__c, e.Processed_Type__c,   
                                       e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, OppId,
                                       e.New_Business_Indicator__c, RtIdEnrX51 ); 
            
            // BEGIN ADD TPB 12/04/2014
            Account acc = new Account(id = oppRecord.AccountId, Rating_State__c = e.Rating_State__c);
            accountToUpdateMap.put(oppRecord.AccountId, acc);           
            // END ADD TPB 12/04/2014                                       
              
            oppIdsWithEnrollmentInsertedSet.add(OppId); 
            Continue;                                   
        } // End Main Loop Process        
        
        /// Begin DML Updates  
        Savepoint sp = Database.setSavepoint();  
        try {     
            // Set Enrollment_Import__c object's Processed__c field to TRUE
            EnrollmentImportProcessedCount += Enrollment_QueryBase.UpdateEnrollmentImportProcessedField(ImportRecIdsSet);                    
            // Insert Error Recycle Records
            insert erInsertList;            
            // Insert Enrollment Records 
            insert enrollmentInsertList; 
            
            // BEGIN ADD TPB 12/04/2014
            // update account records
            update accountToUpdateMap.values();
            updatedAccountCount += accountToUpdateMap.size();
            // END ADD TPB 12/04/2014
            
// BEGIN CHANGE TPB 09/19/2013  
// Commented out the two lines below that performed the move of Enrollment__c data
// to the enrollment_history__c object.  The new change now simply changes the flag
// indicator (Latest_Enrollment__c from 'Y' to 'N'            
            // Insert Enrollment_History Records that are on the Enrollment__c object
            // from the prior months runs
            // This is the first step to archiving dat from the Enrollment__c object            
//            InsertedEnrollmentHistoryCount  += Enrollment_QueryBase.CopyEnrollmentData(oppIdsWithEnrollmentInsertedSet, RptDtYYYYMM);   
//            DeletedEnrollmentCount += Enrollment_QueryBase.DeleteEnrollmentData(oppIdsWithEnrollmentInsertedSet, RptDtYYYYMM);    
              UpdatedToEnrollmentHistoryCount += Enrollment_QueryBase.SetEnrollmentAsHistoryData(oppIdsWithEnrollmentInsertedSet, RptDtYYYYMM);  
// END CHANGE TPB 09/19/2013                       
        /// End DML Updates  
        } catch(System.Exception e) {
            Database.rollback(sp);
            System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_MainProcess.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
            NonTrappableErrorMsg += '<b>Exception in Enrollment_MainProcess.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>'; 
            NonTrappableErrorMsg += '<b>Error occured during batch #</b>' + BatchCount + '<br/>';                      
            ActionNeeded = TRUE;      
            NonTrappableError = TRUE; 
            throw new EnrollmentException(NonTrappableErrorMsg);   
        }   
        // Assume all went well so we can add the counts
        InsertedEnrollmentErrorRecycleCount += erInsertList.size(); 
        InsertedEnrollmentCount += enrollmentInsertList.size(); 
    }    

    global void finish(Database.BatchableContext BC) {         
        // Query the AsyncApexJob object to retrieve the current job's information.
        try {
            AsyncApexJob a = [ SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                               FROM AsyncApexJob 
                               WHERE Id = :BC.getJobId() and JobType <> 'BatchApexWorker' ];
            // Build email message
            EmailBody += '<b>The Batch Apex job</b> ' + a.Status + '.<br/>';               
            EmailBody += '<b>The Batch Apex job processed</b> ' + a.TotalJobItems + ' <b>batches with</b> ' + a.NumberOfErrors + ' <b>failures.</b><br/>';
            EmailBody += '<b>The job was executed by:</b> ' + a.CreatedBy.Email + '.<br/><br/>';
            EmailBody += '<b>Begin Main Process</b><br/>';
            EmailBody += '<b>Total Enrollment Import Records Processed :</b> ' + EnrollmentImportProcessedCount + '<br/>';
            EmailBody += '<b>Total Enrollment Records Inserted: </b> ' + InsertedEnrollmentCount + '<br/>';
            EmailBody += '<b>Total Enrollment Error Recycle Records Inserted: </b> ' + InsertedEnrollmentErrorRecycleCount + '<br/>';
            EmailBody += '<b>Total Enrollment Import Records Processed Successfully: </b> ' + (InsertedEnrollmentCount + InsertedEnrollmentErrorRecycleCount) + '<br/>';
            EmailBody += '<b>Total Accounts Updated: </b> ' + updatedAccountCount + '<br/><br/>';
            EmailBOdy += '<b>Begin Enrollment Archive Process</b><br/>';
// BEGIN CHANGE TPB 09/19/2013       
//            EmailBody += '<b>Total Enrollment deleted:</b> ' + DeletedEnrollmentCount + '<br/>';
              EmailBody += '<b>Total Enrollment Updated to History:</b> ' + UpdatedToEnrollmentHistoryCount  + '<br/>';
// END CHANGE TPB 09/19/2013           
                       
            // Detect if the count being processed from the Enrollment_Import__c object is different 
            // than what was written to the Enrollment__c and the Enrollment_Recycle__c object
            if ( EnrollmentImportProcessedCount - (InsertedEnrollmentCount + InsertedEnrollmentErrorRecycleCount) <> 0 || Test.isRunningTest() ) {
                ActionNeeded = TRUE;
            }
            // Detect if the archive process counts between the delete on the Enrollment__c object and the 
            // insert on Enrollment_History__c object are different
// BEGIN CHANGE TPB 09/19/2013            
//            if ( (InsertedEnrollmentHistoryCount - DeletedEnrollmentCount <> 0) || Test.isRunningTest() ) {
              if ( (UpdatedToEnrollmentHistoryCount - UpdatedToEnrollmentHistoryCount  <> 0) || Test.isRunningTest() ) {
// END CHANGE TPB 09/19/2013
                ActionNeeded = TRUE;
                ArchiveProcessFailed = TRUE;
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
            if ( ProductMissingCount > 0 || Test.isRunningTest() ) {
                EmailBody += '<b>Total Import records that do not have matching SFDC products:</b> ' + ProductMissingCount + '<br/>'; 
            }    
            if ( ArchiveProcessFailed || Test.isRunningTest() ) {
                EmailBody += '<b>Enrollment Archive Process Issues!  Check counts above.</b><br/>';
            }
            if ( NonTrappableError || Test.isRunningTest() ) {
                EmailBody += '<br/><b>*** SERIOUS ISSUE OCCURED ***</b><br/>';
                EmailBody += NonTrappableErrorMsg + '<br/><br/>';
                EmailBody += '<b>Check the logs for details.</b><br/>';
            }           
            // Email the results
// BEGIN: THIS CODE SHOULD ONLY BE UNCOMMENTED DURING TESTING       
      
//            Utils.EmailUtil testEmail = new Utils.EmailUtil(new List<String>{UserInfo.getUserEmail()}); 
//            testEmail.subject(subject);
//            testEmail.replyTo(UserInfo.getUserEmail());
//            testEmail.htmlBody(emailBody);
//            testEmail.sendEmail();  
                
// END: THIS CODE SHOULD ONLY BE UNCOMMENTED DURING TESTING 
    
    
// BEFORE MOVING TO PRODUCTION COMMENT OUT THE CODE ABOVE AND UNCOMMENT THE LINE BELOW
// BEGING CHANGE TPB 03/26/2016
//            EmailAlerts.emailAdmins(subject, emailBody); 
              DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
              String[] toAddresses = cs.Text_255__c.Split(',');
              Utils.EmailUtil EmailSupport = new Utils.EmailUtil(toAddresses); 
              EmailSupport.subject(subject);
              EmailSupport.replyTo(UserInfo.getUserEmail());
              EmailSupport.htmlBody(emailBody);
              EmailSupport.sendEmail(); 

// END CHANGE TPB 03/26/2016


// BEGIN CHANGE AO 04/15/2015 - changed wording of email body and subject            
       
            emailBody = 'Hello,<br/><br/>';
            emailBody += '<p>The 51+ Monthly Enrollment Import Process has been completed.  Sales Account Managers that own accounts ';
            emailBody += 'are required to login to SFDC and review the \"Enrollment Recycles\" tab to resolve any records you own ';
            emailBody += '<b>within 5 business days</b> after the receipt of the email.  This action is necessary for accurate enrollment ';
            emailBody += 'reporting by your management team to be available by the 15th of the month.  We are here to support you if you ';
            emailBody += 'have questions or any difficulty completing the task in 5 days.</p>';
            //
            emailBody += '<p><b>Note:</b> There might be a few instances each month when a NASCO account has terminated, but small numbers of enrollment ';
            emailBody += '(Residual Enrollment) are still being reported by NASCO. If the Enrollment Recycle report shows Residual Enrollment for ';
            emailBody += 'your NASCO SFDC Opportunity, you may ignore that entry. No further action is necessary by you.</p>';
            //
            emailBody += '<p>Please refer to the SOP in the SRG for additional detail regarding the Enrollment Recycle process.</p>';
            emailBody += '<p>If you have any questions or concerns, please contact sfdcSupport@carefirst.com.</p>';
            //
            emailBody += 'Thank you for your cooperation,<br/>';
            emailBody += 'sfdcSupport@carefirst.com';    
            
            Utils.EmailUtil email = new Utils.EmailUtil();
            if ( EmailUsers && QueryBase.isProductionOrg() ) { 
                email.toAddresses(new List<String>{'sfdcSalesUsers@carefirst.com'});                
            } else if ( EmailUsers && !QueryBase.isProductionOrg() ) {  
                // Running in Sandbox so email team
                email.toAddresses(new List<String>{'sfdcTeam@carefirst.com'});
            } else {
                return;
            }             
            email.subject('Salesforce 51+ Enrollment Process - to be completed within 5 days');
            email.replyTo('sfdcSupport@carefirst.com');
            email.htmlBody(emailBody);
            email.sendEmail();      
                
        } catch(System.Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_MainProcess.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                     
        }   
    }        
        
    /*****************************************************************************************
     * 1. Add Enrollment_Import__c record to a list that did not pass custom edit/validation
     * 2. Add Enrollment_Import__c record id to a set that did not pass custom edit/validation
     ****************************************************************************************/
    private void addToErInsertList ( String RecId, String RptDate, String RunDate, String AccountName, String AccountNumber, 
                                     Decimal Contracts, String SourceSystem, String Product, String Risk, String SalesRep,
                                     String ErrorNumber, String ErrorMessage, String ProcessedType, String OppId, 
                                     String RatingState, String NewBusinessIndicator ) {                                       
       
        ERinsertList.add( new Enrollment_Recycle__c( Rpt_Dt__c = RptDate, 
                                                     Run_Dt__c = RunDate, 
                                                     Account_Name__c = AccountName, 
                                                     Account_Number__c = AccountNumber, 
                                                     Contracts__c = Contracts,
                                                     Processed_Type__c = ProcessedType,
                                                     System__c = SourceSystem, 
                                                     SFDC_Product__c = Product, 
                                                     Risk__c = Risk,
                                                     Sales_Rep__c = SalesRep,                                                     
                                                     Error_Number__c = ErrorNumber, 
                                                     Error_Message__c = ErrorMessage, 
                                                     Opportunity_Name__c = OppId,
                                                     Rating_State__c = RatingState,                                                     
                                                     New_Business_Indicator__c = NewBusinessIndicator ));
        // Collect the Enrollment_Import__c ID                                           
        importRecIdsSet.add(RecId); 
    }   
    
    /******************************************************************************************
     * 1. Add Enrollment_Import__C data to the enrollmentInsertList, it passed edit/validations
     * 2. Add Enrollment_Import__c record id to a set, it passed custom edit/validation
     *****************************************************************************************/
    private void addToEnrollmentInsertList ( String RecId, String RptDate, String RunDate, String AccountNumber, String ProcessedType,
                                             Decimal Contracts, String SourceSystem, String Product, String Risk, String OppId,
                                             String NewBusinessIndicator, Id RtIdEnrX51 ) {                                       

// BEGIN/END CHANGE BELOW 09/19/2013 TPB -- added Latest_Enrollment__c = 'Y'       
        enrollmentInsertList.add( new Enrollment__c( Latest_Enrollment__c = 'Y',
                                                     Rpt_Dt__c = RptDate,
                                                     Run_Dt__c = RunDate, 
                                                     Account_Number__c = AccountNumber, 
                                                     Contracts__c = Contracts,
                                                     Processed_Type__c = ProcessedType,                                                     
                                                     System__c = SourceSystem, 
                                                     Product__c = Product, 
                                                     Risk__c = Risk, 
                                                     Opportunity__c = OppId,                                                     
                                                     New_Business_Indicator__c = NewBusinessIndicator,
                                                     RecordTypeId = RtIdEnrX51 ));
        // Collect the Enrollment_Import__c ID                                           
        importRecIdsSet.add(RecId); 
    }  
}