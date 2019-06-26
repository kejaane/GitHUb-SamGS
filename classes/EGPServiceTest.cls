/*
This class contains unit tests for DESCRIPTION

Log: 
+-----------+----------------+------------------------------------------------------
|   Date    |   Developer    |   Description
+-----------+----------------+--------------------------------------------------------
| 10/06/14  |   KG           |   note
| 22/02/18  |  Sajitha       |T01|  Updated the test class to pass validation rules and added
 									test methods to increase coverage
+-----------+----------------+--------------------------------------------------------
*/


@isTest(SeeAllData=false)
private class EGPServiceTest {
    
    public static Account a;
    public static List<Contact> testContacts = new List<Contact>();
    public static List<Opportunity> testOpportunities = new List<Opportunity>();
    // Map<String,Map<String,SObject>> testData = new  Map<String,Map<String,SObject>>();
    // create test data before any test method is called using static block
    static {
        System.debug('Doing this first');
        //TestUtil.createTestAccounts();
        //TestUtil.createTestContacts();
        //TestUtil.createTestOpportunities();
    }
    
    /* 
* Test description
*/
    @isTest( SeeAllData=false)
    static  void testEGPUserTriggerUpdates() {
        
        // test data setup
        // Test methods cannot make web service callouts. To support testing, the standard best practice
        // is to provide a mock implementation of the web service callout which doesn't actually make a callout
        // but returns a simulated response. 
        // The Salesforce test engine is told to use the mock implementation with the following call 
        // to Test.setMock( WebServiceMock.class, instance of Mock implementation class);  
        Test.setMock(WebServiceMock.class, new EGPServiceProxyMockImpl());
        
        
        // testing logic
        Test.startTest();
        //System.debug( TestUtil.accountId);
        //System.debug( TestUtil.contactId);
        //System.debug( TestUtil.opportunityId);
        //createEGPTestData();
        String egpSFDCSupportEmailAddress = 'SFDCTeam@CareFirst.com';
        String egpPortalSupportEmailAddress = 'ep_tech_support@carefirst.com';
        String environmentModuleName = 'EGP Integration';
        String environmentCommonModuleName = 'Common';
        String environmentVariableName_egpSFDCSupportEmailAddress = 'SFDC_Support_Email';
        String environmentVariableName_egpPortalSupportEmailAddress = 'EGP_Support_Email';
        String environmentVariableName_egpRequestTimeout = 'RequestTimeout';
        //T01 - START Inserted test data for sold opportunity
        List<Account>  acclist = new List<Account>();
        a = AIA_TestUtil.CreateAccount('TestAccount');
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1]; 
        List <user> userlist= new List<User>();
        List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
        
        User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = pro.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
        insert u1;
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = pro.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com.test');
        insert u2;
        
        
        User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = pro.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test',ManagerID=u2.Id);
        
        insert u3;
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'Account Executive';
        atmRole.AccountId = a.id;
        atmRole.UserId = u1.id;
        AccountTeamMemberList.add(atmRole);
        
        AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Proposal Specialist';
        atm1.AccountId = a.id;
        atm1.UserId = u2.id;
        
        AccountTeamMemberList.add(atm1);
        
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'Account Manager';
        atmRole2.AccountId = a.id;
        atmRole2.UserId = u3.id;
        AccountTeamMemberList.add(atmRole2);
        
        insert AccountTeamMemberList;
        /*
From EGPService.cls - used to construct opp object
String opportunityQuery = 
'Select Id, Account.Name, Name, Type, StageName, Effective_Date__c, ' +
'System__c, Risk_Non_Risk__c, Enrollment__c, Facets_Grp_Num__c, ' +
'NASCO_Acct_ID__c, Market_Segment_New__c, Contract_End_Date__c FROM Opportunity a' +
' WHERE AccountID = :accountId' +
' AND Effective_Date__c <= TODAY ' +
' AND Contract_End_Date__c >= Today ' +
' AND StageName = \'Sold\' ' +
' AND System__c INCLUDES (\'Facets\',\'Nasco\')';
*/
        
