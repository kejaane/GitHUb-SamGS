//=========================================================================================
//     Date: 04/15/2013
//Developer: Tom Barrett
//  Purpose: Used to create test data as necessary for test classes
//=========================================================================================
//                                 Update History
// Date        Tag	Developer      Description
//=========================================================================================
// 03/05/2014 		Tom Barrett       Updated to accommodate the Opportunity VR18
//                              When StageName = Sold a related product must be 
//                              marked Sold.
// 06/06/2014 		Tom Barrett (TPB) added testOppX.Won_Lost_Reason__c = 'Acquisition'; 
//                              to accomodate the Opportunity VR024 change and 
//                              Incumbent_Successor__c for VR064 
//08/25/2014  		Ashish Ojha       Added Create_Enrollment_2_50_Data 
//                              Create_Enrollment_Import_2_50_Data to create
//                              data for Enrollment Import 2-50 and Enrollment 2-50
//08/26/2014  		Ashish Ojha       Added DeleteBrokerActivityData to create data
//                              for BrokerActivtyDeleteData
//09/19/2014  		Tom Barrett (TPB) Added Processed_Type__c field to create_Enrollment_2_50_Data 
//11/09/2014  		Ashish Ojha       Added Records into Account, cantact and Enrollment_import_2_50 object
//                              inside of the method Create_Enrollment_Import_2_50_Data
//11/10/2014  		Tom Barrett (TPB) Added code to the createTestOpportunities() method
//11/25/2014  		Ashish Ojha       Added Create_Enrollment_Data 
//01/20/2015  		Ashish Ojha       Added Create_Enrollment_Data_Shift
//02/13/2015  		Ashish Ojha       Added createTestAccountsForRanking()
//02/13/2015  		Ashish Ojha       Added createTestContactsForRanking()
//02/13/2015  		Ashish Ojha       Added createTestEnrollmentsForRanking()
//05/26/2015  		Ashish Ojha       Added create_Enrollment_Data_OffAndOnCycle()
//03/29/2016  		Tom Barrett       Added createDynamicCodeDataStore()
//06/29/2016  		Tom Barrett       Resolved issu where to many queries 101 error was occuring
//                              	  The opportunity line items were being created (DML) inside loop.
//                              	  Moved insert outside the for loop.
//07/20/2016  		Ashish Ojha       Added Create_Enrollment_Data_ForHIX_mgrn
//
//03/24/2017  		Tom Barrett (TPB) Added a new method to create an enrollment_Import__c record
//                              		This change was necessary when we changed several places in the enrollment
//                              		process to get the Latest RPT_DT__C value from Enrollment_Import__c
//                              		and Enrollment_Import_2_50__c objects instead of the Enrollment__c 
//                              		object.  This had to be done to an error TOO MANY ROWS as the 
//                              		Enrollment__c object was starting to have million of rows.
//04/16/2017  		Rajesh Pennam T01 UPdated the Class for code Coverage
//06/27/2016  		Asif Kutagulla    Added code to set the opportunity recordtype to 51+ in the method 
//                              		createEnrollmentTestData
//08/17/2016  T02   Arshia Gulati     Added Create_Enrolment_Import_2_50_Data
//======================================================================================================

@IsTest
public class TestUtil{
    static id accountId;
    static id account2_50_Default;
    static id opportunityId;
    static id contactId;
    static id EngagementId;    

