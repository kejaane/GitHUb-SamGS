/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================

*06/08/2018    raj kiran      T01       Added code for role updates
*==================================================================================

*******************************************************************************************************/


@istest
public class AIA_BenefittriggerHandlerHelper_Test {
public Static TestMethod void TestAIA_Benefit_Creation(){
    
    //Commenting as part of US210   
      /* AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
          insert wpt;*/
       //Test.startTest();
          Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        AIA_BenefittriggerHandlerHelper_Test.createAccountTeamMembers(acc.Id);
       
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
       
       
       
       
      Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
  insert brf;
       AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
          aiapln.Has_Benefit_Summary__c = True;
          aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
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
       List<AIA_Plan_Grouper__c> lstGrp = new List<AIA_Plan_Grouper__c>();
          AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
            pg.Name = 'CostShareRanges';
            pg.Plan_Network__c = pn.id;
            pg.Type__c = 'Cost Share Group';
            pg.Record_Type__c = 'BRF';
            pg.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00';
            //insert pg;
          lstGrp.add(pg);
            
           AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
            pg2.Name = 'CostShareRanges';
            pg2.Plan_Network__c = pn2.id;
            pg2.Type__c = 'Cost Share Group';
            pg2.Record_Type__c = 'BRF';
            pg2.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002';
         //   insert pg2;
         lstGrp.add(pg2);
            
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
            pg4.Name = 'Medical Supplies/Equipment-0629';
            pg4.Plan_Network__c = pn2.id;
            pg4.Type__c = 'Benefit Group';
            pg4.Sequence_Number__c = 1;
            pg4.Record_Type__c = 'BRF';
            pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
            //insert pg4;
           lstGrp.add(pg4);
           
           insert lstGrp;
           
          List<AIA_Plan_Benefits__c> lstPlnt = new List<AIA_Plan_Benefits__c>();
           AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
            pb.Benefit_Name__c = 'OutOfPocket_Individual';
            pb.Record_Type__c = 'BRF';
            pb.Type__c = 'Benefit';
            pb.Benefit_Group__c = pg3.id;
            pb.Cost_Share_Low__c = '0';
            pb.Cost_Share_High__c = '100';
            pb.Cost_Share_Increment__c = '10';
            pb.Cost_Share_Default_Amount__c = '40';
            pb.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb.Cost_Share_InvalidIncrements__c = '20, 30';
            pb.Sequence_Number__c = 1;
            //insert pb;
            lstPlnt.add(pb);
        
        AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
            pb29.Benefit_Name__c = '';
            pb29.Record_Type__c = 'BRF';
            pb29.Type__c = 'Benefit';
            pb29.Benefit_Group__c = pg4.id;
            pb29.Cost_Share_Low__c = '0';
            pb29.Cost_Share_High__c = '100';
            pb29.Cost_Share_Increment__c = '10';
            pb29.Cost_Share_Default_Amount__c = '40';
            pb29.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb29.Cost_Share_InvalidIncrements__c = '20, 30';
            pb29.Sequence_Number__c = 1;
           // insert pb29;
           lstPlnt.add(pb29);
          
          AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
            pb2.Benefit_Name__c = 'OutOfPocket_Family';
            pb2.Record_Type__c = 'BRF';
            pb2.Type__c = 'Cost Share';
            pb2.Benefit_Group__c = pg.id;
            pb2.Cost_Share_Low__c = '0';
            pb2.Cost_Share_High__c = '100';
            pb2.Cost_Share_Increment__c = '10';
            pb2.Cost_Share_Default_Amount__c = '40';
            pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb2.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb2;
          lstPlnt.add(pb2);
        
            AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
            pb3.Benefit_Name__c = 'OutOfPocket_Single';
            pb3.Record_Type__c = 'BRF';
            pb3.Type__c = 'Cost Share';
            pb3.Benefit_Group__c = pg.id;
            pb3.Cost_Share_Low__c = '0';
            pb3.Cost_Share_High__c = '100';
            pb3.Cost_Share_Increment__c = '10';
            pb3.Cost_Share_Default_Amount__c = '40';
            pb3.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb3.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb3;
           lstPlnt.add(pb3); 
            AIA_Plan_Benefits__c pb4 = new AIA_Plan_Benefits__c();
            pb4.Benefit_Name__c = 'Deductible_Individual';
            pb4.Record_Type__c = 'BRF';
            pb4.Type__c = 'Cost Share';
            pb4.Benefit_Group__c = pg.id;
            pb4.Cost_Share_Low__c = '0';
            pb4.Cost_Share_High__c = '100';
            pb4.Cost_Share_Increment__c = '10';
            pb4.Cost_Share_Default_Amount__c = '40';
            pb4.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb4.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb4;
            lstPlnt.add(pb4); 
            
            AIA_Plan_Benefits__c pb5 = new AIA_Plan_Benefits__c();
            pb5.Benefit_Name__c = 'Deductible_Family';
            pb5.Record_Type__c = 'BRF';
            pb5.Type__c = 'Cost Share';
            pb5.Benefit_Group__c = pg.id;
            pb5.Cost_Share_Low__c = '0';
            pb5.Cost_Share_High__c = '100';
            pb5.Cost_Share_Increment__c = '10';
            pb5.Cost_Share_Default_Amount__c = '40';
            pb5.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb5.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb5;
           lstPlnt.add(pb5);
            
            AIA_Plan_Benefits__c pb6 = new AIA_Plan_Benefits__c();
            pb6.Benefit_Name__c = 'Deductible_Single';
            pb6.Record_Type__c = 'BRF';
            pb6.Type__c = 'Cost Share';
            pb6.Benefit_Group__c = pg.id;
            pb6.Cost_Share_Low__c = '0';
            pb6.Cost_Share_High__c = '100';
            pb6.Cost_Share_Increment__c = '10';
            pb6.Cost_Share_Default_Amount__c = '40';
            pb6.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb6.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb6;
           lstPlnt.add(pb6);
            
            AIA_Plan_Benefits__c pb7 = new AIA_Plan_Benefits__c();
            pb7.Benefit_Name__c = 'DeductibleCarryOver';
            pb7.Record_Type__c = 'BRF';
            pb7.Type__c = 'Cost Share';
            pb7.Benefit_Group__c = pg.id;
            pb7.Cost_Share_Low__c = '0';
            pb7.Cost_Share_High__c = '100';
            pb7.Cost_Share_Increment__c = '10';
            pb7.Cost_Share_Default_Amount__c = '40';
            pb7.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb7.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb7;
            lstPlnt.add(pb7);
            AIA_Plan_Benefits__c pb8 = new AIA_Plan_Benefits__c();
            pb8.Benefit_Name__c = 'LifetimeMax_Single';
            pb8.Record_Type__c = 'BRF';
            pb8.Type__c = 'Cost Share';
            pb8.Benefit_Group__c = pg.id;
            pb8.Cost_Share_Low__c = '0';
            pb8.Cost_Share_High__c = '100';
            pb8.Cost_Share_Increment__c = '10';
            pb8.Cost_Share_Default_Amount__c = '40';
            pb8.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb8.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb8;
             lstPlnt.add(pb8);
            AIA_Plan_Benefits__c pb9 = new AIA_Plan_Benefits__c();
            pb9.Benefit_Name__c = 'Copay_PCPCopay';
            pb9.Record_Type__c = 'BRF';
            pb9.Type__c = 'Cost Share';
            pb9.Benefit_Group__c = pg.id;
            pb9.Cost_Share_Low__c = '0';
            pb9.Cost_Share_High__c = '100';
            pb9.Cost_Share_Increment__c = '10';
            pb9.Cost_Share_Default_Amount__c = '40';
            pb9.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb9.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb9;
            lstPlnt.add(pb9);
            AIA_Plan_Benefits__c pb10 = new AIA_Plan_Benefits__c();
            pb10.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb10.Record_Type__c = 'BRF';
            pb10.Type__c = 'Cost Share';
            pb10.Benefit_Group__c = pg.id;
            pb10.Cost_Share_Low__c = '0';
            pb10.Cost_Share_High__c = '100';
            pb10.Cost_Share_Increment__c = '10';
            pb10.Cost_Share_Default_Amount__c = '40';
            pb10.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb10.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb10;
            lstPlnt.add(pb10);
            
            AIA_Plan_Benefits__c pb11 = new AIA_Plan_Benefits__c();
            pb11.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb11.Record_Type__c = 'BRF';
            pb11.Type__c = 'Cost Share';
            pb11.Benefit_Group__c = pg.id;
            pb11.Cost_Share_Low__c = '0';
            pb11.Cost_Share_High__c = '100';
            pb11.Cost_Share_Increment__c = '10';
            pb11.Cost_Share_Default_Amount__c = '40';
            pb11.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb11.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb11;
           lstPlnt.add(pb11);
            
            AIA_Plan_Benefits__c pb13 = new AIA_Plan_Benefits__c();
            pb13.Benefit_Name__c = 'OutOfPocket_Individual';
            pb13.Record_Type__c = 'BRF';
            pb13.Type__c = 'Cost Share';
            pb13.Benefit_Group__c = pg2.id;
            pb13.Cost_Share_Low__c = '0';
            pb13.Cost_Share_High__c = '100';
            pb13.Cost_Share_Increment__c = '10';
            pb13.Cost_Share_Default_Amount__c = '40';
            pb13.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb13.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb13;
            lstPlnt.add(pb13);
            AIA_Plan_Benefits__c pb14 = new AIA_Plan_Benefits__c();
            pb14.Benefit_Name__c = 'OutOfPocket_Family';
            pb14.Record_Type__c = 'BRF';
            pb14.Type__c = 'Cost Share';
            pb14.Benefit_Group__c = pg2.id;
            pb14.Cost_Share_Low__c = '0';
            pb14.Cost_Share_High__c = '100';
            pb14.Cost_Share_Increment__c = '10';
            pb14.Cost_Share_Default_Amount__c = '40';
            pb14.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb14.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb14;
            lstPlnt.add(pb14);
            AIA_Plan_Benefits__c pb15 = new AIA_Plan_Benefits__c();
            pb15.Benefit_Name__c = 'OutOfPocket_Single';
            pb15.Record_Type__c = 'BRF';
            pb15.Type__c = 'Cost Share';
            pb15.Benefit_Group__c = pg2.id;
            pb15.Cost_Share_Low__c = '0';
            pb15.Cost_Share_High__c = '100';
            pb15.Cost_Share_Increment__c = '10';
            pb15.Cost_Share_Default_Amount__c = '40';
            pb15.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb15.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb15;
            lstPlnt.add(pb15);
            AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
            pb16.Benefit_Name__c = 'Deductible_Individual';
            pb16.Record_Type__c = 'BRF';
            pb16.Type__c = 'Cost Share';
            pb16.Benefit_Group__c = pg2.id;
            pb16.Cost_Share_Low__c = '0';
            pb16.Cost_Share_High__c = '100';
            pb16.Cost_Share_Increment__c = '10';
            pb16.Cost_Share_Default_Amount__c = '40';
            pb16.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb16.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb16;
            lstPlnt.add(pb16);
            
            insert lstPlnt;
            
            AIA_Plan_Benefits__c pb17 = new AIA_Plan_Benefits__c();
            pb17.Benefit_Name__c = 'Deductible_Family';
            pb17.Record_Type__c = 'BRF';
            pb17.Type__c = 'Cost Share';
            pb17.Benefit_Group__c = pg2.id;
            pb17.Cost_Share_Low__c = '0';
            pb17.Cost_Share_High__c = '100';
            pb17.Cost_Share_Increment__c = '10';
            pb17.Cost_Share_Default_Amount__c = '40';
            pb17.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb17.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb17;
            lstPlnt.add(pb17);
            
           // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb18 = new AIA_Plan_Benefits__c();
            pb18.Benefit_Name__c = 'Deductible_Single';
            pb18.Record_Type__c = 'BRF';
            pb18.Type__c = 'Cost Share';
            pb18.Benefit_Group__c = pg2.id;
            pb18.Cost_Share_Low__c = '0';
            pb18.Cost_Share_High__c = '100';
            pb18.Cost_Share_Increment__c = '10';
            pb18.Cost_Share_Default_Amount__c = '40';
            pb18.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb18.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb18;
           lstPlnt.add(pb18);
           
         //  insert lstPlnt;
            
            AIA_Plan_Benefits__c pb19 = new AIA_Plan_Benefits__c();
            pb19.Benefit_Name__c = 'DeductibleCarryOver';
            pb19.Record_Type__c = 'BRF';
            pb19.Type__c = 'Cost Share';
            pb19.Benefit_Group__c = pg2.id;
            pb19.Cost_Share_Low__c = '0';
            pb19.Cost_Share_High__c = '100';
            pb19.Cost_Share_Increment__c = '10';
            pb19.Cost_Share_Default_Amount__c = '40';
            pb19.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb19.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb19;
           lstPlnt.add(pb19);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb20 = new AIA_Plan_Benefits__c();
            pb20.Benefit_Name__c = 'LifetimeMax_Single';
            pb20.Record_Type__c = 'BRF';
            pb20.Type__c = 'Cost Share';
            pb20.Benefit_Group__c = pg2.id;
            pb20.Cost_Share_Low__c = '0';
            pb20.Cost_Share_High__c = '100';
            pb20.Cost_Share_Increment__c = '10';
            pb20.Cost_Share_Default_Amount__c = '40';
            pb20.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb20.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb20;
            lstPlnt.add(pb20);
            
          //  insert lstPlnt;
            
            
            AIA_Plan_Benefits__c pb21 = new AIA_Plan_Benefits__c();
            pb21.Benefit_Name__c = 'Copay_PCPCopay';
            pb21.Record_Type__c = 'BRF';
            pb21.Type__c = 'Cost Share';
            pb21.Benefit_Group__c = pg2.id;
            pb21.Cost_Share_Low__c = '0';
            pb21.Cost_Share_High__c = '100';
            pb21.Cost_Share_Increment__c = '10';
            pb21.Cost_Share_Default_Amount__c = '40';
            pb21.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb21.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb21;
           lstPlnt.add(pb21);
           
          // insert  lstPlnt;
            
            AIA_Plan_Benefits__c pb22 = new AIA_Plan_Benefits__c();
            pb22.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb22.Record_Type__c = 'BRF';
            pb22.Type__c = 'Cost Share';
            pb22.Benefit_Group__c = pg2.id;
            pb22.Cost_Share_Low__c = '0';
            pb22.Cost_Share_High__c = '100';
            pb22.Cost_Share_Increment__c = '10';
            pb22.Cost_Share_Default_Amount__c = '40';
            pb22.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb22.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb22;
           lstPlnt.add(pb22);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb23 = new AIA_Plan_Benefits__c();
            pb23.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb23.Record_Type__c = 'BRF';
            pb23.Type__c = 'Cost Share';
            pb23.Benefit_Group__c = pg2.id;
            pb23.Cost_Share_Low__c = '0';
            pb23.Cost_Share_High__c = '100';
            pb23.Cost_Share_Increment__c = '10';
            pb23.Cost_Share_Default_Amount__c = '40';
            pb23.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb23.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb23;    
           lstPlnt.add(pb22);
           
         //  insert lstPlnt;
               
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
            
            AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
            apc30.Plan_Benefits__c = pb29.id;
            apc30.AliasName__c = 'General Copay';
            apc30.CopayAmount__c = '200';
            apc30.CoinsuranceAmount__c = '50';
            apc30.MinPayAmount__c = '90';
            apc30.MaxPayAmount__c = '80';
            apc30.IsCovered__c = 'Yes';
            apc30.DeductibleApplies__c = 'No';  
            apc30.MandateIndicator__c = 'Yes';          
            apc30.Jurisdiction__c = 'Test';            
            apc30.MandateName__c='PPACA mandate';
            apc30.ExtID__c = 'rwuifghqierufghaire';
            insert apc30;
        
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
            
          // pbc.IsMandateTrue__c ='Yes';
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
          
           Proposed_Products__c pp = new Proposed_Products__c();           
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.id;
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
           // pp.Jurisdiction__c = 'MD';
            pp.Has_Benefit_Details__c = false;
            insert pp;
            
        AIA_BenefitTriggerHandler.enableAdjustmentsOnInserts();
test.starttest();  
           PageReference pref = Page.AIA_ProposedProd_Summary;
           Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
        //Commenting as part of US1650
         //ext.getPCSdata();
        ext.mainInit();
           ext.createWrapListFromPlan(pp);
        ext.createWrapListFromPlanCostShr(aiapln.id);
       
        ext.saveAndCon();
        ext.addPlan();
        ext.saveandRedirct();
        ext.reviewInit();
       
        ext.back();
     
test.stoptest();            
    }

 public Static TestMethod void TestAIA_Benefit_Creationdisable(){
    
       //Commenting as part of US210 
       /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
          insert wpt;*/
       
          Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        AIA_BenefittriggerHandlerHelper_Test.createAccountTeamMembers(acc.Id);
       
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
       
       
       
       
      Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
     brf.Enrollment_Type__c='Cafeteria';
     brf.Exclusive_Specialty_Provider_Network__c='Yes';
  insert brf;
       AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
          aiapln.Has_Benefit_Summary__c = True;
          aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
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
       List<AIA_Plan_Grouper__c> lstGrp = new List<AIA_Plan_Grouper__c>();
          AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
            pg.Name = 'CostShareRanges';
            pg.Plan_Network__c = pn.id;
            pg.Type__c = 'Cost Share Group';
            pg.Record_Type__c = 'BRF';
            pg.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00';
            pg.IsCovered__c='Yes';
            
            //insert pg;
          lstGrp.add(pg);
            
           AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
            pg2.Name = 'CostShareRanges';
            pg2.Plan_Network__c = pn2.id;
            pg2.Type__c = 'Cost Share Group';
            pg2.Record_Type__c = 'BRF';
            pg2.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002';
            pg2.IsCovered__c='No';

         //   insert pg2;
         lstGrp.add(pg2);
            
            AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
            pg3.Name = 'Medical Supplies/Equipment-0628';
            pg3.Plan_Network__c = pn.id;
            pg3.Type__c = 'Benefit Group';
            pg3.Sequence_Number__c = 1;
            pg3.Record_Type__c = 'BRF';
            pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
            pg3.IsCovered__c='No';

           // insert pg3;
          lstGrp.add(pg3);
            
            AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
            pg4.Name = 'Medical Supplies/Equipment-0629';
            pg4.Plan_Network__c = pn2.id;
            pg4.Type__c = 'Benefit Group';
            pg4.Sequence_Number__c = 1;
            pg4.Record_Type__c = 'BRF';
            pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
            pg4.IsCovered__c='Yes';

            //insert pg4;
           lstGrp.add(pg4);
           
           insert lstGrp;
           
          List<AIA_Plan_Benefits__c> lstPlnt = new List<AIA_Plan_Benefits__c>();
           AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
            pb.Benefit_Name__c = 'OutOfPocket_Individual';
            pb.Record_Type__c = 'BRF';
            pb.Type__c = 'Benefit';
            pb.Benefit_Group__c = pg3.id;
            pb.Cost_Share_Low__c = '0';
            pb.Cost_Share_High__c = '100';
            pb.Cost_Share_Increment__c = '10';
            pb.Cost_Share_Default_Amount__c = '40';
            pb.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb.Cost_Share_InvalidIncrements__c = '20, 30';
            pb.Sequence_Number__c = 1;
            //insert pb;
            lstPlnt.add(pb);
        
        AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
            pb29.Benefit_Name__c = '';
            pb29.Record_Type__c = 'BRF';
            pb29.Type__c = 'Benefit';
            pb29.Benefit_Group__c = pg4.id;
            pb29.Cost_Share_Low__c = '0';
            pb29.Cost_Share_High__c = '100';
            pb29.Cost_Share_Increment__c = '10';
            pb29.Cost_Share_Default_Amount__c = '40';
            pb29.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb29.Cost_Share_InvalidIncrements__c = '20, 30';
            pb29.Sequence_Number__c = 1;
           // insert pb29;
           lstPlnt.add(pb29);
          
          AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
            pb2.Benefit_Name__c = 'OutOfPocket_Family';
            pb2.Record_Type__c = 'BRF';
            pb2.Type__c = 'Cost Share';
            pb2.Benefit_Group__c = pg.id;
            pb2.Cost_Share_Low__c = '0';
            pb2.Cost_Share_High__c = '100';
            pb2.Cost_Share_Increment__c = '10';
            pb2.Cost_Share_Default_Amount__c = '40';
            pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb2.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb2;
          lstPlnt.add(pb2);
        
            AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
            pb3.Benefit_Name__c = 'OutOfPocket_Single';
            pb3.Record_Type__c = 'BRF';
            pb3.Type__c = 'Cost Share';
            pb3.Benefit_Group__c = pg.id;
            pb3.Cost_Share_Low__c = '0';
            pb3.Cost_Share_High__c = '100';
            pb3.Cost_Share_Increment__c = '10';
            pb3.Cost_Share_Default_Amount__c = '40';
            pb3.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb3.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb3;
           lstPlnt.add(pb3); 
            AIA_Plan_Benefits__c pb4 = new AIA_Plan_Benefits__c();
            pb4.Benefit_Name__c = 'Deductible_Individual';
            pb4.Record_Type__c = 'BRF';
            pb4.Type__c = 'Cost Share';
            pb4.Benefit_Group__c = pg.id;
            pb4.Cost_Share_Low__c = '0';
            pb4.Cost_Share_High__c = '100';
            pb4.Cost_Share_Increment__c = '10';
            pb4.Cost_Share_Default_Amount__c = '40';
            pb4.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb4.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb4;
            lstPlnt.add(pb4); 
            
            AIA_Plan_Benefits__c pb5 = new AIA_Plan_Benefits__c();
            pb5.Benefit_Name__c = 'Deductible_Family';
            pb5.Record_Type__c = 'BRF';
            pb5.Type__c = 'Cost Share';
            pb5.Benefit_Group__c = pg.id;
            pb5.Cost_Share_Low__c = '0';
            pb5.Cost_Share_High__c = '100';
            pb5.Cost_Share_Increment__c = '10';
            pb5.Cost_Share_Default_Amount__c = '40';
            pb5.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb5.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb5;
           lstPlnt.add(pb5);
            
            AIA_Plan_Benefits__c pb6 = new AIA_Plan_Benefits__c();
            pb6.Benefit_Name__c = 'Deductible_Single';
            pb6.Record_Type__c = 'BRF';
            pb6.Type__c = 'Cost Share';
            pb6.Benefit_Group__c = pg.id;
            pb6.Cost_Share_Low__c = '0';
            pb6.Cost_Share_High__c = '100';
            pb6.Cost_Share_Increment__c = '10';
            pb6.Cost_Share_Default_Amount__c = '40';
            pb6.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb6.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb6;
           lstPlnt.add(pb6);
            
            AIA_Plan_Benefits__c pb7 = new AIA_Plan_Benefits__c();
            pb7.Benefit_Name__c = 'DeductibleCarryOver';
            pb7.Record_Type__c = 'BRF';
            pb7.Type__c = 'Cost Share';
            pb7.Benefit_Group__c = pg.id;
            pb7.Cost_Share_Low__c = '0';
            pb7.Cost_Share_High__c = '100';
            pb7.Cost_Share_Increment__c = '10';
            pb7.Cost_Share_Default_Amount__c = '40';
            pb7.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb7.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb7;
            lstPlnt.add(pb7);
            AIA_Plan_Benefits__c pb8 = new AIA_Plan_Benefits__c();
            pb8.Benefit_Name__c = 'LifetimeMax_Single';
            pb8.Record_Type__c = 'BRF';
            pb8.Type__c = 'Cost Share';
            pb8.Benefit_Group__c = pg.id;
            pb8.Cost_Share_Low__c = '0';
            pb8.Cost_Share_High__c = '100';
            pb8.Cost_Share_Increment__c = '10';
            pb8.Cost_Share_Default_Amount__c = '40';
            pb8.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb8.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb8;
             lstPlnt.add(pb8);
            AIA_Plan_Benefits__c pb9 = new AIA_Plan_Benefits__c();
            pb9.Benefit_Name__c = 'Copay_PCPCopay';
            pb9.Record_Type__c = 'BRF';
            pb9.Type__c = 'Cost Share';
            pb9.Benefit_Group__c = pg.id;
            pb9.Cost_Share_Low__c = '0';
            pb9.Cost_Share_High__c = '100';
            pb9.Cost_Share_Increment__c = '10';
            pb9.Cost_Share_Default_Amount__c = '40';
            pb9.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb9.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb9;
            lstPlnt.add(pb9);
            AIA_Plan_Benefits__c pb10 = new AIA_Plan_Benefits__c();
            pb10.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb10.Record_Type__c = 'BRF';
            pb10.Type__c = 'Cost Share';
            pb10.Benefit_Group__c = pg.id;
            pb10.Cost_Share_Low__c = '0';
            pb10.Cost_Share_High__c = '100';
            pb10.Cost_Share_Increment__c = '10';
            pb10.Cost_Share_Default_Amount__c = '40';
            pb10.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb10.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb10;
            lstPlnt.add(pb10);
            
            AIA_Plan_Benefits__c pb11 = new AIA_Plan_Benefits__c();
            pb11.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb11.Record_Type__c = 'BRF';
            pb11.Type__c = 'Cost Share';
            pb11.Benefit_Group__c = pg.id;
            pb11.Cost_Share_Low__c = '0';
            pb11.Cost_Share_High__c = '100';
            pb11.Cost_Share_Increment__c = '10';
            pb11.Cost_Share_Default_Amount__c = '40';
            pb11.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb11.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb11;
           lstPlnt.add(pb11);
            
            AIA_Plan_Benefits__c pb13 = new AIA_Plan_Benefits__c();
            pb13.Benefit_Name__c = 'OutOfPocket_Individual';
            pb13.Record_Type__c = 'BRF';
            pb13.Type__c = 'Cost Share';
            pb13.Benefit_Group__c = pg2.id;
            pb13.Cost_Share_Low__c = '0';
            pb13.Cost_Share_High__c = '100';
            pb13.Cost_Share_Increment__c = '10';
            pb13.Cost_Share_Default_Amount__c = '40';
            pb13.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb13.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb13;
            lstPlnt.add(pb13);
            AIA_Plan_Benefits__c pb14 = new AIA_Plan_Benefits__c();
            pb14.Benefit_Name__c = 'OutOfPocket_Family';
            pb14.Record_Type__c = 'BRF';
            pb14.Type__c = 'Cost Share';
            pb14.Benefit_Group__c = pg2.id;
            pb14.Cost_Share_Low__c = '0';
            pb14.Cost_Share_High__c = '100';
            pb14.Cost_Share_Increment__c = '10';
            pb14.Cost_Share_Default_Amount__c = '40';
            pb14.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb14.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb14;
            lstPlnt.add(pb14);
            AIA_Plan_Benefits__c pb15 = new AIA_Plan_Benefits__c();
            pb15.Benefit_Name__c = 'OutOfPocket_Single';
            pb15.Record_Type__c = 'BRF';
            pb15.Type__c = 'Cost Share';
            pb15.Benefit_Group__c = pg2.id;
            pb15.Cost_Share_Low__c = '0';
            pb15.Cost_Share_High__c = '100';
            pb15.Cost_Share_Increment__c = '10';
            pb15.Cost_Share_Default_Amount__c = '40';
            pb15.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb15.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb15;
            lstPlnt.add(pb15);
            AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
            pb16.Benefit_Name__c = 'Deductible_Individual';
            pb16.Record_Type__c = 'BRF';
            pb16.Type__c = 'Cost Share';
            pb16.Benefit_Group__c = pg2.id;
            pb16.Cost_Share_Low__c = '0';
            pb16.Cost_Share_High__c = '100';
            pb16.Cost_Share_Increment__c = '10';
            pb16.Cost_Share_Default_Amount__c = '40';
            pb16.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb16.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb16;
            lstPlnt.add(pb16);
            
            insert lstPlnt;
            
            AIA_Plan_Benefits__c pb17 = new AIA_Plan_Benefits__c();
            pb17.Benefit_Name__c = 'Deductible_Family';
            pb17.Record_Type__c = 'BRF';
            pb17.Type__c = 'Cost Share';
            pb17.Benefit_Group__c = pg2.id;
            pb17.Cost_Share_Low__c = '0';
            pb17.Cost_Share_High__c = '100';
            pb17.Cost_Share_Increment__c = '10';
            pb17.Cost_Share_Default_Amount__c = '40';
            pb17.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb17.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb17;
            lstPlnt.add(pb17);
            
           // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb18 = new AIA_Plan_Benefits__c();
            pb18.Benefit_Name__c = 'Deductible_Single';
            pb18.Record_Type__c = 'BRF';
            pb18.Type__c = 'Cost Share';
            pb18.Benefit_Group__c = pg2.id;
            pb18.Cost_Share_Low__c = '0';
            pb18.Cost_Share_High__c = '100';
            pb18.Cost_Share_Increment__c = '10';
            pb18.Cost_Share_Default_Amount__c = '40';
            pb18.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb18.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb18;
           lstPlnt.add(pb18);
           
         //  insert lstPlnt;
            
            AIA_Plan_Benefits__c pb19 = new AIA_Plan_Benefits__c();
            pb19.Benefit_Name__c = 'DeductibleCarryOver';
            pb19.Record_Type__c = 'BRF';
            pb19.Type__c = 'Cost Share';
            pb19.Benefit_Group__c = pg2.id;
            pb19.Cost_Share_Low__c = '0';
            pb19.Cost_Share_High__c = '100';
            pb19.Cost_Share_Increment__c = '10';
            pb19.Cost_Share_Default_Amount__c = '40';
            pb19.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb19.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb19;
           lstPlnt.add(pb19);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb20 = new AIA_Plan_Benefits__c();
            pb20.Benefit_Name__c = 'LifetimeMax_Single';
            pb20.Record_Type__c = 'BRF';
            pb20.Type__c = 'Cost Share';
            pb20.Benefit_Group__c = pg2.id;
            pb20.Cost_Share_Low__c = '0';
            pb20.Cost_Share_High__c = '100';
            pb20.Cost_Share_Increment__c = '10';
            pb20.Cost_Share_Default_Amount__c = '40';
            pb20.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb20.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb20;
            lstPlnt.add(pb20);
            
          //  insert lstPlnt;
            
            
            AIA_Plan_Benefits__c pb21 = new AIA_Plan_Benefits__c();
            pb21.Benefit_Name__c = 'Copay_PCPCopay';
            pb21.Record_Type__c = 'BRF';
            pb21.Type__c = 'Cost Share';
            pb21.Benefit_Group__c = pg2.id;
            pb21.Cost_Share_Low__c = '0';
            pb21.Cost_Share_High__c = '100';
            pb21.Cost_Share_Increment__c = '10';
            pb21.Cost_Share_Default_Amount__c = '40';
            pb21.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb21.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb21;
           lstPlnt.add(pb21);
           
          // insert  lstPlnt;
            
            AIA_Plan_Benefits__c pb22 = new AIA_Plan_Benefits__c();
            pb22.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb22.Record_Type__c = 'BRF';
            pb22.Type__c = 'Cost Share';
            pb22.Benefit_Group__c = pg2.id;
            pb22.Cost_Share_Low__c = '0';
            pb22.Cost_Share_High__c = '100';
            pb22.Cost_Share_Increment__c = '10';
            pb22.Cost_Share_Default_Amount__c = '40';
            pb22.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb22.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb22;
           lstPlnt.add(pb22);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb23 = new AIA_Plan_Benefits__c();
            pb23.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb23.Record_Type__c = 'BRF';
            pb23.Type__c = 'Cost Share';
            pb23.Benefit_Group__c = pg2.id;
            pb23.Cost_Share_Low__c = '0';
            pb23.Cost_Share_High__c = '100';
            pb23.Cost_Share_Increment__c = '10';
            pb23.Cost_Share_Default_Amount__c = '40';
            pb23.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb23.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb23;    
           lstPlnt.add(pb22);
           
         //  insert lstPlnt;
               
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
            
            AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
            apc30.Plan_Benefits__c = pb29.id;
            apc30.AliasName__c = 'General Copay';
            apc30.CopayAmount__c = '200';
            apc30.CoinsuranceAmount__c = '50';
            apc30.MinPayAmount__c = '90';
            apc30.MaxPayAmount__c = '80';
            apc30.IsCovered__c = 'Yes';
            apc30.DeductibleApplies__c = 'No';  
            apc30.MandateIndicator__c = 'Yes';          
            apc30.Jurisdiction__c = 'Test';            
            apc30.MandateName__c='PPACA mandate';
            apc30.ExtID__c = 'rwuifghqierufghaire';
            insert apc30;
        
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
            
          // pbc.IsMandateTrue__c ='Yes';
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
          //mod 
          
     
     //mod
            
            //system.debug('ppd id medical'+pp1);
     Proposed_Products__c pp1 = new Proposed_Products__c();           
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp1.Benefit_Request_Form__c =brf.id;
            pp1.Funding_Arrangement__c = 'ASO';
            pp1.Product_Category__c = 'Drug';
            pp1.Product_Line__c = 'pp1O';
           pp1.Plan_Name__c = aiapln.id;
            pp1.Product_Name__c = 'BlueChoice Advantage';
            pp1.CDH__c = 'Yes';
            pp1.CDH_Fund_Type__c = 'BlueFund';
            pp1.CDH_Type__c = 'HSA';
            pp1.Deductible__c = 'Stacked';
            pp1.Grandfathered_Status__c = 'Grandfathered';
            pp1.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp1.Blue_Rewards__c = 'No';
            pp1.Out_of_Pocket_Max__c = 'Stacked';
           // pp1.Jurisdiction__c = 'MD';
            pp1.Has_Benefit_Details__c = false;
            pp1.Exclusive_Specialty_Provider_Network__c='Yes';
            pp1.RX_OOP_Max_Integration__c='Integrated';
            insert pp1;
           Proposed_Products__c pp = new Proposed_Products__c();           
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.id;
            pp.Funding_Arrangement__c = 'ASO';
            pp.Product_Category__c = 'Drug';
            pp.Product_Line__c = 'PPO';
           pp.Plan_Name__c = aiapln.id;
            pp.Product_Name__c = 'BlueChoice Advantage';
            pp.CDH__c = 'Yes';
            pp.CDH_Fund_Type__c = 'BlueFund';
            pp.Related_Medical_Product__c=pp1.id;
            pp.Exclusive_Specialty_Provider_Network__c='Yes';
            pp.CDH_Type__c = 'HSA';
            pp.Deductible__c = 'Stacked';
            pp.Grandfathered_Status__c = 'Grandfathered';
            pp.Integrated_Non_Integrated__c = 'Integrated';
            pp.Grandfathered_PPACA_Status__c = 'No';
            pp.Blue_Rewards__c = 'No';
            pp.Out_of_Pocket_Max__c = 'Stacked';
     pp.RX_OOP_Max_Integration__c='Integrated';
           // pp.Jurisdiction__c = 'MD';
            pp.Has_Benefit_Details__c = false;
            insert pp;
                 system.debug('ppd id drug pp'+pp);
 
     Proposed_Products__c pp2 = new Proposed_Products__c();           
            pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp2.Benefit_Request_Form__c =brf.id;
            pp2.Funding_Arrangement__c = 'ASO';
            pp2.Product_Category__c = 'Drug';
            pp2.Product_Line__c = 'pp2O';
           pp2.Plan_Name__c = aiapln.id;
            pp2.Product_Name__c = 'BlueChoice Advantage';
            pp2.CDH__c = 'Yes';
            pp2.CDH_Fund_Type__c = 'BlueFund';
          pp2.Related_Medical_Product__c=pp.id;
            pp2.CDH_Type__c = 'HSA';
            pp2.Deductible__c = 'Stacked';
            pp2.Grandfathered_Status__c = 'Grandfathered';
            pp2.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp2.Grandfathered_ppACA_Status__c = 'No';
            pp2.Blue_Rewards__c = 'No';
            pp2.Out_of_Pocket_Max__c = 'Stacked';
           // pp2.Jurisdiction__c = 'MD';
            pp2.Has_Benefit_Details__c = false;
            pp2.Exclusive_Specialty_Provider_Network__c='Yes';
          pp2.RX_OOP_Max_Integration__c='Integrated';

            insert pp2;
     
                 system.debug('ppd id medical1'+pp2);

     
     //mod offshore

     AIA_Grouper__c ag = new AIA_Grouper__c();
      ag.Name = 'CostShareRanges';
      ag.Group_Type__c = 'Cost Share Group';
      ag.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag.Proposed_Products__c = pp.id;
  insert ag;
     AIA_Grouper__c ag1 = new AIA_Grouper__c();
      ag1.Name = 'CostShareRanges';
      ag1.Group_Type__c = 'Cost Share Group';
      ag1.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag1.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag1.Proposed_Products__c = pp2.id;
  insert ag1;
  AIA_Benefits__c ab = new AIA_Benefits__c();
      ab.Grouper__c = ag.id;
     ab.IS_ASO_Only__c=false;
      ab.Benefit_Name__c = 'Family Out Of Pocket';
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
     ab.Cost_Share_SelectedAmount__c='300';
      ab.IN_CostShare_3Month_DedCarryover_Default__c='Yes';
          ab.IN_CostShare_3Month_DeductibleCarryover__c='No';
     
      insert ab; 
     
     AIA_Benefits__c ab1 = new AIA_Benefits__c();
      ab1.Grouper__c = ag1.id;
     ab1.IS_ASO_Only__c=false;
      ab1.Benefit_Name__c = 'Family Out Of Pocket';
      ab1.Benefit_Type__c = 'Benefit';
      ab1.Copay_Type_1_Mandate_Name__c = 'Test';
      ab1.Type__c = 'Cost Share';
      ab1.Benefit_Record_Type__c = 'BRF';
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
      ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
      ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
      ab1.Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.Copay_Type_2_AliasName__c = 'Test';
      ab1.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.OON_Copay_Type_2_AliasName__c = 'Test';
      ab1.IsAppGlobalCopay__c = true;
     ab1.Cost_Share_SelectedAmount__c='101';
     insert ab1;
     
     Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Maxrow');
  insert lmt;
     
     
        AIA_BenefitTriggerHandler.disableAdjustmentsOnInserts();
        AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();

test.starttest();  
           PageReference pref = Page.AIA_ProposedProd_Summary;
           Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
            //Commenting as part of US1650
         //ext.getPCSdata();
        ext.mainInit();
           ext.createWrapListFromPlan(pp);
        ext.createWrapListFromPlanCostShr(aiapln.id);
               AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();
    AIA_BenefitTriggerHelperClass.validateCopayValues('2','3','4','5','6','7');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','7','4','5','6','3');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','4','5','6','3');
          AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','3','5','6','3');
          AIA_BenefitTriggerHelperClass.validateCopayValues('','','5','6','7','8');


