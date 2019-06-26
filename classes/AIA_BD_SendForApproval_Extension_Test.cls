@isTest
public class AIA_BD_SendForApproval_Extension_Test {
    @testsetup
    public static void createTestData() {
        
        final List<user> userList = new list<user>();
        final List<Account_Team__c> acctMbrList = new List<Account_Team__c>();
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        userList.add(u);

        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u1);
        userList.add(u2);
        userList.add(u3);
        insert userList;
        
        Account acc = AIA_TestUtil.CreateAccount('Test Account');
        
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,AIA_Constants.ACCOUNTEXECUTIVE)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,AIA_Constants.SALES_SERVICE_REP)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,AIA_Constants.PROPOSALSPECIALIST)); 
        insert   acctMbrList;
      
      Opportunity o = new opportunity();
           o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');    
           o.AccountId = acc.id;
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
           //o.Workplan_Type__c = wpt.id;//Commenting as part of US210
           o.StageName = 'RFP';
           o.FullServiceProducer__c = 'Direct';
       insert o;
       
        
      Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = acc.id;
           // nbrf.ARC_Approval_Status__c = 'Approved by Committee'; //mod by offshore
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
      insert nbrf;
       
       
        AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.Id;
            Imp.Account__c = acc.Id;
            //Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
        insert Imp;
         
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
                aiaBD.Implementation__c = Imp.id;
                aiaBD.Account__c=Acc.id;
                aiaBD.Benefit_Request_Form__c=nbrf.id;
            
        insert aiaBD;
      
    }
    public static testMethod void test1() {
        PageReference pgref = Page.AIA_BD_SendForApproval;
        Test.startTest();
        Test.setCurrentPage(pgref);
        //Account a = AIA_TestUtil.CreateAccount('TestAccount');
        //Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        //AIA_Benefit_Design__c bd = AIA_TestUtil.createBenefitDesign(o.Id);
        AIA_Benefit_Design__c aiaBD = [select id from AIA_Benefit_Design__c limit 1];
        Apexpages.StandardController sc = new Apexpages.StandardController(aiaBD);
        AIA_BD_SendForApproval_Extension sfa = new AIA_BD_SendForApproval_Extension(sc);
        sfa.updateBD();
        sfa.Back();
        sfa.updateBD();
        Test.stopTest();
    }
     public static testMethod void test2() {
        PageReference pgref = Page.AIA_BD_SendForApproval;
        Test.startTest();
         try{
        Test.setCurrentPage(pgref);
        //Account a = AIA_TestUtil.CreateAccount('TestAccount');
        //Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        //AIA_Benefit_Design__c bd = AIA_TestUtil.createBenefitDesign(o.Id);
        AIA_Benefit_Design__c aiaBD = [select id from AIA_Benefit_Design__c limit 1];
        Apexpages.StandardController sc = new Apexpages.StandardController(aiaBD);
        AIA_BD_SendForApproval_Extension sfa = new AIA_BD_SendForApproval_Extension(sc);
        sfa.updateBD();
        sfa.Back();
             sfa.objBenefitDesign.Approval_Initial_Submission_Date__c=system.today()-100000;
        sfa.updateBD();
         }
         catch(Exception e){
             
         }
        Test.stopTest();
    }
    
    public static testMethod void updateBDError(){
        
        test.startTest();
        
        //test with BCC RUL Custom profile
        Profile bccProfile = [select id from profile where name ='BCC RUL Custom' ];
        User bccUser = new User(alias = 'alias', email='alias' + '@test.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', ProfileId = bccProfile.Id, 
            timezonesidkey='Europe/London', username='alias6969'+'@test.com'
            );
        insert bccUser;
        
        AIA_Benefit_Design__c aiaBD = [select id from AIA_Benefit_Design__c limit 1];
        Apexpages.StandardController sc = new Apexpages.StandardController(aiaBD);
        AIA_BD_SendForApproval_Extension sfa = new AIA_BD_SendForApproval_Extension(sc);
        
        System.runAs(bccUser){
            sfa.updateBD();
        }
        
        test.stopTest();
    }
}