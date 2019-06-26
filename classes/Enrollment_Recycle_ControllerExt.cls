//=========================================================================================
//      Date: 05/15/2013
// Developer: Tom Barrett (TPB)
//   Purpose: This class is the enrollment recycle class.
// SPECIAL NOTE:
//            #############################################################################
//            This class has a lot of code that must be kept in sync with the main process
//            class called Enrollment_MainProcess and vise versa.  When changes are made
//            to either of these classes always make sure to keep them in sync where
//            necessary.
//            #############################################################################
//            
//         1. The process input records come from the Enrollment_Recycle__c object.  Each
//            input record is read looking for a matching account number on an opportunity
//            record.  The range of opportunity records that are searched is Stage equal
//            to sold and the Effective Date greater than or equal to the last 12 months
//            and the Effective Date less than or equal to last month.
//         2. If an error is detected and that error is not the same error then the
//            record is updated with the new error number and error message.  This process
//            is stored in map and at the end of the looping process the map is used in
//            a DML Update statement.  If the error is detected and it the same error then
//            the record is not stored in the map which results in no change to the record
//         3. At the end of the loop process all Enrollment_Recycle__c records that are 
//            successfully processed and stored in a map which is used to insert to the 
//            Enrollment__c object then that Enrollment_Recycle__record deleted from the
//            Enrollment_Recycle__c object and insert into the Enrollment_Recycle_Archive__c
//            object.
//         4. Finally, during the process a map of opportunity IDs that are collect during
//            the time of collecting enrollment_recycle records that will be inserted into
//            the Enrollment__c object will be used to gather all non-current
//            Enrollment__c records which will be archived to the Enrollment_History__c
//            object.  The archive process deletes them from the Enrollment__c object
//            then inserts those records into the Enrollment_History__c object.
//
//     Usage: Called from the Enrollment_Recycle VF page
//
//=========================================================================================
//                                 Update History
// Date       Developer   Tag     Description
//=========================================================================================
// 09/19/2013 Tom Barrett   	 Making changes to accommodate the consolidation of
//                           	 the enrollment_history__c object data into the Enrollment__c
//                           	 object.  This effort impacted the following:
//                           	 Classes: Enrollment_MainProcess, Enrollment_QueryBase,
//                                    and Enrollment_Recycle_Controllerext.       
//
// 12/04/2014 Tom Barrett    	 Added code to include the Rating_State__c and 
//                           	 New_Business_Indicator__c fields and the 51+ record type logic
// 17/08/2018 Gayathri     T01   Added a method to diffentiate Classic and lightning view                      
//                              
//=========================================================================================

public class Enrollment_Recycle_ControllerExt {   
    // Custom Exceptions
    class Enrollment_Recycle_ControllerExt_DataOutofSyncException Extends Exception {}
    // Used to control which section of the VF page is rendered
    public boolean pageBlockSection1 { set; get; }
    public boolean pageBlockSection2 { set; get; }    
    public boolean pageBlockSection3 { set; get; }
        
    public List<Enrollment__c> enrollmentList { set; get; } 
    // VF page uses to display errors that were not recycled
    public List<Enrollment_Recycle__c> NotRecycledList { set; get; }  
    public boolean submitButton { set; get; }
    // Holds the records the user selected from the Enrollment Recycle Tab
    private final List<Enrollment_Recycle__c> selectedERlist;
    // Messages used in the process
    private final String UserName = UserInfo.getFirstName();
    private final String CompleteSuccess = 'Great job ' + userName + '! All selected Enrollment Recycle errors processed successfully!';
    private final String PartialSuccess = userName + ', some records selected did not process succussfully! ' +
                                          'Please correct and reprocess the unresolved Enrollment Recycle Errors below.';   
    private final String NoneProcessed = userName + ', none of the selected Enrollment Recycle errors processed!  ' + 
                                         'Click the Enrollment Recycle tab again to review the errors, resolve and try again.';   
    private final String NoneSelected = userName + ', you did not select any records! Please click the Enrollment Recycles tab again then select records that you want to recycle.';                                        
    private String introMsg = ' errors selected that are ready to be recycled.  Please review to make sure you have selected the correct records before clicking the Submit button.'; 
    private boolean EnrollmentInserted = false;
    private boolean RecycleErrors = false;
    
    // enum used to manage the type of errors and messages that should display
    private enum ProcessStatus {CompleteSuccess, PartialSuccess, NoneProcessed, NoneSelected}
    // instantiate ProcessStatus as ps 
    private ProcessStatus ps; 
    
