/*****************************************************************************************************
* Update History
* Date         Developer       Tag          Description
*==================================================================================

*06/08/2018    Phani      T01       Added code for role updates
*==================================================================================
* *******************************************************************************************************/
@istest(seealldata=false)
public class AIA_BenefitDesignApproversHelper_Test {

    // Run positive test when check testing is false as expected in the Account Process code
 
 
    static testMethod void insertBenefitDesign(){ 
          Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List <user> userlist= new List<User>();
        List<Account_Team__c> AccountTeamMemberList= new List<Account_Team__c>();
      
        User user = new User(Alias = 'TAlias13', Email='TestUserBRF@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = pro.Id,
                              TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com13');
        
        
        userlist.add(user);
        
        insert userlist;
        
        User u = AIA_TestUtil.createTestUser();
       
        System.runAs(u) { 
            // Create Account
              Account a = AIA_TestUtil.CreateAccount('TestAccount');
            
            // system.assertNotEquals(5,AccountTeamMemberList.size());
             
         Account_Team__c atmRole2 = new Account_Team__c ();
            atmRole2.TeamMemberRole__c = 'Contract Tech';
            atmRole2.AccountId__c =a.id;
            atmRole2.UserId__c = user.id;
            AccountTeamMemberList.add(atmRole2);
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            insert nbrf;
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            //Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            imp.Account__c=a.id;
            imp.Benefit_Request_Form__c=nbrf.id;
            insert imp;
            test.startTest();   
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Implementation__c = Imp.id;
            aiaBD.Status__c='Approved';
            aiaBD.Account__c=a.id;
            aiaBD.Benefit_Request_Form__c=nbrf.id;
            try{
                 
           
            
            insert atmRole2;
                insert aiaBD;
            }
            catch(Exception e){
                
            }
            
            test.stopTest();
            }
    }
    
    static testMethod void insertBenefitDesign2(){ 
          Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List <user> userlist= new List<User>();
        List<Account_Team__c> AccountTeamMemberList= new List<Account_Team__c>();
      
     
        User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
        userlist.add(u1);
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com.test');
         userlist.add(u2);
        
        User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
         userlist.add(u3);
        
        User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF4@testorg.com.test');
         userlist.add(u4);
        
        User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF5@testorg.com.test');
         userlist.add(u5);
        
        User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF6@testorg.com.test');
         userlist.add(u6);
        
        User u7 = new User(Alias = 'TAlias7', Email='TestUserBRF7@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF7@testorg.com.test');
         userlist.add(u7);
         
                User u8 = new User(Alias = 'TAlias8', Email='TestUserBRF8@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer8', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF8@testorg.com.test');
         userlist.add(u8);
         
        User u9 = new User(Alias = 'TAlias9', Email='TestUserBRF9@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer9', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF9@testorg.com.test');
         userlist.add(u9);
         
         User u10 = new User(Alias = 'TAlias10', Email='TestUserBRF8@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer10', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF10@testorg.com.test');
         userlist.add(u10);
         
         User u11 = new User(Alias = 'TAlias11', Email='TestUserBRF11@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer11', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF11@testorg.com.test');
         userlist.add(u11);
         
         User u12 = new User(Alias = 'TAlias12', Email='TestUserBRF12@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer12', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF12@testorg.com.test');
         userlist.add(u12);
         
         User u13 = new User(Alias = 'TAlias13', Email='TestUserBRF13@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer13', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF13@testorg.com.test');
         userlist.add(u13);
         
         User u14 = new User(Alias = 'TAlias8', Email='TestUserBRF14@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer14', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF14@testorg.com.test');
         userlist.add(u14);
         
         User u15 = new User(Alias = 'TAlias15', Email='TestUserBRF15@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer15', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF15@testorg.com.test');
         userlist.add(u15);
         
         User u16 = new User(Alias = 'TAlias16', Email='TestUserBRF16@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer16', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF16@testorg.com.test');
         userlist.add(u16);
         
         User u17 = new User(Alias = 'TAlias17', Email='TestUserBRF17@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer17', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF17@testorg.com.test');
         userlist.add(u17);
         
        insert userlist;
        
        
        
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
        Account_Team__c atmRole = new Account_Team__c ();
        atmRole.TeamMemberRole__c = 'BeneFact Coder';
        atmRole.AccountId__c = a.id;
        atmRole.UserId__c = u2.id;
       AccountTeamMemberList.add(atmRole);
        
        Account_Team__c atm1 = new Account_Team__c ();
        atm1.TeamMemberRole__c = 'Ancillary Analyst';
        atm1.AccountId__c =a.id;
        atm1.UserId__c = u1.id;
      // AccountTeamMemberList.add(atm1);
        
       
        
        Account_Team__c atmRole2 = new Account_Team__c ();
        atmRole2.TeamMemberRole__c = 'MAST Tech';
        atmRole2.AccountId__c = a.id;
        atmRole2.UserId__c = u3.id;
      // AccountTeamMemberList.add(atmRole2);
        
     
        Account_Team__c atmRole5 = new Account_Team__c ();
        atmRole5.TeamMemberRole__c = 'QA Auditor';
        atmRole5.AccountId__c = a.id;
        atmRole5.UserId__c = u6.id;
        AccountTeamMemberList.add(atmRole5);
        
        Account_Team__c atmRole6 = new Account_Team__c ();
        atmRole6.TeamMemberRole__c = 'NASCO Benefit Coder'; //T01
        atmRole6.AccountId__c = a.id;
        atmRole6.UserId__c = u7.id;
        AccountTeamMemberList.add(atmRole6);
        
        Account_Team__c atmRole8 = new Account_Team__c ();
        atmRole8.TeamMemberRole__c = 'Settlements Analyst';  //T01
        atmRole8.AccountId__c = a.id;
        atmRole8.UserId__c = u8.id;
        AccountTeamMemberList.add(atmRole8);
        
        Account_Team__c atmRole9 = new Account_Team__c ();
        atmRole9.TeamMemberRole__c = 'AIA User'; //T01
        atmRole9.AccountId__c = a.id;
        atmRole9.UserId__c = u9.id;
        AccountTeamMemberList.add(atmRole9);
        
        Account_Team__c atmRole10 = new Account_Team__c ();
        atmRole10.TeamMemberRole__c = 'Production ID Card';  //T01
        atmRole10.AccountId__c = a.id;
        atmRole10.UserId__c = u10.id;
        AccountTeamMemberList.add(atmRole10);
        
        Account_Team__c atmRole11 = new Account_Team__c ();
        atmRole11.TeamMemberRole__c = 'MAIN Tech';  //T01
        atmRole11.AccountId__c = a.id;
        atmRole11.UserId__c = u11.id;
        AccountTeamMemberList.add(atmRole11);
        
        Account_Team__c atmRole12 = new Account_Team__c ();
        atmRole12.TeamMemberRole__c = 'BeneFact Tester';
        atmRole12.AccountId__c = a.id;
        atmRole12.UserId__c = u12.id;
        AccountTeamMemberList.add(atmRole12);
        
        Account_Team__c atmRole13 = new Account_Team__c ();
        atmRole13.TeamMemberRole__c = 'Account Dedicated Representative';  //T01
        atmRole13.AccountId__c = a.id;
        atmRole13.UserId__c = u13.id;
        AccountTeamMemberList.add(atmRole13);
        
        Account_Team__c atmRole14 = new Account_Team__c ();
        atmRole14.TeamMemberRole__c = 'Account Manager';
        atmRole14.AccountId__c = a.id;
        atmRole14.UserId__c = u14.id;
        AccountTeamMemberList.add(atmRole14);
        
        Account_Team__c atmRole15 = new Account_Team__c ();
        atmRole15.TeamMemberRole__c = 'Implementation Manager';  //T01
        atmRole15.AccountId__c = a.id;
        atmRole15.UserId__c = u15.id;
        AccountTeamMemberList.add(atmRole15);
        
        Account_Team__c atmRole16 = new Account_Team__c ();
        atmRole16.TeamMemberRole__c = 'Ancillary Analyst';
        atmRole16.AccountId__c = a.id;
        atmRole16.UserId__c = u17.id;
        AccountTeamMemberList.add(atmRole16);
        
        User u = AIA_TestUtil.createTestUser();
        
        
        System.runAs(u) { 
              
         
            // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            insert nbrf;
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            //Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            imp.Account__c=a.id;
            imp.Benefit_Request_Form__c=nbrf.id;
            insert imp;
            test.startTest();   
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Implementation__c = Imp.id;
            aiaBD.Status__c='Approved';
            aiaBD.Account__c=a.id;
            aiaBD.Benefit_Request_Form__c=nbrf.id;
            try{
                 
            
            insert AccountTeamMemberList;
                
            insert atmRole2;
                insert aiaBD;
            }
            catch(Exception e){
                
            }
            
            test.stopTest();
            }
    }
    
    static testMethod void insertBenefitDesign3(){ 
          Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List <user> userlist= new List<User>();
        List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
      
     
        User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
        userlist.add(u1);
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com.test');
         userlist.add(u2);
        
        User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
         userlist.add(u3);
        
        User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF4@testorg.com.test');
         userlist.add(u4);
        
        User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF5@testorg.com.test');
         userlist.add(u5);
        
        User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF6@testorg.com.test');
         userlist.add(u6);
        
        User u7 = new User(Alias = 'TAlias7', Email='TestUserBRF7@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF7@testorg.com.test');
         userlist.add(u7);
        insert userlist;
        // Create Account
        Account a = AIA_TestUtil.AIA_createAccount();
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'BeneFact Coder';
        atmRole.AccountId = a.id;
        atmRole.UserId = u2.id;
       AccountTeamMemberList.add(atmRole);
        
        AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Ancillary Analyst';
        atm1.AccountId =a.id;
        atm1.UserId = u1.id;
       AccountTeamMemberList.add(atm1);
        
       
        
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'MAST Tech';
        atmRole2.AccountId = a.id;
        atmRole2.UserId = u3.id;
       AccountTeamMemberList.add(atmRole2);
        
     
        AccountTeamMember atmRole5 = new AccountTeamMember ();
        atmRole5.TeamMemberRole = 'QA Auditor';
        atmRole5.AccountId = a.id;
        atmRole5.UserId = u6.id;
       // AccountTeamMemberList.add(atmRole5);
        
        AccountTeamMember atmRole6 = new AccountTeamMember ();
        atmRole6.TeamMemberRole = 'NASCO Benefit Coder';
        atmRole6.AccountId = a.id;
        atmRole6.UserId = u7.id;
      //  AccountTeamMemberList.add(atmRole6);
        
        
        User u = AIA_TestUtil.createTestUser();
        
        
        System.runAs(u) { 
              
         
            // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            
        /*    Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            insert nbrf;
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            imp.Account__c=a.id;
            imp.Benefit_Request_Form__c=nbrf.id;
            insert imp;*/
            test.startTest();   
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
          //  aiaBD.Implementation__c = Imp.id;
            aiaBD.Status__c='Approved';
            aiaBD.Account__c=a.id;
          //  aiaBD.Benefit_Request_Form__c=nbrf.id;
            try{
                 
           
                
                insert aiaBD;
            }
            catch(Exception e){
                
            }
            
            test.stopTest();
            }
    }
    static testMethod void insertBenefitDesign4(){ 
          Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List <user> userlist= new List<User>();
        List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
      
     
        User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
        userlist.add(u1);
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com.test');
         userlist.add(u2);
        
        User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
         userlist.add(u3);
        
        User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF4@testorg.com.test');
         userlist.add(u4);
        
        User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF5@testorg.com.test');
         userlist.add(u5);
        
        User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF6@testorg.com.test');
         userlist.add(u6);
        
        User u7 = new User(Alias = 'TAlias7', Email='TestUserBRF7@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF7@testorg.com.test');
         userlist.add(u7);
        insert userlist;
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'Ancillary Analyst';
        atmRole.AccountId = a.id;
        atmRole.UserId = u2.id;
       AccountTeamMemberList.add(atmRole);
        
        AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Ancillary Analyst';
        atm1.AccountId =a.id;
        atm1.UserId = u1.id;
       AccountTeamMemberList.add(atm1);
        
       
        
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'MAST Tech';
        atmRole2.AccountId = a.id;
        atmRole2.UserId = u3.id;
     //  AccountTeamMemberList.add(atmRole2);
        
     
        AccountTeamMember atmRole5 = new AccountTeamMember ();
        atmRole5.TeamMemberRole = 'QA Auditor';
        atmRole5.AccountId = a.id;
        atmRole5.UserId = u6.id;
       // AccountTeamMemberList.add(atmRole5);
        
        AccountTeamMember atmRole6 = new AccountTeamMember ();
        atmRole6.TeamMemberRole = 'NASCO Benefit Coder';
        atmRole6.AccountId = a.id;
        atmRole6.UserId = u7.id;
       // AccountTeamMemberList.add(atmRole6);
        
        
        User u = AIA_TestUtil.createTestUser();
        
        
        System.runAs(u) { 
              
         
            // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            
        /*    Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            insert nbrf;
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            imp.Account__c=a.id;
            imp.Benefit_Request_Form__c=nbrf.id;
            insert imp;*/
            test.startTest();   
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
          //  aiaBD.Implementation__c = Imp.id;
            aiaBD.Status__c='Approved';
            aiaBD.Account__c=a.id;
          //  aiaBD.Benefit_Request_Form__c=nbrf.id;
            try{
                 
           
                
                insert aiaBD;
            }
            catch(Exception e){
                
            }
            
            test.stopTest();
            }
    }
    
    static testMethod void insertBenefitDesign5(){ 
          Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List <user> userlist= new List<User>();
        List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
      
     
        User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
        userlist.add(u1);
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com.test');
         userlist.add(u2);
        
        User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
         userlist.add(u3);
        
        User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF4@testorg.com.test');
         userlist.add(u4);
        
        User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF5@testorg.com.test');
         userlist.add(u5);
        
        User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF6@testorg.com.test');
         userlist.add(u6);
        
        User u7 = new User(Alias = 'TAlias7', Email='TestUserBRF7@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF7@testorg.com.test');
         userlist.add(u7);
        insert userlist;
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'Contract Tech';
        atmRole.AccountId = a.id;
        atmRole.UserId = u2.id;
       AccountTeamMemberList.add(atmRole);
        
        AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Contract Tech';
        atm1.AccountId =a.id;
        atm1.UserId = u1.id;
       AccountTeamMemberList.add(atm1);
        
       
        
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'MAST Tech';
        atmRole2.AccountId = a.id;
        atmRole2.UserId = u3.id;
      // AccountTeamMemberList.add(atmRole2);
        
     
        AccountTeamMember atmRole5 = new AccountTeamMember ();
        atmRole5.TeamMemberRole = 'QA Auditor';
        atmRole5.AccountId = a.id;
        atmRole5.UserId = u6.id;
    //    AccountTeamMemberList.add(atmRole5);
        
        AccountTeamMember atmRole6 = new AccountTeamMember ();
        atmRole6.TeamMemberRole = 'NASCO Benefit Coder';
        atmRole6.AccountId = a.id;
        atmRole6.UserId = u7.id;
        AccountTeamMemberList.add(atmRole6);
        
        
        User u = AIA_TestUtil.createTestUser();
        
        
        System.runAs(u) { 
              
         
            // system.assertNotEquals(5,AccountTeamMemberList.size());
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            
        /*    Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            insert nbrf;
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            imp.Account__c=a.id;
            imp.Benefit_Request_Form__c=nbrf.id;
            insert imp;*/
            test.startTest();   
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
          //  aiaBD.Implementation__c = Imp.id;
            aiaBD.Status__c='Approved';
            aiaBD.Account__c=a.id;
          //  aiaBD.Benefit_Request_Form__c=nbrf.id;
            try{
                 
           
                
                insert aiaBD;
            }
            catch(Exception e){
                
            }
            
            test.stopTest();
            }
    }
    
    static testMethod void insertBenefitDesign6(){ 
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List <user> userlist= new List<User>();
        List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
      
        User user = new User(Alias = 'TAlias13', Email='TestUserBRF@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = pro.Id,
                              TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com13');
        
         User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
        userlist.add(u1);
        
        userlist.add(user);
        
        insert userlist;
        
        User u = AIA_TestUtil.createTestUser();
       
        System.runAs(u) { 
            // Create Account
              Account a = AIA_TestUtil.CreateAccount('TestAccount');
            
            // system.assertNotEquals(5,AccountTeamMemberList.size());
             
         AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
              AccountTeamMember atmRole3 = new AccountTeamMember ();
              atmRole3.TeamMemberRole = 'Contract Tech';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = u1.id;
            AccountTeamMemberList.add(atmRole3);
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            insert nbrf;
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            //Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            imp.Account__c=a.id;
            imp.Benefit_Request_Form__c=nbrf.id;
            insert imp;
            test.startTest();   
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Implementation__c = Imp.id;
            aiaBD.Status__c='Approved';
            aiaBD.Account__c=a.id;
            aiaBD.Benefit_Request_Form__c=nbrf.id;
            try{
                 
           
            
            insert atmRole2;
            insert atmRole3 ;
                insert aiaBD;
            }
            catch(Exception e){
                
            }
            
            test.stopTest();
            }
        }
   
    static testMethod void insertBenefitDesign7(){ 
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List <user> userlist= new List<User>();
        List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
      
        User user = new User(Alias = 'TAlias13', Email='TestUserBRF@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                              LocaleSidKey='en_US', ProfileId = pro.Id,
                              TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com13');
        
         User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
        userlist.add(u1);
        
        userlist.add(user);
        
        insert userlist;
        
        User u = AIA_TestUtil.createTestUser();
       
        System.runAs(u) { 
            // Create Account
              Account a = AIA_TestUtil.CreateAccount('TestAccount');
            
            // system.assertNotEquals(5,AccountTeamMemberList.size());
             
         AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            AccountTeamMemberList.add(atmRole2);
            
              AccountTeamMember atmRole3 = new AccountTeamMember ();
              atmRole3.TeamMemberRole = 'Ancillary Analyst';
            atmRole3.AccountId =a.id;
            atmRole3.UserId = u1.id;
            AccountTeamMemberList.add(atmRole3);
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            insert nbrf;
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            //Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            imp.Account__c=a.id;
            imp.Benefit_Request_Form__c=nbrf.id;
            insert imp;
            test.startTest();   
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Implementation__c = Imp.id;
            aiaBD.Status__c='Approved';
            aiaBD.Account__c=a.id;
            aiaBD.Benefit_Request_Form__c=nbrf.id;
            try{
                 
           
            
            insert atmRole2;
            insert atmRole3 ;
                insert aiaBD;
            }
            catch(Exception e){
                
            }
            
            test.stopTest();
            }
        }
        
         static testMethod void insertBenefitDesign8(){ 
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List <user> userlist= new List<User>();
        List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
      
       User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
        userlist.add(u1);
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com.test');
         userlist.add(u2);
        
        User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
         userlist.add(u3);
        
        User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF4@testorg.com.test');
         userlist.add(u4);
        
      //  userlist.add(user);
        
        insert userlist;
        
        User u = AIA_TestUtil.createTestUser();
       
        System.runAs(u) { 
            // Create Account
              Account a = AIA_TestUtil.AIA_createAccount();
            
            // system.assertNotEquals(5,AccountTeamMemberList.size());
             
                 AccountTeamMember atm1 = new AccountTeamMember ();
                atm1.TeamMemberRole = 'Underwriter'; //T01
                atm1.AccountId =a.id;
                atm1.UserId = u1.id;
               AccountTeamMemberList.add(atm1);
                Insert atm1;
               
                
                AccountTeamMember atmRole2 = new AccountTeamMember ();
                atmRole2.TeamMemberRole = 'Ancillary Analyst';
                atmRole2.AccountId = a.id;
                atmRole2.UserId = u2.id;
               AccountTeamMemberList.add(atmRole2);
                Insert atmRole2;
             
                AccountTeamMember atmRole3 = new AccountTeamMember ();
                atmRole3.TeamMemberRole = 'BeneFact Coder';
                atmRole3.AccountId = a.id;
                atmRole3.UserId = u3.id;
                AccountTeamMemberList.add(atmRole3);
                Insert atmRole3;
                
                AccountTeamMember atmRole4 = new AccountTeamMember ();
                atmRole4.TeamMemberRole = 'NASCO Benefit Coder';
                atmRole4.AccountId = a.id;
                atmRole4.UserId = u4.id;
                AccountTeamMemberList.add(atmRole4);
                Insert atmRole4;
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            insert nbrf;
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            //Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            imp.Account__c=a.id;
            imp.Benefit_Request_Form__c=nbrf.id;
            insert imp;
            test.startTest();   
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Implementation__c = Imp.id;
            aiaBD.Status__c='Approved';
            aiaBD.Account__c=a.id;
            aiaBD.Benefit_Request_Form__c=nbrf.id;
            try{
                 
                insert aiaBD;
            }
            catch(Exception e){
                
            }
            
            test.stopTest();
            }
        }                           
}