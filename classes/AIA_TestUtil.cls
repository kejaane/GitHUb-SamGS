/*
 *=====================================================================================================================
 * Date: 05/18/2016
 * Developer: XXX
 * Purpose: Used to create test data as necessary for test classes
 *=====================================================================================================================
 *                                      Update History
 *                                      --------------
 * Date        Developer            Tag         Description
 *=====================================================================================================================
 * 5/21/2016   Rajesh Pennam                Added test classes for BRFTrigger Handler, regarding  PRF and BRF
 * 6/5/2016    Rajesh Pennam                Added test lass for WorkplanTypeAssignment and WorkplanAssignment
 * 8/25/2016   Indira Das                   Added test method for GSM group structure and get recordtype objects
 * 9/29/2016   Indira Das                   Added test class for the AIA document creation 
 * 7/6/2017    Debkanti                     Added Test class for Opportunity with record type 200+
 * 7/10/2017   Debkanti                     Added Test data for AIA_PCSIntegrationHandler_Test code coverage improvement.
 * 7/25/2017   Debkanti                     Added Test data for AIA_WP_SubProcess_ControllerTest code Coverage improvement.
 * 7/25/2017   Debkanti                     Added Test data for AIA_ImplementationTriggerHelper_Test code Coverage improvement.
 * 4/17/2017   Gayathri             T01     REmoved WP related functionalities
 * 4/24/2018   Arshia               T02     Added Test Data for Process__c and Sub_Process__c
 * 5/2/2018    Arshia               T03     Added Test Data for WorkPlan_Task__c
 * 5/17/2018   Arshia               T04     Added TaskOwner in method CreateWorkPlanTask
 *06-07-2018    raj kiran jv        T05     Added code for brf form validation for test class fail issue.
 *06-08-2018    raj kiran jv        T06     Added code for roles changes
 * 9/5/2018    Arshia               T07     Commentd MHP fields for US-771
 * 2/4/2019 	Chaithra			T08		Added code for Account team change US6713
 *=====================================================================================================================
 */

@IsTest
public class AIA_TestUtil{
    static id accountId;
    static id account2_50_Default;
    static id opportunityId;
    static id contactId;
    static id EngagementId;  
    Static Profile adminProfile;
    static{
       adminProfile = [select id from profile where name='System Administrator']; 
    }
    
    //T01 -- Start
    /*public static AIA_Workplan_Type__c AIA_CreateWorkPlan(){
        AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'Off-Cycle';
        wpt.Active__c=true;
        
        return wpt;
    }*/
    //T01 -- End
    
    public static User AIA_createUser(String alias )
    {
         
        Integer max = 5;
        String randomString = EncodingUtil.convertToHex(crypto.generateAesKey(128)).substring(1,max).toUpperCase();
        Profile profile = adminProfile;
        //string s = string.valueOf(system.now());
        double randomd = Math.random();
        User user = new User(alias = alias, email=alias + '@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = profile.Id, 
            timezonesidkey='Europe/London', username=alias +randomString+randomd+'aia@test.com'
            );
        return user;     
        
    }
    public static Account AIA_createAccount()
    {
        Account acct = new Account(); 
        acct.Name = 'Test10';
        acct.NumberOfEmployees = 45; // Num employees should always be <= 50
        acct.Sic = '0111';
        acct.EIN__c = '123456789'; // Has field validation, cannot be longer than 9 chars
        acct.BillingStreet = '1660 International Drive St. #518 Ste.500e ' +
        '1660 International Drive St. #518 Ste.500e' +
        '1660 International Drive St. #518 Ste.500e';
        acct.BillingCity = 'McLean123456789012345678902345678901';
        acct.BillingState = 'VA';
        acct.BillingPostalCode = '22102-4501'; // Has a validation rule in place 
        //acct.Billing_County_Code__c = 'MD';
        acct.Renewal_Anniversary_Month__c = 'Nov';
        acct.Account_Legal_Name__c= 'test Account';
        insert acct;
        return acct;
    }  
    
    public static Opportunity AIA_createopportunity(String AccId)
    {
        //T01 Start
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'Renewal';
        wpt.Active__c=true;
        insert wpt;*/
        //T01 End
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        opp.StageName = 'Proposal';
       // opp.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = AccId;
        opp.Market_Segment_New__c = '51-199';
        //opp.Business_type__c = 'Renewal';
         opp.Business_type__c = 'New';
        opp.Division__c = '51-199 New Business';
        opp.Legal_Account_Name_Verified__c =true;
        opp.Underwriting_Entity__c = 'NCAS';
        opp.Effective_Date__c =  Date.newInstance(2017,10,1);  // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        //opp.Workplan_Type__c = wpt.id;//T01
        insert opp;
        return opp;
     }
     //Added Opportunity with record type 200+
     public static Opportunity AIA_createopportunity1(String AccId)
    {
        //T01-- Start
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'Renewal';
        wpt.Active__c=true;
        insert wpt;*/
        //T01--End
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = AccId;
        opp.Market_Segment_New__c = '51-199';
        opp.Business_type__c = 'Renewal';
        opp.Division__c = '51-199 New Business';
        opp.Legal_Account_Name_Verified__c =true;
        opp.Underwriting_Entity__c = 'NCAS';
        opp.Effective_Date__c =  Date.newInstance(2018,10,1);  // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        //opp.Workplan_Type__c = wpt.id;//T01
        opp.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
        system.debug('opportunityis'+opp);
        system.debug('inserting opp');
        insert opp;
        system.debug('after insert opp');
        
        return opp;
     }
    //Added opportuntiy line item
    public static OpportunityLineItem AIA_createoppLineItem(String oppId){
        OpportunityLineItem oProd = new  OpportunityLineItem();
        oProd.Product_Sold__c = true;
        oProd.OpportunityId = oppId;
        oProd.Quantity =2.0;
        oProd.TotalPrice = 20;
        oProd.PricebookEntryId = '01u60000003AyCdAAK';
        insert oProd;
        return oProd;
    } 
  //Added Benefit Request Form status as sold.
    public static Benfit_Request_Form__c AIA_BenefitReqForm(String oppId,String accId){
    Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'Sold';
            //brf.Status__c = 'New';
            brf.Account__c = accId;
            brf.Opportunity__c = oppId;
            brf.Jurisdiction__c = 'MD';
            
            //t05 start 
            
            brf.EGWP_Picklist__c = 'No';
            brf.FlexLink_Picklist__c = 'No';
            brf.Request_Type__c = 'Prospect/New';
            brf.Control_Plan__c = '580';
            brf.Benefit_Period__c = 'Calendar';
            brf.Sales_Segment_Size__c = 'commercial 200-999';
            brf.Contract_Period__c = 'Standard - 12 Months';
            brf.Grandfathered_Status__c = 'Grandfathered';
            brf.Grandfathered_PPACA_Status__c = 'No';
            brf.Stop_Loss__c = 'CareFirst';
            brf.Funding_Arrangements__c = 'ASO';
            brf.Broker_Consultant_Compensation__c = 'Commission (%)';
            brf.Broker_Consultant_Amount__c = 5.0;
            
            brf.Identity_Protection__c = 'No';
            brf.Enrollment_Type__c = 'Parallel';
            
            
            //t05 end
            
          insert brf;
        Return brf;
    }
  //Added  AIA_Implementation__c test data
    public static  AIA_Implementation__c AIA_Impl(String oppId,String accId,String brfId){
        AIA_Implementation__c imp = new AIA_Implementation__c();
        imp.name__c = 'strName';
        imp.Description__c = 'strDescription';
        imp.Status__c ='Not Started';
        imp.Account__c = accId;
        imp.Parent_Account__c = accId; 
        imp.Benefit_Request_Form__c = brfId;
        imp.Opportunity__c = oppId;
            insert imp;
        Return imp;
    }
    
    public static Account updateAccount(String accountName)
    {
         // Create some test accounts
        Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account a = new Account();
        a.Name = accountName + '-' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_51;      
        a.Renewal_Anniversary_Month__c='Jan';
        insert a;
        a.Renewal_Anniversary_Month__c='Feb';
        update a;
        accountId = a.id;
        return a;
    }
    
    public static void createTestAccounts() {
        // Create some test accounts
        Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        List<Account> accList = new List<Account>();
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_51;
        accList.add(a);
        accountId = a.id;
        
        //Create the 2-50 default account for the 
        //Broker Activity Process
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
        a = new Account();
        a.Name = '2_50_DEFAULT_ACCOUNT';
        a.Type = 'Partner';
        a.RecordTypeId = rt_Acc_2_50;
        accList.add(a);        
        //Create an account with an entity id for the
        //Broker Activity process that has contacts with 
        //the same entity id
        a = new Account();
        a.Name = 'TestAccount1';
        a.Type = 'Partner';
        a.Entity_ID__c = '123456789';
        a.Entity_Type_AG__c = true;
        a.RecordTypeId = rt_acc_2_50;
        accList.add(a);
        //Create an account that won't have contacts
        //with matching entity id
        a = new Account();
        a.Name = 'TestAccount2';
        a.Type = 'Partner';
        a.Entity_ID__c = '123459999';
        a.Entity_Type_FSP__c = true;
        a.RecordTypeId = rt_acc_2_50;
        accList.add(a);
        //Create an account with an entity id for the
        //Broker Activity process that has contacts with 
        //the same entity id
        a = new Account();
        a.Name = 'TestAccount3';
        a.Type = 'Partner';
        a.Entity_ID__c = '555555555';
        a.Entity_Type_AG__c = true;
        a.RecordTypeId = rt_acc_2_50;
        accList.add(a);                 
        insert acclist;
        
        for(account ac: acclist){
            if ( ac.type=='Customer' ) accountid =ac.id;  
            if ( ac.Type == 'Partner' && ac.Name != '2_50_DEFAULT_ACCOUNT' ) account2_50_Default = ac.Id;
        }    
        
    }
    
    public static void createTestContacts() {
        // Create some test contacts
        // NOTE: Entity_Typed hard coded matches broker import record created in the
        //       CreateBrokerActivityData
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Id rt_Con_51 = QueryBase.getRecordtypeId('Contact', 'X51');        
        Insert new Contact[] { new Contact( AccountId = accountId, FirstName = 'ContactTester1', LastName = 'ContactTester1', Email = 'CT1@CT1.com', phone = '123-123-9991', Employer_Group_Portal__c = TRUE, RecordTypeId = rt_Con_51 ),
                               new Contact( AccountId = accountId, FirstName = 'ContactTester2', LastName = 'ContactTester2', Email = 'CT1@CT2.com', phone = '123-123-9992', Employer_Group_Portal__c = FALSE, RecordTypeId = rt_Con_51 ),
                               new Contact( AccountId = accountId, FirstName = 'ContactTester3', LastName = 'ContactTester3', Email = 'CT1@CT3.com', phone = '123-123-9993', Employer_Group_Portal__c = FALSE, RecordTypeId = rt_Con_51 ),
                               new Contact( AccountId = Account2_50_Default, FirstName = 'BrokerTest1',  LastName = 'BrokerTest1', Email = 'ba@ba1.com', phone = '123-123-3838', Employer_Group_Portal__c = FALSE, Entity_Id__c = '123456789', Entity_Type_SB__c=true, RecordTypeId = rt_Con_2_50 ),                            
                               new Contact( AccountId = Account2_50_Default, FirstName = 'BrokerTest2',  LastName = 'BrokerTest2', Email = 'ba@ba2.com', phone = '123-123-1039', Employer_Group_Portal__c = FALSE, Entity_Id__c = '777777777', Entity_Type_SB__c=true, RecordTypeId = rt_Con_2_50 )}; 
    }    
    
    public static void createTestOpportunities() {
        // Create some test opportunities
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity o = new Opportunity();
        o.Name = 'OppTest' + Date.Today();  
        o.AccountId = accountId;
        o.StageName = 'Proposal';
        o.CloseDate = Date.Today();
        o.System__c = 'Facets';
        o.Facets_Grp_Num__c = 'X23A';        
        o.FullServiceProducer__c = 'Direct';        
        oppList.add(o);                
       
        o.Name = 'OppTest' + Date.Today();  
        o.AccountId = accountId;
        o.StageName = 'Sold';
        o.Effective_Date__c = Date.Today();
        o.Contract_End_Date__c = Date.Today() + 365;
        o.CloseDate = Date.Today() - 15;
        o.System__c = 'Facets';
        o.Facets_Grp_Num__c = 'X23B';
        o.FullServiceProducer__c = 'Direct';
        oppList.add(o);
        
        insert o; 
    }    
    
