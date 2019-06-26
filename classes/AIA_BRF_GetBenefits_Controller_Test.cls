/*===========================================================================================================
 * Date         : 05/04/2017
 * Developer    : Goutham Rapolu
 * Purpose      : Test class for AIA_BRF_GetBenefits_Controller
 *===========================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         	Developer     Tag   	Description
 *===========================================================================================================
 *02/08/2019		Chaithra	 |T01|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
 *==========================================================================================================
 */
 
 @istest(seealldata=false)
    public class AIA_BRF_GetBenefits_Controller_Test {
        @testSetup
        public static void testData()
        {
            Test.startTest();
           User usr = [Select Id From User where firstname = 'spmss'];
      system.runAs(usr)
      {
         // Commenting as part of US210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/


            Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            acc.jurisdiction__c = 'MD';
            update acc;
			
          //Creating Account team members
        	List<user> userList = new list<user>();
        	user u1 = AIA_TestUtil.AIA_createUser('alias1');
        	userList.add(u1); 
        	user u2 = AIA_TestUtil.AIA_createUser('alias2');
        	userList.add(u2);
        	user u3 =AIA_TestUtil.AIA_createUser('alias3');
        	userList.add(u3);
        	insert userList;
        
        	//List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T01
        	List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T01
        	acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Executive')); 
        	acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Proposal Specialist')); 
        	acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Account Manager'));
        	insert acctMbrList;

            Opportunity o = new opportunity();
            o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');    
            o.AccountId = acc.id;
            o.name = 'Test Opportunity';
            o.SBU__c = 'Large';
            o.Market_Segment_New__c = '1000+';
            o.Division__c = 'Commercial Business';
            o.Business_Type__c = 'New';
            o.Effective_Date__c =  Date.newInstance(2014,10,1);
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
            //o.Workplan_Type__c = wpt.id;// Commenting as part of US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;

			Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Request_Type__c = 'Renew As-is';
            brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            brf.Account__c = acc.id;
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
            insert brf;


            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            aiapln.Plan_Id__c='PLAN-Test';
            aiapln.Product_Category__c = 'Medical';
          	aiapln.Product_Status__c = 'Active';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.QA_Complete__c = True;
            
            insert aiapln;
          Test.stopTest();
            
      }
        }
        public static testmethod void TestAIA_BRF_GetBenefits_Controller(){
           
			Benfit_Request_Form__c brf = [select id,name from Benfit_Request_Form__c Limit 1];
            AIA_Plan__c aiapln = [select id,name from AIA_Plan__c Limit 1];
            Proposed_Products__c pp = new Proposed_Products__c();           
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c = brf.id;
            pp.Funding_Arrangement__c = 'ASO';
            pp.Product_Category__c = 'Medical';
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
            pp.Has_Benefit_Details__c =false;
            insert pp;
            system.assertnotequals(null,pp.id);            
            Test.setCurrentPageReference(new PageReference('Page.AIA_ProposedProd_Summary')); 
            System.currentPageReference().getParameters().put('id',pp.id);
            System.currentPageReference().getParameters().put('idValue',pp.id);                        

            ApexPages.StandardController  con2 = new ApexPages.StandardController(pp);
            AIA_BRF_GetBenefits_Controller ext = new AIA_BRF_GetBenefits_Controller(con2);
            Test.startTest();
            ext.bdpid = pp.id;
            ext.bdp = pp;
		    ext.getIsClassic();
            ext.RedirectToSumaryPage();
            test.stopTest();
        }
        
        public static testmethod void TestAIA_BRF_GetBenefits_Controller1(){
           
			Benfit_Request_Form__c brf = [select id,name,ARC_Approval_Status__c from Benfit_Request_Form__c Limit 1];
            AIA_Plan__c aiapln = [select id,name,QA_Complete__c from AIA_Plan__c where QA_Complete__c =true Limit 1];
            aiapln.QA_Complete__c = True;
            update aiapln;
            Proposed_Products__c pp = new Proposed_Products__c();           
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c = brf.id;
            pp.Funding_Arrangement__c = 'ASO';
            pp.Product_Category__c = 'Medical';
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
            pp.Has_Benefit_Details__c =false;
            insert pp;
            system.assertnotequals(null,pp.id);            
            brf.ARC_Approval_Status__c = 'Approved by Committee';
            update brf;
            Test.setCurrentPageReference(new PageReference('Page.AIA_ProposedProd_Summary')); 
            System.currentPageReference().getParameters().put('id',pp.id);
            System.currentPageReference().getParameters().put('idValue',pp.id);                        

            ApexPages.StandardController  con2 = new ApexPages.StandardController(pp);
            AIA_BRF_GetBenefits_Controller ext = new AIA_BRF_GetBenefits_Controller(con2);
            Test.startTest();
            ext.RedirectToSumaryPage();
            test.stopTest();
        }
       }