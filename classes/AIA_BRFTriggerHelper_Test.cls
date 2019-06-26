/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
//===================================================================================
//Date: 06/18/2016
//Developer: Goutham Rapolu
//Purpose: Test class for AIA_BRFTriggerHelper
//==================================================================================
// Update History
// Date         Developer               Description
// 
//==================================================================================
//06/18/2016        Goutham Rapolu              Initial Development
//02/08/2019        Chaithra        |T01|       Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
//==================================================================================
@isTest
public  class AIA_BRFTriggerHelper_Test {
   
    
      public static testmethod void testCaseBrokerNameUpdate(){
     
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        system.assertNotEquals(null,user.id);
        User u = AIA_TestUtil.createTestUser();
          
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);          

        User user2 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com1');
        insert user2;        
        system.assertNotEquals(null,user2.id);

        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';            
            update a;
            
         //T01 Starts
            /*AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Underwriter'; //T02
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user1.id;
            insert atmRole1;*/
            
        //T01 Ends

            
            // Create Opportunity by rajesh
            
          /*  AIA_Workplan_Type__c  wpt=AIA_TestUtil.createWPT1();
            Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('200+').getRecordTypeId();
            Opportunity o= new Opportunity();
        o.Name = 'Test opp';
        o.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        //opp.StageName = 'Proposal';
        o.StageName = 'Sold';
        o.CloseDate = Date.today() + 7;
        o.AccountId = a.id;
        o.description='test';
        o.Market_Segment_New__c = '51-199';
        o.Business_type__c = 'Renewal';
        o.Division__c = '51-199 New Business';
        o.Legal_Account_Name_Verified__c =true;
        o.Underwriting_Entity__c = 'NCAS';
        o.Effective_Date__c =  Date.newInstance(2017,10,1);  // validation rule requires effective date be 1st of month
        o.CloseDate = o.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        o.Contract_End_Date__c = o.Contract_End_Date__c.addDays(-1);
        o.Workplan_Type__c = wpt.id;
        insert o;
            */
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            //o.StageName='Sold';
            o.Business_Type__c='Renewal';
            update o;
            
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr= new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
          nbrf.Sales__c='';
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            AIA_BRFTriggerHelper.hasSkipBRFVRs_CustPerm = true;
             nbrf.Submit_to_Underwriting__c= true;
            nbrf.Request_Type__c = 'Off-Cycle - Administrative and Benefit Change';
            //nbrf.Status__c = 'Sold';
            AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = false;
                       nbrf.Opportunity__c = o.id;
            
            test.startTest();
            
            insert nbrf;
            AIA_TestUtil.createAIADocument(nbrf);
            nbrf.Status__c = 'Sold';
            nbrf.Sales__c='Approved';
      update nbrf;
           system.debug('------br id-----'+nbrf);  
            //added by rajesh
            Benfit_Request_Form__c nbrf2 = new Benfit_Request_Form__c();
            
            nbrf.Sales__c='Approved';
            nbrf2.Contract_Count__c = 123;
            nbrf2.Benefit_Effective_Date__c = system.today();
            nbrf2.Request_Type__c = 'Off-Cycle - Administrative and Benefit Change';
            nbrf2.Account__c = a.id;
            nbrf2.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf2.Escalated_to_Senior_Management__c = true;
            AIA_BRFTriggerHelper.hasSkipBRFVRs_CustPerm = true;
           // nbrf.Submit_to_Underwriting__c= true;
            nbrf2.Status__c = AIA_Constants.sold;
            nbrf2.Source_Benefit_Request_Form__c=nbrf.id;
            AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = false;
            nbrf2.Request_Type__c='Set-up Change - Administrative Changes';
           
            nbrf2.Opportunity__c = o.id;

            insert nbrf2;
            
            AIA_Document__c fileNetDoc = new AIA_Document__c();
            fileNetDoc.Document_Type__c='Signed Quote';
            fileNetDoc.Approval_Status__c='Approved';
            fileNetDoc.Benefit_Request_Form__c = nbrf2.id;
            insert fileNetDoc;
            update nbrf2;

            // T01 - Start Modified data
              List<AIA_Implementation__c> impl = new List<AIA_Implementation__c>();
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
           // Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            //Imp.Workplan_Type__c = wpt.id;
           // Imp.Generate_Workplan_Stages__c = true;
            Imp.Benefit_Request_Form__c=nbrf.id;
            Imp.status__c = AIA_Constants.NotStarted;
            Imp.Risk_Type__c='ASO';
            Imp.Business_Type__c ='NCR1';
            impl.add(Imp);
          
            insert impl;
           
