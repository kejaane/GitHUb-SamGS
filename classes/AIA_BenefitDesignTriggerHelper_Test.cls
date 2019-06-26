@isTest
private class AIA_BenefitDesignTriggerHelper_Test{
    
    @testsetup static void CreateTestData()
    {
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        User user = new User(Alias = 'TAlias17', Email='TestUserBRF@testorg.com',
                             EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = pro.Id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.coma12');
        insert user;
        
        Account a = AIA_TestUtil.CreateAccount('Test Account');
        system.assertNotEquals(null,a.id);
        a.BillingState ='VA';
        update a;
        
        Account_Team__c atmRole2 = new Account_Team__c ();
        atmRole2.TeamMemberRole__c = 'Contract Tech';
        atmRole2.AccountId__c =a.id;
        atmRole2.UserId__c = user.id;
        insert atmRole2;
        
        
         /*R1 added teammember*/
   List<user> userList = new list<user>();
   user u14 = AIA_TestUtil.AIA_createUser('alias144');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias145');
        userList.add(u15);
       insert userlist;
       List<Account_Team__C> acctMbrList = new List<Account_Team__C>(); 
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u14.id,'Account Executive'));
 acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u15.id,'Account Manager'));
       
 insert acctMbrList;
/*R1 added teammember*/
        
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.Business_Type__c = 'New';
        update o;
        
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = a.id;
        //nbrf.ARC_Approval_Status__c = 'Approved by Committee'; //Modified as for validation error.
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
    nbrf.Formulary__c = '1';
        nbrf.Enrollment_Type__c = 'Cafeteria';
        nbrf.Opportunity__c = o.id;
        insert nbrf;
        system.debug('In CreateTestData - Before starttest- getAggregateQueries--'+Limits.getAggregateQueries());
        system.debug('In CreateTestData - Before starttest- getLimitAggregateQueries--'+Limits.getLimitAggregateQueries());
        Test.startTest();
        system.debug('In CreateTestData - After starttest- getAggregateQueries--'+Limits.getAggregateQueries());
        system.debug('In CreateTestData - After starttest- getLimitAggregateQueries--'+Limits.getLimitAggregateQueries());
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        imp.Account__c=a.id;
        imp.Benefit_Request_Form__c=nbrf.id;
        insert Imp;
        
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c=a.id;
        aiaBD.Benefit_Request_Form__c=nbrf.id;
        aiaBD.Approval_Status_Analyst__c='Approved';
        insert aiaBD;
        
        /*AIA_Benefit_Design_Form__c bdf= AIA_TestUtil.createBenefitDesignFormForBD(aiaBD, 'Domestic_Partner',Null);
        bdf.Stand_Alone_Disease_Management__c = 'No';
        bdf.Stand_Alone_Wellness__c = 'No';
        insert bdf;*/                                                               //commented for error 6-6-17
        
        List<AIA_Benefit_Design__c> bdList=new List<AIA_Benefit_Design__c>();
        bdList.add(aiaBD);  
       
        
   /*     AIA_Document__c aiadocBD=AIA_TestUtil.createAIADocument();
        aiadocBD.Benefit_Design__c=aiaBD.id;
        aiadocBD.Benefit_Design_Form__c=bdf.id;
        aiadocBD.Account__c=a.id;
        aiadocBD.Approval_Status__c='Pending';
        
        update aiadocBD; */
        
        AIA_Plan__c plantest= AIA_TestUtil.CreateGSMPlan('Drug', 'Drug-1');
        system.debug('In CreateTestData - Before PP Creation - getAggregateQueries--'+Limits.getAggregateQueries());
        system.debug('In CreateTestData - Before PP Creation - getLimitAggregateQueries--'+Limits.getLimitAggregateQueries());
        plantest.X05OptionsString__c = 'test';
        plantest.X06RenewalPeriodString__c = 'test';
        plantest.X07BenefitRenewsString__c = 'test';
        plantest.Magellan_Behavioral_Health__c = 'test';
        plantest.OON_Fully_Insured__c = 'test';
        plantest.INN_or_Contracted_Provider_Penalty__c = 'test';
        plantest.AllergySerums__c = 'Yes';
        plantest.DiabeticSuppCopayApply__c = 'Yes';
        plantest.DiabeticSuppDedApply__c = 'Yes';
        plantest.DiabeticSuppMandateApply__c = 'Yes';
        plantest.ErectileDysfunc__c = 'Yes';
        plantest.FertilityAgents__c = 'Yes';
        plantest.HBSelectGeneric__c = 'Waive Ded/Waive Copay (Standard)';
        plantest.GrowthHormone__c = 'Yes';
    plantest.Plan_Name__c  = 'Test Plan';
        plantest.MailOrdDispnsMaintDaysSupp__c = 5;
        plantest.MailOrdDispnsNMaintDaysSupp__c = 6;
        plantest.MailOrderAllDrugs__c = 'Yes';
        plantest.OralChemoCopayApply__c = 'Yes';
        plantest.OralChemoDedApply__c = 'Yes';
        if(plantest!=null)
            upsert plantest;
        
        
        Proposed_Products__c pp0= AIA_TestUtil.createBRFProposedProducts(nbrf.id, plantest.id, 'Medical'); 
        Proposed_Products__c pp1= AIA_TestUtil.createBRFProposedProducts(nbrf.id, plantest.id, 'Drug');
        //insert pp1;
        pp1.Related_Medical_Product__c = pp0.id;
    pp0.Dental_Product_Name__c = 'Preferred (PPO) Dental';
        pp0.Deductible__c='Stacked';
        pp0.Vision_Comments__c = 'test';
        pp0.Account_Specified_Vision_Product_Name__c = 'test';
        pp0.Vision_Benefit_Period__c = 'Other';
        pp0.Core_DM_Wellness__c = 'Yes';
        pp0.Benefits_Renew__c = 'Calendar year';
        pp0.Deductible_Applies__c = 'Standard';
        pp0.Orthodontia_Endorsement__c = 'Yes';
    pp0.Blue_Rewards__c = 'Standard';
    pp0.CDH__c = 'Yes';
    pp0.CDH_Fund_Type__c = 'BlueFund';
    pp0.CDH_Type__c = 'HSA';
        pp0.Dental_Variables_by_Product__c = 'Basic Services';
        pp0.Drug_Product_Options__c = 'ASO No Drug';
        pp0.Employer_Arrangement__c = 'Voluntary';
        pp0.Exchange_CDH_Fund_Type__c = 'BlueFund';
        pp0.Exchange_CDH_Type__c = 'HSA';
        pp0.Exchange_Package_Option__c = 'Dummy 1';
        pp0.Integrated_Non_Integrated__c = 'Integrated';
        pp0.Product_Financial_Arrangement__c = 'ASO';
        pp0.Generic_Drugs_Tier_1__c = 2;
        pp0.Grandfathered_ppACA_Status__c = 'Yes';
        pp0.Grandfathered_Status__c = 'Grandfathered';
        pp0.Integrated_Carved_Out_Vendor__c = 'CVS (Direct)';
        pp0.Integrated_Deductible_Integrator__c = 'Yes';
        //pp0.Integrated_Deductibles_and_OOPs1__c = 
        //pp0.Maintenance_Drugs__c 
        pp0.Maintenance_Choice__c = 'Mandatory';
        pp0.Maintenance_Choic_Comments__c = 'Test';
        pp0.Medical_Plan_Comments__c = 'Test';
        pp0.Medical_Product_Name__c = 'BlueChoice HMO';
        pp0.Medical_Product_Option__c = 'Fully Custom';
        //pp0.MHP_Test_Comments__c = 'Test';
        //pp0.MHP_Test_Completed_Date__c = Date.Today();
        pp0.Comments__c = 'Test';
        //pp0.MHP_Test_Completed_By__r.Name 
        //pp0.MHP_Test_Result__c = 'Pass';
        pp0.Network__c = 'Standard';
        pp0.Non_preferred_Brand_Drugs_Tier_3__c = 10;
        pp0.Account_Specified_Drug_Product_Name__c = 'Test';
        pp0.Account_Specified_Medical_Product_Name__c = 'Test';
        pp0.PDPD_ID__c = 'Test';
        pp0.Dental_Product_Options__c = 'Plan 1 (100/80/80/50 IN and 100/80/80/50 OON) - $1,500 max, $25 deductible and $1,500 ortho max or no ortho';
        pp0.BlueVision_Plus_Comments__c = 'Test';
        pp0.Other_Requirements__c = 'test';
        pp0.OralChemoMandateApply__c = 'Yes';
        pp0.Preferred_Brand_Drugs_Tier_2__c = 12;
        pp0.Preventive_Drugs_Affordable_Care_Act__c = 11;
        pp0.Cafeteria__c = true;
        pp0.Rider__c = 'None'; //Added to remove Rider__c error on proposed porduct 6-6-17
        
        pp1.Product_Financial_Arrangement__c = 'Risk';
        
        pp0.INN_and_OON_Annual_Maximum_combined__c = 'Yes'; //added by raj for code cover
        pp0.INN_and_OON_Lifetime_Maximum_combined__c = 'Yes'; //added by raj for code cover
        pp0.INN_and_OON_OOP_Contribute_To_Each_Other__c = 'Yes'; //added by raj for code cover
        pp0.Three_Month_Deductible__c = 'No'; //added by raj for code cover
        
        pp0.Maintenance_Drugs__c =90; //added by raj for code cover
        pp0.Vision_Product_Name__c = 'BlueVision (Core)'; //added by raj for code cover
        pp0.Out_of_Pocket_Max__c  = 'Stacked'; //added by raj for code cover
        pp0.Product_Line__c = 'POS'; //added by raj for code cover
        
        
        pp0.Non_Standard_Fee_Schedule_Comments__c ='XXXX'; //added by raj for code cover
        pp0.Product_Option__c = 'Option1'; //added by raj for code cover
        pp0.RX_OOP_Max_Integration__c  = 'Yes'; //added by raj for code cover
        pp0.Self_administered_Injectable_Tier_4__c = 90; //added by raj for code cover
        pp0.X06_Renewal_Period__c='07–12 Months'; //added by raj for code cover
        
        
        
        
    
        insert pp0;
        
        AIA_Benefit_Design_Product__c  bdp = AIA_TestUtil.createBDProductsForBD(bdList[0],'Drug',plantest.id,pp1.id);
        insert bdp;
        Test.stopTest();
    }
    
    static testMethod void createBenefitDesignProductTest()
    {
        Test.startTest();
        system.debug('In createBenefitDesignProductTest - After starttest- getAggregateQueries--'+Limits.getAggregateQueries());
        system.debug('In createBenefitDesignProductTest - After starttest- getLimitAggregateQueries--'+Limits.getLimitAggregateQueries());
        String bdQuery = QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefit_Design__c','Id != NULL');
        AIA_Benefit_Design__c aiaBD = Database.query(bdQuery);
        
        List<AIA_Benefit_Design__c> bdList=new List<AIA_Benefit_Design__c>();
        bdList.add(aiaBD);  
        
        String ppQuery = QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c','Id != NULL limit 1');
        Proposed_Products__c pp0 = Database.query(ppQuery);
        list<Proposed_Products__c> relatedPPList = new list<Proposed_Products__c>();
        relatedPPList.add(pp0);
        AIA_BenefitDesignTriggerHelper.updateAIADocument(bdList);
        Map<id,AIA_Benefit_Design__c> BDmap= new Map<id,AIA_Benefit_Design__c> ();
        BDmap.put(aiaBD.id, aiaBD);
        AIA_Grouper__c grouper= AIA_TestUtil.createGrouper(pp0.id+'');
        AIA_RxMandate__c testRxMandate = AIA_TestUtil.createRxMandate(pp0.id+'');
    testRxMandate.Mandate_Apply__c = True;
        upsert testRxMandate;
        
        AIA_Benefits__c benefits = AIA_TestUtil.createBenefit(grouper.Id);   
        Limitations__c comments = AIA_TestUtil.createBenefitComentCode(benefits.Id, True ,'Comment');
        insert comments;
        AIA_BenefitDesignTriggerHelper.createBenefitDesignProduct(BDmap);
        String bdpQuery = QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefit_Design_Product__c','Id != NULL limit 1');
        AIA_Benefit_Design_Product__c bdp = Database.query(bdpQuery);
        list<AIA_Benefit_Design_Product__c> newParentBDPList = new list<AIA_Benefit_Design_Product__c>();
        newParentBDPList.add(bdp);
        AIA_BenefitDesignTriggerHelper.getBDPList(relatedPPList,true,newParentBDPList,bdList);
        Proposed_Products__c pp1= AIA_TestUtil.createBRFProposedProducts(aiaBD.Benefit_Request_Form__c,bdp.Plan_Name__c, 'Drug');
        insert pp1;
        String ppQuery2 = QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c','Id != NULL ');
        List<Proposed_Products__c> pplist = Database.query(ppQuery2);
        //pp1.PP_REcordtypeDeveloperName__c='Drug';
        //update pp1;
        relatedPPList.clear();
        relatedPPList.addAll(pplist);
        
        AIA_BenefitDesignTriggerHelper.getBDPList(relatedPPList,true,newParentBDPList,bdList);
        Test.stopTest();
    }
    
    static testMethod void TestRevisionNumberUpdate()
    {
        
        Test.startTest();
        system.debug('In TestRevisionNumberUpdate - After starttest- getAggregateQueries--'+Limits.getAggregateQueries());
        system.debug('In TestRevisionNumberUpdate - After starttest- getLimitAggregateQueries--'+Limits.getLimitAggregateQueries());
        AIA_Implementation__c implOne = [Select Id,Benefit_Design_Revision_Number_Technical__c from AIA_Implementation__c limit 1];
        system.assertEquals(1, implOne.Benefit_Design_Revision_Number_Technical__c);
        
        AIA_Benefit_Design__c abd = [Select id,status__c from AIA_Benefit_Design__c limit 1];
        abd.status__c = 'Approved';
        update abd;
        
        AIA_Benefit_Design__c abdTEST = [Select id,Revision_number__c,status__c from AIA_Benefit_Design__c limit 1];
        system.assertEquals('SF - 1', abdTEST.Revision_number__c);
        
        Test.stopTest();
    }
    
    static testMethod void TestCalculateDaysDiffExcludingHoliday()
    {
        
        Test.startTest();
        system.debug('In TestCalculateDaysDiffExcludingHoliday--'+Limits.getAggregateQueries());
        system.debug('In TestCalculateDaysDiffExcludingHoliday - After starttest- getLimitAggregateQueries--'+Limits.getLimitAggregateQueries());
        AIA_Implementation__c implOne = [Select Id,Benefit_Design_Revision_Number_Technical__c from AIA_Implementation__c limit 1];
        system.assertEquals(1, implOne.Benefit_Design_Revision_Number_Technical__c);
        
        AIA_Benefit_Design__c abd = [Select id, status__c from AIA_Benefit_Design__c limit 1];
        abd.status__c = 'In Progress';
        abd.Ancillary_Tech_Approval_Start_Date__c = system.today();
        abd.Ancillary_Tech_Response_Date__c = system.today().adddays(5);
        abd.Contract_Tech_Approval_Start_Date__c = system.today();
        abd.Contract_Tech_Response_Date__c = system.today().adddays(2);
        abd.NASCO_Benefit_Coder_Approval_Start_Date__c = system.today();
        abd.NASCO_Benefit_Coder_Response_Date__c = system.today().adddays(3);
        abd.Benefact_Coder_Approval_Start_Date__c = system.today();
        abd.Benefact_Coder_Response_Date__c = system.today().adddays(4);
        abd.MAST_Tech_Approval_Start_Date__c = system.today();
        abd.MAST_Tech_Response_Date__c = system.today().adddays(1);
        abd.MAST_Tech_Response_Days__c = 'NA';
            
            update abd;
        abd.Contract_Tech_Approval_Start_Date__c = system.today().addDays(2);
        abd.Ancillary_Tech_Approval_Start_Date__c =system.today();
        abd.Ancillary_Tech_Response_Date__c = system.today().addDays(2);
       // abd.Approver_Ancillary_Analyst__c= userinfo.getUserId();
        update abd;
        
        AIA_Benefit_Design__c abdTEST = [Select id,Revision_number__c,status__c from AIA_Benefit_Design__c limit 1];
        system.assertEquals('SF - 1', abdTEST.Revision_number__c);
        
        holiday HL = new holiday();
        HL.Name = 'TestHoliday';
        HL.ActivityDate = system.today().addDays(20);
       //HL.ActivityDate = THIS_YEAR; 
       // List<Holiday> holidays = [Select Id From Holiday];
        //system.assert(holidays.size() == 0);

        
        Test.stopTest();
    }
    
}