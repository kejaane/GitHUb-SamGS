/*------------------------------------------------------------------------------------
 *                      ----===[ HISTORY ]===---
 * Date        Developer        Description
 *------------------------------------------------------------------------------------
 * 12/04/2012 Varun Nagarajan   Modified code where Business__c and Market_Segment__c 
 *                              fields have been replaced with Business_Type__c and 
 *                              Market_Segment_New__c matching today's world requirements 
 *                              at CareFirst. Underwriting field and a newly created 
 *                              field: Division__c has been included in the test code.                       
 ************************************************************************************
 */
 
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class SubmitToBrokerExpressTest {
    
    @testSetup 
    static  void testData(){
         String pId = [ SELECT Id FROM Profile WHERE Name = '51+ Standard User - Custom' ].id;
        User usr = new User(alias = 'aliasU', email='alias@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = pId, 
            timezonesidkey='Europe/London', username='aliastest@test.com',Lead_Rep__c =true,Lead_Rep_Number__c='123'
            );
        insert usr;
    }

    /**
     * Simulates an opportunity successfully submitted to BE
     */
    static testMethod void successfulSubmitToBrokerExpresstTest() {
        
        Test.startTest();
        
        User salesUser = 
           [SELECT Name, Lead_Rep_Number__c 
            FROM User WHERE isActive = true and Profile.UserLicense.Name = 'Salesforce' and 
                            profile.name = '51+ Standard User - Custom' and Lead_Rep_Number__c != null Limit 1];
    System.runAs(salesUser) {    
        Account acct = new Account();
        acct.Name = 'TestAccount';
        acct.NumberOfEmployees = 52;
        acct.Sic = '0111';
        acct.EIN__c = '12-3456789';
        acct.BillingStreet = '1660 International Dr.';
        acct.BillingCity = 'McLean';
        acct.BillingState = 'VA'; 
        acct.BillingPostalCode = '22102';
        insert acct;
 
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall';
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
//        opp.Market_Segment__c = '51-199';
        opp.Market_Segment_New__c = '51-199';
//        opp.Business__c = 'New Business';
        opp.Business_Type__c = 'New';
        opp.Underwriting_Entity__c = 'DC';
        opp.Lead_Rep_Name_User__c = salesUser.Id;
        opp.Division__c = '51-199 New Business'; 
                   // KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);   // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11); // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);            
        insert opp;  
       // System.debug('zzz: ' + opp.id);
        //System.assertEquals(opp, null);  
        
        
         // System.runAs(salesUser) {
            SubmitToBrokerExpress submit = loadSubmitToBEPage(opp);

            // Verify that page doesn't have any error messages
            System.assertEquals(ApexPages.getMessages().isEmpty(), true);

            // Verify that the opportunity has no BE prospect ID 
            System.assertEquals(opp.BE_Prospect_ID__c, null);

            // Submit to broker express
            PageReference redirectPage = submit.submitToBrokerExpress();
            PageReference expectedPage = new PageReference('/' + opp.Id);

            // Verify that after submitting to BE the opportunity now has a BE prospect ID
            opp = [SELECT BE_Prospect_ID__c FROM Opportunity WHERE Id = :opp.Id];
            //System.assert(opp.BE_Prospect_ID__c != null); //080218
            
            //System.assertEquals(redirectPage.getURL(), expectedPage.getURL());//080218
        }
        Test.stopTest();
    }

    /**
     * Simulates one validation error scenario of an opportunity submitted to broker express
     */ 
    static testMethod void failedValidationSubmitToBrokerExpressTest() {
        Test.startTest();
        User salesUser = 
           [SELECT Name, Lead_Rep_Number__c
            FROM User WHERE Lead_Rep_Number__c != null and isActive = TRUE Limit 1];

        // Create an opportunity and account purposely omitting fields required
        // to send over to broker express to test the error scenarios at first  
        Account acct = new Account();
        acct.Name = '1234567891011121314151617181920212223242526';
        acct.NumberOfEmployees = 40;
        insert acct;
 
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall';
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
//        opp.Business__c = 'New Business'; 
        opp.Business_Type__c = 'New';
        opp.Division__c = '51-199 New Business';
        opp.Underwriting_Entity__c = 'DC';
                // KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);   // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11); // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
                // KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);   // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11); // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        opp.Won_Lost_Reason__c = 'Acquisition';     // VR requires non-blank
        opp.Incumbent_Successor__c = 'CareFirst';   // VR requires this to be set when stage=Sold
        
        insert opp;
        
        System.runAs(salesUser) {
            SubmitToBrokerExpress submit = loadSubmitToBEPage(opp);

            // Verify that page doesn't have any error messages
            System.assertEquals(ApexPages.getMessages().isEmpty(), true);

            // Verify that the opportunity has no BE prospect ID 
            System.assertEquals(opp.BE_Prospect_ID__c, null);

            // Submit to broker express
            PageReference redirectPage = submit.submitToBrokerExpress();
            PageReference expectedPage = null;

            // Since the opportunity is missing required fields, the page reference
            // is returned to null and contains error messages to display to the 
            // user, verify this
            System.assertEquals(redirectPage, expectedPage);
            System.assertEquals(ApexPages.getMessages().isEmpty(), false);
        }
        Test.stopTest();
    }

    /**
     * Simulates the error scenario of submitting a closed opportunity to broker express
     */ 
    static testMethod void closedOpportunitySubmitToBrokerExpressTest() {
        Test.startTest();
        User salesUser = 
           [SELECT Name, Lead_Rep_Number__c 
            FROM User WHERE Lead_Rep_Number__c != null and isActive = TRUE Limit 1];

        // Create an opportunity and account purposely omitting fields required
        // to send over to broker express to test the error scenarios at first  
        Account acct = new Account();
        acct.Name = '1234567891011121314151617181920212223242526';
        acct.NumberOfEmployees = 40;
        insert acct;
 
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall';
        opp.StageName = 'Sold';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
//        opp.Business__c = 'New Business';
        opp.Business_Type__c = 'New';
        opp.Division__c = '51-199 New Business';
        opp.Underwriting_Entity__c = 'DC';
                        // KG - 12/10/2014 - Add these 6 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);   // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11); // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        opp.Won_Lost_Reason__c = 'Acquisition';     // VR requires non-blank
        opp.Incumbent_Successor__c = 'CareFirst';   // VR requires this to be set when stage=Sold
        
        insert opp;
        
        System.runAs(salesUser) {
            SubmitToBrokerExpress submit = loadSubmitToBEPage(opp);

            // Verify that page doesn't have any error messages
            System.assertEquals(ApexPages.getMessages().isEmpty(), true);

            // Verify that the opportunity has no BE prospect ID 
            System.assertEquals(opp.BE_Prospect_ID__c, null);

            // Submit to broker express
            PageReference redirectPage = submit.submitToBrokerExpress();
            PageReference expectedPage = null;

            // Since the opportunity is missing required fields, the page reference
            // is returned to null and contains error messages to display to the 
            // user, verify this
            System.assertEquals(redirectPage, expectedPage);
            System.assertEquals(ApexPages.getMessages().isEmpty(), false);
        }
        Test.stopTest();
    }

    /**
     * Simulates a duplicate opportunity submitted to broker express
     */
    static testMethod void duplicateSubmitToBrokerExpressTest() {
        Test.startTest();
        User salesUser = 
           [SELECT Name, Lead_Rep_Number__c 
            FROM User WHERE Lead_Rep_Number__c != null and isActive = TRUE Limit 1];

        Account acct = new Account();
        acct.Name = 'TestAccount';
        acct.NumberOfEmployees = 52;
        acct.Sic = '0111';
        acct.EIN__c = '12-3456789';
        acct.BillingStreet = '1660 International Dr.';
        acct.BillingCity = 'McLean';
        acct.BillingState = 'VA'; 
        acct.BillingPostalCode = '22102';
        insert acct;
 
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall';
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
//        opp.Market_Segment__c = '51-199';
        opp.Market_Segment_New__c = '51-199';
//        opp.Business__c = 'New Business';
        opp.Business_Type__c = 'New';
        opp.Lead_Rep_Name_User__c = '00530000000cOsOAAU';//salesUser.Id;
        opp.BE_Prospect_ID__c = 'PR-16981';
        opp.Division__c = '51-199 New Business';   
        opp.Underwriting_Entity__c = 'DC';
             
        // KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);   // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11); // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        insert opp;

        // Add a look up entry to simulate that the opportunity was already submitted to
        // broker express but failed to be added to the opportunity 
        BE_Prospect_Lookup__c beLookup = new BE_Prospect_Lookup__c(); 
        beLookup.Transaction_Id__c = String.valueOf(DateTime.now().getTime()); 
        beLookup.Opportunity_ID__c = opp.Id;
        beLookup.BE_Prospect_ID__c = 'PR-16981';

        System.runAs(salesUser) {
            SubmitToBrokerExpress submit = loadSubmitToBEPage(opp);

            // Verify that page doesn't have any error messages
            System.assertEquals(ApexPages.getMessages().isEmpty(), true);

            // Verify that the opportunity has a BE prospect ID 
            System.assert(opp.BE_Prospect_ID__c != null);

            // Submit to broker express
            PageReference redirectPage = submit.submitToBrokerExpress();
            PageReference expectedPage = null;

            // Verify the opportunity has the same BE prospect Id as the lookup entry
            opp = [SELECT BE_Prospect_ID__c FROM Opportunity WHERE Id =: opp.Id];
            System.assertEquals('PR-16981', opp.BE_Prospect_ID__c);
        }
        Test.stopTest();
    }

    /**
     * Simulates the unique scenario where an opportunity was previously submitted to
     * Broker Express and a value was generated for said opportunity but it was never
     * saved on the opportunity itself.
     */
    static testMethod void prospectLookupSubmitToBrokerExpressTest() {
        Test.startTest();
        User salesUser = 
           [SELECT Name, Lead_Rep_Number__c 
            FROM User WHERE isActive = true and Profile.UserLicense.Name = 'Salesforce' and 
                            profile.name = '51+ Standard User - Custom' and Lead_Rep_Number__c != null Limit 1];
            
        System.runAs(salesUser) {
            Account acct = new Account();
            acct.Name = 'TestAccount';
            acct.NumberOfEmployees = 52;
            acct.Sic = '0111';
            acct.EIN__c = '12-3456789';
            acct.BillingStreet = '1660 International Dr.';
            acct.BillingCity = 'McLean';
            acct.BillingState = 'VA'; 
            acct.BillingPostalCode = '22102';
            insert acct;
     
            Opportunity opp = new Opportunity();
            opp.Name = 'Test opp';
            opp.FullServiceProducer__c = 'BenefitMall';
            opp.StageName = 'Proposal';
            opp.CloseDate = Date.today() + 7;
            opp.AccountId = acct.Id;
//            opp.Market_Segment__c = '51-199';
            opp.Market_Segment_New__c = '51-199';
//            opp.Business__c = 'New Business';
            opp.Business_Type__c = 'New';
            opp.Division__c = '51-199 New Business';
            opp.Lead_Rep_Name_User__c = salesUser.Id;
            opp.Underwriting_Entity__c = 'DC';   
            // KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
            opp.Effective_Date__c =  Date.newInstance(2014,10,1);   // validation rule requires effective date be 1st of month
            opp.CloseDate = opp.Effective_Date__c.addDays(-11); // validation rule requires effective date be after close date i.e. effective > closedate
            opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
            opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);     
            insert opp;
    
            // Add a look up entry to simulate that the opportunity was already submitted to
            // broker express but failed to be added to the opportunity 
            BE_Prospect_Lookup__c beLookup = new BE_Prospect_Lookup__c(); 
            beLookup.Transaction_Id__c = String.valueOf(DateTime.now().getTime()); 
            beLookup.Opportunity_ID__c = opp.Id;
            beLookup.BE_Prospect_ID__c = 'PR-16981';

        //System.runAs(salesUser) {
            SubmitToBrokerExpress submit = loadSubmitToBEPage(opp);

            // Verify that page doesn't have any error messages
            System.assertEquals(ApexPages.getMessages().isEmpty(), true);

            // Verify that the opportunity has no BE prospect ID 
            System.assertEquals(opp.BE_Prospect_ID__c, null);

            // Submit to broker express
            PageReference redirectPage = submit.submitToBrokerExpress();
            PageReference expectedPage = new PageReference('/' + opp.Id);

            // Verify the opportunity has the same BE prospect Id as the lookup entry
            opp = [SELECT BE_Prospect_ID__c FROM Opportunity WHERE Id =: opp.Id];
            //System.assertEquals('PR-16981', opp.BE_Prospect_ID__c);         
            //System.assertEquals(redirectPage.getURL(), expectedPage.getURL());
        }
        Test.stopTest();
    }

    /**
     * Simulates an error scenario where there are no environment variables present
     */ 
    static testMethod void noEnvironmentVarsPresentSubmitToBrokerExpressTest() {
        Test.startTest();
        User salesUser = 
           [SELECT Name, Lead_Rep_Number__c 
            FROM User WHERE Lead_Rep_Number__c != null and isActive = TRUE Limit 1];

        // Create an opportunity and account purposely omitting fields required
        // to send over to broker express to test the error scenarios at first  
        Account acct = new Account();
        acct.Name = '1234567891011121314151617181920212223242526';
        acct.NumberOfEmployees = 40;
        insert acct;
 
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall';
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
//        opp.Business__c = 'New Business';   
        opp.Business_Type__c = 'New';
        opp.Division__c = '51-199 New Business';
        opp.Underwriting_Entity__c = 'DC';
                // KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);   // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11); // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
         
        insert opp;

        // Remove all the environment variables
        delete [SELECT ID FROM EnvironmentVariable__c];

        System.runAs(salesUser) {
            SubmitToBrokerExpress submit = loadSubmitToBEPage(opp);

            // Verify that page doesn't have any error messages
            System.assertEquals(ApexPages.getMessages().isEmpty(), true);
            System.assert(submit.environmentVarsPresent == true);

            // Submit to broker express
            PageReference redirectPage = submit.submitToBrokerExpress();
            PageReference expectedPage = null;

            // Verify that the controller is aware of the lack of environment variables
            System.assertEquals(ApexPages.getMessages().isEmpty(), false);
        }
        Test.stopTest();
    }


    /****************************************************************************/
    /***************************** HELPER FUNCTIONS *****************************/
    /****************************************************************************/


    private static SubmitToBrokerExpress loadSubmitToBEPage(Opportunity opp) {
        PageReference pageRef = new PageReference('/apex/SubmitToBrokerExpress');
        test.setCurrentPage(pageRef);

        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
        SubmitToBrokerExpress submit = new SubmitToBrokerExpress(stdController);
        return submit;
    }

}