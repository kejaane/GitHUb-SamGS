/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */

// Date         Developer               Description
// 
//==================================================================================
//06/17/2017    Sajitha Yalamanchili     Initial Development
//06/08/2018    raj kiran      T01       Added code for role updates
//01-18-2019 	Chaithra 		|T02| 	Created users for account team role as per US1702 and US1730
//==================================================================================
@istest(seealldata=false)
public class AIA_OP4PCSJSONGenerator_Test {
 @testSetup static void testdata() {
 // Creating Account Test data
       Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.Type = 'Customer';
        acc.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X51');       
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Account_Legal_Name__c= 'test Account';
         insert acc;
    
	//Removing per US210     
    //Creating WorkPlan Type Test Data 
    /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
         insert wpt;*/
     
     //Creating Users Type Test Data
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
    
     //Creating Account Team members Test Data
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
     List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom   
     //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
      acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u11.id,'Account Executive'));
     //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
         insert acctMbrList;
      
     //Creating Opportunity Test Data   
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
    
     //Creating benefit Request Form Test Data 
     Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
            insert brf;
    
    //Creating AIA Plan Test Data 
    AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
        aiapln.Plan_Name__c='Test Plan';
        aiapln.Plan_Id__c='PLAN-Test';
        aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
        aiapln.Jurisdiction__c = 'MD';
        aiapln.Has_Benefit_Summary__c=true;
        insert aiapln;
         
   //Creating Proposed Plan Test Data 
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
        pp.Network__c='RX Choice';
         insert pp;
      
     //Creating Benefit Design Test Data  
     AIA_Benefit_Design__c aiabd = new AIA_Benefit_Design__c();
        aiabd.Account__c = acc.id;
        aiabd.Benefit_Request_Form__c = brf.Id;
        insert aiabd;
        
      // Craete BDP Test Data
       List<AIA_Benefit_Design_Product__c > bdpLst = new List<AIA_Benefit_Design_Product__c >();
       AIA_Benefit_Design_Product__c  bdp = AIA_TestUtil.createBDProductsForBD(aiabd,'Drug',aiapln.id,pp.id);
        bdp.Has_Benefit_Details__c = true;
        bdp.Funding_Arrangement__c = 'ASO';
        bdpLst.add(bdp);
        AIA_Benefit_Design_Product__c  bdp1 = AIA_TestUtil.createBDProductsForBD(aiabd,'Drug',aiapln.id,pp.id);
        bdp1.Has_Benefit_Details__c = true;
        bdp1.Funding_Arrangement__c = 'Risk';
        bdpLst.add(bdp1);
        insert bdpLst;
    
   // Creating Grouper test data
     List<AIA_Grouper__c> aiagrouperlist = new List<AIA_Grouper__c>();
      AIA_Grouper__c ag = new AIA_Grouper__c();
        ag.Name = 'Diagnostic/Lab/X-Ray';
        ag.Group_Type__c = 'Cost Share Group';
        ag.Grouper_Record_Type__c = 'BRF';
        ag.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag.Proposed_Products__c = pp.id;
        ag.InNetwork__c='NET-01';
        ag.OON_OutNetwork__c='NET-02';
        aiagrouperlist.add(ag);
      
       AIA_Grouper__c ag2 = new AIA_Grouper__c();
        ag2.Name = 'CostShareRanges';
        ag2.Group_Type__c = 'Cost Share Group';
        ag2.Grouper_Record_Type__c = 'BRF';
        ag2.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
        ag2.Sequence_Number__c = 1;
        ag2.Proposed_Products__c = pp.id;
        ag2.InNetwork__c='NET-01';
        ag2.OON_OutNetwork__c='NET-02';
        aiagrouperlist.add(ag2);
        insert aiagrouperlist;
     
     //creating custom setting Data
    AIA_PCS_Transaction_Table__c translation= new AIA_PCS_Transaction_Table__c();
        translation.Name='test';
        translation.PCS_Tag__c='OutOfPocket_Family';
        translation.Salesforce_Display_Name__c='Family Out Of Pocket';
        insert translation;
   
    //Creating Benefit Test Data
      List<AIA_Benefits__c> aiabenList = new List<AIA_Benefits__c>();
        AIA_Benefits__c ab = new AIA_Benefits__c();           
        ab.Grouper__c = ag.id;
        ab.Benefit_Name__c = translation.Salesforce_Display_Name__c;
        ab.Benefit_Type__c = 'Benefit';
        ab.Type__c = 'Benefit';           
        ab.Benefit_Record_Type__c = 'BRF';
        ab.Cost_Share_Low__c = '0';
        ab.Cost_Share_High__c = '100';
        ab.Cost_Share_SelectedAmount__c='150';
        ab.Cost_Share_Increment__c = '10';
        ab.Cost_Share_InvalidIncrements__c = '30';
        ab.Cost_Share_AdditionalIncrements__c = '33';
        ab.OON_Cost_Share_Low__c = '0';
        ab.OON_Cost_Share_High__c = '1000';
        ab.OON_Cost_Share_Increment__c = '100';
        ab.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab.OON_Cost_Share_InvalidIncrements__c = '300';
        ab.OON_Cost_Share_SelectedAmount__c='300';
        ab.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab.Copay_Type_1_IsCovered__c = 'No';
        ab.CoInsurance_AmountValueSelected__c='200';
        ab.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab.Copay_Type_1_AliasName__c='General Copay';
        ab.Copay_Type_2_AliasName__c='General Copay';
        ab.OON_Copay_Type_1_AliasName__c='General Copay';
        ab.OON_Copay_Type_2_AliasName__c='General Copay';
        ab.OON_Copay_Type_2_AmountValueSelected__c = '10';
        ab.OON_Copay_Type_1_AmountValueSelected__c = '10';
        ab.OON_Copay_Type_1_IsCovered__c='Yes';
        ab.OON_CoInsurance_AmountValueSelected__c='500';
        ab.OON_Copay_Min_Payment__c='50';
        ab.Copay_Type_1_AmountValueSelected__c='100';
        ab.OON_Copay_Max_Payment__c='100';
        ab.OON_Tier_Type__c='   Generic';
        ab.Copay_Type_2_AmountValueSelected__c = '10';
        ab.Copay_Type_1_AmountValueSelected__c = '101';
        ab.Additional_Benefit__c = true;
        ab.Allowed_Amount__c= '10000';
        ab.IS_ASO_Only__c= true;
        ab.Place_of_Service__c='Washington,Dc';
        ab.Tier_type__c='Preferred Brand';
        ab.Variation_Condition_ID__c='V123';
        ab.DefaultPlanBenefitValue__c='B1001';
		ab.Copay_Type_1_Mandate_Name__c='test sample' ;//added by raj for code coverage
		
        aiabenList.add(ab);
      AIA_Benefits__c ab13 = new AIA_Benefits__c();           
        ab13.Grouper__c = ag2.id;
        ab13.Benefit_Name__c = 'Family Out Of Pocket';
        ab13.Benefit_Type__c = 'Limitation';
        ab13.Type__c = 'Benefit';           
        ab13.Benefit_Record_Type__c = 'BRF';
        ab13.Cost_Share_Low__c = '0';
        ab13.Cost_Share_High__c = '100';
        ab13.Cost_Share_Increment__c = '10';
        ab13.Cost_Share_InvalidIncrements__c = '30';
        ab13.Cost_Share_AdditionalIncrements__c = '33';
        ab13.OON_Cost_Share_Low__c = '0';
        ab13.OON_Cost_Share_High__c = '1000';
        ab13.OON_Cost_Share_Increment__c = '100';
        ab13.OON_Cost_Share_AdditionalIncrements__c = '330';
        ab13.OON_Cost_Share_InvalidIncrements__c = '300';
        ab13.Copay_Type_1_DeductibleApplies__c = 'Yes';
        ab13.Copay_Type_1_IsCovered__c = 'No';
        ab13.OON_Copay_Type_1_IsCovered__c = 'Yes';
        ab13.OON_Copay_Type_1_DeductibleApplies__c = 'No';
        ab13.Copay_Type_1_AliasName__c='General Copay';
        ab13.Copay_Type_2_AliasName__c='General Copay';
        ab13.OON_Copay_Type_1_AliasName__c='General Copay';
        ab13.OON_Copay_Type_2_AliasName__c='General Copay';
        aiabenList.add(ab13); 
        insert aiabenList;
    
    // create Limitations Test Data 
   List<Limitations__c> aiaLimitation = new List<Limitations__c>();
        Limitations__c lmt = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Maxrow');
        lmt.Benefit__c = ab13.id;
        aiaLimitation.add(lmt);
    Limitations__c lmt2 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'TierLimit');
        lmt.Benefit__c = ab13.id;
        aiaLimitation.add(lmt2);
     Limitations__c lmt3 = AIA_TestUtil.createBenefitComentCode(ab.id,True,'Comment');
        lmt.Benefit__c = ab13.id;
		lmt.TierLimitTo__c =90; // code added by raj for code coverage
		lmt.TierLimitFrom__c =90; // code added by raj for code coverage
		lmt.TierLimitDurationType__c ='Incident';  // code added by raj for code coverage
		lmt.TierLimit_Selected__c=true;// code added by raj for code coverage
		
								
								
        aiaLimitation.add(lmt3);
      Insert aiaLimitation;
     
     // create  RX Mandate Test Data
      AIA_RxMandate__c rX1 = new AIA_RxMandate__c();
      rX1.Mandate_Name__c = 'test Mandate';
      rX1.Mandate_Description__c = 'Test Desc';
      rX1.Mandate_Jurisdiction__c = 'MD';
      rX1.Mandate_Effective_Date__c = Date.newInstance(2016, 12, 9);
      rX1.Mandate_Term_Date__c = Date.newInstance(2018, 12, 9);
      rX1.Mandate_Apply__c = true;
      rX1.Network_Rules_AliasName__c = 'tema';
      rX1.Benefit_Design_Product__c = bdp.id;
      insert rX1;
    }
 
