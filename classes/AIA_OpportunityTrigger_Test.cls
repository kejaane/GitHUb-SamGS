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
@isTest
private class AIA_OpportunityTrigger_Test{
    static testMethod void testMarkOpportunitySold(){
       Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom' limit 1]; 
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestclassUserBRF@testorg.com');
        insert u;
                
        List <user> userlist= new List<User>();
        //List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
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
         insert userlist;
       
         System.runAs(u) {  
        
        Account testacct1 = AIA_Testutil.createAccount('Test Account');  
        
       /*AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'BeneFact Coder';
        atmRole.AccountId = testacct1.id;
        atmRole.UserId = u1.id;
       	AccountTeamMemberList.add(atmRole);
		AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Ancillary Analyst';
        atm1.AccountId = testacct1.id;
        atm1.UserId = u2.id;
      	AccountTeamMemberList.add(atm1);  
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'NASCO Benefit Coder';
        atmRole2.AccountId = testacct1.id;
        atmRole2.UserId = u3.id;
      	AccountTeamMemberList.add(atmRole2);*/
        Account_Team__c atmRole2 =new Account_Team__c();
        atmRole2.UserId__c=u1.id;
        atmRole2.TeamMemberRole__c='BeneFact Coder';
        atmRole2.AccountId__c =testacct1.id;   
        insert atmRole2;     
       
        Id rt_opp_200= QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
      
        
        Opportunity opp = new Opportunity();
            opp.Name = 'Test opp';
            opp.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
            opp.StageName = 'RFP';
            opp.CloseDate = Date.today() + 7;
            opp.AccountId = testacct1.id;
            opp.Market_Segment_New__c = '51-199';
            // opp.Business_type__c = 'Off-Cycle';
            opp.Division__c = '51-199 New Business';
            opp.Legal_Account_Name_Verified__c =true;
            opp.Underwriting_Entity__c = 'NCAS';
            Date tday = system.today();
            opp.Effective_Date__c =Date.newInstance(tday.Year(),tday.month(),1);  //Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
            opp.CloseDate = opp.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
            opp.Contract_End_Date__c = opp.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
            opp.Contract_End_Date__c = opp.Contract_End_Date__c.addDays(-1);            
            opp.Off_Cycle_Term_Date__c = opp.Effective_Date__c.addDays(-1);
            
            Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;
            opp.RecordTypeId = opptwohundredplusId;
       		//Removed as per US210
             /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'Off-Cycle';
            wpt.Active__c=true;
          insert wpt;*/
            insert opp;
          Test.startTest();       
           
          	Opportunity opp2 = new Opportunity();
            opp2.Name = 'Test opp';
            opp2.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
            opp2.StageName = 'RFP';
            opp2.CloseDate = Date.today() + 7;
            opp2.AccountId = testacct1.id;
            opp2.Market_Segment_New__c = '51-199';
            // opp.Business_type__c = 'Off-Cycle';
            opp2.Division__c = '51-199 New Business';
            opp2.Legal_Account_Name_Verified__c =true;
            opp2.Underwriting_Entity__c = 'NCAS';
            Date tday2 = system.today();
            opp2.Effective_Date__c =Date.newInstance(tday.Year(),tday2.month(),1);  //Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
            opp2.CloseDate = opp2.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
            opp2.Contract_End_Date__c = opp2.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
            opp2.Contract_End_Date__c = opp2.Contract_End_Date__c.addDays(-1);            
            opp2.Off_Cycle_Term_Date__c = opp2.Effective_Date__c.addDays(-1);
            
            //Id opptwohundredplusId1 = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('50+').RecordTypeId;
            opp2.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('51+').RecordTypeId;
          insert opp2;
           opp2.RecordTypeId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;
          update opp2;

        //testOppsList.add(testOpp1);
        

        
        //insert test record for Benefit Request Form
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
      //  nbrf.Proposal_Request_Form__c = prf.id;
        nbrf.Account__c = testacct1.id;
        nbrf.Opportunity__c = opp.id;
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Renewal_Date__c = system.today();
        nbrf.Status__c='New';
        insert nbrf;
        
         AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Signed Quote';
        fileNetDoc.Benefit_Request_Form__c = nbrf.id;
        insert fileNetDoc;
        
         nbrf.Status__c='Sold';
         update nbrf;
        
         //Update Opportunity to Sold
                             
        Opportunity QueriedOpp = [Select Id,name from Opportunity where id=:opp.Id];
        QueriedOpp.StageName = 'Sold';
        //Update QueriedOpp;
        
         Test.stopTest();
          }     
        }
        static testmethod void testCreateImplementation(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom' limit 1];
        
        List <user> userlist= new List<User>();
        //List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
        List<Account_Team__c> AccountTeamMemberList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        
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
         insert userlist;
         try{

         test.StartTest();
                 
         Account acc = AIA_TestUtil.CreateAccount('TestAccount');
                
       /*AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'BeneFact Coder';
        atmRole.AccountId = acc.id;
        atmRole.UserId = u1.id;
       	AccountTeamMemberList.add(atmRole); 
        AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Ancillary Analyst';
        atm1.AccountId =acc.id;
        atm1.UserId = u2.id;
       	AccountTeamMemberList.add(atm1); 
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'NASCO Benefit Coder';
        atmRole2.AccountId = acc.id;
        atmRole2.UserId = u3.id;
       	AccountTeamMemberList.add(atmRole2);*/
             
        Account_Team__c atmRole2 =new Account_Team__c();
        atmRole2.UserId__c=u1.id;
        atmRole2.TeamMemberRole__c='BeneFact Coder';
        atmRole2.AccountId__c =acc.id;   
        AccountTeamMemberList.add(atmRole2);
      
                opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);
                //PRF__c prf =AIA_TestUtil.CreatePRF(opp.id);
                Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
                brf.Account__c = acc.id;
                brf.Opportunity__c = opp.id;
                brf.Contract_Count__c = 123;
                brf.Benefit_Effective_Date__c = system.today();
                brf.Renewal_Date__c = system.today();
                brf.Status__c='Sold';
                insert brf;
                Test.stopTest();
                AIA_TestUtil.createAIADocument(brf);
                //brf =AIA_TestUtil.updateBRF(prf.id,acc.id,brf.id);
                brf.Contract_Count__c = 123;
                brf.Benefit_Effective_Date__c = system.today();             
                brf.ARC_Approval_Status__c = 'Approved by Committee';
                brf.Escalated_to_Senior_Management__c = true;
                brf.Status__c = 'Sold';
                update brf;
                opp.recordTypeId=Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;
                opp.stageName='Sold';
                update opp;
                delete opp;
                   
                }
                
                catch(exception e){}
        }
}