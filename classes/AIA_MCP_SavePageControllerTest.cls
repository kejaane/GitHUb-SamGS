@isTest
public class AIA_MCP_SavePageControllerTest {
@testSetup static void testdata() {
        // Creating Account Test data
        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
                
        //Creating Users Type Test Data
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias21');
        userList.add(u2);
        user u3 =AIA_TestUtil.AIA_createUser('alias31');
        userList.add(u3);
        user u4 =AIA_TestUtil.AIA_createUser('alias41');
        userList.add(u4);
        insert userList;
        
        //Creating Account Team members Test Data
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
    	acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Proposal Specialist'));
        insert acctMbrList;
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.AIA_createopportunity(acc.Id);
        
        //Creating benefit Request Form Test Data 
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Funding_Arrangements__c='Risk';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
    	
        //Creating Plan test data
    	AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Plan_Id__c='PLAN-Test';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Has_Benefit_Summary__c=true;
        insert aiapln;
    
    	//Creating BD test data
    	AIA_Benefit_Design__c bd=new AIA_Benefit_Design__c();
        bd.Benefit_Request_Form__c =brf.id;
        bd.Account__c=acc.id;
        insert bd; 
    
    	//Creating Proposed product test data
    	Proposed_Products__c pp = AIA_TestUtil.proposedProduct(brf.Id,aiapln.Id);           
        
        //Creating BDP test data
    	AIA_Benefit_Design_Product__c abdp=AIA_TestUtil.CreateBDP(bd.Id, aiapln.Id, pp.id);
        system.debug('bd.Name'+bd.Name);
    }
    
    public static testmethod void testMCPFullyManaged()
    {
         AIA_Drawloop_Package_ID__c ddps = new AIA_Drawloop_Package_ID__c();
        ddps.Name='MCP - Full Managed Care';
        ddps.DDP_ID__c='345ybvvffg';
        insert ddps;
        Test.startTest();
       
        AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c  limit 1];
        Id RecordTypeId = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('MCP - Full Managed Care').getRecordTypeId();
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bdid.id;
        bdf.Hospice_Care__c ='Yes';
        bdf.Home_Health_Care__c= 'Yes';
        bdf.RecordTypeId = RecordTypeId;
        insert bdf;
        system.assertNotEquals(bdf.Id,null);
        
        PageReference pageRef =Page.AIA_MCP_SavePage;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController stdCon=new  ApexPages.standardController(bdf);
        ApexPages.currentPage().getParameters().put('id',bdf.id);
        AIA_MCP_SavepageController controller = new AIA_MCP_SavepageController(stdCon);
        controller.getIsClassic();
        controller.export();
        controller.mcpedit();
        Test.stopTest();
        
    }
    
    public static testmethod void testMCPNonStandard()
    {
         AIA_Drawloop_Package_ID__c ddps = new AIA_Drawloop_Package_ID__c();
        ddps.Name='MCP - Non Standard';
        ddps.DDP_ID__c='345ybvvffh';
        insert ddps;
        Test.startTest();
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c  limit 1];
        Id RecordTypeId = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('MCP - Non Standard').getRecordTypeId();
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bdid.id;
        bdf.Hospice_Care__c ='Yes';
        bdf.Home_Health_Care__c= 'Yes';
        bdf.RecordTypeId = RecordTypeId;
        insert bdf;
        system.assertNotEquals(bdf.Id,null);
        system.runAs(user)
        {
        PageReference pageRef =Page.AIA_MCP_SavePage;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController stdCon=new  ApexPages.standardController(bdf);
        ApexPages.currentPage().getParameters().put('id',bdf.id);
        AIA_MCP_SavepageController controller = new AIA_MCP_SavepageController(stdCon);
        controller.getIsClassic();
        controller.export();
        controller.mcpedit();   
        }
        Test.stopTest();
        
    }
}