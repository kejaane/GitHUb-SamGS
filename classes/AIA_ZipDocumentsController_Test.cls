@isTest
private class AIA_ZipDocumentsController_Test {
    
    @testsetup public static void createTestData()
    {
         // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom']; 
        List<user> userList = new list<user>();
        User u3 = new User(Alias = 'TAlias2', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
        //insert u2;
        userList.add(u3);
        user u1 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias21');
        userList.add(u2);
      
        insert userList;
        Test.startTest();
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        /*AccountTeamMember atm2 = new AccountTeamMember ();
        atm2.TeamMemberRole = 'Contract Tech';
        atm2.AccountId = a.id;
        atm2.UserId = u3.id;
        acctMbrList.add(atm2);*/
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u1.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'Account Executive'));
        
        insert acctMbrList; 
        
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
 
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Account__c=a.id;
        brf.Request_Type__c='Prospect/New';
        brf.Benefit_Effective_Date__c   = system.today();
        brf.Benefit_Period__c='Calendar';
        brf.Jurisdiction__c ='VA';
        brf.Sales_Segment_Size__c = 'Labor';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c  = 'Grandfathered';
        brf.Broker_Commission__c = 3.5;
        brf.Contract_Count__c = 20;
        brf.Funding_Arrangements__c = 'Both';
        brf.opportunity__c = o.id;
        insert brf;
         
        // AIA_Benefit_Design__c aiaBD = AIA_TestUtil.createBenefitDesign(o.id,a.id);
        // system.assertNotEquals(null,aiaBD.id);
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = a.Id;
        Imp.Benefit_Request_Form__c = brf.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        insert Imp;
        
        AIA_Benefit_Design__c aiaBD1 = new AIA_Benefit_Design__c();
        aiaBD1.Implementation__c = Imp.id;
        aiaBD1.Account__c = a.Id;
        aiaBD1.Benefit_Request_Form__c = brf.Id;
        aiaBD1.Religions_Exemption_Prerequisites__c = 'No';
        aiaBD1.Oppose_Contracteptive_Service__c = 'No'; 
        //aiaBD1.Nonprofit__c = 'Yes';
        insert aiaBD1;
        
        list<AIA_Document__c> lstAD = new list<AIA_Document__c>();
        // creating AIA Document
        AIA_Document__c aiaDoc1 = AIA_TestUtil.createAIADocument();
        aiaDoc1.Adj_Summ_Revision__c = 1;
        aiaDoc1.Benefit_Design__c = aiaBD1.Id;
        lstAD.add(aiaDoc1);
        AIA_Document__c aiaDoc2 = AIA_TestUtil.createAIADocument();
        aiaDoc2.Adj_Summ_Revision__c = 1;
        aiaDoc2.Benefit_Design__c = aiaBD1.Id;
        lstAD.add(aiaDoc2);
        update lstAD;
        
        list<Attachment> lstatt = new list<Attachment>();
        Attachment add1= new Attachment();
        add1.parentId = aiaDoc1.Id;
        add1.Name = 'path';
        add1.body = Blob.valueOf('This is test 1');
        lstatt.add(add1);
        Attachment add2= new Attachment();
        add2.parentId = aiaDoc2.Id;
        add2.Name = 'path';
        add2.body = Blob.valueOf('This is test 2');
        lstatt.add(add2);
        insert lstatt;
    Test.stopTest();
    }

	public static testmethod void TestAIABenefitDesign() {
         User u = AIA_TestUtil.createTestUser();
         AIA_Benefit_Design__c aiaBD = [Select id,name from AIA_Benefit_Design__c limit 1];
         AIA_Document__c aiaDoc = [Select id,name from AIA_Document__c limit 1];
         test.startTest();
        System.runAs(u) { 
               ApexPages.StandardController sc = new ApexPages.StandardController(aiaBD);
               ApexPages.currentPage().getParameters().put('Id',aiaBD.id); 
               AIA_ZipDocumentsController AIA = New AIA_ZipDocumentsController(sc);
               AIA.zipFileName = 'testfile_324.zip';
               AIA.ZipContent = 'test data';
               AIA.uploadZip();
               AIA_ZipDocumentsController.getAttachment(aiaDoc.Id);
               list<AIA_Document__c> lstdoc = new list<AIA_Document__c>();
               lstdoc = [Select Name From AIA_Document__c Where Name like '%zip%' Limit 1];
               if(!lstdoc.isEmpty()) {
                    system.assertEquals('testfile_324.zip', lstdoc[0].Name);
               }
               AIA.cancelButton();
             Test.stopTest();
          }
	}

}