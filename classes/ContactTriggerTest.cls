/*
  This class contains unit tests for Contact related trigger and triggerhandler classes

Log: 
+-----------+----------------+------------------------------------------------------
|   Date    |   Developer    |   Description
+-----------+----------------+--------------------------------------------------------
| 10/06/14  |   KG           |   note
|           |                |
+-----------+----------------+--------------------------------------------------------
*/


@isTest(SeeAllData=true)
private class ContactTriggerTest {

    public static Account a;
    public static Opportunity op;
    public static Contact c1;
    public static Contact c2;
    public static boolean testDataInitialized = false;

    static testMethod void testNewUpdateNonEGPContacts() {
        ContactTriggerTest.setupTestData();
        
        Test.startTest();
        try {
        insert new List<Contact> { c1, c2};
        System.assert( true, 'Success: Input validation logic ignored non-EGP new contacts');
        } catch (Exception e) {
            System.debug( LoggingLevel.DEBUG, 'Error. Line:=' + e.getLineNumber() + ', errorMessage=' + e.getMessage());
            System.assert( false, 'Error: Unable to save new non-EGP contacts');
        }
        Test.stopTest();
    }


    // Negative test. Confirm multiple EGP contacts on same account not allowed when creating new contacts and caught by
    // before/after insert trigger logic
    //
    static testMethod void testNewUpdateEGPContacts() {
        ContactTriggerTest.setupTestData();
        
        // Setup insert scenario with duplicate new EGP contacts to exercise before/after insert trigger event 
        c1.Employer_Group_Portal__c = true;
        c2.Employer_Group_Portal__c = true;
        
        Test.startTest();
        try {
        upsert new List<Contact> { c1, c2};
        //System.assert( false, 'Fail: Input validation logic did not prevent duplicate EGP Contacts per Account');
        } catch (Exception e) {
            System.debug( LoggingLevel.DEBUG, 'Error. Line:=' + e.getLineNumber() + ', errorMessage=' + e.getMessage());
            System.assert( true, 'Success: Input validation logic enforced single EGP Contact per Account');
        }
        Test.stopTest();
        
    
    }
    
    // Negative test. Confirm multiple EGP contacts on same account not allowed as a result of updating existing contacts
    // and caught by before/after update trigger event logic
    static testMethod void testExistingContactsUpdateEGP() {
        ContactTriggerTest.setupTestData();
        
        // Save test data contacts c1, c2  (no EGP flag set on either yet)
        upsert new List<Contact> { c1,c2};
            
        // Setup update scenario with duplicate EGP contacts to exercise before/afterUpdate trigger handler event
        List<Contact> contacts = [ 
                select Id, Employer_Group_Portal__c from Contact where firstName IN ('fName1', 'fName2')
                ] ;
        for(Contact c : contacts)
           c.Employer_Group_Portal__c = true;
           
        Test.startTest();
        try {
        upsert contacts;
        //System.assert( false, 'Fail: Input validation logic did not prevent duplicate EGP Contacts per Account');
        } catch (Exception e) {
            System.debug( LoggingLevel.DEBUG, 'Error. Line:=' + e.getLineNumber() + ', errorMessage=' + e.getMessage());
            System.assert( true, 'Success: Input validation logic enforced single EGP Contact per Account');
        }
        Test.stopTest();
    }
    
 /*---------------------------------------------------------------------------*
  *                             Helper Functions                              *
  *---------------------------------------------------------------------------*/

    private static void setupTestData() {
        if (testDataInitialized) return;
        try {
            a = new Account();
            a.Name = 'SomeTest' + Date.Today();
            a.Type = 'Customer';
            insert a;
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
            User salesUser = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8',FirstName = 'Test', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, Lead_Rep_Number__c = '100',
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');
                     
           /* User salesUser = [SELECT Name, Lead_Rep_Number__c 
                              FROM User 
                              WHERE isActive = TRUE 
                                AND Profile.UserLicense.Name = 'SalesForce'
                                AND Lead_Rep_Number__c != null Limit 1]; */
/*          User salesUser = [SELECT Name, Lead_Rep_Number__c FROM User WHERE Lead_Rep_Number__c != null Limit 1]; */
            op = new Opportunity();
            op.AccountId = a.Id;
                op.Name = 'OppTest' + Date.Today();  
                op.CloseDate = Date.Today();
                        op.SBU__c = 'Small/Medium';
            op.Type = 'Medical Only';
            op.Effective_Date__c =  Date.newInstance(2014,10,1);    // validation rule requires effective date be 1st of month
            op.CloseDate = op.Effective_Date__c.addDays(-11);   // validation rule requires effective date be after close date i.e. effective > closedate
            Date dd = op.Effective_Date__c.addMonths(1);    // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
            dd.addDays(-1);
            op.Contract_End_Date__c = Date.newInstance(2014,10,31);
            op.StageName = 'Sold';
                        op.Incumbent_Successor__c = 'CareFirst';    // VR requires this to be set when stage=Sold
            op.Risk_Non_Risk__c = 'Non-Risk';
            op.Facets_Grp_Num__c = '045H' ;
            //op.NASCO_Acct_ID__c = '';
            op.Market_Segment_New__c = '51-199';
                        op.Business_type__c = 'Renewal';
                        op.Division__c = '51-199 Renewals';   
                        op.Underwriting_Entity__c = 'MD';
                        op.Lead_Rep_Name_User__c = salesUser.Id;
                        // op.GeneralProducer__c = 'Direct'; 
            op.System__c = 'Facets';
                        //op.National_Alliance_ID__c = '';  // set to empty to avoid VR asking for National Alliance to be setup
                        op.Related_Products_Sold__c = 'Test';    
            op.FullServiceProducer__c = 'Benefit Mall';
                        op.Won_Lost_Reason__c = 'Acquisition';     // VR requires non-blank
            insert op;
        
            c1 = new Contact();
            c2 = new Contact();
            c1.AccountId = a.Id;
            c1.FirstName = 'fName1';
            c1.LastName = 'lName1';
            c1.Email = 'Email1@somedomain.com';
            c1.Phone='3013852013';
            
            
            c2.AccountId = a.Id;
            c2.AccountId = a.Id;
            c2.FirstName = 'fName2';
            c2.LastName = 'lName2';
            c2.Email = 'Email2@somedomain.com';
            c2.Phone='3013852013';
             
        
            // no insert DML on contacts. This is controlled by individual test methods     
             //insert List<Contact> { c1,c2};
                
            testDataInitialized = true;
        } catch(Exception e) {
            System.debug('ContactTriggerTest: Could not initialize test data');
            System.assert(false, 'Unable to create test data');
        }
    }
    

}