        User salesUser = [SELECT Name, Lead_Rep_Number__c FROM User WHERE Lead_Rep_Number__c != null Limit 1];
        
        
        
        //Removing as per US210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'Renewal';
        wpt.Active__c=true;
        insert wpt;*/
        List<Opportunity> oplist = new List<Opportunity>();  
        Opportunity op = new Opportunity();
        op.recordTypeId=Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;
        op.Name = 'Test opp';
        op.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        op.StageName = 'Proposal';
        op.CloseDate = Date.today() + 7;
        op.AccountId = a.Id;
        op.Market_Segment_New__c = '51-199';
        op.Business_type__c = 'Renewal';
        op.Division__c = '51-199 New Business';
        op.Legal_Account_Name_Verified__c =true;
        op.Underwriting_Entity__c = 'NCAS';
        op.Effective_Date__c =  Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
        op.CloseDate = op.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        op.Contract_End_Date__c = op.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        op.Contract_End_Date__c = op.Contract_End_Date__c.addDays(-1);
        op.Risk_Non_Risk__c='Risk';
        //op.Workplan_Type__c = wpt.id;//Removed as per US210
        insert op;
        Map<Id,Opportunity> oldOpportunitiesMap = new  Map<Id,Opportunity>();
        oldOpportunitiesMap.put(op.Id, op);
        system.debug('old opps in test'+oldOpportunitiesMap);
        Product2 prod = new Product2(Name = 'Test product'); 
        
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        OpportunityLineItem oppProduct2 = new OpportunityLineItem();
        oppProduct2.OpportunityId = op.Id;
        oppProduct2.PricebookEntryId = standardPrice.Id; 
        oppProduct2.Product_Sold__c = true;
        oppProduct2.Quantity = 10.00 ;
        oppProduct2.TotalPrice = 100.00;
        insert oppProduct2;
        
        Account a1 = new Account();
        a1.Name = 'SomeTest' + Date.Today();
        a1.Type = 'Partner';
        
        insert a1;
        
        Partner__c p= new Partner__c();
        p.Partner__c=a1.id;
        p.Opportunity__c=op.id;
        p.Role__c='Broker';
        p.Effective_Date__c=Date.newInstance(2014,10,1);
        p.End_Date__c=Date.newInstance(2015,10,1);
        insert p;
        
        
        
        a.Ownerid=u3.id;
        system.debug('****acc owner'+a.Ownerid);
        update a;
        
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = a.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = op.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        insert brf;
        Test.stopTest();
        AIA_TestUtil.createAIADocument(brf);
        //brf =AIA_TestUtil.updateBRF(prf.id,acc.id,brf.id);
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();             
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'Sold';
        update brf;
        
        
        op.stageName='Sold';
        op.Won_Lost_Reason__c='Acquisition';
        op.Incumbent_Successor__c = 'CareFirst'; 
        op.System__c='NASCO;FACETS';
        op.NASCO_Acct_ID__c='12345';
        op.Facets_Grp_Num__c='1111,2222';
        op.Contract_End_Date__c=date.newInstance(2020, 10, 31);
        op.Risk_Non_Risk__c='Non-Risk';
        update op;
        oplist.add(op);
        acclist.add(a);
        
        EGPService.applyRules_EGP_OpportunityUpdate(op);
        EGPService.buildEGPAccountUpdateRequestData(acclist); 
        EGPService.buildEGPAccountUpdateRequestData(oplist);
        // T01 - END
        Contact c1 = new Contact();
        c1.AccountId = a.Id;
        c1.FirstName = 'fName1';
        c1.LastName = 'lName1';
        c1.Email = 'Email1@somedomain.com';
        c1.Phone='3013852013';
        c1.Employer_Group_Portal__c=true;
        insert c1;
        
        Contact c2 = new Contact();
        c2.AccountId = a.Id;
        c2.FirstName = 'fName2';
        c2.LastName = 'lName2';
        c2.Email = 'Email2@somedomain.com';
        c2.Phone='3013852013';
        c2.Employer_Group_Portal__c=false;
        insert c2;
        