// Test method to cover Cost Share Group in AIA_OP4PCSIntializeGroupersLimitations class
 public static testMethod void testMethod1()
  {
      Test.startTest();
      AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                From AIA_Benefit_Design_Product__c  limit 1];
      System.assertEquals(bdpObj!= null,true);
      
      // Update Grouper for Cost Share Group
      AIA_Grouper__c agobj=[select id,Group_Type__c,RecordTypeId,Benefit_Design_Product__c from  AIA_Grouper__c  limit 1];
      agobj.Name='CostShareRanges';
      agobj.Benefit_Design_Product__c=bdpObj.id;
      agobj.Group_Type__c = 'Cost Share Group';
      agobj.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('BD Product').getRecordTypeId();
      update agobj;
      System.assertEquals(agobj!= null,true);
      
      AIA_PCS_Transaction_Table__c trans = [Select Salesforce_Display_Name__c,PCS_Tag__c From AIA_PCS_Transaction_Table__c  limit 1];
      
      // Update Benefit for Grouper
      AIA_Benefits__c benobj = [Select Id,Grouper__c,Benefit_Name__c From AIA_Benefits__c  limit 1];
      benobj.Grouper__c=agobj.Id;
      benobj.Benefit_Name__c =trans.Salesforce_Display_Name__c;
      update benobj;
      
      // Call AIA_OP4PCSJSONGenerator class
   AIA_OP4PCSJSONGenerator pcs= new AIA_OP4PCSJSONGenerator();
      pcs.getBDP(bdpObj.Id);// pass BDP Id to Main Class
       test.stopTest();
  
  } 
