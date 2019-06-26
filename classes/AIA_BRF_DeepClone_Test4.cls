@isTest
public class AIA_BRF_DeepClone_Test4 {
	
        public static testmethod void Test_AIA_BRF_DeepClone_TestCase5(){
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
wpt.Used_For__c ='Pre-Sales';
wpt.Workplan_Type__c = 'New';
wpt.Active__c=true;
insert wpt;
system.assertNOTEquals(wpt,Null);*/
        
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
        brf.Benefit_Effective_Date__c = Date.newInstance(2014,10,1);
        // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'Both';
        brf.Request_Type__c='Set-up Change - Administrative Changes';
        insert brf;
        system.assertNOTEquals(brf,Null);
        
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Product_Status__c ='Active';
        aiapln.Has_Benefit_Summary__c = true;
        insert aiapln;
        //aiapln.BDF_Configuration_Last_Updated__c = datetime.now();
        //update aiapln;
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
        list<AIA_Benefits__c> bnftList = new list<AIA_Benefits__c>();
        AIA_Benefits__c ab = new AIA_Benefits__c();           
        ab.Grouper__c = ag.id;
        ab.Benefit_Name__c = 'Family Out Of Pocket2';
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
        //ab.Copay_Type_1_Amount_Customized__c = true;
        //ab.Benefit_Customized__c = true;
        bnftList.add(ab);
        
        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag.id;
        ab1.Benefit_Name__c = 'Family Out Of Pocket2';
        ab1.Benefit_Type__c = 'Benefit';
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
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.Copay_Min_Payment__c = '20';
        ab1.Copay_Max_Payment__c = '30';
        ab1.OON_Copay_Min_Payment__c = '10';
        ab1.OON_Copay_Max_Payment__c = '10';
        //ab1.Copay_Type_1_Amount_Customized__c = false;
        //ab1.Benefit_Customized__c = false;
        bnftList.add(ab1);
        insert bnftList;
        system.assertNOTEquals(bnftList,Null);
        
        test.starttest();
        //AIA_BenefitTriggerHelperClass.UpdatecustomizedProperties(bnftList);
        
        
        AIA_Document__c aiaDoc1 = new AIA_Document__c();
        aiaDoc1.Proposed_products__c = pp.id;
        aiaDoc1.Account__c=acc.id;
        aiaDoc1.Approval_Status__c = 'Approved';
        aiaDoc1.Start_Date__c = System.today();
        aiaDoc1.End_Date__c = System.today()+10;
        aiaDoc1.Document_Type__c = 'Account Kick-off';
        aiaDoc1.Benefit_Request_Form__c = brf.id;
        insert aiaDoc1;
        system.assertNOTEquals(aiaDoc1,Null);
        
        Attachment att=AIA_TestUtil.createAttachment(aiaDoc1.Id);
        system.assertNOTEquals(att,Null);
        
        PageReference pref = Page.AIA_BRF_DeepClone;
        Test.setCurrentPage(pref);
        //ApexPages.currentPage().getParameters().put('id',Imp.id);
        ApexPages.StandardController con = new ApexPages.StandardController(brf);
        ApexPages.currentPage().getParameters().put('id', brf.id);
        ApexPages.currentPage().getParameters().put('planid', aiapln.id);
        AIA_BRF_DeepClone ext = new AIA_BRF_DeepClone(con);
        ApexPages.currentPage().getParameters().put('palanIdValue','BRF');
        ApexPages.currentPage().getParameters().put('PPID', pp.id);
        ApexPages.currentPage().getParameters().put('PPName', pp.name);
        ext.brf.Account__c = acc.id;
        ext.getRelatedAIADocument();
        ext.getSelectedAIADoc();
        ext.ValidateAndCallPCS();
        ext.AIA_DocWrapList = new list<AIA_BRF_DeepClone.AIADocumentWrapper>();
        //AIA_BD_DeepClone_Final.BDPWrapper Wrapvar1 = new AIA_BD_DeepClone_Final.BDPWrapper(aiaBDP1,False);
        AIA_BRF_DeepClone.AIADocumentWrapper WrapDoc = new AIA_BRF_DeepClone.AIADocumentWrapper(aiaDoc1,true);
        
        //ext.lstBDPWrapper.add(Wrapvar1);
        ext.AIA_DocWrapList.add(WrapDoc);
        
        //ext.ValidateAndCallPCS();
        boolean IsBrfPanel = true;
        ext.next();
        boolean IsPPPanel = true;
        ext.next();
        test.stopTest(); 
        
    } 
    
