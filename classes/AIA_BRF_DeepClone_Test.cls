/*===================================================================================
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
*===================================================================================
* Date:         04/7/2017 
* Developer:    Sree Harsha
* Purpose:      Test class for AIA_BRF_DeepClone
* 
*==================================================================================
* Update History
* Date          Developer               Description
*==================================================================================
* 04/7/2017     Sree Harsha         Initial Development
* 09/24/2018    Paritosh         	Split the class
*==================================================================================
*/


@istest
public class AIA_BRF_DeepClone_Test {

public static testmethod void TestAIA_BRF_DeepClone1(){

          
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
   // brf.ARC_Approval_Status__c = 'Approved by Committee';
    brf.Escalated_to_Senior_Management__c = true;
    brf.Status__c = 'new';
    brf.Account__c = acc.id;
    brf.Opportunity__c = o.id;
    brf.Jurisdiction__c = 'MD';
    brf.Funding_Arrangements__c = 'Both';
    insert brf;
    system.assertNOTEquals(brf,Null);
    
    AIA_Document__c fileNetDoc = new AIA_Document__c();
    fileNetDoc.Document_Type__c='Signed Quote';
    fileNetDoc.Approval_Status__c='Approved';
    fileNetDoc.Benefit_Request_Form__c = brf.id;
    insert fileNetDoc;
    system.assertNOTEquals(fileNetDoc,Null);    
    
    Attachment att=AIA_TestUtil.createAttachment(fileNetDoc.Id); 
    system.assertNOTEquals(att,Null);  
      
    AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
    aiapln.Plan_Name__c='Test Plan';
    aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
    aiapln.Jurisdiction__c = 'MD';
    insert aiapln;
    system.assertNOTEquals(aiapln,Null);
    
    createPlanData(aiapln);

          
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
    
        
        AIA_Grouper__c ag = new AIA_Grouper__c();
        ag.Name = 'CostShareRanges';
        ag.Group_Type__c = 'Cost Share Group';
        ag.Grouper_Record_Type__c = 'BRF';
        ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
        ag.Proposed_Products__c = pp.id;
        insert ag;
        system.assertNOTEquals(ag,Null);

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
        system.assertNOTEquals(ab,Null);
    test.starttest();    
    PageReference pref = Page.AIA_BRF_DeepClone;
    Test.setCurrentPage(pref);
    ApexPages.currentPage().getParameters().put('id',brf.id);
    ApexPages.StandardController con = new ApexPages.StandardController(brf);
    
    ApexPages.currentPage().getParameters().put('id', brf.id);
    ApexPages.currentPage().getParameters().put('planid', aiapln.id);
     ApexPages.currentPage().getParameters().put('palanIdValue','BRF');
    ApexPages.currentPage().getParameters().put('PPID', pp.id);
    ApexPages.currentPage().getParameters().put('PPName', pp.name);
    AIA_BRF_DeepClone ext = new AIA_BRF_DeepClone(con);
    ext.getRelatedAIADocument();
    ext.getSelectedAIADoc();
   
    
    ext.ValidateAndCallPCS();
    AIA_BRF_DeepClone.PPWrapper Wrapvar = new AIA_BRF_DeepClone.PPWrapper(pp,true);
    AIA_BRF_DeepClone.AIADocumentWrapper AIADocWrapvar = new AIA_BRF_DeepClone.AIADocumentWrapper(fileNetDoc,true);

         
    ext.lstPPWrapper.add(Wrapvar);
    ext.AIA_DocWrapList.add(AIADocWrapvar);
    ext.ValidateAndCallPCS();
    boolean IsBrfPanel = true;
    ext.next();
    boolean IsPPPanel = true;
    ext.next();
    boolean IsSummaryPanel = true;
    ext.back();
    //ext.deletePP();
    ext.cancelButton();
    //ext.deleteBDP();
     test.stopTest();
    }

   
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
        
        createPlanData(aiapln);
        
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
        
        /*AIA_Grouper__c ag = new AIA_Grouper__c();
ag.Name = 'Surgery';
ag.Group_Type__c = 'Benefit Group';
ag.Grouper_Record_Type__c = 'BRF';
ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
ag.Proposed_Products__c = pp.id;
ag.Benefit_Design_Product__c = aiaBDP1.id;
insert ag;
system.assertNOTEquals(ag,Null);

AIA_Benefits__c ab = new AIA_Benefits__c();           
ab.Grouper__c = ag.id;
ab.Benefit_Name__c = 'Removal of Impacted Teeth';
ab.Benefit_Type__c = 'Benefit';
ab.Type__c = 'Benefit';           
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
ab.RecordTypeId =Schema.SObjectType.AIA_Benefits__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId(); 
insert ab;
system.assertNOTEquals(ab,Null);*/
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
    
    //Create Plan Data.
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
        pg.Record_Type__c = 'BRF';
        pg.ExtID__c = 'PLAN-001N_BDD1CSG_BDD00';
        insert pg;
        
        AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
        pg2.Name = 'CostShareRanges';
        pg2.Plan_Network__c = pn2.id;
        pg2.Type__c = 'Cost Share Group';
        pg2.Record_Type__c = 'BRF';
        pg2.ExtID__c = 'PLAN-001N_BDD1CSG_BDD002';
        insert pg2;
        
        AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
        pg3.Name = 'Medical Supplies/Equipment-0628';
        pg3.Plan_Network__c = pn.id;
        pg3.Type__c = 'Benefit Group';
        pg3.Sequence_Number__c = 1;
        pg3.Record_Type__c = 'BRF';
        pg3.ExtID__c = 'PLAN-001N_BDD1CSG_BDD00432';
        insert pg3;
        
        AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
        pg4.Name = 'Medical Supplies/Equipment-0629';
        pg4.Plan_Network__c = pn2.id;
        pg4.Type__c = 'Benefit Group';
        pg4.Sequence_Number__c = 1;
        pg4.Record_Type__c = 'BRF';
        pg4.ExtID__c = 'PLAN-001N_BDD1CSG_BDD002433';
        insert pg4;
        
        
        List<AIA_Plan_Benefits__c> AIAPBLst = new List<AIA_Plan_Benefits__c>();
        
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
        AIAPBLst.add(pb);
        
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
        AIAPBLst.add(pb29);
        
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
        AIAPBLst.add(pb2);
        
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
        AIAPBLst.add(pb3);
        
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
        AIAPBLst.add(pb4);
        
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
        AIAPBLst.add(pb5);
        
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
        AIAPBLst.add(pb6);
        
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
        AIAPBLst.add(pb7);
        
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
        AIAPBLst.add(pb8);
        
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
        AIAPBLst.add(pb9);
        
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
        AIAPBLst.add(pb10);
        
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
        AIAPBLst.add(pb11);
        
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
        AIAPBLst.add(pb13);
        
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
        AIAPBLst.add(pb14);
        
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
        AIAPBLst.add(pb15);
        
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
        AIAPBLst.add(pb16);
        
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
        AIAPBLst.add(pb17);
        
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
        AIAPBLst.add(pb18);
        
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
        AIAPBLst.add(pb19);
        
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
        AIAPBLst.add(pb20);
        
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
        AIAPBLst.add(pb21);
        
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
        AIAPBLst.add(pb22);
        
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
        AIAPBLst.add(pb23);     
        
        insert AIAPBLst;   
        
        
        
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
        
    }  

}