// Test method to cover Benefit Group in AIA_OP4PCSIntializeGroupersLimitations class
  public static testMethod void testMethod2()
  {
      Test.startTest();
    AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,
                                              Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                From AIA_Benefit_Design_Product__c  limit 1];
           System.assertEquals(bdpObj!= null,true);
      
     // Update Grouper for Benefit Group
    AIA_Grouper__c agobj=[select id,Name,Group_Type__c,Grouper_Record_Type__c,RecordTypeId,Proposed_Products__c,Benefit_Design_Product__c from  AIA_Grouper__c  limit 1];
        agobj.Name = 'Diagnostic/Lab/X-Ray';
        agobj.Group_Type__c = 'Benefit Group';
        agobj.Grouper_Record_Type__c = 'BRF';
        agobj.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
        agobj.Benefit_Design_Product__c=bdpObj.Id;
        update agobj;
      System.assertEquals(agobj!= null,true);
      
       // Update Benefit for Per Admission Copay 
      AIA_Benefits__c benobj = [Select Id,Grouper__c,Copay_Type_1_AliasName__c,Copay_Type_2_AliasName__c,
                                OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c From AIA_Benefits__c  limit 1];
        benobj.Grouper__c=agobj.Id;
        benobj.Copay_Type_1_AliasName__c='Per Admission Copay';
        benobj.Copay_Type_2_AliasName__c='Per Admission Copay';
        benobj.OON_Copay_Type_1_AliasName__c='Per Admission Copay';
        benobj.OON_Copay_Type_2_AliasName__c='Per Admission Copay';
        update benobj;
      
    // Call AIA_OP4PCSJSONGenerator class
     AIA_OP4PCSJSONGenerator pcs= new AIA_OP4PCSJSONGenerator();
      pcs.getBDP(bdpObj.Id);// pass BDP Id to Main Class
       test.stopTest();
  
  }  
  // Test method to cover Limitations in AIA_OP4PCSIntializeGroupersLimitations class
    public static testMethod void testMethod3()
  {
    Test.startTest();
    AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,
                                            Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c From AIA_Benefit_Design_Product__c  limit 1];
     System.assertEquals(bdpObj!= null,true);
      
     // Update Grouper for Benefit Group
    AIA_Grouper__c agobj=[select id,Name,Group_Type__c,Grouper_Record_Type__c,RecordTypeId,Proposed_Products__c,Benefit_Design_Product__c from  AIA_Grouper__c  limit 1];
        agobj.Name = 'Diagnostic/Lab/X-Ray';
        agobj.Group_Type__c = 'Benefit Group';
        agobj.Grouper_Record_Type__c = 'BRF';
        agobj.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
        agobj.Benefit_Design_Product__c=bdpObj.Id;
        update agobj;
      System.assertEquals(agobj!= null,true);
      
      // Update Benefit for General Copay   
      AIA_Benefits__c benobj = [Select Id,Grouper__c,Benefit_Name__c,Copay_Type_1_Mandate_Name__c,Benefit_Type__c,Copay_Type_1_AliasName__c,Copay_Type_2_AliasName__c,
                                OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c From AIA_Benefits__c  where Benefit_Type__c='Limitation'  limit 1];
       benobj.Grouper__c=agobj.Id;
       benobj.Benefit_Name__c = 'Family Out Of Pocket';
       benobj.Benefit_Type__c='Mandate';
       benobj.Copay_Type_1_Mandate_Name__c='test1 Mandate';
       benobj.Copay_Type_1_AliasName__c='General Copay';
       benobj.Copay_Type_2_AliasName__c='General Copay';
       benobj.OON_Copay_Type_1_AliasName__c='General Copay';
       benobj.OON_Copay_Type_2_AliasName__c='General Copay';
       update benobj;
      
     // Update Limitation For benefit
      Limitations__c limobj = [Select Id,Benefit_Name__c,Additional_Comment__c,Benefit__c From Limitations__c  limit 1];
      limobj.Benefit_Name__c='Family Out Of Pocket';
      limobj.Type__c='Comment';
      limobj.IsSelected__c=true;
      limobj.Additional_Comment__c= true;
      limobj.Benefit__c=benobj.Id;
      update limobj;
      
     // Call AIA_OP4PCSJSONGenerator class
      AIA_OP4PCSJSONGenerator pcs= new AIA_OP4PCSJSONGenerator();
      pcs.getBDP(bdpObj.Id);// pass BDP Id to Main Class
       test.stopTest();
  } 
    // Test method to cover PCP Copay condition in AIA_OP4PCSIntializeGroupersLimitations class
    public static testMethod void testMethod4()
  {
      Test.startTest();
      AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                From AIA_Benefit_Design_Product__c  limit 1];
       System.assertEquals(bdpObj!= null,true);
      
      // Update Grouper for Benefit Group
     AIA_Grouper__c agobj=[select id,Name,Group_Type__c,Grouper_Record_Type__c,RecordTypeId,Proposed_Products__c,Benefit_Design_Product__c from  AIA_Grouper__c  limit 1];
        agobj.Name = 'Diagnostic/Lab/X-Ray';
        agobj.Group_Type__c = 'Benefit Group';
        agobj.Grouper_Record_Type__c = 'BRF';
        agobj.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
        agobj.Benefit_Design_Product__c=bdpObj.Id;
        update agobj;
      System.assertEquals(agobj!= null,true);
      
        // Update Benefit for PCP Copay  
      AIA_Benefits__c benobj = [Select Id,Grouper__c,Benefit_Name__c,Benefit_Type__c,Copay_Type_1_AliasName__c,Copay_Type_2_AliasName__c,
                                OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c From AIA_Benefits__c  limit 1];
       benobj.Grouper__c=agobj.Id;
       benobj.Benefit_Name__c = 'Family Out Of Pocket';
       benobj.Benefit_Type__c='Benefit';
       benobj.Copay_Type_1_AliasName__c='PCP Copay';
       benobj.Copay_Type_2_AliasName__c='PCP Copay';
       benobj.OON_Copay_Type_1_AliasName__c='PCP Copay';
       benobj.OON_Copay_Type_2_AliasName__c='PCP Copay';
       update benobj;
     
    // Call AIA_OP4PCSJSONGenerator class
      AIA_OP4PCSJSONGenerator pcs= new AIA_OP4PCSJSONGenerator();
      pcs.getBDP(bdpObj.Id);// pass BDP Id to Main Class
       test.stopTest();
  
  }   
    // Test method to cover Specialist Copay condition in AIA_OP4PCSIntializeGroupersLimitations class
     public static testMethod void testMethod5()
  {

      Test.startTest();
      //Query the BDP
      AIA_Benefit_Design_Product__c bdpObj = [Select Id,Has_Benefit_Details__c,Product_Category__c,Funding_Arrangement__c,Benefit_Design__c,RecordTypeId,Plan_Name__c,Proposed_Products__c,BRF_Juridiction__c
                                                From AIA_Benefit_Design_Product__c  limit 1];
     System.assertEquals(bdpObj!= null,true);
     
      // Update the Grouper for Benefit Group
       AIA_Grouper__c agobj=[select id,Name,Group_Type__c,Grouper_Record_Type__c,RecordTypeId,Proposed_Products__c,Benefit_Design_Product__c from  AIA_Grouper__c  limit 1];
        agobj.Name = 'Diagnostic/Lab/X-Ray';
        agobj.Group_Type__c = 'Benefit Group';
        agobj.Grouper_Record_Type__c = 'BRF';
        agobj.RecordTypeId =Schema.SObjectType.AIA_Grouper__c.getRecordTypeInfosByName().get('Proposed Product').getRecordTypeId();
        agobj.Benefit_Design_Product__c=bdpObj.Id;
        update agobj;
       System.assertEquals(agobj!= null,true);
       
      // Update the Benefit Group for  Specialist Copay
      AIA_Benefits__c benobj = [Select Id,Grouper__c,Benefit_Name__c,Benefit_Type__c,Copay_Type_1_AliasName__c,Copay_Type_2_AliasName__c,
                                OON_Copay_Type_1_AliasName__c,OON_Copay_Type_2_AliasName__c From AIA_Benefits__c  limit 1];
       benobj.Grouper__c=agobj.Id;
       benobj.Benefit_Name__c = 'Family Out Of Pocket';
       benobj.Benefit_Type__c='Benefit';
       benobj.Copay_Type_1_AliasName__c='Specialist Copay';
       benobj.Copay_Type_2_AliasName__c='Specialist Copay';
       benobj.OON_Copay_Type_1_AliasName__c='Specialist Copay';
       benobj.OON_Copay_Type_2_AliasName__c='Specialist Copay';
       update benobj;
      
      // Call the AIA_OP4PCSJSONGenerator class
      AIA_OP4PCSJSONGenerator pcs= new AIA_OP4PCSJSONGenerator();
      pcs.getBDP(bdpObj.Id);// pass BDP Id to Main Class
       test.stopTest();
  }    
}