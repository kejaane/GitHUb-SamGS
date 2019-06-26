@isTest
public class AIA_BRF_DeepClone_Test2 {

    
     public static testmethod void Test_AIA_BRF_DeepClone_TestCaseCustomisedtrue(){
       /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);*///Removed per US210

        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNOTEquals(acc,Null);
       
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
        //o.Workplan_Type__c = wpt.id;//Removed per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = date.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
        brf.Enrollment_Type__c = 'Cafeteria';
        insert brf;
        system.assertNOTEquals(brf,Null);
system.debug('==test==brf==' + brf);
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        system.assertNOTEquals(aiapln,Null);
    
        AIA_BRF_DeepClone_Test.createPlanData(aiapln);

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
        pp.Rider__c = 'None';
        //pp.Effective_Date__c = date.today();
        insert pp;
        system.assertNOTEquals(pp,Null);
        system.debug('==test==PP==' + pp);
       
        
        
        
        
        test.starttest();
        Proposed_Products__c pp1= new Proposed_Products__c();           
        pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
        pp1.Benefit_Request_Form__c = brf.id;
        pp1.Funding_Arrangement__c = 'ASO';
        pp1.Product_Category__c = 'Medical';
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
        pp1.Blue_Rewards__c = 'No';
        pp1.Out_of_Pocket_Max__c = 'Stacked';
        pp1.Has_Benefit_Details__c =false;
        pp1.Rider__c = 'None';
        //pp1.Effective_Date__c = date.today();
        insert pp1;
        system.assertNOTEquals(pp1,Null);
        
        PP1 = [select id,name,Benefit_Request_Form__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c from Proposed_Products__c where id =:pp1.id];     
        system.assertNOTEquals(pp1,Null);
        
        
       
        
        Proposed_Products__c pp3= new Proposed_Products__c();           
        pp3.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
        pp3.Benefit_Request_Form__c = brf.id;
        pp3.Funding_Arrangement__c = 'ASO';
        pp3.Product_Category__c = 'Medical';
        pp3.Product_Line__c = 'PPO';
        pp3.Plan_Name__c = aiapln.id;
        pp3.Product_Name__c = 'BlueChoice Advantage';
        pp3.CDH__c = 'Yes';
        pp3.CDH_Fund_Type__c = 'BlueFund';
        pp3.CDH_Type__c = 'HSA';
        pp3.Deductible__c = 'Stacked';
        pp3.Grandfathered_Status__c = 'Grandfathered';
        pp3.Integrated_Non_Integrated__c = 'Yes';
        pp3.Grandfathered_PPACA_Status__c = 'No';
        pp3.Blue_Rewards__c = 'No';
        pp3.Out_of_Pocket_Max__c = 'Stacked';
        pp3.Has_Benefit_Details__c =false;
        pp3.Rider__c = 'None';
        //pp3.Effective_Date__c = date.today();
        insert pp3;
        system.assertNOTEquals(pp3,Null);
        
        PP3 = [select id,name,Benefit_Request_Form__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c from Proposed_Products__c where id =:pp3.id];     
        system.assertNOTEquals(pp3,Null);
        
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'CostShareRanges';
        ag1.Group_Type__c = 'Benefit Group';
      //  ag1.Benefit_Design_Product__c = aiaPP3.id;
        ag1.Grouper_Record_Type__c = 'BRF';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp3.id;
        insert ag1;
 
        
       
        
        
