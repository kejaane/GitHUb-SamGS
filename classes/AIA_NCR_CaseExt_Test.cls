/*************************************************************************************************************************************************
*  Class            : 
*  Author           : Rajesh Pennam
*  Version History  : 1.0
*  Creation         : 07/27/2017
*  Description      : This class is ffor the code coverage for AIA_Admin_Form_Contorller
*
*  Modification Log:
* ----------------------------------------------------------------------------------------------------------------------------------------------
*  Author          Date-Modified      Tag      Description of Change
* ----------------------------------------------------------------------------------------------------------------------------------------------
* Rajesh Pennam     07/27/2017               Initial Development

*************************************************************************************************************************************************/

@istest
public class AIA_NCR_CaseExt_Test{
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
        
        //Removing per US210
            //Creating WorkPlan Type Test Data 
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c(); 
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;*/
        
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
        insert userList;
        
        //Create Account Team
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Proposal Specialist'));
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
             Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
    brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
    brf.Contract_Count__c = 123;
    brf.Benefit_Effective_Date__c = system.today();
    brf.Account__c = acc.id;
    brf.ARC_Approval_Status__c = '';//'Approved by Committee';
    brf.Escalated_to_Senior_Management__c = true;
    brf.Status__c = 'new';
    brf.Opportunity__c = o.id;
    brf.Jurisdiction__c = 'MD';
    brf.Enrollment_Type__c = 'Cafeteria';
    brf.Request_Type__c = 'Prospect/New';
    insert brf;
    Test.startTest();
       AIA_Implementation__c Imp1 = new AIA_Implementation__c();
    Imp1.Name__c = 'testprf';
    Imp1.Opportunity__c = o.Id;
    Imp1.Account__c = acc.Id;
    //Imp1.Generate_Workplan_Stages__c = true;
    Imp1.Effective_Date__c = system.today();
    Imp1.Implementation_Plan_Timeline_Days__c = '60';
    Imp1.Risk_Type__c='ASO';
    Imp1.Benefit_Request_Form__c = brf.id;
    insert Imp1;     
     Test.stopTest();    
    }
  }  
    
    private static testMethod void Test1(){
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
         
        Opportunity opp = [select id,name from opportunity limit 1];    
        system.debug('opp***'+opp);
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA NCR Cases').getRecordTypeId();
        System.debug('devRecordTypeId ****'+devRecordTypeId);       
        Case cs = new Case();
        cs.Status= 'New';
        cs.Origin = 'ILog';
        cs.Recordtypeid=devRecordTypeId;
        insert cs;
        system.assertNOTEquals(cs,Null);
        
        system.debug('CS^^^^^'+cs);
        list<case> cslst = [select id,origin,status from case];
        system.debug('cslst^^^^**'+cslst);
        PageReference pageRef1 =Page.AIA_NCR_Case_Creation;
        pageRef1.getParameters().put('id',String.ValueOf(opp.id));
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardSetController sc = new ApexPages.standardSetController(cslst);
        AIA_NCR_CaseExt ncrExt = new AIA_NCR_CaseExt(sc);
        system.assertNotEquals(pageRef1 .getUrl(),null);
        Test.startTest();
        ncrExt.save();
        ncrExt.pageNavigation();
        ncrExt.ContactName = 'test';
        ncrExt.isClassic = false;
        ncrExt.pageNavigation();
        ncrExt.cancelFun();
        
        system.assertNotEquals(pageRef1 .getUrl(),null);
        Test.stopTest();
       } 
     }  
     private static testMethod void Test2(){
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
         
        AIA_Implementation__c opp = [select id,name from AIA_Implementation__c limit 1];    
        system.debug('opp***'+opp);
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA NCR Cases').getRecordTypeId();
        System.debug('devRecordTypeId ****'+devRecordTypeId);       
        Case cs = new Case();
        cs.Status= 'New';
        cs.Origin = 'ILog';
        cs.Recordtypeid=devRecordTypeId;
        insert cs;
        system.assertNOTEquals(cs,Null);
        
        system.debug('CS^^^^^'+cs);
        list<case> cslst = [select id,origin,status from case];
        system.debug('cslst^^^^**'+cslst);
        PageReference pageRef1 =Page.AIA_NCR_Case_Creation;
        pageRef1.getParameters().put('id',String.ValueOf(opp.id));
        Test.setCurrentPage(pageRef1);
        
        ApexPages.StandardSetController sc = new ApexPages.standardSetController(cslst);
        AIA_NCR_CaseExt ncrExt = new AIA_NCR_CaseExt(sc);
        system.assertNotEquals(pageRef1 .getUrl(),null);
        ncrExt.save();
        ncrExt.pageNavigation();
        ncrExt.ContactName = 'test';
        ncrExt.isClassic = false;
        ncrExt.pageNavigation();
        ncrExt.cancelFun();
        system.assertNotEquals(pageRef1 .getUrl(),null);
       } 
     }  
            
    }