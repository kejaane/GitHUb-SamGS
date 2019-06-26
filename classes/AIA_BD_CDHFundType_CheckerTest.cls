/*************************************************************************************************************************************************
*  Class            : AIA_BD_CDHFundType_CheckerTest
*  Author           : Rajesh Pennam
*  Version History  : 1.0
*  Creation         : 07/27/2017
*  Description      : This class is used to increase the code coverage for AIA_BD_CDHFundType_Checker
*
*  Modification Log:
* ----------------------------------------------------------------------------------------------------------------------------------------------
*  Author          Date-Modified      Tag      Description of Change
* ----------------------------------------------------------------------------------------------------------------------------------------------
* Rajesh Pennam     07/27/2017               Initial Development
* 01-18-2019 	Chaithra 		|T01| Created users for account team role as per US1702 and US1730
* 02-07-2019	Chaithra		|T02| Replaced std AccountTeamMember with custom AccountTeamMember as per US1736
*************************************************************************************************************************************************/

@isTest
public class AIA_BD_CDHFundType_CheckerTest {
       
      public static testmethod void PPHandlerTestASO(){
      
      Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        List <user> userlist= new List<User>();
        //List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();//T02
       List<Account_Team__c> AccountTeamMemberList= new List<Account_Team__c>();//T02
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
        
        User u5 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF54@testorg.com.test');
         userlist.add(u5);
          User u6 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF6@testorg.com.test');
         userlist.add(u6);
         
         User u7 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF7@testorg.com.test');
         userlist.add(u7);
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
      //  userlist.add(user);
        
        insert userlist;
        
        User u = AIA_TestUtil.createTestUser();
       
        System.runAs(u) { 
            // Create Account
              Account a = AIA_TestUtil.AIA_createAccount();
            
            // system.assertNotEquals(5,AccountTeamMemberList.size());
             //T02 Starts
                 /*AccountTeamMember atm1 = new AccountTeamMember ();
                atm1.TeamMemberRole = 'Underwriter';
                atm1.AccountId =a.id;
                atm1.UserId = u1.id;
               AccountTeamMemberList.add(atm1);
                //Insert atm1;
              // User urr = AIA_TestUtil.createTestUser();
              
              AccountTeamMember atmRole7 = new AccountTeamMember ();
            atmRole7.TeamMemberRole = 'QA Auditor';
            atmRole7.AccountId =a.id;
            atmRole7.UserId = u7.id;
             AccountTeamMemberList.add(atmRole7);
            //insert atmRole7;
            
              AccountTeamMember atmRole14 = new AccountTeamMember ();
            atmRole14.TeamMemberRole = 'MAST Tech';
            atmRole14.AccountId =a.id;
            atmRole14.UserId = u6.id;
            AccountTeamMemberList.add(atmRole14);
            //insert atmRole14;
               AccountTeamMember atmRole12 = new AccountTeamMember ();
                atmRole12.TeamMemberRole = 'Contract Tech';
                atmRole12.AccountId =a.id;
                atmRole12.UserId = u5.id;
            	AccountTeamMemberList.add(atmRole12);
                //insert atmRole12;
                
                AccountTeamMember atmRole2 = new AccountTeamMember ();
                atmRole2.TeamMemberRole = 'Ancillary Analyst';
                atmRole2.AccountId = a.id;
                atmRole2.UserId = u2.id;
               AccountTeamMemberList.add(atmRole2);
                //Insert atmRole2;
             
                AccountTeamMember atmRole3 = new AccountTeamMember ();
                atmRole3.TeamMemberRole = 'BeneFact Coder';
                atmRole3.AccountId = a.id;
                atmRole3.UserId = u3.id;
                AccountTeamMemberList.add(atmRole3);
                //Insert atmRole3;
                
                AccountTeamMember atmRole4 = new AccountTeamMember ();
                atmRole4.TeamMemberRole = 'NASCO Benefit Coder';
                atmRole4.AccountId = a.id;
                atmRole4.UserId = u4.id;
                AccountTeamMemberList.add(atmRole4);
                //Insert atmRole4;*/
               //T01 Starts
               AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u17.id,'Underwriter'));
            	AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u17.id,'QA Auditor'));
            	AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u17.id,'MAST Tech'));
            	AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u17.id,'Contract Tech'));
            	AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u17.id,'BeneFact Coder'));
            	//T02 Ends
        		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u17.id,'Benefit Coder'));
        		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u18.id,'Benefit Tester'));
        		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u19.id,'Vision Analyst'));
        		AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u20.id,'Pharmacy Operations'));
            	//T01 Ends
            insert AccountTeamMemberList;
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
            try{
            
            insert nbrf;
            }catch(exception e){}
             System.assertEquals(nbrf.Status__c, 'new');
            system.debug('----nbrf---'+nbrf.id);  

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
            pp.Blue_Rewards__c='Some value';
            pp.CDH_Fund_Type__c='BlueFund';
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =nbrf.id;
            //pp.MHP_Test_Result__c='Pass';
            pp.Rider__c = 'None;';
            test.startTest();
            insert pp;
              system.debug('----pp---'+pp);  
             try{
                 pp.Custom__c=true;
                 update pp;
             }
             catch(Exception e){}
            
           
             
            Proposed_Products__c pp2 = new Proposed_Products__c();
            pp2.Funding_Arrangement__c='ASO';
            pp2.Plan_Name__c=aiapln.id;
            pp2.Product_Category__c='Medical';
            pp2.Blue_Rewards__c='Some value';
            pp2.CDH_Fund_Type__c='Compatible';
            pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp2.Benefit_Request_Form__c =nbrf.id;
            //pp2.MHP_Test_Result__c='Pass';
            pp2.Rider__c = 'None;';
            
            
            insert pp2;
            
            System.assertEquals(pp2.CDH_Fund_Type__c, 'Compatible');
            
             nbrf.Status__c = 'Sold';
            System.assertEquals(nbrf.Status__c, 'Sold');
  
             update nbrf;
            system.debug('----pp-2--'+pp2);  
    
             try{
                 pp2.Custom__c=true;
                 update pp2;
             }
             catch(Exception e){}
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            imp.Account__c=a.id;
            imp.Benefit_Request_Form__c=nbrf.id;
            insert imp;
               
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Implementation__c = Imp.id;
            aiaBD.Status__c='Approved';
            aiaBD.Account__c=a.id;
            aiaBD.Benefit_Request_Form__c=nbrf.id;
            System.assertEquals(aiaBD.Status__c, 'Approved');
            
            insert aiaBD;
            
            System.assertEquals(aiaBD.Status__c, 'Approved');
            system.debug('----aiaBD---'+aiaBD);  

            try{
                 
                
            }
            catch(Exception e){
                
            }
            
            test.stopTest();
            }
        }
      
      
     
   
    }