        ext.saveAndCon();
        ext.addPlan();
        ext.saveandRedirct();
        ext.reviewInit();
       
        ext.back();
     
test.stoptest();            
    }
      public Static TestMethod void TestAIA_Benefit_CreationdisableOutOfRangeValues(){
    
       //Commenting as part of US210 
       /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
          insert wpt;*/
       
          Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            AIA_BenefittriggerHandlerHelper_Test.createAccountTeamMembers(acc.Id);
       
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
       
       
       
       
      Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
     brf.Enrollment_Type__c='Cafeteria';
     brf.Exclusive_Specialty_Provider_Network__c='Yes';
  insert brf;
       AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
          aiapln.Has_Benefit_Summary__c = True;
          aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
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
       List<AIA_Plan_Grouper__c> lstGrp = new List<AIA_Plan_Grouper__c>();
          AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
            pg.Name = 'CostShareRanges';
            pg.Plan_Network__c = pn.id;
            pg.Type__c = 'Cost Share Group';
            pg.Record_Type__c = 'BRF';
            pg.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00';
            pg.IsCovered__c='Yes';
            
            //insert pg;
          lstGrp.add(pg);
            
           AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
            pg2.Name = 'CostShareRanges';
            pg2.Plan_Network__c = pn2.id;
            pg2.Type__c = 'Cost Share Group';
            pg2.Record_Type__c = 'BRF';
            pg2.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002';
            pg2.IsCovered__c='No';

         //   insert pg2;
         lstGrp.add(pg2);
            
            AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
            pg3.Name = 'Medical Supplies/Equipment-0628';
            pg3.Plan_Network__c = pn.id;
            pg3.Type__c = 'Benefit Group';
            pg3.Sequence_Number__c = 1;
            pg3.Record_Type__c = 'BRF';
            pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
            pg3.IsCovered__c='No';

           // insert pg3;
          lstGrp.add(pg3);
            
            AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
            pg4.Name = 'Medical Supplies/Equipment-0629';
            pg4.Plan_Network__c = pn2.id;
            pg4.Type__c = 'Benefit Group';
            pg4.Sequence_Number__c = 1;
            pg4.Record_Type__c = 'BRF';
            pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
            pg4.IsCovered__c='Yes';

            //insert pg4;
           lstGrp.add(pg4);
           
           insert lstGrp;
           
          List<AIA_Plan_Benefits__c> lstPlnt = new List<AIA_Plan_Benefits__c>();
           AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
            pb.Benefit_Name__c = 'OutOfPocket_Individual';
            pb.Record_Type__c = 'BRF';
            pb.Type__c = 'Benefit';
            pb.Benefit_Group__c = pg3.id;
            pb.Cost_Share_Low__c = '0';
            pb.Cost_Share_High__c = '100';
            pb.Cost_Share_Increment__c = '10';
            pb.Cost_Share_Default_Amount__c = '40';
            pb.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb.Cost_Share_InvalidIncrements__c = '20, 30';
            pb.Sequence_Number__c = 1;
            //insert pb;
            lstPlnt.add(pb);
        
        AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
            pb29.Benefit_Name__c = '';
            pb29.Record_Type__c = 'BRF';
            pb29.Type__c = 'Benefit';
            pb29.Benefit_Group__c = pg4.id;
            pb29.Cost_Share_Low__c = '0';
            pb29.Cost_Share_High__c = '100';
            pb29.Cost_Share_Increment__c = '10';
            pb29.Cost_Share_Default_Amount__c = '40';
            pb29.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb29.Cost_Share_InvalidIncrements__c = '20, 30';
            pb29.Sequence_Number__c = 1;
           // insert pb29;
           lstPlnt.add(pb29);
          
          AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
            pb2.Benefit_Name__c = 'OutOfPocket_Family';
            pb2.Record_Type__c = 'BRF';
            pb2.Type__c = 'Cost Share';
            pb2.Benefit_Group__c = pg.id;
            pb2.Cost_Share_Low__c = '0';
            pb2.Cost_Share_High__c = '100';
            pb2.Cost_Share_Increment__c = '10';
            pb2.Cost_Share_Default_Amount__c = '40';
            pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb2.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb2;
          lstPlnt.add(pb2);
        
            AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
            pb3.Benefit_Name__c = 'OutOfPocket_Single';
            pb3.Record_Type__c = 'BRF';
            pb3.Type__c = 'Cost Share';
            pb3.Benefit_Group__c = pg.id;
            pb3.Cost_Share_Low__c = '0';
            pb3.Cost_Share_High__c = '100';
            pb3.Cost_Share_Increment__c = '10';
            pb3.Cost_Share_Default_Amount__c = '40';
            pb3.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb3.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb3;
           lstPlnt.add(pb3); 
            AIA_Plan_Benefits__c pb4 = new AIA_Plan_Benefits__c();
            pb4.Benefit_Name__c = 'Deductible_Individual';
            pb4.Record_Type__c = 'BRF';
            pb4.Type__c = 'Cost Share';
            pb4.Benefit_Group__c = pg.id;
            pb4.Cost_Share_Low__c = '0';
            pb4.Cost_Share_High__c = '100';
            pb4.Cost_Share_Increment__c = '10';
            pb4.Cost_Share_Default_Amount__c = '40';
            pb4.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb4.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb4;
            lstPlnt.add(pb4); 
            
            AIA_Plan_Benefits__c pb5 = new AIA_Plan_Benefits__c();
            pb5.Benefit_Name__c = 'Deductible_Family';
            pb5.Record_Type__c = 'BRF';
            pb5.Type__c = 'Cost Share';
            pb5.Benefit_Group__c = pg.id;
            pb5.Cost_Share_Low__c = '0';
            pb5.Cost_Share_High__c = '100';
            pb5.Cost_Share_Increment__c = '10';
            pb5.Cost_Share_Default_Amount__c = '40';
            pb5.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb5.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb5;
           lstPlnt.add(pb5);
            
            AIA_Plan_Benefits__c pb6 = new AIA_Plan_Benefits__c();
            pb6.Benefit_Name__c = 'Deductible_Single';
            pb6.Record_Type__c = 'BRF';
            pb6.Type__c = 'Cost Share';
            pb6.Benefit_Group__c = pg.id;
            pb6.Cost_Share_Low__c = '0';
            pb6.Cost_Share_High__c = '100';
            pb6.Cost_Share_Increment__c = '10';
            pb6.Cost_Share_Default_Amount__c = '40';
            pb6.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb6.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb6;
           lstPlnt.add(pb6);
            
            AIA_Plan_Benefits__c pb7 = new AIA_Plan_Benefits__c();
            pb7.Benefit_Name__c = 'DeductibleCarryOver';
            pb7.Record_Type__c = 'BRF';
            pb7.Type__c = 'Cost Share';
            pb7.Benefit_Group__c = pg.id;
            pb7.Cost_Share_Low__c = '0';
            pb7.Cost_Share_High__c = '100';
            pb7.Cost_Share_Increment__c = '10';
            pb7.Cost_Share_Default_Amount__c = '40';
            pb7.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb7.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb7;
            lstPlnt.add(pb7);
            AIA_Plan_Benefits__c pb8 = new AIA_Plan_Benefits__c();
            pb8.Benefit_Name__c = 'LifetimeMax_Single';
            pb8.Record_Type__c = 'BRF';
            pb8.Type__c = 'Cost Share';
            pb8.Benefit_Group__c = pg.id;
            pb8.Cost_Share_Low__c = '0';
            pb8.Cost_Share_High__c = '100';
            pb8.Cost_Share_Increment__c = '10';
            pb8.Cost_Share_Default_Amount__c = '40';
            pb8.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb8.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb8;
             lstPlnt.add(pb8);
            AIA_Plan_Benefits__c pb9 = new AIA_Plan_Benefits__c();
            pb9.Benefit_Name__c = 'Copay_PCPCopay';
            pb9.Record_Type__c = 'BRF';
            pb9.Type__c = 'Cost Share';
            pb9.Benefit_Group__c = pg.id;
            pb9.Cost_Share_Low__c = '0';
            pb9.Cost_Share_High__c = '100';
            pb9.Cost_Share_Increment__c = '10';
            pb9.Cost_Share_Default_Amount__c = '40';
            pb9.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb9.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb9;
            lstPlnt.add(pb9);
            AIA_Plan_Benefits__c pb10 = new AIA_Plan_Benefits__c();
            pb10.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb10.Record_Type__c = 'BRF';
            pb10.Type__c = 'Cost Share';
            pb10.Benefit_Group__c = pg.id;
            pb10.Cost_Share_Low__c = '0';
            pb10.Cost_Share_High__c = '100';
            pb10.Cost_Share_Increment__c = '10';
            pb10.Cost_Share_Default_Amount__c = '40';
            pb10.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb10.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb10;
            lstPlnt.add(pb10);
            
            AIA_Plan_Benefits__c pb11 = new AIA_Plan_Benefits__c();
            pb11.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb11.Record_Type__c = 'BRF';
            pb11.Type__c = 'Cost Share';
            pb11.Benefit_Group__c = pg.id;
            pb11.Cost_Share_Low__c = '0';
            pb11.Cost_Share_High__c = '100';
            pb11.Cost_Share_Increment__c = '10';
            pb11.Cost_Share_Default_Amount__c = '40';
            pb11.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb11.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb11;
           lstPlnt.add(pb11);
            
            AIA_Plan_Benefits__c pb13 = new AIA_Plan_Benefits__c();
            pb13.Benefit_Name__c = 'OutOfPocket_Individual';
            pb13.Record_Type__c = 'BRF';
            pb13.Type__c = 'Cost Share';
            pb13.Benefit_Group__c = pg2.id;
            pb13.Cost_Share_Low__c = '0';
            pb13.Cost_Share_High__c = '100';
            pb13.Cost_Share_Increment__c = '10';
            pb13.Cost_Share_Default_Amount__c = '40';
            pb13.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb13.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb13;
            lstPlnt.add(pb13);
            AIA_Plan_Benefits__c pb14 = new AIA_Plan_Benefits__c();
            pb14.Benefit_Name__c = 'OutOfPocket_Family';
            pb14.Record_Type__c = 'BRF';
            pb14.Type__c = 'Cost Share';
            pb14.Benefit_Group__c = pg2.id;
            pb14.Cost_Share_Low__c = '0';
            pb14.Cost_Share_High__c = '100';
            pb14.Cost_Share_Increment__c = '10';
            pb14.Cost_Share_Default_Amount__c = '40';
            pb14.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb14.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb14;
            lstPlnt.add(pb14);
            AIA_Plan_Benefits__c pb15 = new AIA_Plan_Benefits__c();
            pb15.Benefit_Name__c = 'OutOfPocket_Single';
            pb15.Record_Type__c = 'BRF';
            pb15.Type__c = 'Cost Share';
            pb15.Benefit_Group__c = pg2.id;
            pb15.Cost_Share_Low__c = '0';
            pb15.Cost_Share_High__c = '100';
            pb15.Cost_Share_Increment__c = '10';
            pb15.Cost_Share_Default_Amount__c = '40';
            pb15.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb15.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb15;
            lstPlnt.add(pb15);
            AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
            pb16.Benefit_Name__c = 'Deductible_Individual';
            pb16.Record_Type__c = 'BRF';
            pb16.Type__c = 'Cost Share';
            pb16.Benefit_Group__c = pg2.id;
            pb16.Cost_Share_Low__c = '0';
            pb16.Cost_Share_High__c = '100';
            pb16.Cost_Share_Increment__c = '10';
            pb16.Cost_Share_Default_Amount__c = '40';
            pb16.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb16.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb16;
            lstPlnt.add(pb16);
            
            insert lstPlnt;
            
            AIA_Plan_Benefits__c pb17 = new AIA_Plan_Benefits__c();
            pb17.Benefit_Name__c = 'Deductible_Family';
            pb17.Record_Type__c = 'BRF';
            pb17.Type__c = 'Cost Share';
            pb17.Benefit_Group__c = pg2.id;
            pb17.Cost_Share_Low__c = '0';
            pb17.Cost_Share_High__c = '100';
            pb17.Cost_Share_Increment__c = '10';
            pb17.Cost_Share_Default_Amount__c = '40';
            pb17.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb17.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb17;
            lstPlnt.add(pb17);
            
           // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb18 = new AIA_Plan_Benefits__c();
            pb18.Benefit_Name__c = 'Deductible_Single';
            pb18.Record_Type__c = 'BRF';
            pb18.Type__c = 'Cost Share';
            pb18.Benefit_Group__c = pg2.id;
            pb18.Cost_Share_Low__c = '0';
            pb18.Cost_Share_High__c = '100';
            pb18.Cost_Share_Increment__c = '10';
            pb18.Cost_Share_Default_Amount__c = '40';
            pb18.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb18.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb18;
           lstPlnt.add(pb18);
           
         //  insert lstPlnt;
            
            AIA_Plan_Benefits__c pb19 = new AIA_Plan_Benefits__c();
            pb19.Benefit_Name__c = 'DeductibleCarryOver';
            pb19.Record_Type__c = 'BRF';
            pb19.Type__c = 'Cost Share';
            pb19.Benefit_Group__c = pg2.id;
            pb19.Cost_Share_Low__c = '0';
            pb19.Cost_Share_High__c = '100';
            pb19.Cost_Share_Increment__c = '10';
            pb19.Cost_Share_Default_Amount__c = '40';
            pb19.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb19.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb19;
           lstPlnt.add(pb19);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb20 = new AIA_Plan_Benefits__c();
            pb20.Benefit_Name__c = 'LifetimeMax_Single';
            pb20.Record_Type__c = 'BRF';
            pb20.Type__c = 'Cost Share';
            pb20.Benefit_Group__c = pg2.id;
            pb20.Cost_Share_Low__c = '0';
            pb20.Cost_Share_High__c = '100';
            pb20.Cost_Share_Increment__c = '10';
            pb20.Cost_Share_Default_Amount__c = '40';
            pb20.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb20.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb20;
            lstPlnt.add(pb20);
            
          //  insert lstPlnt;
            
            
            AIA_Plan_Benefits__c pb21 = new AIA_Plan_Benefits__c();
            pb21.Benefit_Name__c = 'Copay_PCPCopay';
            pb21.Record_Type__c = 'BRF';
            pb21.Type__c = 'Cost Share';
            pb21.Benefit_Group__c = pg2.id;
            pb21.Cost_Share_Low__c = '0';
            pb21.Cost_Share_High__c = '100';
            pb21.Cost_Share_Increment__c = '10';
            pb21.Cost_Share_Default_Amount__c = '40';
            pb21.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb21.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb21;
           lstPlnt.add(pb21);
           
          // insert  lstPlnt;
            
            AIA_Plan_Benefits__c pb22 = new AIA_Plan_Benefits__c();
            pb22.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb22.Record_Type__c = 'BRF';
            pb22.Type__c = 'Cost Share';
            pb22.Benefit_Group__c = pg2.id;
            pb22.Cost_Share_Low__c = '0';
            pb22.Cost_Share_High__c = '100';
            pb22.Cost_Share_Increment__c = '10';
            pb22.Cost_Share_Default_Amount__c = '40';
            pb22.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb22.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb22;
           lstPlnt.add(pb22);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb23 = new AIA_Plan_Benefits__c();
            pb23.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb23.Record_Type__c = 'BRF';
            pb23.Type__c = 'Cost Share';
            pb23.Benefit_Group__c = pg2.id;
            pb23.Cost_Share_Low__c = '0';
            pb23.Cost_Share_High__c = '100';
            pb23.Cost_Share_Increment__c = '10';
            pb23.Cost_Share_Default_Amount__c = '40';
            pb23.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb23.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb23;    
           lstPlnt.add(pb22);
           
         //  insert lstPlnt;
               
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
            
            AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
            apc30.Plan_Benefits__c = pb29.id;
            apc30.AliasName__c = 'General Copay';
            apc30.CopayAmount__c = '200';
            apc30.CoinsuranceAmount__c = '50';
            apc30.MinPayAmount__c = '90';
            apc30.MaxPayAmount__c = '80';
            apc30.IsCovered__c = 'Yes';
            apc30.DeductibleApplies__c = 'No';  
            apc30.MandateIndicator__c = 'Yes';          
            apc30.Jurisdiction__c = 'Test';            
            apc30.MandateName__c='PPACA mandate';
            apc30.ExtID__c = 'rwuifghqierufghaire';
            insert apc30;
        
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
            
          // pbc.IsMandateTrue__c ='Yes';
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
          //mod 
          
     
     //mod
            
            //system.debug('ppd id medical'+pp1);
     Proposed_Products__c pp1 = new Proposed_Products__c();           
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp1.Benefit_Request_Form__c =brf.id;
            pp1.Funding_Arrangement__c = 'ASO';
            pp1.Product_Category__c = 'Medical';
            pp1.Product_Line__c = 'pp1O';
           pp1.Plan_Name__c = aiapln.id;
            pp1.Product_Name__c = 'BlueChoice Advantage';
            pp1.CDH__c = 'Yes';
            pp1.CDH_Fund_Type__c = 'BlueFund';
            pp1.CDH_Type__c = 'HSA';
            pp1.Deductible__c = 'Stacked';
            pp1.Grandfathered_Status__c = 'Grandfathered';
            pp1.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp1.Blue_Rewards__c = 'No';
            pp1.Out_of_Pocket_Max__c = 'Stacked';
           // pp1.Jurisdiction__c = 'MD';
            pp1.Has_Benefit_Details__c = false;
            pp1.Exclusive_Specialty_Provider_Network__c='Yes';
            pp1.RX_OOP_Max_Integration__c='Integrated';
            insert pp1;
           Proposed_Products__c pp = new Proposed_Products__c();           
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.id;
            pp.Funding_Arrangement__c = 'ASO';
            pp.Product_Category__c = 'Drug';
            pp.Product_Line__c = 'PPO';
           pp.Plan_Name__c = aiapln.id;
            pp.Product_Name__c = 'BlueChoice Advantage';
            pp.CDH__c = 'Yes';
            pp.CDH_Fund_Type__c = 'BlueFund';
            pp.Related_Medical_Product__c=pp1.id;
            pp.Exclusive_Specialty_Provider_Network__c='Yes';
            pp.CDH_Type__c = 'HSA';
            pp.Deductible__c = 'Stacked';
            pp.Grandfathered_Status__c = 'Grandfathered';
            pp.Integrated_Non_Integrated__c = 'Integrated';
            pp.Grandfathered_PPACA_Status__c = 'No';
            pp.Blue_Rewards__c = 'No';
            pp.Out_of_Pocket_Max__c = 'Stacked';
     pp.RX_OOP_Max_Integration__c='Integrated';
           // pp.Jurisdiction__c = 'MD';
            pp.Has_Benefit_Details__c = false;
            insert pp;
                 system.debug('ppd id drug pp'+pp);
 
     Proposed_Products__c pp2 = new Proposed_Products__c();           
            pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp2.Benefit_Request_Form__c =brf.id;
            pp2.Funding_Arrangement__c = 'ASO';
            pp2.Product_Category__c = 'Drug';
            pp2.Product_Line__c = 'pp2O';
           pp2.Plan_Name__c = aiapln.id;
            pp2.Product_Name__c = 'BlueChoice Advantage';
            pp2.CDH__c = 'Yes';
            pp2.CDH_Fund_Type__c = 'BlueFund';
          pp2.Related_Medical_Product__c=pp.id;
            pp2.CDH_Type__c = 'HSA';
            pp2.Deductible__c = 'Stacked';
            pp2.Grandfathered_Status__c = 'Grandfathered';
            pp2.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp2.Grandfathered_ppACA_Status__c = 'No';
            pp2.Blue_Rewards__c = 'No';
            pp2.Out_of_Pocket_Max__c = 'Stacked';
           // pp2.Jurisdiction__c = 'MD';
            pp2.Has_Benefit_Details__c = false;
            pp2.Exclusive_Specialty_Provider_Network__c='Yes';
          pp2.RX_OOP_Max_Integration__c='Integrated';

            insert pp2;
     
                 system.debug('ppd id medical1'+pp2);

     
     //mod offshore

     AIA_Grouper__c ag = new AIA_Grouper__c();
      ag.Name = 'CostShareRanges';
      ag.Group_Type__c = 'Cost Share Group';
      ag.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag.Proposed_Products__c = pp.id;
  insert ag;
     AIA_Grouper__c ag1 = new AIA_Grouper__c();
      ag1.Name = 'CostShareRanges';
      ag1.Group_Type__c = 'Cost Share Group';
      ag1.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag1.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag1.Proposed_Products__c = pp2.id;
  insert ag1;
  AIA_Benefits__c ab = new AIA_Benefits__c();
      ab.Grouper__c = ag.id;
     ab.IS_ASO_Only__c=false;
      ab.Benefit_Name__c = 'Family Out Of Pocket';
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
      ab.Copay_Type_1_High__c='100';
      ab.Copay_Type_1_Low__c='200';
      ab.Copay_Type_1_Increment__c='300';
      ab.Copay_Type_1_Additional_Increments__c='400';
      ab.Copay_Type_1_AdditionalInvalidIncrements__c='500';
      ab.Copay_Type_1_AmountValueSelected__c='600';
      ab.Copay_Type_2_High__c='100';
      ab.Copay_Type_2_Low__c='200';
      ab.Copay_Type_2_Increment__c='300';
      ab.Copay_Type_2_Additional_Increments__c='400';
      ab.CopayType2_Additional_InvalidIncrement__c='500';
      ab.Copay_Type_2_AmountValueSelected__c='600';
      ab.OON_Copay_AmountHigh__c='100';
      ab.OON_Copay_AmountLow__c='200';
      ab.OON_Copay2_Increment__c='300';
      ab.OON_Copay_Additional_Increments__c='400';
      ab.OON_Copay_Additional_InvalidIncrements__c='500';
      ab.OON_Copay_Type_1_AmountValueSelected__c='600';
      ab.OON_Copay2_High__c='100';
      ab.OON_Copay2_Low__c='200';
      ab.OON_Copay2_Increment__c='300';
      ab.OON_Copay_Type_2_Additional_Increments__c='400';
      ab.OON_Copay2Additional_InvalidIncrements__c='500';
      ab.OON_Copay_Type_2_AmountValueSelected__c='600';
      ab.Cost_Share_High__c='100';
      ab.Cost_Share_Low__c='200';
      ab.Cost_Share_Increment__c='300';
      ab.Cost_Share_AdditionalIncrements__c='400';
      ab.Cost_Share_InvalidIncrements__c='500';
      ab.Cost_Share_SelectedAmount__c='600';
      ab.OON_Cost_Share_High__c='100';
      ab.OON_Cost_Share_Low__c='200';
      ab.OON_Cost_Share_Increment__c='300';
      ab.OON_Cost_Share_AdditionalIncrements__c='400';
      ab.OON_Cost_Share_InvalidIncrements__c='500';
      ab.OON_Cost_Share_SelectedAmount__c='600';
      ab.Coinsurance_AmountHigh__c='100';
      ab.Coinsurance_AmountLow__c='200';
      ab.Coinsurance_AmountIncrement__c='300';
      ab.Coinsurance_Amount_AddtionalIncrements__c='400';
      ab.Coinsurance_Amount_InvalidIncrements__c='500';
      ab.CoInsurance_AmountValueSelected__c='600';
      ab.OON_Coinsurance_AmountHigh__c='100';
      ab.OON_Coinsurance_AmountLow__c='200';
      ab.OON_Coinsurance_AmountIncrement__c='300';
      ab.OON_Coinsurance_AddtionalIncrements__c='400';
      ab.OON_Coinsurance_InvalidIncrements__c='500';
      ab.OON_CoInsurance_AmountValueSelected__c='600';
      ab.IN_CostShare_3Month_DedCarryover_Default__c='Yes';
      ab.IN_CostShare_3Month_DeductibleCarryover__c='No';
      insert ab; 
          
          ab.Cost_Share_SelectedAmount__c='101';
          update ab;
          
       AIA_Benefits__c abdeletion = new AIA_Benefits__c();
      abdeletion.Grouper__c = ag.id;
      abdeletion.IS_ASO_Only__c=false;
      abdeletion.Benefit_Name__c = 'Family Out Of Pocket';
      abdeletion.Benefit_Type__c = 'Benefit';
      abdeletion.Copay_Type_1_Mandate_Name__c = 'Test';
      abdeletion.Type__c = 'Cost Share';
      abdeletion.Benefit_Record_Type__c = 'BRF';
      abdeletion.Cost_Share_Low__c = '0';
      abdeletion.Cost_Share_High__c = '100';
      abdeletion.Cost_Share_Increment__c = '10';
      abdeletion.Cost_Share_InvalidIncrements__c = '30';
      abdeletion.Cost_Share_AdditionalIncrements__c = '33';
      abdeletion.OON_Cost_Share_Low__c = '0';
      abdeletion.OON_Cost_Share_High__c = '1000';
      abdeletion.OON_Cost_Share_Increment__c = '100';
      abdeletion.OON_Cost_Share_AdditionalIncrements__c = '330';
      abdeletion.OON_Cost_Share_InvalidIncrements__c = '300';
      abdeletion.Copay_Type_1_DeductibleApplies__c = 'Yes';
      abdeletion.Copay_Type_1_IsCovered__c = 'No';
      abdeletion.OON_Copay_Type_1_IsCovered__c = 'Yes';
      abdeletion.OON_Copay_Type_1_DeductibleApplies__c = 'No';
      abdeletion.Copay_Type_1_AliasName__c = 'PCP Copay';
      abdeletion.Copay_Type_2_AliasName__c = 'Test';
      abdeletion.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
      abdeletion.OON_Copay_Type_2_AliasName__c = 'Test';
      abdeletion.IsAppGlobalCopay__c = true;
      abdeletion.Copay_Type_1_High__c='100';
      abdeletion.Copay_Type_1_Low__c='200';
      abdeletion.Copay_Type_1_Increment__c='300';
      abdeletion.Copay_Type_1_Additional_Increments__c='400';
      abdeletion.Copay_Type_1_AdditionalInvalidIncrements__c='500';
      abdeletion.Copay_Type_1_AmountValueSelected__c='600';
      abdeletion.Copay_Type_2_High__c='100';
      abdeletion.Copay_Type_2_Low__c='200';
      abdeletion.Copay_Type_2_Increment__c='300';
      abdeletion.Copay_Type_2_Additional_Increments__c='400';
      abdeletion.CopayType2_Additional_InvalidIncrement__c='500';
      abdeletion.Copay_Type_2_AmountValueSelected__c='600';
      abdeletion.OON_Copay_AmountHigh__c='100';
      abdeletion.OON_Copay_AmountLow__c='200';
      abdeletion.OON_Copay2_Increment__c='300';
      abdeletion.OON_Copay_Additional_Increments__c='400';
      abdeletion.OON_Copay_Additional_InvalidIncrements__c='500';
      abdeletion.OON_Copay_Type_1_AmountValueSelected__c='600';
      abdeletion.OON_Copay2_High__c='100';
      abdeletion.OON_Copay2_Low__c='200';
      abdeletion.OON_Copay2_Increment__c='300';
      abdeletion.OON_Copay_Type_2_Additional_Increments__c='400';
      abdeletion.OON_Copay2Additional_InvalidIncrements__c='500';
      abdeletion.OON_Copay_Type_2_AmountValueSelected__c='600';
      abdeletion.Cost_Share_High__c='100';
      abdeletion.Cost_Share_Low__c='200';
      abdeletion.Cost_Share_Increment__c='300';
      abdeletion.Cost_Share_AdditionalIncrements__c='400';
      abdeletion.Cost_Share_InvalidIncrements__c='500';
      abdeletion.Cost_Share_SelectedAmount__c='600';
      abdeletion.OON_Cost_Share_High__c='100';
      abdeletion.OON_Cost_Share_Low__c='200';
      abdeletion.OON_Cost_Share_Increment__c='300';
      abdeletion.OON_Cost_Share_AdditionalIncrements__c='400';
      abdeletion.OON_Cost_Share_InvalidIncrements__c='500';
      abdeletion.OON_Cost_Share_SelectedAmount__c='600';
      abdeletion.Coinsurance_AmountHigh__c='100';
      abdeletion.Coinsurance_AmountLow__c='200';
      abdeletion.Coinsurance_AmountIncrement__c='300';
      abdeletion.Coinsurance_Amount_AddtionalIncrements__c='400';
      abdeletion.Coinsurance_Amount_InvalidIncrements__c='500';
      abdeletion.CoInsurance_AmountValueSelected__c='600';
      abdeletion.OON_Coinsurance_AmountHigh__c='100';
      abdeletion.OON_Coinsurance_AmountLow__c='200';
      abdeletion.OON_Coinsurance_AmountIncrement__c='300';
      abdeletion.OON_Coinsurance_AddtionalIncrements__c='400';
      abdeletion.OON_Coinsurance_InvalidIncrements__c='500';
      abdeletion.OON_CoInsurance_AmountValueSelected__c='600';
      abdeletion.IN_CostShare_3Month_DedCarryover_Default__c='Yes';
      abdeletion.IN_CostShare_3Month_DeductibleCarryover__c='No';
      insert abdeletion;
          
          
          delete abdeletion;
          
          
     
     AIA_Benefits__c ab1 = new AIA_Benefits__c();
      ab1.Grouper__c = ag.id;
     ab1.IS_ASO_Only__c=false;
      ab1.Benefit_Name__c = 'Individual Out Of Pocket';
      ab1.Benefit_Type__c = 'Benefit';
      ab1.Copay_Type_1_Mandate_Name__c = 'Test';
      ab1.Type__c = 'Cost Share';
      ab1.Benefit_Record_Type__c = 'BRF';
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
      ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
      ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
      ab1.Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.Copay_Type_2_AliasName__c = 'Test';
      ab1.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.OON_Copay_Type_2_AliasName__c = 'Test';
      ab1.IsAppGlobalCopay__c = true;
      ab1.Copay_Type_1_High__c='100';
      ab1.Copay_Type_1_Low__c='200';
      ab1.Copay_Type_1_Increment__c='300';
      ab1.Copay_Type_1_Additional_Increments__c='400';
      ab1.Copay_Type_1_AdditionalInvalidIncrements__c='500';
      ab1.Copay_Type_1_AmountValueSelected__c='600';
      ab1.Copay_Type_2_High__c='100';
      ab1.Copay_Type_2_Low__c='200';
      ab1.Copay_Type_2_Increment__c='300';
      ab1.Copay_Type_2_Additional_Increments__c='400';
      ab1.CopayType2_Additional_InvalidIncrement__c='500';
      ab1.Copay_Type_2_AmountValueSelected__c='600';
      ab1.OON_Copay_AmountHigh__c='100';
      ab1.OON_Copay_AmountLow__c='200';
      ab1.OON_Copay2_Increment__c='300';
      ab1.OON_Copay_Additional_Increments__c='400';
      ab1.OON_Copay_Additional_InvalidIncrements__c='500';
      ab1.OON_Copay_Type_1_AmountValueSelected__c='600';
          ab1.OON_Copay2_High__c='100';
      ab1.OON_Copay2_Low__c='200';
      ab1.OON_Copay2_Increment__c='300';
      ab1.OON_Copay_Type_2_Additional_Increments__c='400';
      ab1.OON_Copay2Additional_InvalidIncrements__c='500';
      ab1.OON_Copay_Type_2_AmountValueSelected__c='600';
          ab1.Cost_Share_High__c='100';
      ab1.Cost_Share_Low__c='200';
      ab1.Cost_Share_Increment__c='300';
      ab1.Cost_Share_AdditionalIncrements__c='400';
      ab1.Cost_Share_InvalidIncrements__c='500';
      ab1.Cost_Share_SelectedAmount__c='600';
          ab1.OON_Cost_Share_High__c='100';
      ab1.OON_Cost_Share_Low__c='200';
      ab1.OON_Cost_Share_Increment__c='300';
      ab1.OON_Cost_Share_AdditionalIncrements__c='400';
      ab1.OON_Cost_Share_InvalidIncrements__c='500';
      ab1.OON_Cost_Share_SelectedAmount__c='600';
          ab1.Coinsurance_AmountHigh__c='100';
      ab1.Coinsurance_AmountLow__c='200';
      ab1.Coinsurance_AmountIncrement__c='300';
      ab1.Coinsurance_Amount_AddtionalIncrements__c='400';
      ab1.Coinsurance_Amount_InvalidIncrements__c='500';
      ab1.CoInsurance_AmountValueSelected__c='600';
          ab1.OON_Coinsurance_AmountHigh__c='100';
      ab1.OON_Coinsurance_AmountLow__c='200';
      ab1.OON_Coinsurance_AmountIncrement__c='300';
      ab1.OON_Coinsurance_AddtionalIncrements__c='400';
      ab1.OON_Coinsurance_InvalidIncrements__c='500';
      ab1.OON_CoInsurance_AmountValueSelected__c='600';
        ab1.IN_CostShare_3Month_DedCarryover_Default__c='Yes';
          ab1.IN_CostShare_3Month_DeductibleCarryover__c='No';
      insert ab1; 
ab1.Cost_Share_SelectedAmount__c='101';
          update ab1;
     Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Maxrow');
  insert lmt;
     
     
        AIA_BenefitTriggerHandler.disableAdjustmentsOnInserts();
        AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();

test.starttest();  
           PageReference pref = Page.AIA_ProposedProd_Summary;
           Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
            //Commenting as part of US1650
         //ext.getPCSdata();
        ext.mainInit();
           ext.createWrapListFromPlan(pp);
        ext.createWrapListFromPlanCostShr(aiapln.id);
               AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();
    AIA_BenefitTriggerHelperClass.validateCopayValues('2','3','4','5','6','7');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','7','4','5','6','3');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','4','5','6','3');
          AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','3','5','6','3');


        ext.saveAndCon();
        ext.addPlan();
        ext.saveandRedirct();
        ext.reviewInit();
       
        ext.back();
     
