@istest//(seealldata=true)
public with sharing class AIA_BD_DeepClone_Test2 {

public static testmethod void Test_AIA_BD_DeepClone_TestCase3(){
    AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
    //Commenting as part of US210
    /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
    wpt.Used_For__c ='Pre-Sales';
    wpt.Workplan_Type__c = 'New';
    wpt.Active__c=true;
    insert wpt;
system.assertNOTEquals(wpt,Null);*/

    Account acc = AIA_TestUtil.CreateAccount('TestAccount');
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
     //Creating User Test Data T01 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T01 ends
    insert userList;       
    system.assertNOTEquals(userList.size(),Null);
    
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
    List<Account_Team__c> acctMbrList =new List<Account_Team__c>();//T02
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor')); //T02
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
    	//Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T01 ends
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
system.assertNOTEquals(o,Null);
    
    Benfit_Request_Form__c brfSource = new Benfit_Request_Form__c();
    brfSource.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
    brfSource.Contract_Count__c = 123;
    brfSource.Benefit_Effective_Date__c = system.today();
    brfSource.Account__c = acc.id;
    brfSource.ARC_Approval_Status__c = '';//'Approved by Committee';
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
    brf.ARC_Approval_Status__c = '';//'Approved by Committee';
    brf.Escalated_to_Senior_Management__c = true;
    brf.Status__c = 'new';
    brf.Opportunity__c = o.id;
    brf.Jurisdiction__c = 'MD';
    brf.Enrollment_Type__c = 'Cafeteria';
    brf.Request_Type__c = 'Prospect/New';
    brf.Source_Benefit_Request_Form__c = brfSource.id;
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
    insert pp;
    system.assertNOTEquals(pp,Null);
    
    test.starttest();
    AIA_ProposedProductsHandler.firstRun = true;
    AIA_ProposedProductsHandler.afterInsert = true;
    AIA_ProposedProductsHandler.afterUpdate = true;
    AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
    AIA_BRFTriggerHandler.adjustmentPreviouslyCalled = True;
    AIA_ProposedProductsHandler.adjustmentPreviouslyCalled = True;
    AIA_BenefitDesignTriggerHandler.Firstrun = True;
    AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
    
    list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
    AIA_Implementation__c Imp1 = new AIA_Implementation__c();
    Imp1.Name__c = 'testprf';
    Imp1.Opportunity__c = o.Id;
    Imp1.Account__c = acc.Id;
    //Imp1.Generate_Workplan_Stages__c = true;
    Imp1.Effective_Date__c = system.today();
    Imp1.Implementation_Plan_Timeline_Days__c = '60';
    Imp1.Risk_Type__c='ASO';
    Imp1.Benefit_Request_Form__c = brf.id;
    lstImp.add(Imp1);

    AIA_Implementation__c Imp = new AIA_Implementation__c();
    Imp.Name__c = 'testprf';
    Imp.Opportunity__c = o.Id;
    Imp.Account__c = acc.Id;
    //Imp.Generate_Workplan_Stages__c = true;
    Imp.Effective_Date__c = system.today();
    Imp.Implementation_Plan_Timeline_Days__c = '60';
    Imp.Risk_Type__c='ASO';
    Imp.Benefit_Request_Form__c = brfSource.id;
    lstImp.add(Imp);
    if(lstImp != NULL && lstImp.size()>0)
        insert lstImp;
    system.assertNOTEquals(lstImp.size(),Null);
    
    
    
  PageReference pref = Page.AIA_BDP_DeepClone1;
  Test.setCurrentPage(pref);
  //ApexPages.currentPage().getParameters().put('id',Imp.id);
  ApexPages.StandardController con = new ApexPages.StandardController(Imp1);
  ApexPages.currentPage().getParameters().put('id', Imp1.id);
  ApexPages.currentPage().getParameters().put('planid', aiapln.id);
  AIA_BD_DeepClone ext = new AIA_BD_DeepClone(con);
  ApexPages.currentPage().getParameters().put('palanIdValue','BDD');
    test.stopTest(); 
}
public static testmethod void Test_AIA_BD_DeepClone_TestCase5(){
    AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
    //Commenting as part of US210
    /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
    wpt.Used_For__c ='Pre-Sales';
    wpt.Workplan_Type__c = 'New';
    wpt.Active__c=true;
    insert wpt;
    system.assertNOTEquals(wpt,Null);*/

    Account acc = AIA_TestUtil.CreateAccount('TestAccount');
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
    insert userList;       
    system.assertNOTEquals(userList.size(),Null);
    
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
    List<Account_Team__c> acctMbrList =new List<Account_Team__c>();//T02
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor')); //T01
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
    
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
system.assertNOTEquals(o,Null);
    
    Benfit_Request_Form__c brfSource = new Benfit_Request_Form__c();
    brfSource.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
    brfSource.Contract_Count__c = 123;
    brfSource.Benefit_Effective_Date__c = system.today();
    brfSource.Account__c = acc.id;
    brfSource.ARC_Approval_Status__c = '';//'Approved by Committee';
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
    brf.ARC_Approval_Status__c = '';//'Approved by Committee';
    brf.Escalated_to_Senior_Management__c = true;
    brf.Status__c = 'new';
    brf.Opportunity__c = o.id;
    brf.Jurisdiction__c = 'MD';
    brf.Enrollment_Type__c = 'Cafeteria';
    brf.Request_Type__c = 'Prospect/New';
    brf.Source_Benefit_Request_Form__c = brfSource.id;
    insert brf;
    system.assertNOTEquals(brf,Null);


    AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
    aiapln.Plan_Name__c='Test Plan';
    aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
    aiapln.Jurisdiction__c = 'MD';
    aiapln.Product_Status__c ='Active';
    aiapln.Has_Benefit_Summary__c = true;
    aiapln.Effective_Date__c = system.today()+3;
    aiapln.Termination_Date__c = system.today()+30;
    insert aiapln;
    //aiapln.BDF_Configuration_Last_Updated__c = datetime.now();
//update aiapln;
system.assertNOTEquals(aiapln,Null);

    AIA_BD_DeepClone_Test.createPlanData(aiapln);

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
    system.assertNOTEquals(pp,Null);
    
    AIA_Grouper__c ag = new AIA_Grouper__c();
    ag.Name = 'CostShareRanges';
    ag.Group_Type__c = 'Cost Share Group';
    ag.Grouper_Record_Type__c = 'BDD';
    ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag.Proposed_Products__c = pp.id;
    insert ag;
   system.assertNOTEquals(ag,Null);
list<AIA_Benefits__c> bnftList = new list<AIA_Benefits__c>();
    AIA_Benefits__c ab = new AIA_Benefits__c();           
    ab.Grouper__c = ag.id;
    ab.Benefit_Name__c = 'Family Out Of Pocket';
    ab.Benefit_Type__c = 'Benefit';
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
    ab.Copay_Min_Payment__c = '20';
    ab.Copay_Max_Payment__c = '30';
    ab.OON_Copay_Min_Payment__c = '10';
    ab.OON_Copay_Max_Payment__c = '10';
    
    ab.Allowed_Amount__c = '5';
    ab.Allowed_Amount_Default__c = '1';
    ab.Copay_Type_1_DefaultAmount__c = '4';
    ab.CoInsurance_AmountValueSelected__c = '4';
    ab.Coinsurance_DefaultAmount__c = '5';
    ab.Copay_Type_1_AmountValueSelected__c = '4';
    ab.Copay_Type_1_DefaultAmount__c = '5';
    ab.Copay_Type_2_AmountValueSelected__c = '4';
    ab.Copay_Type_2_DefaultAmount__c = '5';
    ab.Cost_Share_Default_Amount__c = '5';
    ab.Cost_Share_SelectedAmount__c = '4';
    ab.Discount_Amount__c = '4';
    ab.Discount_Amount_Default__c = '5';
    ab.IN_CostShare_3Month_DeductibleCarryover__c = 'Yes';
    ab.IN_CostShare_3Month_DedCarryover_Default__c = 'No';
    ab.OON_Allowed_Amount_Default__c = '4';
    ab.OON_Allowed_Amount__c = '5';
    ab.OON_Coinsurance_DefaultAmount__c = '4';
    ab.OON_CoInsurance_AmountValueSelected__c = '5';
    ab.OON_Copay_1_Default_DeductibleApplies__c = 'No';
    ab.OON_Copay_Type_1_AmountValueSelected__c = '5';
    ab.OON_Copay_1_Default_DeductibleApplies__c = 'Yes';
    ab.OON_Copay_Type_2_AmountValueSelected__c = 'No';
    ab.OON_Copay_Type_1_DefaultAmount__c = '4';
    ab.OON_Copay_Type_1_Benefit_Comment_Cod__c = '4';
    ab.OON_Copay_Type_1_Default_IsCovered__c = 'No';
    ab.OON_Copay_Type_1_Individual_Mandate__c = true;
    ab.OON_Copay_Type_1_Is_ASO_Only__c = true;
    ab.OON_Copay_Type_1_Jurisdiction__c = '3';
    ab.OON_Copay_Type_1_Mandate_Name__c = '34';
   
    
    //ab.Copay_Type_1_Amount_Customized__c = true;
    //ab.Benefit_Customized__c = true;
    bnftList.add(ab);
    
    AIA_Benefits__c ab1 = new AIA_Benefits__c();           
    ab1.Grouper__c = ag.id;
    ab1.Benefit_Name__c = 'Family Out Of Pocket';
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
    
    ab1.Allowed_Amount__c = '5';
    ab1.Allowed_Amount_Default__c = '1';
    ab1.Copay_Type_1_DefaultAmount__c = '4';
    ab1.CoInsurance_AmountValueSelected__c = '4';
    ab1.Coinsurance_DefaultAmount__c = '5';
    ab1.Copay_Type_1_AmountValueSelected__c = '4';
    ab1.Copay_Type_1_DefaultAmount__c = '5';
    ab1.Copay_Type_2_AmountValueSelected__c = '4';
    ab1.Copay_Type_2_DefaultAmount__c = '5';
    ab1.Cost_Share_Default_Amount__c = '5';
    ab1.Cost_Share_SelectedAmount__c = '4';
    ab1.Discount_Amount__c = '4';
    ab1.Discount_Amount_Default__c = '5';
    ab1.IN_CostShare_3Month_DeductibleCarryover__c = 'Yes';
    ab1.IN_CostShare_3Month_DedCarryover_Default__c = 'No';
    ab1.OON_Allowed_Amount_Default__c = '4';
    ab1.OON_Allowed_Amount__c = '5';
    ab1.OON_Coinsurance_DefaultAmount__c = '4';
    ab1.OON_CoInsurance_AmountValueSelected__c = '5';
    ab1.OON_Copay_1_Default_DeductibleApplies__c = 'No';
    ab1.OON_Copay_Type_1_AmountValueSelected__c = '5';
    ab1.OON_Copay_1_Default_DeductibleApplies__c = 'Yes';
    ab1.OON_Copay_Type_2_AmountValueSelected__c = 'No';
    ab1.OON_Copay_Type_1_DefaultAmount__c = '4';
    ab1.OON_Copay_Type_1_Benefit_Comment_Cod__c = '4';
    ab1.OON_Copay_Type_1_Default_IsCovered__c = 'No';
    ab1.OON_Copay_Type_1_Individual_Mandate__c = true;
    ab1.OON_Copay_Type_1_Is_ASO_Only__c = true;
    ab1.OON_Copay_Type_1_Jurisdiction__c = '3';
    ab1.OON_Copay_Type_1_Mandate_Name__c = '34';
    
    
    //ab1.Copay_Type_1_Amount_Customized__c = false;
    //ab1.Benefit_Customized__c = false;
    bnftList.add(ab1);
    insert bnftList;
    system.assertNOTEquals(bnftList,Null);
    
    test.starttest();
    AIA_ProposedProductsHandler.firstRun = true;
    AIA_ProposedProductsHandler.afterInsert = true;
    AIA_ProposedProductsHandler.afterUpdate = true;
    AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
    AIA_BRFTriggerHandler.adjustmentPreviouslyCalled = True;
    AIA_ProposedProductsHandler.adjustmentPreviouslyCalled = True;
    AIA_BenefitDesignTriggerHandler.Firstrun = True;
    AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
    
    list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
    AIA_Implementation__c Imp1 = new AIA_Implementation__c();
    Imp1.Name__c = 'testprf';
    Imp1.Opportunity__c = o.Id;
    Imp1.Account__c = acc.Id;
    //Imp1.Generate_Workplan_Stages__c = true;
    Imp1.Effective_Date__c = system.today();
    Imp1.Implementation_Plan_Timeline_Days__c = '60';
    Imp1.Risk_Type__c='ASO';
    Imp1.Benefit_Request_Form__c = brf.id;
    lstImp.add(Imp1);

    AIA_Implementation__c Imp = new AIA_Implementation__c();
    Imp.Name__c = 'testprf';
    Imp.Opportunity__c = o.Id;
    Imp.Account__c = acc.Id;
    //Imp.Generate_Workplan_Stages__c = true;
    Imp.Effective_Date__c = system.today();
    Imp.Implementation_Plan_Timeline_Days__c = '60';
    Imp.Risk_Type__c='ASO';
    Imp.Benefit_Request_Form__c = brfSource.id;
    lstImp.add(Imp);
    if(lstImp != NULL && lstImp.size()>0)
        insert lstImp;
    system.assertNOTEquals(lstImp.size(),Null);
    
    AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
    aiaBD.Implementation__c = Imp.id;
    aiaBD.Account__c = acc.Id;
    aiaBD.Benefit_Request_Form__c = brf.Id;
    insert aiaBD;
    system.assertNOTEquals(aiaBD,Null);

    List<AIA_Benefit_Design_Product__c> listBDPs = new List<AIA_Benefit_Design_Product__c>();
    
    AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
    aiaBDP1.Benefit_Design__c=aiaBD.id;
    aiaBDP1.Plan_Name__c=aiapln.id;
    aiaBDP1.Proposed_Products__c=PP.id;     
    aiaBDP1.Funding_Arrangement__c = 'Risk';
    aiaBDP1.Custom__c = true;
    aiaBDP1.Product_Category__c = 'Drug';
    listBDPs.add(aiaBDP1);  
    system.assertNOTEquals(aiaBDP1,Null);
    
    AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
    aiaBDP2.Benefit_Design__c=aiaBD.id;
    aiaBDP2.Plan_Name__c=aiapln.id;
    aiaBDP2.Proposed_Products__c=PP.id;     
    aiaBDP2.Funding_Arrangement__c = 'ASO';
    aiaBDP2.Custom__c = true;
    aiaBDP2.Product_Category__c = 'Medical';
    listBDPs.add(aiaBDP2);
    
    insert listBDPs;
    
    AIA_Document__c aiaDoc1 = new AIA_Document__c();
    aiaDoc1.Benefit_Design__c=aiaBD.id;
    aiaDoc1.Account__c=acc.id;
    aiaDoc1.Approval_Status__c = 'Approved';
    aiaDoc1.Start_Date__c = System.today();
    aiaDoc1.End_Date__c = System.today()+10;
    aiaDoc1.Document_Type__c = 'Account Kick-off';
    aiaDoc1.Benefit_Design_Product__c = aiaBDP1.id;
    aiaDoc1.Adj_Summ_Revision__c = 1;
    insert aiaDoc1;
    system.assertNOTEquals(aiaDoc1,Null);
    
    Attachment att=AIA_TestUtil.createAttachment(aiaDoc1.Id);
    system.assertNOTEquals(att,Null);

    PageReference pref = Page.AIA_BDP_DeepClone1;
  Test.setCurrentPage(pref);
  //ApexPages.currentPage().getParameters().put('id',Imp.id);
  ApexPages.StandardController con = new ApexPages.StandardController(Imp1);
  ApexPages.currentPage().getParameters().put('id', Imp1.id);
  ApexPages.currentPage().getParameters().put('planid', aiapln.id);
  AIA_BD_DeepClone ext = new AIA_BD_DeepClone(con);
  ApexPages.currentPage().getParameters().put('palanIdValue','BDD');
  ApexPages.currentPage().getParameters().put('BDPID', aiaBDP1.id);
  ApexPages.currentPage().getParameters().put('BDPName', aiaBDP1.name);
    
  ext.bd.Account__c = acc.id;
  ext.getRelatedAIADocument();
  ext.getSelectedAIADoc();
  ext.ValidateAndCallPCS();
  ext.AIA_DocWrapList = new list<AIA_BD_DeepClone.AIADocumentWrapper>();
  //AIA_BD_DeepClone.BDPWrapper Wrapvar1 = new AIA_BD_DeepClone.BDPWrapper(aiaBDP1,False);
  AIA_BD_DeepClone.AIADocumentWrapper WrapDoc = new AIA_BD_DeepClone.AIADocumentWrapper(aiaDoc1,true);
  
  //ext.lstBDPWrapper.add(Wrapvar1);
  ext.AIA_DocWrapList.add(WrapDoc);
  //ext.ValidateAndCallPCS();
  boolean IsBrfPanel = true;
  ext.next();
    insert ext.newBD;
    system.debug('newBD '+ext.newBD);
    ext.returnToBDP();
  boolean IsPPPanel = true;
  ext.next();
 
}
public static testmethod void Test_AIA_BD_DeepClone_TestCase8(){
    AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
    //Commenting as part of US210
    /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
    wpt.Used_For__c ='Pre-Sales';
    wpt.Workplan_Type__c = 'New';
    wpt.Active__c=true;
    insert wpt;
    system.assertNOTEquals(wpt,Null);*/

    Account acc = AIA_TestUtil.CreateAccount('TestAccount');
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
    insert userList;       
    system.assertNOTEquals(userList.size(),Null);
    
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
    List<Account_Team__c> acctMbrList =new List<Account_Team__c>();//T02
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor')); //T01
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
    
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
system.assertNOTEquals(o,Null);
    
    Benfit_Request_Form__c brfSource = new Benfit_Request_Form__c();
    brfSource.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
    brfSource.Contract_Count__c = 123;
    brfSource.Benefit_Effective_Date__c = system.today();
    brfSource.Account__c = acc.id;
    brfSource.ARC_Approval_Status__c = '';//'Approved by Committee';
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
    brf.ARC_Approval_Status__c = '';//'Approved by Committee';
    brf.Escalated_to_Senior_Management__c = true;
    brf.Status__c = 'new';
    brf.Opportunity__c = o.id;
    brf.Jurisdiction__c = 'MD';
    brf.Enrollment_Type__c = 'Cafeteria';
    brf.Request_Type__c = 'Prospect/New';
    brf.Source_Benefit_Request_Form__c = brfSource.id;
    insert brf;
    system.assertNOTEquals(brf,Null);


    AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
    aiapln.Plan_Name__c='Test Plan';
    aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
    aiapln.Jurisdiction__c = 'MD';
    aiapln.Product_Status__c ='Active';
    aiapln.Has_Benefit_Summary__c = true;
    aiapln.Effective_Date__c = system.today()+3;
    aiapln.Termination_Date__c = system.today()+30;
    insert aiapln;
    //aiapln.BDF_Configuration_Last_Updated__c = datetime.now();
//update aiapln;
system.assertNOTEquals(aiapln,Null);

    AIA_BD_DeepClone_Test.createPlanData(aiapln);

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
    system.assertNOTEquals(pp,Null);
    
    AIA_Grouper__c ag = new AIA_Grouper__c();
    ag.Name = 'CostShareRanges';
    ag.Group_Type__c = 'Cost Share Group';
    ag.Grouper_Record_Type__c = 'BDD';
    ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag.Proposed_Products__c = pp.id;
    insert ag;
   system.assertNOTEquals(ag,Null);
list<AIA_Benefits__c> bnftList = new list<AIA_Benefits__c>();
    AIA_Benefits__c ab = new AIA_Benefits__c();           
    ab.Grouper__c = ag.id;
    ab.Benefit_Name__c = 'Family Out Of Pocket';
    ab.Benefit_Type__c = 'Benefit';
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
    ab.Copay_Min_Payment__c = '20';
    ab.Copay_Max_Payment__c = '30';
    ab.OON_Copay_Min_Payment__c = '10';
    ab.OON_Copay_Max_Payment__c = '10';
    
    ab.Allowed_Amount__c = '5';
    ab.Allowed_Amount_Default__c = '1';
    ab.Copay_Type_1_DefaultAmount__c = '4';
    ab.CoInsurance_AmountValueSelected__c = '4';
    ab.Coinsurance_DefaultAmount__c = '5';
    ab.Copay_Type_1_AmountValueSelected__c = '4';
    ab.Copay_Type_1_DefaultAmount__c = '5';
    ab.Copay_Type_2_AmountValueSelected__c = '4';
    ab.Copay_Type_2_DefaultAmount__c = '5';
    ab.Cost_Share_Default_Amount__c = '5';
    ab.Cost_Share_SelectedAmount__c = '4';
    ab.Discount_Amount__c = '4';
    ab.Discount_Amount_Default__c = '5';
    ab.IN_CostShare_3Month_DeductibleCarryover__c = 'Yes';
    ab.IN_CostShare_3Month_DedCarryover_Default__c = 'No';
    ab.OON_Allowed_Amount_Default__c = '4';
    ab.OON_Allowed_Amount__c = '5';
    ab.OON_Coinsurance_DefaultAmount__c = '4';
    ab.OON_CoInsurance_AmountValueSelected__c = '5';
    ab.OON_Copay_1_Default_DeductibleApplies__c = 'No';
    ab.OON_Copay_Type_1_AmountValueSelected__c = '5';
    ab.OON_Copay_1_Default_DeductibleApplies__c = 'Yes';
    ab.OON_Copay_Type_2_AmountValueSelected__c = 'No';
    ab.OON_Copay_Type_1_DefaultAmount__c = '4';
    ab.OON_Copay_Type_1_Benefit_Comment_Cod__c = '4';
    ab.OON_Copay_Type_1_Default_IsCovered__c = 'No';
    ab.OON_Copay_Type_1_Individual_Mandate__c = true;
    ab.OON_Copay_Type_1_Is_ASO_Only__c = true;
    ab.OON_Copay_Type_1_Jurisdiction__c = '3';
    ab.OON_Copay_Type_1_Mandate_Name__c = '34';
   
    
    //ab.Copay_Type_1_Amount_Customized__c = true;
    //ab.Benefit_Customized__c = true;
    bnftList.add(ab);
    
    AIA_Benefits__c ab1 = new AIA_Benefits__c();           
    ab1.Grouper__c = ag.id;
    ab1.Benefit_Name__c = 'Family Out Of Pocket';
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
    
    ab1.Allowed_Amount__c = '5';
    ab1.Allowed_Amount_Default__c = '1';
    ab1.Copay_Type_1_DefaultAmount__c = '4';
    ab1.CoInsurance_AmountValueSelected__c = '4';
    ab1.Coinsurance_DefaultAmount__c = '5';
    ab1.Copay_Type_1_AmountValueSelected__c = '4';
    ab1.Copay_Type_1_DefaultAmount__c = '5';
    ab1.Copay_Type_2_AmountValueSelected__c = '4';
    ab1.Copay_Type_2_DefaultAmount__c = '5';
    ab1.Cost_Share_Default_Amount__c = '5';
    ab1.Cost_Share_SelectedAmount__c = '4';
    ab1.Discount_Amount__c = '4';
    ab1.Discount_Amount_Default__c = '5';
    ab1.IN_CostShare_3Month_DeductibleCarryover__c = 'Yes';
    ab1.IN_CostShare_3Month_DedCarryover_Default__c = 'No';
    ab1.OON_Allowed_Amount_Default__c = '4';
    ab1.OON_Allowed_Amount__c = '5';
    ab1.OON_Coinsurance_DefaultAmount__c = '4';
    ab1.OON_CoInsurance_AmountValueSelected__c = '5';
    ab1.OON_Copay_1_Default_DeductibleApplies__c = 'No';
    ab1.OON_Copay_Type_1_AmountValueSelected__c = '5';
    ab1.OON_Copay_1_Default_DeductibleApplies__c = 'Yes';
    ab1.OON_Copay_Type_2_AmountValueSelected__c = 'No';
    ab1.OON_Copay_Type_1_DefaultAmount__c = '4';
    ab1.OON_Copay_Type_1_Benefit_Comment_Cod__c = '4';
    ab1.OON_Copay_Type_1_Default_IsCovered__c = 'No';
    ab1.OON_Copay_Type_1_Individual_Mandate__c = true;
    ab1.OON_Copay_Type_1_Is_ASO_Only__c = true;
    ab1.OON_Copay_Type_1_Jurisdiction__c = '3';
    ab1.OON_Copay_Type_1_Mandate_Name__c = '34';
    
    
    //ab1.Copay_Type_1_Amount_Customized__c = false;
    //ab1.Benefit_Customized__c = false;
    bnftList.add(ab1);
    insert bnftList;
    system.assertNOTEquals(bnftList,Null);
    
    test.starttest();
    AIA_ProposedProductsHandler.firstRun = true;
    AIA_ProposedProductsHandler.afterInsert = true;
    AIA_ProposedProductsHandler.afterUpdate = true;
    AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
    AIA_BRFTriggerHandler.adjustmentPreviouslyCalled = True;
    AIA_ProposedProductsHandler.adjustmentPreviouslyCalled = True;
    AIA_BenefitDesignTriggerHandler.Firstrun = True;
    AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
    
    list<AIA_Implementation__c> lstImp = new list<AIA_Implementation__c>();
    AIA_Implementation__c Imp1 = new AIA_Implementation__c();
    Imp1.Name__c = 'testprf';
    Imp1.Opportunity__c = o.Id;
    Imp1.Account__c = acc.Id;
    //Imp1.Generate_Workplan_Stages__c = true;
    Imp1.Effective_Date__c = system.today();
    Imp1.Implementation_Plan_Timeline_Days__c = '60';
    Imp1.Risk_Type__c='ASO';
    Imp1.Benefit_Request_Form__c = brf.id;
    lstImp.add(Imp1);

    AIA_Implementation__c Imp = new AIA_Implementation__c();
    Imp.Name__c = 'testprf';
    Imp.Opportunity__c = o.Id;
    Imp.Account__c = acc.Id;
    //Imp.Generate_Workplan_Stages__c = true;
    Imp.Effective_Date__c = system.today();
    Imp.Implementation_Plan_Timeline_Days__c = '60';
    Imp.Risk_Type__c='ASO';
    Imp.Benefit_Request_Form__c = brfSource.id;
    lstImp.add(Imp);
    if(lstImp != NULL && lstImp.size()>0)
        insert lstImp;
    system.assertNOTEquals(lstImp.size(),Null);
    
    AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
    aiaBD.Implementation__c = Imp.id;
    aiaBD.Account__c = acc.Id;
    aiaBD.Benefit_Request_Form__c = brf.Id;
    insert aiaBD;
    system.assertNOTEquals(aiaBD,Null);

    List<AIA_Benefit_Design_Product__c> listBDPs = new List<AIA_Benefit_Design_Product__c>();
    
    AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
    aiaBDP1.Benefit_Design__c=aiaBD.id;
    aiaBDP1.Plan_Name__c=aiapln.id;
    aiaBDP1.Proposed_Products__c=PP.id;     
    aiaBDP1.Funding_Arrangement__c = 'Risk';
    aiaBDP1.Custom__c = true;
    aiaBDP1.Product_Category__c = 'Drug';
    listBDPs.add(aiaBDP1);  
    system.assertNOTEquals(aiaBDP1,Null);
    
    AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
    aiaBDP2.Benefit_Design__c=aiaBD.id;
    aiaBDP2.Plan_Name__c=aiapln.id;
    aiaBDP2.Proposed_Products__c=PP.id;     
    aiaBDP2.Funding_Arrangement__c = 'ASO';
    aiaBDP2.Custom__c = true;
    aiaBDP2.Product_Category__c = 'Medical';
    listBDPs.add(aiaBDP2);
    
    insert listBDPs;
    
    AIA_Document__c aiaDoc1 = new AIA_Document__c();
    aiaDoc1.Benefit_Design__c=aiaBD.id;
    aiaDoc1.Account__c=acc.id;
    aiaDoc1.Approval_Status__c = 'Approved';
    aiaDoc1.Start_Date__c = System.today();
    aiaDoc1.End_Date__c = System.today()+10;
    aiaDoc1.Document_Type__c = 'Account Kick-off';
    aiaDoc1.Benefit_Design_Product__c = aiaBDP1.id;
    aiaDoc1.Adj_Summ_Revision__c = 1;
    insert aiaDoc1;
    system.assertNOTEquals(aiaDoc1,Null);
        
    List<AIA_Plan_Benefit_Comment_Codes__c> commentCodes = [Select Type__c,FundingArrangement__c from AIA_Plan_Benefit_Comment_Codes__c];
    for (AIA_Plan_Benefit_Comment_Codes__c commentCode : commentCodes)
        {
            commentCode.Type__c='';
            commentCode.FundingArrangement__c='Risk';
        }
    update commentCodes;
        
    Attachment att=AIA_TestUtil.createAttachment(aiaDoc1.Id);
    system.assertNOTEquals(att,Null);

    PageReference pref = Page.AIA_BDP_DeepClone1;
  Test.setCurrentPage(pref);
  //ApexPages.currentPage().getParameters().put('id',Imp.id);
  ApexPages.StandardController con = new ApexPages.StandardController(Imp1);
  ApexPages.currentPage().getParameters().put('id', Imp1.id);
  ApexPages.currentPage().getParameters().put('planid', aiapln.id);
  AIA_BD_DeepClone ext = new AIA_BD_DeepClone(con);
  ApexPages.currentPage().getParameters().put('palanIdValue','BDD');
  ApexPages.currentPage().getParameters().put('BDPID', aiaBDP1.id);
  ApexPages.currentPage().getParameters().put('BDPName', aiaBDP1.name);
  ext.bd.Account__c = acc.id;
    system.debug('newBD '+ext.newBD);
  ext.getRelatedAIADocument();
    system.debug('newBD '+ext.newBD);
  ext.getSelectedAIADoc();
    system.debug('newBD '+ext.newBD);
  ext.ValidateAndCallPCS();
    system.debug('newBD '+ext.newBD);
  ext.AIA_DocWrapList = new list<AIA_BD_DeepClone.AIADocumentWrapper>();
  //AIA_BD_DeepClone.BDPWrapper Wrapvar1 = new AIA_BD_DeepClone.BDPWrapper(aiaBDP1,False);
  AIA_BD_DeepClone.AIADocumentWrapper WrapDoc = new AIA_BD_DeepClone.AIADocumentWrapper(aiaDoc1,true);
  
  //ext.lstBDPWrapper.add(Wrapvar1);
  ext.AIA_DocWrapList.add(WrapDoc);
  system.debug('newBD '+ext.newBD);
  //ext.ValidateAndCallPCS();
  boolean IsBrfPanel = true;
  ext.next();
  boolean IsPPPanel = true;
  ext.next();
 
}
public static testmethod void TestAIA_BD_DeepCloneHelperOutNetwork(){

     API_ENDPOINT_URLS__c cs = new API_ENDPOINT_URLS__c();
    cs.name='PCS_APIDetails';
    cs.ENDPOINT_URL__c = 'https://servicestt.carefirst.com/pcs7devb/PRRestService/PCSSFDCIntegrator/RESTJSON/SendPlanDetails';        
    insert cs;
    AIA_Plan__c plan = AIA_TestUtil.CreatePlan('PLAN - 1111');
    Test.setMock(HttpCalloutMock.class, new AIA_WebServiceMOCKPCSIntegration());      
             
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
    /*//Creating User Test Data T01 starts
        user u17 = AIA_TestUtil.AIA_createUser('aliash17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('aliash18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('aliash17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('aliash18');
        userList.add(u20);
		//T01 ends*/
    insert userList;       
    system.assertNOTEquals(userList.size(),Null);
    
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
    List<Account_Team__c> acctMbrList =new List<Account_Team__c>();//T02
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
    	/*//Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T01 ends*/
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
    brf.Jurisdiction__c = 'DC';
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
    
    
        AIA_Plan_Network__c pn2 = new AIA_Plan_Network__c();
        pn2.ExtID__c = 'PLAN-001N_BDD123';
        pn2.Name = 'OutNetwork';
        pn2.Plan__c = aiapln.id;
        insert pn2;
    	AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
        pg4.Name = 'Medical Supplies/Equipment-0629';
        pg4.Plan_Network__c = pn2.id;
        pg4.Type__c = 'Benefit Group';
        pg4.Sequence_Number__c = 1;
        pg4.Record_Type__c = 'BDD';
        pg4.ExtID__c = 'PLAN-001N_BDD1CSG_BDD00243312';
        insert pg4;
        
        AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
        pb29.Benefit_Name__c = 'Test Benefit';
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
        
        AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
        apc.Plan_Benefits__c = pb29.id;
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
        apc.ExtID__c = 'rwuifghqierufghaire123';
        insert apc;
        
        AIA_Plan_Copay_Type__c apc1 = new AIA_Plan_Copay_Type__c();
        apc1.Plan_Benefits__c = pb29.id;
        apc1.AliasName__c = 'PCP Copay';
        apc1.CopayAmount__c = '200';
        apc1.CoinsuranceAmount__c = '50';
        apc1.MinPayAmount__c = '90';
        apc1.MaxPayAmount__c = '80';
        apc1.IsCovered__c = 'Yes';
        apc1.DeductibleApplies__c = 'No';
        apc1.MandateIndicator__c = 'No';
        apc1.Jurisdiction__c = 'MD';
        apc1.MandateName__c='Home health care ';
        apc1.ExtID__c = 'rwuifghqierufghaire1234';
        insert apc1;
        
        
        AIA_Plan_Limitation__c obj = new AIA_Plan_Limitation__c();
        obj.TierAgeFrom__c = 10;
        obj.TierAgeTo__c = 20;
        obj.TierAgeType__c = 'Years';
        obj.TierLimitDurationType__c = 'Plan Year';
        obj.TierLimitFrom__c = 30;
        obj.TierLimitTo__c = 50;
        obj.TierLimitType__c = 'Days';
        obj.Type__c = 'TierLimit';
        obj.Plan_Benefits__c = pb29.id;
        obj.MandateIndicator__c = True;
        insert obj;
        
        AIA_Plan_Benefit_Comment_Codes__c pbc =new AIA_Plan_Benefit_Comment_Codes__c();
        pbc.Plan_Limitation__c = obj.id;
        pbc.Code__c = 333;
        pbc.Comment__c ='Test';
        pbc.IsRequired__c = 'Yes';
        Insert pbc;
        AIA_BD_DeepClone_Test.createPlanData(aiapln);
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
        
    	list<AIA_Implementation__c> lstimp = new List<AIA_Implementation__c>();
    AIA_Implementation__c Imp1 = new AIA_Implementation__c();
    Imp1.Name__c = 'testprf';
    Imp1.Opportunity__c = o.Id;
    Imp1.Account__c = acc.Id;
    //Imp1.Generate_Workplan_Stages__c = true;
    Imp1.Effective_Date__c = system.today();
    Imp1.Implementation_Plan_Timeline_Days__c = '60';
    Imp1.Risk_Type__c='ASO';
    Imp1.Benefit_Request_Form__c = brf.id;
    lstimp.add(Imp1);
   
    AIA_Implementation__c Imp = new AIA_Implementation__c();
    Imp.Name__c = 'testprf';
    Imp.Opportunity__c = o.Id;
    Imp.Account__c = acc.Id;
    //Imp.Generate_Workplan_Stages__c = true;
    Imp.Effective_Date__c = system.today();
    Imp.Implementation_Plan_Timeline_Days__c = '60';
    Imp.Risk_Type__c='ASO';
    Imp.Benefit_Request_Form__c = brf.id;
    lstimp.add(Imp);
    insert lstimp;
    test.starttest();
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
    aiaBDP1.Product_Category__c ='Drug';
    aiaBDP1.Has_Benefit_Details__c = false;
    insert aiaBDP1;
    
    AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
    aiaBDP2.Benefit_Design__c=aiaBD.id;
    aiaBDP2.Plan_Name__c=aiapln.id;
    aiaBDP2.Proposed_Products__c=PP.id;     
    aiaBDP2.Funding_Arrangement__c = 'Risk';
    aiaBDP2.Product_Category__c ='Drug';
    aiaBDP2.Has_Benefit_Details__c = false;
    insert aiaBDP2;
    
    AIA_Grouper__c ag1 = new AIA_Grouper__c();
    ag1.Name = 'CostShareRanges';
    ag1.Group_Type__c = 'Benefit Group';
    ag1.Benefit_Design_Product__c = aiaBDP1.id;
    ag1.Grouper_Record_Type__c = 'BDD';
    ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag1.Sequence_Number__c = 1;
    ag1.Proposed_Products__c = pp.id;
    insert ag1;

    AIA_Grouper__c ag2 = new AIA_Grouper__c();
    ag2.Name = 'CostShareRanges';
    ag2.Group_Type__c = 'Benefit Group';
    ag2.Benefit_Design_Product__c = aiaBDP1.id;
    ag2.Grouper_Record_Type__c = 'BDD';
    ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag2.Sequence_Number__c = 2;
    ag2.Proposed_Products__c = pp.id;
    insert ag2;

    AIA_Benefits__c ab1 = new AIA_Benefits__c();           
    ab1.Grouper__c = ag1.id;
    ab1.Benefit_Name__c = 'Individual Out Of Pocket';
    ab1.Benefit_Type__c = 'Mandate';
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
    ab1.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire1234';
    update ab1;
        
    AIA_Benefits__c ab2 = new AIA_Benefits__c();           
    ab2.Grouper__c = ag2.id;
    ab2.Benefit_Name__c = 'Individual Out Of Pocket';
    ab2.Benefit_Type__c = 'Mandate';
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
    ab2.CoInsurance_AmountValueSelected__c = 'Yes';
    ab2.OON_Copay_Type_1_IsCovered__c = 'Yes';
    ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
    ab2.Copay_Type_1_AmountValueSelected__c = 'Yes';
    ab2.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire123';
    update ab2;
    
    
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
    ab.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire1234';
    insert ab;  
    
    AIA_Benefits__c ab22 = new AIA_Benefits__c();           
    ab22.Grouper__c = ag1.id;
    ab22.Benefit_Name__c = 'Family Out Of Pocket';
    ab22.Benefit_Type__c = 'Limitation';
    ab22.Type__c = 'Cost Share';           
    ab22.Benefit_Record_Type__c = 'BDD';
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
    ab22.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire123';
    insert ab22;
    system.assertNOTEquals(aiaBDP2,Null);
    
         AIA_BD_DeepCloneHelper helper = new AIA_BD_DeepCloneHelper();
         helper.getCopaysFromPlan(aiapln.id, 'BDD', aiaBDP1, aiaBD);
    
       	 test.stopTest();
    }
    public static testmethod void TestAIA_BD_DeepCloneHelperOutNetwork1(){

     API_ENDPOINT_URLS__c cs = new API_ENDPOINT_URLS__c();
    cs.name='PCS_APIDetails';
    cs.ENDPOINT_URL__c = 'https://servicestt.carefirst.com/pcs7devb/PRRestService/PCSSFDCIntegrator/RESTJSON/SendPlanDetails';        
    insert cs;
    AIA_Plan__c plan = AIA_TestUtil.CreatePlan('PLAN - 1111');
    Test.setMock(HttpCalloutMock.class, new AIA_WebServiceMOCKPCSIntegration());      
             
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
       /* //Creating User Test Data T01 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T01 ends*/
    insert userList;       
    system.assertNOTEquals(userList.size(),Null);
    
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
    List<Account_Team__c> acctMbrList =new List<Account_Team__c>();//T02
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
    /*//Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T01 ends*/
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
    brf.Jurisdiction__c = 'DC';
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
    
    
        AIA_Plan_Network__c pn2 = new AIA_Plan_Network__c();
        pn2.ExtID__c = 'PLAN-001N_BDD123';
        pn2.Name = 'OutNetwork';
        pn2.Plan__c = aiapln.id;
        insert pn2;
    	AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
        pg4.Name = 'Medical Supplies/Equipment-0629';
        pg4.Plan_Network__c = pn2.id;
        pg4.Type__c = 'Benefit Group';
        pg4.Sequence_Number__c = 1;
        pg4.Record_Type__c = 'BDD';
        pg4.ExtID__c = 'PLAN-001N_BDD1CSG_BDD00243312';
        insert pg4;
        
        AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
        pb29.Benefit_Name__c = 'Test Benefit';
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
        
        AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
        apc.Plan_Benefits__c = pb29.id;
        apc.AliasName__c = 'PCP Copay';
        apc.CopayAmount__c = '200';
        apc.CoinsuranceAmount__c = '50';
        apc.MinPayAmount__c = '90';
        apc.MaxPayAmount__c = '80';
        apc.IsCovered__c = 'Yes';
        apc.DeductibleApplies__c = 'No';
        apc.MandateIndicator__c = 'Yes';
        apc.Jurisdiction__c = 'MD';
        apc.MandateName__c='Home health care ';
        apc.ExtID__c = 'rwuifghqierufghaire123';
        insert apc;
        
        AIA_Plan_Copay_Type__c apc1 = new AIA_Plan_Copay_Type__c();
        apc1.Plan_Benefits__c = pb29.id;
        apc1.AliasName__c = 'PCP Copay';
        apc1.CopayAmount__c = '200';
        apc1.CoinsuranceAmount__c = '50';
        apc1.MinPayAmount__c = '90';
        apc1.MaxPayAmount__c = '80';
        apc1.IsCovered__c = 'Yes';
        apc1.DeductibleApplies__c = 'No';
        apc1.MandateIndicator__c = 'Yes';
        apc1.Jurisdiction__c = 'MD';
        apc1.MandateName__c='Home health care ';
        apc1.ExtID__c = 'rwuifghqierufghaire1234';
        insert apc1;
        
        
        AIA_Plan_Limitation__c obj = new AIA_Plan_Limitation__c();
        obj.TierAgeFrom__c = 10;
        obj.TierAgeTo__c = 20;
        obj.TierAgeType__c = 'Years';
        obj.TierLimitDurationType__c = 'Plan Year';
        obj.TierLimitFrom__c = 30;
        obj.TierLimitTo__c = 50;
        obj.TierLimitType__c = 'Days';
        obj.Type__c = 'TierLimit';
        obj.Plan_Benefits__c = pb29.id;
        obj.MandateIndicator__c = True;
        insert obj;
        
        AIA_Plan_Benefit_Comment_Codes__c pbc =new AIA_Plan_Benefit_Comment_Codes__c();
        pbc.Plan_Limitation__c = obj.id;
        pbc.Code__c = 333;
        pbc.Comment__c ='Test';
        pbc.IsRequired__c = 'Yes';
        Insert pbc;
        AIA_BD_DeepClone_Test.createPlanData(aiapln);
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
        
    	list<AIA_Implementation__c> lstimp = new List<AIA_Implementation__c>();
    AIA_Implementation__c Imp1 = new AIA_Implementation__c();
    Imp1.Name__c = 'testprf';
    Imp1.Opportunity__c = o.Id;
    Imp1.Account__c = acc.Id;
    //Imp1.Generate_Workplan_Stages__c = true;
    Imp1.Effective_Date__c = system.today();
    Imp1.Implementation_Plan_Timeline_Days__c = '60';
    Imp1.Risk_Type__c='ASO';
    Imp1.Benefit_Request_Form__c = brf.id;
    lstimp.add(Imp1);
   
    AIA_Implementation__c Imp = new AIA_Implementation__c();
    Imp.Name__c = 'testprf';
    Imp.Opportunity__c = o.Id;
    Imp.Account__c = acc.Id;
    //Imp.Generate_Workplan_Stages__c = true;
    Imp.Effective_Date__c = system.today();
    Imp.Implementation_Plan_Timeline_Days__c = '60';
    Imp.Risk_Type__c='ASO';
    Imp.Benefit_Request_Form__c = brf.id;
    lstimp.add(Imp);
    insert lstimp;
    test.starttest();
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
    aiaBDP1.Product_Category__c ='Drug';
    aiaBDP1.Has_Benefit_Details__c = false;
    aiaBDP1.jurisdiction__c = 'MD';
    insert aiaBDP1;
    
    AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
    aiaBDP2.Benefit_Design__c=aiaBD.id;
    aiaBDP2.Plan_Name__c=aiapln.id;
    aiaBDP2.Proposed_Products__c=PP.id;     
    aiaBDP2.Funding_Arrangement__c = 'Risk';
    aiaBDP2.Product_Category__c ='Drug';
    aiaBDP2.Has_Benefit_Details__c = false;
        aiaBDP2.jurisdiction__c = 'MD';
    insert aiaBDP2;
    
    AIA_Grouper__c ag1 = new AIA_Grouper__c();
    ag1.Name = 'CostShareRanges';
    ag1.Group_Type__c = 'Benefit Group';
    ag1.Benefit_Design_Product__c = aiaBDP1.id;
    ag1.Grouper_Record_Type__c = 'BDD';
    ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag1.Sequence_Number__c = 1;
    ag1.Proposed_Products__c = pp.id;
    insert ag1;

    AIA_Grouper__c ag2 = new AIA_Grouper__c();
    ag2.Name = 'CostShareRanges';
    ag2.Group_Type__c = 'Benefit Group';
    ag2.Benefit_Design_Product__c = aiaBDP1.id;
    ag2.Grouper_Record_Type__c = 'BDD';
    ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag2.Sequence_Number__c = 2;
    ag2.Proposed_Products__c = pp.id;
    insert ag2;

    AIA_Benefits__c ab1 = new AIA_Benefits__c();           
    ab1.Grouper__c = ag1.id;
    ab1.Benefit_Name__c = 'Individual Out Of Pocket';
    ab1.Benefit_Type__c = 'Mandate';
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
    ab1.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire1234';
    update ab1;
        
    AIA_Benefits__c ab2 = new AIA_Benefits__c();           
    ab2.Grouper__c = ag2.id;
    ab2.Benefit_Name__c = 'Individual Out Of Pocket';
    ab2.Benefit_Type__c = 'Mandate';
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
    ab2.CoInsurance_AmountValueSelected__c = 'Yes';
    ab2.OON_Copay_Type_1_IsCovered__c = 'Yes';
    ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
    ab2.Copay_Type_1_AmountValueSelected__c = 'Yes';
    ab2.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire123';
    update ab2;
    
    
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
    ab.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire1234';
    insert ab;  
    
    AIA_Benefits__c ab22 = new AIA_Benefits__c();           
    ab22.Grouper__c = ag1.id;
    ab22.Benefit_Name__c = 'Family Out Of Pocket';
    ab22.Benefit_Type__c = 'Limitation';
    ab22.Type__c = 'Cost Share';           
    ab22.Benefit_Record_Type__c = 'BDD';
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
    ab22.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire123';
    insert ab22;
    system.assertNOTEquals(aiaBDP2,Null);
    
         AIA_BD_DeepCloneHelper helper = new AIA_BD_DeepCloneHelper();
         helper.getCopaysFromPlan(aiapln.id, 'BDD', aiaBDP1, aiaBD);
    
       	 test.stopTest();
    }
    
    public static testmethod void TestAIA_BD_DeepCloneHelperOutNetwork2(){

     API_ENDPOINT_URLS__c cs = new API_ENDPOINT_URLS__c();
    cs.name='PCS_APIDetails';
    cs.ENDPOINT_URL__c = 'https://servicestt.carefirst.com/pcs7devb/PRRestService/PCSSFDCIntegrator/RESTJSON/SendPlanDetails';        
    insert cs;
    AIA_Plan__c plan = AIA_TestUtil.CreatePlan('PLAN - 1111');
    Test.setMock(HttpCalloutMock.class, new AIA_WebServiceMOCKPCSIntegration());      
             
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
        /*//Creating User Test Data T01 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);*/
		//T01 ends
    insert userList;       
    system.assertNOTEquals(userList.size(),Null);
    
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
    List<Account_Team__c> acctMbrList =new List<Account_Team__c>();//T02
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
    /*//Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T01 ends*/
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
    brf.Jurisdiction__c = 'DC';
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
    
    
        AIA_Plan_Network__c pn2 = new AIA_Plan_Network__c();
        pn2.ExtID__c = 'PLAN-001N_BDD123';
        pn2.Name = 'OutNetwork';
        pn2.Plan__c = aiapln.id;
        insert pn2;
    	AIA_Plan_Grouper__c pg4 = new AIA_Plan_Grouper__c();
        pg4.Name = 'Medical Supplies/Equipment-0629';
        pg4.Plan_Network__c = pn2.id;
        pg4.Type__c = 'Benefit Group';
        pg4.Sequence_Number__c = 1;
        pg4.Record_Type__c = 'BDD';
        pg4.ExtID__c = 'PLAN-001N_BDD1CSG_BDD00243312';
        insert pg4;
        
        AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
        pb29.Benefit_Name__c = 'Test Benefit';
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
        pb29.IS_ASO_Only__c='No';
        insert pb29;
        
        Set<Id> benefitsId = new Set<Id>{pb29.Id};
        
        AIA_Plan_Copay_Type__c apc = new AIA_Plan_Copay_Type__c();
        apc.Plan_Benefits__c = pb29.id;
        apc.AliasName__c = 'PCP Copay';
        apc.CopayAmount__c = '200';
        apc.CoinsuranceAmount__c = '50';
        apc.MinPayAmount__c = '90';
        apc.MaxPayAmount__c = '80';
        apc.IsCovered__c = 'Yes';
        apc.DeductibleApplies__c = 'No';
        apc.MandateIndicator__c = 'Yes';
        apc.Jurisdiction__c = 'MD';
        apc.MandateName__c='Home health care ';
        apc.ExtID__c = 'rwuifghqierufghaire123';
        insert apc;
        
        AIA_Plan_Copay_Type__c apc1 = new AIA_Plan_Copay_Type__c();
        apc1.Plan_Benefits__c = pb29.id;
        apc1.AliasName__c = 'PCP Copay';
        apc1.CopayAmount__c = '200';
        apc1.CoinsuranceAmount__c = '50';
        apc1.MinPayAmount__c = '90';
        apc1.MaxPayAmount__c = '80';
        apc1.IsCovered__c = 'Yes';
        apc1.DeductibleApplies__c = 'No';
        apc1.MandateIndicator__c = 'Yes';
        apc1.Jurisdiction__c = 'MD';
        apc1.MandateName__c='Home health care ';
        apc1.ExtID__c = 'rwuifghqierufghaire1234';
        insert apc1;
        
        
        AIA_Plan_Limitation__c obj = new AIA_Plan_Limitation__c();
        obj.TierAgeFrom__c = 10;
        obj.TierAgeTo__c = 20;
        obj.TierAgeType__c = 'Years';
        obj.TierLimitDurationType__c = 'Plan Year';
        obj.TierLimitFrom__c = 30;
        obj.TierLimitTo__c = 50;
        obj.TierLimitType__c = 'Days';
        obj.Type__c = 'TierLimit';
        obj.Plan_Benefits__c = pb29.id;
        obj.MandateIndicator__c = false;
        insert obj;
        
        AIA_Plan_Benefit_Comment_Codes__c pbc =new AIA_Plan_Benefit_Comment_Codes__c();
        pbc.Plan_Limitation__c = obj.id;
        pbc.Code__c = 333;
        pbc.Comment__c ='Test';
        pbc.IsRequired__c = 'Yes';
        Insert pbc;
        AIA_BD_DeepClone_Test.createPlanData(aiapln);
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
        
    	list<AIA_Implementation__c> lstimp = new List<AIA_Implementation__c>();
    AIA_Implementation__c Imp1 = new AIA_Implementation__c();
    Imp1.Name__c = 'testprf';
    Imp1.Opportunity__c = o.Id;
    Imp1.Account__c = acc.Id;
    //Imp1.Generate_Workplan_Stages__c = true;
    Imp1.Effective_Date__c = system.today();
    Imp1.Implementation_Plan_Timeline_Days__c = '60';
    Imp1.Risk_Type__c='ASO';
    Imp1.Benefit_Request_Form__c = brf.id;
    lstimp.add(Imp1);
   
    AIA_Implementation__c Imp = new AIA_Implementation__c();
    Imp.Name__c = 'testprf';
    Imp.Opportunity__c = o.Id;
    Imp.Account__c = acc.Id;
    //Imp.Generate_Workplan_Stages__c = true;
    Imp.Effective_Date__c = system.today();
    Imp.Implementation_Plan_Timeline_Days__c = '60';
    Imp.Risk_Type__c='ASO';
    Imp.Benefit_Request_Form__c = brf.id;
    lstimp.add(Imp);
    insert lstimp;
    test.starttest();
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
    aiaBDP1.Product_Category__c ='Drug';
    aiaBDP1.Has_Benefit_Details__c = false;
    aiaBDP1.jurisdiction__c = 'MD';
    insert aiaBDP1;
    
    AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
    aiaBDP2.Benefit_Design__c=aiaBD.id;
    aiaBDP2.Plan_Name__c=aiapln.id;
    aiaBDP2.Proposed_Products__c=PP.id;     
    aiaBDP2.Funding_Arrangement__c = 'Risk';
    aiaBDP2.Product_Category__c ='Drug';
    aiaBDP2.Has_Benefit_Details__c = false;
        aiaBDP2.jurisdiction__c = 'MD';
    insert aiaBDP2;
    
    AIA_Grouper__c ag1 = new AIA_Grouper__c();
    ag1.Name = 'CostShareRanges';
    ag1.Group_Type__c = 'Benefit Group';
    ag1.Benefit_Design_Product__c = aiaBDP1.id;
    ag1.Grouper_Record_Type__c = 'BDD';
    ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag1.Sequence_Number__c = 1;
    ag1.Proposed_Products__c = pp.id;
    insert ag1;

    AIA_Grouper__c ag2 = new AIA_Grouper__c();
    ag2.Name = 'CostShareRanges';
    ag2.Group_Type__c = 'Benefit Group';
    ag2.Benefit_Design_Product__c = aiaBDP1.id;
    ag2.Grouper_Record_Type__c = 'BDD';
    ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag2.Sequence_Number__c = 2;
    ag2.Proposed_Products__c = pp.id;
    insert ag2;

    AIA_Benefits__c ab1 = new AIA_Benefits__c();           
    ab1.Grouper__c = ag1.id;
    ab1.Benefit_Name__c = 'Individual Out Of Pocket';
    ab1.Benefit_Type__c = 'Mandate';
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
    ab1.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire1234';
    update ab1;
        
    AIA_Benefits__c ab2 = new AIA_Benefits__c();           
    ab2.Grouper__c = ag2.id;
    ab2.Benefit_Name__c = 'Individual Out Of Pocket';
    ab2.Benefit_Type__c = 'Mandate';
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
    ab2.CoInsurance_AmountValueSelected__c = 'Yes';
    ab2.OON_Copay_Type_1_IsCovered__c = 'Yes';
    ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
    ab2.Copay_Type_1_AmountValueSelected__c = 'Yes';
    ab2.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire123';
    update ab2;
    
    
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
    ab.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire1234';
    insert ab;  
    
    AIA_Benefits__c ab22 = new AIA_Benefits__c();           
    ab22.Grouper__c = ag1.id;
    ab22.Benefit_Name__c = 'Family Out Of Pocket';
    ab22.Benefit_Type__c = 'Limitation';
    ab22.Type__c = 'Cost Share';           
    ab22.Benefit_Record_Type__c = 'BDD';
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
    ab22.OutNetwork_ExtID_Copay1__c = 'rwuifghqierufghaire123';
    insert ab22;
    system.assertNOTEquals(aiaBDP2,Null);
    
        String BDPID = aiaBDP1.id;
        String qry = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('AIA_Benefit_Design_Product__c', 'Id=:BDPID limit 1000','Benefit_Design__r.Jurisdiction__c,');
        //benefitsId
        List<AIA_Benefit_Design_Product__c> bdpLst = database.query(qry);
        AIA_BD_DeepCloneHelper helper = new AIA_BD_DeepCloneHelper();
        helper.getPlanLimitation(benefitsId,bdpLst[0]);
    
       	 test.stopTest();
    }
}