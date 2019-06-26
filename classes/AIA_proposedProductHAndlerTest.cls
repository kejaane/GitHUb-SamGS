@isTest(seealldata=false)
public class AIA_proposedProductHAndlerTest {

 public static testmethod void PPHandlerTestASO(){
          
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
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = a.id;
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
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(brf);
            
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            aiapln.Plan_Id__c='PLAN-Test';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.Has_Benefit_Summary__c=true;
               
            insert aiapln;
      
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='ASO';
            pp.Plan_Name__c=aiapln.id;
            pp.Product_Category__c='Medical';
            pp.Blue_Rewards__c='Standard';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.Id;
             //pp.MHP_Test_Result__c='Pass';
             
              test.startTest();
             
              insert pp;
            AIA_ProposedProductsHandler.firstRun=false;
                
             try{
                 pp.Custom__c=true;
                 //pp.MHP_Test_Result__c='';
                 update pp;
             }
             catch(Exception e){}
           
             test.stopTest();
            Proposed_Products__c pp2=[select id from Proposed_Products__c where id= :pp.id];
            pp2.Custom__c=false;
            //pp2.MHP_Test_Result__c='Fail';
            update pp2;
            
     }
    }

    public static testmethod void PPHandlerTestRisk(){
        
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
     
        
           
             
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='Risk';
            pp.Plan_Name__c=aiapln.id;
            pp.Product_Category__c='Medical';
            pp.Blue_Rewards__c='Some value';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =dbSaveresult1.getId();
             //pp.MHP_Test_Result__c='Pass';
             
              test.startTest();
             
              insert pp;
            
                  //pp.MHP_Test_Result__c='Fail';
                 update pp;
             try{
                 pp.Custom__c=true;
                 update pp;
             }
             catch(Exception e){}
            
             test.stopTest();
     }
    }
   public static testmethod void PPHandlerTestRisk1(){
        
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
     
             
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='Risk';
            pp.Plan_Name__c=aiapln.id;
            pp.Product_Category__c='Medical';
            pp.Blue_Rewards__c='Some value';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =dbSaveresult1.getId();
             //pp.MHP_Test_Result__c='Fail';
             
              test.startTest();
             
              insert pp;
            
                  //pp.MHP_Test_Result__c='Fail';
                 update pp;
             try{
                 pp.Custom__c=true;
                 update pp;
             }
             catch(Exception e){}
            
             test.stopTest();
     }
    }
public static testmethod void PPHandlerTestRisk2(){
        
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
     
        
           
             
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='Risk';
            pp.Plan_Name__c=aiapln.id;
            pp.Product_Category__c='Medical';
            pp.Blue_Rewards__c='Some value';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =dbSaveresult1.getId();
             //pp.MHP_Test_Result__c='';
             
              test.startTest();
             
              insert pp;
            
                  //pp.MHP_Test_Result__c='Fail';
                 update pp;
             try{
                 pp.Custom__c=true;
                 update pp;
             }
             catch(Exception e){}
            
             test.stopTest();
     }
    }

public static testmethod void PPHandlerTestASO1(){
        
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
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = a.id;
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
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(brf);
            
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            aiapln.Plan_Id__c='PLAN-Test';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.Has_Benefit_Summary__c=true;
               
            insert aiapln;
     Map<id,Proposed_Products__c> ppmap= new Map<id,Proposed_Products__c>();
         Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='ASO';
            pp.Plan_Name__c=aiapln.id;
            pp.Product_Category__c='Medical';
            pp.Blue_Rewards__c='Standard';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.Id;
             //pp.MHP_Test_Result__c='Fail';
             pp.Integrated_Non_Integrated__c ='Integrated';
     pp.Deductible__c ='Stacked';
              test.startTest();  
             insert pp;
     ppmap.put(pp.id,pp);
   
    
     List<Proposed_Products__c> plist = new List<Proposed_Products__c>();
     Proposed_Products__c pp1 = new Proposed_Products__c();
            pp1.Funding_Arrangement__c='ASO';
            pp1.Plan_Name__c=aiapln.id;
            pp1.Product_Category__c='Drug';
            pp1.Blue_Rewards__c='Some value';
            pp1.Related_Medical_Product__c=pp.id;
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
            pp1.Benefit_Request_Form__c =brf.Id;
             //pp1.MHP_Test_Result__c='Pass';
             pp1.Integrated_Non_Integrated__c ='Integrated';
            pp1.Deductible__c=pp.Deductible__c;
               plist.add(pp1) ;         
              insert plist;
  
            AIA_ProposedProductsHandler.firstRun=false;
     AIA_ProposedProductsHandler handler = new AIA_ProposedProductsHandler();
     handler.UpdateRelatedDrugPP_Insert(plist);
   //AIA_ProposedProductsHandler.updateMHPTest(plist, ppmap);
   
                
             try{
                 pp.Custom__c=true;
                 //pp.MHP_Test_Result__c='fail';
                 update pp;
                 update pp1;
             }
             catch(Exception e){}
           
             test.stopTest();
            Proposed_Products__c pp2=[select id from Proposed_Products__c where id= :pp.id];
            pp2.Custom__c=false;
            //pp2.MHP_Test_Result__c='Fail';
            update pp2;
            
     }
    }
