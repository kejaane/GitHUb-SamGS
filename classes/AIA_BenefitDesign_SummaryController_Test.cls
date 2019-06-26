/*===================================================================================
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
*===================================================================================
* Date:         11/18/2016
* Developer:    Sree Harsha
* Purpose:      Test class for AIA_BenefitDesign_SummaryController
* 
*==================================================================================
* Update History
* Date          Developer               	Description
*==================================================================================
* 11/18/2016    Sree Harsha         		Initial Development
* 06/08/2018    raj kiran      	|T01|       Added code for role updates
* 01-18-2019 	Chaithra 		|T02| 		Created users for account team role as per US1702 and US1730
*==================================================================================
*/

@istest
    public class AIA_BenefitDesign_SummaryController_Test {


        public static testmethod void TestAIA_benefitsummary_WithPlanStaticMedical1(){
            
            //Removed as part of US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/


          //  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
          Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        //Creating User Test Data 
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u10 = AIA_TestUtil.AIA_createUser('alias10');
        userList.add(u10); 
        user u11 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u11);
        user u12 = AIA_TestUtil.AIA_createUser('alias12');
        userList.add(u12); 
        user u13 = AIA_TestUtil.AIA_createUser('alias13');
        userList.add(u13);
            //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u13.id,'Implementation Manager'));
        //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
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
            //o.Workplan_Type__c = wpt.id;//Per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;


            test.starttest();
         AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
             Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
          //  brf.ARC_Approval_Status__c = 'Approved by Committee';
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
            aiapln.Has_Benefit_Summary__c=true;
            //  aiapln.BDF_Configuration_Last_Updated__c=date.today();
            //  aiapln.Configuration_Last_Updated__c=date.today();

            insert aiapln;
            /* StaticResource sr = [select id,body from StaticResource Where Name = 'BenSumJSONBRF_Test'];
            String jsonStr=sr.body.toString();
            AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
            AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
            mapper.saveToSetUp(apbroot,'BRF');

            StaticResource sr2 = [select id,body from StaticResource Where Name = 'BenSumJSONBDD_Test'];
            String jsonStr2=sr2.body.toString();
            AIA_PCS_BenefitSummary apbroot2=AIA_PCS_BenefitSummary.parse(jsonStr2);
            AIA_PlanTemplateMapper mapper2 = new AIA_PlanTemplateMapper();
            mapper2.saveToSetUp(apbroot2,'BDD');*/


            createPlanData(aiapln);

            Proposed_Products__c pp = new Proposed_Products__c();           
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
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
            pp.Rider__c='None';
            insert pp;

            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            ag.Group_Type__c = 'Cost Share Group';
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();

            ag.Proposed_Products__c = pp.id;
            insert ag;


            AIA_Benefits__c ab = new AIA_Benefits__c();           
            ab.Grouper__c = ag.id;
            ab.Benefit_Name__c = 'Family Out Of Pocket';
            ab.Benefit_Type__c = 'Benefit';
            ab.Type__c = 'Cost Share';           
            ab.Benefit_Record_Type__c = 'BRF';
            ab.Cost_Share_Low__c = '0';
            ab.Cost_Share_High__c = '100';
            ab.Cost_Share_Increment__c = '10';
            ab.Cost_Share_InvalidIncrements__c = '30';
            ab.Cost_Share_AdditionalIncrements__c = '33';
            ab.OON_Cost_Share_Low__c = '0';
            ab.OON_Cost_Share_High__c = '1000';
            ab.OON_Cost_Share_Increment__c = '100';
            ab.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab.OON_Cost_Share_InvalidIncrements__c = '300';
            ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab.Copay_Type_1_IsCovered__c = 'No';
            ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab.Copay_Type_1_AliasName__c='Test';
            ab.Copay_Type_2_AliasName__c='Test';
            ab.OON_Copay_Type_1_AliasName__c='Test';
            ab.OON_Copay_Type_2_AliasName__c='Test';
            ab.Copay_Min_Payment__c = '20';
            ab.Copay_Max_Payment__c = '30';
            ab.OON_Copay_Min_Payment__c = '10';
            ab.OON_Copay_Max_Payment__c = '10';
            insert ab;

            
            /*
                    PageReference pref = Page.AIA_ProposedProd_Summary;
                    Test.setCurrentPage(pref);
                    ApexPages.currentPage().getParameters().put('id',pp.id);
                    ApexPages.StandardController con = new ApexPages.StandardController(PP);
                    ApexPages.currentPage().getParameters().put('id',pp.id);
                    AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);

                   // ext.mainInit();
                    ext.dispatcher();
                    ext.saveAndCon();*/
            List<AIA_Plan_Benefits__c> plben= [select id,name from AIA_Plan_Benefits__c where Plan__c = :String.valueof(aiapln.Id).substring(0,15)] ;
            system.debug('plben size===='+plben.size());
            AIA_Benefit_Design__c bd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

            AIA_Benefit_Design_Product__c bdp= new AIA_Benefit_Design_Product__c();
            bdp.Benefit_Design__c=bd.id;
          //  bdp.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Product__c', rtype);
            bdp.Plan_Name__c=aiapln.id;
            bdp.Proposed_Products__c=pp.id;     
            bdp.Funding_Arrangement__c = 'Risk';
            bdp.Product_Category__c='Vision';
            insert bdp;
            
            
            
            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where Benefit_Design__c =:bd.Id limit 1];
            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdpObj.id);
            System.currentPageReference().getParameters().put('idValue',bdpObj.id);                        

            ApexPages.StandardController con2 = new ApexPages.StandardController(bdpObj);
            AIA_BenefitDesign_SummaryController ext2 = new AIA_BenefitDesign_SummaryController(con2);


           ext2.dispatcher();
           ext2.saveAndCon();

            test.stopTest();
        }
  public static testmethod void TestAIA_benefitsummary_WithPlanStaticMedical(){
            //Removed per US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/


            //Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            //modified by offshore
             Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
      	//Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
		
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
      		//acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor')); //T01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
      	//Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
            insert acctMbrList;
            //end
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
            //o.Workplan_Type__c = wpt.id;//Per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;

     Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
           // brf.ARC_Approval_Status__c = 'Approved by Committee';
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
            aiapln.Has_Benefit_Summary__c=true;
            //  aiapln.BDF_Configuration_Last_Updated__c=date.today();
            //  aiapln.Configuration_Last_Updated__c=date.today();

            insert aiapln;
            StaticResource sr = [select id,body from StaticResource Where Name = 'BenSumJSONBRF_Test'];
            String jsonStr=sr.body.toString();
            AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
            AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
            mapper.saveToSetUp(apbroot,'BRF');

            StaticResource sr2 = [select id,body from StaticResource Where Name = 'BenSumJSONBDD_Test'];
            String jsonStr2=sr2.body.toString();
            AIA_PCS_BenefitSummary apbroot2=AIA_PCS_BenefitSummary.parse(jsonStr2);
            AIA_PlanTemplateMapper mapper2 = new AIA_PlanTemplateMapper();
            mapper2.saveToSetUp(apbroot2,'BDD');


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
            pp.Rider__c='None';
            insert pp;


            test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
            PageReference pref = Page.AIA_ProposedProd_Summary;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);

            // ext.mainInit();
            ext.dispatcher();
            ext.saveAndCon();
            List<AIA_Plan_Benefits__c> plben= [select id,name from AIA_Plan_Benefits__c where Plan__c = :String.valueof(aiapln.Id).substring(0,15)] ;
            system.debug('plben size===='+plben.size());
            AIA_Benefit_Design__c bd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

            AIA_Benefit_Design_Product__c bdp= new AIA_Benefit_Design_Product__c();
            bdp.Benefit_Design__c=bd.id;
          //  bdp.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Product__c', rtype);
            bdp.Plan_Name__c=aiapln.id;
            bdp.Proposed_Products__c=pp.id;     
            bdp.Funding_Arrangement__c = 'Risk';
          bdp.Product_Category__c='Drug';
            insert bdp;
            
            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where Benefit_Design__c =:bd.Id limit 1];
            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdpObj.id);
            System.currentPageReference().getParameters().put('idValue',bdpObj.id);                        

            ApexPages.StandardController con2 = new ApexPages.StandardController(bdpObj);
            AIA_BenefitDesign_SummaryController ext2 = new AIA_BenefitDesign_SummaryController(con2);
            try{
                ext2.mainInit();
            }catch(Exception e){
            }

            //ext2.dispatcher();
            ext2.saveAndCon();

            test.stopTest();
        }
        
        public static testmethod void TestAIA_benefitsummary_WithPlanStaticMedicalcategrory(){
            //Removed per US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/


            //Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            //modified by offshore
             Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
            //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
            //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
            insert acctMbrList;
            //end
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
            //o.Workplan_Type__c = wpt.id;//Per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;

     Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
           // brf.ARC_Approval_Status__c = 'Approved by Committee';
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
            aiapln.Has_Benefit_Summary__c=true;
            //  aiapln.BDF_Configuration_Last_Updated__c=date.today();
            //  aiapln.Configuration_Last_Updated__c=date.today();

            insert aiapln;
            StaticResource sr = [select id,body from StaticResource Where Name = 'BenSumJSONBRF_Test'];
            String jsonStr=sr.body.toString();
            AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
            AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
            mapper.saveToSetUp(apbroot,'BRF');

            StaticResource sr2 = [select id,body from StaticResource Where Name = 'BenSumJSONBDD_Test'];
            String jsonStr2=sr2.body.toString();
            AIA_PCS_BenefitSummary apbroot2=AIA_PCS_BenefitSummary.parse(jsonStr2);
            AIA_PlanTemplateMapper mapper2 = new AIA_PlanTemplateMapper();
            mapper2.saveToSetUp(apbroot2,'BDD');


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
            pp.Rider__c='None';
            insert pp;


            test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
            PageReference pref = Page.AIA_ProposedProd_Summary;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);

            // ext.mainInit();
            ext.dispatcher();
            ext.saveAndCon();
            List<AIA_Plan_Benefits__c> plben= [select id,name from AIA_Plan_Benefits__c where Plan__c = :String.valueof(aiapln.Id).substring(0,15)] ;
            system.debug('plben size===='+plben.size());
            AIA_Benefit_Design__c bd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

            AIA_Benefit_Design_Product__c bdp= new AIA_Benefit_Design_Product__c();
            bdp.Benefit_Design__c=bd.id;
          //  bdp.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Product__c', rtype);
            bdp.Plan_Name__c=aiapln.id;
            bdp.Proposed_Products__c=pp.id;     
            bdp.Funding_Arrangement__c = 'Risk';
          bdp.Product_Category__c='Medical';
            insert bdp;
            
            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where Benefit_Design__c =:bd.Id limit 1];
            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdpObj.id);
            System.currentPageReference().getParameters().put('idValue',bdpObj.id);                        

            ApexPages.StandardController con2 = new ApexPages.StandardController(bdpObj);
            AIA_BenefitDesign_SummaryController ext2 = new AIA_BenefitDesign_SummaryController(con2);
            try{
                ext2.mainInit();
            }catch(Exception e){
            }

            //ext2.dispatcher();
            ext2.saveAndCon();

            test.stopTest();
        }
        
 public static testmethod void TestAIA_benefitsummary_WithPlanStaticMedicalError(){
     try{
            //Removed per US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/


            //Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            //modified by offshore
             Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
         		//Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
         List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom   
         //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
           //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
         	//Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
            insert acctMbrList;
            //end
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
            //o.Workplan_Type__c = wpt.id;//Per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;

     Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
           // brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;


            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            aiapln.Plan_Id__c='';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.Has_Benefit_Summary__c=true;
            //  aiapln.BDF_Configuration_Last_Updated__c=date.today();
            //  aiapln.Configuration_Last_Updated__c=date.today();

            insert aiapln;
            StaticResource sr = [select id,body from StaticResource Where Name = 'BenSumJSONBRF_Test'];
            String jsonStr=sr.body.toString();
            AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
            AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
            mapper.saveToSetUp(apbroot,'BRF');

            StaticResource sr2 = [select id,body from StaticResource Where Name = 'BenSumJSONBDD_Test'];
            String jsonStr2=sr2.body.toString();
            AIA_PCS_BenefitSummary apbroot2=AIA_PCS_BenefitSummary.parse(jsonStr2);
            AIA_PlanTemplateMapper mapper2 = new AIA_PlanTemplateMapper();
            mapper2.saveToSetUp(apbroot2,'BDD');


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
            pp.Rider__c='None';
            insert pp;


            test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
            PageReference pref = Page.AIA_ProposedProd_Summary;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);

            // ext.mainInit();
            ext.dispatcher();
            ext.saveAndCon();
            List<AIA_Plan_Benefits__c> plben= [select id,name from AIA_Plan_Benefits__c where Plan__c = :String.valueof(aiapln.Id).substring(0,15)] ;
            system.debug('plben size===='+plben.size());
            AIA_Benefit_Design__c bd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

            AIA_Benefit_Design_Product__c bdp= new AIA_Benefit_Design_Product__c();
            bdp.Benefit_Design__c=bd.id;
          //  bdp.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Product__c', rtype);
             bdp.Plan_Name__c=aiapln.id;
            bdp.Proposed_Products__c=pp.id;     
            bdp.Funding_Arrangement__c = 'Risk';
            insert bdp;
            
            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where Benefit_Design__c =:bd.Id limit 1];
            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdp.id);
            System.currentPageReference().getParameters().put('idValue',bdp.id);                        

            ApexPages.StandardController con2 = new ApexPages.StandardController(bdp);
            AIA_BenefitDesign_SummaryController ext2 = new AIA_BenefitDesign_SummaryController(con2);
            try{
                ext2.mainInit();
            }catch(Exception e){
            }

            //ext2.dispatcher();
            ext2.saveAndCon();

            test.stopTest();
     }
     catch(Exception e){
         system.debug('To cover error');
     }
        }


        public static testmethod void TestAIA_benefitsummary_WithPlanStaticDrug(){
            //Removed per US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/


            //Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            //modified by offshore
             Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
            //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
            //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
            insert acctMbrList;
            //
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
            //o.Workplan_Type__c = wpt.id;//as per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;


             Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
           // brf.ARC_Approval_Status__c = 'Approved by Committee';
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
            //  aiapln.BDF_Configuration_Last_Updated__c=date.today();
            //  aiapln.Configuration_Last_Updated__c=date.today();

            insert aiapln;
            StaticResource sr = [select id,body from StaticResource Where Name = 'BenSumJSONBRF_Test'];
            String jsonStr=sr.body.toString();
            AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
            AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
            mapper.saveToSetUp(apbroot,'BRF');

            StaticResource sr2 = [select id,body from StaticResource Where Name = 'BenSumJSONBDD_Test'];
            String jsonStr2=sr2.body.toString();
            AIA_PCS_BenefitSummary apbroot2=AIA_PCS_BenefitSummary.parse(jsonStr2);
            AIA_PlanTemplateMapper mapper2 = new AIA_PlanTemplateMapper();
            mapper2.saveToSetUp(apbroot2,'BDD');


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
            pp.Rider__c='None';
            pp.Network__c='National';
            insert pp;

             //RK
            AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
              RXgrouper.Name = 'Retail NonMaintenance';
              RXgrouper.Group_Type__c = 'Benefit Group';
              RXgrouper.Grouper_Record_Type__c = 'BDD';//mod
              //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
              RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            
              RXgrouper.Proposed_Products__c = pp.id;
              insert RXgrouper;
              
              AIA_Benefits__c ab3 = new AIA_Benefits__c();
              ab3.Grouper__c = RXgrouper.id;
              ab3.Benefit_Name__c = 'Retail NonMaintenance Generic Ben';
              ab3.Benefit_Type__c = 'Benefit';
              ab3.Copay_Type_1_Mandate_Name__c = 'Test';
              ab3.Type__c = 'Benefit';  
              ab3.Benefit_Record_Type__c = 'BRF';
              ab3.CoInsurance_AmountValueSelected__c = '10';
              ab3.Copay_Type_1_IsCovered__c = 'Yes';
              ab3.Copay_Type_1_DeductibleApplies__c  = 'Yes';
              ab3.AnnualMaximumApplies__c = 'Yes';  
              ab3.OON_CoInsurance_AmountValueSelected__c = '10';
              ab3.OON_Copay_Type_1_IsCovered__c = 'Yes';
              ab3.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
              ab3.OON_AnnualMaximumApplies__c = 'Yes';
              insert ab3; 
              
                AIA_Benefits__c ab4 = new AIA_Benefits__c();
              ab4.Grouper__c = RXgrouper.id;
              ab4.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand Ben';
              ab4.Benefit_Type__c = 'Benefit';
              ab4.Copay_Type_1_Mandate_Name__c = 'Test';
              ab4.Type__c = 'Benefit';  
              ab4.Benefit_Record_Type__c = 'BRF';
              ab4.CoInsurance_AmountValueSelected__c = '10';
              ab4.Copay_Type_1_IsCovered__c = 'Yes';
              ab4.Copay_Type_1_DeductibleApplies__c  = 'Yes';
              ab4.AnnualMaximumApplies__c = 'Yes';  
              ab4.OON_CoInsurance_AmountValueSelected__c = '10';
              ab4.OON_Copay_Type_1_IsCovered__c = 'Yes';
              ab4.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
              ab4.OON_AnnualMaximumApplies__c = 'Yes';
              insert ab4; 
              
                AIA_Benefits__c ab5 = new AIA_Benefits__c();
              ab5.Grouper__c = RXgrouper.id;
              ab5.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand Ben';
              ab5.Benefit_Type__c = 'Benefit';
              ab5.Copay_Type_1_Mandate_Name__c = 'Test';
              ab5.Type__c = 'Benefit';  
              ab5.Benefit_Record_Type__c = 'BRF';
              ab5.CoInsurance_AmountValueSelected__c = '10';
              ab5.Copay_Type_1_IsCovered__c = 'Yes';
              ab5.Copay_Type_1_DeductibleApplies__c  = 'Yes';
              ab5.AnnualMaximumApplies__c = 'Yes';  
              ab5.OON_CoInsurance_AmountValueSelected__c = '10';
              ab5.OON_Copay_Type_1_IsCovered__c = 'Yes';
              ab5.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
              ab5.OON_AnnualMaximumApplies__c = 'Yes';
              insert ab5; 
              
                AIA_Benefits__c ab6 = new AIA_Benefits__c();
              ab6.Grouper__c = RXgrouper.id;
              ab6.Benefit_Name__c = 'Retail NonMaintenance Self-Injectab6le Ben';
              ab6.Benefit_Type__c = 'Benefit';
              ab6.Copay_Type_1_Mandate_Name__c = 'Test';
              ab6.Type__c = 'Benefit';  
              ab6.Benefit_Record_Type__c = 'BRF';
              ab6.CoInsurance_AmountValueSelected__c = '10';
              ab6.Copay_Type_1_IsCovered__c = 'Yes';
              ab6.Copay_Type_1_DeductibleApplies__c  = 'Yes';
              ab6.AnnualMaximumApplies__c = 'Yes';  
              ab6.OON_CoInsurance_AmountValueSelected__c = '10';
              ab6.OON_Copay_Type_1_IsCovered__c = 'Yes';
              ab6.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
              ab6.OON_AnnualMaximumApplies__c = 'Yes';
              insert ab6; 
              
              //RK
            
            test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
            PageReference pref = Page.AIA_ProposedProd_Summary;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);

            // ext.mainInit();
            ext.dispatcher();
            ext.saveAndCon();
            AIA_Benefit_Design__c bd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

            AIA_Benefit_Design_Product__c bdp= new AIA_Benefit_Design_Product__c();
            bdp.Benefit_Design__c=bd.id;
          //  bdp.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Product__c', rtype);
            bdp.Plan_Name__c=aiapln.id;
            bdp.Proposed_Products__c=pp.id;     
            bdp.Funding_Arrangement__c = 'Risk';
            insert bdp;

            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where Benefit_Design__c =:bd.Id limit 1];
            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdpObj.id);
            System.currentPageReference().getParameters().put('idValue',bdpObj.id);                        

            ApexPages.StandardController con2 = new ApexPages.StandardController(bdpObj);
            AIA_BenefitDesign_SummaryController ext2 = new AIA_BenefitDesign_SummaryController(con2);
            // ext2.mainInit();
            
            ext2.dispatcher();
            ext2.saveAndCon();

            test.stopTest();
        }

        public static testmethod void TestAIA_benefitsummary_ErrorMEssage(){
            //Removed per US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/


             //Account acc = AIA_TestUtil.CreateAccount('TestAccount');
Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
            //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
            //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
             /*R1 added teammember*/
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
  /*R1 added teammember*/
            insert acctMbrList;
            //end
            

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
            //o.Workplan_Type__c = wpt.id;//as per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;


           
       Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            //brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;


            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            // aiapln.Plan_Id__c='PLAN-Test';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            //  aiapln.BDF_Configuration_Last_Updated__c=date.today();
            //  aiapln.Configuration_Last_Updated__c=date.today();

            insert aiapln;
            StaticResource sr = [select id,body from StaticResource Where Name = 'BenSumJSONBRF_Test'];
            String jsonStr=sr.body.toString();
            AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
            AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
            //  mapper.saveToSetUp(apbroot,'BRF');

            StaticResource sr2 = [select id,body from StaticResource Where Name = 'BenSumJSONBDD_Test'];
            String jsonStr2=sr2.body.toString();
            AIA_PCS_BenefitSummary apbroot2=AIA_PCS_BenefitSummary.parse(jsonStr2);
            AIA_PlanTemplateMapper mapper2 = new AIA_PlanTemplateMapper();
            //   mapper2.saveToSetUp(apbroot2,'BDD');


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
            pp.Has_Benefit_Details__c =true;
            pp.Rider__c='None';
            insert pp;
            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            ag.Group_Type__c = 'Benefit Group';
            ag.Grouper_Record_Type__c = 'BRF';
            ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();

            ag.Proposed_Products__c = pp.id;
            insert ag;

            

            test.starttest();

AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
            System.debug('++++++acc++++'+acc);
            System.debug('++++++o.id++++'+o.id);
            System.debug('+++++brf.id++++'+brf.id);
            AIA_Benefit_Design__c bd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);
            System.debug('++++++BD++++'+BD.id);
            
          AIA_Plan__c plan = AIA_TestUtil.CreateGSMPlan('Medical','xyz');
            plan.Has_Benefit_Summary__c = true;
            plan.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            plan.Jurisdiction__c = 'MD';
            plan.BDF_Configuration_Last_Updated__c  = null;
            insert plan;
            
     AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            //aiaBD.Implementation__c = Imp.id;
            aiaBD.Account__c = acc.id;
            aiaBD.Benefit_Request_Form__c = brf.Id;
            insert aiaBD;
     List<AIA_Benefit_Design_Product__c> bdpLst = new List<AIA_Benefit_Design_Product__c>();
     AIA_Benefit_Design_Product__c  bdp = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp.Has_Benefit_Details__c = true;
            bdp.Funding_Arrangement__c = 'ASO';
            bdpLst.add(bdp);
    AIA_Benefit_Design_Product__c  bdp1 = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp1.Has_Benefit_Details__c = true;
            bdp1.Funding_Arrangement__c = 'Risk';
            bdpLst.add(bdp1);
            insert bdpLst;
            
            
            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where id =:bdp1.Id limit 1];
            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            //   System.currentPageReference().getParameters().put('id',bdpObj.id);
            //   System.currentPageReference().getParameters().put('idValue',bdpObj.id);                        

            ApexPages.StandardController con2 = new ApexPages.StandardController(bdpObj);
            AIA_BenefitDesign_SummaryController ext2 = new AIA_BenefitDesign_SummaryController(con2);
            ext2.mainInit();
            ext2.dispatcher();
            //   ext2.saveAndCon();

            test.stopTest();
        }


        public static testmethod void TestAIA_benefitsummary_ErrorMEssage2(){
            //Removing as per US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/


            //Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            //mod by offshore
             Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
            //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
            //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
             /*R1 added teammember*/
             acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
              /*R1 added teammember*/
            insert acctMbrList;
            //end
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
            //o.Workplan_Type__c = wpt.id;//as per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;


           
       Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
           // brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;

            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            aiapln.Plan_Name__c='Test Plan';
            // aiapln.Plan_Id__c='PLAN-Test';
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            //  aiapln.BDF_Configuration_Last_Updated__c=date.today();
            //  aiapln.Configuration_Last_Updated__c=date.today();

            insert aiapln;
            StaticResource sr = [select id,body from StaticResource Where Name = 'BenSumJSONBRF_Test'];
            String jsonStr=sr.body.toString();
            AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
            AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
            //  mapper.saveToSetUp(apbroot,'BRF');

            StaticResource sr2 = [select id,body from StaticResource Where Name = 'BenSumJSONBDD_Test'];
            String jsonStr2=sr2.body.toString();
            AIA_PCS_BenefitSummary apbroot2=AIA_PCS_BenefitSummary.parse(jsonStr2);
            AIA_PlanTemplateMapper mapper2 = new AIA_PlanTemplateMapper();
            //   mapper2.saveToSetUp(apbroot2,'BDD');


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
            pp.Has_Benefit_Details__c =true;
            pp.Rider__c='None';
            insert pp;
            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            ag.Group_Type__c = 'Benefit Group';
            ag.Grouper_Record_Type__c = 'BRF';
            ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();

            ag.Proposed_Products__c = pp.id;
            insert ag;
      
     
             
            AIA_Plan__c plan = AIA_TestUtil.CreateGSMPlan('Medical','xyz');
            plan.Has_Benefit_Summary__c = true;
            plan.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            plan.Jurisdiction__c = 'MD';
            plan.BDF_Configuration_Last_Updated__c  = null;
            insert plan;
         
    /* Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];

            User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB123RF@testorg.com.test');
            insert u;

            User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF121@testorg.com.test');
            insert u1;

            User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF222@testorg.com.test');
            insert u2;

            User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBR12F3@testorg.com.test');
            insert u3;

            User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB3RF4@testorg.com.test');
            insert u4;

            User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUse12rBRF5@testorg.com.test');
            insert u5;

            User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingU21serBRF6@testorg.com.test');
            insert u6;

            User u7 = new User(Alias = 'TAlias7', Email='TestUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Testin11gUserBRF7@testorg.com.test');
            insert u7;

            User u8 = new User(Alias = 'TAla87', Email='T76estUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSery67', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Test76564in11gUserBRF7@testorg.com.test');
            insert u8;

            User u9 = new User(Alias = 'TAli97', Email='Te5467stUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer776', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te75stin11gUserBRF7@testorg.com.test');
            insert u9;


            User u10 = new User(Alias = 'TA197', Email='Te10e11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='Testing1076', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te10gUserBRF7@testorg.com.test');
            insert u10;

            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId = acc.id;
            atmRole.UserId = u.id;
            insert atmRole;

            AccountTeamMember atm1 = new AccountTeamMember ();
            atm1.TeamMemberRole = 'Account Manager';
            atm1.AccountId =acc.id;
            atm1.UserId = u1.id;
            insert atm1;

            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Implementation Manager';
            atmRole1.AccountId = acc.id;
            atmRole1.UserId = u2.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);

            AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Settlements';
            atmRole2.AccountId = acc.id;
            atmRole2.UserId = u3.id;
            insert atmRole2;

            AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Billing Tech';
            atmRole3.AccountId = acc.id;
            atmRole3.UserId = u4.id;
            insert atmRole3;

            AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'Audit';
            atmRole4.AccountId = acc.id;
            atmRole4.UserId = u5.id;
            insert atmRole4;

            AccountTeamMember atmRole5 = new AccountTeamMember ();
            atmRole5.TeamMemberRole = 'QA Auditor';
            atmRole5.AccountId = acc.id;
            atmRole5.UserId = u6.id;
            insert atmRole5;


            AccountTeamMember atmRole61 = new AccountTeamMember ();
            atmRole61.TeamMemberRole = 'Contract Tech';
            atmRole61.AccountId = acc.id;
            atmRole61.UserId = u7.id;
            insert atmRole61;        

            AccountTeamMember atmRole62 = new AccountTeamMember ();
            atmRole62.TeamMemberRole = 'Ancillary Analyst';
            atmRole62.AccountId = acc.id;
            atmRole62.UserId = u8.id;
            insert atmRole62;        

            AccountTeamMember atmRole6 = new AccountTeamMember ();
            atmRole6.TeamMemberRole = 'NASCO Benefit Coder';
            atmRole6.AccountId = acc.id;
            atmRole6.UserId = u9.id;
            insert atmRole6;        

            AccountTeamMember atmRole15 = new AccountTeamMember ();
            atmRole15.TeamMemberRole = 'MAST Tech';
            atmRole15.AccountId = acc.id;
            atmRole15.UserId = u10.id;
            insert atmRole15; */
     test.starttest();
    AIA_AdjustmentSummaryUtils.disableAdjustmentSummary(); 
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

           AIA_Benefit_Design__c aiabd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);
            
            
      
            
        AIA_Benefit_Design_Product__c bdp= new AIA_Benefit_Design_Product__c();
            bdp.Benefit_Design__c=aiaBD.id;
          //  bdp.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Product__c', rtype);
            bdp.Plan_Name__c=aiapln.id;
            bdp.Proposed_Products__c=pp.id;     
            bdp.Funding_Arrangement__c = 'Risk';
            insert bdp;
             
        
            


         

            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where id =:bdp.id limit 1];
            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdpObj.id);
            //   System.currentPageReference().getParameters().put('idValue',bdpObj.id);                        

            ApexPages.StandardController con2 = new ApexPages.StandardController(bdpObj);
            AIA_BenefitDesign_SummaryController ext2 = new AIA_BenefitDesign_SummaryController(con2);
            ext2.mainInit();
            ext2.dispatcher();
            //   ext2.saveAndCon();

            test.stopTest();
        }

  public Static TestMethod void TestAIA_BenefitDesign_SummaryControllerForGrouperRisk(){

            //Removing per US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/

             // Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            //mod by off
             Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
         user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
      //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
      List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom      
      //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
      	//Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
            insert acctMbrList;
            //end
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
            //o.Workplan_Type__c = wpt.id;//as per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;




            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
           // brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            //  aiapln.Has_Benefit_Summary__c = True;
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            insert aiapln;

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
            pp.Has_Benefit_Details__c =True;
            pp.Rider__c='None';
            insert pp;
            test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            ag.Group_Type__c = 'Benefit Group';
            //ag.Benefit_Design_Product__c = 
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();

            ag.Proposed_Products__c = pp.id;
            insert ag;

            /*            
          AIA_Benefits__c ab = new AIA_Benefits__c();           
                ab.Grouper__c = ag.id;
                ab.Benefit_Name__c = 'Family Out Of Pocket';
                ab.Benefit_Type__c = 'Mandate';
                ab.Type__c = 'Cost Share';           
                ab.Benefit_Record_Type__c = 'BRF';
                ab.Cost_Share_Low__c = '0';
                ab.Cost_Share_High__c = '100';
                ab.Cost_Share_Increment__c = '10';
                ab.Cost_Share_InvalidIncrements__c = '30';
                ab.Cost_Share_AdditionalIncrements__c = '33';
                ab.OON_Cost_Share_Low__c = '0';
                ab.OON_Cost_Share_High__c = '1000';
                ab.OON_Cost_Share_Increment__c = '100';
                ab.OON_Cost_Share_AdditionalIncrements__c = '330';
                ab.OON_Cost_Share_InvalidIncrements__c = '300';
                ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
                ab.Copay_Type_1_IsCovered__c = 'No';
                ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
                ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
                ab.Copay_Type_1_AliasName__c='Test';
                ab.Copay_Type_2_AliasName__c='Test';
                ab.OON_Copay_Type_1_AliasName__c='Test';
                ab.OON_Copay_Type_2_AliasName__c='Test';
                insert ab;  
             */
            List<AIA_Benefits__c> aiabenList = new List<AIA_Benefits__c>();
            AIA_Benefits__c ab2 = new AIA_Benefits__c();           
            ab2.Grouper__c = ag.id;
            ab2.Benefit_Name__c = 'Test Benefit';
            ab2.Benefit_Type__c = 'Mandate';
            ab2.Type__c = 'Benefit';           
            ab2.Benefit_Record_Type__c = 'BRF';
            ab2.Cost_Share_Low__c = '0';
            ab2.Cost_Share_High__c = '100';
            ab2.Cost_Share_Increment__c = '10';
            ab2.Cost_Share_InvalidIncrements__c = '30';
            ab2.Cost_Share_AdditionalIncrements__c = '33';
            ab2.OON_Cost_Share_Low__c = '0';
            ab2.OON_Cost_Share_High__c = '1000';
            ab2.OON_Cost_Share_Increment__c = '100';
            ab2.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab2.OON_Cost_Share_InvalidIncrements__c = '300';
            ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab2.Copay_Type_1_IsCovered__c = 'No';
            ab2.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab2.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab2.Copay_Type_1_AliasName__c='Test';
            ab2.Copay_Type_2_AliasName__c='Test';
            ab2.OON_Copay_Type_1_AliasName__c='Test';
            ab2.OON_Copay_Type_2_AliasName__c='Test';
            aiabenList.add(ab2);
            AIA_Benefits__c ab3 = new AIA_Benefits__c();           
            ab3.Grouper__c = ag.id;
            ab3.Benefit_Name__c = 'Test Benefit';
            ab3.Benefit_Type__c = 'Benefit';
            ab3.Type__c = 'Benefit';           
            ab3.Benefit_Record_Type__c = 'BRF';
            ab3.Cost_Share_Low__c = '0';
            ab3.Cost_Share_High__c = '100';
            ab3.Cost_Share_Increment__c = '10';
            ab3.Cost_Share_InvalidIncrements__c = '30';
            ab3.Cost_Share_AdditionalIncrements__c = '33';
            ab3.OON_Cost_Share_Low__c = '0';
            ab3.OON_Cost_Share_High__c = '1000';
            ab3.OON_Cost_Share_Increment__c = '100';
            ab3.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab3.OON_Cost_Share_InvalidIncrements__c = '300';
            ab3.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab3.Copay_Type_1_IsCovered__c = 'No';
            ab3.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab3.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab3.Copay_Type_1_AliasName__c='Test';
            ab3.Copay_Type_2_AliasName__c='Test';
            ab3.OON_Copay_Type_1_AliasName__c='Test';
            ab3.OON_Copay_Type_2_AliasName__c='Test';
            aiabenList.add(ab3);
            insert aiabenList;



       /*     Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];

            User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB123RF@testorg.com.test');
            insert u;

            User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF121@testorg.com.test');
            insert u1;

            User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF222@testorg.com.test');
            insert u2;

            User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBR12F3@testorg.com.test');
            insert u3;

            User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB3RF4@testorg.com.test');
            insert u4;

            User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUse12rBRF5@testorg.com.test');
            insert u5;

            User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingU21serBRF6@testorg.com.test');
            insert u6;

            User u7 = new User(Alias = 'TAlias7', Email='TestUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Testin11gUserBRF7@testorg.com.test');
            insert u7;

            User u8 = new User(Alias = 'TAla87', Email='T76estUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSery67', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Test76564in11gUserBRF7@testorg.com.test');
            insert u8;

            User u9 = new User(Alias = 'TAli97', Email='Te5467stUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer776', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te75stin11gUserBRF7@testorg.com.test');
            insert u9;


            User u10 = new User(Alias = 'TA197', Email='Te10e11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='Testing1076', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te10gUserBRF7@testorg.com.test');
            insert u10;

            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId = acc.id;
            atmRole.UserId = u.id;
            insert atmRole;

            AccountTeamMember atm1 = new AccountTeamMember ();
            atm1.TeamMemberRole = 'Account Manager';
            atm1.AccountId =acc.id;
            atm1.UserId = u1.id;
            insert atm1;

            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Implementation Manager';
            atmRole1.AccountId = acc.id;
            atmRole1.UserId = u2.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);

            AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Settlements';
            atmRole2.AccountId = acc.id;
            atmRole2.UserId = u3.id;
            insert atmRole2;

            AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Billing Tech';
            atmRole3.AccountId = acc.id;
            atmRole3.UserId = u4.id;
            insert atmRole3;

            AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'Audit';
            atmRole4.AccountId = acc.id;
            atmRole4.UserId = u5.id;
            insert atmRole4;

            AccountTeamMember atmRole5 = new AccountTeamMember ();
            atmRole5.TeamMemberRole = 'QA Auditor';
            atmRole5.AccountId = acc.id;
            atmRole5.UserId = u6.id;
            insert atmRole5;


            AccountTeamMember atmRole61 = new AccountTeamMember ();
            atmRole61.TeamMemberRole = 'Contract Tech';
            atmRole61.AccountId = acc.id;
            atmRole61.UserId = u7.id;
            insert atmRole61;        

            AccountTeamMember atmRole62 = new AccountTeamMember ();
            atmRole62.TeamMemberRole = 'Ancillary Analyst';
            atmRole62.AccountId = acc.id;
            atmRole62.UserId = u8.id;
            insert atmRole62;        

            AccountTeamMember atmRole6 = new AccountTeamMember ();
            atmRole6.TeamMemberRole = 'NASCO Benefit Coder';
            atmRole6.AccountId = acc.id;
            atmRole6.UserId = u9.id;
            insert atmRole6;        

            AccountTeamMember atmRole15 = new AccountTeamMember ();
            atmRole15.TeamMemberRole = 'MAST Tech';
            atmRole15.AccountId = acc.id;
            atmRole15.UserId = u10.id;
            insert atmRole15; */


            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = acc.id;
            Imp.Account__c = Imp.Opportunity__r.AccountId;
            //Imp.Generate_Workplan_Stages__c = true;//as per US210
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='Risk';
            insert Imp;

            AIA_Benefit_Design__c aiabd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

            AIA_Plan__c plan = AIA_TestUtil.CreateGSMPlan('Medical','xyz');
            plan.Has_Benefit_Summary__c = true;
            plan.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            plan.Jurisdiction__c = 'MD';
            plan.BDF_Configuration_Last_Updated__c  = null;
            insert plan;
            List<AIA_Benefit_Design_Product__c > bdpLst = new List<AIA_Benefit_Design_Product__c >();

            AIA_Benefit_Design_Product__c  bdp = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp.Has_Benefit_Details__c = true;
            bdp.Funding_Arrangement__c = 'Risk';
            bdpLst.add(bdp);
            AIA_Benefit_Design_Product__c  bdp1 = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp1.Has_Benefit_Details__c = true;
            bdp1.Funding_Arrangement__c = 'Risk';
            bdpLst.add(bdp1);
            insert bdpLst;

            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where Id =:bdp.Id limit 1];
            System.assertEquals(bdpObj!= null,true);

            AIA_Grouper__c ag1 = new AIA_Grouper__c();
            ag1.Name = 'CostShareRanges';
            ag1.Group_Type__c = 'Benefit Group';
            ag1.Benefit_Design_Product__c = bdpObj.id;
            ag1.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
            ag1.Sequence_Number__c = 1;
            ag1.Proposed_Products__c = pp.id;
            insert ag1;


            AIA_Benefits__c ab = new AIA_Benefits__c();           
            ab.Grouper__c = ag1.id;
            ab.Benefit_Name__c = 'Family Out Of Pocket';
            ab.Benefit_Type__c = 'Limitation';
            ab.Benefit_Summary_Comment__c='test comment';//mod
            ab.Type__c = 'Cost Share';           
            ab.Benefit_Record_Type__c = 'BRF';
            ab.Cost_Share_Low__c = '0';
            ab.Cost_Share_High__c = '100';
            ab.Cost_Share_Increment__c = '10';
            ab.Cost_Share_InvalidIncrements__c = '30';
            ab.Cost_Share_AdditionalIncrements__c = '33';
            ab.OON_Cost_Share_Low__c = '0';
            ab.OON_Cost_Share_High__c = '1000';
            ab.OON_Cost_Share_Increment__c = '100';
            ab.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab.OON_Cost_Share_InvalidIncrements__c = '300';
            ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab.Copay_Type_1_IsCovered__c = 'No';
            ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab.Copay_Type_1_AliasName__c='Test';
            ab.Copay_Type_2_AliasName__c='Test';
            ab.OON_Copay_Type_1_AliasName__c='Test';
            ab.OON_Copay_Type_2_AliasName__c='Test';
            insert ab;  

            AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
            pn.ExtID__c = '33r34t33dr';
            pn.Plan__c=plan.id;
            pn.Record_Type__c='BDD';

            insert pn;

            AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
            apg.ExtID__c =  '33r34t33dr';
            apg.ISExisting_Grouper__c = true;  
            apg.Plan__c = plan.id;
            apg.Record_Type__c = 'BDD';
            apg.Plan_Grouper_Name__c = '2233df';
            apg.Plan_Network__c = pn.id;
            //apg.Type__c = 'Benefit Group ';
            apg.Sequence_Number__c = 1;
            insert apg;  
            AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c(); 
            //apbt.Parent_Benefit_Name__c =  
            apbt.Benefit_Name__c ='wdwd';
            apbt.Benefit_Group__c = apg.id;
            apbt.Record_Type__c = 'BDD';
            apbt.IS_ASO_Only__c='Yes';
            //apbt.Name =
            apbt.Sequence_Number__c = 1;
            apbt.Coinsurance_DefaultAmount__c = '2323';   
            apbt.ISExisting_Benefit__c = True;
            apbt.Type__c='Benefit';

            insert apbt;

            List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
            AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
            apcty1.Plan_Benefits__c = apbt.id; 
            apcty1.DeductibleApplies__c = 'Yes';
            apcty1.AliasName__c = 'fhf';
            apcty1.IsCovered__c= 'Yes';
            apcty1.MandateIndicator__c='No';
            apcty1.CoinsuranceAmount__c='345';
            apcty1.Jurisdiction__c='gfhjh';
            apcty1.CopayAmount__c='67yuh';
            apcty1.MinPayAmount__c ='900';
            apcty1.MaxPayAmount__c='89';
            planCopyLst.add(apcty1);


            AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
            apcty.Plan_Benefits__c = apbt.id; 
            apcty.DeductibleApplies__c = 'Yes';
            apcty.AliasName__c = 'fhf';
            apcty.IsCovered__c= 'Yes';
            apcty.MandateIndicator__c='Yes';
            apcty.CoinsuranceAmount__c='345';
            apcty.Jurisdiction__c='gfhjh';
            apcty.CopayAmount__c='67yuh';
            apcty.MinPayAmount__c ='900';
            apcty.MaxPayAmount__c='89';
            planCopyLst.add(apcty);
            insert planCopyLst;     

            List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
            AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
            apl.Plan_Benefits__c = apbt.id;
            apl.MaxAgeType__c = 'Days';
            apl.Type__c = 'TierLimit';
            apl.Jurisdiction__c = 'Federal';
            apl.TierLimitType__c = 'Days';
            apl.MandateIndicator__c = false;
            apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
            apl.TierLimitDurationType__c = 'Lifetime'; 
            apl.MaxAgeTo__c = 23;
            apl.MaxValue__c = 33;
            apl.TierAgeTo__c = 33;
            apl.TierLimitFrom__c = 2;
            apl.TierAgeType__c = 'Years';
            apl.TierAgeFrom__c = 23;
            apl.TierLimitTo__c = 44;
            apl.MaxApply__c = 'Per Breast';
            apl.MaxType__c = 'Dollars';
            apl.MaxDuration__c = 2;
            apl.MaxDurationType__c = 'Day';
            apl.MaxAgeFrom__c = 3;
            apl.Effective_Date__c=Date.today().addDays(-10);
            apl.Term_Date__c=Date.today().addDays(10);
            planList.add(apl);


            AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
            aplObj.Plan_Benefits__c = apbt.id;
            aplObj.MaxAgeType__c = 'Days';
            aplObj.Type__c = 'MaxRow';
            aplObj.Jurisdiction__c = 'Federal';
            aplObj.TierLimitType__c = 'Days';
            aplObj.MandateIndicator__c = false;
            aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
            aplObj.TierLimitDurationType__c = 'Lifetime'; 
            aplObj.MaxAgeTo__c = 23;
            aplObj.MaxValue__c = 33;
            aplObj.TierAgeTo__c = 33;
            aplObj.TierLimitFrom__c = 2;
            aplObj.TierAgeType__c = 'Years';
            aplObj.TierAgeFrom__c = 23;
            aplObj.TierLimitTo__c = 44;
            aplObj.MaxApply__c = 'Per Breast';
            aplObj.MaxType__c = 'Dollars';
            aplObj.MaxDuration__c = 2;
            aplObj.MaxDurationType__c = 'Day';
            aplObj.MaxAgeFrom__c = 3;
            aplObj.Effective_Date__c=Date.today().addDays(-10);
            aplObj.Term_Date__c=Date.today().addDays(10);
            planList.add(aplObj);
            insert planList;



            List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
            AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc.Plan_Limitation__c = planList[0].id;
            apbcc.Code__c = 2323;
            apbcc.IsRequired__c='Yes';
            apbcc.FundingArrangement__c='Risk';
            apbcc.Comment__c = 'ewfweger';
      
            apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
            pbCCodeList.add(apbcc);
            AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc1.Plan_Limitation__c = planList[1].id;
            apbcc1.Code__c = 2323;
            apbcc1.Comment__c = 'ewfweger';
            apbcc1.IsRequired__c='Yes';
            apbcc1.FundingArrangement__c='Risk';
            apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
            pbCCodeList.add(apbcc1);
            AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc2.Plan_Limitation__c = planList[0].id;
            apbcc2.Code__c = 2323;
            apbcc2.Comment__c = 'ewfweger';
            apbcc2.FundingArrangement__c='Risk';
            apbcc2.Plan_Copay_Type__c =planCopyLst[0].id;
            pbCCodeList.add(apbcc2);
            insert pbCCodeList;

            Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
            lmt.TierLimit_Selected__c=true;
            lmt.Benefit__c = ab.id;
            lmt.TierLimitFrom__c = 2;
            lmt.TierLimitType__c = 'Days';
            lmt.TierLimitTo__c = 44;
            lmt.TierLimitDurationType__c = 'Lifetime';
            insert lmt;
            Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
            lmt2.Benefit__c = ab.id;
            lmt2.TierAge_Selected__c=true;
            lmt2.TierAgeType__c = 'Years';
            lmt2.TierAgeFrom__c = 23;
            lmt2.TierLimitTo__c = 44;
            lmt2.MaxDuration_Selected__c=true;
            lmt2.MaxValue__c = 33;
            lmt2.MaxDuration__c = 2;
            lmt2.MaxDurationType__c = 'Day';
            lmt2.MaxApply__c = 'Per Breast';
            lmt2.MaxType__c = 'Dollars';
            lmt2.MaxAge_Selected__c=true;
            lmt2.MaxAgeFrom__c = 3;
            lmt2.MaxAgeTo__c = 23;
            lmt2.MaxAgeType__c = 'Days';
            insert lmt2;

            Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
            lmt3.Benefit__c = ab.id;
            lmt3.Is_ASO_Only__c = False;
            insert lmt3;

            AIA_benefitDesign_SummaryController.BenifitsrWrapper bwrap = new AIA_benefitDesign_SummaryController.BenifitsrWrapper();
            bwrap.benifitNameStr = 'ABCD';
            bwrap.benifitlmt = '232';

            bwrap.MaxPlanCodelst.add(apbcc);
            bwrap.maxPlan = '223';
            bwrap.GrpName = 'CostShareRanges';
            bwrap.madateCheck = True;
            bwrap.tierPlan = '2';

            bwrap.lstPlanlimit.add(apl);
            //List<Limitations__c> limlist = new List<Limitations__c>();
            bwrap.lstlimit.add(lmt);
            bwrap.aiaBenifitObj= ab;
            //List<AIA_benefitDesign_SummaryController.NetworkTypeWrapper> nwlist = new List<AIA_benefitDesign_SummaryController.NetworkTypeWrapper>();
            AIA_benefitDesign_SummaryController.NetworkTypeWrapper nwwrap = new AIA_benefitDesign_SummaryController.NetworkTypeWrapper();
            //nwwrap.networkTypeStr = '545';
            nwwrap.benifitNetworkObj = apbt;
            nwwrap.copayTypeForDrugObj= apcty;
            AIA_benefitDesign_SummaryController.CopayTypeWrapper xyz = new AIA_benefitDesign_SummaryController.CopayTypeWrapper();
            xyz.copayTypeSelectedObj = apcty; 
            xyz.copayTypePecSpecObj = apcty;
            xyz.copayTypeSelectedObj2 = apcty;
            xyz.copayTypePecSpecObj2 = apcty;

            nwwrap.copayTypeWrapObj = xyz;

            bwrap.networkWrapList.add(nwwrap);
            bwrap.copayTypeWrapObj = xyz;


            AIA_benefitDesign_SummaryController.GrouperWrapper wrap = new AIA_benefitDesign_SummaryController.GrouperWrapper();
            wrap.aiaGrouper = ag;
            wrap.grouperObj = apg;
            wrap.benifitWrapList.add(bwrap);
            wrap.INpcpVal = 'bhuv';
            wrap.INspcpVal = 'dxcv';
            wrap.OutpcpVal ='cfvg';
            wrap.OutspcpVal ='xdcfv';

            list<AIA_benefitDesign_SummaryController.GrouperWrapper> grprwr = new list<AIA_benefitDesign_SummaryController.GrouperWrapper>();

            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdpObj.id);
            System.currentPageReference().getParameters().put('idValue',pp.id);                        

            ApexPages.StandardController con = new ApexPages.StandardController(bdpObj);
            AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);

            AIA_Plan_Grouper__c grprListToClr = [Select id, Name, Sequence_Number__c,Record_Type__c,ISExisting_Grouper__c, Plan_Network__c,Type__c, Plan_Network__r.Name 
                                                 From AIA_Plan_Grouper__c  limit 1];
            system.assertEquals(grprListToClr!=null,true);
            //system.assertEquals(grprListToClr.Type__c ,'Benefit Group');                                     
            grprListToClr.Type__c = 'Benefit Group';
            update grprListToClr;
            String  planIdStr = String.valueof(bdpObj.Plan_Name__c).left(15);
            ext.getGroupersFromPlan(planIdStr,'BDD');
            ext.getBenefitsForPlan(planIdStr,'BDD');
            ext.createWrapListFromPlan(bdpObj);
            ext.pp = bdpObj;
            ext.grouperWrapList.add(wrap);
            ext.isPCScallReq(plan);
            ext.hasBnftSumry(plan);
            //Commenting as part of US1650
            //ext.getPCSdata();
            ext.mainInit(); 
            ext.reviewInit();
            ext.saveandRedirct();
            bdpObj.Has_Benefit_Details__c = false;
            bdpObj.Funding_Arrangement__c = 'Risk';
            update bdpObj;

            AIA_Benefit_Design_Product__c bdpUpdateObj = [Select Id,Product_Category__c,Has_Benefit_Details__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                          From AIA_Benefit_Design_Product__c where Id =:bdpObj.Id limit 1];

            //ext.SaveAndContinuePlanBenefits(bdpObj);
            EXT.createWrapListFromPlan(bdpUpdateObj);
            ext.createListFromPP(bdpUpdateObj.id,false);
            ext.createListFromPP(bdpUpdateObj.id,true);
            ext.back();
            ext.SaveAndContinuePlanBenefits(bdpUpdateObj);
            ext.saveAndCon();
            ext.saveAndContemp();
            ext.dispatcherTemp();

            test.stoptest();      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
        }

  public Static TestMethod void TestAIA_BenefitDesign_SummaryControllerForGrouperRiskMandate(){

            //Removed as per US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/

             // Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            //mod by off
             Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
         user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
      //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
      		//acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
      //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
            insert acctMbrList;
            //end
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
            //o.Workplan_Type__c = wpt.id;//as per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;




            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
           // brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            //  aiapln.Has_Benefit_Summary__c = True;
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            insert aiapln;

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
            pp.Has_Benefit_Details__c =True;
            pp.Rider__c='None';
            insert pp;
            test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            ag.Group_Type__c = 'Benefit Group';
            //ag.Benefit_Design_Product__c = 
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();

            ag.Proposed_Products__c = pp.id;
            insert ag;

            /*            
          AIA_Benefits__c ab = new AIA_Benefits__c();           
                ab.Grouper__c = ag.id;
                ab.Benefit_Name__c = 'Family Out Of Pocket';
                ab.Benefit_Type__c = 'Mandate';
                ab.Type__c = 'Cost Share';           
                ab.Benefit_Record_Type__c = 'BRF';
                ab.Cost_Share_Low__c = '0';
                ab.Cost_Share_High__c = '100';
                ab.Cost_Share_Increment__c = '10';
                ab.Cost_Share_InvalidIncrements__c = '30';
                ab.Cost_Share_AdditionalIncrements__c = '33';
                ab.OON_Cost_Share_Low__c = '0';
                ab.OON_Cost_Share_High__c = '1000';
                ab.OON_Cost_Share_Increment__c = '100';
                ab.OON_Cost_Share_AdditionalIncrements__c = '330';
                ab.OON_Cost_Share_InvalidIncrements__c = '300';
                ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
                ab.Copay_Type_1_IsCovered__c = 'No';
                ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
                ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
                ab.Copay_Type_1_AliasName__c='Test';
                ab.Copay_Type_2_AliasName__c='Test';
                ab.OON_Copay_Type_1_AliasName__c='Test';
                ab.OON_Copay_Type_2_AliasName__c='Test';
                insert ab;  
             */
            List<AIA_Benefits__c> aiabenList = new List<AIA_Benefits__c>();
            AIA_Benefits__c ab2 = new AIA_Benefits__c();           
            ab2.Grouper__c = ag.id;
            ab2.Benefit_Name__c = 'Test Benefit';
            ab2.Benefit_Type__c = 'Mandate';
            ab2.Type__c = 'Benefit';           
            ab2.Benefit_Record_Type__c = 'BRF';
            ab2.Cost_Share_Low__c = '0';
            ab2.Cost_Share_High__c = '100';
            ab2.Cost_Share_Increment__c = '10';
            ab2.Cost_Share_InvalidIncrements__c = '30';
            ab2.Cost_Share_AdditionalIncrements__c = '33';
            ab2.OON_Cost_Share_Low__c = '0';
            ab2.OON_Cost_Share_High__c = '1000';
            ab2.OON_Cost_Share_Increment__c = '100';
            ab2.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab2.OON_Cost_Share_InvalidIncrements__c = '300';
            ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab2.Copay_Type_1_IsCovered__c = 'No';
            ab2.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab2.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab2.Copay_Type_1_AliasName__c='Test';
            ab2.Copay_Type_2_AliasName__c='Test';
            ab2.OON_Copay_Type_1_AliasName__c='Test';
            ab2.OON_Copay_Type_2_AliasName__c='Test';
            aiabenList.add(ab2);
            AIA_Benefits__c ab3 = new AIA_Benefits__c();           
            ab3.Grouper__c = ag.id;
            ab3.Benefit_Name__c = 'Test Benefit';
            ab3.Benefit_Type__c = 'Benefit';
            ab3.Type__c = 'Benefit';           
            ab3.Benefit_Record_Type__c = 'BRF';
            ab3.Cost_Share_Low__c = '0';
            ab3.Cost_Share_High__c = '100';
            ab3.Cost_Share_Increment__c = '10';
            ab3.Cost_Share_InvalidIncrements__c = '30';
            ab3.Cost_Share_AdditionalIncrements__c = '33';
            ab3.OON_Cost_Share_Low__c = '0';
            ab3.OON_Cost_Share_High__c = '1000';
            ab3.OON_Cost_Share_Increment__c = '100';
            ab3.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab3.OON_Cost_Share_InvalidIncrements__c = '300';
            ab3.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab3.Copay_Type_1_IsCovered__c = 'No';
            ab3.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab3.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab3.Copay_Type_1_AliasName__c='Test';
            ab3.Copay_Type_2_AliasName__c='Test';
            ab3.OON_Copay_Type_1_AliasName__c='Test';
            ab3.OON_Copay_Type_2_AliasName__c='Test';
            aiabenList.add(ab3);
            insert aiabenList;



       /*     Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];

            User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB123RF@testorg.com.test');
            insert u;

            User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF121@testorg.com.test');
            insert u1;

            User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF222@testorg.com.test');
            insert u2;

            User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBR12F3@testorg.com.test');
            insert u3;

            User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB3RF4@testorg.com.test');
            insert u4;

            User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUse12rBRF5@testorg.com.test');
            insert u5;

            User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingU21serBRF6@testorg.com.test');
            insert u6;

            User u7 = new User(Alias = 'TAlias7', Email='TestUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Testin11gUserBRF7@testorg.com.test');
            insert u7;

            User u8 = new User(Alias = 'TAla87', Email='T76estUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSery67', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Test76564in11gUserBRF7@testorg.com.test');
            insert u8;

            User u9 = new User(Alias = 'TAli97', Email='Te5467stUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer776', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te75stin11gUserBRF7@testorg.com.test');
            insert u9;


            User u10 = new User(Alias = 'TA197', Email='Te10e11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='Testing1076', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te10gUserBRF7@testorg.com.test');
            insert u10;

            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId = acc.id;
            atmRole.UserId = u.id;
            insert atmRole;

            AccountTeamMember atm1 = new AccountTeamMember ();
            atm1.TeamMemberRole = 'Account Manager';
            atm1.AccountId =acc.id;
            atm1.UserId = u1.id;
            insert atm1;

            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Implementation Manager';
            atmRole1.AccountId = acc.id;
            atmRole1.UserId = u2.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);

            AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Settlements';
            atmRole2.AccountId = acc.id;
            atmRole2.UserId = u3.id;
            insert atmRole2;

            AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Billing Tech';
            atmRole3.AccountId = acc.id;
            atmRole3.UserId = u4.id;
            insert atmRole3;

            AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'Audit';
            atmRole4.AccountId = acc.id;
            atmRole4.UserId = u5.id;
            insert atmRole4;

            AccountTeamMember atmRole5 = new AccountTeamMember ();
            atmRole5.TeamMemberRole = 'QA Auditor';
            atmRole5.AccountId = acc.id;
            atmRole5.UserId = u6.id;
            insert atmRole5;


            AccountTeamMember atmRole61 = new AccountTeamMember ();
            atmRole61.TeamMemberRole = 'Contract Tech';
            atmRole61.AccountId = acc.id;
            atmRole61.UserId = u7.id;
            insert atmRole61;        

            AccountTeamMember atmRole62 = new AccountTeamMember ();
            atmRole62.TeamMemberRole = 'Ancillary Analyst';
            atmRole62.AccountId = acc.id;
            atmRole62.UserId = u8.id;
            insert atmRole62;        

            AccountTeamMember atmRole6 = new AccountTeamMember ();
            atmRole6.TeamMemberRole = 'NASCO Benefit Coder';
            atmRole6.AccountId = acc.id;
            atmRole6.UserId = u9.id;
            insert atmRole6;        

            AccountTeamMember atmRole15 = new AccountTeamMember ();
            atmRole15.TeamMemberRole = 'MAST Tech';
            atmRole15.AccountId = acc.id;
            atmRole15.UserId = u10.id;
            insert atmRole15; */


            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = acc.id;
            Imp.Account__c = Imp.Opportunity__r.AccountId;
            //Imp.Generate_Workplan_Stages__c = true;//as per US210
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='Risk';
            insert Imp;

            AIA_Benefit_Design__c aiabd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

            AIA_Plan__c plan = AIA_TestUtil.CreateGSMPlan('Medical','xyz');
            plan.Has_Benefit_Summary__c = true;
            plan.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            plan.Jurisdiction__c = 'MD';
            plan.BDF_Configuration_Last_Updated__c  = null;
            insert plan;
            List<AIA_Benefit_Design_Product__c > bdpLst = new List<AIA_Benefit_Design_Product__c >();

            AIA_Benefit_Design_Product__c  bdp = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp.Has_Benefit_Details__c = true;
            bdp.Funding_Arrangement__c = 'Risk';
            bdpLst.add(bdp);
            AIA_Benefit_Design_Product__c  bdp1 = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp1.Has_Benefit_Details__c = true;
            bdp1.Funding_Arrangement__c = 'Risk';
            bdpLst.add(bdp1);
            insert bdpLst;

            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where Id =:bdp.Id limit 1];
            System.assertEquals(bdpObj!= null,true);

            AIA_Grouper__c ag1 = new AIA_Grouper__c();
            ag1.Name = 'CostShareRanges';
            ag1.Group_Type__c = 'Benefit Group';
            ag1.Benefit_Design_Product__c = bdpObj.id;
            ag1.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
            ag1.Sequence_Number__c = 1;
            ag1.Proposed_Products__c = pp.id;
            insert ag1;


            AIA_Benefits__c ab = new AIA_Benefits__c();           
            ab.Grouper__c = ag1.id;
            ab.Benefit_Name__c = 'Family Out Of Pocket';
            ab.Benefit_Type__c = 'Limitation';
            ab.Benefit_Summary_Comment__c='test comment';//mod
            ab.Type__c = 'Cost Share';           
            ab.Benefit_Record_Type__c = 'BRF';
            ab.Cost_Share_Low__c = '0';
            ab.Cost_Share_High__c = '100';
            ab.Cost_Share_Increment__c = '10';
            ab.Cost_Share_InvalidIncrements__c = '30';
            ab.Cost_Share_AdditionalIncrements__c = '33';
            ab.OON_Cost_Share_Low__c = '0';
            ab.OON_Cost_Share_High__c = '1000';
            ab.OON_Cost_Share_Increment__c = '100';
            ab.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab.OON_Cost_Share_InvalidIncrements__c = '300';
            ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab.Copay_Type_1_IsCovered__c = 'No';
            ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab.Copay_Type_1_AliasName__c='Test';
            ab.Copay_Type_2_AliasName__c='Test';
            ab.OON_Copay_Type_1_AliasName__c='Test';
            ab.OON_Copay_Type_2_AliasName__c='Test';
            insert ab;  

            AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
            pn.ExtID__c = '33r34t33dr';
            pn.Plan__c=plan.id;
            pn.Record_Type__c='BDD';

            insert pn;

            AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
            apg.ExtID__c =  '33r34t33dr';
            apg.ISExisting_Grouper__c = true;  
            apg.Plan__c = plan.id;
            apg.Record_Type__c = 'BDD';
            apg.Plan_Grouper_Name__c = '2233df';
            apg.Plan_Network__c = pn.id;
            //apg.Type__c = 'Benefit Group ';
            apg.Sequence_Number__c = 1;
            insert apg;  
            AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c(); 
            //apbt.Parent_Benefit_Name__c =  
            apbt.Benefit_Name__c ='wdwd';
            apbt.Benefit_Group__c = apg.id;
            apbt.Record_Type__c = 'BDD';
            apbt.IS_ASO_Only__c='Yes';
            //apbt.Name =
            apbt.Sequence_Number__c = 1;
            apbt.Coinsurance_DefaultAmount__c = '2323';   
            apbt.ISExisting_Benefit__c = True;
            apbt.Type__c='Benefit';

            insert apbt;

            List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
            AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
            apcty1.Plan_Benefits__c = apbt.id; 
            apcty1.DeductibleApplies__c = 'Yes';
            apcty1.AliasName__c = 'fhf';
            apcty1.IsCovered__c= 'Yes';
            apcty1.MandateIndicator__c='No';
            apcty1.CoinsuranceAmount__c='345';
            apcty1.Jurisdiction__c='gfhjh';
            apcty1.CopayAmount__c='67yuh';
            apcty1.MinPayAmount__c ='900';
            apcty1.MaxPayAmount__c='89';
            planCopyLst.add(apcty1);


            AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
            apcty.Plan_Benefits__c = apbt.id; 
            apcty.DeductibleApplies__c = 'Yes';
            apcty.AliasName__c = 'fhf';
            apcty.IsCovered__c= 'Yes';
            apcty.MandateIndicator__c='No';
            apcty.CoinsuranceAmount__c='345';
            apcty.Jurisdiction__c='gfhjh';
            apcty.CopayAmount__c='67yuh';
            apcty.MinPayAmount__c ='900';
            apcty.MaxPayAmount__c='89';
            planCopyLst.add(apcty);
            insert planCopyLst;     

            List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
            AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
            apl.Plan_Benefits__c = apbt.id;
            apl.MaxAgeType__c = 'Days';
            apl.Type__c = 'TierLimit';
            apl.Jurisdiction__c = 'Federal';
            apl.TierLimitType__c = 'Days';
            apl.MandateIndicator__c = false;
            apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
            apl.TierLimitDurationType__c = 'Lifetime'; 
            apl.MaxAgeTo__c = 23;
            apl.MaxValue__c = 33;
            apl.TierAgeTo__c = 33;
            apl.TierLimitFrom__c = 2;
            apl.TierAgeType__c = 'Years';
            apl.TierAgeFrom__c = 23;
            apl.TierLimitTo__c = 44;
            apl.MaxApply__c = 'Per Breast';
            apl.MaxType__c = 'Dollars';
            apl.MaxDuration__c = 2;
            apl.MaxDurationType__c = 'Day';
            apl.MaxAgeFrom__c = 3;
            apl.Effective_Date__c=Date.today().addDays(-10);
            apl.Term_Date__c=Date.today().addDays(10);
            planList.add(apl);


            AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
            aplObj.Plan_Benefits__c = apbt.id;
            aplObj.MaxAgeType__c = 'Days';
            aplObj.Type__c = 'MaxRow';
            aplObj.Jurisdiction__c = 'Federal';
            aplObj.TierLimitType__c = 'Days';
            aplObj.MandateIndicator__c = false;
            aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
            aplObj.TierLimitDurationType__c = 'Lifetime'; 
            aplObj.MaxAgeTo__c = 23;
            aplObj.MaxValue__c = 33;
            aplObj.TierAgeTo__c = 33;
            aplObj.TierLimitFrom__c = 2;
            aplObj.TierAgeType__c = 'Years';
            aplObj.TierAgeFrom__c = 23;
            aplObj.TierLimitTo__c = 44;
            aplObj.MaxApply__c = 'Per Breast';
            aplObj.MaxType__c = 'Dollars';
            aplObj.MaxDuration__c = 2;
            aplObj.MaxDurationType__c = 'Day';
            aplObj.MaxAgeFrom__c = 3;
            aplObj.Effective_Date__c=Date.today().addDays(-10);
            aplObj.Term_Date__c=Date.today().addDays(10);
            planList.add(aplObj);
            insert planList;



            List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
            AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc.Plan_Limitation__c = planList[0].id;
            apbcc.Code__c = 2323;
            apbcc.IsRequired__c='Yes';
            apbcc.FundingArrangement__c='Risk';
            apbcc.Comment__c = 'ewfweger';
      
            apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
            pbCCodeList.add(apbcc);
            AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc1.Plan_Limitation__c = planList[1].id;
            apbcc1.Code__c = 2323;
            apbcc1.Comment__c = 'ewfweger';
            apbcc1.IsRequired__c='Yes';
            apbcc1.FundingArrangement__c='Risk';
            apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
            pbCCodeList.add(apbcc1);
            AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc2.Plan_Limitation__c = planList[0].id;
            apbcc2.Code__c = 2323;
            apbcc2.Comment__c = 'ewfweger';
            apbcc2.FundingArrangement__c='Risk';
            apbcc2.Plan_Copay_Type__c =planCopyLst[0].id;
            pbCCodeList.add(apbcc2);
            insert pbCCodeList;

            Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
            lmt.TierLimit_Selected__c=true;
            lmt.Benefit__c = ab.id;
            lmt.TierLimitFrom__c = 2;
            lmt.TierLimitType__c = 'Days';
            lmt.TierLimitTo__c = 44;
            lmt.TierLimitDurationType__c = 'Lifetime';
            insert lmt;
            Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
            lmt2.Benefit__c = ab.id;
            lmt2.TierAge_Selected__c=true;
            lmt2.TierAgeType__c = 'Years';
            lmt2.TierAgeFrom__c = 23;
            lmt2.TierLimitTo__c = 44;
            lmt2.MaxDuration_Selected__c=true;
            lmt2.MaxValue__c = 33;
            lmt2.MaxDuration__c = 2;
            lmt2.MaxDurationType__c = 'Day';
            lmt2.MaxApply__c = 'Per Breast';
            lmt2.MaxType__c = 'Dollars';
            lmt2.MaxAge_Selected__c=true;
            lmt2.MaxAgeFrom__c = 3;
            lmt2.MaxAgeTo__c = 23;
            lmt2.MaxAgeType__c = 'Days';
            insert lmt2;

            Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
            lmt3.Benefit__c = ab.id;

            insert lmt3;

            AIA_benefitDesign_SummaryController.BenifitsrWrapper bwrap = new AIA_benefitDesign_SummaryController.BenifitsrWrapper();
            bwrap.benifitNameStr = 'ABCD';
            bwrap.benifitlmt = '232';

            bwrap.MaxPlanCodelst.add(apbcc);
            bwrap.maxPlan = '223';
            bwrap.GrpName = 'CostShareRanges';
            bwrap.madateCheck = True;
            bwrap.tierPlan = '2';

            bwrap.lstPlanlimit.add(apl);
            //List<Limitations__c> limlist = new List<Limitations__c>();
            bwrap.lstlimit.add(lmt);
            bwrap.aiaBenifitObj= ab;
            //List<AIA_benefitDesign_SummaryController.NetworkTypeWrapper> nwlist = new List<AIA_benefitDesign_SummaryController.NetworkTypeWrapper>();
            AIA_benefitDesign_SummaryController.NetworkTypeWrapper nwwrap = new AIA_benefitDesign_SummaryController.NetworkTypeWrapper();
            //nwwrap.networkTypeStr = '545';
            nwwrap.benifitNetworkObj = apbt;
            nwwrap.copayTypeForDrugObj= apcty;
            AIA_benefitDesign_SummaryController.CopayTypeWrapper xyz = new AIA_benefitDesign_SummaryController.CopayTypeWrapper();
            xyz.copayTypeSelectedObj = apcty; 
            xyz.copayTypePecSpecObj = apcty;
            xyz.copayTypeSelectedObj2 = apcty;
            xyz.copayTypePecSpecObj2 = apcty;

            nwwrap.copayTypeWrapObj = xyz;

            bwrap.networkWrapList.add(nwwrap);
            bwrap.copayTypeWrapObj = xyz;


            AIA_benefitDesign_SummaryController.GrouperWrapper wrap = new AIA_benefitDesign_SummaryController.GrouperWrapper();
            wrap.aiaGrouper = ag;
            wrap.grouperObj = apg;
            wrap.benifitWrapList.add(bwrap);
            wrap.INpcpVal = 'bhuv';
            wrap.INspcpVal = 'dxcv';
            wrap.OutpcpVal ='cfvg';
            wrap.OutspcpVal ='xdcfv';

            list<AIA_benefitDesign_SummaryController.GrouperWrapper> grprwr = new list<AIA_benefitDesign_SummaryController.GrouperWrapper>();

            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdpObj.id);
            System.currentPageReference().getParameters().put('idValue',pp.id);                        

            ApexPages.StandardController con = new ApexPages.StandardController(bdpObj);
            AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);

            AIA_Plan_Grouper__c grprListToClr = [Select id, Name, Sequence_Number__c,Record_Type__c,ISExisting_Grouper__c, Plan_Network__c,Type__c, Plan_Network__r.Name 
                                                 From AIA_Plan_Grouper__c  limit 1];
            system.assertEquals(grprListToClr!=null,true);
            //system.assertEquals(grprListToClr.Type__c ,'Benefit Group');                                     
            grprListToClr.Type__c = 'Benefit Group';
            update grprListToClr;
            String  planIdStr = String.valueof(bdpObj.Plan_Name__c).left(15);
            ext.getGroupersFromPlan(planIdStr,'BDD');
            ext.getBenefitsForPlan(planIdStr,'BDD');
            ext.createWrapListFromPlan(bdpObj);
            ext.pp = bdpObj;
            ext.grouperWrapList.add(wrap);
            ext.isPCScallReq(plan);
            ext.hasBnftSumry(plan);
            //Commenting as part of US1650
            //ext.getPCSdata();
            ext.mainInit(); 
            ext.reviewInit();
            ext.saveandRedirct();
            bdpObj.Has_Benefit_Details__c = false;
            bdpObj.Funding_Arrangement__c = 'Risk';
            update bdpObj;

            AIA_Benefit_Design_Product__c bdpUpdateObj = [Select Id,Product_Category__c,Has_Benefit_Details__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                          From AIA_Benefit_Design_Product__c where Id =:bdpObj.Id limit 1];

            //ext.SaveAndContinuePlanBenefits(bdpObj);
            EXT.createWrapListFromPlan(bdpUpdateObj);
            ext.createListFromPP(bdpUpdateObj.id,false);
            ext.createListFromPP(bdpUpdateObj.id,true);
            ext.back();
            ext.SaveAndContinuePlanBenefits(bdpUpdateObj);
            ext.saveAndCon();
            ext.saveAndContemp();
            ext.dispatcherTemp();

            test.stoptest();      
        }
 public Static TestMethod void TestAIA_BenefitDesign_SummaryControllerForGrouperMandatefalse(){

            //Removing as per US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/

             // Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            //mod by off
             Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
     //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
     		//acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
             /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
            /*R1 added teammember*/
     	//Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
            insert acctMbrList;
            //end
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
            //o.Workplan_Type__c = wpt.id;//as per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;




            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
           // brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            //  aiapln.Has_Benefit_Summary__c = True;
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            insert aiapln;

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
            pp.Has_Benefit_Details__c =True;
            pp.Rider__c='None';
            insert pp;
            test.starttest();

AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            ag.Group_Type__c = 'Benefit Group';
            //ag.Benefit_Design_Product__c = 
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();

            ag.Proposed_Products__c = pp.id;
            insert ag;

            /*            
          AIA_Benefits__c ab = new AIA_Benefits__c();           
                ab.Grouper__c = ag.id;
                ab.Benefit_Name__c = 'Family Out Of Pocket';
                ab.Benefit_Type__c = 'Mandate';
                ab.Type__c = 'Cost Share';           
                ab.Benefit_Record_Type__c = 'BRF';
                ab.Cost_Share_Low__c = '0';
                ab.Cost_Share_High__c = '100';
                ab.Cost_Share_Increment__c = '10';
                ab.Cost_Share_InvalidIncrements__c = '30';
                ab.Cost_Share_AdditionalIncrements__c = '33';
                ab.OON_Cost_Share_Low__c = '0';
                ab.OON_Cost_Share_High__c = '1000';
                ab.OON_Cost_Share_Increment__c = '100';
                ab.OON_Cost_Share_AdditionalIncrements__c = '330';
                ab.OON_Cost_Share_InvalidIncrements__c = '300';
                ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
                ab.Copay_Type_1_IsCovered__c = 'No';
                ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
                ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
                ab.Copay_Type_1_AliasName__c='Test';
                ab.Copay_Type_2_AliasName__c='Test';
                ab.OON_Copay_Type_1_AliasName__c='Test';
                ab.OON_Copay_Type_2_AliasName__c='Test';
                insert ab;  
             */
            List<AIA_Benefits__c> aiabenList = new List<AIA_Benefits__c>();
            AIA_Benefits__c ab2 = new AIA_Benefits__c();           
            ab2.Grouper__c = ag.id;
            ab2.Benefit_Name__c = 'Test Benefit';
            ab2.Benefit_Type__c = 'Mandate';
            ab2.Type__c = 'Benefit';           
            ab2.Benefit_Record_Type__c = 'BRF';
            ab2.Cost_Share_Low__c = '0';
            ab2.Cost_Share_High__c = '100';
            ab2.Cost_Share_Increment__c = '10';
            ab2.Cost_Share_InvalidIncrements__c = '30';
            ab2.Cost_Share_AdditionalIncrements__c = '33';
            ab2.OON_Cost_Share_Low__c = '0';
            ab2.OON_Cost_Share_High__c = '1000';
            ab2.OON_Cost_Share_Increment__c = '100';
            ab2.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab2.OON_Cost_Share_InvalidIncrements__c = '300';
            ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab2.Copay_Type_1_IsCovered__c = 'No';
            ab2.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab2.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab2.Copay_Type_1_AliasName__c='Test';
            ab2.Copay_Type_2_AliasName__c='Test';
            ab2.OON_Copay_Type_1_AliasName__c='Test';
            ab2.OON_Copay_Type_2_AliasName__c='Test';
            aiabenList.add(ab2);
            AIA_Benefits__c ab3 = new AIA_Benefits__c();           
            ab3.Grouper__c = ag.id;
            ab3.Benefit_Name__c = 'Test Benefit';
            ab3.Benefit_Type__c = 'Benefit';
            ab3.Type__c = 'Benefit';           
            ab3.Benefit_Record_Type__c = 'BRF';
            ab3.Cost_Share_Low__c = '0';
            ab3.Cost_Share_High__c = '100';
            ab3.Cost_Share_Increment__c = '10';
            ab3.Cost_Share_InvalidIncrements__c = '30';
            ab3.Cost_Share_AdditionalIncrements__c = '33';
            ab3.OON_Cost_Share_Low__c = '0';
            ab3.OON_Cost_Share_High__c = '1000';
            ab3.OON_Cost_Share_Increment__c = '100';
            ab3.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab3.OON_Cost_Share_InvalidIncrements__c = '300';
            ab3.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab3.Copay_Type_1_IsCovered__c = 'No';
            ab3.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab3.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab3.Copay_Type_1_AliasName__c='Test';
            ab3.Copay_Type_2_AliasName__c='Test';
            ab3.OON_Copay_Type_1_AliasName__c='Test';
            ab3.OON_Copay_Type_2_AliasName__c='Test';
            aiabenList.add(ab3);
            insert aiabenList;



       /*     Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];

            User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB123RF@testorg.com.test');
            insert u;

            User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF121@testorg.com.test');
            insert u1;

            User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF222@testorg.com.test');
            insert u2;

            User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBR12F3@testorg.com.test');
            insert u3;

            User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB3RF4@testorg.com.test');
            insert u4;

            User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUse12rBRF5@testorg.com.test');
            insert u5;

            User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingU21serBRF6@testorg.com.test');
            insert u6;

            User u7 = new User(Alias = 'TAlias7', Email='TestUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Testin11gUserBRF7@testorg.com.test');
            insert u7;

            User u8 = new User(Alias = 'TAla87', Email='T76estUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSery67', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Test76564in11gUserBRF7@testorg.com.test');
            insert u8;

            User u9 = new User(Alias = 'TAli97', Email='Te5467stUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer776', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te75stin11gUserBRF7@testorg.com.test');
            insert u9;


            User u10 = new User(Alias = 'TA197', Email='Te10e11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='Testing1076', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te10gUserBRF7@testorg.com.test');
            insert u10;

            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId = acc.id;
            atmRole.UserId = u.id;
            insert atmRole;

            AccountTeamMember atm1 = new AccountTeamMember ();
            atm1.TeamMemberRole = 'Account Manager';
            atm1.AccountId =acc.id;
            atm1.UserId = u1.id;
            insert atm1;

            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Implementation Manager';
            atmRole1.AccountId = acc.id;
            atmRole1.UserId = u2.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);

            AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Settlements';
            atmRole2.AccountId = acc.id;
            atmRole2.UserId = u3.id;
            insert atmRole2;

            AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Billing Tech';
            atmRole3.AccountId = acc.id;
            atmRole3.UserId = u4.id;
            insert atmRole3;

            AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'Audit';
            atmRole4.AccountId = acc.id;
            atmRole4.UserId = u5.id;
            insert atmRole4;

            AccountTeamMember atmRole5 = new AccountTeamMember ();
            atmRole5.TeamMemberRole = 'QA Auditor';
            atmRole5.AccountId = acc.id;
            atmRole5.UserId = u6.id;
            insert atmRole5;


            AccountTeamMember atmRole61 = new AccountTeamMember ();
            atmRole61.TeamMemberRole = 'Contract Tech';
            atmRole61.AccountId = acc.id;
            atmRole61.UserId = u7.id;
            insert atmRole61;        

            AccountTeamMember atmRole62 = new AccountTeamMember ();
            atmRole62.TeamMemberRole = 'Ancillary Analyst';
            atmRole62.AccountId = acc.id;
            atmRole62.UserId = u8.id;
            insert atmRole62;        

            AccountTeamMember atmRole6 = new AccountTeamMember ();
            atmRole6.TeamMemberRole = 'NASCO Benefit Coder';
            atmRole6.AccountId = acc.id;
            atmRole6.UserId = u9.id;
            insert atmRole6;        

            AccountTeamMember atmRole15 = new AccountTeamMember ();
            atmRole15.TeamMemberRole = 'MAST Tech';
            atmRole15.AccountId = acc.id;
            atmRole15.UserId = u10.id;
            insert atmRole15; */


            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = acc.id;
            Imp.Account__c = Imp.Opportunity__r.AccountId;
            //Imp.Generate_Workplan_Stages__c = true;//as per US210
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            insert Imp;

            AIA_Benefit_Design__c aiabd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

            AIA_Plan__c plan = AIA_TestUtil.CreateGSMPlan('Medical','xyz');
            plan.Has_Benefit_Summary__c = true;
            plan.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            plan.Jurisdiction__c = 'MD';
            plan.BDF_Configuration_Last_Updated__c  = null;
            insert plan;
            List<AIA_Benefit_Design_Product__c > bdpLst = new List<AIA_Benefit_Design_Product__c >();

            AIA_Benefit_Design_Product__c  bdp = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp.Has_Benefit_Details__c = true;
            bdp.Funding_Arrangement__c = 'ASO';
            bdpLst.add(bdp);
            AIA_Benefit_Design_Product__c  bdp1 = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp1.Has_Benefit_Details__c = true;
            bdp1.Funding_Arrangement__c = 'Risk';
            bdpLst.add(bdp1);
            insert bdpLst;

            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where Id =:bdp.Id limit 1];
            System.assertEquals(bdpObj!= null,true);

            AIA_Grouper__c ag1 = new AIA_Grouper__c();
            ag1.Name = 'CostShareRanges';
            ag1.Group_Type__c = 'Benefit Group';
            ag1.Benefit_Design_Product__c = bdpObj.id;
            ag1.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
            ag1.Sequence_Number__c = 1;
            ag1.Proposed_Products__c = pp.id;
            insert ag1;


            AIA_Benefits__c ab = new AIA_Benefits__c();           
            ab.Grouper__c = ag1.id;
            ab.Benefit_Name__c = 'Family Out Of Pocket';
            ab.Benefit_Type__c = 'Mandate';
            ab.Benefit_Summary_Comment__c='test comment';//mod
            ab.Type__c = 'Cost Share';           
            ab.Benefit_Record_Type__c = 'BRF';
            ab.Cost_Share_Low__c = '0';
            ab.Cost_Share_High__c = '100';
            ab.Cost_Share_Increment__c = '10';
            ab.Cost_Share_InvalidIncrements__c = '30';
            ab.Cost_Share_AdditionalIncrements__c = '33';
            ab.OON_Cost_Share_Low__c = '0';
            ab.OON_Cost_Share_High__c = '1000';
            ab.OON_Cost_Share_Increment__c = '100';
            ab.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab.OON_Cost_Share_InvalidIncrements__c = '300';
            ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab.Copay_Type_1_IsCovered__c = 'No';
            ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab.Copay_Type_1_AliasName__c='Test';
            ab.Copay_Type_2_AliasName__c='Test';
            ab.OON_Copay_Type_1_AliasName__c='Test';
            ab.OON_Copay_Type_2_AliasName__c='Test';
            insert ab;  

            AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
            pn.ExtID__c = '33r34t33dr';
            pn.Plan__c=plan.id;
            pn.Record_Type__c='BDD';

            insert pn;

            AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
            apg.ExtID__c =  '33r34t33dr';
            apg.ISExisting_Grouper__c = true;  
            apg.Plan__c = plan.id;
            apg.Record_Type__c = 'BDD';
            apg.Plan_Grouper_Name__c = '2233df';
            apg.Plan_Network__c = pn.id;
            //apg.Type__c = 'Benefit Group ';
            apg.Sequence_Number__c = 1;
            insert apg;  
            AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c(); 
            //apbt.Parent_Benefit_Name__c =  
            apbt.Benefit_Name__c ='wdwd';
            apbt.Benefit_Group__c = apg.id;
            apbt.Record_Type__c = 'BDD';
            apbt.IS_ASO_Only__c='No';
            //apbt.Name =
            apbt.Sequence_Number__c = 1;
            apbt.Coinsurance_DefaultAmount__c = '2323';   
            apbt.ISExisting_Benefit__c = True;
            apbt.Type__c='Benefit';

            insert apbt;

            List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
            AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
            apcty1.Plan_Benefits__c = apbt.id; 
            apcty1.DeductibleApplies__c = 'Yes';
            apcty1.AliasName__c = 'fhf';
            apcty1.IsCovered__c= 'Yes';
            apcty1.MandateIndicator__c='No';
            apcty1.CoinsuranceAmount__c='345';
            apcty1.Jurisdiction__c='gfhjh';
            apcty1.CopayAmount__c='67yuh';
            apcty1.MinPayAmount__c ='900';
            apcty1.MaxPayAmount__c='89';
            planCopyLst.add(apcty1);


            AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
            apcty.Plan_Benefits__c = apbt.id; 
            apcty.DeductibleApplies__c = 'Yes';
            apcty.AliasName__c = 'fhf';
            apcty.IsCovered__c= 'Yes';
            apcty.MandateIndicator__c='No';
            apcty.CoinsuranceAmount__c='345';
            apcty.Jurisdiction__c='gfhjh';
            apcty.CopayAmount__c='67yuh';
            apcty.MinPayAmount__c ='900';
            apcty.MaxPayAmount__c='89';
            planCopyLst.add(apcty);
            insert planCopyLst;     

            List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
            AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
            apl.Plan_Benefits__c = apbt.id;
            apl.MaxAgeType__c = 'Days';
            apl.Type__c = 'TierLimit';
            apl.Jurisdiction__c = 'Federal';
            apl.TierLimitType__c = 'Days';
            apl.MandateIndicator__c = false;
            apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
            apl.TierLimitDurationType__c = 'Lifetime'; 
            apl.MaxAgeTo__c = 23;
            apl.MaxValue__c = 33;
            apl.TierAgeTo__c = 33;
            apl.TierLimitFrom__c = 2;
            apl.TierAgeType__c = 'Years';
            apl.TierAgeFrom__c = 23;
            apl.TierLimitTo__c = 44;
            apl.MaxApply__c = 'Per Breast';
            apl.MaxType__c = 'Dollars';
            apl.MaxDuration__c = 2;
            apl.MaxDurationType__c = 'Day';
            apl.MaxAgeFrom__c = 3;
            apl.Effective_Date__c=Date.today().addDays(-10);
            apl.Term_Date__c=Date.today().addDays(10);
            planList.add(apl);


            AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
            aplObj.Plan_Benefits__c = apbt.id;
            aplObj.MaxAgeType__c = 'Days';
            aplObj.Type__c = 'MaxRow';
            aplObj.Jurisdiction__c = 'Federal';
            aplObj.TierLimitType__c = 'Days';
            aplObj.MandateIndicator__c = false;
            aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
            aplObj.TierLimitDurationType__c = 'Lifetime'; 
            aplObj.MaxAgeTo__c = 23;
            aplObj.MaxValue__c = 33;
            aplObj.TierAgeTo__c = 33;
            aplObj.TierLimitFrom__c = 2;
            aplObj.TierAgeType__c = 'Years';
            aplObj.TierAgeFrom__c = 23;
            aplObj.TierLimitTo__c = 44;
            aplObj.MaxApply__c = 'Per Breast';
            aplObj.MaxType__c = 'Dollars';
            aplObj.MaxDuration__c = 2;
            aplObj.MaxDurationType__c = 'Day';
            aplObj.MaxAgeFrom__c = 3;
            aplObj.Effective_Date__c=Date.today().addDays(-10);
            aplObj.Term_Date__c=Date.today().addDays(10);
            planList.add(aplObj);
            insert planList;



            List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
            AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc.Plan_Limitation__c = planList[0].id;
            apbcc.Code__c = 2323;
            apbcc.Comment__c = 'ewfweger';
            apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
            pbCCodeList.add(apbcc);
            AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc1.Plan_Limitation__c = planList[1].id;
            apbcc1.Code__c = 2323;
            apbcc1.Comment__c = 'ewfweger';
            apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
            pbCCodeList.add(apbcc1);
            AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
            //apbcc2.Plan_Limitation__c = planList[0].id;
            apbcc2.Code__c = 2323;
            apbcc2.Comment__c = 'ewfweger';
            //apbcc2.Plan_Copay_Type__c = apcty.id;
            pbCCodeList.add(apbcc2);
            insert pbCCodeList;

            Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
            lmt.Benefit__c = ab.id;
            lmt.Type__c='MaxRow';
            insert lmt;
            Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
            lmt.Benefit__c = ab.id;
            insert lmt2;

            Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
            lmt.Benefit__c = ab.id;
            insert lmt3;

            AIA_benefitDesign_SummaryController.BenifitsrWrapper bwrap = new AIA_benefitDesign_SummaryController.BenifitsrWrapper();
            bwrap.benifitNameStr = 'ABCD';
            bwrap.benifitlmt = '232';

            bwrap.MaxPlanCodelst.add(apbcc);
            bwrap.maxPlan = '223';
            bwrap.GrpName = 'CostShareRanges';
            bwrap.madateCheck = True;
            bwrap.tierPlan = '2';

            bwrap.lstPlanlimit.add(apl);
            //List<Limitations__c> limlist = new List<Limitations__c>();
            bwrap.lstlimit.add(lmt);
            bwrap.aiaBenifitObj= ab;
            //List<AIA_benefitDesign_SummaryController.NetworkTypeWrapper> nwlist = new List<AIA_benefitDesign_SummaryController.NetworkTypeWrapper>();
            AIA_benefitDesign_SummaryController.NetworkTypeWrapper nwwrap = new AIA_benefitDesign_SummaryController.NetworkTypeWrapper();
            //nwwrap.networkTypeStr = '545';
            nwwrap.benifitNetworkObj = apbt;
            nwwrap.copayTypeForDrugObj= apcty;
            AIA_benefitDesign_SummaryController.CopayTypeWrapper xyz = new AIA_benefitDesign_SummaryController.CopayTypeWrapper();
            xyz.copayTypeSelectedObj = apcty; 
            xyz.copayTypePecSpecObj = apcty;
            xyz.copayTypeSelectedObj2 = apcty;
            xyz.copayTypePecSpecObj2 = apcty;

            nwwrap.copayTypeWrapObj = xyz;

            bwrap.networkWrapList.add(nwwrap);
            bwrap.copayTypeWrapObj = xyz;


            AIA_benefitDesign_SummaryController.GrouperWrapper wrap = new AIA_benefitDesign_SummaryController.GrouperWrapper();
            wrap.aiaGrouper = ag;
            wrap.grouperObj = apg;
            wrap.benifitWrapList.add(bwrap);
            wrap.INpcpVal = 'bhuv';
            wrap.INspcpVal = 'dxcv';
            wrap.OutpcpVal ='cfvg';
            wrap.OutspcpVal ='xdcfv';

            list<AIA_benefitDesign_SummaryController.GrouperWrapper> grprwr = new list<AIA_benefitDesign_SummaryController.GrouperWrapper>();

            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdpObj.id);
            System.currentPageReference().getParameters().put('idValue',pp.id);                        

            ApexPages.StandardController con = new ApexPages.StandardController(bdpObj);
            AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);

            AIA_Plan_Grouper__c grprListToClr = [Select id, Name, Sequence_Number__c,Record_Type__c,ISExisting_Grouper__c, Plan_Network__c,Type__c, Plan_Network__r.Name 
                                                 From AIA_Plan_Grouper__c  limit 1];
            system.assertEquals(grprListToClr!=null,true);
            //system.assertEquals(grprListToClr.Type__c ,'Benefit Group');                                     
            grprListToClr.Type__c = 'Benefit Group';
            update grprListToClr;
            String  planIdStr = String.valueof(bdpObj.Plan_Name__c).left(15);
            ext.getGroupersFromPlan(planIdStr,'BDD');
            ext.getBenefitsForPlan(planIdStr,'BDD');
            ext.createWrapListFromPlan(bdpObj);
            ext.pp = bdpObj;
            ext.grouperWrapList.add(wrap);
            ext.isPCScallReq(plan);
            ext.hasBnftSumry(plan);
            //Commenting as part of US1650
            //ext.getPCSdata();
            ext.mainInit(); 
            ext.reviewInit();
            ext.saveandRedirct();
            bdpObj.Has_Benefit_Details__c = false;
            bdpObj.Funding_Arrangement__c = 'Risk';
            update bdpObj;

            AIA_Benefit_Design_Product__c bdpUpdateObj = [Select Id,Product_Category__c,Has_Benefit_Details__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                          From AIA_Benefit_Design_Product__c where Id =:bdpObj.Id limit 1];

            //ext.SaveAndContinuePlanBenefits(bdpObj);
            EXT.createWrapListFromPlan(bdpUpdateObj);
            ext.createListFromPP(bdpUpdateObj.id,false);
            ext.createListFromPP(bdpUpdateObj.id,true);
            ext.back();
            ext.SaveAndContinuePlanBenefits(bdpUpdateObj);
            ext.saveAndCon();
            ext.saveAndContemp();
            ext.dispatcherTemp();

            test.stoptest();      
        }

        public Static TestMethod void TestAIA_BenefitDesign_SummaryControllerForGrouper(){

            //Removing a sper US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/

             // Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            //mod by off
             Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
            //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
            /*R1 added teammember*/ 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
            /*R1 added teammember*/
            //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
            insert acctMbrList;
            //end
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
            //o.Workplan_Type__c = wpt.id;//as per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;




            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
           // brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            //  aiapln.Has_Benefit_Summary__c = True;
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            insert aiapln;

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
            pp.Has_Benefit_Details__c =True;
            pp.Rider__c='None';
            insert pp;
            test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            ag.Group_Type__c = 'Benefit Group';
            //ag.Benefit_Design_Product__c = 
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();

            ag.Proposed_Products__c = pp.id;
            insert ag;

            /*            
          AIA_Benefits__c ab = new AIA_Benefits__c();           
                ab.Grouper__c = ag.id;
                ab.Benefit_Name__c = 'Family Out Of Pocket';
                ab.Benefit_Type__c = 'Mandate';
                ab.Type__c = 'Cost Share';           
                ab.Benefit_Record_Type__c = 'BRF';
                ab.Cost_Share_Low__c = '0';
                ab.Cost_Share_High__c = '100';
                ab.Cost_Share_Increment__c = '10';
                ab.Cost_Share_InvalidIncrements__c = '30';
                ab.Cost_Share_AdditionalIncrements__c = '33';
                ab.OON_Cost_Share_Low__c = '0';
                ab.OON_Cost_Share_High__c = '1000';
                ab.OON_Cost_Share_Increment__c = '100';
                ab.OON_Cost_Share_AdditionalIncrements__c = '330';
                ab.OON_Cost_Share_InvalidIncrements__c = '300';
                ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
                ab.Copay_Type_1_IsCovered__c = 'No';
                ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
                ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
                ab.Copay_Type_1_AliasName__c='Test';
                ab.Copay_Type_2_AliasName__c='Test';
                ab.OON_Copay_Type_1_AliasName__c='Test';
                ab.OON_Copay_Type_2_AliasName__c='Test';
                insert ab;  
             */
            List<AIA_Benefits__c> aiabenList = new List<AIA_Benefits__c>();
            AIA_Benefits__c ab2 = new AIA_Benefits__c();           
            ab2.Grouper__c = ag.id;
            ab2.Benefit_Name__c = 'Test Benefit';
            ab2.Benefit_Type__c = 'Mandate';
            ab2.Type__c = 'Benefit';           
            ab2.Benefit_Record_Type__c = 'BRF';
            ab2.Cost_Share_Low__c = '0';
            ab2.Cost_Share_High__c = '100';
            ab2.Cost_Share_Increment__c = '10';
            ab2.Cost_Share_InvalidIncrements__c = '30';
            ab2.Cost_Share_AdditionalIncrements__c = '33';
            ab2.OON_Cost_Share_Low__c = '0';
            ab2.OON_Cost_Share_High__c = '1000';
            ab2.OON_Cost_Share_Increment__c = '100';
            ab2.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab2.OON_Cost_Share_InvalidIncrements__c = '300';
            ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab2.Copay_Type_1_IsCovered__c = 'No';
            ab2.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab2.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab2.Copay_Type_1_AliasName__c='Test';
            ab2.Copay_Type_2_AliasName__c='Test';
            ab2.OON_Copay_Type_1_AliasName__c='Test';
            ab2.OON_Copay_Type_2_AliasName__c='Test';
            aiabenList.add(ab2);
            AIA_Benefits__c ab3 = new AIA_Benefits__c();           
            ab3.Grouper__c = ag.id;
            ab3.Benefit_Name__c = 'Test Benefit';
            ab3.Benefit_Type__c = 'Benefit';
            ab3.Type__c = 'Benefit';           
            ab3.Benefit_Record_Type__c = 'BRF';
            ab3.Cost_Share_Low__c = '0';
            ab3.Cost_Share_High__c = '100';
            ab3.Cost_Share_Increment__c = '10';
            ab3.Cost_Share_InvalidIncrements__c = '30';
            ab3.Cost_Share_AdditionalIncrements__c = '33';
            ab3.OON_Cost_Share_Low__c = '0';
            ab3.OON_Cost_Share_High__c = '1000';
            ab3.OON_Cost_Share_Increment__c = '100';
            ab3.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab3.OON_Cost_Share_InvalidIncrements__c = '300';
            ab3.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab3.Copay_Type_1_IsCovered__c = 'No';
            ab3.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab3.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab3.Copay_Type_1_AliasName__c='Test';
            ab3.Copay_Type_2_AliasName__c='Test';
            ab3.OON_Copay_Type_1_AliasName__c='Test';
            ab3.OON_Copay_Type_2_AliasName__c='Test';
            aiabenList.add(ab3);
            insert aiabenList;



       /*     Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];

            User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB123RF@testorg.com.test');
            insert u;

            User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF121@testorg.com.test');
            insert u1;

            User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF222@testorg.com.test');
            insert u2;

            User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBR12F3@testorg.com.test');
            insert u3;

            User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB3RF4@testorg.com.test');
            insert u4;

            User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUse12rBRF5@testorg.com.test');
            insert u5;

            User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingU21serBRF6@testorg.com.test');
            insert u6;

            User u7 = new User(Alias = 'TAlias7', Email='TestUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Testin11gUserBRF7@testorg.com.test');
            insert u7;

            User u8 = new User(Alias = 'TAla87', Email='T76estUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSery67', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Test76564in11gUserBRF7@testorg.com.test');
            insert u8;

            User u9 = new User(Alias = 'TAli97', Email='Te5467stUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer776', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te75stin11gUserBRF7@testorg.com.test');
            insert u9;


            User u10 = new User(Alias = 'TA197', Email='Te10e11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='Testing1076', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te10gUserBRF7@testorg.com.test');
            insert u10;

            AccountTeamMember atmRole = new AccountTeamMember ();
            atmRole.TeamMemberRole = 'BeneFact Coder';
            atmRole.AccountId = acc.id;
            atmRole.UserId = u.id;
            insert atmRole;

            AccountTeamMember atm1 = new AccountTeamMember ();
            atm1.TeamMemberRole = 'Account Manager';
            atm1.AccountId =acc.id;
            atm1.UserId = u1.id;
            insert atm1;

            AccountTeamMember atmRole1 = new AccountTeamMember ();
            atmRole1.TeamMemberRole = 'Implementation Manager';
            atmRole1.AccountId = acc.id;
            atmRole1.UserId = u2.id;
            insert atmRole1;
            system.assertNotEquals(null,atmRole1.id);

            AccountTeamMember atmRole2 = new AccountTeamMember ();
            atmRole2.TeamMemberRole = 'Settlements';
            atmRole2.AccountId = acc.id;
            atmRole2.UserId = u3.id;
            insert atmRole2;

            AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Billing Tech';
            atmRole3.AccountId = acc.id;
            atmRole3.UserId = u4.id;
            insert atmRole3;

            AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'Audit';
            atmRole4.AccountId = acc.id;
            atmRole4.UserId = u5.id;
            insert atmRole4;

            AccountTeamMember atmRole5 = new AccountTeamMember ();
            atmRole5.TeamMemberRole = 'QA Auditor';
            atmRole5.AccountId = acc.id;
            atmRole5.UserId = u6.id;
            insert atmRole5;


            AccountTeamMember atmRole61 = new AccountTeamMember ();
            atmRole61.TeamMemberRole = 'Contract Tech';
            atmRole61.AccountId = acc.id;
            atmRole61.UserId = u7.id;
            insert atmRole61;        

            AccountTeamMember atmRole62 = new AccountTeamMember ();
            atmRole62.TeamMemberRole = 'Ancillary Analyst';
            atmRole62.AccountId = acc.id;
            atmRole62.UserId = u8.id;
            insert atmRole62;        

            AccountTeamMember atmRole6 = new AccountTeamMember ();
            atmRole6.TeamMemberRole = 'NASCO Benefit Coder';
            atmRole6.AccountId = acc.id;
            atmRole6.UserId = u9.id;
            insert atmRole6;        

            AccountTeamMember atmRole15 = new AccountTeamMember ();
            atmRole15.TeamMemberRole = 'MAST Tech';
            atmRole15.AccountId = acc.id;
            atmRole15.UserId = u10.id;
            insert atmRole15; */


            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = acc.id;
            Imp.Account__c = Imp.Opportunity__r.AccountId;
            //Imp.Generate_Workplan_Stages__c = true;//as per US210
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            insert Imp;

            AIA_Benefit_Design__c aiabd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

            AIA_Plan__c plan = AIA_TestUtil.CreateGSMPlan('Medical','xyz');
            plan.Has_Benefit_Summary__c = true;
            plan.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            plan.Jurisdiction__c = 'MD';
            plan.BDF_Configuration_Last_Updated__c  = null;
            insert plan;
            List<AIA_Benefit_Design_Product__c > bdpLst = new List<AIA_Benefit_Design_Product__c >();

            AIA_Benefit_Design_Product__c  bdp = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp.Has_Benefit_Details__c = true;
            bdp.Funding_Arrangement__c = 'ASO';
            bdpLst.add(bdp);
            AIA_Benefit_Design_Product__c  bdp1 = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp1.Has_Benefit_Details__c = true;
            bdp1.Funding_Arrangement__c = 'Risk';
            bdpLst.add(bdp1);
            insert bdpLst;

            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where Id =:bdp.Id limit 1];
            System.assertEquals(bdpObj!= null,true);

            AIA_Grouper__c ag1 = new AIA_Grouper__c();
            ag1.Name = 'CostShareRanges';
            ag1.Group_Type__c = 'Benefit Group';
            ag1.Benefit_Design_Product__c = bdpObj.id;
            ag1.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
            ag1.Sequence_Number__c = 1;
            ag1.Proposed_Products__c = pp.id;
            insert ag1;


            AIA_Benefits__c ab = new AIA_Benefits__c();           
            ab.Grouper__c = ag1.id;
            ab.Benefit_Name__c = 'Family Out Of Pocket';
            ab.Benefit_Type__c = 'Mandate';
            ab.Benefit_Summary_Comment__c='test comment';//mod
            ab.Type__c = 'Cost Share';           
            ab.Benefit_Record_Type__c = 'BRF';
            ab.Cost_Share_Low__c = '0';
            ab.Cost_Share_High__c = '100';
            ab.Cost_Share_Increment__c = '10';
            ab.Cost_Share_InvalidIncrements__c = '30';
            ab.Cost_Share_AdditionalIncrements__c = '33';
            ab.OON_Cost_Share_Low__c = '0';
            ab.OON_Cost_Share_High__c = '1000';
            ab.OON_Cost_Share_Increment__c = '100';
            ab.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab.OON_Cost_Share_InvalidIncrements__c = '300';
            ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab.Copay_Type_1_IsCovered__c = 'No';
            ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab.Copay_Type_1_AliasName__c='Test';
            ab.Copay_Type_2_AliasName__c='Test';
            ab.OON_Copay_Type_1_AliasName__c='Test';
            ab.OON_Copay_Type_2_AliasName__c='Test';
            insert ab;  

            AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
            pn.ExtID__c = '33r34t33dr';
            pn.Plan__c=plan.id;
            pn.Record_Type__c='BDD';

            insert pn;

            AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
            apg.ExtID__c =  '33r34t33dr';
            apg.ISExisting_Grouper__c = true;  
            apg.Plan__c = plan.id;
            apg.Record_Type__c = 'BDD';
            apg.Plan_Grouper_Name__c = '2233df';
            apg.Plan_Network__c = pn.id;
            //apg.Type__c = 'Benefit Group ';
            apg.Sequence_Number__c = 1;
            insert apg;  
            AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c(); 
            //apbt.Parent_Benefit_Name__c =  
            apbt.Benefit_Name__c ='wdwd';
            apbt.Benefit_Group__c = apg.id;
            apbt.Record_Type__c = 'BDD';
            apbt.IS_ASO_Only__c='No';
            //apbt.Name =
            apbt.Sequence_Number__c = 1;
            apbt.Coinsurance_DefaultAmount__c = '2323';   
            apbt.ISExisting_Benefit__c = True;
            apbt.Type__c='Benefit';

            insert apbt;

            List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
            AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
            apcty1.Plan_Benefits__c = apbt.id; 
            apcty1.DeductibleApplies__c = 'Yes';
            apcty1.AliasName__c = 'fhf';
            apcty1.IsCovered__c= 'Yes';
            apcty1.MandateIndicator__c='Yes';
            apcty1.CoinsuranceAmount__c='345';
            apcty1.Jurisdiction__c='gfhjh';
            apcty1.CopayAmount__c='67yuh';
            apcty1.MinPayAmount__c ='900';
            apcty1.MaxPayAmount__c='89';
            planCopyLst.add(apcty1);


            AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
            apcty.Plan_Benefits__c = apbt.id; 
            apcty.DeductibleApplies__c = 'Yes';
            apcty.AliasName__c = 'fhf';
            apcty.IsCovered__c= 'Yes';
            apcty.MandateIndicator__c='No';
            apcty.CoinsuranceAmount__c='345';
            apcty.Jurisdiction__c='gfhjh';
            apcty.CopayAmount__c='67yuh';
            apcty.MinPayAmount__c ='900';
            apcty.MaxPayAmount__c='89';
            planCopyLst.add(apcty);
            insert planCopyLst;     

            List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
            AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
            apl.Plan_Benefits__c = apbt.id;
            apl.MaxAgeType__c = 'Days';
            apl.Type__c = 'TierLimit';
            apl.Jurisdiction__c = 'Federal';
            apl.TierLimitType__c = 'Days';
            apl.MandateIndicator__c = true;
            apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
            apl.TierLimitDurationType__c = 'Lifetime'; 
            apl.MaxAgeTo__c = 23;
            apl.MaxValue__c = 33;
            apl.TierAgeTo__c = 33;
            apl.TierLimitFrom__c = 2;
            apl.TierAgeType__c = 'Years';
            apl.TierAgeFrom__c = 23;
            apl.TierLimitTo__c = 44;
            apl.MaxApply__c = 'Per Breast';
            apl.MaxType__c = 'Dollars';
            apl.MaxDuration__c = 2;
            apl.MaxDurationType__c = 'Day';
            apl.MaxAgeFrom__c = 3;
            apl.Effective_Date__c=Date.today().addDays(-10);
            apl.Term_Date__c=Date.today().addDays(10);
            planList.add(apl);


            AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
            aplObj.Plan_Benefits__c = apbt.id;
            aplObj.MaxAgeType__c = 'Days';
            aplObj.Type__c = 'MaxRow';
            aplObj.Jurisdiction__c = 'Federal';
            aplObj.TierLimitType__c = 'Days';
            aplObj.MandateIndicator__c = false;
            aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
            aplObj.TierLimitDurationType__c = 'Lifetime'; 
            aplObj.MaxAgeTo__c = 23;
            aplObj.MaxValue__c = 33;
            aplObj.TierAgeTo__c = 33;
            aplObj.TierLimitFrom__c = 2;
            aplObj.TierAgeType__c = 'Years';
            aplObj.TierAgeFrom__c = 23;
            aplObj.TierLimitTo__c = 44;
            aplObj.MaxApply__c = 'Per Breast';
            aplObj.MaxType__c = 'Dollars';
            aplObj.MaxDuration__c = 2;
            aplObj.MaxDurationType__c = 'Day';
            aplObj.MaxAgeFrom__c = 3;
            aplObj.Effective_Date__c=Date.today().addDays(-10);
            aplObj.Term_Date__c=Date.today().addDays(10);
            planList.add(aplObj);
            insert planList;



            List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
            AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc.Plan_Limitation__c = planList[0].id;
            apbcc.Code__c = 2323;
            apbcc.Comment__c = 'ewfweger';
            apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
            pbCCodeList.add(apbcc);
            AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc1.Plan_Limitation__c = planList[1].id;
            apbcc1.Code__c = 2323;
            apbcc1.Comment__c = 'ewfweger';
            apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
            pbCCodeList.add(apbcc1);
            AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
            //apbcc2.Plan_Limitation__c = planList[0].id;
            apbcc2.Code__c = 2323;
            apbcc2.Comment__c = 'ewfweger';
            //apbcc2.Plan_Copay_Type__c = apcty.id;
            pbCCodeList.add(apbcc2);
            insert pbCCodeList;

            Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
            lmt.Benefit__c = ab.id;
            lmt.Type__c='MaxRow';
            insert lmt;
            Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
            lmt.Benefit__c = ab.id;
            insert lmt2;

            Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
            lmt.Benefit__c = ab.id;
            insert lmt3;

            AIA_benefitDesign_SummaryController.BenifitsrWrapper bwrap = new AIA_benefitDesign_SummaryController.BenifitsrWrapper();
            bwrap.benifitNameStr = 'ABCD';
            bwrap.benifitlmt = '232';

            bwrap.MaxPlanCodelst.add(apbcc);
            bwrap.maxPlan = '223';
            bwrap.GrpName = 'CostShareRanges';
            bwrap.madateCheck = True;
            bwrap.tierPlan = '2';

            bwrap.lstPlanlimit.add(apl);
            //List<Limitations__c> limlist = new List<Limitations__c>();
            bwrap.lstlimit.add(lmt);
            bwrap.aiaBenifitObj= ab;
            //List<AIA_benefitDesign_SummaryController.NetworkTypeWrapper> nwlist = new List<AIA_benefitDesign_SummaryController.NetworkTypeWrapper>();
            AIA_benefitDesign_SummaryController.NetworkTypeWrapper nwwrap = new AIA_benefitDesign_SummaryController.NetworkTypeWrapper();
            //nwwrap.networkTypeStr = '545';
            nwwrap.benifitNetworkObj = apbt;
            nwwrap.copayTypeForDrugObj= apcty;
            AIA_benefitDesign_SummaryController.CopayTypeWrapper xyz = new AIA_benefitDesign_SummaryController.CopayTypeWrapper();
            xyz.copayTypeSelectedObj = apcty; 
            xyz.copayTypePecSpecObj = apcty;
            xyz.copayTypeSelectedObj2 = apcty;
            xyz.copayTypePecSpecObj2 = apcty;

            nwwrap.copayTypeWrapObj = xyz;

            bwrap.networkWrapList.add(nwwrap);
            bwrap.copayTypeWrapObj = xyz;


            AIA_benefitDesign_SummaryController.GrouperWrapper wrap = new AIA_benefitDesign_SummaryController.GrouperWrapper();
            wrap.aiaGrouper = ag;
            wrap.grouperObj = apg;
            wrap.benifitWrapList.add(bwrap);
            wrap.INpcpVal = 'bhuv';
            wrap.INspcpVal = 'dxcv';
            wrap.OutpcpVal ='cfvg';
            wrap.OutspcpVal ='xdcfv';

            list<AIA_benefitDesign_SummaryController.GrouperWrapper> grprwr = new list<AIA_benefitDesign_SummaryController.GrouperWrapper>();

            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdpObj.id);
            System.currentPageReference().getParameters().put('idValue',pp.id);                        

            ApexPages.StandardController con = new ApexPages.StandardController(bdpObj);
            AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);

            AIA_Plan_Grouper__c grprListToClr = [Select id, Name, Sequence_Number__c,Record_Type__c,ISExisting_Grouper__c, Plan_Network__c,Type__c, Plan_Network__r.Name 
                                                 From AIA_Plan_Grouper__c  limit 1];
            system.assertEquals(grprListToClr!=null,true);
            //system.assertEquals(grprListToClr.Type__c ,'Benefit Group');                                     
            grprListToClr.Type__c = 'Benefit Group';
            update grprListToClr;
            String  planIdStr = String.valueof(bdpObj.Plan_Name__c).left(15);
            ext.getGroupersFromPlan(planIdStr,'BDD');
            ext.getBenefitsForPlan(planIdStr,'BDD');
            ext.createWrapListFromPlan(bdpObj);
            ext.pp = bdpObj;
            ext.grouperWrapList.add(wrap);
            ext.isPCScallReq(plan);
            ext.hasBnftSumry(plan);
            //Commenting as part of US1650
            //ext.getPCSdata();
            ext.mainInit(); 
            ext.reviewInit();
            ext.saveandRedirct();
            bdpObj.Has_Benefit_Details__c = false;
            bdpObj.Funding_Arrangement__c = 'Risk';
            update bdpObj;

            AIA_Benefit_Design_Product__c bdpUpdateObj = [Select Id,Product_Category__c,Has_Benefit_Details__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                          From AIA_Benefit_Design_Product__c where Id =:bdpObj.Id limit 1];

            //ext.SaveAndContinuePlanBenefits(bdpObj);
            EXT.createWrapListFromPlan(bdpUpdateObj);
            ext.createListFromPP(bdpUpdateObj.id,false);
            ext.createListFromPP(bdpUpdateObj.id,true);
            ext.back();
            ext.SaveAndContinuePlanBenefits(bdpUpdateObj);
            ext.saveAndCon();
            ext.saveAndContemp();
            ext.dispatcherTemp();

            test.stoptest();      
        }



        public static void createPlanData( AIA_Plan__c aiapln){

            AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
            pn.ExtID__c = 'PLAN-001N_BDD1';
            pn.Name = 'InNetwork';
            pn.Plan__c = aiapln.id;
            insert pn;

            AIA_Plan_Network__c pn2 = new AIA_Plan_Network__c();
            pn2.ExtID__c = 'PLAN-001N_BDD12';
            pn2.Name = 'OutNetwork';
            pn2.Plan__c = aiapln.id;
            insert pn2;

            AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
            pg.Name = 'CostShareRanges';
            pg.Plan_Network__c = pn.id;
            pg.Type__c = 'Cost Share Group';
            pg.Record_Type__c = 'BDD';
            pg.ExtID__c = 'PLAN-001N_BDD1CSG_BDD00';
            insert pg;

            AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
            pg2.Name = 'CostShareRanges';
            pg2.Plan_Network__c = pn2.id;
            pg2.Type__c = 'Cost Share Group';
            pg2.Record_Type__c = 'BDD';
            pg2.ExtID__c = 'PLAN-001N_BDD1CSG_BDD002';
            insert pg2;

            AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
            pg3.Name = 'Medical Supplies/Equipment-0628';
            pg3.Plan_Network__c = pn.id;
            pg3.Type__c = 'Benefit Group';
            pg3.Sequence_Number__c = 1;
            pg3.Record_Type__c = 'BDD';
            pg3.ExtID__c = 'PLAN-001N_BDD1CSG_BDD00432';
            insert pg3;

            AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
            pg4.Name = 'Medical Supplies/Equipment-0629';
            pg4.Plan_Network__c = pn2.id;
            pg4.Type__c = 'Benefit Group';
            pg4.Sequence_Number__c = 1;
            pg4.Record_Type__c = 'BDD';
            pg4.ExtID__c = 'PLAN-001N_BDD1CSG_BDD002433';
            insert pg4;

            AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
            pb.Benefit_Name__c = 'OutOfPocket_Individual';
            pb.Record_Type__c = 'BDD';
            pb.Type__c = 'Benefit';
            pb.Benefit_Group__c = pg3.id;
            pb.Cost_Share_Low__c = '0';
            pb.Cost_Share_High__c = '100';
            pb.Cost_Share_Increment__c = '10';
            pb.Cost_Share_Default_Amount__c = '40';
            pb.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb.Cost_Share_InvalidIncrements__c = '20, 30';
            pb.Sequence_Number__c = 1;
            insert pb;

            AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
            pb29.Benefit_Name__c = '';
            pb29.Record_Type__c = 'BDD';
            pb29.Type__c = 'Benefit';
            pb29.Benefit_Group__c = pg4.id;
            pb29.Cost_Share_Low__c = '0';
            pb29.Cost_Share_High__c = '100';
            pb29.Cost_Share_Increment__c = '10';
            pb29.Cost_Share_Default_Amount__c = '40';
            pb29.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb29.Cost_Share_InvalidIncrements__c = '20, 30';
            pb29.Sequence_Number__c = 1;
            insert pb29;

            AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
            pb2.Benefit_Name__c = 'OutOfPocket_Family';
            pb2.Record_Type__c = 'BDD';
            pb2.Type__c = 'Cost Share';
            pb2.Benefit_Group__c = pg.id;
            pb2.Cost_Share_Low__c = '0';
            pb2.Cost_Share_High__c = '100';
            pb2.Cost_Share_Increment__c = '10';
            pb2.Cost_Share_Default_Amount__c = '40';
            pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb2.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb2;

            AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
            pb3.Benefit_Name__c = 'OutOfPocket_Single';
            pb3.Record_Type__c = 'BDD';
            pb3.Type__c = 'Cost Share';
            pb3.Benefit_Group__c = pg.id;
            pb3.Cost_Share_Low__c = '0';
            pb3.Cost_Share_High__c = '100';
            pb3.Cost_Share_Increment__c = '10';
            pb3.Cost_Share_Default_Amount__c = '40';
            pb3.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb3.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb3;

            AIA_Plan_Benefits__c pb4 = new AIA_Plan_Benefits__c();
            pb4.Benefit_Name__c = 'Deductible_Individual';
            pb4.Record_Type__c = 'BDD';
            pb4.Type__c = 'Cost Share';
            pb4.Benefit_Group__c = pg.id;
            pb4.Cost_Share_Low__c = '0';
            pb4.Cost_Share_High__c = '100';
            pb4.Cost_Share_Increment__c = '10';
            pb4.Cost_Share_Default_Amount__c = '40';
            pb4.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb4.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb4;

            AIA_Plan_Benefits__c pb5 = new AIA_Plan_Benefits__c();
            pb5.Benefit_Name__c = 'Deductible_Family';
            pb5.Record_Type__c = 'BDD';
            pb5.Type__c = 'Cost Share';
            pb5.Benefit_Group__c = pg.id;
            pb5.Cost_Share_Low__c = '0';
            pb5.Cost_Share_High__c = '100';
            pb5.Cost_Share_Increment__c = '10';
            pb5.Cost_Share_Default_Amount__c = '40';
            pb5.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb5.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb5;

            AIA_Plan_Benefits__c pb6 = new AIA_Plan_Benefits__c();
            pb6.Benefit_Name__c = 'Deductible_Single';
            pb6.Record_Type__c = 'BDD';
            pb6.Type__c = 'Cost Share';
            pb6.Benefit_Group__c = pg.id;
            pb6.Cost_Share_Low__c = '0';
            pb6.Cost_Share_High__c = '100';
            pb6.Cost_Share_Increment__c = '10';
            pb6.Cost_Share_Default_Amount__c = '40';
            pb6.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb6.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb6;

            AIA_Plan_Benefits__c pb7 = new AIA_Plan_Benefits__c();
            pb7.Benefit_Name__c = 'DeductibleCarryOver';
            pb7.Record_Type__c = 'BDD';
            pb7.Type__c = 'Cost Share';
            pb7.Benefit_Group__c = pg.id;
            pb7.Cost_Share_Low__c = '0';
            pb7.Cost_Share_High__c = '100';
            pb7.Cost_Share_Increment__c = '10';
            pb7.Cost_Share_Default_Amount__c = '40';
            pb7.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb7.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb7;

            AIA_Plan_Benefits__c pb8 = new AIA_Plan_Benefits__c();
            pb8.Benefit_Name__c = 'LifetimeMax_Single';
            pb8.Record_Type__c = 'BDD';
            pb8.Type__c = 'Cost Share';
            pb8.Benefit_Group__c = pg.id;
            pb8.Cost_Share_Low__c = '0';
            pb8.Cost_Share_High__c = '100';
            pb8.Cost_Share_Increment__c = '10';
            pb8.Cost_Share_Default_Amount__c = '40';
            pb8.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb8.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb8;

            AIA_Plan_Benefits__c pb9 = new AIA_Plan_Benefits__c();
            pb9.Benefit_Name__c = 'Copay_PCPCopay';
            pb9.Record_Type__c = 'BDD';
            pb9.Type__c = 'Cost Share';
            pb9.Benefit_Group__c = pg.id;
            pb9.Cost_Share_Low__c = '0';
            pb9.Cost_Share_High__c = '100';
            pb9.Cost_Share_Increment__c = '10';
            pb9.Cost_Share_Default_Amount__c = '40';
            pb9.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb9.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb9;

            AIA_Plan_Benefits__c pb10 = new AIA_Plan_Benefits__c();
            pb10.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb10.Record_Type__c = 'BDD';
            pb10.Type__c = 'Cost Share';
            pb10.Benefit_Group__c = pg.id;
            pb10.Cost_Share_Low__c = '0';
            pb10.Cost_Share_High__c = '100';
            pb10.Cost_Share_Increment__c = '10';
            pb10.Cost_Share_Default_Amount__c = '40';
            pb10.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb10.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb10;

            AIA_Plan_Benefits__c pb11 = new AIA_Plan_Benefits__c();
            pb11.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb11.Record_Type__c = 'BDD';
            pb11.Type__c = 'Cost Share';
            pb11.Benefit_Group__c = pg.id;
            pb11.Cost_Share_Low__c = '0';
            pb11.Cost_Share_High__c = '100';
            pb11.Cost_Share_Increment__c = '10';
            pb11.Cost_Share_Default_Amount__c = '40';
            pb11.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb11.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb11;

            AIA_Plan_Benefits__c pb13 = new AIA_Plan_Benefits__c();
            pb13.Benefit_Name__c = 'OutOfPocket_Individual';
            pb13.Record_Type__c = 'BDD';
            pb13.Type__c = 'Cost Share';
            pb13.Benefit_Group__c = pg2.id;
            pb13.Cost_Share_Low__c = '0';
            pb13.Cost_Share_High__c = '100';
            pb13.Cost_Share_Increment__c = '10';
            pb13.Cost_Share_Default_Amount__c = '40';
            pb13.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb13.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb13;

            AIA_Plan_Benefits__c pb14 = new AIA_Plan_Benefits__c();
            pb14.Benefit_Name__c = 'OutOfPocket_Family';
            pb14.Record_Type__c = 'BDD';
            pb14.Type__c = 'Cost Share';
            pb14.Benefit_Group__c = pg2.id;
            pb14.Cost_Share_Low__c = '0';
            pb14.Cost_Share_High__c = '100';
            pb14.Cost_Share_Increment__c = '10';
            pb14.Cost_Share_Default_Amount__c = '40';
            pb14.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb14.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb14;

            AIA_Plan_Benefits__c pb15 = new AIA_Plan_Benefits__c();
            pb15.Benefit_Name__c = 'OutOfPocket_Single';
            pb15.Record_Type__c = 'BDD';
            pb15.Type__c = 'Cost Share';
            pb15.Benefit_Group__c = pg2.id;
            pb15.Cost_Share_Low__c = '0';
            pb15.Cost_Share_High__c = '100';
            pb15.Cost_Share_Increment__c = '10';
            pb15.Cost_Share_Default_Amount__c = '40';
            pb15.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb15.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb15;

            AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
            pb16.Benefit_Name__c = 'Deductible_Individual';
            pb16.Record_Type__c = 'BDD';
            pb16.Type__c = 'Cost Share';
            pb16.Benefit_Group__c = pg2.id;
            pb16.Cost_Share_Low__c = '0';
            pb16.Cost_Share_High__c = '100';
            pb16.Cost_Share_Increment__c = '10';
            pb16.Cost_Share_Default_Amount__c = '40';
            pb16.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb16.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb16;

            AIA_Plan_Benefits__c pb17 = new AIA_Plan_Benefits__c();
            pb17.Benefit_Name__c = 'Deductible_Family';
            pb17.Record_Type__c = 'BDD';
            pb17.Type__c = 'Cost Share';
            pb17.Benefit_Group__c = pg2.id;
            pb17.Cost_Share_Low__c = '0';
            pb17.Cost_Share_High__c = '100';
            pb17.Cost_Share_Increment__c = '10';
            pb17.Cost_Share_Default_Amount__c = '40';
            pb17.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb17.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb17;

            AIA_Plan_Benefits__c pb18 = new AIA_Plan_Benefits__c();
            pb18.Benefit_Name__c = 'Deductible_Single';
            pb18.Record_Type__c = 'BDD';
            pb18.Type__c = 'Cost Share';
            pb18.Benefit_Group__c = pg2.id;
            pb18.Cost_Share_Low__c = '0';
            pb18.Cost_Share_High__c = '100';
            pb18.Cost_Share_Increment__c = '10';
            pb18.Cost_Share_Default_Amount__c = '40';
            pb18.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb18.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb18;

            AIA_Plan_Benefits__c pb19 = new AIA_Plan_Benefits__c();
            pb19.Benefit_Name__c = 'DeductibleCarryOver';
            pb19.Record_Type__c = 'BDD';
            pb19.Type__c = 'Cost Share';
            pb19.Benefit_Group__c = pg2.id;
            pb19.Cost_Share_Low__c = '0';
            pb19.Cost_Share_High__c = '100';
            pb19.Cost_Share_Increment__c = '10';
            pb19.Cost_Share_Default_Amount__c = '40';
            pb19.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb19.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb19;

            AIA_Plan_Benefits__c pb20 = new AIA_Plan_Benefits__c();
            pb20.Benefit_Name__c = 'LifetimeMax_Single';
            pb20.Record_Type__c = 'BDD';
            pb20.Type__c = 'Cost Share';
            pb20.Benefit_Group__c = pg2.id;
            pb20.Cost_Share_Low__c = '0';
            pb20.Cost_Share_High__c = '100';
            pb20.Cost_Share_Increment__c = '10';
            pb20.Cost_Share_Default_Amount__c = '40';
            pb20.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb20.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb20;

            AIA_Plan_Benefits__c pb21 = new AIA_Plan_Benefits__c();
            pb21.Benefit_Name__c = 'Copay_PCPCopay';
            pb21.Record_Type__c = 'BDD';
            pb21.Type__c = 'Cost Share';
            pb21.Benefit_Group__c = pg2.id;
            pb21.Cost_Share_Low__c = '0';
            pb21.Cost_Share_High__c = '100';
            pb21.Cost_Share_Increment__c = '10';
            pb21.Cost_Share_Default_Amount__c = '40';
            pb21.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb21.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb21;

            AIA_Plan_Benefits__c pb22 = new AIA_Plan_Benefits__c();
            pb22.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb22.Record_Type__c = 'BDD';
            pb22.Type__c = 'Cost Share';
            pb22.Benefit_Group__c = pg2.id;
            pb22.Cost_Share_Low__c = '0';
            pb22.Cost_Share_High__c = '100';
            pb22.Cost_Share_Increment__c = '10';
            pb22.Cost_Share_Default_Amount__c = '40';
            pb22.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb22.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb22;

            AIA_Plan_Benefits__c pb23 = new AIA_Plan_Benefits__c();
            pb23.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb23.Record_Type__c = 'BDD';
            pb23.Type__c = 'Cost Share';
            pb23.Benefit_Group__c = pg2.id;
            pb23.Cost_Share_Low__c = '0';
            pb23.Cost_Share_High__c = '100';
            pb23.Cost_Share_Increment__c = '10';
            pb23.Cost_Share_Default_Amount__c = '40';
            pb23.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb23.Cost_Share_InvalidIncrements__c = '20, 30';
            insert pb23;        



            AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
            apc.Plan_Benefits__c = pb.id;
            apc.AliasName__c = 'PCP Copay';
            apc.CopayAmount__c = '200';
            apc.CoinsuranceAmount__c = '50';
            apc.MinPayAmount__c = '90';
            apc.MaxPayAmount__c = '80';
            apc.IsCovered__c = 'Yes';
            apc.DeductibleApplies__c = 'No';
            apc.MandateIndicator__c = 'No';
            apc.Jurisdiction__c = 'MD';
            apc.MandateName__c='Home health care ';
            apc.ExtID__c = 'rwuifghqierufghaire';
            insert apc;

            AIA_Plan_Copay_Type__c apc3 = new AIA_Plan_Copay_Type__c();
            apc3.Plan_Benefits__c = pb.id;
            apc3.AliasName__c = 'General Copay';
            apc3.CopayAmount__c = '200';
            apc3.CoinsuranceAmount__c = '50';
            apc3.MinPayAmount__c = '90';
            apc3.MaxPayAmount__c = '80';
            apc3.IsCovered__c = 'Yes';
            apc3.DeductibleApplies__c = 'No';
            apc3.MandateIndicator__c = 'No';
            apc3.Jurisdiction__c = 'MD';
            apc3.MandateName__c='Home health care ';
            apc3.ExtID__c = 'rwuifghqierufghaire';
            insert apc3;
            AIA_Plan_Copay_Type__c apc2 = new AIA_Plan_Copay_Type__c();
            apc2.Plan_Benefits__c = pb29.id;
            apc2.AliasName__c = 'General Copay';
            apc2.CopayAmount__c = '200';
            apc2.CoinsuranceAmount__c = '50';
            apc2.MinPayAmount__c = '90';
            apc2.MaxPayAmount__c = '80';
            apc2.IsCovered__c = 'Yes';
            apc2.DeductibleApplies__c = 'No';
            apc2.MandateIndicator__c = 'Yes';
            apc2.Jurisdiction__c = 'Federal';
            apc2.MandateName__c='PPACA mandate';
            apc2.ExtID__c = 'rwuifghqierufghaire';
            insert apc2;

            AIA_Plan_Limitation__c obj = new AIA_Plan_Limitation__c();
            obj.TierAgeFrom__c = 10;
            obj.TierAgeTo__c = 20;
            obj.TierAgeType__c = 'Years';
            obj.TierLimitDurationType__c = 'Plan Year';
            obj.TierLimitFrom__c = 30;
            obj.TierLimitTo__c = 50;
            obj.TierLimitType__c = 'Days';
            obj.Type__c = 'TierLimit';
            obj.Plan_Benefits__c = pb.id;
            obj.MandateIndicator__c = True;
            insert obj;

            AIA_Plan_Limitation__c obj2 = new AIA_Plan_Limitation__c();
            obj2.Plan_Benefits__c = pb.id;
            obj2.MandateIndicator__c = False;
            insert obj2;

            AIA_Plan_Limitation__c obj3 = new AIA_Plan_Limitation__c();
            obj3.MaxAgeFrom__c = 10;
            obj3.MaxAgeTo__c = 20;
            obj3.MaxAgeType__c = 'Years';
            obj3.MaxDuration__c = 10;
            obj3.MaxApply__c = 'Per Unit';
            obj3.MaxDurationType__c = 'Day';
            obj3.MaxType__c = 'Visits';
            obj3.MaxRow_Mandate_Description__c = 'Test';
            obj3.MaxValue__c = 30;
            obj3.Type__c = 'MaxRow';
            obj3.Plan_Benefits__c = pb.id;
            obj3.MandateIndicator__c = True;
            insert obj3;

            AIA_Plan_Benefit_Comment_Codes__c pbc =new AIA_Plan_Benefit_Comment_Codes__c();
            // pbc.Plan_Benefit_Parent_Name__c = ;
            pbc.Plan_Limitation__c = obj.id;

             //pbc.IsMandateTrue__c =false;
            pbc.Code__c = 333;
            pbc.Comment__c ='Test';
            //  pbc.Jurisdiction__c ='MD';
            pbc.IsRequired__c = 'Yes';
            //  pbc.Plan_Copay_Type__c ='';
            Insert pbc;

            AIA_Plan_Benefit_Comment_Codes__c pbc2 =new AIA_Plan_Benefit_Comment_Codes__c();
            // pbc.Plan_Benefit_Parent_Name__c = ;
            //  pbc.Plan_Limitation__c = obj.id;

            // pbc.IsMandateTrue__c ='Yes';
            pbc2.Code__c = 333;
            pbc2.Comment__c ='Test';
            //  pbc2.Jurisdiction__c ='MD';
            pbc2.IsRequired__c = 'Yes' ;
            pbc2.Plan_Copay_Type__c =apc.id;
            Insert pbc2;

        }
        
        
        
      public static AIA_Benefit_Design__c cCreateBenefitDesignWImpFromBrf(Account acc, string oppid, string brfid){
          
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = oppid;
            Imp.Account__c = acc.id;
           // Imp.Account__c = Imp.Opportunity__r.AccountId;
            //Imp.Generate_Workplan_Stages__c = true;//as per US210
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
          //  insert Imp;
                
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
           // aiaBD.Implementation__c = Imp.id;
            aiaBD.Account__c = acc.id;
            aiaBD.Benefit_Request_Form__c = brfId;
            insert aiaBD;
        return aiaBD;
    }

        public static testmethod void AIA_BenefitDesign_SummaryController_TestCase6(){
        //Removing as per US210
          /*  AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*/

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
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        
            
            insert userList;
		//T02 ends
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
        /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
        
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brfSource = new Benfit_Request_Form__c();
        brfSource.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brfSource.Contract_Count__c = 123;
        brfSource.Benefit_Effective_Date__c = system.today();
        brfSource.Account__c = acc.id;
      //  brfSource.ARC_Approval_Status__c = 'Approved by Committee';
        brfSource.Escalated_to_Senior_Management__c = true;
        brfSource.Status__c = 'new';
        brfSource.Opportunity__c = o.id;
        brfSource.Jurisdiction__c = 'MD';
        brfSource.Enrollment_Type__c = 'Cafeteria';
        brfSource.Request_Type__c = 'Prospect/New';
        insert brfSource;
        system.assertNOTEquals(brfSource,Null);

        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
       // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        brf.Source_Benefit_Request_Form__c = brfSource.id;
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
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
        pp.Has_Benefit_Details__c =True;
        pp.Rider__c='None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.Id;
        Imp1.Account__c = acc.Id;
        //Imp1.Generate_Workplan_Stages__c = true;//as per US210
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Benefit_Request_Form__c = brf.id;
        lstImp.add(Imp1);

        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;//as per US210
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brfSource.id;
        lstImp.add(Imp);
        if(lstImp != NULL && lstImp.size()>0)
            insert lstImp;
        system.assertNOTEquals(lstImp.size(),Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDPDrug = new AIA_Benefit_Design_Product__c();
        aiaBDPDrug.Benefit_Design__c=aiaBD.id;
        aiaBDPDrug.Plan_Name__c=aiapln.id;
        aiaBDPDrug.Proposed_Products__c=PP.id;     
        aiaBDPDrug.Funding_Arrangement__c = 'ASO';
        aiaBDPDrug.Product_Category__c ='Drug';
        aiaBDPDrug.Has_Benefit_Details__c = true;
        aiaBDPDrug.Integrated_Deductibles__c = 'No';
        aiaBDPDrug.Integrated_OOP_Integration__c = 'Yes';
        insert aiaBDPDrug;
        aiaBDPDrug = [select id,name,Benefit_Design__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c
        ,Integrated_OOP_Integration__c,Integrated_Deductibles__c   from AIA_Benefit_Design_Product__c where id =:aiaBDPDrug.id];     
        system.assertNOTEquals(aiaBDPDrug,Null);
        
        
        AIA_Document__c aiaDoc1 = new AIA_Document__c();
        aiaDoc1.Benefit_Design_Product__c=aiaBDPDrug.id;
        aiaDoc1.Account__c=acc.id;
        aiaDoc1.Approval_Status__c = 'Approved';
        aiaDoc1.Start_Date__c = System.today();
        aiaDoc1.End_Date__c = System.today()+10;
        aiaDoc1.Opportunity__c=o.id;
        insert aiaDoc1;
        system.assertNOTEquals(aiaDoc1,Null);
        
        Attachment att=AIA_TestUtil.createAttachment(aiaDoc1.Id);
        system.assertNOTEquals(att,Null);
        
        AIA_Grouper__c ag12 = new AIA_Grouper__c();
        ag12.Name = 'Retail NonMaintenance';
        ag12.Group_Type__c = 'Benefit Group';
        ag12.Benefit_Design_Product__c = aiaBDPDrug.id;
        ag12.Grouper_Record_Type__c = 'BDD';
        ag12.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag12.Sequence_Number__c = 12;
        ag12.Proposed_Products__c = pp.id;
        insert ag12;
        
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'CostShareRanges';
        ag1.Group_Type__c = 'Benefit Group';
        ag1.Benefit_Design_Product__c = aiaBDPDrug.id;
        ag1.Grouper_Record_Type__c = 'BDD';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp.id;
        insert ag1;
        

        AIA_Grouper__c ag2 = new AIA_Grouper__c();
        ag2.Name = 'CostShareRanges';
        ag2.Group_Type__c = 'Benefit Group';
        ag2.Benefit_Design_Product__c = aiaBDPDrug.id;
        ag2.Grouper_Record_Type__c = 'BDD';
        ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag2.Sequence_Number__c = 2;
        ag2.Proposed_Products__c = pp.id;
        insert ag2;

        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag1.id;
        ab1.Benefit_Name__c = 'Individual Out Of Pocket';
        ab1.Benefit_Type__c = 'Benefit';
        ab1.Type__c = 'Cost Share';           
        ab1.Benefit_Record_Type__c = 'BDD';
        ab1.Cost_Share_Low__c = '0';
        ab1.Cost_Share_High__c = '100';
        ab1.Cost_Share_Increment__c = '10';
        ab1.Cost_Share_InvalidIncrements__c = '30';
        ab1.Cost_Share_AdditionalIncrements__c = '33';
        ab1.OON_Cost_Share_Low__c = '0';
        ab1.OON_Cost_Share_High__c = '1000';
        ab1.OON_Cost_Share_Increment__c = '100';
        ab1.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab1.OON_Cost_Share_InvalidIncrements__c = '300';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_2_DefaultAmount__c ='No';
        insert ab1;  
        ab1.CoInsurance_AmountValueSelected__c = 'Yes';
        ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_AmountValueSelected__c = 'Yes';
        update ab1;
        
        AIA_Benefits__c ab = new AIA_Benefits__c();           
        ab.Grouper__c = ag1.id;
        ab.Benefit_Name__c = 'Family Out Of Pocket';
        ab.Benefit_Type__c = 'Mandate';
        ab.Type__c = 'Cost Share';           
        ab.Benefit_Record_Type__c = 'BDD';
        ab.Cost_Share_Low__c = '0';
        ab.Cost_Share_High__c = '100';
        ab.Cost_Share_Increment__c = '10';
        ab.Cost_Share_InvalidIncrements__c = '30';
        ab.Cost_Share_AdditionalIncrements__c = '33';
        ab.OON_Cost_Share_Low__c = '0';
        ab.OON_Cost_Share_High__c = '1000';
        ab.OON_Cost_Share_Increment__c = '100';
        ab.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab.OON_Cost_Share_InvalidIncrements__c = '300';
        ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab.Copay_Type_1_IsCovered__c = 'No';
        ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab.Copay_Type_1_AliasName__c='Test';
        ab.Copay_Type_2_AliasName__c='Test';
        ab.OON_Copay_Type_1_AliasName__c='Test';
        ab.OON_Copay_Type_2_AliasName__c='Test';
        insert ab;  
        

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Grouper__c apg1 = new AIA_Plan_Grouper__c();
        apg1.ExtID__c =  '33r34t33dr2';
        apg1.ISExisting_Grouper__c = false;  
        apg1.Plan__c = aiapln.id;
        apg1.Record_Type__c = 'BDD';
        apg1.Plan_Grouper_Name__c = '2233df';
        apg1.Plan_Network__c = pn.id;
        apg1.Sequence_Number__c = 2;
        insert apg1; 
        
        AIA_Plan_Grouper__c apg2 = new AIA_Plan_Grouper__c();
        apg2.ExtID__c =  '33r34t33dr2';
        apg2.ISExisting_Grouper__c = false;  
        apg2.Plan__c = aiapln.id;
        apg2.Record_Type__c = 'BDD';
        apg2.Plan_Grouper_Name__c = '2233df';
        apg2.Plan_Network__c = pn.id;
        apg2.Sequence_Number__c = 1;
        insert apg2;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.Type__c='Cost Share';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'MaxRow';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
       // aplObj.MandateIndicator__c = false;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        //mod offshore
        aplObj.MandateIndicator__c=True;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        //offshore
        apbcc1.FundingArrangement__c='Risk';
            //end
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;

        Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
        lmt.Benefit__c = ab.id;
        insert lmt;
        Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
        lmt.Benefit__c = ab.id;
        insert lmt2;

        Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
        lmt.Benefit__c = ab.id;
        insert lmt3;
        
        aiaBDPDrug = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                      From AIA_Benefit_Design_Product__c where id =: aiaBDPDrug.id limit 1];
            
        string bpdID = aiaBDPDrug.id;
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDPDrug.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDPDrug);
        ApexPages.currentPage().getParameters().put('id', aiaBDPDrug.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);

        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDPDrug);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDPDrug);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        ext.rowOrder = 0;
        ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
  
    public static testmethod void AIA_BenefitDesign_SummaryController_TestCase6_1(){
        //Removing as part of US210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*/

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
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        insert userList;
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u13.id,'Contract Tech'));
        /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
        
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brfSource = new Benfit_Request_Form__c();
        brfSource.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brfSource.Contract_Count__c = 123;
        brfSource.Benefit_Effective_Date__c = system.today();
        brfSource.Account__c = acc.id;
      //  brfSource.ARC_Approval_Status__c = 'Approved by Committee';
        brfSource.Escalated_to_Senior_Management__c = true;
        brfSource.Status__c = 'new';
        brfSource.Opportunity__c = o.id;
        brfSource.Jurisdiction__c = 'MD';
        brfSource.Enrollment_Type__c = 'Cafeteria';
        brfSource.Request_Type__c = 'Prospect/New';
        insert brfSource;
        system.assertNOTEquals(brfSource,Null);

        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
       // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        brf.Source_Benefit_Request_Form__c = brfSource.id;
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
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
        pp.Has_Benefit_Details__c =True;
        pp.Rider__c='None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.Id;
        Imp1.Account__c = acc.Id;
        //Imp1.Generate_Workplan_Stages__c = true;//as per US210
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Benefit_Request_Form__c = brf.id;
        lstImp.add(Imp1);

        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;//as per US210
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brfSource.id;
        lstImp.add(Imp);
        if(lstImp != NULL && lstImp.size()>0)
            insert lstImp;
        system.assertNOTEquals(lstImp.size(),Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDPDrug = new AIA_Benefit_Design_Product__c();
        aiaBDPDrug.Benefit_Design__c=aiaBD.id;
        aiaBDPDrug.Plan_Name__c=aiapln.id;
        aiaBDPDrug.Proposed_Products__c=PP.id;     
        aiaBDPDrug.Funding_Arrangement__c = 'ASO';
        aiaBDPDrug.Product_Category__c ='Drug';
        aiaBDPDrug.Has_Benefit_Details__c = true;
        aiaBDPDrug.Integrated_Deductibles__c = 'No';
        aiaBDPDrug.Integrated_OOP_Integration__c = 'Yes';
        insert aiaBDPDrug;
        aiaBDPDrug = [select id,name,Benefit_Design__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c
        ,Integrated_OOP_Integration__c,Integrated_Deductibles__c   from AIA_Benefit_Design_Product__c where id =:aiaBDPDrug.id];     
        system.assertNOTEquals(aiaBDPDrug,Null);
        
        
        AIA_Document__c aiaDoc1 = new AIA_Document__c();
        aiaDoc1.Benefit_Design_Product__c=aiaBDPDrug.id;
        aiaDoc1.Account__c=acc.id;
        aiaDoc1.Approval_Status__c = 'Approved';
        aiaDoc1.Start_Date__c = System.today();
        aiaDoc1.End_Date__c = System.today()+10;
        aiaDoc1.Opportunity__c=o.id;
        insert aiaDoc1;
        system.assertNOTEquals(aiaDoc1,Null);
        
        Attachment att=AIA_TestUtil.createAttachment(aiaDoc1.Id);
        system.assertNOTEquals(att,Null);
        
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'CostShareRanges';
        ag1.Group_Type__c = 'Benefit Group';
        ag1.Benefit_Design_Product__c = aiaBDPDrug.id;
        ag1.Grouper_Record_Type__c = 'BDD';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp.id;
        insert ag1;
        

        AIA_Grouper__c ag2 = new AIA_Grouper__c();
        ag2.Name = 'CostShareRanges';
        ag2.Group_Type__c = 'Benefit Group';
        ag2.Benefit_Design_Product__c = aiaBDPDrug.id;
        ag2.Grouper_Record_Type__c = 'BDD';
        ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag2.Sequence_Number__c = 2;
        ag2.Proposed_Products__c = pp.id;
        insert ag2;

        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag1.id;
        ab1.Benefit_Name__c = 'Individual Out Of Pocket';
        ab1.Benefit_Type__c = 'Benefit';
        ab1.Type__c = 'Cost Share';           
        ab1.Benefit_Record_Type__c = 'BDD';
        ab1.Cost_Share_Low__c = '0';
        ab1.Cost_Share_High__c = '100';
        ab1.Cost_Share_Increment__c = '10';
        ab1.Cost_Share_InvalidIncrements__c = '30';
        ab1.Cost_Share_AdditionalIncrements__c = '33';
        ab1.OON_Cost_Share_Low__c = '0';
        ab1.OON_Cost_Share_High__c = '1000';
        ab1.OON_Cost_Share_Increment__c = '100';
        ab1.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab1.OON_Cost_Share_InvalidIncrements__c = '300';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_2_DefaultAmount__c ='No';
        insert ab1;  
        ab1.CoInsurance_AmountValueSelected__c = 'Yes';
        ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_AmountValueSelected__c = 'Yes';
        update ab1;
        
        AIA_Benefits__c ab = new AIA_Benefits__c();           
        ab.Grouper__c = ag1.id;
        ab.Benefit_Name__c = 'Family Out Of Pocket';
        ab.Benefit_Type__c = 'Mandate';
        ab.Type__c = 'Cost Share';           
        ab.Benefit_Record_Type__c = 'BDD';
        ab.Cost_Share_Low__c = '0';
        ab.Cost_Share_High__c = '100';
        ab.Cost_Share_Increment__c = '10';
        ab.Cost_Share_InvalidIncrements__c = '30';
        ab.Cost_Share_AdditionalIncrements__c = '33';
        ab.OON_Cost_Share_Low__c = '0';
        ab.OON_Cost_Share_High__c = '1000';
        ab.OON_Cost_Share_Increment__c = '100';
        ab.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab.OON_Cost_Share_InvalidIncrements__c = '300';
        ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab.Copay_Type_1_IsCovered__c = 'No';
        ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab.Copay_Type_1_AliasName__c='Test';
        ab.Copay_Type_2_AliasName__c='Test';
        ab.OON_Copay_Type_1_AliasName__c='Test';
        ab.OON_Copay_Type_2_AliasName__c='Test';
        insert ab;  
        

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Grouper__c apg1 = new AIA_Plan_Grouper__c();
        apg1.ExtID__c =  '33r34t33dr2';
        apg1.ISExisting_Grouper__c = false;  
        apg1.Plan__c = aiapln.id;
        apg1.Record_Type__c = 'BDD';
        apg1.Plan_Grouper_Name__c = '2233df';
        apg1.Plan_Network__c = pn.id;
        apg1.Sequence_Number__c = 2;
        insert apg1; 
        
        AIA_Plan_Grouper__c apg2 = new AIA_Plan_Grouper__c();
        apg2.ExtID__c =  '33r34t33dr2';
        apg2.ISExisting_Grouper__c = false;  
        apg2.Plan__c = aiapln.id;
        apg2.Record_Type__c = 'BDD';
        apg2.Plan_Grouper_Name__c = '2233df';
        apg2.Plan_Network__c = pn.id;
        apg2.Sequence_Number__c = 1;
        insert apg2;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.Type__c='Cost Share';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'MaxRow';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
       // aplObj.MandateIndicator__c = false;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        //mod offshore
        aplObj.MandateIndicator__c=True;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        //offshore
        apbcc1.FundingArrangement__c='Risk';
            //end
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;

        Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
        lmt.Benefit__c = ab.id;
        insert lmt;
        Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
        lmt.Benefit__c = ab.id;
        insert lmt2;

        Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
        lmt.Benefit__c = ab.id;
        insert lmt3;
        
        aiaBDPDrug = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                      From AIA_Benefit_Design_Product__c where id =: aiaBDPDrug.id limit 1];
            
        string bpdID = aiaBDPDrug.id;
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDPDrug.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDPDrug);
        ApexPages.currentPage().getParameters().put('id', aiaBDPDrug.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);

        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDPDrug);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDPDrug);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        ext.rowOrder = 0;
        ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
    
    public static testmethod void AIA_BenefitDesign_SummaryController_TestCase6_2(){
        //Removing as per US210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*/

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
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        
        insert userList;       
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
        /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
        
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brfSource = new Benfit_Request_Form__c();
        brfSource.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brfSource.Contract_Count__c = 123;
        brfSource.Benefit_Effective_Date__c = system.today();
        brfSource.Account__c = acc.id;
      //  brfSource.ARC_Approval_Status__c = 'Approved by Committee';
        brfSource.Escalated_to_Senior_Management__c = true;
        brfSource.Status__c = 'new';
        brfSource.Opportunity__c = o.id;
        brfSource.Jurisdiction__c = 'MD';
        brfSource.Enrollment_Type__c = 'Cafeteria';
        brfSource.Request_Type__c = 'Prospect/New';
        insert brfSource;
        system.assertNOTEquals(brfSource,Null);

        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
       // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        brf.Source_Benefit_Request_Form__c = brfSource.id;
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
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
        pp.Has_Benefit_Details__c =True;
        pp.Rider__c='None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.Id;
        Imp1.Account__c = acc.Id;
        //Imp1.Generate_Workplan_Stages__c = true;//as per US210
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Benefit_Request_Form__c = brf.id;
        lstImp.add(Imp1);

        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;//as per US210
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brfSource.id;
        lstImp.add(Imp);
        if(lstImp != NULL && lstImp.size()>0)
            insert lstImp;
        system.assertNOTEquals(lstImp.size(),Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDPDrug = new AIA_Benefit_Design_Product__c();
        aiaBDPDrug.Benefit_Design__c=aiaBD.id;
        aiaBDPDrug.Plan_Name__c=aiapln.id;
        aiaBDPDrug.Proposed_Products__c=PP.id;     
        aiaBDPDrug.Funding_Arrangement__c = 'ASO';
        aiaBDPDrug.Product_Category__c ='Drug';
        aiaBDPDrug.Has_Benefit_Details__c = true;
        aiaBDPDrug.Integrated_Deductibles__c = 'Yes';
        aiaBDPDrug.Integrated_OOP_Integration__c = 'Yes';
        insert aiaBDPDrug;
        aiaBDPDrug = [select id,name,Benefit_Design__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c
        ,Integrated_OOP_Integration__c,Integrated_Deductibles__c   from AIA_Benefit_Design_Product__c where id =:aiaBDPDrug.id];     
        system.assertNOTEquals(aiaBDPDrug,Null);
        
        
        AIA_Document__c aiaDoc1 = new AIA_Document__c();
        aiaDoc1.Benefit_Design_Product__c=aiaBDPDrug.id;
        aiaDoc1.Account__c=acc.id;
        aiaDoc1.Approval_Status__c = 'Approved';
        aiaDoc1.Start_Date__c = System.today();
        aiaDoc1.End_Date__c = System.today()+10;
        aiaDoc1.Opportunity__c=o.id;
        insert aiaDoc1;
        system.assertNOTEquals(aiaDoc1,Null);
        
        Attachment att=AIA_TestUtil.createAttachment(aiaDoc1.Id);
        system.assertNOTEquals(att,Null);
        
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'CostShareRanges';
        ag1.Group_Type__c = 'Benefit Group';
        ag1.Benefit_Design_Product__c = aiaBDPDrug.id;
        ag1.Grouper_Record_Type__c = 'BDD';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp.id;
        insert ag1;
        

        AIA_Grouper__c ag2 = new AIA_Grouper__c();
        ag2.Name = 'CostShareRanges';
        ag2.Group_Type__c = 'Benefit Group';
        ag2.Benefit_Design_Product__c = aiaBDPDrug.id;
        ag2.Grouper_Record_Type__c = 'BDD';
        ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag2.Sequence_Number__c = 2;
        ag2.Proposed_Products__c = pp.id;
        insert ag2;

        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag1.id;
        ab1.Benefit_Name__c = 'Individual Out Of Pocket';
        ab1.Benefit_Type__c = 'Benefit';
        ab1.Type__c = 'Cost Share';           
        ab1.Benefit_Record_Type__c = 'BDD';
        ab1.Cost_Share_Low__c = '0';
        ab1.Cost_Share_High__c = '100';
        ab1.Cost_Share_Increment__c = '10';
        ab1.Cost_Share_InvalidIncrements__c = '30';
        ab1.Cost_Share_AdditionalIncrements__c = '33';
        ab1.OON_Cost_Share_Low__c = '0';
        ab1.OON_Cost_Share_High__c = '1000';
        ab1.OON_Cost_Share_Increment__c = '100';
        ab1.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab1.OON_Cost_Share_InvalidIncrements__c = '300';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_2_DefaultAmount__c ='No';
        insert ab1;  
        ab1.CoInsurance_AmountValueSelected__c = 'Yes';
        ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_AmountValueSelected__c = 'Yes';
        update ab1;
        
        AIA_Benefits__c ab = new AIA_Benefits__c();           
        ab.Grouper__c = ag1.id;
        ab.Benefit_Name__c = 'Family Out Of Pocket';
        ab.Benefit_Type__c = 'Mandate';
        ab.Type__c = 'Cost Share';           
        ab.Benefit_Record_Type__c = 'BDD';
        ab.Cost_Share_Low__c = '0';
        ab.Cost_Share_High__c = '100';
        ab.Cost_Share_Increment__c = '10';
        ab.Cost_Share_InvalidIncrements__c = '30';
        ab.Cost_Share_AdditionalIncrements__c = '33';
        ab.OON_Cost_Share_Low__c = '0';
        ab.OON_Cost_Share_High__c = '1000';
        ab.OON_Cost_Share_Increment__c = '100';
        ab.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab.OON_Cost_Share_InvalidIncrements__c = '300';
        ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab.Copay_Type_1_IsCovered__c = 'No';
        ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab.Copay_Type_1_AliasName__c='Test';
        ab.Copay_Type_2_AliasName__c='Test';
        ab.OON_Copay_Type_1_AliasName__c='Test';
        ab.OON_Copay_Type_2_AliasName__c='Test';
        insert ab;  
        

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Grouper__c apg1 = new AIA_Plan_Grouper__c();
        apg1.ExtID__c =  '33r34t33dr2';
        apg1.ISExisting_Grouper__c = false;  
        apg1.Plan__c = aiapln.id;
        apg1.Record_Type__c = 'BDD';
        apg1.Plan_Grouper_Name__c = '2233df';
        apg1.Plan_Network__c = pn.id;
        apg1.Sequence_Number__c = 2;
        insert apg1; 
        
        AIA_Plan_Grouper__c apg2 = new AIA_Plan_Grouper__c();
        apg2.ExtID__c =  '33r34t33dr2';
        apg2.ISExisting_Grouper__c = false;  
        apg2.Plan__c = aiapln.id;
        apg2.Record_Type__c = 'BDD';
        apg2.Plan_Grouper_Name__c = '2233df';
        apg2.Plan_Network__c = pn.id;
        apg2.Sequence_Number__c = 1;
        insert apg2;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.Type__c='Cost Share';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'MaxRow';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
       // aplObj.MandateIndicator__c = false;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        //mod offshore
        aplObj.MandateIndicator__c=True;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        //offshore
        apbcc1.FundingArrangement__c='Risk';
            //end
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;

        Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
        lmt.Benefit__c = ab.id;
        insert lmt;
        Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
        lmt.Benefit__c = ab.id;
        insert lmt2;

        Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
        lmt.Benefit__c = ab.id;
        insert lmt3;
        
        aiaBDPDrug = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                      From AIA_Benefit_Design_Product__c where id =: aiaBDPDrug.id limit 1];
            
        string bpdID = aiaBDPDrug.id;
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDPDrug.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDPDrug);
        ApexPages.currentPage().getParameters().put('id', aiaBDPDrug.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);

        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDPDrug);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDPDrug);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        ext.rowOrder = 0;
        ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
    
    public static testmethod void AIA_BenefitDesign_SummaryController_TestCase6_3(){
        //Removing as part of US210
       /* AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*/

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
      
        
		user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        insert userList;       
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
        
        /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brfSource = new Benfit_Request_Form__c();
        brfSource.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brfSource.Contract_Count__c = 123;
        brfSource.Benefit_Effective_Date__c = system.today();
        brfSource.Account__c = acc.id;
      //  brfSource.ARC_Approval_Status__c = 'Approved by Committee';
        brfSource.Escalated_to_Senior_Management__c = true;
        brfSource.Status__c = 'new';
        brfSource.Opportunity__c = o.id;
        brfSource.Jurisdiction__c = 'MD';
        brfSource.Enrollment_Type__c = 'Cafeteria';
        brfSource.Request_Type__c = 'Prospect/New';
        insert brfSource;
        system.assertNOTEquals(brfSource,Null);

        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
       // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        brf.Source_Benefit_Request_Form__c = brfSource.id;
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
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
        pp.Has_Benefit_Details__c =True;
        pp.Rider__c='None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.Id;
        Imp1.Account__c = acc.Id;
        //Imp1.Generate_Workplan_Stages__c = true;//as per US210
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Benefit_Request_Form__c = brf.id;
        lstImp.add(Imp1);

        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;//as per US210
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brfSource.id;
        lstImp.add(Imp);
        if(lstImp != NULL && lstImp.size()>0)
            insert lstImp;
        system.assertNOTEquals(lstImp.size(),Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDPDrug = new AIA_Benefit_Design_Product__c();
        aiaBDPDrug.Benefit_Design__c=aiaBD.id;
        aiaBDPDrug.Plan_Name__c=aiapln.id;
        aiaBDPDrug.Proposed_Products__c=PP.id;     
        aiaBDPDrug.Funding_Arrangement__c = 'ASO';
        aiaBDPDrug.Product_Category__c ='Drug';
        aiaBDPDrug.Has_Benefit_Details__c = true;
        aiaBDPDrug.Integrated_Deductibles__c = 'No';
        aiaBDPDrug.Integrated_OOP_Integration__c = 'No';
        insert aiaBDPDrug;
        aiaBDPDrug = [select id,name,Benefit_Design__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c
        ,Integrated_OOP_Integration__c,Integrated_Deductibles__c   from AIA_Benefit_Design_Product__c where id =:aiaBDPDrug.id];     
        system.assertNOTEquals(aiaBDPDrug,Null);
        
        
        AIA_Document__c aiaDoc1 = new AIA_Document__c();
        aiaDoc1.Benefit_Design_Product__c=aiaBDPDrug.id;
        aiaDoc1.Account__c=acc.id;
        aiaDoc1.Approval_Status__c = 'Approved';
        aiaDoc1.Start_Date__c = System.today();
        aiaDoc1.End_Date__c = System.today()+10;
        aiaDoc1.Opportunity__c=o.id;
        insert aiaDoc1;
        system.assertNOTEquals(aiaDoc1,Null);
        
        Attachment att=AIA_TestUtil.createAttachment(aiaDoc1.Id);
        system.assertNOTEquals(att,Null);
        
        
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'CostShareRanges';
        ag1.Group_Type__c = 'Benefit Group';
        ag1.Benefit_Design_Product__c = aiaBDPDrug.id;
        ag1.Grouper_Record_Type__c = 'BDD';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp.id;
        insert ag1;
        

        AIA_Grouper__c ag2 = new AIA_Grouper__c();
        ag2.Name = 'CostShareRanges';
        ag2.Group_Type__c = 'Benefit Group';
        ag2.Benefit_Design_Product__c = aiaBDPDrug.id;
        ag2.Grouper_Record_Type__c = 'BDD';
        ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag2.Sequence_Number__c = 2;
        ag2.Proposed_Products__c = pp.id;
        insert ag2;

        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag1.id;
        ab1.Benefit_Name__c = 'Individual Out Of Pocket';
        ab1.Benefit_Type__c = 'Benefit';
        ab1.Type__c = 'Cost Share';           
        ab1.Benefit_Record_Type__c = 'BDD';
        ab1.Cost_Share_Low__c = '0';
        ab1.Cost_Share_High__c = '100';
        ab1.Cost_Share_Increment__c = '10';
        ab1.Cost_Share_InvalidIncrements__c = '30';
        ab1.Cost_Share_AdditionalIncrements__c = '33';
        ab1.OON_Cost_Share_Low__c = '0';
        ab1.OON_Cost_Share_High__c = '1000';
        ab1.OON_Cost_Share_Increment__c = '100';
        ab1.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab1.OON_Cost_Share_InvalidIncrements__c = '300';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_2_DefaultAmount__c ='No';
        insert ab1;  
        ab1.CoInsurance_AmountValueSelected__c = 'Yes';
        ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_AmountValueSelected__c = 'Yes';
        update ab1;
        
        AIA_Benefits__c ab = new AIA_Benefits__c();           
        ab.Grouper__c = ag1.id;
        ab.Benefit_Name__c = 'Family Out Of Pocket';
        ab.Benefit_Type__c = 'Mandate';
        ab.Type__c = 'Cost Share';           
        ab.Benefit_Record_Type__c = 'BDD';
        ab.Cost_Share_Low__c = '0';
        ab.Cost_Share_High__c = '100';
        ab.Cost_Share_Increment__c = '10';
        ab.Cost_Share_InvalidIncrements__c = '30';
        ab.Cost_Share_AdditionalIncrements__c = '33';
        ab.OON_Cost_Share_Low__c = '0';
        ab.OON_Cost_Share_High__c = '1000';
        ab.OON_Cost_Share_Increment__c = '100';
        ab.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab.OON_Cost_Share_InvalidIncrements__c = '300';
        ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab.Copay_Type_1_IsCovered__c = 'No';
        ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab.Copay_Type_1_AliasName__c='Test';
        ab.Copay_Type_2_AliasName__c='Test';
        ab.OON_Copay_Type_1_AliasName__c='Test';
        ab.OON_Copay_Type_2_AliasName__c='Test';
        insert ab;  
        

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Grouper__c apg1 = new AIA_Plan_Grouper__c();
        apg1.ExtID__c =  '33r34t33dr2';
        apg1.ISExisting_Grouper__c = false;  
        apg1.Plan__c = aiapln.id;
        apg1.Record_Type__c = 'BDD';
        apg1.Plan_Grouper_Name__c = '2233df';
        apg1.Plan_Network__c = pn.id;
        apg1.Sequence_Number__c = 2;
        insert apg1; 
        
        AIA_Plan_Grouper__c apg2 = new AIA_Plan_Grouper__c();
        apg2.ExtID__c =  '33r34t33dr2';
        apg2.ISExisting_Grouper__c = false;  
        apg2.Plan__c = aiapln.id;
        apg2.Record_Type__c = 'BDD';
        apg2.Plan_Grouper_Name__c = '2233df';
        apg2.Plan_Network__c = pn.id;
        apg2.Sequence_Number__c = 1;
        insert apg2;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.Type__c='Cost Share';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'MaxRow';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
       // aplObj.MandateIndicator__c = false;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        //mod offshore
        aplObj.MandateIndicator__c=True;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        //offshore
        apbcc1.FundingArrangement__c='Risk';
            //end
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;

        Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
        lmt.Benefit__c = ab.id;
        insert lmt;
        Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
        lmt.Benefit__c = ab.id;
        insert lmt2;

        Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
        lmt.Benefit__c = ab.id;
        insert lmt3;
        
        
        aiaBDPDrug = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                      From AIA_Benefit_Design_Product__c where id =: aiaBDPDrug.id limit 1];
            
        string bpdID = aiaBDPDrug.id;
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDPDrug.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDPDrug);
        ApexPages.currentPage().getParameters().put('id', aiaBDPDrug.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);

        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDPDrug);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDPDrug);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        ext.rowOrder = 0;
        ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    } 
         public static testmethod void AIA_BenefitDesign_SummaryController_TestCase7(){
        //Removing as part of US210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*/

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
        
		user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
       
        insert userList;       
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
        /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
       
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
      //  brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
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
        pp.Has_Benefit_Details__c =True;
        pp.Rider__c='None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.Id;
        Imp1.Account__c = acc.Id;
        //Imp1.Generate_Workplan_Stages__c = true;//as per US210
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Benefit_Request_Form__c = brf.id;
        lstImp.add(Imp1);

        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;//as per US210
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        lstImp.add(Imp);
        if(lstImp != NULL && lstImp.size()>0)
            insert lstImp;
        system.assertNOTEquals(lstImp.size(),Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c=aiaBD.id;
        aiaBDP1.Plan_Name__c=aiapln.id;
        aiaBDP1.Proposed_Products__c=PP.id;     
        aiaBDP1.Funding_Arrangement__c = 'ASO';
        aiaBDP1.Product_Category__c ='Medical';//mod from medical to drug
        aiaBDP1.Has_Benefit_Details__c = false;
        insert aiaBDP1;  
         
        aiaBDP1 = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                   From AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     
        system.assertNOTEquals(aiaBDP1,Null);
        
        
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'CostShareRanges';
        ag1.Group_Type__c = 'Benefit Group';
        ag1.Benefit_Design_Product__c = aiaBDP1.id;
        ag1.Grouper_Record_Type__c = 'BDD';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp.id;
        insert ag1;

        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag1.id;
        ab1.Benefit_Name__c = 'Individual Out Of Pocket';
        ab1.Benefit_Type__c = 'Benefit';
        ab1.Type__c = 'Cost Share';           
        ab1.Benefit_Record_Type__c = 'BDD';
        ab1.Cost_Share_Low__c = '0';
        ab1.Cost_Share_High__c = '100';
        ab1.Cost_Share_Increment__c = '10';
        ab1.Cost_Share_InvalidIncrements__c = '30';
        ab1.Cost_Share_AdditionalIncrements__c = '33';
        ab1.OON_Cost_Share_Low__c = '0';
        ab1.OON_Cost_Share_High__c = '1000';
        ab1.OON_Cost_Share_Increment__c = '100';
        ab1.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab1.OON_Cost_Share_InvalidIncrements__c = '300';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_2_DefaultAmount__c ='No';
        insert ab1;  

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        apbt.IS_ASO_Only__c='Yes';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.Type__c='Cost Share';
        apbt1.IS_ASO_Only__c='No';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'MaxRow';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
        aplObj.MandateIndicator__c = false;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;
        
        string bpdID = aiaBDP1.id;
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDP1);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);

        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDP1);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDP1);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        ext.rowOrder = 0;
        ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
        public static testmethod void AIA_BenefitDesign_SummaryController_TestCase8(){
        //Removes as per US210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*/

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
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        
        insert userList;  
             
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Vision');
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
        pp.Has_Benefit_Details__c =True;
        pp.Rider__c='None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.Id;
        Imp1.Account__c = acc.Id;
        //Imp1.Generate_Workplan_Stages__c = true;//as per US210
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Benefit_Request_Form__c = brf.id;
        lstImp.add(Imp1);

        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;//as per US210
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        lstImp.add(Imp);
        if(lstImp != NULL && lstImp.size()>0)
            insert lstImp;
        system.assertNOTEquals(lstImp.size(),Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c=aiaBD.id;
        aiaBDP1.Plan_Name__c=aiapln.id;
        aiaBDP1.Proposed_Products__c=PP.id;     
        aiaBDP1.Funding_Arrangement__c = 'ASO';
        aiaBDP1.Product_Category__c ='Drug';//mod from vision to drug
        aiaBDP1.Has_Benefit_Details__c = false;
        aiaBDP1.Integrated_Deductibles__c = 'Yes';
        aiaBDP1.Integrated_OOP_Integration__c = 'Yes';
        insert aiaBDP1;  
         
        aiaBDP1 = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                   ,Integrated_OOP_Integration__c,Integrated_Deductibles__c   From AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     
        system.assertNOTEquals(aiaBDP1,Null);
        
        
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'CostShareRanges';
        ag1.Group_Type__c = 'Benefit Group';
        ag1.Benefit_Design_Product__c = aiaBDP1.id;
        ag1.Grouper_Record_Type__c = 'BDD';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp.id;
        insert ag1;
        
        AIA_Grouper__c ag12 = new AIA_Grouper__c();
        ag12.Name = 'Retail NonMaintenance';
        ag12.Group_Type__c = 'Benefit Group';
        ag12.Benefit_Design_Product__c = aiaBDP1.id;
        ag12.Grouper_Record_Type__c = 'BDD';
        ag12.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag12.Sequence_Number__c = 2;
        ag12.Proposed_Products__c = pp.id;
        insert ag12;

        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag1.id;
        ab1.Benefit_Name__c = 'Individual Out Of Pocket';
        ab1.Benefit_Type__c = 'Benefit';
        ab1.Type__c = 'Cost Share';           
        ab1.Benefit_Record_Type__c = 'BDD';
        ab1.Cost_Share_Low__c = '0';
        ab1.Cost_Share_High__c = '100';
        ab1.Cost_Share_Increment__c = '10';
        ab1.Cost_Share_InvalidIncrements__c = '30';
        ab1.Cost_Share_AdditionalIncrements__c = '33';
        ab1.OON_Cost_Share_Low__c = '0';
        ab1.OON_Cost_Share_High__c = '1000';
        ab1.OON_Cost_Share_Increment__c = '100';
        ab1.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab1.OON_Cost_Share_InvalidIncrements__c = '300';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_2_DefaultAmount__c ='No';
        insert ab1;
        
        AIA_Benefits__c ab2 = new AIA_Benefits__c();           
        ab2.Grouper__c = ag1.id;
        ab2.Benefit_Name__c = 'Family Out Of Pocket';
        ab2.Benefit_Type__c = 'Benefit';
        ab2.Type__c = 'Cost Share';           
        ab2.Benefit_Record_Type__c = 'BDD';
        ab2.Cost_Share_Low__c = '0';
        ab2.Cost_Share_High__c = '100';
        ab2.Cost_Share_Increment__c = '10';
        ab2.Cost_Share_InvalidIncrements__c = '30';
        ab2.Cost_Share_AdditionalIncrements__c = '33';
        ab2.OON_Cost_Share_Low__c = '0';
        ab2.OON_Cost_Share_High__c = '1000';
        ab2.OON_Cost_Share_Increment__c = '100';
        ab2.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab2.OON_Cost_Share_InvalidIncrements__c = '300';
        ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab2.Copay_Type_1_IsCovered__c = 'No';
        ab2.OON_Copay_Type_1_IsCovered__c = 'No';
        ab2.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab2.Copay_Type_1_AliasName__c='Test';
        ab2.Copay_Type_2_AliasName__c='Test';
        ab2.OON_Copay_Type_1_AliasName__c='Test';
        ab2.OON_Copay_Type_2_AliasName__c='Test';
        ab2.OON_Copay_Type_2_DefaultAmount__c ='No';
        insert ab2;
        
        AIA_Benefits__c ab3 = new AIA_Benefits__c();           
        ab3.Grouper__c = ag1.id;
        ab3.Benefit_Name__c = 'Individual Deductible';
        ab3.Benefit_Type__c = 'Benefit';
        ab3.Type__c = 'Cost Share';           
        ab3.Benefit_Record_Type__c = 'BDD';
        ab3.Cost_Share_Low__c = '0';
        ab3.Cost_Share_High__c = '100';
        ab3.Cost_Share_Increment__c = '10';
        ab3.Cost_Share_InvalidIncrements__c = '30';
        ab3.Cost_Share_AdditionalIncrements__c = '33';
        ab3.OON_Cost_Share_Low__c = '0';
        ab3.OON_Cost_Share_High__c = '1000';
        ab3.OON_Cost_Share_Increment__c = '100';
        ab3.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab3.OON_Cost_Share_InvalidIncrements__c = '300';
        ab3.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab3.Copay_Type_1_IsCovered__c = 'No';
        ab3.OON_Copay_Type_1_IsCovered__c = 'No';
        ab3.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab3.Copay_Type_1_AliasName__c='Test';
        ab3.Copay_Type_2_AliasName__c='Test';
        ab3.OON_Copay_Type_1_AliasName__c='Test';
        ab3.OON_Copay_Type_2_AliasName__c='Test';
        ab3.OON_Copay_Type_2_DefaultAmount__c ='No';
        insert ab3;
        
        AIA_Benefits__c ab4 = new AIA_Benefits__c();           
        ab4.Grouper__c = ag1.id;
        ab4.Benefit_Name__c = 'Family Deductible';
        ab4.Benefit_Type__c = 'Benefit';
        ab4.Type__c = 'Cost Share';           
        ab4.Benefit_Record_Type__c = 'BDD';
        ab4.Cost_Share_Low__c = '0';
        ab4.Cost_Share_High__c = '100';
        ab4.Cost_Share_Increment__c = '10';
        ab4.Cost_Share_InvalidIncrements__c = '30';
        ab4.Cost_Share_AdditionalIncrements__c = '33';
        ab4.OON_Cost_Share_Low__c = '0';
        ab4.OON_Cost_Share_High__c = '1000';
        ab4.OON_Cost_Share_Increment__c = '100';
        ab4.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab4.OON_Cost_Share_InvalidIncrements__c = '300';
        ab4.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab4.Copay_Type_1_IsCovered__c = 'No';
        ab4.OON_Copay_Type_1_IsCovered__c = 'No';
        ab4.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab4.Copay_Type_1_AliasName__c='Test';
        ab4.Copay_Type_2_AliasName__c='Test';
        ab4.OON_Copay_Type_1_AliasName__c='Test';
        ab4.OON_Copay_Type_2_AliasName__c='Test';
        ab4.OON_Copay_Type_2_DefaultAmount__c ='No';
        insert ab4;

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        apbt.IS_ASO_Only__c='Yes';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.Type__c='Cost Share';
        apbt1.IS_ASO_Only__c='No';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'MaxRow';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
        aplObj.MandateIndicator__c = false;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;
        
        string bpdID = aiaBDP1.id;
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDP1);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);

        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDP1);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDP1);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        ext.rowOrder = 0;
        ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
        public static testmethod void AIA_BenefitDesign_SummaryController_TestCase9(){
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*///as per US210

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
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        
        insert userList;       
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
         
		/*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
      //  brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Vision');
        pp.Benefit_Request_Form__c = brf.id;
        pp.Funding_Arrangement__c = 'Risk';
        pp.Product_Category__c = 'Drug'; //from drug to dental
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
        pp.Has_Benefit_Details__c =True;
        pp.Rider__c='None';
        pp.Exclusive_Specialty_Provider_Network__c = 'Yes';
        pp.ExtraCare_Health_Care_Card__c = 'No'; //Changed From 'Yes'
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.Id;
        Imp1.Account__c = acc.Id;
        //Imp1.Generate_Workplan_Stages__c = true;//as per US210
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Benefit_Request_Form__c = brf.id;
        lstImp.add(Imp1);

        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;//as per US210
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        lstImp.add(Imp);
        if(lstImp != NULL && lstImp.size()>0)
            insert lstImp;
        system.assertNOTEquals(lstImp.size(),Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c=aiaBD.id;
        aiaBDP1.Plan_Name__c=aiapln.id;
        aiaBDP1.Proposed_Products__c=PP.id;     
        aiaBDP1.Funding_Arrangement__c = 'Risk';
        aiaBDP1.Product_Category__c ='Vision';
        aiaBDP1.Has_Benefit_Details__c = false;
        insert aiaBDP1;  
         
        aiaBDP1 = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                   From AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     
        system.assertNOTEquals(aiaBDP1,Null);
        
        
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'CostShareRanges';
        ag1.Group_Type__c = 'Benefit Group';
        ag1.Benefit_Design_Product__c = aiaBDP1.id;
        ag1.Grouper_Record_Type__c = 'BDD';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp.id;
        insert ag1;

        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag1.id;
        ab1.Benefit_Name__c = 'Individual Out Of Pocket';
        ab1.Benefit_Type__c = 'Limitation';
        ab1.Type__c = 'Cost Share';           
        ab1.Benefit_Record_Type__c = 'BDD';
        ab1.Cost_Share_Low__c = '0';
        ab1.Cost_Share_High__c = '100';
        ab1.Cost_Share_Increment__c = '10';
        ab1.Cost_Share_InvalidIncrements__c = '30';
        ab1.Cost_Share_AdditionalIncrements__c = '33';
        ab1.OON_Cost_Share_Low__c = '0';
        ab1.OON_Cost_Share_High__c = '1000';
        ab1.OON_Cost_Share_Increment__c = '100';
        ab1.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab1.OON_Cost_Share_InvalidIncrements__c = '300';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_2_DefaultAmount__c ='No';
        ab1.IS_ASO_Only__c = false;
        ab1.Benefit_Summary_Comment__c='test comment';
        insert ab1;  

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        apbt.IS_ASO_Only__c='Yes';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.Type__c='Cost Share';
        apbt1.IS_ASO_Only__c='No';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        apcty1.AnnualMaximumApplies__c='Yes';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        apcty.AnnualMaximumApplies__c='No';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'MaxRow';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
        aplObj.MandateIndicator__c = false;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;
        //start offshore limitations
            Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab1.id,True,'Maxrow');
            lmt.TierLimit_Selected__c=true;
            lmt.Benefit__c = ab1.id;
            lmt.TierLimitFrom__c = 2;
            lmt.TierLimitType__c = 'Days';
            lmt.TierLimitTo__c = 44;
            lmt.TierLimitDurationType__c = 'Lifetime';
            insert lmt;
            Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab1.id,True,'TierLimit');
            lmt2.Benefit__c = ab1.id;
            lmt2.TierAge_Selected__c=true;
            lmt2.TierAgeType__c = 'Years';
            lmt2.TierAgeFrom__c = 23;
            lmt2.TierLimitTo__c = 44;
            lmt2.MaxDuration_Selected__c=true;
            lmt2.MaxValue__c = 33;
            lmt2.MaxDuration__c = 2;
            lmt2.MaxDurationType__c = 'Day';
            lmt2.MaxApply__c = 'Per Breast';
            lmt2.MaxType__c = 'Dollars';
            lmt2.MaxAge_Selected__c=true;
            lmt2.MaxAgeFrom__c = 3;
            lmt2.MaxAgeTo__c = 23;
            lmt2.MaxAgeType__c = 'Days';
            lmt2.IS_ASO_Only__c=false;
            insert lmt2;
        
        //end
        string bpdID = aiaBDP1.id;
        
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDP1);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);
        ext.rowOrder = 1;
        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDP1);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDP1);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        
        //ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
    public static testmethod void AIA_BenefitDesign_SummaryController_TestCase10(){
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*///as per US210

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
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        
        insert userList;       
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
        /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
        
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
       // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Dental');
        pp.Benefit_Request_Form__c = brf.id;
        pp.Funding_Arrangement__c = 'ASO';
        //mod for drug
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
        pp.Rider__c='None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.Id;
        Imp1.Account__c = acc.Id;
        //Imp1.Generate_Workplan_Stages__c = true;//as per US210
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Benefit_Request_Form__c = brf.id;
        lstImp.add(Imp1);

        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;//as per US210
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        lstImp.add(Imp);
        if(lstImp != NULL && lstImp.size()>0)
            insert lstImp;
        system.assertNOTEquals(lstImp.size(),Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c=aiaBD.id;
        aiaBDP1.Plan_Name__c=aiapln.id;
        aiaBDP1.Proposed_Products__c=PP.id;     
        aiaBDP1.Funding_Arrangement__c = 'Risk';
        aiaBDP1.Product_Category__c ='Dental';
        aiaBDP1.Has_Benefit_Details__c = false;
        insert aiaBDP1;  
         
        aiaBDP1 = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                   From AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     
        system.assertNOTEquals(aiaBDP1,Null);
        
        
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'CostShareRanges';
        ag1.Group_Type__c = 'Benefit Group';
        ag1.Benefit_Design_Product__c = aiaBDP1.id;
        ag1.Grouper_Record_Type__c = 'BDD';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp.id;
        insert ag1;

        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag1.id;
        ab1.Benefit_Name__c = 'Individual Out Of Pocket';
        ab1.Benefit_Type__c = 'Benefit';
        ab1.Type__c = 'Cost Share';        
        ab1.Benefit_Record_Type__c = 'BDD';
        ab1.Cost_Share_Low__c = '0';
        ab1.Cost_Share_High__c = '100';
        ab1.Cost_Share_Increment__c = '10';
        ab1.Cost_Share_InvalidIncrements__c = '30';
        ab1.Cost_Share_AdditionalIncrements__c = '33';
        ab1.OON_Cost_Share_Low__c = '0';
        ab1.OON_Cost_Share_High__c = '1000';
        ab1.OON_Cost_Share_Increment__c = '100';
        ab1.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab1.OON_Cost_Share_InvalidIncrements__c = '300';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_2_DefaultAmount__c ='No';
        ab1.IS_ASO_Only__c = false;
        insert ab1;  

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.Type__c='Cost Share';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'MaxRow';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
        aplObj.MandateIndicator__c = false;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;
        
        string bpdID = aiaBDP1.id;
        
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDP1);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);
        ext.rowOrder = 0;
        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDP1);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDP1);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        
        ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
        
         public static testmethod void AIA_BenefitDesign_SummaryController_TestCase10Benefit(){
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*///as per US210

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
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        
        insert userList;       
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
        
        /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
       // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Dental');
        pp.Benefit_Request_Form__c = brf.id;
        pp.Funding_Arrangement__c = 'ASO';
        //mod for drug
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
        pp.Rider__c='None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.Id;
        Imp1.Account__c = acc.Id;
        //Imp1.Generate_Workplan_Stages__c = true;//as per US210
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Benefit_Request_Form__c = brf.id;
        lstImp.add(Imp1);

        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;//as per US210
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        lstImp.add(Imp);
        if(lstImp != NULL && lstImp.size()>0)
            insert lstImp;
        system.assertNOTEquals(lstImp.size(),Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c=aiaBD.id;
        aiaBDP1.Plan_Name__c=aiapln.id;
        aiaBDP1.Proposed_Products__c=PP.id;     
        aiaBDP1.Funding_Arrangement__c = 'Risk';
        aiaBDP1.Product_Category__c ='Dental';
        aiaBDP1.Has_Benefit_Details__c = true;
        insert aiaBDP1;  
         
        aiaBDP1 = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                   From AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     
        system.assertNOTEquals(aiaBDP1,Null);
        
        
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'CostShareRanges';
        ag1.Group_Type__c = 'Benefit Group';
        ag1.Benefit_Design_Product__c = aiaBDP1.id;
        ag1.Grouper_Record_Type__c = 'BDD';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp.id;
        insert ag1;

        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag1.id;
        ab1.Benefit_Name__c = 'Individual Out Of Pocket';
        ab1.Benefit_Type__c = 'Benefit';
        ab1.Type__c = 'Benefit'; //   Cost Share to benefit to cover benefit for loop      
        ab1.Benefit_Record_Type__c = 'BDD';
        ab1.Cost_Share_Low__c = '0';
        ab1.Cost_Share_High__c = '100';
        ab1.Cost_Share_Increment__c = '10';
        ab1.Cost_Share_InvalidIncrements__c = '30';
        ab1.Cost_Share_AdditionalIncrements__c = '33';
        ab1.OON_Cost_Share_Low__c = '0';
        ab1.OON_Cost_Share_High__c = '1000';
        ab1.OON_Cost_Share_Increment__c = '100';
        ab1.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab1.OON_Cost_Share_InvalidIncrements__c = '300';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_2_DefaultAmount__c ='No';
        ab1.IS_ASO_Only__c = false;
        insert ab1;  

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        apg.IsCovered__c='true';
        apg.AnnualMaximumApplies__c='Y';
        apg.DeductibleApplies__c='Y';
        insert apg;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
          
          
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.Type__c='Cost Share';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'MaxRow';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
        aplObj.MandateIndicator__c = false;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;
        
        string bpdID = aiaBDP1.id;
        
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDP1);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);
        ext.rowOrder = 0;
        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDP1);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDP1);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        
        ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
        
    public static testmethod void AIA_BenefitDesign_SummaryController_TestCase11(){
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*///as per US210

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
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        
        insert userList;       
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
        
        /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
       // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Dental');
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
        pp.Has_Benefit_Details__c =true;
        pp.Rider__c='None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.Id;
        Imp1.Account__c = acc.Id;
        //Imp1.Generate_Workplan_Stages__c = true;//as per US210
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Benefit_Request_Form__c = brf.id;
        lstImp.add(Imp1);

        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;//as per US210
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        lstImp.add(Imp);
        if(lstImp != NULL && lstImp.size()>0)
            insert lstImp;
        system.assertNOTEquals(lstImp.size(),Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c=aiaBD.id;
        aiaBDP1.Plan_Name__c=aiapln.id;
        aiaBDP1.Proposed_Products__c=PP.id;     
        aiaBDP1.Funding_Arrangement__c = 'ASO';
        aiaBDP1.Product_Category__c = 'Drug';
        aiaBDP1.Has_Benefit_Details__c = true;
        insert aiaBDP1;  
         
        aiaBDP1 = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                   From AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     
        system.assertNOTEquals(aiaBDP1,Null);
        
        
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'Cost Share Group';
        ag1.Group_Type__c = 'Cost Share Group';
        ag1.Benefit_Design_Product__c = aiaBDP1.id;
        ag1.Grouper_Record_Type__c = 'BDD';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp.id;
        insert ag1;

        list<AIA_Benefits__c> lstBen = new list<AIA_Benefits__c>();

        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag1.id;
        ab1.Benefit_Name__c = 'PCP Copay';
        ab1.Benefit_Type__c = 'Benefit';
        ab1.Type__c = 'Cost Share';           
        ab1.Benefit_Record_Type__c = 'BDD';
        ab1.Cost_Share_Low__c = '0';
        ab1.Cost_Share_High__c = '100';
        ab1.Cost_Share_Increment__c = '10';
        ab1.Cost_Share_InvalidIncrements__c = '30';
        ab1.Cost_Share_AdditionalIncrements__c = '33';
        ab1.OON_Cost_Share_Low__c = '0';
        ab1.OON_Cost_Share_High__c = '1000';
        ab1.OON_Cost_Share_Increment__c = '100';
        ab1.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab1.OON_Cost_Share_InvalidIncrements__c = '300';
        ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_IsCovered__c = 'No';
        ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_2_DefaultAmount__c ='No';
        ab1.IS_ASO_Only__c = false;
        lstBen.add(ab1);  

        AIA_Benefits__c ab2 = new AIA_Benefits__c();           
        ab2.Grouper__c = ag1.id;
        ab2.Benefit_Name__c = 'Specialist Copay';
        ab2.Benefit_Type__c = 'Benefit';
        ab2.Type__c = 'Cost Share';           
        ab2.Benefit_Record_Type__c = 'BDD';
        ab2.Cost_Share_Low__c = '0';
        ab2.Cost_Share_High__c = '100';
        ab2.Cost_Share_Increment__c = '10';
        ab2.Cost_Share_InvalidIncrements__c = '30';
        ab2.Cost_Share_AdditionalIncrements__c = '33';
        ab2.OON_Cost_Share_Low__c = '0';
        ab2.OON_Cost_Share_High__c = '1000';
        ab2.OON_Cost_Share_Increment__c = '100';
        ab2.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab2.OON_Cost_Share_InvalidIncrements__c = '300';
        ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab2.Copay_Type_1_IsCovered__c = 'No';
        ab2.OON_Copay_Type_1_IsCovered__c = 'No';
        ab2.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab2.Copay_Type_1_AliasName__c='Test';
        ab2.Copay_Type_2_AliasName__c='Test';
        ab2.OON_Copay_Type_1_AliasName__c='Test';
        ab2.OON_Copay_Type_2_AliasName__c='Test';
        ab2.OON_Copay_Type_2_DefaultAmount__c ='No';
        ab2.IS_ASO_Only__c = false;
        lstBen.add(ab2);  

        AIA_Benefits__c ab3 = new AIA_Benefits__c();           
        ab3.Grouper__c = ag1.id;
        ab3.Benefit_Name__c = 'Per Admission Copay';
        ab3.Benefit_Type__c = 'Benefit';
        ab3.Type__c = 'Cost Share';           
        ab3.Benefit_Record_Type__c = 'BDD';
        ab3.Cost_Share_Low__c = '0';
        ab3.Cost_Share_High__c = '100';
        ab3.Cost_Share_Increment__c = '10';
        ab3.Cost_Share_InvalidIncrements__c = '30';
        ab3.Cost_Share_AdditionalIncrements__c = '33';
        ab3.OON_Cost_Share_Low__c = '0';
        ab3.OON_Cost_Share_High__c = '1000';
        ab3.OON_Cost_Share_Increment__c = '100';
        ab3.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab3.OON_Cost_Share_InvalidIncrements__c = '300';
        ab3.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab3.Copay_Type_1_IsCovered__c = 'No';
        ab3.OON_Copay_Type_1_IsCovered__c = 'No';
        ab3.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab3.Copay_Type_1_AliasName__c='Test';
        ab3.Copay_Type_2_AliasName__c='Test';
        ab3.OON_Copay_Type_1_AliasName__c='Test';
        ab3.OON_Copay_Type_2_AliasName__c='Test';
        ab3.OON_Copay_Type_2_DefaultAmount__c ='No';
        ab3.IS_ASO_Only__c = false;
        lstBen.add(ab3);

        AIA_Benefits__c ab4 = new AIA_Benefits__c();           
        ab4.Grouper__c = ag1.id;
        ab4.Benefit_Name__c = 'Coinsurance';
        ab4.Benefit_Type__c = 'Benefit';
        ab4.Type__c = 'Cost Share';           
        ab4.Benefit_Record_Type__c = 'BDD';
        ab4.Cost_Share_Low__c = '0';
        ab4.Cost_Share_High__c = '100';
        ab4.Cost_Share_Increment__c = '10';
        ab4.Cost_Share_InvalidIncrements__c = '30';
        ab4.Cost_Share_AdditionalIncrements__c = '33';
        ab4.OON_Cost_Share_Low__c = '0';
        ab4.OON_Cost_Share_High__c = '1000';
        ab4.OON_Cost_Share_Increment__c = '100';
        ab4.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab4.OON_Cost_Share_InvalidIncrements__c = '300';
        ab4.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab4.Copay_Type_1_IsCovered__c = 'No';
        ab4.OON_Copay_Type_1_IsCovered__c = 'No';
        ab4.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab4.Copay_Type_1_AliasName__c='Test';
        ab4.Copay_Type_2_AliasName__c='Test';
        ab4.OON_Copay_Type_1_AliasName__c='Test';
        ab4.OON_Copay_Type_2_AliasName__c='Test';
        ab4.OON_Copay_Type_2_DefaultAmount__c ='No';
        ab4.IS_ASO_Only__c = false;
        lstBen.add(ab4);

        AIA_Benefits__c ab5 = new AIA_Benefits__c();           
        ab5.Grouper__c = ag1.id;
        ab5.Benefit_Name__c = 'General Copay';
        ab5.Benefit_Type__c = 'Benefit';
        ab5.Type__c = 'Cost Share';           
        ab5.Benefit_Record_Type__c = 'BDD';
        ab5.Cost_Share_Low__c = '0';
        ab5.Cost_Share_High__c = '100';
        ab5.Cost_Share_Increment__c = '10';
        ab5.Cost_Share_InvalidIncrements__c = '30';
        ab5.Cost_Share_AdditionalIncrements__c = '33';
        ab5.OON_Cost_Share_Low__c = '0';
        ab5.OON_Cost_Share_High__c = '1000';
        ab5.OON_Cost_Share_Increment__c = '100';
        ab5.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab5.OON_Cost_Share_InvalidIncrements__c = '300';
        ab5.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab5.Copay_Type_1_IsCovered__c = 'No';
        ab5.OON_Copay_Type_1_IsCovered__c = 'No';
        ab5.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab5.Copay_Type_1_AliasName__c='Test';
        ab5.Copay_Type_2_AliasName__c='Test';
        ab5.OON_Copay_Type_1_AliasName__c='Test';
        ab5.OON_Copay_Type_2_AliasName__c='Test';
        ab5.OON_Copay_Type_2_DefaultAmount__c ='No';
        ab5.IS_ASO_Only__c = false;
        lstBen.add(ab5);
        insert lstBen;

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.Type__c='Cost Share';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'MaxRow';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
        aplObj.MandateIndicator__c = false;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        planList.add(aplObj);
        insert planList;
        
      
          
          list<Limitations__c> lstLimit = new list<Limitations__c>();
          Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab4.id, True, 'Maxrow');
          lmt.IS_ASO_Only__c=false;
          lstLimit.add(lmt);
          Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab5.id, True, 'TierLimit');
                  lmt2.IS_ASO_Only__c=false;
      lstLimit.add(lmt2);
          
          insert lstLimit;

        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;
        
        string bpdID = aiaBDP1.id;
        
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDP1);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);
        ext.rowOrder = 1;
        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDP1);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDP1);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        
        //ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
     public static testmethod void AIA_BenefitDesign_SummaryController_TestCase12(){
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*///as per US210

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
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        
        insert userList;       
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
        
        /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Dental');
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
        pp.Has_Benefit_Details__c =true;
         pp.Rider__c='None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
        AIA_Implementation__c Imp1 = new AIA_Implementation__c();
        Imp1.Name__c = 'testprf';
        Imp1.Opportunity__c = o.Id;
        Imp1.Account__c = acc.Id;
        //Imp1.Generate_Workplan_Stages__c = true;//as per US210
        Imp1.Effective_Date__c = system.today();
        Imp1.Implementation_Plan_Timeline_Days__c = '60';
        Imp1.Risk_Type__c='ASO';
        Imp1.Benefit_Request_Form__c = brf.id;
        lstImp.add(Imp1);

        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;//as per US210
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        lstImp.add(Imp);
        if(lstImp != NULL && lstImp.size()>0)
            insert lstImp;
        system.assertNOTEquals(lstImp.size(),Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c=aiaBD.id;
        aiaBDP1.Plan_Name__c=aiapln.id;
        aiaBDP1.Proposed_Products__c=PP.id;     
        aiaBDP1.Funding_Arrangement__c = 'ASO';
        aiaBDP1.Product_Category__c = 'Drug';
        aiaBDP1.Has_Benefit_Details__c = true;
        insert aiaBDP1;  
         
        aiaBDP1 = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                   From AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     
        system.assertNOTEquals(aiaBDP1,Null);
        
          AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
          RXgrouper.Name = 'Retail NonMaintenance';
          RXgrouper.Group_Type__c = 'Benefit Group';
          RXgrouper.Grouper_Record_Type__c = 'BDD';
          //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'BD Product');
          RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
          RXgrouper.Sequence_Number__c = 1;
          RXgrouper.Proposed_Products__c = pp.id;
          RXgrouper.Benefit_Design_Product__c = aiaBDP1.id;
          insert RXgrouper;

          list<AIA_Benefits__c> lstBen = new list<AIA_Benefits__c>();
          AIA_Benefits__c ab3 = new AIA_Benefits__c();
          ab3.Grouper__c = RXgrouper.id;
          ab3.Benefit_Name__c = 'Retail NonMaintenance Generic Ben';
          ab3.Benefit_Type__c = 'Benefit';
          ab3.Copay_Type_1_Mandate_Name__c = 'Test';
          ab3.Type__c = 'Benefit';  
          ab3.Benefit_Record_Type__c = 'BDD';
          ab3.CoInsurance_AmountValueSelected__c = '10';
          ab3.Copay_Type_1_IsCovered__c = 'Yes';
          ab3.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab3.AnnualMaximumApplies__c = 'Yes';  
          ab3.OON_CoInsurance_AmountValueSelected__c = '10';
          ab3.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab3.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab3.OON_AnnualMaximumApplies__c = 'Yes';
          lstBen.add(ab3); 
          
          AIA_Benefits__c ab4 = new AIA_Benefits__c();
          ab4.Grouper__c = RXgrouper.id;
          ab4.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand Ben';
          ab4.Benefit_Type__c = 'Benefit';
          ab4.Copay_Type_1_Mandate_Name__c = 'Test';
          ab4.Type__c = 'Benefit';  
          ab4.Benefit_Record_Type__c = 'BDD';
          ab4.CoInsurance_AmountValueSelected__c = '10';
          ab4.Copay_Type_1_IsCovered__c = 'Yes';
          ab4.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab4.AnnualMaximumApplies__c = 'Yes';  
          ab4.OON_CoInsurance_AmountValueSelected__c = '10';
          ab4.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab4.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab4.OON_AnnualMaximumApplies__c = 'Yes';
          lstBen.add(ab4);
          
          AIA_Benefits__c ab5 = new AIA_Benefits__c();
          ab5.Grouper__c = RXgrouper.id;
          ab5.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand Ben';
          ab5.Benefit_Type__c = 'Benefit';
          ab5.Copay_Type_1_Mandate_Name__c = 'Test';
          ab5.Type__c = 'Benefit';  
          ab5.Benefit_Record_Type__c = 'BDD';
          ab5.CoInsurance_AmountValueSelected__c = '10';
          ab5.Copay_Type_1_IsCovered__c = 'Yes';
          ab5.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab5.AnnualMaximumApplies__c = 'Yes';  
          ab5.OON_CoInsurance_AmountValueSelected__c = '10';
          ab5.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab5.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab5.OON_AnnualMaximumApplies__c = 'Yes';
          lstBen.add(ab5); 
          
          AIA_Benefits__c ab6 = new AIA_Benefits__c();
          ab6.Grouper__c = RXgrouper.id;
          ab6.Benefit_Name__c = 'Retail NonMaintenance Self-Injectab6le Ben';
          ab6.Benefit_Type__c = 'Limitation';
          ab6.Copay_Type_1_Mandate_Name__c = 'Test';
          ab6.Type__c = 'Benefit';  
          ab6.Benefit_Record_Type__c = 'BDD';
          ab6.CoInsurance_AmountValueSelected__c = '10';
          ab6.Copay_Type_1_IsCovered__c = 'Yes';
          ab6.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab6.AnnualMaximumApplies__c = 'Yes';  
          ab6.OON_CoInsurance_AmountValueSelected__c = '10';
          ab6.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab6.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab6.OON_AnnualMaximumApplies__c = 'Yes';
         ab6.IS_ASO_Only__c=false;
         ab6.Benefit_Summary_Comment__c='test comm';//mod
          lstBen.add(ab6); 
          insert lstBen;
          
          list<Limitations__c> lstLimit = new list<Limitations__c>();
          Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab6.id, True, 'Maxrow');
          lstLimit.add(lmt);
          Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab5.id, True, 'TierLimit');
          lstLimit.add(lmt2);
          Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab4.id, True, 'Comment');
          lstLimit.add(lmt3);
          insert lstLimit;

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.Type__c='Cost Share';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'MaxRow';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
        aplObj.MandateIndicator__c = false;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;
        
        string bpdID = aiaBDP1.id;
        
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDP1);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);
        ext.rowOrder = 1;
        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDP1);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDP1);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        
        //ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
      public static testmethod void AIA_BenefitDesign_SummaryController_TestCase13(){
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*///as per US210

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
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        
        insert userList;       
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
        
        /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
      //  brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'Federal';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Dental');
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
        pp.Has_Benefit_Details__c =true;
         pp.Rider__c='None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c=aiaBD.id;
        aiaBDP1.Plan_Name__c=aiapln.id;
        aiaBDP1.Proposed_Products__c=PP.id;     
        aiaBDP1.Funding_Arrangement__c = 'ASO';
        aiaBDP1.Product_Category__c = 'Drug';
        aiaBDP1.Has_Benefit_Details__c = true;
        insert aiaBDP1;  
         
        aiaBDP1 = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                   From AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     
        system.assertNOTEquals(aiaBDP1,Null);

          AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
          RXgrouper.Name = 'Retail NonMaintenance';
          RXgrouper.Group_Type__c = 'Benefit Group';
          RXgrouper.Grouper_Record_Type__c = 'BDD';
          //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'BD Product');
          RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
          RXgrouper.Benefit_Design_Product__c = aiaBDP1.id;
          RXgrouper.Proposed_Products__c = pp.id;
          insert RXgrouper;

          list<AIA_Benefits__c> lstBen = new list<AIA_Benefits__c>();
          AIA_Benefits__c ab3 = new AIA_Benefits__c();
          ab3.Grouper__c = RXgrouper.id;
          ab3.Benefit_Name__c = 'Retail NonMaintenance Generic';
          ab3.Benefit_Type__c = 'Benefit';
          ab3.Copay_Type_1_Mandate_Name__c = 'Test';
          ab3.Type__c = 'Benefit';  
          ab3.Benefit_Record_Type__c = 'BDD';
          ab3.CoInsurance_AmountValueSelected__c = '10';
          ab3.Copay_Type_1_IsCovered__c = 'No';
          ab3.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab3.AnnualMaximumApplies__c = 'Yes';  
          ab3.OON_CoInsurance_AmountValueSelected__c = '10';
          ab3.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab3.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab3.OON_AnnualMaximumApplies__c = 'Yes';
          lstBen.add(ab3); 
          
          AIA_Benefits__c ab4 = new AIA_Benefits__c();
          ab4.Grouper__c = RXgrouper.id;
          ab4.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand';
          ab4.Benefit_Type__c = 'Benefit';
          ab4.Copay_Type_1_Mandate_Name__c = 'Test';
          ab4.Type__c = 'Benefit';  
          ab4.Benefit_Record_Type__c = 'BDD';
          ab4.CoInsurance_AmountValueSelected__c = '10';
          ab4.Copay_Type_1_IsCovered__c = 'No';
          ab4.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab4.AnnualMaximumApplies__c = 'Yes';  
          ab4.OON_CoInsurance_AmountValueSelected__c = '10';
          ab4.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab4.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab4.OON_AnnualMaximumApplies__c = 'Yes';
          lstBen.add(ab4);
          
          AIA_Benefits__c ab5 = new AIA_Benefits__c();
          ab5.Grouper__c = RXgrouper.id;
          ab5.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand';
          ab5.Benefit_Type__c = 'Benefit';
          ab5.Copay_Type_1_Mandate_Name__c = 'Test';
          ab5.Type__c = 'Benefit';  
          ab5.Benefit_Record_Type__c = 'BDD';
          ab5.CoInsurance_AmountValueSelected__c = '10';
          ab5.Copay_Type_1_IsCovered__c = 'No';
          ab5.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab5.AnnualMaximumApplies__c = 'Yes';  
          ab5.OON_CoInsurance_AmountValueSelected__c = '10';
          ab5.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab5.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab5.OON_AnnualMaximumApplies__c = 'Yes';
          lstBen.add(ab5); 
          
          AIA_Benefits__c ab6 = new AIA_Benefits__c();
          ab6.Grouper__c = RXgrouper.id;
          ab6.Benefit_Name__c = 'Retail NonMaintenance Self-Injectable';
          ab6.Benefit_Type__c = 'Benefit';
          ab6.Copay_Type_1_Mandate_Name__c = 'Test';
          ab6.Type__c = 'Benefit';  
          ab6.Benefit_Record_Type__c = 'BDD';
          ab6.CoInsurance_AmountValueSelected__c = '10';
          ab6.Copay_Type_1_IsCovered__c = 'No';
          ab6.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab6.AnnualMaximumApplies__c = 'Yes';  
          ab6.OON_CoInsurance_AmountValueSelected__c = '10';
          ab6.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab6.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab6.OON_AnnualMaximumApplies__c = 'Yes';
          lstBen.add(ab6); 
          insert lstBen;
          
          list<Limitations__c> lstLimit = new List<Limitations__c>();
          Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab6.id, True, 'Maxrow');
         lmt.IS_ASO_Only__c=false;//mod
         lstLimit.add(lmt);
          Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab4.id, True, 'TierLimit');
          lstLimit.add(lmt2);
          Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab5.id, True, 'Comment');
          lstLimit.add(lmt3);
          insert lstLimit;

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.IS_ASO_Only__c = 'No';
        apbt1.Type__c='Cost Share';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        apl.Effective_Date__c = system.today();
        apl.Term_Date__c = system.today();
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'TierLimit';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
        aplObj.MandateIndicator__c = true;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        aplObj.Effective_Date__c = system.today()-1;
        aplObj.Term_Date__c = system.today()+1;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;
        
        string bpdID = aiaBDP1.id;
        
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDP1);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);
        ext.rowOrder = 1;
        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDP1);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDP1);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        
        //ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
    public static testmethod void AIA_BenefitDesign_SummaryController_RXCustomName(){
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);//Copay_Type_2_Amount_Customized__c*///as per US210

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
        
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        
        insert userList;       
        system.assertNOTEquals(userList.size(),Null);
        
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
        
       /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));/*R1 added teammember*/
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
        o.type = 'Drug Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        //o.Workplan_Type__c = wpt.id;//as per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
      //  brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Request_Type__c = 'Prospect/New';
        insert brf;
        system.assertNOTEquals(brf,Null);


        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'Federal';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        createPlanData(aiapln);
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Dental');
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
        pp.Has_Benefit_Details__c =true;
         pp.Rider__c='None';
                insert pp;
        system.assertNOTEquals(pp,Null);
        
        test.starttest();  
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = brf.Id;
        insert aiaBD;
        system.assertNOTEquals(aiaBD,Null);
        
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c=aiaBD.id;
        aiaBDP1.Plan_Name__c=aiapln.id;
        aiaBDP1.Proposed_Products__c=PP.id;     
        aiaBDP1.Funding_Arrangement__c = 'ASO';
        aiaBDP1.Product_Category__c = 'Drug';
        aiaBDP1.Has_Benefit_Details__c = true;
         aiaBDP1.Integrated_Deductibles__c = 'No';
        aiaBDP1.Integrated_OOP_Integration__c = 'No';

        insert aiaBDP1;  
         
        aiaBDP1 = [Select Id,Has_Benefit_Details__c,Integrated_Deductibles__c ,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                   ,Integrated_OOP_Integration__c  From AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     
        system.assertNOTEquals(aiaBDP1,Null);

          AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
          RXgrouper.Name = 'Retail NonMaintenance';
          RXgrouper.Group_Type__c = 'Benefit Group';
          RXgrouper.Grouper_Record_Type__c = 'BDD';
          //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'BD Product');
          RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
          RXgrouper.Benefit_Design_Product__c = aiaBDP1.id;
          RXgrouper.Proposed_Products__c = pp.id;
          insert RXgrouper;

          list<AIA_Benefits__c> lstBen = new list<AIA_Benefits__c>();
          AIA_Benefits__c ab3 = new AIA_Benefits__c();
          ab3.Grouper__c = RXgrouper.id;
          ab3.Benefit_Name__c = 'Retail NonMaintenance Generic';
          ab3.Benefit_Type__c = 'Benefit';
          ab3.Copay_Type_1_Mandate_Name__c = 'Test';
          ab3.Type__c = 'Benefit';  
          ab3.Benefit_Record_Type__c = 'BDD';
          ab3.CoInsurance_AmountValueSelected__c = '10';
          ab3.Copay_Type_1_IsCovered__c = 'Yes';
          ab3.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab3.AnnualMaximumApplies__c = 'Yes';  
          ab3.OON_CoInsurance_AmountValueSelected__c = '10';
          ab3.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab3.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab3.OON_AnnualMaximumApplies__c = 'Yes';
          lstBen.add(ab3); 
          
          AIA_Benefits__c ab4 = new AIA_Benefits__c();
          ab4.Grouper__c = RXgrouper.id;
          ab4.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand';
          ab4.Benefit_Type__c = 'Benefit';
          ab4.Copay_Type_1_Mandate_Name__c = 'Test';
          ab4.Type__c = 'Benefit';  
          ab4.Benefit_Record_Type__c = 'BDD';
          ab4.CoInsurance_AmountValueSelected__c = '10';
          ab4.Copay_Type_1_IsCovered__c = 'Yes';
          ab4.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab4.AnnualMaximumApplies__c = 'Yes';  
          ab4.OON_CoInsurance_AmountValueSelected__c = '10';
          ab4.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab4.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab4.OON_AnnualMaximumApplies__c = 'Yes';
          lstBen.add(ab4);
          
          AIA_Benefits__c ab5 = new AIA_Benefits__c();
          ab5.Grouper__c = RXgrouper.id;
          ab5.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand';
          ab5.Benefit_Type__c = 'Benefit';
          ab5.Copay_Type_1_Mandate_Name__c = 'Test';
          ab5.Type__c = 'Benefit';  
          ab5.Benefit_Record_Type__c = 'BDD';
          ab5.CoInsurance_AmountValueSelected__c = '10';
          ab5.Copay_Type_1_IsCovered__c = 'Yes';
          ab5.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab5.AnnualMaximumApplies__c = 'Yes';  
          ab5.OON_CoInsurance_AmountValueSelected__c = '10';
          ab5.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab5.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab5.OON_AnnualMaximumApplies__c = 'Yes';
          lstBen.add(ab5); 
          
          AIA_Benefits__c ab6 = new AIA_Benefits__c();
          ab6.Grouper__c = RXgrouper.id;
          ab6.Benefit_Name__c = 'Retail NonMaintenance Self-Injectable';
          ab6.Benefit_Type__c = 'Benefit';
          ab6.Copay_Type_1_Mandate_Name__c = 'Test';
          ab6.Type__c = 'Benefit';  
          ab6.Benefit_Record_Type__c = 'BDD';
          ab6.CoInsurance_AmountValueSelected__c = '10';
          ab6.Copay_Type_1_IsCovered__c = 'Yes';
          ab6.Copay_Type_1_DeductibleApplies__c  = 'Yes';
          ab6.AnnualMaximumApplies__c = 'Yes';  
          ab6.OON_CoInsurance_AmountValueSelected__c = '10';
          ab6.OON_Copay_Type_1_IsCovered__c = 'Yes';
          ab6.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
          ab6.OON_AnnualMaximumApplies__c = 'Yes';
          lstBen.add(ab6); 
          insert lstBen;
          
          list<Limitations__c> lstLimit = new List<Limitations__c>();
          Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab6.id, True, 'Maxrow');
         lmt.IS_ASO_Only__c=false;//mod
         lstLimit.add(lmt);
          Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab4.id, True, 'TierLimit');
          lstLimit.add(lmt2);
          Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab5.id, True, 'Comment');
          lstLimit.add(lmt3);
          insert lstLimit;

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BDD';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BDD';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='Family Out Of Pocket';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BDD';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BDD';
        apbt1.Sequence_Number__c = 2;
        apbt1.Coinsurance_DefaultAmount__c = '2323';   
        apbt1.ISExisting_Benefit__c = True;
        apbt1.IS_ASO_Only__c = 'No';
        apbt1.Type__c='Cost Share';
        insert apbt1;

        List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
        AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
        apcty1.Plan_Benefits__c = apbt.id; 
        apcty1.DeductibleApplies__c = 'Yes';
        apcty1.AliasName__c = 'fhf';
        apcty1.IsCovered__c= 'Yes';
        apcty1.MandateIndicator__c='Yes';
        apcty1.CoinsuranceAmount__c='345';
        apcty1.Jurisdiction__c='gfhjh';
        apcty1.CopayAmount__c='67yuh';
        apcty1.MinPayAmount__c ='900';
        apcty1.MaxPayAmount__c='89';
        apcty1.TierType__c ='Generic';
        apcty1.Allowed_Amount__c ='100';
        apcty1.Approximate_Member_Payment_w_Discount__c ='120';
        apcty1.Discount_Amount__c ='10';
        planCopyLst.add(apcty1);


        AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
        apcty.Plan_Benefits__c = apbt1.id; 
        apcty.DeductibleApplies__c = 'Yes';
        apcty.AliasName__c = 'fhf';
        apcty.IsCovered__c= 'Yes';
        apcty.MandateIndicator__c='No';
        apcty.CoinsuranceAmount__c='345';
        apcty.Jurisdiction__c='gfhjh';
        apcty.CopayAmount__c='67yuh';
        apcty.MinPayAmount__c ='900';
        apcty.MaxPayAmount__c='89';
        apcty.TierType__c ='Preferred';
        apcty.Allowed_Amount__c ='90';
        apcty.Approximate_Member_Payment_w_Discount__c ='110';
        apcty.Discount_Amount__c ='20';
        planCopyLst.add(apcty);
        insert planCopyLst;   

        planCopyLst = [select id,name,Plan_Benefits__c,DeductibleApplies__c,AliasName__c,IsCovered__c,MandateIndicator__c,CoinsuranceAmount__c,Jurisdiction__c,CopayAmount__c,MinPayAmount__c,MaxPayAmount__c,TierType__c,Allowed_Amount__c,Approximate_Member_Payment_w_Discount__c,Discount_Amount__c  from AIA_Plan_Copay_Type__c  where id =: planCopyLst limit 10] ;

        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
        apl.Plan_Benefits__c = apbt.id;
        apl.MaxAgeType__c = 'Days';
        apl.Type__c = 'TierLimit';
        apl.Jurisdiction__c = 'Federal';
        apl.TierLimitType__c = 'Days';
        apl.MandateIndicator__c = false;
        apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        apl.TierLimitDurationType__c = 'Lifetime'; 
        apl.MaxAgeTo__c = 23;
        apl.MaxValue__c = 33;
        apl.TierAgeTo__c = 33;
        apl.TierLimitFrom__c = 2;
        apl.TierAgeType__c = 'Years';
        apl.TierAgeFrom__c = 23;
        apl.TierLimitTo__c = 44;
        apl.MaxApply__c = 'Per Breast';
        apl.MaxType__c = 'Dollars';
        apl.MaxDuration__c = 2;
        apl.MaxDurationType__c = 'Day';
        apl.MaxAgeFrom__c = 3;
        apl.Effective_Date__c = system.today();
        apl.Term_Date__c = system.today();
        planList.add(apl);


        AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
        aplObj.Plan_Benefits__c = apbt.id;
        aplObj.MaxAgeType__c = 'Days';
        aplObj.Type__c = 'TierLimit';
        aplObj.Jurisdiction__c = 'Federal';
        aplObj.TierLimitType__c = 'Days';
        aplObj.MandateIndicator__c = true;
        aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
        aplObj.TierLimitDurationType__c = 'Lifetime'; 
        aplObj.MaxAgeTo__c = 23;
        aplObj.MaxValue__c = 33;
        aplObj.TierAgeTo__c = 33;
        aplObj.TierLimitFrom__c = 2;
        aplObj.TierAgeType__c = 'Years';
        aplObj.TierAgeFrom__c = 23;
        aplObj.TierLimitTo__c = 44;
        
        aplObj.MaxApply__c = 'Per Breast';
        aplObj.MaxType__c = 'Dollars';
        aplObj.MaxDuration__c = 2;
        aplObj.MaxDurationType__c = 'Day';
        aplObj.MaxAgeFrom__c = 3;
        aplObj.Effective_Date__c = system.today()-1;
        aplObj.Term_Date__c = system.today()+1;
        planList.add(aplObj);
        insert planList;



        List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
        AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc.Plan_Limitation__c = planList[0].id;
        apbcc.Code__c = 2323;
        apbcc.Comment__c = 'ewfweger';
        apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
        pbCCodeList.add(apbcc);
        AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc1.Plan_Limitation__c = planList[1].id;
        apbcc1.Code__c = 2323;
        apbcc1.Comment__c = 'ewfweger';
        apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
        pbCCodeList.add(apbcc1);
        AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
        apbcc2.Code__c = 2323;
        apbcc2.Comment__c = 'ewfweger';
        pbCCodeList.add(apbcc2);
        insert pbCCodeList;
        
        string bpdID = aiaBDP1.id;
        
        PageReference pref = Page.AIA_BenefitDesign_Summary;
        Test.setCurrentPage(pref);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        ApexPages.StandardController con = new ApexPages.StandardController(aiaBDP1);
        ApexPages.currentPage().getParameters().put('id', aiaBDP1.id);
        AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);
        ext.rowOrder = 1;
        ext.mainInit();
        //Commenting as part of US1650
        //ext.getPCSdata();
        boolean isReview = true; 
        ext.createWrapListFromPlan(aiaBDP1);
        ext.createListBDPExisting(bpdID);
        ext.createListFromPP(bpdID,isReview);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
        ext.SaveAndContinuePlanBenefits(aiaBDP1);
        //ext.hideErrorpanel();
        ext.showerror = true;
        ext.saveAndCon();
        ext.saveandRedirct();
        ext.reviewInit();
        
        //ext.dispatcherTemp();
        ext.back();
       test.stopTest(); 
    }
      
      public Static TestMethod void TestAIA_Benefit_SummaryControllerForGrouperdrug1ErrorMsg() {


  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
  wpt.Used_For__c = 'Pre-Sales';
  wpt.Workplan_Type__c = 'New';
  wpt.Active__c = true;
  insert wpt;*///as per US210

   Account acc = AIA_TestUtil.CreateAccount('TestAccount');
   
   /*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
          //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        userList.add(u15);
       insert userlist;
      // List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
      List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom 
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
          //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
 insert acctMbrList;
/*R1 added teammember*/

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
  //o.Workplan_Type__c = wpt.id;//as per US210
  o.StageName = 'RFP';
  o.FullServiceProducer__c = 'Direct';
  insert o;

    Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
       // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
  aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
  aiapln.Jurisdiction__c = 'MD';
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
  pp.Has_Benefit_Details__c = True;
        pp.Rider__c='None';
  pp.Network__c = 'National';
  pp.Exclusive_Specialty_Provider_Network__c = 'Yes';   
  pp.ExtraCare_Health_Care_Card__c = 'No';   //Changed from 'Yes'
  pp.Maintenance_Choice__c = 'None';   
  pp.OralChemoMandateApply__c = 'No';   
  pp.Integrated_Deductible_Integrator__c = 'No';
  pp.Integrated_OOP_Integration__c = 'Yes';
  insert pp;
  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
  RXgrouper.Name = 'Retail NonMaintenance';
  RXgrouper.Group_Type__c = 'Benefit Group';
  RXgrouper.Grouper_Record_Type__c = 'BRF';
  //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
  RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();

  RXgrouper.Proposed_Products__c = pp.id;
  insert RXgrouper;

  AIA_Benefits__c ab7 = new AIA_Benefits__c();
  ab7.Grouper__c = RXgrouper.id;
  ab7.Benefit_Name__c = 'Retail NonMaintenance Generic Ben';
  ab7.Benefit_Type__c = 'Benefit';
  ab7.Copay_Type_1_Mandate_Name__c = 'Test';
  ab7.Type__c = 'Benefit';  
  ab7.Benefit_Record_Type__c = 'BRF';
  ab7.CoInsurance_AmountValueSelected__c = '10';
  ab7.Copay_Type_1_IsCovered__c = 'No';
  ab7.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab7.AnnualMaximumApplies__c = 'Yes';  
  ab7.OON_CoInsurance_AmountValueSelected__c = '10';
  ab7.OON_Copay_Type_1_IsCovered__c = 'No';
  ab7.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab7.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab7; 
  
  AIA_Benefits__c ab8 = new AIA_Benefits__c();
  ab8.Grouper__c = RXgrouper.id;
  ab8.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand Ben';
  ab8.Benefit_Type__c = 'Benefit';
  ab8.Copay_Type_1_Mandate_Name__c = 'Test';
  ab8.Type__c = 'Benefit';  
  ab8.Benefit_Record_Type__c = 'BRF';
  ab8.CoInsurance_AmountValueSelected__c = '10';
  ab8.Copay_Type_1_IsCovered__c = 'No';
  ab8.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab8.AnnualMaximumApplies__c = 'Yes';  
  ab8.OON_CoInsurance_AmountValueSelected__c = '10';
  ab8.OON_Copay_Type_1_IsCovered__c = 'No';
  ab8.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab8.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab8; 
  
  AIA_Benefits__c ab9 = new AIA_Benefits__c();
  ab9.Grouper__c = RXgrouper.id;
  ab9.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand Ben';
  ab9.Benefit_Type__c = 'Benefit';
  ab9.Copay_Type_1_Mandate_Name__c = 'Test';
  ab9.Type__c = 'Benefit';  
  ab9.Benefit_Record_Type__c = 'BRF';
  ab9.CoInsurance_AmountValueSelected__c = '10';
  ab9.Copay_Type_1_IsCovered__c = 'No';
  ab9.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab9.AnnualMaximumApplies__c = 'Yes';  
  ab9.OON_CoInsurance_AmountValueSelected__c = '10';
  ab9.OON_Copay_Type_1_IsCovered__c = 'No';
  ab9.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab9.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab9; 
  
  AIA_Benefits__c ab10 = new AIA_Benefits__c();
  ab10.Grouper__c = RXgrouper.id;
  ab10.Benefit_Name__c = 'Retail NonMaintenance Self-Injectab10le Ben';
  ab10.Benefit_Type__c = 'Benefit';
  ab10.Copay_Type_1_Mandate_Name__c = 'Test';
  ab10.Type__c = 'Benefit';  
  ab10.Benefit_Record_Type__c = 'BRF';
  ab10.CoInsurance_AmountValueSelected__c = '10';
  ab10.Copay_Type_1_IsCovered__c = 'No';
  ab10.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab10.AnnualMaximumApplies__c = 'Yes';  
  ab10.OON_CoInsurance_AmountValueSelected__c = '10';
  ab10.OON_Copay_Type_1_IsCovered__c = 'No';
  ab10.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab10.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab10; 
  

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
  ApexPages.currentPage().getParameters().put('id', pp.id);
  ApexPages.StandardController con = new ApexPages.StandardController(PP);
  ApexPages.currentPage().getParameters().put('id', '186');


  AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
  //  ext.mapPlanIdToPlan.put(aiapln.id,aiapln);
  ext.mainInit();
  ext.saveAndCon();
  ext.reviewInit();
  ext.getBenefitSummary_TO();
  ext.prodBtnClicked = 'drug';

  test.stoptest();
 }
        
        public Static TestMethod void TestAIA_Benefit_SummaryControllerForGrouperdrug1ErrorMsgmain() {

            try{
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
  wpt.Used_For__c = 'Pre-Sales';
  wpt.Workplan_Type__c = 'New';
  wpt.Active__c = true;
  insert wpt;*///as per US210

   Account acc = AIA_TestUtil.CreateAccount('TestAccount');
    /*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); 
 List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
                acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
 insert acctMbrList;
/*R1 added teammember*/

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
  //o.Workplan_Type__c = wpt.id;//as per US210
  o.StageName = 'RFP';
  o.FullServiceProducer__c = 'Direct';
  insert o;

    Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
       // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
  aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
  aiapln.Jurisdiction__c = 'MD';
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
  pp.Has_Benefit_Details__c = True;
        pp.Rider__c='None';
  pp.Network__c = 'National';
  pp.Exclusive_Specialty_Provider_Network__c = 'Yes';   
  pp.ExtraCare_Health_Care_Card__c = 'No';   //Changed from 'Yes'
  pp.Maintenance_Choice__c = 'None';   
  pp.OralChemoMandateApply__c = 'No';   
  pp.Integrated_Deductible_Integrator__c = 'No';
  pp.Integrated_OOP_Integration__c = 'Yes';
  insert pp;
  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
  RXgrouper.Name = 'Retail NonMaintenance';
  RXgrouper.Group_Type__c = 'Benefit Group';
  RXgrouper.Grouper_Record_Type__c = 'BRF';
  //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
  RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();

  RXgrouper.Proposed_Products__c = pp.id;
  insert RXgrouper;

  AIA_Benefits__c ab7 = new AIA_Benefits__c();
  ab7.Grouper__c = RXgrouper.id;
  ab7.Benefit_Name__c = 'Retail NonMaintenance Generic Ben';
  ab7.Benefit_Type__c = 'Benefit';
  ab7.Copay_Type_1_Mandate_Name__c = 'Test';
  ab7.Type__c = 'Benefit';  
  ab7.Benefit_Record_Type__c = 'BRF';
  ab7.CoInsurance_AmountValueSelected__c = '10';
  ab7.Copay_Type_1_IsCovered__c = 'No';
  ab7.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab7.AnnualMaximumApplies__c = 'Yes';  
  ab7.OON_CoInsurance_AmountValueSelected__c = '10';
  ab7.OON_Copay_Type_1_IsCovered__c = 'No';
  ab7.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab7.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab7; 
  
  AIA_Benefits__c ab8 = new AIA_Benefits__c();
  ab8.Grouper__c = RXgrouper.id;
  ab8.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand Ben';
  ab8.Benefit_Type__c = 'Benefit';
  ab8.Copay_Type_1_Mandate_Name__c = 'Test';
  ab8.Type__c = 'Benefit';  
  ab8.Benefit_Record_Type__c = 'BRF';
  ab8.CoInsurance_AmountValueSelected__c = '10';
  ab8.Copay_Type_1_IsCovered__c = 'No';
  ab8.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab8.AnnualMaximumApplies__c = 'Yes';  
  ab8.OON_CoInsurance_AmountValueSelected__c = '10';
  ab8.OON_Copay_Type_1_IsCovered__c = 'No';
  ab8.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab8.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab8; 
  
  AIA_Benefits__c ab9 = new AIA_Benefits__c();
  ab9.Grouper__c = RXgrouper.id;
  ab9.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand Ben';
  ab9.Benefit_Type__c = 'Benefit';
  ab9.Copay_Type_1_Mandate_Name__c = 'Test';
  ab9.Type__c = 'Benefit';  
  ab9.Benefit_Record_Type__c = 'BRF';
  ab9.CoInsurance_AmountValueSelected__c = '10';
  ab9.Copay_Type_1_IsCovered__c = 'No';
  ab9.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab9.AnnualMaximumApplies__c = 'Yes';  
  ab9.OON_CoInsurance_AmountValueSelected__c = '10';
  ab9.OON_Copay_Type_1_IsCovered__c = 'No';
  ab9.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab9.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab9; 
  
  AIA_Benefits__c ab10 = new AIA_Benefits__c();
  ab10.Grouper__c = 'asd';
  ab10.Benefit_Name__c = 'Retail NonMaintenance Self-Injectab10le Ben';
  ab10.Benefit_Type__c = 'Benefit';
  ab10.Copay_Type_1_Mandate_Name__c = 'Test';
  ab10.Type__c = 'Benefit';  
  ab10.Benefit_Record_Type__c = 'BRF';
  ab10.CoInsurance_AmountValueSelected__c = '10';
  ab10.Copay_Type_1_IsCovered__c = 'No';
  ab10.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab10.AnnualMaximumApplies__c = 'Yes';  
  ab10.OON_CoInsurance_AmountValueSelected__c = '10';
  ab10.OON_Copay_Type_1_IsCovered__c = 'No';
  ab10.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab10.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab10; 
  

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
  ApexPages.currentPage().getParameters().put('id', 'asd');
  ApexPages.StandardController con = new ApexPages.StandardController(PP);
  ApexPages.currentPage().getParameters().put('id', '186');


  AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
  //  ext.mapPlanIdToPlan.put(aiapln.id,aiapln);
  ext.mainInit();
  ext.saveAndCon();
  ext.reviewInit();
  ext.getBenefitSummary_TO();
  ext.prodBtnClicked = 'drug';

  test.stoptest();
            }
            catch(Exception e){
                system.debug('to cover error');
            }
            
 }
        
    public Static TestMethod void TestAIA_Benefit_SummaryControllerForGrouperdrug1() {


  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
  wpt.Used_For__c = 'Pre-Sales';
  wpt.Workplan_Type__c = 'New';
  wpt.Active__c = true;
  insert wpt;*///as per US210

   Account acc = AIA_TestUtil.CreateAccount('TestAccount');
   
   
   /*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); 
 List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
 insert acctMbrList;
/*R1 added teammember*/

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
 // o.Workplan_Type__c = wpt.id;//as per US210
  o.StageName = 'RFP';
  o.FullServiceProducer__c = 'Direct';
  insert o;

    Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
       // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
  aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
  aiapln.Jurisdiction__c = 'MD';
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
  pp.Has_Benefit_Details__c = True;
        pp.Rider__c='None';
  pp.Network__c = 'National';
  pp.Exclusive_Specialty_Provider_Network__c = 'Yes';   
  pp.ExtraCare_Health_Care_Card__c = 'Yes';   
  pp.Maintenance_Choice__c = 'None';   
  pp.OralChemoMandateApply__c = 'No';   
  pp.Integrated_Deductible_Integrator__c = 'No';
  pp.Integrated_OOP_Integration__c = 'Yes';
  insert pp;
  test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
  AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
  RXgrouper.Name = 'Retail NonMaintenance';
  RXgrouper.Group_Type__c = 'Benefit Group';
  RXgrouper.Grouper_Record_Type__c = 'BRF';
  //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
  RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();

  RXgrouper.Proposed_Products__c = pp.id;
  insert RXgrouper;

  AIA_Benefits__c ab7 = new AIA_Benefits__c();
  ab7.Grouper__c = RXgrouper.id;
  ab7.Benefit_Name__c = 'Retail NonMaintenance Generic Ben';
  ab7.Benefit_Type__c = 'Benefit';
  ab7.Copay_Type_1_Mandate_Name__c = 'Test';
  ab7.Type__c = 'Benefit';  
  ab7.Benefit_Record_Type__c = 'BRF';
  ab7.CoInsurance_AmountValueSelected__c = '10';
  ab7.Copay_Type_1_IsCovered__c = 'No';
  ab7.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab7.AnnualMaximumApplies__c = 'Yes';  
  ab7.OON_CoInsurance_AmountValueSelected__c = '10';
  ab7.OON_Copay_Type_1_IsCovered__c = 'No';
  ab7.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab7.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab7; 
  
  AIA_Benefits__c ab8 = new AIA_Benefits__c();
  ab8.Grouper__c = RXgrouper.id;
  ab8.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand Ben';
  ab8.Benefit_Type__c = 'Benefit';
  ab8.Copay_Type_1_Mandate_Name__c = 'Test';
  ab8.Type__c = 'Benefit';  
  ab8.Benefit_Record_Type__c = 'BRF';
  ab8.CoInsurance_AmountValueSelected__c = '10';
  ab8.Copay_Type_1_IsCovered__c = 'No';
  ab8.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab8.AnnualMaximumApplies__c = 'Yes';  
  ab8.OON_CoInsurance_AmountValueSelected__c = '10';
  ab8.OON_Copay_Type_1_IsCovered__c = 'No';
  ab8.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab8.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab8; 
  
  AIA_Benefits__c ab9 = new AIA_Benefits__c();
  ab9.Grouper__c = RXgrouper.id;
  ab9.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand Ben';
  ab9.Benefit_Type__c = 'Benefit';
  ab9.Copay_Type_1_Mandate_Name__c = 'Test';
  ab9.Type__c = 'Benefit';  
  ab9.Benefit_Record_Type__c = 'BRF';
  ab9.CoInsurance_AmountValueSelected__c = '10';
  ab9.Copay_Type_1_IsCovered__c = 'No';
  ab9.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab9.AnnualMaximumApplies__c = 'Yes';  
  ab9.OON_CoInsurance_AmountValueSelected__c = '10';
  ab9.OON_Copay_Type_1_IsCovered__c = 'No';
  ab9.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab9.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab9; 
  
  AIA_Benefits__c ab10 = new AIA_Benefits__c();
  ab10.Grouper__c = RXgrouper.id;
  ab10.Benefit_Name__c = 'Retail NonMaintenance Self-Injectab10le Ben';
  ab10.Benefit_Type__c = 'Benefit';
  ab10.Copay_Type_1_Mandate_Name__c = 'Test';
  ab10.Type__c = 'Benefit';  
  ab10.Benefit_Record_Type__c = 'BRF';
  ab10.CoInsurance_AmountValueSelected__c = '10';
  ab10.Copay_Type_1_IsCovered__c = 'No';
  ab10.Copay_Type_1_DeductibleApplies__c  = 'Yes';
  ab10.AnnualMaximumApplies__c = 'Yes';  
  ab10.OON_CoInsurance_AmountValueSelected__c = '10';
  ab10.OON_Copay_Type_1_IsCovered__c = 'No';
  ab10.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
  ab10.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab10; 
  

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
  ApexPages.currentPage().getParameters().put('id', pp.id);
  ApexPages.StandardController con = new ApexPages.StandardController(PP);
  ApexPages.currentPage().getParameters().put('id', pp.id);


  AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
  //  ext.mapPlanIdToPlan.put(aiapln.id,aiapln);
  ext.mainInit();
  ext.saveAndCon();
  ext.reviewInit();
  ext.getBenefitSummary_TO();
  ext.prodBtnClicked = 'drug';

  test.stoptest();
 }