            Benfit_Request_Form__c nbrft = [select id,name,Broker_Consultant_Name__c from Benfit_Request_Form__c where id=:nbrf.id];
          //system.assertEquals(nbrft.Broker_Consultant_Name__c , c.id);
            Benfit_Request_Form__c brf=[select id,Status__c,Opportunity__c,Account__c,request_type__c,(select id,Benefit_Request_Form__c,status__c,opportunity__c,opportunity__r.name, Opportunity__r.description from Implementations__r) from Benfit_Request_Form__c where id =:nbrf.id];
          system.debug('brff:'+brf.Implementations__r);
            List<Benfit_Request_Form__c> nbrfl=new List<Benfit_Request_Form__c>();
            nbrfl.add(nbrf);
            nbrfl.add(nbrf2);
              AIA_BRFTriggerHelper.updateStatus(nbrfl);
            // T01-End
                test.stopTest();
        }
 }
    
 public static testmethod void testCaseTeamRoleBNCForAccountmanager(){
        User u = AIA_TestUtil.createTestUser();
        
        System.runAs(u) { 
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';
            update a;
        
            //T01 Starts
            /*AccountTeamMember atm1 = new AccountTeamMember ();
            atm1.TeamMemberRole = 'Account Manager';
            atm1.AccountId =a.id;
            atm1.UserId = userinfo.getUserId();
            insert atm1;
            
            AccountTeamMember atm2 = new AccountTeamMember ();
            atm2.TeamMemberRole = 'Account Manager';
            atm2.AccountId =a.id;
            atm2.UserId = userinfo.getUserId();
            insert atm2;
            
            AccountTeamMember atm3 = new AccountTeamMember ();
            atm3.TeamMemberRole = 'Account Manager';
            atm3.AccountId =a.id;
            atm3.UserId = userinfo.getUserId();
            insert atm3;*/
            Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=userinfo.getUserId();
                 atmRole1.TeamMemberRole__c='Account Manager';
                 atmRole1.AccountId__c =a.id;   
            insert atmRole1;
            Account_Team__c atmRole2 =new Account_Team__c();
                 atmRole2.UserId__c=userinfo.getUserId();
                 atmRole2.TeamMemberRole__c='Account Manager';
                 atmRole2.AccountId__c =a.id;   
            insert atmRole2;
            Account_Team__c atmRole3 =new Account_Team__c();
                 atmRole3.UserId__c=userinfo.getUserId();
                 atmRole3.TeamMemberRole__c='Account Manager';
                 atmRole3.AccountId__c =a.id;   
            insert atmRole3;
            //T01 Ends
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
            AIA_TestUtil.AIA_createoppLineItem(o.Id);
            o.Business_Type__c = 'Renewal';
            o.stageName = 'Sold';
            o.Effective_Date__c =  Date.newInstance(2018,10,1);
            o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1);  
            o.Contract_End_Date__c = o.Contract_End_Date__c.addDays(-1);
            o.Won_Lost_Reason__c = 'Test';
            o.Incumbent_Successor__c = 'ACO';
            test.startTest();
            update o;
            system.assertNotEquals(null,o.id);
            
            // Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
            system.assertNotEquals(null,p.id);
            
            Try{
                Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRFForBNCRole(p.id,a.id,o.id);
                
                system.assertNotEquals(null,brf.id);
                brf.Funding_Arrangements__c ='Both';
                AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
                update brf;
                
               //Added by rajesh 
                AIA_Implementation__c Imp = new AIA_Implementation__c();
                Imp.Name__c = 'testprf';
                Imp.Opportunity__c = o.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Effective_Date__c = system.today();
                Imp.Implementation_Plan_Timeline_Days__c = '60';
                //Imp.Workplan_Type__c = wpt.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Benefit_Request_Form__c=brf.id;
                imp.status__c = AIA_Constants.NotStarted;
                imp.Risk_Type__c='ASO';
                insert imp;
                 test.stopTest();
            }Catch(Exception e){
                
            }
            
         }
       
    }
    
    
    public static testmethod void testCaseTeamRoleBNC(){
        test.startTest();
        User u = AIA_TestUtil.createTestUser();
        
        System.runAs(u) { 
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';
            update a;
            //T01 Starts
            /*AccountTeamMember atm1 = new AccountTeamMember ();
            atm1.TeamMemberRole = 'NASCO Benefit Coder';
            atm1.AccountId =a.id;
            atm1.UserId = userinfo.getUserId();
            insert atm1;
            
            AccountTeamMember atm2 = new AccountTeamMember ();
            atm2.TeamMemberRole = 'Account Manager';
            atm2.AccountId =a.id;
            atm2.UserId = userinfo.getUserId();
            insert atm2;
            
            AccountTeamMember atm3 = new AccountTeamMember ();
            atm3.TeamMemberRole = 'Account Executive';
            atm3.AccountId =a.id;
            atm3.UserId = userinfo.getUserId();
            insert atm3;*/
            
            
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            o.Business_Type__c = 'New';
            system.assertNotEquals(null,o.id);
            
            // Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
            system.assertNotEquals(null,p.id);
            
            Try{
                Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRFForBNCRole(p.id,a.id,o.id);
                
                system.assertNotEquals(null,brf.id);
                brf.Funding_Arrangements__c ='Both';
                AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
                update brf;
                
               //Added by rajesh 
                AIA_Implementation__c Imp = new AIA_Implementation__c();
                Imp.Name__c = 'testprf';
                Imp.Opportunity__c = o.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Effective_Date__c = system.today();
                Imp.Implementation_Plan_Timeline_Days__c = '60';
                //Imp.Workplan_Type__c = wpt.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Benefit_Request_Form__c=brf.id;
                imp.status__c = AIA_Constants.NotStarted;
                imp.Risk_Type__c='ASO';
                insert imp;
                
            }Catch(Exception e){
                
            }
            
         }
        test.stopTest();
    }
    
    public static testmethod void testCaseTeamRoleBNCMulti(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        insert user;
        system.assertNotEquals(null,user.id);
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);   
        test.startTest();
        
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';        
        update a;
        List<user> userList = new list<user>();
        user u8 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u8); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u17 =AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        insert userList;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u7.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u8.id,'Proposal Specialist')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'Account Manager'));
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u17.id,'Underwriter'));
        insert acctMbrList;
        
        /*AccountTeamMember atm = new AccountTeamMember ();
        atm.TeamMemberRole = 'NASCO Benefit Coder';
        atm.AccountId =a.id;
        atm.UserId = userinfo.getUserId();
        insert atm;
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'NASCO Benefit Coder';
        atmRole.AccountId =a.id;
        atmRole.UserId = user.id;
        insert atmRole;*/
      /*  AccountTeamMember atmRole1 = new AccountTeamMember ();
        atmRole1.TeamMemberRole = 'Underwriter';
        atmRole1.AccountId =a.id;
        atmRole1.UserId = user1.id;
        insert atmRole1;
        system.assertNotEquals(null,atmRole1.id);*/
        
        System.runAs(user) { 
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            o.Business_Type__c = 'New';
            system.assertNotEquals(null,o.id);
            // Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
            system.assertNotEquals(null,p.id);
            
            try{
                Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRFForBFCRole(p.id,a.id,o.id);  
                brf.Funding_Arrangements__c ='Both';
                AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
                update brf;
                
                //Added by rajesh 
                AIA_Implementation__c Imp = new AIA_Implementation__c();
                Imp.Name__c = 'testprf';
                Imp.Opportunity__c = o.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Effective_Date__c = system.today();
                Imp.Implementation_Plan_Timeline_Days__c = '60';
                //Imp.Workplan_Type__c = wpt.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Benefit_Request_Form__c=brf.id;
                imp.status__c = AIA_Constants.NotStarted;
                imp.Risk_Type__c='ASO';
                insert imp;
                
            }catch(Exception e){
                
            }
            
         }
        test.stopTest();
    } 
    
    public static testmethod void testCaseTeamRoleBFC(){
     /*   Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        insert user;
        system.assertNotEquals(null,user.id);
        User u = AIA_TestUtil.createTestUser();

        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);     */
        
          
        
        //test.startTest();
          User u = AIA_TestUtil.createTestUser();   
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('TestAccount');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';            
            update a;
            //T01 Starts
            /*AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'BeneFact Coder';
            atm.AccountId =a.id;
            atm.UserId = userinfo.getUserId();
            insert atm;
            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Underwriter';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = u.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);  */
            //T02 commented
           /* Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=userinfo.getUserId();
                 atmRole1.TeamMemberRole__c='BeneFact Coder';
                 atmRole1.AccountId__c =a.id;   
            insert atmRole1;
            Account_Team__c atmRole2 =new Account_Team__c();
                 atmRole2.UserId__c=userinfo.getUserId();
                 atmRole2.TeamMemberRole__c='Underwriter';
                 atmRole2.AccountId__c =a.id;   
            insert atmRole2;*/
           /* Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=userinfo.getUserId();
                 atmRole1.TeamMemberRole__c='BeneFact Coder';
                 atmRole1.AccountId__c =a.id;   
            insert atmRole1;
            Account_Team__c atmRole2 =new Account_Team__c();
                 atmRole2.UserId__c=userinfo.getUserId();
                 atmRole2.TeamMemberRole__c='Underwriter';
                 atmRole2.AccountId__c =a.id;   
            insert atmRole2;*/
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            o.Business_Type__c = 'New';
            system.assertNotEquals(null,o.id);
            // Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
            system.assertNotEquals(null,p.id);
            
                Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRFForBFCRole(p.id,a.id,o.id);  
                brf.Funding_Arrangements__c ='Both';
                brf.Status__c='Sold';//mod offshore
                AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
                update brf;
              try{  
                //Added by rajesh 
                AIA_Implementation__c Imp = new AIA_Implementation__c();
                Imp.Name__c = 'testprf';
                Imp.Opportunity__c = o.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Effective_Date__c = system.today();
                Imp.Implementation_Plan_Timeline_Days__c = '60';
                //Imp.Workplan_Type__c = wpt.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Benefit_Request_Form__c=brf.id;
                imp.status__c = AIA_Constants.NotStarted;
                imp.Risk_Type__c='ASO';
                test.startTest();
                insert imp;
                
            }catch(Exception e){
                
            }
            
         }
        test.stopTest();
    }
    
    public static testmethod void testCaseTeamRoleBFCMulti(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        insert user;
        system.assertNotEquals(null,user.id);
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);           
        test.startTest();
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingPostalCode = '21117';
        a.BillingCountry = 'US';
        update a;
        List<user> userList = new list<user>();
        user u8 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u8); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        insert userList;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u7.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u8.id,'Proposal Specialist')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,userinfo.getUserId(),'BeneFact Coder'));//T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,userinfo.getUserId(),'BeneFact Coder'));//T01
        insert acctMbrList;
        //T01 Starts
        /*AccountTeamMember atm = new AccountTeamMember ();
        atm.TeamMemberRole = 'BeneFact Coder';
        atm.AccountId =a.id;
        atm.UserId = userinfo.getUserId();
        insert atm;
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'BeneFact Coder';
        atmRole.AccountId =a.id;
        atmRole.UserId = user.id;
        insert atmRole;*/
        //T01 Ends
      /*      AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Underwriter';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user1.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);*/
        
        System.runAs(user) {  
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            // Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
            system.assertNotEquals(null,p.id);
            try{
                Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRFForBFCRole(p.id,a.id,o.id);  
                brf.Funding_Arrangements__c ='Both';
                AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
                update brf;
                
                //Added by rajesh 
                AIA_Implementation__c Imp = new AIA_Implementation__c();
                Imp.Name__c = 'testprf';
                Imp.Opportunity__c = o.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Effective_Date__c = system.today();
                Imp.Implementation_Plan_Timeline_Days__c = '60';
                //Imp.Workplan_Type__c = wpt.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Benefit_Request_Form__c=brf.id;
                imp.status__c = AIA_Constants.NotStarted;
                imp.Risk_Type__c='ASO';
                insert imp;
                
            }catch(Exception e){
                
            }
            
         }
        test.stopTest();
    } 
    
    public static testmethod void testCaseTeamRoleAXAMulti(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        insert user;
        system.assertNotEquals(null,user.id);
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);           
        test.startTest();
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingPostalCode = '21117';
        a.BillingCountry = 'US';
        update a;
        //T01 Starst
        /*AccountTeamMember atm = new AccountTeamMember ();
        atm.TeamMemberRole = 'BeneFact Coder';
        atm.AccountId =a.id;
        atm.UserId = userinfo.getUserId();
        insert atm;
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'Ancillary Analyst';
        atmRole.AccountId =a.id;
        atmRole.UserId = user.id;
        insert atmRole;
        
        AccountTeamMember atmRole1 = new AccountTeamMember ();
        atmRole1.TeamMemberRole = 'Ancillary Analyst';
        atmRole1.AccountId =a.id;
        atmRole1.UserId = user1.id;
        insert atmRole1;*/
         //system.assertNotEquals(null,atmRole1.id);
        //T01 ends
       
        List<user> userList = new list<user>();
        user u8 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u8); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u17 =AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);//T01 added
        insert userList;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u7.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u8.id,'Proposal Specialist')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u17.id,'BeneFact Coder'));//T01 
        insert acctMbrList;
    
        System.runAs(user) {  
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            // Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
            system.assertNotEquals(null,p.id);
            try{
                Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRFForBFCRole(p.id,a.id,o.id);  
                brf.Funding_Arrangements__c ='Both';
                AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
                update brf;
                
                //Added by rajesh 
                AIA_Implementation__c Imp = new AIA_Implementation__c();
                Imp.Name__c = 'testprf';
                Imp.Opportunity__c = o.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Effective_Date__c = system.today();
                Imp.Implementation_Plan_Timeline_Days__c = '60';
                //Imp.Workplan_Type__c = wpt.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Benefit_Request_Form__c=brf.id;
                imp.status__c = AIA_Constants.NotStarted;
                imp.Risk_Type__c='ASO';
                insert imp;
                
            }catch(Exception e){
                
            }
            
         }
        test.stopTest();
    } 
    
    public static testmethod void testCaseNOTeamRole(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        insert user;
        system.assertNotEquals(null,user.id);
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);           
        test.startTest();
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingPostalCode = '21117';
        a.BillingCountry = 'US';
        update a;
        //T01 starts
        /*AccountTeamMember atm = new AccountTeamMember ();
        atm.TeamMemberRole = 'Account Executive';
        atm.AccountId =a.id;
        atm.UserId = userinfo.getUserId();
        insert atm;
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'Proposal Specialist';
        atmRole.AccountId =a.id;
        atmRole.UserId = user.id;
        insert atmRole;
        
        AccountTeamMember atmRole1 = new AccountTeamMember ();
        atmRole1.TeamMemberRole = 'Account Manager';
        atmRole1.AccountId =a.id;
        atmRole1.UserId = user1.id;
        insert atmRole1;*/
        Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=userinfo.getUserId();
                 atmRole1.TeamMemberRole__c='Account Executive';
                 atmRole1.AccountId__c =a.id;   
            insert atmRole1;
            Account_Team__c atmRole2 =new Account_Team__c();
                 atmRole2.UserId__c=user.id;
                 atmRole2.TeamMemberRole__c='Proposal Specialist';
                 atmRole2.AccountId__c =a.id;   
            insert atmRole2;
        Account_Team__c atmRole3 =new Account_Team__c();
                 atmRole3.UserId__c=user1.id;
                 atmRole3.TeamMemberRole__c='Account Manager';
                 atmRole3.AccountId__c =a.id;   
            insert atmRole3;
        //T01 ends
        
        
    
        System.runAs(user) {  
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            // Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
            system.assertNotEquals(null,p.id);
            try{
                Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRFForBFCRole(p.id,a.id,o.id);  
                brf.Funding_Arrangements__c ='Both';
                AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
                update brf;
                
                //added by rajesh
                 Benfit_Request_Form__c brf2 = AIA_TestUtil.CreateBRFForBFCRole(p.id,a.id,o.id);  
                 brf2.Status__c = AIA_Constants.sold;
                brf2.Source_Benefit_Request_Form__c=brf.id;
                    update brf2;
                    //end
                system.debug('------br id-----'+brf2.id);
                //added by rajesh
                
              AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            //Imp.Workplan_Type__c = wpt.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Benefit_Request_Form__c=brf2.id;
            imp.status__c = AIA_Constants.InProgress;
            imp.Risk_Type__c='ASO';
            insert imp;
            //end
            }catch(Exception e){
                
            }
            
         }
        test.stopTest();
    } 

    public static testmethod void testCaseTeamWithOutRole(){
        test.startTest();

        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingPostalCode = '21117';
        a.BillingCountry = 'US';
        update a;
        
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
        PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
        system.assertNotEquals(null,p.id);
        try{
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Proposal_Request_Form__c = p.id;
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
            insert nbrf;
            
            List<Benfit_Request_Form__c> brflist = new List<Benfit_Request_Form__c>();
            brflist.add(nbrf);
            
            Set<id> setaccid = new Set<id>();
            setaccid.add(a.id);
            
            //Added by rajesh 
                AIA_Implementation__c Imp = new AIA_Implementation__c();
                Imp.Name__c = 'testprf';
                Imp.Opportunity__c = o.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Effective_Date__c = system.today();
                Imp.Implementation_Plan_Timeline_Days__c = '60';
                //Imp.Workplan_Type__c = wpt.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Benefit_Request_Form__c=nbrf.id;
                imp.status__c = AIA_Constants.NotStarted;
                imp.Risk_Type__c='ASO';
                insert imp;
         
         AIA_BRFTriggerHelper.processEmail(brflist,setaccid);
         
        }catch(Exception e){}
        test.stopTest();
    }

    public static testmethod void testBRFSOLD(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        system.assertNotEquals(null,user.id);
        User u = AIA_TestUtil.createTestUser();
          
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);          
        
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';
            update a;
            
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            insert atm;
            system.assertNotEquals(null,atm.id);
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            insert atmRole;
            system.assertNotEquals(null,atmRole.id);
            
            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Underwriter';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user1.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);
            test.startTest();



        
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
        PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
        system.assertNotEquals(null,p.id);
        try{
            
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
           /* nbrf.Proposal_Request_Form__c = p.id;
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';*/
            
            
           // nbrf = QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO  ');
            nbrf.Account__c = a.id;
            nbrf.Opportunity__c = o.id;
            nbrf.Request_Type__c = 'Prospect/New';
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Benefit_Period__c = 'Calendar';
           // nbrf.Control_Plan__c = 'MD';
            nbrf.Status__c = 'New';
            nbrf.Sales_Segment_Size__c = 'Commercial 1,000+';
            nbrf.Contract_Period__c = 'Non-Standard';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Broker_Commission__c = 3.5;
            nbrf.Contract_Count__c = 12;
            nbrf.Formulary__c = 'N/A';
            nbrf.Maintenance_Choice__c = 'N/A';
            nbrf.Exclusive_Specialty_Provider_Network__c = 'Yes';
            nbrf.Generic_Step_Therapy__c = 'Dummy1';
            nbrf.Tiers__c = '3';
            nbrf.Number_of_Months_for_Contract_Period__c = 24;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
            insert nbrf;
            
       AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Signed Quote';
        fileNetDoc.Benefit_Request_Form__c = nbrf.id;
        insert fileNetDoc;
         nbrf.Status__c = 'Sold';
        update nbrf;
            
        }catch(Exception e){}
        test.stopTest();
    }


}

  public static testmethod void testValidateSoldSOLD(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        system.assertNotEquals(null,user.id);
        User u = AIA_TestUtil.createTestUser();
          
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);          
        
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account1');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';
            update a;
            
         /*   AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            insert atm;
            system.assertNotEquals(null,atm.id);
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            insert atmRole;
            system.assertNotEquals(null,atmRole.id);
            
            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Underwriter';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user1.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);*/
            test.startTest();



        
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
           //Insert PRF
          PRF__c prf = new PRF__c();
            prf.Name = 'testprf';
            prf.Opportunity__c = o.id;
            prf.Alt_Network_State__c = 'MD';
            prf.CDH_Administrator__c = 'ConnectYourCare';
            prf.Medical_Networks__c = 'Alternative Networks';
            prf.Medical_Products__c = 'CDH';
            prf.CDH_Products__c = 'Blue Preferred';
            prf.CDH_Addl_Info__c = 'Test';
            prf.CDH_Funding_Arrangement__c = 'HSA';
            insert prf;
        
        
        system.assertNotEquals(null,prf.id);
        try{
            
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
           /* nbrf.Proposal_Request_Form__c = p.id;
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';*/
            
            
           // nbrf = QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO  ');
            nbrf.Account__c = a.id;
            nbrf.Opportunity__c = o.id;
            nbrf.Request_Type__c = 'Prospect/New';
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Benefit_Period__c = 'Calendar';
         //   nbrf.Control_Plan__c = 'MD';
            nbrf.Status__c = 'New';
            nbrf.Sales_Segment_Size__c = 'Commercial 1,000+';
            nbrf.Contract_Period__c = 'Non-Standard';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Broker_Commission__c = 3.5;
            nbrf.Contract_Count__c = 12;
            nbrf.Formulary__c = 'N/A';
            nbrf.Maintenance_Choice__c = 'N/A';
            nbrf.Exclusive_Specialty_Provider_Network__c = 'Yes';
            nbrf.Generic_Step_Therapy__c = 'Dummy1';
            nbrf.Tiers__c = '3';
            nbrf.Number_of_Months_for_Contract_Period__c = 24;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Proposal_Request_Form__c = prf.id;
            AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
            insert nbrf;
            
            //Added by rajesh 
                AIA_Implementation__c Imp = new AIA_Implementation__c();
                Imp.Name__c = 'testprf';
                Imp.Opportunity__c = o.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Effective_Date__c = system.today();
                Imp.Implementation_Plan_Timeline_Days__c = '60';
                //Imp.Workplan_Type__c = wpt.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Benefit_Request_Form__c=nbrf.id;
                imp.status__c = AIA_Constants.NotStarted;
                imp.Risk_Type__c='ASO';
                insert imp;
                
       AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = nbrf.id;
        insert fileNetDoc;
         nbrf.Status__c = 'Sold';
        update nbrf;
                          
        }catch(Exception e){}
        test.stopTest();
    }


}

    public static testmethod void testBRFCensusInformation(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        system.assertNotEquals(null,user.id);
        User u = AIA_TestUtil.createTestUser();
          
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);          
        
        
        System.runAs(u) { 
            // Create Account
             Account a = new Account();
            a.Name = 'accountName';
            a.Type = 'Customer';
//            a.RecordTypeId = rt_acc_51;      
            a.Renewal_Anniversary_Month__c='Jan';
            a.Account_Legal_Name__c= 'test Account';
            
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';
            insert a;
            
         /*   AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'NASCO Benefit Coder';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            insert atm;
            system.assertNotEquals(null,atm.id);
            
            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            insert atmRole;
            system.assertNotEquals(null,atmRole.id); */
            
            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Underwriter';
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user1.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id); 
            test.startTest();



        
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
        PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
        system.assertNotEquals(null,p.id);
        try{
            
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();

            
            //nbrf = QueryBase.getRecordtypeid('Benfit_Request_Form__c','ASO');
            nbrf.Account__c = a.id;
            nbrf.Opportunity__c = o.id;
            nbrf.Request_Type__c = 'Prospect/New';
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Benefit_Period__c = 'Calendar';
          //  nbrf.Control_Plan__c = 'MD';
            nbrf.Status__c = 'New';
            nbrf.Sales_Segment_Size__c = 'Commercial 1,000+';
            nbrf.Contract_Period__c = 'Non-Standard';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Broker_Commission__c = 3.5;
            nbrf.Contract_Count__c = 12;
            nbrf.Formulary__c = 'N/A';
            nbrf.Maintenance_Choice__c = 'N/A';
            nbrf.Exclusive_Specialty_Provider_Network__c = 'Yes';
            nbrf.Generic_Step_Therapy__c = 'Dummy1';
            nbrf.Tiers__c = '3';
            nbrf.Number_of_Months_for_Contract_Period__c = 24;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
         //   nbrf.Submit_to_Underwriting__c= false;
          //  AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
            insert nbrf;
            
       AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = nbrf.id;
        insert fileNetDoc;
         nbrf.Status__c = 'Sold';
        update nbrf;
        
        
       AIA_Plan__c plantest= AIA_TestUtil.CreateGSMPlan('Medical', 'Medical-1');
        Proposed_Products__c pp0= AIA_TestUtil.createBRFProposedProducts(nbrf.id, plantest.id, 'Medical'); 
        insert pp0;
            
        }catch(Exception e){}
        test.stopTest();
    }       
     

}