        AIA_Benefits__c ab = new AIA_Benefits__c();           
        ab.Grouper__c = ag1.id;
        ab.Benefit_Name__c = 'Family Out Of Pocket2';
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
        ab.Coinsurance_DefaultAmount__c = 'No';
        ab.Copay_Type_1_Default_IsCovered__c = 'Yes';
        ab.Copay_Type_1_Default_DeductibleApplies__c = 'No';
        ab.Copay_Type_1_DefaultAmount__c = 'No';
        //ab1.NewBenefitValue__c= 'Yes';
        ab.DefaultPlanBenefitValue__c = 'No';
        ab.Copay_Type_1_AmountValueSelected__c = 'Yes';
        ab.OON_Coinsurance_DefaultAmount__c = '';
        ab.OON_CoInsurance_AmountValueSelected__c= 'No';
        ab.OON_Copay_Type_1_Default_IsCovered__c = 'Yes';
        //ab.OON_Copay_Type_1_IsCovered__cc= 'No';
        ab.OON_Copay_1_Default_DeductibleApplies__c= 'Yes';
        ab.OON_Copay_Type_1_DeductibleApplies__c= 'No';
        ab.OON_Copay_Type_1_DefaultAmount__c= 'Yes';
        ab.OON_Copay_Type_1_AmountValueSelected__c= 'No';
        ab.OON_Copay_Type_2_DefaultAmount__c= 'Yes';
        ab.OON_Copay_Type_2_AmountValueSelected__c= 'No';
        ab.Benefit_non_standard__c = false;
        insert ab;  

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BRF';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BRF';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='wdwd';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BRF';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        apbt.IS_ASO_Only__c='Yes';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BRF';
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
        planCopyLst.add(apcty);
        insert planCopyLst;     
Set<id> setPlanLimids = new Set<id>();
        List<AIA_Plan_Limitation__c> planList = new List<AIA_Plan_Limitation__c>();
        AIA_Plan_Limitation__c obj = new AIA_Plan_Limitation__c();
        obj.TierAgeFrom__c = 10;
        obj.TierAgeTo__c = 20;
        obj.TierAgeType__c = 'Years';
        obj.TierLimitDurationType__c = 'Plan Year';
        obj.TierLimitFrom__c = 30;
        obj.TierLimitTo__c = 50;
        obj.TierLimitType__c = 'Days';
        obj.Type__c = 'TierLimit';
        obj.Plan_Benefits__c = apbt.id;
        obj.MandateIndicator__c = false;
                obj.Effective_Date__c=system.today();

        planList.add(obj);


       
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
               obj3.Plan_Benefits__c = apbt1.id;
               obj3.MandateIndicator__c = false;
               obj3.Effective_Date__c=system.today();

        planList.add(obj3);
        insert planList;

        for(AIA_Plan_Limitation__c planobj:planList)
        {
            setPlanLimids.add(planobj.id);
        }

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

        Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
        lmt.Benefit__c = ab.id;
       
        insert lmt;
        Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
        lmt2.Benefit__c = ab.id;
        insert lmt2;

        Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
        lmt3.Benefit__c = ab.id;
        insert lmt3;
        
         AIA_Document__c aiaDoc1 = new AIA_Document__c();
        aiaDoc1.Proposed_products__c = pp.id;
        aiaDoc1.Account__c=acc.id;
        aiaDoc1.Approval_Status__c = 'Approved';
        aiaDoc1.Start_Date__c = System.today();
        aiaDoc1.End_Date__c = System.today()+10;
        aiaDoc1.Document_Type__c = 'Account Kick-off';
        aiaDoc1.Benefit_Request_Form__c = brf.id;
        insert aiaDoc1;
        AIA_Document__c aiaDoc2 = new AIA_Document__c();
        aiaDoc2.Account__c=acc.id;
        aiaDoc2.Approval_Status__c = 'Approved';
        aiaDoc2.Start_Date__c = System.today();
        aiaDoc2.End_Date__c = System.today()+10;
        aiaDoc2.Document_Type__c = 'Account Kick-off';
        aiaDoc2.Benefit_Request_Form__c = brf.id;
        insert aiaDoc2;
        system.assertNOTEquals(aiaDoc2,Null);
        