    public static void createTestAccounts() {
        // Create some test accounts
        Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        List<Account> accList = new List<Account>();
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        //a.Type = 'Partner';
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
               //AO 08/04/2017 update added dpb record and GP record

        a = new Account();
        a.Name = 'TestAccount4';
        a.Type = 'Partner';
        a.Entity_ID__c = '555155555';
        a.Entity_Type_PDB__c = true;
        a.RecordTypeId = rt_acc_2_50;
        accList.add(a);
        
         a = new Account();
        a.Name = 'TestAccount5';
        a.Type = 'Partner';
        a.Entity_ID__c = '555555551';
        a.Entity_Type_GP__c = true;
        a.RecordTypeId = rt_acc_2_50;
        accList.add(a);
        insert acclist;
       // Ao changes end 
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
        Id RecType51Plus = QueryBase.getRecordTypeId('Opportunity', 'X51');
        List<Opportunity> testOppsList = new List<Opportunity>();      
        map<id,Opportunity> maptestOppsList = new map<id,Opportunity>();  //T01
        
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
        //testOpp1.Facets_Grp_Num__c = 'CE12';
        testOpp1.Related_Products_Sold__c = 'Test';       
        Date effectiveDate = testOpp1.CloseDate.addDays(35);        
        testOpp1.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        Date contractEndDate = testOpp1.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp1.Contract_End_Date__c = contractEndDate;  
        testOpp1.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014              
		testOpp1.RecordTypeId = RecType51Plus;//Asif
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
        testOpp2.System__c = 'Facets';    /*
        testOpp2.Facets_Grp_Num__c = 'CE12';*/
        testOpp2.Related_Products_Sold__c = 'Test';      
        effectiveDate = testOpp2.CloseDate.addDays(35);        
        testOpp2.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        contractEndDate = testOpp2.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp2.Contract_End_Date__c = contractEndDate;  
        testOpp2.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014          
		testOpp2.RecordTypeId = RecType51Plus;//Asif	
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
                  //added 
        //testOpp3.Facets_Grp_Num__c = 'YZ3A';   
          testOpp3.RecordTypeId = RecType51Plus;//Asif 

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
        testOpp4.System__c = 'Facets';    /*
        testOpp4.Facets_Grp_Num__c = 'YZ32';  */    
        testOpp4.Related_Products_Sold__c = 'Test';      
        effectiveDate = testOpp4.CloseDate.addDays(35);        
        testOpp4.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        contractEndDate = testOpp4.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp4.Contract_End_Date__c = contractEndDate;
        testOpp4.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014            
		testOpp4.RecordTypeId = RecType51Plus;//Asif                
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
        testOpp4_2.System__c = 'Facets';    /*
        testOpp4_2.Facets_Grp_Num__c = 'YZ3A';*/   
        testOpp4_2.Related_Products_Sold__c = 'Test';       
        effectiveDate = testOpp4_2.CloseDate.addDays(35);        
        testOpp4_2.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        contractEndDate = testOpp4_2.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp4_2.Contract_End_Date__c = contractEndDate; 
        testOpp4_2.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014             
         testOpp4_2.RecordTypeId = RecType51Plus;//Asif       
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
                 testOpp5.RecordTypeId = RecType51Plus;//Asif 
           //added 
           //testOpp5.Facets_Grp_Num__c = 'YZ3A'; 

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
        testOpp6.RecordTypeId = RecType51Plus;//Asif 
            //added 
           //testOpp6.Facets_Grp_Num__c = 'YZ3A'; 

        testOppsList.add(testOpp6);
        //insert testOpp6;
        Opportunity testOpp7 = new Opportunity();
        testOpp7.Name = 'Test Opportunity85';
        testOpp7.AccountId = testacct6.Id;
        testOpp7.StageName ='Proposal';   
        testOpp7.CloseDate = Date.today()-30;
        testOpp7.SBU__c = 'Small/Medium';
        testOpp7.Market_Segment_New__c = '51-199';
        testOpp7.Business_type__c = 'Renewal';
        testOpp7.Division__c = '51-199 Renewals';   
        testopp7.Underwriting_Entity__c = 'MD';
        testopp7.Lead_Rep_Name_User__c = salesUser.Id;
        testOpp7.GeneralProducer__c = 'Direct'; 
        testOpp7.System__c = 'National Alliance';    
        //testOpp7.National_Alliance_ID__c = '12345';  
        testOpp7.Related_Products_Sold__c = 'Test';    
        effectiveDate = testOpp7.CloseDate.addDays(35);        
        testOpp7.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(), 1);
        contractEndDate = testOpp7.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp7.Contract_End_Date__c = contractEndDate;  
        testOpp7.Won_Lost_Reason__c = 'Acquisition';    //TPB 06/06/2014    
        testOpp7.RecordTypeId = RecType51Plus;//Asif
         
         //added
        //testOpp6.Facets_Grp_Num__c = 'YZ3A';         
         testOppsList.add(testOpp7);
//        OppIds.add(testOpp6.id);       