    public static void createTestEngagements() {
        // Create some test Engagements

        Engagements__c test1 = new Engagements__c();
        test1.Name = 'Enagement Test1';
        // Get NCAS Picklist values
//        Schema.DescribeFieldResult F = Engagements__c.NCAS_Segment_Leader__c.getDescribe();
//        List<Schema.PicklistEntry> P = F.getPicklistValues();
        // Add first picklist value to field
//        test1.NCAS_Segment_Leader__c = P[0].getValue();
        
        insert test1;
        
        //
        Engagements__c test2 = new Engagements__c();
        test2.Name = 'Training Enagement Test2';
        // Get NCAS Picklist values
//        Schema.DescribeFieldResult F2 = Engagements__c.NCAS_Segment_Leader__c.getDescribe();
//        List<Schema.PicklistEntry> P2 = F2.getPicklistValues();
        // Add first picklist value to field
//        test2.NCAS_Segment_Leader__c = P2[0].getValue();
        
        insert test2;      
    }
    
       
    /*******************************************
     * Test Data for the Enrollment Process
     ******************************************/    
    public static String createEnrollmentTestData() {
        List<Account> accountList = new List<Account>();
        Set<id> OppIds = new Set<id>(); 
        
        /* Get Dates for testing 
         *  Since we only look at opportunities with effective date from last month
         * back 12 months we need to have our test data set up from last month
        */
        Date LastMonth = Date.today().toStartofMonth()-1; // Get last month
        String MM = String.valueOf(LastMonth.month());
        if ( LastMonth.month() < 10 ) {
            MM = ('0' + String.valueOf(LastMonth.month())); 
        }
        String YYYY = String.valueOf(LastMonth.Year());
        String RptDt = YYYY + MM;               // Format CCYYMM
        String RunDt = Date.Today().format() + ' 5:00:00'; // Format MM/DD/CCYYY HH:MM:SS           
        
       
        /* create user */
        User salesUser = [SELECT Name, Lead_Rep_Number__c 
                          FROM User 
                          WHERE Lead_Rep_Number__c != null Limit 1];
        /* create accounts */  
        Account testacct1 = new Account();
        testacct1.Name = 'TestAccount4';
        testacct1.Type = 'Customer';
        accountList.add(testacct1);
        
        Account testacct2 = new Account();
        testacct2.Name = 'TestAccount44';
        testacct2.Type = 'Partner';
        accountList.add(testacct2);
        
        Account testacct3 = new Account();
        testacct3.Name = 'TestAccount12';
        testacct3.Type = 'Customer';
        accountList.add(testacct3);
        
        Account testacct4 = new Account();
        testacct4.Name = 'TestAccount32';
        testacct4.Type = 'Customer';
        accountList.add(testacct4);
        
        Account testacct5 = new Account();
        testacct5.Name = 'TestAccount75';
        testacct5.Type = 'Partner';
        accountList.add(testacct5);
        
        Account testacct6 = new Account();
        testacct6.Name = 'TestAccount85';
        testacct6.Type = 'Customer';
        accountList.add(testacct6);
        
        insert accountList;        


        /* create opportunities */        
        List<Opportunity> testOppsList = new List<Opportunity>();      
        
        // Opportunity has a NASCO System and an associated NASCO group ID
        Opportunity testOpp1 = new Opportunity();
        testOpp1.Name = 'Test Opportunity1';
        testopp1.AccountId = testacct1.Id;
        testOpp1.StageName ='Proposal';    
        testOpp1.CloseDate = Date.today()-90;
        testOpp1.SBU__c = 'Small/Medium';
        testopp1.Market_Segment_New__c = '51-199';
        testopp1.Business_type__c = 'Renewal';
        testopp1.Division__c = '51-199 Renewals';   
        testopp1.Underwriting_Entity__c = 'MD';
        testopp1.Lead_Rep_Name_User__c = salesUser.Id;
        testOpp1.GeneralProducer__c = 'Direct'; 
        testOpp1.System__c = 'NASCO';    
        testOpp1.NASCO_Acct_ID__c = '12201';   
        testOpp1.Related_Products_Sold__c = 'Test';       
        Date effectiveDate = testOpp1.CloseDate.addDays(35);        
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        Date contractEndDate = testOpp1.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014              

        testOppsList.add(testOpp1);
//        OppIds.add(testOpp1.id);

        
        // Opportunity has a Facets System and an associated Facets Group ID       
        Opportunity testOpp2 = new Opportunity();
        testOpp2.Name = 'Test Opportunity12';
        testopp2.AccountId = testacct3.Id;
        testOpp2.StageName ='Proposal'; 
        testOpp2.CloseDate = Date.today()-70;
        testOpp2.SBU__c = 'Large';
        testopp2.Market_Segment_New__c = '200-999';
        testopp2.Business_type__c = 'New';
        testopp2.Division__c = 'Labor Affairs';   
        testopp2.Underwriting_Entity__c = 'MD';
        testopp2.Lead_Rep_Name_User__c = salesUser.Id;
        testOpp2.GeneralProducer__c = 'Direct'; 
        testOpp2.System__c = 'Facets';    
        testOpp2.Facets_Grp_Num__c = 'CE12';
        testOpp2.Related_Products_Sold__c = 'Test';      
        effectiveDate = testOpp2.CloseDate.addDays(35);        
        testOpp2.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        contractEndDate = testOpp2.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp2.Contract_End_Date__c = contractEndDate;  
        testOpp2.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014          

        testOppsList.add(testOpp2);
//        OppIds.add(testOpp2.id); 

        // Opportunity has a Network Lease System and an associated Network Lease ID         
        Opportunity testOpp3 = new Opportunity();
        testOpp3.Name = 'Test Opportunity44';
        testopp3.AccountId = testacct2.Id;
        testOpp3.StageName ='Proposal';   
        testOpp3.CloseDate = Date.today()-90;
        testOpp3.SBU__c = 'Small/Medium';
        testopp3.Market_Segment_New__c = '51-199';
        testopp3.Business_type__c = 'Renewal';
        testopp3.Division__c = '51-199 Renewals';   
        testopp3.Underwriting_Entity__c = 'MD';
        testopp3.Lead_Rep_Name_User__c = salesUser.Id;
        testOpp3.GeneralProducer__c = 'Direct'; 
        testOpp3.System__c = 'Network Lease';    
        testOpp3.Net_Lease_Group_ID__c = 'NWL4444'; 
        testOpp3.Type = 'Network Leasing Local';  
        testOpp3.Related_Products_Sold__c = 'Test';      
        effectiveDate = testOpp3.CloseDate.addDays(35);        
        testOpp3.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        contractEndDate = testOpp3.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp3.Contract_End_Date__c = contractEndDate;
        testOpp3.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014           
                 
        testOppsList.add(testOpp3);
//        OppIds.add(testOpp3.id); 
        
        
        // Opportunity has a Facets System and an associated Facets Group ID    
        Opportunity testOpp4 = new Opportunity();
        testOpp4.Name = 'Test Opportunity32';
        testopp4.AccountId = testacct4.Id;
        testOpp4.StageName ='Proposal';   
        testOpp4.CloseDate = Date.today()-150;
        testOpp4.SBU__c = 'Small/Medium';
        testopp4.Market_Segment_New__c = '51-199';
        testopp4.Business_type__c = 'Renewal';
        testopp4.Division__c = '51-199 Renewals';   
        testopp4.Underwriting_Entity__c = 'MD';
        testopp4.Lead_Rep_Name_User__c = salesUser.Id;
        testOpp4.GeneralProducer__c = 'Direct'; 
        testOpp4.System__c = 'Facets';    
        testOpp4.Facets_Grp_Num__c = 'YZ32';   
        testOpp4.Related_Products_Sold__c = 'Test';      
        effectiveDate = testOpp4.CloseDate.addDays(35);        
        testOpp4.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        contractEndDate = testOpp4.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp4.Contract_End_Date__c = contractEndDate;
        testOpp4.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014            
                
        testOppsList.add(testOpp4);
//        OppIds.add(testOpp4.id);
        
        // Adding another opportunity to the same Account to test the rollup summary
        // capability of the Enrollment_ContractSummary classes sort method that is 
        // in the Enrollment_ContractSummaryHelperClass
        // Opportunity has a Facets System and an associated Facets Group ID    
        Opportunity testOpp4_2 = new Opportunity();
        testOpp4_2.Name = 'Test Opportunity32';
        testopp4_2.AccountId = testacct4.Id;
        testOpp4_2.StageName ='Proposal';   
        testOpp4_2.CloseDate = Date.today()-150;
        testOpp4_2.SBU__c = 'Small/Medium';
        testopp4_2.Market_Segment_New__c = '51-199';
        testopp4_2.Business_type__c = 'Renewal';
        testopp4_2.Division__c = '51-199 Renewals';   
        testopp4_2.Underwriting_Entity__c = 'MD';
        testopp4_2.Lead_Rep_Name_User__c = salesUser.Id;
        testOpp4_2.GeneralProducer__c = 'Direct'; 
        testOpp4_2.System__c = 'Facets';    
        testOpp4_2.Facets_Grp_Num__c = 'YZ3A';   
        testOpp4_2.Related_Products_Sold__c = 'Test';       
        effectiveDate = testOpp4_2.CloseDate.addDays(35);        
        testOpp4_2.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        contractEndDate = testOpp4_2.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp4_2.Contract_End_Date__c = contractEndDate; 
        testOpp4_2.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014             
                
        testOppsList.add(testOpp4_2);
//        OppIds.add(testOpp4_2.id);        
        
        
        // Opportunity has a LuminX System and an associated LuminX Group ID  
        Opportunity testOpp5 = new Opportunity();
        testOpp5.Name = 'Test Opportunity75';
        testopp5.AccountId = testacct5.Id;
        testOpp5.StageName ='Proposal';   
        testOpp5.CloseDate = Date.today()-30;
        testOpp5.SBU__c = 'Small/Medium';
        testopp5.Market_Segment_New__c = '51-199';
        testopp5.Business_type__c = 'Renewal';
        testopp5.Division__c = '51-199 Renewals';   
        testopp5.Underwriting_Entity__c = 'MD';
        testopp5.Lead_Rep_Name_User__c = salesUser.Id;
        testOpp5.GeneralProducer__c = 'Direct'; 
        testOpp5.System__c = 'LuminX';    
        testOpp5.Luminex__c = 'WEE75';  
        testOpp5.Related_Products_Sold__c = 'Test';       
        effectiveDate = testOpp5.CloseDate.addDays(35);        
        testOpp5.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        contractEndDate = testOpp5.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp5.Contract_End_Date__c = contractEndDate;  
        testOpp5.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014            
                 
        testOppsList.add(testOpp5);
//        OppIds.add(testOpp5.id);   
               
        
       // Opportunity has a National Alliance System and an associated National Alliance Group ID  
        Opportunity testOpp6 = new Opportunity();
        testOpp6.Name = 'Test Opportunity85';
        testopp6.AccountId = testacct6.Id;
        testOpp6.StageName ='Proposal';   
        testOpp6.CloseDate = Date.today()-30;
        testOpp6.SBU__c = 'Small/Medium';
        testopp6.Market_Segment_New__c = '51-199';
        testopp6.Business_type__c = 'Renewal';
        testopp6.Division__c = '51-199 Renewals';   
        testopp6.Underwriting_Entity__c = 'MD';
        testopp6.Lead_Rep_Name_User__c = salesUser.Id;
        testOpp6.GeneralProducer__c = 'Direct'; 
        testOpp6.System__c = 'National Alliance';    
        testOpp6.National_Alliance_ID__c = '12345';  
        testOpp6.Related_Products_Sold__c = 'Test';    
        effectiveDate = testOpp6.CloseDate.addDays(35);        
        testOpp6.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        contractEndDate = testOpp6.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp6.Contract_End_Date__c = contractEndDate;  
        testOpp6.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014            
                 
        testOppsList.add(testOpp6);
//        OppIds.add(testOpp6.id);       

        // Perform the Insert of the records just built above        
        Insert testOppsList;
        
        // add related opportunity line item data to the opps just inserted
        for ( Opportunity rec : testOppsList ) {
            oppIds.add(rec.id);
            InsertOpportunityLineItems(rec.id);
        }        
    
        // Update the Stage to sold
        // Have to do this because of VR18
        for ( Opportunity rec : testOppsList ) {
            rec.Incumbent_Successor__c = 'CareFirst';
            rec.StageName = 'Sold';
        }
  
        update testOppsList;

        
        //Product not available in the Standard Price Book and Product is not Active        
        Product2 testProd11 = new Product2();
        testProd11.name = 'HM Select';  
        testProd11.IsActive = False;
        insert testProd11;


        /****************************************
         * Insert some related enrollment records
         ****************************************/        
        List<Enrollment__c> enrList = new List<Enrollment__c>();  
      
        for ( Opportunity opp : [ SELECT id, Account.Name, System__c FROM Opportunity WHERE Id =:OppIds ] ) { 
            Enrollment__c e = new Enrollment__c();
            e.Opportunity__c = opp.id;         
            e.Account_Number__c = 'aed5';        
            e.System__c =  opp.System__c; 
            e.Contracts__c = 100;            
            e.Processed_Type__c = 'M';
            e.Risk__c = 'Risk';
            e.Rpt_dt__c = RptDt;
            e.Run_Dt__c = RunDt;
            e.Product__c = 'BC Advantage';   
            e.Latest_Enrollment__c = 'Y';          
            enrList.add(e); 
        }
        
    
        if  ( enrList.size() > 0 ) {        
            insert enrList;             
        } 


        /* create sample Enrollment Import */
        List <Enrollment_Import__c> enrollmentImportList = new List<Enrollment_Import__c>();
        for(integer i = 0; i<91; i++){
            Enrollment_Import__c EnImp = new Enrollment_Import__c();
    
            //Condition 1 - Happy Path: Correct Account Number and matching System, Correct Opportunity and Active Product. 
            if(i<10){
                EnImp.Account_Name__c = 'TestAccount'+ i;
                EnImp.Account_Number__c = '1220'+i;        
                EnImp.System__c = 'NASCO';
                EnImp.Contracts__c = 50+i;
                EnImp.Processed__c = FALSE;
                EnImp.Processed_Type__c = 'M';
                EnImp.Risk__c = 'Non-Risk';
                EnImp.Rpt_dt__c = RptDt;
                EnImp.Run_Dt__c = RunDt;
                EnImp.SFDC_Product__c = 'BC Advantage';               
                enrollmentImportList.add(EnImp);
            }
    
            //Condition 2: Correct Account Number and matching System, Correct Opportunity and Unavailable Product in system.
            else if(i>10 && i<21){
                EnImp.Account_Name__c = 'TestAccount'+i;
                EnImp.Account_Number__c = 'CE'+i;        
                EnImp.System__c = 'Facets';
                EnImp.Contracts__c = 50+i;
                EnImp.Processed__c = FALSE;
                EnImp.Processed_Type__c = 'M';
                EnImp.Risk__c = 'Non-Risk';
                EnImp.Rpt_dt__c = RptDt;
                EnImp.Run_Dt__c = RunDt;
                EnImp.SFDC_Product__c = 'Dangerous Product';             
                enrollmentImportList.add(EnImp);
            }
    
            //Condition 3: Opportunities with no matching System and Account Numbers.    
            else if (i>20 && i<31){
                EnImp.Account_Name__c = 'TestAccount'+i;
                EnImp.Account_Number__c = 'ABCDE';  
                EnImp.System__c = 'LuminX';
                EnImp.Contracts__c = 50+i;
                EnImp.Processed__c = FALSE;
                EnImp.Processed_Type__c = 'M';
                EnImp.Risk__c = 'Non-Risk';
                EnImp.Rpt_dt__c = RptDt;
                EnImp.Run_Dt__c = RunDt;
                EnImp.SFDC_Product__c = 'HM Select';  
                enrollmentImportList.add(EnImp);
            }  
            
            //Condition 4: Opportunity records that have already been processed.                
            else if (i>30 && i<41){
                EnImp.Account_Name__c = 'TestAccount'+i;
                EnImp.Account_Number__c = 'YZ'+i;        
                EnImp.System__c = 'Facets';
                EnImp.Contracts__c = 50+i;
                EnImp.Processed__c = TRUE;
                EnImp.Processed_Type__c = 'M';
                EnImp.Risk__c = 'Non-Risk';
                EnImp.Rpt_dt__c = RptDt;
                EnImp.Run_Dt__c = RunDt;
                EnImp.SFDC_Product__c = 'BC Advantage';      
                enrollmentImportList.add(EnImp);
            } 
            
            //Condition 5: Correct Account Number and matching Network Lease System, Correct Opportunity and Unavailable Product in system.              
            else if (i>40 && i<51){
                EnImp.Account_Name__c = 'TestAccount'+i;
                EnImp.Account_Number__c = 'NWL44'+i;        
                EnImp.System__c = 'Network Lease';
                EnImp.Contracts__c = 0+i;
                EnImp.Processed__c = FALSE;
                EnImp.Processed_Type__c = 'M';
                EnImp.Risk__c = 'Non-Risk';
                EnImp.Rpt_dt__c = RptDt;
                EnImp.Run_Dt__c = RunDt;
                EnImp.SFDC_Product__c = 'UPNF';             
                enrollmentImportList.add(EnImp);
            }
            
            //Condition 6: Accounts don't exist in Salesforce and all records with i>50 will be kicked to the Enrollment Recycle Object.          
            else if (i>50 && i<61){
                EnImp.Account_Name__c = 'TestAccountXX'+i;
                EnImp.Account_Number__c = 'XYZ'+i;        
                EnImp.System__c = 'Facets';
                EnImp.Contracts__c = 35+i;
                EnImp.Processed__c = FALSE;
                EnImp.Processed_Type__c = 'M';
                EnImp.Risk__c = 'Non-Risk';
                EnImp.Rpt_dt__c = RptDt;
                EnImp.Run_Dt__c = RunDt;
                EnImp.SFDC_Product__c = 'BC Advantage';           
                enrollmentImportList.add(EnImp);
            }
            
            //Condition 7: System doesn't exist in Salesforce.          
            else if (i>60 && i<71){
                EnImp.Account_Name__c = 'TestAccountXY'+i;
                EnImp.Account_Number__c = 'XYZ'+i;        
                EnImp.System__c = 'WRONG SYSTEM';
                EnImp.Contracts__c = 50+i;
                EnImp.Processed__c = FALSE;
                EnImp.Processed_Type__c = 'M';
                EnImp.Risk__c = 'Risk';
                EnImp.Rpt_dt__c = RptDt;
                EnImp.Run_Dt__c = RunDt;
                EnImp.SFDC_Product__c = 'Unavailable Product';             
                enrollmentImportList.add(EnImp);
            }
            
            //Condition 8: Happy Path for LuminX System.          
            else if (i>70 && i<81){
                EnImp.Account_Name__c = 'TestAccount'+i;
                EnImp.Account_Number__c = 'WEE'+i;        
                EnImp.System__c = 'LuminX';
                EnImp.Contracts__c = 1+i;
                EnImp.Processed__c = FALSE;
                EnImp.Processed_Type__c = 'M';
                EnImp.Risk__c = 'Risk';
                EnImp.Rpt_dt__c = RptDt;
                EnImp.Run_Dt__c = RunDt;
                EnImp.SFDC_Product__c = 'BC Advantage';            
                enrollmentImportList.add(EnImp);
            }
            //Condition 8: Happy Path for National Alliance System.          
            else if (i>80 && i<91){
                EnImp.Account_Name__c = 'TestAccount'+i;
                EnImp.Account_Number__c = '1234'+i;        
                EnImp.System__c = 'National Alliance';
                EnImp.Contracts__c = 1+i;
                EnImp.Processed__c = FALSE;
                EnImp.Processed_Type__c = 'M';
                EnImp.Risk__c = 'Non-Risk';
                EnImp.Rpt_dt__c = RptDt;
                EnImp.Run_Dt__c = RunDt;
                EnImp.SFDC_Product__c = 'BC Advantage';            
                enrollmentImportList.add(EnImp);            
            }
            
        }
           
        if (enrollmentImportList.size() > 0){     
            insert enrollmentImportList;
        }        
  
        //Create Enrollment recycle test data  
        List<Enrollment_Recycle__c> erList = new List<Enrollment_Recycle__c>();  
        
        for ( Opportunity opp : [ SELECT Account.Name, System__c FROM Opportunity WHERE Id =:OppIds ] ) { 
            Enrollment_Recycle__c er = new Enrollment_Recycle__c();           
            er.Account_Name__c = opp.Account.Name;
            er.Account_Number__c = 'aed5';        
            er.System__c =  opp.System__c; 
            er.Contracts__c = 100;            
            er.Processed_Type__c = 'M';
            er.Error_Message__c = 'Missing Facets Id';
            er.Opportunity_Name__c = null;
            er.Risk__c = 'Risk';
            er.Rpt_dt__c = RptDt;
            er.Run_Dt__c = RunDt;
            er.Sales_Rep__c = 'Tester';
            er.SFDC_Product__c = 'BC Advantage'; 
            
            if ( opp.System__c == 'Facets' ) er.Error_Number__c = '0004';
            if ( opp.System__c == 'LuminX' ) er.Error_Number__c = '0005';
            if ( opp.System__c == 'NASCO' ) er.Error_Number__c = '0006';
            if ( opp.System__c == 'Network Lease' ) er.Error_Number__c = '0007';
            if ( opp.System__c == 'National Alliance' ) er.Error_Number__c = '0008';
            
            erList.add(er); 
        } 

        // Create a record that has no known product
        Enrollment_Recycle__c er = new Enrollment_Recycle__c();           
        er.Account_Name__c = 'Any Account';
        er.Account_Number__c = 'CE12';        
        er.System__c =  'Facets'; 
        er.Contracts__c = 100;            
        er.Processed_Type__c = 'M';
        er.Error_Message__c = 'No Salesforce Product found! Contact sfdcSupport@carefirst.com';
        er.Error_Number__c = '0001';
        er.Opportunity_Name__c = null;
        er.Risk__c = 'Risk';
        er.Rpt_dt__c = RptDt;
        er.Run_Dt__c = RunDt;
        er.Sales_Rep__c = 'Tester';
        er.SFDC_Product__c = 'NOTFOUND';                 
        erList.add(er);
        
        
        // Create a record that has no known system
        Enrollment_Recycle__c er2 = new Enrollment_Recycle__c();           
        er2.Account_Name__c = 'Any Account';
        er2.Account_Number__c = 'CE12';        
        er2.System__c =  'NoSuchSystem'; 
        er2.Contracts__c = 100;            
        er2.Processed_Type__c = 'M';
        er2.Error_Message__c = 'System not found in Salesforce';
        er2.Error_Number__c = '0002';
        er2.Opportunity_Name__c = null;
        er2.Risk__c = 'Risk';
        er2.Rpt_dt__c = RptDt;
        er2.Run_Dt__c = RunDt;
        er2.Sales_Rep__c = 'Tester';
        er2.SFDC_Product__c = 'BC Advantage';                 
        erList.add(er2);        

        if  ( erList.size() > 0 ) {         
            insert erList; 
        }
        return RptDt;               
    } //END public static void createEnrollmentTestData()
    
    public static void InsertOpportunityLineItems(Id oppId) {
        PricebookEntry[] priceBookEntry = [ Select p.Name,  p.Id , p.IsActive From PricebookEntry p  where p.IsActive = true limit 3];
        List<OpportunityLineItem> oppProducts = new List<OpportunityLineItem>() ;
        OpportunityLineItem oppProduct1 = new OpportunityLineItem();
        oppProduct1.OpportunityId = oppId;
        oppProduct1.PricebookEntryId = priceBookEntry[0].Id;
        oppProduct1.Product_Sold__c = false;
        oppProduct1.Quantity = 10.00 ;
        oppProduct1.TotalPrice = 100.00;
        oppProducts.add(oppProduct1) ;
        
        OpportunityLineItem oppProduct2 = new OpportunityLineItem();
        oppProduct2.OpportunityId = oppId;
        oppProduct2.PricebookEntryId = priceBookEntry[1].Id;
        oppProduct2.Product_Sold__c = true;
        oppProduct2.Quantity = 10.00 ;
        oppProduct2.TotalPrice = 100.00;
        oppProducts.add(oppProduct2) ;
        
        OpportunityLineItem oppProduct3 = new OpportunityLineItem();
        oppProduct3.OpportunityId = oppId;
        oppProduct3.PricebookEntryId = priceBookEntry[2].Id;
        oppProduct3.Product_Sold__c = true;
        oppProduct3.Quantity = 10.00 ;
        oppProduct3.TotalPrice = 100.00;
        oppProducts.add(oppProduct3) ;
             
        insert oppProducts;
    } 
    
    
    