test.stoptest();            
    }
    
     public Static TestMethod void TestAIA_Benefit_CreationdisableOutOfRangeValuesIOPocket(){
    
       //Commenting as part of US210 
       /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
          insert wpt;*/
       
          Account acc = AIA_TestUtil.CreateAccount('TestAccount');
AIA_BenefittriggerHandlerHelper_Test.createAccountTeamMembers(acc.Id);
       
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
       
       
       
       
      Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
     brf.Enrollment_Type__c='Cafeteria';
     brf.Exclusive_Specialty_Provider_Network__c='Yes';
  insert brf;
       AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
          aiapln.Has_Benefit_Summary__c = True;
          aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
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
       List<AIA_Plan_Grouper__c> lstGrp = new List<AIA_Plan_Grouper__c>();
          AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
            pg.Name = 'CostShareRanges';
            pg.Plan_Network__c = pn.id;
            pg.Type__c = 'Cost Share Group';
            pg.Record_Type__c = 'BRF';
            pg.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00';
            pg.IsCovered__c='Yes';
            
            //insert pg;
          lstGrp.add(pg);
            
           AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
            pg2.Name = 'CostShareRanges';
            pg2.Plan_Network__c = pn2.id;
            pg2.Type__c = 'Cost Share Group';
            pg2.Record_Type__c = 'BRF';
            pg2.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002';
            pg2.IsCovered__c='No';

         //   insert pg2;
         lstGrp.add(pg2);
            
            AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
            pg3.Name = 'Medical Supplies/Equipment-0628';
            pg3.Plan_Network__c = pn.id;
            pg3.Type__c = 'Benefit Group';
            pg3.Sequence_Number__c = 1;
            pg3.Record_Type__c = 'BRF';
            pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
            pg3.IsCovered__c='No';

           // insert pg3;
          lstGrp.add(pg3);
            
            AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
            pg4.Name = 'Medical Supplies/Equipment-0629';
            pg4.Plan_Network__c = pn2.id;
            pg4.Type__c = 'Benefit Group';
            pg4.Sequence_Number__c = 1;
            pg4.Record_Type__c = 'BRF';
            pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
            pg4.IsCovered__c='Yes';

            //insert pg4;
           lstGrp.add(pg4);
           
           insert lstGrp;
           
          List<AIA_Plan_Benefits__c> lstPlnt = new List<AIA_Plan_Benefits__c>();
           AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
            pb.Benefit_Name__c = 'OutOfPocket_Individual';
            pb.Record_Type__c = 'BRF';
            pb.Type__c = 'Benefit';
            pb.Benefit_Group__c = pg3.id;
            pb.Cost_Share_Low__c = '0';
            pb.Cost_Share_High__c = '100';
            pb.Cost_Share_Increment__c = '10';
            pb.Cost_Share_Default_Amount__c = '40';
            pb.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb.Cost_Share_InvalidIncrements__c = '20, 30';
            pb.Sequence_Number__c = 1;
            //insert pb;
            lstPlnt.add(pb);
        
        AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
            pb29.Benefit_Name__c = '';
            pb29.Record_Type__c = 'BRF';
            pb29.Type__c = 'Benefit';
            pb29.Benefit_Group__c = pg4.id;
            pb29.Cost_Share_Low__c = '0';
            pb29.Cost_Share_High__c = '100';
            pb29.Cost_Share_Increment__c = '10';
            pb29.Cost_Share_Default_Amount__c = '40';
            pb29.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb29.Cost_Share_InvalidIncrements__c = '20, 30';
            pb29.Sequence_Number__c = 1;
           // insert pb29;
           lstPlnt.add(pb29);
          
          AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
            pb2.Benefit_Name__c = 'OutOfPocket_Family';
            pb2.Record_Type__c = 'BRF';
            pb2.Type__c = 'Cost Share';
            pb2.Benefit_Group__c = pg.id;
            pb2.Cost_Share_Low__c = '0';
            pb2.Cost_Share_High__c = '100';
            pb2.Cost_Share_Increment__c = '10';
            pb2.Cost_Share_Default_Amount__c = '40';
            pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb2.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb2;
          lstPlnt.add(pb2);
        
            AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
            pb3.Benefit_Name__c = 'OutOfPocket_Single';
            pb3.Record_Type__c = 'BRF';
            pb3.Type__c = 'Cost Share';
            pb3.Benefit_Group__c = pg.id;
            pb3.Cost_Share_Low__c = '0';
            pb3.Cost_Share_High__c = '100';
            pb3.Cost_Share_Increment__c = '10';
            pb3.Cost_Share_Default_Amount__c = '40';
            pb3.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb3.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb3;
           lstPlnt.add(pb3); 
            AIA_Plan_Benefits__c pb4 = new AIA_Plan_Benefits__c();
            pb4.Benefit_Name__c = 'Deductible_Individual';
            pb4.Record_Type__c = 'BRF';
            pb4.Type__c = 'Cost Share';
            pb4.Benefit_Group__c = pg.id;
            pb4.Cost_Share_Low__c = '0';
            pb4.Cost_Share_High__c = '100';
            pb4.Cost_Share_Increment__c = '10';
            pb4.Cost_Share_Default_Amount__c = '40';
            pb4.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb4.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb4;
            lstPlnt.add(pb4); 
            
            AIA_Plan_Benefits__c pb5 = new AIA_Plan_Benefits__c();
            pb5.Benefit_Name__c = 'Deductible_Family';
            pb5.Record_Type__c = 'BRF';
            pb5.Type__c = 'Cost Share';
            pb5.Benefit_Group__c = pg.id;
            pb5.Cost_Share_Low__c = '0';
            pb5.Cost_Share_High__c = '100';
            pb5.Cost_Share_Increment__c = '10';
            pb5.Cost_Share_Default_Amount__c = '40';
            pb5.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb5.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb5;
           lstPlnt.add(pb5);
            
            AIA_Plan_Benefits__c pb6 = new AIA_Plan_Benefits__c();
            pb6.Benefit_Name__c = 'Deductible_Single';
            pb6.Record_Type__c = 'BRF';
            pb6.Type__c = 'Cost Share';
            pb6.Benefit_Group__c = pg.id;
            pb6.Cost_Share_Low__c = '0';
            pb6.Cost_Share_High__c = '100';
            pb6.Cost_Share_Increment__c = '10';
            pb6.Cost_Share_Default_Amount__c = '40';
            pb6.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb6.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb6;
           lstPlnt.add(pb6);
            
            AIA_Plan_Benefits__c pb7 = new AIA_Plan_Benefits__c();
            pb7.Benefit_Name__c = 'DeductibleCarryOver';
            pb7.Record_Type__c = 'BRF';
            pb7.Type__c = 'Cost Share';
            pb7.Benefit_Group__c = pg.id;
            pb7.Cost_Share_Low__c = '0';
            pb7.Cost_Share_High__c = '100';
            pb7.Cost_Share_Increment__c = '10';
            pb7.Cost_Share_Default_Amount__c = '40';
            pb7.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb7.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb7;
            lstPlnt.add(pb7);
            AIA_Plan_Benefits__c pb8 = new AIA_Plan_Benefits__c();
            pb8.Benefit_Name__c = 'LifetimeMax_Single';
            pb8.Record_Type__c = 'BRF';
            pb8.Type__c = 'Cost Share';
            pb8.Benefit_Group__c = pg.id;
            pb8.Cost_Share_Low__c = '0';
            pb8.Cost_Share_High__c = '100';
            pb8.Cost_Share_Increment__c = '10';
            pb8.Cost_Share_Default_Amount__c = '40';
            pb8.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb8.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb8;
             lstPlnt.add(pb8);
            AIA_Plan_Benefits__c pb9 = new AIA_Plan_Benefits__c();
            pb9.Benefit_Name__c = 'Copay_PCPCopay';
            pb9.Record_Type__c = 'BRF';
            pb9.Type__c = 'Cost Share';
            pb9.Benefit_Group__c = pg.id;
            pb9.Cost_Share_Low__c = '0';
            pb9.Cost_Share_High__c = '100';
            pb9.Cost_Share_Increment__c = '10';
            pb9.Cost_Share_Default_Amount__c = '40';
            pb9.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb9.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb9;
            lstPlnt.add(pb9);
            AIA_Plan_Benefits__c pb10 = new AIA_Plan_Benefits__c();
            pb10.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb10.Record_Type__c = 'BRF';
            pb10.Type__c = 'Cost Share';
            pb10.Benefit_Group__c = pg.id;
            pb10.Cost_Share_Low__c = '0';
            pb10.Cost_Share_High__c = '100';
            pb10.Cost_Share_Increment__c = '10';
            pb10.Cost_Share_Default_Amount__c = '40';
            pb10.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb10.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb10;
            lstPlnt.add(pb10);
            
            AIA_Plan_Benefits__c pb11 = new AIA_Plan_Benefits__c();
            pb11.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb11.Record_Type__c = 'BRF';
            pb11.Type__c = 'Cost Share';
            pb11.Benefit_Group__c = pg.id;
            pb11.Cost_Share_Low__c = '0';
            pb11.Cost_Share_High__c = '100';
            pb11.Cost_Share_Increment__c = '10';
            pb11.Cost_Share_Default_Amount__c = '40';
            pb11.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb11.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb11;
           lstPlnt.add(pb11);
            
            AIA_Plan_Benefits__c pb13 = new AIA_Plan_Benefits__c();
            pb13.Benefit_Name__c = 'OutOfPocket_Individual';
            pb13.Record_Type__c = 'BRF';
            pb13.Type__c = 'Cost Share';
            pb13.Benefit_Group__c = pg2.id;
            pb13.Cost_Share_Low__c = '0';
            pb13.Cost_Share_High__c = '100';
            pb13.Cost_Share_Increment__c = '10';
            pb13.Cost_Share_Default_Amount__c = '40';
            pb13.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb13.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb13;
            lstPlnt.add(pb13);
            AIA_Plan_Benefits__c pb14 = new AIA_Plan_Benefits__c();
            pb14.Benefit_Name__c = 'OutOfPocket_Family';
            pb14.Record_Type__c = 'BRF';
            pb14.Type__c = 'Cost Share';
            pb14.Benefit_Group__c = pg2.id;
            pb14.Cost_Share_Low__c = '0';
            pb14.Cost_Share_High__c = '100';
            pb14.Cost_Share_Increment__c = '10';
            pb14.Cost_Share_Default_Amount__c = '40';
            pb14.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb14.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb14;
            lstPlnt.add(pb14);
            AIA_Plan_Benefits__c pb15 = new AIA_Plan_Benefits__c();
            pb15.Benefit_Name__c = 'OutOfPocket_Single';
            pb15.Record_Type__c = 'BRF';
            pb15.Type__c = 'Cost Share';
            pb15.Benefit_Group__c = pg2.id;
            pb15.Cost_Share_Low__c = '0';
            pb15.Cost_Share_High__c = '100';
            pb15.Cost_Share_Increment__c = '10';
            pb15.Cost_Share_Default_Amount__c = '40';
            pb15.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb15.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb15;
            lstPlnt.add(pb15);
            AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
            pb16.Benefit_Name__c = 'Deductible_Individual';
            pb16.Record_Type__c = 'BRF';
            pb16.Type__c = 'Cost Share';
            pb16.Benefit_Group__c = pg2.id;
            pb16.Cost_Share_Low__c = '0';
            pb16.Cost_Share_High__c = '100';
            pb16.Cost_Share_Increment__c = '10';
            pb16.Cost_Share_Default_Amount__c = '40';
            pb16.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb16.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb16;
            lstPlnt.add(pb16);
            
            insert lstPlnt;
            
            AIA_Plan_Benefits__c pb17 = new AIA_Plan_Benefits__c();
            pb17.Benefit_Name__c = 'Deductible_Family';
            pb17.Record_Type__c = 'BRF';
            pb17.Type__c = 'Cost Share';
            pb17.Benefit_Group__c = pg2.id;
            pb17.Cost_Share_Low__c = '0';
            pb17.Cost_Share_High__c = '100';
            pb17.Cost_Share_Increment__c = '10';
            pb17.Cost_Share_Default_Amount__c = '40';
            pb17.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb17.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb17;
            lstPlnt.add(pb17);
            
           // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb18 = new AIA_Plan_Benefits__c();
            pb18.Benefit_Name__c = 'Deductible_Single';
            pb18.Record_Type__c = 'BRF';
            pb18.Type__c = 'Cost Share';
            pb18.Benefit_Group__c = pg2.id;
            pb18.Cost_Share_Low__c = '0';
            pb18.Cost_Share_High__c = '100';
            pb18.Cost_Share_Increment__c = '10';
            pb18.Cost_Share_Default_Amount__c = '40';
            pb18.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb18.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb18;
           lstPlnt.add(pb18);
           
         //  insert lstPlnt;
            
            AIA_Plan_Benefits__c pb19 = new AIA_Plan_Benefits__c();
            pb19.Benefit_Name__c = 'DeductibleCarryOver';
            pb19.Record_Type__c = 'BRF';
            pb19.Type__c = 'Cost Share';
            pb19.Benefit_Group__c = pg2.id;
            pb19.Cost_Share_Low__c = '0';
            pb19.Cost_Share_High__c = '100';
            pb19.Cost_Share_Increment__c = '10';
            pb19.Cost_Share_Default_Amount__c = '40';
            pb19.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb19.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb19;
           lstPlnt.add(pb19);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb20 = new AIA_Plan_Benefits__c();
            pb20.Benefit_Name__c = 'LifetimeMax_Single';
            pb20.Record_Type__c = 'BRF';
            pb20.Type__c = 'Cost Share';
            pb20.Benefit_Group__c = pg2.id;
            pb20.Cost_Share_Low__c = '0';
            pb20.Cost_Share_High__c = '100';
            pb20.Cost_Share_Increment__c = '10';
            pb20.Cost_Share_Default_Amount__c = '40';
            pb20.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb20.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb20;
            lstPlnt.add(pb20);
            
          //  insert lstPlnt;
            
            
            AIA_Plan_Benefits__c pb21 = new AIA_Plan_Benefits__c();
            pb21.Benefit_Name__c = 'Copay_PCPCopay';
            pb21.Record_Type__c = 'BRF';
            pb21.Type__c = 'Cost Share';
            pb21.Benefit_Group__c = pg2.id;
            pb21.Cost_Share_Low__c = '0';
            pb21.Cost_Share_High__c = '100';
            pb21.Cost_Share_Increment__c = '10';
            pb21.Cost_Share_Default_Amount__c = '40';
            pb21.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb21.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb21;
           lstPlnt.add(pb21);
           
          // insert  lstPlnt;
            
            AIA_Plan_Benefits__c pb22 = new AIA_Plan_Benefits__c();
            pb22.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb22.Record_Type__c = 'BRF';
            pb22.Type__c = 'Cost Share';
            pb22.Benefit_Group__c = pg2.id;
            pb22.Cost_Share_Low__c = '0';
            pb22.Cost_Share_High__c = '100';
            pb22.Cost_Share_Increment__c = '10';
            pb22.Cost_Share_Default_Amount__c = '40';
            pb22.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb22.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb22;
           lstPlnt.add(pb22);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb23 = new AIA_Plan_Benefits__c();
            pb23.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb23.Record_Type__c = 'BRF';
            pb23.Type__c = 'Cost Share';
            pb23.Benefit_Group__c = pg2.id;
            pb23.Cost_Share_Low__c = '0';
            pb23.Cost_Share_High__c = '100';
            pb23.Cost_Share_Increment__c = '10';
            pb23.Cost_Share_Default_Amount__c = '40';
            pb23.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb23.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb23;    
           lstPlnt.add(pb22);
           
         //  insert lstPlnt;
               
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
            
            AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
            apc30.Plan_Benefits__c = pb29.id;
            apc30.AliasName__c = 'General Copay';
            apc30.CopayAmount__c = '200';
            apc30.CoinsuranceAmount__c = '50';
            apc30.MinPayAmount__c = '90';
            apc30.MaxPayAmount__c = '80';
            apc30.IsCovered__c = 'Yes';
            apc30.DeductibleApplies__c = 'No';  
            apc30.MandateIndicator__c = 'Yes';          
            apc30.Jurisdiction__c = 'Test';            
            apc30.MandateName__c='PPACA mandate';
            apc30.ExtID__c = 'rwuifghqierufghaire';
            insert apc30;
        
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
            
          // pbc.IsMandateTrue__c ='Yes';
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
          //mod 
          
     
     //mod
            
            //system.debug('ppd id medical'+pp1);
     Proposed_Products__c pp1 = new Proposed_Products__c();           
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp1.Benefit_Request_Form__c =brf.id;
            pp1.Funding_Arrangement__c = 'ASO';
            pp1.Product_Category__c = 'Drug';
            pp1.Product_Line__c = 'pp1O';
           pp1.Plan_Name__c = aiapln.id;
            pp1.Product_Name__c = 'BlueChoice Advantage';
            pp1.CDH__c = 'Yes';
            pp1.CDH_Fund_Type__c = 'BlueFund';
            pp1.CDH_Type__c = 'HSA';
            pp1.Deductible__c = 'Stacked';
            pp1.Grandfathered_Status__c = 'Grandfathered';
            pp1.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp1.Blue_Rewards__c = 'No';
            pp1.Out_of_Pocket_Max__c = 'Stacked';
           // pp1.Jurisdiction__c = 'MD';
            pp1.Has_Benefit_Details__c = false;
            pp1.Exclusive_Specialty_Provider_Network__c='Yes';
            pp1.RX_OOP_Max_Integration__c='Integrated';
            insert pp1;
           Proposed_Products__c pp = new Proposed_Products__c();           
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.id;
            pp.Funding_Arrangement__c = 'ASO';
            pp.Product_Category__c = 'Drug';
            pp.Product_Line__c = 'PPO';
           pp.Plan_Name__c = aiapln.id;
            pp.Product_Name__c = 'BlueChoice Advantage';
            pp.CDH__c = 'Yes';
            pp.CDH_Fund_Type__c = 'BlueFund';
            pp.Related_Medical_Product__c=pp1.id;
            pp.Exclusive_Specialty_Provider_Network__c='Yes';
            pp.CDH_Type__c = 'HSA';
            pp.Deductible__c = 'Stacked';
            pp.Grandfathered_Status__c = 'Grandfathered';
            pp.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp.Grandfathered_PPACA_Status__c = 'No';
            pp.Blue_Rewards__c = 'No';
            pp.Out_of_Pocket_Max__c = 'Stacked';
     pp.RX_OOP_Max_Integration__c='Integrated';
           // pp.Jurisdiction__c = 'MD';
            pp.Has_Benefit_Details__c = false;
            insert pp;
                 system.debug('ppd id drug pp'+pp);
 
     Proposed_Products__c pp2 = new Proposed_Products__c();           
            pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp2.Benefit_Request_Form__c =brf.id;
            pp2.Funding_Arrangement__c = 'ASO';
            pp2.Product_Category__c = 'Drug';
            pp2.Product_Line__c = 'pp2O';
           pp2.Plan_Name__c = aiapln.id;
            pp2.Product_Name__c = 'BlueChoice Advantage';
            pp2.CDH__c = 'Yes';
            pp2.CDH_Fund_Type__c = 'BlueFund';
          pp2.Related_Medical_Product__c=pp.id;
            pp2.CDH_Type__c = 'HSA';
            pp2.Deductible__c = 'Stacked';
            pp2.Grandfathered_Status__c = 'Grandfathered';
            pp2.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp2.Grandfathered_ppACA_Status__c = 'No';
            pp2.Blue_Rewards__c = 'No';
            pp2.Out_of_Pocket_Max__c = 'Stacked';
           // pp2.Jurisdiction__c = 'MD';
            pp2.Has_Benefit_Details__c = false;
            pp2.Exclusive_Specialty_Provider_Network__c='Yes';
          pp2.RX_OOP_Max_Integration__c='Integrated';

            insert pp2;
     
                 system.debug('ppd id medical1'+pp2);

     
     //mod offshore

     AIA_Grouper__c ag = new AIA_Grouper__c();
      ag.Name = 'CostShareRanges';
      ag.Group_Type__c = 'Cost Share Group';
      ag.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag.Proposed_Products__c = pp.id;
  insert ag;
     AIA_Grouper__c ag1 = new AIA_Grouper__c();
      ag1.Name = 'CostShareRanges';
      ag1.Group_Type__c = 'Cost Share Group';
      ag1.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag1.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag1.Proposed_Products__c = pp2.id;
  insert ag1;
  AIA_Benefits__c ab = new AIA_Benefits__c();
      ab.Grouper__c = ag.id;
     ab.IS_ASO_Only__c=false;
      ab.Benefit_Name__c = 'Individual Out Of Pocket';
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
      ab.Copay_Type_1_High__c='100';
      ab.Copay_Type_1_Low__c='200';
      ab.Copay_Type_1_Increment__c='300';
      ab.Copay_Type_1_Additional_Increments__c='400';
      ab.Copay_Type_1_AdditionalInvalidIncrements__c='500';
      ab.Copay_Type_1_AmountValueSelected__c='600';
      ab.Copay_Type_2_High__c='100';
      ab.Copay_Type_2_Low__c='200';
      ab.Copay_Type_2_Increment__c='300';
      ab.Copay_Type_2_Additional_Increments__c='400';
      ab.CopayType2_Additional_InvalidIncrement__c='500';
      ab.Copay_Type_2_AmountValueSelected__c='600';
      ab.OON_Copay_AmountHigh__c='100';
      ab.OON_Copay_AmountLow__c='200';
      ab.OON_Copay2_Increment__c='300';
      ab.OON_Copay_Additional_Increments__c='400';
      ab.OON_Copay_Additional_InvalidIncrements__c='500';
      ab.OON_Copay_Type_1_AmountValueSelected__c='600';
          ab.OON_Copay2_High__c='100';
      ab.OON_Copay2_Low__c='200';
      ab.OON_Copay2_Increment__c='300';
      ab.OON_Copay_Type_2_Additional_Increments__c='400';
      ab.OON_Copay2Additional_InvalidIncrements__c='500';
      ab.OON_Copay_Type_2_AmountValueSelected__c='600';
          ab.Cost_Share_High__c='100';
      ab.Cost_Share_Low__c='200';
      ab.Cost_Share_Increment__c='300';
      ab.Cost_Share_AdditionalIncrements__c='400';
      ab.Cost_Share_InvalidIncrements__c='500';
      ab.Cost_Share_SelectedAmount__c='600';
          ab.OON_Cost_Share_High__c='100';
      ab.OON_Cost_Share_Low__c='200';
      ab.OON_Cost_Share_Increment__c='300';
      ab.OON_Cost_Share_AdditionalIncrements__c='400';
      ab.OON_Cost_Share_InvalidIncrements__c='500';
      ab.OON_Cost_Share_SelectedAmount__c='600';
          ab.Coinsurance_AmountHigh__c='100';
      ab.Coinsurance_AmountLow__c='200';
      ab.Coinsurance_AmountIncrement__c='300';
      ab.Coinsurance_Amount_AddtionalIncrements__c='400';
      ab.Coinsurance_Amount_InvalidIncrements__c='500';
      ab.CoInsurance_AmountValueSelected__c='600';
          ab.OON_Coinsurance_AmountHigh__c='100';
      ab.OON_Coinsurance_AmountLow__c='200';
      ab.OON_Coinsurance_AmountIncrement__c='300';
      ab.OON_Coinsurance_AddtionalIncrements__c='400';
      ab.OON_Coinsurance_InvalidIncrements__c='500';
      ab.OON_CoInsurance_AmountValueSelected__c='600';
        ab.IN_CostShare_3Month_DedCarryover_Default__c='Yes';
          ab.IN_CostShare_3Month_DeductibleCarryover__c='No';
      insert ab; 
          
          ab.Cost_Share_SelectedAmount__c='101';
          update ab;
     
     AIA_Benefits__c ab1 = new AIA_Benefits__c();
      ab1.Grouper__c = ag.id;
     ab1.IS_ASO_Only__c=false;
      ab1.Benefit_Name__c = 'Individual Out Of Pocket';
      ab1.Benefit_Type__c = 'Benefit';
      ab1.Copay_Type_1_Mandate_Name__c = 'Test';
      ab1.Type__c = 'Cost Share';
      ab1.Benefit_Record_Type__c = 'BRF';
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
      ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
      ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
      ab1.Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.Copay_Type_2_AliasName__c = 'Test';
      ab1.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.OON_Copay_Type_2_AliasName__c = 'Test';
      ab1.IsAppGlobalCopay__c = true;
      ab1.Copay_Type_1_High__c='100';
      ab1.Copay_Type_1_Low__c='200';
      ab1.Copay_Type_1_Increment__c='300';
      ab1.Copay_Type_1_Additional_Increments__c='400';
      ab1.Copay_Type_1_AdditionalInvalidIncrements__c='500';
      ab1.Copay_Type_1_AmountValueSelected__c='600';
      ab1.Copay_Type_2_High__c='100';
      ab1.Copay_Type_2_Low__c='200';
      ab1.Copay_Type_2_Increment__c='300';
      ab1.Copay_Type_2_Additional_Increments__c='400';
      ab1.CopayType2_Additional_InvalidIncrement__c='500';
      ab1.Copay_Type_2_AmountValueSelected__c='600';
      ab1.OON_Copay_AmountHigh__c='100';
      ab1.OON_Copay_AmountLow__c='200';
      ab1.OON_Copay2_Increment__c='300';
      ab1.OON_Copay_Additional_Increments__c='400';
      ab1.OON_Copay_Additional_InvalidIncrements__c='500';
      ab1.OON_Copay_Type_1_AmountValueSelected__c='600';
          ab1.OON_Copay2_High__c='100';
      ab1.OON_Copay2_Low__c='200';
      ab1.OON_Copay2_Increment__c='300';
      ab1.OON_Copay_Type_2_Additional_Increments__c='400';
      ab1.OON_Copay2Additional_InvalidIncrements__c='500';
      ab1.OON_Copay_Type_2_AmountValueSelected__c='600';
          ab1.Cost_Share_High__c='100';
      ab1.Cost_Share_Low__c='200';
      ab1.Cost_Share_Increment__c='300';
      ab1.Cost_Share_AdditionalIncrements__c='400';
      ab1.Cost_Share_InvalidIncrements__c='500';
      ab1.Cost_Share_SelectedAmount__c='600';
          ab1.OON_Cost_Share_High__c='100';
      ab1.OON_Cost_Share_Low__c='200';
      ab1.OON_Cost_Share_Increment__c='300';
      ab1.OON_Cost_Share_AdditionalIncrements__c='400';
      ab1.OON_Cost_Share_InvalidIncrements__c='500';
      ab1.OON_Cost_Share_SelectedAmount__c='600';
          ab1.Coinsurance_AmountHigh__c='100';
      ab1.Coinsurance_AmountLow__c='200';
      ab1.Coinsurance_AmountIncrement__c='300';
      ab1.Coinsurance_Amount_AddtionalIncrements__c='400';
      ab1.Coinsurance_Amount_InvalidIncrements__c='500';
      ab1.CoInsurance_AmountValueSelected__c='600';
          ab1.OON_Coinsurance_AmountHigh__c='100';
      ab1.OON_Coinsurance_AmountLow__c='200';
      ab1.OON_Coinsurance_AmountIncrement__c='300';
      ab1.OON_Coinsurance_AddtionalIncrements__c='400';
      ab1.OON_Coinsurance_InvalidIncrements__c='500';
      ab1.OON_CoInsurance_AmountValueSelected__c='600';
        ab1.IN_CostShare_3Month_DedCarryover_Default__c='Yes';
          ab1.IN_CostShare_3Month_DeductibleCarryover__c='No';
      insert ab1; 
ab1.Cost_Share_SelectedAmount__c='101';
          update ab1;
     Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Maxrow');
  insert lmt;
     
     
        AIA_BenefitTriggerHandler.disableAdjustmentsOnInserts();
        AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();

test.starttest();  
           PageReference pref = Page.AIA_ProposedProd_Summary;
           Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
            //Commenting as part of US1650
         //ext.getPCSdata();
        ext.mainInit();
           ext.createWrapListFromPlan(pp);
        ext.createWrapListFromPlanCostShr(aiapln.id);
               AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();
    AIA_BenefitTriggerHelperClass.validateCopayValues('2','3','4','5','6','7');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','7','4','5','6','3');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','4','5','6','3');
          AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','3','5','6','3');


        ext.saveAndCon();
        ext.addPlan();
        ext.saveandRedirct();
        ext.reviewInit();
       
        ext.back();
     