        AIA_Document__c aiaDoc3 = new AIA_Document__c();
        aiaDoc3.Proposed_products__c = pp3.id;
        aiaDoc3.Account__c=acc.id;
        aiaDoc3.Approval_Status__c = 'Approved';
        aiaDoc3.Start_Date__c = System.today();
        aiaDoc3.End_Date__c = System.today()+10;
        aiaDoc3.Document_Type__c = 'Account Kick-off';
        aiaDoc3.Benefit_Request_Form__c = brf.id;
        insert aiaDoc3;
        system.assertNOTEquals(aiaDoc3,Null);
        Attachment att=AIA_TestUtil.createAttachment(aiaDoc3.Id);
        system.assertNOTEquals(att,Null);
        PageReference pref = Page.AIA_BRF_DeepClone;
      Test.setCurrentPage(pref);
      //ApexPages.currentPage().getParameters().put('id',Imp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(brf);
      ApexPages.currentPage().getParameters().put('id', brf.id);
      ApexPages.currentPage().getParameters().put('planid', aiapln.id);
      AIA_BRF_DeepClone ext = new AIA_BRF_DeepClone(con);
      ApexPages.currentPage().getParameters().put('palanIdValue','BRF');
      ApexPages.currentPage().getParameters().put('PPID', PP3.id);
      ApexPages.currentPage().getParameters().put('PPName', PP3.name);
      ext.brf.Account__c = acc.id;
      ext.getRelatedAIADocument();
      ext.getSelectedAIADoc();
      AIA_BRF_DeepClone.PPWrapper Wrapvar = new AIA_BRF_DeepClone.PPWrapper(PP3,true);
      AIA_BRF_DeepClone.PPWrapper Wrapvar1 = new AIA_BRF_DeepClone.PPWrapper(PP1,true);
       AIA_BRF_DeepClone.AIADocumentWrapper aiadocwrap = new AIA_BRF_DeepClone.AIADocumentWrapper(aiaDoc1,true);
      ext.AIA_DocWrapList.add(aiadocwrap);
      ext.lstPPWrapper.add(Wrapvar);
      ext.lstPPWrapper.add(Wrapvar1);
        ext.Istestdata = true;
      AIA_BRF_DeepClone.CopayTypeWrapper xyz = new AIA_BRF_DeepClone.CopayTypeWrapper();
       xyz.copayTypeSelectedObj = apcty; 
       xyz.copayTypePecSpecObj = apcty;
       xyz.copayTypeSelectedObj2 = apcty;
       xyz.copayTypePecSpecObj2 = apcty;
       ext.copayBenMap.put('Family Out Of Pocket2',xyz);
       ext.copayBenMap.put('Individual Out Of Pocket2',xyz);
      boolean IsBrfPanel = true;
      ext.next();
      boolean IsPPPanel = true;
      ext.ValidateAndCallPCS();
     ext.next();
     // boolean IsSummaryPanel = true;
      //  ext.save();
      ext.back();
        
        ext.cancelButton();
      // ext.IsSummaryPanel = true;
      //   ext.next();
      
