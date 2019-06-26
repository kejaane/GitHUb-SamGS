/*===================================================================================
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
*===================================================================================
* Date:         07/26/2017 
* Developer:    Satya
* Purpose:      Test class for AIA_ApprovalResponseTriggerHelper

* 
*==================================================================================
* Update History
* Date          Developer               Description
*==================================================================================
* 07/26/2017     Satya              Initial Development
* 05/18/2018     Sajitha Y   |T01|  Added test methods to cover hasSkipBRFVRs_CustPerm conditions 
                                    to increase coverage
* 02/05/2019	Chaithra	 |T02|	Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================
*/


@istest
public class AIA_ApprovalResponseTriggerHelper_Test2 {
   
    @testSetup
    public static void testData(){
      //Commenting as part of US210
      /*
      AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
      insert wpt;*/
	Test.startTest();
   Account acc = AIA_TestUtil.CreateAccount('TestAccount');

  Opportunity o = new opportunity();
      o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
      o.AccountId = acc.id;
      o.name = 'Test Opportunity';
      o.SBU__c = 'Large';
      o.Market_Segment_New__c = '1000+';
      o.Division__c = 'Commercial Business';
      o.Business_Type__c = 'New';
      o.Effective_Date__c = Date.newInstance(2014, 10, 1);
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

    Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
       
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Request_Type__c = 'Renewal';
        brf.Benefit_Period__c = 'Calendar';
        brf.Control_Plan__c = '580';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Grandfathered'; 
        brf.Identity_Protection__c = 'No';
        brf.Broker_Commission__c = 3.5;
        brf.Contract_Count__c = 5;
        brf.Formulary__c = '1';
        brf.Maintenance_Choice__c = 'Mandatory';
        insert brf;
        
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
      aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
      aiapln.Jurisdiction__c = 'MD';
  insert aiapln;
  //Test.starttest();
  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'ASO';
      pp.Product_Category__c = 'Drug';
      pp.Product_Line__c = 'PPO';
      pp.Plan_Name__c = aiapln.id;
      pp.Product_Name__c = 'BlueChoice Advantage';
      pp.CDH__c = 'Yes';
      pp.CDH_Fund_Type__c = 'BlueFund';
      pp.CDH_Type__c = 'HSA';
      pp.Deductible__c = 'Stacked';
      pp.Grandfathered_Status__c = 'Grandfathered';
      pp.Integrated_Non_Integrated__c = 'Yes';
      pp.Grandfathered_PPACA_Status__c = 'No';
      pp.Blue_Rewards__c = 'No';
      pp.Out_of_Pocket_Max__c = 'Stacked';
      pp.Has_Benefit_Details__c = True;
      pp.Network__c = 'National';
      pp.Exclusive_Specialty_Provider_Network__c = 'Yes';   
      pp.ExtraCare_Health_Care_Card__c = 'Yes';   
      pp.Maintenance_Choice__c = 'None';   
      pp.OralChemoMandateApply__c = 'No';   
      pp.Integrated_Deductible_Integrator__c = 'No';
      pp.Integrated_OOP_Integration__c = 'Yes';
      pp.Rider__c = 'None';
      insert pp;
  	Test.stopTest();

    }

/*public Static TestMethod void TestAIA_ApprovalResponseTriggerHelper() {
            Benfit_Request_Form__c brf =[SELECT Id FROM Benfit_Request_Form__c ];

      
      List<Approval_Response__c> LsApproval = new List<Approval_Response__c>();
      
      Approval_Response__c AR = new Approval_Response__c();
      AR.Benefit_Request_Form__c=brf.id;
      AR.Business_Area__c='AIA MAST';
      AR.Response__c='Accept';
      LsApproval.add(AR);
      
      Approval_Response__c AR1 = new Approval_Response__c();
      AR1.Benefit_Request_Form__c=brf.id;
      AR1.Business_Area__c='AIA BeneFACT Coding';
      AR1.Response__c='Accept';
      LsApproval.add(AR1);
      
      Test.startTest();
      insert LsApproval;
      Test.stopTest();
     // AIA_ApprovalResponseTriggerHelper.validateAccountRole(LsApproval);

    }*/
    
