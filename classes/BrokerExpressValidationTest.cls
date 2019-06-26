/*------------------------------------------------------------------------------------
 *                      ----===[ HISTORY ]===---
 * Date        Developer     Tag   Description
 *------------------------------------------------------------------------------------
 * 12/03/2012 Varun Nagarajan   	Modified code where Business__c and Market_Segment__c 
 *                              	fields have been replaced with Business_Type__c, 
 *                              	Division__c and Market_Segment_New__c matching today's 
 *                              	world requirements at CareFirst. 
 * 1/21/2019  Chaithra 		|T01|	Fixed test class failure
 *************************************************************************************
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
private class BrokerExpressValidationTest {

    /**
     * Simulates account validation errors
     */
    static testMethod void accountValidationErrorsTest() {
        Test.startTest();
        User salesUser = 
           [SELECT Name, Lead_Rep_Number__c 
            FROM User WHERE Lead_Rep_Number__c != null Limit 1];
    
        Account acct = new Account();
        acct.Name = 'TestAccount';
        acct.NumberOfEmployees = 45; // Num employees should always be <= 50
        acct.Sic = '0111';
        acct.EIN__c = '123456789'; // Has field validation, cannot be longer than 9 chars
        acct.BillingStreet = '1660 International Drive St. #518 Ste.500e ' +
        '1660 International Drive St. #518 Ste.500e' +
        '1660 International Drive St. #518 Ste.500e';
        acct.BillingCity = 'McLean123456789012345678902345678901';
        acct.BillingState = 'MD';
        acct.BillingPostalCode = '22102-4501'; // Has a validation rule in place 
        acct.Billing_County_Code__c = 'DCMD';
        insert acct;
 
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
        //opp.Market_Segment__c = '51-199';
        opp.Market_Segment_New__c = '51-199';
        //opp.Business__c = 'CFA Renewal';
        opp.Business_type__c = 'Renewal';
        opp.Division__c = '51-199 New Business';
//VN - 12/22/2012       
        opp.Underwriting_Entity__c = 'NCAS';
        opp.Lead_Rep_Name_User__c = salesUser.Id;
        // KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);	// validation rule requires effective date be 1st of month
		opp.CloseDate = opp.Effective_Date__c.addDays(-11);	// validation rule requires effective date be after close date i.e. effective > closedate
		opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);	// VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        insert opp;

        BrokerExpressValidation validation = new BrokerExpressValidation(opp.Id, 'transactionId');

        // Verify there are no validation errors before processing
        System.assertEquals(validation.validRequest, true);
        System.assertEquals(validation.validationErrors, false);

        validation.validateData();
        
        // Verify there are validation errors with the above opportunity
        System.assertEquals(validation.validRequest, false);
        System.assertEquals(validation.validationErrors, true);


        // Update the account with additional known validation errors
        acct.NumberOfEmployees = 10000;
        acct.EIN__c = 'EINSTRING';
        //acct.BillingPostalCode = 'Not a number'; // Validation rule
        update acct;

        validation = new BrokerExpressValidation(opp.Id, 'transactionId');
        validation.validateData();

        // Verify that this isn't a valid request because it is a duplicate
        System.assertEquals(validation.validRequest, false);
        System.assertEquals(validation.validationErrors, true);

        Test.stopTest();
    }

    /**
     * Simulates validation on an opportunity that is not associated to an account
     */
    static testMethod void opportunityWithoutAnAccountTest() {
        Test.startTest();

        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.GeneralProducer__c = 'Direct';
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
//VN - 12/03/2012        
        //opp.Market_Segment__c = '51-199';
        opp.Market_Segment_New__c = '51-199';
        //opp.Business__c = 'New Business';
        opp.Business_Type__c = 'New';
        opp.Division__c = '51-199 New Business';
//VN - 12/22/2012
        opp.Underwriting_Entity__c = 'MD';
        // KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);	// validation rule requires effective date be 1st of month
		opp.CloseDate = opp.Effective_Date__c.addDays(-11);	// validation rule requires effective date be after close date i.e. effective > closedate
		opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);	// VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        insert opp;

        BrokerExpressValidation validation = new BrokerExpressValidation(opp.Id, 'transactionId');

        System.assertEquals(validation.validRequest, true);
        System.assertEquals(validation.duplicateError, false);
        System.assertEquals(validation.validationErrors, false);

        validation.validateData();

        // Verify that after validating, error flags were set
        System.assertEquals(validation.validRequest, false);
        //System.assertEquals(validation.duplicateError, true);
        System.assertEquals(validation.validationErrors, true);
        
        Test.stopTest();        
    }

    /**
     * Verifies that an opportunity which is not in a proposal stage yields a validation error
     */
    static testMethod void incorrectStageValidationTest() {
        Test.startTest();
        User salesUser = 
           [SELECT Name, Lead_Rep_Number__c 
            FROM User WHERE Lead_Rep_Number__c != null Limit 1];
    
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
        //opp.FullServiceProducer__c = 'BenefitMall';
        opp.GeneralProducer__c = 'CBIZ';
        opp.StageName = 'Sold';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
//VN - 12/03/2012
        //opp.Market_Segment__c = '51-199';
        opp.Market_Segment_New__c = '51-199';
        //opp.Business__c = 'New Business';
        opp.Business_Type__c = 'New';
        opp.Division__c = '51-199 New Business';
//VN - 12/22/2012        
        opp.Underwriting_Entity__c = 'MD';
        opp.Lead_Rep_Name_User__c = salesUser.Id;
        // KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);	// validation rule requires effective date be 1st of month
		opp.CloseDate = opp.Effective_Date__c.addDays(-11);	// validation rule requires effective date be after close date i.e. effective > closedate
		opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);	// VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        opp.Won_Lost_Reason__c = 'Acquisition';     // VR requires non-blank
        opp.Incumbent_Successor__c = 'CareFirst'; 	// VR requires this to be set when stage=Sold
        insert opp;

        BrokerExpressValidation validation = new BrokerExpressValidation(opp.Id, 'transactionId');
        validation.validateData();
        
        // Verify there are validation errors with the above opportunity as it is in a sold stage
        System.assertEquals(validation.validRequest, false);
        System.assertEquals(validation.oppStageError, true);

        Test.stopTest();
    }


    /**
     * Verifies that a proposed opportunity older than 180 days ( Proposal_Sent__c and Today)
     * results in a validation error  
     */
    static testMethod void opportunityProposed180DaysOldTest() {
        Test.startTest();
        User salesUser = 
           [SELECT Name, Lead_Rep_Number__c 
            FROM User WHERE Lead_Rep_Number__c != null Limit 1];
    
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
        System.assertEquals(acct.Sic == '0111', true);

 
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'Direct';
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
//VN - 12/03/2012
        //opp.Market_Segment__c = '51-199';
        opp.Market_Segment_New__c = '51-199';
        //opp.Business__c = 'New Business';
        opp.Division__c = '51-199 New Business';
        opp.Business_Type__c = 'New';
        opp.SBU__c = 'Small/Medium';
//VN - 12/22/2012        
        opp.Underwriting_Entity__c = 'MD';
        opp.Lead_Rep_Name_User__c = salesUser.Id;
        		// KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);	// validation rule requires effective date be 1st of month
		opp.CloseDate = opp.Effective_Date__c.addDays(-11);	// validation rule requires effective date be after close date i.e. effective > closedate
		opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);	// VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        
        insert opp;
        //System.assertEquals(opp.Name == 'Test opp', true);
        //T01 changes Starts
		FSP_GP__c fsp_gp=new FSP_GP__c();
        fsp_gp.Opportunity__c=opp.Id;
        fsp_gp.FSP_GP__C='FSP';
        fsp_gp.Partner__c='BenefitMall';
        fsp_gp.Effective_Date__c=Date.newInstance(2014,10,1);
        fsp_gp.End_Date__c=date.newinstance(2016, 10, 14);
        Insert fsp_gp;
        
        FSP_GP_Lookup__c fspGP = new FSP_GP_Lookup__c();
        fspGP.FSP_GP__c = 'BenefitMall';
        fspGp.DBE_WH__c = 'Test&Test';
        fspGP.Tax_Id__c='TaxId';
        insert fspGP;
        //T01 Ends
        BrokerExpressValidation validation = new BrokerExpressValidation(opp.Id, 'transactionId');
        validation.validateData();
        
        // Verify there are no validation errors with the above opportunity
        System.assertEquals(validation.validRequest, true);
        System.assertEquals(validation.duplicateError, false);

		// Now make the proposed date > 180 days old
		opp.Proposal_Sent__c = Date.newInstance(2013,1,1);
		// KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);	// validation rule requires effective date be 1st of month
		opp.CloseDate = opp.Effective_Date__c.addDays(-11);	// validation rule requires effective date be after close date i.e. effective > closedate
		opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);	// VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
		upsert opp;

        validation = new BrokerExpressValidation(opp.Id, 'transactionId');
        validation.validateData();
        
        // Verify there are validation errors with the above opportunity as it is in a sold stage
        System.assertEquals(validation.validRequest, false);
        System.assertEquals(validation.oppProposedMoreThan180DaysAgoError, true);

        Test.stopTest();
    }

    /**
     * Simulates generic validation errors
     */
    static testMethod void contactRolesValidationErrorsTest() {
        Test.startTest();
        User salesUser = 
           [SELECT Name, Lead_Rep_Number__c 
            FROM User WHERE Lead_Rep_Number__c != null Limit 1];
    
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
        opp.FullServiceProducer__c = 'Direct';
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
//VN - 12/03/2012        
        //opp.Market_Segment__c = '51-199';
        opp.Market_Segment_New__c = '51-199';
        //opp.Business__c = 'New Business';
        opp.Business_Type__c = 'New';
        opp.Division__c = '51-199 New Business';
//VN - 12/22/2012   
        opp.Underwriting_Entity__c = 'MD';
        opp.Lead_Rep_Name_User__c = salesUser.Id;
// KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);	// validation rule requires effective date be 1st of month
		opp.CloseDate = opp.Effective_Date__c.addDays(-11);	// validation rule requires effective date be after close date i.e. effective > closedate
		opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);	// VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        
        insert opp;

        Contact firmExec = new Contact();
        firmExec.AccountId = acct.Id;
        firmExec.FirstName = 'TestTestTestTestTestTest';
        firmExec.LastName = 'ContactContactContactContactTest';
        firmExec.Email = 'testContactContactContactContactTestContact' +
            'ContactContactContactContact@test.com';
        firmExec.Phone = '99922';
        insert firmExec;

        OpportunityContactRole firmExecRole = new OpportunityContactRole();
        firmExecRole.OpportunityId = opp.Id;
        firmExecRole.ContactId = firmExec.Id;
        firmExecRole.Role = 'Firm Executive';
        insert firmExecRole;

        Contact groupAdmin = new Contact();
        groupAdmin.AccountId = acct.Id;
        groupAdmin.FirstName = 'Test2';
        groupAdmin.LastName = 'Contact';
        groupAdmin.Email = 'test2@test.com';
        groupAdmin.Phone = '9992523124';
        insert groupAdmin;

        OpportunityContactRole groupAdminRole = new OpportunityContactRole();
        groupAdminRole.OpportunityId = opp.Id;
        groupAdminRole.ContactId = groupAdmin.Id;
        groupAdminRole.Role = 'Group Administrator';
        insert groupAdminRole;

        BrokerExpressValidation validation = new BrokerExpressValidation(opp.Id, 'transactionId');

        // Verify there are no validation errors before processing
        System.assertEquals(validation.validRequest, true);
        System.assertEquals(validation.validationErrors, false);

        validation.validateData();

        System.assertEquals(validation.validRequest, false);
        System.assertEquals(validation.validationErrors, true);

        Test.stopTest();
    }

    /**
     * Simulates generic validation errors
     */
    static testMethod void validationErrorsTest() {
        Test.startTest();
        User salesUser = 
           [SELECT Name, Lead_Rep_Number__c 
            FROM User WHERE Lead_Rep_Number__c != null Limit 1];
    
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
        System.assertEquals(acct.Sic == '0111', true);

 
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'Direct';
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
//VN - 12/03/2012
        //opp.Market_Segment__c = '51-199';
        opp.Market_Segment_New__c = '51-199';
        //opp.Business__c = 'New Business';
        opp.Division__c = '51-199 New Business';
        opp.Business_Type__c = 'New';
        opp.SBU__c = 'Small/Medium';
//VN - 12/22/2012        
        opp.Underwriting_Entity__c = 'MD';
        opp.Lead_Rep_Name_User__c = salesUser.Id;
        // KG - 12/10/2014 - Add these 4 lines to satisfy VRs around Contract end date needing to be last day of month
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);	// validation rule requires effective date be 1st of month
		opp.CloseDate = opp.Effective_Date__c.addDays(-11);	// validation rule requires effective date be after close date i.e. effective > closedate
		opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);	// VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        
        insert opp;
        //System.assertEquals(opp.Name == 'Test opp', true);
        //T01 Starts
		FSP_GP__c fsp_gp=new FSP_GP__c();
        fsp_gp.Opportunity__c=opp.Id;
        fsp_gp.FSP_GP__C='FSP';
        fsp_gp.Partner__c='BenefitMall';
        fsp_gp.Effective_Date__c=Date.newInstance(2014,10,1);
        fsp_gp.End_Date__c=date.newinstance(2016, 10, 14);
        Insert fsp_gp;
        
        FSP_GP_Lookup__c fspGP = new FSP_GP_Lookup__c();
        fspGP.FSP_GP__c = 'BenefitMall';
        fspGp.DBE_WH__c = 'Test&Test';
        fspGP.Tax_Id__c='TaxId';
        insert fspGP;
        //T01 Ends
        BrokerExpressValidation validation = new BrokerExpressValidation(opp.Id, 'transactionId');
        validation.validateData();
        
        // Verify there are no validation errors with the above opportunity
        System.assertEquals(validation.validRequest, true);
        System.assertEquals(validation.duplicateError, false);


        // ==============START Tests for HIX- 722 business rules
		// Removed 11/23/15 as part of HIX changes reversal requestd by project.
        // ==============END Tests for HIX- 722 business rules



        // Set the stage to "Proposal" so it passes the first validation then set the prospect Id
        opp.BE_Prospect_ID__c = '09-89871';
        update opp;

        validation = new BrokerExpressValidation(opp.Id, 'transactionId');
        validation.validateData();

        // Verify that this isn't a valid request because it is a duplicate
        System.assertEquals(validation.validRequest, false);
        System.assertEquals(validation.duplicateError, true);
 
        String phoneNumber = '(922)7.22-4562';
        String unformatted = '9227224562';
        System.assertEquals(unformatted, BrokerExpressValidation.unformatPhoneNumber(phoneNumber));

        Test.stopTest();
    }

}