    public static testmethod void TestAIA_BRF_DeepCloneHelper(){

     API_ENDPOINT_URLS__c cs = new API_ENDPOINT_URLS__c();
        cs.name='PCS_APIDetails';
        cs.ENDPOINT_URL__c = 'https://servicestt.carefirst.com/pcs7devb/PRRestService/PCSSFDCIntegrator/RESTJSON/SendPlanDetails';        
        insert cs;
        AIA_Plan__c plan = AIA_TestUtil.CreatePlan('PLAN - 1111');
        Test.setMock(HttpCalloutMock.class, new AIA_WebServiceMOCKPCSIntegration());      
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
      
    
    AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
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
        pp.Has_Benefit_Details__c =True;
        pp.Rider__c = 'None';
        insert pp;
        system.assertNOTEquals(pp,Null);
        
         test.starttest();    
    PageReference pref = Page.AIA_BRF_DeepClone;
    Test.setCurrentPage(pref);
    ApexPages.currentPage().getParameters().put('id',brf.id);
    ApexPages.StandardController con = new ApexPages.StandardController(brf);
    
    ApexPages.currentPage().getParameters().put('id', brf.id);
    ApexPages.currentPage().getParameters().put('planid', aiapln.id);
    AIA_BRF_DeepClone ext = new AIA_BRF_DeepClone(con);
    ext.getRelatedAIADocument();
    ext.getSelectedAIADoc();
    ApexPages.currentPage().getParameters().put('palanIdValue','BRF');
    ApexPages.currentPage().getParameters().put('PPID', pp.id);
    ApexPages.currentPage().getParameters().put('PPName', pp.name);
    ApexPages.currentPage().getParameters().put('planid', aiapln.id);
    
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

            
  public static testmethod void Test_AIA_BRF_DeepClone_TriggerHelper(){
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
       // brf.ARC_Approval_Status__c = 'Approved by Committee';
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
        //aiapln.BDF_Configuration_Last_Updated__c = datetime.now();
    //update aiapln;
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
    list<AIA_Benefits__c> bnftList = new list<AIA_Benefits__c>();
        AIA_Benefits__c ab = new AIA_Benefits__c();           
        ab.Grouper__c = ag.id;
        ab.Benefit_Name__c = 'Family Out Of Pocket2';
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
        //ab.Copay_Type_1_Amount_Customized__c = true;
        //ab.Benefit_Customized__c = true;
        bnftList.add(ab);
        
        AIA_Benefits__c ab1 = new AIA_Benefits__c();           
        ab1.Grouper__c = ag.id;
        ab1.Benefit_Name__c = 'Family Out Of Pocket2';
        ab1.Benefit_Type__c = 'Benefit';
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
        ab1.Copay_Type_1_IsCovered__c = 'Yes';
        ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab1.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab1.Copay_Type_1_AliasName__c='Test';
        ab1.Copay_Type_2_AliasName__c='Test';
        ab1.OON_Copay_Type_1_AliasName__c='Test';
        ab1.OON_Copay_Type_2_AliasName__c='Test';
        ab1.Copay_Min_Payment__c = '20';
        ab1.Copay_Max_Payment__c = '30';
        ab1.OON_Copay_Min_Payment__c = '10';
        ab1.OON_Copay_Max_Payment__c = '10';
        ab1.OON_Copay_Default_Max_Payment__c  = '20';
        //ab1.Copay_Type_1_Amount_Customized__c = false;
        //ab1.Benefit_Customized__c = false;
        
        ab1.Copay_Type_1_AmountValueSelected__c = '60';
         ab1.Copay_Type_1_Additional_Increments__c = '200';
        ab1.Copay_Type_1_High__c =  '100';
            ab1.Copay_Type_1_Low__c =  '50';
            ab1.Copay_Type_1_Increment__c =  '5';
            ab1.Copay_Type_1_AdditionalInvalidIncrements__c = '100';
        //ab1. PPid__c = pp.id;
        bnftList.add(ab1);
        insert bnftList;
        system.assertNOTEquals(bnftList,Null);
        
        test.starttest();
        AIA_BenefitTriggerHelperClass.UpdatecustomizedProperties(bnftList);
        
        
        
        test.stopTest(); 
     
  }
  public static testmethod void Test_AIA_BRF_DeepClone_TestCaseLimitaions(){
       /* AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
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
        brf.Enrollment_Type__c = 'Cafeteria';
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
        insert pp;
        system.assertNOTEquals(pp,Null);
        
       
        
        
        
        
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
        ab.OON_Coinsurance_DefaultAmount__c = 'Yes';
        ab.OON_CoInsurance_AmountValueSelected__c= 'No';
        ab.OON_Copay_Type_1_Default_IsCovered__c = 'Yes';
        //ab.OON_Copay_Type_1_IsCovered__cc= 'No';
        ab.OON_Copay_1_Default_DeductibleApplies__c= 'Yes';
        ab.OON_Copay_Type_1_DeductibleApplies__c= 'No';
        ab.OON_Copay_Type_1_DefaultAmount__c= 'Yes';
        ab.OON_Copay_Type_1_AmountValueSelected__c= 'No';
        ab.OON_Copay_Type_2_DefaultAmount__c= 'Yes';
        ab.OON_Copay_Type_2_AmountValueSelected__c= 'No';
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
        //.IsCustom__c = 'Yes';
        //
      lmt.Type__c = 'Comment';
      lmt.IsRequired__c = true;
          lmt.IsSelected__c = false;
          lmt.OldMax_TierVal__c = 'Yes';
          lmt.MaxValue__c = 4;
        insert lmt;
        Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
        lmt2.Benefit__c = ab.id;
      
      lmt2.Type__c = 'Comment';
      lmt2.IsRequired__c = true;
          lmt2.IsSelected__c = false;
          lmt2.OldMax_TierVal__c = 'Yes';
          lmt2.MaxValue__c = 4;
        insert lmt2;

        Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
        lmt3.Benefit__c = ab.id;
      
      lmt3.Benefit__c = ab.id;
      
      lmt3.Type__c = 'Comment';
      lmt3.IsRequired__c = true;
          lmt3.IsSelected__c = false;
          lmt3.OldMax_TierVal__c = 'Yes';
          lmt3.MaxValue__c = 4;
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
        system.assertNOTEquals(aiaDoc1,Null);
        
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
        
      //  ext.cancelButton();
       ext.IsSummaryPanel = true;
        ext.next();
      
     // ext.ValidateAndCallPCS();
        test.stopTest(); 
     
    }                 

    public static testmethod void TestAIA_benefitsummary_PlanRXMan() {


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
      //o.Workplan_Type__c = wpt.id;//Removed per US210
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
    //brf.MHP_Test_Result__c ='True';
        insert brf;

  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
        aiapln.Plan_Name__c = 'Test Plan';

  insert aiapln;
  test.starttest();
  list<Proposed_Products__c> pPlist = new list<Proposed_Products__c>();
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
      pp.Rider__c = 'None';
      pp.Network__c = 'National';   
      pp.Exclusive_Specialty_Provider_Network__c='Yes';
    pPlist.add(pp);
       
    insert pPlist;
    
    AIA_Document__c doc = new AIA_Document__c ();
    doc.Document_Status__c = 'Draft';
    doc.Category__c = 'Benefit Request Form';
    doc.Document_Type__c = 'Signed Quote';
    doc.Start_Date__c = system.today();
    doc.End_Date__c = system.today();
    doc.Approval_Status__c = 'Not Started';
    doc.Benefit_Request_Form__c = brf.id;
    insert doc;
    
    AIA_Plan_RxMandate__c planrx = new AIA_Plan_RxMandate__c();
    planrx.ExtId__c = 'EXTID_RXMAN_123_Test';
    planrx.Mandate_Apply__c = 'Yes';
    planrx.Mandate_Description__c = 'test Description';
    planrx.Mandate_Effective_Date__c = system.today();
    planrx.Mandate_Jurisdiction__c = 'MD';
    planrx.Mandate_Name__c = 'Test_MandateName';
    planrx.Mandate_Term_Date__c = system.today();
    planrx.Network_Rules_AliasName__c = 'AliasNameNR';
    planrx.Plan__c = aiapln.id;
        
    insert planrx;  

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
  ApexPages.StandardController con = new ApexPages.StandardController(PP);
  AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    ext.mainInit();
  test.stopTest();
 }

}