 /*public Static TestMethod void TestAIA_ApprovalResponseTriggerHelper1() {
     
     Benfit_Request_Form__c brf =[SELECT Id,Account__c FROM Benfit_Request_Form__c ];
     List<User> userList = new List<User>();
     Account acc = [SELECT ID FROM Account LIMIT 1 ];
     Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        userList.add(u);     
        User u1 = new User(Alias = 'T01', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF01@testorg.com.test');
         userList.add(u1);          
        User u2 = new User(Alias = 'T02', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF02@testorg.com.test');
         userList.add(u2); 
     User u3 = new User(Alias = 'T03', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF03@testorg.com.test');
         userList.add(u3); 
     
     User u4 = new User(Alias = 'T04', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF04@testorg.com.test');
         userList.add(u4); 
        insert userList;
    
     List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'BeneFact Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'MAST Tech'));   
        
            insert acctMbrList;

            Test.startTest();
     System.runAs(u){
   PermissionSet ps = new PermissionSet();
    ps.Name = 'Test';
    ps.Label = 'Test';
    insert ps;
    SetupEntityAccess sea = new SetupEntityAccess();
    sea.ParentId = ps.Id;
    sea.SetupEntityId = [select Id from CustomPermission where DeveloperName = 'AIA_Ignore_BRF_Validation_Rules'][0].Id;
    insert sea;
    PermissionSetAssignment psa = new PermissionSetAssignment();
    psa.AssigneeId = u.id;
    psa.PermissionSetId = ps.Id;
    insert psa;
    
         
    
        List<Approval_Response__c> LsApproval = new List<Approval_Response__c>();
      
      Approval_Response__c AR = new Approval_Response__c();
      AR.Benefit_Request_Form__c = brf.Id;
      AR.Business_Area__c='AIA MAST';
      AR.Response__c='Pending';
      LsApproval.add(AR);
      
      Approval_Response__c AR1 = new Approval_Response__c();
      AR1.Benefit_Request_Form__c=brf.id;
      AR1.Business_Area__c='AIA BeneFACT Coding';
      AR1.Response__c='Pending';
      LsApproval.add(AR1);
     
      
      insert LsApproval;         
  }
      Test.stopTest();
 }*/
   /* public Static TestMethod void TestAIA_ApprovalResponseTriggerHelper2(){
        Benfit_Request_Form__c brf =[SELECT Id,Account__c FROM Benfit_Request_Form__c ];
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
     User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        insert u;
        List<AccountTeamMember> teamList = [select UserId,AccountId,TeamMemberRole 
                                            from AccountTeamMember 
                                            WHERE AccountId=:brf.Account__c ];
        delete teamList;
        Test.startTest(); 
         List<Approval_Response__c> LsApproval = new List<Approval_Response__c>();
      
      Approval_Response__c AR = new Approval_Response__c();
      AR.Benefit_Request_Form__c = brf.Id;
      AR.Business_Area__c='AIA MAST';
      AR.Response__c='Pending';
         //AR.Comments__c='Rejected';
      LsApproval.add(AR);
      
      Approval_Response__c AR1 = new Approval_Response__c();
      AR1.Benefit_Request_Form__c=brf.id;
      AR1.Business_Area__c='AIA BeneFACT Coding';
      AR1.Response__c='Pending';
        //AR1.Comments__c='Rejected';
      LsApproval.add(AR1);
       
        System.runAs(u){
      insert LsApproval;
        }
        Test.stopTest();
    }*/
  public Static TestMethod void TestAIA_ApprovalResponseTriggerHelper3() {
     
     Benfit_Request_Form__c brf =[SELECT Id,Account__c FROM Benfit_Request_Form__c ];
     List<User> userList = new List<User>();
     Account acc = [SELECT ID FROM Account LIMIT 1 ];
     Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       //Profile pro1 = [SELECT Id FROM Profile WHERE Name ='AIA RUL Custom'];
      
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        userList.add(u);     
        User u1 = new User(Alias = 'T01', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF01@testorg.com.test');
         userList.add(u1);          
        User u2 = new User(Alias = 'T02', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF02@testorg.com.test');
         userList.add(u2); 
     User u3 = new User(Alias = 'T03', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF03@testorg.com.test');
         userList.add(u3); 
     
     User u4 = new User(Alias = 'T04', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF04@testorg.com.test');
         userList.add(u4); 
        insert userList;     
     
     //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
     List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'MAST Tech'));   
        
         insert acctMbrList;

           Test.startTest();
        System.runAs(u){ 
            
        List<Approval_Response__c> LsApproval = new List<Approval_Response__c>();
      
      Approval_Response__c AR = new Approval_Response__c();
      AR.Benefit_Request_Form__c = brf.Id;
      AR.Business_Area__c='AIA MAST';
      AR.Response__c='Pending';
      LsApproval.add(AR);
      
      Approval_Response__c AR1 = new Approval_Response__c();
      AR1.Benefit_Request_Form__c=brf.id;
      AR1.Business_Area__c='AIA BeneFACT Coding';
      AR1.Response__c='Pending';
      LsApproval.add(AR1);     
  
      insert LsApproval;         
  }
      Test.stopTest();
 } 
  public Static TestMethod void TestAIA_ApprovalResponseTriggerHelper4() {
     
     Benfit_Request_Form__c brf =[SELECT Id,Account__c FROM Benfit_Request_Form__c ];
     List<User> userList = new List<User>();
     Account acc = [SELECT ID FROM Account LIMIT 1 ];
     Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       //Profile pro1 = [SELECT Id FROM Profile WHERE Name ='AIA RUL Custom'];
       
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        userList.add(u);     
        User u1 = new User(Alias = 'T01', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF01@testorg.com.test');
         userList.add(u1);          
        User u2 = new User(Alias = 'T02', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF02@testorg.com.test');
         userList.add(u2); 
     User u3 = new User(Alias = 'T03', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF03@testorg.com.test');
         userList.add(u3); 
     
     User u4 = new User(Alias = 'T04', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF04@testorg.com.test');
         userList.add(u4); 
        insert userList; 
      //T02 starts
     /*List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
         acctMbrList =[select id from AccountTeamMember ];
        delete acctMbrList;*/
      List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
      acctMbrList=[select id from Account_Team__c];
      delete acctMbrList;
	//T02 Ends
           Test.startTest();
        
      system.runAs(u)  {   
        List<Approval_Response__c> LsApproval = new List<Approval_Response__c>();
      
      Approval_Response__c AR = new Approval_Response__c();
      AR.Benefit_Request_Form__c = brf.Id;
      AR.Business_Area__c='AIA MAST';
      AR.Response__c='Pending';
      LsApproval.add(AR);
      
     Approval_Response__c AR1 = new Approval_Response__c();
      AR1.Benefit_Request_Form__c=brf.id;
      AR1.Business_Area__c='AIA BeneFACT Coding';
      AR1.Response__c='Pending';
      LsApproval.add(AR1);    
    
      insert LsApproval;         
      }
      Test.stopTest();
      
 } 
    
    public Static TestMethod void TestAIA_ApprovalResponseTriggerHelper5() {
     
     Benfit_Request_Form__c brf =[SELECT Id,Account__c FROM Benfit_Request_Form__c ];
     List<User> userList = new List<User>();
     Account acc = [SELECT ID FROM Account LIMIT 1 ];
     Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       //Profile pro1 = [SELECT Id FROM Profile WHERE Name ='AIA RUL Custom'];
      
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        userList.add(u);     
        User u1 = new User(Alias = 'T01', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF01@testorg.com.test');
         userList.add(u1);          
        User u2 = new User(Alias = 'T02', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF02@testorg.com.test');
         userList.add(u2); 
     User u3 = new User(Alias = 'T03', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF03@testorg.com.test');
         userList.add(u3); 
     
     User u4 = new User(Alias = 'T04', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF04@testorg.com.test');
         userList.add(u4); 
        insert userList;    
     AIA_ApprovalResponseTriggerHelper.hasSkipBRFVRs_CustPerm = false;
     //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
     List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
       //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'MAST Tech'));   
        
         insert acctMbrList;

           Test.startTest();
        System.runAs(u){ 
            
        List<Approval_Response__c> LsApproval = new List<Approval_Response__c>();
      
      Approval_Response__c AR = new Approval_Response__c();
      AR.Benefit_Request_Form__c = brf.Id;
      AR.Business_Area__c='AIA MAST';
      AR.Response__c='Pending';
      LsApproval.add(AR);
      
      Approval_Response__c AR1 = new Approval_Response__c();
      AR1.Benefit_Request_Form__c=brf.id;
      AR1.Business_Area__c='AIA BeneFACT Coding';
      AR1.Response__c='Pending';
      LsApproval.add(AR1);     
            try{
      insert LsApproval;
            }
            catch(exception e)
            {}
  }
      Test.stopTest();
 } 
  //T01 - Start
  public Static TestMethod void TestAIA_ApprovalResponseTriggerHelper6() {
     
     Benfit_Request_Form__c brf =[SELECT Id,Account__c FROM Benfit_Request_Form__c ];
     List<User> userList = new List<User>();
     Account acc = [SELECT ID FROM Account LIMIT 1 ];
     Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       //Profile pro1 = [SELECT Id FROM Profile WHERE Name ='AIA RUL Custom'];
       
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        userList.add(u);     
        User u1 = new User(Alias = 'T01', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF01@testorg.com.test');
         userList.add(u1);          
        User u2 = new User(Alias = 'T02', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF02@testorg.com.test');
         userList.add(u2); 
     User u3 = new User(Alias = 'T03', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF03@testorg.com.test');
         userList.add(u3); 
     
     User u4 = new User(Alias = 'T04', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF04@testorg.com.test');
         userList.add(u4); 
        insert userList; 
       AIA_ApprovalResponseTriggerHelper.hasSkipBRFVRs_CustPerm = false;
     //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();T02
     List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
         acctMbrList =[select id from Account_Team__c ];//T02 [select id from AccountTeamMember ];
        delete acctMbrList;
     
           Test.startTest();
        
      system.runAs(u)  {    
        List<Approval_Response__c> LsApproval = new List<Approval_Response__c>();
      
      Approval_Response__c AR = new Approval_Response__c();
      AR.Benefit_Request_Form__c = brf.Id;
      AR.Business_Area__c='AIA MAST';
      AR.Response__c='Pending';
      LsApproval.add(AR);
      
     Approval_Response__c AR1 = new Approval_Response__c();
      AR1.Benefit_Request_Form__c=brf.id;
      AR1.Business_Area__c='AIA BeneFACT Coding';
      AR1.Response__c='Pending';
      LsApproval.add(AR1);    
      try{
          insert LsApproval;  
      }catch(Exception e){}
      
      }
      Test.stopTest();
 } 
   public Static TestMethod void TestAIA_ApprovalResponseTriggerHelper7() {
     
     Benfit_Request_Form__c brf =[SELECT Id,Account__c FROM Benfit_Request_Form__c ];
     List<User> userList = new List<User>();
     Account acc = [SELECT ID FROM Account LIMIT 1 ];
     Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
       //Profile pro1 = [SELECT Id FROM Profile WHERE Name ='AIA RUL Custom'];
      
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        userList.add(u);     
        User u1 = new User(Alias = 'T01', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF01@testorg.com.test');
         userList.add(u1);          
        User u2 = new User(Alias = 'T02', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF02@testorg.com.test');
         userList.add(u2); 
     User u3 = new User(Alias = 'T03', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF03@testorg.com.test');
         userList.add(u3); 
     
     User u4 = new User(Alias = 'T04', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF04@testorg.com.test');
         userList.add(u4); 
        insert userList;    
     AIA_ApprovalResponseTriggerHelper.hasSkipBRFVRs_CustPerm = false;
       
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
         acctMbrList =[select id from Account_Team__c ];//T02 [select id from AccountTeamMember ];
        delete acctMbrList;
     	//List<AccountTeamMember> acctMbrList1 = new List<AccountTeamMember>(); T02
     	List<Account_Team__c> acctMbrList1= new List<Account_Team__c>();
      	acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Account Executive')); 
      
         insert acctMbrList1;

           Test.startTest();
        System.runAs(u){ 
            
        List<Approval_Response__c> LsApproval = new List<Approval_Response__c>();
      
      Approval_Response__c AR = new Approval_Response__c();
      AR.Benefit_Request_Form__c = brf.Id;
      AR.Business_Area__c='AIA MAST';
      AR.Response__c='Pending';
      LsApproval.add(AR);
      
      Approval_Response__c AR1 = new Approval_Response__c();
      AR1.Benefit_Request_Form__c=brf.id;
      AR1.Business_Area__c='AIA BeneFACT Coding';
      AR1.Response__c='Pending';
      LsApproval.add(AR1);     
            try{
             insert LsApproval;
            }
            catch(exception e) {}
           
  }
      Test.stopTest();
 } 
//T01 - End    
  }