test.stoptest();            
    }
    public Static TestMethod void TestAIA_Benefit_CreationdisableOutOfRangeValuesFamilyDeductible(){
    
       //Commenting as part of US210 
       /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
          insert wpt;*/
       
          Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            AIA_BenefittriggerHandlerHelper_Test.createAccountTeamMembers(acc.Id);
       
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
       
       
       
       
      Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
     brf.Enrollment_Type__c='Cafeteria';
     brf.Exclusive_Specialty_Provider_Network__c='Yes';
  insert brf;
       AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
          aiapln.Has_Benefit_Summary__c = True;
          aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
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
       List<AIA_Plan_Grouper__c> lstGrp = new List<AIA_Plan_Grouper__c>();
          AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
            pg.Name = 'CostShareRanges';
            pg.Plan_Network__c = pn.id;
            pg.Type__c = 'Cost Share Group';
            pg.Record_Type__c = 'BRF';
            pg.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00';
            pg.IsCovered__c='Yes';
            
            //insert pg;
          lstGrp.add(pg);
            
           AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
            pg2.Name = 'CostShareRanges';
            pg2.Plan_Network__c = pn2.id;
            pg2.Type__c = 'Cost Share Group';
            pg2.Record_Type__c = 'BRF';
            pg2.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002';
            pg2.IsCovered__c='No';

         //   insert pg2;
         lstGrp.add(pg2);
            
            AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
            pg3.Name = 'Medical Supplies/Equipment-0628';
            pg3.Plan_Network__c = pn.id;
            pg3.Type__c = 'Benefit Group';
            pg3.Sequence_Number__c = 1;
            pg3.Record_Type__c = 'BRF';
            pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
            pg3.IsCovered__c='No';

           // insert pg3;
          lstGrp.add(pg3);
            
            AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
            pg4.Name = 'Medical Supplies/Equipment-0629';
            pg4.Plan_Network__c = pn2.id;
            pg4.Type__c = 'Benefit Group';
            pg4.Sequence_Number__c = 1;
            pg4.Record_Type__c = 'BRF';
            pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
            pg4.IsCovered__c='Yes';

            //insert pg4;
           lstGrp.add(pg4);
           
           insert lstGrp;
           
          List<AIA_Plan_Benefits__c> lstPlnt = new List<AIA_Plan_Benefits__c>();
           AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
            pb.Benefit_Name__c = 'OutOfPocket_Individual';
            pb.Record_Type__c = 'BRF';
            pb.Type__c = 'Benefit';
            pb.Benefit_Group__c = pg3.id;
            pb.Cost_Share_Low__c = '0';
            pb.Cost_Share_High__c = '100';
            pb.Cost_Share_Increment__c = '10';
            pb.Cost_Share_Default_Amount__c = '40';
            pb.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb.Cost_Share_InvalidIncrements__c = '20, 30';
            pb.Sequence_Number__c = 1;
            //insert pb;
            lstPlnt.add(pb);
        
        AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
            pb29.Benefit_Name__c = '';
            pb29.Record_Type__c = 'BRF';
            pb29.Type__c = 'Benefit';
            pb29.Benefit_Group__c = pg4.id;
            pb29.Cost_Share_Low__c = '0';
            pb29.Cost_Share_High__c = '100';
            pb29.Cost_Share_Increment__c = '10';
            pb29.Cost_Share_Default_Amount__c = '40';
            pb29.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb29.Cost_Share_InvalidIncrements__c = '20, 30';
            pb29.Sequence_Number__c = 1;
           // insert pb29;
           lstPlnt.add(pb29);
          
          AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
            pb2.Benefit_Name__c = 'OutOfPocket_Family';
            pb2.Record_Type__c = 'BRF';
            pb2.Type__c = 'Cost Share';
            pb2.Benefit_Group__c = pg.id;
            pb2.Cost_Share_Low__c = '0';
            pb2.Cost_Share_High__c = '100';
            pb2.Cost_Share_Increment__c = '10';
            pb2.Cost_Share_Default_Amount__c = '40';
            pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb2.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb2;
          lstPlnt.add(pb2);
        
            AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
            pb3.Benefit_Name__c = 'OutOfPocket_Single';
            pb3.Record_Type__c = 'BRF';
            pb3.Type__c = 'Cost Share';
            pb3.Benefit_Group__c = pg.id;
            pb3.Cost_Share_Low__c = '0';
            pb3.Cost_Share_High__c = '100';
            pb3.Cost_Share_Increment__c = '10';
            pb3.Cost_Share_Default_Amount__c = '40';
            pb3.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb3.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb3;
           lstPlnt.add(pb3); 
            AIA_Plan_Benefits__c pb4 = new AIA_Plan_Benefits__c();
            pb4.Benefit_Name__c = 'Deductible_Individual';
            pb4.Record_Type__c = 'BRF';
            pb4.Type__c = 'Cost Share';
            pb4.Benefit_Group__c = pg.id;
            pb4.Cost_Share_Low__c = '0';
            pb4.Cost_Share_High__c = '100';
            pb4.Cost_Share_Increment__c = '10';
            pb4.Cost_Share_Default_Amount__c = '40';
            pb4.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb4.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb4;
            lstPlnt.add(pb4); 
            
            AIA_Plan_Benefits__c pb5 = new AIA_Plan_Benefits__c();
            pb5.Benefit_Name__c = 'Deductible_Family';
            pb5.Record_Type__c = 'BRF';
            pb5.Type__c = 'Cost Share';
            pb5.Benefit_Group__c = pg.id;
            pb5.Cost_Share_Low__c = '0';
            pb5.Cost_Share_High__c = '100';
            pb5.Cost_Share_Increment__c = '10';
            pb5.Cost_Share_Default_Amount__c = '40';
            pb5.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb5.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb5;
           lstPlnt.add(pb5);
            
            AIA_Plan_Benefits__c pb6 = new AIA_Plan_Benefits__c();
            pb6.Benefit_Name__c = 'Deductible_Single';
            pb6.Record_Type__c = 'BRF';
            pb6.Type__c = 'Cost Share';
            pb6.Benefit_Group__c = pg.id;
            pb6.Cost_Share_Low__c = '0';
            pb6.Cost_Share_High__c = '100';
            pb6.Cost_Share_Increment__c = '10';
            pb6.Cost_Share_Default_Amount__c = '40';
            pb6.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb6.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb6;
           lstPlnt.add(pb6);
            
            AIA_Plan_Benefits__c pb7 = new AIA_Plan_Benefits__c();
            pb7.Benefit_Name__c = 'DeductibleCarryOver';
            pb7.Record_Type__c = 'BRF';
            pb7.Type__c = 'Cost Share';
            pb7.Benefit_Group__c = pg.id;
            pb7.Cost_Share_Low__c = '0';
            pb7.Cost_Share_High__c = '100';
            pb7.Cost_Share_Increment__c = '10';
            pb7.Cost_Share_Default_Amount__c = '40';
            pb7.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb7.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb7;
            lstPlnt.add(pb7);
            AIA_Plan_Benefits__c pb8 = new AIA_Plan_Benefits__c();
            pb8.Benefit_Name__c = 'LifetimeMax_Single';
            pb8.Record_Type__c = 'BRF';
            pb8.Type__c = 'Cost Share';
            pb8.Benefit_Group__c = pg.id;
            pb8.Cost_Share_Low__c = '0';
            pb8.Cost_Share_High__c = '100';
            pb8.Cost_Share_Increment__c = '10';
            pb8.Cost_Share_Default_Amount__c = '40';
            pb8.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb8.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb8;
             lstPlnt.add(pb8);
            AIA_Plan_Benefits__c pb9 = new AIA_Plan_Benefits__c();
            pb9.Benefit_Name__c = 'Copay_PCPCopay';
            pb9.Record_Type__c = 'BRF';
            pb9.Type__c = 'Cost Share';
            pb9.Benefit_Group__c = pg.id;
            pb9.Cost_Share_Low__c = '0';
            pb9.Cost_Share_High__c = '100';
            pb9.Cost_Share_Increment__c = '10';
            pb9.Cost_Share_Default_Amount__c = '40';
            pb9.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb9.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb9;
            lstPlnt.add(pb9);
            AIA_Plan_Benefits__c pb10 = new AIA_Plan_Benefits__c();
            pb10.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb10.Record_Type__c = 'BRF';
            pb10.Type__c = 'Cost Share';
            pb10.Benefit_Group__c = pg.id;
            pb10.Cost_Share_Low__c = '0';
            pb10.Cost_Share_High__c = '100';
            pb10.Cost_Share_Increment__c = '10';
            pb10.Cost_Share_Default_Amount__c = '40';
            pb10.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb10.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb10;
            lstPlnt.add(pb10);
            
            AIA_Plan_Benefits__c pb11 = new AIA_Plan_Benefits__c();
            pb11.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb11.Record_Type__c = 'BRF';
            pb11.Type__c = 'Cost Share';
            pb11.Benefit_Group__c = pg.id;
            pb11.Cost_Share_Low__c = '0';
            pb11.Cost_Share_High__c = '100';
            pb11.Cost_Share_Increment__c = '10';
            pb11.Cost_Share_Default_Amount__c = '40';
            pb11.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb11.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb11;
           lstPlnt.add(pb11);
            
            AIA_Plan_Benefits__c pb13 = new AIA_Plan_Benefits__c();
            pb13.Benefit_Name__c = 'OutOfPocket_Individual';
            pb13.Record_Type__c = 'BRF';
            pb13.Type__c = 'Cost Share';
            pb13.Benefit_Group__c = pg2.id;
            pb13.Cost_Share_Low__c = '0';
            pb13.Cost_Share_High__c = '100';
            pb13.Cost_Share_Increment__c = '10';
            pb13.Cost_Share_Default_Amount__c = '40';
            pb13.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb13.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb13;
            lstPlnt.add(pb13);
            AIA_Plan_Benefits__c pb14 = new AIA_Plan_Benefits__c();
            pb14.Benefit_Name__c = 'OutOfPocket_Family';
            pb14.Record_Type__c = 'BRF';
            pb14.Type__c = 'Cost Share';
            pb14.Benefit_Group__c = pg2.id;
            pb14.Cost_Share_Low__c = '0';
            pb14.Cost_Share_High__c = '100';
            pb14.Cost_Share_Increment__c = '10';
            pb14.Cost_Share_Default_Amount__c = '40';
            pb14.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb14.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb14;
            lstPlnt.add(pb14);
            AIA_Plan_Benefits__c pb15 = new AIA_Plan_Benefits__c();
            pb15.Benefit_Name__c = 'OutOfPocket_Single';
            pb15.Record_Type__c = 'BRF';
            pb15.Type__c = 'Cost Share';
            pb15.Benefit_Group__c = pg2.id;
            pb15.Cost_Share_Low__c = '0';
            pb15.Cost_Share_High__c = '100';
            pb15.Cost_Share_Increment__c = '10';
            pb15.Cost_Share_Default_Amount__c = '40';
            pb15.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb15.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb15;
            lstPlnt.add(pb15);
            AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
            pb16.Benefit_Name__c = 'Deductible_Individual';
            pb16.Record_Type__c = 'BRF';
            pb16.Type__c = 'Cost Share';
            pb16.Benefit_Group__c = pg2.id;
            pb16.Cost_Share_Low__c = '0';
            pb16.Cost_Share_High__c = '100';
            pb16.Cost_Share_Increment__c = '10';
            pb16.Cost_Share_Default_Amount__c = '40';
            pb16.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb16.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb16;
            lstPlnt.add(pb16);
            
            insert lstPlnt;
            
            AIA_Plan_Benefits__c pb17 = new AIA_Plan_Benefits__c();
            pb17.Benefit_Name__c = 'Deductible_Family';
            pb17.Record_Type__c = 'BRF';
            pb17.Type__c = 'Cost Share';
            pb17.Benefit_Group__c = pg2.id;
            pb17.Cost_Share_Low__c = '0';
            pb17.Cost_Share_High__c = '100';
            pb17.Cost_Share_Increment__c = '10';
            pb17.Cost_Share_Default_Amount__c = '40';
            pb17.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb17.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb17;
            lstPlnt.add(pb17);
            
           // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb18 = new AIA_Plan_Benefits__c();
            pb18.Benefit_Name__c = 'Deductible_Single';
            pb18.Record_Type__c = 'BRF';
            pb18.Type__c = 'Cost Share';
            pb18.Benefit_Group__c = pg2.id;
            pb18.Cost_Share_Low__c = '0';
            pb18.Cost_Share_High__c = '100';
            pb18.Cost_Share_Increment__c = '10';
            pb18.Cost_Share_Default_Amount__c = '40';
            pb18.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb18.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb18;
           lstPlnt.add(pb18);
           
         //  insert lstPlnt;
            
            AIA_Plan_Benefits__c pb19 = new AIA_Plan_Benefits__c();
            pb19.Benefit_Name__c = 'DeductibleCarryOver';
            pb19.Record_Type__c = 'BRF';
            pb19.Type__c = 'Cost Share';
            pb19.Benefit_Group__c = pg2.id;
            pb19.Cost_Share_Low__c = '0';
            pb19.Cost_Share_High__c = '100';
            pb19.Cost_Share_Increment__c = '10';
            pb19.Cost_Share_Default_Amount__c = '40';
            pb19.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb19.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb19;
           lstPlnt.add(pb19);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb20 = new AIA_Plan_Benefits__c();
            pb20.Benefit_Name__c = 'LifetimeMax_Single';
            pb20.Record_Type__c = 'BRF';
            pb20.Type__c = 'Cost Share';
            pb20.Benefit_Group__c = pg2.id;
            pb20.Cost_Share_Low__c = '0';
            pb20.Cost_Share_High__c = '100';
            pb20.Cost_Share_Increment__c = '10';
            pb20.Cost_Share_Default_Amount__c = '40';
            pb20.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb20.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb20;
            lstPlnt.add(pb20);
            
          //  insert lstPlnt;
            
            
            AIA_Plan_Benefits__c pb21 = new AIA_Plan_Benefits__c();
            pb21.Benefit_Name__c = 'Copay_PCPCopay';
            pb21.Record_Type__c = 'BRF';
            pb21.Type__c = 'Cost Share';
            pb21.Benefit_Group__c = pg2.id;
            pb21.Cost_Share_Low__c = '0';
            pb21.Cost_Share_High__c = '100';
            pb21.Cost_Share_Increment__c = '10';
            pb21.Cost_Share_Default_Amount__c = '40';
            pb21.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb21.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb21;
           lstPlnt.add(pb21);
           
          // insert  lstPlnt;
            
            AIA_Plan_Benefits__c pb22 = new AIA_Plan_Benefits__c();
            pb22.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb22.Record_Type__c = 'BRF';
            pb22.Type__c = 'Cost Share';
            pb22.Benefit_Group__c = pg2.id;
            pb22.Cost_Share_Low__c = '0';
            pb22.Cost_Share_High__c = '100';
            pb22.Cost_Share_Increment__c = '10';
            pb22.Cost_Share_Default_Amount__c = '40';
            pb22.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb22.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb22;
           lstPlnt.add(pb22);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb23 = new AIA_Plan_Benefits__c();
            pb23.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb23.Record_Type__c = 'BRF';
            pb23.Type__c = 'Cost Share';
            pb23.Benefit_Group__c = pg2.id;
            pb23.Cost_Share_Low__c = '0';
            pb23.Cost_Share_High__c = '100';
            pb23.Cost_Share_Increment__c = '10';
            pb23.Cost_Share_Default_Amount__c = '40';
            pb23.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb23.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb23;    
           lstPlnt.add(pb22);
           
         //  insert lstPlnt;
               
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
            
            AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
            apc30.Plan_Benefits__c = pb29.id;
            apc30.AliasName__c = 'General Copay';
            apc30.CopayAmount__c = '200';
            apc30.CoinsuranceAmount__c = '50';
            apc30.MinPayAmount__c = '90';
            apc30.MaxPayAmount__c = '80';
            apc30.IsCovered__c = 'Yes';
            apc30.DeductibleApplies__c = 'No';  
            apc30.MandateIndicator__c = 'Yes';          
            apc30.Jurisdiction__c = 'Test';            
            apc30.MandateName__c='PPACA mandate';
            apc30.ExtID__c = 'rwuifghqierufghaire';
            insert apc30;
        
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
            
          // pbc.IsMandateTrue__c ='Yes';
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
          //mod 
          
     
     //mod
            
            //system.debug('ppd id medical'+pp1);
     Proposed_Products__c pp1 = new Proposed_Products__c();           
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp1.Benefit_Request_Form__c =brf.id;
            pp1.Funding_Arrangement__c = 'ASO';
            pp1.Product_Category__c = 'Drug';
            pp1.Product_Line__c = 'pp1O';
           pp1.Plan_Name__c = aiapln.id;
            pp1.Product_Name__c = 'BlueChoice Advantage';
            pp1.CDH__c = 'Yes';
            pp1.CDH_Fund_Type__c = 'BlueFund';
            pp1.CDH_Type__c = 'HSA';
            pp1.Deductible__c = 'Stacked';
            pp1.Grandfathered_Status__c = 'Grandfathered';
            pp1.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp1.Blue_Rewards__c = 'No';
            pp1.Out_of_Pocket_Max__c = 'Stacked';
           // pp1.Jurisdiction__c = 'MD';
            pp1.Has_Benefit_Details__c = false;
            pp1.Exclusive_Specialty_Provider_Network__c='Yes';
            pp1.RX_OOP_Max_Integration__c='Integrated';
            insert pp1;
           Proposed_Products__c pp = new Proposed_Products__c();           
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.id;
            pp.Funding_Arrangement__c = 'ASO';
            pp.Product_Category__c = 'Drug';
            pp.Product_Line__c = 'PPO';
           pp.Plan_Name__c = aiapln.id;
            pp.Product_Name__c = 'BlueChoice Advantage';
            pp.CDH__c = 'Yes';
            pp.CDH_Fund_Type__c = 'BlueFund';
            pp.Related_Medical_Product__c=pp1.id;
            pp.Exclusive_Specialty_Provider_Network__c='Yes';
            pp.CDH_Type__c = 'HSA';
            pp.Deductible__c = 'Stacked';
            pp.Grandfathered_Status__c = 'Grandfathered';
            pp.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp.Grandfathered_PPACA_Status__c = 'No';
            pp.Blue_Rewards__c = 'No';
            pp.Out_of_Pocket_Max__c = 'Stacked';
     pp.RX_OOP_Max_Integration__c='Integrated';
           // pp.Jurisdiction__c = 'MD';
            pp.Has_Benefit_Details__c = false;
            insert pp;
                 system.debug('ppd id drug pp'+pp);
 
     Proposed_Products__c pp2 = new Proposed_Products__c();           
            pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp2.Benefit_Request_Form__c =brf.id;
            pp2.Funding_Arrangement__c = 'ASO';
            pp2.Product_Category__c = 'Drug';
            pp2.Product_Line__c = 'pp2O';
           pp2.Plan_Name__c = aiapln.id;
            pp2.Product_Name__c = 'BlueChoice Advantage';
            pp2.CDH__c = 'Yes';
            pp2.CDH_Fund_Type__c = 'BlueFund';
          pp2.Related_Medical_Product__c=pp.id;
            pp2.CDH_Type__c = 'HSA';
            pp2.Deductible__c = 'Stacked';
            pp2.Grandfathered_Status__c = 'Grandfathered';
            pp2.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp2.Grandfathered_ppACA_Status__c = 'No';
            pp2.Blue_Rewards__c = 'No';
            pp2.Out_of_Pocket_Max__c = 'Stacked';
           // pp2.Jurisdiction__c = 'MD';
            pp2.Has_Benefit_Details__c = false;
            pp2.Exclusive_Specialty_Provider_Network__c='Yes';
          pp2.RX_OOP_Max_Integration__c='Integrated';

            insert pp2;
     
                 system.debug('ppd id medical1'+pp2);

     
     //mod offshore

     AIA_Grouper__c ag = new AIA_Grouper__c();
      ag.Name = 'CostShareRanges';
      ag.Group_Type__c = 'Cost Share Group';
      ag.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag.Proposed_Products__c = pp.id;
  insert ag;
     AIA_Grouper__c ag1 = new AIA_Grouper__c();
      ag1.Name = 'CostShareRanges';
      ag1.Group_Type__c = 'Cost Share Group';
      ag1.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag1.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag1.Proposed_Products__c = pp2.id;
  insert ag1;
  AIA_Benefits__c ab = new AIA_Benefits__c();
      ab.Grouper__c = ag.id;
     ab.IS_ASO_Only__c=false;
      ab.Benefit_Name__c = 'Family Deductible';
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
      ab.Copay_Type_1_High__c='100';
      ab.Copay_Type_1_Low__c='200';
      ab.Copay_Type_1_Increment__c='300';
      ab.Copay_Type_1_Additional_Increments__c='400';
      ab.Copay_Type_1_AdditionalInvalidIncrements__c='500';
      ab.Copay_Type_1_AmountValueSelected__c='600';
      ab.Copay_Type_2_High__c='100';
      ab.Copay_Type_2_Low__c='200';
      ab.Copay_Type_2_Increment__c='300';
      ab.Copay_Type_2_Additional_Increments__c='400';
      ab.CopayType2_Additional_InvalidIncrement__c='500';
      ab.Copay_Type_2_AmountValueSelected__c='600';
      ab.OON_Copay_AmountHigh__c='100';
      ab.OON_Copay_AmountLow__c='200';
      ab.OON_Copay2_Increment__c='300';
      ab.OON_Copay_Additional_Increments__c='400';
      ab.OON_Copay_Additional_InvalidIncrements__c='500';
      ab.OON_Copay_Type_1_AmountValueSelected__c='600';
          ab.OON_Copay2_High__c='100';
      ab.OON_Copay2_Low__c='200';
      ab.OON_Copay2_Increment__c='300';
      ab.OON_Copay_Type_2_Additional_Increments__c='400';
      ab.OON_Copay2Additional_InvalidIncrements__c='500';
      ab.OON_Copay_Type_2_AmountValueSelected__c='600';
          ab.Cost_Share_High__c='100';
      ab.Cost_Share_Low__c='200';
      ab.Cost_Share_Increment__c='300';
      ab.Cost_Share_AdditionalIncrements__c='400';
      ab.Cost_Share_InvalidIncrements__c='500';
      ab.Cost_Share_SelectedAmount__c='600';
          ab.OON_Cost_Share_High__c='100';
      ab.OON_Cost_Share_Low__c='200';
      ab.OON_Cost_Share_Increment__c='300';
      ab.OON_Cost_Share_AdditionalIncrements__c='400';
      ab.OON_Cost_Share_InvalidIncrements__c='500';
      ab.OON_Cost_Share_SelectedAmount__c='600';
          ab.Coinsurance_AmountHigh__c='100';
      ab.Coinsurance_AmountLow__c='200';
      ab.Coinsurance_AmountIncrement__c='300';
      ab.Coinsurance_Amount_AddtionalIncrements__c='400';
      ab.Coinsurance_Amount_InvalidIncrements__c='500';
      ab.CoInsurance_AmountValueSelected__c='600';
          ab.OON_Coinsurance_AmountHigh__c='100';
      ab.OON_Coinsurance_AmountLow__c='200';
      ab.OON_Coinsurance_AmountIncrement__c='300';
      ab.OON_Coinsurance_AddtionalIncrements__c='400';
      ab.OON_Coinsurance_InvalidIncrements__c='500';
      ab.OON_CoInsurance_AmountValueSelected__c='600';
        ab.IN_CostShare_3Month_DedCarryover_Default__c='Yes';
          ab.IN_CostShare_3Month_DeductibleCarryover__c='No';
      insert ab; 
          
          ab.Cost_Share_SelectedAmount__c='101';
          update ab;
     
     AIA_Benefits__c ab1 = new AIA_Benefits__c();
      ab1.Grouper__c = ag.id;
     ab1.IS_ASO_Only__c=false;
      ab1.Benefit_Name__c = 'Individual Out Of Pocket';
      ab1.Benefit_Type__c = 'Benefit';
      ab1.Copay_Type_1_Mandate_Name__c = 'Test';
      ab1.Type__c = 'Cost Share';
      ab1.Benefit_Record_Type__c = 'BRF';
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
      ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
      ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
      ab1.Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.Copay_Type_2_AliasName__c = 'Test';
      ab1.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.OON_Copay_Type_2_AliasName__c = 'Test';
      ab1.IsAppGlobalCopay__c = true;
      ab1.Copay_Type_1_High__c='100';
      ab1.Copay_Type_1_Low__c='200';
      ab1.Copay_Type_1_Increment__c='300';
      ab1.Copay_Type_1_Additional_Increments__c='400';
      ab1.Copay_Type_1_AdditionalInvalidIncrements__c='500';
      ab1.Copay_Type_1_AmountValueSelected__c='600';
      ab1.Copay_Type_2_High__c='100';
      ab1.Copay_Type_2_Low__c='200';
      ab1.Copay_Type_2_Increment__c='300';
      ab1.Copay_Type_2_Additional_Increments__c='400';
      ab1.CopayType2_Additional_InvalidIncrement__c='500';
      ab1.Copay_Type_2_AmountValueSelected__c='600';
      ab1.OON_Copay_AmountHigh__c='100';
      ab1.OON_Copay_AmountLow__c='200';
      ab1.OON_Copay2_Increment__c='300';
      ab1.OON_Copay_Additional_Increments__c='400';
      ab1.OON_Copay_Additional_InvalidIncrements__c='500';
      ab1.OON_Copay_Type_1_AmountValueSelected__c='600';
          ab1.OON_Copay2_High__c='100';
      ab1.OON_Copay2_Low__c='200';
      ab1.OON_Copay2_Increment__c='300';
      ab1.OON_Copay_Type_2_Additional_Increments__c='400';
      ab1.OON_Copay2Additional_InvalidIncrements__c='500';
      ab1.OON_Copay_Type_2_AmountValueSelected__c='600';
          ab1.Cost_Share_High__c='100';
      ab1.Cost_Share_Low__c='200';
      ab1.Cost_Share_Increment__c='300';
      ab1.Cost_Share_AdditionalIncrements__c='400';
      ab1.Cost_Share_InvalidIncrements__c='500';
      ab1.Cost_Share_SelectedAmount__c='600';
          ab1.OON_Cost_Share_High__c='100';
      ab1.OON_Cost_Share_Low__c='200';
      ab1.OON_Cost_Share_Increment__c='300';
      ab1.OON_Cost_Share_AdditionalIncrements__c='400';
      ab1.OON_Cost_Share_InvalidIncrements__c='500';
      ab1.OON_Cost_Share_SelectedAmount__c='600';
          ab1.Coinsurance_AmountHigh__c='100';
      ab1.Coinsurance_AmountLow__c='200';
      ab1.Coinsurance_AmountIncrement__c='300';
      ab1.Coinsurance_Amount_AddtionalIncrements__c='400';
      ab1.Coinsurance_Amount_InvalidIncrements__c='500';
      ab1.CoInsurance_AmountValueSelected__c='600';
          ab1.OON_Coinsurance_AmountHigh__c='100';
      ab1.OON_Coinsurance_AmountLow__c='200';
      ab1.OON_Coinsurance_AmountIncrement__c='300';
      ab1.OON_Coinsurance_AddtionalIncrements__c='400';
      ab1.OON_Coinsurance_InvalidIncrements__c='500';
      ab1.OON_CoInsurance_AmountValueSelected__c='600';
        ab1.IN_CostShare_3Month_DedCarryover_Default__c='Yes';
          ab1.IN_CostShare_3Month_DeductibleCarryover__c='No';
      insert ab1; 
ab1.Cost_Share_SelectedAmount__c='101';
          update ab1;
     Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Maxrow');
  insert lmt;
     
     
        AIA_BenefitTriggerHandler.disableAdjustmentsOnInserts();
        AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();

test.starttest();  
           PageReference pref = Page.AIA_ProposedProd_Summary;
           Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
         //Commenting as part of US1650
         //ext.getPCSdata();
        ext.mainInit();
           ext.createWrapListFromPlan(pp);
        ext.createWrapListFromPlanCostShr(aiapln.id);
               AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();
    AIA_BenefitTriggerHelperClass.validateCopayValues('2','3','4','5','6','7');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','7','4','5','6','3');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','4','5','6','3');
          AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','3','5','6','3');


        ext.saveAndCon();
        ext.addPlan();
        ext.saveandRedirct();
        ext.reviewInit();
       
        ext.back();
     