    // Build a list to hold recyclable errors for inserting into the Enrollment_Recycle__c
    // object at the end of the process
    private List<Enrollment_Recycle__c> erUpdateList = new List<Enrollment_Recycle__c>();     
    // Build a list of records that will be inserted into the Enrollment__c object
    private List<Enrollment__c> enrollmentInsertList = new List<Enrollment__c>(); 
    // Build a list of records that were not recycling
    private List<Enrollment_Recycle__c> enrollmentNotRecycledList = new List<Enrollment_Recycle__c>();   
    // Build a set of Enrollment_Recycle__c records that were written to the Enrollment__c
    // object.  This will be used to archive the Enrollments_Recycle records 
    private Set<Id> EnrollmentRecycleRecIdsSet = new Set<Id>();
    // Build a set of opp ids that had enrollment data inserted
    private Set<Id> oppIdsWithEnrollmentInsertedSet = new Set<Id>();
    // Build a set of ids for what the user has selected to be processed
    private Set<Id> SelectedERids = new Set<Id>();
    // Counters used to track processed/insert/update/misc  
    private integer RecycledCount = 0;
    private integer NotRecycledCount = 0; 
    
    // BEGIN ADD TPB 12/04/2014
    private Map<id, Account> accountToUpdateMap = new Map<Id, Account>();    
    // Get the Enrollment 51+ record type id
    Id RtIdEnrX51 = Enrollment_QueryBase.RtIdEnrX51;
    // END ADD TPB 12/04/2014     
	
    //T01--Start--Method to check whether the page is in Classic or lightning
    public Boolean getIsClassic() {
    return (AIA_Utils.isClassic());
    }
    //T01--End
    