public static testmethod void PPHandlerTestASO2(){
        
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
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = a.id;
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
            
            
            Database.SaveResult dbSaveresult1 = Database.Insert(brf);
            
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            aiapln.Plan_Id__c='PLAN-Test';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.Has_Benefit_Summary__c=true;
               
            insert aiapln;
      
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='ASO';
            pp.Plan_Name__c=aiapln.id;
            pp.Product_Category__c='Medical';
            pp.Blue_Rewards__c='Custom';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.Id;
             //pp.MHP_Test_Result__c='Deferred';
     pp.FSA_BlueFund__c = true;
     pp.CDH__c = 'Yes';
     pp.CDH_Type__c ='HRA Integrated';
     pp.Custom_Wellness__c = true;
     pp.Custom_Core_DM_Wellness__c = true;
     pp.Integrated_Non_Integrated__c='Integrated - Carved-Out';
             
              test.startTest();
             
              insert pp;
     
            AIA_ProposedProductsHandler.firstRun=false;
                
             try{
                 //pp.Custom__c=true;
                 //pp.MHP_Test_Result__c='Fail';
                 update pp;
             }
             catch(Exception e){}
           
             test.stopTest();
            Proposed_Products__c pp2=[select id from Proposed_Products__c where id= :pp.id];
            pp2.Custom__c=false;
            //pp2.MHP_Test_Result__c='Fail';
            update pp2;
            
     }
    }
    
    public static testmethod void PPHandlerTestASO2updateBRFMHPTestResult(){
        
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
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = a.id;
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
            Benfit_Request_Form__c brf1 = new Benfit_Request_Form__c();
            brf1.Request_Type__c = 'Renew As-is';
        brf1.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf1.Contract_Count__c = 123;
        brf1.Benefit_Effective_Date__c = system.today();
        brf1.Account__c = a.id;
        brf1.Escalated_to_Senior_Management__c = true;
        brf1.Status__c = 'new';
        brf1.Opportunity__c = o.id;
        brf1.Jurisdiction__c = 'MD';
        brf1.Enrollment_Type__c = 'Cafeteria';
        //brf1.MHP_Test_Result__c = 'Pass';
        brf1.EGWP_Picklist__c = 'Yes';
        brf1.FlexLink_Picklist__c = 'Yes';
        brf1.Benefit_Effective_Date__c = system.today();
        brf1.Benefit_Period__c = 'Contract';
        brf1.Control_Plan__c = '690';
        brf1.Sales_Segment_Size__c = 'Commercial 200-999';
        brf1.Contract_Period__c = 'Standard - 12 Months';
        brf1.Grandfathered_Status__c = 'Non-Grandfathered';
        brf1.Grandfathered_PPACA_Status__c = 'Yes';
        brf1.Stop_Loss__c = 'Carefirst';
        brf1.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf1.Broker_Consultant_Amount__c = 50;
        brf1.Identity_Protection__c = 'Yes';
        brf1.Enrollment_Type__c = 'Parallel';
        brf1.Funding_Arrangements__c = 'Risk';
            
            Database.SaveResult dbSaveresult1 = Database.Insert(brf);
            Database.SaveResult dbSaveresult2 = Database.Insert(brf1);
            
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            aiapln.Plan_Id__c='PLAN-Test';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.Has_Benefit_Summary__c=true;
               
            insert aiapln;
      List<Proposed_Products__c> pplst=new List<Proposed_Products__c>();
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='ASO';
            pp.Plan_Name__c=aiapln.id;
            pp.Product_Category__c='Medical';
            pp.Blue_Rewards__c='Custom';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.Id;
             //pp.MHP_Test_Result__c='Deferred';
     pp.FSA_BlueFund__c = true;
     pp.CDH__c = 'Yes';
     pp.CDH_Type__c ='HRA Integrated';
     pp.Custom_Wellness__c = true;
     pp.Custom_Core_DM_Wellness__c = true;
     pp.Integrated_Non_Integrated__c='Integrated - Carved-Out';
             
              test.startTest();
             pplst.add(pp);
     
      Proposed_Products__c pp1 = new Proposed_Products__c();
            pp1.Funding_Arrangement__c='ASO';
            pp1.Plan_Name__c=aiapln.id;
            pp1.Product_Category__c='Medical';
            pp1.Blue_Rewards__c='Custom';
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp1.Benefit_Request_Form__c =brf1.Id;
             //pp1.MHP_Test_Result__c='Deferred';
     pp1.FSA_BlueFund__c = true;
     pp1.CDH__c = 'Yes';
     pp1.CDH_Type__c ='HRA Integrated';
     pp1.Custom_Wellness__c = true;
     pp1.Custom_Core_DM_Wellness__c = true;
     //pp1.Integrated_Non_Integrated__c='Integrated - Carved-Out';
             

     //another product
     Proposed_Products__c pp2 = new Proposed_Products__c();
            pp2.Funding_Arrangement__c='ASO';
            pp2.Plan_Name__c=aiapln.id;
            pp2.Product_Category__c='Medical';
            pp2.Blue_Rewards__c='Custom';
            pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp2.Benefit_Request_Form__c =brf.Id;
             //pp2.MHP_Test_Result__c='Deferred';
     pp2.FSA_BlueFund__c = true;
     pp2.CDH__c = 'Yes';
     pp2.CDH_Type__c ='HRA Integrated';
     pp2.Custom_Wellness__c = true;
     pp2.Custom_Core_DM_Wellness__c = true;
     
      //another product
     Proposed_Products__c pp3 = new Proposed_Products__c();
            pp3.Funding_Arrangement__c='ASO';
            pp3.Plan_Name__c=aiapln.id;
            pp3.Product_Category__c='Medical';
            pp3.Blue_Rewards__c='Custom';
            pp3.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp3.Benefit_Request_Form__c =brf.Id;
            // pp3.MHP_Test_Result__c='';
     pp3.FSA_BlueFund__c = true;
     pp3.CDH__c = 'Yes';
     pp3.CDH_Type__c ='HRA Integrated';
     pp3.Custom_Wellness__c = true;
     pp3.Custom_Core_DM_Wellness__c = true;
     
      //another product
     Proposed_Products__c pp4 = new Proposed_Products__c();
            pp4.Funding_Arrangement__c='ASO';
            pp4.Plan_Name__c=aiapln.id;
            pp4.Product_Category__c='Medical';
            pp4.Blue_Rewards__c='Custom';
            pp4.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp4.Benefit_Request_Form__c =brf.Id;
             //pp4.MHP_Test_Result__c='Pass';
     pp4.FSA_BlueFund__c = true;
     pp4.CDH__c = 'Yes';
     pp4.CDH_Type__c ='HRA Integrated';
     pp4.Custom_Wellness__c = true;
     pp4.Custom_Core_DM_Wellness__c = true;
     
     //test.startTest();
             pplst.add(pp1);
             pplst.add(pp3);
             pplst.add(pp4);
              insert pplst;
     
            AIA_ProposedProductsHandler.firstRun=false;
                
             try{
                 //pp.Custom__c=true;
                 //pp.MHP_Test_Result__c='Fail';
                 update pp;
             }
             catch(Exception e){}
            Map<Id,Proposed_Products__c> pplst1=new Map<Id,Proposed_Products__c>([select id from Proposed_Products__c]);
     AIA_ProposedProductsHandler.updateBRFMHPTestResult(pplst1.values(),pplst1);
     AIA_ProposedProductsHandler.updateBRFMHPTestResult(pplst1.values(),null);
             test.stopTest();
            Proposed_Products__c pp2rec=[select id from Proposed_Products__c where id= :pp.id];
            pp2rec.Custom__c=false;
            //pp2rec.MHP_Test_Result__c='Fail';
            update pp2rec;
            
     }
    }
    
  public static testmethod void PPHandlerTestASO3(){
        
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
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Request_Type__c = 'Set-up Change - Administrative Changes';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = a.id;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = '';
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
         brf.Blue_Rewards_Drawloop__c='Standard';  
            
            Database.SaveResult dbSaveresult1 = Database.Insert(brf);
            
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            aiapln.Plan_Id__c='PLAN-Test';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.Has_Benefit_Summary__c=true;
               
            insert aiapln;
      
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Funding_Arrangement__c='ASO';
            pp.Plan_Name__c=aiapln.id;
            pp.Product_Category__c='Medical';
            pp.Blue_Rewards__c='No';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.Id;
             //pp.MHP_Test_Result__c='';
    
             
              test.startTest();
             
              insert pp;
            AIA_ProposedProductsHandler.firstRun=false;
              List<Proposed_Products__c> newLst = new List<Proposed_Products__c>();
             Map<Id,Proposed_Products__c> oldMap = new Map<Id,Proposed_Products__c>();
            oldMap.put(pp.Id,pp);
             try{
                 pp.Custom__c=true;
                 //pp.MHP_Test_Result__c='Pass';
                 update pp;
                 newLst.add(pp);
             }
             catch(Exception e){}
           AIA_ProposedProductsHandler.updateMHPTest(newLst,oldMap);
             test.stopTest();
            Proposed_Products__c pp2=[select id from Proposed_Products__c where id= :pp.id];
            pp2.Custom__c=false;
            //pp2.MHP_Test_Result__c='Fail';
            update pp2;
            
     }
    } 
  
    //R1E1 Start
    public static testmethod void testUpdateRelatedDrugPP(){
        
       Account acc = AIA_TestUtil.CreateAccount('Test Account');
        
        List<user> userList = new list<user>();
        user u1  = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2  = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u3  = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        insert userList;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,AIA_Constants.SALES_SERVICE_REP)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,AIA_Constants.ACCOUNTEXECUTIVE)); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,AIA_Constants.PROPOSALSPECIALIST)); 
        insert acctMbrList;   
        
        Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Set-up Change - Administrative Changes';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.Status__c = 'new';
        brf.Contract_Count__c = 123;
        brf.Opportunity__c = opp.id;
        brf.Funding_Arrangements__c = 'ASO';
        brf.Blue_Rewards_Drawloop__c='Standard';  
        insert brf;
        
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Plan_Id__c='PLAN-Test';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Has_Benefit_Summary__c=true;
        insert aiapln;
        
        Proposed_Products__c pp = new Proposed_Products__c();
        pp.Funding_Arrangement__c='ASO';
        pp.Plan_Name__c=aiapln.id;
        pp.Product_Category__c='Medical';
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical_Risk');
        pp.Benefit_Request_Form__c =brf.Id;
        pp.Integrated_Non_Integrated__c = 'Integrated';
        insert pp;
        
        Proposed_Products__c pp2 = new Proposed_Products__c();
        pp2.Funding_Arrangement__c='ASO';
        pp2.Plan_Name__c=aiapln.id;
        pp2.Product_Category__c='Medical';
        pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
        pp2.Related_Medical_Product__c = pp.Id;
        pp2.Benefit_Request_Form__c =brf.Id;
        insert pp2;
        
        Map<id,Proposed_Products__c> dummy = new Map<id,Proposed_Products__c>();
        AIA_ProposedProductsHandler.UpdateRelatedDrugPP(new List<Proposed_Products__c>{pp},dummy);
        
    }
    //R1E1 End
}