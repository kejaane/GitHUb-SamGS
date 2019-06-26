/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================

*06/08/2018    raj kiran      T01       Added code for role updates
*02/07/2019		Chaithra	  T02 		Replacing standard AccountTeam object with Custom obj as part of US1736
*==================================================================================

*******************************************************************************************************/
@istest//(seealldata=true)
public with sharing class AIA_BD_DeepClone_Test {
    public static testmethod void Test_AIA_BD_DeepClone_TestCase1(){
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
    
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
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
    aiapln.Product_Status__c = 'Active';
    aiapln.Plan_Id__c='PLAN-Test';
    aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
    aiapln.Jurisdiction__c = 'MD';
    aiapln.Has_Benefit_Summary__c=true;
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
    ab.Copay_Default_Min_Payment__c = '25';
    ab.Copay_Max_Payment__c = '30';
    ab.Copay_Default_Max_Payment__c = '20';
    ab.OON_Copay_Min_Payment__c = '10';
    ab.OON_Copay_Default_Min_Payment__c = '20';
    ab.OON_Copay_Max_Payment__c = '10';
    ab.OON_Copay_Default_Max_Payment__c = '20';
    
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

    insert ab;
    system.assertNOTEquals(ab,Null);
    
    test.starttest();
    AIA_ProposedProductsHandler.firstRun = true;
    AIA_ProposedProductsHandler.afterInsert = true;
    AIA_ProposedProductsHandler.afterUpdate = true;
    AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
    AIA_BRFTriggerHandler.adjustmentPreviouslyCalled = True;
    AIA_ProposedProductsHandler.adjustmentPreviouslyCalled = True;
    AIA_BenefitDesignTriggerHandler.Firstrun = True;
    AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
    
    List<AIA_Plan_Benefits__c> plben= [select id,name from AIA_Plan_Benefits__c where Plan__c = :String.valueof(aiapln.Id).substring(0,15)] ;
    system.debug('plben size===='+plben.size());
    
    
    AIA_Implementation__c Imp1 = new AIA_Implementation__c();
    Imp1.Name__c = 'testprf';
    Imp1.Opportunity__c = o.Id;
    Imp1.Account__c = acc.Id;
    //Imp1.Generate_Workplan_Stages__c = true;
    Imp1.Effective_Date__c = system.today();
    Imp1.Implementation_Plan_Timeline_Days__c = '60';
    Imp1.Risk_Type__c='ASO';
    Imp1.Benefit_Request_Form__c = brf.id;
    insert Imp1;
    system.assertNOTEquals(Imp1,Null);

    AIA_Implementation__c Imp = new AIA_Implementation__c();
    Imp.Name__c = 'testprf';
    Imp.Opportunity__c = o.Id;
    Imp.Account__c = acc.Id;
    //Imp.Generate_Workplan_Stages__c = true;
    Imp.Effective_Date__c = system.today();
    Imp.Implementation_Plan_Timeline_Days__c = '60';
    Imp.Risk_Type__c='ASO';
    Imp.Benefit_Request_Form__c = brfSource.id;
    insert Imp;
    system.assertNOTEquals(Imp,Null);
    
    AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
    aiaBD.Implementation__c = Imp.id;
    aiaBD.Account__c = acc.Id;
    aiaBD.Benefit_Request_Form__c = brfSource.Id;
    insert aiaBD;
    system.assertNOTEquals(aiaBD,Null);
    
    
    
    AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
    aiaBDP1.Benefit_Design__c=aiaBD.id;
    aiaBDP1.Plan_Name__c=aiapln.id;
    aiaBDP1.Proposed_Products__c=PP.id;     
    aiaBDP1.Funding_Arrangement__c = 'Risk';
    insert aiaBDP1;       
    system.assertNOTEquals(aiaBDP1,Null);
    
    AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
    aiaBDP2.Benefit_Design__c = aiaBD.id;
    aiaBDP2.Related_Medical_Product__c = aiaBDP1.id;   
    aiaBDP1.Plan_Name__c=aiapln.id;     
    aiaBDP1.Funding_Arrangement__c = 'ASO';
    insert aiaBDP2; 
    system.assertNOTEquals(aiaBDP2,Null);
    
    AIA_Benefit_Design_Form__c aiaBDF = new AIA_Benefit_Design_Form__c();       
    aiaBDF.Benefit_Design__c = aiaBD.id;        
    aiaBDF.Michelle_s_Law_4a__c = 'Yes';        
    aiaBDF.Child_Dependents_Limit_Age_4a__c =26;        
    aiaBDF.Michelle_s_Law_Waiver_4a__c = 'Yes';     
    aiaBDF.Students_Limit_Age_4a__c = 26;       
    aiaBDF.Child_Dependents_Removal_Method_4a__c = 'End of Calendar Month';     
    aiaBDF.Students_Removal_Method_4a__c = 'End of Calendar Month';     
    aiaBDF.Part_time_Students_with_Disabilities_4a__c ='No';      
    aiaBDF.Number_Of_Eligibles__c='10';
    //aiaBDF.External_Review_Processing_Comments__c = 'Hello';
    insert aiaBDF;              
    system.assertNOTEquals(aiaBDF,Null);        
    //System.debug('7.Number of Queries used in this apex code so far: ' + Limits.getQueries()); 
    system.debug('Testclass: '+aiaBDF);
   
    AIA_Document__c aiaDoc1 = new AIA_Document__c();
    aiaDoc1.Benefit_Design__c=aiaBD.id;
    aiaDoc1.Account__c=acc.id;
    aiaDoc1.Approval_Status__c = 'Approved';
    aiaDoc1.Start_Date__c = System.today();
    aiaDoc1.End_Date__c = System.today()+10;
    aiaDoc1.Adj_Summ_Revision__c = 1;
    insert aiaDoc1;
    system.assertNOTEquals(aiaDoc1,Null);
    
    Attachment att=AIA_TestUtil.createAttachment(aiaDoc1.Id);
    system.assertNOTEquals(att,Null);

    PageReference pref = Page.AIA_BDP_DeepClone1;
    Test.setCurrentPage(pref);
    ApexPages.currentPage().getParameters().put('id', Imp.id);
    ApexPages.StandardController con = new ApexPages.StandardController(Imp1);
    
    ApexPages.currentPage().getParameters().put('id', Imp1.id);
    ApexPages.currentPage().getParameters().put('planid', aiapln.id);
    AIA_BD_DeepClone ext = new AIA_BD_DeepClone(con);
    ext.getRelatedAIADocument();
    ext.getSelectedAIADoc();
    aiaBDP1 = [select id,name,Benefit_Design__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c from AIA_Benefit_Design_Product__c where id =:aiaBDP2.id];     
    ApexPages.currentPage().getParameters().put('palanIdValue', 'BDD');
    ApexPages.currentPage().getParameters().put('BDPID', aiaBDP1.id);
    ApexPages.currentPage().getParameters().put('BDPName', aiaBDP1.name);
    ext.ValidateAndCallPCS();
    
    AIA_BD_DeepClone.BDPWrapper Wrapvar = new AIA_BD_DeepClone.BDPWrapper(aiaBDP1,true);
    AIA_BD_DeepClone.AIADocumentWrapper WrapDoc = new AIA_BD_DeepClone.AIADocumentWrapper(aiaDoc1,true);
    ext.lstBDPWrapper.add(Wrapvar);
    ext.AIA_DocWrapList.add(WrapDoc);
    //ext.selBDPList.add(aiaBDP1);
    //ext.ValidateAndCallPCS();
    //ext.next();
    //ext.back();
    ext.getBDForClone(Imp1.id);
    ext.IsBrfPanel = true;
    ext.bd.Account__c = acc.id;
   
    ext.bd.source_BD__c = aiaBD.id;
    ext.IsBrfPanel = false;
    ext.IsSummaryPanel = false;
    ext.IsPPPanel = true;
    ext.next();
    ext.IsSummaryPanel = true;
    ext.back();
    ext.cancelButton();
    ext.deleteBDP();
    
    test.stopTest(); 
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

  
    List<AIA_Plan_Benefits__c> AIAPBLst = new List<AIA_Plan_Benefits__c>();
   
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
    AIAPBLst.add(pb);

    AIA_Plan_Benefits__c pb29 = new AIA_Plan_Benefits__c();
    pb29.Benefit_Name__c = 'OutOfPocket_Individual';
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
    AIAPBLst.add(pb29);

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
    AIAPBLst.add(pb2);

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
    AIAPBLst.add(pb3);

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
    AIAPBLst.add(pb4);

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
    AIAPBLst.add(pb5);

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
    AIAPBLst.add(pb6);

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
    AIAPBLst.add(pb7);

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
    AIAPBLst.add(pb8);

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
    AIAPBLst.add(pb9);

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
    AIAPBLst.add(pb10);

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
    AIAPBLst.add(pb11);

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
    AIAPBLst.add(pb13);

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
    AIAPBLst.add(pb14);

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
    AIAPBLst.add(pb15);

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
    AIAPBLst.add(pb16);

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
    AIAPBLst.add(pb17);

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
    AIAPBLst.add(pb18);

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
    AIAPBLst.add(pb19);

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
    AIAPBLst.add(pb20);

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
    AIAPBLst.add(pb21);

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
    AIAPBLst.add(pb22);

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
    pbc.Type__c = 'Mandate';
    pbc.FundingArrangement__c = 'Risk';
    //  pbc.Plan_Copay_Type__c ='';
    Insert pbc;

    AIA_Plan_Benefit_Comment_Codes__c pbc2 =new AIA_Plan_Benefit_Comment_Codes__c();

    pbc2.Plan_Limitation__c = obj.id;
    pbc2.Code__c = 333;
    pbc2.Comment__c ='Test';
    //  pbc2.Jurisdiction__c ='MD';
    pbc2.IsRequired__c = 'Yes' ;
    pbc2.Plan_Copay_Type__c =apc.id;
    Insert pbc2;

    }
    
public static testmethod void Test_AIA_BD_DeepClone_TestCase2(){
   AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
    //Commenting as part of US210
    /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
    wpt.Used_For__c ='Pre-Sales';
    wpt.Workplan_Type__c = 'New';
    wpt.Active__c=true;
    insert wpt;
  system.assertNOTEquals(wpt,Null);*/

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
    insert userList;       
    system.assertNOTEquals(userList.size(),Null);
    
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();T02
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
    insert aiapln;
   
  system.assertNOTEquals(aiapln,Null);
    //createPlanData(aiapln);
    
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
    Imp.Benefit_Request_Form__c = brfSource.id;
    lstimp.add(Imp);
    
    if(lstimp != null && lstimp.size()>0)
      insert lstimp;
    system.assertNOTEquals(lstimp.size(),Null);
    test.starttest();
    AIA_ProposedProductsHandler.firstRun = true;
    AIA_ProposedProductsHandler.afterInsert = true;
    AIA_ProposedProductsHandler.afterUpdate = true;
    AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
    AIA_BRFTriggerHandler.adjustmentPreviouslyCalled = True;
    AIA_ProposedProductsHandler.adjustmentPreviouslyCalled = True;
    AIA_BenefitDesignTriggerHandler.Firstrun = True;
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
    aiaBDP1.Product_Category__c ='Medical';
    aiaBDP1.Has_Benefit_Details__c = false;
    insert aiaBDP1;  
    system.assertNOTEquals(aiaBDP1,Null);
    aiaBDP1 = [select id,name,Benefit_Design__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c from AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     

    
    AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
    aiaBDP2.Benefit_Design__c=aiaBD.id;
    aiaBDP2.Plan_Name__c=aiapln.id;
    aiaBDP2.Proposed_Products__c=PP.id;     
    aiaBDP2.Funding_Arrangement__c = 'ASO';
    aiaBDP2.Product_Category__c ='Drug';
    aiaBDP2.Has_Benefit_Details__c = false;
    insert aiaBDP2;  
    system.assertNOTEquals(aiaBDP2,Null);
    aiaBDP2 = [select id,name,Benefit_Design__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c from AIA_Benefit_Design_Product__c where id =:aiaBDP2.id];     
    system.assertNOTEquals(aiaBDP2,Null);
    
    AIA_Benefit_Design_Product__c aiaBDP3 = new AIA_Benefit_Design_Product__c();
    aiaBDP3.Benefit_Design__c = aiaBD.id;
    aiaBDP3.Related_Medical_Product__c = aiaBDP1.id;   
    aiaBDP3.Plan_Name__c=aiapln.id;   
    aiaBDP3.Proposed_Products__c=PP.id;    
    aiaBDP3.Funding_Arrangement__c = 'ASO';
    aiaBDP3.Product_Category__c ='Medical';
    aiaBDP3.Cloned_From__c = aiaBDP1.id;
    aiaBDP3.Has_Benefit_Details__c = false;
    insert aiaBDP3;
    
    aiaBDP3 = [select id,name,Benefit_Design__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c from AIA_Benefit_Design_Product__c where id =:aiaBDP3.id];     
    system.assertNOTEquals(aiaBDP3,Null);
    
    list<AIA_Grouper__c> aiaGrouper = new list<AIA_Grouper__c>();
    AIA_Grouper__c ag1 = new AIA_Grouper__c();
    ag1.Name = 'CostShareRanges';
    ag1.Group_Type__c = 'Benefit Group';
    ag1.Benefit_Design_Product__c = aiaBDP3.id;
    ag1.Grouper_Record_Type__c = 'BDD';
    ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag1.Sequence_Number__c = 1;
    ag1.Proposed_Products__c = pp.id;
    aiaGrouper.add(ag1);
    //insert aiaGrouper;

    AIA_Grouper__c ag2 = new AIA_Grouper__c();
    ag2.Name = 'CostShareRanges';
    ag2.Group_Type__c = 'Cost Share Group';
    ag2.Benefit_Design_Product__c = aiaBDP2.id;
    ag2.Grouper_Record_Type__c = 'BDD';
    ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag2.Sequence_Number__c = 2;
    ag2.Proposed_Products__c = pp.id;
    aiaGrouper.add(ag2);
    //insert ag2;
    insert aiaGrouper;
    system.assertNOTEquals(aiaGrouper.size(),Null);

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
  
    
    insert ab1;  
    /*ab1.CoInsurance_AmountValueSelected__c = 'Yes';
    ab1.OON_Copay_Type_1_IsCovered__c = 'Yes';
    ab1.Copay_Type_1_DeductibleApplies__c = 'Yes';
    ab1.Copay_Type_1_AmountValueSelected__c = 'Yes';
    update ab1;*/
    
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
    ab2.Allowed_Amount__c = '5';
    ab2.Allowed_Amount_Default__c = '1';
    ab2.Copay_Type_1_DefaultAmount__c = '4';
    ab2.CoInsurance_AmountValueSelected__c = '4';
    ab2.Coinsurance_DefaultAmount__c = '5';
    ab2.Copay_Type_1_AmountValueSelected__c = '4';
    ab2.Copay_Type_1_DefaultAmount__c = '5';
    ab2.Copay_Type_2_AmountValueSelected__c = '4';
    ab2.Copay_Type_2_DefaultAmount__c = '5';
    ab2.Cost_Share_Default_Amount__c = '5';
    ab2.Cost_Share_SelectedAmount__c = '4';
    ab2.Discount_Amount__c = '4';
    ab2.Discount_Amount_Default__c = '5';
    ab2.IN_CostShare_3Month_DeductibleCarryover__c = 'Yes';
    ab2.IN_CostShare_3Month_DedCarryover_Default__c = 'No';
    ab2.OON_Allowed_Amount_Default__c = '4';
    ab2.OON_Allowed_Amount__c = '5';
    ab2.OON_Coinsurance_DefaultAmount__c = '4';
    ab2.OON_CoInsurance_AmountValueSelected__c = '5';
    ab2.OON_Copay_1_Default_DeductibleApplies__c = 'No';
    ab2.OON_Copay_Type_1_AmountValueSelected__c = '5';
    ab2.OON_Copay_1_Default_DeductibleApplies__c = 'Yes';
    ab2.OON_Copay_Type_2_AmountValueSelected__c = 'No';
    ab2.OON_Copay_Type_1_DefaultAmount__c = '4';
    ab2.OON_Copay_Type_1_Benefit_Comment_Cod__c = '4';
    ab2.OON_Copay_Type_1_Default_IsCovered__c = 'No';
    ab2.OON_Copay_Type_1_Individual_Mandate__c = true;
    ab2.OON_Copay_Type_1_Is_ASO_Only__c = true;
    ab2.OON_Copay_Type_1_Jurisdiction__c = '3';
    ab2.OON_Copay_Type_1_Mandate_Name__c = '34';
   
    insert ab2;  
    ab2.CoInsurance_AmountValueSelected__c = 'Yes';
    ab2.OON_Copay_Type_1_IsCovered__c = 'Yes';
    ab2.Copay_Type_1_DeductibleApplies__c = 'Yes';
    ab2.Copay_Type_1_AmountValueSelected__c = 'Yes';
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
    
    AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
    apbt.Benefit_Name__c ='wdwd';
    apbt.Benefit_Group__c = apg.id;
    apbt.Record_Type__c = 'BDD';
    apbt.Sequence_Number__c = 1;
    apbt.Coinsurance_DefaultAmount__c = '2323';   
    apbt.ISExisting_Benefit__c = True;
    apbt.Type__c='Benefit';
    apbt.IS_ASO_Only__c ='No';
    insert apbt;
    list<AIA_Plan_Benefits__c> listben = new list<AIA_Plan_Benefits__c>();
    AIA_Plan_Benefits__c apbt1 = new AIA_Plan_Benefits__c();   
    apbt1.Benefit_Name__c ='wdwd1';
    apbt1.Benefit_Group__c = apg.id;
    apbt1.Record_Type__c = 'BDD';
    apbt1.Sequence_Number__c = 2;
    apbt1.Coinsurance_DefaultAmount__c = '2323';   
    apbt1.ISExisting_Benefit__c = false;
    apbt1.Type__c='Cost Share';
    apbt1.IS_ASO_Only__c ='Yes';
    listben.add(apbt1);
        
    insert listben;

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

    
    AIA_Config__c cus = new AIA_Config__c();
    cus.Run__c = true;
    cus.Name ='BDTHelper.createBenefitDesignProduct';
    
    insert cus;
    
    
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
	
    
    //AIA_BD_DeepClone clone = new AIA_BD_DeepClone();
    
    Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
    lmt.Benefit__c = ab.id;
    insert lmt;
    Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
    lmt.Benefit__c = ab.id;
    insert lmt2;

    Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
    lmt.Benefit__c = ab.id;
    insert lmt3;
  
 
   ApexPages.currentPage().getParameters().put('id', Imp1.id);
  PageReference pref = Page.AIA_BDP_DeepClone1;
  Test.setCurrentPage(pref);
  ApexPages.currentPage().getParameters().put('id',Imp1.id);
  ApexPages.StandardController con = new ApexPages.StandardController(Imp1);
  //ApexPages.currentPage().getParameters().put('id', Imp1.id);
  ApexPages.currentPage().getParameters().put('planid', aiapln.id);
  AIA_BD_DeepClone ext = new AIA_BD_DeepClone(con);
  ApexPages.currentPage().getParameters().put('palanIdValue','BDD');
  ApexPages.currentPage().getParameters().put('BDPID', aiaBDP3.id);
  ApexPages.currentPage().getParameters().put('BDPName', aiaBDP3.name);
  ext.bd.Account__c = acc.id;
  ext.getRelatedAIADocument();
  ext.getSelectedAIADoc();
    
    List<AIA_Plan_Copay_Type__c> copTypeList= new  List<AIA_Plan_Copay_Type__c>();
    
    copTypeList = [Select id,Name,AliasName__c, Plan_Benefits__r.Record_Type__c,Allowed_Amount__c,AnnualMaximumApplies__c,Benefit_Sequence_Number__c,CoinsuranceAmount__c,Copay_Additional_Increments__c,
                CopayAmount__c,Copay_High__c,Copay_Increment__c,Copay_Low__c,Copay_Sequence_Number__c,DeductibleApplies__c,Discount_Amount__c,Discount_Amount_Percent__c,
                DiscountApplies__c,Discount_Applies__c,Effective_Date__c,ExtID__c,Grouper_Name__c,IsASOOnly__c,IsCovered__c,Jurisdiction__c,Jurisdiction_for_BRF__c,
                MandateIndicator__c,MandateName__c,MaxPayAmount__c,MinPayAmount__c,Plan_Benefits__c,PlanID__c,Approximate_Member_Payment_w_Discount__c,Term_Date__c,TierType__c,
                Plan_Benefits__r.benefit_name__C,Plan_Benefits__r.Parent_Benefit_Name__c,Copay_Additional_InvalidIncrements__c,Plan_Benefits__r.IS_ASO_Only__c,
                Plan_Benefits__r.IsAppGlobalCopay__c,Plan_Benefits__r.IsAppGlobalCoinsurance__c,Plan_Benefits__r.Davis_Benefit_Variable__c,
                Plan_Benefits__r.Coinsurance_AmountLow__c, Plan_Benefits__r.Coinsurance_AmountHigh__c,Plan_Benefits__r.Coinsurance_AmountIncrement__c,
                Plan_Benefits__r.Coinsurance_Amount_AddtionalIncrements__c, Plan_Benefits__r.Coinsurance_Amount_InvalidIncrements__c,Plan_Benefits__r.MandateLockDownInd__c,Plan_Benefits__r.MappingBRFBenefitID__c
                from AIA_Plan_Copay_Type__c Where Plan_Benefits__c =:listben
                  and (jurisdiction__c = 'Federal' OR jurisdiction__c = 'FD')
                  order by   Plan_Benefits__r.benefit_name__C limit 1];
    
    ext.ClonebenifitFromCopay(ab1.Benefit_Name__c,aiaBDP3,aiaGrouper,5,5);
  AIA_BD_DeepClone.BDPWrapper Wrapvar = new AIA_BD_DeepClone.BDPWrapper(aiaBDP3,true);
  AIA_BD_DeepClone.BDPWrapper Wrapvar1 = new AIA_BD_DeepClone.BDPWrapper(aiaBDP1,true);
  ext.lstBDPWrapper.add(Wrapvar);
  ext.lstBDPWrapper.add(Wrapvar1);
  ext.ValidateAndCallPCS();
  AIA_BD_DeepClone.CopayTypeWrapper xyz = new AIA_BD_DeepClone.CopayTypeWrapper();
    xyz.copayTypeSelectedObj = apcty; 
    xyz.copayTypePecSpecObj = apcty;
    xyz.copayTypeSelectedObj2 = apcty;
    xyz.copayTypePecSpecObj2 = apcty;
    ext.copayBenMap.put('Family Out Of Pocket',xyz);
    ext.copayBenMap.put('OutOfPocket_Individual',xyz);
  boolean IsBrfPanel = true;
  ext.next();
  boolean IsPPPanel = true;
  ext.next();
  boolean IsSummaryPanel = true;
  ext.back();
  
    test.stopTest(); 
 
}
   
}