test.stoptest();            
    }
    public Static TestMethod void TestAIA_Benefit_CreationdisableOutOfRangeValuesIndividualDeductible(){
    
       //Commenting as part of US210 
       /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
          insert wpt;*/
       
          Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        AIA_BenefittriggerHandlerHelper_Test.createAccountTeamMembers(acc.Id);
       
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
       
       
       
       
      Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
     brf.Enrollment_Type__c='Cafeteria';
     brf.Exclusive_Specialty_Provider_Network__c='Yes';
  insert brf;
       AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
          aiapln.Has_Benefit_Summary__c = True;
          aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
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
       List<AIA_Plan_Grouper__c> lstGrp = new List<AIA_Plan_Grouper__c>();
          AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
            pg.Name = 'CostShareRanges';
            pg.Plan_Network__c = pn.id;
            pg.Type__c = 'Cost Share Group';
            pg.Record_Type__c = 'BRF';
            pg.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00';
            pg.IsCovered__c='Yes';
            
            //insert pg;
          lstGrp.add(pg);
            
           AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
            pg2.Name = 'CostShareRanges';
            pg2.Plan_Network__c = pn2.id;
            pg2.Type__c = 'Cost Share Group';
            pg2.Record_Type__c = 'BRF';
            pg2.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002';
            pg2.IsCovered__c='No';

         //   insert pg2;
         lstGrp.add(pg2);
            
            AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
            pg3.Name = 'Medical Supplies/Equipment-0628';
            pg3.Plan_Network__c = pn.id;
            pg3.Type__c = 'Benefit Group';
            pg3.Sequence_Number__c = 1;
            pg3.Record_Type__c = 'BRF';
            pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
            pg3.IsCovered__c='No';

           // insert pg3;
          lstGrp.add(pg3);
            
            AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
            pg4.Name = 'Medical Supplies/Equipment-0629';
            pg4.Plan_Network__c = pn2.id;
            pg4.Type__c = 'Benefit Group';
            pg4.Sequence_Number__c = 1;
            pg4.Record_Type__c = 'BRF';
            pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
            pg4.IsCovered__c='Yes';

            //insert pg4;
           lstGrp.add(pg4);
           
           insert lstGrp;
           
          List<AIA_Plan_Benefits__c> lstPlnt = new List<AIA_Plan_Benefits__c>();
           AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
            pb.Benefit_Name__c = 'OutOfPocket_Individual';
            pb.Record_Type__c = 'BRF';
            pb.Type__c = 'Benefit';
            pb.Benefit_Group__c = pg3.id;
            pb.Cost_Share_Low__c = '0';
            pb.Cost_Share_High__c = '100';
            pb.Cost_Share_Increment__c = '10';
            pb.Cost_Share_Default_Amount__c = '40';
            pb.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb.Cost_Share_InvalidIncrements__c = '20, 30';
            pb.Sequence_Number__c = 1;
            //insert pb;
            lstPlnt.add(pb);
        
        AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
            pb29.Benefit_Name__c = '';
            pb29.Record_Type__c = 'BRF';
            pb29.Type__c = 'Benefit';
            pb29.Benefit_Group__c = pg4.id;
            pb29.Cost_Share_Low__c = '0';
            pb29.Cost_Share_High__c = '100';
            pb29.Cost_Share_Increment__c = '10';
            pb29.Cost_Share_Default_Amount__c = '40';
            pb29.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb29.Cost_Share_InvalidIncrements__c = '20, 30';
            pb29.Sequence_Number__c = 1;
           // insert pb29;
           lstPlnt.add(pb29);
          
          AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
            pb2.Benefit_Name__c = 'OutOfPocket_Family';
            pb2.Record_Type__c = 'BRF';
            pb2.Type__c = 'Cost Share';
            pb2.Benefit_Group__c = pg.id;
            pb2.Cost_Share_Low__c = '0';
            pb2.Cost_Share_High__c = '100';
            pb2.Cost_Share_Increment__c = '10';
            pb2.Cost_Share_Default_Amount__c = '40';
            pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb2.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb2;
          lstPlnt.add(pb2);
        
            AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
            pb3.Benefit_Name__c = 'OutOfPocket_Single';
            pb3.Record_Type__c = 'BRF';
            pb3.Type__c = 'Cost Share';
            pb3.Benefit_Group__c = pg.id;
            pb3.Cost_Share_Low__c = '0';
            pb3.Cost_Share_High__c = '100';
            pb3.Cost_Share_Increment__c = '10';
            pb3.Cost_Share_Default_Amount__c = '40';
            pb3.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb3.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb3;
           lstPlnt.add(pb3); 
            AIA_Plan_Benefits__c pb4 = new AIA_Plan_Benefits__c();
            pb4.Benefit_Name__c = 'Deductible_Individual';
            pb4.Record_Type__c = 'BRF';
            pb4.Type__c = 'Cost Share';
            pb4.Benefit_Group__c = pg.id;
            pb4.Cost_Share_Low__c = '0';
            pb4.Cost_Share_High__c = '100';
            pb4.Cost_Share_Increment__c = '10';
            pb4.Cost_Share_Default_Amount__c = '40';
            pb4.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb4.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb4;
            lstPlnt.add(pb4); 
            
            AIA_Plan_Benefits__c pb5 = new AIA_Plan_Benefits__c();
            pb5.Benefit_Name__c = 'Deductible_Family';
            pb5.Record_Type__c = 'BRF';
            pb5.Type__c = 'Cost Share';
            pb5.Benefit_Group__c = pg.id;
            pb5.Cost_Share_Low__c = '0';
            pb5.Cost_Share_High__c = '100';
            pb5.Cost_Share_Increment__c = '10';
            pb5.Cost_Share_Default_Amount__c = '40';
            pb5.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb5.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb5;
           lstPlnt.add(pb5);
            
            AIA_Plan_Benefits__c pb6 = new AIA_Plan_Benefits__c();
            pb6.Benefit_Name__c = 'Deductible_Single';
            pb6.Record_Type__c = 'BRF';
            pb6.Type__c = 'Cost Share';
            pb6.Benefit_Group__c = pg.id;
            pb6.Cost_Share_Low__c = '0';
            pb6.Cost_Share_High__c = '100';
            pb6.Cost_Share_Increment__c = '10';
            pb6.Cost_Share_Default_Amount__c = '40';
            pb6.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb6.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb6;
           lstPlnt.add(pb6);
            
            AIA_Plan_Benefits__c pb7 = new AIA_Plan_Benefits__c();
            pb7.Benefit_Name__c = 'DeductibleCarryOver';
            pb7.Record_Type__c = 'BRF';
            pb7.Type__c = 'Cost Share';
            pb7.Benefit_Group__c = pg.id;
            pb7.Cost_Share_Low__c = '0';
            pb7.Cost_Share_High__c = '100';
            pb7.Cost_Share_Increment__c = '10';
            pb7.Cost_Share_Default_Amount__c = '40';
            pb7.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb7.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb7;
            lstPlnt.add(pb7);
            AIA_Plan_Benefits__c pb8 = new AIA_Plan_Benefits__c();
            pb8.Benefit_Name__c = 'LifetimeMax_Single';
            pb8.Record_Type__c = 'BRF';
            pb8.Type__c = 'Cost Share';
            pb8.Benefit_Group__c = pg.id;
            pb8.Cost_Share_Low__c = '0';
            pb8.Cost_Share_High__c = '100';
            pb8.Cost_Share_Increment__c = '10';
            pb8.Cost_Share_Default_Amount__c = '40';
            pb8.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb8.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb8;
             lstPlnt.add(pb8);
            AIA_Plan_Benefits__c pb9 = new AIA_Plan_Benefits__c();
            pb9.Benefit_Name__c = 'Copay_PCPCopay';
            pb9.Record_Type__c = 'BRF';
            pb9.Type__c = 'Cost Share';
            pb9.Benefit_Group__c = pg.id;
            pb9.Cost_Share_Low__c = '0';
            pb9.Cost_Share_High__c = '100';
            pb9.Cost_Share_Increment__c = '10';
            pb9.Cost_Share_Default_Amount__c = '40';
            pb9.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb9.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb9;
            lstPlnt.add(pb9);
            AIA_Plan_Benefits__c pb10 = new AIA_Plan_Benefits__c();
            pb10.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb10.Record_Type__c = 'BRF';
            pb10.Type__c = 'Cost Share';
            pb10.Benefit_Group__c = pg.id;
            pb10.Cost_Share_Low__c = '0';
            pb10.Cost_Share_High__c = '100';
            pb10.Cost_Share_Increment__c = '10';
            pb10.Cost_Share_Default_Amount__c = '40';
            pb10.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb10.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb10;
            lstPlnt.add(pb10);
            
            AIA_Plan_Benefits__c pb11 = new AIA_Plan_Benefits__c();
            pb11.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb11.Record_Type__c = 'BRF';
            pb11.Type__c = 'Cost Share';
            pb11.Benefit_Group__c = pg.id;
            pb11.Cost_Share_Low__c = '0';
            pb11.Cost_Share_High__c = '100';
            pb11.Cost_Share_Increment__c = '10';
            pb11.Cost_Share_Default_Amount__c = '40';
            pb11.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb11.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb11;
           lstPlnt.add(pb11);
            
            AIA_Plan_Benefits__c pb13 = new AIA_Plan_Benefits__c();
            pb13.Benefit_Name__c = 'OutOfPocket_Individual';
            pb13.Record_Type__c = 'BRF';
            pb13.Type__c = 'Cost Share';
            pb13.Benefit_Group__c = pg2.id;
            pb13.Cost_Share_Low__c = '0';
            pb13.Cost_Share_High__c = '100';
            pb13.Cost_Share_Increment__c = '10';
            pb13.Cost_Share_Default_Amount__c = '40';
            pb13.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb13.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb13;
            lstPlnt.add(pb13);
            AIA_Plan_Benefits__c pb14 = new AIA_Plan_Benefits__c();
            pb14.Benefit_Name__c = 'OutOfPocket_Family';
            pb14.Record_Type__c = 'BRF';
            pb14.Type__c = 'Cost Share';
            pb14.Benefit_Group__c = pg2.id;
            pb14.Cost_Share_Low__c = '0';
            pb14.Cost_Share_High__c = '100';
            pb14.Cost_Share_Increment__c = '10';
            pb14.Cost_Share_Default_Amount__c = '40';
            pb14.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb14.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb14;
            lstPlnt.add(pb14);
            AIA_Plan_Benefits__c pb15 = new AIA_Plan_Benefits__c();
            pb15.Benefit_Name__c = 'OutOfPocket_Single';
            pb15.Record_Type__c = 'BRF';
            pb15.Type__c = 'Cost Share';
            pb15.Benefit_Group__c = pg2.id;
            pb15.Cost_Share_Low__c = '0';
            pb15.Cost_Share_High__c = '100';
            pb15.Cost_Share_Increment__c = '10';
            pb15.Cost_Share_Default_Amount__c = '40';
            pb15.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb15.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb15;
            lstPlnt.add(pb15);
            AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
            pb16.Benefit_Name__c = 'Deductible_Individual';
            pb16.Record_Type__c = 'BRF';
            pb16.Type__c = 'Cost Share';
            pb16.Benefit_Group__c = pg2.id;
            pb16.Cost_Share_Low__c = '0';
            pb16.Cost_Share_High__c = '100';
            pb16.Cost_Share_Increment__c = '10';
            pb16.Cost_Share_Default_Amount__c = '40';
            pb16.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb16.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb16;
            lstPlnt.add(pb16);
            
            insert lstPlnt;
            
            AIA_Plan_Benefits__c pb17 = new AIA_Plan_Benefits__c();
            pb17.Benefit_Name__c = 'Deductible_Family';
            pb17.Record_Type__c = 'BRF';
            pb17.Type__c = 'Cost Share';
            pb17.Benefit_Group__c = pg2.id;
            pb17.Cost_Share_Low__c = '0';
            pb17.Cost_Share_High__c = '100';
            pb17.Cost_Share_Increment__c = '10';
            pb17.Cost_Share_Default_Amount__c = '40';
            pb17.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb17.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb17;
            lstPlnt.add(pb17);
            
           // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb18 = new AIA_Plan_Benefits__c();
            pb18.Benefit_Name__c = 'Deductible_Single';
            pb18.Record_Type__c = 'BRF';
            pb18.Type__c = 'Cost Share';
            pb18.Benefit_Group__c = pg2.id;
            pb18.Cost_Share_Low__c = '0';
            pb18.Cost_Share_High__c = '100';
            pb18.Cost_Share_Increment__c = '10';
            pb18.Cost_Share_Default_Amount__c = '40';
            pb18.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb18.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb18;
           lstPlnt.add(pb18);
           
         //  insert lstPlnt;
            
            AIA_Plan_Benefits__c pb19 = new AIA_Plan_Benefits__c();
            pb19.Benefit_Name__c = 'DeductibleCarryOver';
            pb19.Record_Type__c = 'BRF';
            pb19.Type__c = 'Cost Share';
            pb19.Benefit_Group__c = pg2.id;
            pb19.Cost_Share_Low__c = '0';
            pb19.Cost_Share_High__c = '100';
            pb19.Cost_Share_Increment__c = '10';
            pb19.Cost_Share_Default_Amount__c = '40';
            pb19.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb19.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb19;
           lstPlnt.add(pb19);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb20 = new AIA_Plan_Benefits__c();
            pb20.Benefit_Name__c = 'LifetimeMax_Single';
            pb20.Record_Type__c = 'BRF';
            pb20.Type__c = 'Cost Share';
            pb20.Benefit_Group__c = pg2.id;
            pb20.Cost_Share_Low__c = '0';
            pb20.Cost_Share_High__c = '100';
            pb20.Cost_Share_Increment__c = '10';
            pb20.Cost_Share_Default_Amount__c = '40';
            pb20.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb20.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb20;
            lstPlnt.add(pb20);
            
          //  insert lstPlnt;
            
            
            AIA_Plan_Benefits__c pb21 = new AIA_Plan_Benefits__c();
            pb21.Benefit_Name__c = 'Copay_PCPCopay';
            pb21.Record_Type__c = 'BRF';
            pb21.Type__c = 'Cost Share';
            pb21.Benefit_Group__c = pg2.id;
            pb21.Cost_Share_Low__c = '0';
            pb21.Cost_Share_High__c = '100';
            pb21.Cost_Share_Increment__c = '10';
            pb21.Cost_Share_Default_Amount__c = '40';
            pb21.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb21.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb21;
           lstPlnt.add(pb21);
           
          // insert  lstPlnt;
            
            AIA_Plan_Benefits__c pb22 = new AIA_Plan_Benefits__c();
            pb22.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb22.Record_Type__c = 'BRF';
            pb22.Type__c = 'Cost Share';
            pb22.Benefit_Group__c = pg2.id;
            pb22.Cost_Share_Low__c = '0';
            pb22.Cost_Share_High__c = '100';
            pb22.Cost_Share_Increment__c = '10';
            pb22.Cost_Share_Default_Amount__c = '40';
            pb22.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb22.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb22;
           lstPlnt.add(pb22);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb23 = new AIA_Plan_Benefits__c();
            pb23.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb23.Record_Type__c = 'BRF';
            pb23.Type__c = 'Cost Share';
            pb23.Benefit_Group__c = pg2.id;
            pb23.Cost_Share_Low__c = '0';
            pb23.Cost_Share_High__c = '100';
            pb23.Cost_Share_Increment__c = '10';
            pb23.Cost_Share_Default_Amount__c = '40';
            pb23.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb23.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb23;    
           lstPlnt.add(pb22);
           
         //  insert lstPlnt;
               
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
            
            AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
            apc30.Plan_Benefits__c = pb29.id;
            apc30.AliasName__c = 'General Copay';
            apc30.CopayAmount__c = '200';
            apc30.CoinsuranceAmount__c = '50';
            apc30.MinPayAmount__c = '90';
            apc30.MaxPayAmount__c = '80';
            apc30.IsCovered__c = 'Yes';
            apc30.DeductibleApplies__c = 'No';  
            apc30.MandateIndicator__c = 'Yes';          
            apc30.Jurisdiction__c = 'Test';            
            apc30.MandateName__c='PPACA mandate';
            apc30.ExtID__c = 'rwuifghqierufghaire';
            insert apc30;
        
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
            
          // pbc.IsMandateTrue__c ='Yes';
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
          //mod 
          
     
     //mod
            
            //system.debug('ppd id medical'+pp1);
     Proposed_Products__c pp1 = new Proposed_Products__c();           
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp1.Benefit_Request_Form__c =brf.id;
            pp1.Funding_Arrangement__c = 'ASO';
            pp1.Product_Category__c = 'Drug';
            pp1.Product_Line__c = 'pp1O';
           pp1.Plan_Name__c = aiapln.id;
            pp1.Product_Name__c = 'BlueChoice Advantage';
            pp1.CDH__c = 'Yes';
            pp1.CDH_Fund_Type__c = 'BlueFund';
            pp1.CDH_Type__c = 'HSA';
            pp1.Deductible__c = 'Stacked';
            pp1.Grandfathered_Status__c = 'Grandfathered';
            pp1.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp1.Blue_Rewards__c = 'No';
            pp1.Out_of_Pocket_Max__c = 'Stacked';
           // pp1.Jurisdiction__c = 'MD';
            pp1.Has_Benefit_Details__c = false;
            pp1.Exclusive_Specialty_Provider_Network__c='Yes';
            pp1.RX_OOP_Max_Integration__c='Integrated';
            insert pp1;
           Proposed_Products__c pp = new Proposed_Products__c();           
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.id;
            pp.Funding_Arrangement__c = 'ASO';
            pp.Product_Category__c = 'Drug';
            pp.Product_Line__c = 'PPO';
           pp.Plan_Name__c = aiapln.id;
            pp.Product_Name__c = 'BlueChoice Advantage';
            pp.CDH__c = 'Yes';
            pp.CDH_Fund_Type__c = 'BlueFund';
            pp.Related_Medical_Product__c=pp1.id;
            pp.Exclusive_Specialty_Provider_Network__c='Yes';
            pp.CDH_Type__c = 'HSA';
            pp.Deductible__c = 'Stacked';
            pp.Grandfathered_Status__c = 'Grandfathered';
            pp.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp.Grandfathered_PPACA_Status__c = 'No';
            pp.Blue_Rewards__c = 'No';
            pp.Out_of_Pocket_Max__c = 'Stacked';
     pp.RX_OOP_Max_Integration__c='Integrated';
           // pp.Jurisdiction__c = 'MD';
            pp.Has_Benefit_Details__c = false;
            insert pp;
                 system.debug('ppd id drug pp'+pp);
 
     Proposed_Products__c pp2 = new Proposed_Products__c();           
            pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp2.Benefit_Request_Form__c =brf.id;
            pp2.Funding_Arrangement__c = 'ASO';
            pp2.Product_Category__c = 'Drug';
            pp2.Product_Line__c = 'pp2O';
           pp2.Plan_Name__c = aiapln.id;
            pp2.Product_Name__c = 'BlueChoice Advantage';
            pp2.CDH__c = 'Yes';
            pp2.CDH_Fund_Type__c = 'BlueFund';
          pp2.Related_Medical_Product__c=pp.id;
            pp2.CDH_Type__c = 'HSA';
            pp2.Deductible__c = 'Stacked';
            pp2.Grandfathered_Status__c = 'Grandfathered';
            pp2.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp2.Grandfathered_ppACA_Status__c = 'No';
            pp2.Blue_Rewards__c = 'No';
            pp2.Out_of_Pocket_Max__c = 'Stacked';
           // pp2.Jurisdiction__c = 'MD';
            pp2.Has_Benefit_Details__c = false;
            pp2.Exclusive_Specialty_Provider_Network__c='Yes';
          pp2.RX_OOP_Max_Integration__c='Integrated';

            insert pp2;
     
                 system.debug('ppd id medical1'+pp2);

     
     //mod offshore

     AIA_Grouper__c ag = new AIA_Grouper__c();
      ag.Name = 'CostShareRanges';
      ag.Group_Type__c = 'Cost Share Group';
      ag.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag.Proposed_Products__c = pp.id;
  insert ag;
     AIA_Grouper__c ag1 = new AIA_Grouper__c();
      ag1.Name = 'CostShareRanges';
      ag1.Group_Type__c = 'Cost Share Group';
      ag1.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag1.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag1.Proposed_Products__c = pp2.id;
  insert ag1;
  AIA_Benefits__c ab = new AIA_Benefits__c();
      ab.Grouper__c = ag.id;
     ab.IS_ASO_Only__c=false;
      ab.Benefit_Name__c = 'Individual Deductible';
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
      ab.Copay_Type_1_High__c='100';
      ab.Copay_Type_1_Low__c='200';
      ab.Copay_Type_1_Increment__c='300';
      ab.Copay_Type_1_Additional_Increments__c='400';
      ab.Copay_Type_1_AdditionalInvalidIncrements__c='500';
      ab.Copay_Type_1_AmountValueSelected__c='600';
      ab.Copay_Type_2_High__c='100';
      ab.Copay_Type_2_Low__c='200';
      ab.Copay_Type_2_Increment__c='300';
      ab.Copay_Type_2_Additional_Increments__c='400';
      ab.CopayType2_Additional_InvalidIncrement__c='500';
      ab.Copay_Type_2_AmountValueSelected__c='600';
      ab.OON_Copay_AmountHigh__c='100';
      ab.OON_Copay_AmountLow__c='200';
      ab.OON_Copay2_Increment__c='300';
      ab.OON_Copay_Additional_Increments__c='400';
      ab.OON_Copay_Additional_InvalidIncrements__c='500';
      ab.OON_Copay_Type_1_AmountValueSelected__c='600';
          ab.OON_Copay2_High__c='100';
      ab.OON_Copay2_Low__c='200';
      ab.OON_Copay2_Increment__c='300';
      ab.OON_Copay_Type_2_Additional_Increments__c='400';
      ab.OON_Copay2Additional_InvalidIncrements__c='500';
      ab.OON_Copay_Type_2_AmountValueSelected__c='600';
          ab.Cost_Share_High__c='100';
      ab.Cost_Share_Low__c='200';
      ab.Cost_Share_Increment__c='300';
      ab.Cost_Share_AdditionalIncrements__c='400';
      ab.Cost_Share_InvalidIncrements__c='500';
      ab.Cost_Share_SelectedAmount__c='600';
          ab.OON_Cost_Share_High__c='100';
      ab.OON_Cost_Share_Low__c='200';
      ab.OON_Cost_Share_Increment__c='300';
      ab.OON_Cost_Share_AdditionalIncrements__c='400';
      ab.OON_Cost_Share_InvalidIncrements__c='500';
      ab.OON_Cost_Share_SelectedAmount__c='600';
          ab.Coinsurance_AmountHigh__c='100';
      ab.Coinsurance_AmountLow__c='200';
      ab.Coinsurance_AmountIncrement__c='300';
      ab.Coinsurance_Amount_AddtionalIncrements__c='400';
      ab.Coinsurance_Amount_InvalidIncrements__c='500';
      ab.CoInsurance_AmountValueSelected__c='600';
          ab.OON_Coinsurance_AmountHigh__c='100';
      ab.OON_Coinsurance_AmountLow__c='200';
      ab.OON_Coinsurance_AmountIncrement__c='300';
      ab.OON_Coinsurance_AddtionalIncrements__c='400';
      ab.OON_Coinsurance_InvalidIncrements__c='500';
      ab.OON_CoInsurance_AmountValueSelected__c='600';
        ab.IN_CostShare_3Month_DedCarryover_Default__c='Yes';
          ab.IN_CostShare_3Month_DeductibleCarryover__c='No';
      insert ab; 
          
          ab.Cost_Share_SelectedAmount__c='101';
          update ab;
     
     AIA_Benefits__c ab1 = new AIA_Benefits__c();
      ab1.Grouper__c = ag.id;
     ab1.IS_ASO_Only__c=false;
      ab1.Benefit_Name__c = 'Individual Out Of Pocket';
      ab1.Benefit_Type__c = 'Benefit';
      ab1.Copay_Type_1_Mandate_Name__c = 'Test';
      ab1.Type__c = 'Cost Share';
      ab1.Benefit_Record_Type__c = 'BRF';
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
      ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
      ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
      ab1.Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.Copay_Type_2_AliasName__c = 'Test';
      ab1.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.OON_Copay_Type_2_AliasName__c = 'Test';
      ab1.IsAppGlobalCopay__c = true;
      ab1.Copay_Type_1_High__c='100';
      ab1.Copay_Type_1_Low__c='200';
      ab1.Copay_Type_1_Increment__c='300';
      ab1.Copay_Type_1_Additional_Increments__c='400';
      ab1.Copay_Type_1_AdditionalInvalidIncrements__c='500';
      ab1.Copay_Type_1_AmountValueSelected__c='600';
      ab1.Copay_Type_2_High__c='100';
      ab1.Copay_Type_2_Low__c='200';
      ab1.Copay_Type_2_Increment__c='300';
      ab1.Copay_Type_2_Additional_Increments__c='400';
      ab1.CopayType2_Additional_InvalidIncrement__c='500';
      ab1.Copay_Type_2_AmountValueSelected__c='600';
      ab1.OON_Copay_AmountHigh__c='100';
      ab1.OON_Copay_AmountLow__c='200';
      ab1.OON_Copay2_Increment__c='300';
      ab1.OON_Copay_Additional_Increments__c='400';
      ab1.OON_Copay_Additional_InvalidIncrements__c='500';
      ab1.OON_Copay_Type_1_AmountValueSelected__c='600';
          ab1.OON_Copay2_High__c='100';
      ab1.OON_Copay2_Low__c='200';
      ab1.OON_Copay2_Increment__c='300';
      ab1.OON_Copay_Type_2_Additional_Increments__c='400';
      ab1.OON_Copay2Additional_InvalidIncrements__c='500';
      ab1.OON_Copay_Type_2_AmountValueSelected__c='600';
          ab1.Cost_Share_High__c='100';
      ab1.Cost_Share_Low__c='200';
      ab1.Cost_Share_Increment__c='300';
      ab1.Cost_Share_AdditionalIncrements__c='400';
      ab1.Cost_Share_InvalidIncrements__c='500';
      ab1.Cost_Share_SelectedAmount__c='600';
          ab1.OON_Cost_Share_High__c='100';
      ab1.OON_Cost_Share_Low__c='200';
      ab1.OON_Cost_Share_Increment__c='300';
      ab1.OON_Cost_Share_AdditionalIncrements__c='400';
      ab1.OON_Cost_Share_InvalidIncrements__c='500';
      ab1.OON_Cost_Share_SelectedAmount__c='600';
          ab1.Coinsurance_AmountHigh__c='100';
      ab1.Coinsurance_AmountLow__c='200';
      ab1.Coinsurance_AmountIncrement__c='300';
      ab1.Coinsurance_Amount_AddtionalIncrements__c='400';
      ab1.Coinsurance_Amount_InvalidIncrements__c='500';
      ab1.CoInsurance_AmountValueSelected__c='600';
          ab1.OON_Coinsurance_AmountHigh__c='100';
      ab1.OON_Coinsurance_AmountLow__c='200';
      ab1.OON_Coinsurance_AmountIncrement__c='300';
      ab1.OON_Coinsurance_AddtionalIncrements__c='400';
      ab1.OON_Coinsurance_InvalidIncrements__c='500';
      ab1.OON_CoInsurance_AmountValueSelected__c='600';
        ab1.IN_CostShare_3Month_DedCarryover_Default__c='Yes';
          ab1.IN_CostShare_3Month_DeductibleCarryover__c='No';
      insert ab1; 
ab1.Cost_Share_SelectedAmount__c='101';
          update ab1;
     Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Maxrow');
  insert lmt;
     
     
        AIA_BenefitTriggerHandler.disableAdjustmentsOnInserts();
        AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();

test.starttest();  
           PageReference pref = Page.AIA_ProposedProd_Summary;
           Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
         //Commenting as part of US1650
         //ext.getPCSdata();
        ext.mainInit();
           ext.createWrapListFromPlan(pp);
        ext.createWrapListFromPlanCostShr(aiapln.id);
               AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();
    AIA_BenefitTriggerHelperClass.validateCopayValues('2','3','4','5','6','7');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','7','4','5','6','3');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','4','5','6','3');
          AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','3','5','6','3');


        ext.saveAndCon();
        ext.addPlan();
        ext.saveandRedirct();
        ext.reviewInit();
       
        ext.back();
     
