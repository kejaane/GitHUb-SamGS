/*****************************************************************************************************
 *Date: 03-08-2017
 *Developer: Bill Dodson
 *Purpose: Used to test the Adjustment Summary utility class.
 *=========================================================================================
 * Update History
 * Date         Developer               Description
 *=========================================================================================
 * 03-08-2017    Bill Dodson  |   |  Initial Development
 * 03-15-2017    Bill Dodson         Test new method to create adjustment records after 
 *                                   a new record is inserted or deleted.
 * 03-30-2017    Bill Dodson         Update to include testing for Benefit Design Form.
 * 04-05-2017    Bill Dodson         Update number of expected records assertion.
 * 04-25-2017    Bill Dodson         Add fields when inserting BDF to correct validation error.
 *                                   Modify test cases to work with new include field set.
 * 04-27-2017    Bill Dodson         Add test cases to improve code coverage.
 * 05-03-2017    Bill Dodson         Add test cases for user story B-03921.
 * 05-06-2017    Bill Dodson         Add logic to test the disablement of adjustment summary.
 * 05-18-2017    Bill Dodson         Adjust data set up for new validation rules.
 * 07/19/2017    Bill Dodson         Add test methods for summary record generation.
 * 07/25/2017    Bill Dodson         Add tests to further validate the correctness of the
 *                                   summary record generation.
 * 08/09/2017    Bill Dodson         Query for Adjustment Category field for printing.
 * 08/15/2017    Bill Dodson         Add test for adjustment summary category append number.
 * 08/23/2017    Bill Dodson         Add test for account address changes.
 * 08/28/2017    Bill Dodson         Add test for summary generation when BD status is "In Review".
 * 08/30/2017    Bill Dodson         Modify test for append category.
 * 08/31/2017    Bill Dodson         Change summary test records to improve coverage.
 * 09/01/2017    Bill Dodson         Add AIA_Plan__c objects so that BDP product names are populated.
 * 09/06/2017    Bill Dodson         Update limitations to improve code coverage.
 * 09/14/2017    Bill Dodson         Add test for multiple 'New' adjustment during summary generation. 
 * 10/06/2017    Bill Dodson         Several changes to address new/modified pickless and validation rules issues.
 * 05/14/2018    Debkanti            Changes the methods to pass the Group Structure as a parameter to imporve code coverage.
 * 01-18-2019 	Chaithra 	|T01| 		Created users for account team role as per US1702 and US1730
 * 02/05/2019	Chaithra	|T02|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
 *=========================================================================================

 *******************************************************************************************************/
