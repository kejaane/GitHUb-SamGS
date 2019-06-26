/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================

*06/08/2018    raj kiran      T01       Added code for role updates
*02-07-2019 	Chaithra 	  |T02| Replaced std AccountTeamMember with custom AccountTeamMember as per US1736 
*==================================================================================

*******************************************************************************************************/
@istest
public class AIA_Benefit_SummaryController_Test {
    
     public static List<user> userList;
     //public static List<AccountTeamMember> acctMbrList; //T02
     public static List<Account_Team__c> acctMbrList;//T02

 public static testmethod void TestAIA_benefitsummary_ErrorMessage1() {
     
     
     userList = new list<user>();
     //acctMbrList = new List<AccountTeamMember>();//T02
     acctMbrList =new List<Account_Team__c>();//T02
     user u1 = AIA_TestUtil.AIA_createUser('alias1');
     user u2 = AIA_TestUtil.AIA_createUser('alias2');
     user u3 = AIA_TestUtil.AIA_createUser('alias3');
     userList.add(u1);
     userList.add(u2);
     userList.add(u3);
     insert userList;
     
     
  //Commenting as part of US210
    /* AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  
   Account acc = AIA_TestUtil.CreateAccount('TestAccount');
   acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Executive')); 
   acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Account Manager')); 
   acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Proposal Specialist')); 
   insert   acctMbrList;

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
        //update brf;
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical', 'Test');
        aiapln.Plan_Name__c = 'Test Plan';
  insert aiapln;
  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
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
      pp.Has_Benefit_Details__c = True;
      pp.Rider__c = 'None';
  insert pp;
    //test.starttest();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
  ApexPages.StandardController con = new ApexPages.StandardController(PP);
  AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);

  test.stopTest();
 }
 
 public static testmethod void TestAIA_benefitsummary_ErrorMessage2() {

//Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/
   Account acc = AIA_TestUtil.CreateAccount('TestAccount');
   
   
   /*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); //T02
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
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
    //brf.MHP_Test_Result__c ='True';
        insert brf;

  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical', 'Test');
        aiapln.Plan_Name__c = 'Test Plan';

  insert aiapln;
  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  list<Proposed_Products__c> pPlist = new list<Proposed_Products__c>();
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
      pp.Has_Benefit_Details__c = True;
      pp.Rider__c = 'None';
    pPlist.add(pp);
    
    Proposed_Products__c pp1 = new Proposed_Products__c();
    pp1.Rider__c = 'None';
    pp1.Benefit_Request_Form__c = brf.id;
    pPlist.add(pp1);
    
    insert pPlist;
    
    AIA_Plan_RxMandate__c planrx = new AIA_Plan_RxMandate__c();
    planrx.ExtId__c = 'EXTID_RXMAN_123_Test';
    planrx.Mandate_Apply__c = 'Yes';
    planrx.Mandate_Description__c = 'test Description';
    planrx.Mandate_Effective_Date__c = system.today()-30;
    planrx.Mandate_Jurisdiction__c = 'MD';
    planrx.Mandate_Name__c = 'Test_MandateName';
    planrx.Mandate_Term_Date__c = system.today()+30;
    planrx.Network_Rules_AliasName__c = 'AliasNameNR';
    planrx.Plan__c = aiapln.id;
        
    insert planrx;  
    
    AIA_Document__c doc = new AIA_Document__c ();
    doc.Document_Status__c = 'Draft';
    doc.Category__c = 'Benefit Request Form';
    doc.Document_Type__c = 'Signed Quote';
    doc.Start_Date__c = system.today();
    doc.End_Date__c = system.today();
    doc.Approval_Status__c = 'Not Started';
    doc.Benefit_Request_Form__c = brf.id;
    insert doc;

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
  ApexPages.StandardController con = new ApexPages.StandardController(PP);
  AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    ext.mainInit();
  test.stopTest();
 }
 
 public static testmethod void TestAIA_benefitsummary_ErrorMessage3() {

//Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/
   Account acc = AIA_TestUtil.CreateAccount('TestAccount');
   
   /*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
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
      //o.Workplan_Type__c = wpt.id;//Commenting as part of US210
      o.StageName = 'RFP';
      o.FullServiceProducer__c = 'Direct';
  insert o;
     Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //nbrf.Control_Plan__c='690';
    brf.Contract_Count__c = 123;
    brf.Benefit_Effective_Date__c = system.today();
    brf.Escalated_to_Senior_Management__c = true;
    brf.Status__c = 'New';
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
    
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical', 'Test');
        aiapln.Plan_Name__c = 'Test Plan';
  insert aiapln;
  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  list<Proposed_Products__c> pPlist = new list<Proposed_Products__c>();
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
      pp.Has_Benefit_Details__c = True;
      pp.Rider__c = 'None';
    pPlist.add(pp);
    
    Proposed_Products__c pp1 = new Proposed_Products__c();
    pp1.Rider__c = 'None';
    pp1.Benefit_Request_Form__c = brf.id;
    pPlist.add(pp1);
    
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
    
    Benfit_Request_Form__c brf1 = new Benfit_Request_Form__c();
    brf1.id = brf.id;
    brf1.ARC_Approval_Status__c = 'Auto-Approved by System';
    brf1.Status__c = 'sold';
    update brf1;

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
    //ApexPages.currentPage().getParameters().put('id',pp.id);
  ApexPages.StandardController con = new ApexPages.StandardController(PP);
  AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    ext.mainInit();
    ext.dispatcher();
  test.stopTest();
 }

 
public static testmethod void TestAIA_benefitsummary_ErrorMessage() {
  //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

   Account acc = AIA_TestUtil.CreateAccount('TestAccount');
/*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
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
        
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical', 'Test');
  aiapln.Plan_Name__c = 'Test Plan';
 
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
      pp.Has_Benefit_Details__c = false;
      pp.Rider__c = 'None';
  insert pp;

  AIA_Grouper__c ag = new AIA_Grouper__c();
     ag.Name = 'CostShareRanges';
     ag.Group_Type__c = 'Cost Share Group';
     ag.Grouper_Record_Type__c = 'BRF';
  //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
    ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
    ag.Proposed_Products__c = pp.id;
  insert ag;
  test.starttest();
 AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
  ApexPages.currentPage().getParameters().put('id', pp.id);
  ApexPages.StandardController con = new ApexPages.StandardController(PP);
  ApexPages.currentPage().getParameters().put('id', pp.id);
  ApexPages.currentPage().getParameters().put('planId', aiapln.id);
  AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
  ApexPages.currentPage().getParameters().put('planType', 'Drug');
  ext.mainInit();
  ext.dispatcher();
  ext.addPlan();
  ApexPages.currentPage().getParameters().put('planType', 'Vision');
  ext.addPlan();
  ApexPages.currentPage().getParameters().put('planType', 'Dental');
  ext.addPlan();
  AIA_Benefit_SummaryController.GrouperWrapper gwr = new AIA_Benefit_SummaryController.GrouperWrapper(ag,2);
  test.stopTest();
 }
 
 public static testmethod void TestAIA_benefitsummary_Dispatchtemp() {
 //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
/*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
       List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
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
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical', 'Test');
      aiapln.Has_Benefit_Summary__c = True;
      aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
      aiapln.Jurisdiction__c = 'MD';
      aiapln.Product_Category__c = 'Medical';
      aiapln.Configuration_Last_Updated__c = null;
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

  AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
      pg.Name = 'CostShareRanges';
      pg.Plan_Network__c = pn.id;
      pg.Type__c = 'Cost Share Group';
      pg.Record_Type__c = 'BRF';
      pg.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00';
  insert pg;

  AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
      pg2.Name = 'CostShareRanges';
      pg2.Plan_Network__c = pn2.id;
      pg2.Type__c = 'Cost Share Group';
      pg2.Record_Type__c = 'BRF';
      pg2.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002';
  insert pg2;

  AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
      pg3.Name = 'Medical Supplies/Equipment-0628';
      pg3.Plan_Network__c = pn.id;
      pg3.Type__c = 'Benefit Group';
      pg3.Sequence_Number__c = 1;
      pg3.Record_Type__c = 'BRF';
      pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
  insert pg3;

  AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
      pg4.Name = 'Medical Supplies/Equipment-0629';
      pg4.Plan_Network__c = pn2.id;
      pg4.Type__c = 'Benefit Group';
      pg4.Sequence_Number__c = 1;
      pg4.Record_Type__c = 'BRF';
      pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
  insert pg4;

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();

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
      pb.IsAppGlobalCopay__c = true;
      // insert pb;
  lstPlnt.add(pb);

  insert lstPlnt;

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
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);
  // insert lstPlnt;

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
      pb2.IsAppGlobalCopay__c = true;
      //insert pb2;
  lstPlnt.add(pb2);
  //insert lstPlnt;


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
      pb3.IsAppGlobalCopay__c = true;
      // insert pb3;
  lstPlnt.add(pb3);

  // insert lstPlnt;


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
      pb4.IsAppGlobalCopay__c = true;
      // insert pb4;
  lstPlnt.add(pb4);
  //insert lstPlnt;

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
      pb5.IsAppGlobalCopay__c = true;
      //insert pb5;
  lstPlnt.add(pb5);
  //insert lstPlnt;

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
  //insert lstPlnt;

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
      //insert pb7;
  lstPlnt.add(pb7);
  //insert lstPlnt;

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
  // insert lstPlnt;

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
  // insert lstPlnt;

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
      // insert pb10;
  lstPlnt.add(pb10);
  // insert lstPlnt;

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
  //insert lstPlnt;

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
      // insert pb13;
  lstPlnt.add(pb13);
  // insert lstPlnt;

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
  //insert lstPlnt;

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
      // insert pb15;
  lstPlnt.add(pb15);
  //insert lstPlnt;

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
  // insert lstPlnt;

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
      //insert pb17;
  lstPlnt.add(pb17);
  //insert lstPlnt;

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
  //insert lstPlnt;

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
  lstPlnt.add(pb6);
  //insert lstPlnt;

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
  //insert lstPlnt;

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
  // insert lstPlnt;

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
  //insert lstPlnt;

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
      //insert pb23;  
  lstPlnt.add(pb23);
  //insert lstPlnt;      



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
      apc.MandateName__c = 'Home health care ';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      obj.Effective_Date__c=system.today();
     obj.Term_Date__c=system.today();
  insert obj;

  AIA_Plan_Limitation__c obj2 = new AIA_Plan_Limitation__c();
      obj2.Plan_Benefits__c = pb.id;
      obj2.MandateIndicator__c = False;
      obj2.Effective_Date__c=system.today();
     obj2.Term_Date__c=system.today();
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
      obj3.Effective_Date__c=system.today();
     obj3.Term_Date__c=system.today();
  insert obj3;

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c =True;
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      pbc.Type__c='Mandate';
      //pbc.Plan_Copay_Type__c ='';
      pbc.FundingArrangement__c ='Risk';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
        pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
     pbc.Type__c='Limit';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'ASO';
      //pp.Funding_Arrangement__c = 'Risk';
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
      //pp.Blue_Rewards__c = 'Standard';
      pp.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.Rider__c = 'None';
      //pp.FirstHelp__c = 'Yes';
  insert pp;

  test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.currentPage().getParameters().put('planId', aiapln.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
      ApexPages.currentPage().getParameters().put('planType', 'Drug');
      ext.mainInit();
      ext.saveandcontemp();
      ext.rowOrder = 0;
      ext.dispatchertemp();
      ext.addPlan();
      ApexPages.currentPage().getParameters().put('planType', 'Vision');
      ext.addPlan();
      ApexPages.currentPage().getParameters().put('planType', 'Dental');
      ext.addPlan();
      boolean testbol = ext.hasBnftSumry(aiapln);
      boolean testbol1 = ext.isPCScallReq(aiapln);
      boolean testbol2 = ext.ValidateCoInsurance('100','test');
      boolean testbol3 = ext.isMultipleofActual(1,1);
      boolean testbol4 = ext.validateCopayValues('10','10','10','10','10','10','10');
      system.debug('-----testbol1---->'+testbol1);
  test.stopTest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerVision() {

//Commenting as part of US210
 /* AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
  /*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();T02
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02 
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u15.id,'Account Manager'));
 insert acctMbrList;
/*R1 added teammember*/
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
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerValidate() {

  //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
/*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
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
      aiapln.Has_Benefit_Summary__c = True;
      aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
      aiapln.Jurisdiction__c = 'MD';
      
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'PCP Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'PCP Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'PCP Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'PCP Copay';
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
      pb4.Benefit_Name__c = 'PCP Copay';
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
      pb5.Benefit_Name__c = 'PCP Copay';
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
      pb6.Benefit_Name__c = 'PCP Copay';
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
      pb7.Benefit_Name__c = 'PCP Copay';
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
      pb8.Benefit_Name__c = 'PCP Copay';
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
      pb9.Benefit_Name__c = 'PCP Copay';
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
      pb10.Benefit_Name__c = 'PCP Copay';
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
      pb11.Benefit_Name__c = 'PCP Copay';
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
      pb13.Benefit_Name__c = 'PCP Copay';
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
      pb14.Benefit_Name__c = 'PCP Copay';
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
      pb15.Benefit_Name__c = 'PCP Copay';
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
      pb16.Benefit_Name__c = 'PCP Copay';
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
      pb17.Benefit_Name__c = 'PCP Copay';
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
      pb18.Benefit_Name__c = 'PCP Copay';
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
      pb19.Benefit_Name__c = 'PCP Copay';
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
      pb20.Benefit_Name__c = 'PCP Copay';
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
      pb21.Benefit_Name__c = 'PCP Copay';
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
      pb22.Benefit_Name__c = 'PCP Copay';
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
      pb23.Benefit_Name__c = 'PCP Copay';
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
      apc.MandateName__c = 'Home health care ';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.OralChemoMandateApply__c  = 'Yes'; 
      pp.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
     // Commenting as part of US1650
      //ext.getPCSdata();
      ext.mainInit();
      ext.createWrapListFromPlan(pp);
      ext.createWrapListFromPlanCostShr(aiapln.id);
      //ext.bnftcostlst[0].Cost_Share_SelectedAmount__c = '10';
      
      

      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AliasName__c = 'PCP Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Increment__c = '5';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'PCP Copay';

      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AliasName__c = 'PCP Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Increment__c = '';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'PCP Copay';

      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AliasName__c = 'PCP Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Increment__c = '5';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30,40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'PCP Copay';

      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AliasName__c = 'PCP Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_High__c = '5';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Low__c = '1';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Increment__c = '';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'PCP Copay';

  ext.saveAndCon();
  ext.back();
  boolean testbol4 = ext.validateCopayValues('10','-10','10','10','10','-1','10');

  test.stoptest();
 }

public Static TestMethod void TestAIA_Benefit_SummaryControllerForNoBenefitData() {

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
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical', 'Test');
      aiapln.Configuration_Last_Updated__c = system.today() + 2;
      aiapln.Product_Last_Updated__c = system.today() - 2;
      aiapln.Has_Benefit_Summary__c = False;
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
      pp.Has_Benefit_Details__c = True;
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
      Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
    
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
      ext.mainInit();
  test.stoptest();
 }
 
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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
      pp.Has_Benefit_Details__c = True;//to enter hasben method
      pp.Network__c = 'National';
      pp.Exclusive_Specialty_Provider_Network__c = 'Yes';   
      pp.ExtraCare_Health_Care_Card__c = 'Yes';   
      pp.Maintenance_Choice__c = 'None';   
      pp.OralChemoMandateApply__c = 'No';   
      pp.Integrated_Deductible_Integrator__c = 'No';
      pp.Integrated_OOP_Integration__c = 'Yes';
      pp.Rider__c = 'None';
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
 
 public Static TestMethod void TestAIA_Benefit_SummaryController1() {

   //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
  
  List<user> userList = new list<user>();
        user u41 = AIA_TestUtil.AIA_createUser('alias41');
        userList.add(u41);        
        user u51= AIA_TestUtil.AIA_createUser('alias51');
        userList.add(u51); 
        user u61 = AIA_TestUtil.AIA_createUser('alias61');
        userList.add(u61);
        insert userList;   
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();t02
             List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
            
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u41.id,'Account Executive')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u51.id,'Proposal Specialist'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u61.id,'Account Manager'));
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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
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
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
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
      apc.MandateName__c = 'Home health care ';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  
    Proposed_Products__c pp1 = new Proposed_Products__c();
      pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp1.Benefit_Request_Form__c = brf.id;
      pp1.Funding_Arrangement__c = 'Risk';
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
      pp1.Blue_Rewards__c = 'Standard';
      pp1.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp1.Has_Benefit_Details__c = false;
      pp1.FirstHelp__c = 'Yes';
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
      // Commenting as part of US1650
      //ext.getPCSdata();
      ext.createWrapListFromPlan(pp1);
      ext.createWrapListFromPlanCostShr(aiapln.id);
      ext.saveAndCon();
      ext.addPlan();
      ext.saveandRedirct();
      ext.reviewInit();
      ext.rowOrder = 0;
      ext.dispatcherTemp();
      ext.back();

AIA_Benefit_SummaryController benefitSummaryCtrl = new AIA_Benefit_SummaryController();
  test.stoptest();
 }
 
  public Static TestMethod void TestAIA_Benefit_SummaryControllerForGrouper() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical', 'Test');
      aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
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
      pp.Has_Benefit_Details__c = True;
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();


  AIA_Grouper__c ag = new AIA_Grouper__c();
      ag.Name = 'CostShareRanges';
      ag.Group_Type__c = 'Cost Share Group';
      ag.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag.Proposed_Products__c = pp.id;
  insert ag;

  List < AIA_Benefits__c > lstBnft = new List < AIA_Benefits__c > ();
  AIA_Benefits__c ab = new AIA_Benefits__c();
      ab.Grouper__c = ag.id;
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
      //insert ab; 
      lstBnft.add(ab);
      insert lstBnft;
    
      AIA_Benefits__c ab2 = new AIA_Benefits__c();
      ab2.Grouper__c = ag.id;
      ab2.Benefit_Name__c = 'Test Benefit';
      ab2.Copay_Type_1_Mandate_Name__c = 'Test';
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
      ab2.IsAppGlobalCopay__c = true;
      // insert ab2; 
  lstBnft.add(ab2);

  //  insert lstBnft;

  Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Maxrow');
  insert lmt;
  Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'TierLimit');
  insert lmt2;
  Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Comment');
  insert lmt3;

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

  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerDrugFromSetup() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
     brf.Exclusive_Specialty_Provider_Network__c='Yes';
        insert brf;
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
      aiapln.Has_Benefit_Summary__c = True;
      aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
      aiapln.Jurisdiction__c = 'MD';
      aiapln.Product_Category__c = 'Drug';
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

  AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
      pg.Name = 'CostShareRanges';
      pg.Plan_Network__c = pn.id;
      pg.Type__c = 'Cost Share Group';
      pg.Record_Type__c = 'BRF';
      pg.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00';
  insert pg;

  AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
      pg2.Name = 'CostShareRanges';
      pg2.Plan_Network__c = pn2.id;
      pg2.Type__c = 'Cost Share Group';
      pg2.Record_Type__c = 'BRF';
      pg2.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002';
  insert pg2;

  AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
      pg3.Name = 'Medical Supplies/Equipment-0628';
      pg3.Plan_Network__c = pn.id;
      pg3.Type__c = 'Benefit Group';
      pg3.Sequence_Number__c = 1;
      pg3.Record_Type__c = 'BRF';
      pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
  insert pg3;

  AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
      pg4.Name = 'Medical Supplies/Equipment-0629';
      pg4.Plan_Network__c = pn2.id;
      pg4.Type__c = 'Benefit Group';
      pg4.Sequence_Number__c = 1;
      pg4.Record_Type__c = 'BRF';
      pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
  insert pg4;

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
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
      pb.IS_ASO_Only__c = 'Yes';
      //insert pb;
  lstPlnt.add(pb);

  insert lstPlnt;

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
      pb29.IS_ASO_Only__c = 'Yes';
      //insert pb29;
  lstPlnt.add(pb29);

  //  insert lstPlnt;

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
      pb2.IS_ASO_Only__c = 'Yes';
      // insert pb2;
  lstPlnt.add(pb2);
  //insert lstPlnt;

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
      pb3.IS_ASO_Only__c = 'No';
      // insert pb3;
  lstPlnt.add(pb3);

  //insert lstPlnt;

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
      pb4.IS_ASO_Only__c = 'No';
      // insert pb4;
  lstPlnt.add(pb4);

  //insert lstPlnt;

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
      pb5.IS_ASO_Only__c = 'No';
      //insert pb5;
  lstPlnt.add(pb5);

  // insert lstPlnt;

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
      pb6.IS_ASO_Only__c = 'No';
      // insert pb6;
  lstPlnt.add(pb6);

  // insert lstPlnt;

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
      pb7.IS_ASO_Only__c = 'No';
      // insert pb7;
  lstPlnt.add(pb7);
  //  insert lstPlnt;

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
      pb8.IS_ASO_Only__c = 'No';
      // insert pb8;
  lstPlnt.add(pb8);

  // insert lstPlnt;


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
      pb9.IS_ASO_Only__c = 'No';
      // insert pb9;
  lstPlnt.add(pb9);
  // insert lstPlnt;


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
      pb10.IS_ASO_Only__c = 'No';
      //insert pb10;
  lstPlnt.add(pb10);

  // insert lstPlnt;


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
      pb11.IS_ASO_Only__c = 'No';
      // insert pb11;
  lstPlnt.add(pb11);

  // insert lstPlnt;


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
      pb13.IS_ASO_Only__c = 'No';
      //insert pb13;
  lstPlnt.add(pb13);

  // insert lstPlnt;

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
      pb14.IS_ASO_Only__c = 'No';
      //insert pb14;
  lstPlnt.add(pb14);

  // insert lstPlnt;

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

  // insert lstPlnt;

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
      //insert pb16;
  lstPlnt.add(pb16);

  //insert lstPlnt;

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
      //insert pb17;
  lstPlnt.add(pb17);
  //insert lstPlnt;

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
      //insert pb18;
  lstPlnt.add(pb18);
  //insert lstPlnt;

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
      // insert pb20;
  lstPlnt.add(pb20);
  //insert lstPlnt;

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
  //insert lstPlnt;


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

  //insert lstPlnt;

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
  lstPlnt.add(pb23);
  // insert lstPlnt;



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
      apc.MandateName__c = 'Home health care ';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c =True;
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

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
      pp.Network__c = 'National';
      pp.ExtraCare_Health_Care_Card__c = 'Yes';
      pp.Maintenance_Choice__c = 'None';   
      pp.OralChemoMandateApply__c = 'No';   
      pp.Has_Benefit_Details__c = false;
      pp.Rider__c = 'None';
      pp.Exclusive_Specialty_Provider_Network__c ='Yes';
  insert pp;


  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
      // Commenting as part of US1650
      //ext.getPCSdata();
      ext.mainInit();
      // ext.createWrapListFromPlan(pp);
      ext.createWrapListFromPlanCostShr(aiapln.id);
      //  ext.dispatcherTemp();
      //  ext.saveAndContemp();
      ext.saveAndCon();
      ext.addPlan();
      ext.saveandRedirct();
      ext.reviewInit();
      ext.back();

  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerDispatcherTmp1() {

 //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
  
  /*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();T02
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02 
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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Funding_Arrangements__c = 'Both';
        insert brf;
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'PCP Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'PCP Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'PCP Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'PCP Copay';
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
      pb4.Benefit_Name__c = 'PCP Copay';
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
      pb5.Benefit_Name__c = 'PCP Copay';
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
      pb6.Benefit_Name__c = 'PCP Copay';
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
      pb7.Benefit_Name__c = 'PCP Copay';
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
      pb8.Benefit_Name__c = 'PCP Copay';
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
      pb9.Benefit_Name__c = 'PCP Copay';
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
      pb10.Benefit_Name__c = 'PCP Copay';
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
      pb11.Benefit_Name__c = 'PCP Copay';
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
      pb13.Benefit_Name__c = 'PCP Copay';
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
      pb14.Benefit_Name__c = 'PCP Copay';
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
      pb15.Benefit_Name__c = 'PCP Copay';
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
      pb16.Benefit_Name__c = 'PCP Copay';
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
      pb17.Benefit_Name__c = 'PCP Copay';
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
      pb18.Benefit_Name__c = 'PCP Copay';
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
      pb19.Benefit_Name__c = 'PCP Copay';
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
      pb20.Benefit_Name__c = 'PCP Copay';
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
      pb21.Benefit_Name__c = 'PCP Copay';
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
      pb22.Benefit_Name__c = 'PCP Copay';
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
      pb23.Benefit_Name__c = 'PCP Copay';
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
      apc.MandateName__c = 'Home health care ';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.OralChemoMandateApply__c  = 'Yes';   
      pp.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;




  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
       ext.rowOrder = 1;
       ext.pp.funding_Arrangement__c = 'Risk';
     
      ext.back();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerDispatcherTmp() {

 //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

   Account acc = AIA_TestUtil.CreateAccount('TestAccount');
/*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();T02
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02 
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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Funding_Arrangements__c = 'Both';
        insert brf;
        
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'PCP Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'PCP Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'PCP Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'PCP Copay';
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
      pb4.Benefit_Name__c = 'PCP Copay';
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
      pb5.Benefit_Name__c = 'PCP Copay';
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
      pb6.Benefit_Name__c = 'PCP Copay';
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
      pb7.Benefit_Name__c = 'PCP Copay';
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
      pb8.Benefit_Name__c = 'PCP Copay';
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
      pb9.Benefit_Name__c = 'PCP Copay';
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
      pb10.Benefit_Name__c = 'PCP Copay';
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
      pb11.Benefit_Name__c = 'PCP Copay';
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
      pb13.Benefit_Name__c = 'PCP Copay';
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
      pb14.Benefit_Name__c = 'PCP Copay';
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
      pb15.Benefit_Name__c = 'PCP Copay';
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
      pb16.Benefit_Name__c = 'PCP Copay';
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
      pb17.Benefit_Name__c = 'PCP Copay';
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
      pb18.Benefit_Name__c = 'PCP Copay';
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
      pb19.Benefit_Name__c = 'PCP Copay';
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
      pb20.Benefit_Name__c = 'PCP Copay';
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
      pb21.Benefit_Name__c = 'PCP Copay';
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
      pb22.Benefit_Name__c = 'PCP Copay';
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
      pb23.Benefit_Name__c = 'PCP Copay';
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
      apc.MandateName__c = 'Home health care ';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.Out_of_Pocket_Max__c = 'Stacked';
      pp.OralChemoMandateApply__c  = 'Yes';    
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    
      ext.dispatcherTemp();
      ext.back();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerDental() {

 //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
  
  /*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
      // List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); 
       List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
      aiapln.Has_Benefit_Summary__c = True;
      aiapln.Product_Last_Updated_String_Format__c = '2016-10-18  08:17:23 PM';
      aiapln.Jurisdiction__c = 'MD';
      //  aiapln.Product_Last_Updated__c=Date.today()+1;
      // aiapln.Configuration_Last_Updated__c = Date.today();

  insert aiapln;
  
    Proposed_Products__c pp1 = new Proposed_Products__c();
      pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Dental');
      pp1.Benefit_Request_Form__c = brf.id;
      pp1.Funding_Arrangement__c = 'Risk';
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
      pp1.Blue_Rewards__c = 'Standard';
      pp1.Out_of_Pocket_Max__c = 'Stacked';
      pp1.product_category__c = 'Dental';
      // pp.Jurisdiction__c = 'MD';
      pp1.Has_Benefit_Details__c = True;
      pp1.Rider__c = 'None';
  insert pp1;
  
  AIA_Grouper__c ag = new AIA_Grouper__c();
      ag.Name = 'Grouper1';
      ag.Group_Type__c = 'Benefit Group';
      ag.Grouper_Record_Type__c = 'BRF';
      ag.CoInsurance__c = '10';
      ag.IsCovered__c = 'Yes';
      ag.DeductibleApplies__c  = 'Yes';
      ag.AnnualMaximumApplies__c = 'Yes';
      ag.CoInsurance_Low__c = '10';
      ag.CoInsurance_High__c = '100';
      ag.CoInsurance_Increment__c = '1';
      ag.CoInsurance_AddIncrement__c = '11';
      ag.CoInsurance_InvalidIncrement__c = '12';
  
      ag.OON_CoInsurance__c = '10';
      ag.OON_IsCovered__c = 'Yes';
      ag.OON_DeductibleApplies__c = 'Yes';
      ag.OON_AnnualMaximumApplies__c = 'Yes';
      ag.OON_CoInsurance_Low__c = '0';
      ag.OON_CoInsurance_High__c = '100';
      ag.OON_CoInsurance_Increment__c   = '1';
      ag.OON_CoInsurance_InvalidIncrement__c = '12';
      ag.OON_CoInsurance_AddIncrement__c = '15';
  
      ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
      ag.Proposed_Products__c = pp1.id;
  insert ag;
  
  AIA_Benefits__c ab = new AIA_Benefits__c();
      ab.Grouper__c = ag.id;
      ab.Benefit_Name__c = 'Ben1';
      ab.Benefit_Type__c = 'Benefit';
      ab.Copay_Type_1_Mandate_Name__c = 'Test';
      ab.Type__c = 'Benefit';
      
      ab.Benefit_Record_Type__c = 'BRF';
      ab.CoInsurance_AmountValueSelected__c = '10';
      ab.Copay_Type_1_IsCovered__c = 'Yes';
      ab.Copay_Type_1_DeductibleApplies__c  = 'Yes';
      ab.AnnualMaximumApplies__c = 'Yes';
      
      ab.OON_CoInsurance_AmountValueSelected__c = '10';
      ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
      ab.OON_Copay_Type_1_DeductibleApplies__c = 'Yes';
      ab.OON_AnnualMaximumApplies__c = 'Yes';
  insert ab; 



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
     // ext.getPCSdata();
      
      ext.createWrapListFromPlan(pp1);
      ext.createWrapListFromPlanCostShr(aiapln.id);
    
      ext.saveAndCon();
      ext.addPlan();
      ext.saveandRedirct();
      ext.reviewInit();
      ext.rowOrder = 0;
      ext.dispatcherTemp();
      ext.back();

AIA_Benefit_SummaryController benefitSummaryCtrl = new AIA_Benefit_SummaryController();
  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryController() { userList = new list<user>();
     //acctMbrList = new List<AccountTeamMember>();
     acctMbrList= new List<Account_Team__c>();//T02
     user u1 = AIA_TestUtil.AIA_createUser('alias1');
     user u2 = AIA_TestUtil.AIA_createUser('alias2');
     user u3 = AIA_TestUtil.AIA_createUser('alias3');
     userList.add(u1);
     userList.add(u2);
     userList.add(u3);
     insert userList;
 

   //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
 
   acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Executive')); 
   acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Account Manager')); 
   acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Proposal Specialist')); 
   insert   acctMbrList;
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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
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
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
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
      apc.MandateName__c = 'Home health care ';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

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
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.Rider__c = 'None';
  insert pp;



  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    
    
    // Commenting as part of US1650
      //ext.getPCSdata();
      ext.mainInit();
      ext.createWrapListFromPlan(pp);
      ext.createWrapListFromPlanCostShr(aiapln.id);
    
      ext.saveAndCon();
      ext.addPlan();
      ext.saveandRedirct();
      ext.reviewInit();
      ext.rowOrder = 0;
      ext.dispatcherTemp();
      ext.back();
     
 
AIA_Benefit_SummaryController benefitSummaryCtrl = new AIA_Benefit_SummaryController();
  test.stoptest();
 }
 
  public Static TestMethod void TestAIA_Benefit_SummaryControllerForGrouperdrug() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
  test.starttest();
AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();


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
      ab2.Benefit_Name__c = 'Test Benefit';
      ab2.Copay_Type_1_Mandate_Name__c = 'Test';
      //ab2.Benefit_Type__c = 'Benefit';
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
  
  //RK
    AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
      RXgrouper.Name = 'Retail NonMaintenance';
      RXgrouper.Group_Type__c = 'Benefit Group';
      RXgrouper.Grouper_Record_Type__c = 'BRF';
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

  Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Maxrow');
  insert lmt;
  Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'TierLimit');
  insert lmt2;
  Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id, True, 'Comment');
  insert lmt3;

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
 
public Static TestMethod void TestAIA_Benefit_SummaryControllerDispatcherTmp3() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Funding_Arrangements__c = 'Both';
        insert brf;
        
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'Specialist Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'Specialist Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'Specialist Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'Specialist Copay';
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
      pb4.Benefit_Name__c = 'Specialist Copay';
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
      pb5.Benefit_Name__c = 'Specialist Copay';
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
      pb6.Benefit_Name__c = 'Specialist Copay';
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
      pb7.Benefit_Name__c = 'Specialist Copay';
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
      pb8.Benefit_Name__c = 'Specialist Copay';
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
      pb9.Benefit_Name__c = 'Specialist Copay';
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
      pb10.Benefit_Name__c = 'Specialist Copay';
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
      pb11.Benefit_Name__c = 'Specialist Copay';
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
      pb13.Benefit_Name__c = 'Specialist Copay';
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
      pb14.Benefit_Name__c = 'Specialist Copay';
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
      pb15.Benefit_Name__c = 'Specialist Copay';
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
      pb16.Benefit_Name__c = 'Specialist Copay';
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
      pb17.Benefit_Name__c = 'Specialist Copay';
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
      pb18.Benefit_Name__c = 'Specialist Copay';
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
      pb19.Benefit_Name__c = 'Specialist Copay';
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
      pb20.Benefit_Name__c = 'Specialist Copay';
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
      pb21.Benefit_Name__c = 'Specialist Copay';
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
      pb22.Benefit_Name__c = 'Specialist Copay';
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
      pb23.Benefit_Name__c = 'Specialist Copay';
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
      apc.AliasName__c = 'Specialist Copay';
      apc.CopayAmount__c = '200';
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
      apc3.Plan_Benefits__c = pb.id;
      apc3.AliasName__c = 'Specialist Copay';
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
  
  AIA_Plan_Copay_Type__c apc2 = new AIA_Plan_Copay_Type__c();
      apc2.Plan_Benefits__c = pb29.id;
      apc2.AliasName__c = 'Specialist Copay';
      apc2.CopayAmount__c = '200';
      apc2.CoinsuranceAmount__c = '50';
      apc2.MinPayAmount__c = '90';
      apc2.MaxPayAmount__c = '80';
      apc2.IsCovered__c = 'Yes';
      apc2.DeductibleApplies__c = 'No';
      apc2.MandateIndicator__c = 'Yes';
      apc2.Jurisdiction__c = 'Federal';
      apc2.MandateName__c = 'PPACA mandate';
      apc2.ExtID__c = 'rwuifghqierufghaire';
  insert apc2;

  AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
      apc30.Plan_Benefits__c = pb29.id;
      apc30.AliasName__c = 'Specialist Copay';
      apc30.CopayAmount__c = '200';
      apc30.CoinsuranceAmount__c = '50';
      apc30.MinPayAmount__c = '90';
      apc30.MaxPayAmount__c = '80';
      apc30.IsCovered__c = 'Yes';
      apc30.DeductibleApplies__c = 'No';
      apc30.MandateIndicator__c = 'Yes';
      apc30.Jurisdiction__c = 'Test';
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.Out_of_Pocket_Max__c = 'Stacked';
      pp.OralChemoMandateApply__c  = 'Yes';    
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    
      ext.dispatcherTemp();
        
      ext.back();
      ext.dispatcher();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerDispatcherTmp4() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Funding_Arrangements__c = 'Both';
        insert brf;
        
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'Per Admission Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'Per Admission Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'Per Admission Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'Per Admission Copay';
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
  
  AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
      pb16.Benefit_Name__c = 'Per Admission Copay';
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

  AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
      apc.Plan_Benefits__c = pb.id;
      apc.AliasName__c = 'Per Admission Copay';
      apc.CopayAmount__c = '200';
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
      apc3.Plan_Benefits__c = pb.id;
      apc3.AliasName__c = 'Per Admission Copay';
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
  
  AIA_Plan_Copay_Type__c apc2 = new AIA_Plan_Copay_Type__c();
      apc2.Plan_Benefits__c = pb29.id;
      apc2.AliasName__c = 'Per Admission Copay';
      apc2.CopayAmount__c = '200';
      apc2.CoinsuranceAmount__c = '50';
      apc2.MinPayAmount__c = '90';
      apc2.MaxPayAmount__c = '80';
      apc2.IsCovered__c = 'Yes';
      apc2.DeductibleApplies__c = 'No';
      apc2.MandateIndicator__c = 'Yes';
      apc2.Jurisdiction__c = 'Federal';
      apc2.MandateName__c = 'PPACA mandate';
      apc2.ExtID__c = 'rwuifghqierufghaire';
  insert apc2;

  AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
      apc30.Plan_Benefits__c = pb29.id;
      apc30.AliasName__c = 'Per Admission Copay';
      apc30.CopayAmount__c = '200';
      apc30.CoinsuranceAmount__c = '50';
      apc30.MinPayAmount__c = '90';
      apc30.MaxPayAmount__c = '80';
      apc30.IsCovered__c = 'Yes';
      apc30.DeductibleApplies__c = 'No';
      apc30.MandateIndicator__c = 'Yes';
      apc30.Jurisdiction__c = 'Test';
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.Out_of_Pocket_Max__c = 'Stacked';
      pp.OralChemoMandateApply__c  = 'Yes';    
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    
      ext.dispatcherTemp();        
      ext.back();
      ext.dispatcher();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerDispatcherTmp5() {

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
     // o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Funding_Arrangements__c = 'Both';
        insert brf;
        
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'Coinsurance';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'Coinsurance';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'Coinsurance';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'Coinsurance';
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
  
  AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
      pb16.Benefit_Name__c = 'Coinsurance';
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

  AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
      apc.Plan_Benefits__c = pb.id;
      apc.AliasName__c = 'Coinsurance';
      apc.CopayAmount__c = '200';
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
      apc3.Plan_Benefits__c = pb.id;
      apc3.AliasName__c = 'Coinsurance';
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
  
  AIA_Plan_Copay_Type__c apc2 = new AIA_Plan_Copay_Type__c();
      apc2.Plan_Benefits__c = pb29.id;
      apc2.AliasName__c = 'Coinsurance';
      apc2.CopayAmount__c = '200';
      apc2.CoinsuranceAmount__c = '50';
      apc2.MinPayAmount__c = '90';
      apc2.MaxPayAmount__c = '80';
      apc2.IsCovered__c = 'Yes';
      apc2.DeductibleApplies__c = 'No';
      apc2.MandateIndicator__c = 'Yes';
      apc2.Jurisdiction__c = 'Federal';
      apc2.MandateName__c = 'PPACA mandate';
      apc2.ExtID__c = 'rwuifghqierufghaire';
  insert apc2;

  AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
      apc30.Plan_Benefits__c = pb29.id;
      apc30.AliasName__c = 'Coinsurance';
      apc30.CopayAmount__c = '200';
      apc30.CoinsuranceAmount__c = '50';
      apc30.MinPayAmount__c = '90';
      apc30.MaxPayAmount__c = '80';
      apc30.IsCovered__c = 'Yes';
      apc30.DeductibleApplies__c = 'No';
      apc30.MandateIndicator__c = 'Yes';
      apc30.Jurisdiction__c = 'Test';
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.Out_of_Pocket_Max__c = 'Stacked';
      pp.OralChemoMandateApply__c  = 'Yes';    
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    
      ext.dispatcherTemp();
    
        
      ext.back();
      ext.dispatcher();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerDispatcherTmp6() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Funding_Arrangements__c = 'Both';
        insert brf;
        
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'General Copay';
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
      pb.IS_ASO_Only__c='Yes';
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'General Copay';
      pb29.Record_Type__c = 'BRF';
      pb29.Type__c = 'Benefit';
      pb29.IS_ASO_Only__c='No';
      pb29.Benefit_Group__c = pg4.id;
      pb29.Cost_Share_Low__c = '0';
      pb29.Cost_Share_High__c = '100';
      pb29.Cost_Share_Increment__c = '10';
      pb29.Cost_Share_Default_Amount__c = '40';
      pb29.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb29.Cost_Share_InvalidIncrements__c = '20, 30';
      pb29.Sequence_Number__c = 1;
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'Three Month Carryover Deductible';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'General Copay';
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
  
  AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
      pb16.Benefit_Name__c = 'General Copay';
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

  AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
      apc.Plan_Benefits__c = pb.id;
      apc.AliasName__c = 'General Copay';
      apc.CopayAmount__c = '200';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.Out_of_Pocket_Max__c = 'Stacked';
      pp.OralChemoMandateApply__c  = 'Yes';    
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    
      ext.dispatcherTemp();
            ext.getPlanCommentCodes();
        
      ext.back();
      ext.dispatcher();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerDispatcherTmp7() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Funding_Arrangements__c = 'Both';
        insert brf;
        
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'General Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      pb.IS_ASO_Only__c = 'No';
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'General Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      pb29.IS_ASO_Only__c = 'No';
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'General Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      pb.IS_ASO_Only__c = 'No';
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'General Copay';
      pb3.Record_Type__c = 'BRF';
      pb3.Type__c = 'Cost Share';
      pb3.Benefit_Group__c = pg.id;
      pb3.Cost_Share_Low__c = '0';
      pb3.Cost_Share_High__c = '100';
      pb3.Cost_Share_Increment__c = '10';
      pb3.Cost_Share_Default_Amount__c = '40';
      pb3.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb3.Cost_Share_InvalidIncrements__c = '20, 30';
      pb3.IS_ASO_Only__c = 'No';
      //insert pb3;
  lstPlnt.add(pb3);
  
  AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
      pb16.Benefit_Name__c = 'General Copay';
      pb16.Record_Type__c = 'BRF';
      pb16.Type__c = 'Cost Share';
      pb16.Benefit_Group__c = pg2.id;
      pb16.Cost_Share_Low__c = '0';
      pb16.Cost_Share_High__c = '100';
      pb16.Cost_Share_Increment__c = '10';
      pb16.Cost_Share_Default_Amount__c = '40';
      pb16.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb16.Cost_Share_InvalidIncrements__c = '20, 30';
      pb16.IS_ASO_Only__c = 'No';
      // insert pb16;
  lstPlnt.add(pb16);

  insert lstPlnt;

  AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
      apc.Plan_Benefits__c = pb.id;
      apc.AliasName__c = 'General Copay';
      apc.CopayAmount__c = '200';
      apc.CoinsuranceAmount__c = '50';
      apc.MinPayAmount__c = '90';
      apc.MaxPayAmount__c = '80';
      apc.IsCovered__c = 'Yes';
      apc.DeductibleApplies__c = 'No';
      apc.MandateIndicator__c = 'Yes';
      apc.Jurisdiction__c = 'Federal';
      apc.MandateName__c = 'Home health care ';
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
      apc3.MandateIndicator__c = 'Yes';
      apc3.Jurisdiction__c = 'Federal';
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.Jurisdiction__c = 'Federal';
      apc30.MandateName__c = 'PPACA mandate';
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
      obj.Jurisdiction__c = 'Federal';
  insert obj;

  AIA_Plan_Limitation__c obj2 = new AIA_Plan_Limitation__c();
      obj2.Plan_Benefits__c = pb.id;
      obj2.MandateIndicator__c = true;
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      pbc.Type__c ='Limitation';
      pbc.FundingArrangement__c = 'Risk';
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      pbc.Type__c ='Limitation';
      pbc.FundingArrangement__c = 'Risk';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.Out_of_Pocket_Max__c = 'Stacked';
      pp.OralChemoMandateApply__c  = 'Yes';    
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    
      ext.dispatcherTemp();
      ext.getPlanCommentCodes();  
      ext.back();
      ext.dispatcher();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerDispatcherTmp8() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Funding_Arrangements__c = 'Both';
        insert brf;
        
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'General Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'General Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'General Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'General Copay';
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
  
  AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
      pb16.Benefit_Name__c = 'General Copay';
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

  AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
      apc.Plan_Benefits__c = pb.id;
      apc.AliasName__c = 'General Copay';
      apc.CopayAmount__c = '200';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      //pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
       pbc.Type__c ='Mandate';
      pbc.FundingArrangement__c = 'Risk';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
       pbc.Type__c ='Mandate';
      pbc.FundingArrangement__c = 'Risk';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.Out_of_Pocket_Max__c = 'Stacked';
      pp.OralChemoMandateApply__c  = 'Yes';    
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    
      ext.dispatcherTemp();
      ext.getPlanCommentCodes();  
      ext.back();
      ext.dispatcher();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerDispatcherTmp9() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Funding_Arrangements__c = 'Both';
        insert brf;
        
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'General Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'General Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'General Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'General Copay';
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
  
  AIA_Plan_Benefits__c pb16 = new AIA_Plan_Benefits__c();
      pb16.Benefit_Name__c = 'General Copay';
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

  AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
      apc.Plan_Benefits__c = pb.id;
      apc.AliasName__c = 'General Copay';
      apc.CopayAmount__c = '200';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      //pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
       pbc.Type__c ='Mandate';
      pbc.FundingArrangement__c = 'Risk';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
       pbc.Type__c ='Mandate';
      pbc.FundingArrangement__c = 'Risk';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

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
      pp.Blue_Rewards__c = 'Standard';
      pp.Out_of_Pocket_Max__c = 'Stacked';
      pp.OralChemoMandateApply__c  = 'Yes';    
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    
      ext.dispatcherTemp();
     
      ext.getPlanCommentCodes();  
      ext.back();
      ext.dispatcher();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerVision3() {

  //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
  
  /*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); 
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Enrollment_Type__c= 'Cafeteria';
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
      pg3.Type__c = 'Cost Share Group';
      pg3.Sequence_Number__c = 1;
      pg3.Record_Type__c = 'BRF';
      pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
      // insert pg3;
  lstGrp.add(pg3);
  
    AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
      pg4.Name = 'Medical Supplies/Equipment-0628';
      pg4.Plan_Network__c = pn2.id;
      pg4.Type__c = 'Cost Share Group';
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
        insert apbt1;  
 

  //  insert lstPlnt;

  AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
      apc.Plan_Benefits__c = apbt.id;
      apc.AliasName__c = 'Specialist Copay';
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
      apc3.AliasName__c = 'Specialist Copay';
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
      pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp1.Benefit_Request_Form__c = brf.id;
      pp1.Funding_Arrangement__c = 'Risk';
      pp1.Product_Category__c = 'Drug'; //previoulsy Vision
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
      pp1.FirstHelp__c = 'Yes';
      pp1.Exclusive_Specialty_Provider_Network__c = 'Yes';
      pp1.ExtraCare_Health_Care_Card__c = 'No';
  insert pp1;
  
    Proposed_Products__c pp5 = new Proposed_Products__c();
         pp5.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp5.Benefit_Request_Form__c = brf.id;
      pp5.Funding_Arrangement__c = 'Risk';
      pp5.Product_Category__c = 'Drug'; //previoulsy Vision
      pp5.Product_Line__c = 'PPO';
      pp5.Plan_Name__c = aiapln.id;
      pp5.Product_Name__c = 'BlueChoice Advantage';
      pp5.CDH__c = 'Yes';
      pp5.CDH_Fund_Type__c = 'BlueFund';
      pp5.CDH_Type__c = 'HSA';
      pp5.Deductible__c = 'Stacked';
      pp5.Grandfathered_Status__c = 'Grandfathered';
      pp5.Integrated_Non_Integrated__c = 'Yes';
      pp5.Grandfathered_PPACA_Status__c = 'No';
      pp5.Blue_Rewards__c = 'Standard';
      pp5.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp5.Has_Benefit_Details__c = false;
      pp5.Rider__c = 'None';
      pp5.FirstHelp__c = 'Yes';
      pp5.Exclusive_Specialty_Provider_Network__c = 'Yes';
      pp5.ExtraCare_Health_Care_Card__c = 'No';
        //pp5.Related_Medical_Product__c = pp1.id;
         insert pp5;
  
  List<Proposed_Products__c> pPList = new List<Proposed_Products__c>();
  Proposed_Products__c pp2 = new Proposed_Products__c();
      pp2.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp2.Benefit_Request_Form__c = brf.id;
      pp2.Funding_Arrangement__c = 'Risk';
      pp2.Product_Category__c = 'Drug';
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
      pp2.Blue_Rewards__c = 'Standard';
      pp2.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp2.Has_Benefit_Details__c = false;
      pp2.Rider__c = 'None';
      pp2.FirstHelp__c = 'Yes';
      pp2.Exclusive_Specialty_Provider_Network__c = 'Yes';
      pp2.ExtraCare_Health_Care_Card__c = 'No';
      //pp2.Related_Medical_Product__c= pp1.id;
      
      pPList.add(pp2);
      
      Proposed_Products__c pp3 = new Proposed_Products__c();
      pp3.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp3.Benefit_Request_Form__c = brf.id;
      pp3.Funding_Arrangement__c = 'Risk';
      pp3.Product_Category__c = 'Drug';
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
      pp3.Blue_Rewards__c = 'Standard';
      pp3.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp3.Has_Benefit_Details__c = false;
      pp3.Rider__c = 'None';
      pp3.FirstHelp__c = 'Yes';
      pp3.Exclusive_Specialty_Provider_Network__c = 'Yes';
      pp3.ExtraCare_Health_Care_Card__c = 'No';
      //pp3.Related_Medical_Product__c= pp1.id;
      
      pPList.add(pp3);
      
      insert pPList;
  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
  
  AIA_Grouper__c RXgrouper = new AIA_Grouper__c();
      RXgrouper.Name = 'Retail NonMaintenance';
      RXgrouper.Group_Type__c = 'Benefit Group';
      RXgrouper.Grouper_Record_Type__c = 'BRF';
      //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
      RXgrouper.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
    
      RXgrouper.Proposed_Products__c = pp1.id;
  insert RXgrouper;
  
  list<AIA_Benefits__c> benfList = new list<AIA_Benefits__c>();
   AIA_Benefits__c ab6 = new AIA_Benefits__c();
      ab6.Grouper__c = RXgrouper.id;
      ab6.Benefit_Name__c = 'Specialist Copay';
      //ab6.Benefit_Type__c = 'Benefit';
      ab6.Benefit_Type__c = 'Mandate';
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
      ab6.Benefit_Summary_Comment__c ='hello';
      ab6.Copay_Type_1_Benefit_Comment_Codes__c ='NA';
  insert ab6;
  //benfList.add(ab6);
  
  AIA_Benefits__c ab7 = new AIA_Benefits__c();
      ab7.Grouper__c = RXgrouper.id;
      ab7.Benefit_Name__c = 'Specialist Copay';
      //ab7.Benefit_Type__c = 'Benefit';
      ab7.Benefit_Type__c = 'Mandate';
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
      ab7.Benefit_Summary_Comment__c ='abc';
      ab7.Copay_Type_1_Benefit_Comment_Codes__c ='NA';
      benfList.add(ab7);
      
      insert benfList;
      
  
  Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab6.id, True, 'TierLimit');
  insert lmt2;
  Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab6.id, True, 'Comment');
  insert lmt3;
 
  

  
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
      //ext.dispatcherTemp();
      ext.back();

AIA_Benefit_SummaryController benefitSummaryCtrl = new AIA_Benefit_SummaryController();
  test.stoptest();
 }

 
  public Static TestMethod void TestAIA_Benefit_SummaryControllerValidate2() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
  AIA_Plan_Grouper__c pg = new AIA_Plan_Grouper__c();
      pg.Name = 'CostShareRanges';
      pg.Plan_Network__c = pn.id;
      pg.Type__c = 'Cost Share Group';
      pg.Record_Type__c = 'BRF';
      pg.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00';
      pg.IsCovered__c='True';
      pg.DeductibleApplies__c='Yes';
      pg.AnnualMaximumApplies__c='Yes';
      //insert pg;
  lstGrp.add(pg);

  AIA_Plan_Grouper__c pg2 = new AIA_Plan_Grouper__c();
      pg2.Name = 'CostShareRanges';
      pg2.Plan_Network__c = pn2.id;
      pg2.Type__c = 'Cost Share Group';
      pg2.Record_Type__c = 'BRF';
      pg2.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002';
      pg2.IsCovered__c='True';
      pg2.DeductibleApplies__c='Yes';
      pg2.AnnualMaximumApplies__c='Yes';
      //   insert pg2;
  lstGrp.add(pg2);

  AIA_Plan_Grouper__c pg3 = new AIA_Plan_Grouper__c();
      pg3.Name = 'Medical Supplies/Equipment-0628';
      pg3.Plan_Network__c = pn.id;
      pg3.Type__c = 'Benefit Group';
      pg3.Sequence_Number__c = 1;
      pg3.Record_Type__c = 'BRF';
      pg3.ExtID__c = 'PLAN-001N_BRF1CSG_BRF00432';
      pg3.IsCovered__c='True';
      pg3.DeductibleApplies__c='Yes';
      pg3.AnnualMaximumApplies__c='Yes';
      // insert pg3;
  lstGrp.add(pg3);

  AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
      pg4.Name = 'Medical Supplies/Equipment-0629';
      pg4.Plan_Network__c = pn2.id;
      pg4.Type__c = 'Benefit Group';
      pg4.Sequence_Number__c = 1;
      pg4.Record_Type__c = 'BRF';
      pg4.ExtID__c = 'PLAN-001N_BRF1CSG_BRF002433';
      pg4.IsCovered__c='True';
      pg4.DeductibleApplies__c='Yes';
      pg4.AnnualMaximumApplies__c='Yes';
      //insert pg4;
  lstGrp.add(pg4);

  insert lstGrp;

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'Specialist Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'Specialist Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'Specialist Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'Specialist Copay';
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
      pb4.Benefit_Name__c = 'Specialist Copay';
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
      pb5.Benefit_Name__c = 'Specialist Copay';
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
      pb6.Benefit_Name__c = 'Specialist Copay';
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
      pb7.Benefit_Name__c = 'Specialist Copay';
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
      pb8.Benefit_Name__c = 'Specialist Copay';
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
      pb9.Benefit_Name__c = 'Specialist Copay';
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
      pb10.Benefit_Name__c = 'Specialist Copay';
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
      pb11.Benefit_Name__c = 'Specialist Copay';
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
      pb13.Benefit_Name__c = 'Specialist Copay';
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
      pb14.Benefit_Name__c = 'Specialist Copay';
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
      pb15.Benefit_Name__c = 'Specialist Copay';
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
      pb16.Benefit_Name__c = 'Specialist Copay';
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
      pb17.Benefit_Name__c = 'Specialist Copay';
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
      pb18.Benefit_Name__c = 'Specialist Copay';
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
      pb19.Benefit_Name__c = 'Specialist Copay';
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
      pb20.Benefit_Name__c = 'Specialist Copay';
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
      pb21.Benefit_Name__c = 'Specialist Copay';
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
      pb22.Benefit_Name__c = 'Specialist Copay';
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
      pb23.Benefit_Name__c = 'Specialist Copay';
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
      apc.AliasName__c = 'Specialist Copay';
      apc.CopayAmount__c = '200';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.OralChemoMandateApply__c  = 'Yes'; 
      pp.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
      // Commenting as part of US1650
      //ext.getPCSdata();
      ext.mainInit();
      ext.createWrapListFromPlan(pp);
      ext.createWrapListFromPlanCostShr(aiapln.id);
     /*ext.bnftcostlst[0].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[1].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[2].Cost_Share_SelectedAmount__c = '10';
      */

      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Specialist Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Increment__c = '5';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'Specialist Copay';

      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Specialist Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Increment__c = '';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'Specialist Copay';

      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Specialist Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Increment__c = '5';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30,40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'Specialist Copay';

      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Specialist Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_High__c = '5';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Low__c = '1';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Increment__c = '';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'Specialist Copay';

  ext.saveAndCon();
  ext.back();


  test.stoptest();
 }
 
  public Static TestMethod void TestAIA_Benefit_SummaryControllerValidate3() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'Per Admission Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'Per Admission Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'Per Admission Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'Per Admission Copay';
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
      pb4.Benefit_Name__c = 'Per Admission Copay';
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
      pb5.Benefit_Name__c = 'Per Admission Copay';
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
      pb6.Benefit_Name__c = 'Per Admission Copay';
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
      pb7.Benefit_Name__c = 'Per Admission Copay';
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
      pb8.Benefit_Name__c = 'Per Admission Copay';
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
      pb9.Benefit_Name__c = 'Per Admission Copay';
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
      pb10.Benefit_Name__c = 'Per Admission Copay';
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
      pb11.Benefit_Name__c = 'Per Admission Copay';
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
      pb13.Benefit_Name__c = 'Per Admission Copay';
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
      pb14.Benefit_Name__c = 'Per Admission Copay';
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
      pb15.Benefit_Name__c = 'Per Admission Copay';
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
      pb16.Benefit_Name__c = 'Per Admission Copay';
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
      pb17.Benefit_Name__c = 'Per Admission Copay';
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
      pb18.Benefit_Name__c = 'Per Admission Copay';
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
      pb19.Benefit_Name__c = 'Per Admission Copay';
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
      pb20.Benefit_Name__c = 'Per Admission Copay';
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
      pb21.Benefit_Name__c = 'Per Admission Copay';
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
      pb22.Benefit_Name__c = 'Per Admission Copay';
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
      pb23.Benefit_Name__c = 'Per Admission Copay';
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
      apc.AliasName__c = 'Per Admission Copay';
      apc.CopayAmount__c = '200';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.OralChemoMandateApply__c  = 'Yes'; 
      pp.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
     // Commenting as part of US1650
      //ext.getPCSdata();
      ext.mainInit();
      ext.createWrapListFromPlan(pp);
      ext.createWrapListFromPlanCostShr(aiapln.id);
      /*ext.bnftcostlst[0].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[1].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[2].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[3].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[4].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[5].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[6].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[7].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[8].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[9].Cost_Share_SelectedAmount__c = '10';
*/
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Per Admission Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Increment__c = '5';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'Per Admission Copay';

      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Per Admission Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Increment__c = '';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'Per Admission Copay';

      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Per Admission Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Increment__c = '5';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30,40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'Per Admission Copay';

      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Per Admission Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_High__c = '5';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Low__c = '1';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Increment__c = '';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'Per Admission Copay';

  ext.saveAndCon();
  ext.back();


  test.stoptest();
 }
 
