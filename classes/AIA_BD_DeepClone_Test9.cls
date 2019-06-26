@istest//(seealldata=true)
public with sharing class AIA_BD_DeepClone_Test9 {

    public static testmethod void Test_AIA_BD_DeepClone_TestCase17(){
   AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
    //Commenting as part of US210
     /*   AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
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
    insert userList;       
    system.assertNOTEquals(userList.size(),Null);
    
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
    List<Account_Team__c> acctMbrList =new List<Account_Team__c>();//T02
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
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
    brfSource.Benefit_Effective_Date__c =Date.newInstance(2014,10,1);
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
    brf.Benefit_Effective_Date__c =Date.newInstance(2014,10,1);
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
    
    AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Dental','Test');
    aiapln.Plan_Name__c='Test Plan';
    aiapln.Product_Last_Updated__c=datetime.newInstance(2015, 9, 15, 12, 30, 0);

    aiapln.Jurisdiction__c = 'MD';
    aiapln.Product_Status__c ='Active';
    aiapln.Has_Benefit_Summary__c = False;
    aiapln.Effective_Date__c = Date.newInstance(2016,10,1);
    aiapln.Configuration_Last_Updated__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);

    insert aiapln;
    //aiapln.BDF_Configuration_Last_Updated__c = '2015-10-18  08:17:23 PM';
    //update aiapln;
    system.assertNOTEquals(aiapln,Null);
    system.assertNOTEquals(aiapln.Id,Null);
    AIA_BD_DeepClone_Test.createPlanData(aiapln);

    AIA_Plan__c aiaplnProd = AIA_TestUtil.CreateGSMPlan('Medical1','Test1');
    aiaplnProd.Plan_Name__c='Test Plan11';
    aiaplnProd.Product_Last_Updated__c=datetime.newInstance(2015, 9, 15, 12, 30, 0);
    aiapln.Configuration_Last_Updated__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
    aiaplnProd.Product_Status__c ='Active';
    aiaplnProd.Has_Benefit_Summary__c = False;
    aiapln.Effective_Date__c = Date.newInstance(2016,10,1);
    insert aiaplnProd;
    //aiapln.BDF_Configuration_Last_Updated__c = datetime.now();
    //update aiapln;
    system.assertNOTEquals(aiaplnProd,Null);
    system.assertNOTEquals(aiaplnProd.Id,Null);
    
    Proposed_Products__c pp = new Proposed_Products__c();           
    pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Dental');
    pp.Benefit_Request_Form__c = brf.id;
    pp.Funding_Arrangement__c = 'ASO';
    pp.Product_Category__c = 'Dental';
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
    insert pp;
    system.assertNOTEquals(pp,Null);
    
    
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
    
    list<AIA_Benefit_Design_Product__c> bdpList = new list<AIA_Benefit_Design_Product__c>();
    AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
    aiaBDP1.Benefit_Design__c=aiaBD.id;
    aiaBDP1.Plan_Name__c=aiapln.id;
    aiaBDP1.Proposed_Products__c=PP.id;     
    aiaBDP1.Funding_Arrangement__c = 'ASO';
    aiaBDP1.Product_Category__c ='Dental';
    aiaBDP1.Has_Benefit_Details__c = true;
    aiaBDP1.AIA_Dollar_Penalty__c = 10;
    insert aiaBDP1;
    system.assertNOTEquals(aiaBDP1,Null);
    aiaBDP1 = [select id,name,Benefit_Design__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c from AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     
    system.assertNOTEquals(aiaBDP1,Null);
    
    AIA_Benefit_Design_Product__c aiaBDPDrug = new AIA_Benefit_Design_Product__c();
    aiaBDPDrug.Benefit_Design__c=aiaBD.id;
    aiaBDPDrug.Plan_Name__c=aiapln.id;
    aiaBDPDrug.Proposed_Products__c=PP.id;     
    aiaBDPDrug.Funding_Arrangement__c = 'Both';
    aiaBDPDrug.Product_Category__c ='Dental';
    aiaBDPDrug.Has_Benefit_Details__c = false;
    insert aiaBDPDrug;
    system.assertNOTEquals(aiaBDPDrug,Null);
    
    AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
    aiaBDP2.Benefit_Design__c=aiaBD.id;
    aiaBDP2.Plan_Name__c=aiaplnProd.id;
    aiaBDP2.Proposed_Products__c=PP.id;     
    aiaBDP2.Funding_Arrangement__c = 'ASO';
    aiaBDP2.Product_Category__c ='Dental';
    aiaBDP2.Has_Benefit_Details__c = true;
    
    bdpList.add(aiaBDP2);
    AIA_Benefit_Design_Product__c aiaBDP3 = new AIA_Benefit_Design_Product__c();
    aiaBDP3.Benefit_Design__c = aiaBD.id;
    aiaBDP3.Related_Medical_Product__c = aiaBDP1.id;   
    aiaBDP3.Plan_Name__c=aiapln.id;   
    aiaBDP3.Proposed_Products__c=PP.id;    
    aiaBDP3.Funding_Arrangement__c = 'ASO';
    aiaBDP3.Product_Category__c ='Dental';
    aiaBDP3.Cloned_From__c = aiaBDP1.id;
    aiaBDP3.Has_Benefit_Details__c = true;
    bdpList.add(aiaBDP3);
    insert bdpList;
    
    AIA_Document__c aiaDoc1 = new AIA_Document__c();
    aiaDoc1.Benefit_Design_Product__c=aiaBDP3.id;
    aiaDoc1.Account__c=acc.id;
    aiaDoc1.Approval_Status__c = 'Approved';
    aiaDoc1.Start_Date__c = System.today();
    aiaDoc1.End_Date__c = System.today()+10;
    insert aiaDoc1;
    system.assertNOTEquals(aiaDoc1,Null);
    
    Attachment att=AIA_TestUtil.createAttachment(aiaDoc1.Id);
    system.assertNOTEquals(att,Null);
    
    AIA_Benefit_Design_Product__c aiaBDPMed = new AIA_Benefit_Design_Product__c();
    
    bdpList = [select id,name,Benefit_Design__c,Plan_Name__c,Product_Category__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c from AIA_Benefit_Design_Product__c where Id IN: bdpList];     
    system.assertNOTEquals(bdpList,Null);
    system.assertEquals(bdpList.size(),2);
    
    for(AIA_Benefit_Design_Product__c bdp: bdpList){
      if(bdp.Product_Category__c =='Dental')
        aiaBDPMed = bdp;
    }
    AIA_Grouper__c ag1 = new AIA_Grouper__c();
    ag1.Name = 'CostShareRanges';
    ag1.Group_Type__c = 'Benefit Group';
    ag1.Benefit_Design_Product__c = bdpList[1].id;
    ag1.Grouper_Record_Type__c = 'BDD';
    ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag1.Sequence_Number__c = 1;
    ag1.Proposed_Products__c = pp.id;
    insert ag1;

    AIA_Grouper__c ag2 = new AIA_Grouper__c();
    ag2.Name = 'CostShareRanges';
    ag2.Group_Type__c = 'Benefit Group';
    ag2.Benefit_Design_Product__c = bdpList[0].id;
    ag2.Grouper_Record_Type__c = 'BDD';
    ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag2.Sequence_Number__c = 2;
    ag2.Proposed_Products__c = pp.id;
    insert ag2;

    AIA_Benefits__c ab1 = new AIA_Benefits__c();           
    ab1.Grouper__c = ag1.id;
    ab1.Benefit_Name__c = 'OutOfPocket_Individual';
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
    update ab1;
        
    AIA_Benefits__c ab2 = new AIA_Benefits__c();           
    ab2.Grouper__c = ag2.id;
    ab2.Benefit_Name__c = 'OutOfPocket_Individual';
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
    update ab2;
    
    
    AIA_Benefits__c ab = new AIA_Benefits__c();           
    ab.Grouper__c = ag1.id;
    ab.Benefit_Name__c = 'OutOfPocket_Individual';
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
    
    AIA_Benefits__c ab22 = new AIA_Benefits__c();           
    ab22.Grouper__c = ag1.id;
    ab22.Benefit_Name__c = 'OutOfPocket_Individual';
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
    insert ab22;  

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
    
    AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
    apbt.Benefit_Name__c ='wdwd';
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
    
    ext.copayBenMap = new Map<string, AIA_BD_DeepClone.CopayTypeWrapper>();
    AIA_BD_DeepClone.CopayTypeWrapper xyz = new AIA_BD_DeepClone.CopayTypeWrapper();
        
    xyz.copayTypeSelectedObj = apcty; 
    xyz.copayTypePecSpecObj = apcty;
    xyz.copayTypeSelectedObj2 = apcty;
    xyz.copayTypePecSpecObj2 = apcty;
    ext.copayBenMap.put('Individual Deductible',xyz);
    ext.copayBenMap.put('OutOfPocket_Individual',xyz);
    boolean IsBrfPanel = true;
    ext.next();
    list<AIA_Grouper__c> gList = new list<AIA_Grouper__c>();
    ext.lstBDPWrapper = new list<AIA_BD_DeepClone.BDPWrapper>();
    AIA_BD_DeepClone.BDPWrapper Wrapvar = new AIA_BD_DeepClone.BDPWrapper(bdpList[1],true);
    AIA_BD_DeepClone.BDPWrapper Wrapvar1 = new AIA_BD_DeepClone.BDPWrapper(bdpList[0],true);
    AIA_BD_DeepClone.BDPWrapper Wrapvar2 = new AIA_BD_DeepClone.BDPWrapper(aiaBDPDrug,true);
    ext.lstBDPWrapper.add(Wrapvar);
    ext.lstBDPWrapper.add(Wrapvar1);
    ext.lstBDPWrapper.add(Wrapvar2);
    boolean IsPPPanel = true;
    ext.next();
    gList.add(ag2);
    //ext.ClonebenifitFromCopay('Individual Out Of Pocket',aiaBDPMed,gList);
    boolean IsSummaryPanel = true;
    ext.back();
    ext.erroMessages = new set<string>();
    ext.erroMessages.add(bdpList[0].Name);
    ext.deleteBDP();
    
    ApexPages.currentPage().getParameters().put('planid', aiaplnProd.id);
    ext.ValidateAndCallPCS();
    
    /*
    ext.AIADoc = new list<AIA_Document__c>();
    ext.selBDPList = new list<AIA_Benefit_Design_Product__c>();
    
    ApexPages.currentPage().getParameters().put('id', Imp1.id);
    
    ApexPages.currentPage().getParameters().put('planid', aiapln.id);
    ApexPages.currentPage().getParameters().put('palanIdValue','BDD');
    ApexPages.currentPage().getParameters().put('BDPID', aiaBDPMed.id);
    ApexPages.currentPage().getParameters().put('BDPName', aiaBDPMed.name);
    ext.ValidateAndCallPCS();
    IsSummaryPanel = false;
    IsPPPanel = true;
    ext.next();
    ApexPages.currentPage().getParameters().put('planid', '');
    ext.ValidateAndCallPCS();*/
    test.stopTest(); 
 
}
    public static testmethod void Test_AIA_BD_DeepClone_TestCase18(){
   AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
    //Commenting as part of US210
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
    insert userList;       
    system.assertNOTEquals(userList.size(),Null);
    
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
    List<Account_Team__c> acctMbrList =new List<Account_Team__c>();//T02
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Implementation Manager')); 
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Billing Tech'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Auditor'));
    acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u12.id,'Contract Tech'));
    
    insert acctMbrList;
    system.assertNOTEquals(acctMbrList.size(),Null);
    //Creating AIA_Config__c data:
    //AIA_Config__c conf = AIA_Test_BD_DeepClone_Utl.conf();
    //system.assertNOTEquals(conf,Null);
    
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
    brfSource.Benefit_Effective_Date__c =Date.newInstance(2014,10,1);
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
    brf.Benefit_Effective_Date__c =Date.newInstance(2014,10,1);
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
    
    AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Vision','Test');
    aiapln.Plan_Name__c='Test Plan';
    aiapln.Product_Last_Updated__c=datetime.newInstance(2015, 9, 15, 12, 30, 0);

    aiapln.Jurisdiction__c = 'MD';
    aiapln.Product_Status__c ='Active';
    aiapln.Has_Benefit_Summary__c = False;
    aiapln.Effective_Date__c = Date.newInstance(2016,10,1);
    aiapln.Configuration_Last_Updated__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);

    insert aiapln;
    //aiapln.BDF_Configuration_Last_Updated__c = '2015-10-18  08:17:23 PM';
    //update aiapln;
    system.assertNOTEquals(aiapln,Null);
    system.assertNOTEquals(aiapln.Id,Null);
    AIA_BD_DeepClone_Test.createPlanData(aiapln);

    AIA_Plan__c aiaplnProd = AIA_TestUtil.CreateGSMPlan('Vision','Test1');
    aiaplnProd.Plan_Name__c='Test Plan11';
    aiaplnProd.Product_Last_Updated__c=datetime.newInstance(2015, 9, 15, 12, 30, 0);
    aiapln.Configuration_Last_Updated__c=datetime.newInstance(2014, 9, 15, 12, 30, 0);
    aiaplnProd.Product_Status__c ='Active';
    aiaplnProd.Has_Benefit_Summary__c = False;
    aiapln.Effective_Date__c = Date.newInstance(2016,10,1);
    insert aiaplnProd;
    //aiapln.BDF_Configuration_Last_Updated__c = datetime.now();
    //update aiapln;
    system.assertNOTEquals(aiaplnProd,Null);
    system.assertNOTEquals(aiaplnProd.Id,Null);
    
    Proposed_Products__c pp = new Proposed_Products__c();           
    pp.RecordTypeId = QueryBase.getRecordtypeId('Proposed_Products__c', 'Vision');
    pp.Benefit_Request_Form__c = brf.id;
    pp.Funding_Arrangement__c = 'ASO';
    pp.Product_Category__c = 'Vision';
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
    insert pp;
    system.assertNOTEquals(pp,Null);
    
    
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
    
    list<AIA_Benefit_Design_Product__c> bdpList = new list<AIA_Benefit_Design_Product__c>();
    AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
    aiaBDP1.Benefit_Design__c=aiaBD.id;
    aiaBDP1.Plan_Name__c=aiapln.id;
    aiaBDP1.Proposed_Products__c=PP.id;     
    aiaBDP1.Funding_Arrangement__c = 'ASO';
    aiaBDP1.Product_Category__c ='Vision';
    aiaBDP1.Has_Benefit_Details__c = true;
    aiaBDP1.AIA_Dollar_Penalty__c = 10;
    insert aiaBDP1;
    system.assertNOTEquals(aiaBDP1,Null);
    aiaBDP1 = [select id,name,Benefit_Design__c,Plan_Name__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c from AIA_Benefit_Design_Product__c where id =:aiaBDP1.id];     
    system.assertNOTEquals(aiaBDP1,Null);
    
    AIA_Benefit_Design_Product__c aiaBDPDrug = new AIA_Benefit_Design_Product__c();
    aiaBDPDrug.Benefit_Design__c=aiaBD.id;
    aiaBDPDrug.Plan_Name__c=aiapln.id;
    aiaBDPDrug.Proposed_Products__c=PP.id;     
    aiaBDPDrug.Funding_Arrangement__c = 'Both';
    aiaBDPDrug.Product_Category__c ='Vision';
    aiaBDPDrug.Has_Benefit_Details__c = false;
    insert aiaBDPDrug;
    system.assertNOTEquals(aiaBDPDrug,Null);
    
    AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
    aiaBDP2.Benefit_Design__c=aiaBD.id;
    aiaBDP2.Plan_Name__c=aiaplnProd.id;
    aiaBDP2.Proposed_Products__c=PP.id;     
    aiaBDP2.Funding_Arrangement__c = 'ASO';
    aiaBDP2.Product_Category__c ='Vision';
    aiaBDP2.Has_Benefit_Details__c = true;
    
    bdpList.add(aiaBDP2);
    AIA_Benefit_Design_Product__c aiaBDP3 = new AIA_Benefit_Design_Product__c();
    aiaBDP3.Benefit_Design__c = aiaBD.id;
    aiaBDP3.Related_Medical_Product__c = aiaBDP1.id;   
    aiaBDP3.Plan_Name__c=aiapln.id;   
    aiaBDP3.Proposed_Products__c=PP.id;    
    aiaBDP3.Funding_Arrangement__c = 'ASO';
    aiaBDP3.Product_Category__c ='Vision';
    aiaBDP3.Cloned_From__c = aiaBDP1.id;
    aiaBDP3.Has_Benefit_Details__c = true;
    bdpList.add(aiaBDP3);
    insert bdpList;
    
    AIA_Document__c aiaDoc1 = new AIA_Document__c();
    aiaDoc1.Benefit_Design_Product__c=aiaBDP3.id;
    aiaDoc1.Account__c=acc.id;
    aiaDoc1.Approval_Status__c = 'Approved';
    aiaDoc1.Start_Date__c = System.today();
    aiaDoc1.End_Date__c = System.today()+10;
    insert aiaDoc1;
    system.assertNOTEquals(aiaDoc1,Null);
    
    Attachment att=AIA_TestUtil.createAttachment(aiaDoc1.Id);
    system.assertNOTEquals(att,Null);
    
    AIA_Benefit_Design_Product__c aiaBDPMed = new AIA_Benefit_Design_Product__c();
    
    bdpList = [select id,name,Benefit_Design__c,Plan_Name__c,Product_Category__c,Plan_Name__r.Product_Status__c,Funding_Arrangement__c,Plan_Name__r.Plan_Id__c,Proposed_Products__c from AIA_Benefit_Design_Product__c where Id IN: bdpList];     
    system.assertNOTEquals(bdpList,Null);
    system.assertEquals(bdpList.size(),2);
    
    for(AIA_Benefit_Design_Product__c bdp: bdpList){
      if(bdp.Product_Category__c =='Vision')
        aiaBDPMed = bdp;
    }
    AIA_Grouper__c ag1 = new AIA_Grouper__c();
    ag1.Name = 'CostShareRanges';
    ag1.Group_Type__c = 'Benefit Group';
    ag1.Benefit_Design_Product__c = bdpList[1].id;
    ag1.Grouper_Record_Type__c = 'BDD';
    ag1.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag1.Sequence_Number__c = 1;
    ag1.Proposed_Products__c = pp.id;
    insert ag1;

    AIA_Grouper__c ag2 = new AIA_Grouper__c();
    ag2.Name = 'CostShareRanges';
    ag2.Group_Type__c = 'Benefit Group';
    ag2.Benefit_Design_Product__c = bdpList[0].id;
    ag2.Grouper_Record_Type__c = 'BDD';
    ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
    ag2.Sequence_Number__c = 2;
    ag2.Proposed_Products__c = pp.id;
    insert ag2;

    AIA_Benefits__c ab1 = new AIA_Benefits__c();           
    ab1.Grouper__c = ag1.id;
    ab1.Benefit_Name__c = 'OutOfPocket_Individual';
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
    update ab2;
    
    
    AIA_Benefits__c ab = new AIA_Benefits__c();           
    ab.Grouper__c = ag1.id;
    ab.Benefit_Name__c = 'OutOfPocket_Individual';
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
    
    AIA_Benefits__c ab22 = new AIA_Benefits__c();           
    ab22.Grouper__c = ag1.id;
    ab22.Benefit_Name__c = 'OutOfPocket_Individual';
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
    insert ab22;  

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
    
    AIA_Plan_Benefits__c apbt = new AIA_Plan_Benefits__c();   
    apbt.Benefit_Name__c ='wdwd';
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
    apcty1.Jurisdiction__c='Federal';
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
    //ext.getRelatedAIADocument();
    //ext.getSelectedAIADoc();
    
    //Added To improve Code Coverage: 28-7-2017
    //Start
    ext.AIA_DocWrapList = new list<AIA_BD_DeepClone.AIADocumentWrapper>();      
    AIA_BD_DeepClone.AIADocumentWrapper WrapDoc = new AIA_BD_DeepClone.AIADocumentWrapper(aiaDoc1,true);        
    ext.AIA_DocWrapList.add(WrapDoc);
    //End   
    ext.copayBenMap = new Map<string, AIA_BD_DeepClone.CopayTypeWrapper>();
    AIA_BD_DeepClone.CopayTypeWrapper xyz = new AIA_BD_DeepClone.CopayTypeWrapper();
        
    xyz.copayTypeSelectedObj = apcty; 
    xyz.copayTypePecSpecObj = apcty;
    xyz.copayTypeSelectedObj2 = apcty;
    xyz.copayTypePecSpecObj2 = apcty;
    ext.copayBenMap.put('Individual Deductible',xyz);
    //ext.copayBenMap.put('OutOfPocket_Individual',xyz);
    boolean IsBrfPanel = true;
    ext.next();
    list<AIA_Grouper__c> gList = new list<AIA_Grouper__c>();
    ext.lstBDPWrapper = new list<AIA_BD_DeepClone.BDPWrapper>();
    AIA_BD_DeepClone.BDPWrapper Wrapvar = new AIA_BD_DeepClone.BDPWrapper(bdpList[1],true);
    AIA_BD_DeepClone.BDPWrapper Wrapvar1 = new AIA_BD_DeepClone.BDPWrapper(bdpList[0],true);
    AIA_BD_DeepClone.BDPWrapper Wrapvar2 = new AIA_BD_DeepClone.BDPWrapper(aiaBDPDrug,true);
    ext.lstBDPWrapper.add(Wrapvar);
    ext.lstBDPWrapper.add(Wrapvar1);
    ext.lstBDPWrapper.add(Wrapvar2);
    boolean IsPPPanel = true;
    ext.next();
    //gList.add(ag2);
    //ext.ClonebenifitFromCopay('Individual Out Of Pocket',aiaBDPMed,gList);
    boolean IsSummaryPanel = true;
    ext.back();
    //ext.erroMessages = new set<string>();
    //ext.erroMessages.add(bdpList[0].Name);
    //ext.deleteBDP();
    
    ApexPages.currentPage().getParameters().put('planid', aiaplnProd.id);
    ext.ValidateAndCallPCS();
    
    /*
    ext.AIADoc = new list<AIA_Document__c>();
    ext.selBDPList = new list<AIA_Benefit_Design_Product__c>();
    
    ApexPages.currentPage().getParameters().put('id', Imp1.id);
    
    ApexPages.currentPage().getParameters().put('planid', aiapln.id);
    ApexPages.currentPage().getParameters().put('palanIdValue','BDD');
    ApexPages.currentPage().getParameters().put('BDPID', aiaBDPMed.id);
    ApexPages.currentPage().getParameters().put('BDPName', aiaBDPMed.name);
    ext.ValidateAndCallPCS();
    IsSummaryPanel = false;
    IsPPPanel = true;
    ext.next();
    ApexPages.currentPage().getParameters().put('planid', '');
    ext.ValidateAndCallPCS();*/
    test.stopTest(); 
 
}
}