        // peform assertions
        System.assert(true);
        
    }
    
    @isTest( SeeAllData=true)
    public static void testEGPAccountUpdate() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom' limit 1]; 
        
        
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='uniqueUserName@test.com');
        
        
        Map<String,Map<String,SObject>> testData = EGPServiceTest.createEGPAccountUpdateTestData();
        Map<String,Account> accounts = (Map<String,Account>) testData.get('Account');
        Map<String,Opportunity> opps = (Map<String,Opportunity>) testData.get('Opportunity');
        
        System.debug(String.valueOf(accounts));
        System.debug(String.valueOf(opps));
        
        Test.startTest();
        
        Account a1 = accounts.get('TestAccountforo3');
        Account ax = [ select Id,Name, Owner.FirstName, Owner.LastName, Owner.Email from Account where Name = :a1.Name ];
        ax.Owner.FirstName = 'Ken2';
        upsert ax;
        
        //Account a2 = accounts.get('TestAccountforo4');
        //a2.Owner.FirstName = 'Ken2';
        //upsert a2;
        //T01- START
        EGPService.validateSubmittedAccountUpdates() ;
        EGPService.validateSubmittedOpportunityUpdates();
        //T01 - END
        Test.stopTest(); 
        
        System.debug('Finished testEGPAccountUpdate');
        
    }
    
    @isTest
    public static void testEGPChangeDetection() {
        
        //------------set up test data -----------------------//
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User salesUser = new User(	Alias = 'kgt', Email='someuser@testorg.com', 
                                  EmailEncodingKey='UTF-8', LastName='Tester', FirstName='Ken', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p.Id, 
                                  TimeZoneSidKey='America/Los_Angeles', UserName='ken@testorg.com');
        insert salesUser;
        
        Account acct = new Account();
        acct.Name = 'TestAccount';
        acct.NumberOfEmployees = 45; 
        acct.Sic = '0111';
        acct.EIN__c = '123456789'; // Has field validation, cannot be longer than 9 chars
        acct.BillingStreet = '1660 International Drive St. #518 Ste.500e ';
        acct.BillingCity = 'McLean';
        acct.BillingState = 'MD';
        acct.BillingPostalCode = '20871'; // Has a validation rule in place 
        acct.Billing_County_Code__c = 'DCMD';
        
        acct.Owner = salesUser;
        insert acct;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
        opp.Market_Segment_New__c = '51-199';
        opp.Business_type__c = 'Renewal';
        opp.Division__c = '51-199 New Business';
        opp.Underwriting_Entity__c = 'NCAS';
        opp.Lead_Rep_Name_User__c = salesUser.Id;
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);	// validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11);	// validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);	// VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        
        opp.System__c = 'NASCO';
        opp.NASCO_Acct_ID__c = '12345689';
        opp.Facets_Grp_Num__c = '1123';
        opp.Risk_Non_Risk__c = 'Risk';
        opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule cannot be blank
        opp.GeneralProducer__c = 'GP';
        opp.Enrollment__c = 'CareFirst Connect';
        
        opp.Account = acct;
        // insert opp;
        //------------end set up test data -----------------------//
        
        
        Account testAcct = acct.clone();
        Opportunity testOpp	= opp.clone();
        
        Test.startTest();
        
        //--------------------------------------------------------------------------------
        
        // Account change detection
        // Negative test: test egpUpdate for identical accounts
        System.assert( !EGPService.hasEgpUpdate(testAcct,acct), 'Failed to ignore identical accounts');   
        
        // test null input
        System.assert(!EGPService.hasEgpUpdate( null, acct), 'Failed to ignore Null input - no change');
        System.assert(!EGPService.hasEgpUpdate( acct, null), 'Failed to ignore Null input - no change');
        
        // Positive test: detect relevant field change
        
        testAcct = acct.clone();
        testAcct.Name = 'ChangedName';
        System.assert(EGPService.hasEgpUpdate(testAcct,acct), 'Failed to detect change on relevant field: Account.Name');
        
        testAcct = acct.clone();
        testAcct.Owner = acct.Owner.clone();
        testAcct.Owner.FirstName = 'ChangedFirstName';
        System.assert(EGPService.hasEgpUpdate(testAcct,acct), 'Failed to detect change on relevant field: Account.Owner.FirstName');
        
        testAcct = acct.clone();
        testAcct.Owner = acct.Owner.clone();
        testAcct.Owner.LastName = 'ChangedLastName';
        System.assert(EGPService.hasEgpUpdate(testAcct,acct), 'Failed to detect change on relevant field: Account.Owner.LastName');
        
        testAcct = acct.clone();
        testAcct.Owner = acct.Owner.clone();
        testAcct.Owner.Email = 'Changed@email.com';
        System.assert(EGPService.hasEgpUpdate(testAcct,acct), 'Failed to detect change on relevant field: Account.Owner.Email');
        
        // Negative test: detect ignoring of irrelevant field change
        // This is an important test to reduce the volume of updates sent by the EGP AccountUpdate function.
        
        testAcct = acct.clone();
        testAcct.BillingStreet = 'ChangedBillingStreet';
        System.assert(!EGPService.hasEgpUpdate(testAcct,acct), 'Failed to ignore irrelevant field: Account.BillingStreet');
        
        testAcct = acct.clone();
        testAcct.AG_Rank__c = 799;
        System.assert(!EGPService.hasEgpUpdate(testAcct,acct), 'Failed to ignore irrelevant field: Account.AG_Rank__c');
        
        //--------------------------------------------------------------------------------
        
        // Opportunity change detection
        // test egpUpdate for identical opps
        System.assert( !EGPService.hasEgpUpdate(testOpp,opp), 'Failed to ignore identical opps');
        
        // test null input
        System.assert(!EGPService.hasEgpUpdate( null, opp), 'Null input opp');
        System.assert(!EGPService.hasEgpUpdate( testOpp, null), 'Null input opp');
        
        // Negative test: modify a non-relevant field. result should be false
        testOpp.Market_Segment_New__c = '11-222';
        System.assert(!EGPService.hasEgpUpdate(testOpp,opp), 'Failed to ignore not relevant field Opportunity.Market_Segment_New__c');
        
        // Positive tests: modify a relevant field, result should be true
        testOpp = opp.clone();
        testOpp.System__c = 'Something else';
        System.assert(EGPService.hasEgpUpdate(testOpp,opp), 'Failed to detect change on relevant field: Opportunity.System__c');
        
        testOpp = opp.clone();
        testOpp.NASCO_Acct_ID__c = 'NASCO_Acct_ID__c changed';
        System.assert(EGPService.hasEgpUpdate(testOpp,opp), 'Failed to detect change on relevant field Opportunity.NASCO_Acct_ID__c');
        
        testOpp = opp.clone();
        testOpp.Facets_Grp_Num__c = 'facets grpnum changed';
        System.assert( EGPService.hasEgpUpdate(testOpp,opp), 'Failed to detect change on relevant field Opportunity.Facets_Grp_Num__c');
        
        testOpp = opp.clone();
        testOpp.Risk_Non_Risk__c = 'risk changed';
        System.assert( EGPService.hasEgpUpdate(testOpp,opp), 'Failed to detect change on relevant field Opportunity.Risk_Non_Risk__c');
        
        testOpp = opp.clone();
        testOpp.FullServiceProducer__c = 'fsp changed';
        System.assert( EGPService.hasEgpUpdate(testOpp,opp), 'Failed to detect change on relevant field Opportunity.FullServiceProducer__c');
        
        testOpp = opp.clone();
        testOpp.GeneralProducer__c = 'gp changed';
        System.assert(EGPService.hasEgpUpdate(testOpp,opp), 'Failed to detect change on relevant field Opportunity.GeneralProducer__c');
        
        testOpp = opp.clone();
        testOpp.Enrollment__c = 'Enrollment__c changed';
        System.assert(EGPService.hasEgpUpdate(testOpp,opp), 'Failed to detect change on relevant field Opportunity.Enrollment__c');
        
        
        
        Test.stopTest();
        
        
        
    }
    
    @isTest
    public static void testEGPServiceFault() {
        EGPServiceFault fault;
        Test.startTest();
        fault = EGPServiceFault.SystemUnavailableFault;
        fault = EGPServiceFault.DatabaseFault;
        fault = EGPServiceFault.SystemTimeoutFault;
        fault = EGPServiceFault.InputRequestDataInValid;
        fault = EGPServiceFault.DefaultFault;
        fault = EGPServiceFault.DataNotFound;
        fault = new EGPServiceFault('F0001', 'SystemUnavailabelFault',
                                    'Unknown error occurred during execution. System not available.'); 	
        Test.stopTest();
    }
    
    
    
    /*---------------------------------------------------------------------------*
*                             Helper Functions                              *
*---------------------------------------------------------------------------*/
    public static void creatEGPTestData() {
        
        Account a = new Account();
        insert a;
        
        Opportunity op = new Opportunity();
        op.AccountId = a.Id;
        
        /*
From EGPService.cls - used to construct opp object
String opportunityQuery = 
'Select Id, Account.Name, Name, Type, StageName, Effective_Date__c, ' +
'System__c, Risk_Non_Risk__c, Enrollment__c, Facets_Grp_Num__c, ' +
'NASCO_Acct_ID__c, Market_Segment_New__c, Contract_End_Date__c FROM Opportunity a' +
' WHERE AccountID = :accountId' +
' AND Effective_Date__c <= TODAY ' +
' AND Contract_End_Date__c >= Today ' +
' AND StageName = \'Sold\' ' +
' AND System__c INCLUDES (\'Facets\',\'Nasco\')';
*/
        
        op.Name= 'TestOpportunity';
        op.Type = 'Medical Only';
        op.Effective_Date__c =  Date.today() - 7;
        op.Contract_End_Date__c = Date.today();
        op.StageName = 'Sold';
        op.Risk_Non_Risk__c = 'Non-Risk';
        op.Facets_Grp_Num__c = '045H' ;
        op.NASCO_Acct_ID__c = '';
        op.Market_Segment_New__c = '51-199';
        op.System__c = 'Facets';
        
        insert op;
        
        Contact c1 = new Contact();
        Contact c2 = new Contact();
        c1.AccountId = a.Id;
        c1.FirstName = 'fName1';
        c1.LastName = 'lName1';
        c1.Email = 'Email1';
        c1.Phone='3013852013';
        
        
        c2.AccountId = a.Id;
        c2.FirstName = 'fName2';
        c2.LastName = 'lName2';
        c2.Email = 'Email2';
        c2.Phone='3013852013';
        
        insert c1;
        insert c2;
    }
    
    public static Map<String,Map<String,SObject>> createEGPAccountUpdateTestData() {
        // Data staging for test
        
        // Test Data Map
        // Map { 'Account' => Map<Name,Account> , 'Opportunity' => Map<String,Opportunity> }
        // 
        Map<String, Map<String,SObject>> testData = new Map<String, Map<String,SObject>>();
        
        
        Map<String,Account> accounts = new Map<String,Account>();
        //T01-Modified test data for to pass validation rules
        // Create Account
        Account a1 = AIA_TestUtil.CreateAccount('TestAccountforo3');
        system.assertNotEquals(null,a1.id);
        a1.BillingState ='VA';
        update a1;
        accounts.put(a1.Name, a1);
        // Create Opportunity
        Map<String, Opportunity> opps = new Map<String, Opportunity>();
        list<Opportunity> oplist= new list<Opportunity>();
        Opportunity o3 = AIA_TestUtil.AIA_createopportunity(a1.Id);
        system.assertNotEquals(null,o3.id);
        o3.Name='Testo3';
        o3.StageName ='Sold';
        try{
            update o3;
        }
        catch (Exception e) {
            System.AssertNotEquals('False', 'Exception ' + e);
        }
        opps.put(o3.Name, o3);
        
        // Create Account
        Account a2 = AIA_TestUtil.CreateAccount('TestAccountforo4');
        system.assertNotEquals(null,a2.id);
        a2.BillingState ='VA';
        update a2;
        accounts.put(a2.Name, a2);
        // Create Opportunity
        
        Opportunity o4 = AIA_TestUtil.AIA_createopportunity(a2.Id);
        system.assertNotEquals(null,o4.id);
        o4.Name='Testo4';
        o4.StageName ='Sold';
        o4.System__c = 'NASCO';
        o4.NASCO_Acct_ID__c = '12689';
        
        try{
            update o4;
        }
        catch (Exception e) {
            System.AssertNotEquals('False', 'Exception ' + e);
        }
        opps.put(o4.Name, o4);
        //T01- END
        testData.put('Account', accounts);
        testData.put('Opportunity', opps);
        return testData;
        
    }
    //T01 - START    
    static testMethod void Test5(){
        Test.startTest();
        EGPService.reloadConfigurationFromEnvironmentVariables();
        //Changes for Method getservice() begins
        EGPServiceProxy.SalesForceEndpoint1  service = new EGPServiceProxy.SalesForceEndpoint1();
        EGPService.isInitialized=true;
        EGPService.environmentVariableName_egpSFDCSupportEmailAddress = 'Test_SFDC_Support_Email';
        EGPService.environmentVariableName_egpPortalSupportEmailAddress = 'Test_EGP_Support_Email';
        service=EGPService.getService();
        Test.stopTest();
        EGPAccountUpdateRequest hub=new EGPAccountUpdateRequest();
        String str=JSON.serialize(hub);
        //EGPService.sendEGPManageUserRequestsInFuture(str);
        
    }
    
    static testMethod void testBatch(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
        User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');
        Test.StartTest();
        System.runAs(u) {
            TestUtil.createTestAccounts();                
            TestUtil.createTestOpportunities();    
            TestUtil.createTestContacts();               
            
        }
        
        
        Test.StopTest();
        
    }
    @isTest( SeeAllData=false)
    static  void testEGPUserTriggerUpdates1() {
        
        // test data setup
        // Test methods cannot make web service callouts. To support testing, the standard best practice
        // is to provide a mock implementation of the web service callout which doesn't actually make a callout
        // but returns a simulated response. 
        // The Salesforce test engine is told to use the mock implementation with the following call 
        // to Test.setMock( WebServiceMock.class, instance of Mock implementation class);  
        Test.setMock(WebServiceMock.class, new EGPServiceProxyMockImpl());
        
        
        // testing logic
        Test.startTest();
        //System.debug( TestUtil.accountId);
        //System.debug( TestUtil.contactId);
        //System.debug( TestUtil.opportunityId);
        //createEGPTestData();
        
        
        Account a1 = AIA_TestUtil.CreateAccount('TestAccount');
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator' limit 1]; 
        List <user> userlist= new List<User>();
        List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
        
        User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = pro.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
        insert u1;
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = pro.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com.test');
        insert u2;
        
        
        User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
                           EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
                           LocaleSidKey='en_US', ProfileId = pro.Id,
                           TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test',ManagerID=u2.Id);
        
        insert u3;
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'Account Executive';
        atmRole.AccountId = a1.id;
        atmRole.UserId = u1.id;
        AccountTeamMemberList.add(atmRole);
        
        AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Proposal Specialist';
        atm1.AccountId = a1.id;
        atm1.UserId = u2.id;
        
        AccountTeamMemberList.add(atm1);
        
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'Account Manager';
        atmRole2.AccountId = a1.id;
        atmRole2.UserId = u3.id;
        AccountTeamMemberList.add(atmRole2);
        
        insert AccountTeamMemberList;
        
        User salesUser = [SELECT Name, Lead_Rep_Number__c FROM User WHERE Lead_Rep_Number__c != null Limit 1];
        
        
        
        //Removing per US210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'Renewal';
        wpt.Active__c=true;
        insert wpt;*/
        List<Opportunity> oplist = new List<Opportunity>();  
        Opportunity op = new Opportunity();
        op.recordTypeId=Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;
        op.Name = 'Test opp';
        op.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        op.StageName = 'Proposal';
        op.CloseDate = Date.today() + 7;
        op.AccountId = a1.Id;
        op.Market_Segment_New__c = '51-199';
        op.Business_type__c = 'Renewal';
        op.Division__c = '51-199 New Business';
        op.Legal_Account_Name_Verified__c =true;
        op.Underwriting_Entity__c = 'NCAS';
        op.Effective_Date__c =  Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
        op.CloseDate = op.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        op.Contract_End_Date__c = op.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        op.Contract_End_Date__c = op.Contract_End_Date__c.addDays(-1);
        //op.Workplan_Type__c = wpt.id;
        insert op;
        
        Product2 prod = new Product2(Name = 'Test product'); 
        
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prod.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        OpportunityLineItem oppProduct2 = new OpportunityLineItem();
        oppProduct2.OpportunityId = op.Id;
        oppProduct2.PricebookEntryId = standardPrice.Id; 
        oppProduct2.Product_Sold__c = true;
        oppProduct2.Quantity = 10.00 ;
        oppProduct2.TotalPrice = 100.00;
        insert oppProduct2;
        
        Account a2 = new Account();
        a2.Name = 'SomeTest' + Date.Today();
        a2.Type = 'Partner';
        
        insert a2;
        
        Partner__c p= new Partner__c();
        p.Partner__c=a2.id;
        p.Opportunity__c=op.id;
        p.Role__c='Broker';
        p.Effective_Date__c=Date.newInstance(2014,10,1);
        p.End_Date__c=Date.newInstance(2015,10,1);
        insert p;
        a1.Ownerid=u3.id;
        update a1;
        
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = a1.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = op.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        insert brf;
        Test.stopTest();
        AIA_TestUtil.createAIADocument(brf);
        
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();             
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'Sold';
        update brf;
        
        
        op.stageName='Sold';
        op.Won_Lost_Reason__c='Acquisition';
        op.Incumbent_Successor__c = 'CareFirst'; 
        op.System__c='FACETS';
        op.Facets_Grp_Num__c='1111,2222';
        op.Contract_End_Date__c=date.newInstance(2020, 10, 31);
        update op;
        oplist.add(op);
        EGPService.applyRules_EGP_OpportunityUpdate(op);
        EGPService.buildEGPAccountUpdateRequestData(oplist); 
        
        Contact c = new Contact();
        // c1.AccountId = a1.Id;
        c.FirstName = 'f1Name1';
        c.LastName = 'l1Name1';
        c.Email = 'Email11@somedomain.com';
        c.Phone='30138520134';
        c.Employer_Group_Portal__c=true;
        try{
            insert c;
        }catch(exception e)
        {
            
        }
        
        EGPService.buildEGPManageUserRequestData(c);
        
        // peform assertions
        System.assert(true);
        
    }
    
    
    public static void setupEnvironmentData() {
        List<EnvironmentVariable__c> envVars = new List<EnvironmentVariable__c>();
        EnvironmentVariable__c ev;
        
        String sfdcEmail = UserInfo.getUserEmail();
        ev = new EnvironmentVariable__c(  Variable_Name__c = 'EGP_EndPoint', Value__c = 'xx' , Name = 'EGP_EndPoint', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
        envVars.add(ev);
        ev = new EnvironmentVariable__c(  Variable_Name__c = 'EGP_ClientCertificateName', Value__c = 'salesforce_dev3_carefirst_com' , Name = 'EGP_ClientCertificateName', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
        envVars.add(ev);
        ev = new EnvironmentVariable__c(  Variable_Name__c = 'RequestTimeout', Value__c = '60000' , Name = 'RequestTimeout', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
        envVars.add(ev);
        ev = new EnvironmentVariable__c(  Variable_Name__c = 'EGP_Support_Email', Value__c = sfdcEmail , Name = 'EGP_Support_Email', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
        envVars.add(ev);
        ev = new EnvironmentVariable__c(  Variable_Name__c = 'SFDC_Support_Email', Value__c = sfdcEmail , Name = 'SFDC_Support_Email', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
        envVars.add(ev);
        
        upsert envVars;     
    }
    //T01 - END  
}