  public Static TestMethod void TestAIA_Benefit_SummaryControllerValidate4() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'Coinsurance';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'Coinsurance';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'Coinsurance';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'Coinsurance';
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
      pb4.Benefit_Name__c = 'Coinsurance';
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
      pb5.Benefit_Name__c = 'Coinsurance';
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
      pb6.Benefit_Name__c = 'Coinsurance';
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
      pb7.Benefit_Name__c = 'Coinsurance';
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
      pb8.Benefit_Name__c = 'Coinsurance';
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
      pb9.Benefit_Name__c = 'Coinsurance';
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
      pb10.Benefit_Name__c = 'Coinsurance';
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
      pb11.Benefit_Name__c = 'Coinsurance';
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
      pb13.Benefit_Name__c = 'Coinsurance';
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
      pb14.Benefit_Name__c = 'Coinsurance';
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
      pb15.Benefit_Name__c = 'Coinsurance';
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
      pb16.Benefit_Name__c = 'Coinsurance';
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
      pb17.Benefit_Name__c = 'Coinsurance';
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
      pb18.Benefit_Name__c = 'Coinsurance';
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
      pb19.Benefit_Name__c = 'Coinsurance';
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
      pb20.Benefit_Name__c = 'Coinsurance';
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
      pb21.Benefit_Name__c = 'Coinsurance';
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
      pb22.Benefit_Name__c = 'Coinsurance';
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
      pb23.Benefit_Name__c = 'Coinsurance';
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
      apc.AliasName__c = 'Coinsurance';
      apc.CopayAmount__c = '200';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.OralChemoMandateApply__c  = 'Yes'; 
      pp.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
      // Commenting as part of US1650
      //ext.getPCSdata();
      ext.mainInit();
      ext.createWrapListFromPlan(pp);
      ext.createWrapListFromPlanCostShr(aiapln.id);
      /*ext.bnftcostlst[0].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[1].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[2].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[3].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[4].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[5].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[6].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[7].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[8].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[9].Cost_Share_SelectedAmount__c = '10';
*/
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Coinsurance';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Increment__c = '5';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'Coinsurance';

      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Coinsurance';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Increment__c = '';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'Coinsurance';

      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Coinsurance';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Increment__c = '5';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30,40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'Coinsurance';

      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCoinsurance__c = true;
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Cost_Share_SelectedAmount__c = '40';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AliasName__c = 'Coinsurance';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_High__c = '5';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Low__c = '1';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Increment__c = '';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'Coinsurance';

