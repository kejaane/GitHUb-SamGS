/*===========================================================================================================
 * Date         : 05/04/2017
 * Developer    : Goutham Rapolu
 * Purpose      : Test class for AIA_BD_GetBenefits_Controller
 *===========================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer     Tag   Description
 *===========================================================================================================
 * 2/7/2018   | Satya T     | T01  | Added as a part of US651. Moved logic from JS button controller
 06/08/2018    raj kiran      T02       Added code for role updates
* 01-18-2019 	Chaithra 		|T03| Created users for account team role as per US1702 and US1730
 *==========================================================================================================
 */
 
 @istest(seealldata=false)
    public class AIA_BD_GetBenefits_Controller_Test {
    
    @testSetup static void testdata() {
         	//Commenting as part of US210
        	/*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/

            Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            system.assertNOTEquals(acc,Null);
            List<user> userList = new list<user>();

            user u9 = AIA_TestUtil.AIA_createUser('alias9');
            userList.add(u9);
            user u10 = AIA_TestUtil.AIA_createUser('alias10');
            userList.add(u10);
            user u11 = AIA_TestUtil.AIA_createUser('alias11');
            userList.add(u11);
            user u12 = AIA_TestUtil.AIA_createUser('alias12');
            userList.add(u12);
            user u13 = AIA_TestUtil.AIA_createUser('alias13');
            userList.add(u13);
            user u14 = AIA_TestUtil.AIA_createUser('alias13');
            userList.add(u14);
        
            insert userList;       
            system.assertNOTEquals(userList.size(),Null);
            
            List<Account_Team__c> acctMbrList = new List<Account_Team__c>();
            
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor')); //T01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u13.id,'Contract Tech'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
            
            insert acctMbrList;
            system.assertNOTEquals(acctMbrList.size(),Null);

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
            //o.Workplan_Type__c = wpt.id;//Commenting as part of US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;

            test.starttest();
         
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            //brf.ARC_Approval_Status__c = 'Approved by Committee'; //Modified for Validation exception -6/6/17
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;

            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            aiapln.Plan_Id__c='PLAN-Test';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.QA_Complete__c = true;
            
            insert aiapln;
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
            pp.Has_Benefit_Details__c =false;
            pp.Network__c = 'National'; //Added for Validation of network__c exception -6/6/17
            insert pp;
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = acc.id;
            Imp.Account__c = Imp.Opportunity__r.AccountId;
            //Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            insert Imp;
            
            AIA_Benefit_Design__c bd = new AIA_Benefit_Design__c();
            bd.Implementation__c = Imp.id;
            bd.Account__c = acc.Id;
            bd.Benefit_Request_Form__c = brf.Id;
            insert bd;
            system.assertNOTEquals(bd,Null);
            
            
            list<AIA_Benefit_Design_Product__c> bdplst = new list<AIA_Benefit_Design_Product__c>();
            
            AIA_Benefit_Design_Product__c bdp= new AIA_Benefit_Design_Product__c();
            bdp.Benefit_Design__c=bd.id;
            bdp.BDP_validations_flag__c = false;
            bdp.Plan_Name__c=aiapln.id;
            bdp.Proposed_Products__c=pp.id;     
            bdp.Funding_Arrangement__c = 'ASO';//Modified from "Risk" -6/6/17
            bdp.has_benefit_details__c = false;
            bdp.Network__c= 'National';  //Added for Validation of network__c exception -6/6/17
            bdplst.add(bdp);
            
            AIA_Benefit_Design_Product__c bdp1= new AIA_Benefit_Design_Product__c();
            bdp1.Benefit_Design__c=bd.id;
            bdp1.BDP_validations_flag__c = true;
            bdp1.Plan_Name__c=aiapln.id;
            bdp1.Proposed_Products__c=pp.id;     
            bdp1.Funding_Arrangement__c = 'ASO';//Modified from "Risk" -6/6/17
            bdp1.has_benefit_details__c = false;
            bdp1.Network__c= 'National';  //Added for Validation of network__c exception -6/6/17
            bdplst.add(bdp1);
            
            
            
            insert bdplst;
            
            
            test.stopTest();
    }
    
    
    
      
        public static testmethod void TestAIA_BD_GetBenefits_Controller(){
           
            test.starttest();
            
            AIA_Benefit_Design_Product__c bdpObj =  new AIA_Benefit_Design_Product__c();
            AIA_Benefit_Design_Product__c bdp =  [select id,Benefit_Design__c,BDP_validations_flag__c,Plan_Name__c,Proposed_Products__c,Funding_Arrangement__c,has_benefit_details__c,Network__c from AIA_Benefit_Design_Product__c where BDP_validations_flag__c = false and Funding_Arrangement__c = 'ASO' ];
            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdp.id);
            System.currentPageReference().getParameters().put('idValue',bdpObj.id);                        

            ApexPages.StandardController  con2 = new ApexPages.StandardController(bdpObj);
            AIA_BD_GetBenefits_Controller ext = new AIA_BD_GetBenefits_Controller(con2);
           ext.bdpid = bdpObj.id;
           ext.bdp = bdpObj;
           ext.updateBDP();
           ext.RedirectToSumaryPage();
           
            test.stopTest();
        }
        
        //T01 changes start
        public static testmethod void TestAIA_BD_GetBenefits_Controller_updateBDP(){
           
            test.starttest();
            
            AIA_Benefit_Design_Product__c bdpObj =  new AIA_Benefit_Design_Product__c();
            AIA_Benefit_Design_Product__c bdp =  [select id,Benefit_Design__c,BDP_validations_flag__c,Plan_Name__c,Proposed_Products__c,Funding_Arrangement__c,has_benefit_details__c,Network__c from AIA_Benefit_Design_Product__c where BDP_validations_flag__c = true and Funding_Arrangement__c = 'ASO' ];
            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdp.id);
            System.currentPageReference().getParameters().put('idValue',bdpObj.id);                        

            ApexPages.StandardController  con2 = new ApexPages.StandardController(bdpObj);
            AIA_BD_GetBenefits_Controller ext = new AIA_BD_GetBenefits_Controller(con2);
           ext.bdpid = bdpObj.id;
           ext.bdp = bdpObj;
           ext.updateBDP();
           system.AssertEquals(bdpObj.BDP_validations_flag__c,false);
           system.AssertNotEquals(bdpObj.BDP_validations_flag__c,true);
           
            test.stopTest();
        }
          //T01 changes ends
               
        
       
    }