public static testmethod void AIA_BenefitDesign_SummaryController_TestCase14(){
    /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
  wpt.Used_For__c = 'Pre-Sales';
  wpt.Workplan_Type__c = 'New';
  wpt.Active__c = true;
  insert wpt;*///as per US210
      //Account acc = AIA_TestUtil.CreateAccount('TestAccount');
Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
    //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
    		//acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
            /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
            /*R1 added teammember*/ acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));/*R1 added teammember*/
            /*R1 added teammember*/
            //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
    insert acctMbrList;
            
    
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
  //o.Workplan_Type__c = wpt.id;//as per US210
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
        insert brf;
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
  aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
  aiapln.Jurisdiction__c = 'MD';
  insert aiapln;
  
  Proposed_Products__c pp = new Proposed_Products__c();
  pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
  pp.Benefit_Request_Form__c = brf.id;
  pp.Funding_Arrangement__c = 'Risk';
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
    pp.Rider__c='None';
  pp.Network__c = 'National';
  pp.Exclusive_Specialty_Provider_Network__c = 'Yes';   
  pp.ExtraCare_Health_Care_Card__c = 'No'; //Changed from 'Yes'   
  pp.Maintenance_Choice__c = 'None';   
  pp.OralChemoMandateApply__c = 'No';   
  pp.Integrated_Deductible_Integrator__c = 'No';
  pp.Integrated_OOP_Integration__c = 'Yes';
  insert pp;
  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
    PageReference pref = Page.AIA_ProposedProd_Summary;
    Test.setCurrentPage(pref);
    List<AIA_Plan_Benefits__c> plben= [select id,name from AIA_Plan_Benefits__c where Plan__c = :String.valueof(aiapln.Id).substring(0,15)] ;
    system.debug('plben size===='+plben.size());
    AIA_Benefit_Design__c bd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

    AIA_Benefit_Design_Product__c bdp= new AIA_Benefit_Design_Product__c();
    bdp.Benefit_Design__c=bd.id;
    //  bdp.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Product__c', rtype);
    bdp.Plan_Name__c=aiapln.id;
    bdp.Proposed_Products__c=pp.id;     
    bdp.Funding_Arrangement__c = 'Risk';
    insert bdp;
    ApexPages.currentPage().getParameters().put('id', pp.id);
    
    AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where Benefit_Design__c =:bd.Id limit 1];
    Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
    System.currentPageReference().getParameters().put('id',bdpObj.id);
    System.currentPageReference().getParameters().put('idValue',bdpObj.id);                        

    ApexPages.StandardController con2 = new ApexPages.StandardController(bdpObj);
    AIA_BenefitDesign_SummaryController ext2 = new AIA_BenefitDesign_SummaryController(con2);
    
    //AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    ext2.resultvalue='Success';
  //  ext2.grouperWrapListCostShr = new List<AIA_BenefitDesign_SummaryController.GrouperWrapper>();
  //  ext2.maplst = new Map<String,AIA_Plan_Benefits__c>();
    ext2.rowHidden=1;
    ext2.mainInit();
    ext2.getPlanLimitation();
    test.stopTest();
}

        
        public Static TestMethod void Test_SaveAndContinuePlanBenefits(){


             // Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            //mod by off
             Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        //List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = rt_acc_51;      
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
            //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
            List <Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //t01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
            /*R1 added teammember*/ 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
            /*R1 added teammember*/
            //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
            insert acctMbrList;
            //end
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
            //o.Workplan_Type__c = wpt.id;//as per US210
            o.StageName = 'RFP';
            o.FullServiceProducer__c = 'Direct';
            insert o;




            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
           // brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
            //  aiapln.Has_Benefit_Summary__c = True;
            aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            insert aiapln;

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
            pp.Has_Benefit_Details__c =True;
            pp.Rider__c='None';
            insert pp;
            test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            ag.Group_Type__c = 'Benefit Group';
            //ag.Benefit_Design_Product__c = 
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();

            ag.Proposed_Products__c = pp.id;
            insert ag;

            List<AIA_Benefits__c> aiabenList = new List<AIA_Benefits__c>();
            AIA_Benefits__c ab2 = new AIA_Benefits__c();           
            ab2.Grouper__c = ag.id;
            ab2.Benefit_Name__c = 'Test Benefit';
            ab2.Benefit_Type__c = 'Mandate';
            ab2.Type__c = 'Benefit';           
            ab2.Benefit_Record_Type__c = 'BRF';
            ab2.Cost_Share_Low__c = '0';
            ab2.Cost_Share_High__c = '100';
            ab2.Cost_Share_Increment__c = '10';
            ab2.Cost_Share_InvalidIncrements__c = '30';
            ab2.Cost_Share_AdditionalIncrements__c = '33';
            ab2.OON_Cost_Share_Low__c = '0';
            ab2.OON_Cost_Share_High__c = '1000';
            ab2.OON_Cost_Share_Increment__c = '100';
            ab2.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab2.OON_Cost_Share_InvalidIncrements__c = '300';
            ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab2.Copay_Type_1_IsCovered__c = 'No';
            ab2.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab2.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab2.Copay_Type_1_AliasName__c='Test';
            ab2.Copay_Type_2_AliasName__c='Test';
            ab2.OON_Copay_Type_1_AliasName__c='Test';
            ab2.OON_Copay_Type_2_AliasName__c='Test';
            aiabenList.add(ab2);
            AIA_Benefits__c ab3 = new AIA_Benefits__c();           
            ab3.Grouper__c = ag.id;
            ab3.Benefit_Name__c = 'Test Benefit';
            ab3.Benefit_Type__c = 'Benefit';
            ab3.Type__c = 'Benefit';           
            ab3.Benefit_Record_Type__c = 'BRF';
            ab3.Cost_Share_Low__c = '0';
            ab3.Cost_Share_High__c = '100';
            ab3.Cost_Share_Increment__c = '10';
            ab3.Cost_Share_InvalidIncrements__c = '30';
            ab3.Cost_Share_AdditionalIncrements__c = '33';
            ab3.OON_Cost_Share_Low__c = '0';
            ab3.OON_Cost_Share_High__c = '1000';
            ab3.OON_Cost_Share_Increment__c = '100';
            ab3.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab3.OON_Cost_Share_InvalidIncrements__c = '300';
            ab3.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab3.Copay_Type_1_IsCovered__c = 'No';
            ab3.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab3.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab3.Copay_Type_1_AliasName__c='Test';
            ab3.Copay_Type_2_AliasName__c='Test';
            ab3.OON_Copay_Type_1_AliasName__c='Test';
            ab3.OON_Copay_Type_2_AliasName__c='Test';
            aiabenList.add(ab3);
            insert aiabenList;

            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = acc.id;
            Imp.Account__c = Imp.Opportunity__r.AccountId;
            //Imp.Generate_Workplan_Stages__c = true;//as per US210
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            insert Imp;

            AIA_Benefit_Design__c aiabd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

            AIA_Plan__c plan = AIA_TestUtil.CreateGSMPlan('Medical','xyz');
            plan.Has_Benefit_Summary__c = true;
            plan.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            plan.Jurisdiction__c = 'MD';
            plan.BDF_Configuration_Last_Updated__c  = null;
            insert plan;
            List<AIA_Benefit_Design_Product__c > bdpLst = new List<AIA_Benefit_Design_Product__c >();

            AIA_Benefit_Design_Product__c  bdp = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp.Has_Benefit_Details__c = true;
            bdp.Funding_Arrangement__c = 'ASO';
            bdpLst.add(bdp);
            AIA_Benefit_Design_Product__c  bdp1 = AIA_TestUtil.createBDProductsForBD(aiabd,'Medical',plan.id,pp.id);
            bdp1.Has_Benefit_Details__c = true;
            bdp1.Funding_Arrangement__c = 'Risk';
            bdpLst.add(bdp1);
            insert bdpLst;

            AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                    From AIA_Benefit_Design_Product__c where Id =:bdp.Id limit 1];
            System.assertEquals(bdpObj!= null,true);

            AIA_Grouper__c ag1 = new AIA_Grouper__c();
            ag1.Name = 'CostShareRanges';
            ag1.Group_Type__c = 'Benefit Group';
            ag1.Benefit_Design_Product__c = bdpObj.id;
            ag1.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
            ag1.Sequence_Number__c = 1;
            ag1.Proposed_Products__c = pp.id;
            insert ag1;


            AIA_Benefits__c ab = new AIA_Benefits__c();           
            ab.Grouper__c = ag1.id;
            ab.Benefit_Name__c = 'Family Out Of Pocket';
            ab.Benefit_Type__c = 'Mandate';
            ab.Benefit_Summary_Comment__c='test comment';//mod
            ab.Type__c = 'Cost Share';           
            ab.Benefit_Record_Type__c = 'BRF';
            ab.Cost_Share_Low__c = '0';
            ab.Cost_Share_High__c = '100';
            ab.Cost_Share_Increment__c = '10';
            ab.Cost_Share_InvalidIncrements__c = '30';
            ab.Cost_Share_AdditionalIncrements__c = '33';
            ab.OON_Cost_Share_Low__c = '0';
            ab.OON_Cost_Share_High__c = '1000';
            ab.OON_Cost_Share_Increment__c = '100';
            ab.OON_Cost_Share_AdditionalIncrements__c = '330';
            ab.OON_Cost_Share_InvalidIncrements__c = '300';
            ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab.Copay_Type_1_IsCovered__c = 'No';
            ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab.Copay_Type_1_AliasName__c='Test';
            ab.Copay_Type_2_AliasName__c='Test';
            ab.OON_Copay_Type_1_AliasName__c='Test';
            ab.OON_Copay_Type_2_AliasName__c='Test';
            insert ab;  

            AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
            pn.ExtID__c = '33r34t33dr';
            pn.Plan__c=plan.id;
            pn.Record_Type__c='BDD';

            insert pn;

            AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
            apg.ExtID__c =  '33r34t33dr';
            apg.ISExisting_Grouper__c = true;  
            apg.Plan__c = plan.id;
            apg.Record_Type__c = 'BDD';
            apg.Plan_Grouper_Name__c = '2233df';
            apg.Plan_Network__c = pn.id;
            //apg.Type__c = 'Benefit Group ';
            apg.Sequence_Number__c = 1;
            insert apg;  
            AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c(); 
            //apbt.Parent_Benefit_Name__c =  
            apbt.Benefit_Name__c ='wdwd';
            apbt.Benefit_Group__c = apg.id;
            apbt.Record_Type__c = 'BDD';
            apbt.IS_ASO_Only__c='No';
            //apbt.Name =
            apbt.Sequence_Number__c = 1;
            apbt.Coinsurance_DefaultAmount__c = '2323';   
            apbt.ISExisting_Benefit__c = True;
            apbt.Type__c='Benefit';

            insert apbt;

            List<AIA_Plan_Copay_Type__c> planCopyLst = new List<AIA_Plan_Copay_Type__c>();
            AIA_Plan_Copay_Type__c apcty1= new AIA_Plan_Copay_Type__c();
            apcty1.Plan_Benefits__c = apbt.id; 
            apcty1.DeductibleApplies__c = 'Yes';
            apcty1.AliasName__c = 'fhf';
            apcty1.IsCovered__c= 'Yes';
            apcty1.MandateIndicator__c='Yes';
            apcty1.CoinsuranceAmount__c='345';
            apcty1.Jurisdiction__c='gfhjh';
            apcty1.CopayAmount__c='67yuh';
            apcty1.MinPayAmount__c ='900';
            apcty1.MaxPayAmount__c='89';
            planCopyLst.add(apcty1);


            AIA_Plan_Copay_Type__c apcty= new AIA_Plan_Copay_Type__c();
            apcty.Plan_Benefits__c = apbt.id; 
            apcty.DeductibleApplies__c = 'Yes';
            apcty.AliasName__c = 'fhf';
            apcty.IsCovered__c= 'Yes';
            apcty.MandateIndicator__c='No';
            apcty.CoinsuranceAmount__c='345';
            apcty.Jurisdiction__c='gfhjh';
            apcty.CopayAmount__c='67yuh';
            apcty.MinPayAmount__c ='900';
            apcty.MaxPayAmount__c='89';
            planCopyLst.add(apcty);
            insert planCopyLst;     

            List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
            AIA_Plan_Limitation__c apl = new AIA_Plan_Limitation__c();
            apl.Plan_Benefits__c = apbt.id;
            apl.MaxAgeType__c = 'Days';
            apl.Type__c = 'TierLimit';
            apl.Jurisdiction__c = 'Federal';
            apl.TierLimitType__c = 'Days';
            apl.MandateIndicator__c = true;
            apl.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
            apl.TierLimitDurationType__c = 'Lifetime'; 
            apl.MaxAgeTo__c = 23;
            apl.MaxValue__c = 33;
            apl.TierAgeTo__c = 33;
            apl.TierLimitFrom__c = 2;
            apl.TierAgeType__c = 'Years';
            apl.TierAgeFrom__c = 23;
            apl.TierLimitTo__c = 44;
            apl.MaxApply__c = 'Per Breast';
            apl.MaxType__c = 'Dollars';
            apl.MaxDuration__c = 2;
            apl.MaxDurationType__c = 'Day';
            apl.MaxAgeFrom__c = 3;
            apl.Effective_Date__c=Date.today().addDays(-10);
            apl.Term_Date__c=Date.today().addDays(10);
            planList.add(apl);


            AIA_Plan_Limitation__c aplObj = new AIA_Plan_Limitation__c();
            aplObj.Plan_Benefits__c = apbt.id;
            aplObj.MaxAgeType__c = 'Days';
            aplObj.Type__c = 'MaxRow';
            aplObj.Jurisdiction__c = 'Federal';
            aplObj.TierLimitType__c = 'Days';
            aplObj.MandateIndicator__c = false;
            aplObj.MaxRow_Mandate_Description__c = 'efvrbrrrrrr';
            aplObj.TierLimitDurationType__c = 'Lifetime'; 
            aplObj.MaxAgeTo__c = 23;
            aplObj.MaxValue__c = 33;
            aplObj.TierAgeTo__c = 33;
            aplObj.TierLimitFrom__c = 2;
            aplObj.TierAgeType__c = 'Years';
            aplObj.TierAgeFrom__c = 23;
            aplObj.TierLimitTo__c = 44;
            aplObj.MaxApply__c = 'Per Breast';
            aplObj.MaxType__c = 'Dollars';
            aplObj.MaxDuration__c = 2;
            aplObj.MaxDurationType__c = 'Day';
            aplObj.MaxAgeFrom__c = 3;
            aplObj.Effective_Date__c=Date.today().addDays(-10);
            aplObj.Term_Date__c=Date.today().addDays(10);
            planList.add(aplObj);
            insert planList;



            List<AIA_Plan_Benefit_Comment_Codes__c> pbCCodeList = new List<AIA_Plan_Benefit_Comment_Codes__c>();             
            AIA_Plan_Benefit_Comment_Codes__c apbcc = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc.Plan_Limitation__c = planList[0].id;
            apbcc.Code__c = 2323;
            apbcc.Comment__c = 'ewfweger';
            apbcc.Plan_Copay_Type__c = planCopyLst[0].id;
            pbCCodeList.add(apbcc);
            AIA_Plan_Benefit_Comment_Codes__c apbcc1 = new AIA_Plan_Benefit_Comment_Codes__c();
            apbcc1.Plan_Limitation__c = planList[1].id;
            apbcc1.Code__c = 2323;
            apbcc1.Comment__c = 'ewfweger';
            apbcc1.Plan_Copay_Type__c = planCopyLst[1].id;
            pbCCodeList.add(apbcc1);
            AIA_Plan_Benefit_Comment_Codes__c apbcc2 = new AIA_Plan_Benefit_Comment_Codes__c();
            //apbcc2.Plan_Limitation__c = planList[0].id;
            apbcc2.Code__c = 2323;
            apbcc2.Comment__c = 'ewfweger';
            //apbcc2.Plan_Copay_Type__c = apcty.id;
            pbCCodeList.add(apbcc2);
            insert pbCCodeList;

            Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
            lmt.Benefit__c = ab.id;
            lmt.Type__c='MaxRow';
            insert lmt;
            Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
            lmt.Benefit__c = ab.id;
            insert lmt2;

            Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
            lmt.Benefit__c = ab.id;
            insert lmt3;

            AIA_benefitDesign_SummaryController.BenifitsrWrapper bwrap = new AIA_benefitDesign_SummaryController.BenifitsrWrapper();
            bwrap.benifitNameStr = 'ABCD';
            bwrap.benifitlmt = '232';

            bwrap.MaxPlanCodelst.add(apbcc);
            bwrap.maxPlan = '223';
            bwrap.GrpName = 'CostShareRanges';
            bwrap.madateCheck = True;
            bwrap.tierPlan = '2';

            bwrap.lstPlanlimit.add(apl);
            //List<Limitations__c> limlist = new List<Limitations__c>();
            bwrap.lstlimit.add(lmt);
            bwrap.aiaBenifitObj= ab;
            //List<AIA_benefitDesign_SummaryController.NetworkTypeWrapper> nwlist = new List<AIA_benefitDesign_SummaryController.NetworkTypeWrapper>();
            AIA_benefitDesign_SummaryController.NetworkTypeWrapper nwwrap = new AIA_benefitDesign_SummaryController.NetworkTypeWrapper();
            //nwwrap.networkTypeStr = '545';
            nwwrap.benifitNetworkObj = apbt;
            nwwrap.copayTypeForDrugObj= apcty;
            AIA_benefitDesign_SummaryController.CopayTypeWrapper xyz = new AIA_benefitDesign_SummaryController.CopayTypeWrapper();
            xyz.copayTypeSelectedObj = apcty; 
            xyz.copayTypePecSpecObj = apcty;
            xyz.copayTypeSelectedObj2 = apcty;
            xyz.copayTypePecSpecObj2 = apcty;

            nwwrap.copayTypeWrapObj = xyz;

            bwrap.networkWrapList.add(nwwrap);
            bwrap.copayTypeWrapObj = xyz;


            AIA_benefitDesign_SummaryController.GrouperWrapper wrap = new AIA_benefitDesign_SummaryController.GrouperWrapper();
            wrap.aiaGrouper = ag;
            wrap.grouperObj = apg;
            wrap.benifitWrapList.add(bwrap);
            wrap.INpcpVal = 'bhuv';
            wrap.INspcpVal = 'dxcv';
            wrap.OutpcpVal ='cfvg';
            wrap.OutspcpVal ='xdcfv';

            list<AIA_benefitDesign_SummaryController.GrouperWrapper> grprwr = new list<AIA_benefitDesign_SummaryController.GrouperWrapper>();

            Test.setCurrentPageReference(new PageReference('Page.AIA_BenefitDesign_Summary')); 
            System.currentPageReference().getParameters().put('id',bdpObj.id);
            System.currentPageReference().getParameters().put('idValue',pp.id);                        

            ApexPages.StandardController con = new ApexPages.StandardController(bdpObj);
            AIA_BenefitDesign_SummaryController ext = new AIA_BenefitDesign_SummaryController(con);

            AIA_Plan_Grouper__c grprListToClr = [Select id, Name, Sequence_Number__c,Record_Type__c,ISExisting_Grouper__c, Plan_Network__c,Type__c, Plan_Network__r.Name 
                                                 From AIA_Plan_Grouper__c  limit 1];
            system.assertEquals(grprListToClr!=null,true);
            //system.assertEquals(grprListToClr.Type__c ,'Benefit Group');                                     
            grprListToClr.Type__c = 'Benefit Group';
            update grprListToClr;
            String  planIdStr = String.valueof(bdpObj.Plan_Name__c).left(15);
            ext.getGroupersFromPlan(planIdStr,'BDD');
            ext.getBenefitsForPlan(planIdStr,'BDD');
            ext.createWrapListFromPlan(bdpObj);
            ext.pp = bdpObj;
            ext.grouperWrapList.add(wrap);
            ext.isPCScallReq(plan);
            ext.hasBnftSumry(plan);
            //Commenting as part of US1650
            //ext.getPCSdata();
            ext.mainInit(); 
            ext.reviewInit();
            ext.saveandRedirct();
            bdpObj.Has_Benefit_Details__c = false;
            bdpObj.Funding_Arrangement__c = 'Risk';
            update bdpObj;

            AIA_Benefit_Design_Product__c bdpUpdateObj = [Select Id,Product_Category__c,Has_Benefit_Details__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                          From AIA_Benefit_Design_Product__c where Id =:bdpObj.Id limit 1];

            //ext.SaveAndContinuePlanBenefits(bdpObj);
            EXT.createWrapListFromPlan(bdpUpdateObj);
            ext.createListFromPP(bdpUpdateObj.id,false);
            ext.createListFromPP(bdpUpdateObj.id,true);
            ext.back();
            for (AIA_benefitDesign_SummaryController.GrouperWrapper grpWrapper : ext.grouperWrapList){
                for (AIA_benefitDesign_SummaryController.BenifitsrWrapper benWrapper : grpWrapper.benifitWrapList){
                    benWrapper.grpName='CostShareRanges';
                }
            }
            
            ext.SaveAndContinuePlanBenefits(bdpUpdateObj);
            ext.saveAndCon();
            ext.saveAndContemp();
            ext.dispatcherTemp();

            test.stoptest();      
        }
   
    }