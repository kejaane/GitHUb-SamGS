/*=================================================================================================================
 * Date         : 07/27/2018
 * Developer    : Gayathri Palanisamy
 * Purpose      : This i sthe test class for AIA_BD_Case and AIA_Account_Issue_Case Classes
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 07/27/2018 | Gayathri 	   |     | 		Initial Version
 * 01-18-2019 	Chaithra 		|T01| 		Created users for account team role as per US1702 and US1730
 * 02/05/2019	Chaithra	 	|T02|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
 *=================================================================================================================
 */
@istest
public class AIA_BD_Account_Issue_CaseExtTest {
@testSetup Static void testdata() {

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u222 = AIA_TestUtil.createTestUser();
        
        System.runAs(u222){
    
        //Create Test Accounts
        Account acc = new Account();
        acc.Name = 'TestAccount1';
        acc.Type = 'Customer';
        acc.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X51');       
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Jurisdiction__c = 'MD';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        system.assertNOTEquals(acc,Null);
        
        //Create Users to insert in Account Team Roles
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias21');
        userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias71');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias81');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias31');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias41');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias51');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias61');
        userList.add(u6);
        user u9 = AIA_TestUtil.AIA_createUser('alias91');
        userList.add(u9);
        user u = AIA_TestUtil.AIA_createUser('alias0');
        userList.add(u);
        user u10 = AIA_TestUtil.AIA_createUser('alias10');
        userList.add(u10);
        //Creating User Test Data T01 starts
        user u17 = AIA_TestUtil.AIA_createUser('aliasg17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('aliasg18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('aliasg17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('aliasg18');
        userList.add(u20);
		//T01 ends   
        insert userList;
        
        //Create Account Team
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Proposal Specialist'));
        //Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T01 ends
        insert acctMbrList;
        
        
        
        //Create Test Opportunity
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
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        //o.Jurisdiction__c = 'MD';
        insert o;
        system.assertNOTEquals(o,Null);
        Test.startTest();    
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
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
        brf.Funding_Arrangements__c = 'ASO';
        insert brf;
            
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Account__c=acc.id;
        Imp.Benefit_Design_Revision_Date__c=system.today();
		Imp.Benefit_Request_Form__c=brf.id;
            insert Imp;
        
        AIA_Benefit_Design__c bd = new AIA_Benefit_Design__c();
            bd.Account__c = acc.id;
            bd.Implementation__c = Imp.id;
            bd.Benefit_Request_Form__c = brf.id;
            insert bd;
           
            
          
        Test.stopTest();
    }
  }
    private static testMethod void TestImpAccIssueInvalid(){
    User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'AIA 200+ Standard User - Custom'].Id,
     LastName = 'last',
     Email = 'puser000@Test.com',
     Username = 'puser000@Test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',                
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US');
    
     insert u;
     
     system.runAS (u) {
         
        AIA_Implementation__c Imp = [select id,name from AIA_Implementation__c limit 1];    
        system.debug('Imp***'+Imp);
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA Account Issue').getRecordTypeId();
        System.debug('devRecordTypeId ****'+devRecordTypeId);       
        Case cs = new Case();
        cs.Status= 'New';
         cs.Priority = 'Medium';
         cs.Issue_Frequency__c = 'Account Specific';
        cs.Origin = 'Email';
        cs.Recordtypeid=devRecordTypeId;
        
        List<Case> cslst = new List<Case>();
        cslst.add(cs);           
        PageReference pageRef1 =Page.AIA_Account_Issue_Case;
        pageRef1.getParameters().put('id',String.ValueOf(Imp.id));
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardSetController sc = new ApexPages.standardSetController(cslst);
        AIA_Account_Issue_CaseExt accExt = new AIA_Account_Issue_CaseExt(sc);
         accExt.isAssignmentRule=true;
        system.assertNotEquals(pageRef1 .getUrl(),null);
        accExt.save();
        accExt.pageNavigation();
        accExt.isClassic = false;
        accExt.cancelFun();
        system.assertNotEquals(pageRef1 .getUrl(),null);
       } 
    }
    
    private static testMethod void TestImpAccIssue(){
    User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'AIA 200+ Standard User - Custom'].Id,
     LastName = 'last',
     Email = 'puser000@Test.com',
     Username = 'puser000@Test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',                
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US');
    
     insert u;
     
     system.runAS (u) {
         
        AIA_Implementation__c Imp = [select id,name from AIA_Implementation__c limit 1];    
        system.debug('Imp***'+Imp);
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA Account Issue').getRecordTypeId();
        System.debug('devRecordTypeId ****'+devRecordTypeId);       
        Case cs = new Case();
        cs.Status= 'New';
        cs.Priority = 'Medium';
        cs.Issue_Category__c = 'Pre-Sales';
        cs.Issue_Sub_Category__c='RFP';
        cs.Origin = 'Email';
        cs.Recordtypeid=devRecordTypeId;
        
        List<Case> cslst = new List<Case>();
        cslst.add(cs);           
        PageReference pageRef1 =Page.AIA_Account_Issue_Case;
        pageRef1.getParameters().put('id',String.ValueOf(Imp.id));
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardSetController sc = new ApexPages.standardSetController(cslst);
        AIA_Account_Issue_CaseExt accExt = new AIA_Account_Issue_CaseExt(sc);
        accExt.pageNavigation();
        accExt.accountCase = cs;
        accExt.save();
        
        system.assertNotEquals(pageRef1 .getUrl(),null);
       } 
    }
    
    private static testMethod void TestAccIssue(){
    User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'AIA 200+ Standard User - Custom'].Id,
     LastName = 'last',
     Email = 'puser000@Test.com',
     Username = 'puser000@Test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',                
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US');
    
     insert u;
     
     system.runAS (u) {
         
        Account acc = [select id,name from Account limit 1];    
        system.debug('acc***'+acc);
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA Account Issue').getRecordTypeId();
        System.debug('devRecordTypeId ****'+devRecordTypeId);       
        Case cs = new Case();
        cs.Status= 'New';
        cs.Priority = 'Medium';
        cs.Issue_Category__c = 'Pre-Sales';
        cs.Issue_Sub_Category__c='RFP';
        cs.Origin = 'Email';
        cs.Recordtypeid=devRecordTypeId;
        
        List<Case> cslst = new List<Case>();
        cslst.add(cs);           
        PageReference pageRef1 =Page.AIA_Account_Issue_Case;
        pageRef1.getParameters().put('id',String.ValueOf(acc.id));
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardSetController sc = new ApexPages.standardSetController(cslst);
        AIA_Account_Issue_CaseExt accExt = new AIA_Account_Issue_CaseExt(sc);
        accExt.pageNavigation();
        accExt.accountCase = cs;
        accExt.save();
        
        system.assertNotEquals(pageRef1 .getUrl(),null);
       } 
    }
    
    private static testMethod void TestBDAccIssue(){
    User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'AIA 200+ Standard User - Custom'].Id,
     LastName = 'last',
     Email = 'puser000@Test.com',
     Username = 'puser000@Test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',                
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US');
    
     insert u;
     
     system.runAS (u) {
         
        AIA_Benefit_Design__c bd = [select id,name from AIA_Benefit_Design__c limit 1];    
        system.debug('bd***'+bd);
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA Account Issue').getRecordTypeId();
        System.debug('devRecordTypeId ****'+devRecordTypeId);       
        Case cs = new Case();
        cs.Status= 'New';
        cs.Priority = 'Medium';
        cs.Issue_Category__c = 'Pre-Sales';
        cs.Issue_Sub_Category__c='RFP';
        cs.Origin = 'Email';
        cs.Recordtypeid=devRecordTypeId;
        
        List<Case> cslst = new List<Case>();
        cslst.add(cs);           
        PageReference pageRef1 =Page.AIA_Account_Issue_Case;
        pageRef1.getParameters().put('id',String.ValueOf(bd.id));
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardSetController sc = new ApexPages.standardSetController(cslst);
        AIA_Account_Issue_CaseExt accExt = new AIA_Account_Issue_CaseExt(sc);
        accExt.pageNavigation();
        accExt.accountCase = cs;
        accExt.save();
        
        system.assertNotEquals(pageRef1 .getUrl(),null);
       } 
    }
    private static testMethod void TestBDCaseIssue(){
    User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'AIA 200+ Standard User - Custom'].Id,
     LastName = 'last',
     Email = 'puser000@Test.com',
     Username = 'puser000@Test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',                
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US');
    
     insert u;
     
     system.runAS (u) {
         
        AIA_Benefit_Design__c bd = [select id,name from AIA_Benefit_Design__c limit 1];    
        system.debug('bd***'+bd);
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA Account Issue').getRecordTypeId();
        System.debug('devRecordTypeId ****'+devRecordTypeId);       
        Case cs = new Case();
        cs.Status= 'New';
        cs.Priority = 'Medium';
        cs.Issue_Category__c = 'Pre-Sales';
        cs.Issue_Sub_Category__c='RFP';
        cs.Origin = 'Email';
        cs.Recordtypeid=devRecordTypeId;
        
        List<Case> cslst = new List<Case>();
        cslst.add(cs);           
        PageReference pageRef1 =Page.AIA_BD_Case;
        pageRef1.getParameters().put('id',String.ValueOf(bd.id));
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardSetController sc = new ApexPages.standardSetController(cslst);
        AIA_BD_Case bdExt = new AIA_BD_Case(sc);
        bdExt.pageNavigation();
        bdExt.BDCase = cs;
        bdExt.save();
        bdExt.isClassic = false;
        bdExt.cancelFun();
        system.assertNotEquals(pageRef1 .getUrl(),null);
       } 
    }
}