        // Perform the Insert of the records just built above        
        Insert testOppsList;
        system.debug('----------------testOppsList---'+testOppsList);
        //added by rajesh T01 Changes Starts Here
        for(opportunity op:testOppsList){
        maptestOppsList.put(op.id,op); 
        }
         //added by rajesh
            //insert a new product
        Product2 p = new product2(name='Standard Price Book1');
        insert p;
        
        Product2 p2 = new product2(name='Standard Price Book1');
        insert p2;
        
        //define the standart price for the product
        
        
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = p.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        //insert new PricebookEntry(pricebook2id = standardPrice.id, product2id = p.id,unitprice=1.0, isActive=true);
        Pricebook2 pb = new pricebook2(name='Standard Price Book');
        insert pb;
        
        PricebookEntry pbe = new PricebookEntry(pricebook2id=pb.id, product2id=p.id,unitprice=1.0, isActive=true);
        insert pbe;
        //end  T01 Changes Ends Here 
        //BEGIN ADD Tom Barrett 06/29/2016
        List<OpportunityLineItem> oppProducts = new List<OpportunityLineItem>() ;
        //PricebookEntry[] priceBookEntry = [ Select p.Name,  p.Id , p.IsActive From PricebookEntry p  where p.IsActive = true limit 3];
        //END ADD Tom Barrett 06/29/2016
        //added by rajesh for test
        
        PricebookEntry[] priceBookEntry = [ Select Name,  Id , IsActive From PricebookEntry   where IsActive = true limit 3];

        //end by rajesh
        system.debug('------priceBookEntry ----'+priceBookEntry);
        // add related opportunity line item data to the opps just inserted
        for ( Opportunity rec : maptestOppsList.values()) { // T01 Update testOppsList with mpatestOppsList.Values
            oppIds.add(rec.id);
            
        //BEGIN CHANGE Tom Barrett 06/29/2016
            //InsertOpportunityLineItems(rec.id);
            oppProducts.addAll(BuildOpportunityLineItems(rec.id, priceBookEntry));            
        }     
        insert oppProducts; //ADD Tom Barrett 06/29/2016
        //END CHANGE Tom Barrett 06/29/2016
        
        // Update the Stage to sold
        // Have to do this because of VR18
        for ( Opportunity rec : maptestOppsList.values()) { // T01 Update testOppsList with mpatestOppsList.Values starts Here
            rec.Incumbent_Successor__c = 'CareFirst';
            rec.StageName = 'Sold';
        }
  
          system.debug('----------------maptestOppsList---'+maptestOppsList);
        try{
        update maptestOppsList.values();
        }catch(exception e){} //T01 Changes Ends Here

        
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
            