public static testmethod void testCaseTeamRoleMASMulti(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com');
        insert user;
        system.assertNotEquals(null,user.id);
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);           
        test.startTest();
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingPostalCode = '21117';
        a.BillingCountry = 'US';
        update a;
        List<user> userList = new list<user>();
        user u8 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u8); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        insert userList;
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u7.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u8.id,'Proposal Specialist')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'Account Manager'));
        insert acctMbrList;
        AccountTeamMember atm = new AccountTeamMember ();
        atm.TeamMemberRole = 'BeneFact Coder';
        atm.AccountId =a.id;
        atm.UserId = userinfo.getUserId();
        insert atm;
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'MAST Tech';
        atmRole.AccountId =a.id;
        atmRole.UserId = user.id;
        insert atmRole;
        
        AccountTeamMember atmRole1 = new AccountTeamMember ();
        atmRole1.TeamMemberRole = 'MAST Tech';
        atmRole1.AccountId =a.id;
        atmRole1.UserId = user1.id;
        insert atmRole1;
        
        system.assertNotEquals(null,atmRole1.id);
    
        System.runAs(user) {  
            
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            // Create PRF
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
            system.assertNotEquals(null,p.id);
            try{
                Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRFForBFCRole(p.id,a.id,o.id);  
                brf.Funding_Arrangements__c ='Both';
                AIA_BRFTriggerHelper.hasSkipBRFVRs_CustPerm = false;
                update brf;
            }catch(Exception e){
                
            }
            
         }
        test.stopTest();
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
                atm1.TeamMemberRole = 'Underwriter';
                atm1.AccountId =a.id;
                atm1.UserId = u1.id;
               AccountTeamMemberList.add(atm1);
                Insert atm1;
               
                
              /*  AccountTeamMember atmRole2 = new AccountTeamMember ();
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
                Insert atmRole4;*/
            
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
             AIA_BRFTriggerHelper.hasSkipBRFVRs_CustPerm = false;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
                     
                     //added by rajesh
                Benfit_Request_Form__c nbrf2 = new Benfit_Request_Form__c();
            nbrf2.Contract_Count__c = 123;
            nbrf2.Benefit_Effective_Date__c = system.today();
            nbrf2.Account__c = a.id;
            nbrf2.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf2.Escalated_to_Senior_Management__c = true;
             AIA_BRFTriggerHelper.hasSkipBRFVRs_CustPerm = false;
            nbrf2.Status__c = 'new';
            nbrf2.Source_Benefit_Request_Form__c=nbrf.id;
            nbrf2.Opportunity__c = o.id;
            
            
            test.startTest();   
            
           
            try{
                 
                insert nbrf;
            }
            catch(Exception e){
                
            }
            
            test.stopTest();
            }
        }
   
   static testMethod void insertBenefitDesign9(){ 
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
              a.jurisdiction__c = 'VA';
              update a;
            
            // system.assertNotEquals(5,AccountTeamMemberList.size());
             
                 AccountTeamMember atm1 = new AccountTeamMember ();
                atm1.TeamMemberRole = 'Underwriter';
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
                
          
            // Create Opportunity
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
            system.assertNotEquals(null,p.id);
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
             AIA_BRFTriggerHelper.hasSkipBRFVRs_CustPerm = false;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            nbrf.Proposal_Request_Form__c = p.id;
            
            list<Benfit_Request_Form__c> brflist = new List<Benfit_Request_Form__c>();
            Benfit_Request_Form__c nbrf2 = new Benfit_Request_Form__c();
            nbrf2.Contract_Count__c = 123;
            nbrf2.Benefit_Effective_Date__c = system.today();
            nbrf2.Account__c = a.id;
            nbrf2.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf2.Escalated_to_Senior_Management__c = true;
             AIA_BRFTriggerHelper.hasSkipBRFVRs_CustPerm = false;
            nbrf2.Status__c = 'Sold';
            nbrf2.Opportunity__c = o.id;
            nbrf2.Proposal_Request_Form__c = p.id;
            
            Benfit_Request_Form__c nbrf1 = new Benfit_Request_Form__c();
            nbrf1.Contract_Count__c = 1234;
            nbrf1.Source_Benefit_Request_Form__c = nbrf2.id;
            nbrf1.Request_Type__c = 'Set-up Change - Benefit Changes';
            nbrf1.Benefit_Effective_Date__c = system.today();
            nbrf1.Account__c = a.id;
            nbrf1.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf1.Escalated_to_Senior_Management__c = true;
             AIA_BRFTriggerHelper.hasSkipBRFVRs_CustPerm = false;
            nbrf1.Status__c = 'Sold';
            nbrf1.Opportunity__c = o.id;
            
        
            
            brflist.add(nbrf2);
            brflist.add(nbrf1);
                     
            test.startTest();   

            try{
                 
                insert nbrf;
            }
            catch(Exception e){
                
            }
            
            test.stopTest();
            }
        }
   public static testmethod void testValidateSoldSOLD1(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        system.assertNotEquals(null,user.id);
        User u = AIA_TestUtil.createTestUser();
          
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);          
        
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';
            a.Jurisdiction__c='VA';
            update a;
        AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Underwriter';  //T02
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user1.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);
            test.startTest();
      // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
           //Insert PRF
          PRF__c prf = new PRF__c();
            prf.Name = 'testprf';
            prf.Opportunity__c = o.id;
            prf.Alt_Network_State__c = 'MD';
            prf.CDH_Administrator__c = 'ConnectYourCare';
            prf.Medical_Networks__c = 'Alternative Networks';
            prf.Medical_Products__c = 'CDH';
            prf.CDH_Products__c = 'Blue Preferred';
            prf.CDH_Addl_Info__c = 'Test';
            prf.CDH_Funding_Arrangement__c = 'HSA';
            insert prf;
        
        
        system.assertNotEquals(null,prf.id);
        try{
            
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
              nbrf.Account__c = a.id;
            nbrf.Opportunity__c = o.id;
            nbrf.Request_Type__c = 'Off-Cycle - Administrative and Benefit Change';
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Benefit_Period__c = 'Calendar';
         //   nbrf.Control_Plan__c = 'MD';
            nbrf.Status__c = 'New';
            nbrf.Sales_Segment_Size__c = 'Commercial 1,000+';
            nbrf.Contract_Period__c = 'Non-Standard';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Broker_Commission__c = 3.5;
            nbrf.Contract_Count__c = 12;
            nbrf.Formulary__c = 'N/A';
            nbrf.Maintenance_Choice__c = 'N/A';
            nbrf.Exclusive_Specialty_Provider_Network__c = 'Yes';
            nbrf.Generic_Step_Therapy__c = 'Dummy1';
            nbrf.Tiers__c = '3';
            nbrf.Number_of_Months_for_Contract_Period__c = 24;
            nbrf.ARC_Approval_Status__c = 'Auto-Approved by System';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Proposal_Request_Form__c = prf.id;
            nbrf.Submit_to_Underwriting__c = false;
           nbrf.Sales__c='Approved';
            insert nbrf;
            AIA_BRFTriggerHelper.hasSkipBRFVRs_CustPerm = false;
            //Added by rajesh 
                AIA_Implementation__c Imp = new AIA_Implementation__c();
                Imp.Name__c = 'testprf';
                Imp.Opportunity__c = o.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Effective_Date__c = system.today();
                Imp.Implementation_Plan_Timeline_Days__c = '60';
                //Imp.Workplan_Type__c = wpt.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Benefit_Request_Form__c=nbrf.id;
                imp.status__c = AIA_Constants.NotStarted;
                imp.Risk_Type__c='ASO';
                insert imp;
                
       AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Signed Quote';
        fileNetDoc.Benefit_Request_Form__c = nbrf.id;
        insert fileNetDoc;
         nbrf.Status__c = 'Sold';
        update nbrf;
                          
        }catch(Exception e){}
        test.stopTest();
    }


}
 
