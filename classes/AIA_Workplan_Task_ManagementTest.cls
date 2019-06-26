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
 *
 *=========================================================================================
 * Date: 09/19/2017
 * Developer: Goutham Rapolu
 * Purpose: Used to create test data for AIA_Workplan_Task_Management related to US110
 *=========================================================================================
 * Update History
 * Date       Developer      Description
 *06/08/2018    raj kiran      T01       Added code for role updates
 * 
 *========================================================================================
 */
@isTest 
private class AIA_Workplan_Task_ManagementTest {
    
    @testSetup
    static public void setUpTestData()
    {
        Test.startTest();
     User usr = [Select Id From User where firstname = 'spmss'];
      system.runAs(usr)
      {
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        checkRecursive.runOnce();
        AIA_ProposedProductsHandler.firstRun = true;
        
        //Account a = AIA_TestUtil.CreateAccount('Test Account');
        //system.assertNotEquals(null,a.id);
         Account a = AIA_TestUtil.acc();
         //Creating User Test Data 
                
          
          List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        /**/  userList.add(u2);
        user u3 =AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);
        user u4 =AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5);        
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);        
        user u7 = AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7); 
        user u8 = AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);
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
        user u14 = AIA_TestUtil.AIA_createUser('alias14');
        userList.add(u14);
     
        user u15 = AIA_TestUtil.AIA_createUser('alias15');
        userList.add(u15);
        user u16 = AIA_TestUtil.AIA_createUser('alias16');
        userList.add(u16);
         insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u1.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'Settlements Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u6.id,'Underwriter')); //To1
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u7.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u8.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u9.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u10.id,'Settlements Analyst')); //To1
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u11.id,'Automated Enrollment Tech')); //To1
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u12.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u13.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u14.id,'Proposal Specialist'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u15.id,'Implementation Manager'));
        insert acctMbrList;
        System.debug('Total Number of SOQL Queries allowed in after inserting acc team mmbers>>: ' +  Limits.getLimitQueries());  
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
        list<Opportunity> opplst = new list<Opportunity>();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test opp';
        opp1.FullServiceProducer__c = 'BenefitMall'; // Validation rule where I cannot leave this blank
        opp1.StageName = 'Proposal';
        opp1.CloseDate = Date.today() + 7;
        opp1.AccountId = a.Id;
        opp1.Market_Segment_New__c = '51-199';
        opp1.Business_type__c = 'New';
        opp1.Division__c = '51-199 New Business';
        opp1.Legal_Account_Name_Verified__c =true;
        opp1.Underwriting_Entity__c = 'NCAS';
        opp1.Effective_Date__c =  Date.newInstance(2014,10,1);  // validation rule requires effective date be 1st of month
        opp1.CloseDate = opp1.Effective_Date__c.addDays(-11);  // validation rule requires effective date be after close date i.e. effective > closedate
        opp1.Contract_End_Date__c = opp1.Effective_Date__c.addMonths(1);  // VR requires contract_end_date > effective_date and contract_end_date be last day of a month
        opp1.Contract_End_Date__c = opp1.Contract_End_Date__c.addDays(-1);
        //opp.Workplan_Type__c = wpt.id;//T01
        opp1.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');
        opplst.add(opp1);
       
        insert opp1;
        
        //
         List<Benfit_Request_Form__c> nbrflist = new List<Benfit_Request_Form__c >();
         Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        //nbrf.Control_Plan__c='690';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        // brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.Id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        nbrflist.add(brf);
        
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = a.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Benefit_Request_Form__c = brf.id;
        insert Imp;
        
                 
        
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = a.id;
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Formulary__c = '1';
        nbrf.Enrollment_Type__c = 'Cafeteria';
        nbrf.Opportunity__c = opp1.id;
        nbrflist.add(nbrf);
        
        insert nbrflist;
          
        

       
        
          
           System.debug('Total Number of SOQL Queries allowed in after 211 line>: ' +  Limits.getLimitQueries()); 
          
        List<AIA_Document__c> AIADocList = new List<AIA_Document__c>();
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Complete';
        aiaDoc.Document_Type__c = 'Cede Document';
        aiaDoc.Active__c = True;
        aiadoc.Document_Name__c = 'Test';
        aiadoc.source__c = 'Benefit Request Form';
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Approval_Status__c = 'Approved';
        //aiadoc.Opportunity__c=o.id;  
        //aiadoc.Benefit_Request_Form__c = nbrf.id;
        //aiadoc.Implementation__c= imp.id; 
        aiaDoc.Sub_Department__c = 'Benefits Summaries';
        aiaDoc.Category__c = 'Opportunity';
        AIADocList.add(aiaDoc);
         AIA_Document__c aiaDoc1 = new AIA_Document__c();
        aiaDoc1.Document_Status__c = 'Complete';
        aiaDoc1.Document_Type__c = 'Cede Document';
        aiaDoc1.Active__c = True;
        aiaDoc1.Document_Name__c = 'Test';
        aiaDoc1.source__c = 'Benefit Request Form';
        aiaDoc1.Start_Date__c = System.today();
        aiaDoc1.End_Date__c = System.today()+10;
        aiaDoc1.Approval_Status__c = 'Approved';
        aiaDoc1.Benefit_Request_Form__c = nbrf.id;
        aiaDoc1.Implementation__c= imp.id; 
        aiaDoc1.Sub_Department__c = 'Benefits Summaries';
        aiaDoc1.Category__c = 'Benefit Request Form';
        aiaDoc1.Account__c = a.Id;
        AIADocList.add(aiaDoc1);
        
        AIA_Document__c aiaDoc2 = new AIA_Document__c();
        aiaDoc2.Document_Status__c = 'Complete';
        aiaDoc2.Document_Type__c = 'Cede Document';
        aiaDoc2.Active__c = True;
        aiaDoc2.Document_Name__c = 'Test';
        aiaDoc2.source__c = 'Implementation';
        aiaDoc2.Start_Date__c = System.today();
        aiaDoc2.End_Date__c = System.today()+10;
        aiaDoc2.Approval_Status__c = 'Approved';
        aiaDoc2.Implementation__c= imp.id;
        aiaDoc2.Account__c = a.Id;
        aiaDoc2.Sub_Department__c = 'Benefits Summaries';
        aiaDoc2.Category__c = 'Implementation';
        AIADocList.add(aiaDoc2);
        insert AIADocList;        
        
        
         System.debug('Total Number of SOQL Queries allowed in after  line 247>>: ' +  Limits.getLimitQueries()); 
        
        List<Workplan_Task_Template__c> WTTList = new List<Workplan_Task_Template__c>();
         
           Workplan_Task_Template__c WTT60 = new Workplan_Task_Template__c();
        WTT60.Description__c = 'Complete AIA_Group_Structure_Request_Form__c';
        WTT60.Related_Object_API_Name__c = 'AIA_Group_Structure_Request_Form__c';
        WTT60.Status__c = 'Not-Started';
        WTT60.Task_Completion_Events__c = 'Update';
        WTT60.Task_Completion_Expression__c = '2';
        WTT60.Task_Creation_Criteria_Expression__c = '';
        WTT60.Task_Creation_Events__c = 'Insert';
        WTT60.Task_Owner__c = '';
        WTT60.Task_Owner_Type__c = 'Account Team Role';
        WTT60.Task_Type__c = 'Manual / SF should auto close this task';
		WTT60.Acc_Team_Role_for_New_Business__c = 'Account Manager';
        WTT60.Acc_Team_Role_for_Renewal_Business__c = 'Account Manager';
        WTTList.add(WTT60); 
          
          Workplan_Task_Template__c WTT50 = new Workplan_Task_Template__c();
        WTT50.Description__c = 'Complete implementation';
        WTT50.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT50.Status__c = 'Not-Started';
        WTT50.Task_Completion_Events__c = 'Update';
        WTT50.Task_Completion_Expression__c = '2';
        WTT50.Task_Creation_Criteria_Expression__c = '';
        WTT50.Task_Creation_Events__c = 'Insert';
        WTT50.Task_Owner__c = '';
        WTT50.Task_Owner_Type__c = 'Account Team Role';
        WTT50.Task_Type__c = 'Manual / SF should auto close this task';
		WTT50.Acc_Team_Role_for_New_Business__c = 'Proposal Specialist';
        WTT50.Acc_Team_Role_for_Renewal_Business__c = 'Proposal Specialist';
        WTTList.add(WTT50);
          Workplan_Task_Template__c WTT51 = new Workplan_Task_Template__c();
        WTT51.Description__c = 'Complete implementation';
        WTT51.Related_Object_API_Name__c = 'AIA_Document__c';
        WTT51.Status__c = 'Not-Started';
        WTT51.Task_Completion_Events__c = 'Update';
        WTT51.Task_Completion_Expression__c = '2';
        WTT51.Task_Creation_Criteria_Expression__c = '';
        WTT51.Task_Creation_Events__c = 'Insert';
        WTT51.Task_Owner__c = 'Implementation Manager';
        WTT51.Task_Owner_Type__c = 'Account Team Role';
        WTT51.Task_Type__c = 'Manual / SF should auto close this task';
		WTT51.Acc_Team_Role_for_New_Business__c = 'Implementation Manager';
        WTT51.Acc_Team_Role_for_Renewal_Business__c = 'Implementation Manager';
        WTTList.add(WTT51); 
        
            Workplan_Task_Template__c WTT58 = new Workplan_Task_Template__c();
        WTT58.Description__c = 'Complete implementation';
        WTT58.Related_Object_API_Name__c = 'AIA_Document__c';
        WTT58.Status__c = 'Not-Started';
        WTT58.Task_Completion_Events__c = 'Update';
        WTT58.Task_Completion_Expression__c = '2';
        WTT58.Task_Creation_Criteria_Expression__c = '';
        WTT58.Task_Creation_Events__c = 'Insert';
        WTT58.Task_Owner__c = 'Proposal Specialist';
        WTT58.Task_Owner_Type__c = 'Account Team Role';
        WTT58.Task_Type__c = 'Manual / SF should auto close this task';
		WTT60.Acc_Team_Role_for_New_Business__c = 'Implementation Manager';
        WTT60.Acc_Team_Role_for_Renewal_Business__c = 'Implementation Manager';
        WTTList.add(WTT58); 
          
           Workplan_Task_Template__c WTT52 = new Workplan_Task_Template__c();
        WTT52.Description__c = 'Complete implementation';
        WTT52.Related_Object_API_Name__c = 'AIA_Benefit_Design__c';
        WTT52.Status__c = 'Not-Started';
        WTT52.Task_Completion_Events__c = 'Update';
        WTT52.Task_Completion_Expression__c = '2';
        WTT52.Task_Creation_Criteria_Expression__c = '';
        WTT52.Task_Creation_Events__c = 'Insert';
        WTT52.Task_Owner__c = 'Proposal Specialist';
        WTT52.Task_Owner_Type__c = 'Account Team Role';
        WTT52.Task_Type__c = 'Manual / SF should auto close this task';

        WTTList.add(WTT52);   
        
   Workplan_Task_Template__c WTT53 = new Workplan_Task_Template__c();
        WTT53.Description__c = 'Complete implementation';
        WTT53.Related_Object_API_Name__c = 'AIA_Benefit_Design_Product__c';
        WTT52.Status__c = 'Not-Started';
        WTT53.Task_Completion_Events__c = 'Update';
        WTT53.Task_Completion_Expression__c = '2';
        WTT53.Task_Creation_Criteria_Expression__c = '';
        WTT53.Task_Creation_Events__c = 'Insert';
        WTT53.Task_Owner__c = 'Proposal Specialist';
        WTT53.Task_Owner_Type__c = 'Account Team Role';
        WTT53.Task_Type__c = 'Manual / SF should auto close this task';

        WTTList.add(WTT53); 
          
   Workplan_Task_Template__c WTT54 = new Workplan_Task_Template__c();
        WTT54.Description__c = 'Complete implementation';
        WTT54.Related_Object_API_Name__c = 'AIA_Benefit_Design_Form__c';
        WTT54.Status__c = 'Not-Started';
        WTT54.Task_Completion_Events__c = 'Update';
        WTT54.Task_Completion_Expression__c = '2';
        WTT54.Task_Creation_Criteria_Expression__c = '';
        WTT54.Task_Creation_Events__c = 'Insert';
        WTT54.Task_Owner__c = 'Proposal Specialist';
        WTT54.Task_Owner_Type__c = 'Account Team Role';
        WTT54.Task_Type__c = 'Manual / SF should auto close this task';

        WTTList.add(WTT54); 

