@istest
    public class AIA_Benefit_SummaryController_Test1 {
        
        public Static TestMethod void TestAIA_Benefit_SummaryControllerForGrouperdrug1() {
            
            //Commenting as part of US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
    wpt.Used_For__c = 'Pre-Sales';
    wpt.Workplan_Type__c = 'New';
    wpt.Active__c = true;
    insert wpt;*/
            
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
            
            //Raj added below code for code covergae start 
            Benfit_Request_Form__c brf123 = new Benfit_Request_Form__c();    
            
            brf123.Contract_Count__c = 123;
            brf123.Benefit_Effective_Date__c = system.today();
            //brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf123.Escalated_to_Senior_Management__c = true;
            brf123.Status__c = 'Sold';
            brf123.Account__c = acc.id;
            brf123.Opportunity__c = o.id;
            brf123.Jurisdiction__c = 'MD';
            brf123.Request_Type__c = 'Renewal';
            brf123.Benefit_Period__c = 'Calendar';
            brf123.Control_Plan__c = '580';
            brf123.Sales_Segment_Size__c = 'Commercial 200-999';
            brf123.Contract_Period__c = 'Standard - 12 Months';
            brf123.Grandfathered_Status__c = 'Grandfathered'; 
            brf123.Identity_Protection__c = 'No';
            brf123.Broker_Commission__c = 3.5;
            brf123.Contract_Count__c = 5;
            brf123.Formulary__c = '1';
            brf123.Maintenance_Choice__c = 'Mandatory';
            insert brf123;
            
            Proposed_Products__c pp123 = new Proposed_Products__c();
            pp123.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
            pp123.Benefit_Request_Form__c = brf123.id;
            pp123.Funding_Arrangement__c = 'ASO';
            pp123.Product_Category__c = 'Drug';
            pp123.Product_Line__c = 'PPO';
            pp123.Plan_Name__c = aiapln.id;
            pp123.Product_Name__c = 'BlueChoice Advantage';
            pp123.CDH__c = 'Yes';
            pp123.CDH_Fund_Type__c = 'BlueFund';
            pp123.CDH_Type__c = 'HSA';
            pp123.Deductible__c = 'Stacked';
            pp123.Grandfathered_Status__c = 'Grandfathered';
            pp123.Integrated_Non_Integrated__c = 'Yes';
            pp123.Grandfathered_PPACA_Status__c = 'No';
            pp123.Blue_Rewards__c = 'No';
            pp123.Out_of_Pocket_Max__c = 'Stacked';
            pp123.Has_Benefit_Details__c = True;
            pp123.Network__c = 'National';
            pp123.Exclusive_Specialty_Provider_Network__c = 'Yes';   
            pp123.ExtraCare_Health_Care_Card__c = 'Yes';   
            pp123.Maintenance_Choice__c = 'None';   
            pp123.OralChemoMandateApply__c = 'No';   
            pp123.Integrated_Deductible_Integrator__c = 'No';
            pp123.Integrated_OOP_Integration__c = 'Yes';
            pp123.Rider__c = 'None';
            insert pp123;
            
            
            AIA_Plan__c p = new AIA_Plan__c ();
            p.Product_Category__c = 'Medical';
            p.Product_Line__c = 'Health Maintenance Organization';
            p.CDH__c = 'Yes';
            p.CDH_Type__c = 'HSA';
            p.CDH_Fund_Type__c = 'BlueFund';
            p.Plan_Id__c = 'testsdglksdgjlsldgkjs';
            p.Effective_Date__c = system.today();
            p.Termination_Date__c = system.today();
            p.Product_Status__c ='Active';
            p.Jurisdiction__c = 'MD';
            p.Product_Last_Updated_String_Format__c = '2016-10-25 07:04:03 AM';
            insert p;
            
            //Raj added above  code for code covergae end 
            
            Test.starttest();
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
            
            
            AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
            RXgrouper.Name = 'Retail NonMaintenance';
            RXgrouper.Group_Type__c = 'Benefit Group';
            RXgrouper.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            RXgrouper.Proposed_Products__c = pp.id;
            insert RXgrouper;
            
            List<AIA_Benefits__c> Benlist = new  List<AIA_Benefits__c>();
            AIA_Benefits__c ab7 = new AIA_Benefits__c();
            ab7.Grouper__c = RXgrouper.id;
            ab7.Benefit_Name__c = 'Retail NonMaintenance Generic';
            ab7.Benefit_Type__c = 'Benefit';
            ab7.Copay_Type_1_Mandate_Name__c = 'Test';
            ab7.Type__c = 'Benefit';  
            ab7.Benefit_Record_Type__c = 'BRF';
            ab7.CoInsurance_AmountValueSelected__c = '10';
            ab7.Copay_Type_1_IsCovered__c = 'Yes';
            ab7.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab7.AnnualMaximumApplies__c = 'Yes';  
            ab7.OON_CoInsurance_AmountValueSelected__c = '10';
            ab7.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab7.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab7.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab7); 
            
            AIA_Benefits__c ab13 = new AIA_Benefits__c();
            ab13.Grouper__c = RXgrouper.id;
            ab13.Benefit_Name__c = 'Retail NonMaintenance Generic';
            ab13.Benefit_Type__c = 'Benefit';
            ab13.Copay_Type_1_Mandate_Name__c = 'Test';
            ab13.Type__c = 'Benefit';  
            ab13.Benefit_Record_Type__c = 'BRF';
            ab13.CoInsurance_AmountValueSelected__c = '10';
            ab13.Copay_Type_1_IsCovered__c = 'No';
            ab13.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab13.AnnualMaximumApplies__c = 'Yes';  
            ab13.OON_CoInsurance_AmountValueSelected__c = '10';
            ab13.OON_Copay_Type_1_IsCovered__c = 'No';
            ab13.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab13.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab13);  
            
            
            AIA_Benefits__c ab8 = new AIA_Benefits__c();
            ab8.Grouper__c = RXgrouper.id;
            ab8.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand';
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
            Benlist.add(ab8); 
            
            AIA_Benefits__c ab14 = new AIA_Benefits__c();
            ab14.Grouper__c = RXgrouper.id;
            ab14.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand';
            ab14.Benefit_Type__c = 'Benefit';
            ab14.Copay_Type_1_Mandate_Name__c = 'Test';
            ab14.Type__c = 'Benefit';  
            ab14.Benefit_Record_Type__c = 'BRF';
            ab14.CoInsurance_AmountValueSelected__c = '10';
            ab14.Copay_Type_1_IsCovered__c = 'Yes';
            ab14.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab14.AnnualMaximumApplies__c = 'Yes';  
            ab14.OON_CoInsurance_AmountValueSelected__c = '10';
            ab14.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab14.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab14.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab14);
            
            AIA_Benefits__c ab9 = new AIA_Benefits__c();
            ab9.Grouper__c = RXgrouper.id;
            ab9.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand';
            ab9.Benefit_Type__c = 'Benefit';
            ab9.Copay_Type_1_Mandate_Name__c = 'Test';
            ab9.Type__c = 'Benefit';  
            ab9.Benefit_Record_Type__c = 'BRF';
            ab9.CoInsurance_AmountValueSelected__c = '10';
            ab9.Copay_Type_1_IsCovered__c = 'Yes';
            ab9.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab9.AnnualMaximumApplies__c = 'Yes';  
            ab9.OON_CoInsurance_AmountValueSelected__c = '10';
            ab9.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab9.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab9.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab9);  
            
            AIA_Benefits__c ab11 = new AIA_Benefits__c();
            ab11.Grouper__c = RXgrouper.id;
            ab11.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand';
            ab11.Benefit_Type__c = 'Benefit';
            ab11.Copay_Type_1_Mandate_Name__c = 'Test';
            ab11.Type__c = 'Benefit';  
            ab11.Benefit_Record_Type__c = 'BRF';
            ab11.CoInsurance_AmountValueSelected__c = '10';
            ab11.Copay_Type_1_IsCovered__c = 'No';
            ab11.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab11.AnnualMaximumApplies__c = 'Yes';  
            ab11.OON_CoInsurance_AmountValueSelected__c = '10';
            ab11.OON_Copay_Type_1_IsCovered__c = 'No';
            ab11.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab11.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab11);
            
            AIA_Benefits__c ab10 = new AIA_Benefits__c();
            ab10.Grouper__c = RXgrouper.id;
            ab10.Benefit_Name__c = 'Retail NonMaintenance Self-Injectable';
            ab10.Benefit_Type__c = 'Benefit';
            ab10.Copay_Type_1_Mandate_Name__c = 'Test';
            ab10.Type__c = 'Benefit';  
            ab10.Benefit_Record_Type__c = 'BRF';
            ab10.CoInsurance_AmountValueSelected__c = '10';
            ab10.Copay_Type_1_IsCovered__c = 'Yes';
            ab10.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab10.AnnualMaximumApplies__c = 'Yes';  
            ab10.OON_CoInsurance_AmountValueSelected__c = '10';
            ab10.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab10.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab10.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab10);  
            
            AIA_Benefits__c ab12 = new AIA_Benefits__c();
            ab12.Grouper__c = RXgrouper.id;
            ab12.Benefit_Name__c = 'Retail NonMaintenance Self-Injectable';
            ab12.Benefit_Type__c = 'Benefit';
            ab12.Copay_Type_1_Mandate_Name__c = 'Test';
            ab12.Type__c = 'Benefit';  
            ab12.Benefit_Record_Type__c = 'BRF';
            ab12.CoInsurance_AmountValueSelected__c = '10';
            ab12.Copay_Type_1_IsCovered__c = 'No';
            ab12.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab12.AnnualMaximumApplies__c = 'Yes';  
            ab12.OON_CoInsurance_AmountValueSelected__c = '10';
            ab12.OON_Copay_Type_1_IsCovered__c = 'No';
            ab12.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab12.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab12);
            
            Insert Benlist;
            
            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            //ag.Group_Type__c = 'Cost Share Group';
            ag.Group_Type__c = 'Benefit Group';
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            
            ag.Proposed_Products__c = pp.id;
            insert ag;
            
            
            AIA_Benefits__c ab = new AIA_Benefits__c();
            ab.Grouper__c = ag.id;
            ab.Copay_Type_1_Mandate_Name__c = 'Test';
            ab.Benefit_Name__c = 'Family Out Of Pocket';
            //ab.Benefit_Type__c = 'Benefit';
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
            ab.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab.Copay_Type_2_AliasName__c = 'Test';
            ab.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab.OON_Copay_Type_2_AliasName__c = 'Test';
            ab.Copay_Min_Payment__c = '20';
            ab.Copay_Max_Payment__c = '30';
            ab.OON_Copay_Min_Payment__c = '10';
            ab.OON_Copay_Max_Payment__c = '10';
            ab.Benefit_Summary_Comment__c ='hello';
            ab.Copay_Type_1_Benefit_Comment_Codes__c ='NA';
            insert ab;
            
            AIA_Benefits__c ab2 = new AIA_Benefits__c();
            ab2.Grouper__c = ag.id;
            ab2.Benefit_Name__c = 'Individual Out Of Pocket';
            ab2.Copay_Type_1_Mandate_Name__c = 'Test';
            //ab2.Benefit_Type__c = 'Benefit';
            ab2.Benefit_Type__c = 'Benefit';
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
            ab2.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab2.Copay_Type_2_AliasName__c = 'Test';
            ab2.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab2.OON_Copay_Type_2_AliasName__c = 'Test';
            ab2.CoInsurance_AmountValueSelected__c = '50';
            ab2.Copay_Type_1_AmountValueSelected__c = '100';
            ab2.Copay_Min_Payment__c = '100';
            ab2.Copay_Max_Payment__c = '200';
            ab2.OON_CoInsurance_AmountValueSelected__c = '50';
            ab2.OON_Copay_Type_1_AmountValueSelected__c = '100';
            ab2.OON_Copay_Min_Payment__c = '100';
            ab2.OON_Copay_Max_Payment__c = '200';
            ab2.Benefit_Summary_Comment__c ='hello';
            ab2.Copay_Type_1_Benefit_Comment_Codes__c ='NA';
            insert ab2;
            
            AIA_Benefits__c ab3 = new AIA_Benefits__c();
            ab3.Grouper__c = ag.id;
            ab3.IS_ASO_Only__c=false;
            ab3.Benefit_Name__c = 'Family Deductible';
            ab3.Benefit_Type__c = 'Benefit';
            ab3.Copay_Type_1_Mandate_Name__c = 'Test';
            ab3.Type__c = 'Cost Share';
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
            ab3.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab3.Copay_Type_2_AliasName__c = 'Test';
            ab3.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab3.OON_Copay_Type_2_AliasName__c = 'Test';
            ab3.IsAppGlobalCopay__c = true;
            insert ab3; 
            
            AIA_Benefits__c ab4 = new AIA_Benefits__c();
            ab4.Grouper__c = ag.id;
            ab4.IS_ASO_Only__c=false;
            ab4.Benefit_Name__c = 'Individual Deductible';
            ab4.Benefit_Type__c = 'Benefit';
            ab4.Copay_Type_1_Mandate_Name__c = 'Test';
            ab4.Type__c = 'Cost Share';
            ab4.Benefit_Record_Type__c = 'BRF';
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
            ab4.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab4.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab4.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab4.Copay_Type_2_AliasName__c = 'Test';
            ab4.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab4.OON_Copay_Type_2_AliasName__c = 'Test';
            ab4.IsAppGlobalCopay__c = true;
            insert ab4;
            
            
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
        
        public Static TestMethod void TestAIA_Benefit_SummaryControllerForGrouperdrug2() {
            
            //Commenting as part of US210
            /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
    wpt.Used_For__c = 'Pre-Sales';
    wpt.Workplan_Type__c = 'New';
    wpt.Active__c = true;
    insert wpt;*/
            
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
            
            
            
            Proposed_Products__c pp2 = new Proposed_Products__c();
            pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
            pp2.Benefit_Request_Form__c = brf.id;
            pp2.Funding_Arrangement__c = 'ASO';
            pp2.Product_Category__c = 'Drug';
            pp2.Product_Line__c = 'pp2O';
            pp2.Plan_Name__c = aiapln.id;
            pp2.Product_Name__c = 'BlueChoice Advantage';
            pp2.CDH__c = 'Yes';
            pp2.CDH_Fund_Type__c = 'BlueFund';
            pp2.CDH_Type__c = 'HSA';
            pp2.Deductible__c = 'Stacked';
            pp2.Grandfathered_Status__c = 'Grandfathered';
            pp2.Integrated_Non_Integrated__c = 'Yes';
            pp2.Grandfathered_PPACA_Status__c = 'No';
            pp2.Blue_Rewards__c = 'No';
            pp2.Out_of_Pocket_Max__c = 'Stacked';
            pp2.Has_Benefit_Details__c = True;
            pp2.Network__c = 'National';
            pp2.Exclusive_Specialty_Provider_Network__c = 'Yes';   
            pp2.ExtraCare_Health_Care_Card__c = 'Yes';   
            pp2.Maintenance_Choice__c = 'None';   
            pp2.OralChemoMandateApply__c = 'No';   
            pp2.Integrated_Deductible_Integrator__c = 'No';
            pp2.Integrated_OOP_Integration__c = 'No';
            pp2.Rider__c = 'None';
            insert pp2;
            test.starttest();
            
            AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
            RXgrouper.Name = 'Retail NonMaintenance';
            RXgrouper.Group_Type__c = 'Benefit Group';
            RXgrouper.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            RXgrouper.Proposed_Products__c = pp2.id;
            insert RXgrouper;
            
            List<AIA_Benefits__c> Benlist = new  List<AIA_Benefits__c>();
            AIA_Benefits__c ab7 = new AIA_Benefits__c();
            ab7.Grouper__c = RXgrouper.id;
            ab7.Benefit_Name__c = 'Retail NonMaintenance Generic';
            ab7.Benefit_Type__c = 'Benefit';
            ab7.Copay_Type_1_Mandate_Name__c = 'Test';
            ab7.Type__c = 'Benefit';  
            ab7.Benefit_Record_Type__c = 'BRF';
            ab7.CoInsurance_AmountValueSelected__c = '10';
            ab7.Copay_Type_1_IsCovered__c = 'Yes';
            ab7.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab7.AnnualMaximumApplies__c = 'Yes';  
            ab7.OON_CoInsurance_AmountValueSelected__c = '10';
            ab7.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab7.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab7.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab7); 
            
            AIA_Benefits__c ab13 = new AIA_Benefits__c();
            ab13.Grouper__c = RXgrouper.id;
            ab13.Benefit_Name__c = 'Retail NonMaintenance Generic';
            ab13.Benefit_Type__c = 'Benefit';
            ab13.Copay_Type_1_Mandate_Name__c = 'Test';
            ab13.Type__c = 'Benefit';  
            ab13.Benefit_Record_Type__c = 'BRF';
            ab13.CoInsurance_AmountValueSelected__c = '10';
            ab13.Copay_Type_1_IsCovered__c = 'No';
            ab13.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab13.AnnualMaximumApplies__c = 'Yes';  
            ab13.OON_CoInsurance_AmountValueSelected__c = '10';
            ab13.OON_Copay_Type_1_IsCovered__c = 'No';
            ab13.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab13.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab13);  
            
            
            AIA_Benefits__c ab8 = new AIA_Benefits__c();
            ab8.Grouper__c = RXgrouper.id;
            ab8.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand';
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
            Benlist.add(ab8); 
            
            AIA_Benefits__c ab14 = new AIA_Benefits__c();
            ab14.Grouper__c = RXgrouper.id;
            ab14.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand';
            ab14.Benefit_Type__c = 'Benefit';
            ab14.Copay_Type_1_Mandate_Name__c = 'Test';
            ab14.Type__c = 'Benefit';  
            ab14.Benefit_Record_Type__c = 'BRF';
            ab14.CoInsurance_AmountValueSelected__c = '10';
            ab14.Copay_Type_1_IsCovered__c = 'Yes';
            ab14.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab14.AnnualMaximumApplies__c = 'Yes';  
            ab14.OON_CoInsurance_AmountValueSelected__c = '10';
            ab14.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab14.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab14.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab14);
            
            AIA_Benefits__c ab9 = new AIA_Benefits__c();
            ab9.Grouper__c = RXgrouper.id;
            ab9.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand';
            ab9.Benefit_Type__c = 'Benefit';
            ab9.Copay_Type_1_Mandate_Name__c = 'Test';
            ab9.Type__c = 'Benefit';  
            ab9.Benefit_Record_Type__c = 'BRF';
            ab9.CoInsurance_AmountValueSelected__c = '10';
            ab9.Copay_Type_1_IsCovered__c = 'Yes';
            ab9.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab9.AnnualMaximumApplies__c = 'Yes';  
            ab9.OON_CoInsurance_AmountValueSelected__c = '10';
            ab9.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab9.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab9.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab9);  
            
            AIA_Benefits__c ab11 = new AIA_Benefits__c();
            ab11.Grouper__c = RXgrouper.id;
            ab11.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand';
            ab11.Benefit_Type__c = 'Benefit';
            ab11.Copay_Type_1_Mandate_Name__c = 'Test';
            ab11.Type__c = 'Benefit';  
            ab11.Benefit_Record_Type__c = 'BRF';
            ab11.CoInsurance_AmountValueSelected__c = '10';
            ab11.Copay_Type_1_IsCovered__c = 'No';
            ab11.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab11.AnnualMaximumApplies__c = 'Yes';  
            ab11.OON_CoInsurance_AmountValueSelected__c = '10';
            ab11.OON_Copay_Type_1_IsCovered__c = 'No';
            ab11.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab11.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab11);
            
            AIA_Benefits__c ab10 = new AIA_Benefits__c();
            ab10.Grouper__c = RXgrouper.id;
            ab10.Benefit_Name__c = 'Retail NonMaintenance Self-Injectable';
            ab10.Benefit_Type__c = 'Benefit';
            ab10.Copay_Type_1_Mandate_Name__c = 'Test';
            ab10.Type__c = 'Benefit';  
            ab10.Benefit_Record_Type__c = 'BRF';
            ab10.CoInsurance_AmountValueSelected__c = '10';
            ab10.Copay_Type_1_IsCovered__c = 'Yes';
            ab10.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab10.AnnualMaximumApplies__c = 'Yes';  
            ab10.OON_CoInsurance_AmountValueSelected__c = '10';
            ab10.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab10.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab10.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab10);  
            
            AIA_Benefits__c ab12 = new AIA_Benefits__c();
            ab12.Grouper__c = RXgrouper.id;
            ab12.Benefit_Name__c = 'Retail NonMaintenance Self-Injectable';
            ab12.Benefit_Type__c = 'Benefit';
            ab12.Copay_Type_1_Mandate_Name__c = 'Test';
            ab12.Type__c = 'Benefit';  
            ab12.Benefit_Record_Type__c = 'BRF';
            ab12.CoInsurance_AmountValueSelected__c = '10';
            ab12.Copay_Type_1_IsCovered__c = 'No';
            ab12.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab12.AnnualMaximumApplies__c = 'Yes';  
            ab12.OON_CoInsurance_AmountValueSelected__c = '10';
            ab12.OON_Copay_Type_1_IsCovered__c = 'No';
            ab12.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab12.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab12);
            
            Insert Benlist;
            
            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            //ag.Group_Type__c = 'Cost Share Group';
            ag.Group_Type__c = 'Benefit Group';
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            
            ag.Proposed_Products__c = pp2.id;
            insert ag;
            
            
            AIA_Benefits__c ab = new AIA_Benefits__c();
            ab.Grouper__c = ag.id;
            ab.Copay_Type_1_Mandate_Name__c = 'Test';
            ab.Benefit_Name__c = 'Family Out Of Pocket';
            //ab.Benefit_Type__c = 'Benefit';
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
            ab.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab.Copay_Type_2_AliasName__c = 'Test';
            ab.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab.OON_Copay_Type_2_AliasName__c = 'Test';
            ab.Copay_Min_Payment__c = '20';
            ab.Copay_Max_Payment__c = '30';
            ab.OON_Copay_Min_Payment__c = '10';
            ab.OON_Copay_Max_Payment__c = '10';
            ab.Benefit_Summary_Comment__c ='hello';
            ab.Copay_Type_1_Benefit_Comment_Codes__c ='NA';
            insert ab;
            
            AIA_Benefits__c ab2 = new AIA_Benefits__c();
            ab2.Grouper__c = ag.id;
            ab2.Benefit_Name__c = 'Individual Out Of Pocket';
            ab2.Copay_Type_1_Mandate_Name__c = 'Test';
            //ab2.Benefit_Type__c = 'Benefit';
            ab2.Benefit_Type__c = 'Benefit';
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
            ab2.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab2.Copay_Type_2_AliasName__c = 'Test';
            ab2.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab2.OON_Copay_Type_2_AliasName__c = 'Test';
            ab2.CoInsurance_AmountValueSelected__c = '50';
            ab2.Copay_Type_1_AmountValueSelected__c = '100';
            ab2.Copay_Min_Payment__c = '100';
            ab2.Copay_Max_Payment__c = '200';
            ab2.OON_CoInsurance_AmountValueSelected__c = '50';
            ab2.OON_Copay_Type_1_AmountValueSelected__c = '100';
            ab2.OON_Copay_Min_Payment__c = '100';
            ab2.OON_Copay_Max_Payment__c = '200';
            ab2.Benefit_Summary_Comment__c ='hello';
            ab2.Copay_Type_1_Benefit_Comment_Codes__c ='NA';
            insert ab2;
            
            AIA_Benefits__c ab3 = new AIA_Benefits__c();
            ab3.Grouper__c = ag.id;
            ab3.IS_ASO_Only__c=false;
            ab3.Benefit_Name__c = 'Family Deductible';
            ab3.Benefit_Type__c = 'Benefit';
            ab3.Copay_Type_1_Mandate_Name__c = 'Test';
            ab3.Type__c = 'Cost Share';
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
            ab3.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab3.Copay_Type_2_AliasName__c = 'Test';
            ab3.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab3.OON_Copay_Type_2_AliasName__c = 'Test';
            ab3.IsAppGlobalCopay__c = true;
            insert ab3; 
            
            AIA_Benefits__c ab4 = new AIA_Benefits__c();
            ab4.Grouper__c = ag.id;
            ab4.IS_ASO_Only__c=false;
            ab4.Benefit_Name__c = 'Individual Deductible';
            ab4.Benefit_Type__c = 'Benefit';
            ab4.Copay_Type_1_Mandate_Name__c = 'Test';
            ab4.Type__c = 'Cost Share';
            ab4.Benefit_Record_Type__c = 'BRF';
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
            ab4.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab4.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab4.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab4.Copay_Type_2_AliasName__c = 'Test';
            ab4.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab4.OON_Copay_Type_2_AliasName__c = 'Test';
            ab4.IsAppGlobalCopay__c = true;
            insert ab4;
            
            
            PageReference pref = Page.AIA_ProposedProd_Summary;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id', pp2.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP2);
            ApexPages.currentPage().getParameters().put('id', pp2.id);
            
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
            //  ext.mapPlanIdToPlan.put(aiapln.id,aiapln);
            ext.mainInit();
            ext.saveAndCon();
            ext.reviewInit();
            ext.getBenefitSummary_TO();
            ext.prodBtnClicked = 'drug';
            
            test.stoptest();
        }
        
        public Static TestMethod void TestAIA_Benefit_SummaryControllerForGrouperdrug3() {
            
            //Commenting as part of US210
            /* AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
    wpt.Used_For__c = 'Pre-Sales';
    wpt.Workplan_Type__c = 'New';
    wpt.Active__c = true;
    insert wpt;*/
            
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
            // o.Workplan_Type__c = wpt.id;//Commenting as part of US210
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
            Test.starttest();
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
            pp.Integrated_Deductible_Integrator__c = 'Yes';
            pp.Integrated_OOP_Integration__c = 'Yes';
            pp.Rider__c = 'None';
            insert pp;
            
            
            
            AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
            RXgrouper.Name = 'Retail NonMaintenance';
            RXgrouper.Group_Type__c = 'Benefit Group';
            RXgrouper.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            RXgrouper.Proposed_Products__c = pp.id;
            insert RXgrouper;
            
            List<AIA_Benefits__c> Benlist = new  List<AIA_Benefits__c>();
            AIA_Benefits__c ab7 = new AIA_Benefits__c();
            ab7.Grouper__c = RXgrouper.id;
            ab7.Benefit_Name__c = 'Retail NonMaintenance Generic';
            ab7.Benefit_Type__c = 'Benefit';
            ab7.Copay_Type_1_Mandate_Name__c = 'Test';
            ab7.Type__c = 'Benefit';  
            ab7.Benefit_Record_Type__c = 'BRF';
            ab7.CoInsurance_AmountValueSelected__c = '10';
            ab7.Copay_Type_1_IsCovered__c = 'Yes';
            ab7.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab7.AnnualMaximumApplies__c = 'Yes';  
            ab7.OON_CoInsurance_AmountValueSelected__c = '10';
            ab7.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab7.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab7.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab7); 
            
            AIA_Benefits__c ab13 = new AIA_Benefits__c();
            ab13.Grouper__c = RXgrouper.id;
            ab13.Benefit_Name__c = 'Retail NonMaintenance Generic';
            ab13.Benefit_Type__c = 'Benefit';
            ab13.Copay_Type_1_Mandate_Name__c = 'Test';
            ab13.Type__c = 'Benefit';  
            ab13.Benefit_Record_Type__c = 'BRF';
            ab13.CoInsurance_AmountValueSelected__c = '10';
            ab13.Copay_Type_1_IsCovered__c = 'No';
            ab13.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab13.AnnualMaximumApplies__c = 'Yes';  
            ab13.OON_CoInsurance_AmountValueSelected__c = '10';
            ab13.OON_Copay_Type_1_IsCovered__c = 'No';
            ab13.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab13.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab13);  
            
            
            AIA_Benefits__c ab8 = new AIA_Benefits__c();
            ab8.Grouper__c = RXgrouper.id;
            ab8.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand';
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
            Benlist.add(ab8); 
            
            AIA_Benefits__c ab14 = new AIA_Benefits__c();
            ab14.Grouper__c = RXgrouper.id;
            ab14.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand';
            ab14.Benefit_Type__c = 'Benefit';
            ab14.Copay_Type_1_Mandate_Name__c = 'Test';
            ab14.Type__c = 'Benefit';  
            ab14.Benefit_Record_Type__c = 'BRF';
            ab14.CoInsurance_AmountValueSelected__c = '10';
            ab14.Copay_Type_1_IsCovered__c = 'Yes';
            ab14.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab14.AnnualMaximumApplies__c = 'Yes';  
            ab14.OON_CoInsurance_AmountValueSelected__c = '10';
            ab14.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab14.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab14.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab14);
            
            AIA_Benefits__c ab9 = new AIA_Benefits__c();
            ab9.Grouper__c = RXgrouper.id;
            ab9.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand';
            ab9.Benefit_Type__c = 'Benefit';
            ab9.Copay_Type_1_Mandate_Name__c = 'Test';
            ab9.Type__c = 'Benefit';  
            ab9.Benefit_Record_Type__c = 'BRF';
            ab9.CoInsurance_AmountValueSelected__c = '10';
            ab9.Copay_Type_1_IsCovered__c = 'Yes';
            ab9.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab9.AnnualMaximumApplies__c = 'Yes';  
            ab9.OON_CoInsurance_AmountValueSelected__c = '10';
            ab9.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab9.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab9.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab9);  
            
            AIA_Benefits__c ab11 = new AIA_Benefits__c();
            ab11.Grouper__c = RXgrouper.id;
            ab11.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand';
            ab11.Benefit_Type__c = 'Benefit';
            ab11.Copay_Type_1_Mandate_Name__c = 'Test';
            ab11.Type__c = 'Benefit';  
            ab11.Benefit_Record_Type__c = 'BRF';
            ab11.CoInsurance_AmountValueSelected__c = '10';
            ab11.Copay_Type_1_IsCovered__c = 'No';
            ab11.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab11.AnnualMaximumApplies__c = 'Yes';  
            ab11.OON_CoInsurance_AmountValueSelected__c = '10';
            ab11.OON_Copay_Type_1_IsCovered__c = 'No';
            ab11.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab11.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab11);
            
            AIA_Benefits__c ab10 = new AIA_Benefits__c();
            ab10.Grouper__c = RXgrouper.id;
            ab10.Benefit_Name__c = 'Retail NonMaintenance Self-Injectable';
            ab10.Benefit_Type__c = 'Benefit';
            ab10.Copay_Type_1_Mandate_Name__c = 'Test';
            ab10.Type__c = 'Benefit';  
            ab10.Benefit_Record_Type__c = 'BRF';
            ab10.CoInsurance_AmountValueSelected__c = '10';
            ab10.Copay_Type_1_IsCovered__c = 'Yes';
            ab10.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab10.AnnualMaximumApplies__c = 'Yes';  
            ab10.OON_CoInsurance_AmountValueSelected__c = '10';
            ab10.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab10.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab10.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab10);  
            
            AIA_Benefits__c ab12 = new AIA_Benefits__c();
            ab12.Grouper__c = RXgrouper.id;
            ab12.Benefit_Name__c = 'Retail NonMaintenance Self-Injectable';
            ab12.Benefit_Type__c = 'Benefit';
            ab12.Copay_Type_1_Mandate_Name__c = 'Test';
            ab12.Type__c = 'Benefit';  
            ab12.Benefit_Record_Type__c = 'BRF';
            ab12.CoInsurance_AmountValueSelected__c = '10';
            ab12.Copay_Type_1_IsCovered__c = 'No';
            ab12.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab12.AnnualMaximumApplies__c = 'Yes';  
            ab12.OON_CoInsurance_AmountValueSelected__c = '10';
            ab12.OON_Copay_Type_1_IsCovered__c = 'No';
            ab12.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab12.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab12);
            
            Insert Benlist;
            
            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            //ag.Group_Type__c = 'Cost Share Group';
            ag.Group_Type__c = 'Benefit Group';
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            
            ag.Proposed_Products__c = pp.id;
            insert ag;
            
            
            AIA_Benefits__c ab = new AIA_Benefits__c();
            ab.Grouper__c = ag.id;
            ab.Copay_Type_1_Mandate_Name__c = 'Test';
            ab.Benefit_Name__c = 'Family Out Of Pocket';
            //ab.Benefit_Type__c = 'Benefit';
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
            ab.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab.Copay_Type_2_AliasName__c = 'Test';
            ab.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab.OON_Copay_Type_2_AliasName__c = 'Test';
            ab.Copay_Min_Payment__c = '20';
            ab.Copay_Max_Payment__c = '30';
            ab.OON_Copay_Min_Payment__c = '10';
            ab.OON_Copay_Max_Payment__c = '10';
            ab.Benefit_Summary_Comment__c ='hello';
            ab.Copay_Type_1_Benefit_Comment_Codes__c ='NA';
            insert ab;
            
            AIA_Benefits__c ab2 = new AIA_Benefits__c();
            ab2.Grouper__c = ag.id;
            ab2.Benefit_Name__c = 'Individual Out Of Pocket';
            ab2.Copay_Type_1_Mandate_Name__c = 'Test';
            //ab2.Benefit_Type__c = 'Benefit';
            ab2.Benefit_Type__c = 'Benefit';
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
            ab2.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab2.Copay_Type_2_AliasName__c = 'Test';
            ab2.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab2.OON_Copay_Type_2_AliasName__c = 'Test';
            ab2.CoInsurance_AmountValueSelected__c = '50';
            ab2.Copay_Type_1_AmountValueSelected__c = '100';
            ab2.Copay_Min_Payment__c = '100';
            ab2.Copay_Max_Payment__c = '200';
            ab2.OON_CoInsurance_AmountValueSelected__c = '50';
            ab2.OON_Copay_Type_1_AmountValueSelected__c = '100';
            ab2.OON_Copay_Min_Payment__c = '100';
            ab2.OON_Copay_Max_Payment__c = '200';
            ab2.Benefit_Summary_Comment__c ='hello';
            ab2.Copay_Type_1_Benefit_Comment_Codes__c ='NA';
            insert ab2;
            
            AIA_Benefits__c ab3 = new AIA_Benefits__c();
            ab3.Grouper__c = ag.id;
            ab3.IS_ASO_Only__c=false;
            ab3.Benefit_Name__c = 'Family Deductible';
            ab3.Benefit_Type__c = 'Benefit';
            ab3.Copay_Type_1_Mandate_Name__c = 'Test';
            ab3.Type__c = 'Cost Share';
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
            ab3.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab3.Copay_Type_2_AliasName__c = 'Test';
            ab3.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab3.OON_Copay_Type_2_AliasName__c = 'Test';
            ab3.IsAppGlobalCopay__c = true;
            insert ab3; 
            
            AIA_Benefits__c ab4 = new AIA_Benefits__c();
            ab4.Grouper__c = ag.id;
            ab4.IS_ASO_Only__c=false;
            ab4.Benefit_Name__c = 'Individual Deductible';
            ab4.Benefit_Type__c = 'Benefit';
            ab4.Copay_Type_1_Mandate_Name__c = 'Test';
            ab4.Type__c = 'Cost Share';
            ab4.Benefit_Record_Type__c = 'BRF';
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
            ab4.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab4.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab4.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab4.Copay_Type_2_AliasName__c = 'Test';
            ab4.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab4.OON_Copay_Type_2_AliasName__c = 'Test';
            ab4.IsAppGlobalCopay__c = true;
            insert ab4;
            
            
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
        
        public Static TestMethod void TestAIA_Benefit_SummaryControllerForGrouperdrug4() {
            
            //Commenting as part of US210
            /* AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
    wpt.Used_For__c = 'Pre-Sales';
    wpt.Workplan_Type__c = 'New';
    wpt.Active__c = true;
    insert wpt;*/
            
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
            Test.starttest();
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
            pp.Integrated_Deductible_Integrator__c = 'Yes';
            pp.Integrated_OOP_Integration__c = 'Yes';
            pp.Rider__c = 'None';
            insert pp;
            
            
            
            AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
            RXgrouper.Name = 'Retail Maintenance';
            RXgrouper.Group_Type__c = 'Benefit Group';
            RXgrouper.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            RXgrouper.Proposed_Products__c = pp.id;
            insert RXgrouper;
            
            List<AIA_Benefits__c> Benlist = new  List<AIA_Benefits__c>();
            AIA_Benefits__c ab7 = new AIA_Benefits__c();
            ab7.Grouper__c = RXgrouper.id;
            ab7.Benefit_Name__c = 'Retail NonMaintenance Generic';
            ab7.Benefit_Type__c = 'Benefit';
            ab7.Copay_Type_1_Mandate_Name__c = 'Test';
            ab7.Type__c = 'Benefit';  
            ab7.Benefit_Record_Type__c = 'BRF';
            ab7.CoInsurance_AmountValueSelected__c = '10';
            ab7.Copay_Type_1_IsCovered__c = 'Yes';
            ab7.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab7.AnnualMaximumApplies__c = 'Yes';  
            ab7.OON_CoInsurance_AmountValueSelected__c = '10';
            ab7.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab7.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab7.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab7); 
            
            AIA_Benefits__c ab13 = new AIA_Benefits__c();
            ab13.Grouper__c = RXgrouper.id;
            ab13.Benefit_Name__c = 'Retail NonMaintenance Generic';
            ab13.Benefit_Type__c = 'Benefit';
            ab13.Copay_Type_1_Mandate_Name__c = 'Test';
            ab13.Type__c = 'Benefit';  
            ab13.Benefit_Record_Type__c = 'BRF';
            ab13.CoInsurance_AmountValueSelected__c = '10';
            ab13.Copay_Type_1_IsCovered__c = 'No';
            ab13.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab13.AnnualMaximumApplies__c = 'Yes';  
            ab13.OON_CoInsurance_AmountValueSelected__c = '10';
            ab13.OON_Copay_Type_1_IsCovered__c = 'No';
            ab13.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab13.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab13);  
            
            
            AIA_Benefits__c ab8 = new AIA_Benefits__c();
            ab8.Grouper__c = RXgrouper.id;
            ab8.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand';
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
            Benlist.add(ab8); 
            
            AIA_Benefits__c ab14 = new AIA_Benefits__c();
            ab14.Grouper__c = RXgrouper.id;
            ab14.Benefit_Name__c = 'Retail NonMaintenance NonPreferred Brand';
            ab14.Benefit_Type__c = 'Benefit';
            ab14.Copay_Type_1_Mandate_Name__c = 'Test';
            ab14.Type__c = 'Benefit';  
            ab14.Benefit_Record_Type__c = 'BRF';
            ab14.CoInsurance_AmountValueSelected__c = '10';
            ab14.Copay_Type_1_IsCovered__c = 'Yes';
            ab14.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab14.AnnualMaximumApplies__c = 'Yes';  
            ab14.OON_CoInsurance_AmountValueSelected__c = '10';
            ab14.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab14.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab14.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab14);
            
            AIA_Benefits__c ab9 = new AIA_Benefits__c();
            ab9.Grouper__c = RXgrouper.id;
            ab9.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand';
            ab9.Benefit_Type__c = 'Benefit';
            ab9.Copay_Type_1_Mandate_Name__c = 'Test';
            ab9.Type__c = 'Benefit';  
            ab9.Benefit_Record_Type__c = 'BRF';
            ab9.CoInsurance_AmountValueSelected__c = '10';
            ab9.Copay_Type_1_IsCovered__c = 'Yes';
            ab9.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab9.AnnualMaximumApplies__c = 'Yes';  
            ab9.OON_CoInsurance_AmountValueSelected__c = '10';
            ab9.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab9.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab9.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab9);  
            
            AIA_Benefits__c ab11 = new AIA_Benefits__c();
            ab11.Grouper__c = RXgrouper.id;
            ab11.Benefit_Name__c = 'Retail NonMaintenance Preferred Brand';
            ab11.Benefit_Type__c = 'Benefit';
            ab11.Copay_Type_1_Mandate_Name__c = 'Test';
            ab11.Type__c = 'Benefit';  
            ab11.Benefit_Record_Type__c = 'BRF';
            ab11.CoInsurance_AmountValueSelected__c = '10';
            ab11.Copay_Type_1_IsCovered__c = 'No';
            ab11.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab11.AnnualMaximumApplies__c = 'Yes';  
            ab11.OON_CoInsurance_AmountValueSelected__c = '10';
            ab11.OON_Copay_Type_1_IsCovered__c = 'No';
            ab11.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab11.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab11);
            
            AIA_Benefits__c ab10 = new AIA_Benefits__c();
            ab10.Grouper__c = RXgrouper.id;
            ab10.Benefit_Name__c = 'Retail NonMaintenance Self-Injectable';
            ab10.Benefit_Type__c = 'Benefit';
            ab10.Copay_Type_1_Mandate_Name__c = 'Test';
            ab10.Type__c = 'Benefit';  
            ab10.Benefit_Record_Type__c = 'BRF';
            ab10.CoInsurance_AmountValueSelected__c = '10';
            ab10.Copay_Type_1_IsCovered__c = 'Yes';
            ab10.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab10.AnnualMaximumApplies__c = 'Yes';  
            ab10.OON_CoInsurance_AmountValueSelected__c = '10';
            ab10.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab10.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab10.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab10);  
            
            AIA_Benefits__c ab12 = new AIA_Benefits__c();
            ab12.Grouper__c = RXgrouper.id;
            ab12.Benefit_Name__c = 'Retail NonMaintenance Self-Injectable';
            ab12.Benefit_Type__c = 'Benefit';
            ab12.Copay_Type_1_Mandate_Name__c = 'Test';
            ab12.Type__c = 'Benefit';  
            ab12.Benefit_Record_Type__c = 'BRF';
            ab12.CoInsurance_AmountValueSelected__c = '10';
            ab12.Copay_Type_1_IsCovered__c = 'No';
            ab12.Copay_Type_1_DeductibleApplies__c  = 'Yes';
            ab12.AnnualMaximumApplies__c = 'Yes';  
            ab12.OON_CoInsurance_AmountValueSelected__c = '10';
            ab12.OON_Copay_Type_1_IsCovered__c = 'No';
            ab12.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab12.OON_AnnualMaximumApplies__c = 'Yes';
            Benlist.add(ab12);
            
            Insert Benlist;
            
            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            //ag.Group_Type__c = 'Cost Share Group';
            ag.Group_Type__c = 'Benefit Group';
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            
            ag.Proposed_Products__c = pp.id;
            insert ag;
            
            
            AIA_Benefits__c ab = new AIA_Benefits__c();
            ab.Grouper__c = ag.id;
            ab.Copay_Type_1_Mandate_Name__c = 'Test';
            ab.Benefit_Name__c = 'Family Out Of Pocket';
            //ab.Benefit_Type__c = 'Benefit';
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
            ab.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab.Copay_Type_2_AliasName__c = 'Test';
            ab.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab.OON_Copay_Type_2_AliasName__c = 'Test';
            ab.Copay_Min_Payment__c = '20';
            ab.Copay_Max_Payment__c = '30';
            ab.OON_Copay_Min_Payment__c = '10';
            ab.OON_Copay_Max_Payment__c = '10';
            ab.Benefit_Summary_Comment__c ='hello';
            ab.Copay_Type_1_Benefit_Comment_Codes__c ='NA';
            insert ab;
            
            AIA_Benefits__c ab2 = new AIA_Benefits__c();
            ab2.Grouper__c = ag.id;
            ab2.Benefit_Name__c = 'Individual Out Of Pocket';
            ab2.Copay_Type_1_Mandate_Name__c = 'Test';
            //ab2.Benefit_Type__c = 'Benefit';
            ab2.Benefit_Type__c = 'Benefit';
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
            ab2.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab2.Copay_Type_2_AliasName__c = 'Test';
            ab2.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab2.OON_Copay_Type_2_AliasName__c = 'Test';
            ab2.CoInsurance_AmountValueSelected__c = '50';
            ab2.Copay_Type_1_AmountValueSelected__c = '100';
            ab2.Copay_Min_Payment__c = '100';
            ab2.Copay_Max_Payment__c = '200';
            ab2.OON_CoInsurance_AmountValueSelected__c = '50';
            ab2.OON_Copay_Type_1_AmountValueSelected__c = '100';
            ab2.OON_Copay_Min_Payment__c = '100';
            ab2.OON_Copay_Max_Payment__c = '200';
            ab2.Benefit_Summary_Comment__c ='hello';
            ab2.Copay_Type_1_Benefit_Comment_Codes__c ='NA';
            insert ab2;
            
            AIA_Benefits__c ab3 = new AIA_Benefits__c();
            ab3.Grouper__c = ag.id;
            ab3.IS_ASO_Only__c=false;
            ab3.Benefit_Name__c = 'Family Deductible';
            ab3.Benefit_Type__c = 'Benefit';
            ab3.Copay_Type_1_Mandate_Name__c = 'Test';
            ab3.Type__c = 'Cost Share';
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
            ab3.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab3.Copay_Type_2_AliasName__c = 'Test';
            ab3.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab3.OON_Copay_Type_2_AliasName__c = 'Test';
            ab3.IsAppGlobalCopay__c = true;
            insert ab3; 
            
            AIA_Benefits__c ab4 = new AIA_Benefits__c();
            ab4.Grouper__c = ag.id;
            ab4.IS_ASO_Only__c=false;
            ab4.Benefit_Name__c = 'Individual Deductible';
            ab4.Benefit_Type__c = 'Benefit';
            ab4.Copay_Type_1_Mandate_Name__c = 'Test';
            ab4.Type__c = 'Cost Share';
            ab4.Benefit_Record_Type__c = 'BRF';
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
            ab4.OON_Copay_Type_1_IsCovered__c = 'Yes';
            ab4.OON_Copay_Type_1_DeductibleApplies__c = 'No';
            ab4.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab4.Copay_Type_2_AliasName__c = 'Test';
            ab4.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab4.OON_Copay_Type_2_AliasName__c = 'Test';
            ab4.IsAppGlobalCopay__c = true;
            insert ab4;
            
            
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
        
        //The Benefit Request Form cannot be modified after it has been sold
        public Static TestMethod void TestMainInitErrors() {
            
            Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            Opportunity o = new opportunity();
            o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
            o.AccountId = acc.id;
            o.name = 'Test Opportunity';
            o.SBU__c = 'Large';
            o.Market_Segment_New__c = '200-999';//mod offshore
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
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'Sold';
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
            brf.Funding_Arrangements__c = 'Risk';
            insert brf;
            
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Vision', 'Test');
            aiapln.Has_Benefit_Summary__c = True;
            aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.QA_Complete__c = true;
            insert aiapln;
            
            
            Proposed_Products__c pp1 = new Proposed_Products__c();
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Vision');
            pp1.Benefit_Request_Form__c = brf.id;
            pp1.Funding_Arrangement__c = 'Risk';
            pp1.Product_Category__c = 'Vision';
            pp1.Product_Line__c = 'PPO';
            pp1.Plan_Name__c = aiapln.id;
            pp1.Product_Name__c = 'BlueChoice Advantage';
            pp1.CDH__c = 'Yes';
            pp1.CDH_Fund_Type__c = 'BlueFund';
            pp1.CDH_Type__c = 'HSA';
            pp1.Deductible__c = 'Stacked';
            pp1.Grandfathered_Status__c = 'Grandfathered';
            pp1.Integrated_Non_Integrated__c = 'Yes';
            pp1.Grandfathered_PPACA_Status__c = 'No';
            pp1.Blue_Rewards__c = 'Standard';
            pp1.Out_of_Pocket_Max__c = 'Stacked';
            // pp.Jurisdiction__c = 'MD';
            pp1.Has_Benefit_Details__c = false;
            pp1.Rider__c = 'None';
            insert pp1;
            
            test.starttest();
            AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
            
            PageReference pref = Page.AIA_ProposedProd_Summary;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id', pp1.id);
            ApexPages.StandardController con = new ApexPages.StandardController(pp1);
            ApexPages.currentPage().getParameters().put('id', pp1.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
            
            ext.mainInit();
            test.stoptest();
        }
        
        //The Benefit Request Form cannot be modified after it has been submitted for ARC Approval.
        public Static TestMethod void TestMainInitErrors2() {
            
            Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            Opportunity o = new opportunity();
            o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
            o.AccountId = acc.id;
            o.name = 'Test Opportunity';
            o.SBU__c = 'Large';
            o.Market_Segment_New__c = '200-999';//mod offshore
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
            brf.Funding_Arrangements__c = 'Risk';
            brf.ARC_Approval_Status__c = 'Approved by Committee';
            insert brf;
            
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Vision', 'Test');
            aiapln.Has_Benefit_Summary__c = True;
            aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.QA_Complete__c = true;
            aiapln.Plan_Id__c = null;
            insert aiapln;
            
            Proposed_Products__c pp1 = new Proposed_Products__c();
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Vision');
            pp1.Benefit_Request_Form__c = brf.id;
            pp1.Funding_Arrangement__c = 'Risk';
            pp1.Product_Category__c = 'Vision';
            pp1.Product_Line__c = 'PPO';
            pp1.Plan_Name__c = aiapln.id;
            pp1.Product_Name__c = 'BlueChoice Advantage';
            pp1.CDH__c = 'Yes';
            pp1.CDH_Fund_Type__c = 'BlueFund';
            pp1.CDH_Type__c = 'HSA';
            pp1.Deductible__c = 'Stacked';
            pp1.Grandfathered_Status__c = 'Grandfathered';
            pp1.Integrated_Non_Integrated__c = 'Yes';
            pp1.Grandfathered_PPACA_Status__c = 'No';
            pp1.Blue_Rewards__c = 'Standard';
            pp1.Out_of_Pocket_Max__c = 'Stacked';
            // pp.Jurisdiction__c = 'MD';
            pp1.Has_Benefit_Details__c = false;
            pp1.Rider__c = 'None';
            insert pp1;
            
            test.starttest();
            AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
            
            PageReference pref = Page.AIA_ProposedProd_Summary;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id', pp1.id);
            ApexPages.StandardController con = new ApexPages.StandardController(pp1);
            ApexPages.currentPage().getParameters().put('id', pp1.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
            
            ext.mainInit();
            test.stoptest();
        }
        
        
        //No PCS Plan ID  found for the selected Plan
        public Static TestMethod void TestMainInitErrors3() {
            
            Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            Opportunity o = new opportunity();
            o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
            o.AccountId = acc.id;
            o.name = 'Test Opportunity';
            o.SBU__c = 'Large';
            o.Market_Segment_New__c = '200-999';//mod offshore
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
            brf.Funding_Arrangements__c = 'Risk';
            insert brf;
            
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Vision', 'Test');
            aiapln.Has_Benefit_Summary__c = True;
            aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.QA_Complete__c = true;
            aiapln.Plan_Id__c = null;
            insert aiapln;
            
            Proposed_Products__c pp1 = new Proposed_Products__c();
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Vision');
            pp1.Benefit_Request_Form__c = brf.id;
            pp1.Funding_Arrangement__c = 'Risk';
            pp1.Product_Category__c = 'Vision';
            pp1.Product_Line__c = 'PPO';
            pp1.Plan_Name__c = aiapln.id;
            pp1.Product_Name__c = 'BlueChoice Advantage';
            pp1.CDH__c = 'Yes';
            pp1.CDH_Fund_Type__c = 'BlueFund';
            pp1.CDH_Type__c = 'HSA';
            pp1.Deductible__c = 'Stacked';
            pp1.Grandfathered_Status__c = 'Grandfathered';
            pp1.Integrated_Non_Integrated__c = 'Yes';
            pp1.Grandfathered_PPACA_Status__c = 'No';
            pp1.Blue_Rewards__c = 'Standard';
            pp1.Out_of_Pocket_Max__c = 'Stacked';
            // pp.Jurisdiction__c = 'MD';
            pp1.Has_Benefit_Details__c = false;
            pp1.Rider__c = 'None';
            insert pp1;
            
            
            test.starttest();
            AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
            
            PageReference pref = Page.AIA_ProposedProd_Summary;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id', pp1.id);
            ApexPages.StandardController con = new ApexPages.StandardController(pp1);
            ApexPages.currentPage().getParameters().put('id', pp1.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
            
            ext.mainInit();
            test.stoptest();
        }
        
        public Static TestMethod void TestAIA_Benefit_SummaryControllerVision() {
            
            //Commenting as part of US210
            /* AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
    wpt.Used_For__c = 'Pre-Sales';
    wpt.Workplan_Type__c = 'New';
    wpt.Active__c = true;
    insert wpt;*/
            
            Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            Opportunity o = new opportunity();
            o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
            o.AccountId = acc.id;
            o.name = 'Test Opportunity';
            o.SBU__c = 'Large';
            o.Market_Segment_New__c = '200-999';//mod offshore
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
            brf.Funding_Arrangements__c = 'Risk';
            insert brf;
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Vision', 'Test');
            aiapln.Has_Benefit_Summary__c = True;
            aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            //  aiapln.Product_Last_Updated__c=Date.today()+1;
            // aiapln.Configuration_Last_Updated__c = Date.today();
            insert aiapln;
            
            AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
            pn.ExtID__c = 'PLAN-001N_BRF1';
            pn.Name = 'InNetwork';
            pn.Plan__c = aiapln.id;
            insert pn;
            
            AIA_Plan_Network__c pn2 = new AIA_Plan_Network__c();
            pn2.ExtID__c = 'PLAN-001N_BRF12';
            pn2.Name = 'OutNetwork';
            pn2.Plan__c = aiapln.id;
            insert pn2;
            
            List < AIA_Plan_Grouper__c > lstGrp = new List < AIA_Plan_Grouper__c > ();
            AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
            pg3.Name = 'Medical Supplies/Equipment-0628';
            pg3.Plan_Network__c = pn.id;
            pg3.Type__c = 'Benefit Group';
            pg3.Sequence_Number__c = 1;
            pg3.Record_Type__c = 'BRF';
            pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
            // insert pg3;
            lstGrp.add(pg3);
            
            AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
            pg4.Name = 'Medical Supplies/Equipment-0628';
            pg4.Plan_Network__c = pn2.id;
            pg4.Type__c = 'Benefit Group';
            pg4.Sequence_Number__c = 1;
            pg4.Record_Type__c = 'BRF';
            pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
            //insert pg4;
            lstGrp.add(pg4);
            
            insert lstGrp;
            
            
            AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
            apbt.Benefit_Name__c ='wdwd';
            apbt.Benefit_Group__c = pg3.id;
            apbt.Record_Type__c = 'BRF';
            apbt.Sequence_Number__c = 1;
            apbt.Coinsurance_DefaultAmount__c = '2323';  
            apbt.Davis_Benefit_Variable__c = '10';    
            apbt.ISExisting_Benefit__c = True;
            apbt.Type__c='Benefit';
            apbt.IsAppGlobalCopay__c=True;
            insert apbt;
            
            AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
            apbt1.Benefit_Name__c ='wdwd';
            apbt1.Benefit_Group__c = pg4.id;
            apbt1.Record_Type__c = 'BRF';
            apbt1.Sequence_Number__c = 1;
            apbt1.Coinsurance_DefaultAmount__c = '2323';   
            apbt1.ISExisting_Benefit__c = True;
            apbt1.Davis_Benefit_Variable__c = '10';
            apbt1.Type__c='Benefit';
            apbt1.IsAppGlobalCopay__c=True;
            
            insert apbt1;  
            
            
            //  insert lstPlnt;
            
            AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
            apc.Plan_Benefits__c = apbt.id;
            apc.AliasName__c = 'PCP Copay';
            apc.CopayAmount__c = '200';
            apc.Discount_Amount__c = '10';
            apc.Approximate_Member_Payment_w_Discount__c = '10';
            apc.Allowed_Amount__c = '15';
            apc.CoinsuranceAmount__c = '50';
            apc.MinPayAmount__c = '90';
            apc.MaxPayAmount__c = '80';
            apc.IsCovered__c = 'Yes';
            apc.DeductibleApplies__c = 'No';
            apc.MandateIndicator__c = 'No';
            apc.Jurisdiction__c = 'MD';
            apc.MandateName__c = 'Home health care ';
            apc.ExtID__c = 'rwuifghqierufghaire';
            insert apc;
            
            AIA_Plan_Copay_Type__c apc3 = new AIA_Plan_Copay_Type__c();
            apc3.Plan_Benefits__c = apbt1.id;
            apc3.AliasName__c = 'General Copay';
            apc3.Discount_Amount__c = '10';
            apc3.Approximate_Member_Payment_w_Discount__c = '10';
            apc3.Allowed_Amount__c = '15';
            apc3.CopayAmount__c = '200';
            apc3.CoinsuranceAmount__c = '50';
            apc3.MinPayAmount__c = '90';
            apc3.MaxPayAmount__c = '80';
            apc3.IsCovered__c = 'Yes';
            apc3.DeductibleApplies__c = 'No';
            apc3.MandateIndicator__c = 'No';
            apc3.Jurisdiction__c = 'MD';
            apc3.MandateName__c = 'Home health care ';
            apc3.ExtID__c = 'rwuifghqierufghaire';
            insert apc3;
            
            
            Proposed_Products__c pp1 = new Proposed_Products__c();
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Vision');
            pp1.Benefit_Request_Form__c = brf.id;
            pp1.Funding_Arrangement__c = 'Risk';
            pp1.Product_Category__c = 'Vision';
            pp1.Product_Line__c = 'PPO';
            pp1.Plan_Name__c = aiapln.id;
            pp1.Product_Name__c = 'BlueChoice Advantage';
            pp1.CDH__c = 'Yes';
            pp1.CDH_Fund_Type__c = 'BlueFund';
            pp1.CDH_Type__c = 'HSA';
            pp1.Deductible__c = 'Stacked';
            pp1.Grandfathered_Status__c = 'Grandfathered';
            pp1.Integrated_Non_Integrated__c = 'Yes';
            pp1.Grandfathered_PPACA_Status__c = 'No';
            pp1.Blue_Rewards__c = 'Standard';
            pp1.Out_of_Pocket_Max__c = 'Stacked';
            // pp.Jurisdiction__c = 'MD';
            pp1.Has_Benefit_Details__c = false;
            pp1.Rider__c = 'None';
            insert pp1;
            
            //offshore
            AIA_Grouper__c ag = new AIA_Grouper__c();
            ag.Name = 'CostShareRanges';
            ag.Group_Type__c = 'Cost Share Group';
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            ag.Proposed_Products__c = pp1.id;
            insert ag;
            
            createBenefit('PCP Copay',ag);
            createBenefit('Specialist Copay',ag);
            createBenefit('Per Admission Copay',ag);
            createBenefit('General Copay',ag);
            createBenefit('Coinsurance',ag);
            
            
            test.starttest();
            AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
            
            PageReference pref = Page.AIA_ProposedProd_Summary;
            Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id', pp1.id);
            ApexPages.StandardController con = new ApexPages.StandardController(pp1);
            ApexPages.currentPage().getParameters().put('id', pp1.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
            
            ext.mainInit();
            // Commenting as part of US1650
            //ext.getPCSdata();
            ext.createWrapListFromPlan(pp1);
            ext.createWrapListFromPlanCostShr(aiapln.id);
            ext.SaveAndContinuePlanBenefits(pp1);
            ext.hideErrorpanel();
            ext.showerror = true;
            ext.saveAndCon();
            ext.addPlan();
            ext.saveandRedirct();
            ext.reviewInit();
            ext.rowOrder = 0;
            
            ext.dispatcherTemp();
            ext.back();
            boolean testbol2 = ext.ValidateCoInsurance('-10','test');
            boolean testbol3 = ext.isMultipleofActual(3,1);
            boolean testbol4 = ext.validateCopayValues('10','10','10','10','10','0','10');
            AIA_Benefit_SummaryController benefitSummaryCtrl = new AIA_Benefit_SummaryController();
            //benefitSummaryCtrl.rowOrder = 1;
            //benefitSummaryCtrl.dispatcherTemp();
            test.stoptest();
        }
        
        public static void createBenefit(String bname,AIA_Grouper__c ag){
            AIA_Benefits__c ab = new AIA_Benefits__c();
            ab.Grouper__c = ag.id;
            ab.IS_ASO_Only__c=false;
            ab.Benefit_Name__c = bname;//mod
            ab.Benefit_Type__c = 'Benefit';
            ab.Copay_Type_1_Mandate_Name__c = 'Test';
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
            ab.Copay_Type_1_AliasName__c = 'PCP Copay';
            ab.Copay_Type_2_AliasName__c = 'Test';
            ab.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            ab.OON_Copay_Type_2_AliasName__c = 'Test';
            ab.IsAppGlobalCopay__c = true;
            ab.Cost_Share_SelectedAmount__c='200';
            insert ab; 
            Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Maxrow');
            insert lmt;
            
        }
        @istest
        public static void testMethodCheck()
        {
            
            /* Account acc = AIA_TestUtil.CreateAccount('TestAccount');
    
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
    
    Benfit_Request_Form__c brf123 = new Benfit_Request_Form__c();    
    
    brf123.Contract_Count__c = 123;
    brf123.Benefit_Effective_Date__c = system.today();
    //brf.ARC_Approval_Status__c = 'Approved by Committee';
    brf123.Escalated_to_Senior_Management__c = true;
    brf123.Status__c = 'New';
    brf123.Account__c = acc.id;
    brf123.Opportunity__c = o.id;
    brf123.Jurisdiction__c = 'MD';
    brf123.Request_Type__c = 'Renewal';
    brf123.Benefit_Period__c = 'Calendar';
    brf123.Control_Plan__c = '580';
    brf123.Sales_Segment_Size__c = 'Commercial 200-999';
    brf123.Contract_Period__c = 'Standard - 12 Months';
    brf123.Grandfathered_Status__c = 'Grandfathered'; 
    brf123.Identity_Protection__c = 'No';
    brf123.Broker_Commission__c = 3.5;
    brf123.Contract_Count__c = 5;
    brf123.Formulary__c = '1';
    brf123.Maintenance_Choice__c = 'Mandatory';
    insert brf123;
    
    AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
    aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
    aiapln.Jurisdiction__c = 'MD';
    aiapln.QA_Complete__c=true;
    insert aiapln;
    
    Proposed_Products__c ppTest=new Proposed_Products__c();
    ppTest.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
    ppTest.Benefit_Request_Form__c = brf123.id;
    ppTest.Funding_Arrangement__c = 'ASO';
    ppTest.Product_Category__c = 'Drug';
    ppTest.Product_Line__c = 'PPO';
    ppTest.Has_Benefit_Details__c=false;*/
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
            aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
            aiapln.Jurisdiction__c = 'MD';
            aiapln.QA_Complete__c=true;
            insert aiapln;
            
            testMethodInsert();
            Proposed_Products__c ppTest=[SELECT Id FROM Proposed_Products__c LIMIT 1];
            ppTest.Plan_Name__c=aiapln.Id;
            update ppTest;
            
            
            AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
            RXgrouper.Name = 'Retail NonMaintenance';
            RXgrouper.Group_Type__c = 'Benefit Group';
            RXgrouper.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            RXgrouper.Proposed_Products__c = ppTest.id;
            insert RXgrouper;
            
            test.startTest();
            PageReference pageRef = Page.AIA_ProposedProd_Summary;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ppTest);
            ApexPages.currentPage().getParameters().put('id',ppTest.id);
            AIA_Benefit_SummaryController bsc = new AIA_Benefit_SummaryController(sc);
            bsc.mainInit();
            bsc.dispatcher();
            
            
            test.stopTest();
        }
        
        public static void testMethodInsert()
        {
            
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
            
            Benfit_Request_Form__c brf123 = new Benfit_Request_Form__c();    
            
            brf123.Contract_Count__c = 123;
            brf123.Benefit_Effective_Date__c = system.today();
            //brf.ARC_Approval_Status__c = 'Approved by Committee';
            brf123.Escalated_to_Senior_Management__c = true;
            brf123.Status__c = 'New';
            brf123.Account__c = acc.id;
            brf123.Opportunity__c = o.id;
            brf123.Jurisdiction__c = 'MD';
            brf123.Request_Type__c = 'Renewal';
            brf123.Benefit_Period__c = 'Calendar';
            brf123.Control_Plan__c = '580';
            brf123.Sales_Segment_Size__c = 'Commercial 200-999';
            brf123.Contract_Period__c = 'Standard - 12 Months';
            brf123.Grandfathered_Status__c = 'Grandfathered'; 
            brf123.Identity_Protection__c = 'No';
            brf123.Broker_Commission__c = 3.5;
            brf123.Contract_Count__c = 5;
            brf123.Formulary__c = '1';
            brf123.Maintenance_Choice__c = 'Mandatory';
            insert brf123;
            
            Proposed_Products__c ppTest=new Proposed_Products__c();
            ppTest.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
            ppTest.Benefit_Request_Form__c = brf123.id;
            ppTest.Funding_Arrangement__c = 'ASO';
            ppTest.Product_Category__c = 'Drug';
            ppTest.Product_Line__c = 'PPO';
            ppTest.Has_Benefit_Details__c=false;
            insert ppTest;
            
            AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
            RXgrouper.Name = 'Retail NonMaintenance';
            RXgrouper.Group_Type__c = 'Benefit Group';
            RXgrouper.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            RXgrouper.Proposed_Products__c = ppTest.id;
            insert RXgrouper;

        }
        
        @istest
        public static void testMethodCheck1()
        {
           	testMethodInsert();
            Proposed_Products__c proProd= [SELECT Id FROM Proposed_Products__c LIMIT 1];
            test.startTest();
            PageReference pageRef = Page.AIA_ProposedProd_Summary;
            Test.setCurrentPage(pageRef);
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(proProd);
            ApexPages.currentPage().getParameters().put('id',proProd.id);
            AIA_Benefit_SummaryController cntrl = new AIA_Benefit_SummaryController(sc);
            cntrl.dispatcher();
            cntrl.createListFromPPTemp(proProd.id,true);
           // cntrl.createListFromPP(proProd.id,false);
            proProd.Funding_Arrangement__c='Risk';
            proProd.Has_Benefit_Details__c=true;
            update proProd;
            AIA_Grouper__c grp=[SELECT Id FROM AIA_Grouper__c WHERE Name='Retail NonMaintenance' and Proposed_Products__c=:proProd.Id LIMIT 1];
			grp.Group_Type__c='Cost Share Group	';
            update grp;
           // cntrl.dispatcher();
            cntrl.createListFromPP(proProd.id,false);
            test.stopTest();
        }
        
        //R1E1 Start
        @istest
        public static void testValidatePlanBenifits()
        {
            Account acc = AIA_TestUtil.createAccount('TestAccount');
            Opportunity opp = AIA_TestUtil.CreateOpportunity(acc.Id);
            
            //proposed product
            Proposed_Products__c ppTest=new Proposed_Products__c();
            ppTest.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
            ppTest.Funding_Arrangement__c = 'Risk';
            ppTest.Product_Category__c = 'Drug';
            ppTest.Product_Line__c = 'PPO';
            ppTest.Has_Benefit_Details__c=true;
            
            //benefit costs
            AIA_Benefits__c bc1 = new AIA_Benefits__c();
            bc1.Benefit_Name__c = 'PCP Copay';
            bc1.Cost_Share_SelectedAmount__c='1';
            bc1.OON_Cost_Share_SelectedAmount__c='2';
            
            AIA_Benefits__c bc2 = new AIA_Benefits__c();
            bc2.Benefit_Name__c = 'Specialist Copay';
            bc2.Cost_Share_SelectedAmount__c='1';
            bc2.OON_Cost_Share_SelectedAmount__c='2';
            
            AIA_Benefits__c bc3 = new AIA_Benefits__c();
            bc3.Benefit_Name__c = 'Per Admission Copay';
            bc3.Cost_Share_SelectedAmount__c='1';
            bc3.OON_Cost_Share_SelectedAmount__c='2';
            
            AIA_Benefits__c bc4 = new AIA_Benefits__c();
            bc4.Benefit_Name__c = 'General Copay';
            bc4.Cost_Share_SelectedAmount__c='1';
            bc4.OON_Cost_Share_SelectedAmount__c='2';
            
            AIA_Benefits__c bc5 = new AIA_Benefits__c();
            bc5.Benefit_Name__c = 'Coinsurance';
            bc5.Cost_Share_SelectedAmount__c='1';
            bc5.OON_Cost_Share_SelectedAmount__c='2';
            
            List<AIA_Benefits__c> benCostList = new  List<AIA_Benefits__c>{bc1, bc2, bc3, bc4, bc5};
            
            //benefits
            AIA_Benefit_SummaryController.BenifitsrWrapper benWrapper;
            List<AIA_Benefit_SummaryController.BenifitsrWrapper> benifitWrapList = new  List<AIA_Benefit_SummaryController.BenifitsrWrapper>();
                
            AIA_Benefits__c b1 = new AIA_Benefits__c();
            b1.IsAppGlobalCopay__c = true;
            b1.Copay_Type_1_AmountValueSelected__c = '';
            b1.Copay_Type_2_AmountValueSelected__c = '';
            b1.OON_Copay_Type_1_AmountValueSelected__c = '';
            b1.OON_Copay_Type_2_AmountValueSelected__c = '';
            b1.Copay_Type_1_AliasName__c = 'PCP Copay';
            b1.Copay_Type_2_AliasName__c = 'PCP Copay';
            b1.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
            benWrapper = new AIA_Benefit_SummaryController.BenifitsrWrapper();
            benWrapper.aiaBenifitObj = b1;
            benifitWrapList.add(benWrapper);
            
            AIA_Benefits__c b2 = new AIA_Benefits__c();
            b2.IsAppGlobalCopay__c = true;
            b2.Copay_Type_1_AmountValueSelected__c = '';
            b2.Copay_Type_2_AmountValueSelected__c = '';
            b2.OON_Copay_Type_1_AmountValueSelected__c = '';
            b2.OON_Copay_Type_2_AmountValueSelected__c = '';
            b2.Copay_Type_1_AliasName__c = 'Specialist Copay';
            b2.Copay_Type_2_AliasName__c = 'Specialist Copay';
            b2.OON_Copay_Type_1_AliasName__c = 'Specialist Copay';
            benWrapper = new AIA_Benefit_SummaryController.BenifitsrWrapper();
            benWrapper.aiaBenifitObj = b2;
            benifitWrapList.add(benWrapper);
            
            AIA_Benefits__c b3 = new AIA_Benefits__c();
            b3.IsAppGlobalCopay__c = true;
            b3.Copay_Type_1_AmountValueSelected__c = '';
            b3.Copay_Type_2_AmountValueSelected__c = '';
            b3.OON_Copay_Type_1_AmountValueSelected__c = '';
            b3.OON_Copay_Type_2_AmountValueSelected__c = '';
            b3.Copay_Type_1_AliasName__c = 'General Copay';
            b3.Copay_Type_2_AliasName__c = 'General Copay';
            b3.OON_Copay_Type_1_AliasName__c = 'General Copay';
            benWrapper = new AIA_Benefit_SummaryController.BenifitsrWrapper();
            benWrapper.aiaBenifitObj = b3;
            benifitWrapList.add(benWrapper);
            
            AIA_Benefits__c b4 = new AIA_Benefits__c();
            b4.IsAppGlobalCopay__c = true;
            b4.Copay_Type_1_AmountValueSelected__c = '';
            b4.Copay_Type_2_AmountValueSelected__c = '';
            b4.OON_Copay_Type_1_AmountValueSelected__c = '';
            b4.OON_Copay_Type_2_AmountValueSelected__c = '';
            b4.Copay_Type_1_AliasName__c = 'Per Admission Copay';
            b4.Copay_Type_2_AliasName__c = 'Per Admission Copay';
            b4.OON_Copay_Type_1_AliasName__c = 'Per Admission Copay';
            benWrapper = new AIA_Benefit_SummaryController.BenifitsrWrapper();
            benWrapper.aiaBenifitObj = b4;
            benifitWrapList.add(benWrapper);
            
            AIA_Benefits__c b5 = new AIA_Benefits__c();
            b5.IsAppGlobalCoinsurance__c = true;
            b5.CoInsurance_AmountValueSelected__c = '';
            b5.OON_CoInsurance_AmountValueSelected__c = '';
            b5.Coinsurance_AmountLow__c='0';
            b5.OON_Coinsurance_AmountLow__c='0';
            benWrapper = new AIA_Benefit_SummaryController.BenifitsrWrapper();
            benWrapper.aiaBenifitObj = b5;
            benifitWrapList.add(benWrapper);

            //Group Wrapper
            AIA_Benefit_SummaryController.GrouperWrapper grpWrapper = new AIA_Benefit_SummaryController.GrouperWrapper();
            grpWrapper.benifitWrapList = benifitWrapList;
            
            test.startTest();
            AIA_Benefit_SummaryController cont = new AIA_Benefit_SummaryController();
            cont.grouperWrapList = new List<AIA_Benefit_SummaryController.GrouperWrapper>{grpWrapper};
            cont.pp = ppTest;
            cont.bnftcostlst = benCostList;
            cont.saveAndCon();
            cont.getIsClassic();
            List<AIA_RxMandate__c> PPRxMandate = cont.PPRxMandate;
            String resultvalue = cont.resultvalue;
            List<Proposed_Products__c> relatedMedicalPPList = cont.relatedMedicalPPList;
            integer rowHidden = cont.rowHidden;
            test.stopTest();
        }
        
         @istest
        public static void test_validateCopayValues(){
            
            AIA_Benefit_SummaryController cont = new AIA_Benefit_SummaryController();
            cont.validateCopayValues('10', '', 'increment', '5', 'invalidincrement', '5', 'benifitName');
            cont.validateCopayValues(null, null, 'increment', '', 'invalidincrement', '5', 'benifitName');
            cont.validateCopayValues('15', null, 'increment', '', 'invalidincrement', '10', 'benifitName');
            cont.validateCopayValues('15', '12', 'increment', '', '10', '10', 'benifitName');
            cont.validateCopayValues('15', '5', '5', '', '10', '10', 'benifitName');
            cont.validateCopayValues('15', '5', '5', '', '15', '10', 'benifitName');
            cont.validateCopayValues('15', '5', '5', '', '', '10', 'benifitName');
            cont.validateCopayValues('15', '5', '3', '', 'invalidincrement', '10', 'benifitName');
            cont.validateCopayValues('10', '5', 'increment', '', 'invalidincrement', '15', 'benifitName');
        }
        
         @istest
        public static void test_mainInitException(){
            
            ApexPages.currentPage().getParameters().put('id','xxxxxxxxxxxxxxx');
            AIA_Benefit_SummaryController cont = new AIA_Benefit_SummaryController();
            cont.mainInit();
        }
        
        //R1E1 End
    }