test.stoptest();            
    }
    
     public Static TestMethod void TestAIA_Benefit_Creationdisableintrgrated(){
    
       //Commenting as part of US210 
       /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
          insert wpt;*/
       
          Account acc = AIA_TestUtil.CreateAccount('TestAccount');
            AIA_BenefittriggerHandlerHelper_Test.createAccountTeamMembers(acc.Id);
       
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
       
       
       
       
      Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
     brf.Enrollment_Type__c='Cafeteria';
     brf.Exclusive_Specialty_Provider_Network__c='Yes';
  insert brf;
       AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
          aiapln.Has_Benefit_Summary__c = True;
          aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
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
       List<AIA_Plan_Grouper__c> lstGrp = new List<AIA_Plan_Grouper__c>();
          AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
            pg.Name = 'CostShareRanges';
            pg.Plan_Network__c = pn.id;
            pg.Type__c = 'Cost Share Group';
            pg.Record_Type__c = 'BRF';
            pg.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00';
            pg.IsCovered__c='Yes';
            
            //insert pg;
          lstGrp.add(pg);
            
           AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
            pg2.Name = 'CostShareRanges';
            pg2.Plan_Network__c = pn2.id;
            pg2.Type__c = 'Cost Share Group';
            pg2.Record_Type__c = 'BRF';
            pg2.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002';
            pg2.IsCovered__c='No';

         //   insert pg2;
         lstGrp.add(pg2);
            
            AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
            pg3.Name = 'Medical Supplies/Equipment-0628';
            pg3.Plan_Network__c = pn.id;
            pg3.Type__c = 'Benefit Group';
            pg3.Sequence_Number__c = 1;
            pg3.Record_Type__c = 'BRF';
            pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
            pg3.IsCovered__c='No';

           // insert pg3;
          lstGrp.add(pg3);
            
            AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
            pg4.Name = 'Medical Supplies/Equipment-0629';
            pg4.Plan_Network__c = pn2.id;
            pg4.Type__c = 'Benefit Group';
            pg4.Sequence_Number__c = 1;
            pg4.Record_Type__c = 'BRF';
            pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
            pg4.IsCovered__c='Yes';

            //insert pg4;
           lstGrp.add(pg4);
           
           insert lstGrp;
           
          List<AIA_Plan_Benefits__c> lstPlnt = new List<AIA_Plan_Benefits__c>();
           AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
            pb.Benefit_Name__c = 'OutOfPocket_Individual';
            pb.Record_Type__c = 'BRF';
            pb.Type__c = 'Benefit';
            pb.Benefit_Group__c = pg3.id;
            pb.Cost_Share_Low__c = '0';
            pb.Cost_Share_High__c = '100';
            pb.Cost_Share_Increment__c = '10';
            pb.Cost_Share_Default_Amount__c = '40';
            pb.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb.Cost_Share_InvalidIncrements__c = '20, 30';
            pb.Sequence_Number__c = 1;
            //insert pb;
            lstPlnt.add(pb);
        
        AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
            pb29.Benefit_Name__c = '';
            pb29.Record_Type__c = 'BRF';
            pb29.Type__c = 'Benefit';
            pb29.Benefit_Group__c = pg4.id;
            pb29.Cost_Share_Low__c = '0';
            pb29.Cost_Share_High__c = '100';
            pb29.Cost_Share_Increment__c = '10';
            pb29.Cost_Share_Default_Amount__c = '40';
            pb29.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb29.Cost_Share_InvalidIncrements__c = '20, 30';
            pb29.Sequence_Number__c = 1;
           // insert pb29;
           lstPlnt.add(pb29);
          
          AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
            pb2.Benefit_Name__c = 'OutOfPocket_Family';
            pb2.Record_Type__c = 'BRF';
            pb2.Type__c = 'Cost Share';
            pb2.Benefit_Group__c = pg.id;
            pb2.Cost_Share_Low__c = '0';
            pb2.Cost_Share_High__c = '100';
            pb2.Cost_Share_Increment__c = '10';
            pb2.Cost_Share_Default_Amount__c = '40';
            pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb2.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb2;
          lstPlnt.add(pb2);
        
            AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
            pb3.Benefit_Name__c = 'OutOfPocket_Single';
            pb3.Record_Type__c = 'BRF';
            pb3.Type__c = 'Cost Share';
            pb3.Benefit_Group__c = pg.id;
            pb3.Cost_Share_Low__c = '0';
            pb3.Cost_Share_High__c = '100';
            pb3.Cost_Share_Increment__c = '10';
            pb3.Cost_Share_Default_Amount__c = '40';
            pb3.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb3.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb3;
           lstPlnt.add(pb3); 
            AIA_Plan_Benefits__c pb4 = new AIA_Plan_Benefits__c();
            pb4.Benefit_Name__c = 'Deductible_Individual';
            pb4.Record_Type__c = 'BRF';
            pb4.Type__c = 'Cost Share';
            pb4.Benefit_Group__c = pg.id;
            pb4.Cost_Share_Low__c = '0';
            pb4.Cost_Share_High__c = '100';
            pb4.Cost_Share_Increment__c = '10';
            pb4.Cost_Share_Default_Amount__c = '40';
            pb4.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb4.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb4;
            lstPlnt.add(pb4); 
            
            AIA_Plan_Benefits__c pb5 = new AIA_Plan_Benefits__c();
            pb5.Benefit_Name__c = 'Deductible_Family';
            pb5.Record_Type__c = 'BRF';
            pb5.Type__c = 'Cost Share';
            pb5.Benefit_Group__c = pg.id;
            pb5.Cost_Share_Low__c = '0';
            pb5.Cost_Share_High__c = '100';
            pb5.Cost_Share_Increment__c = '10';
            pb5.Cost_Share_Default_Amount__c = '40';
            pb5.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb5.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb5;
           lstPlnt.add(pb5);
            
            AIA_Plan_Benefits__c pb6 = new AIA_Plan_Benefits__c();
            pb6.Benefit_Name__c = 'Deductible_Single';
            pb6.Record_Type__c = 'BRF';
            pb6.Type__c = 'Cost Share';
            pb6.Benefit_Group__c = pg.id;
            pb6.Cost_Share_Low__c = '0';
            pb6.Cost_Share_High__c = '100';
            pb6.Cost_Share_Increment__c = '10';
            pb6.Cost_Share_Default_Amount__c = '40';
            pb6.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb6.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb6;
           lstPlnt.add(pb6);
            
            AIA_Plan_Benefits__c pb7 = new AIA_Plan_Benefits__c();
            pb7.Benefit_Name__c = 'DeductibleCarryOver';
            pb7.Record_Type__c = 'BRF';
            pb7.Type__c = 'Cost Share';
            pb7.Benefit_Group__c = pg.id;
            pb7.Cost_Share_Low__c = '0';
            pb7.Cost_Share_High__c = '100';
            pb7.Cost_Share_Increment__c = '10';
            pb7.Cost_Share_Default_Amount__c = '40';
            pb7.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb7.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb7;
            lstPlnt.add(pb7);
            AIA_Plan_Benefits__c pb8 = new AIA_Plan_Benefits__c();
            pb8.Benefit_Name__c = 'LifetimeMax_Single';
            pb8.Record_Type__c = 'BRF';
            pb8.Type__c = 'Cost Share';
            pb8.Benefit_Group__c = pg.id;
            pb8.Cost_Share_Low__c = '0';
            pb8.Cost_Share_High__c = '100';
            pb8.Cost_Share_Increment__c = '10';
            pb8.Cost_Share_Default_Amount__c = '40';
            pb8.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb8.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb8;
             lstPlnt.add(pb8);
            AIA_Plan_Benefits__c pb9 = new AIA_Plan_Benefits__c();
            pb9.Benefit_Name__c = 'Copay_PCPCopay';
            pb9.Record_Type__c = 'BRF';
            pb9.Type__c = 'Cost Share';
            pb9.Benefit_Group__c = pg.id;
            pb9.Cost_Share_Low__c = '0';
            pb9.Cost_Share_High__c = '100';
            pb9.Cost_Share_Increment__c = '10';
            pb9.Cost_Share_Default_Amount__c = '40';
            pb9.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb9.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb9;
            lstPlnt.add(pb9);
            AIA_Plan_Benefits__c pb10 = new AIA_Plan_Benefits__c();
            pb10.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb10.Record_Type__c = 'BRF';
            pb10.Type__c = 'Cost Share';
            pb10.Benefit_Group__c = pg.id;
            pb10.Cost_Share_Low__c = '0';
            pb10.Cost_Share_High__c = '100';
            pb10.Cost_Share_Increment__c = '10';
            pb10.Cost_Share_Default_Amount__c = '40';
            pb10.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb10.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb10;
            lstPlnt.add(pb10);
            
            AIA_Plan_Benefits__c pb11 = new AIA_Plan_Benefits__c();
            pb11.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb11.Record_Type__c = 'BRF';
            pb11.Type__c = 'Cost Share';
            pb11.Benefit_Group__c = pg.id;
            pb11.Cost_Share_Low__c = '0';
            pb11.Cost_Share_High__c = '100';
            pb11.Cost_Share_Increment__c = '10';
            pb11.Cost_Share_Default_Amount__c = '40';
            pb11.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb11.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb11;
           lstPlnt.add(pb11);
            
            AIA_Plan_Benefits__c pb13 = new AIA_Plan_Benefits__c();
            pb13.Benefit_Name__c = 'OutOfPocket_Individual';
            pb13.Record_Type__c = 'BRF';
            pb13.Type__c = 'Cost Share';
            pb13.Benefit_Group__c = pg2.id;
            pb13.Cost_Share_Low__c = '0';
            pb13.Cost_Share_High__c = '100';
            pb13.Cost_Share_Increment__c = '10';
            pb13.Cost_Share_Default_Amount__c = '40';
            pb13.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb13.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb13;
            lstPlnt.add(pb13);
            AIA_Plan_Benefits__c pb14 = new AIA_Plan_Benefits__c();
            pb14.Benefit_Name__c = 'OutOfPocket_Family';
            pb14.Record_Type__c = 'BRF';
            pb14.Type__c = 'Cost Share';
            pb14.Benefit_Group__c = pg2.id;
            pb14.Cost_Share_Low__c = '0';
            pb14.Cost_Share_High__c = '100';
            pb14.Cost_Share_Increment__c = '10';
            pb14.Cost_Share_Default_Amount__c = '40';
            pb14.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb14.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb14;
            lstPlnt.add(pb14);
            AIA_Plan_Benefits__c pb15 = new AIA_Plan_Benefits__c();
            pb15.Benefit_Name__c = 'OutOfPocket_Single';
            pb15.Record_Type__c = 'BRF';
            pb15.Type__c = 'Cost Share';
            pb15.Benefit_Group__c = pg2.id;
            pb15.Cost_Share_Low__c = '0';
            pb15.Cost_Share_High__c = '100';
            pb15.Cost_Share_Increment__c = '10';
            pb15.Cost_Share_Default_Amount__c = '40';
            pb15.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb15.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb15;
            lstPlnt.add(pb15);
            AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
            pb16.Benefit_Name__c = 'Deductible_Individual';
            pb16.Record_Type__c = 'BRF';
            pb16.Type__c = 'Cost Share';
            pb16.Benefit_Group__c = pg2.id;
            pb16.Cost_Share_Low__c = '0';
            pb16.Cost_Share_High__c = '100';
            pb16.Cost_Share_Increment__c = '10';
            pb16.Cost_Share_Default_Amount__c = '40';
            pb16.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb16.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb16;
            lstPlnt.add(pb16);
            
            insert lstPlnt;
            
            AIA_Plan_Benefits__c pb17 = new AIA_Plan_Benefits__c();
            pb17.Benefit_Name__c = 'Deductible_Family';
            pb17.Record_Type__c = 'BRF';
            pb17.Type__c = 'Cost Share';
            pb17.Benefit_Group__c = pg2.id;
            pb17.Cost_Share_Low__c = '0';
            pb17.Cost_Share_High__c = '100';
            pb17.Cost_Share_Increment__c = '10';
            pb17.Cost_Share_Default_Amount__c = '40';
            pb17.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb17.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb17;
            lstPlnt.add(pb17);
            
           // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb18 = new AIA_Plan_Benefits__c();
            pb18.Benefit_Name__c = 'Deductible_Single';
            pb18.Record_Type__c = 'BRF';
            pb18.Type__c = 'Cost Share';
            pb18.Benefit_Group__c = pg2.id;
            pb18.Cost_Share_Low__c = '0';
            pb18.Cost_Share_High__c = '100';
            pb18.Cost_Share_Increment__c = '10';
            pb18.Cost_Share_Default_Amount__c = '40';
            pb18.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb18.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb18;
           lstPlnt.add(pb18);
           
         //  insert lstPlnt;
            
            AIA_Plan_Benefits__c pb19 = new AIA_Plan_Benefits__c();
            pb19.Benefit_Name__c = 'DeductibleCarryOver';
            pb19.Record_Type__c = 'BRF';
            pb19.Type__c = 'Cost Share';
            pb19.Benefit_Group__c = pg2.id;
            pb19.Cost_Share_Low__c = '0';
            pb19.Cost_Share_High__c = '100';
            pb19.Cost_Share_Increment__c = '10';
            pb19.Cost_Share_Default_Amount__c = '40';
            pb19.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb19.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb19;
           lstPlnt.add(pb19);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb20 = new AIA_Plan_Benefits__c();
            pb20.Benefit_Name__c = 'LifetimeMax_Single';
            pb20.Record_Type__c = 'BRF';
            pb20.Type__c = 'Cost Share';
            pb20.Benefit_Group__c = pg2.id;
            pb20.Cost_Share_Low__c = '0';
            pb20.Cost_Share_High__c = '100';
            pb20.Cost_Share_Increment__c = '10';
            pb20.Cost_Share_Default_Amount__c = '40';
            pb20.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb20.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb20;
            lstPlnt.add(pb20);
            
          //  insert lstPlnt;
            
            
            AIA_Plan_Benefits__c pb21 = new AIA_Plan_Benefits__c();
            pb21.Benefit_Name__c = 'Copay_PCPCopay';
            pb21.Record_Type__c = 'BRF';
            pb21.Type__c = 'Cost Share';
            pb21.Benefit_Group__c = pg2.id;
            pb21.Cost_Share_Low__c = '0';
            pb21.Cost_Share_High__c = '100';
            pb21.Cost_Share_Increment__c = '10';
            pb21.Cost_Share_Default_Amount__c = '40';
            pb21.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb21.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb21;
           lstPlnt.add(pb21);
           
          // insert  lstPlnt;
            
            AIA_Plan_Benefits__c pb22 = new AIA_Plan_Benefits__c();
            pb22.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb22.Record_Type__c = 'BRF';
            pb22.Type__c = 'Cost Share';
            pb22.Benefit_Group__c = pg2.id;
            pb22.Cost_Share_Low__c = '0';
            pb22.Cost_Share_High__c = '100';
            pb22.Cost_Share_Increment__c = '10';
            pb22.Cost_Share_Default_Amount__c = '40';
            pb22.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb22.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb22;
           lstPlnt.add(pb22);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb23 = new AIA_Plan_Benefits__c();
            pb23.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb23.Record_Type__c = 'BRF';
            pb23.Type__c = 'Cost Share';
            pb23.Benefit_Group__c = pg2.id;
            pb23.Cost_Share_Low__c = '0';
            pb23.Cost_Share_High__c = '100';
            pb23.Cost_Share_Increment__c = '10';
            pb23.Cost_Share_Default_Amount__c = '40';
            pb23.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb23.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb23;    
           lstPlnt.add(pb22);
           
         //  insert lstPlnt;
               
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
            
            AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
            apc30.Plan_Benefits__c = pb29.id;
            apc30.AliasName__c = 'General Copay';
            apc30.CopayAmount__c = '200';
            apc30.CoinsuranceAmount__c = '50';
            apc30.MinPayAmount__c = '90';
            apc30.MaxPayAmount__c = '80';
            apc30.IsCovered__c = 'Yes';
            apc30.DeductibleApplies__c = 'No';  
            apc30.MandateIndicator__c = 'Yes';          
            apc30.Jurisdiction__c = 'Test';            
            apc30.MandateName__c='PPACA mandate';
            apc30.ExtID__c = 'rwuifghqierufghaire';
            insert apc30;
        
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
            
          // pbc.IsMandateTrue__c ='Yes';
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
          //mod 
          
     
     //mod
            
            //system.debug('ppd id medical'+pp1);
     Proposed_Products__c pp1 = new Proposed_Products__c();           
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp1.Benefit_Request_Form__c =brf.id;
            pp1.Funding_Arrangement__c = 'ASO';
            pp1.Product_Category__c = 'Drug';
            pp1.Product_Line__c = 'pp1O';
           pp1.Plan_Name__c = aiapln.id;
            pp1.Product_Name__c = 'BlueChoice Advantage';
            pp1.CDH__c = 'Yes';
            pp1.CDH_Fund_Type__c = 'BlueFund';
            pp1.CDH_Type__c = 'HSA';
            pp1.Deductible__c = 'Stacked';
            pp1.Grandfathered_Status__c = 'Grandfathered';
            pp1.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp1.Blue_Rewards__c = 'No';
            pp1.Out_of_Pocket_Max__c = 'Stacked';
           // pp1.Jurisdiction__c = 'MD';
            pp1.Has_Benefit_Details__c = false;
            pp1.Exclusive_Specialty_Provider_Network__c='Yes';
            pp1.RX_OOP_Max_Integration__c='Integrated';
            insert pp1;
           Proposed_Products__c pp = new Proposed_Products__c();           
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.id;
            pp.Funding_Arrangement__c = 'ASO';
            pp.Product_Category__c = 'Drug';
            pp.Product_Line__c = 'PPO';
           pp.Plan_Name__c = aiapln.id;
            pp.Product_Name__c = 'BlueChoice Advantage';
            pp.CDH__c = 'Yes';
            pp.CDH_Fund_Type__c = 'BlueFund';
            pp.Related_Medical_Product__c=pp1.id;
            pp.Exclusive_Specialty_Provider_Network__c='Yes';
            pp.CDH_Type__c = 'HSA';
            pp.Deductible__c = 'Stacked';
            pp.Grandfathered_Status__c = 'Grandfathered';
            pp.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp.Grandfathered_PPACA_Status__c = 'No';
            pp.Blue_Rewards__c = 'No';
            pp.Out_of_Pocket_Max__c = 'Stacked';
     pp.RX_OOP_Max_Integration__c='Integrated';
           // pp.Jurisdiction__c = 'MD';
            pp.Has_Benefit_Details__c = false;
            insert pp;
                 system.debug('ppd id drug pp'+pp);
 
     Proposed_Products__c pp2 = new Proposed_Products__c();           
            pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp2.Benefit_Request_Form__c =brf.id;
            pp2.Funding_Arrangement__c = 'ASO';
            pp2.Product_Category__c = 'Drug';
            pp2.Product_Line__c = 'pp2O';
           pp2.Plan_Name__c = aiapln.id;
            pp2.Product_Name__c = 'BlueChoice Advantage';
            pp2.CDH__c = 'Yes';
            pp2.CDH_Fund_Type__c = 'BlueFund';
          pp2.Related_Medical_Product__c=pp.id;
            pp2.CDH_Type__c = 'HSA';
            pp2.Deductible__c = 'Stacked';
            pp2.Grandfathered_Status__c = 'Grandfathered';
            pp2.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp2.Grandfathered_ppACA_Status__c = 'No';
            pp2.Blue_Rewards__c = 'No';
            pp2.Out_of_Pocket_Max__c = 'Stacked';
           // pp2.Jurisdiction__c = 'MD';
            pp2.Has_Benefit_Details__c = false;
            pp2.Exclusive_Specialty_Provider_Network__c='Yes';
          pp2.RX_OOP_Max_Integration__c='Integrated';

            insert pp2;
     
                 system.debug('ppd id medical1'+pp2);

     
     //mod offshore

     AIA_Grouper__c ag = new AIA_Grouper__c();
      ag.Name = 'CostShareRanges';
      ag.Group_Type__c = 'Cost Share Group';
      ag.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag.Proposed_Products__c = pp.id;
  insert ag;
     AIA_Grouper__c ag1 = new AIA_Grouper__c();
      ag1.Name = 'CostShareRanges';
      ag1.Group_Type__c = 'Cost Share Group';
      ag1.Grouper_Record_Type__c = 'BRF';
        ag1.benefit_Custom__c=true;
         ag1.Benefit_Non_Standard__c=true;
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag1.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag1.Proposed_Products__c = pp2.id;
  insert ag1;
  
  List<AIA_Benefits__c> benlist = new  List<AIA_Benefits__c>();
  AIA_Benefits__c ab = new AIA_Benefits__c();
      ab.Grouper__c = ag.id;
     ab.IS_ASO_Only__c=false;
      ab.Benefit_Name__c = 'Family Out Of Pocket';
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
        ab.Additional_Benefit__c = true;
      ab.additional_limitation__c = true;
     benlist.add(ab);
     
     AIA_Benefits__c ab1 = new AIA_Benefits__c();
      ab1.Grouper__c = ag1.id;
     ab1.IS_ASO_Only__c=false;
      ab1.Benefit_Name__c = 'Family Out Of Pocket';
      ab1.Benefit_Type__c = 'Benefit';
      ab1.Copay_Type_1_Mandate_Name__c = 'Test';
      ab1.Type__c = 'Cost Share';
      ab1.Benefit_Record_Type__c = 'BRF';
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
      ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
      ab1.OON_Copay_Type_1_DeductibleApplies__c = 'No';
      ab1.Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.Copay_Type_2_AliasName__c = 'Test';
      ab1.OON_Copay_Type_1_AliasName__c = 'PCP Copay';
      ab1.OON_Copay_Type_2_AliasName__c = 'Test';
      ab1.IsAppGlobalCopay__c = true;
     benlist.add(ab1);
     insert benlist;
     Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Maxrow');
  insert lmt;
     
     
        AIA_BenefitTriggerHandler.disableAdjustmentsOnInserts();
        AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();

test.starttest();  
           PageReference pref = Page.AIA_ProposedProd_Summary;
           Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
         //Commenting as part of US1650
         //ext.getPCSdata();
        ext.mainInit();
           ext.createWrapListFromPlan(pp);
        ext.createWrapListFromPlanCostShr(aiapln.id);
               AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();
        AIA_BenefitTriggerHelperClass.UpdatecustomizedProperties(benlist);
         AIA_BenefitTriggerHelperClass.updateppbdp(pp2.id,'',false,false);   
    AIA_BenefitTriggerHelperClass.validateCopayValues('2','3','4','','6','7');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','7','4','5','6','3');
     AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','4','5','6','3');
          AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','3','5','6','3');


        ext.saveAndCon();
        ext.addPlan();
        ext.saveandRedirct();
        ext.reviewInit();
        
       
        ext.back();
     
test.stoptest();            
    }
    
  public static testmethod void TestAIA_benefitDEsign_Static(){
       //Commenting as part of US210  
       /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;*/

        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom']; 
         List<user> userList = new list<user>();
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        //insert u;
        userList.add(u);
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test');
        //insert u2;
        userList.add(u2);
        
        // Create Account
        Account Acc = AIA_TestUtil.CreateAccount('TestAccount');
        
        system.assertNotEquals(null,Acc.id);
       
        
          //Create testusers
       
        user usr1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(usr1);
        user usr2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(usr2);        
        user usr3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(usr3);        
        user usr4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(usr4);        
        user usr5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(usr5); 
        user usr6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(usr6);
        insert userList;       
       
       
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); 
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,usr5.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,usr6.id,'Account Executive'));
      
        insert acctMbrList;
       
        AIA_TestUtil.AIA_createAccountTeamMember(Acc.Id, usr6.id, 'Contract Tech');
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity(Acc.Id);
        system.assertNotEquals(null,o.id);
        o.Business_Type__c = 'New';
        update o;
        
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Plan_Id__c='PLAN-Test';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Has_Benefit_Summary__c=true;
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

        test.starttest();
        
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
           
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = Acc.id;
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Account__c = Acc.id;
        nbrf.Opportunity__c = o.id;
        nbrf.Jurisdiction__c = 'MD';
        try{
        insert nbrf;
}catch(Exception e){}
        
        Proposed_Products__c pp = new Proposed_Products__c();           
        pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
        pp.Benefit_Request_Form__c = nbrf.id;
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
        try{
        insert pp;
}catch(Exception e){}
        

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
        //AIA_Benefit_Design__c bd=AIA_TestUtil.CreateBenefitDesignWImpFromBrf(Acc,o.id,nbrf.id);
        AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = Acc.id;
           // Imp.Account__c = Imp.Opportunity__r.AccountId;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
          //  insert Imp;
                
            AIA_Benefit_Design__c bd = new AIA_Benefit_Design__c();
           // aiaBD.Implementation__c = Imp.id;
            bd.Account__c =Acc.id;
            bd.Benefit_Request_Form__c = nbrf.Id;
            insert bd;

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
        try{
            //ext2.mainInit();
        }catch(Exception e){
        }

        //ext2.dispatcher();
        ext2.saveAndCon();

        test.stopTest();
    }
    
    
    
    public static Proposed_Products__c pp;
    public static AIA_Benefit_Design_Product__c bdp;
    public static AIA_Grouper__c ag;
    public static AIA_Grouper__c ag1;
    public static List<AIA_Benefits__c> lstBnft; 
    
    
   /* public static testmethod void TestAIA_benefitsummary_ErrorMessage12(){
            CreateTestData();
        
            Test.startTest();           
                PageReference pageRef = Page.AIA_Custom_Benefits_Delete;
                Test.setCurrentPage(pageRef);            
                ApexPages.currentPage().getParameters().put('pid', pp.Id);
                ApexPages.currentPage().getParameters().put('Grouper', ag.Id);          
                
                AIA_Custom_Benefits_Delete_Cls controller = new AIA_Custom_Benefits_Delete_Cls();                           
                controller.getBenefitNames();
                controller.selectedBenefit = 'test1';
                controller.SelectedBenfits();
                controller.selectedBenefit = 'test2';
                controller.DeleteLimitations();
                controller.DeleteBenfits();
                controller.selectedBenefit = 'test1';
                controller.DeleteBenfits();
                controller.cancel();
        PageReference pref1 = Page.AIA_ProposedProd_Summary;
           Test.setCurrentPage(pref1);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
         //Commenting as part of US1650
         //ext.getPCSdata();
        ext.mainInit();
           ext.createWrapListFromPlan(pp);
        //ext.createWrapListFromPlanCostShr(aiapln.id);
               AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();
         ext.saveAndCon();
        ext.addPlan();
        ext.saveandRedirct();
        ext.reviewInit();
        ext.back();
            Test.stopTest();
    } */
