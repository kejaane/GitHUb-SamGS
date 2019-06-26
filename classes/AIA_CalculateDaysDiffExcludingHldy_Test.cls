/*===================================================================================
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
*===================================================================================
* Date:         04/3/2017 
* Developer:    Sree Harsha
* Purpose:      Test class for AIA_CalculateDaysDiffExcludingHoliday
* 
*==================================================================================
* Update History
* Date          Developer               Description
*==================================================================================
* 04/3/2017     Sree Harsha             Initial Development
* 01-18-2019    Chaithra        |T01|   Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================
*/

@isTest
    private class AIA_CalculateDaysDiffExcludingHldy_Test{

    @testsetup static void CreateTestData()
        {
            Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
            User user = new User(Alias = 'TAlias17', Email='TestUserBRF@testorg.com',
                                 EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                                 LocaleSidKey='en_US', ProfileId = pro.Id,
                                 TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.coma12');
            insert user;
            
            Account a = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,a.id);
            a.BillingState ='VA';
            update a;
            //T01 Starts
            Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=user.id;
                 atmRole1.TeamMemberRole__c='Contract Tech';
                 atmRole1.AccountId__c =a.id;   
            insert atmRole1;
            
            /*AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Contract Tech';
            atmRole2.AccountId =a.id;
            atmRole2.UserId = user.id;
            insert atmRole2;*/
			//T01 Ends
            
            Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
            system.assertNotEquals(null,o.id);
            o.Business_Type__c = 'New';
            update o;
            
            Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = a.id;
           // nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            insert nbrf;
            system.debug('In CreateTestData - Before starttest- getAggregateQueries--'+Limits.getAggregateQueries());
            system.debug('In CreateTestData - Before starttest- getLimitAggregateQueries--'+Limits.getLimitAggregateQueries());
            Test.startTest();
            system.debug('In CreateTestData - After starttest- getAggregateQueries--'+Limits.getAggregateQueries());
            system.debug('In CreateTestData - After starttest- getLimitAggregateQueries--'+Limits.getLimitAggregateQueries());
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            imp.Account__c=a.id;
            imp.Benefit_Request_Form__c=nbrf.id;
            insert Imp;
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Implementation__c = Imp.id;
            aiaBD.Account__c=a.id;
            aiaBD.Benefit_Request_Form__c=nbrf.id;
            aiaBD.Ancillary_Tech_Approval_Start_Date__c = date.today();
            aiaBD.Ancillary_Tech_Response_Date__c = date.today()+3;
            aiaBD.Approver_Ancillary_Analyst__c = userInfo.getUserID();
            aiaBD.Approver_Contract_Tech__c= userInfo.getUserID();
            aiaBD.Approver_Benefit_Coder__c=userInfo.getUserID();
            aiaBD.AIA_Approver_MAST_Tech__c=userInfo.getUserID();
            aiaBD.Approver_Vision_Analyst__c=userInfo.getUserID();
            aiaBD.AIA_Approver_Benefit_Coder__c=userInfo.getUserID();
            aiaBD.AIA_Approver_Benefit_Tester__c=userInfo.getUserID();
            aiaBD.Approver_Pharmacy_Operations__c=userInfo.getUserID();
            aiaBd.AIA_Approver_Benefact_Coder__c=userInfo.getUserID();
            //insert aiaBD;
            
            AIA_Benefit_Design__c aiaBD2 = new AIA_Benefit_Design__c();
            aiaBD2.Implementation__c = Imp.id;
            aiaBD2.Account__c=a.id;
            aiaBD2.Benefit_Request_Form__c=nbrf.id;
            aiaBD2.Ancillary_Tech_Approval_Start_Date__c = date.today();
            aiaBD2.Ancillary_Tech_Response_Date__c = date.today()+3;
            
            AIA_Benefit_Design__c aiaBD3 = new AIA_Benefit_Design__c();
            aiaBD3.Implementation__c = Imp.id;
            aiaBD3.Account__c=a.id;
            aiaBD3.Benefit_Request_Form__c=nbrf.id;
            aiaBD3.Contract_Tech_Approval_Start_Date__c = date.today();
            aiaBD3.Contract_Tech_Response_Date__c = date.today();
            aiaBD3.Approver_Ancillary_Analyst__c = userInfo.getUserID();
            aiaBD3.Approver_Contract_Tech__c= userInfo.getUserID();
            aiaBD3.Approver_Benefit_Coder__c=userInfo.getUserID();
            aiaBD3.AIA_Approver_MAST_Tech__c=userInfo.getUserID();
            aiaBD.Approver_Vision_Analyst__c=userInfo.getUserID();
            aiaBD.AIA_Approver_Benefit_Coder__c=userInfo.getUserID();
            aiaBD.AIA_Approver_Benefit_Tester__c=userInfo.getUserID();
            aiaBD.Approver_Pharmacy_Operations__c=userInfo.getUserID();
            aiaBd.AIA_Approver_Benefact_Coder__c=userInfo.getUserID();
            
            AIA_Benefit_Design__c aiaBD4 = new AIA_Benefit_Design__c();
            aiaBD4.Implementation__c = Imp.id;
            aiaBD4.Account__c=a.id;
            aiaBD4.Benefit_Request_Form__c=nbrf.id;
            aiaBD4.NASCO_Benefit_Coder_Approval_Start_Date__c = date.today();
            aiaBD4.NASCO_Benefit_Coder_Response_Date__c = date.today()+2;
            
            List<AIA_Benefit_Design__c> bdList=new List<AIA_Benefit_Design__c>();
            bdList.add(aiaBD); 
            bdList.add(aiaBD2);
            bdList.add(aiaBD3);
            bdList.add(aiaBD4);
            insert bdList;
            
            AIA_Benefit_Design_Form__c bdf= AIA_TestUtil.createBenefitDesignFormForBD(bdList[0], 'Domestic_Partner',null);
            bdf.Stand_Alone_Disease_Management__c = 'No';
            bdf.Stand_Alone_Wellness__c = 'No';
            upsert bdf;
            
            
           
            
            AIA_Document__c aiadocBD=AIA_TestUtil.createAIADocument();
            aiadocBD.Benefit_Design__c=bdList[0].id;
            aiadocBD.Benefit_Design_Form__c=bdf.id;
            aiadocBD.Account__c=a.id;
            aiadocBD.Approval_Status__c='Pending';
            
            update aiadocBD; 
            
        }
        
             
        static testMethod void TestCalculateDaysDiffExcludingHoliday()
        {
            
            Test.startTest();
            system.debug('In TestCalculateDaysDiffExcludingHoliday--'+Limits.getAggregateQueries());
            system.debug('In TestCalculateDaysDiffExcludingHoliday - After starttest- getLimitAggregateQueries--'+Limits.getLimitAggregateQueries());
            AIA_Implementation__c implOne = [Select Id,Benefit_Design_Revision_Number_Technical__c from AIA_Implementation__c limit 1];
            system.assertEquals(1, implOne.Benefit_Design_Revision_Number_Technical__c);
          
            Holiday HL = new holiday();
            HL.Name = 'TestHoliday';
            HL.ActivityDate = system.today().addDays(2);
            //insert HL;
            
            AIA_Benefit_Design__c abd = [Select id, status__c,Approver_Ancillary_Analyst__c,Approver_Vision_Analyst__c,Approver_Pharmacy_Operations__c,AIA_Approver_Benefact_Coder__c,Approver_Contract_Tech__c,AIA_Approver_Benefit_Coder__c,Approver_Benefit_Coder__c,AIA_Approver_MAST_Tech__c,Ancillary_Tech_Approval_Start_Date__c,Ancillary_Tech_Response_Date__c,Ancillary_Tech_Response_Days__c,
            Contract_Tech_Approval_Start_Date__c,Contract_Tech_Response_Date__c,Contract_Tech_Response_Days__c,NASCO_Benefit_Coder_Approval_Start_Date__c,NASCO_Benefit_Coder_Response_Date__c,NASCO_Benefit_Coder_Response_Days__c,
            Benefact_Coder_Approval_Start_Date__c,Benefact_Coder_Response_Date__c,Benefact_Coder_Response_Days__c,MAST_Tech_Approval_Start_Date__c,MAST_Tech_Response_Date__c,MAST_Tech_Response_Days__c,
            Pharmacy_Operations_Approval_Start_Date__c,Pharmacy_Operations_Response_Days__c,Pharmacy_Operations_Response_Date__c,Vision_Analyst_Approval_Start_Date__c,Vision_Analyst_Response_Days__c,Vision_Analyst_Response_Date__c,AIA_Benefit_Coder_Approval_Start_Date__c,
            AIA_Benefit_Coder_Response_Days__c,AIA_Benefit_Coder_Response_Date__c,AIA_Approver_Benefit_Tester__c,AIA_Benefit_Tester_Approval_Start_Date__c,AIA_Benefit_Tester_Response_Days__c,AIA_Benefit_Tester_Response_Date__c                             
            from AIA_Benefit_Design__c limit 1];
            abd.status__c = 'In Review';
            abd.Vision_Analyst_Response_Date__c = system.today().adddays(3);
            abd.Ancillary_Tech_Approval_Start_Date__c = system.today();
            abd.Ancillary_Tech_Response_Date__c = system.today().adddays(5);
            abd.Contract_Tech_Approval_Start_Date__c = system.today();
            abd.Contract_Tech_Response_Date__c = system.today().adddays(2);
            abd.Vision_Analyst_Approval_Start_Date__c = system.today();
            abd.NASCO_Benefit_Coder_Approval_Start_Date__c=system.today();
            abd.NASCO_Benefit_Coder_Response_Date__c = system.today().adddays(3);
            abd.Benefact_Coder_Approval_Start_Date__c = system.today();
            abd.Benefact_Coder_Response_Date__c = system.today().adddays(4);
            abd.MAST_Tech_Approval_Start_Date__c = system.today();
            abd.MAST_Tech_Response_Date__c = system.today().adddays(1);
            abd.MAST_Tech_Response_Days__c = 'NA';
            abd.Pharmacy_Operations_Response_Date__c =system.today().adddays(3);
            abd.Pharmacy_Operations_Approval_Start_Date__c=system.today();
            abd.AIA_Benefit_Tester_Response_Date__c=system.today().adddays(3);
            abd.AIA_Benefit_Tester_Approval_Start_Date__c =system.today();
            abd.AIA_Benefit_Coder_Response_Date__c=system.today().adddays(1);
            abd.AIA_Benefit_Coder_Approval_Start_Date__c=system.today();
            update abd;
            
            list<AIA_Benefit_Design__c> abdList = new list<AIA_Benefit_Design__c>();
            
            abdList = [Select id,Revision_number__c,status__c,Approver_Ancillary_Analyst__c,Approver_Contract_Tech__c,Approver_Benefit_Coder__c,AIA_Approver_Benefact_Coder__c,AIA_Approver_MAST_Tech__c,AIA_Approver_Benefit_Coder__c,AIA_Approver_Benefit_Tester__c,Approver_Pharmacy_Operations__c,
                       Ancillary_Tech_Approval_Start_Date__c,Ancillary_Tech_Response_Date__c,Ancillary_Tech_Response_Days__c ,
            Contract_Tech_Approval_Start_Date__c,Contract_Tech_Response_Date__c,Contract_Tech_Response_Days__c,NASCO_Benefit_Coder_Approval_Start_Date__c,NASCO_Benefit_Coder_Response_Date__c,NASCO_Benefit_Coder_Response_Days__c,Benefact_Coder_Approval_Start_Date__c,
            Benefact_Coder_Response_Date__c,Approver_Vision_Analyst__c,Benefact_Coder_Response_Days__c,MAST_Tech_Approval_Start_Date__c,MAST_Tech_Response_Date__c,MAST_Tech_Response_Days__c,
            Pharmacy_Operations_Approval_Start_Date__c,Pharmacy_Operations_Response_Days__c,Pharmacy_Operations_Response_Date__c,Vision_Analyst_Approval_Start_Date__c,Vision_Analyst_Response_Days__c,Vision_Analyst_Response_Date__c,AIA_Benefit_Coder_Approval_Start_Date__c,
            AIA_Benefit_Coder_Response_Days__c,AIA_Benefit_Coder_Response_Date__c,AIA_Benefit_Tester_Approval_Start_Date__c,AIA_Benefit_Tester_Response_Days__c,AIA_Benefit_Tester_Response_Date__c                             
            
            from AIA_Benefit_Design__c  ];
            //system.assertEquals('SF - 1', abdTEST.Revision_number__c);
            //system.debug('');
           
            //abdList.add(abd);
            //abdList.add(abdTEST);
            //set<id> 
          AIA_CalculateDaysDiffExcludingHoliday.calApprovalResponseDay(abdList);
           //HL.ActivityDate = THIS_YEAR; 
           // List<Holiday> holidays = [Select Id From Holiday];
            //system.assert(holidays.size() == 0);

            
            Test.stopTest();
        }
        
        static testMethod void TestCalculateDaysDiffExcludingHoliday2()
        {
            
            Holiday HL = new holiday();
            HL.Name = 'TestHoliday';
            HL.ActivityDate = system.today().addDays(2);
            insert HL;
            Date startDate =system.today().addDays(2);
            Date endDate =system.today().addDays(2);
            
            AIA_CalculateDaysDiffExcludingHoliday.CalculateWorkingDays(startDate,endDate);
            startDate = date.newInstance(2017,4,22);
            endDate = startDate;
            AIA_CalculateDaysDiffExcludingHoliday.CalculateWorkingDays(startDate,endDate);
        }
    }