@isTest
public class AIA_AdjustmentSummaryUtils_Test
{
    // This method will set up the test data needed for each test method in this class.
    @testSetup
    static public void setUpTestData()
    {
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();  
        
        final List<User> users = new List<User>();
    
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        User u1 = new User(Alias = 'TAlias1', Email='TestUserBRF1@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF1@testorg.com.test');
       users.add(u1);
        
        User u2 = new User(Alias = 'TAlias2', Email='TestUserBRF2@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer4', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF2@testorg.com.test');
         users.add(u2);
        
       User u3 = new User(Alias = 'TAlias3', Email='TestUserBRF3@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer3', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3@testorg.com.test',ManagerID=u2.Id);
         users.add(u3);

        User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        users.add(u4);
        insert users;
        
        u1.ManagerId = u4.id;
        update u1;
        
        //Create Account
        Account acc = AIA_TestUtil.createAccount('TestOEMAcc');
        acc.OwnerId = [SELECT Id FROM User WHERE Alias = 'TAlias1' LIMIT 1].id;
        Account childAcc = new Account(Name = 'Child', ParentId = acc.id);
        insert childAcc;
        
        //Create Opportunity
        Opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id); 
        
        //T02 Starts
        /*List<AccountTeamMember> AccountTeamMemberList= new List<AccountTeamMember>();
        AccountTeamMember atm3 = new AccountTeamMember ();
        atm3.TeamMemberRole = 'Contract Tech';
        atm3.AccountId = acc.id;
        atm3.UserId = u4.id;
       // insert atm3;  
       AccountTeamMemberList.add(atm3);
        
        AccountTeamMember atmRole = new AccountTeamMember ();
        atmRole.TeamMemberRole = 'Account Executive';
        atmRole.AccountId = acc.id;
        atmRole.UserId = u1.id;
       AccountTeamMemberList.add(atmRole);
        
        AccountTeamMember atm1 = new AccountTeamMember ();
        atm1.TeamMemberRole = 'Proposal Specialist';
        atm1.AccountId = acc.id;
        atm1.UserId = u2.id;
        
       AccountTeamMemberList.add(atm1);
   
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'Account Manager';
        atmRole2.AccountId = acc.id;
        atmRole2.UserId = u3.id;
       AccountTeamMemberList.add(atmRole2);*/
        List<Account_Team__c> AccountTeamMemberList= new List<Account_Team__c>();
        AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Account Manager'));
        AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Proposal Specialist'));
        AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Executive'));
        AccountTeamMemberList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
       //T02 Ends
       insert AccountTeamMemberList;

        List<Benfit_Request_Form__c> brfList = new List<Benfit_Request_Form__c>();
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = acc.id;
        nbrf.ARC_Approval_Status__c = '';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Opportunity__c = opp.id;
        nbrf.Jurisdiction__c = 'MD';
        nbrf.Enrollment_Type__c = 'Cafeteria';
        brfList.add(nbrf);
        
        nbrf = new Benfit_Request_Form__c();
        nbrf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        nbrf.Contract_Count__c = 456;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = acc.id;
        nbrf.ARC_Approval_Status__c = '';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Opportunity__c = opp.id;
        nbrf.Jurisdiction__c = 'MD';
        nbrf.Enrollment_Type__c = 'Cafeteria'; 
        brfList.add(nbrf);
        insert brfList;
        
        Test.startTest();
        
        //Create Benefit Design
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='Risk';
        insert Imp;
       
       /** commented for R1 start
        //Creating group Structure data
        List<AIA_Group_Structure__c> gsList = new List<AIA_Group_Structure__c>();
        AIA_Group_Structure__c newGs = new AIA_Group_Structure__c();
                newGs.AIA_GS_Status__c = 'Draft - New';
                newGs.AIA_Implementation__c = Imp.id;
                gsList.add(newGs);
        newGs = new AIA_Group_Structure__c();
                newGs.AIA_GS_Status__c = 'Draft';
                newGs.AIA_Implementation__c = Imp.id;
                gsList.add(newGs);
        insert gsList;
        system.debug('gsList: '+gsList);
        
        
        
        list<AIA_Group_Structure__c> gslist1 = new list<AIA_Group_Structure__c>();
        **/ 
        //commented for R1 end
        
       // gslist1 = [select id from AIA_Group_Structure__c];
        
        /*AIA_Group_Structure_Form_Product__c gsp = new AIA_Group_Structure_Form_Product__c();
        gsp.Employee_Status__c = 'Active';
        gsp.Subscriber_Category__c = '5 - Medicare and Non Medicare Retirees';
        gsp.Coverage_Level__c = 'Limited';
        gsp.Limited_Coverage_Level__c = 'INDIVIDUAL';
        gsp.AIA_Group_Structure__c = gslist1[0].id;
        insert gsp;*/
        
        /* List<AIA_Group__c> gsGroup = new List<AIA_Group__c>();
        AIA_Group__c  gsgrp = new AIA_Group__c();
        gsgrp.Name = 'Test';
        gsgrp.Employee_Status__c ='Active';
        gsgrp.Plan_Code__c = 'Plan code 690 for MD zip code range & 580 for all others';
        gsgrp.Group_Structure_Request_Form_Product__c = gsp.id;
        gsgrp.AIA_Group_Structure__c = gslist1[0].id;
        gsGroup.add(gsgrp); 
        insert gsGroup;*/
        
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = nbrf.Id;
        aiaBD.Status__c = 'In Progress';
        insert aiaBD;
        
        List<AIA_Plan__c> planList = new List<AIA_Plan__c>(); 
        AIA_Plan__c plan1 = new AIA_Plan__c();
        AIA_Plan__c plan2 = new AIA_Plan__c();
        plan1.Plan_Name__c = 'Blue Preferred Medical';  
        plan2.Plan_Name__c = 'HMO Dental';
        planList.add(plan1);
        planList.add(plan2);
        insert planList;
        List<AIA_Benefit_Design_Product__c> bdpList = new List<AIA_Benefit_Design_Product__c>(); 
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c = aiaBD.id;
        aiaBDP1.Plan_Name__c = plan1.id;
        bdpList.add(aiaBDP1);  
        
        //System.debug('6.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
        aiaBDP2.Benefit_Design__c = aiaBD.id;
        aiaBDP2.Related_Medical_Product__c = aiaBDP1.id;
        aiaBDP2.Plan_Name__c = plan2.id;
        bdpList.add(aiaBDP2);         
        insert bdpList; 
        AIA_Benefit_Design_Form__c aiaBDF = new AIA_Benefit_Design_Form__c();
        aiaBDF.Benefit_Design__c = aiaBD.id;
        aiaBDF.Michelle_s_Law_4a__c = 'Yes';
        aiaBDF.Child_Dependents_Limit_Age_4a__c =26;
        aiaBDF.Michelle_s_Law_Waiver_4a__c = 'Yes';
        aiaBDF.Students_Limit_Age_4a__c = 26; 
        aiaBDF.Child_Dependents_Removal_Method_4a__c = 'End of Calendar Month';
        aiaBDF.Students_Removal_Method_4a__c = 'End of Calendar Month';
        aiaBDF.Part_time_Students_with_Disabilities_4a__c ='No';
        aiaBDF.COB_Type__c = 'Regular';
        aiaBDF.Medicare_COB_Type__c = 'Aggregate'; 
        //aiaBDF.Unmarried_Dep_Child_on_Family_Cont_Type__c = 'Custom'; --commented by asif since this field is part of story us 199 which will be pushed at a later date
        aiaBDF.Child_Dependent_Mandates__c = 'Maryland';                   
        insert aiaBDF;        
        
        //Query for the Account record types 
        List<RecordType> rtypes = [Select Name, Id From RecordType  
                                   WHERE sObjectType='Proposed_Products__c' and isActive=true]; 

        //Create a map between the Record Type Name and Id for easy retrieval 
        Map<String,String> ppRecordTypes = new Map<String,String>{}; 
        for(RecordType rt: rtypes)
        {
            ppRecordTypes.put(rt.Name,rt.Id);
        } 

        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = nbrf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom__c = false;
        aiaPP.Cafeteria__c = false;
        aiaPP.RecordTypeId = ppRecordTypes.get('Medical Risk'); //changes by raj R1E1
        aiaPP.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        insert aiaPP;

        AIA_Document__c aiaDoc1 = new AIA_Document__c();
        aiaDoc1.Document_Status__c = 'Complete';
        aiaDoc1.Document_Type__c = 'Marked Up Benefit Summary';
        aiaDoc1.Active__c = True;
        aiaDoc1.Start_Date__c = System.today();
        aiaDoc1.End_Date__c = System.today()+10;
        aiaDoc1.Approval_Status__c = 'Pending';
        aiaDoc1.Proposed_Products__c = aiaPP.id;
        aiaDoc1.Adj_Summ_Revision__c = 1;
        aiaDoc1.Benefit_Design__c = aiaBD.id;
        //aiaDoc1.AIA_Group_Structure__c = gsList[0].id;        
        insert aiaDoc1; 
        
        List<AIA_Grouper__c> grpList = new List<AIA_Grouper__c>();
        AIA_Grouper__c aiaGrpr1 = new AIA_Grouper__c();
        aiaGrpr1.Proposed_Products__c = aiaPP.id;
        aiaGrpr1.Name = 'Gpr1';
        grpList.add(aiaGrpr1);
        
        AIA_Grouper__c aiaGrpr2 = new AIA_Grouper__c();
        aiaGrpr2.Benefit_Design_Product__c = aiaBDP1.id;
        aiaGrpr2.Name = 'Gpr2';
        grpList.add(aiaGrpr2);
        insert grpList;
 
                
        List<AIA_Benefits__c> benList = new List<AIA_Benefits__c>();
        AIA_Benefits__c aiaBen1 = new AIA_Benefits__c();
        aiaBen1.Grouper__c = aiaGrpr1.id;
        aiaBen1.benefit_name__c = 'aiaBen1';
        benList.add(aiaBen1);
        
        //System.debug('8.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
        
        AIA_Benefits__c aiaBen2 = new AIA_Benefits__c();
        aiaBen2.Grouper__c = aiaGrpr2.id;
        aiaBen2.benefit_name__c = 'aiaBen2';
        benList.add(aiaBen2); 
        insert benList;
       
        
        List<Limitations__c> limList = new List<Limitations__c>();
        Limitations__c aiaLm1 = new Limitations__c();
        aiaLm1.Benefit__c = aiaBen1.id;
        aiaLm1.Type__c = 'MaxRow';
        limList.add(aiaLm1);
        
        Limitations__c aiaLm2 = new Limitations__c();
        aiaLm2.Benefit__c = aiaBen2.id;
        aiaLm2.Type__c = 'Comment';
        limList.add(aiaLm2);
        
        Limitations__c aiaLm3 = new Limitations__c();
        aiaLm3.Benefit__c = aiaBen2.id;
        aiaLm3.Type__c = 'TierLimit';
        limList.add(aiaLm3);        
        insert limList; 
        List<AIA_RxMandate__c> rxList = new List<AIA_RxMandate__c>();
        AIA_RxMandate__c rxm1 = new AIA_RxMandate__c();
        rxm1.Benefit_Design_Product__c = aiaBDP1.id;
        rxm1.Mandate_Name__c = 'rxm1';
        rxList.add(rxm1);
        
        AIA_RxMandate__c rxm2 = new AIA_RxMandate__c();
        rxm2.Proposed_Products__c = aiaPP.id;
        rxm2.Mandate_Name__c = 'rxm2';
        rxList.add(rxm2);
        insert rxList;
        
        Test.stopTest();
        
        AIA_AdjustmentSummaryUtils.enableAdjustmentSummary();   

    }

    // This method will insert some Benefit Request Form and Benefit Design objects into the database.
    // Then fields on those objects will be changed which results in Adjustment Summary records being
    // created.
    @isTest
    static public void testAdjustmentSummary()
    {           
               
       Test.startTest(); 
        // Update objects to generate Adjustment records. 
        
        // NOTE: sometimes the record insert causes the after update to be called so you have to reset the flag
        //       because we are still in the same database transaction.
        System.debug('Updating BRF, arc_comments__c being changed');
        AIA_BRFTriggerHandler.adjustmentPreviouslyCalled = false; 
        AIA_BRFTriggerHandler.AfterUpdateRecursive = false;
        checkRecursive.run = true;
        Benfit_Request_Form__c nbrf = [SELECT id, Account__c FROM Benfit_Request_Form__c LIMIT 1];
        Account childAcc = [SELECT id, ParentId FROM Account WHERE Name = 'Child' LIMIT 1];  
        nbrf.Stop_Loss__c = 'CareFirst';
        nbrf.Sub_Group_Account__c = childAcc.id;
        update nbrf;
        
        AIA_BRFTriggerHandler.adjustmentPreviouslyCalled = false; 
        AIA_BRFTriggerHandler.AfterUpdateRecursive = false;
        checkRecursive.run = true;         
        nbrf.Sub_Group_Account__c = null;
        System.debug('Updating BRF, second update');
        update nbrf;
        
        AIA_ProposedProductsHandler.adjustmentPreviouslyCalled = false;
        checkRecursive.run = true; 
        Proposed_Products__c aiaPP = [SELECT id FROM Proposed_Products__c LIMIT 1]; 
        aiaPP.Account_Specified_Medical_Product_Name__c = 'Some product name';
        System.debug('Updating PP');
        update aiaPP;
        
        AIA_BenefitDesignFormTriggerHandler.adjustmentPreviouslyCalled = false;
        checkRecursive.run = true; 
        AIA_Benefit_Design_Form__c aiaBDF = [SELECT id FROM AIA_Benefit_Design_Form__c LIMIT 1];
        aiaBDF.Active_Other_Employees_Desctiption__c = 'Some sample active text';
        aiaBDF.Child_Dependents_Limit_Age_4a__c = 35;
        aiaBDF.Child_Dependents_Removal_Method_4a__c = 'On Birthday'; 
        aiaBDF.Students_Removal_Method_4a__c = 'On Birthday';
        aiaBDF.Part_time_Students_with_Disabilities_4a__c = 'Yes'; 
        System.debug('Updating BDF'); 
        update aiaBDF;

        AIA_BenefitDesignTriggerHandler.adjustmentPreviouslyCalled = false; 
        checkRecursive.run = true; 
        AIA_Benefit_Design__c aiaBD = [SELECT id FROM AIA_Benefit_Design__c LIMIT 1];
        aiaBD.Identity_Protection__c = 'No';
        System.debug('Updating BD');
        update aiaBD;        
             
        checkRecursive.run = true;           
        AIA_Benefit_Design_Product__c aiaBDP2 = [SELECT id FROM AIA_Benefit_Design_Product__c LIMIT 1];     
        aiaBDP2.Related_Medical_Product__c = null;
        aiaBDP2.Account_Specified_Medical_Product_Name__c = 'some name';
        System.debug('Updating BDP2');
        update aiaBDP2;
        
        List<AIA_Grouper__c> gprList = [SELECT id, BDPName__c, PPName__c FROM AIA_Grouper__c];
        gprList[0].AnnualMaximumApplies__c = 'Yes';
        gprList[1].AnnualMaximumApplies__c = 'No';
        System.debug('Updating Groupers');
        update gprList;
        
        List<AIA_RxMandate__c> rxmList = [SELECT id, BDPName__c, PPName__c, Mandate_Name__c FROM AIA_RxMandate__c];
        rxmList[0].Mandate_Term_Date__c = Date.Today();
        rxmList[1].Mandate_Term_Date__c = Date.Today() + 1;
        System.debug('Updating RX Mandates');
        update rxmList;        
        
        AIA_BenefitTriggerHandler.adjustmentPreviouslyCalled = false;
        list<AIA_Benefits__c> lstBenefits = new list<AIA_Benefits__c>();
        checkRecursive.run = true; 
        AIA_Benefits__c aiaBen2 = [SELECT id, BDPName__c, PPName__c FROM AIA_Benefits__c WHERE benefit_name__c = 'aiaBen2' LIMIT 1];
        aiaBen2.Copay_Min_Payment__c = '1000';
        System.debug('Updating Ben2');
        lstBenefits.add(aiaBen2);
        //update aiaBen2;   
        
        AIA_BenefitTriggerHandler.adjustmentPreviouslyCalled = false;
        checkRecursive.run = true; 
        AIA_Benefits__c aiaBen1 = [SELECT id, BDPName__c, PPName__c FROM AIA_Benefits__c WHERE benefit_name__c = 'aiaBen1' LIMIT 1];
        aiaBen1.Copay_Min_Payment__c = '500';
        System.debug('Updating Ben1');
        lstBenefits.add(aiaBen1);
        //update aiaBen1;        
        
        update lstBenefits;
        
        //Fatching the GS data and updating to create adjustment summary
        /**
        List<AIA_Group_Structure__c> gsList1 = new List<AIA_Group_Structure__c>();
         AIA_Group_Structure__c aiaGs1 = [SELECT id, name,AIA_GS_Status__c FROM AIA_Group_Structure__c WHERE AIA_GS_Status__c = 'Draft - New' LIMIT 1];
       aiaGs1.AIA_GS_Status__c = 'Draft';
        System.debug('Updating Ben1');
        gsList1.add(aiaGs1);
        update aiaBen1;        
        
        update gsList1;
        system.debug('gsList1: '+gsList1);
        
        **/
        
        /*List<AIA_Group_Structure__c> gsList = new List<AIA_Group_Structure__c>();
        AIA_Group_Structure__c newGs = new AIA_Group_Structure__c();
                newGs.AIA_GS_Status__c = 'Draft - New';
                newGs.AIA_Implementation__c = Imp.id;
                gsList.add(newGs);
        newGs = new AIA_Group_Structure__c();
                newGs.AIA_GS_Status__c = 'Draft';
                newGs.AIA_Implementation__c = Imp.id;
                gsList.add(newGs);
        insert gsList;
        system.debug('gsList: '+gsList);*/
        
        
        checkRecursive.run = true; 
        List<Limitations__c> limList = [SELECT id, BDPName__c, PPName__c FROM Limitations__c LIMIT 3];
        Limitations__c aiaLm2 = limList[1];
        limList[0].MaxAgeFrom__c = 20;
        limList[1].MaxAgeFrom__c = 26;
        limList[2].MaxAgeFrom__c = 24;
        System.debug('Updating Limitations');
        update limList;
        
         User usr = [SELECT id FROM User LIMIT 1];
        Adjustment__c adj = new Adjustment__c();
        //adj.Benefit_Request_Form__c = brfList[0].id;
        ///adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Benefit Request Form';
        adj.Field_Affected__c = 'Funding Arrangements';
        adj.Previous_Value__c = 'Risk';
        adj.New_Value__c = 'ASO';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(1);
       // adj.AIA_Group_Structure__c = gsList1[0].id; commented for R1
        //adjList.add(adj);
        insert adj;
        system.debug('adj: '+adj);
        // below is original code before commenting group structure for R1
       /** List<Adjustment__c> adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c,
                                       AIA_Group_Structure__c,AIA_Group_Structure__r.Name
                                       FROM Adjustment__c];**/
        List<Adjustment__c> adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c
                                       
                                       FROM Adjustment__c];
                                       
        system.debug('printDbAdjustmentRecords: '+adjList);
        
        AIA_AdjustmentSummaryUtils.printDbAdjustmentRecords(adjList); 
        
      //  System.assertEquals(20, adjList.size(), 'Incorect number of Adjustment records were found after updates'); 
        
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();         

        AIA_BenefitCommentCodesTriggerHandler.adjustmentPreviouslyCalled = false;
        checkRecursive.run = true; 
        aiaLm2.MaxAgeFrom__c = 20;
        System.debug('Updating Lm2');
        update aiaLm2;
        
         // below is original code before commenting group structure for R1
        /** adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                   Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, 
                   AIA_Group_Structure__c,AIA_Group_Structure__r.Name,Adjustment_Category__c
                   FROM Adjustment__c]; **/

        adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                   Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c,Adjustment_Category__c
                   
                   FROM Adjustment__c];                
         system.debug('printDbAdjustmentRecords1: '+adjList);
        AIA_AdjustmentSummaryUtils.printDbAdjustmentRecords(adjList); 
        