/*public static void CreateTestData(){ 
            Test.startTest();
            Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
            List<User> userList= new List<User>();
            User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB123RF@testorg.com.test');
            //insert u;
            userList.add(u);
    
            User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF121@testorg.com.test');
            userList.add(u1);
                //insert u1;
    
            User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF222@testorg.com.test');
            //insert u2;
            userList.add(u2);
    
            User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBR12F3@testorg.com.test');
            //insert u3;
            userList.add(u3);
    
            User u4 = new User(Alias = 'TAlias4', Email='TestUserBRF4@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserB3RF4@testorg.com.test');
            //insert u4;
            userList.add(u4);
    
            User u5 = new User(Alias = 'TAlias5', Email='TestUserBRF5@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer5', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingUse12rBRF5@testorg.com.test');
            //insert u5;
            userList.add(u5);
    
            User u6 = new User(Alias = 'TAlias6', Email='TestUserBRF6@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer6', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='TestingU21serBRF6@testorg.com.test');
            //insert u6;
            userList.add(u6);
    
            User u7 = new User(Alias = 'TAlias7', Email='TestUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer7', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Testin11gUserBRF7@testorg.com.test');
            //insert u7;
            userList.add(u7);
    
            User u8 = new User(Alias = 'TAla87', Email='T76estUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSery67', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Test76564in11gUserBRF7@testorg.com.test');
            //insert u8;
            userList.add(u8);
    
            User u9 = new User(Alias = 'TAli97', Email='Te5467stUse11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='TestingUSer776', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te75stin11gUserBRF7@testorg.com.test');
            //insert u9;
            userList.add(u9);
    
    
            User u10 = new User(Alias = 'TA197', Email='Te10e11rBRF7@testorg.com',
                    EmailEncodingKey='UTF-8', LastName='Testing1076', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_US', ProfileId = pro.Id,
                    TimeZoneSidKey='America/Los_Angeles', UserName='Te10gUserBRF7@testorg.com.test');
            //insert u10;
            userList.add(u10);
            insert userList;
            //Commenting as part of US210 
            //AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            //wpt.Used_For__c = 'Pre-Sales';
            //wpt.Workplan_Type__c = 'New';
            //wpt.Active__c = true;
            //insert wpt;
            
            Account Acc = new Account();
            Acc.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X51');
            Acc.Name = 'Test Account';
            Acc.Type = 'Customer';
            Acc.Account_Legal_Name__c = 'Test Account Legal Name';
            Acc.BillingStreet = 'James Street';
            Acc.BillingCity = 'New York';
            Acc.BillingState = 'MD';
            Acc.BillingPostalCode = '21212';
            Acc.BillingCountry = 'USA';
            Acc.Billing_County_Code__c = 'MO-Montgomery';
            
            Insert Acc;
            
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
            insert o;*/

        
            /*AccountTeamMember atmRole = new AccountTeamMember ();
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
            atmRole2.TeamMemberRole = 'Settlements Analyst'; //T01
            atmRole2.AccountId = acc.id;
            atmRole2.UserId = u3.id;
            insert atmRole2;
    
            AccountTeamMember atmRole3 = new AccountTeamMember ();
            atmRole3.TeamMemberRole = 'Billing Tech';
            atmRole3.AccountId = acc.id;
            atmRole3.UserId = u4.id;
            insert atmRole3;
    
            AccountTeamMember atmRole4 = new AccountTeamMember ();
            atmRole4.TeamMemberRole = 'Auditor'; //T01
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
            insert atmRole15;*/
    
            /*List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u.id,'BeneFact Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Implementation Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Settlements Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u6.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'MAST Tech'));
        insert acctMbrList;
        
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.Id;
            Imp.Account__c = acc.Id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            insert Imp;  
            
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Implementation__c = Imp.id;
            aiaBD.Account__c = acc.id;   
            aiaBD.Parent_Account__c = acc.id;                    
            insert aiaBD;
            
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            //    nbrf.Control_Plan__c='690';     
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            brf.ARC_Approval_Status__c = 'Pending';
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = acc.id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            brf.Rider__c = 'Vision Care Rider';
            insert brf;
        
            AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical', 'Test');
            aiapln.Plan_Name__c = 'Test Plan';
            //aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
            // aiapln.Jurisdiction__c = 'MD';
            insert aiapln;
        
            pp = new Proposed_Products__c();
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
            pp.Has_Benefit_Details__c = True;
            insert pp;
        
            ag = new AIA_Grouper__c();
            ag.Name = 'Additional Services';
            ag.Group_Type__c = 'Benefit Group';
            ag.Grouper_Record_Type__c = 'BRF';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();            
            ag.Proposed_Products__c = pp.id;
            insert ag;
        
            lstBnft = new List < AIA_Benefits__c > ();
            AIA_Benefits__c ab3 = new AIA_Benefits__c();
            ab3.Grouper__c = ag.id;
            ab3.Benefit_Name__c = 'test1';            
            ab3.Benefit_Type__c = 'Benefit';
            ab3.Type__c = 'Benefit';
            ab3.Benefit_Record_Type__c = 'BRF';          
            lstBnft.add(ab3); 
            
            AIA_Benefits__c ab4 = new AIA_Benefits__c();
            ab4.Grouper__c = ag.id;
            ab4.Benefit_Name__c = 'test2';            
            ab4.Benefit_Type__c = 'Benefit';
            ab4.Type__c = 'Benefit';
            ab4.Benefit_Record_Type__c = 'BRF';                        
            lstBnft.add(ab4);
        
            AIA_Benefits__c ab = new AIA_Benefits__c();
            ab.Grouper__c = ag.id;
            ab.Benefit_Name__c = 'test1 - General General';
            ab.Benefit_Type__c = 'Benefit';
            //ab.Benefit_Type__c = 'Limitation';      
            ab.Type__c = 'Benefit';
            ab.Benefit_Record_Type__c = 'BRF';    
            ab.Parent_Benefit__c = ab3.Id; 
            ab.CoInsurance_AmountValueSelected__c = '';
            ab.Copay_Type_1_DeductibleApplies__c = ''; 
            ab.Copay_Type_1_IsCovered__c = 'N/A';
            ab.Place_of_Service__c = 'In-Patient';
            ab.Dummy_Parent_Benefit_Name__c = 'Ben1';
            ab.Additional_Benefit__c = True;
            ab.RecordTypeId = Schema.SObjectType.AIA_Benefits__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
                    
            lstBnft.add(ab);            
            
            AIA_Benefits__c ab2 = new AIA_Benefits__c();
            ab2.Grouper__c = ag.id;
            ab2.Benefit_Name__c = 'test2 - Outpatient Independent Lab';            
            ab2.Benefit_Type__c = 'Benefit';
            //ab2.Type__c = 'Benefit';
            //ab2.Benefit_Record_Type__c = 'BRF';   
            //ab2.Benefit_Record_Type__c= 'Proposed_Product';
            ab2.Parent_Benefit__c = ab3.Id;
            ab2.CoInsurance_AmountValueSelected__c = '1000';
            ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
            ab2.Copay_Type_1_IsCovered__c = 'Yes';    
            ab2.Place_of_Service__c = 'Out-Patient';
            ab2.Dummy_Parent_Benefit_Name__c = 'Ben2';
            ab2.Additional_Benefit__c = True; 
            ab2.RecordTypeId = Schema.SObjectType.AIA_Benefits__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
            lstBnft.add(ab2);
            insert lstBnft;
            
            List < Limitations__c > lstLmt = new List < Limitations__c > ();
            Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Maxrow');
            //lmt.Additional_Comment__c = True;
            lstLmt.add(lmt);            
            Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Comment');
            lstLmt.add(lmt3);
            
            insert lstLmt;      
    
            bdp= new AIA_Benefit_Design_Product__c();
            bdp.Benefit_Design__c=aiaBD.id;
            //  bdp.RecordTypeId= QueryBase.getRecordtypeId('AIA_Benefit_Design_Product__c', rtype);
            bdp.Plan_Name__c=aiapln.id;
            bdp.Proposed_Products__c=pp.id;     
            // bdp.Funding_Arrangement__c = 'Risk';
            insert bdp;  
        
        
            ag1 = new AIA_Grouper__c();
            ag1.Name = 'Additional Services';
            ag1.Group_Type__c = 'Benefit Group';
            ag1.Grouper_Record_Type__c = 'BDD';
            //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
            ag1.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();            
            ag1.Proposed_Products__c = pp.id;
            ag1.Benefit_Design_Product__c = bdp.id;
            insert ag1;
        
            List < AIA_Benefits__c > BDlstBnft = new List < AIA_Benefits__c > ();
            AIA_Benefits__c BDab3 = new AIA_Benefits__c();
            BDab3.Grouper__c = ag1.id;
            BDab3.Benefit_Name__c = 'test3';            
            BDab3.Benefit_Type__c = 'Benefit';
            BDab3.Type__c = 'Benefit';
            BDab3.Benefit_Record_Type__c = 'BDD';                      
            BDlstBnft.add(BDab3); 
            
            /*AIA_Benefits__c BDab4 = new AIA_Benefits__c();
            BDab4.Grouper__c = ag1.id;
            BDab4.Benefit_Name__c = 'test4';            
            BDab4.Benefit_Type__c = 'Limitation';
            BDab4.Type__c = 'Benefit';
            BDab4.Benefit_Record_Type__c = 'BDD';            
            BDlstBnft.add(BDab4);
        
            AIA_Benefits__c BDab = new AIA_Benefits__c();
            BDab.Grouper__c = ag1.id;
            BDab.Benefit_Name__c = 'test3 - General General';
            BDab.Benefit_Type__c = 'Benefit';            
            BDab.Type__c = 'Benefit';
            BDab.Benefit_Record_Type__c = 'BDD';    
            BDab.Parent_Benefit__c = BDab3.Id;        
            BDlstBnft.add(BDab);            
            
            AIA_Benefits__c BDab2 = new AIA_Benefits__c();
            BDab2.Grouper__c = ag1.id;
            BDab2.Benefit_Name__c = 'test4 - Outpatient Independent Lab';            
            BDab2.Benefit_Type__c = 'Benefit';
            BDab2.Type__c = 'Benefit';
            BDab2.Benefit_Record_Type__c = 'BDD';   
            BDab.Parent_Benefit__c = BDab3.Id;        
            BDlstBnft.add(BDab2); 
    Test.stopTest();
    }*/

   public static void createAccountTeamMembers(String accId)
   {
       
       //Creating Account team members
            List<user> userList = new list<user>();
            user u1 = AIA_TestUtil.AIA_createUser('alias1');
            userList.add(u1); 
            user u2 = AIA_TestUtil.AIA_createUser('alias2');
            userList.add(u2);
            user u3 =AIA_TestUtil.AIA_createUser('alias3');
            userList.add(u3);
            insert userList;
        
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();//T02
            List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accId,u1.id,'Account Executive')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accId,u2.id,'Proposal Specialist')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accId,u3.id,'Account Manager'));
            insert acctMbrList;
       
   }