    // Broker_Import__c Data Build     
    public static void CreateBrokerActivityData() {      
        
        // Create Broker Import Data
        List <Broker_Import_2_50__c> biImportList = new List<Broker_Import_2_50__c>();
        Broker_Import_2_50__c bi = new Broker_Import_2_50__c();
        //AG Entity Type
        bi.Account_Name__c = 'TestAccount1';
        bi.Entity_Id__c = '123456789';
        bi.Entity_Type__c = 'AG';
        bi.Phone__c = '123-456-1781';        
        bi.address_Line__c = '123 Happy Lane';  
        bi.Processed__c = FALSE;                              
        biImportList.add(bi);
        //FSP Entity Type same entity id as above
        bi = new Broker_Import_2_50__c();
        bi.Account_Name__c = 'TestAccount1';
        bi.Entity_Id__c = '123456789';
        bi.Entity_Type__c = 'FSP';
        bi.Phone__c = '123-456-0789';        
        bi.address_Line__c = 'SB Happy Lane';  
        bi.Processed__c = FALSE;                              
        biImportList.add(bi);   
        //SB Entity Type same Entity Id as above
        //and mathing an account we created above
        bi = new Broker_Import_2_50__c();
        bi.First_Name__c = 'SB1';
        bi.Entity_Id__c = '123456789';
        bi.Entity_Type__c = 'SB';
        bi.Phone__c = '123-456-2789';        
        bi.address_Line__c = 'SB Happy Lane';  
        bi.Processed__c = FALSE;                              
        biImportList.add(bi); 
        //This record is duplicated from the above record
        //this should now be an update to the Contact object
        bi = new Broker_Import_2_50__c();
        bi.First_Name__c = 'SB1';
        bi.Entity_Id__c = '123456789';
        bi.Entity_Type__c = 'SB';
        bi.Phone__c = '123-456-7789';        
        bi.address_Line__c = 'SB Happy Lane';  
        bi.Processed__c = FALSE;                              
        biImportList.add(bi);         
        //Create another Entity Type 'SB to test
        //where a Contact does not exists in SF
        //and an account with matching entity id
        //also does not exist
        bi = new Broker_Import_2_50__c();
        bi.First_Name__c = 'SB2';
        bi.Entity_Id__c = '666666666';
        bi.Entity_Type__c = 'SB';
        bi.Phone__c = '678-456-4123';        
        bi.address_Line__c = 'SB2 Happy Lane';  
        bi.Processed__c = FALSE;                              
        biImportList.add(bi); 
        //Create an entity id that matches
        //an existing contact record
        bi = new Broker_Import_2_50__c();
        bi.First_Name__c = 'SB2';
        bi.Entity_Id__c = '777777777';
        bi.Entity_Type__c = 'SB';
        bi.Phone__c = '678-456-9123';        
        bi.address_Line__c = 'SB2 Happy Lane';  
        bi.Processed__c = FALSE;                              
        biImportList.add(bi);    
        //Create a contact that has a matching Account
        //with the same entity id but make sure
        //we don't have an existing contact with the same
        // matching entity id in sf
        //Create an entity id that matches
        //an existing contact record
        bi = new Broker_Import_2_50__c();
        bi.First_Name__c = 'SB2';
        bi.Entity_Id__c = '555555555';
        bi.Entity_Type__c = 'SB';
        bi.Phone__c = '678-456-1233';        
        bi.address_Line__c = 'SB2 Happy Lane';  
        bi.Processed__c = FALSE;                              
        biImportList.add(bi); 
        //Setup for default 2-50 account record
        bi = new Broker_Import_2_50__c();        
        bi.Account_Name__c = 'TestAccount';
        bi.Entity_Id__c = '123456780';
        bi.Entity_Type__c = 'AG';
        bi.Phone__c = '123-456-789';        
        bi.address_Line__c = 'AG Happy Lane';  
        bi.Processed__c = FALSE;                              
        biImportList.add(bi); 
        insert biImportList;
    }   
     // Broker_Import__c Data Build For Deletion   
    // Set Processed Flag = True 
    public static void DeleteBrokerActivityData() {      
        
        // Create Broker Import Data
        List <Broker_Import_2_50__c> biImportList = new List<Broker_Import_2_50__c>();
        Broker_Import_2_50__c bi = new Broker_Import_2_50__c();
        //AG Entity Type
        bi.Account_Name__c = 'TestAccount1';
        bi.Entity_Id__c = '123456789';
        bi.Entity_Type__c = 'AG';
        bi.Phone__c = '123-456-1781';        
        bi.address_Line__c = '123 Happy Lane';  
        bi.Processed__c = true;                              
        biImportList.add(bi);
        //FSP Entity Type same entity id as above
        bi = new Broker_Import_2_50__c();
        bi.Account_Name__c = 'TestAccount1';
        bi.Entity_Id__c = '123456789';
        bi.Entity_Type__c = 'FSP';
        bi.Phone__c = '123-456-0789';        
        bi.address_Line__c = 'SB Happy Lane';  
        bi.Processed__c = true;                              
        biImportList.add(bi);   
        //SB Entity Type same Entity Id as above
        //and matching an account we created above
        bi = new Broker_Import_2_50__c();
        bi.First_Name__c = 'SB1';
        bi.Entity_Id__c = '123456789';
        bi.Entity_Type__c = 'SB';
        bi.Phone__c = '123-456-2789';        
        bi.address_Line__c = 'SB Happy Lane';  
        bi.Processed__c = true;                              
        biImportList.add(bi); 
        //This record is duplicated from the above record
        //this should now be an update to the Contact object
        bi = new Broker_Import_2_50__c();
        bi.First_Name__c = 'SB1';
        bi.Entity_Id__c = '123456789';
        bi.Entity_Type__c = 'SB';
        bi.Phone__c = '123-456-7789';        
        bi.address_Line__c = 'SB Happy Lane';  
        bi.Processed__c = true;                              
        biImportList.add(bi);         
        //Create another Entity Type 'SB to test
        //where a Contact does not exists in SF
        //and an account with matching entity id
        //also does not exist
        bi = new Broker_Import_2_50__c();
        bi.First_Name__c = 'SB2';
        bi.Entity_Id__c = '666666666';
        bi.Entity_Type__c = 'SB';
        bi.Phone__c = '678-456-4123';        
        bi.address_Line__c = 'SB2 Happy Lane';  
        bi.Processed__c = true;                              
        biImportList.add(bi); 
        //Create an entity id that matches
        //an existing contact record
        bi = new Broker_Import_2_50__c();
        bi.First_Name__c = 'SB2';
        bi.Entity_Id__c = '777777777';
        bi.Entity_Type__c = 'SB';
        bi.Phone__c = '678-456-9123';        
        bi.address_Line__c = 'SB2 Happy Lane';  
        bi.Processed__c = true;                              
        biImportList.add(bi);    
        //Create a contact that has a matching Account
        //with the same entity id but make sure
        //we don't have an existing contact with the same
        // matching entity id in sf
        //Create an entity id that matches
        //an existing contact record
        bi = new Broker_Import_2_50__c();
        bi.First_Name__c = 'SB2';
        bi.Entity_Id__c = '555555555';
        bi.Entity_Type__c = 'SB';
        bi.Phone__c = '678-456-1233';        
        bi.address_Line__c = 'SB2 Happy Lane';  
        bi.Processed__c = true;                              
        biImportList.add(bi); 
        //Setup for default 2-50 account record
        bi = new Broker_Import_2_50__c();        
        bi.Account_Name__c = 'TestAccount';
        bi.Entity_Id__c = '123456780';
        bi.Entity_Type__c = 'AG';
        bi.Phone__c = '123-456-789';        
        bi.address_Line__c = 'AG Happy Lane';  
        bi.Processed__c = true;                              
        biImportList.add(bi); 
        insert biImportList;
    }   
    // Ashish Ojha Changes
    // Data Build for Enrollment 2-50
    public static void Create_Enrolment_Import_2_50_Data() {
        //createTestAccounts();
        
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
        Id rt_con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_2_50;
        a.AccountNumber = '12345';
        a.Facets_Account_Number__c = 'Abc1';
        a.Entity_Id__c = '12345566';
        a.sic = 'SicTest';
        a.Rating_State__c = 'MD';
        
        insert a;
        
        Account b = New Account();
        b.Name = 'SomeTest1' + Date.Today();
        b.Type = 'Customer';
        b.RecordTypeId = rt_acc_2_50;
        b.AccountNumber = '012345';
        b.Facets_Account_Number__c = 'WXY1';
        b.Entity_Id__c = '12345548';
        b.sic = 'SicTest';
        b.Rating_State__c = 'MD';
        insert b;
        
        Account c = New Account();
        c.Name = 'SomeTest2' + Date.Today();
        c.Type = 'Partner';
        c.entity_id__c = '12345678';
        c.RecordTypeId = rt_acc_2_50;
        c.AccountNumber = '012345';
        c.Facets_Account_Number__c = 'PQRS';
        c.sic = 'SicTest';
        c.Rating_State__c = 'MD';
        insert c;
        
        Contact con = new Contact();
        con.LastName = 'Test';
        con.RecordTypeId = rt_con_2_50;
        con.Entity_Id__c = '1234567898';
        insert con;
        
        //Create Enrollment_Import_2_50 Data
        List<Enrollment_Import_2_50__c> enrList2_50 = new List<Enrollment_Import_2_50__c>();
        Enrollment_Import_2_50__c enrl              = new Enrollment_Import_2_50__c();
        enrl.Account_Effective_Date__c              = system.today();
        enrl.Account_Number__c                      = '1111';
        enrl.Account_Name__c                        = 'Test';
        enrl.Sic__c                                 = 'SicTest';
        enrl.Rating_State__c                        = 'MD';
        enrl.AE_ID__c                               = 'test';
        enrl.AE_Name__c                             = 'test';
        enrl.External_Key__c                        = '1234test';
        enrl.Processed__c                           = false;
        enrl.Term_Date__c                           = system.today();
        enrl.Contracts__c                           = 23;
        enrl.Processed_Type__c                      = 't';
        enrl.Risk__c                                = 'tst';
        enrl.Rpt_dt__c                              = '201412';
        enrl.Run_Dt__c                              = '201221';
        enrl.SFDC_Product__c                        = 'test';
        enrl.System__c                              = 'atest';
        enrl.AG_Id__c                               = '12345548';
        enrl.GP_Id__c                               = '12345566';
        enrl.Contract_Effective_Date__c             = system.today().addDays(-300);
        enrl.Renewal_date__C                        = system.today().addDays(100);
        enrList2_50.add(enrl);
        
        enrl                                        = new Enrollment_Import_2_50__c();
        enrl.Account_Effective_Date__c              = system.today();
        enrl.GP_Id__c                               = '12345566';
        enrl.Account_Number__c                      = '3333';
        enrl.Account_Name__c                        = 'Test';
        enrl.Sic__c                                 = 'SicTest';
        enrl.Rating_State__c                        = 'MD';
        enrl.AE_ID__c                               = 'test';
        enrl.AE_Name__c                             = 'test';
        enrl.Processed__c                           = false;
        enrl.External_Key__c                        = '1234test1';
        enrl.Contracts__c                           = 23;
        enrl.Processed_Type__c                      = 't';
        enrl.Risk__c                                = 'tst';
        enrl.Rpt_dt__c                              = '201411';
        enrl.Run_Dt__c                              = '201221';
        enrl.SFDC_Product__c                        = 'test';
        enrl.System__c                              = 'atest';
        enrl.Contract_Effective_Date__c             = system.today().addDays(-300);
        enrl.Renewal_date__C                        = system.today().addDays(100);
        enrList2_50.add(enrl);
        
         enrl                                       = new Enrollment_Import_2_50__c();
        enrl.Account_Effective_Date__c              = system.today();
        enrl.Account_Number__c                      = '2222';
        enrl.Account_Name__c                        = 'Test';
        enrl.AE_ID__c                               = 'test';
        enrl.AE_Name__c                             = 'test';
        enrl.External_Key__c                        = '1234test';
        enrl.Processed__c                           = false;
        enrl.Term_Date__c                           = system.today();
        enrl.Contracts__c                           = 23;
        enrl.Processed_Type__c                      = 't';
        enrl.Risk__c                                = 'tst';
        enrl.Rpt_dt__c                              = '201412';
        enrl.Run_Dt__c                              = '201221';
        enrl.SFDC_Product__c                        = 'test';
        enrl.System__c                              = 'atest';
        enrl.Ag_id__c                               = '12345678';
        enrl.FSP_id__c                              = '12345678';
        enrl.GP_id__c                               = '12345678';
        enrl.sic__c                                 = 'SicTest';
        enrl.Rating_State__c                        = 'MD';
        enrl.Processed_Opportunity__c               = false;
        enrl.SB_id__c                               = '1234567898';
        enrl.Contract_Effective_Date__c             = system.today().addDays(-300);
        enrl.Renewal_date__C                        = system.today().addDays(100);
        enrList2_50.add(enrl);

      
        
        insert enrList2_50;
    }
    
     // Ashish Ojha Changes
   /*
    // Data Build for Enrollment__c
    public static void Create_Enrollment_2_50_Data() {
        //Create Enrollment_2_50 Data        
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_2_50;
        a.AccountNumber = '12345';
        insert a;
               
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_2_50;
        con.email           ='con@email.con';
        con.AccountId       = a.id;
        insert con;
        
        
        List<Enrollment_2_50__c> enrList2_50 = new List<Enrollment_2_50__c>();
        Enrollment_2_50__c enrl                     = new Enrollment_2_50__c();
        enrl.Account_Effective_Date__c              = system.today();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 2345678;
        enrl.External_Key__c                        = '1234test';        
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.id;
        enrl.FSP__c                                 = a.id;
        enrl.AG__c                                  = a.id;
        enrl.SB__c                                  = con.id;        
        enrl.Rpt_Dt__c                              = '201412';
        enrl.Processed_Type__c                      = 'M';    //TPB 09/19/2014       
        enrList2_50.add(enrl);
        
        enrl                                        = new Enrollment_2_50__c();
        enrl.Account_Effective_Date__c              = system.today();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 23456781;
        enrl.External_Key__c                        = '1234test1';
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.Id;
        enrl.FSP__c                                 = a.Id;
        enrl.AG__c                                  = a.Id;
        enrl.SB__c                                  = con.id;
        enrl.Rpt_Dt__c                              = '201411';
        enrl.Processed_Type__c                      = 'M';    
        
        enrList2_50.add(enrl);
        
        insert enrList2_50;
    }    
    */
         // Ashish Ojha Changes
    // Data Build for Enrollment__c
    public static void Create_Enrollment_Data() {
        //Create Enrollment_2_50 Data        
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_2_50;
        a.AccountNumber = '12345';
        insert a;
               
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_2_50;
        con.email           ='con@email.con';
        con.AccountId       = a.id;
        insert con;
        
        Opportunity o = new Opportunity();
        o.Name = 'OppTest' + Date.Today();  
        o.AccountId = a.id;
        o.StageName = 'Proposal';
        o.CloseDate = Date.Today();
        o.System__c = 'Facets';
        o.Facets_Grp_Num__c = 'X23C';        
        o.FullServiceProducer__c = 'Direct';        
        o.Contract_End_Date__c = Date.Today() + 365;
        insert o; 
        
        Id enr_acc_2_50 = QueryBase.getRecordtypeId('Enrollment__c', 'X2_50');
        List<Enrollment__c> enrList = new List<Enrollment__c>();
        Enrollment__c enrl                     = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 2345678;
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.id;
        enrl.FSP__c                                 = a.id;
        enrl.AG__c                                  = a.id;
        enrl.SB__c                                  = con.id;        
        enrl.Rpt_Dt__c                              = '201412';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;   
        enrl.RecordTypeId                           = enr_acc_2_50;   
        enrList.add(enrl);
        
        enrl                                        = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 23456781;
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.Id;
        enrl.FSP__c                                 = a.Id;
        enrl.AG__c                                  = a.Id;
        enrl.SB__c                                  = con.id;
        enrl.Rpt_Dt__c                              = '201411';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;
        enrl.RecordTypeId                           = enr_acc_2_50;
        enrList.add(enrl);
        
        insert enrList;
    }    
// Ashish Ojha Changes
    // Data Build for Enrollment__c
    public static void Create_Enrollment_Data_Shift() {
        //Create Enrollment_2_50 Data        
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_2_50;
        a.AccountNumber = '12345';
        insert a;
               
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_2_50;
        con.email           ='con@email.con';
        con.AccountId       = a.id;
        insert con;
        
        Opportunity o = new Opportunity();
        o.Name = 'OppTest' + Date.Today();  
        o.AccountId = a.id;
        o.StageName = 'Proposal';
        o.CloseDate = Date.Today();
        o.System__c = 'Facets';
        o.Facets_Grp_Num__c = 'X23D';        
        o.FullServiceProducer__c = 'Direct';        
        o.Contract_End_Date__c = Date.Today() + 365;
        insert o; 
        
        Id enr_acc_2_50 = QueryBase.getRecordtypeId('Enrollment__c', 'X2_50');
        Id enr_acc_51 = QueryBase.getRecordtypeId('Enrollment__c', 'X51+');
        List<Enrollment__c> enrList = new List<Enrollment__c>();
        Enrollment__c enrl                     = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 2345678;
        enrl.Am_Name__c                             = 'Tester';
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.id;
        enrl.FSP__c                                 = a.id;
        enrl.AG__c                                  = a.id;
        enrl.SB__c                                  = con.id;        
        enrl.Rpt_Dt__c                              = '201401';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;   
        enrl.RecordTypeId                           = enr_acc_2_50;   
        enrList.add(enrl);
        
        enrl                                        = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 23456781;
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.Id;
        enrl.FSP__c                                 = a.Id;
        enrl.AG__c                                  = a.Id;
        enrl.SB__c                                  = con.id;
        enrl.Rpt_Dt__c                              = '201403';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;
        enrl.Curr_Fiscal_Year__c                    =  '2014_Baseline';                
        enrl.Curr_Baseline_Compensation_Owner__c    = 'tester';
        enrl.Curr_Baseline_Contracts__c             = 2345668;

        enrList.add(enrl);
        
        
        insert enrList;
    }
// Data Build for Enrollment__c 51 + record type 
    public static void Create_Enrollment_Data_51() {
        //Create Enrollment_2_50 Data        
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X51');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_2_50;
        a.AccountNumber = '12345';
        insert a;
               
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_2_50;
        con.email           ='con@email.con';
        con.AccountId       = a.id;
        insert con;
        
        Opportunity o = new Opportunity();
        o.Name = 'OppTest' + Date.Today();  
        o.AccountId = a.id;
        o.StageName = 'Proposal';
        o.CloseDate = Date.Today();
        o.System__c = 'Facets';
        o.Facets_Grp_Num__c = 'X23E';        
        o.FullServiceProducer__c = 'Direct';        
        o.Contract_End_Date__c = Date.Today() + 365;
        insert o; 
        
        Id enr_acc_2_50 = QueryBase.getRecordtypeId('Enrollment__c', 'X2_50');
        Id enr_acc_51 = QueryBase.getRecordtypeId('Enrollment__c', 'X51');
        List<Enrollment__c> enrList = new List<Enrollment__c>();
        Enrollment__c enrl                     = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 2345678;
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.id;
        enrl.FSP__c                                 = a.id;
        enrl.AG__c                                  = a.id;
        enrl.SB__c                                  = con.id;        
        enrl.Rpt_Dt__c                              = '201401';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;   
        enrl.RecordTypeId                           = enr_acc_51;   
        enrList.add(enrl);
        
        enrl                                        = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 23456781;
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.Id;
        enrl.FSP__c                                 = a.Id;
        enrl.AG__c                                  = a.Id;
        enrl.SB__c                                  = con.id;
        enrl.Rpt_Dt__c                              = '201201';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;
        enrl.RecordTypeId                           = enr_acc_51;
        enrList.add(enrl);
        
        
        insert enrList;
    }
    // Data Build for Enrollment__c
    public static void Create_Enrollment_Data_EXC() {
        //Create Enrollment_2_50 Data        
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X51');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_2_50;
        a.AccountNumber = '12345';
        insert a;
               
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_2_50;
        con.email           ='con@email.con';
        con.AccountId       = a.id;
        insert con;
        
        Opportunity o = new Opportunity();
        o.Name = 'OppTest' + Date.Today();  
        o.AccountId = a.id;
        o.StageName = 'Proposal';
        o.CloseDate = Date.Today();
        o.System__c = 'Facets';
        o.Facets_Grp_Num__c = 'X23F';        
        o.FullServiceProducer__c = 'Direct';        
        o.Contract_End_Date__c = Date.Today() + 365;
        insert o; 
        
        Id enr_acc_2_50 = QueryBase.getRecordtypeId('Enrollment__c', 'X2_50');
        Id enr_acc_51 = QueryBase.getRecordtypeId('Enrollment__c', 'X51');
        List<Enrollment__c> enrList = new List<Enrollment__c>();
        Enrollment__c enrl                     = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 2345678;
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.id;
        enrl.FSP__c                                 = a.id;
        enrl.AG__c                                  = a.id;
        enrl.SB__c                                  = con.id;        
        enrl.Rpt_Dt__c                              = '201501';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;   
        enrl.RecordTypeId                           = enr_acc_51;   
        enrList.add(enrl);
        
        enrl                                        = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 23456781;
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.Id;
        enrl.FSP__c                                 = a.Id;
        enrl.AG__c                                  = a.Id;
        enrl.SB__c                                  = con.id;
        enrl.Rpt_Dt__c                              = '201501';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;
        enrl.RecordTypeId                           = enr_acc_51;
        enrList.add(enrl);
        
        
        insert enrList;
    }
    // Data Build for Account for Setting Ranking fields
  public static void createTestAccountsForRanking() {
        // Create some test accounts
        List<Account> accList = new List<Account>();
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
        Account a = new Account();
        a.Name = 'TestAccount1';
        a.Type = 'Partner';
        a.Entity_ID__c = '123456789';
        a.Entity_Type_AG__c = true;
        a.RecordTypeId = rt_acc_2_50;
        a.AG_Contracts_for_Year__c = 20;
        accList.add(a);
        
        a = new Account();
        a.Name = 'TestAccount2';
        a.Type = 'Partner';
        a.Entity_ID__c = '123459999';
        a.Entity_Type_FSP__c = true;
        a.RecordTypeId = rt_acc_2_50;
        accList.add(a);
        
        a = new Account();
        a.Name = 'TestAccount3';
        a.Type = 'Partner';
        a.Entity_ID__c = '555555555';
        a.Entity_Type_AG__c = true;
        a.RecordTypeId = rt_acc_2_50;
        accList.add(a);        
        insert acclist;            
        
    }
        // Data Build for Contact for Setting Ranking fields

    public static void createTestContactsForRanking() {
        // Create some test contacts
        
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Id rt_Con_51 = QueryBase.getRecordtypeId('Contact', 'X51');        
        Insert new Contact[] { new Contact( AccountId = Account2_50_Default, FirstName = 'BrokerTest1',  LastName = 'BrokerTest1', Email = 'ba@ba1.com', phone = '123-123-3838', Employer_Group_Portal__c = FALSE, Entity_Id__c = '123456789', Entity_Type_SB__c=true, RecordTypeId = rt_Con_2_50,SB_Rank__C = 2,Contracts_for_Year__c = 20 ,Groups_for_Year__c = 10 ),                            
                               new Contact( AccountId = Account2_50_Default, FirstName = 'BrokerTest2',  LastName = 'BrokerTest2', Email = 'ba@ba2.com', phone = '123-123-1039', Employer_Group_Portal__c = FALSE, Entity_Id__c = '777777777', Entity_Type_SB__c=true, RecordTypeId = rt_Con_2_50 ,SB_Rank__C = 5, Contracts_for_Year__c = 30 , Groups_for_Year__c = 5)}; 
    }    
      
    // Data Build for Enrollment__c for Setting Ranking fields
    public static void createTestenrollmentsForRanking() {
        
        //Create Enrollment_2_50 Data   
        
             
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_2_50;
        a.AccountNumber = '12345';
        insert a;
               
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_2_50;
        con.email           ='con@email.con';
        con.AccountId       = a.id;
        insert con;
        
        Opportunity o = new Opportunity();
        o.Name = 'OppTest' + Date.Today();  
        o.AccountId = a.id;
        o.StageName = 'Proposal';
        o.CloseDate = Date.Today();
        o.System__c = 'Facets';
        o.Facets_Grp_Num__c = 'X23G';        
        o.FullServiceProducer__c = 'Direct';        
        o.Contract_End_Date__c = Date.Today() + 365;
        insert o; 
        
        Id enr_acc_2_50 = QueryBase.getRecordtypeId('Enrollment__c', 'X2_50');
        Id enr_acc_51 = QueryBase.getRecordtypeId('Enrollment__c', 'X51+');
        List<Enrollment__c> enrList = new List<Enrollment__c>();
        Enrollment__c enrl                     = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           =  78;
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.id;
        enrl.FSP__c                                 = a.id;
        enrl.AG__c                                  = a.id;
        enrl.SB__c                                  = con.id;        
        enrl.Rpt_Dt__c                              = '201601';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;   
        enrl.RecordTypeId                           = enr_acc_2_50;   
        enrList.add(enrl);
        
        enrl                                        = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 23;
        enrl.Status__c                              = 'Active';
        enrl.GP__c                                  = a.Id;
        enrl.FSP__c                                 = a.Id;
        enrl.AG__c                                  = a.Id;
        enrl.SB__c                                  = con.id;
        enrl.Rpt_Dt__c                              = '201601';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;
        enrl.RecordTypeId                           = enr_acc_2_50;
        enrList.add(enrl);
        insert enrList;
     }
     // Ashish Ojha Changes
    // Data Build for Enrollment__c
    public static void Create_Enrollment_Data_OffAndOnCycle() {
        //Create Enrollment_2_50 Data        
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_2_50;
        a.AccountNumber = '12345';
        insert a;
               
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_2_50;
        con.email           ='con@email.con';
        con.AccountId       = a.id;
        insert con;
        
        Opportunity o = new Opportunity();
        o.Name = 'OppTest' + Date.Today();  
        o.AccountId = a.id;
        o.StageName = 'Proposal';
        o.CloseDate = Date.Today();
        o.System__c = 'Facets';
        o.Facets_Grp_Num__c = 'X23H';        
        o.FullServiceProducer__c = 'Direct';        
        o.Contract_End_Date__c = Date.Today() + 365;
        insert o; 
        
        Id enr_acc_2_50 = QueryBase.getRecordtypeId('Enrollment__c', 'X2_50');
        Id enr_acc_51 = QueryBase.getRecordtypeId('Enrollment__c', 'X51+');
        List<Enrollment__c> enrList = new List<Enrollment__c>();
        Enrollment__c enrl                     = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 2345678;
        enrl.Am_Name__c                             = 'Tester';
        enrl.GP__c                                  = a.id;
        enrl.FSP__c                                 = a.id;
        enrl.AG__c                                  = a.id;
        enrl.SB__c                                  = con.id;        
        enrl.Rpt_Dt__c                              = '201401';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;
        enrl.Status__c                              = 'Termed';
        enrl.Termination_Date__c                    = Date.Today();
        enrl.On_cycle__c                            = False;   
        enrl.Reporting_checkbox_off_cycle__c         = TRUE;
        enrl.Reporting_checkbox__c                   = False;
        enrl.RecordTypeId                           = enr_acc_2_50;   
        enrList.add(enrl);
        
        enrl                                        = new Enrollment__c();
        enrl.Account_Number__c                      = '12345';
        enrl.Contracts__c                           = 23456781;
        enrl.Status__c                              = 'Termed';
        enrl.Termination_Date__c                    = Date.Today();
        enrl.On_cycle__c                            = TRUE;
        enrl.GP__c                                  = a.Id;
        enrl.FSP__c                                 = a.Id;
        enrl.AG__c                                  = a.Id;
        enrl.SB__c                                  = con.id;
        enrl.Rpt_Dt__c                              = '201411';
        enrl.Processed_Type__c                      = 'M';    
        enrl.Opportunity__c                         = o.id;
        enrl.Curr_Fiscal_Year__c                    =  '2014_Baseline';                
        enrl.Curr_Baseline_Compensation_Owner__c    = 'tester';
        enrl.Curr_Baseline_Contracts__c             = 2345668;
        enrl.Reporting_checkbox_off_cycle__c         = False;
        enrl.Reporting_checkbox__c                   = TRUE;
        enrList.add(enrl);
        
        
        insert enrList;
    }
     public static void createChatterGroups(){
        CollaborationGroup cgrp = new CollaborationGroup();
        cgrp.Name = 'SFDC ProcessesX';
        cgrp.CollaborationType = 'public';      
        insert cgrp;              
    }
     /*******************************************
     * Test Data for population of opportunity
       from 
        to BRF. IF BRF is created from
       PRF
     ******************************************/
     
     
    /*-----------------------------------------------------        
                        Rajesh Changes Starts
    -------------------------------------------------------*/
    //The Following Test Methods tests BRFTrigger And AIA_BRFTriggerHandler class.
    