public static testmethod void testValidateSoldSOLD2(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        system.assertNotEquals(null,user.id);
        User u = AIA_TestUtil.createTestUser();
          
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);          
        
        User user2 = new User(Alias = 'Alias12', Email='TestUserBRF2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF11@testorg.com1');
        insert user2;        
        system.assertNotEquals(null,user2.id);
    
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';
            a.Jurisdiction__c='VA';
            update a;
            
            AccountTeamMember atm = new AccountTeamMember ();
            atm.TeamMemberRole = 'Account Executive';
            atm.AccountId =a.id;
            atm.UserId = u.id;
            insert atm;
            system.assertNotEquals(null,atm.id); 
            
            /*AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'Implementation Manager';
            atmRole.AccountId =a.id;
            atmRole.UserId = user.id;
            insert atmRole;
            system.assertNotEquals(null,atmRole.id);
            
            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Underwriter';   //T02
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user1.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);
            
             AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Account Manager';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user2.id;
            insert atmRole2;
            system.assertNotEquals(null,atmRole2.id);*/
            Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=user.id;
                 atmRole1.TeamMemberRole__c='Implementation Manager';
                 atmRole1.AccountId__c =a.id;   
            insert atmRole1;
            Account_Team__c atmRole2 =new Account_Team__c();
                 atmRole2.UserId__c=user1.id;
                 atmRole2.TeamMemberRole__c='Underwriter';
                 atmRole2.AccountId__c =a.id;   
            insert atmRole2;
        Account_Team__c atmRole3 =new Account_Team__c();
                 atmRole3.UserId__c=user2.id;
                 atmRole3.TeamMemberRole__c='Account Manager';
                 atmRole3.AccountId__c =a.id;   
            insert atmRole3;
        //T01 ends
            test.startTest();
      // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            
        system.assertNotEquals(null,o.id);
        // Create PRF
           //Insert PRF
          PRF__c prf = new PRF__c();
            prf.Name = 'testprf';
            prf.Opportunity__c = o.id;
            prf.Alt_Network_State__c = 'MD';
            prf.CDH_Administrator__c = 'ConnectYourCare';
            prf.Medical_Networks__c = 'Alternative Networks';
            prf.Medical_Products__c = 'CDH';
            prf.CDH_Products__c = 'Blue Preferred';
            prf.CDH_Addl_Info__c = 'Test';
            prf.CDH_Funding_Arrangement__c = 'HSA';
            insert prf;
        
        
        system.assertNotEquals(null,prf.id);
        try{
            
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
           
            nbrf.Account__c = a.id;
           // nbrf.Opportunity__c = o.id;
            nbrf.Request_Type__c = 'Prospect/New';
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Benefit_Period__c = 'Calendar';
         //   nbrf.Control_Plan__c = 'MD';
            nbrf.Status__c = 'New';
            nbrf.Sales_Segment_Size__c = 'Commercial 1,000+';
            nbrf.Contract_Period__c = 'Non-Standard';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Broker_Commission__c = 3.5;
            nbrf.Contract_Count__c = 12;
            nbrf.Formulary__c = 'N/A';
            nbrf.Maintenance_Choice__c = 'N/A';
            nbrf.Exclusive_Specialty_Provider_Network__c = 'Yes';
            nbrf.Generic_Step_Therapy__c = 'Dummy1';
            nbrf.Tiers__c = '3';
            nbrf.Number_of_Months_for_Contract_Period__c = 24;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Proposal_Request_Form__c = prf.id;
            nbrf.Submit_to_Underwriting__c = true;
            AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = false;
            insert nbrf;
            
            //Added by rajesh 
                AIA_Implementation__c Imp = new AIA_Implementation__c();
                Imp.Name__c = 'testprf';
                Imp.Opportunity__c = o.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Effective_Date__c = system.today();
                Imp.Implementation_Plan_Timeline_Days__c = '60';
                //Imp.Workplan_Type__c = wpt.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Benefit_Request_Form__c=nbrf.id;
                imp.status__c = AIA_Constants.NotStarted;
                imp.Risk_Type__c='ASO';
                insert imp;
                
       AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Signed Quote';
        fileNetDoc.Benefit_Request_Form__c = nbrf.id;
        insert fileNetDoc;
         nbrf.Status__c = 'Sold';
        update nbrf;
          o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
            o.StageName='Sold';
            o.Business_Type__c='Renewal';
            update o;                
        }catch(Exception e){}
        test.stopTest();
    }


} 
  public static testmethod void testCaseBrokerNameUpdate1(){
      AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = false;
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        system.assertNotEquals(null,user.id);
        User u = AIA_TestUtil.createTestUser();
          
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);          

        User user2 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com1');
        insert user2;        
        system.assertNotEquals(null,user2.id);

        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';            
            update a;
            
         //T01 starts
            /*AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Underwriter';  //T02
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user1.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);*/
            Account_Team__c atmRole2 =new Account_Team__c();
                 atmRole2.UserId__c=user1.id;
                 atmRole2.TeamMemberRole__c='Underwriter';
                 atmRole2.AccountId__c =a.id;   
            insert atmRole2;
            //t01 Ends

            
            // Create Opportunity by rajesh
            
          /*  AIA_Workplan_Type__c  wpt=AIA_TestUtil.createWPT1();
            Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('200+').getRecordTypeId();
            Opportunity o= new Opportunity();
        o.Name = 'Test opp';
        o.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        //opp.StageName = 'Proposal';
        o.StageName = 'Sold';
        o.CloseDate = Date.today() + 7;
        o.AccountId = a.id;
        o.description='test';
        o.Market_Segment_New__c = '51-199';
        o.Business_type__c = 'Renewal';
        o.Division__c = '51-199 New Business';
        o.Legal_Account_Name_Verified__c =true;
        o.Underwriting_Entity__c = 'NCAS';
        o.Effective_Date__c =  Date.newInstance(2017,10,1);  // validation rule requires effective date be 1st of month
        o.CloseDate = o.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        o.Contract_End_Date__c = o.Contract_End_Date__c.addDays(-1);
        o.Workplan_Type__c = wpt.id;
        insert o;
            */
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            //o.StageName='Sold';
            o.Business_Type__c='Renewal';
            update o;
            
            //create contact
            contact c = AIA_TestUtil.createTestContactsAcc(a.id);
            insert c; 
            
            //add contact role for opp
            OpportunityContactRole ocr= new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
          nbrf.Sales__c='';
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
             nbrf.Submit_to_Underwriting__c= true;
            nbrf.Request_Type__c = 'Off-Cycle - Administrative and Benefit Change';
            //nbrf.Status__c = 'Sold';
              nbrf.Opportunity__c = o.id;
            
            test.startTest();
            system.debug('** test boolean'+AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm);
            insert nbrf;
            AIA_TestUtil.createAIADocument(nbrf);
            nbrf.Status__c = 'Sold';
            nbrf.Sales__c='Approved';
      update nbrf;
           system.debug('------br id-----'+nbrf);  
            //added by rajesh
            Benfit_Request_Form__c nbrf2 = new Benfit_Request_Form__c();
            
            nbrf.Sales__c='Approved';
            nbrf2.Contract_Count__c = 123;
            nbrf2.Benefit_Effective_Date__c = system.today();
            nbrf2.Request_Type__c = 'Off-Cycle - Administrative and Benefit Change';
            nbrf2.Account__c = a.id;
            nbrf2.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf2.Escalated_to_Senior_Management__c = true;
            AIA_BRFTriggerHelper.hasSkipBRFVRs_CustPerm = true;
           // nbrf.Submit_to_Underwriting__c= true;
            nbrf2.Status__c = AIA_Constants.sold;
            nbrf2.Source_Benefit_Request_Form__c=nbrf.id;
            AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = false;
            nbrf2.Request_Type__c='Set-up Change - Administrative Changes';
           // AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = false;
            nbrf2.Opportunity__c = o.id;

            insert nbrf2;
            
            AIA_Document__c fileNetDoc = new AIA_Document__c();
            fileNetDoc.Document_Type__c='Signed Quote';
            fileNetDoc.Approval_Status__c='Approved';
            fileNetDoc.Benefit_Request_Form__c = nbrf2.id;
            insert fileNetDoc;
            update nbrf2;

            
              List<AIA_Implementation__c> impl = new List<AIA_Implementation__c>();
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            //Imp.Workplan_Type__c = wpt.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Benefit_Request_Form__c=nbrf.id;
            Imp.status__c = 'In-Progress';
            Imp.Risk_Type__c='ASO';
            Imp.Business_Type__c ='NCR1';
            impl.add(Imp);
            //added by offshore
            AIA_Implementation__c Imp2 = new AIA_Implementation__c();
            Imp2.Name__c = 'testprf';
            Imp2.Opportunity__c = o.id;
            Imp2.Generate_Workplan_Stages__c = true;
            Imp2.Effective_Date__c = system.today();
            Imp2.Implementation_Plan_Timeline_Days__c = '60';
            //Imp.Workplan_Type__c = wpt.id;
            Imp2.Generate_Workplan_Stages__c = true;
            Imp2.Benefit_Request_Form__c=nbrf2.id;
            Imp2.status__c = 'In-Progress';
            Imp2.Risk_Type__c='ASO';
            Imp2.Business_Type__c ='NCR';
            impl.add(Imp2);
            system.debug('----imp1---'+imp.id+'---------imp1--status__c --'+imp.status__c+'---------'+imp.Benefit_Request_Form__c);
            AIA_Implementation__c Imp1 = new AIA_Implementation__c();
            Imp1.Name__c = 'testprf';
            Imp1.Opportunity__c = o.id;
            Imp1.Business_Type__c ='NCR';
            Imp1.Generate_Workplan_Stages__c = true;
            Imp1.Effective_Date__c = system.today();
            Imp1.Implementation_Plan_Timeline_Days__c = '60';
            //Imp.Workplan_Type__c = wpt.id;
            Imp1.Generate_Workplan_Stages__c = true;
            Imp1.Benefit_Request_Form__c=nbrf.id;
            Imp1.status__c = AIA_Constants.NotStarted;
            Imp1.Risk_Type__c='ASO';
            impl.add(Imp1);
            insert impl;
           // system.debug('----imp1---'+imp1.id+'------imp1--status__c --'+imp1.status__c+'---------'+imp1.Benefit_Request_Form__c);
            //end
           // Benfit_Request_Form__c nbrft = [select id,name,Broker_Consultant_Name__c from Benfit_Request_Form__c where id=:nbrf.id];
          //system.assertEquals(nbrft.Broker_Consultant_Name__c , c.id);
           // Benfit_Request_Form__c brf=[select id,Status__c,Opportunity__c,Account__c,request_type__c,(select id,Benefit_Request_Form__c,status__c,opportunity__c,opportunity__r.name, Opportunity__r.description from Implementations__r) from Benfit_Request_Form__c where id =:nbrf.id];
         // system.debug('brff:'+brf.Implementations__r);
            List<Benfit_Request_Form__c> nbrfl=new List<Benfit_Request_Form__c>();
            nbrfl.add(nbrf);
           nbrfl.add(nbrf2);
            try{
     AIA_BRFTriggerHelper.updateStatus(nbrfl);
            }catch(exception e){}
                test.stopTest();
        }
 } 
    
 public static testmethod void testValidateSoldSOLD3(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User user = new User(Alias = 'TAlias1', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com1');
        insert user;
        system.assertNotEquals(null,user.id);
        User u = AIA_TestUtil.createTestUser();
          
        User user1 = new User(Alias = 'TAlias11', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com1');
        insert user1;        
        system.assertNotEquals(null,user1.id);          
        
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            a.BillingStreet = 'Test Street';
            a.BillingCity = 'Test City';
            a.BillingPostalCode = '21117';
            a.BillingCountry = 'US';
            a.Jurisdiction__c='VA';
            update a;
        AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Underwriter';  //T02
            atmRole1.AccountId =a.id;
            atmRole1.UserId = user1.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);
            test.startTest();
      // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
           //Insert PRF
          PRF__c prf = new PRF__c();
            prf.Name = 'testprf';
            prf.Opportunity__c = o.id;
            prf.Alt_Network_State__c = 'MD';
            prf.CDH_Administrator__c = 'ConnectYourCare';
            prf.Medical_Networks__c = 'Alternative Networks';
            prf.Medical_Products__c = 'CDH';
            prf.CDH_Products__c = 'Blue Preferred';
            prf.CDH_Addl_Info__c = 'Test';
            prf.CDH_Funding_Arrangement__c = 'HSA';
            insert prf;
        
        
        system.assertNotEquals(null,prf.id);
        try{
            
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
              nbrf.Account__c = a.id;
            nbrf.Opportunity__c = o.id;
            nbrf.Request_Type__c = 'Set-up Change - Admin and Benefit Changes';
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Benefit_Period__c = 'Calendar';
         //   nbrf.Control_Plan__c = 'MD';
            nbrf.Status__c = 'New';
            nbrf.Sales_Segment_Size__c = 'Commercial 1,000+';
            nbrf.Contract_Period__c = 'Non-Standard';
            nbrf.Grandfathered_Status__c = 'Grandfathered';
            nbrf.Broker_Commission__c = 3.5;
            nbrf.Contract_Count__c = 12;
            nbrf.Formulary__c = 'N/A';
            nbrf.Maintenance_Choice__c = 'N/A';
            nbrf.Exclusive_Specialty_Provider_Network__c = 'Yes';
            nbrf.Generic_Step_Therapy__c = 'Dummy1';
            nbrf.Tiers__c = '3';
            nbrf.Number_of_Months_for_Contract_Period__c = 24;
            nbrf.ARC_Approval_Status__c = 'Auto-Approved by System';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Proposal_Request_Form__c = prf.id;
            nbrf.Submit_to_Underwriting__c = false;
           nbrf.Sales__c='Approved';
            insert nbrf;
            AIA_BRFTriggerHelper.hasSkipBRFVRs_CustPerm = false;
            //Added by rajesh 
                AIA_Implementation__c Imp = new AIA_Implementation__c();
                Imp.Name__c = 'testprf';
                Imp.Opportunity__c = o.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Effective_Date__c = system.today();
                Imp.Implementation_Plan_Timeline_Days__c = '60';
                //Imp.Workplan_Type__c = wpt.id;
                Imp.Generate_Workplan_Stages__c = true;
                Imp.Benefit_Request_Form__c=nbrf.id;
                imp.status__c = AIA_Constants.NotStarted;
                imp.Risk_Type__c='ASO';
                insert imp;
                
       AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Signed Quote';
        fileNetDoc.Benefit_Request_Form__c = nbrf.id;
        insert fileNetDoc;
         nbrf.Status__c = 'Sold';
        update nbrf;
                          
        }catch(Exception e){}
        test.stopTest();
    }


}
 
  
 
}