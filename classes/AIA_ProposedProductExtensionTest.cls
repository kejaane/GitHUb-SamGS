@isTest(seealldata=false)
public class AIA_ProposedProductExtensionTest {    

    public static testmethod void testdeafultPPproducts(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
        
 System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            //atm.TeamMemberRole = 'NASCO Benefit Coder2';
     		atm.TeamMemberRole = 'Benefit Coder';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
             
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            //atmRole3.TeamMemberRole = 'Ancillary Analyst';
     		atmRole3.TeamMemberRole = 'Vision Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
     		
     		AccountTeamMember atmRole5 = new AccountTeamMember ();
            atmRole5.TeamMemberRole = 'Benefit Tester';
            atmRole5.AccountId =a.id;
            atmRole5.UserId = user.id;
            AccountTeamMemberList.add(atmRole5);
     
     		AccountTeamMember atmRole6 = new AccountTeamMember ();
            atmRole6.TeamMemberRole = 'Pharmacy Operations';
            atmRole6.AccountId =a.id;
            atmRole6.UserId = user.id;
            AccountTeamMemberList.add(atmRole6);*/
     		List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            test.startTest();
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Funding_Arrangements__c = 'Risk';
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Funding_Arrangements__c = 'RISK';
            nbrf.Opportunity__c = o.id;
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            
            AIA_Plan__c plantest = AIA_TestUtil.CreateGSMPlan('Medical', 'Medical-1');
            
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('Drug', 'Drug-1');
            
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest);
            planlist.add(plantest2);
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

            
            Proposed_Products__c pp = new Proposed_Products__c();
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
          
            AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            String nextPage = controller.save().getUrl();
            nextPage = controller.save().getUrl();
            controller.getIsClassic();   
            test.stopTest();
        }
   }

   public static testmethod void testdeafultPPDrug(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
            List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            test.startTest();
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Funding_Arrangements__c = 'RISK';
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('Drug', 'Drug-1');
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest2);
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

            
            Proposed_Products__c pp = new Proposed_Products__c();
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
          
            AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            //String nextPage = controller.save().getUrl();
            //String nextPage;
            //nextPage = controller.save().getUrl();
            controller.cancel();
            ApexPages.currentPage().getParameters().put('brfId', NULL);
            controller.cancel();
            test.stopTest();
        }
   }
    
   public static testmethod void testdeafultPPVision(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
            AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
            AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
            AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
            List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            test.startTest();
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            //AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('Vision', 'Vision-2');
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('Vision', 'Drug-1');
            //AIA_Plan__c plantest3 = AIA_TestUtil.CreateGSMPlan('Pharmacy', 'Pharmacy-2');
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest2);
            //planlist.add(plantest3);
            
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

            
            Proposed_Products__c pp = new Proposed_Products__c();
            //pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
            //pp.Benefit_Request_Form__c =dbSaveresult1.getId();
            //insert pp;
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
          
            AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            String nextPage = controller.save().getUrl();
            nextPage = controller.save().getUrl();
            //controller.saveandGetBenefits();
            test.stopTest();
        }
   } 

   public static testmethod void testdeafultPPVision2(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
             /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
            List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            test.startTest();
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('Vision', 'Vision-1');
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest2);
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

            
            Proposed_Products__c pp = new Proposed_Products__c();
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
          
            AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            String nextPage = controller.save().getUrl();
            nextPage = controller.save().getUrl();
            
            test.stopTest();
        }
   }

   public static testmethod void testdeafultPPDental(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
            List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            test.startTest();
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('Dental', 'Dental-1');
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest2);
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

            
            Proposed_Products__c pp = new Proposed_Products__c();
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
          
            AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            String nextPage = controller.save().getUrl();
            nextPage = controller.save().getUrl();
            
            test.stopTest();
        }
   }
   

   public static testmethod void testdeafultPPCareFirst(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
            List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            test.startTest();
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('CareFirst Private Exchange', 'CareFirst Private Exchange-1');
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest2);
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

            
            Proposed_Products__c pp = new Proposed_Products__c();
            
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
            try{
                  AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            String nextPage = controller.save().getUrl();
            nextPage = controller.save().getUrl();
            }
            catch(Exception e){
                system.debug('error--'+e.getMessage());
            }
            
            test.stopTest();
        }
   }
   

   /***********************/
   public static testmethod void testdeafult(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
        test.startTest();
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
            List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
           // nbrf.Funding_Arrangements__c = 'ASO';
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
           // nbrf.Funding_Arrangements__c = 'ASO';
            nbrf.Opportunity__c = o.id;
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('CareFirst Private Exchange', 'CareFirst Private Exchange-1');
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest2);
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

            
            Proposed_Products__c pp = new Proposed_Products__c();
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
          
           AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            ApexPages.currentPage().getParameters().put('planid','');
            controller.saveandGetBenefits();
            controller.save();
            controller.cancel();
 
            test.stopTest();
        }
   }
   
  public static testmethod void testErrorMessage2(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
      
 System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
     		List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Funding_Arrangements__c = 'Risk';
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Funding_Arrangements__c = 'Risk';
            nbrf.Opportunity__c = o.id;
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            aiapln.Plan_Id__c='PLAN-Test';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.Has_Benefit_Summary__c=true;
               
            insert aiapln;
     
             StaticResource sr = [select id,body from StaticResource Where Name = 'BenSumJSONBRF_Test'];
            String jsonStr=sr.body.toString();
            AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
            AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
            mapper.saveToSetUp(apbroot,'BRF');
           
           
              test.startTest();
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='Risk';
            pp.Plan_Name__c=aiapln.id;
            pp.Product_Category__c='Medical';
            pp.Blue_Rewards__c='Some value';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =dbSaveresult1.getId();
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('planid', aiapln.id);
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
             
           try{ 
                   
            AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            // controller.save().getUrl();
             controller.saveandGetBenefits();
               
             }
             catch(Exception e){
                  system.debug('error--'+e.getMessage());
             }
  
            pp.Blue_Rewards__c='';
                         update pp;
                
                PageReference pageRef2 = Page.AIA_ProposedProductSummary;
                Test.setCurrentPage(pageRef2);
                ApexPages.currentPage().getParameters().put('id',pp.id);
                        ApexPages.StandardController ctler2 = new ApexPages.StandardController(pp);
                          AIA_ProposedProductExtension controller2 = new AIA_ProposedProductExtension(ctler2);
                 controller2.saveandGetBenefits();
            test.stopTest();
        }
   }

    
    public static testmethod void testErrorMessage1(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
      
 System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
     		List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Funding_Arrangements__c = 'Risk';
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Funding_Arrangements__c = 'ASO';
            nbrf.Opportunity__c = o.id;
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            
            AIA_Plan__c plantest = AIA_TestUtil.CreateGSMPlan('Medical', 'Medical-1');
            
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('Drug', 'Drug-1');
            
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest);
            planlist.add(plantest2);
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

              test.startTest();
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='ASO';
            pp.Plan_Name__c=lst[0].getId();
           pp.Product_Category__c='Medical';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =dbSaveresult1.getId();
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
   
            AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
             try{
                    controller.save().getUrl();
             }
             catch(Exception e){
                  system.debug('error--'+e.getMessage());
             }
  
       
                
            test.stopTest();
        }
   }
   
   public static testmethod void testdeafultPharmacy(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
            List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            test.startTest();
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            nbrf.RecordTypeId = QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'Risk');
            nbrf.Jurisdiction__c ='VA';
            nbrf.Exclusive_Specialty_Provider_Network__c ='No - Requires Approval';
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest2);
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

            
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='Risk';
            pp.Plan_Name__c=lst[0].getId();
            pp.Product_Category__c='Drug';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
            pp.Benefit_Request_Form__c =dbSaveresult1.getId();
            pp.Network__c ='National';
            pp.Exclusive_Specialty_Provider_Network__c = 'Yes';
            
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            system.debug('Object msg: '+pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
          
            AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            system.debug('Null is : '+controller);
            //String nextPage = controller.save().getUrl();
            //nextPage = controller.save().getUrl();
            controller.save();
            
            test.stopTest();
        }
        
   }
        public static testmethod void testdeafultPharmacy1(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
			List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            test.startTest();
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            nbrf.RecordTypeId = QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
            nbrf.Jurisdiction__c ='VA';
            nbrf.Exclusive_Specialty_Provider_Network__c ='No - Requires Approval';
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest2);
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

            
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='Risk';
            pp.Plan_Name__c=lst[0].getId();
            pp.Product_Category__c='Drug';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
            pp.Benefit_Request_Form__c =dbSaveresult1.getId();
            pp.Network__c ='Standard';
            pp.Exclusive_Specialty_Provider_Network__c = 'No - Requires Approval';
            pp.OralChemoMandateApply__c = 'Yes';
            insert pp;
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            system.debug('Object msg: '+pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
          
            AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            system.debug('Null is : '+controller);
            //String nextPage = controller.save().getUrl();
            //nextPage = controller.save().getUrl();
            controller.save();
            
            test.stopTest();
        }
   }
   public static testmethod void testdeafultPharmacy2(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.Jurisdiction__c='MD';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
            List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            test.startTest();
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            nbrf.RecordTypeId = QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'Risk');
            nbrf.Jurisdiction__c ='MD';
            nbrf.Exclusive_Specialty_Provider_Network__c ='No';
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest2);
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

            
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='Risk';
            pp.Plan_Name__c=lst[0].getId();
            pp.Product_Category__c='Drug';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
            pp.Benefit_Request_Form__c =dbSaveresult1.getId();
            pp.Network__c ='Standard';
            pp.Exclusive_Specialty_Provider_Network__c = 'No - Requires Approval';
            pp.OralChemoMandateApply__c = 'Yes';
            insert pp;
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            system.debug('Object msg: '+pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
          
            AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            system.debug('Null is : '+controller);
            //String nextPage = controller.save().getUrl();
            //nextPage = controller.save().getUrl();
            controller.save();
            
            test.stopTest();
        }
   } 
    
    public static testmethod void testdeafultPharmacy3(){

        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        User u = AIA_TestUtil.createTestUser();
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.Jurisdiction__c='VA';
            update a;
            /*List<AccountTeamMember> AccountTeamMemberList=new List<AccountTeamMember>();
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder2';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            AccountTeamMemberList.add(atm);
            
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            AccountTeamMemberList.add(atmRole);
            
             AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'QA Auditor';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user.id;
            AccountTeamMemberList.add(atmRole1);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
             AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = user.id;
            AccountTeamMemberList.add(atmRole3);
            
             AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'MAST Tech';
            atmRole4.AccountId =a.id;
            atmRole4.UserId = user.id;
            AccountTeamMemberList.add(atmRole4);
            
            insert AccountTeamMemberList;*/
            List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'MAST Tech'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'QA Auditor'));
     		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'Contract Tech'));
            AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,user.id,'BeneFact Coder'));
            insert AccountTeamMemberList;
            
           // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            test.startTest();
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            nbrf.RecordTypeId = QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'Risk');
            nbrf.Jurisdiction__c ='VA';
            nbrf.Exclusive_Specialty_Provider_Network__c ='No';
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(nbrf);
            AIA_Plan__c plantest2 = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest2);
            
            //insert planlist;
            
            list<Database.SaveResult> lst = Database.Insert(planlist);

            system.debug('********'+lst);

            
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='Risk';
            pp.Plan_Name__c=lst[0].getId();
            pp.Product_Category__c='Drug';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
            pp.Benefit_Request_Form__c =dbSaveresult1.getId();
            pp.Network__c ='Standard';
            //pp.Exclusive_Specialty_Provider_Network__c = 'No - Requires Approval';
            pp.OralChemoMandateApply__c = 'Yes';
            insert pp;
            ApexPages.StandardController ctler = new ApexPages.StandardController(pp);
            system.debug('Object msg: '+pp);
            PageReference pageRef = Page.AIA_ProposedProductSummary;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('planid', lst[0].getId());
            ApexPages.currentPage().getParameters().put('brfId', dbSaveresult1.getId());
          
            AIA_ProposedProductExtension controller = new AIA_ProposedProductExtension(ctler);
            system.debug('Null is : '+controller);
            //String nextPage = controller.save().getUrl();
            //nextPage = controller.save().getUrl();
            controller.save();
            
            test.stopTest();
        }
   } 


}