     // ext.ValidateAndCallPCS();
        test.stopTest(); 
     
    }
   
    public static testmethod void Test_AIA_BRF_DeepClone_TestCase3(){
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
    system.assertNOTEquals(wpt,Null);*///Removed per US210

        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        
    
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
        //o.Workplan_Type__c = wpt.id;//Removed per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
    system.assertNOTEquals(o,Null);
        
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
    system.assertNOTEquals(brf,Null);

        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
    system.assertNOTEquals(aiapln,Null);

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
        pp.Rider__c = 'None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        test.starttest();
      
       
        
        
        PageReference pref = Page.AIA_BRF_DeepClone;
      Test.setCurrentPage(pref);
      //ApexPages.currentPage().getParameters().put('id',Imp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(brf);
      ApexPages.currentPage().getParameters().put('id', brf.id);
      ApexPages.currentPage().getParameters().put('planid', aiapln.id);
      AIA_BRF_DeepClone ext = new AIA_BRF_DeepClone(con);
      ApexPages.currentPage().getParameters().put('palanIdValue','BRF');
        test.stopTest(); 
     
  }


  public static testmethod void Test_AIA_BRF_DeepClone_TestCase4(){
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);*///Removed per US210

        Account acc = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNOTEquals(acc,Null);
        
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
        //o.Workplan_Type__c = wpt.id;//Removed per US210
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        insert o;
        system.assertNOTEquals(o,Null);
        
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
        brf.enrollment_type__c = 'Cafeteria';
        insert brf;
        system.assertNOTEquals(brf,Null);

        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = False;
        insert aiapln;
        //aiapln.BDF_Configuration_Last_Updated__c = datetime.now();
        //update aiapln;
        system.assertNOTEquals(aiapln,Null);
        system.assertNOTEquals(aiapln.Id,Null);
        AIA_BRF_DeepClone_Test.createPlanData(aiapln);

    AIA_Plan__c aiaplnProd = AIA_TestUtil.CreateGSMPlan('Medical1','Test1');
        aiaplnProd.Plan_Name__c='Test Plan11';
        aiaplnProd.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiaplnProd.Jurisdiction__c = 'MD';
        aiaplnProd.Product_Status__c ='Closed';
        aiaplnProd.Has_Benefit_Summary__c = False;
        insert aiaplnProd;
        //aiapln.BDF_Configuration_Last_Updated__c = datetime.now();
        //update aiapln;
        system.assertNOTEquals(aiaplnProd,Null);
        system.assertNOTEquals(aiaplnProd.Id,Null);
        
        test.starttest();
        
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
        pp.Rider__c = 'None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
        
        
        list<Proposed_Products__c> ppList = new list<Proposed_Products__c>();
        Proposed_Products__c pp1 = new Proposed_Products__c();           
        pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
        pp1.Benefit_Request_Form__c = brf.id;
        pp1.Funding_Arrangement__c = 'ASO';
        pp1.Product_Category__c = 'Medical';
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
        pp1.Blue_Rewards__c = 'No';
        pp1.Out_of_Pocket_Max__c = 'Stacked';
        pp1.Has_Benefit_Details__c =True;
        pp1.Rider__c = 'None';
        insert pp1;
        system.assertNOTEquals(pp1,Null);
        PP1 = [select id,name,Benefit_Request_Form__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c from Proposed_Products__c where id =:PP1.id];     
        system.assertNOTEquals(PP1,Null);
        
        Proposed_Products__c pp2 = new Proposed_Products__c();           
        pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
        pp2.Benefit_Request_Form__c = brf.id;
        pp2.Funding_Arrangement__c = 'Both';
        pp2.Product_Category__c = 'Medical';
        pp2.Product_Line__c = 'PPO';
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
        pp2.Has_Benefit_Details__c =True;
        pp2.FirstHelp__c = '';
        pp2.Rider__c = 'None';
        
        //ppList.add(pp2);
        insert pp2;
        //system.assertNOTEquals(pp2,Null)
        
        Proposed_Products__c pp3 = new Proposed_Products__c();           
        pp3.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
        pp3.Benefit_Request_Form__c = brf.id;
        pp3.Funding_Arrangement__c = 'ASO';
        pp3.Product_Category__c = 'Medical';
        pp3.Product_Line__c = 'PPO';
        pp3.Plan_Name__c = aiapln.id;
        pp3.Product_Name__c = 'BlueChoice Advantage';
        pp3.CDH__c = 'Yes';
        pp3.CDH_Fund_Type__c = 'BlueFund';
        pp3.CDH_Type__c = 'HSA';
        pp3.Deductible__c = 'Stacked';
        pp3.Grandfathered_Status__c = 'Grandfathered';
        pp3.Integrated_Non_Integrated__c = 'Yes';
        pp3.Grandfathered_PPACA_Status__c = 'No';
        pp3.Blue_Rewards__c = 'No';
        pp3.Out_of_Pocket_Max__c = 'Stacked';
        pp3.Has_Benefit_Details__c =True;
        pp3.Rider__c = 'None';
        
        ppList.add(pp3);
        
        
        Proposed_Products__c pp4 = new Proposed_Products__c();           
        pp4.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
        pp4.Benefit_Request_Form__c = brf.id;
        pp4.Funding_Arrangement__c = 'ASO';
        pp4.Product_Category__c = 'Medical';
        pp4.Product_Line__c = 'PPO';
        pp4.Plan_Name__c = aiapln.id;
        pp4.Product_Name__c = 'BlueChoice Advantage';
        pp4.CDH__c = 'Yes';
        pp4.CDH_Fund_Type__c = 'BlueFund';
        pp4.CDH_Type__c = 'HSA';
        pp4.Deductible__c = 'Stacked';
        pp4.Grandfathered_Status__c = 'Grandfathered';
        pp4.Integrated_Non_Integrated__c = 'Yes';
        pp4.Grandfathered_PPACA_Status__c = 'No';
        pp4.Blue_Rewards__c = 'No';
        pp4.Out_of_Pocket_Max__c = 'Stacked';
        pp4.Has_Benefit_Details__c =True;
        pp4.Rider__c = 'None';
        pp4.Cloned_From__c = pp1.id;
        ppList.add(pp4);
        insert ppList;
      
        
        AIA_Document__c aiaDoc1 = new AIA_Document__c();
        aiaDoc1.Proposed_Products__c=pp4.id;
        aiaDoc1.Account__c=acc.id;
        aiaDoc1.Approval_Status__c = 'Approved';
        aiaDoc1.Start_Date__c = System.today();
        aiaDoc1.End_Date__c = System.today()+10;
        insert aiaDoc1;
        system.assertNOTEquals(aiaDoc1,Null);
        
        Attachment att=AIA_TestUtil.createAttachment(aiaDoc1.Id);
        system.assertNOTEquals(att,Null);
        
        Proposed_Products__c aiaPPMed = new Proposed_Products__c();
        
        ppList = [select id,name,Benefit_Request_Form__c,Plan_Name__c,Product_Category__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c from Proposed_Products__c where Id IN: ppList];     
        system.assertNOTEquals(ppList,Null);
        system.assertEquals(ppList.size(),2);
        
        for(Proposed_Products__c pps:ppList){
          if(pps.Product_Category__c =='Medical')
            aiaPPMed = pps;
        }
        AIA_Grouper__c ag1 = new AIA_Grouper__c();
        ag1.Name = 'CostShareRanges1';
        ag1.Group_Type__c = 'Benefit Group';
        ag1.Proposed_Products__c = pplist[1].id;
        ag1.Grouper_Record_Type__c = 'BRF';
        ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
        ag1.Sequence_Number__c = 1;
        ag1.Proposed_Products__c = pp.id;
        insert ag1;

        AIA_Grouper__c ag2 = new AIA_Grouper__c();
        ag2.Name = 'CostShareRanges1';
        ag2.Group_Type__c = 'Benefit Group';
        ag2.Proposed_Products__c = ppList[0].id;
        ag2.Grouper_Record_Type__c = 'BRF';
        ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
        ag2.Sequence_Number__c = 2;
        ag2.Proposed_Products__c = pp.id;
        insert ag2;

        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag1.id;
        ab1.Benefit_Name__c = 'Individual Out Of Pocket1';
        ab1.Benefit_Type__c = 'Mandate';
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
        
        AIA_Benefits__c ab2 = new AIA_Benefits__c();           
        ab2.Grouper__c = ag2.id;
        ab2.Benefit_Name__c = 'Individual Out Of Pocket1';
        ab2.Benefit_Type__c = 'Mandate';
        ab2.Type__c = 'Cost Share';           
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
        ab2.OON_Copay_Type_1_IsCovered__c = 'No';
        ab2.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab2.Copay_Type_1_AliasName__c='Test';
        ab2.Copay_Type_2_AliasName__c='Test';
        ab2.OON_Copay_Type_1_AliasName__c='Test';
        ab2.OON_Copay_Type_2_AliasName__c='Test';
        ab2.OON_Copay_Type_2_DefaultAmount__c ='No';
        insert ab2;  
        ab2.CoInsurance_AmountValueSelected__c = 'Yes';
        ab2.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab2.Copay_Type_1_AmountValueSelected__c = 'Yes';
        update ab2;
        
        
        AIA_Benefits__c ab = new AIA_Benefits__c();           
        ab.Grouper__c = ag1.id;
        ab.Benefit_Name__c = 'Family Out Of Pocket1';
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
        
        AIA_Benefits__c ab22 = new AIA_Benefits__c();           
        ab22.Grouper__c = ag1.id;
        ab22.Benefit_Name__c = 'Family Out Of Pocket1';
        ab22.Benefit_Type__c = 'Limitation';
        ab22.Type__c = 'Cost Share';           
        ab22.Benefit_Record_Type__c = 'BRF';
        ab22.Cost_Share_Low__c = '0';
        ab22.Cost_Share_High__c = '100';
        ab22.Cost_Share_Increment__c = '10';
        ab22.Cost_Share_InvalidIncrements__c = '30';
        ab22.Cost_Share_AdditionalIncrements__c = '33';
        ab22.OON_Cost_Share_Low__c = '0';
        ab22.OON_Cost_Share_High__c = '1000';
        ab22.OON_Cost_Share_Increment__c = '100';
        ab22.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab22.OON_Cost_Share_InvalidIncrements__c = '300';
        ab22.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab22.Copay_Type_1_IsCovered__c = 'No';
        ab22.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab22.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab22.Copay_Type_1_AliasName__c='Test';
        ab22.Copay_Type_2_AliasName__c='Test';
        ab22.OON_Copay_Type_1_AliasName__c='Test';
        ab22.OON_Copay_Type_2_AliasName__c='Test';
        insert ab22;  

        AIA_Plan_Network__c pn = new AIA_Plan_Network__c();
        pn.ExtID__c = '33r34t33dr';
        pn.Plan__c=aiapln.id;
        pn.Record_Type__c='BRF';
        insert pn;

        AIA_Plan_Grouper__c apg = new AIA_Plan_Grouper__c();
        apg.ExtID__c =  '33r34t33dr';
        apg.ISExisting_Grouper__c = true;  
        apg.Plan__c = aiapln.id;
        apg.Record_Type__c = 'BRF';
        apg.Plan_Grouper_Name__c = '2233df';
        apg.Plan_Network__c = pn.id;
        apg.Sequence_Number__c = 1;
        insert apg;  
        
        AIA_Plan_Grouper__c apg1 = new AIA_Plan_Grouper__c();
        apg1.ExtID__c =  '33r34t33dr2';
        apg1.ISExisting_Grouper__c = false;  
        apg1.Plan__c = aiapln.id;
        apg1.Record_Type__c = 'BRF';
        apg1.Plan_Grouper_Name__c = '2233df';
        apg1.Plan_Network__c = pn.id;
        apg1.Sequence_Number__c = 2;
        insert apg1; 
        
        AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
        apbt.Benefit_Name__c ='wdwd';
        apbt.Benefit_Group__c = apg.id;
        apbt.Record_Type__c = 'BRF';
        apbt.Sequence_Number__c = 1;
        apbt.Coinsurance_DefaultAmount__c = '2323';   
        apbt.ISExisting_Benefit__c = True;
        apbt.Type__c='Benefit';
        insert apbt;
        
        AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
        apbt1.Benefit_Name__c ='wdwd1';
        apbt1.Benefit_Group__c = apg.id;
        apbt1.Record_Type__c = 'BRF';
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

        Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
        lmt.Benefit__c = ab.id;
        insert lmt;
        Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
        lmt.Benefit__c = ab.id;
        insert lmt2;

        Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
        lmt.Benefit__c = ab.id;
        insert lmt3;
       
        PageReference pref = Page.AIA_BRF_DeepClone;
        Test.setCurrentPage(pref);
        //ApexPages.currentPage().getParameters().put('id',Imp.id); 
        ApexPages.StandardController con = new ApexPages.StandardController(brf);
        ApexPages.currentPage().getParameters().put('id', brf.id);
        ApexPages.currentPage().getParameters().put('planid', aiapln.id);
        AIA_BRF_DeepClone ext = new AIA_BRF_DeepClone(con);
        ApexPages.currentPage().getParameters().put('palanIdValue','BDD');
        ApexPages.currentPage().getParameters().put('PPID', PP1.id);
        ApexPages.currentPage().getParameters().put('PPName', PP1.name);
        ext.brf.Account__c = acc.id;
        ext.getRelatedAIADocument();
        ext.getSelectedAIADoc();
        
        ext.copayBenMap = new Map<string, AIA_BRF_DeepClone.CopayTypeWrapper>();
        AIA_BRF_DeepClone.CopayTypeWrapper xyz = new AIA_BRF_DeepClone.CopayTypeWrapper();
        xyz.copayTypeSelectedObj = apcty; 
        xyz.copayTypePecSpecObj = apcty;
        xyz.copayTypeSelectedObj2 = apcty;
        xyz.copayTypePecSpecObj2 = apcty;
        ext.copayBenMap.put('Individual Deductible1',xyz);
        ext.copayBenMap.put('Individual Out Of Pocket1',xyz);
        boolean IsBrfPanel = true;
        ext.next();
        list<AIA_Grouper__c> gList = new list<AIA_Grouper__c>();
        ext.lstPPWrapper = new list<AIA_BRF_DeepClone.PPWrapper>();
        AIA_BRF_DeepClone.PPWrapper Wrapvar = new AIA_BRF_DeepClone.PPWrapper(ppList[1],true);
        AIA_BRF_DeepClone.PPWrapper Wrapvar1 = new AIA_BRF_DeepClone.PPWrapper(ppList[0],false);
        AIA_BRF_DeepClone.PPWrapper Wrapvar2 = new AIA_BRF_DeepClone.PPWrapper(pp2,true);
        ext.lstPPWrapper.add(Wrapvar);
        ext.lstPPWrapper.add(Wrapvar1);
        ext.lstPPWrapper.add(Wrapvar2);
        boolean IsPPPanel = true;
       // ext.next();
        gList.add(ag2);
        ext.ClonebenifitFromCopay('Individual Out Of Pocket1',pp2,gList,1,1);
        boolean IsSummaryPanel = true;
        ext.back();
        ext.erroMessages = new set<string>();
        ext.erroMessages.add(ppList[0].Name);
        ext.deletePP();
        ApexPages.currentPage().getParameters().put('planid', aiaplnProd.id);
        ext.ValidateAndCallPCS();
        ext.AIADoc = new list<AIA_Document__c>();
        ext.selPPList = new list<Proposed_Products__c>();
        ApexPages.currentPage().getParameters().put('id', brf.id);
        //aiapln.Has_Benefit_Summary__c = false;
        //update aiapln;
        ApexPages.currentPage().getParameters().put('planid', aiapln.id);
        ApexPages.currentPage().getParameters().put('palanIdValue','BRF');
        ApexPages.currentPage().getParameters().put('PPID', aiaPPMed.id);
        ApexPages.currentPage().getParameters().put('PPName', aiaPPMed.name);
        //ext.ValidateAndCallPCS();
        IsSummaryPanel = false;
        IsPPPanel = true;
        ApexPages.currentPage().getParameters().put('planid', '');
        test.stopTest(); 
     
    } 
}