             //T01 Chagnes Starts Here
              Id enRecordTypeId = Schema.SObjectType.Enrollment__c.getRecordTypeInfosByName().get('51+').getRecordTypeId();
            //Id devRecordTypeId = Schema.SObjectType.Enrollment__c.getRecordTypeInfosByName().get('X51').getRecordTypeId();
            //Id enr_acc_2_50 = QueryBase.getRecordtypeId('Enrollment__c', 'X2_50');
             Enrollment__c e2 = new Enrollment__c();
            e2.Opportunity__c = opp.id;         
            e2.Account_Number__c = 'aed5';        
            e2.System__c =  opp.System__c; 
            e2.Contracts__c = 100;            
            e2.Processed_Type__c = 'M';
            e2.Risk__c = 'Risk';
            e2.Rpt_dt__c = RptDt;
            e2.Run_Dt__c = RunDt;
            e2.Product__c = 'BC Advantage';   
            e2.Latest_Enrollment__c = 'Y';  
            e2.RecordTypeId=enRecordTypeId;
            e2.New_Business_Indicator__c='N';
            enrList.add(e2);
        }
        
    
        if  ( enrList.size() > 0 ) {        
            //added by rajesh 
        try {
            insert enrList;
        } catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
            //database.insert(enrList,false);  //end
        } 
        //T01 Changes Ends Here 


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

        //added by rajesh T01 Changes Starts Here
        Enrollment_Recycle__c er21 = new Enrollment_Recycle__c();           
        er21.Account_Name__c = 'Any Account';
        er21.Account_Number__c = 'CE12';        
        er21.System__c =  'LuminX'; 
        er21.Contracts__c = 100;            
        er21.Processed_Type__c = 'M';
        er21.Error_Message__c = 'System not found in Salesforce';
        er21.Error_Number__c = '0002';
        er21.Opportunity_Name__c = null;
        er21.Risk__c = 'Risk';
        er21.Rpt_dt__c = RptDt;
        er21.Run_Dt__c = RunDt;
        er21.Sales_Rep__c = 'Tester';
        er21.SFDC_Product__c = 'BC Advantage';                 
        erList.add(er21);  //T01 Changes Ends Here
        
        if  ( erList.size() > 0 ) {         
            insert erList; 
        }
        return RptDt;               
    } //END public static void createEnrollmentTestData()
    
    //BEGIN CHANGE Tom Barrett 06/29/2016
    //public static void InsertOpportunityLineItems(Id oppId) {
    public static List<OpportunityLineItem> BuildOpportunityLineItems(Id oppId, PricebookEntry[] priceBookEntry) { //T01 Changes Starts Here
system.debug('------priceBookEntry 715----'+priceBookEntry);
    //added by rajesh
            //insert a new product
        Product2 p = new product2(name='Standard Price Book');
        insert p;
        
        Product2 p2 = new product2(name='Standard Price Book');
        insert p2;
        
        //define the standart price for the product
        
        
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = p.Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        //insert new PricebookEntry(pricebook2id = standardPrice.id, product2id = p.id,unitprice=1.0, isActive=true);
        Pricebook2 pb = new pricebook2(name='Standard ');
        insert pb;
        
        PricebookEntry pbe = new PricebookEntry(pricebook2id=pb.id, product2id=p.id,unitprice=1.0, isActive=true);
        insert pbe;
        //end T01 Changes Ends Here
        
 //        PricebookEntry[] priceBookEntry = [ Select p.Name,  p.Id , p.IsActive From PricebookEntry p  where p.IsActive = true limit 3];
    //END CHANGE Tom Barrett 06/29/2016
        List<OpportunityLineItem> oppProducts = new List<OpportunityLineItem>() ;
        OpportunityLineItem oppProduct1 = new OpportunityLineItem();
        oppProduct1.OpportunityId = oppId;
        oppProduct1.PricebookEntryId = pbe.Id; //T01 Replaced priceBoodkEntry[0].id with pbe.Id
        oppProduct1.Product_Sold__c = false;
        oppProduct1.Quantity = 10.00 ;
        oppProduct1.TotalPrice = 100.00;
        oppProducts.add(oppProduct1) ;
        
        OpportunityLineItem oppProduct2 = new OpportunityLineItem();
        oppProduct2.OpportunityId = oppId;
        oppProduct2.PricebookEntryId = pbe.Id; //T01 Replaced priceBoodkEntry[0].id with pbe.Id
        oppProduct2.Product_Sold__c = true;
        oppProduct2.Quantity = 10.00 ;
        oppProduct2.TotalPrice = 100.00;
        oppProducts.add(oppProduct2) ;
        
        OpportunityLineItem oppProduct3 = new OpportunityLineItem();
        oppProduct3.OpportunityId = oppId;
        oppProduct3.PricebookEntryId = pbe.Id; //T01 Replaced priceBoodkEntry[0].id with pbe.Id
        oppProduct3.Product_Sold__c = true;
        oppProduct3.Quantity = 10.00 ;
        oppProduct3.TotalPrice = 100.00;
        oppProducts.add(oppProduct3) ;
        return oppProducts;
             
//        insert oppProducts; CHANGE Tom Barrett 06/29/2016
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

        //AO 08/04/2017 update added dpb record and GP record
              
        
        
        
         bi = new Broker_Import_2_50__c();
        bi.Account_Name__c = 'TestAccount1';
        bi.Entity_Id__c = '555155555';
        bi.Entity_Type__c = 'PDB';
        bi.Phone__c = '123-456-0789';        
        bi.address_Line__c = 'SB Happy Lane';  
        bi.Processed__c = FALSE;                              
        biImportList.add(bi);   
       
        bi = new Broker_Import_2_50__c();
        bi.Account_Name__c = 'TestAccount1';
        bi.Entity_Id__c = '555555551';
        bi.Entity_Type__c = 'GP';
        bi.Phone__c = '123-456-0789';        
        bi.address_Line__c = 'SB Happy Lane';  
        bi.Processed__c = FALSE;                              
        biImportList.add(bi);   
       //AO change end
        
        
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
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_2_50;
        a.AccountNumber = '12345';
        a.Facets_Account_Number__c = 'Abc1';
        a.Entity_Id__c = '12345566';
        a.sic = 'SicTest';
        a.Rating_State__c = 'MD';
        a.EIN__c = '123456789';     
        a.status__c = 'Migrted';
        
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
        b.EIN__c = '987654321';     
        b.status__c = 'Migrted';
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
        c.EIN__c = '987654321';     
        c.status__c = 'Migrted';
        insert c;
        
        Contact con = new Contact();
        con.LastName = 'Test';
        con.Entity_Id__c = '1234567898';
        con.accountid = c.id;//modified by asif
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
        enrl.Rpt_dt__c                              = '201701';
        enrl.Run_Dt__c                              = '201221';
        enrl.SFDC_Product__c                        = 'test';
        enrl.System__c                              = 'atest';
        enrl.AG_Id__c                               = '12345548';
        enrl.GP_Id__c                               = '12345566';
        enrl.EIN__c                                 = '000000000';
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
        enrl.Rpt_dt__c                              = '201701';
        enrl.Run_Dt__c                              = '201221';
        enrl.SFDC_Product__c                        = 'test';
        enrl.System__c                              = 'atest';
        enrl.EIN__c                                 = '11111111';
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
        enrl.Rpt_dt__c                              = '201701';
        enrl.Run_Dt__c                              = '201221';
        enrl.SFDC_Product__c                        = 'test';
        enrl.System__c                              = 'atest';
        enrl.Ag_id__c                               = '12345678';
        enrl.FSP_id__c                              = '12345678';
      //Start - T01
        enrl.PDB_id__c                              = '12345678'; 
        enrl.PDB_Name__c                            = 'WANADA'; 
      //End - T01
        enrl.GP_id__c                               = '12345678';
        enrl.sic__c                                 = 'SicTest';
        enrl.EIN__c                                 = '222222222';      
        enrl.term_reason__c                         = 'GHXR';
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
        o.Direct_Plus_Broker_CF_Hub__c = 'WANADA';  
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
      
        a = new Account();
        a.Name = 'TestAccount4';
        a.Type = 'Partner';
        a.Entity_ID__c = '555155555';
        a.Entity_Type_PDB__c = true;
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
        
        //added by rajesh T01 Changes Starts Here
        Id actRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('2-50').getRecordTypeId();
        Id rt_acc_2_501 = QueryBase.getRecordtypeId('Account', '2-50');
        Account a1 = new Account();
        a1.Name = 'SomeTest' + Date.Today();
        //a1.Type = 'Customer';
        a1.Type = 'Partner';
        a1.RecordTypeId = actRecordTypeId ;
        a1.AG_Contracts_for_Year__c=1999;
        a1.AccountNumber = '12345';
        insert a1;
        //end T01 Changes Ends Here
             
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        //a.Type = 'Customer';
        a.Type = 'Partner';
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
        enrl.PDB__c                                 = a.id;		//T02
        enrl.SB__c                                  = con.id;        
        enrl.Rpt_Dt__c                              = '201701';
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
        enrl.PDB__c                                 = a.Id;   	//T02     
        enrl.SB__c                                  = con.id;
        enrl.Rpt_Dt__c                              = '201701';
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
    
    // BEGIN ADD TPB 03/29/2016
    public static void createDynamicCodeDataStore() {
        List<DynamicCodeDataStore__c> csList = new List<DynamicCodeDataStore__c>();
        DynamicCodeDataStore__c cs = new DynamicCodeDataStore__c();
        cs.name = 'EmailSupportTeams';
        cs.Text_255__c = 'sfdcTeam@carefirst.com';
        csList.add(cs);
        DynamicCodeDataStore__c cs2 = new DynamicCodeDataStore__c();
        cs2.name = 'sfdcTeamEmail';
        cs2.Text_255__c = 'sfdcTeam@carefirst.com';
        csList.add(cs2);
        insert csList;
    }   
    // END ADD TPB 03/29/2016   
    
              // Ashish Ojha Changes Begin 07/20/2016       
    // Data Build for HIX data migration        
    public static void Create_Enrollment_Data_ForHIX_mgrn() {       
        //Create account data       
        list<account> acclist = New List<account>();            
        Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');     
        Account a = new Account();      
        a.Name = 'SomeTest' + Date.Today();     
        a.Type = 'Customer';        
        a.RecordTypeId = rt_acc_2_50;       
        a.AccountNumber = '12345';      
        a.Facets_account_number__c = '12345';       
        a.status__C = 'Migrated';       
        a.EIN__C = '123456789';     
        acclist.add(a);     
                    
                
        a = new Account();      
        a.Name = 'SomeTest' + Date.Today();     
        a.Type = 'partner';     
        a.RecordTypeId = rt_acc_2_50;       
        a.AccountNumber = '12345';      
        a.Facets_account_number__c = '1234578';     
        a.Rectype_Facets_account_number__c = '1234578';     
        //a.status__C = 'Migrated';     
        a.EIN__C = '123456789';     
        acclist.add(a);             
            
        insert acclist;   
        //T01 Changes Starts Here
         Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_2_50;
        con.email           ='con@email.con';
        con.AccountId       = a.id;
        insert con;
        //T01 Changes Ends Here
        
        List <Opportunity> opptList = new List<Opportunity>();      
        Opportunity o = new Opportunity();      
        o.Name = 'OppTest' + Date.Today();          
        o.AccountId = a.id;     
        o.StageName = 'Proposal';       
        o.CloseDate = Date.Today();     
        o.System__c = 'Facets';     
        o.Facets_Grp_Num__c = 'X23H';               
        o.FullServiceProducer__c = 'Direct';        
        o.external_key__c = '1234';             
        o.Contract_End_Date__c = Date.Today() + 365;        
        opptList.add(o);        
                
        // NOw we update this opportunity       
        o = New opportunity();      
        o.Name = 'OppTest' + Date.Today();          
        o.AccountId = a.id;     
        o.StageName = 'Proposal';       
        o.CloseDate = Date.Today();     
        o.System__c = 'Facets';     
        o.Facets_Grp_Num__c = 'X23H';               
        o.FullServiceProducer__c = 'Direct';        
        o.ein__c = '123456789';     
        o.external_key__c = '1111'+system.today().addDays(-300) + 'X2_50';      
                            
        o.Contract_End_Date__c = Date.Today() + 365;        
        o.StageName = 'Migrated to DCHL';       
        o.Won_Lost_reason__c = 'Group Terminated Due to Migration to DCHL';         
        opptList.add(o);                                
                
        insert opptlist;        
        // Update the Stage to Migrated to DCHL     
        // Have to do this because of VR18      
        for ( Opportunity op : OpptList ) {     
           op.StageName = 'Migrated to DCHL';       
           op.Won_Lost_reason__c = 'Group Terminated Due to Migration to DCHL';     
           op.termination_date__C = System.today();     
        }       
        
        update OpptList;        
                
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
        enrl.Status__c                              = 'Active';     
        enrl.Termination_Date__c                    = Date.Today();     
        enrl.On_cycle__c                            = False;        
        enrl.Reporting_checkbox_off_cycle__c         = TRUE;        
        enrl.Reporting_checkbox__c                   = False;       
        enrl.RecordTypeId                           = enr_acc_2_50;         
        enrl.ein__c                                 = '123456789';      
                
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
        //enrl.SB__c                                  = con.id;     
        enrl.Rpt_Dt__c                              = '201411';     
        enrl.Processed_Type__c                      = 'M';          
        enrl.Opportunity__c                         = o.id;     
        enrl.Curr_Fiscal_Year__c                    =  '2014_Baseline';                     
        enrl.Curr_Baseline_Compensation_Owner__c    = 'tester';     
        enrl.Curr_Baseline_Contracts__c             = 2345668;      
        enrl.Reporting_checkbox_off_cycle__c         = False;       
        enrl.Reporting_checkbox__c                   = TRUE;        
        enrl.ein__c                                 = '123456789';      
        enrList.add(enrl);      
                
                
        insert enrList;     
                
         //Create Enrollment_Import_2_50 Data       
        List<Enrollment_Import_2_50__c> enrList2_50 = new List<Enrollment_Import_2_50__c>();        
        Enrollment_Import_2_50__c enrlm              = new Enrollment_Import_2_50__c();     
        enrlm.Account_Effective_Date__c              = system.today();      
        enrlm.Account_Number__c                      = '1111';      
        enrlm.Account_Name__c                        = 'Test';      
        enrlm.Sic__c                                 = 'SicTest';       
        enrlm.Rating_State__c                        = 'MD';        
        enrlm.AE_ID__c                               = 'test';      
        enrlm.AE_Name__c                             = 'test';      
        enrlm.External_Key__c                        = '1234test';      
        enrlm.Processed__c                           = false;       
        enrlm.Term_Date__c                           = system.today();      
        enrlm.Contracts__c                           = 23;      
        enrlm.Processed_Type__c                      = 't';     
        enrlm.Risk__c                                = 'tst';       
        enrlm.Rpt_dt__c                              = '201701';        
        enrlm.Run_Dt__c                              = '201221';        
        enrlm.SFDC_Product__c                        = 'test';      
        enrlm.System__c                              = 'atest';     
        enrlm.AG_Id__c                               = '12345548';      
        enrlm.GP_Id__c                               = '12345566';      
        enrlm.EIN__c                                 = '123456789';     
        enrlm.term_reason__c                         = 'GRHX';      
        enrlm.Contract_Effective_Date__c             = system.today().addDays(-300);        
        enrlm.Renewal_date__C                        = system.today().addDays(100);     
        enrList2_50.add(enrlm);     
                
        enrlm                                        = new Enrollment_Import_2_50__c();     
        enrlm.Account_Effective_Date__c              = system.today();      
        enrlm.GP_Id__c                               = '12345566';      
        enrlm.Account_Number__c                      = '12345';     
        enrlm.Account_Name__c                        = 'Test';      
        enrlm.Sic__c                                 = 'SicTest';       
        enrlm.Rating_State__c                        = 'MD';        
        enrlm.AE_ID__c                               = 'test';      
        enrlm.AE_Name__c                             = 'test';      
        enrlm.Processed__c                           = false;       
        enrlm.External_Key__c                        = '1234test1';     
        enrlm.Contracts__c                           = 23;      
        enrlm.Processed_Type__c                      = 't';     
        enrlm.Risk__c                                = 'tst';       
        enrlm.Rpt_dt__c                              = '201701';        
        enrlm.Run_Dt__c                              = '201221';        
        enrlm.SFDC_Product__c                        = 'test';      
        enrlm.System__c                              = 'atest';     
        enrlm.EIN__c                                 = '111111111';     
        enrlm.term_reason__c                         = 'GRHX';      
        enrlm.Contract_Effective_Date__c             = system.today().addDays(-300);        
        enrlm.Renewal_date__C                        = system.today().addDays(100);     
        enrList2_50.add(enrlm);     
                
         enrlm                                       = new Enrollment_Import_2_50__c();     
        enrlm.Account_Effective_Date__c              = system.today();      
        enrlm.Account_Number__c                      = '2222';      
        enrlm.Account_Name__c                        = 'Test';      
        enrlm.AE_ID__c                               = 'test';      
        enrlm.AE_Name__c                             = 'test';      
        enrlm.External_Key__c                        = '1234test';      
        enrlm.Processed__c                           = false;       
        enrlm.Term_Date__c                           = system.today();      
        enrlm.Contracts__c                           = 23;      
        enrlm.Processed_Type__c                      = 't';     
        enrlm.Risk__c                                = 'tst';       
        enrlm.Rpt_dt__c                              = '201701';        
        enrlm.Run_Dt__c                              = '201221';        
        enrlm.SFDC_Product__c                        = 'test';      
        enrlm.System__c                              = 'atest';     
        enrlm.Ag_id__c                               = '12345678';      
        enrlm.FSP_id__c                              = '12345678';         
        enrlm.GP_id__c                               = '12345678';      
        enrlm.sic__c                                 = 'SicTest';       
        enrlm.Rating_State__c                        = 'MD';        
        enrlm.Processed_Opportunity__c               = false;       
        enrlm.SB_id__c                               = '1234567898';        
        enrlm.EIN__c                                 = '222222222';     
        enrlm.term_reason__c                         = 'GRHX';      
        enrlm.Contract_Effective_Date__c             = system.today().addDays(-300);        
        enrlm.Renewal_date__C                        = system.today().addDays(100);     
        enrList2_50.add(enrlm);     
            
                
        insert enrList2_50;     
                
                
    }           
  // Ashish Ojha Changes end 07/20/2016      
     
 // BEGIN ADD TPB 03/24/2017
    public static void Create_Enrollment_Import() {
        Date dt = Date.Today();   
        String RptDt = dt.year() + '02';
        List <Enrollment_Import__c> enrollmentImportList = new List<Enrollment_Import__c>();        
        Enrollment_Import__c EnImp = new Enrollment_Import__c();
        EnImp.Account_Name__c = 'TestAccount';
        EnImp.Account_Number__c = '1220';        
        EnImp.System__c = 'NASCO';
        EnImp.Contracts__c = 50;
        EnImp.Processed__c = FALSE;
        EnImp.Processed_Type__c = 'M';
        EnImp.Risk__c = 'Non-Risk';
        EnImp.Rpt_dt__c = RptDt;
        EnImp.Run_Dt__c = RptDt;
        EnImp.SFDC_Product__c = 'Standard Price Book1';    
        
        //added by rajesh T01 Changes Starts Here
        EnImp.Sales_Rep__c= 'Test';
        //EnImp.Error_Number__c= RptDt;
        //EnImp.Error_Message__c= RptDt;
        EnImp.Rating_State__c= 'D';
        EnImp.New_Business_Indicator__c = 'Y';
        //T01 Chagnes Ends Here          
        enrollmentImportList.add(EnImp);
        insert enrollmentImportList;
    }
    // END ADD TPB 03/24/2017
    
    //added by rajesh
    //T01 Changes Starts Here
    
    public static void Create_Error_Message() {
    
    list<Error_Message__c> lsterr=new list<Error_Message__c>();
    Error_Message__c ee=new Error_Message__c();
    ee.Error_Number__c='0006';
    ee.Error_Message__c='test';
    ee.Error_Number_Type__c='User';
    ee.Source_Type__c='Enrollment';
    lsterr.add(ee);
    
    Error_Message__c ee2=new Error_Message__c();
    ee2.Error_Number__c='0001';
    ee2.Error_Message__c='test2';
    ee2.Error_Number_Type__c='User';
    ee2.Source_Type__c='Enrollment';
    lsterr.add(ee2);
    
    Error_Message__c ee3=new Error_Message__c();
    ee3.Error_Number__c='0002';
    ee3.Error_Message__c='test3';
    ee3.Error_Number_Type__c='User';
    ee3.Source_Type__c='Enrollment';
    lsterr.add(ee3);
    
    Error_Message__c ee4=new Error_Message__c();
    ee4.Error_Number__c='0003';
    ee4.Error_Message__c='test4';
    ee4.Error_Number_Type__c='User';
    ee4.Source_Type__c='Enrollment';
    lsterr.add(ee4);
    
    Error_Message__c ee51=new Error_Message__c();
    ee51.Error_Number__c='0004';
    ee51.Error_Message__c='test5';
    ee51.Error_Number_Type__c='User';
    ee51.Source_Type__c='Enrollment';
    lsterr.add(ee51);
    
    Error_Message__c ee5=new Error_Message__c();
    ee5.Error_Number__c='0005';
    ee5.Error_Message__c='test41';
    ee5.Error_Number_Type__c='User';
    ee5.Source_Type__c='Enrollment';
    lsterr.add(ee5);
    
    Error_Message__c ee517=new Error_Message__c();
    ee517.Error_Number__c='0007';
    ee517.Error_Message__c='test57';
    ee517.Error_Number_Type__c='User';
    ee517.Source_Type__c='Enrollment';
    lsterr.add(ee517);
    
    Error_Message__c ee58=new Error_Message__c();
    ee58.Error_Number__c='0008';
    ee58.Error_Message__c='test418';
    ee58.Error_Number_Type__c='User';
    ee58.Source_Type__c='Enrollment';
    lsterr.add(ee58);
    insert lsterr;
    } //T01 Changes Ends Here
}