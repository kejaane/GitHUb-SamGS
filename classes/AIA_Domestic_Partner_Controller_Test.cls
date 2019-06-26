/*=================================================================================================
* Date         : 09/22/2017
* Developer    : Ravi Teja
* Purpose      : This class function is test class for AIA_Domestic_Partner_Controller
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 09/22/2017| Raviteja    |     | Initial Version                                         
*01-18-2019 	Chaithra 		|T01| Created users for account team role as per US1702 and US1730
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_Domestic_Partner_Controller_Test {
    @testSetup static void testdata() {
        // Creating Account Test data
        Account acc = new Account();
        acc.Name = 'TestAccount1';
        acc.Type = 'Customer';
        acc.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X51');       
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        
        //Commenting as part of US210
        /*//Creating WorkPlan Type Test Data 
        AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;*/
        
        //Creating Users Type Test Data
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
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T01 ends
        insert userList;
        
        //Creating Account Team members Test Data
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
        //Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T01 ends
        insert acctMbrList;
        
        //Creating Opportunity Test Data   
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
        //o.Workplan_Type__c = wpt.id;//Change as part of US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        
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
    }
    private static testMethod void unitTest(){
        Test.startTest();
        PageReference pageRef =Page.AIA_MCP_DL_ManagedCare;
        Test.setCurrentPage(pageRef);
        Benfit_Request_Form__c brfObj = [Select Id From Benfit_Request_Form__c  limit 1];
        account acc = [Select Id From account  limit 1];
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Plan_Id__c='PLAN-Test';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Has_Benefit_Summary__c=true;
        insert aiapln;
        AIA_Benefit_Design__c bd=new AIA_Benefit_Design__c();
        bd.Benefit_Request_Form__c =brfObj.id;
        bd.Account__c=acc.id;
        insert bd;              	
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bd.id;
        insert bdf;
        Id RecordTypeIdAdmin = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c  limit 1];
        //domestic
        PageReference pageRef1 =Page.AIA_Domestic_Partner_DL;
        Test.setCurrentPage(pageRef1);
        ApexPages.currentPage().getParameters().put('retURL',bd.id);
        ApexPages.standardController stdCon=new  ApexPages.standardController(bdf);
        AIA_Domestic_Partner_Controller bdfsave1=new AIA_Domestic_Partner_Controller(stdCon);
        Id RecordTypeId1 = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Domestic Partner - Self Insured Only').getRecordTypeId();
        system.debug('bd.Name'+bd.Name);
        ApexPages.currentPage().getParameters().put('node',bdid.Name );
        ApexPages.currentPage().getParameters().put('RecordType',RecordTypeId1 );
        bdfsave1.getGroupers();
        //bdfsave1.save();
        bdfsave1.getIsClassic();
        bdfsave1.savenew();
        bdfsave1.cancel();
    }
    private static testMethod void unitTest2(){
        try{
            Test.startTest();
            PageReference pageRef =Page.AIA_MCP_DL_ManagedCare;
            Test.setCurrentPage(pageRef);
            Benfit_Request_Form__c brfObj = [Select Id From Benfit_Request_Form__c  limit 1];
            account acc = [Select Id From account  limit 1];
            AIA_Benefit_Design__c bd=new AIA_Benefit_Design__c();
            bd.Benefit_Request_Form__c =brfObj.id;
            bd.Account__c=acc.id;
            insert bd;              	
            AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
            bdf.Benefit_Design__c=bd.id;
            insert bdf;
            Id RecordTypeIdAdmin = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
            AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c  limit 1];
            //domestic
            PageReference pageRef1 =Page.AIA_Domestic_Partner_DL;
            Test.setCurrentPage(pageRef1);
            ApexPages.standardController stdCon1=new  ApexPages.standardController(bdf);
            AIA_Domestic_Partner_Controller bdfsave1=new AIA_Domestic_Partner_Controller(stdCon1);
            Id RecordTypeId1 = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Domestic Partner - Self Insured Only').getRecordTypeId();
            system.debug('bd.Name'+bd.Name);
            ApexPages.currentPage().getParameters().put('node',bdid.Name );
            ApexPages.currentPage().getParameters().put('RecordType',RecordTypeId1 );
            bdfsave1.getGroupers();
            //bdfsave1.save();
            bdfsave1.cancel();
        }
        catch(Exception e){
            system.debug('for catch coverage');
        }
    }
}