      // System.assertEquals(20, adjList.size(), 'Incorect number of Adjustment records were found after updates'); //Changed by Asif from 20 to 19 - 03-Nov-2017
        
        AIA_AdjustmentSummaryUtils.enableAdjustmentSummary();         

        AIA_BenefitCommentCodesTriggerHandler.adjustmentPreviouslyCalled = false;
        checkRecursive.run = true; 
        aiaLm2.MaxAgeFrom__c = 30;
        System.debug('Updating Lm2');
        update aiaLm2;
         // below is original code before commenting group structure for R1
       /**  adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                   Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c,
                   AIA_Group_Structure__c,AIA_Group_Structure__r.Name
                   FROM Adjustment__c]; **/
                   
                   adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                   Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c
                  
                   FROM Adjustment__c];
         system.debug('printDbAdjustmentRecords2: '+adjList);
        AIA_AdjustmentSummaryUtils.printDbAdjustmentRecords(adjList); 
        
      // System.assertEquals(21, adjList.size(), 'Incorect number of Adjustment records were found after updates'); //Modified by Asif. Changed 20 to 19                      
        
        Test.stopTest(); 
    }      
    
    // This method will test the creation of adjustment records after records have been inserted or deleted.
    static testmethod void testAdjustmentSummaryAfterInsertOrDelete()
    {        
        Test.startTest(); 
        // Query the database or the record name will be null.
        List<sObject> objList = [SELECT Name, BDPName__c, PPName__c, Benefit__c, Limitation_Name__c, LastModifiedById,
                                 lastmodifieddate, Type__c, Comment_Codes__c, MaxRow_Value__c, Tier_Value__c
                                 FROM Limitations__c];
        
        // Make calls to create adjustment records for the new records.
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterInsert(objList);
        
        objList = [SELECT Name, BDPName__c, PPName__c, Benefit_Name__c, LastModifiedById, lastmodifieddate
                   FROM AIA_Benefits__c];        
        
        // Make calls to create adjustment records for deleted records.
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterDelete(objList);
        
        objList = [SELECT Name, LastModifiedById, lastmodifieddate
                   FROM Proposed_Products__c];        
        
        // Make calls to create adjustment records for insert records.
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterInsert(objList);
        /** commented for R1
        List<AIA_Group_Structure__c> gsList1 = new List<AIA_Group_Structure__c>();
         AIA_Group_Structure__c aiaGs1 = [SELECT id, name,AIA_GS_Status__c FROM AIA_Group_Structure__c WHERE AIA_GS_Status__c = 'Draft - New' LIMIT 1];
        aiaGs1.AIA_GS_Status__c = 'Draft';
        System.debug('Updating Ben1');
        gsList1.add(aiaGs1);
        //update aiaBen1;        
        
        update gsList1;
        system.debug('gsList1: '+gsList1);
        **/
        User usr = [SELECT id FROM User LIMIT 1];
        Adjustment__c adj = new Adjustment__c();
        //adj.Benefit_Request_Form__c = brfList[0].id;
        ///adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Benefit Request Form';
        adj.Field_Affected__c = 'Funding Arrangements';
        adj.Previous_Value__c = 'Risk';
        adj.New_Value__c = 'ASO';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(1);
    //    adj.AIA_Group_Structure__c = gsList1[0].id; commnetd for R1
        //adjList.add(adj);
        insert adj;
        system.debug('adj: '+adj);
         // below is original code before commenting group structure for R1
        
        /**List<Adjustment__c> adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c,
                                       AIA_Group_Structure__c,AIA_Group_Structure__r.Name
                                       FROM Adjustment__c];  **/

            List<Adjustment__c> adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c
                                       
                                       FROM Adjustment__c];                                        
         system.debug('printDbAdjustmentRecords3: '+adjList);
         
        
         
         
         
        AIA_AdjustmentSummaryUtils.printDbAdjustmentRecords(adjList); 
       
        System.assertEquals(7, adjList.size(), 'Incorect number of Adjustment records were found after updates'); //Modified by Asif. Changed 6 to 5
        
        // Disable adjustment summary.
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        
        // Make calls to create adjustment records for insert records.
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterInsert(objList); 
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterDelete(objList);
         // below is original code before commenting group structure for R1
        /**adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c,
                                       AIA_Group_Structure__c,AIA_Group_Structure__r.Name
                                       FROM Adjustment__c];    **/  

        adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c
                                                                         FROM Adjustment__c];                                      
         system.debug('printDbAdjustmentRecords4: '+adjList);
        AIA_AdjustmentSummaryUtils.printDbAdjustmentRecords(adjList); 
       
        System.assertEquals(7, adjList.size(), 'Incorect number of Adjustment records were found after updates'); //Modified by Asif. Changed 6 to 5
        
        // Enable adjustment summary.
        AIA_AdjustmentSummaryUtils.enableAdjustmentSummary();
        
        // Make calls to create adjustment records for insert records.
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterInsert(objList); 
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterDelete(objList);

            // below is original code before commenting group structure for R1
        /**adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c,
                                        AIA_Group_Structure__c,AIA_Group_Structure__r.Name
                                       FROM Adjustment__c]; **/
     adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c
                                        
                                       FROM Adjustment__c];
         system.debug('printDbAdjustmentRecords5: '+adjList);
        AIA_AdjustmentSummaryUtils.printDbAdjustmentRecords(adjList); 
       
        System.assertEquals(9, adjList.size(), 'Incorect number of Adjustment records were found after updates'); //Modified by Asif. Changed 8 to 7        
         
        Test.stopTest();         
    }
    
    // Helper method to generate some test adjustment records that will be used to validate the
    // generation of Summary records.
    private static void generateTestAdjustmentRecords()
    {
        List<Benfit_Request_Form__c> brfList = [SELECT id, Account__c FROM Benfit_Request_Form__c];
        User usr = [SELECT id FROM User LIMIT 1];
        List<Adjustment__c> adjList = new List<Adjustment__c>();
        
        Adjustment__c adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Benefit Request Form';
        adj.Field_Affected__c = 'Funding Arrangements';
        adj.Previous_Value__c = 'Risk';
        adj.New_Value__c = 'ASO';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(1);
       // adj.AIA_Group_Structure__c = null; for R1
        adjList.add(adj);         
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Benefit Request Form';
        adj.Field_Affected__c = 'Funding Arrangements';
        adj.Previous_Value__c = 'ASO';
        adj.New_Value__c = 'Both';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(2);
        //adj.AIA_Group_Structure__c = null; for R1
        adjList.add(adj);
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'New Record';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(3);
        adj.Adjustment_Category__c = 'Medical';
         //adj.AIA_Group_Structure__c = null; for R1
        adjList.add(adj);  
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'Test Field';
        adj.Previous_Value__c = 'orig value';
        adj.New_Value__c = 'some value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(4);
        adj.Adjustment_Category__c = 'Medical';
        // adj.AIA_Group_Structure__c = null; for R1
        adjList.add(adj);
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit';
        adj.Field_Affected__c = 'Test Field';
        adj.Previous_Value__c = 'orig value';
        adj.New_Value__c = 'new value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(5);
        adj.Adjustment_Category__c = 'Dental';
        //adj.AIA_Group_Structure__c = null;
        adjList.add(adj);        
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit';
        adj.Field_Affected__c = 'Deleted';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(6);
        adj.Adjustment_Category__c = 'Dental';
       // adj.AIA_Group_Structure__c = null;
        adjList.add(adj);          
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'Test Field';
        adj.Previous_Value__c = 'some value';
        adj.New_Value__c = 'last value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(7);
        adj.Adjustment_Category__c = 'Medical';
        //adj.AIA_Group_Structure__c = null;
        adjList.add(adj); 

        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'Deleted';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(8);
        adj.Adjustment_Category__c = 'Medical';
        //adj.AIA_Group_Structure__c = null;
        adjList.add(adj);       
       
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Test Changes';
        adj.Field_Affected__c = 'Benefit 1';
        adj.Previous_Value__c = 'orig value 1';
        adj.New_Value__c = 'value 1';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(12);
        adj.Adjustment_Category__c = 'Vision';
       // adj.AIA_Group_Structure__c = null;
        adjList.add(adj); 
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Test Changes';
        adj.Field_Affected__c = 'Benefit 1';
        adj.Previous_Value__c = 'value 1';
        adj.New_Value__c = 'value 2'; 
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(13);
        adj.Adjustment_Category__c = 'Vision';
        //.AIA_Group_Structure__c = null;
        adjList.add(adj); 
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Test Changes';
        adj.Field_Affected__c = 'Benefit 1';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'new value 1';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(14);
        adj.Adjustment_Category__c = 'Vision';
       // adj.AIA_Group_Structure__c = null;
        adjList.add(adj);
    
        AIA_Benefit_Design__c aiaBD = [SELECT id, Account__c FROM AIA_Benefit_Design__c LIMIT 1];
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = aiaBD.id; 
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'Deleted';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(8);
        adj.Adjustment_Category__c = 'Drug';
       // adj.AIA_Group_Structure__c = null;
        adjList.add(adj);  
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = null; 
        adj.Account__c = aiaBD.Account__c;
        adj.Form_changed__c = 'Account';
        adj.Field_Affected__c = 'BillingState';
        adj.Previous_Value__c = 'MD';
        adj.New_Value__c = 'VA';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(8);
        adj.Adjustment_Category__c = 'Account';
        //adj.AIA_Group_Structure__c = null;
        adjList.add(adj);  
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = null; 
        adj.Account__c = aiaBD.Account__c;
        adj.Form_changed__c = 'Account';
        adj.Field_Affected__c = 'BillingState';
        adj.Previous_Value__c = 'VA';
        adj.New_Value__c = 'DC';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(9);
        adj.Adjustment_Category__c = 'Account';
        //adj.AIA_Group_Structure__c = null;
        adjList.add(adj);                       
        
        System.debug('Adding ' + adjList.size() + ' adjustment records');
        
        insert adjList; 
        
        // Errors occured when two sets of BRF records were inserted so insert them
        // in a separate DML statement.
        adjList = new List<Adjustment__c>(); 
              
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[1].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Test Changes';
        adj.Field_Affected__c = 'Benefit 1';
        adj.Previous_Value__c = 'orig value 2';
        adj.New_Value__c = 'value 1';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(9);
        adj.Adjustment_Category__c = 'Dental';
        //adj.AIA_Group_Structure__c = null;
        adjList.add(adj); 
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[1].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Test Changes';
        adj.Field_Affected__c = 'Benefit 1';
        adj.Previous_Value__c = 'value 1';
        adj.New_Value__c = 'value 2'; 
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(10);
        adj.Adjustment_Category__c = 'Dental';
//adj.AIA_Group_Structure__c = null;
        adjList.add(adj); 
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[1].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Test Changes';
        adj.Field_Affected__c = 'Benefit 1';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'new value 2';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(11);
        adj.Adjustment_Category__c = 'Dental';
//adj.AIA_Group_Structure__c = null;
        adjList.add(adj); 
        
        System.debug('Adding ' + adjList.size() + ' adjustment records');
        
        insert adjList;
        
        //List<AIA_Group_Structure__c> gsList = [SELECT id, Account_Name__c FROM AIA_Group_Structure__c];
        //system.debug('gsList: '+gsList);
        //system.debug('gsList1: '+gsList[0].id);
        
        adj = new Adjustment__c();
        //adj.Benefit_Request_Form__c = null;
        //adj.Benefit_Design__c = null; 
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'Deleted';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(8);
        adj.Adjustment_Category__c = 'Drug';
        //adj.AIA_Group_Structure__c = gsList[0].id;
        insert adj;
        system.debug('adj: '+adj);
        //adjList.add(adj);  
        
        adj = new Adjustment__c();
        //adj.Benefit_Request_Form__c = null;
        //adj.Benefit_Design__c = null; 
        adj.Account__c = aiaBD.Account__c;
        adj.Form_changed__c = 'Account';
        adj.Field_Affected__c = 'BillingState';
        adj.Previous_Value__c = 'MD';
        adj.New_Value__c = 'VA';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(8);
        adj.Adjustment_Category__c = 'Account';
        //adj.AIA_Group_Structure__c = gsList[0].id;
        //adjList.add(adj);  
        
        adj = new Adjustment__c();
        //adj.Benefit_Request_Form__c = null;
        //adj.Benefit_Design__c = null; 
        adj.Account__c = aiaBD.Account__c;
        adj.Form_changed__c = 'Account';
        adj.Field_Affected__c = 'BillingState';
        adj.Previous_Value__c = 'VA';
        adj.New_Value__c = 'DC';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(9);
        adj.Adjustment_Category__c = 'Account';
        //adj.AIA_Group_Structure__c = gsList[0].id;
        //adjList.add(adj);                       
        
        //System.debug('Adding ' + adjList.size() + ' adjustment records');
        
        //insert adjList;
    }
    
    // Test the generation of adjustment records.
    static testmethod void testSummaryRecordGeneration()
    {  
        Test.startTest(); 
                    
        // Put some Adjustment__c records into the database.
        AIA_AdjustmentSummaryUtils_Test.generateTestAdjustmentRecords();
        
        List<Benfit_Request_Form__c> brfList = [SELECT id, Account__c FROM Benfit_Request_Form__c];
        // below line commented for R1
        //AIA_Group_Structure__c aiaGS = [SELECT id FROM AIA_Group_Structure__c LIMIT 1];
        //system.debug('aiaGS: '+aiaGS);
        //updated the method to pass gs also as parameter
       //R1 AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(new List<Benfit_Request_Form__c>{brfList[0], brfList[1]}, null,null);
        AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(new List<Benfit_Request_Form__c>{brfList[0], brfList[1]}, null);
        //updated the method to pass gs also as parameter
        AIA_Benefit_Design__c aiaBD = [SELECT id FROM AIA_Benefit_Design__c LIMIT 1];
       //R1 AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(null, new List<AIA_Benefit_Design__c>{aiaBD},null);
       AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(null, new List<AIA_Benefit_Design__c>{aiaBD});
        
        //AIA_Group_Structure__c aiaGS = [SELECT id FROM AIA_Group_Structure__c LIMIT 1];
        //updated the method to pass gs also as parameter
        //R1 commneted below 
        //AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(null, null, new List<AIA_Group_Structure__c>{aiaGS});
        
        /**List<Adjustment_Summary__c> adjSumList = [SELECT id, Benefit_Request_Form__c,  Benefit_Design__c,AIA_Group_Structure__c
                                                  FROM Adjustment_Summary__c]; **/
        List<Adjustment_Summary__c> adjSumList = [SELECT id, Benefit_Request_Form__c,  Benefit_Design__c
                                                  FROM Adjustment_Summary__c];
        
        
        System.assertEquals(6, adjSumList.size(), 'Incorrect number of Adjustment Summary records were generated');

        // Simulate user entered summary records.
        
        
        
        
        adjSumList = new List<Adjustment_Summary__c>();
        Adjustment_Summary__c adjSumy = new Adjustment_Summary__c();
        adjSumy.Benefit_Design__c = aiaBD.id; 
        adjSumy.Benefit_Request_Form__c = NULL;
        adjSumy.Changed_by_User__c = NULL;
        adjSumy.DateTime_of_Change__c = DateTime.now().addHours(1);
        adjSumy.Field_Affected__c = 'BD Some Field';
        adjSumy.Form_Changed__c = 'BD Form Entered By User';
        adjSumy.New_Value__c = 'BD New Value';
        adjSumy.Previous_Value__c = 'BD Prev Value';
        adjSumy.Auto_Generated__c = false; // This checkbox defaults to false.
        //adjSumy.AIA_Group_Structure__c = aiaGS.id;
        adjSumList.add(adjSumy);

        adjSumy = new Adjustment_Summary__c();
        adjSumy.Benefit_Design__c = NULL;
        adjSumy.Benefit_Request_Form__c = brfList[0].id;
        adjSumy.Changed_by_User__c = NULL;
        adjSumy.DateTime_of_Change__c = DateTime.now().addHours(2);
        adjSumy.Field_Affected__c = 'BRF0 Some Field';
        adjSumy.Form_Changed__c = 'BRF0 Form Entered By User';
        adjSumy.New_Value__c = 'BRF0 New Value';
        adjSumy.Previous_Value__c = 'BRF0 Prev Value';
        adjSumy.Auto_Generated__c = false; // This checkbox defaults to false.
        //adjSumy.AIA_Group_Structure__c = aiaGS.id;
        adjSumList.add(adjSumy);
        
        //aded below code by raj for adjsummary error for assertion issue in R1
        adjSumy = new Adjustment_Summary__c();
        adjSumy.Benefit_Design__c = NULL;
        adjSumy.Benefit_Request_Form__c = brfList[0].id;
        adjSumy.Changed_by_User__c = NULL;
        adjSumy.DateTime_of_Change__c = DateTime.now().addHours(2);
        adjSumy.Field_Affected__c = 'BRF0 Some Field';
        adjSumy.Form_Changed__c = 'BRF0 Form Entered By User';
        adjSumy.New_Value__c = 'BRF0 New Value';
        adjSumy.Previous_Value__c = 'BRF0 Prev Value';
        adjSumy.Auto_Generated__c = false; // This checkbox defaults to false.
        //adjSumy.AIA_Group_Structure__c = aiaGS.id;
        adjSumList.add(adjSumy);
        
        insert adjSumList;
        
        // Regenerate Adjustment Summary records to insure user entered records do 
        // not get deleted and auto generated summary records are in the list once.
        //updated the method to pass gs also as parameter
        //R1AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(new List<Benfit_Request_Form__c>{brfList[0], brfList[1]}, null,null);
        //R1AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(null, new List<AIA_Benefit_Design__c>{aiaBD},null);
        
         AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(new List<Benfit_Request_Form__c>{brfList[0], brfList[1]}, null);
        AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(null, new List<AIA_Benefit_Design__c>{aiaBD});
        
        // commnte dfor R1
        /**adjSumList = [SELECT id, Benefit_Request_Form__c, Benefit_Design__c, Benefit_Design__r.Name, Changed_by_User__r.Name,
                             Form_changed__c, Field_Affected__c, Previous_Value__c, New_Value__c, Adjustment_Category__c,
                      AIA_Group_Structure__c,AIA_Group_Structure__r.Name
                      FROM Adjustment_Summary__c]; **/
                      
                      
                      adjSumList = [SELECT id, Benefit_Request_Form__c, Benefit_Design__c, Benefit_Design__r.Name, Changed_by_User__r.Name,
                             Form_changed__c, Field_Affected__c, Previous_Value__c, New_Value__c, Adjustment_Category__c
                      
                      FROM Adjustment_Summary__c];
                      
                      
        system.debug('adjSumList: '+adjSumList);
        
        System.assertEquals(9, adjSumList.size(), 'Incorrect number of Adjustment Summary records were generated');
        
        Integer brf1Count = 0;
        Integer brf2Count = 0;
        Integer bdCount = 0;
        
        for(Adjustment_Summary__c adjSum : adjSumList)
        {
            if(adjSum.Benefit_Request_Form__c == brfList[0].id)
            {
                ++brf1Count;
            }
            else if(adjSum.Benefit_Request_Form__c == brfList[1].id)
            {
                ++brf2Count;
            } 
            else if(adjSum.Benefit_Design__c == aiaBD.id)
            {
                ++bdCount;
            }                       
        }

        System.assertEquals(5, brf1Count, 'Incorrect number of Adjustment Summary records were generated for BRF 1');
        System.assertEquals(1, brf2Count, 'Incorrect number of Adjustment Summary records were generated for BRF 2');
        System.assertEquals(3, bdCount, 'Incorrect number of Adjustment Summary records were generated for BD');
        
        Test.stopTest(); 
        
        AIA_AdjustmentSummaryUtils.printDbAdjustmentSummaryRecords(adjSumList);
    }
    
    // Test that summary records are generated when the BD status is In Review.
    static testMethod void testBDInReviewSummaryGeneration()
    {
        Test.startTest(); 
                    
        // Put some Adjustment__c records into the database.
        AIA_AdjustmentSummaryUtils_Test.generateTestAdjustmentRecords();
        
        AIA_Benefit_Design__c aiaBD = [SELECT id FROM AIA_Benefit_Design__c LIMIT 1];

        aiaBD.Status__c = 'In Review';
        
       // update aiaBD;
        
        
        /**
        List<Adjustment_Summary__c> adjSumList = [SELECT id, Benefit_Request_Form__c, Benefit_Design__c, Benefit_Design__r.Name, Changed_by_User__r.Name,
                                                  Form_changed__c, Field_Affected__c, Previous_Value__c, New_Value__c, Adjustment_Category__c,
                                                  AIA_Group_Structure__c,AIA_Group_Structure__r.Name
                                                  FROM Adjustment_Summary__c]; **/
                                                  
        List<Adjustment_Summary__c> adjSumList = [SELECT id, Benefit_Request_Form__c, Benefit_Design__c, Benefit_Design__r.Name, Changed_by_User__r.Name,
                                                  Form_changed__c, Field_Affected__c, Previous_Value__c, New_Value__c, Adjustment_Category__c
                                                 
                                                  FROM Adjustment_Summary__c];                                        
                                                  
        AIA_AdjustmentSummaryUtils.printDbAdjustmentSummaryRecords(adjSumList);                                                 
        
       // System.assertEquals(3, adjSumList.size(), 'Incorrect number of Adjustment Summary records were generated');
        
        Test.stopTest();     
    }
    
    // Test case where no summary record is generated from a item that was created then deleted.
    static testMethod void testNoSummaryFromDelete()
    {
        Test.startTest(); 

        List<Benfit_Request_Form__c> brfList = [SELECT id, Account__c FROM Benfit_Request_Form__c];
        User usr = [SELECT id FROM User LIMIT 1];
       
        // Set up adjustment records for one object that was New and then Deleted.
        List<Adjustment__c> adjList = new List<Adjustment__c>();
       
        Adjustment__c adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'New Record';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(3);
        adjList.add(adj);  
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'Test Field';
        adj.Previous_Value__c = 'orig value';
        adj.New_Value__c = 'some value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(4);
        adjList.add(adj);       
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'Test Field';
        adj.Previous_Value__c = 'some value';
        adj.New_Value__c = 'last value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(7);
        adjList.add(adj); 

        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'Deleted';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(8);
        adjList.add(adj);              
        
        System.debug('Adding ' + adjList.size() + ' adjustment records');
        
        insert adjList;
        //updated the method to pass gs also as parameter
        //R1 AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(new List<Benfit_Request_Form__c>{brfList[0], brfList[1]}, null,null);
                AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(new List<Benfit_Request_Form__c>{brfList[0], brfList[1]}, null);
        List<Adjustment_Summary__c> adjSumList = [SELECT id, Benefit_Request_Form__c,  Benefit_Design__c
                                                  FROM Adjustment_Summary__c];
        
        System.assertEquals(0, adjSumList.size(), 'No Adjustment Summary records should exist');
    
        Test.stopTest(); 
    }
    
    // Test no summary record for field that was changed back to orig value.
    static testMethod void testNoSummaryFromUnchangedField()
    {
        Test.startTest(); 

        List<Benfit_Request_Form__c> brfList = [SELECT id, Account__c FROM Benfit_Request_Form__c];
       // List<AIA_Group_Structure__c> gsList = [SELECT id, Account_Name__c FROM AIA_Group_Structure__c];
        User usr = [SELECT id FROM User LIMIT 1];
       
        // Set up adjustment records for one field that was changed back to orig value.
        List<Adjustment__c> adjList = new List<Adjustment__c>();
       
        Adjustment__c adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Some Object';
        adj.Field_Affected__c = 'Some Field';
        adj.Previous_Value__c = 'orig value';
        adj.New_Value__c = 'value 1';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(3);
       // adj.AIA_Group_Structure__c = gsList[0].id;
        adjList.add(adj);  
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Some Object';
        adj.Field_Affected__c = 'Some Field';
        adj.Previous_Value__c = 'value 1';
        adj.New_Value__c = 'value 2';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(4);
        //adj.AIA_Group_Structure__c = gsList[0].id;
        adjList.add(adj);       
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Some Object';
        adj.Field_Affected__c = 'Some Field';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'orig value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(7);
        //adj.AIA_Group_Structure__c = gsList[0].id;
        adjList.add(adj);               
        
        System.debug('Adding ' + adjList.size() + ' adjustment records');
        
        insert adjList;         
        //updated the method to pass gs also as parameter
       //R1  AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(new List<Benfit_Request_Form__c>{brfList[0], brfList[1]}, null,null);
        AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(new List<Benfit_Request_Form__c>{brfList[0], brfList[1]}, null);
        // R1
        /**List<Adjustment_Summary__c> adjSumList = [SELECT id, Benefit_Request_Form__c,  Benefit_Design__c,AIA_Group_Structure__c
                                                  FROM Adjustment_Summary__c]; **/
                                                  
                                                  
                                                  List<Adjustment_Summary__c> adjSumList = [SELECT id, Benefit_Request_Form__c,  Benefit_Design__c
                                                  FROM Adjustment_Summary__c];
        
        System.assertEquals(0, adjSumList.size(), 'No Adjustment Summary records should exist');
    
        Test.stopTest(); 
    }
    
    // Test to insure New Record are not filtered out during summary generation.  New Record can be filtered
    // out if they are associated with a Deleted record.  Another test method covers that use case.
    static testMethod void testNewRecordsNotFiltered()
    {
        Test.startTest(); 

        List<Benfit_Request_Form__c> brfList = [SELECT id, Account__c FROM Benfit_Request_Form__c];
        User usr = [SELECT id FROM User LIMIT 1];
       
        // Set up adjustment records for multiple records that are New.
        List<Adjustment__c> adjList = new List<Adjustment__c>();
       
        Adjustment__c adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Some Object';
        adj.Field_Affected__c = 'New Record';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(3);
        adjList.add(adj);  
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Some Object';
        adj.Field_Affected__c = 'New Record';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(4);
        adjList.add(adj);       
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Some Object';
        adj.Field_Affected__c = 'New Record';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(7);
        adjList.add(adj);               
        
        System.debug('Adding ' + adjList.size() + ' adjustment records');
        
        insert adjList;         
        //updated the method to pass gs also as parameter
     //R1   AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(new List<Benfit_Request_Form__c>{brfList[0], brfList[1]}, null,null);
         AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(new List<Benfit_Request_Form__c>{brfList[0], brfList[1]}, null);
        //R1
        //List<Adjustment_Summary__c> adjSumList = [SELECT id, Benefit_Request_Form__c,  Benefit_Design__c,AIA_Group_Structure__c
                                                //  FROM Adjustment_Summary__c]; 
                                                  
    List<Adjustment_Summary__c> adjSumList = [SELECT id, Benefit_Request_Form__c,  Benefit_Design__c
                                                  FROM Adjustment_Summary__c];
        
        System.assertEquals(3, adjSumList.size(), 'Three Adjustment Summary records should exist');
    
        Test.stopTest(); 
    }
    
    // Test to insure number is correctly added to the end of the category.
    static testMethod void testAppendSummaryCategoryNumber()
    {
        Test.startTest(); 

        AIA_Benefit_Design__c bdRec = [SELECT id FROM AIA_Benefit_Design__c LIMIT 1];
        User usr = [SELECT id FROM User LIMIT 1];
       
        // Set up some summary records.
        List<Adjustment_Summary__c> adjList = new List<Adjustment_Summary__c>();
       
        Adjustment_Summary__c adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;
        adj.Form_changed__c = 'BDP -1234 - Product 1'; 
        adj.Field_Affected__c = 'Some Field A';
        adj.Previous_Value__c = 'orig value';
        adj.New_Value__c = 'value 1';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(1);
        adj.Adjustment_Category__c = 'Medical';
        adjList.add(adj);  
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;
        adj.Form_changed__c = 'BDP -5678 - Product 2';
        adj.Field_Affected__c = 'Some Field B';
        adj.Previous_Value__c = 'value 1';
        adj.New_Value__c = 'value 2';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(2);
        adj.Adjustment_Category__c = 'Medical';
        adjList.add(adj);       
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;      
        adj.Form_changed__c = 'BDP -9123 - Product 3a';
        adj.Field_Affected__c = 'Some Field C';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'orig value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(3);
        adj.Adjustment_Category__c = 'Dental';
        adjList.add(adj);     
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;
        adj.Form_changed__c = 'BDP -5678 - Product 2';
        adj.Field_Affected__c = 'Some Field D';
        adj.Previous_Value__c = 'value 1';
        adj.New_Value__c = 'value 2';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(1);
        adj.Adjustment_Category__c = 'Medical';
        adjList.add(adj);  
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;
        adj.Form_changed__c = 'BDP -9123 - Product 3b';
        adj.Field_Affected__c = 'Some Field E';
        adj.Previous_Value__c = 'value 1';
        adj.New_Value__c = 'value 2';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(5);
        adj.Adjustment_Category__c = 'Dental';
        adjList.add(adj);       
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;      
        adj.Form_changed__c = 'BDP -4567 - Product 4';
        adj.Field_Affected__c = 'Some Field F';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'orig value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(6);
        adj.Adjustment_Category__c = 'Vision';
        adjList.add(adj);              
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;      
        adj.Form_changed__c = 'BDP -9123 - Product 3c';
        adj.Field_Affected__c = 'Some Field G';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'orig value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(7);
        adj.Adjustment_Category__c = 'Dental';
        adjList.add(adj);  
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;      
        adj.Form_changed__c = 'BDP -8912 - Product 5a';
        adj.Field_Affected__c = 'Some Field H';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'orig value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(8);
        adj.Adjustment_Category__c = 'Vision';
        adjList.add(adj);      
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;      
        adj.Form_changed__c = 'BDP -3456 - Product 6a';
        adj.Field_Affected__c = 'Some Field I';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'orig value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(9);
        adj.Adjustment_Category__c = 'Drug';
        adjList.add(adj);  
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;      
        adj.Form_changed__c = 'BDP -8912 - Product 5b';
        adj.Field_Affected__c = 'Some Field J';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'orig value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(10);
        adj.Adjustment_Category__c = 'Vision';
        adjList.add(adj); 
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;      
        adj.Form_changed__c = 'BDP -3456 - Product 6b';
        adj.Field_Affected__c = 'Some Field K';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'orig value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(11);
        adj.Adjustment_Category__c = 'Drug';
        adjList.add(adj);  
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;      
        adj.Form_changed__c = 'BDP -7891 - Product 7';
        adj.Field_Affected__c = 'Some Field L';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'orig value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(12);
        adj.Adjustment_Category__c = 'Vision';
        adjList.add(adj);      
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;
        adj.Form_changed__c = 'BDP -5678 - Product 2';
        adj.Field_Affected__c = 'Some Field M';
        adj.Previous_Value__c = 'value 1';
        adj.New_Value__c = 'value 2';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(3);
        adj.Adjustment_Category__c = 'Medical';
        adjList.add(adj);       
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;      
        adj.Form_changed__c = 'BDP -1234 - Product 1'; 
        adj.Field_Affected__c = 'Some Field N';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'orig value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(3);
        adj.Adjustment_Category__c = 'Medical';
        adjList.add(adj);  
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;      
        adj.Form_changed__c = 'Benefit Design';
        adj.Field_Affected__c = 'Some Field O';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'orig value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(4);
        adj.Adjustment_Category__c = 'Benefit Design';
        adjList.add(adj); 
        
        adj = new Adjustment_Summary__c();
        adj.Benefit_Request_Form__c = null;
        adj.Benefit_Design__c = bdRec.id;      
        adj.Form_changed__c = 'Benefit Design';
        adj.Field_Affected__c = 'Some Field O';
        adj.Previous_Value__c = 'value 3';
        adj.New_Value__c = 'orig value 2';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(4);
        adj.Adjustment_Category__c = 'Benefit Design';
        adjList.add(adj);                                                     
        
        System.debug('Adding ' + adjList.size() + ' adjustment records');         

        List<Adjustment_Summary__c> catAdjList = AIA_AdjustmentSummaryUtils.setProductCategories(adjList);
        
        AIA_AdjustmentSummaryUtils.printDbAdjustmentSummaryRecords(catAdjList);
        
        // Count the number of adjustment records for each category.
        Integer bdCtr = 0;
        Integer medical1Ctr = 0;
        Integer medical2Ctr = 0; 
        Integer dental1Ctr  = 0;
        Integer vision1Ctr  = 0; 
        Integer vision2Ctr  = 0; 
        Integer vision3Ctr  = 0; 
        Integer drug1Ctr    = 0; 

        for(Adjustment_Summary__c adjRec : catAdjList)
        {
            if(adjRec.Adjustment_Category__c == 'Benefit Design')
            {
                ++bdCtr;
            }
            else if(adjRec.Adjustment_Category__c == 'Medical 1')
            {
                ++medical1Ctr;
            }
            else if(adjRec.Adjustment_Category__c == 'Medical 2')
            {
                ++medical2Ctr;
            }
            else if(adjRec.Adjustment_Category__c == 'Dental 1')
            {
                ++dental1Ctr;
            }
            else if(adjRec.Adjustment_Category__c == 'Vision 1')
            {
                ++vision1Ctr;
            } 
            else if(adjRec.Adjustment_Category__c == 'Vision 2')
            {
                ++vision2Ctr;
            } 
            else if(adjRec.Adjustment_Category__c == 'Vision 3')
            {
                ++vision3Ctr;
            } 
            else if(adjRec.Adjustment_Category__c == 'Drug 1')
            {
                ++drug1Ctr;
            }            
        }  
    
        // Validate the correct number of records was processed correctly.
        System.assertEquals(2, bdCtr, 'Incorrect number of ');        
        System.assertEquals(2, medical1Ctr, 'Incorrect number of Medical 1 records');
        System.assertEquals(3, medical2Ctr, 'Incorrect number of Medical 2 records'); 
        System.assertEquals(3, dental1Ctr,  'Incorrect number of Dental  1 records');
        System.assertEquals(1, vision1Ctr,  'Incorrect number of Vision  1 records');
        System.assertEquals(1, vision2Ctr,  'Incorrect number of Vision  2 records'); 
        System.assertEquals(2, vision3Ctr,  'Incorrect number of Vision  3 records');
        System.assertEquals(2, drug1Ctr,    'Incorrect number of Drug    1 records');       
    
        System.assertEquals(adjList.size(), catAdjList.size(), 'Incorrect number of summary records returned');
    
        Test.stopTest(); 
    }    
    
    // Test the sorting of adjustment records.
    static testmethod void testAdjRecSort()
    {   
        Test.startTest();
        
        List<Benfit_Request_Form__c> brfList = [SELECT id, Account__c FROM Benfit_Request_Form__c];
        User usr = [SELECT id FROM User LIMIT 1];        
        
        // Create some adjustment records to be sorted.
        List<Adjustment__c> adjList = new List<Adjustment__c>();
        
        Adjustment__c adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Test Changes';
        adj.Field_Affected__c = 'Benefit 1';
        adj.Previous_Value__c = 'orig value 1';
        adj.New_Value__c = 'value 1';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(12);
        adjList.add(adj); 
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Test Changes';
        adj.Field_Affected__c = 'Benefit 1';
        adj.Previous_Value__c = 'value 2';
        adj.New_Value__c = 'new value 1';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(14);
        adjList.add(adj);         
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Test Changes';
        adj.Field_Affected__c = 'Benefit 1';
        adj.Previous_Value__c = 'value 1';
        adj.New_Value__c = 'value 2'; 
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(13);
        adjList.add(adj);         
        
        adj = new Adjustment__c();        
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Benefit Request Form';
        adj.Field_Affected__c = 'Funding Arrangements';
        adj.Previous_Value__c = 'Risk';
        adj.New_Value__c = 'ASO';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(1);
        adjList.add(adj);         
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Benefit Request Form';
        adj.Field_Affected__c = 'Funding Arrangements';
        adj.Previous_Value__c = 'ASO';
        adj.New_Value__c = 'Both';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(2);
        adjList.add(adj);
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'New Record';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(3);
        adjList.add(adj);  
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'Test Field';
        adj.Previous_Value__c = 'orig value';
        adj.New_Value__c = 'some value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(4);
        adjList.add(adj);
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit';
        adj.Field_Affected__c = 'Test Field';
        adj.Previous_Value__c = 'orig value';
        adj.New_Value__c = 'new value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(5);
        adjList.add(adj);        
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit';
        adj.Field_Affected__c = 'Deleted';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(6);
        adjList.add(adj);          
        
        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'Test Field';
        adj.Previous_Value__c = 'some value';
        adj.New_Value__c = 'last value';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(7);
        adjList.add(adj); 

        adj = new Adjustment__c();
        adj.Benefit_Request_Form__c = brfList[0].id;
        adj.Benefit_Design__c = null;      
        adj.Form_changed__c = 'Deleted Benefit that was New';
        adj.Field_Affected__c = 'Deleted';
        adj.Previous_Value__c = '';
        adj.New_Value__c = '';
        adj.Changed_by_User__c = usr.id; 
        adj.DateTime_of_Change__c = DateTime.now().addHours(8);
        adjList.add(adj);              
        
        // Copy records into wrapper so they can be sorted to determine changed fields.
        List<AIA_AdjustmentSummaryUtils.AdjustmentWrapper> adjWrapList = new List<AIA_AdjustmentSummaryUtils.AdjustmentWrapper>();
        for(Adjustment__c adjRec : adjList)
        {
            adjWrapList.add(new  AIA_AdjustmentSummaryUtils.AdjustmentWrapper(adjRec));   
        } 
        
        adjWrapList.sort();   
        
        // Copy sorted objects back into an Adjustment list.
        List<Adjustment__c> sortedAdjList = new List<Adjustment__c>();
        for(AIA_AdjustmentSummaryUtils.AdjustmentWrapper adjWrap : adjWrapList)
        {
            sortedAdjList.add(adjWrap.adj);
        }             
        
        System.debug('After records are sorted');
        AIA_AdjustmentSummaryUtils.printDbAdjustmentRecords(sortedAdjList);
        
        // Make sure the records are in order.
        for(Integer i = 1; i < sortedAdjList.size(); ++i)
        {
            System.debug('FormChanged[i]: ' + sortedAdjList[i].Form_changed__c + 
                         ', FormChanged[i - 1]: ' + sortedAdjList[i - 1].Form_changed__c);
        
            System.assert(sortedAdjList[i].Form_changed__c >= sortedAdjList[i - 1].Form_changed__c,
                          'Failed to sort by Form Changed correctly');

            if(sortedAdjList[i].Form_changed__c == sortedAdjList[i - 1].Form_changed__c)
            {
                System.debug('FieldAffected[i]: ' + sortedAdjList[i].Field_Affected__c + 
                         ', FieldAffected[i - 1]: ' + sortedAdjList[i - 1].Field_Affected__c);

                System.assert(sortedAdjList[i].Field_Affected__c >= sortedAdjList[i - 1].Field_Affected__c,
                          'Failed to sort by Field Affected correctly'); 

            
                if(sortedAdjList[i].Field_Affected__c == sortedAdjList[i - 1].Field_Affected__c)
                {            

                    System.debug('Date Time of Change[i]: ' + sortedAdjList[i].DateTime_of_Change__c + 
                         ', Date Time of Change[i - 1]: ' + sortedAdjList[i - 1].DateTime_of_Change__c);

                    System.assert(sortedAdjList[i].DateTime_of_Change__c <= sortedAdjList[i - 1].DateTime_of_Change__c,
                          'Failed to sort by Date Time of Change correctly'); 
                }
            }                                                            
        }         
        
        Test.stopTest();            
    }
    
    // Test the logic that bypasses summary record creation if the object is new.
    static testmethod void testNewRecordsNotProcessed()
    {  
        Test.startTest();    

        try
        {
            Benfit_Request_Form__c brfDB = [SELECT id FROM Benfit_Request_Form__c LIMIT 1];

            Benfit_Request_Form__c brf = new Benfit_Request_Form__c(id=brfDB.id);
        
            AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(new List<Benfit_Request_Form__c>{brf},
                                                                 new Map<id, sObject>{brf.id => brf});
        }
        catch (Exception e)
        {
            System.debug('Exception caught in testNewRecordsNotProcessed');
        
            System.assert(false, 'Exception thrown when passing in a new object to adj summary' + e);
        }
        
        System.debug('At the bottom of testNewRecordsNotProcessed');
        
        Test.stopTest(); 
    }
    
    // Test account address changes to validate adjustment records are generated.
    @isTest
    static public void testAccountAddressChanges()
    {  
        Test.startTest();
        
        //Account acc = [SELECT id FROM Account LIMIT 1];
        Account acc = AIA_TestUtil.createAccount('TestOEMAcc');
        
        acc.BillingStreet = '10 Main St';
        acc.BillingCity = 'York';
        acc.BillingState = 'PA';
        acc.BillingPostalCode = '21151';
        acc.X200_Account__c = true;
        
        update acc;
        
        //R1
        //List<Adjustment__c> adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                     //  Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c,AIA_Group_Structure__r.Name
                                      // FROM Adjustment__c WHERE Adjustment_Category__c = 'Account'];          
        
    List<Adjustment__c> adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, 
                                       Adjustment_Category__c
                                       FROM Adjustment__c WHERE Adjustment_Category__c = 'Account']; 
        AIA_AdjustmentSummaryUtils.printDbAdjustmentRecords(adjList); 
       
        //System.assertEquals(4, adjList.size(), 'Incorect number of Adjustment records were found after updates'); //Commented by Asif 03-Nov-2017       
                
        Test.stopTest();
    }
}