  ext.saveAndCon();
  ext.back();


  test.stoptest();
 }
 
  public Static TestMethod void TestAIA_Benefit_SummaryControllerValidate5() {

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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'General Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'General Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'General Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'General Copay';
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
      pb4.Benefit_Name__c = 'General Copay';
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
      pb5.Benefit_Name__c = 'General Copay';
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
      pb6.Benefit_Name__c = 'General Copay';
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
      pb7.Benefit_Name__c = 'General Copay';
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
      pb8.Benefit_Name__c = 'General Copay';
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
      pb9.Benefit_Name__c = 'General Copay';
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
      pb10.Benefit_Name__c = 'General Copay';
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
      pb11.Benefit_Name__c = 'General Copay';
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
      pb13.Benefit_Name__c = 'General Copay';
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
      pb14.Benefit_Name__c = 'General Copay';
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
      pb15.Benefit_Name__c = 'General Copay';
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
      pb16.Benefit_Name__c = 'General Copay';
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
      pb17.Benefit_Name__c = 'General Copay';
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
      pb18.Benefit_Name__c = 'General Copay';
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
      pb19.Benefit_Name__c = 'General Copay';
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
      pb20.Benefit_Name__c = 'General Copay';
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
      pb21.Benefit_Name__c = 'General Copay';
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
      pb22.Benefit_Name__c = 'General Copay';
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
      pb23.Benefit_Name__c = 'General Copay';
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
      apc.AliasName__c = 'General Copay';
      apc.CopayAmount__c = '200';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
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
      pp.Blue_Rewards__c = 'Standard';
      pp.OralChemoMandateApply__c  = 'Yes'; 
      pp.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
      // Commenting as part of US1650
      //ext.getPCSdata();
      ext.mainInit();
      ext.createWrapListFromPlan(pp);
      ext.createWrapListFromPlanCostShr(aiapln.id);
      /*ext.bnftcostlst[0].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[1].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[2].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[3].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[4].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[5].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[6].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[7].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[8].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[9].Cost_Share_SelectedAmount__c = '10';
*/
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AliasName__c = 'General Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Increment__c = '5';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'General Copay';

      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AliasName__c = 'General Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Increment__c = '';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'General Copay';

      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AliasName__c = 'General Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_High__c = '100';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Low__c = '10';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Increment__c = '5';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30,40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'General Copay';

      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AliasName__c = 'General Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_High__c = '5';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Low__c = '1';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Increment__c = '';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_Additional_Increments__c = '20,30';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_1_AdditionalInvalidIncrements__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'General Copay';

  ext.saveAndCon();
  ext.back();


  test.stoptest();
 }
 
  public Static TestMethod void TestAIA_Benefit_SummaryControllerValidate6() {

 //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
/*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
      // List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); 
       List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Enrollment_Type__c = 'Cafeteria';
        insert brf;
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'General Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'General Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'General Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'General Copay';
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
      pb4.Benefit_Name__c = 'General Copay';
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
      pb5.Benefit_Name__c = 'General Copay';
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
      pb6.Benefit_Name__c = 'General Copay';
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
      pb7.Benefit_Name__c = 'General Copay';
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
      pb8.Benefit_Name__c = 'General Copay';
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
      pb9.Benefit_Name__c = 'General Copay';
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
      pb10.Benefit_Name__c = 'General Copay';
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
      pb11.Benefit_Name__c = 'General Copay';
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
      pb13.Benefit_Name__c = 'General Copay';
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
      pb14.Benefit_Name__c = 'General Copay';
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
      pb15.Benefit_Name__c = 'General Copay';
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
      pb16.Benefit_Name__c = 'General Copay';
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
      pb17.Benefit_Name__c = 'General Copay';
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
      pb18.Benefit_Name__c = 'General Copay';
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
      pb19.Benefit_Name__c = 'General Copay';
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
      pb20.Benefit_Name__c = 'General Copay';
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
      pb21.Benefit_Name__c = 'General Copay';
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
      pb22.Benefit_Name__c = 'General Copay';
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
      pb23.Benefit_Name__c = 'General Copay';
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
      apc.AliasName__c = 'General Copay';
      apc.CopayAmount__c = '200';
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
      apc3.MandateName__c = 'Home health care ';
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
      apc2.MandateName__c = 'PPACA mandate';
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
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
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
      pp.Blue_Rewards__c = 'Standard';
      pp.OralChemoMandateApply__c  = 'Yes'; 
      pp.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
      pp.Exclusive_Specialty_Provider_Network__c = 'Yes';
      pp.ExtraCare_Health_Care_Card__c = 'No';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
      // Commenting as part of US1650
      //ext.getPCSdata();
      ext.mainInit();
      ext.createWrapListFromPlan(pp);
      ext.createWrapListFromPlanCostShr(aiapln.id);
      /*ext.bnftcostlst[0].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[1].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[2].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[3].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[4].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[5].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[6].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[7].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[8].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[9].Cost_Share_SelectedAmount__c = '10';
*/
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AliasName__c = 'General Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Increment__c = '5';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'General Copay';

      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AliasName__c = 'General Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Increment__c = '';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'General Copay';

      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AliasName__c = 'General Copay';
      ext.pp.Exclusive_Specialty_Provider_Network__c = 'Yes';
      ext.pp.ExtraCare_Health_Care_Card__c = 'No';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Increment__c = '5';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30,40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'General Copay';

      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AliasName__c = 'General Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_High__c = '5';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Low__c = '1';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Increment__c = '';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'General Copay';

  ext.saveAndCon();
  ext.back();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerValidate7() {

   //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
/*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02 
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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Enrollment_Type__c = 'Cafeteria';
        insert brf;
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'Specialist Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'Specialist Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'Specialist Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'Specialist Copay';
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
      pb4.Benefit_Name__c = 'Specialist Copay';
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
      pb5.Benefit_Name__c = 'Specialist Copay';
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
      pb6.Benefit_Name__c = 'Specialist Copay';
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
      pb7.Benefit_Name__c = 'Specialist Copay';
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
      pb8.Benefit_Name__c = 'Specialist Copay';
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
      pb9.Benefit_Name__c = 'Specialist Copay';
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
      pb10.Benefit_Name__c = 'Specialist Copay';
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
      pb11.Benefit_Name__c = 'Specialist Copay';
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
      pb13.Benefit_Name__c = 'Specialist Copay';
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
      pb14.Benefit_Name__c = 'Specialist Copay';
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
      pb15.Benefit_Name__c = 'Specialist Copay';
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
      pb16.Benefit_Name__c = 'Specialist Copay';
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
      pb17.Benefit_Name__c = 'Specialist Copay';
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
      pb18.Benefit_Name__c = 'Specialist Copay';
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
      pb19.Benefit_Name__c = 'Specialist Copay';
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
      pb20.Benefit_Name__c = 'Specialist Copay';
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
      pb21.Benefit_Name__c = 'Specialist Copay';
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
      pb22.Benefit_Name__c = 'Specialist Copay';
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
      pb23.Benefit_Name__c = 'Specialist Copay';
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
      apc.AliasName__c = 'Specialist Copay';
      apc.CopayAmount__c = '200';
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
      apc3.Plan_Benefits__c = pb.id;
      apc3.AliasName__c = 'Specialist Copay';
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
  
  AIA_Plan_Copay_Type__c apc2 = new AIA_Plan_Copay_Type__c();
      apc2.Plan_Benefits__c = pb29.id;
      apc2.AliasName__c = 'Specialist Copay';
      apc2.CopayAmount__c = '200';
      apc2.CoinsuranceAmount__c = '50';
      apc2.MinPayAmount__c = '90';
      apc2.MaxPayAmount__c = '80';
      apc2.IsCovered__c = 'Yes';
      apc2.DeductibleApplies__c = 'No';
      apc2.MandateIndicator__c = 'Yes';
      apc2.Jurisdiction__c = 'Federal';
      apc2.MandateName__c = 'PPACA mandate';
      apc2.ExtID__c = 'rwuifghqierufghaire';
  insert apc2;

  AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
      apc30.Plan_Benefits__c = pb29.id;
      apc30.AliasName__c = 'Specialist Copay';
      apc30.CopayAmount__c = '200';
      apc30.CoinsuranceAmount__c = '50';
      apc30.MinPayAmount__c = '90';
      apc30.MaxPayAmount__c = '80';
      apc30.IsCovered__c = 'Yes';
      apc30.DeductibleApplies__c = 'No';
      apc30.MandateIndicator__c = 'Yes';
      apc30.Jurisdiction__c = 'Test';
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      //  pbc.Jurisdiction__c ='MD';
      pbc.IsRequired__c = 'Yes';
      //  pbc.Plan_Copay_Type__c ='';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      // pbc.Plan_Benefit_Parent_Name__c = ;
      //  pbc.Plan_Limitation__c = obj.id;
      // pbc.IsMandateTrue__c ='Yes';
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      //  pbc2.Jurisdiction__c ='MD';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
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
      pp.Blue_Rewards__c = 'Standard';
      pp.OralChemoMandateApply__c  = 'Yes'; 
      pp.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Exclusive_Specialty_Provider_Network__c = 'Yes';
      pp.ExtraCare_Health_Care_Card__c = 'No';
      pp.Rider__c = 'None';
  insert pp;

  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
      // Commenting as part of US1650
      //ext.getPCSdata();
      ext.mainInit();
      ext.createWrapListFromPlan(pp);
      ext.createWrapListFromPlanCostShr(aiapln.id);
      /*ext.bnftcostlst[0].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[1].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[2].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[3].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[4].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[5].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[6].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[7].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[8].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[9].Cost_Share_SelectedAmount__c = '10';
*/
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AliasName__c = 'Specialist Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Increment__c = '5';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'Specialist Copay';

      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AliasName__c = 'Specialist Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Increment__c = '';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'Specialist Copay';

      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AliasName__c = 'Specialist Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Increment__c = '5';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30,40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'Specialist Copay';

      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCoinsurance__c = true;
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AliasName__c = 'Specialist Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_High__c = '5';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Low__c = '1';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Increment__c = '';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'Specialist Copay';

  ext.saveAndCon();
  ext.back();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerValidate8() {

   //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
/*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02 
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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Enrollment_Type__c = 'Cafeteria';
        insert brf;
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'Per Admission Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'Per Admission Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'Per Admission Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'Per Admission Copay';
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
      pb4.Benefit_Name__c = 'Per Admission Copay';
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
      pb5.Benefit_Name__c = 'Per Admission Copay';
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
      pb6.Benefit_Name__c = 'Per Admission Copay';
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
      pb7.Benefit_Name__c = 'Per Admission Copay';
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
      pb8.Benefit_Name__c = 'Per Admission Copay';
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
      pb9.Benefit_Name__c = 'Per Admission Copay';
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
      pb10.Benefit_Name__c = 'Per Admission Copay';
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
      pb11.Benefit_Name__c = 'Per Admission Copay';
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
      pb13.Benefit_Name__c = 'Per Admission Copay';
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
      pb14.Benefit_Name__c = 'Per Admission Copay';
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
      pb15.Benefit_Name__c = 'Per Admission Copay';
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
      pb16.Benefit_Name__c = 'Per Admission Copay';
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
      pb17.Benefit_Name__c = 'Per Admission Copay';
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
      pb18.Benefit_Name__c = 'Per Admission Copay';
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
      pb19.Benefit_Name__c = 'Per Admission Copay';
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
      pb20.Benefit_Name__c = 'Per Admission Copay';
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
      pb21.Benefit_Name__c = 'Per Admission Copay';
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
      pb22.Benefit_Name__c = 'Per Admission Copay';
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
      pb23.Benefit_Name__c = 'Per Admission Copay';
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
      apc.AliasName__c = 'Per Admission Copay';
      apc.CopayAmount__c = '200';
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
      apc3.Plan_Benefits__c = pb.id;
      apc3.AliasName__c = 'Per Admission Copay';
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
  
  AIA_Plan_Copay_Type__c apc2 = new AIA_Plan_Copay_Type__c();
      apc2.Plan_Benefits__c = pb29.id;
      apc2.AliasName__c = 'Per Admission Copay';
      apc2.CopayAmount__c = '200';
      apc2.CoinsuranceAmount__c = '50';
      apc2.MinPayAmount__c = '90';
      apc2.MaxPayAmount__c = '80';
      apc2.IsCovered__c = 'Yes';
      apc2.DeductibleApplies__c = 'No';
      apc2.MandateIndicator__c = 'Yes';
      apc2.Jurisdiction__c = 'Federal';
      apc2.MandateName__c = 'PPACA mandate';
      apc2.ExtID__c = 'rwuifghqierufghaire';
  insert apc2;

  AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
      apc30.Plan_Benefits__c = pb29.id;
      apc30.AliasName__c = 'Per Admission Copay';
      apc30.CopayAmount__c = '200';
      apc30.CoinsuranceAmount__c = '50';
      apc30.MinPayAmount__c = '90';
      apc30.MaxPayAmount__c = '80';
      apc30.IsCovered__c = 'Yes';
      apc30.DeductibleApplies__c = 'No';
      apc30.MandateIndicator__c = 'Yes';
      apc30.Jurisdiction__c = 'Test';
      apc30.MandateName__c = 'PPACA mandate';
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
     
     
     
  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      pbc.Plan_Limitation__c = obj.id;
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      pbc.IsRequired__c = 'Yes';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;
//mod 26-5
Proposed_Products__c pp1 = new Proposed_Products__c();
      pp1.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp1.Benefit_Request_Form__c = brf.id;
      pp1.Funding_Arrangement__c = 'Risk';
      pp1.Product_Category__c = 'Medical';
      pp1.Product_Line__c = 'PPO';
      pp1.Plan_Name__c = aiapln.id;
      pp1.Product_Name__c = 'BlueChoice Advantage';
      pp1.CDH__c = 'Yes';
      pp1.CDH_Fund_Type__c = 'BlueFund';
      pp1.CDH_Type__c = 'HSA';
      pp1.Deductible__c = 'Stacked';
      pp1.Grandfathered_Status__c = 'Grandfathered';
      pp1.Integrated_Non_Integrated__c = 'Integrated';//from yes to integrated
      pp1.RX_OOP_Max_Integration__c='Integrated';
      pp1.Grandfathered_PPACA_Status__c = 'No';
      pp1.Blue_Rewards__c = 'Standard';
      pp1.OralChemoMandateApply__c  = 'Yes'; 
      pp1.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp1.Has_Benefit_Details__c = false;
      pp1.FirstHelp__c = 'Yes';
      pp1.Rider__c = 'None';
    insert pp1;
//end
  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
      pp.Benefit_Request_Form__c = brf.id;
      pp.Funding_Arrangement__c = 'Risk';
      pp.Product_Category__c = 'Drug';
     pp.Related_Medical_Product__c=pp1.id;
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
      pp.Blue_Rewards__c = 'Standard';
      pp.OralChemoMandateApply__c  = 'Yes'; 
      pp.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
      pp.Exclusive_Specialty_Provider_Network__c = 'Yes';
      pp.ExtraCare_Health_Care_Card__c = 'No';
  insert pp;

     //mod
    AIA_Grouper__c ag = new AIA_Grouper__c();
     ag.Name = 'CostShareRanges';
     ag.Group_Type__c = 'Cost Share Group';
     ag.Grouper_Record_Type__c = 'BRF';
    //ag.RecordTypeId = QueryBase.getRecordtypeId('AIA_Grouper__c', 'Proposed Product');
    ag.RecordTypeId = Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
    ag.Proposed_Products__c = pp1.id;
  insert ag;
     //plan benefit mod 26-5
     List<AIA_Benefits__c> allb=new List<AIA_Benefits__c>();
     AIA_Benefits__c ab7 = new AIA_Benefits__c();
      ab7.Grouper__c = ag.id;
      ab7.Benefit_Name__c = 'Family Out Of Pocket';
      //ab7.Cost_Share_SelectedAmount__c='40';
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
     
     allb.add(ab7);
     AIA_Benefits__c ab8 = new AIA_Benefits__c();
      ab8.Grouper__c = ag.id;
      ab8.Benefit_Name__c = 'Individual Out Of Pocket';
     // ab8.Cost_Share_SelectedAmount__c='40';
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
  allb.add(ab8);
     AIA_Benefits__c ab9 = new AIA_Benefits__c();
      ab9.Grouper__c = ag.id;
      ab9.Benefit_Name__c = 'Family Deductible';
        //   ab9.Cost_Share_SelectedAmount__c='40';

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
  allb.add(ab9);
     AIA_Benefits__c ab10 = new AIA_Benefits__c();
      ab10.Grouper__c = ag.id;
      ab10.Benefit_Name__c = 'Individual Deductible';
     //      ab10.Cost_Share_SelectedAmount__c='40';

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
    allb.add(ab10);
insert allb;
     //end
     
     
     
     
  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    // Commenting as part of US1650
      //ext.getPCSdata();
      ext.mainInit();
      ext.createWrapListFromPlan(pp);
      ext.createWrapListFromPlanCostShr(aiapln.id);
      /*ext.bnftcostlst[0].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[1].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[2].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[3].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[4].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[5].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[6].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[7].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[8].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[9].Cost_Share_SelectedAmount__c = '10';
*/
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AliasName__c = 'Per Admission Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Increment__c = '5';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'Per Admission Copay';

      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AliasName__c = 'Per Admission Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Increment__c = '';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'Per Admission Copay';

      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AliasName__c = 'Per Admission Copay';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Increment__c = '5';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30,40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'Per Admission Copay';

      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AliasName__c = 'Per Admission Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_High__c = '5';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Low__c = '1';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Increment__c = '';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'Per Admission Copay';

  ext.saveAndCon();
  ext.back();


  test.stoptest();
 }
 
 public Static TestMethod void TestAIA_Benefit_SummaryControllerValidate9() {

     //Commenting as part of US210
  /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
      wpt.Used_For__c = 'Pre-Sales';
      wpt.Workplan_Type__c = 'New';
      wpt.Active__c = true;
  insert wpt;*/

  Account acc = AIA_TestUtil.CreateAccount('TestAccount');
/*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); 
 		 List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
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
      //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
        brf.Enrollment_Type__c = 'Cafeteria';
        insert brf;
  AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug', 'Test');
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

  List < AIA_Plan_Benefits__c > lstPlnt = new List < AIA_Plan_Benefits__c > ();
  AIA_Plan_Benefits__c pb = new AIA_Plan_Benefits__c();
      pb.Benefit_Name__c = 'PCP Copay';
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
      pb.IsAppGlobalCoinsurance__c = true;
      pb.IsAppGlobalCopay__c = true;
      //insert pb;
  lstPlnt.add(pb);

  AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
      pb29.Benefit_Name__c = 'PCP Copay';
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
      pb29.IsAppGlobalCoinsurance__c = true;
      pb29.IsAppGlobalCopay__c = true;
      // insert pb29;
  lstPlnt.add(pb29);

  AIA_Plan_Benefits__c pb2 = new AIA_Plan_Benefits__c();
      pb2.Benefit_Name__c = 'PCP Copay';
      pb2.Record_Type__c = 'BRF';
      pb2.Type__c = 'Cost Share';
      pb2.Benefit_Group__c = pg.id;
      pb2.Cost_Share_Low__c = '0';
      pb2.Cost_Share_High__c = '100';
      pb2.Cost_Share_Increment__c = '10';
      pb2.Cost_Share_Default_Amount__c = '40';
      pb2.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb2.Cost_Share_InvalidIncrements__c = '20, 30';
      pb2.IsAppGlobalCoinsurance__c = true;
      pb2.IsAppGlobalCopay__c = true;
      //  insert pb2;
  lstPlnt.add(pb2);

  AIA_Plan_Benefits__c pb3 = new AIA_Plan_Benefits__c();
      pb3.Benefit_Name__c = 'PCP Copay';
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
      pb4.Benefit_Name__c = 'PCP Copay';
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
      pb5.Benefit_Name__c = 'PCP Copay';
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
      pb6.Benefit_Name__c = 'PCP Copay';
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
      pb7.Benefit_Name__c = 'PCP Copay';
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
      pb8.Benefit_Name__c = 'PCP Copay';
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
      pb9.Benefit_Name__c = 'PCP Copay';
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
      pb10.Benefit_Name__c = 'PCP Copay';
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
      pb11.Benefit_Name__c = 'PCP Copay';
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
      pb13.Benefit_Name__c = 'PCP Copay';
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
      pb14.Benefit_Name__c = 'PCP Copay';
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
      pb15.Benefit_Name__c = 'PCP Copay';
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
      pb16.Benefit_Name__c = 'PCP Copay';
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
      pb17.Benefit_Name__c = 'PCP Copay';
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
      pb18.Benefit_Name__c = 'PCP Copay';
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
      pb19.Benefit_Name__c = 'PCP Copay';
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
      pb20.Benefit_Name__c = 'PCP Copay';
      pb20.Record_Type__c = 'BRF';
      pb20.Type__c = 'Cost Share';
      pb20.Benefit_Group__c = pg2.id;
      pb20.Cost_Share_Low__c = '0';
      pb20.Cost_Share_High__c = '100';
      pb20.Cost_Share_Increment__c = '10';
      pb20.Cost_Share_Default_Amount__c = '40';
      pb20.Cost_Share_AdditionalIncrements__c = '22, 33';
      pb20.Cost_Share_InvalidIncrements__c = '20, 30';
  lstPlnt.add(pb20);
  
  AIA_Plan_Benefits__c pb21 = new AIA_Plan_Benefits__c();
      pb21.Benefit_Name__c = 'PCP Copay';
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
      pb22.Benefit_Name__c = 'PCP Copay';
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
      pb23.Benefit_Name__c = 'PCP Copay';
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
      apc.MandateName__c = 'Home health care ';
      apc.ExtID__c = 'rwuifghqierufghaire';
  insert apc;

  AIA_Plan_Copay_Type__c apc3 = new AIA_Plan_Copay_Type__c();
      apc3.Plan_Benefits__c = pb.id;
      apc3.AliasName__c = 'PCP Copay';
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
  
  AIA_Plan_Copay_Type__c apc2 = new AIA_Plan_Copay_Type__c();
      apc2.Plan_Benefits__c = pb29.id;
      apc2.AliasName__c = 'PCP Copay';
      apc2.CopayAmount__c = '200';
      apc2.CoinsuranceAmount__c = '50';
      apc2.MinPayAmount__c = '90';
      apc2.MaxPayAmount__c = '80';
      apc2.IsCovered__c = 'Yes';
      apc2.DeductibleApplies__c = 'No';
      apc2.MandateIndicator__c = 'Yes';
      apc2.Jurisdiction__c = 'Federal';
      apc2.MandateName__c = 'PPACA mandate';
      apc2.ExtID__c = 'rwuifghqierufghaire';
  insert apc2;

  AIA_Plan_Copay_Type__c apc30 = new AIA_Plan_Copay_Type__c();
      apc30.Plan_Benefits__c = pb29.id;
      apc30.AliasName__c = 'PCP Copay';
      apc30.CopayAmount__c = '200';
      apc30.CoinsuranceAmount__c = '50';
      apc30.MinPayAmount__c = '90';
      apc30.MaxPayAmount__c = '80';
      apc30.IsCovered__c = 'Yes';
      apc30.DeductibleApplies__c = 'No';
      apc30.MandateIndicator__c = 'Yes';
      apc30.Jurisdiction__c = 'Test';
      apc30.MandateName__c = 'PPACA mandate';
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

  AIA_Plan_Benefit_Comment_Codes__c pbc = new AIA_Plan_Benefit_Comment_Codes__c();
      pbc.Plan_Limitation__c = obj.id;
      pbc.Code__c = 333;
      pbc.Comment__c = 'Test';
      pbc.IsRequired__c = 'Yes';
  Insert pbc;

  AIA_Plan_Benefit_Comment_Codes__c pbc2 = new AIA_Plan_Benefit_Comment_Codes__c();
      pbc2.Code__c = 333;
      pbc2.Comment__c = 'Test';
      pbc2.IsRequired__c = 'Yes';
      pbc2.Plan_Copay_Type__c = apc.id;
  Insert pbc2;

  Proposed_Products__c pp = new Proposed_Products__c();
      pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
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
      pp.Blue_Rewards__c = 'Standard';
      pp.OralChemoMandateApply__c  = 'Yes'; 
      pp.Out_of_Pocket_Max__c = 'Stacked';
      // pp.Jurisdiction__c = 'MD';
      pp.Has_Benefit_Details__c = false;
      pp.FirstHelp__c = 'Yes';
      pp.Rider__c = 'None';
      pp.Exclusive_Specialty_Provider_Network__c = 'Yes';
      pp.ExtraCare_Health_Care_Card__c = 'No';
  insert pp;
     
  test.starttest();
  AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();

  PageReference pref = Page.AIA_ProposedProd_Summary;
  Test.setCurrentPage(pref);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      ApexPages.StandardController con = new ApexPages.StandardController(PP);
      ApexPages.currentPage().getParameters().put('id', pp.id);
      AIA_Benefit_SummaryController ext = new AIA_Benefit_SummaryController(con);
    // Commenting as part of US1650
      //ext.getPCSdata();
      ext.mainInit();
      ext.createWrapListFromPlan(pp);
      ext.createWrapListFromPlanCostShr(aiapln.id);
      /*ext.bnftcostlst[0].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[1].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[2].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[3].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[4].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[5].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[6].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[7].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[8].Cost_Share_SelectedAmount__c = '10';
      ext.bnftcostlst[9].Cost_Share_SelectedAmount__c = '10';
*/
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AliasName__c = 'PCP Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Increment__c = '5';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'PCP Copay';

      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AliasName__c = 'PCP Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Increment__c = '';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '10,50';
      ext.grouperWrapList[0].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'PCP Copay';

      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_AliasName__c = 'PCP Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_High__c = '100';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Low__c = '10';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Increment__c = '5';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30,40';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[0].aiaBenifitObj.Benefit_Name__c = 'PCP Copay';

      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.IsAppGlobalCopay__c = true;
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AmountValueSelected__c = '40';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_AliasName__c = 'PCP Copay';
      ext.pp.funding_Arrangement__c = 'Risk';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_High__c = '5';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Low__c = '1';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Increment__c = '';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Copay_Type_2_Additional_Increments__c = '20,30';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.CopayType2_Additional_InvalidIncrement__c = '40,50';
      ext.grouperWrapList[1].benifitWrapList[1].aiaBenifitObj.Benefit_Name__c = 'PCP Copay';

  ext.saveAndCon();
  ext.back();


  test.stoptest();
 }
 
      public static testmethod void TestAIA_benefitsummary_WithPlanStaticMedical(){
            //Commenting as part of US210 
           /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
            wpt.Used_For__c ='Pre-Sales';
            wpt.Workplan_Type__c = 'New';
            wpt.Active__c=true;
            insert wpt;*/
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
        
        user u41 = AIA_TestUtil.AIA_createUser('alias41');
        userList.add(u41);        
        user u51= AIA_TestUtil.AIA_createUser('alias51');
        userList.add(u51); 
        user u61 = AIA_TestUtil.AIA_createUser('alias61');
        userList.add(u61);
         
        //Creating User Test Data T01 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
          insert userList;
		//T01 ends
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
             List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //T01
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
            
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u41.id,'Account Executive')); 
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u51.id,'Proposal Specialist'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u61.id,'Account Manager'));
          //Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T01 ends
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
            //o.Workplan_Type__c = wpt.id; //Commenting as part of US210
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
            insert brf;


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
            ext.dispatcher();
            ext.saveAndCon();
            List<AIA_Plan_Benefits__c> plben= [select id,name from AIA_Plan_Benefits__c where Plan__c = :String.valueof(aiapln.Id).substring(0,15)] ;
            AIA_Benefit_Design__c bd=cCreateBenefitDesignWImpFromBrf(acc,o.id,brf.id);

            AIA_Benefit_Design_Product__c bdp= new AIA_Benefit_Design_Product__c();
            bdp.Benefit_Design__c=bd.id;
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
                ext2.mainInit();
            }catch(Exception e){
            }
            ext2.saveAndCon();

            test.stopTest();
        }

      public static AIA_Benefit_Design__c cCreateBenefitDesignWImpFromBrf(Account acc, string oppid, string brfid){
          
            
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = oppid;
            Imp.Account__c = acc.id;
            //Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
            AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
            aiaBD.Account__c = acc.id;
            aiaBD.Benefit_Request_Form__c = brfId;
            insert aiaBD;
        return aiaBD;
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
  
    

}