@isTest
public class AIA_Ben_Form_redExtensionTest {
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
        
       //Creating User Test Data 
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
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
        user u10 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u10); 
        user u11 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u11);
    	user u12 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u12); 
        user u13 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u13);
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
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u13.id,'Implementation Manager'));
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
        //o.Workplan_Type__c = wpt.id;//Commenting as part of US210
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
        bdf.Hospice_Care__c ='Yes';
        bdf.Home_Health_Care__c= 'Yes';
        insert bdf;
        AIA_Benefit_Design_Form__c bdf1=new AIA_Benefit_Design_Form__c();
        bdf1.Benefit_Design__c=bd.id;
        bdf1.Hospice_Care__c ='Yes';
        bdf1.Home_Health_Care__c= 'Yes';
        bdf1.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Domestic Partner - Self Insured Only').getRecordTypeId();
        insert bdf1;
        Id RecordTypeIdAdmin = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c  limit 1];
        
        AIA_Benefit_Design_Form__c bdfadmin=new AIA_Benefit_Design_Form__c();
        bdfadmin.Benefit_Design__c=bd.id;
        bdfadmin.Hospice_Care__c ='Yes';
        bdfadmin.Home_Health_Care__c= 'Yes';
        bdfadmin.Group_Numbers__c='test1,test2';
        bdfadmin.RecordTypeId=RecordTypeIdAdmin;
        insert bdfadmin;
        
        
        
        system.debug('bd.Name'+bd.Name);
        PageReference pageRef =Page.AIA_Ben_Form_Redirect_RecordType;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController stdCon=new  ApexPages.standardController(bdf);
        ApexPages.currentPage().getParameters().put('retURL',bd.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAke',bd.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAke_lkid',bd.id);
        AIA_Ben_Form_RedirectExtensionController rec=new AIA_Ben_Form_RedirectExtensionController(stdCon);
        rec.Selected= Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        rec.getItems();
        rec.selectedvalue();
        
        PageReference pageRef1 =Page.AIA_Ben_Form_Redirect_RecordType;
        Test.setCurrentPage(pageRef1);
        ApexPages.standardController stdCon1=new  ApexPages.standardController(bdf1);
        ApexPages.currentPage().getParameters().put('id',bdf1.id);
        ApexPages.currentPage().getParameters().put('retURL',bd.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAke',bd.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAke_lkid',bd.id);
        AIA_Ben_Form_RedirectExtensionController rec1=new AIA_Ben_Form_RedirectExtensionController(stdCon);
        rec1.Selected=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Domestic Partner - Self Insured Only').getRecordTypeId();
        rec1.getItems();
        rec1.selectedvalue();
        rec1.RedirectToSumaryPage();
        rec1.cancel();
        test.stopTest();
    }
     private static testMethod void unitTestdpe(){
        Test.startTest();
       
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
        bdf.Hospice_Care__c ='Yes';
        bdf.Home_Health_Care__c= 'Yes';
        insert bdf;
        AIA_Benefit_Design_Form__c bdf1=new AIA_Benefit_Design_Form__c();
        bdf1.Benefit_Design__c=bd.id;
        bdf1.Hospice_Care__c ='Yes';
        bdf1.Home_Health_Care__c= 'Yes';
        bdf1.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Domestic Partner - Self Insured Only').getRecordTypeId();
        insert bdf1;
        Id RecordTypeIdAdmin = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c  limit 1];
        
        AIA_Benefit_Design_Form__c bdfadmin=new AIA_Benefit_Design_Form__c();
        bdfadmin.Benefit_Design__c=bd.id;
        bdfadmin.Hospice_Care__c ='Yes';
        bdfadmin.Home_Health_Care__c= 'Yes';
        bdfadmin.Group_Numbers__c='test1,test2';
        bdfadmin.RecordTypeId=RecordTypeIdAdmin;
        insert bdfadmin;
        
         system.debug('bd.Name'+bd.Name);
        PageReference pageRef =Page.AIA_Ben_Form_Redirect_RecordType;
        Test.setCurrentPage(pageRef);
        ApexPages.standardController stdCon=new  ApexPages.standardController(bdf);
        ApexPages.currentPage().getParameters().put('retURL',bd.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAke',bd.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAke_lkid',bd.id);
        AIA_Ben_Form_RedirectExtensionController rec=new AIA_Ben_Form_RedirectExtensionController(stdCon);
        rec.Selected= Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        rec.getItems();
        rec.selectedvalue();
        
        PageReference pageRef1 =Page.AIA_Ben_Form_Redirect_RecordType;
        Test.setCurrentPage(pageRef1);
        ApexPages.standardController stdCon1=new  ApexPages.standardController(bdf);
        ApexPages.currentPage().getParameters().put('id',bdfadmin.id);
        ApexPages.currentPage().getParameters().put('retURL',bd.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAke',bd.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAke_lkid',bd.id);
        AIA_Ben_Form_RedirectExtensionController rec1=new AIA_Ben_Form_RedirectExtensionController(stdCon);
        rec1.Selected=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Domestic Partner - Self Insured Only').getRecordTypeId();
        rec1.getItems();
        rec1.selectedvalue();
        rec1.RedirectToSumaryPage();
        rec1.cancel();
        test.stopTest();
    }
    
    private static testmethod void unitTestMCPForm()
    {
      Test.startTest();
       
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
        Proposed_Products__c ppid = AIA_TestUtil.createBRFProposedProducts(brfObj.Id,aiapln.Id,'Medical');
        AIA_Benefit_Design_Product__c bdp = AIA_TestUtil.createBDProductsForBD(bd, 'Medical', aiapln.Id, ppid.id);
        insert bdp;
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bd.id;
        bdf.Hospice_Care__c ='Yes';
        bdf.Home_Health_Care__c= 'Yes';
        insert bdf;
        
        AIA_Benefit_Design_Form__c bdf1=new AIA_Benefit_Design_Form__c();
        bdf1.Benefit_Design__c=bd.id;
        bdf1.Hospice_Care__c ='Yes';
        bdf1.Home_Health_Care__c= 'Yes';
        bdf1.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('MCP - Full Managed Care').getRecordTypeId();
        insert bdf1;
        
        AIA_Benefit_Design_Form__c bdfadmin=new AIA_Benefit_Design_Form__c();
        bdfadmin.Benefit_Design__c=bd.id;
        bdfadmin.Hospice_Care__c ='Yes';
        bdfadmin.Home_Health_Care__c= 'Yes';
        bdfadmin.Group_Numbers__c='test1,test2';
        bdfadmin.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        insert bdfadmin;
        
        PageReference pageRef =Page.AIA_Ben_Form_Redirect_RecordType;
        Test.setCurrentPage(pageRef);
        system.debug('bd.Name'+bd.Name);
        ApexPages.currentPage().getParameters().put('retURL',bdp.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAm4',bdp.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAm4_lkid',bdp.id);
        ApexPages.standardController stdCon=new  ApexPages.standardController(bdf);
        AIA_Ben_Form_RedirectExtensionController rec=new AIA_Ben_Form_RedirectExtensionController(stdCon);
        //rec.getIsClassic();
        rec.getItems();
        rec.Selected= Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('MCP - Full Managed Care').getRecordTypeId();
        rec.selectedvalue();
        ApexPages.currentPage().getParameters().put('id',bdf1.id);
        rec.RedirectToSumaryPage();
        rec.cancel();
        
        PageReference pageRef1 =Page.AIA_Ben_Form_Redirect_RecordType;
        Test.setCurrentPage(pageRef1);
        ApexPages.standardController stdCon1=new  ApexPages.standardController(bdf);
        ApexPages.currentPage().getParameters().put('id',bdfadmin.id);
        ApexPages.currentPage().getParameters().put('retURL',bdp.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAm4',bdp.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAm4_lkid',bdp.id);
        AIA_Ben_Form_RedirectExtensionController rec1=new AIA_Ben_Form_RedirectExtensionController(stdCon);
        rec1.Selected=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        rec1.getItems();
        rec1.selectedvalue();
        rec1.RedirectToSumaryPage();
    }
    
     private static testmethod void unitTestManaged()
    {
      Test.startTest();
       
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
        Proposed_Products__c ppid = AIA_TestUtil.createBRFProposedProducts(brfObj.Id,aiapln.Id,'Medical');
        AIA_Benefit_Design_Product__c bdp = AIA_TestUtil.createBDProductsForBD(bd, 'Medical', aiapln.Id, ppid.id);
        insert bdp;
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bd.id;
        bdf.Hospice_Care__c ='Yes';
        bdf.Home_Health_Care__c= 'Yes';
        insert bdf;
        
        AIA_Benefit_Design_Form__c bdf1=new AIA_Benefit_Design_Form__c();
        bdf1.Benefit_Design__c=bd.id;
        bdf1.Hospice_Care__c ='Yes';
        bdf1.Home_Health_Care__c= 'Yes';
        bdf1.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Managed Care Programs').getRecordTypeId();
        insert bdf1;
        
        AIA_Benefit_Design_Form__c bdfDomestic=new AIA_Benefit_Design_Form__c();
        bdfDomestic.Benefit_Design__c=bd.id;
        bdfDomestic.Hospice_Care__c ='Yes';
        bdfDomestic.Home_Health_Care__c= 'Yes';
        bdfDomestic.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Domestic Partner - Self Insured Only').getRecordTypeId();
        insert bdfDomestic;
        
        
        PageReference pageRef =Page.AIA_Ben_Form_Redirect_RecordType;
        Test.setCurrentPage(pageRef);
        system.debug('bd.Name'+bd.Name);
        ApexPages.currentPage().getParameters().put('retURL',bdp.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAm4',bdp.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAm4_lkid',bdp.id);
        ApexPages.standardController stdCon=new  ApexPages.standardController(bdf);
        AIA_Ben_Form_RedirectExtensionController rec=new AIA_Ben_Form_RedirectExtensionController(stdCon);
        rec.getItems();
        rec.Selected= Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Managed Care Programs').getRecordTypeId();
        rec.selectedvalue();
        ApexPages.currentPage().getParameters().put('id',bdf1.id);
        rec.RedirectToSumaryPage();
        
        PageReference pageRef1 =Page.AIA_Ben_Form_Redirect_RecordType;
        Test.setCurrentPage(pageRef1);
        ApexPages.standardController stdCon1=new  ApexPages.standardController(bdf);
        ApexPages.currentPage().getParameters().put('id',bdfDomestic.id);
        ApexPages.currentPage().getParameters().put('retURL',bdp.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAm4',bdp.id);
        ApexPages.currentPage().getParameters().put('CF00N60000002jAm4_lkid',bdp.id);
        AIA_Ben_Form_RedirectExtensionController rec1=new AIA_Ben_Form_RedirectExtensionController(stdCon);
        rec1.Selected=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Domestic Partner - Self Insured Only').getRecordTypeId();
        rec1.getItems();
        rec1.selectedvalue();
        rec1.RedirectToSumaryPage();
       
    }
    private static testmethod void unitTestManaged1()
    {
      Test.startTest();
       
        Benfit_Request_Form__c brfObj = [Select Id From Benfit_Request_Form__c  limit 1];
        account acc = [Select Id From account  limit 1];
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
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
        Proposed_Products__c ppid = AIA_TestUtil.createBRFProposedProducts(brfObj.Id,aiapln.Id,'Medical');
        AIA_Benefit_Design_Product__c bdp = AIA_TestUtil.createBDProductsForBD(bd, 'Medical', aiapln.Id, ppid.id);
        bdp.Product_Category__c='Medical';
        bdp.AIA_INN_Contracted_Provider_Penalty__c='10';
        insert bdp;
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        /*bdf.Benefit_Design__c=bd.id;
        bdf.Hospice_Care__c ='Yes';
        bdf.Home_Health_Care__c= 'Yes';
        insert bdf;*/
        
        AIA_Benefit_Design_Form__c bdf1=new AIA_Benefit_Design_Form__c();
        bdf1.Benefit_Design__c=bd.id;
        bdf1.Hospice_Care__c ='Yes';
        bdf1.Home_Health_Care__c= 'Yes';
        bdf1.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Managed Care Programs').getRecordTypeId();
        insert bdf1;
        
        AIA_Benefit_Design_Form__c bdfDomestic=new AIA_Benefit_Design_Form__c();
        bdfDomestic.Benefit_Design__c=bd.id;
        bdfDomestic.Hospice_Care__c ='Yes';
        bdfDomestic.Home_Health_Care__c= 'Yes';
        bdfDomestic.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Domestic Partner - Self Insured Only').getRecordTypeId();
        insert bdfDomestic;
        
        
        PageReference pageRef =Page.AIA_MCP_BDP_SelectionPage;
        Test.setCurrentPage(pageRef);
        system.debug('bd.Name'+bd.Name);
       ApexPages.currentPage().getParameters().put('bdid',bd.id);
        Apexpages.currentPage().getParameters().put('node',bd.id);
        apexpages.currentpage().getparameters().put('mcpmode','New');
       // ApexPages.currentPage().getParameters().put('CF00N60000002jAm4',bdp.id);
       // ApexPages.currentPage().getParameters().put('CF00N60000002jAm4_lkid',bdp.id);
        ApexPages.standardController stdCon=new  ApexPages.standardController(bdf);
        AIA_MCP_BDP_SelectionController rec=new AIA_MCP_BDP_SelectionController(stdCon);
        rec.getIsClassic();
        rec.getProducts();
        rec.isSelected=true;
        rec.selectedbp=bdp.id;      
        rec.updateBdp();
       AIA_Benefit_Design_Product__c product = [SELECT AIA_INN_Contracted_Provider_Penalty__c FROM AIA_Benefit_Design_Product__c WHERE id =:bdp.id LIMIT 1];
        System.assertEquals(NULL, product.AIA_INN_Contracted_Provider_Penalty__c);
        rec.bdpWrappers[0].isSelected =true;        
        rec.Next();   
        rec.bdpWrappers[0].isSelected =false;        
        rec.Next();   
        apexpages.currentpage().getparameters().put('src','bdp');
        Pagereference pr = rec.cancel();
       
        apexpages.currentpage().getparameters().put('src','bd');
       
        rec.Cancel();    
        apexpages.currentpage().getparameters().put('mcpmode','edit');
        rec.Cancel(); 
    }
    
    private static testmethod void unitTestManaged2()
    {
      Test.startTest();
       
        Benfit_Request_Form__c brfObj = [Select Id From Benfit_Request_Form__c  limit 1];
        account acc = [Select Id From account  limit 1];
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
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
        Proposed_Products__c ppid = AIA_TestUtil.createBRFProposedProducts(brfObj.Id,aiapln.Id,'Medical');
        AIA_Benefit_Design_Product__c bdp = AIA_TestUtil.createBDProductsForBD(bd, 'Medical', aiapln.Id, ppid.id);
        bdp.Product_Category__c='Medical';
        bdp.SelectBDP__c=TRUE;
        insert bdp;
        
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bd.id;
        bdf.Hospice_Care__c ='Yes';
        bdf.Home_Health_Care__c= 'Yes';
        //insert bdf;
        
        AIA_Benefit_Design_Form__c bdf1=new AIA_Benefit_Design_Form__c();
        bdf1.Benefit_Design__c=bd.id;
        bdf1.Hospice_Care__c ='Yes';
        bdf1.Home_Health_Care__c= 'Yes';
        bdf1.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Managed Care Programs').getRecordTypeId();
        insert bdf1;
        
        AIA_Benefit_Design_Form__c bdfDomestic=new AIA_Benefit_Design_Form__c();
        bdfDomestic.Benefit_Design__c=bd.id;
        bdfDomestic.Hospice_Care__c ='Yes';
        bdfDomestic.Home_Health_Care__c= 'Yes';
        bdfDomestic.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Domestic Partner - Self Insured Only').getRecordTypeId();
        insert bdfDomestic;
        
        
        PageReference pageRef =Page.AIA_MCP_BDP_SelectionPage;
        Test.setCurrentPage(pageRef);
        system.debug('bd.Name'+bd.Name);
       ApexPages.currentPage().getParameters().put('bdid',bd.id);
        Apexpages.currentPage().getParameters().put('node',bd.id);
        apexpages.currentpage().getparameters().put('mcpmode','New');        
       // ApexPages.currentPage().getParameters().put('CF00N60000002jAm4',bdp.id);
       // ApexPages.currentPage().getParameters().put('CF00N60000002jAm4_lkid',bdp.id);
        ApexPages.standardController stdCon=new  ApexPages.standardController(bdf);
        AIA_MCP_BDP_SelectionController rec=new AIA_MCP_BDP_SelectionController(stdCon);
        //apexpages.currentpage().getparameters().put('mcpid',bdf.id);
        rec.bd = bd;
        rec.mcpid=bdf1.id;
        rec.getIsClassic();
        rec.getProducts();
    }
    private static testmethod void unitTestManaged3(){
        Benfit_Request_Form__c brfObj = [Select Id From Benfit_Request_Form__c  limit 1];
        account acc = [Select Id From account  limit 1];
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
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
        Proposed_Products__c ppid = AIA_TestUtil.createBRFProposedProducts(brfObj.Id,aiapln.Id,'Medical');
        AIA_Benefit_Design_Product__c bdp = AIA_TestUtil.createBDProductsForBD(bd, 'Medical', aiapln.Id, ppid.id);
        bdp.Product_Category__c='Medical';
        bdp.AIA_INN_Contracted_Provider_Penalty__c='10';
        insert bdp;
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        /*bdf.Benefit_Design__c=bd.id;
        bdf.Hospice_Care__c ='Yes';
        bdf.Home_Health_Care__c= 'Yes';
        insert bdf;*/
        
        AIA_Benefit_Design_Form__c bdf1=new AIA_Benefit_Design_Form__c();
        bdf1.Benefit_Design__c=bd.id;
        bdf1.Hospice_Care__c ='Yes';
        bdf1.Home_Health_Care__c= 'Yes';
        bdf1.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Managed Care Programs').getRecordTypeId();
        insert bdf1;
        
        AIA_Benefit_Design_Form__c bdfDomestic=new AIA_Benefit_Design_Form__c();
        bdfDomestic.Benefit_Design__c=bd.id;
        bdfDomestic.Hospice_Care__c ='Yes';
        bdfDomestic.Home_Health_Care__c= 'Yes';
        bdfDomestic.RecordTypeId=Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Domestic Partner - Self Insured Only').getRecordTypeId();
        insert bdfDomestic;
        
        
        PageReference pageRef =Page.AIA_MCP_BDP_SelectionPage;
        Test.setCurrentPage(pageRef);
        system.debug('bd.Name'+bd.Name);
       ApexPages.currentPage().getParameters().put('bdid',bd.id);
        Apexpages.currentPage().getParameters().put('node',bd.id);
        apexpages.currentpage().getparameters().put('mcpmode','edit');
       // ApexPages.currentPage().getParameters().put('CF00N60000002jAm4',bdp.id);
       // ApexPages.currentPage().getParameters().put('CF00N60000002jAm4_lkid',bdp.id);
        ApexPages.standardController stdCon=new  ApexPages.standardController(bdf);
        AIA_MCP_BDP_SelectionController rec=new AIA_MCP_BDP_SelectionController(stdCon);
        Test.startTest();
        rec.cancel();
        Test.stopTest();
    }
    
}