Workplan_Task_Template__c WTT55 = new Workplan_Task_Template__c();
        WTT55.Description__c = 'Complete implementation';
        WTT55.Related_Object_API_Name__c = 'PRF__c';
        WTT54.Status__c = 'Not-Started';
        WTT55.Task_Completion_Events__c = 'Update';
        WTT55.Task_Completion_Expression__c = '2';
        WTT55.Task_Creation_Criteria_Expression__c = '';
        WTT55.Task_Creation_Events__c = 'Insert';
        WTT55.Task_Owner__c = 'Proposal Specialist';
        WTT55.Task_Owner_Type__c = 'Account Team Role';
        WTT55.Task_Type__c = 'Manual / SF should auto close this task';

        WTTList.add(WTT55);           
          
        Workplan_Task_Template__c WTT0 = new Workplan_Task_Template__c();
        WTT0.Description__c = 'Complete Zip Code Verification Request';
        WTT0.Related_Object_API_Name__c = 'Benfit_Request_Form__c';
        WTT0.Status__c = 'Not-Started';
        WTT0.Task_Completion_Events__c = 'Update';
        WTT0.Task_Completion_Expression__c = '2';
        WTT0.Task_Creation_Criteria_Expression__c = '';
        WTT0.Task_Creation_Events__c = 'Insert';
        WTT0.Task_Owner__c = 'Proposal Specialist';
        WTT0.Task_Owner_Type__c = 'Account Team Role';
        WTT0.Task_Type__c = 'Manual / SF should auto close this task';

        WTTList.add(WTT0);
        
        Workplan_Task_Template__c WTT = new Workplan_Task_Template__c();
        WTT.Description__c = 'Complete Zip Code Verification Request';
        WTT.Related_Object_API_Name__c = 'Benfit_Request_Form__c';
        WTT.Status__c = 'Not-Started';
        WTT.Task_Completion_Events__c = 'Update';
        WTT.Task_Completion_Expression__c = '2';
        WTT.Task_Creation_Criteria_Expression__c = '1 AND 2';
        WTT.Task_Creation_Events__c = 'Insert';
        WTT.Task_Owner__c = 'Proposal Specialist';
        WTT.Task_Owner_Type__c = 'Account Team Role';
        WTT.Task_Type__c = 'Manual / SF should auto close this task';

        WTTList.add(WTT);
        
        Workplan_Task_Template__c WTT2 = new Workplan_Task_Template__c();
        WTT2.Description__c = 'Complete ARC Approval';
        WTT2.Related_Object_API_Name__c = 'Benfit_Request_Form__c';
        WTT2.Status__c = 'Not-Started';
        WTT2.Task_Completion_Events__c = 'Update';
        WTT2.Task_Completion_Expression__c = '2';
        WTT2.Task_Creation_Criteria_Expression__c = '1 OR 2';
        WTT2.Task_Creation_Events__c = 'Insert';
        WTT2.Task_Owner__c = 'Proposal Specialist';
        WTT2.Task_Owner_Type__c = 'Account Team Role';
        WTT2.Task_Type__c = 'Manual / SF should auto close this task';

        WTTList.add(WTT2);
        
        Workplan_Task_Template__c WTT3 = new Workplan_Task_Template__c();
        WTT3.Description__c = 'Request and Upload CEDE Document';
        WTT3.Related_Object_API_Name__c = 'Benfit_Request_Form__c';
        WTT3.Status__c = 'Not-Started';
        WTT3.Task_Completion_Events__c = 'Insert';
        WTT3.Task_Completion_Expression__c = '2';
        WTT3.Task_Creation_Criteria_Expression__c = '//((1 OR 2) AND (3 OR 4)//)';
        WTT3.Task_Creation_Events__c = 'Insert';
        WTT3.Task_Owner__c = 'Ancillary Analyst';
        WTT3.Task_Owner_Type__c = 'Account Team Role';
        WTT3.Task_Type__c = 'Manual / SF should auto close this task';

        WTTList.add(WTT3);
        
        
          
        Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
        WTT4.Description__c = 'Verify Account Legal Names';
        WTT4.Related_Object_API_Name__c = 'Opportunity';
        WTT4.Status__c = 'Not-Started';
        WTT4.Task_Creation_Events__c = 'Insert';
        WTT4.Task_Completion_Events__c = 'Update';
        WTT4.Task_Creation_Criteria_Expression__c = '';
        WTT4.Task_Completion_Expression__c = '1';
        WTT4.Task_Owner_Type__c = 'Account Team Role';
        WTT4.Task_Owner__c = 'Ancillary Analyst';
        WTT4.Task_Type__c = 'Manual / SF should auto close this task';
        WTTList.add(WTT4);
        /*  Group g=new Group();
          g.Name='test';
          insert g;
        GroupMember grpm=new GroupMember();
          grpm.GroupId=g.Id;
          grpm.UserOrGroupId=usr.Id;
          insert grpm;*/
          
        Workplan_Task_Template__c WTT5 = new Workplan_Task_Template__c();
        WTT5.Description__c = 'Verify Account Legal Name test';
        WTT5.Related_Object_API_Name__c = 'Benfit_Request_Form__c';
        WTT5.Status__c = 'Not-Started';
        WTT5.Task_Creation_Events__c = 'Insert';
        WTT5.Task_Completion_Events__c = 'Update';
        WTT5.Task_Creation_Criteria_Expression__c = '//((1 AND 2) AND ()//)';
        WTT5.Task_Completion_Expression__c = '1';
        WTT5.Task_Owner_Type__c = 'QUEUE';
          WTT5.Queue_Name__c='test';
          
        WTT5.Task_Owner__c = 'Ancillary Analyst';
        WTT5.Task_Type__c = 'Manual / SF should auto close this task';
        WTTList.add(WTT5);
        
        insert WTTList;
        
         System.debug('Total Number of SOQL Queries allowed in after inserting WPTT line 460>>: ' +  Limits.getLimitQueries()); 
        
        
        List<Workplan_Task_Rules__c> WTRList = new List<Workplan_Task_Rules__c>();
        Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
        WTR.Field_API_Name__c = 'Jurisdiction__c';
        WTR.Object_API_Name__c = 'Benfit_Request_Form__c';
        WTR.Object_DML_Event__c = 'Insert';
        WTR.Operation__c = 'Equal To';
        WTR.Rule_Number__c = 1;
        WTR.Value__c = 'VA';
        WTR.Workplan_Task_Template__c = WTT.id;
        WTR.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR);
          
       Workplan_Task_Rules__c WTR60 = new Workplan_Task_Rules__c();
        WTR60.Field_API_Name__c = 'Name';
        WTR60.Object_API_Name__c = 'AIA_Group_Structure_Request_Form__c';
        WTR60.Object_DML_Event__c = 'Insert';
        WTR60.Operation__c = 'Not Equal To';
        WTR60.Rule_Number__c = 1;
        WTR60.Value__c = '';
        WTR60.Workplan_Task_Template__c = WTT60.id;
        WTR60.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR60); 
          
