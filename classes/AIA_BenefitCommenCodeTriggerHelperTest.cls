/*****************************************************************************************************
*Date: 09-16-2016 
*Developer: Indira Das
*Purpose: test class for AIA benefit trigger handler
*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
*09-16-2016    Indira Das     Initial Development
* 09/11/2018    raj kiran jv    code changes for R1E1- record type update  R1E1
*==================================================================================

*******************************************************************************************************/


@isTest
public class AIA_BenefitCommenCodeTriggerHelperTest {
    
  @isTest static void testupdateAIADocAttachmentid() {
         Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         List <user> userlist= new List<User>();
        User user = new User(Alias = 'TAlias17', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com12');
         
         User user1 = new User(Alias = 'TAlias13', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com13');
         
       
         userlist.add(user1);
         
         
        insert userlist;
         
        User u = AIA_TestUtil.createTestUser();
        
        
        System.runAs(u) { 
            // Create Account
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
             List<Account_Team__c> AccountTeamMemberList=new List<Account_Team__c>();
         
             Account_Team__c atmRole2 = new Account_Team__c ();
            atmRole2.TeamMemberRole__c = 'Contract Tech';
            atmRole2.AccountId__c =a.id;
            atmRole2.UserId__c = user1.id;
            AccountTeamMemberList.add(atmRole2);
            
           
            
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
            OpportunityContactRole ocr= new OpportunityContactRole(OpportunityId=o.id, ContactId=c.id, Role='Broker', IsPrimary=true);
            insert ocr;
            test.startTest();
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
            
            insert nbrf;
            
            AIA_Plan__c plantest= AIA_TestUtil.CreateGSMPlan('Medical', 'Medical-1');
            AIA_Plan__c plantest2= AIA_TestUtil.CreateGSMPlan('Drug', 'Drug-1');
            
            List<AIA_Plan__c> planlist= new List<AIA_Plan__c>();
            planlist.add(plantest);
            planlist.add(plantest2);
            
            insert planlist;
            
            Proposed_Products__c pp= AIA_TestUtil.createBRFProposedProducts(nbrf.id, plantest.id, 'Medical'); //R1E1
            insert pp;
            
           AIA_Grouper__c gp=AIA_TestUtil.createGrouper(pp.Id);
           AIA_Benefits__c ben= AIA_TestUtil.createBenefit(gp.id);
            
            List<Limitations__c> llist= new List<Limitations__c>();
             Limitations__c c1= AIA_TestUtil.createBenefitComentCode(ben.id, true,'Comment');
             Limitations__c c2= AIA_TestUtil.createBenefitComentCode(ben.id, true,'TierLimit');
            Limitations__c c3= AIA_TestUtil.createBenefitComentCode(ben.id, true,'MaxRow');
            Limitations__c c4= AIA_TestUtil.createBenefitComentCode(ben.id, true,'Comment');
            Limitations__c c5= AIA_TestUtil.createBenefitComentCode(ben.id, true,'TierLimit');
            llist.add(c1);
            llist.add(c2);
            llist.add(c3);
            llist.add(c4);
            llist.add(c5);
            insert llist;
            
            List<Limitations__c> updateList = new List<Limitations__c>();
            c1.comment_codes__c='Updated comment codes';
            c1.MaxDuration__c = 2;
            c1.MaxDuration_Increment__c = '1';
            c1.MaxDuration_High__c = '5';
            c1.MaxDuration_Low__c = '0';
            c1.IsSelected__c=false;            
            //updateList.add(c1);
            update c1;
            
            c2.comment_codes__c='Updated comment codes';
            c2.MaxDuration__c = 6;
            c2.MaxDuration_Increment__c = '1';
            c2.MaxDuration_High__c = '5';
            c2.MaxDuration_Low__c = '0';
            c2.IsSelected__c=false;
            updateList.add(c2);
            
            update updateList;
            
            c4.comment_codes__c='Updated comment codes';
            c4.MaxValue__c = 2;
            c4.MaxValue_Increment__c = '1';
            c4.MaxValue_High__c = '5';
            c4.MaxValue_Low__c = '0';
            c4.IsSelected__c=false;            
            //updateList.add(c1);
            update c4;
            
            c5.comment_codes__c='Updated comment codes';
            c5.MaxValue__c  = 6;
            c5.MaxValue_Increment__c = '1';
            c5.MaxValue_High__c = '5';
            c5.MaxValue_Low__c = '0';
            c5.IsSelected__c=false;
            update c5;
            
            AIA_BenefitCommentCodeTRiggerHelper.isInRange2(true,2,'1','5','0');
            
            delete c5;
            
            test.stopTest(); 
        }
    }
}