    // Controller Constructor
    public Enrollment_Recycle_ControllerExt(ApexPages.StandardSetController controller) {   
        // get rendered defaults for the VF page
        pageBlockSection1 = true; 
        pageBlockSection2 = false;          
        pageBlockSection3 = false;     
        submitButton = true;
                  
        this.selectedERlist = controller.getSelected();        
        if ( RecordsSelected()) {     
            introMsg = userName + ', you have ' + selectedERList.size() + introMsg;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, introMsg));
        }
    }        
    
    public PageReference ProcessSelection() {  
        // No records selected by the user so return
        if ( !RecordsSelected() ) return null; 
        // Hide the submit button  and page blocks so the user is forced to click 
        // the Enrollment Recycle tab to reevaluate the Enrollment Recycle Errors
        pageBlockSection2 = false;
        pageBlockSection3 = false;
        submitButton = false;
                 
        // Build map of active products 
        Map<String, Id> sfProductsMap = QueryBase.getAllPricebookEntryIds('Standard Price Book');
        // Build map of Enrollment_Error_Message__c error messages
        Map<String, Error_Message__c> eemMap = Enrollment_QueryBase.getErrorMessageMap(); 
        // Build Opportunity System fields (Nasco, Facets, etc) Maps data
        Enrollment_QueryBase.BuildOppSystemKeyMaps();        
        // Get map of Facets #s found on the Opportunities
        Map<String, Opportunity> facetsOppsMap = Enrollment_QueryBase.FacetsOppsMap; 
        // Get map of Luminex #s found on the Opportunities
        Map<String, Opportunity> luminexOppsMap = Enrollment_QueryBase.LuminexOppsMap;
        // Get map of Nasco #s found on the Opportunities
        Map<String, Opportunity> NascoOppsMap = Enrollment_QueryBase.NascoOppsMap; 
        // Get map of Network Leasing Types found on the Opportunities 
        Map<String, Opportunity> nwlOppsMap = Enrollment_QueryBase.NwlOppsMap;   
        // Get map of National Alliance #s found on Opportunities
        Map<String, Opportunity> naOppsMap = Enrollment_QueryBase.NaOppsMap;   

        // Error message record
        Error_Message__c eem; 
        // Holds Opportunity record in main loop process
        Opportunity OppRecord;   
        // Holds Opportunity Id
        String OppId = '';   
                
        // Holds the Rpt_dt__c value.  This helps assist in getting the correct data to 
        // archive to the Enrollment_History__C object
        String RptDtYYYYMM = '';   
             
        for ( Enrollment_Recycle__c e : selectedERlist ) {            
            SelectedERids.add(e.Id);
            RptDtYYYYMM = e.Rpt_Dt__c; 
            OppId = '';            
            /// Begin checking if Facets System is found on input record
            if ( e.System__c == 'Facets' ) {
                /// Begin Check if Facets account number is found on an opportunity
                oppRecord = facetsOppsMap.get(e.Account_Number__c.toUpperCase());
                if ( OppRecord <> NULL ) {
                    OppId = OppRecord.Id;   
                    System.debug('zz Facets: ' + OppId);  
                } else {                
                    // Error Number 0004 - Facets account number not found
                    eem = eemMap.get('0004');
                    // If not the same error on the Error_Recycle__c then add to update list
                    if ( e.Error_Number__c <> '0004' ) {
                        addToErUpdateList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                           e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                           eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                           e.Rating_State__c, e.New_Business_Indicator__c ); 
                    }
                    addToErList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                 e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                 eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                 e.Rating_State__c, e.New_Business_Indicator__c ); 
                    NotRecycledCount += 1;                    
                    Continue;                    
                } /// End Check if Facets account number is found on an opportunity
            } /// End checking Facets System if found on input record        
            
            /// Begin checking if Luminex System is found on input record
            if ( e.System__c == 'LuminX' ) {                
                oppRecord = luminexOppsMap.get(e.Account_Number__c.toUpperCase());
                /// Begin Check if Luminex account number is found on an opportunity
                if ( OppRecord <> NULL ) {
                    OppId = OppRecord.Id;   
                    System.debug('zz Luminex: ' + OppId);  
                } else {                
                    // Error Number 0005 - Luminex account number not found
                    eem = eemMap.get('0005');
                    // If not the same error on the Error_Recycle__c then add to update list
                    if ( e.Error_Number__c <> '0005' ) {                    
                        addToErUpdateList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                           e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                           eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                           e.Rating_State__c, e.New_Business_Indicator__c );  
                    } 
                    addToErList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                 e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                 eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                 e.Rating_State__c, e.New_Business_Indicator__c );                               
                    NotRecycledCount += 1;
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
                    // If not the same error on the Error_Recycle__c then add to update list
                    if ( e.Error_Number__c <> '0006' ) {                    
                        addToErUpdateList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                           e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                           eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                           e.Rating_State__c, e.New_Business_Indicator__c );
                    }                     
                    addToErList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                 e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                 eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                 e.Rating_State__c, e.New_Business_Indicator__c );                               
                    NotRecycledCount += 1;
                    Continue;                    
                } /// End Check if Nasco account number is found on an opportunity
            } /// End checking if Nasco System is found on input record    
            
            /// Begin checking if Network Leasing System is found on input record            
            if ( e.System__c == 'Network Lease' ) {
                /// Begin Checking if Network Leasing account number is found on an opportunity
                system.debug('Inside Network Lease Loop 250'+nwlOppsMap);
                oppRecord = nwlOppsMap.get(e.Account_Number__c.toUpperCase());
                if ( OppRecord <> NULL ) {
                    OppId = OppRecord.Id;   
                    System.debug('zz NWL: ' + OppId);  
                } else {                 
                    // Error Number 0007 - Network Leasing account name not found
                    eem = eemMap.get('0007');  
                    // If not the same error on the Error_Recycle__c then add to update list
                    if ( e.Error_Number__c <> '0007' ) {                                       
                        addToErUpdateList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                           e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                           eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                           e.Rating_State__c, e.New_Business_Indicator__c ); 
                    }  
                    addToErList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                 e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                 eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                e.Rating_State__c, e.New_Business_Indicator__c );                               
                    NotRecycledCount += 1;
                    Continue;                    
                } /// End Checking if Network Leasing account number is found on an opportunity
            } /// End checking Network Leasing System is found on input record             
            
            /// Begin checking if National Alliance System is found on input record            
            if ( e.System__c == 'National Alliance' ) {
                /// Begin Checking if National Alliance account number is found on an opportunity
                oppRecord = naOppsMap.get(e.Account_Number__c.toUpperCase());
                if ( OppRecord <> NULL ) {
                    OppId = OppRecord.Id;   
                    System.debug('zz National Alliance: ' + OppId);  
                } else {                 
                    // Error Number 0008 - National Alliance account name not found
                    eem = eemMap.get('0008');  
                    // If not the same error on the Error_Recycle__c then add to update list
                    if ( e.Error_Number__c <> '0008' ) {                                       
                        addToErUpdateList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                           e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                           eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                           e.Rating_State__c, e.New_Business_Indicator__c ); 
                    }  
                    addToErList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                 e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                 eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                 e.Rating_State__c, e.New_Business_Indicator__c );                               
                    NotRecycledCount += 1;
                    Continue;                    
                } /// End Checking if National Alliance account number is found on an opportunity
            } /// End checking National Alliance System is found on input record                             

            
            // OK!  If we made it this far and could not find a known System on the input data
            // write it to the Enrollment_Recycle__c object a support error type
            if ( OppId == NULL || OppId == '' ) {
                // Error Number 0002 - System not found 
                eem = eemMap.get('0002');
                // If not the same error then add to update list
                if ( e.Error_Number__c <> '0002' ) {                
                    addToErUpdateList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                       e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                       eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                                       e.Rating_State__c, e.New_Business_Indicator__c ); 
                } 
                addToErList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                             e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                             eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                             e.Rating_State__c, e.New_Business_Indicator__c  );                           
                NotRecycledCount += 1;
                Continue;
            }
            

            /// Begin Check if product exists in SF
            If ( sfProductsMap.get(e.SFDC_Product__c.toUpperCase()) == null ) {
                // Error Number 0001 - Product Not Found - write to the Error Recycle List
                eem = eemMap.get('0001'); 
                // If not the same error then add to update list
                if ( e.Error_Number__c <> '0001' ) {              
                    addToErUpdateList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                                       e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                                       eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, OppId,
                                       e.Rating_State__c, e.New_Business_Indicator__c ); 
                }
                addToErList( e.Id, e.Rpt_Dt__c, e.Run_Dt__c, e.Account_Name__c, e.Account_Number__c, 
                             e.Contracts__c, e.System__c, e.SFDC_Product__c, e.Risk__c, e.Sales_Rep__c, 
                             eem.Error_Number__c, eem.Error_Message__c, e.Processed_Type__c, NULL,
                             e.Rating_State__c, e.New_Business_Indicator__c );                             
                NotRecycledCount += 1;
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
            RecycledCount += 1;
            Continue;         
        } 
        /// Begin DML Operations        
        Savepoint sp = Database.setSavepoint();
        try {   
            CheckCountAgainstEnrollmentRecycle();         
            // Insert Enrollment Records             
            insert enrollmentInsertList; 

            // BEGIN ADD TPB 12/04/2014
            // update account records
            update accountToUpdateMap.values();
            // END ADD TPB 12/04/2014
            
            // Update Enrollment_Recycle Records
            update erUpdateList; 
// BEGIN CHANGE TPB 09/19/2013 
// Commented out the two lines below that performed the move of Enrollment__c data
// to the enrollment_history__c object.  The new change now simply changes the flag
// indicator (Latest_Enrollment__c from 'Y' to 'N'
            // START PROCESS TO MOVE PRIOR MONTH ENROLLMENT TO ENROLLMENT HISTORY
            // Insert Enrollment_History Records that are on the Enrollment__c object
            // from the prior months runs then delete the matching Enrollment__c object records
            // The two step process completes the archive process
//            Enrollment_QueryBase.CopyEnrollmentData(oppIdsWithEnrollmentInsertedSet, RptDtYYYYMM);   
//            Enrollment_QueryBase.DeleteEnrollmentData(oppIdsWithEnrollmentInsertedSet, RptDtYYYYMM);
            Enrollment_QueryBase.SetEnrollmentAsHistoryData(oppIdsWithEnrollmentInsertedSet, RptDtYYYYMM);
// END CHANGE TPB 09/19/2013             
            // START ARCHIVE PROCESS OF ENROLLMENT_RECYCLE__C RECORDS
            Enrollment_QueryBase.CopyEnrollmentRecycleData(EnrollmentRecycleRecIdsSet, TRUE);
            Enrollment_QueryBase.DeleteEnrollmentRecycleData(EnrollmentRecycleRecIdsSet);           
             
            // MADE IT THIS FAR SO WE ASSUME DML'S ABOVE EXECUTED SUCCESSFULLY
            // Set the enrollmentList so the VF page can use it in the pageBlockTable           
            enrollmentList = enrollmentInsertList;            
            NotRecycledList = enrollmentNotRecycledList;
                        
            // Make the pageBlockSection3 visible if enrollment recycle errors processed (recycled)
            if ( EnrollmentInserted ) {
                pageBlockSection3 = true;
            }            
            // IF we recycled all selected enrollment recycle records then display Complete Success
            if ( EnrollmentInserted && !RecycleErrors ) {                
                ps = ProcessStatus.CompleteSuccess;            
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, CompleteSuccess));
            } else if ( EnrollmentInserted && RecycleErrors ) {
                pageBlockSection2 = true;
                ps = ProcessStatus.PartialSuccess;            
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, PartialSuccess));            
            } else {                
                ps = ProcessStatus.NoneProcessed;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, NoneProcessed)); 
            }                
        } catch (System.DMLexception e) {
            Database.rollback(sp);
            pageBlockSection1 = false;
            pageBlockSection2 = false;             
            pageBlockSection3 = false;                    
            String FatalError = 'Exception in Enrollment_Recycle_ControllerExt: DML Error at line ' + e.getLineNumber() + ' - ' + e.getMessage() + 
                                ' -- Please contact sfdcSupport@carefirst.com with a screen shot.';
            ApexPages.AddMessage( new ApexPages.message(ApexPages.severity.FATAL, FatalError));  
            System.debug(LoggingLevel.ERROR, FatalError);                   
        } catch (Enrollment_Recycle_ControllerExt_DataOutofSyncException e ) {
            String FatalError = 'Records were previously processed!  Go back to the Enrollment Recycle tab and try again.'; 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, FatalError)); 

               
        } catch (System.Exception e) {
            Database.rollback(sp); 
            pageBlockSection1 = false;
            pageBlockSection2 = false; 
            pageBlockSection3 = false;            
            String FatalError = 'Exception in Enrollment_Recycle_ControllerExt: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage() + 
                                ' -- Please contact sfdcSupport@carefirst.com with a screen shot.';         
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, FatalError));  
            System.debug(LoggingLevel.ERROR, FatalError);        
        }
        /// End DML Operations            
        return null; 
    } 
    
    // check if records are not selected and return false; otherwise, true
    private boolean RecordsSelected() {
        if ( selectedERlist == NULL || selectedERlist.isEmpty() ) {            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, NoneSelected));
            pageBlockSection1 = false;
            submitButton = false;
            return false;
        }
        return true;
    }  
    
    /*****************************************************************************************
     * Add Enrollment_Recycle__c record to the erUpdatelist
     ****************************************************************************************/
    private void addToErUpdateList ( String RecId, String RptDate, String RunDate, String AccountName, String AccountNumber, 
                                     Decimal Contracts, String SourceSystem, String Product, String Risk, String SalesRep,
                                     String ErrorNumber, String ErrorMessage, String ProcessedType, String OppId,
                                     String RatingState, String NewBusinessIndicator ) { 
       
        erUpdateList.add( new Enrollment_Recycle__c( id = RecId,
                                                     Rpt_Dt__c = RptDate, 
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
        RecycleErrors = true;
    }   
    
    /******************************************************************************************
     * 1. Add Enrollment_Recycle__c data to the enrollmentInsertList, it passed edit/validations
     * 2. Add Enrollment_Recycle__c record id to a set, it passed custom edit/validation
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
        // Collect the Enrollment_Recycle__c ID                                           
        EnrollmentRecycleRecIdsSet.add(RecId);                
        // we set this true assuming the actual DML insert will work
        // if it doesn't this variable is not evaluted so it doesn't matter 
        EnrollmentInserted = true;        
    } 
    
    /*****************************************************************************************
     * Add Enrollment_Recycle__c record to a list that did not pass custom edit/validation
     * This list is used to build the VF pageBlockSection2
     ****************************************************************************************/
    private void addToErList ( String RecId, String RptDate, String RunDate, String AccountName, String AccountNumber, 
                               Decimal Contracts, String SourceSystem, String Product, String Risk, String SalesRep,
                               String ErrorNumber, String ErrorMessage, String ProcessedType, String OppId,
                               STring RatingState, String NewBusinessIndicator ) { 
  
        enrollmentNotRecycledList.add( new Enrollment_Recycle__c( id = RecId,
                                                              Rpt_Dt__c = RptDate, 
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
        RecycleErrors = true;
    } 
    
    /****************************************************************************************
     * Get the current count on the Enrollment_Recycle__c object based on the selected     
     * records the user is trying to process.  Then compare this count to the actual selected
     * records the user is trying to process.  Throw an error if it is not the same     
     ***************************************************************************************/
     private void CheckCountAgainstEnrollmentRecycle () {
         Integer ERcount = 0;                  
         ERcount = [ SELECT Count() FROM Enrollment_Recycle__c
                         WHERE id = :SelectedERids ];
         if ( ERcount <> SelectedERids.size() ) {
             throw new Enrollment_Recycle_ControllerExt_DataOutofSyncException('Records were previously processed!  Go back to the Enrollment Recycle tab and try again.');
         }         
     }    
}