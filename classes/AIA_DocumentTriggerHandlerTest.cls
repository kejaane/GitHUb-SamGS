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
/*****************************************************************************************************
*Date: 05/31/2016
*Developer: Spandhan Zangam 
*Purpose: AIA_Document trigger Test class
*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================
*06-16-2016    Spandhan                 Initial Development
*11/20/2017    Satya          T01       Added for Docusign/BA/BAC user stories
*06/08/2018    raj kiran      T02       Added code for role updates
*02/08/2019		Chaithra	 |T03|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================

*******************************************************************************************************/

@isTest
private class AIA_DocumentTriggerHandlerTest {
    static testMethod void CreateAIADocument() {
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        
        Id AdminPID = [select id from profile where Name = 'System Administrator'].Id;
        List<User> lstinsertuser=new List<User>();
        for(Integer i=0;i<7;i++)
        {
            User admin = new User();
            admin.FirstName = 'MrX';
            admin.LastName = 'LastMrx';
            admin.email = 'mrxzz@mytest.com';
            admin.alias = 'zzts';
            admin.communityNickname = 'MrXLastMrx'+i;
            admin.username = 'mrxzzt'+i+'@mytest.com';
            admin.EmailEncodingKey = 'ISO-8859-1';
            admin.LanguageLocaleKey = 'en_US';
            admin.LocaleSidKey = 'en_US';
            admin.TimeZoneSidKey = 'America/New_York';
            admin.ProfileId = AdminPID;
            lstinsertuser.add(admin);
        }        
        
        insert lstinsertuser;
        system.assertNotEquals(0, lstinsertuser.size());
        // T03 changes starts
        //List<AccountTeamMember> lstAcctTeamMbr=new List<AccountTeamMember>();
        /*for(Integer i=0;i<7;i++)
        {
            AccountTeamMember member=new AccountTeamMember();
            member.AccountAccessLevel ='Edit';
            member.AccountId =a.Id;
            if(i==0){
                member.TeamMemberRole ='AIA User'; //T02
            }else if(i==1){
                member.TeamMemberRole ='AIA User'; //T02
            }else if(i==2){
                member.TeamMemberRole ='Account Manager';
            }else if(i==3){
                member.TeamMemberRole ='QA Auditor';
            }else if(i==4){
                member.TeamMemberRole ='Billing Tech';
            }else if(i==5){
                member.TeamMemberRole ='Settlements Analyst';
            }else if(i==6){
                member.TeamMemberRole ='Implementation Manager';
            }
            member.UserId =lstinsertuser[i].Id;
            lstAcctTeamMbr.add(member);
        }*/
        
        List<Account_Team__c> lstAcctTeamMbr = new List<Account_Team__c>();
        for(Integer i=0;i<7;i++)
        {
          Account_Team__c member = new  Account_Team__c();
          member.AccountAccessLevel__c ='Edit';
            member.AccountId__c =a.Id;
            if(i==0){
                member.TeamMemberRole__c ='AIA User'; //T02
            }else if(i==1){
                member.TeamMemberRole__c ='AIA User'; //T02
            }else if(i==2){
                member.TeamMemberRole__c ='Account Manager';
            }else if(i==3){
                member.TeamMemberRole__c ='QA Auditor';
            }else if(i==4){
                member.TeamMemberRole__c ='Billing Tech';
            }else if(i==5){
                member.TeamMemberRole__c ='Settlements Analyst';
            }else if(i==6){
                member.TeamMemberRole__c ='Implementation Manager';
            }
            member.UserId__c =lstinsertuser[i].Id;
            lstAcctTeamMbr.add(member);
          
        }
        //T03 changes Ends
        insert lstAcctTeamMbr;
        system.assertNotEquals(0, lstAcctTeamMbr.size());
        //T03 starts
        /*List<AccountTeamMember> lstquery=[Select Id,TeamMemberRole from AccountTeamMember Where AccountId =: a.Id];//T03
        for(AccountTeamMember tesam: lstquery){
            System.debug('\n'+tesam.TeamMemberRole);
        }*/ //T03 ends
        List<Account_Team__c> lstquery=[Select Id,TeamMemberRole__c from Account_Team__c where AccountId__c =: a.Id ]; //T03
        for(Account_Team__c tesam: lstquery){
            System.debug('\n'+tesam.TeamMemberRole__c);
        }
        
         AIA_Document__c doc=new AIA_Document__c();
                doc.Account__c = a.Id;
                doc.Document_Type__c ='Production Id Card';
                insert doc;
         Attachment att=AIA_TestUtil.createAttachment(doc.Id);
         
         User u1 = AIA_TestUtil.AIA_createUser('test1');
        
        
        Group grp = new Group();
        grp.Name = 'AIA BAA';
        Insert grp;
        
        
        
        System.debug(lstAcctTeamMbr);
        // to run for specific user amnd profile
        User u = AIA_TestUtil.createTestUser();
        system.assertNotEquals(null, u);
        System.runAs(u) { 
            Test.StartTest();
            
                  
                doc.Document_Type__c ='Mock ID Card';
                update doc;
                
                doc.Document_Type__c ='Group Structure Document';
                update doc;
                
                //T01 changes
                GroupMember gMem = new GroupMember();
                gMem.groupId = grp.id;
                gMem.UserOrGroupId = u.id;
                insert gMem;
                
                doc.Document_Type__c ='Custom BAA';
                doc.Is_sent_for_BAA_Approval__c = false;
                update doc;
                //T01 changes ends
               
                
                
                
            Test.StopTest();
        }
    }
    
}