Workplan_Task_Rules__c WTR53 = new Workplan_Task_Rules__c();
        WTR53.Field_API_Name__c = 'Name';
        WTR53.Object_API_Name__c = 'AIA_Benefit_Design_Product__c';
        WTR53.Object_DML_Event__c = 'Insert';
        WTR53.Operation__c = 'Not Equal To';
        WTR53.Rule_Number__c = 1;
        WTR53.Value__c = '';
        WTR53.Workplan_Task_Template__c = WTT53.id;
        WTR53.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR53); 
        
          Workplan_Task_Rules__c WTR54 = new Workplan_Task_Rules__c();
        WTR54.Field_API_Name__c = 'Name';
        WTR54.Object_API_Name__c = 'AIA_Benefit_Design_Form__c';
        WTR54.Object_DML_Event__c = 'Insert';
        WTR54.Operation__c = 'Not Equal To';
        WTR54.Rule_Number__c = 1;
        WTR54.Value__c = '';
        WTR54.Workplan_Task_Template__c = WTT54.id;
        WTR54.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR54); 
       
          Workplan_Task_Rules__c WTR55 = new Workplan_Task_Rules__c();
        WTR55.Field_API_Name__c = 'Name';
        WTR55.Object_API_Name__c = 'PRF__c';
        WTR55.Object_DML_Event__c = 'Insert';
        WTR55.Operation__c = 'Not Equal To';
        WTR55.Rule_Number__c = 1;
        WTR55.Value__c = '';
        WTR55.Workplan_Task_Template__c = WTT55.id;
        WTR55.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR55);   
          
        Workplan_Task_Rules__c WTR2 = new Workplan_Task_Rules__c();
        WTR2.Field_API_Name__c = 'Zip_Code_Validation__c';
        WTR2.Object_API_Name__c = 'Benfit_Request_Form__c';
        WTR2.Object_DML_Event__c = 'Update';
        WTR2.Operation__c = 'Not Equal To';
        WTR2.Rule_Number__c = 2;
        WTR2.Value__c = '';
        WTR2.Workplan_Task_Template__c = WTT.id;
        WTR2.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR2);
        Workplan_Task_Rules__c WTR25 = new Workplan_Task_Rules__c();
        WTR25.Field_API_Name__c = 'Zip_Code_Validation__c';
        WTR25.Object_API_Name__c = 'AIA_Implementation__c';
        WTR25.Object_DML_Event__c = 'Update';
        WTR25.Operation__c = 'Not Equal To';
        WTR25.Rule_Number__c = 2;
        WTR25.Value__c = '';
        WTR25.Workplan_Task_Template__c = WTT50.id;
        WTR25.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR25); 
        
        Workplan_Task_Rules__c WTR3 = new Workplan_Task_Rules__c();
        WTR3.Field_API_Name__c = 'Legal_Account_Name_Verified__c';
        WTR3.Object_API_Name__c = 'Opportunity';
        WTR3.Object_DML_Event__c = 'Update';
        WTR3.Operation__c = 'Equal To';
        WTR3.Rule_Number__c = 1;
        WTR3.Value__c = 'True';
        WTR3.Workplan_Task_Template__c = WTT4.id;
        WTR3.Criteria_Type__c = 'Task Completion Criteria';

        WTRList.add(WTR3);
          
        Workplan_Task_Rules__c WTR52 = new Workplan_Task_Rules__c();
        WTR52.Field_API_Name__c = 'Name';
        WTR52.Object_API_Name__c = 'AIA_Benefit_Design__c';
        WTR52.Object_DML_Event__c = 'Update';
        WTR52.Operation__c = 'Not Equal To';
        WTR52.Rule_Number__c = 1;
        WTR52.Value__c = '';
        WTR52.Workplan_Task_Template__c = WTT52.id;
        WTR52.Criteria_Type__c = 'Task Completion Criteria';
        WTRList.add(WTR52);
          
        Workplan_Task_Rules__c WTR41 = new Workplan_Task_Rules__c();
        WTR41.Field_API_Name__c = 'Legal_Account_Name_Verified__c';
        WTR41.Object_API_Name__c = 'Opportunity';
        WTR41.Object_DML_Event__c = 'Update';
        WTR41.Operation__c = 'Equal To';
        WTR41.Rule_Number__c = 2;
        WTR41.Value__c = 'False';
        WTR41.Workplan_Task_Template__c = WTT4.id;
        WTR41.Criteria_Type__c = 'Task Completion Criteria';

        WTRList.add(WTR41);
        Workplan_Task_Rules__c WTR42 = new Workplan_Task_Rules__c();
        WTR42.Field_API_Name__c = 'Legal_Account_Name_Verified__c';
        WTR42.Object_API_Name__c = 'Opportunity';
        WTR42.Object_DML_Event__c = 'Update';
        WTR42.Operation__c = 'Equal To';
        WTR42.Rule_Number__c = 1;
        WTR42.Value__c = 'True';
        WTR42.Workplan_Task_Template__c = WTT4.id;
        WTR42.Criteria_Type__c = 'Task Completion Criteria';
        WTRList.add(WTR42);
        
        Workplan_Task_Rules__c WTR43 = new Workplan_Task_Rules__c();
        WTR43.Field_API_Name__c = 'Legal_Account_Name_Verified__c';
        WTR43.Object_API_Name__c = 'Opportunity';
        WTR43.Object_DML_Event__c = 'Update';
        WTR43.Operation__c = 'Not Equal To';
        WTR43.Rule_Number__c = 2;
        WTR43.Value__c = 'False';
        WTR43.Workplan_Task_Template__c = WTT4.id;
        WTR43.Criteria_Type__c = 'Task Completion Criteria';
        WTRList.add(WTR43); 
          
        Workplan_Task_Rules__c WTR44 = new Workplan_Task_Rules__c();
        WTR44.Field_API_Name__c = 'Legal_Account_Name_Verified__c';
        WTR44.Object_API_Name__c = 'Benfit_Request_Form__c';
        WTR44.Object_DML_Event__c = 'Update';
        WTR44.Operation__c = 'Not Equal To';
        WTR44.Rule_Number__c = 2;
        WTR44.Value__c = 'True';
        WTR44.Workplan_Task_Template__c = WTT4.id;
        WTR44.Criteria_Type__c = 'Task Completion Criteria';
        WTRList.add(WTR44);   
          
        Workplan_Task_Rules__c WTR45 = new Workplan_Task_Rules__c();
        WTR45.Field_API_Name__c = 'Legal_Account_Name_Verified__c';
        WTR45.Object_API_Name__c = 'Benfit_Request_Form__c';
        WTR45.Object_DML_Event__c = 'Update';
        WTR45.Operation__c = 'Equal To';
        WTR45.Rule_Number__c = 2;
        WTR45.Value__c = 'True';
        WTR45.Workplan_Task_Template__c = WTT4.id;
        WTR45.Criteria_Type__c = 'Task Completion Criteria';
        WTRList.add(WTR45);  
       Workplan_Task_Rules__c WTR46 = new Workplan_Task_Rules__c();
        WTR46.Field_API_Name__c = 'Document_Type__c';
        WTR46.Object_API_Name__c = 'AIA_Document__c';
        WTR46.Object_DML_Event__c = 'Insert';
        WTR46.Operation__c = 'Equal To';
        WTR46.Rule_Number__c = 1;
        WTR46.Value__c = 'Cede Document';
        WTR46.Workplan_Task_Template__c = WTT4.id;
        WTR46.Criteria_Type__c = 'Task Completion Criteria';
        WTRList.add(WTR46);  
        Workplan_Task_Rules__c WTR56 = new Workplan_Task_Rules__c();
        WTR56.Field_API_Name__c = 'Document_Type__c';
        WTR56.Object_API_Name__c = 'AIA_Document__c';
        WTR56.Object_DML_Event__c = 'Insert';
        WTR56.Operation__c = 'Equal To';
        WTR56.Rule_Number__c = 1;
        WTR56.Value__c = 'Cede Document';
        WTR56.Workplan_Task_Template__c = WTT58.id;
        WTR56.Criteria_Type__c = 'Task Completion Criteria';
        WTRList.add(WTR56);   
       Workplan_Task_Rules__c WTR47 = new Workplan_Task_Rules__c();
        WTR47.Field_API_Name__c = 'Document_Type__c';
        WTR47.Object_API_Name__c = 'AIA_Document__c';
        WTR47.Object_DML_Event__c = 'Insert';
        WTR47.Operation__c = 'Not Equal To';
        WTR47.Rule_Number__c = 3;
        WTR47.Value__c = 'Cede Document';
        WTR47.Workplan_Task_Template__c = WTT4.id;
        WTR47.Criteria_Type__c = 'Task Completion Criteria';
        WTRList.add(WTR47);  
          
        Workplan_Task_Rules__c WTR4 = new Workplan_Task_Rules__c();
        WTR4.Field_API_Name__c = 'Legal_Account_Name_Verified__c';
        WTR4.Object_API_Name__c = 'Opportunity';
        WTR4.Object_DML_Event__c = 'Update';
        WTR4.Operation__c = 'Equal To';
        WTR4.Rule_Number__c = 2;
        WTR4.Value__c = 'False';
        WTR4.Workplan_Task_Template__c = WTT5.id;
        WTR4.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR4); 
        Workplan_Task_Rules__c WTR5 = new Workplan_Task_Rules__c();
        WTR5.Field_API_Name__c = 'Jurisdiction__c';
        WTR5.Object_API_Name__c = 'Benfit_Request_Form__c';
        WTR5.Object_DML_Event__c = 'Insert';
        WTR5.Operation__c = 'Not Equal To';
        WTR5.Rule_Number__c = 1;
        WTR5.Value__c = 'VA';
        WTR5.Workplan_Task_Template__c = WTT3.id;
        WTR5.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR5);
        
        Workplan_Task_Rules__c WTR6 = new Workplan_Task_Rules__c();
        WTR6.Field_API_Name__c = 'Document_Type__c';
        WTR6.Object_API_Name__c = 'AIA_Document__c';
        WTR6.Object_DML_Event__c = 'Insert';
        WTR6.Operation__c = 'Equal To';
        WTR6.Rule_Number__c = 2;
        WTR6.Value__c = 'Cede Document';
        WTR6.Workplan_Task_Template__c = WTT3.id;
        WTR6.Criteria_Type__c = 'Task Completion Criteria';

        WTRList.add(WTR6);
        
        Workplan_Task_Rules__c WTR7 = new Workplan_Task_Rules__c();
        WTR7.Field_API_Name__c = 'Document_Type__c';
        WTR7.Object_API_Name__c = 'AIA_Document__c';
        WTR7.Object_DML_Event__c = 'Update';
        WTR7.Operation__c = 'Equal To';
        WTR7.Rule_Number__c = 2;
        WTR7.Value__c = 'CEDE Document';
        WTR7.Workplan_Task_Template__c = WTT5.id;
        WTR7.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR7);
        
        Workplan_Task_Rules__c WTR8 = new Workplan_Task_Rules__c();
        WTR8.Field_API_Name__c = 'Document_Type__c';
        WTR8.Object_API_Name__c = 'AIA_Document__c';
        WTR8.Object_DML_Event__c = 'Insert';
        WTR8.Operation__c = 'Not Equal To';
        WTR8.Rule_Number__c = 1;
        WTR8.Value__c = '';
        WTR8.Workplan_Task_Template__c = WTT4.id;
        WTR8.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR8);
        
        Workplan_Task_Rules__c WTR90 = new Workplan_Task_Rules__c();
        WTR90.Field_API_Name__c = 'Jurisdiction__c';
        WTR90.Object_API_Name__c = 'Benfit_Request_Form__c';
        WTR90.Object_DML_Event__c = 'Insert';
        WTR90.Operation__c = 'Equal To';
        WTR90.Rule_Number__c = 1;
        WTR90.Value__c = 'VA';
        WTR90.Workplan_Task_Template__c = WTT5.id;
        WTR90.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR90);
        
          Workplan_Task_Rules__c WTR903 = new Workplan_Task_Rules__c();
        WTR903.Field_API_Name__c = 'Zip_Code_Validation__c';
        WTR903.Object_API_Name__c = 'Benfit_Request_Form__c';
        WTR903.Object_DML_Event__c = 'Update';
        WTR903.Operation__c = 'Not Equal To';
        WTR903.Rule_Number__c = 2;
        WTR903.Value__c = '';
        WTR903.Workplan_Task_Template__c = WTT5.id;
        WTR903.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR903);
        Workplan_Task_Rules__c WTR902 = new Workplan_Task_Rules__c();
        WTR902.Field_API_Name__c = 'Zip_Code_Validation__c';
        WTR902.Object_API_Name__c = 'Benfit_Request_Form__c';
        WTR902.Object_DML_Event__c = 'Update';
        WTR902.Operation__c = 'Not Equal To';
        WTR902.Rule_Number__c = 2;
        WTR902.Value__c = '';
        WTR902.Workplan_Task_Template__c = WTT0.id;
        WTR902.Criteria_Type__c = 'Task Creation Criteria';

        WTRList.add(WTR902);
        
        insert WTRList;
        
        List<Workplan_Task__c> WTList = new List<Workplan_Task__c>();
        Workplan_Task__c WT = new Workplan_Task__c();
        WT.AccountID__c = a.id;
        WT.Description__c = 'Verify Account Legal Name';
        WT.Opportunity__c = o.id;
        WT.RelatedObjectId__c = o.id;
        WT.Status__c = 'Not Started';
        WT.Task_Owner__c = 'Ancillary Analyst';
        WT.Task_Owner_Type__c = 'Account Team Role';
        WT.Workplan_Task_Template__c = WTT4.id;
        WTList.add(WT);
        Workplan_Task__c WTa1 = new Workplan_Task__c();
        WTa1.AccountID__c = a.id;
        WTa1.Description__c = 'Verify Account Legal Name';
        WTa1.Opportunity__c = opp1.id;
        WTa1.RelatedObjectId__c = o.id;
        WTa1.Status__c = 'Not Started';
        WTa1.Task_Owner__c = 'Ancillary Analyst';
        WTa1.Task_Owner_Type__c = 'Account Team Role';
        WTa1.Workplan_Task_Template__c = WTT4.id;
        WTList.add(WTa1);
        Workplan_Task__c WT1 = new Workplan_Task__c();
        WT1.AccountID__c = a.id;
        WT1.Description__c = 'Verify Account Legal Name';
        WT1.Opportunity__c = o.id;
        WT1.RelatedObjectId__c = o.id;
        WT1.Status__c = 'Not Started';
        WT1.Task_Owner__c = 'Ancillary Analyst';
        WT1.Task_Owner_Type__c = 'QUEUE';
        WT1.Send_Notification__c=True;
        WT1.Workplan_Task_Template__c = WTT5.id;
        WTList.add(WT1);
        Workplan_Task__c WT1a1 = new Workplan_Task__c();
        WT1a1.AccountID__c = a.id;
        WT1a1.Description__c = 'Verify Account Legal Name';
        WT1a1.Opportunity__c = opp1.id;
        WT1a1.RelatedObjectId__c = o.id;
        WT1a1.Status__c = 'Not Started';
        WT1a1.Task_Owner__c = 'Ancillary Analyst';
        WT1a1.Task_Owner_Type__c = 'QUEUE';
        WT1a1.Send_Notification__c=True;
        WT1a1.Workplan_Task_Template__c = WTT5.id;
        WTList.add(WT1a1);
        Workplan_Task__c WT2 = new Workplan_Task__c();
        WT2.AccountID__c = a.id;
        WT2.Description__c = 'Verify Account Legal Name';
        WT2.Opportunity__c = o.id;
        WT2.RelatedObjectId__c = nbrf.id;
        WT2.Status__c = 'Not Started';
        WT2.Task_Owner__c = 'Ancillary Analyst';
        WT2.Task_Owner_Type__c = 'QUEUE';
        WT2.Send_Notification__c=True;
        WT2.Workplan_Task_Template__c = WTT50.id;
        WTList.add(WT2);
         Workplan_Task__c WT2a = new Workplan_Task__c();
        WT2a.AccountID__c = a.id;
        WT2a.Description__c = 'Verify Account Legal Name';
        WT2a.Opportunity__c = opp1.id;
        WT2a.RelatedObjectId__c = nbrf.id;
        WT2a.Status__c = 'Not Started';
        WT2a.Task_Owner__c = 'Ancillary Analyst';
        WT2a.Task_Owner_Type__c = 'QUEUE';
        WT2a.Send_Notification__c=True;
        WT2a.Workplan_Task_Template__c = WTT50.id;
        WTList.add(WT2a);
        Workplan_Task__c WT3 = new Workplan_Task__c();
        WT3.AccountID__c = a.id;
        WT3.Description__c = 'Verify Account Legal Name';
        WT3.Opportunity__c = o.id;
        WT3.RelatedObjectId__c = imp.id;
        WT3.Status__c = 'Not Started';
        WT3.Task_Owner__c = 'Ancillary Analyst';
        WT3.Task_Owner_Type__c = 'QUEUE';
        WT3.Send_Notification__c=True;
        WT3.Workplan_Task_Template__c = WTT50.id;
        WTList.add(WT3);
        Workplan_Task__c WT3a = new Workplan_Task__c();
        WT3a.AccountID__c = a.id;
        WT3a.Description__c = 'Verify Account Legal Name';
        WT3a.Opportunity__c = opp1.id;
        WT3a.RelatedObjectId__c = imp.id;
        WT3a.Status__c = 'Not Started';
        WT3a.Task_Owner__c = 'Ancillary Analyst';
        WT3a.Task_Owner_Type__c = 'QUEUE';
        WT3a.Send_Notification__c=True;
        WT3a.Workplan_Task_Template__c = WTT50.id;
        WTList.add(WT3a);
       Workplan_Task__c WT4 = new Workplan_Task__c();
        WT4.AccountID__c = a.id;
        WT4.Description__c = 'Verify Account Legal Name';
        WT4.Opportunity__c = o.id;
        WT4.RelatedObjectId__c = aiaDoc.id;
        WT4.Status__c = 'Not Started';
        WT4.Task_Owner__c = 'Ancillary Analyst';
        WT4.Task_Owner_Type__c = 'QUEUE';
        WT4.Send_Notification__c=True;
        WT4.Workplan_Task_Template__c = WTT51.id;
        WTList.add(WT4);
        Workplan_Task__c WT4a = new Workplan_Task__c();
        WT4a.AccountID__c = a.id;
        WT4a.Description__c = 'Verify Account Legal Name';
        WT4a.Opportunity__c = opp1.id;
        WT4a.RelatedObjectId__c = aiaDoc.id;
        WT4a.Status__c = 'Not Started';
        WT4a.Task_Owner__c = 'Ancillary Analyst';
        WT4a.Task_Owner_Type__c = 'QUEUE';
        WT4a.Send_Notification__c=True;
        WT4a.Workplan_Task_Template__c = WTT51.id;
        WTList.add(WT4a);
          Workplan_Task__c WT42 = new Workplan_Task__c();
        WT42.AccountID__c = a.id;
        WT42.Description__c = 'Verify Account Legal Name';
        WT42.Opportunity__c = o.id;
        WT42.RelatedObjectId__c = aiaDoc1.id;
        WT42.Status__c = 'Not Started';
        WT42.Task_Owner__c = 'Ancillary Analyst';
        WT42.Task_Owner_Type__c = 'QUEUE';
        WT42.Send_Notification__c=True;
        WT42.Workplan_Task_Template__c = WTT58.id;
        WTList.add(WT42);
         Workplan_Task__c WT42a = new Workplan_Task__c();
        WT42a.AccountID__c = a.id;
        WT42a.Description__c = 'Verify Account Legal Name';
        WT42a.Opportunity__c = opp1.id;
        WT42a.RelatedObjectId__c = aiaDoc1.id;
        WT42a.Status__c = 'Not Started';
        WT42a.Task_Owner__c = 'Ancillary Analyst';
        WT42a.Task_Owner_Type__c = 'QUEUE';
        WT42a.Send_Notification__c=True;
        WT42a.Workplan_Task_Template__c = WTT58.id;
        WTList.add(WT42a);           
           
                     
          
        insert WTList;
        
         System.debug('Total Number of SOQL Queries allowed in after inserting WPT line 880>>: ' +  Limits.getLimitQueries()); 
        
        Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
        DWT.Dependent_Task__c = WTT2.id;
        DWT.Primary_Task__c = WTT3.id;
        
        insert DWT;
      Test.stopTest();
    }
    
    }
    
    
    
    
    
    
    static testMethod void testAIAWorkplanOnBRFdoc1() {
        
        test.starttest();
        
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        checkRecursive.runOnce();
        AIA_ProposedProductsHandler.firstRun = true;
        
        string IMPQuery = QueryBase2.getSobjectAllFieldsSOQL('AIA_Implementation__c','Id != NULL ');
        List<AIA_Implementation__c> IMPList = Database.query(IMPQuery);
        
       
        
        string AIADocQuery = QueryBase2.getSobjectAllFieldsSOQL('AIA_Document__c','Id != NULL ');
        list<AIA_Document__c> lstaiaDoc = Database.query(AIADocQuery);
        map<id,AIA_Document__c>  mapaiaDoc = new map<id,AIA_Document__c>();
        for(AIA_Document__c doc:lstaiaDoc){
            mapaiaDoc.put(doc.id,doc);
        }
          
        string WTTQuery = QueryBase2.getSobjectAllFieldsSOQL('Workplan_Task_Template__c','Id != NULL ');
        List<Workplan_Task_Template__c> WTTList = Database.query(WTTQuery);
        
        string WTRQuery = QueryBase2.getSobjectAllFieldsSOQL('Workplan_Task_Rules__c','Id != NULL ');
        List<Workplan_Task_Rules__c> WTRList = Database.query(WTRQuery);
        
        string DWTQuery = QueryBase2.getSobjectAllFieldsSOQL('Dependent_Workplan_Task__c','Id != NULL ');
        List<Dependent_Workplan_Task__c> DWTList = Database.query(DWTQuery);
        
        string WTQuery = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Workplan_Task__c','Id != NULL and Task_Owner_Type__c = \'Account Team Role\'','Workplan_Task_Template__r.Queue_Name__c,');
        List<Workplan_Task__c> WTList = Database.query(WTQuery);
        WTList[0].Status__c = 'Completed';
        update WTList[0];
        
        AIA_Workplan_Task_Management aiaworkplan = new AIA_Workplan_Task_Management();
        AIA_WorkPlanTasks_Completion aiataskcompletion = new AIA_WorkPlanTasks_Completion();
        //AIA_Workplan_SendEmail aiasendemail = new AIA_Workplan_SendEmail();
        //AIA_WorkPlanTaskTriggerHelper.createTasks(WTList);
        
       aiaworkplan.createWorkplanTasksForSObject('Insert',mapaiaDoc,'AIA_Document__c');
       aiataskcompletion.completionWorkplanTasksForAIADocument('Insert',lstaiaDoc,'AIA_Document__c');  
       
        test.stoptest();
    }
    
    static testMethod void testAIAWorkplanOnBRF() {
        
        test.starttest();
        
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        checkRecursive.runOnce();
        AIA_ProposedProductsHandler.firstRun = true;
        
        string IMPQuery = QueryBase2.getSobjectAllFieldsSOQL('AIA_Implementation__c','Id != NULL ');
        List<AIA_Implementation__c> IMPList = Database.query(IMPQuery);
        
        string AIADocQuery = QueryBase2.getSobjectAllFieldsSOQL('AIA_Document__c','Id != NULL ');
        list<AIA_Document__c> lstaiaDoc = Database.query(AIADocQuery);
        lstaiaDoc[0].implementation__c=IMPList[0].id;
        update  lstaiaDoc[0];  
        map<id,AIA_Document__c>  mapaiaDoc = new map<id,AIA_Document__c>();
        for(AIA_Document__c doc:lstaiaDoc){
            mapaiaDoc.put(doc.id,doc);
        }
         
        string WTTQuery = QueryBase2.getSobjectAllFieldsSOQL('Workplan_Task_Template__c','Id != NULL ');
        List<Workplan_Task_Template__c> WTTList = Database.query(WTTQuery);
        
        string WTRQuery = QueryBase2.getSobjectAllFieldsSOQL('Workplan_Task_Rules__c','Id != NULL ');
        List<Workplan_Task_Rules__c> WTRList = Database.query(WTRQuery);
        
        string DWTQuery = QueryBase2.getSobjectAllFieldsSOQL('Dependent_Workplan_Task__c','Id != NULL ');
        List<Dependent_Workplan_Task__c> DWTList = Database.query(DWTQuery);
        
        string WTQuery = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Workplan_Task__c','Id != NULL and Task_Owner_Type__c = \'Account Team Role\'','Workplan_Task_Template__r.Queue_Name__c,');
        List<Workplan_Task__c> WTList = Database.query(WTQuery);
        WTList[0].Status__c = 'NotRequired';
        update WTList[0];
        
        AIA_Workplan_Task_Management aiaworkplan = new AIA_Workplan_Task_Management();
        AIA_WorkPlanTasks_Completion aiataskcompletion = new AIA_WorkPlanTasks_Completion();
       
        aiaworkplan.createWorkplanTasksForSObject('Insert',mapaiaDoc,'AIA_Document__c');
        aiataskcompletion.completionWorkplanTasksForAIADocument('Insert',lstaiaDoc,'AIA_Document__c');
        
        test.stoptest();
    }
 
    static testMethod void testAIAWorkplanOnIMP() {
        
        
        
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        checkRecursive.runOnce();
        AIA_ProposedProductsHandler.firstRun = true;
        
        string IMPQuery = QueryBase2.getSobjectAllFieldsSOQL('AIA_Implementation__c','Id != NULL ');
        List<AIA_Implementation__c> IMPList = Database.query(IMPQuery);
        map<id,AIA_Implementation__c>  mapImp = new map<id,AIA_Implementation__c>();
        for(AIA_Implementation__c imp:IMPList){
            mapImp.put(imp.id,imp);
        }
       
         
        test.starttest();
        
        AIA_Workplan_Task_Management aiaworkplan = new AIA_Workplan_Task_Management();
        
        aiaworkplan.createWorkplanTasksForSObject('Insert',mapImp,'AIA_Implementation__c');
      
      
                
        test.stoptest();
    }
  
  	static testMethod void testAIAWorkplanOnIMPNew() {
        
        
        
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        checkRecursive.runOnce();
        AIA_ProposedProductsHandler.firstRun = true;
        
        string IMPQuery = QueryBase2.getSobjectAllFieldsSOQL('AIA_Implementation__c','Id != NULL ');
        List<AIA_Implementation__c> IMPList = Database.query(IMPQuery);
        Opportunity opp = [Select Id,Business_Type__c from Opportunity where Id =: IMPList[0].opportunity__c Limit 1];
        opp.Business_Type__c = 'New';
        update opp;
        map<id,AIA_Implementation__c>  mapImp = new map<id,AIA_Implementation__c>();
        for(AIA_Implementation__c imp:IMPList){
            mapImp.put(imp.id,imp);
        }
       
         
        test.starttest();
        
        AIA_Workplan_Task_Management aiaworkplan = new AIA_Workplan_Task_Management();
        
        aiaworkplan.createWorkplanTasksForSObject('Insert',mapImp,'AIA_Implementation__c');
      
        opp.Business_Type__c = 'Renewal';
        update opp;
                
        test.stoptest();
    }
  
   static testMethod void testAIAWorkplanOnBRFdocNew() {
        
        test.starttest();
        
        AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();
        checkRecursive.runOnce();
        AIA_ProposedProductsHandler.firstRun = true;
        
        string IMPQuery = QueryBase2.getSobjectAllFieldsSOQL('AIA_Implementation__c','Id != NULL ');
        List<AIA_Implementation__c> IMPList = Database.query(IMPQuery);
        Opportunity opp = [Select Id,Business_Type__c,AccountId from Opportunity where Id =: IMPList[0].opportunity__c Limit 1];
        opp.Business_Type__c = 'New';
        update opp;
       
        
        string AIADocQuery = QueryBase2.getSobjectAllFieldsSOQL('AIA_Document__c','Id != NULL ');
        list<AIA_Document__c> lstaiaDoc = Database.query(AIADocQuery);
        map<id,AIA_Document__c>  mapaiaDoc = new map<id,AIA_Document__c>();
        for(AIA_Document__c doc:lstaiaDoc){
            mapaiaDoc.put(doc.id,doc);
        }
        string WTTQuery = QueryBase2.getSobjectAllFieldsSOQL('Workplan_Task_Template__c','Id != NULL ');
        List<Workplan_Task_Template__c> WTTList = Database.query(WTTQuery);
        for(Workplan_Task_Template__c WTT:WTTList)
        {
            WTT.Acc_Team_Role_for_New_Business__c = 'Account Manager';
            WTT.Acc_Team_Role_for_Renewal_Business__c = 'Account Manager';
        }
       update WTTList;
        
        /*string WTRQuery = QueryBase2.getSobjectAllFieldsSOQL('Workplan_Task_Rules__c','Id != NULL ');
        List<Workplan_Task_Rules__c> WTRList = Database.query(WTRQuery);
        
        string DWTQuery = QueryBase2.getSobjectAllFieldsSOQL('Dependent_Workplan_Task__c','Id != NULL ');
        List<Dependent_Workplan_Task__c> DWTList = Database.query(DWTQuery);
        
        string WTQuery = QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Workplan_Task__c','Id != NULL and Task_Owner_Type__c = \'Account Team Role\'','Workplan_Task_Template__r.Queue_Name__c,');
        List<Workplan_Task__c> WTList = Database.query(WTQuery);
        WTList[0].Status__c = 'Completed';
        update WTList[0];*/
        
        AIA_Workplan_Task_Management aiaworkplan = new AIA_Workplan_Task_Management();
        aiaworkplan.createWorkplanTasksForSObject('Insert',mapaiaDoc,'AIA_Document__c');
        opp.Business_Type__c = 'Renewal';
        update opp; 
        
        test.stoptest();
    }
    
    
  
}