public Static TestMethod void TestAIA_Benefit_Creationdisableintrgrated2(){
    
       //Commenting as part of US210 
       /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
          insert wpt;*/
     
          Account acc = AIA_TestUtil.CreateAccount('TestAccount');
          AIA_BenefittriggerHandlerHelper_Test.createAccountTeamMembers(acc.Id);
        
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
      
       
       
       
      Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
        brf.Enrollment_Type__c='Cafeteria';
        brf.Exclusive_Specialty_Provider_Network__c='Yes';
        insert brf;
    
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
          aiapln.Has_Benefit_Summary__c = True;
          aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
          aiapln.Jurisdiction__c = 'MD';
        //  aiapln.Product_Last_Updated__c=Date.today()+1;
         // aiapln.Configuration_Last_Updated__c = Date.today();
      
          insert aiapln;
       
            List<AIA_Plan_Network__c> plnNet =new List<AIA_Plan_Network__c>();
            AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
            pn.ExtID__c = 'PLAN-001N_BRF1';
            pn.Name = 'InNetwork';
            pn.Plan__c = aiapln.id;
            //insert pn;
            plnNet.add(pn);
            AIA_Plan_Network__c pn2 = new AIA_Plan_Network__c();
            pn2.ExtID__c = 'PLAN-001N_BRF12';
            pn2.Name = 'OutNetwork';
            pn2.Plan__c = aiapln.id;
            //insert pn2;
            plnNet.add(pn2);
            insert plnNet;
       
            List<AIA_Plan_Grouper__c> lstGrp = new List<AIA_Plan_Grouper__c>();
            AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
            pg.Name = 'CostShareRanges';
            pg.Plan_Network__c = pn.id;
            pg.Type__c = 'Cost Share Group';
            pg.Record_Type__c = 'BRF';
            pg.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00';
            pg.IsCovered__c='Yes';
            
            //insert pg;
            lstGrp.add(pg);
            
           AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
            pg2.Name = 'CostShareRanges';
            pg2.Plan_Network__c = pn2.id;
            pg2.Type__c = 'Cost Share Group';
            pg2.Record_Type__c = 'BRF';
            pg2.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002';
            pg2.IsCovered__c='No';

         //   insert pg2;
         lstGrp.add(pg2);
            
            AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
            pg3.Name = 'Medical Supplies/Equipment-0628';
            pg3.Plan_Network__c = pn.id;
            pg3.Type__c = 'Benefit Group';
            pg3.Sequence_Number__c = 1;
            pg3.Record_Type__c = 'BRF';
            pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
            pg3.IsCovered__c='No';

           // insert pg3;
          lstGrp.add(pg3);
            
            AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
            pg4.Name = 'Medical Supplies/Equipment-0629';
            pg4.Plan_Network__c = pn2.id;
            pg4.Type__c = 'Benefit Group';
            pg4.Sequence_Number__c = 1;
            pg4.Record_Type__c = 'BRF';
            pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
            pg4.IsCovered__c='Yes';

            //insert pg4;
           lstGrp.add(pg4);
           
           insert lstGrp;
           
          List<AIA_Plan_Benefits__c> lstPlnt = new List<AIA_Plan_Benefits__c>();
           AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
            pb.Benefit_Name__c = 'OutOfPocket_Individual';
            pb.Record_Type__c = 'BRF';
            pb.Type__c = 'Benefit';
            pb.Benefit_Group__c = pg3.id;
            pb.Cost_Share_Low__c = '0';
            pb.Cost_Share_High__c = '100';
            pb.Cost_Share_Increment__c = '10';
            pb.Cost_Share_Default_Amount__c = '40';
            pb.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb.Cost_Share_InvalidIncrements__c = '20, 30';
            pb.Sequence_Number__c = 1;
            //insert pb;
            lstPlnt.add(pb);
        
        AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
            pb29.Benefit_Name__c = '';
            pb29.Record_Type__c = 'BRF';
            pb29.Type__c = 'Benefit';
            pb29.Benefit_Group__c = pg4.id;
            pb29.Cost_Share_Low__c = '0';
            pb29.Cost_Share_High__c = '100';
            pb29.Cost_Share_Increment__c = '10';
            pb29.Cost_Share_Default_Amount__c = '40';
            pb29.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb29.Cost_Share_InvalidIncrements__c = '20, 30';
            pb29.Sequence_Number__c = 1;
           // insert pb29;
           lstPlnt.add(pb29);
          
          AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
            pb2.Benefit_Name__c = 'OutOfPocket_Family';
            pb2.Record_Type__c = 'BRF';
            pb2.Type__c = 'Cost Share';
            pb2.Benefit_Group__c = pg.id;
            pb2.Cost_Share_Low__c = '0';
            pb2.Cost_Share_High__c = '100';
            pb2.Cost_Share_Increment__c = '10';
            pb2.Cost_Share_Default_Amount__c = '40';
            pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb2.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb2;
          lstPlnt.add(pb2);
        
            AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
            pb3.Benefit_Name__c = 'OutOfPocket_Single';
            pb3.Record_Type__c = 'BRF';
            pb3.Type__c = 'Cost Share';
            pb3.Benefit_Group__c = pg.id;
            pb3.Cost_Share_Low__c = '0';
            pb3.Cost_Share_High__c = '100';
            pb3.Cost_Share_Increment__c = '10';
            pb3.Cost_Share_Default_Amount__c = '40';
            pb3.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb3.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb3;
           lstPlnt.add(pb3); 
            AIA_Plan_Benefits__c pb4 = new AIA_Plan_Benefits__c();
            pb4.Benefit_Name__c = 'Deductible_Individual';
            pb4.Record_Type__c = 'BRF';
            pb4.Type__c = 'Cost Share';
            pb4.Benefit_Group__c = pg.id;
            pb4.Cost_Share_Low__c = '0';
            pb4.Cost_Share_High__c = '100';
            pb4.Cost_Share_Increment__c = '10';
            pb4.Cost_Share_Default_Amount__c = '40';
            pb4.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb4.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb4;
            lstPlnt.add(pb4); 
            
            AIA_Plan_Benefits__c pb5 = new AIA_Plan_Benefits__c();
            pb5.Benefit_Name__c = 'Deductible_Family';
            pb5.Record_Type__c = 'BRF';
            pb5.Type__c = 'Cost Share';
            pb5.Benefit_Group__c = pg.id;
            pb5.Cost_Share_Low__c = '0';
            pb5.Cost_Share_High__c = '100';
            pb5.Cost_Share_Increment__c = '10';
            pb5.Cost_Share_Default_Amount__c = '40';
            pb5.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb5.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb5;
           lstPlnt.add(pb5);
            
            AIA_Plan_Benefits__c pb6 = new AIA_Plan_Benefits__c();
            pb6.Benefit_Name__c = 'Deductible_Single';
            pb6.Record_Type__c = 'BRF';
            pb6.Type__c = 'Cost Share';
            pb6.Benefit_Group__c = pg.id;
            pb6.Cost_Share_Low__c = '0';
            pb6.Cost_Share_High__c = '100';
            pb6.Cost_Share_Increment__c = '10';
            pb6.Cost_Share_Default_Amount__c = '40';
            pb6.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb6.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb6;
           lstPlnt.add(pb6);
            
            AIA_Plan_Benefits__c pb7 = new AIA_Plan_Benefits__c();
            pb7.Benefit_Name__c = 'DeductibleCarryOver';
            pb7.Record_Type__c = 'BRF';
            pb7.Type__c = 'Cost Share';
            pb7.Benefit_Group__c = pg.id;
            pb7.Cost_Share_Low__c = '0';
            pb7.Cost_Share_High__c = '100';
            pb7.Cost_Share_Increment__c = '10';
            pb7.Cost_Share_Default_Amount__c = '40';
            pb7.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb7.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb7;
            lstPlnt.add(pb7);
            AIA_Plan_Benefits__c pb8 = new AIA_Plan_Benefits__c();
            pb8.Benefit_Name__c = 'LifetimeMax_Single';
            pb8.Record_Type__c = 'BRF';
            pb8.Type__c = 'Cost Share';
            pb8.Benefit_Group__c = pg.id;
            pb8.Cost_Share_Low__c = '0';
            pb8.Cost_Share_High__c = '100';
            pb8.Cost_Share_Increment__c = '10';
            pb8.Cost_Share_Default_Amount__c = '40';
            pb8.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb8.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb8;
             lstPlnt.add(pb8);
            AIA_Plan_Benefits__c pb9 = new AIA_Plan_Benefits__c();
            pb9.Benefit_Name__c = 'Copay_PCPCopay';
            pb9.Record_Type__c = 'BRF';
            pb9.Type__c = 'Cost Share';
            pb9.Benefit_Group__c = pg.id;
            pb9.Cost_Share_Low__c = '0';
            pb9.Cost_Share_High__c = '100';
            pb9.Cost_Share_Increment__c = '10';
            pb9.Cost_Share_Default_Amount__c = '40';
            pb9.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb9.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb9;
            lstPlnt.add(pb9);
            AIA_Plan_Benefits__c pb10 = new AIA_Plan_Benefits__c();
            pb10.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb10.Record_Type__c = 'BRF';
            pb10.Type__c = 'Cost Share';
            pb10.Benefit_Group__c = pg.id;
            pb10.Cost_Share_Low__c = '0';
            pb10.Cost_Share_High__c = '100';
            pb10.Cost_Share_Increment__c = '10';
            pb10.Cost_Share_Default_Amount__c = '40';
            pb10.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb10.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb10;
            lstPlnt.add(pb10);
            
            AIA_Plan_Benefits__c pb11 = new AIA_Plan_Benefits__c();
            pb11.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb11.Record_Type__c = 'BRF';
            pb11.Type__c = 'Cost Share';
            pb11.Benefit_Group__c = pg.id;
            pb11.Cost_Share_Low__c = '0';
            pb11.Cost_Share_High__c = '100';
            pb11.Cost_Share_Increment__c = '10';
            pb11.Cost_Share_Default_Amount__c = '40';
            pb11.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb11.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb11;
           lstPlnt.add(pb11);
            
            AIA_Plan_Benefits__c pb13 = new AIA_Plan_Benefits__c();
            pb13.Benefit_Name__c = 'OutOfPocket_Individual';
            pb13.Record_Type__c = 'BRF';
            pb13.Type__c = 'Cost Share';
            pb13.Benefit_Group__c = pg2.id;
            pb13.Cost_Share_Low__c = '0';
            pb13.Cost_Share_High__c = '100';
            pb13.Cost_Share_Increment__c = '10';
            pb13.Cost_Share_Default_Amount__c = '40';
            pb13.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb13.Cost_Share_InvalidIncrements__c = '20, 30';
          //  insert pb13;
            lstPlnt.add(pb13);
            AIA_Plan_Benefits__c pb14 = new AIA_Plan_Benefits__c();
            pb14.Benefit_Name__c = 'OutOfPocket_Family';
            pb14.Record_Type__c = 'BRF';
            pb14.Type__c = 'Cost Share';
            pb14.Benefit_Group__c = pg2.id;
            pb14.Cost_Share_Low__c = '0';
            pb14.Cost_Share_High__c = '100';
            pb14.Cost_Share_Increment__c = '10';
            pb14.Cost_Share_Default_Amount__c = '40';
            pb14.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb14.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb14;
            lstPlnt.add(pb14);
            AIA_Plan_Benefits__c pb15 = new AIA_Plan_Benefits__c();
            pb15.Benefit_Name__c = 'OutOfPocket_Single';
            pb15.Record_Type__c = 'BRF';
            pb15.Type__c = 'Cost Share';
            pb15.Benefit_Group__c = pg2.id;
            pb15.Cost_Share_Low__c = '0';
            pb15.Cost_Share_High__c = '100';
            pb15.Cost_Share_Increment__c = '10';
            pb15.Cost_Share_Default_Amount__c = '40';
            pb15.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb15.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb15;
            lstPlnt.add(pb15);
            AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
            pb16.Benefit_Name__c = 'Deductible_Individual';
            pb16.Record_Type__c = 'BRF';
            pb16.Type__c = 'Cost Share';
            pb16.Benefit_Group__c = pg2.id;
            pb16.Cost_Share_Low__c = '0';
            pb16.Cost_Share_High__c = '100';
            pb16.Cost_Share_Increment__c = '10';
            pb16.Cost_Share_Default_Amount__c = '40';
            pb16.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb16.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb16;
            lstPlnt.add(pb16);
            
            insert lstPlnt;
    
            
            AIA_Plan_Benefits__c pb17 = new AIA_Plan_Benefits__c();
            pb17.Benefit_Name__c = 'Deductible_Family';
            pb17.Record_Type__c = 'BRF';
            pb17.Type__c = 'Cost Share';
            pb17.Benefit_Group__c = pg2.id;
            pb17.Cost_Share_Low__c = '0';
            pb17.Cost_Share_High__c = '100';
            pb17.Cost_Share_Increment__c = '10';
            pb17.Cost_Share_Default_Amount__c = '40';
            pb17.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb17.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb17;
            lstPlnt.add(pb17);
            
           // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb18 = new AIA_Plan_Benefits__c();
            pb18.Benefit_Name__c = 'Deductible_Single';
            pb18.Record_Type__c = 'BRF';
            pb18.Type__c = 'Cost Share';
            pb18.Benefit_Group__c = pg2.id;
            pb18.Cost_Share_Low__c = '0';
            pb18.Cost_Share_High__c = '100';
            pb18.Cost_Share_Increment__c = '10';
            pb18.Cost_Share_Default_Amount__c = '40';
            pb18.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb18.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb18;
           lstPlnt.add(pb18);
           
         //  insert lstPlnt;
            
            AIA_Plan_Benefits__c pb19 = new AIA_Plan_Benefits__c();
            pb19.Benefit_Name__c = 'DeductibleCarryOver';
            pb19.Record_Type__c = 'BRF';
            pb19.Type__c = 'Cost Share';
            pb19.Benefit_Group__c = pg2.id;
            pb19.Cost_Share_Low__c = '0';
            pb19.Cost_Share_High__c = '100';
            pb19.Cost_Share_Increment__c = '10';
            pb19.Cost_Share_Default_Amount__c = '40';
            pb19.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb19.Cost_Share_InvalidIncrements__c = '20, 30';
           //insert pb19;
           lstPlnt.add(pb19);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb20 = new AIA_Plan_Benefits__c();
            pb20.Benefit_Name__c = 'LifetimeMax_Single';
            pb20.Record_Type__c = 'BRF';
            pb20.Type__c = 'Cost Share';
            pb20.Benefit_Group__c = pg2.id;
            pb20.Cost_Share_Low__c = '0';
            pb20.Cost_Share_High__c = '100';
            pb20.Cost_Share_Increment__c = '10';
            pb20.Cost_Share_Default_Amount__c = '40';
            pb20.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb20.Cost_Share_InvalidIncrements__c = '20, 30';
            //insert pb20;
            lstPlnt.add(pb20);
            
          //  insert lstPlnt;
            
            
            AIA_Plan_Benefits__c pb21 = new AIA_Plan_Benefits__c();
            pb21.Benefit_Name__c = 'Copay_PCPCopay';
            pb21.Record_Type__c = 'BRF';
            pb21.Type__c = 'Cost Share';
            pb21.Benefit_Group__c = pg2.id;
            pb21.Cost_Share_Low__c = '0';
            pb21.Cost_Share_High__c = '100';
            pb21.Cost_Share_Increment__c = '10';
            pb21.Cost_Share_Default_Amount__c = '40';
            pb21.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb21.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb21;
           lstPlnt.add(pb21);
           
          // insert  lstPlnt;
            
            AIA_Plan_Benefits__c pb22 = new AIA_Plan_Benefits__c();
            pb22.Benefit_Name__c = 'Copay_SpecialistCopay';
            pb22.Record_Type__c = 'BRF';
            pb22.Type__c = 'Cost Share';
            pb22.Benefit_Group__c = pg2.id;
            pb22.Cost_Share_Low__c = '0';
            pb22.Cost_Share_High__c = '100';
            pb22.Cost_Share_Increment__c = '10';
            pb22.Cost_Share_Default_Amount__c = '40';
            pb22.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb22.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb22;
           lstPlnt.add(pb22);
           
          // insert lstPlnt;
            
            AIA_Plan_Benefits__c pb23 = new AIA_Plan_Benefits__c();
            pb23.Benefit_Name__c = 'Copay_PerAdmissionCopay';
            pb23.Record_Type__c = 'BRF';
            pb23.Type__c = 'Cost Share';
            pb23.Benefit_Group__c = pg2.id;
            pb23.Cost_Share_Low__c = '0';
            pb23.Cost_Share_High__c = '100';
            pb23.Cost_Share_Increment__c = '10';
            pb23.Cost_Share_Default_Amount__c = '40';
            pb23.Cost_Share_AdditionalIncrements__c = '22, 33';
            pb23.Cost_Share_InvalidIncrements__c = '20, 30';
           // insert pb23;    
           lstPlnt.add(pb22);
           
         //  insert lstPlnt;
          List<AIA_Plan_Copay_Type__c> planCopay = new List<AIA_Plan_Copay_Type__c>();     
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
            //insert apc;
            planCopay.add(apc);
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
            //insert apc3;
            planCopay.add(apc3);
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
            //insert apc2;
            planCopay.add(apc2);
            AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
            apc30.Plan_Benefits__c = pb29.id;
            apc30.AliasName__c = 'General Copay';
            apc30.CopayAmount__c = '200';
            apc30.CoinsuranceAmount__c = '50';
            apc30.MinPayAmount__c = '90';
            apc30.MaxPayAmount__c = '80';
            apc30.IsCovered__c = 'Yes';
            apc30.DeductibleApplies__c = 'No';  
            apc30.MandateIndicator__c = 'Yes';          
            apc30.Jurisdiction__c = 'Test';            
            apc30.MandateName__c='PPACA mandate';
            apc30.ExtID__c = 'rwuifghqierufghaire';
            //insert apc30;
            planCopay.add(apc30);
            insert planCopay;
   
    List<AIA_Plan_Limitation__c> planLimi =new List<AIA_Plan_Limitation__c>();
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
            //insert obj;
            planLimi.add(obj);
           
           AIA_Plan_Limitation__c obj2 = new AIA_Plan_Limitation__c();
               obj2.Plan_Benefits__c = pb.id;
               obj2.MandateIndicator__c = False;
            //insert obj2;
            planLimi.add(obj2);
      
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
            //insert obj3;
            planLimi.add(obj3);
            insert planLimi;      
            AIA_Plan_Benefit_Comment_Codes__c pbc =new AIA_Plan_Benefit_Comment_Codes__c();
           // pbc.Plan_Benefit_Parent_Name__c = ;
            pbc.Plan_Limitation__c = obj.id;
            
          // pbc.IsMandateTrue__c ='Yes';
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
          //mod 
          
     
     //mod
            List<Proposed_Products__c> ppList= new List<Proposed_Products__c>();
            //system.debug('ppd id medical'+pp1);
            Proposed_Products__c pp1 = new Proposed_Products__c();           
            pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp1.Benefit_Request_Form__c =brf.id;
            pp1.Funding_Arrangement__c = 'ASO';
            pp1.Product_Category__c = 'Drug';
            pp1.Product_Line__c = 'pp1O';
            pp1.Plan_Name__c = aiapln.id;
            pp1.Product_Name__c = 'BlueChoice Advantage';
            pp1.CDH__c = 'Yes';
            pp1.CDH_Fund_Type__c = 'BlueFund';
            pp1.CDH_Type__c = 'HSA';
            pp1.Deductible__c = 'Stacked';
            pp1.Grandfathered_Status__c = 'Grandfathered';
            pp1.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp1.Blue_Rewards__c = 'No';
            pp1.Out_of_Pocket_Max__c = 'Stacked';
           // pp1.Jurisdiction__c = 'MD';
            pp1.Has_Benefit_Details__c = false;
            pp1.Exclusive_Specialty_Provider_Network__c='Yes';
            pp1.RX_OOP_Max_Integration__c='Integrated';
            //insert pp1;
            ppList.add(pp1);
    
            Proposed_Products__c pp = new Proposed_Products__c();           
            pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp.Benefit_Request_Form__c =brf.id;
            pp.Funding_Arrangement__c = 'ASO';
            pp.Product_Category__c = 'Drug';
            pp.Product_Line__c = 'PPO';
            pp.Plan_Name__c = aiapln.id;
            pp.Product_Name__c = 'BlueChoice Advantage';
            pp.CDH__c = 'Yes';
            pp.CDH_Fund_Type__c = 'BlueFund';
            pp.Related_Medical_Product__c=pp1.id;
            pp.Exclusive_Specialty_Provider_Network__c='Yes';
            pp.CDH_Type__c = 'HSA';
            pp.Deductible__c = 'Stacked';
            pp.Grandfathered_Status__c = 'Grandfathered';
            pp.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp.Grandfathered_PPACA_Status__c = 'No';
            pp.Blue_Rewards__c = 'No';
            pp.Out_of_Pocket_Max__c = 'Stacked';
            pp.RX_OOP_Max_Integration__c='Integrated';
           // pp.Jurisdiction__c = 'MD';
            pp.Has_Benefit_Details__c = false;
            //insert pp;
            ppList.add(pp);
                 system.debug('ppd id drug pp'+pp);
 
     Proposed_Products__c pp2 = new Proposed_Products__c();           
            pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
            pp2.Benefit_Request_Form__c =brf.id;
            pp2.Funding_Arrangement__c = 'ASO';
            pp2.Product_Category__c = 'Drug';
            pp2.Product_Line__c = 'pp2O';
           pp2.Plan_Name__c = aiapln.id;
            pp2.Product_Name__c = 'BlueChoice Advantage';
            pp2.CDH__c = 'Yes';
            pp2.CDH_Fund_Type__c = 'BlueFund';
          pp2.Related_Medical_Product__c=pp.id;
            pp2.CDH_Type__c = 'HSA';
            pp2.Deductible__c = 'Stacked';
            pp2.Grandfathered_Status__c = 'Grandfathered';
            pp2.Integrated_Non_Integrated__c = 'Non-Integrated';
            pp2.Grandfathered_ppACA_Status__c = 'No';
            pp2.Blue_Rewards__c = 'No';
            pp2.Out_of_Pocket_Max__c = 'Stacked';
           // pp2.Jurisdiction__c = 'MD';
            pp2.Has_Benefit_Details__c = false;
            pp2.Exclusive_Specialty_Provider_Network__c='Yes';
            pp2.RX_OOP_Max_Integration__c='Integrated';

            //insert pp2;
            ppList.add(pp2);
            insert ppList;
                 system.debug('ppd id medical1'+pp2);

     
     //mod offshore

     AIA_Grouper__c ag = new AIA_Grouper__c();
      ag.Name = 'CostShareRanges';
      ag.Group_Type__c = 'Cost Share Group';
      ag.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag.Proposed_Products__c = pp.id;
  insert ag;
     AIA_Grouper__c ag1 = new AIA_Grouper__c();
      ag1.Name = 'CostShareRanges';
      ag1.Group_Type__c = 'Cost Share Group';
      ag1.Grouper_Record_Type__c = 'BRF';
        ag1.benefit_Custom__c=true;
         ag1.Benefit_Non_Standard__c=true;
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag1.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag1.Proposed_Products__c = pp2.id;
  insert ag1;
  system.debug('line 7036');
     //Creating Users Type Test Data
    List<user> userList = new list<user>();
        /*user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3); 
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);*/
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);
   
         insert userList;
    test.starttest();
     //Creating Account Team members Test Data
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
          acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
         
      
     insert acctMbrList;
    system.debug('line 67065');
    //Creating Implementation
     AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.Id;
       // Imp.Account__c = oppId.Account;
       // Imp.Account__c = Imp.Opportunity__r.AccountId;
       Imp.Account__c=acc.id;
        //Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c=brf.id;
        insert Imp;
    system.debug('line 67079');
     //Creating Benefit Design Test Data  
     AIA_Benefit_Design__c aiabd = new AIA_Benefit_Design__c();
        aiabd.Account__c = acc.id;
        aiabd.Benefit_Request_Form__c = brf.Id;
        aiaBD.Implementation__c = Imp.id;
        insert aiabd;
        system.debug('line 67086');
      // Craete BDP Test Data
       List<AIA_Benefit_Design_Product__c > bdpLst = new List<AIA_Benefit_Design_Product__c >();
       AIA_Benefit_Design_Product__c  bdp = AIA_TestUtil.createBDProductsForBD(aiabd,'Drug',aiapln.id,pp.id);
        bdp.Has_Benefit_Details__c = true;
        bdp.Funding_Arrangement__c = 'ASO';
        insert bdp;
        system.debug('line 67093');
    
    AIA_Grouper__c agobj=[select id,Group_Type__c,RecordTypeId,Benefit_Design_Product__c from  AIA_Grouper__c  limit 1];
      //agobj.Name='CostShareRanges';
      agobj.Benefit_Design_Product__c=bdp.id;
     // agobj.Group_Type__c = 'Cost Share Group';
      //agobj.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
      update agobj;
    
    system.debug('line 67102');
     
     //test.starttest();
        AIA_BenefitTriggerHandler.disableAdjustmentsOnInserts();
        AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();

  
           PageReference pref = Page.AIA_ProposedProd_Summary;
            system.debug('line 67110');
           Test.setCurrentPage(pref);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            ApexPages.StandardController con = new ApexPages.StandardController(PP);
            ApexPages.currentPage().getParameters().put('id',pp.id);
            AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
            system.debug('line 67116');
         //Commenting as part of US1650
         //ext.getPCSdata();
        ext.mainInit();
           ext.createWrapListFromPlan(pp);
        ext.createWrapListFromPlanCostShr(aiapln.id);
    system.debug('line 67122');
               AIA_BenefitTriggerHandler.resetAdjustmentPreviouslyCalledFlag();
    system.debug('line 67124');
       // AIA_BenefitTriggerHelperClass.UpdatecustomizedProperties(benlist);
         AIA_BenefitTriggerHelperClass.updateppbdp(pp2.id,bdp.id,true,false); 
    system.debug('line 67127');
    //AIA_BenefitTriggerHelperClass.validateCopayValues('2','3','4','','6','7');
     //AIA_BenefitTriggerHelperClass.validateCopayValues('3','7','4','5','6','3');
    // AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','4','5','6','3');
         // AIA_BenefitTriggerHelperClass.validateCopayValues('3','1','3','5','6','3');


        ext.saveAndCon();
        ext.addPlan();
        ext.saveandRedirct();
        ext.reviewInit();
        
       
        ext.back();
     
test.stoptest();            
    }
    
}