    /*-----------------------Test Methods Starts Here for BRF Trigger------------------*/
    public static Account createAccount(String accountName)
    {
         // Create some test accounts
         
         
         List<user> userList = new list<user>();
        user u1 = AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_createUser('alias2');
        userList.add(u2);
        user u7 = AIA_createUser('alias7');
        userList.add(u7);
        user u8 = AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_createUser('alias6');
        userList.add(u6);
        //T08 Starts
        User u11 = AIA_createUser('alias11');
        userList.add(u11);
        user u12 = AIA_createUser('alias12');
        userList.add(u12);
        user u9 = AIA_createUser('alias9');
        userList.add(u9);
        user u10 = AIA_createUser('alias10');
        userList.add(u10);
        //T08 Ends
        
        insert userList;   
         
         
        Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account a = new Account();
        a.Name = accountName;
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_51;      
        a.Renewal_Anniversary_Month__c='Jan';
        a.Account_Legal_Name__c= 'test Account';
        insert a;
       // return a;  
        
             
        // Commented out as part of T08
        
        // 10/27 - Replaced the code above and added account team members to list
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList =new List<Account_Team__c>();
        //acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u7.id,'NASCO Benefit Coder'));T08 
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u4.id,'QA Auditor')); 
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u5.id,'MAST Tech')); 
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u1.id,'Underwriter'));  //t06
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u2.id,'AIA User'));  //t06
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u11.id,'Benefit Tester'));//T08
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u12.id,'Pharmacy Operations'));//T08
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u9.id,'Vision Analyst'));//T08
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u10.id,'Benefit Coder'));  //T08                                       
        // Insert all members at once
        insert acctMbrList;
        
        
        
        //T08 ends
        return a;
    }
    
    
    public static Account createAccount2(String accountName)
    {
         // Create some test accounts
         
         
         List<user> userList = new list<user>();
        user u1 = AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_createUser('alias2');
        userList.add(u2);
        user u7 = AIA_createUser('alias7');
        userList.add(u7);
        user u8 = AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_createUser('alias6');
        userList.add(u6);
        
        
        insert userList;   
         
         
        Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account a = new Account();
        a.Name = accountName;
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_51;      
        a.Renewal_Anniversary_Month__c='Jan';
        a.Account_Legal_Name__c= 'test Account';
        insert a;
       // return a;  
        
             
        
        // 10/27 - Replaced the code above and added account team members to list
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        
        //acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u2.id,'Sales Assistant')); 
        
        //insert acctMbrList;
        
        return a;
    }
    
    // replaced with custom account team object as part of T08 Starts
    /* 
    // SD - new method to create account team members at once
    public static AccountTeamMember SD_CreateAccountTeamMember(String aId, String uId, String teamMemberRole)
    {
         AccountTeamMember acctMbr = new AccountTeamMember(AccountId=aId,UserId=uId,TeamMemberRole=teamMemberRole); 
         return acctMbr;
    }*/
    public static Account_Team__c SD_CreateAccountTeamMember(String aId, String uId, String teamMemberRole)
    {
         Account_Team__c acctMbr = new Account_Team__c(AccountId__c=aId,UserId__c=uId,TeamMemberRole__c=teamMemberRole); 
         return acctMbr;
    }
    //Added method to add Standard Acccount tEamMemeber
    public static AccountTeamMember SD_CreateStdAccountTeamMember(String aId, String uId, String teamMemberRole)
    {
         AccountTeamMember acctMbr = new AccountTeamMember(AccountId=aId,UserId=uId,TeamMemberRole=teamMemberRole); 
         return acctMbr;
    }
        
    //T08 ends
   //T01-- Start 
    /*public static AIA_Workplan_Type__c createWPT1(){
        AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Active__c = true;
        wpt.Used_For__c = 'Pre-Sales';
        wpt.Workplan_Type__c = 'new';
        insert wpt;
        return wpt;
        
              
    }*/
    //T01 -- End
    //Removing Wp as part of US210
    public static Opportunity CreateOpportunity(string aid){
        Opportunity opp = new Opportunity();
        opp.Name = 'Testopp';
        opp.AccountId = aid;
        opp.FullServiceProducer__c = 'testpro';
        opp.Legal_Account_Name_Verified__c=true;
        opp.Business_Type__c = 'new';
        opp.Effective_Date__c = system.today().toStartofMonth();
        opp.CloseDate = opp.Effective_Date__c - 1;
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1)-1;
        opp.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
        opp.Market_Segment_New__c = '51-199';
        opp.Division__c = 'Labor Affairs';
        opp.Won_Lost_Reason__c = 'Acquisition';
        opp.Incumbent_Successor__c = 'Aetna';
        opp.SBU__c = 'Large';   
        //opp.StageName = 'test';
        opp.StageName = 'Proposal';
        //opp.Workplan_Type__c = wptid;
        insert opp;
        return opp;
         
    }
    
    public static Benfit_Request_Form__c CreateBRF(string pid,string aid){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom']; 
        
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        insert u;
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
        insert u2;
        
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
          //Create testusers
        List<user> userList = new list<user>();
        user usr1 = AIA_createUser('alias1');
        userList.add(usr1);
        user usr2 = AIA_createUser('alias2');
        userList.add(usr2);        
        user usr3 = AIA_createUser('alias3');
        userList.add(usr3);        
        user usr4 = AIA_createUser('alias4');
        userList.add(usr4);        
        user usr5 = AIA_createUser('alias5');
        userList.add(usr5); 
        user usr6 = AIA_createUser('alias6');
        userList.add(usr6);
        insert userList;       
       
       
        //Create Account teams for all the relevant roles
        //AIA_createAccountTeamMember(a.Id, usr1.id, 'NASCO Benefit Coder');
        //AIA_createAccountTeamMember(a.Id, usr2.id, 'BeneFact Coder');
        //AIA_createAccountTeamMember(a.Id, usr3.id, 'Ancillary Analyst');
        //AIA_createAccountTeamMember(a.Id, usr4.id, 'QA Auditor');
        //AIA_createAccountTeamMember(a.Id, usr5.id, 'MAST Tech'); 
        AIA_createAccountTeamMember(a.Id, usr6.id, 'Contract Tech');
        
        /*
        AccountTeamMember atm = new AccountTeamMember ();
        atm.TeamMemberRole = 'NASCO Benefit Coder';
        atm.AccountId =a.id;
        atm.UserId = userinfo.getUserId();
        insert atm;
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'BeneFact Coder';
        atmRole.AccountId = a.id;
        atmRole.UserId = u.id;
        insert atmRole;
        
        AccountTeamMember atm2 = new AccountTeamMember ();
        atm2.TeamMemberRole = 'Audit';
        atm2.AccountId = a.id;
        atm2.UserId = u2.id;
        insert atm2;
        */
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.Business_Type__c = 'New';
        update o;
         
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        if(pid != null)
        nbrf.Proposal_Request_Form__c = pid;
       // nbrf.Control_Plan__c='690';     
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = aid;
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Account__c = a.id;
        nbrf.Opportunity__c = o.id;
        nbrf.Jurisdiction__c = 'MD';
        
        //t05 start 
            
            nbrf.EGWP_Picklist__c = 'No';
            nbrf.FlexLink_Picklist__c = 'No';
            nbrf.Request_Type__c = 'Prospect/New';
            nbrf.Control_Plan__c = '580';
            nbrf.Benefit_Period__c = 'Calendar';
            nbrf.Sales_Segment_Size__c = 'commercial 200-999';
            nbrf.Contract_Period__c = 'Standard - 12 Months';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Grandfathered_PPACA_Status__c = 'No';
            nbrf.Stop_Loss__c = 'CareFirst';
            nbrf.Funding_Arrangements__c = 'ASO';
            nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
            nbrf.Broker_Consultant_Amount__c = 5.0;
            
            nbrf.Identity_Protection__c = 'No';
            nbrf.Enrollment_Type__c = 'Parallel';
            
            
            //t05 end
            
        insert nbrf;
        return nbrf;
    }
    
    
     public static Benfit_Request_Form__c CreateBRF2(string pid,string oid,string aid){
        
         
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        if(pid != null)
        nbrf.Proposal_Request_Form__c = pid;
    //    nbrf.Control_Plan__c='690';     
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = aid;
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Account__c = aid;
        nbrf.Opportunity__c = oid;
        nbrf.Jurisdiction__c = 'MD';
        
        //t05 start 
            
            nbrf.EGWP_Picklist__c = 'No';
            nbrf.FlexLink_Picklist__c = 'No';
            nbrf.Request_Type__c = 'Prospect/New';
            nbrf.Control_Plan__c = '580';
            nbrf.Benefit_Period__c = 'Calendar';
            nbrf.Sales_Segment_Size__c = 'commercial 200-999';
            nbrf.Contract_Period__c = 'Standard - 12 Months';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Grandfathered_PPACA_Status__c = 'No';
            nbrf.Stop_Loss__c = 'CareFirst';
            nbrf.Funding_Arrangements__c = 'ASO';
            nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
            nbrf.Broker_Consultant_Amount__c = 5.0;
            
            nbrf.Identity_Protection__c = 'No';
            nbrf.Enrollment_Type__c = 'Parallel';
            
            
            //t05 end
        insert nbrf;
        return nbrf;
    }
    
    public static Benfit_Request_Form__c CreateBRFStatusSold(string pid,string aid,string oid){
        profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        insert u;
        
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        //List<AccountTeamMember> atmlist= new  List<AccountTeamMember>();
        List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom T08
        /*AccountTeamMember atm = new AccountTeamMember ();
        atm.TeamMemberRole = 'NASCO Benefit Coder';
        atm.AccountId =a.id;
        atm.UserId = userinfo.getUserId();
        atmlist.add(atm);
        //insert atm;
        
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'BeneFact Coder';
        atmRole.AccountId =a.id;
        atmRole.UserId = u.id;
        atmlist.add(atmRole);
        insert atmlist;*/
        Account_Team__c atmRole =new Account_Team__c();
        atmRole.AccountId__c=a.id;
        atmRole.UserId__c=u.id;
        atmRole.TeamMemberRole__c='BeneFact Coder';
        insert atmRole;
        
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        if(pid != null)
        nbrf.Proposal_Request_Form__c = pid;
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = aid;
     //   nbrf.Control_Plan__c='690';
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'Sold';
        nbrf.Opportunity__c = oid;
        
        //t05 start 
            
            nbrf.EGWP_Picklist__c = 'No';
            nbrf.FlexLink_Picklist__c = 'No';
            nbrf.Request_Type__c = 'Prospect/New';
            nbrf.Control_Plan__c = '580';
            nbrf.Benefit_Period__c = 'Calendar';
            nbrf.Sales_Segment_Size__c = 'commercial 200-999';
            nbrf.Contract_Period__c = 'Standard - 12 Months';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Grandfathered_PPACA_Status__c = 'No';
            nbrf.Stop_Loss__c = 'CareFirst';
            nbrf.Funding_Arrangements__c = 'ASO';
            nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
            nbrf.Broker_Consultant_Amount__c = 5.0;
            
            nbrf.Identity_Protection__c = 'No';
            nbrf.Enrollment_Type__c = 'Parallel';
            
            
            //t05 end
        
        insert nbrf;
        return nbrf;
    } 
    
    public static Benfit_Request_Form__c CreateBRFForBNCRole(string pid,string aid,string oid){
        
        
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        if(pid != null)
        nbrf.Proposal_Request_Form__c = pid;
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = aid;
      //  nbrf.Control_Plan__c='MD';
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'New';
        nbrf.Opportunity__c = oid;
        
        //t05 start 
            
            nbrf.EGWP_Picklist__c = 'No';
            nbrf.FlexLink_Picklist__c = 'No';
            nbrf.Request_Type__c = 'Prospect/New';
            nbrf.Control_Plan__c = '580';
            nbrf.Benefit_Period__c = 'Calendar';
            nbrf.Sales_Segment_Size__c = 'commercial 200-999';
            nbrf.Contract_Period__c = 'Standard - 12 Months';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Grandfathered_PPACA_Status__c = 'No';
            nbrf.Stop_Loss__c = 'CareFirst';
            nbrf.Funding_Arrangements__c = 'ASO';
            nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
            nbrf.Broker_Consultant_Amount__c = 5.0;
            
            nbrf.Identity_Protection__c = 'No';
            nbrf.Enrollment_Type__c = 'Parallel';
            
            
            //t05 end
        insert nbrf;
        return nbrf;
    } 
    
    public static Benfit_Request_Form__c CreateBRFForBFCRole(string pid,string aid,string oid){
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        if(pid != null)
        nbrf.Proposal_Request_Form__c = pid;
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = aid;
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'New';
        nbrf.Opportunity__c = oid;
        
        //t05 start 
            
            nbrf.EGWP_Picklist__c = 'No';
            nbrf.FlexLink_Picklist__c = 'No';
            nbrf.Request_Type__c = 'Prospect/New';
            nbrf.Control_Plan__c = '580';
            nbrf.Benefit_Period__c = 'Calendar';
            nbrf.Sales_Segment_Size__c = 'commercial 200-999';
            nbrf.Contract_Period__c = 'Standard - 12 Months';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Grandfathered_PPACA_Status__c = 'No';
            nbrf.Stop_Loss__c = 'CareFirst';
            nbrf.Funding_Arrangements__c = 'ASO';
            nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
            nbrf.Broker_Consultant_Amount__c = 5.0;
            
            nbrf.Identity_Protection__c = 'No';
            nbrf.Enrollment_Type__c = 'Parallel';
            
            
            //t05 end
        insert nbrf;
        return nbrf;
    } 
    public static Opportunity CreateOpportunityWithWPT(string aid, string workPTID){
        Id rt_AIA_200 = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
        Opportunity opp = new Opportunity();
        opp.RecordTypeId = rt_AIA_200;
        opp.Name = 'Testopp';
        opp.AccountId = aid;
        opp.FullServiceProducer__c = 'testpro';
        opp.Legal_Account_Name_Verified__c=true;
        opp.Business_Type__c = 'Renewal';
        opp.Effective_Date__c = system.today().toStartofMonth()-1;
        opp.CloseDate = opp.Effective_Date__c - 1;
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1)-1;
        opp.StageName = 'Sold';
        opp.System__c ='Nasco';
        opp.NASCO_Acct_ID__c ='12345,12345,12345,12345';
        opp.Workplan_Type__c = workPTID;
        insert opp;
        return opp;
         
    }
    public static PRF__c CreatePRF(string oid){
        PRF__c prf = new PRF__c();
       // prf.RecordTypeId = Schema.SObjectType.PRF__c.getRecordTypeInfosByName().get('CF Proposal Request').getRecordTypeId();
        prf.Name = 'testprf';
        prf.Opportunity__c = oid;
        prf.Alt_Network_State__c = 'MD';
        prf.CDH_Administrator__c = 'ConnectYourCare';
        prf.Medical_Networks__c = 'Alternative Networks';
        prf.Medical_Products__c = 'CDH';
        prf.CDH_Products__c = 'Blue Preferred';
        prf.CDH_Addl_Info__c = 'Test';
        prf.CDH_Funding_Arrangement__c = 'HSA';
        insert prf;
        //return prf;
        

        PRF__c prf2 = new PRF__c();
       // prf2.RecordTypeId = Schema.SObjectType.PRF__c.getRecordTypeInfosByName().get('CF (200+)').getRecordTypeId();
        prf2.Name = 'testprf2';
        prf2.Opportunity__c = oid;
        insert prf2;
        //return prf2;
        
        
        PRF__c prf3 = new PRF__c();
        
        prf3.Name = 'testprf3';
        prf3.Opportunity__c = oid;
        prf3.Medical_Networks__c = 'PPO with Blue Card';
        insert prf3;
        return prf3; 
        

    }
    
    public static AIA_Implementation__c CreateImp(string oid){
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = oid;
   /* R1 changes to false*/     
   //Imp.Generate_Workplan_Stages__c = false;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO'; 
        //Imp.Risk_Type__c='Risk';
 
        insert Imp;

        return Imp;
    }
    public static AIA_Implementation__c UpdateImp(string oid){
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = oid;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        insert Imp;
        Imp.Implementation_Plan_Timeline_Days__c = '120';
        update Imp;
        return Imp;

    }
    
    //Create FileNet document
    public static void createAIADocument(Benfit_Request_Form__c brf){
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Signed Quote';
        fileNetDoc.Approval_Status__c='Approved';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
    }
    public static Benfit_Request_Form__c updateBRF(string pid,string aid,string brfid){
        Benfit_Request_Form__c ubrf = new Benfit_Request_Form__c();
        ubrf.Id = brfid;
        ubrf.Proposal_Request_Form__c = pid;
        ubrf.Contract_Count__c = 123;
        ubrf.Benefit_Effective_Date__c = system.today();
        ubrf.Account__c = aid;
        ubrf.ARC_Approval_Status__c = 'Approved by Committee';
        ubrf.Escalated_to_Senior_Management__c = true;
        ubrf.Status__c = 'sold';
        //t05 start 
            
            ubrf.EGWP_Picklist__c = 'No';
            ubrf.FlexLink_Picklist__c = 'No';
            ubrf.Request_Type__c = 'Prospect/New';
            ubrf.Control_Plan__c = '580';
            ubrf.Benefit_Period__c = 'Calendar';
            ubrf.Sales_Segment_Size__c = 'commercial 200-999';
            ubrf.Contract_Period__c = 'Standard - 12 Months';
            ubrf.Grandfathered_Status__c = 'Grandfathered';
            ubrf.Grandfathered_PPACA_Status__c = 'No';
            ubrf.Stop_Loss__c = 'CareFirst';
            ubrf.Funding_Arrangements__c = 'ASO';
            ubrf.Broker_Consultant_Compensation__c = 'Commission (%)';
            ubrf.Broker_Consultant_Amount__c = 5.0;
            
            ubrf.Identity_Protection__c = 'No';
            ubrf.Enrollment_Type__c = 'Parallel';
            
            
            //t05 end
        
        insert ubrf;
        return ubrf;
    }
    /*-----------------------Test Methods End Here for BRF Trigger------------------*/
    
    //This Test Methods tests WorkplanStageTrigger And its Handler Classes
    
    /*-----------------------Test Methods Starts Here for WorkplanStageTrigger------------------*/
    
    public static List<Opportunity> createOpps(string aid){       
        List<Opportunity> opplst =new List<Opportunity>();
        Opportunity opp = new Opportunity();
        opp.Name = 'Testopp';
        opp.AccountId = aid;
        opp.FullServiceProducer__c = 'testpro';
        opp.Legal_Account_Name_Verified__c=true;
        opp.Effective_Date__c = system.today().toStartofMonth();
        opp.CloseDate = opp.Effective_Date__c - 1;
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1)-1;
        opp.StageName = 'test';
        opplst.add(opp);
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Testopp1';
        opp1.AccountId = aid;
        opp1.FullServiceProducer__c = 'testpro';
        opp1.Legal_Account_Name_Verified__c=true;
        opp1.Effective_Date__c = system.today().toStartofMonth();
        opp1.CloseDate = opp.Effective_Date__c - 1;
        opp1.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1)-1;
        opp1.StageName = 'test';
        opplst.add(opp1);
        insert opplst;
        return opplst;
    }
    /*public static List<Workplan_Stage__c> createParentWPS(){
        List<Workplan_Stage__c> pwpslst = new List<Workplan_Stage__c>();
        Workplan_Stage__c ws = new Workplan_Stage__c();
        ws.Status__c = 'Not Started';
        pwpslst.add(ws);
        
        Workplan_Stage__c ws1 = new Workplan_Stage__c();
        ws1.Status__c = 'Not Started';
        pwpslst.add(ws1);
        insert pwpslst;
        return pwpslst;
    }
    public static List<Workplan_Stage__c> createChildOldWPS(List<Workplan_Stage__c> pwpslst1,List<Opportunity> olst){
        Schema.DescribeSObjectResult WPSdSobjres = Schema.SObjectType.Workplan_Stage__c; 
        Map<String,Schema.RecordTypeInfo> WPSRecordType = WPSdSobjres.getRecordTypeInfosByName(); 
        Id SubProcesswpsRtid = WPSRecordType.get('Sub-Process').getRecordTypeId();
        
        List<Workplan_Stage__c> cowpslst = new List<Workplan_Stage__c>();
        
        Workplan_Stage__c ws2 = new Workplan_Stage__c();
        ws2.Status__c = 'Not Started';
        ws2.RecordTypeID = SubProcesswpsRtid;
        ws2.Parent_Workplan_Stage__c = pwpslst1[0].Id;
        ws2.of_Total_Tasks__c = 2;
        ws2.of_Completed_Tasks__c = 1;
        ws2.Opportunity__c = olst[0].Id;
        cowpslst.add(ws2);
        
        Workplan_Stage__c ws3 = new Workplan_Stage__c();
        ws3.Status__c = 'Not Started';
        ws3.RecordTypeID = SubProcesswpsRtid;
        ws3.Parent_Workplan_Stage__c = pwpslst1[1].Id;
        ws3.of_Total_Tasks__c = null;
        ws3.of_Completed_Tasks__c = null;
        ws3.Opportunity__c = olst[1].Id;
        cowpslst.add(ws3);
        insert cowpslst;
        return cowpslst;
    }
    public static List<Workplan_Stage__c> createChildWPS(List<Workplan_Stage__c> pwpslst1){
        Schema.DescribeSObjectResult WPSdSobjres = Schema.SObjectType.Workplan_Stage__c; 
        Map<String,Schema.RecordTypeInfo> WPSRecordType = WPSdSobjres.getRecordTypeInfosByName(); 
        Id ProcesswpsRtid = WPSRecordType.get('Process').getRecordTypeId();
        List<Workplan_Stage__c> cwpslst = new List<Workplan_Stage__c>();
        Workplan_Stage__c ws4 = new Workplan_Stage__c();
        ws4.Status__c = 'Not Started';
        ws4.RecordTypeID = ProcesswpsRtid;
        ws4.Parent_Workplan_Stage__c = pwpslst1[0].Id;
        ws4.of_Total_Tasks__c = 3;
        ws4.of_Completed_Tasks__c = 1;
        cwpslst.add(ws4);
        
        Workplan_Stage__c ws5 = new Workplan_Stage__c();
        ws5.Status__c = 'Not Started';
        ws5.RecordTypeID = ProcesswpsRtid;
        ws5.Parent_Workplan_Stage__c = pwpslst1[1].Id;
        ws5.of_Total_Tasks__c = null;
        ws5.of_Completed_Tasks__c = null;
        cwpslst.add(ws5);
        
        Workplan_Stage__c ws6 = new Workplan_Stage__c();
        ws6.Status__c = 'Not Started';
        ws6.RecordTypeID = ProcesswpsRtid;
        ws6.Parent_Workplan_Stage__c = pwpslst1[1].Id;
        ws6.of_Total_Tasks__c = null;
        ws6.of_Completed_Tasks__c = null;
        cwpslst.add(ws6);
        insert cwpslst;
        return cwpslst;
    }
    public static void updatePWPS(list<Workplan_Stage__c> colst,list<Workplan_Stage__c> cnlst){
        colst[0].Status__c = 'Completed';
        colst[1].Status__c = 'Not Required';
        cnlst[0].Status__c = 'Completed';
        cnlst[1].Status__c = 'Not Required';
        cnlst[2].Status__c = 'In Progress';
        update colst;
        update cnlst;
    }
    public static void deleteWPS(list<Workplan_Stage__c> dnlst){
        delete dnlst;
    }*/
    //T01--End
    /*-----------------------Test Methods Ends Here for WorkplanStageTrigger------------------*/
    
 
    //This Test Methods tests WorkplanAssignmentTrigger And AIA_WorkplanAssignmentTriggerHandler Class. 
    
    /*-----------------------Test Methods starts Here for WorkplanAssignmentTrigger------------------*/
    //T01 -- Start
    /*
    public static List<Workplan_Stage__c> createWPS(){
        List<Workplan_Stage__c> wpslst = new List<Workplan_Stage__c>();
        Workplan_Stage__c ws = new Workplan_Stage__c();
        ws.Status__c = 'Not Started';
        ws.End_Date__c = system.today();
        wpslst.add(ws);
        
        Workplan_Stage__c ws1 = new Workplan_Stage__c();
        ws1.Status__c = 'Not Started';
        ws1.End_Date__c = system.today();
        wpslst.add(ws1);
        
        Workplan_Stage__c ws2 = new Workplan_Stage__c();
        ws2.Status__c = 'Not Started';
        ws2.End_Date__c = system.today();
        wpslst.add(ws2);
        
        Workplan_Stage__c ws3 = new Workplan_Stage__c();
        ws3.Status__c = 'Not Started';
        ws3.End_Date__c = system.today();
        wpslst.add(ws3);
        
        Workplan_Stage__c ws4 = new Workplan_Stage__c();
        ws4.Status__c = 'Not Started';
        ws4.End_Date__c = system.today();
        wpslst.add(ws4);
        
        Workplan_Stage__c ws5 = new Workplan_Stage__c();
        ws5.Status__c = 'Not Started';
        ws5.End_Date__c = system.today();
        wpslst.add(ws5);
        insert wpslst;
        return wpslst;
    }*/
    public static List<PRF__c> createPRF(){
        List<PRF__c> prflst = new List<PRF__c>();
        
       /* PRF__c prf1 = new PRF__c();
        prf1.Name = 'testprf1';
        prf1.Medical_Networks__c ='PPO with Blue Card';
        prf1.Medical_Products__c = 'BC Advantage';
        prflst.add(prf1);
        
        PRF__c prf2 = new PRF__c();
        prf2.Name = 'testprf2';
        prf2.Medical_Networks__c ='PPO with Blue Card';
        prf2.Medical_Products__c = 'BC Advantage';
        prflst.add(prf2); */
        
        PRF__c prf3 = new PRF__c();
        prf3.Name = 'testprf3';
        prf3.Medical_Networks__c ='PPO with Blue Card';
        prf3.Presc_Rx_Addt_Info__c = 'Test';
        prf3.Medical_Products_Other__c='Test';
       
        prflst.add(prf3);
        
        insert prflst;
        return prflst;
    }
    //T01 -- Start
    /*public static List<AIA_Workplan_Assignment__c> createWPA(List<Workplan_Stage__c> wpslst,List<PRF__c> prflst){
        List<AIA_Workplan_Assignment__c>  walst = new List<AIA_Workplan_Assignment__c>();
        
        AIA_Workplan_Assignment__c wa = new AIA_Workplan_Assignment__c();
        wa.Status__c = 'In Progress';
        wa.Workplan_Stage__c = wpslst[0].Id;
        wa.Proposal_Request_form__c = prflst[0].Id;
        walst.add(wa);
        
        AIA_Workplan_Assignment__c wa1 = new AIA_Workplan_Assignment__c();
        wa1.Status__c = 'In Progress';
        wa1.Workplan_Stage__c = wpslst[1].Id;
        wa1.Proposal_Request_form__c = prflst[1].Id;
        walst.add(wa1);
        
        AIA_Workplan_Assignment__c wa2 = new AIA_Workplan_Assignment__c();
        wa2.Status__c = 'In Progress';
        wa2.Workplan_Stage__c = wpslst[2].Id;
        wa2.Proposal_Request_form__c = prflst[2].Id;
        walst.add(wa2);
        
        AIA_Workplan_Assignment__c wa3 = new AIA_Workplan_Assignment__c();
        wa3.Status__c = 'In Progress';
        wa3.Workplan_Stage__c = wpslst[3].Id;
        wa3.Proposal_Request_form__c = prflst[0].Id;
        walst.add(wa3);
        
        AIA_Workplan_Assignment__c wa4 = new AIA_Workplan_Assignment__c();
        wa4.Status__c = 'In Progress';
        wa4.Workplan_Stage__c = wpslst[4].Id;
        wa4.Proposal_Request_form__c = prflst[1].Id;
        walst.add(wa4);
        
        AIA_Workplan_Assignment__c wa5 = new AIA_Workplan_Assignment__c();
        wa5.Status__c = 'In Progress';
        wa5.Workplan_Stage__c = wpslst[5].Id;
        wa5.Proposal_Request_form__c = prflst[2].Id;
        walst.add(wa5);
        
        insert walst;
        return walst;
    }
    public static List<AIA_Workplan_Assignment__c> updateWPA(List<AIA_Workplan_Assignment__c> wpalst){
        wpalst[0].Status__c = 'In Progress';
        wpalst[1].Status__c = 'Sent';        
        wpalst[2].Status__c = 'Accepted';
        wpalst[3].Status__c = 'Completed';        
        wpalst[4].Status__c = 'Not Required';
        wpalst[5].Status__c = 'Completed';
        
        update wpalst;
        return wpalst; 
    }
    public static void deleteWPA(List<AIA_Workplan_Assignment__c> wpalst){
        delete wpalst;
    }*///T01 End
  //  public static void deleteWPS(List<Workplan_Stage__c> wpslst){
  //      delete wpslst;
  //  }    
    /*-----------------------Test Methods Ends Here for WorkplanAssignmentTrigger------------------*/
 
 
    //This Test Method tests WorkplanTypeAssignmentTrigger And AIA_WorkplanTypeAssignmentTriggerHandler Class.
    
    /*-----------------------Test Methods starts Here for WorkplanTypeAssignmentTrigger------------------*/
    public static List<Group> createGroup(List<string> stn,string typ){
        List<Group> Glst = new List<Group>();
        for(string s:stn){
            Group g = new Group();
            g.Name = s;
            g.type = typ;
            Glst.add(g);
        }
        insert Glst;
        return Glst;
    }
    public static List<QueuesObject> createQueues(List<Group> gids,string typ){
        List<QueuesObject> Qlst = new List<QueuesObject>();
        for(Group g:gids){
            QueuesObject q = new QueueSObject();
            q.QueueID = g.id;
            q.SobjectType = typ;
            Qlst.add(q);
        }
        insert Qlst;
        return Qlst;
    }
   //T01-- Start 
    /*public static AIA_Workplan_Type__c createWPT(){
        AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        insert wpt;
        return wpt;
    }
    public static Workplan_Type_Stage__c createWPTS(string wptid){
        Workplan_Type_Stage__c wpts = new Workplan_Type_Stage__c();
        wpts.Workplan_Type__c = wptid;
        insert wpts;
        return wpts;
    }
    public static List<AIA_Workplan_Type_Task__c> createWPTT(string wptsid){
        /*Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Id rt_Con_51 = QueryBase.getRecordtypeId('Contact', 'X51');  
        // Create some test accounts
        Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        List<Account> accList = new List<Account>();
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_51;
        accList.add(a);
        insert accList; 
        system.assertNotEquals(NULL,accList.size());    
        list<contact> contList = new list<contact>();
        contList.add(new Contact( AccountId = accList[0].Id, FirstName = 'ContactTester1', LastName = 'ContactTester1', Email = 'CT1@CT1.com', 
                                phone = '123-123-9991', Employer_Group_Portal__c = TRUE ,RecordTypeId = rt_Con_51));
        
        insert contList;
        system.assertEquals(1,contList.size());
        
        AIA_Workplan_Type__c wptp = new AIA_Workplan_Type__c();
        wptp.active__c = true;  
        wptp.Workplan_Type__c ='Renewal';
        wptp.Used_For__c ='Pre-Sales';
        insert wptp;
       
        CreateOpportunityWithWPT(a.Id,wptp.id);
        
        List<AIA_Workplan_Type_Task__c> wpttlst = new List<AIA_Workplan_Type_Task__c>();
        AIA_Workplan_Type_Task__c wptt1 = new AIA_Workplan_Type_Task__c();
        wptt1.Workplan_Type_Stage__c = wptsid;
        wptt1.Queue_Name__c = '';
        wptt1.Send_Notification__c = true;
        wptt1.Assgin_To_Non_AIA_Contact__c = true;
        //wptt1.Contact__c = contList[0].Id;
        wpttlst.add(wptt1);
            
        AIA_Workplan_Type_Task__c wptt2 = new AIA_Workplan_Type_Task__c();
        wptt2.Workplan_Type_Stage__c = wptsid;
        wptt2.Queue_Name__c = 'TestQ2';
        wptt1.Send_Notification__c = true;
        wptt1.Assgin_To_Non_AIA_Contact__c = false;
        wpttlst.add(wptt2);
            
        AIA_Workplan_Type_Task__c wptt3 = new AIA_Workplan_Type_Task__c();
        wptt3.Workplan_Type_Stage__c = wptsid;
        wptt3.Queue_Name__c = 'TestQ3';
        wpttlst.add(wptt3);
        
        insert wpttlst;
        return wpttlst;
        
    }
    public static List<AIA_Workplan_Type_Task__c> updateWPTT(List<AIA_Workplan_Type_Task__c> ulst){
        ulst[0].Queue_Name__c = '';
        ulst[1].Queue_Name__c = 'TestQ5';
        ulst[2].Queue_Name__c = 'TestQ6';
        update ulst;
        return ulst;
    }*/
    //T01--End
    /*-----------------------Test Methods Ends Here for WorkplanTypeAssignmentTrigger------------------*/
    
    /*-----------------------------------------------------        
                        Rajesh Changes Ends
    -------------------------------------------------------*/
    
      //Goutham Changes
    //This Test Method tests BRFTrigger And AIA_BRFCloneWithProductsCX class.
    public static void AIA_BRFCloneWithProductsCX_Test(){
    
        // setup account and opportunity
        Account acct = new Account(); 
        acct.Name = 'TestAccount';
        acct.NumberOfEmployees = 45; // Num employees should always be <= 50
        acct.Sic = '0111';
        acct.EIN__c = '123456789'; // Has field validation, cannot be longer than 9 chars
        acct.BillingStreet = '1660 International Drive St. #518 Ste.500e ' +
        '1660 International Drive St. #518 Ste.500e' +
        '1660 International Drive St. #518 Ste.500e';
        acct.BillingCity = 'McLean123456789012345678902345678901';
        acct.BillingState = 'VA';
        acct.BillingPostalCode = '22102-4501'; // Has a validation rule in place 
        acct.Billing_County_Code__c = 'DCMD';
        acct.Renewal_Anniversary_Month__c = 'Nov';
        acct.Account_Legal_Name__c= 'test Account';
        insert acct;
        
        //Insert Test Record For Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        opp.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
        opp.AccountId = acct.Id;
        opp.Market_Segment_New__c = '51-199';
        opp.Business_type__c = 'Renewal';
        opp.Division__c = '51-199 New Business';
        opp.Legal_Account_Name_Verified__c =true;
        opp.Underwriting_Entity__c = 'NCAS';
        opp.Effective_Date__c =  Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
        opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);
        insert opp;

        // create a Benfit_Request_Form__c
        Benfit_Request_Form__c BRF = new Benfit_Request_Form__c();
        BRF.Opportunity__c = opp.id;
        BRF.Benefit_Effective_Date__c = system.today();
        BRF.Contract_Count__c = 14;
        BRF.Broker_Commission__c =31.0;
        BRF.Renewal_Date__c = system.today();
        BRF.Account__c = acct.id;
        BRF.Funding_Arrangements__c = 'Risk';
        
        //t05 start 
            
            BRF.EGWP_Picklist__c = 'No';
            BRF.FlexLink_Picklist__c = 'No';
            BRF.Request_Type__c = 'Prospect/New';
            BRF.Control_Plan__c = '580';
            BRF.Benefit_Period__c = 'Calendar';
            BRF.Sales_Segment_Size__c = 'commercial 200-999';
            BRF.Contract_Period__c = 'Standard - 12 Months';
            BRF.Grandfathered_Status__c = 'Grandfathered';
            BRF.Grandfathered_PPACA_Status__c = 'No';
            BRF.Stop_Loss__c = 'CareFirst';
           
            BRF.Broker_Consultant_Compensation__c = 'Commission (%)';
            BRF.Broker_Consultant_Amount__c = 5.0;
            
            BRF.Identity_Protection__c = 'No';
            BRF.Enrollment_Type__c = 'Parallel';
            
            
            //t05 end
        insert BRF;

        // create a BRF Proposed Products record
        Proposed_Products__c pp = new Proposed_Products__c();
        pp.Benefit_Request_Form__c = BRF.id;
        insert pp;

}       
    //Chida to test implemenation
    
    public static void AIA_Implemenation_Test (){ 
    
    Account acc = new Account();
        acc.Name = 'testAcc';
        acc.Type = 'testType';
        acc.Account_Legal_Name__c='Legal';
        insert acc;

    //Insert Test Record For Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Testopp';
        opp.AccountId = acc.id;
        opp.FullServiceProducer__c = 'testpro';
        opp.Legal_Account_Name_Verified__c=true;
        opp.Effective_Date__c = system.today().toStartofMonth();
        Integer numberOfDays = Date.daysInMonth(Date.Today().year(), Date.Today().month());     
        opp.Contract_End_Date__c = Date.newInstance(Date.Today().year(), Date.Today().month(), numberOfDays);
        opp.CloseDate = Date.Today() - 34;
        opp.StageName = 'test';
        insert opp;    
    //Insert test Account for Opportunity
      //  Account acc = new Account();
      AIA_Implementation__c Imp=new AIA_Implementation__c();
    //    acc.Name = 'testAcc';
     //   acc.Type = 'testType';
        Imp.Name__c = 'Test10';
        Imp.Opportunity__c = opp.id;
        //AIA_Workplan_Type__c wpt = AIA_CreateWorkPlan();//T01
        //Imp.Workplan_Type__c =wpt.id;//T01
        //Imp.Generate_Workplan_Stages__c = true;//T01
        Imp.Risk_Type__c='ASO';
        insert Imp;
        
        
        event e =new event();
        e.recordTypeId=QueryBase.getRecordtypeId('Event', 'AIA_Open_Enrollment_Meeting');
        e.Implementation__c = imp.id;
        e.whatId = imp.id;
        e.durationinminutes=90;
        e.activityDateTime =system.now();
        e.subject='TestOpenEvent';
        e.capacity__C=1;        
        insert e;       
        
    }
    
    public static void AIA_CreateEvents(){
        Account acc =createAccount('TestOEMAcc');
        Opportunity opp =AIA_createopportunity(acc.id);
        AIA_Implementation__c imp = CreateImplementation(opp.id);
        list<event> eventList = new list<event>();
        event e =new event();
        e.recordTypeId=QueryBase.getRecordtypeId('Event', 'AIA_Open_Enrollment_Meeting');
        e.Implementation__c = imp.id;
        e.whatId = imp.id;
        e.durationinminutes=90;
        e.activityDateTime =system.now();
        e.subject='TestOpenEvent';
        e.capacity__C=1;
        e.Meeting_Status__c='Open';
        eventList.add(e);
        
        e =new event();
        e.recordTypeId=QueryBase.getRecordtypeId('Event', 'AIA_Open_Enrollment_Meeting');
        e.Implementation__c = imp.id;
        e.whatId = imp.id;
        e.durationinminutes=90;
        e.activityDateTime =system.now();
        e.subject='TestFullEvent';
        e.capacity__C=1;
        e.Meeting_Status__c='Full';
        eventList.add(e);
        
        e =new event();
        e.recordTypeId=QueryBase.getRecordtypeId('Event', 'AIA_Open_Enrollment_Meeting');
        e.Implementation__c = imp.id;
        e.whatId = imp.id;
        e.durationinminutes=90;
        e.activityDateTime =system.now();
        e.subject='TestCompletedEvent';
        e.capacity__C=1;
        e.Meeting_Status__c='Completed';
        eventList.add(e);
        insert eventList;
    }
    
    public static void createContract(){
        //Create Account
        Account acc =createAccount('TestOEMAcc');
        //Create Opportunity
        Opportunity opp =AIA_createopportunity(acc.id);     
        //Create testusers
        List<user> userList = new list<user>();
        user u1 = AIA_createUser('alias1');
        userList.add(u1);
        user u2 = AIA_createUser('alias2');
        userList.add(u2);        
        user u3 = AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_createUser('alias66');
        userList.add(u6);
        user u7 = AIA_createUser('alias5');
        userList.add(u7);
        insert userList;       
        
        //Create Account teams for all the relevant roles
        AIA_createAccountTeamMember(acc.Id, u1.id, 'Auditor'); //t06
        //AIA_createAccountTeamMember(acc.Id, u2.id, 'C&C Contact');
        AIA_createAccountTeamMember(acc.Id, u3.id, 'Contract Manager');
        AIA_createAccountTeamMember(acc.Id, u4.id, 'Legal');
        //AIA_createAccountTeamMember(acc.Id, u5.id, 'Sales Service Rep');   
        AIA_createAccountTeamMember(acc.Id, u6.id, 'Benefit Contract Specialist');  
        AIA_createAccountTeamMember(acc.Id, u7.id, 'Account Manager');
        
    /*
        AIA_createAccountTeamMember(acc.Id, u1.id, 'Ancillary Analyst');
        AIA_createAccountTeamMember(acc.Id, u2.id,  'Benefact Coder');
        AIA_createAccountTeamMember(acc.Id, u3.id,  'Contract Tech');
        AIA_createAccountTeamMember(acc.Id, u4.id,  'QA Auditor');
        AIA_createAccountTeamMember(acc.Id, u5.id,  'Ancillary Analyst');        
    */
        
        //Create an Implementation
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.Id;
        Imp.account__c = acc.id;
      /*R1 changes to false*/  
      //Imp.Generate_Workplan_Stages__c = false;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
       
      
        insert Imp;
        
        //Create the contract
        contract contractRec = new contract();
        contractRec.accountId=acc.Id;
        contractRec.StartDate=system.today();
        contractRec.ContractTerm=3;
        contractRec.Implementation__c=imp.id;
        insert contractRec;
    }
        
     
    public static User createTestUser(){ 
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestclassUserBRF@testorg.com');
        insert u;
        return u;
     }  
     public static AIA_Document__c createAIADocument(){ 
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Complete';
        aiaDoc.Document_Type__c = 'Additional Documentation';
        aiaDoc.Active__c = True;
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Approval_Status__c = 'Pending';
        insert aiaDoc;
        return aiaDoc;
     } 
     
     public static AIA_Document__c createAIADocument1(id acc){ 
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Draft';
        aiaDoc.Document_Type__c = 'Quote';
        aiaDoc.Active__c = True;
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Approval_Status__c = 'Not Started';
        aiaDoc.Account__C = acc;
        insert aiaDoc;
        return aiaDoc;
     } 
     
    public static AIA_Document__c createAIADocument(String DocumentType,String Status){ 
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Complete';
        aiaDoc.Document_Type__c = DocumentType;
        aiaDoc.Active__c = True;
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Approval_Status__c = Status;
       Account acc = AIA_createAccount();
        aiaDoc.Account__c=acc.id;        
        insert aiaDoc;
        return aiaDoc;
     } 
     
     public static Proposed_Products__c createProposedProducts(string BRFID){ 
        Proposed_Products__c pp = new Proposed_Products__c();
        pp.Benefit_Request_Form__c = BRFID;
        insert pp;
        return pp;
     } 
     
     public static AIA_Grouper__c createGrouper(string PPID){
        Id PPRTypeId = Schema.SObjectType.AIA_Grouper__c.RecordTypeInfosByName.get('Proposed Product').RecordTypeId;
        AIA_Grouper__c testGrouper = new AIA_Grouper__c();
        testGrouper.Proposed_Products__c = PPID;
        testGrouper.recordtypeid=PPRTypeId;
        insert testGrouper;
        return testGrouper;
     }
     
     public static AIA_Benefits__c createBenefit(string grouperId){
        AIA_Benefits__c testBenefit = new AIA_Benefits__c();
        Id benefitPPRTypeId = Schema.SObjectType.AIA_Benefits__c.RecordTypeInfosByName.get('Proposed Product').RecordTypeId;
        //testBenefit.recordTypeId = benefitPPRTypeId;
        testBenefit.Grouper__c=grouperId;
        insert testBenefit;
        return testBenefit;
     }
     
     public static List<PRF__c> AIA_CreatePRF(string oppid){

    List<PRF__c> prfList = new list<PRF__c>();
        PRF__c prf1 = new PRF__c();
        prf1.Name = 'testprf';
        prf1.Opportunity__c = oppid;
        prf1.Alt_Network_State__c = 'MD';
        prf1.CDH_Administrator__c = 'ConnectYourCare';
        prf1.Medical_Networks__c = 'Alternative Networks';
        prf1.Medical_Products__c = 'CDH';
        prf1.CDH_Products__c = 'Blue Preferred';
        prf1.CDH_Addl_Info__c = 'Test';
        prf1.CDH_Funding_Arrangement__c = 'HSA';
        prfList.add(prf1);
        
        PRF__c prf2 = new PRF__c();
        prf2.Name = 'test1prf';
        prf2.Opportunity__c = oppid;
        prf2.Alt_Network_State__c = 'MD';
        prf2.CDH_Administrator__c = 'ConnectYourCare';
        prf2.Medical_Networks__c = 'Alternative Networks';
        prf2.Medical_Products__c = 'CDH';
        prf2.CDH_Products__c = 'Blue Preferred';
        prf2.CDH_Addl_Info__c = 'Test';
        prf2.CDH_Funding_Arrangement__c = 'HSA';
        prfList.add(prf2);
        
        PRF__c prf3 = new PRF__c();
        prf3.Name = 'test2prf';
        prf3.Opportunity__c = oppid;
        prf3.Alt_Network_State__c = 'MD';
        prf3.CDH_Administrator__c = 'ConnectYourCare';
        prf3.Medical_Networks__c = 'Alternative Networks';
        prf3.Medical_Products__c = 'CDH';
        prf3.CDH_Products__c = 'Blue Preferred';
        prf3.CDH_Addl_Info__c = 'Test';
        prf3.CDH_Funding_Arrangement__c = 'HSA';
        prfList.add(prf3);
        
        insert prfList;
        return prfList;
        
}
     
     public static Proposed_Products__c createBRFProposedProducts(string BRFID , string planid,string rtype){ 
        if(rtype=='Medical')
            rtype='Medical Risk';
        Proposed_Products__c pp = new Proposed_Products__c();
        pp.Benefit_Request_Form__c = BRFID;
        pp.Plan_Name__c=planid;
        pp.RecordTypeId= Schema.SObjectType.Proposed_Products__c.RecordTypeInfosByName.get(rtype).RecordTypeId;
       
        return pp;
     } 
     Public Static AIA_Plan__c CreateGSMPlan( String rtype, string pname){
        AIA_Plan__c p = new AIA_Plan__c ();

           p.Product_Category__c = rtype;
            p.Parent_Product__c= pname+'-parent';
            p.Product_Line__c = 'HMO';
            p.CDH__c = 'No';
            p.CDH_Type__c = 'HSA';
            p.CDH_Fund_Type__c = 'BlueFund';
            p.Plan_Id__c = pname+'001';
            p.Effective_Date__c = system.today();
            p.Termination_Date__c = system.today ();
            p.Product_Status__c ='Active';
            p.Jurisdiction__c = 'MD';
            p.RetDispnsMaintDaysSupp__c=22;
            //p.DeductibleAccumulatorMethod__c='Stacked';
            //p.OOPAccumulatorMethod__c='Stacked';
            p.Integrated_DedIndicator__c='Yes';
            p.Integrated_OOP_Indicator__c='Yes';
            //p.TierCount__c=5;
         
        
        return p;
            
    }
     
      public static List<Proposed_Products__c> createListProposedProducts(string BRFID,string testResult){ 
        List<Proposed_Products__c> ppList = new List<Proposed_Products__c>();
        for(integer i=1;i<10;i++){
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Benefit_Request_Form__c = BRFID;
            //   pp.MHP_Test_Result__c = testResult;            //T07
            ppList.add(pp);
        }
        insert ppList;
        return ppList;
     } 
     
     public static List<Proposed_Products__c> createListProposedProductsForASO(string BRFID,string testResult){ 
        List<Proposed_Products__c> ppList = new List<Proposed_Products__c>();
        for(integer i=1;i<10;i++){
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Benefit_Request_Form__c = BRFID;
            //   pp.MHP_Test_Result__c = testResult;            //T07
            pp.Blue_Rewards__c ='NO';
            ppList.add(pp);
        }
        insert ppList;
        return ppList;
     } 
     
     public static AIA_Benefit_Design__c createBenefitDesign(string oppId){ 
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = oppId;
       // Imp.Account__c = oppId.Account;
        Imp.Account__c = Imp.Opportunity__r.AccountId;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        insert Imp;
        
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        
         User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u4;


         User u5 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF355@testorg.com.test');
        insert u5;
                
                  
        
            // Step 1 - Create Account
            Account a = AIA_TestUtil.AIA_createAccount();
            // Step 2 - create Work Plan Type
            //AIA_Workplan_Type__c wpt = AIA_TestUtil.createWPT1();//T01
         
		//T08 Starts         
        /*AccountTeamMember atm3 = new AccountTeamMember ();
        atm3.TeamMemberRole = 'Underwriter'; //t06
        atm3.AccountId = a.id;
        atm3.UserId = u4.id;
        insert atm3;  

        AccountTeamMember atm4 = new AccountTeamMember ();
        atm4.TeamMemberRole = 'MAST Tech';
        atm4.AccountId = a.id;
        atm4.UserId = u5.id;
        insert atm4;         
      
        AccountTeamMember atm5 = new AccountTeamMember ();
        atm5.TeamMemberRole = 'AIA User'; //t06
        atm5.AccountId = a.id;
        atm5.UserId = u5.id;
        insert atm5; */
        
        List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        Account_Team__c atm5= new Account_Team__c();
        atm5.AccountId__c=a.id;
        atm5.TeamMemberRole__c='AIA User';
        atm5.UserId__c=u5.id;
        AccountTeamMemberList.add(atm5);
        Account_Team__c atm4= new Account_Team__c();
        atm4.AccountId__c=a.id;
        atm4.TeamMemberRole__c='MAST Tech';
        atm4.UserId__c=u5.id;
        AccountTeamMemberList.add(atm4);
        Account_Team__c atm3= new Account_Team__c();
        atm3.AccountId__c=a.id;
        atm3.TeamMemberRole__c='Underwriter';
        atm3.UserId__c=u4.id;
        AccountTeamMemberList.add(atm3);
        insert  AccountTeamMemberList;
        //T08 ends
            // Step 3 - Create Opportunity
            Opportunity o = AIA_TestUtil.CreateOpportunity(a.Id);//Updating as part of US210
            // Step 4 - Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);           
            
            
                // Step 5 -  Create BRF
                Benfit_Request_Form__c b = AIA_TestUtil.CreateBRF(p.Id,a.id);
                Proposed_Products__c pp = AIA_TestUtil.createProposedProducts(b.Id);  
                /*Proposed_Products__c pp1 = new Proposed_Products__c();
                pp1.Benefit_Request_Form__c = b.id;
                pp1.Related_Medical_Product__c = pp.Id;
                insert pp1;*/
        List<AIA_Benefit_Design__c> aiaBDLst = new List<AIA_Benefit_Design__c>();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = a.id;
        aiaBD.Benefit_Request_Form__c = b.Id;
        
        AIA_Benefit_Design__c aiaBD1 = new AIA_Benefit_Design__c();
        aiaBD1.Implementation__c = Imp.id;
        aiaBD1.Account__c = a.Id;
        aiaBD1.Benefit_Request_Form__c = b.Id;
        //aiaBDLst.add(aiaBD1);
       aiaBDLst.add(aiaBD);
        try{
            insert aiaBDLst;
        }
        catch (DMLException dex)
        {
            System.debug(dex.getMessage());
        }
        return aiaBD;
     }  
     
          public static AIA_Benefit_Design__c createBenefitDesign(string oppId,string accId){ 
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = oppId;
        Imp.Account__c = accId;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        insert Imp;
        
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        
         User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u4;


         User u5 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF355@testorg.com.test');
        insert u5;
                
                  
        
            // Step 1 - Create Account
            Account a = AIA_TestUtil.AIA_createAccount();
            // Step 2 - create Work Plan Type
           // AIA_Workplan_Type__c wpt = AIA_TestUtil.createWPT1();//T01
         
         //T08 starts
        /*AccountTeamMember atm3 = new AccountTeamMember ();
        atm3.TeamMemberRole = 'Underwriter'; //t06
        atm3.AccountId = a.id;
        atm3.UserId = u4.id;
        insert atm3;  

        AccountTeamMember atm4 = new AccountTeamMember ();
        atm4.TeamMemberRole = 'MAST Tech';
        atm4.AccountId = a.id;
        atm4.UserId = u5.id;
        insert atm4;         
      
        AccountTeamMember atm5 = new AccountTeamMember ();
        atm5.TeamMemberRole = 'AIA User'; //t06
        atm5.AccountId = a.id;
        atm5.UserId = u5.id;
        insert atm5;*/
        List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        Account_Team__c atm5= new Account_Team__c();
        atm5.AccountId__c=a.id;
        atm5.TeamMemberRole__c='AIA User';
        atm5.UserId__c=u5.id;
        AccountTeamMemberList.add(atm5);
        Account_Team__c atm4= new Account_Team__c();
        atm4.AccountId__c=a.id;
        atm4.TeamMemberRole__c='MAST Tech';
        atm4.UserId__c=u5.id;
        AccountTeamMemberList.add(atm4);
        Account_Team__c atm3= new Account_Team__c();
        atm3.AccountId__c=a.id;
        atm3.TeamMemberRole__c='Underwriter';
        atm3.UserId__c=u4.id;
        AccountTeamMemberList.add(atm3);
        insert  AccountTeamMemberList;
        //T08 ends
            // Step 3 - Create Opportunity
            Opportunity o = AIA_TestUtil.CreateOpportunity(a.Id);//Updating as part of US210
            // Step 4 - Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);           
            
            
                // Step 5 -  Create BRF
                Benfit_Request_Form__c b = AIA_TestUtil.CreateBRF(p.Id,a.id);
                Proposed_Products__c pp = AIA_TestUtil.createProposedProducts(b.Id);  
                /*Proposed_Products__c pp1 = new Proposed_Products__c();
                pp1.Benefit_Request_Form__c = b.id;
                pp1.Related_MedicalCreateBRF_Product__c = pp.Id;
                insert pp1;*/
        List<AIA_Benefit_Design__c> aiaBDLst = new List<AIA_Benefit_Design__c>();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = accId;
        aiaBD.Benefit_Request_Form__c = b.Id;
        
        AIA_Benefit_Design__c aiaBD1 = new AIA_Benefit_Design__c();
        aiaBD1.Implementation__c = Imp.id;
        aiaBD1.Account__c = accId;
        aiaBD1.Benefit_Request_Form__c = b.Id;
        //aiaBDLst.add(aiaBD1);
       aiaBDLst.add(aiaBD);
        try{
            insert aiaBDLst;
        }
        catch (DMLException dex)
        {
            System.debug(dex.getMessage());
        }
        return aiaBD;
     }  
     //T01 -- Start
    /* public static AIA_Workplan_Assignment__c createWPAssignment(List<Workplan_Stage__c> wpslst,string prfId){
        
        AIA_Workplan_Assignment__c wa = new AIA_Workplan_Assignment__c();
        wa.Status__c = 'In Progress';
        wa.Workplan_Stage__c = wpslst[0].Id;
        wa.Proposal_Request_form__c = prfId;
        insert wa;
        return wa;
     }*/
     //T01 -- End
     public static List<AIA_Implementation__c> CreateImpList(string oid){
        //T01-- Start
         /*
        AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'Renewal';
        wpt.Used_For__c = 'Implementation';
        wpt.Active__c=true;
        insert wpt;
        Workplan_Type_Stage__c wpts = new Workplan_Type_Stage__c();
        wpts.Workplan_Type__c = wpt.id;
        wpts.Active__c = true;
        insert wpts;*/
        //T01 -- End 
        
        List<AIA_Implementation__c> ImpList = new List<AIA_Implementation__c>();
        for(integer i=1;i<10;i++){
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = oid;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            //Imp.Workplan_Type__c = wpt.id;//T01
            Imp.Generate_Workplan_Stages__c = true;
            ImpList.add(Imp);
        }
        insert ImpList;
        return ImpList;
    } 
    
    public static AIA_Implementation__c CreateImplementation(string oid){
        //T01--Start
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'Renewal';
        wpt.Used_For__c = 'Implementation';
        wpt.Active__c=true;
        insert wpt;
        Workplan_Type_Stage__c wptsObj = new Workplan_Type_Stage__c();
        wptsObj.Workplan_Type__c = wpt.id;
        wptsObj.Active__c = true;
        insert wptsObj; 
        Id wps_RTID = QueryBase.getRecordtypeId('Workplan_Stage__c', 'Process');
        */
        //T01--End
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = oid;
        //Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
       // Imp.Workplan_Type__c = wpt.id;//T01
        //Imp.Generate_Workplan_Stages__c = true;
        Imp.Risk_Type__c='ASO';
        Imp.status__c='Not Started';
        insert Imp;
        
        /*T01--Start
        Workplan_Stage__c wpts = new Workplan_Stage__c();
        wpts.Workplan_Type__c = wpt.id;
        wpts.Workplan_Type_Stage__c = wptsObj.id;
        wpts.Implementation__c = Imp.id;
        wpts.Status__c = 'Completed';
        wpts.recordTypeId =wps_RTID;
        insert wpts; 
        
        Workplan_Stage__c wpts1 = new Workplan_Stage__c();
        wpts1.Workplan_Type__c = wpt.id;
        wpts1.Workplan_Type_Stage__c = wptsObj.id;
        wpts1.Implementation__c = Imp.id; 
        wpts1.Parent_Workplan_Stage__c = wpts.id;
        wpts1.Status__c = 'Not Started';
        insert wpts1; 
        *///T01--End
        return Imp;
    } 
    
    
    public static AIA_Implementation__c CreateImplementation1(string oid){
       
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = oid;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.status__c='In-Progress';
        insert Imp;
        return Imp;
    } 
    
    
    
     public static AIA_RxMandate__c createRxMandate(string PPID){
            AIA_RxMandate__c testRxMandate = new AIA_RxMandate__c();
            testRxMandate.Proposed_Products__c = PPID;
            insert testRxMandate;
            return testRxMandate;
        }
    //T02 starts --replaced std object AccountTeamMember with custom obj Account_Team__c
    /*public static AccountTeamMember AIA_createAccountTeamMember(string accId, string usrId, string strRole){
        AccountTeamMember acctMbr = new AccountTeamMember(); 
        acctMbr.AccountId = accId;
        acctMbr.TeamMemberRole = strRole;
        acctMbr.UserId = usrId;
        insert acctMbr;
        return acctMbr;
    } */ 
    public static Account_Team__c AIA_createAccountTeamMember(string accId, string usrId, string strRole){
        Account_Team__c acctMbr = new Account_Team__c(); 
        acctMbr.AccountId__c = accId;
        acctMbr.TeamMemberRole__c = strRole;
        acctMbr.UserId__c = usrId;
        insert acctMbr;
        return acctMbr;
    }
    // T02 Ends
    public static Account AIA_createImplementationAccount()     
    {       
        Account acct = new Account();       
        acct.Name = 'Test10';       
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
        acct.Renewal_Anniversary_Month__c = 'Nov';      
        acct.Account_Legal_Name__c= 'test Account';     
        insert acct;        
        return acct;        
    }   
    
     public static Attachment createAttachment(Id pId){
        Attachment attch=new Attachment();
        attch.parentId=pId;
        attch.Body=Blob.valueOf('This is test');
        attch.description='Test description';
        attch.name='Test1';
        insert attch;
        return attch;
    }
    
    /*T01--Start
    public static void createWorkplan(Workplan_Type_Stage__c wtsc){
        Workplan_Stage__c wpts = new Workplan_Stage__c();
        
        wpts.Workplan_Type_Stage__c = wtsc.id;
        insert wpts; 
        
    }
    *///T01--End
  

    Public Static AIA_Plan__c CreatePlan(string id){
        AIA_Plan__c p = new AIA_Plan__c ();

            p.Product_Category__c = 'Medical';
            p.Product_Line__c = 'Health Maintenance Organization';
            p.CDH__c = 'Yes';
            p.CDH_Type__c = 'HSA';
            p.CDH_Fund_Type__c = 'BlueFund';
            p.Plan_Id__c = 'test';
            p.Effective_Date__c = system.today();
            p.Termination_Date__c = system.today ();
            p.Product_Status__c ='Active';
            p.Jurisdiction__c = 'MD';
            p.Has_Benefit_Summary__c = TRUE;
        insert p;
        return p;
            
    }
    //Start
    // For AIA_PCSIntegrationHandler_Test code coverage improvement 7/7/17
    
     public static AIA_Benefit_Design__c cCreateBenefitDesignWImpFromBrf(String acc, string oppid, string brfid){
          
            
     AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = oppid;
        Imp.Account__c = acc;
        // Imp.Account__c = Imp.Opportunity__r.AccountId;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        //  insert Imp;
                
     AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        //aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc;
        aiaBD.Benefit_Request_Form__c = brfId;
        aiaBD.Approval_Status__c = 'Approved';
         insert aiaBD;
        return aiaBD;
    }
   
    //Creating Account Data:
    Public Static Account acc(){
        Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
         insert acc;
         return acc;
    }
    //T01 -- Start
    //Uncommenting for R1 Deployment
    //Creating Workplan Data:
    Public Static AIA_Workplan_Type__c wrkPln(String used){
        AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c = used;
        //wpt.Used_For__c  ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
         insert wpt;
         return wpt;
    }
    //T01 -- End
    
    //Creating Opportunity Data:
    Public Static Opportunity opp(String acc){
        Opportunity o = new opportunity();
        o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');    
        o.AccountId = acc;
        o.name = 'Test Opportunity';
        o.SBU__c = 'Large';
        o.Market_Segment_New__c = '1000+';
        o.Division__c = 'Commercial Business';
        o.Business_Type__c = 'New';
        o.Effective_Date__c =  Date.newInstance(2014,10,1);
        o.CloseDate = o.Effective_Date__c.addDays(-11);
        o.Legal_Account_Name_Verified__c = true;
        o.AE_Name__c = 'Test AE Name';
        o.AM_Name__c = 'Test AM Name';
        o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1);
        o.Contract_End_Date__c = o.Contract_End_Date__c.addDays(-1);
        o.type = 'Medical Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpln;//Commenting as part of US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
          insert o;
          return o;
    }
    
    //Removing WP as part of US210
     Public Static Opportunity opp1(String acc){
        Opportunity o = new opportunity();
        o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');    
        o.AccountId = acc;
        o.name = 'Test Opportunity';
        o.SBU__c = 'Large';
        o.Market_Segment_New__c = '1000+';
        o.Division__c = 'Commercial Business';
        o.Business_Type__c = 'New';
        o.Effective_Date__c =  Date.newInstance(2014,10,1);
        o.CloseDate = o.Effective_Date__c.addDays(-11);
        o.Legal_Account_Name_Verified__c = false;
        o.AE_Name__c = 'Test AE Name';
        o.AM_Name__c = 'Test AM Name';
        o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1);
        o.Contract_End_Date__c = o.Contract_End_Date__c.addDays(-1);
        o.type = 'Medical Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpln;
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
          insert o;
          return o;
    }
    public static Account createAccount1(String accountName)
    {
         // Create some test accounts
        Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account a = new Account();
        a.Name = accountName;
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_51;      
        a.Renewal_Anniversary_Month__c='Jan';
        //a.Account_Legal_Name__c= 'test Account';
        insert a;
        
        List<user> userList = new list<user>();
        user u1 = AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 = AIA_createUser('alias7');
        userList.add(u7);
        user u8 = AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_createUser('alias6');
        userList.add(u6);
         //T08 Starts
        User u11 = AIA_createUser('alias11');
        userList.add(u11);
        user u12 = AIA_createUser('alias12');
        userList.add(u12);
        user u9 = AIA_createUser('alias9');
        userList.add(u9);
        user u10 = AIA_createUser('alias10');
        userList.add(u10);
        //T08 Ends
        insert userList;  
        // 10/27 - Replaced the code above and added account team members to list
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T08
        //acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u4.id,'QA Auditor')); 
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u5.id,'MAST Tech')); 
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u1.id,'Underwriter')); //t06 
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u2.id,'AIA User')); //t06
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u11.id,'Benefit Tester'));//T08
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u12.id,'Pharmacy Operations'));//T08
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u9.id,'Vision Analyst'));//T08
        acctMbrList.add(SD_CreateAccountTeamMember(a.Id,u10.id,'Benefit Coder'));  //T08 
        insert acctMbrList;
        
        return a;
    }
    //Creating BenefitRequest form data:
    Public Static Benfit_Request_Form__c benForm(String acc, String opp){
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //nbrf.Control_Plan__c='690';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc;
        brf.Opportunity__c = opp;
        brf.Jurisdiction__c = 'MD';
        
        //t05 start 
            
            brf.EGWP_Picklist__c = 'No';
            brf.FlexLink_Picklist__c = 'No';
            brf.Request_Type__c = 'Prospect/New';
            brf.Control_Plan__c = '580';
            brf.Benefit_Period__c = 'Calendar';
            brf.Sales_Segment_Size__c = 'commercial 200-999';
            brf.Contract_Period__c = 'Standard - 12 Months';
            brf.Grandfathered_Status__c = 'Grandfathered';
            brf.Grandfathered_PPACA_Status__c = 'No';
            brf.Stop_Loss__c = 'CareFirst';
            brf.Funding_Arrangements__c = 'ASO';
            brf.Broker_Consultant_Compensation__c = 'Commission (%)';
            brf.Broker_Consultant_Amount__c = 5.0;
            
            brf.Identity_Protection__c = 'No';
            brf.Enrollment_Type__c = 'Parallel';
            
            
            //t05 end
            insert brf;
            return brf;
    }
    
    Public Static Benfit_Request_Form__c benefitForm(Id acc,Id opp){
    Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc;
        brf.Opportunity__c = opp;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
        brf.EGWP_Picklist__c = 'No';
        brf.FlexLink_Picklist__c = 'No';
        brf.Request_Type__c = 'RFP';
        brf.Benefit_Period__c= 'Contract';
        brf.Stop_Loss__c ='CareFirst';
        brf.Control_Plan__c= '690';
        brf.Sales_Segment_Size__c = 'Labor';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Mixed';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 
        brf.Contract_Count__c =5;
        brf.Identity_Protection__c= 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        
        
                insert brf;
        return brf;
    }
    //Creating AIA_Plan__c test data:
   Public Static AIA_Plan__c CreatePlan( String rtype, string pname){
            AIA_Plan__c p = new AIA_Plan__c ();
            p.Product_Category__c = rtype;
            p.Parent_Product__c= pname+'-parent';
            p.Product_Line__c = 'HMO';
            p.CDH__c = 'No';
            p.CDH_Type__c = 'HSA';
            p.CDH_Fund_Type__c = 'BlueFund';
            p.Plan_Id__c = pname+'001';
            p.Effective_Date__c = system.today();
            p.Termination_Date__c = system.today ();
            p.Product_Status__c ='Active';
            p.Jurisdiction__c = 'MD';
            p.RetDispnsMaintDaysSupp__c=22;
            //p.DeductibleAccumulatorMethod__c='Stacked';
            //p.OOPAccumulatorMethod__c='Stacked';
            p.Integrated_DedIndicator__c='Yes';
            p.Integrated_OOP_Indicator__c='Yes';
            //p.TierCount__c=5;
            p.Plan_Name__c='Test Plan';
            p.Plan_Id__c='PLAN-Test';
            p.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            p.Jurisdiction__c = 'MD';
            p.Has_Benefit_Summary__c=true;
            insert p;
            return p;
    }
    //Creating AIA_Plan__c test data:
    Public Static Proposed_Products__c proposedProduct( String benFrom, string plan){
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
        pp.Benefit_Request_Form__c = benFrom;
        pp.Funding_Arrangement__c = 'ASO';
        pp.Product_Category__c = 'Medical';
        pp.Product_Line__c = 'PPO';
        pp.Plan_Name__c = plan;
        pp.Product_Name__c = 'BlueChoice Advantage';
        pp.CDH__c = 'Yes';
        pp.CDH_Fund_Type__c = 'BlueFund';
        pp.CDH_Type__c = 'HSA';
        pp.Deductible__c = 'Stacked';
        pp.Grandfathered_Status__c = 'Grandfathered';
        pp.Integrated_Non_Integrated__c = 'Yes';
        pp.Grandfathered_PPACA_Status__c = 'No';
        pp.Blue_Rewards__c = 'No';
        pp.Out_of_Pocket_Max__c = 'Stacked';
        pp.Has_Benefit_Details__c =false;
        pp.Rider__c='None';
         insert pp;
         return pp;
    }
    //Creating AIA_PCS_Op4_ErrorCodes__c data:
    Public Static AIA_PCS_Op4_ErrorCodes__c errCode( String name, string code){
    AIA_PCS_Op4_ErrorCodes__c errorCode = new AIA_PCS_Op4_ErrorCodes__c();
        errorCode.Name = name;
        errorCode.Code__c = code;
        errorCode.Message__c = 'Mandatory field "Comment" is not available in the request';
        insert errorCode;
        return errorCode;
    }
     Public Static AIA_Benefit_Design_Product__c CreateBDP(string bd,String planid,String ppid){
        AIA_Benefit_Design_Product__c bdp = new AIA_Benefit_Design_Product__c ();

        bdp.Benefit_Design__c=bd;
        //bdp.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Product__c', rtype);
        bdp.Plan_Name__c=planid;
        bdp.Proposed_Products__c=ppid;     
        bdp.Funding_Arrangement__c = 'Risk';
        bdp.ARC_Approved__c = True;
        bdp.PCS_Custom_Plan_Id__c = null;
        bdp.PCS_Sync__c = 'Not Started';
        bdp.Custom_New__c = 'Custom';
        insert bdp;
        return bdp;
            
    }
    //Finish
    //Start 
    //Test Data for AIA_WP_SubProcess_ControllerTest code Coverage:
    //Creating data for AIA_Config__c
    Public Static AIA_Config__c aiaConf(string name){
        AIA_Config__c config = new AIA_Config__c();
        config.Name = name;
        config.Run__c = true;
        insert config;
        return config;
    }
    //Creating data for Opportunity
    public Static Opportunity oppor(String accnt){
        Opportunity opp = new Opportunity();
            opp.Name = 'Test opp';
            opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
            opp.StageName = 'RFP';
            opp.CloseDate = Date.today() + 7;
            opp.AccountId = accnt;
            opp.Market_Segment_New__c = '51-199';
            // opp.Business_type__c = 'Off-Cycle';
            opp.Division__c = '51-199 New Business';
            opp.Legal_Account_Name_Verified__c =true;
            opp.Underwriting_Entity__c = 'NCAS';
            Date tday = system.today();
            opp.Effective_Date__c =Date.newInstance(tday.Year(),tday.month(),1);  //Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
            opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
            opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
            opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);            
            opp.Off_Cycle_Term_Date__c = opp.Effective_Date__c.addDays(-1);
            
            Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;
            opp.RecordTypeId = opptwohundredplusId;
            insert opp;
        return opp;
    }
    //Creating data for Account
    Public Static Account acc(String name, String type, String legalName, String recordType){
        Account accnt = new Account();
        accnt.Name = name;
        accnt.Type = type;
        accnt.RecordTypeId = recordType;      
        accnt.Renewal_Anniversary_Month__c='Jan';
        accnt.Account_Legal_Name__c= legalName;
        insert accnt;
        Return accnt;
    } 
    //T08 replaced std Account Team member with custom 
    //Account team member data creation
    /*Public Static AccountTeamMember accTeam(String accnt,String role){
        AccountTeamMember atm = new AccountTeamMember ();
        atm.TeamMemberRole = role;
        atm.AccountId =accnt;
        atm.UserId = userinfo.getUserId();
        insert atm;
        return atm;
    }*/
    Public Static Account_Team__c accTeam(String accnt,String role){
        Account_Team__c atm = new Account_Team__c ();
        atm.TeamMemberRole__c = role;
        atm.AccountId__c =accnt;
        atm.UserId__c = userinfo.getUserId();
        insert atm;
        return atm;
    }
    
    //Creating Opportunity data with required field only
    Public Static Opportunity opporty (String accnt, String wPlan){
            Opportunity opp = new Opportunity();
            opp.Name = 'Testopp';
            opp.AccountId = accnt;
            opp.FullServiceProducer__c = 'testpro';
            opp.Legal_Account_Name_Verified__c=true;
            opp.Business_Type__c = 'new';
            opp.Effective_Date__c = system.today().toStartofMonth();
            opp.CloseDate = opp.Effective_Date__c - 1;
            opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1)-1;
            opp.StageName = 'test';
            opp.Workplan_Type__c = wPlan;
            insert opp;
            return opp;
        
    }
    //Test Data Creatation for AIA_ImplementationTriggerHelper_Test
    //Account team member data creation for Implementation haldler
    /*Public Static AccountTeamMember accTm(String accnt,String role,String usr){
        AccountTeamMember atm = new AccountTeamMember ();
        atm.TeamMemberRole = role;
        atm.AccountId =accnt;
        atm.UserId = usr;
        return atm;
    }*/
    Public Static Account_Team__c accTm(String accnt,String role,String usr){
        Account_Team__c atm = new Account_Team__c ();
        atm.TeamMemberRole__c = role;
        atm.AccountId__c =accnt;
        atm.UserId__c = usr;
        return atm;
    }
    
    //AIA_Implementation__c data creation for Implementation haldler
    Public Static AIA_Implementation__c imp(String accnt, String brf){
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = [Select Id from Opportunity LIMIT 1].id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Account__c=accnt;
        Imp.Benefit_Request_Form__c=brf;
        insert Imp;
        return Imp;
    }
    //AIA_Benefit_Design__c data creation for Implementation haldler
    Public Static AIA_Benefit_Design__c benefitDesn(String imp, String accnt, String reqFrm){
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = imp;
        aiaBD.Account__c=accnt;
        aiaBD.Benefit_Request_Form__c=reqFrm; 
        aiaBD.status__c = 'In Progress';
        insert aiaBD;
        Return aiaBD;
    }
    
    //Finish
    
    Public Static AIA_Plan__c CreateDrugPlan(string id){
        AIA_Plan__c p = new AIA_Plan__c ();

            p.Product_Category__c = 'Drug';
            p.Product_Line__c = 'Health Maintenance Organization';
            p.CDH__c = 'Yes';
            p.CDH_Type__c = 'HSA';
            p.CDH_Fund_Type__c = 'BlueFund';
            p.Plan_Id__c = 'test_drug';
            p.Effective_Date__c = system.today();
            p.Termination_Date__c = system.today ();
            p.Product_Status__c ='Active';
            p.Jurisdiction__c = 'MD';
            p.Has_Benefit_Summary__c = False;
        insert p;
        return p;
            
    }
    
    Public Static AIA_Related_Plans__c CreateRelatedPlan(string medplanid, string drugplanid){
        AIA_Related_Plans__c arp = new AIA_Related_Plans__c();
        arp.Plan__c = medplanid;
        arp.Related_Plan__c = drugplanid;
        arp.Type__c = 'Drug';
        insert arp;
        return arp;
    }
    
    public static Benfit_Request_Form__c CreateBRFASO(string pid,string aid){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom']; 
        
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        insert u;
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
        insert u2;
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
       /* AccountTeamMember atm = new AccountTeamMember ();
        atm.TeamMemberRole = 'NASCO Benefit Coder';
        atm.AccountId =a.id;
        atm.UserId = userinfo.getUserId();
        insert atm;*/
        
        /*AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'BeneFact Coder';
        atmRole.AccountId = a.id;
        atmRole.UserId = u.id;
        insert atmRole;*/
        Account_Team__c atmRole= new Account_Team__c();
        atmRole.AccountId__c=a.id;
        atmRole.UserId__c=u.id;
        atmRole.TeamMemberRole__c='BeneFact Coder';
        insert atmRole;
        
      /*  AccountTeamMember atm2 = new AccountTeamMember ();
        atm2.TeamMemberRole = 'Ancillary Analyst';
        atm2.AccountId = a.id;
        atm2.UserId = u2.id;
        insert atm2;*/
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.Business_Type__c = 'New';
        update o;
         
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        if(pid != null)
        nbrf.Proposal_Request_Form__c = pid;
              
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = aid;
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Account__c = a.id;
        nbrf.Opportunity__c = o.id;
        nbrf.Jurisdiction__c = 'MD';
        
        //t05 start 
            
            nbrf.EGWP_Picklist__c = 'No';
            nbrf.FlexLink_Picklist__c = 'No';
            nbrf.Request_Type__c = 'Prospect/New';
            nbrf.Control_Plan__c = '580';
            nbrf.Benefit_Period__c = 'Calendar';
            nbrf.Sales_Segment_Size__c = 'commercial 200-999';
            nbrf.Contract_Period__c = 'Standard - 12 Months';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Grandfathered_PPACA_Status__c = 'No';
            nbrf.Stop_Loss__c = 'CareFirst';
            nbrf.Funding_Arrangements__c = 'ASO';
            nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
            nbrf.Broker_Consultant_Amount__c = 5.0;
            
            nbrf.Identity_Protection__c = 'No';
            nbrf.Enrollment_Type__c = 'Parallel';
            
            
            //t05 end
            
            
        insert nbrf;
        return nbrf;
    }
    
   /* 
       public static AIA_Group_Structure_Management__c createGroupStructure(){ 
        AIA_Group_Structure_Management__c aiaGS = new AIA_Group_Structure_Management__c();
        aiaGS.Status__c = 'Draft';
        aiaGS.Benefit_Effective_DateInput__c = system.today();
     //   aiaGS.Control_Plan__c = '690';
        aiaGS.Par_Plan__c = 'Plan code 690 for MD';
        aiaGS.National_or_Local_Account__c = 'National';

        insert aiaGS;
        return aiaGS;
     } 
     public static AIA_Group_Structure_Notes__c createGSNotes(String note, string type, String gsid){
            AIA_Group_Structure_Notes__c gsn = new AIA_Group_Structure_Notes__c();
                gsn.Notes__c = note;
                gsn.Note_Type__c = type ;
                gsn.Group_Structure_Management__c = gsid;
                  
         return gsn;
    }
    
    public static void createListofGSMtypeCodes(Integer countofNumbers, id recordtid, String rtype){
        List<AIA_GSM_Type_Code__c> GSMtypeCodeList= new List<AIA_GSM_Type_Code__c>();
        integer num=0;
        if (rtype=='MD_GroupNumber'){
             num=1900000;
        }
        else if (rtype=='DC_GroupNumber')
             num=5800000;
        else if (rtype=='DC_DepartmentNumber' )
             num=1000;
        else if ( rtype=='MD_DepartmentNumber')
             num=5000;
        else if (rtype=='FacetNumbers')
             num=100;
        for (Integer i=0;i<countofNumbers;i++){
            AIA_GSM_Type_Code__c gtc = new AIA_GSM_Type_Code__c();
             if (rtype=='MD_GroupNumber' || rtype=='DC_GroupNumber'){
                 gtc.Name=String.valueOf(num++);
            }
            else if (rtype=='DC_DepartmentNumber' || rtype=='MD_DepartmentNumber'){
              gtc.Name='00000K'+String.valueOf(num++);
            }
            else if (rtype=='FacetNumbers')
               gtc.Name='A'+String.valueOf(num++);
            
            gtc.Status__c='Available';
            gtc.RecordTypeId=recordtid;
            GSMtypeCodeList.add(gtc);
        }       
         insert GSMtypeCodeList;
    }
    */
    public static Map<string,id> getREcordtypeforObject(String objectAPIName){
      Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(objectAPIName).getDescribe();
       List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
        Map<String,Id> mapRecordTypeNameandId = new Map<String,Id>();
        for(Schema.RecordTypeInfo info : recordTypeInfo){
         mapRecordTypeNameandId.put(info.getName(),info.getRecordTypeId());
        }
        return mapRecordTypeNameandId;
    }
    
  /*  public static AIA_Group_Structure_Management__c CreateGSMWithAllRole(){
         Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom']; 
        
        
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        insert u;
        
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
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
        insert u3;
        
        User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF4@testorg.com.test');
        insert u4;
        
        User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF5@testorg.com.test');
        insert u5;
        
        User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF6@testorg.com.test');
        insert u6;
        
        User u7 = new User(Alias = 'TAlias7', Email='TestUserBRF7@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF7@testorg.com.test');
        insert u7;
        
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'BeneFact Coder';
        atmRole.AccountId = a.id;
        atmRole.UserId = u.id;
        insert atmRole;
        
        AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Account Manager';
        atm1.AccountId =a.id;
        atm1.UserId = u1.id;
        insert atm1;
        
        AccountTeamMember atmRole1 = new AccountTeamMember ();
        atmRole1.TeamMemberRole = 'Implementation Manager';
        atmRole1.AccountId = a.id;
        atmRole1.UserId = u2.id;
        insert atmRole1;
        system.assertNotEquals(null,atmRole1.id);
        
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'Settlements Analyst';
        atmRole2.AccountId = a.id;
        atmRole2.UserId = u3.id;
        insert atmRole2;
        
         AccountTeamMember atmRole3 = new AccountTeamMember ();
        atmRole3.TeamMemberRole = 'Billing Tech';
        atmRole3.AccountId = a.id;
        atmRole3.UserId = u4.id;
        insert atmRole3;
        
        AccountTeamMember atmRole4 = new AccountTeamMember ();
        atmRole4.TeamMemberRole = 'Audit';
        atmRole4.AccountId = a.id;
        atmRole4.UserId = u5.id;
        insert atmRole4;
        
        AccountTeamMember atmRole5 = new AccountTeamMember ();
        atmRole5.TeamMemberRole = 'QA Auditor';
        atmRole5.AccountId = a.id;
        atmRole5.UserId = u6.id;
        insert atmRole5;
        
        AccountTeamMember atmRole6 = new AccountTeamMember ();
        atmRole6.TeamMemberRole = 'NASCO Benefit Coder';
        atmRole6.AccountId = a.id;
        atmRole6.UserId = u7.id;
        insert atmRole6;
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.Business_Type__c = 'New';
        update o;
        
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
    //    nbrf.Control_Plan__c='690';     
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Account__c = a.id;
        nbrf.Opportunity__c = o.id;
        nbrf.Jurisdiction__c = 'MD';
        insert nbrf;
             
         // Create Implementation
         AIA_Implementation__c i = AIA_TestUtil.CreateImp(o.id);
         system.assertNotEquals(null,i.id);            
         system.debug('nbrf::: '+nbrf);
         
         //AIA_GroupStructureApproversHelper aiaGSP = new AIA_GroupStructureApproversHelper();
         //aiaGSP.beforeUpdateTeamMember().setAccountId.add(a.id);
         
        //Create Group Structure 
        AIA_Group_Structure_Management__c aiaGS = new AIA_Group_Structure_Management__c();
        aiaGS.Status__c = 'Draft';
        aiaGS.Benefit_Effective_DateInput__c = system.today();
   //     aiaGS.Control_Plan__c = 'MD';
        aiaGS.Par_Plan__c = 'Plan code 690 for MD';
        aiaGS.National_or_Local_Account__c = 'National';
        aiaGS.Account__c = a.id;
        aiaGS.Opportunity__c = o.id;
        aiaGS.Benefit_Request_Form__c = nbrf.id;
        aiaGS.Implementation__c = i.id;
        insert aiaGS;
        return aiaGS;
    }*/
    
 /*   public static AIA_Group_Structure_Management__c CreateGSMWithAccountTeam(){
         Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom']; 
        
        
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        insert u;
        
        
        User u1 = new User(Alias = 'TAlias', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
        insert u1;
        
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'BeneFact Coder';
        atmRole.AccountId = a.id;
        atmRole.UserId = u.id;
        insert atmRole;
        
        AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Account Manager';
        atm1.AccountId =a.id;
        atm1.UserId = u1.id;
        insert atm1;
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.Business_Type__c = 'New';
        update o;
        
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
    //    nbrf.Control_Plan__c='690';     
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Account__c = a.id;
        nbrf.Opportunity__c = o.id;
        nbrf.Jurisdiction__c = 'MD';
        insert nbrf;
             
         // Create Implementation
       /*  AIA_Implementation__c i = AIA_TestUtil.CreateImp(o.id);
         system.assertNotEquals(null,i.id);            
         system.debug('nbrf::: '+nbrf);
         
         
        //Create Group Structure 
       // AIA_Group_Structure_Management__c aiaGS = new AIA_Group_Structure_Management__c();
        aiaGS.Status__c = 'Draft';
        aiaGS.Benefit_Effective_DateInput__c = system.today();
   //     aiaGS.Control_Plan__c = '690';
        aiaGS.Par_Plan__c = 'Plan code 690 for MD';
        aiaGS.National_or_Local_Account__c = 'National';
        aiaGS.Account__c = a.id;
        aiaGS.Opportunity__c = o.id;
        aiaGS.Benefit_Request_Form__c = nbrf.id;
        aiaGS.Implementation__c = i.id;
        insert aiaGS;
        return aiaGS;
    }    */
    
      public static contact createTestContactsAcc(ID accId) {
        // Create some test contacts
        // NOTE: Entity_Typed hard coded matches broker import record created in the
        //       CreateBrokerActivityData
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Id rt_Con_51 = QueryBase.getRecordtypeId('Contact', 'X51');        
        contact con=  new Contact( AccountId = accId, FirstName = 'ContactTester2', LastName = 'ContactTester2', Email = 'CT1@CT2.com', phone = '123-123-9992', Employer_Group_Portal__c = FALSE, RecordTypeId = rt_Con_51 );
     
     return   con;
   }
    
   public static AIA_Benefit_Design_Form__c createBenefitDesignFormForBD(AIA_Benefit_Design__c bd,String rtype,string bdpid)
    {
        AIA_Benefit_Design_Form__c aiaBDF = new AIA_Benefit_Design_Form__c();
        aiaBDF.Benefit_Design__c=bd.id;
        aiaBDF.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Form__c', rtype);
        //aiaBDF.Benefit_Design_Product__c=bdpid;
        aiaBDF.Child_Dependent_Mandates__c = 'DC/VA';
        aiaBDF.Michelle_s_Law_4a__c = 'Yes';
        aiaBDF.Child_Dependents_Limit_Age_4a__c =26;
        aiaBDF.Michelle_s_Law_Waiver_4a__c = 'Yes';
        aiaBDF.Students_Limit_Age_4a__c = 26; 
        aiaBDF.Child_Dependents_Removal_Method_4a__c = 'End of Calendar Month';
        aiaBDF.Students_Removal_Method_4a__c = 'End of Calendar Month';
        aiaBDF.Part_time_Students_with_Disabilities_4a__c ='No';                         
        insert aiaBDF;
        
        return aiaBDF;
    }
    
    
     public static AIA_Benefit_Design_Product__c createBDProductsForBD(AIA_Benefit_Design__c bd,String rtype,string planid,string ppid)
    {
        AIA_Benefit_Design_Product__c bdp= new AIA_Benefit_Design_Product__c();
        bdp.Benefit_Design__c=bd.id;
        bdp.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Product__c', rtype);
        bdp.Plan_Name__c=planid;
        bdp.Proposed_Products__c=ppid;     
        bdp.Funding_Arrangement__c = 'Risk';
        return bdp;
    }
    
    
    public static Limitations__c createBenefitComentCode(String benefitID, Boolean Isselect,String sType)
    {
        Limitations__c bcomment= new Limitations__c();
       
        bcomment.IsSelected__c=Isselect;
        bcomment.Benefit__c=benefitID;
        if(stype=='Maxrow')
        {
            bcomment.Type__c='MaxRow';
            bcomment.MaxDuration__c=1;
            bcomment.MaxAgeFrom__c=1;
            bcomment.MaxValue__c=3;
            bcomment.Additional_Comment__c = true;
            
        }
        if(stype=='TierLimit')
        {
            bcomment.Type__c='TierLimit';
            bcomment.TierAgeTo__c=1;
            bcomment.TierAgeFrom__c=1;
           bcomment.Jurisdiction__c='test';
            
        }
        if(stype=='Comment'){
             bcomment.comment_codes__c='some coments';
            bcomment.Code__c='456';
             bcomment.Type__c='Comment';
            bcomment.Additional_Comment__c = true;
        }
        
        return bcomment;
    }
    public static AIA_Benefit_Design__c CreateBenefitDesignWImpFromBrf(Account acc, string oppid, string brfid){
           
            Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
             
             User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB123RF@testorg.com.test');
        insert u;
        
        User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF121@testorg.com.test');
        insert u1;
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF222@testorg.com.test');
        insert u2;
        
        User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBR12F3@testorg.com.test');
        insert u3;
        
        User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB3RF4@testorg.com.test');
        insert u4;
        
        User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUse12rBRF5@testorg.com.test');
        insert u5;
        
        User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingU21serBRF6@testorg.com.test');
        insert u6;
        
        User u7 = new User(Alias = 'TAlias7', Email='TestUse11rBRF7@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='Testin11gUserBRF7@testorg.com.test');
        insert u7;
        
        User u8 = new User(Alias = 'TAla87', Email='T76estUse11rBRF7@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSery67', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='Test76564in11gUserBRF7@testorg.com.test');
        insert u8;
       
        User u9 = new User(Alias = 'TAli97', Email='Te5467stUse11rBRF7@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer776', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='Te75stin11gUserBRF7@testorg.com.test');
        insert u9;
        
        
        User u10 = new User(Alias = 'TA197', Email='Te10e11rBRF7@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing1076', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='Te10gUserBRF7@testorg.com.test');
        insert u10;
        //T08 starts
        /*AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'BeneFact Coder';
        atmRole.AccountId = acc.id;
        atmRole.UserId = u.id;
        insert atmRole;
        
        AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Account Manager';
        atm1.AccountId =acc.id;
        atm1.UserId = u1.id;
        insert atm1;
        
        AccountTeamMember atmRole1 = new AccountTeamMember ();
        atmRole1.TeamMemberRole = 'Implementation Manager';
        atmRole1.AccountId = acc.id;
        atmRole1.UserId = u2.id;
        insert atmRole1;
        system.assertNotEquals(null,atmRole1.id);
        
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'Settlements Analyst';
        atmRole2.AccountId = acc.id;
        atmRole2.UserId = u3.id;
        insert atmRole2;
        
         AccountTeamMember atmRole3 = new AccountTeamMember ();
        atmRole3.TeamMemberRole = 'Billing Tech';
        atmRole3.AccountId = acc.id;
        atmRole3.UserId = u4.id;
        insert atmRole3;
        
        AccountTeamMember atmRole4 = new AccountTeamMember ();
        atmRole4.TeamMemberRole = 'Auditor';
        atmRole4.AccountId = acc.id;
        atmRole4.UserId = u5.id;
        insert atmRole4;
        
        AccountTeamMember atmRole5 = new AccountTeamMember ();
        atmRole5.TeamMemberRole = 'QA Auditor';
        atmRole5.AccountId = acc.id;
        atmRole5.UserId = u6.id;
        insert atmRole5;
        
     
        AccountTeamMember atmRole61 = new AccountTeamMember ();
        atmRole61.TeamMemberRole = 'Contract Tech';
        atmRole61.AccountId = acc.id;
        atmRole61.UserId = u7.id;
        insert atmRole61;        
        
        AccountTeamMember atmRole62 = new AccountTeamMember ();
        atmRole62.TeamMemberRole = 'Ancillary Analyst';
        atmRole62.AccountId = acc.id;
        atmRole62.UserId = u8.id;
        insert atmRole62;        
        
        AccountTeamMember atmRole6 = new AccountTeamMember ();
        atmRole6.TeamMemberRole = 'NASCO Benefit Coder';
        atmRole6.AccountId = acc.id;
        atmRole6.UserId = u9.id;
        insert atmRole6;        
       
         AccountTeamMember atmRole15 = new AccountTeamMember ();
        atmRole15.TeamMemberRole = 'MAST Tech';
        atmRole15.AccountId = acc.id;
        atmRole15.UserId = u10.id;
        insert atmRole15;*/
        List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        AccountTeamMemberList.add(SD_CreateAccountTeamMember(acc.Id,u10.id,'MAST Tech')); 
        AccountTeamMemberList.add(SD_CreateAccountTeamMember(acc.Id,u7.id,'Contract Tech'));
        AccountTeamMemberList.add(SD_CreateAccountTeamMember(acc.Id,u5.id,'QA Auditor'));
        AccountTeamMemberList.add(SD_CreateAccountTeamMember(acc.Id,u6.id,'Auditor'));
        AccountTeamMemberList.add(SD_CreateAccountTeamMember(acc.Id,u4.id,'Billing Tech'));
        AccountTeamMemberList.add(SD_CreateAccountTeamMember(acc.Id,u3.id,'Settlements Analyst'));
        AccountTeamMemberList.add(SD_CreateAccountTeamMember(acc.Id,u2.id,'Implementation Manager'));
        AccountTeamMemberList.add(SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Manager'));
        AccountTeamMemberList.add(SD_CreateAccountTeamMember(acc.Id,u.id,'BeneFact Coder'));
        insert AccountTeamMemberList;
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = oppid;
            Imp.Account__c = acc.id;
           // Imp.Account__c = Imp.Opportunity__r.AccountId;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
          //  insert Imp;
                
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
           // aiaBD.Implementation__c = Imp.id;
            aiaBD.Account__c = acc.id;
            aiaBD.Benefit_Request_Form__c = brfId;
            insert aiaBD;
        return aiaBD;
    }
    /*Test data for AIA_GSM_GSRFProductCount*/
    public static AIA_Implementation__c gsmImp(String opp,String accnt,String brf){
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp;
        Imp.Account__c = accnt;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brf;
        insert Imp;
        return Imp;
    }
    public static AIA_Implementation__c gsmImp1(String opp,String accnt,String brf){
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp;
        Imp.Account__c = accnt;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brf;
        insert Imp;
        return Imp;
    }
    /*
    public static AIA_Group_Structure_Request_Form__c gsmGsrf(String imp){
        AIA_Group_Structure_Request_Form__c gsrf1 = new AIA_Group_Structure_Request_Form__c();
        gsrf1.Implementation__c = imp;
        gsrf1.Status__c = 'Draft - New';
        gsrf1.Processing_Type__c = 'Standard';
        insert gsrf1;
        return gsrf1;
        
    }
    public static AIA_Group_Structure_Request_Form__c gsmGsrf1(String imp){
        AIA_Group_Structure_Request_Form__c gsrf1 = new AIA_Group_Structure_Request_Form__c();
        gsrf1.Implementation__c = imp;
        gsrf1.Status__c = 'Draft - New';
        gsrf1.Processing_Type__c = 'Standard';
        insert gsrf1;
        return gsrf1;
        
    }
    public static AIA_Group_Structure_Form_Product__c gsmGsrfprod(String gsrf){
        AIA_Group_Structure_Form_Product__c gsrfp = new AIA_Group_Structure_Form_Product__c();
        gsrfp.Group_Structure_Request_Form__c = gsrf;
        gsrfp.Coverage_Level__c = 'Standard';
        gsrfp.Deductible__c = 'Two';
        insert gsrfp;
        return gsrfp;
        
    }
    */
    //T02 -- Start
    public static List<Process__c> CreateProcessList(string ImpId){
        List<Process__c> processList = new List<Process__c>();
 
         Process__c process = new Process__c();
         process.Active__c = true;
         process.Process_Name__c =  'Group Structure and Admin Setup';
         process.Used_For__c = 'Post-Sales';
         process.Version__c = 1;
         process.Implementation__c = ImpId;
         processList.add(process);
         
         process = new Process__c();
         process.Active__c = true;
         process.Process_Name__c =  'Benefit Design and Creation of NAEGS';
         process.Used_For__c = 'Post-Sales';
         process.Version__c = 1;
         process.Implementation__c = ImpId;
         processList.add(process);
         
         process = new Process__c();
         process.Active__c = true;
         process.Process_Name__c =  'Open Enrollment, Materials & Support';
         process.Used_For__c = 'Post-Sales';
         process.Version__c = 1;
         process.Implementation__c = ImpId;
         processList.add(process);

        process = new Process__c();
         process.Active__c = true;
         process.Process_Name__c =  'Benefit Coding, Loading & Testing';
         process.Used_For__c = 'Post-Sales';
         process.Version__c = 1;
         process.Implementation__c = ImpId;
         processList.add(process);
       
         insert processList;
        return processList;
    }
    
    public static List<Sub_Process__c> CreateSubProcessList(string ImpId, string ProcessId){
          List<Sub_Process__c> subProcessList = new List<Sub_Process__c>();
          Sub_Process__c sbprocess = new Sub_Process__c();  
          sbprocess.Used_For__c = 'Post-Sales';
          sbprocess.Active__c  = true;
          SBprocess.Implementation__c = ImpId;
          sbprocess.Stage__c = 'Implementation Plan';
          sbprocess.Sequence_Number__c = 1;
          sbprocess.Process__c = ProcessId;
          subProcessList.add(sbprocess);
            
         sbprocess = new Sub_Process__c();  
            sbprocess.Used_For__c = 'Post-Sales';
            sbprocess.Active__c  = true;
            sbprocess.Implementation__c = ImpId;
            sbprocess.Process__c = ProcessId;
            sbprocess.Stage__c = 'Account Kick-off Meeting';
            sbprocess.Sequence_Number__c = 2;            
            subProcessList.add(sbprocess);
         
            sbprocess = new Sub_Process__c();  
            sbprocess.Used_For__c = 'Post-Sales';
            sbprocess.Active__c  = true;
            SBprocess.Implementation__c = ImpId;
            sbprocess.Process__c = ProcessId;
            sbprocess.Stage__c = 'Group Structure';
            sbprocess.Sequence_Number__c = 3;            
            subProcessList.add(sbprocess);  
            
            sbprocess = new Sub_Process__c();  
            sbprocess.Used_For__c = 'Post-Sales';
            sbprocess.Active__c  = true;
            SBprocess.Implementation__c = ImpId;
            sbprocess.Process__c = ProcessId;
            sbprocess.Stage__c = 'Benefit Design';
            sbprocess.Status__c='Not Required';
            sbprocess.Sequence_Number__c = 4;            
            subProcessList.add(sbprocess);
                            
            insert subProcessList;
            return subProcessList;
    }
    //T02 -- End
    //T03 -- Start 
    public static List<WorkPlan_Task__c> CreateWorkPlanTask(string ImpId, string OppId, string SubProcessId, List<string> lstUserId,string TaskOwner){ //T04
        List<WorkPlan_Task__c> lstTask = new List<WorkPlan_Task__c>();
        WorkPlan_Task__c objTask;
        for(String u:lstUserId){
            objTask = new WorkPlan_Task__c();
        objTask.Task_Name__c = 'TaskName1';       
        objTask.Description__c = 'TaskDesc1';       
        objTask.OwnerId = u;       
        objTask.ExpectedDate__c = System.Today()+10;       
        objTask.Sub_Process__c = SubProcessId;       
        objTask.Opportunity__c = OppId; 
        objTask.Implementation__c = ImpId; 
        objTask.Opportunity_Implementation_ID__c = ImpId; 
        objTask.RelatedObjectId__c = ImpId; 
        objTask.SLA_Day_Type__c = 'Calendar';   
        objTask.Status__c = 'In Progress'; 
        objTask.Task_Owner__c = TaskOwner;      //T04
        lstTask.add(objTask);        
        }
        insert lstTask;
        return lstTask;
    }
    public static AIA_Area_Manager__c CreateAreaManager(string strUserId, string area_belongs_to, string areas,string alias,string profile)
    {
        AIA_Area_Manager__c usrEntry1 = new AIA_Area_Manager__c();
            usrEntry1.Area_Manager__c = strUserId;
            usrEntry1.Area_Belong_to__c = area_belongs_to;
            usrEntry1.Areas__c = areas;
            usrEntry1.Name = alias;
            usrEntry1.RecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get(profile).getRecordTypeId(); 
            
        insert usrEntry1;
        return usrEntry1;
    }
    //T03 -- End
    //
    /*Group Structure trigger test data creatation Start*/
     public static Benfit_Request_Form__c createBrfgs(string acc, string opp){
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = acc;
        //nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Opportunity__c = opp;
        nbrf.Jurisdiction__c = 'MD';
        
        //t05 start 
            
            nbrf.EGWP_Picklist__c = 'No';
            nbrf.FlexLink_Picklist__c = 'No';
            nbrf.Request_Type__c = 'Prospect/New';
            nbrf.Control_Plan__c = '580';
            nbrf.Benefit_Period__c = 'Calendar';
            nbrf.Sales_Segment_Size__c = 'commercial 200-999';
            nbrf.Contract_Period__c = 'Standard - 12 Months';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Grandfathered_PPACA_Status__c = 'No';
            nbrf.Stop_Loss__c = 'CareFirst';
            nbrf.Funding_Arrangements__c = 'ASO';
            nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
            nbrf.Broker_Consultant_Amount__c = 5.0;
            
            nbrf.Identity_Protection__c = 'No';
            nbrf.Enrollment_Type__c = 'Parallel';
            
            
            //t05 end
        
        insert nbrf;
        return nbrf;
        
    }
    public static AIA_Implementation__c createImpgs(string acc, string opp){
     AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp;
        Imp.Account__c = acc;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        insert Imp;
        return Imp;
    }
    //Added for AIADocumentAttachmentTest class code coverage Improvement.
    /*Public Static AIA_Group_Structure__c createGs(string Imp){
    AIA_Group_Structure__c gs = new AIA_Group_Structure__c();
        gs.AIA_Implementation__c = Imp;
        gs.AIA_GS_Revision_Notes__c = 'Test';
        insert gs;
        return gs;
    }*/ //Commented for R1 Deployment
   /*Group Structure trigger test data creatation End*/
    //Create necessary users and profile for all gsm classes
    public static void createUsers(Account accnt){
        //Creating User Test Data 
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u9 = AIA_TestUtil.AIA_createUser('alias9');
        userList.add(u9);
        user u10 = AIA_TestUtil.AIA_createUser('alias10');
        userList.add(u10);
        user u11 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u11); 
        user u12 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u12);
        user u13 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u13); 
        user u14 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u14);
     
        user u15 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u15);
        user u16 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u16);
         //T08 Starts
        User u18 = AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_createUser('alias19');
        userList.add(u19);
        user u20 = AIA_createUser('alias20');
        userList.add(u20);
        user u21 = AIA_createUser('alias21');
        userList.add(u21);
        //T08 Ends
         insert userList;
        
        //Creating AccountMember Test Data 
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T08 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();//T08
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u16.id,'Settlements Analyst')); //t06
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter'));  //t06
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst')); //t06
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //t06
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Implementation Manager'));
        acctMbrList.add(SD_CreateAccountTeamMember(accnt.Id,u18.id,'Benefit Tester'));//T08
        acctMbrList.add(SD_CreateAccountTeamMember(accnt.Id,u19.id,'Pharmacy Operations'));//T08
        acctMbrList.add(SD_CreateAccountTeamMember(accnt.Id,u20.id,'Vision Analyst'));//T08
        acctMbrList.add(SD_CreateAccountTeamMember(accnt.Id,u21.id,'Benefit Coder'));  //T08
        insert acctMbrList;

    }
    //Creating Opportunity Data:
    Public Static Opportunity opp(String acc, String wpln){
        Opportunity o = new opportunity();
        o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');    
        o.AccountId = acc;
        o.name = 'Test Opportunity';
        o.SBU__c = 'Large';
        o.Market_Segment_New__c = '1000+';
        o.Division__c = 'Commercial Business';
        o.Business_Type__c = 'New';
        o.Effective_Date__c =  Date.newInstance(2014,10,1);
        o.CloseDate = o.Effective_Date__c.addDays(-11);
        o.Legal_Account_Name_Verified__c = true;
        o.AE_Name__c = 'Test AE Name';
        o.AM_Name__c = 'Test AM Name';
        o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1);
        o.Contract_End_Date__c = o.Contract_End_Date__c.addDays(-1);
        o.type = 'Medical Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        o.Workplan_Type__c = wpln;
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
          insert o;
          return o;
    }
    //Creating Process__c test data
    Public Static Process__c pro(String opp, String imp){
        Process__c process = new Process__c();
        process.Implementation__c = imp;
        process.Opportunity__c = opp;
        process.Process_Condition__c = 'New';
        process.Stage__c = 'RFP';
        process.Status__c = 'Not Started';
        insert process;
        return process;
    }
   //Creating Sub_Process__c test data
    Public Static Sub_Process__c Subpro(String opp, String imp, String pro){ 
        Sub_Process__c subProcess = new Sub_Process__c();
            subProcess.Opportunity__c = opp;
            subProcess.Implementation__c = imp;
            subProcess.Process__c = pro;
            subProcess.SLA_Day_Type__c = 'Business';
            subProcess.Status__c = 'Not Started';
            subProcess.Stage__c = 'RFP';
        insert subProcess;
        return subProcess;
            }
    
}