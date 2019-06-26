/*=========================================================================================
* 							Update History
* Date         Developer     Tag          Description
*==================================================================================
*02/05/2019		Chaithra	 |T02|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================
*/
@isTest
private class AIA_Add_Products_On_BRF_Cls_test{
    
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
        
        //T02 Starts
        /*List<AccountTeamMember> accTeamMemberLst = new List<AccountTeamMember>();
        AccountTeamMember atmRole2 = new AccountTeamMember ();
        atmRole2.TeamMemberRole = 'Contract Tech';
        atmRole2.AccountId =a.id;
        atmRole2.UserId = user.id;
        //accTeamMemberLst.add(atmRole2);
        insert atmRole2;*/
        List<Account_Team__c> accTeamMemberLst =new List<Account_Team__c>();
        Account_Team__c atmRole2=new Account_Team__c();
        atmRole2.AccountId__c=a.id;
        atmRole2.TeamMemberRole__c='Contract Tech';
        atmRole2.UserId__c=user.id;
        //T02 Ends
        //T01
        /*AccountTeamMember atmRole3 = new AccountTeamMember ();
        atmRole3.TeamMemberRole = 'Account Manager';
        atmRole3.AccountId =a.id;
        atmRole3.UserId = user.id;
        //accTeamMemberLst.add(atmRole3);
        insert atmRole3;
        
        AccountTeamMember atmRole4 = new AccountTeamMember ();
        atmRole4.TeamMemberRole = 'Account Executive';
        atmRole4.AccountId =a.id;
        atmRole4.UserId = user.id;
        // accTeamMemberLst.add(atmRole4);
        insert atmRole4;
        //insert accTeamMemberLst;*/
        
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        o.Business_Type__c = 'New';
        update o;
        
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = a.id;
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
      nbrf.Formulary__c = '1';
        nbrf.Enrollment_Type__c = 'Cafeteria';
        nbrf.Opportunity__c = o.id;
        insert nbrf;
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = a.id;
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
      brf.Formulary__c = '1';
        brf.Enrollment_Type__c = 'Cafeteria';
        brf.Opportunity__c = o.id;
        insert brf;
        system.debug('In CreateTestData - Before starttest- getAggregateQueries--'+Limits.getAggregateQueries());
        system.debug('In CreateTestData - Before starttest- getLimitAggregateQueries--'+Limits.getLimitAggregateQueries());
        Test.startTest();
        system.debug('In CreateTestData - After starttest- getAggregateQueries--'+Limits.getAggregateQueries());
        system.debug('In CreateTestData - After starttest- getLimitAggregateQueries--'+Limits.getLimitAggregateQueries());
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        //Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        imp.Account__c=a.id;
        imp.Benefit_Request_Form__c=nbrf.id;
        insert Imp;
        
      
       
        
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
        Proposed_Products__c pp1= AIA_TestUtil.createBRFProposedProducts(brf.id, plantest.id, 'Drug');
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
        pp0.ARC_check__c =true; // added by raj for code coverage
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
        
        pp1.Product_Financial_Arrangement__c = 'Risk';
    
        insert pp0;
        insert pp1;
       
        Test.stopTest();
    }
    
    static testMethod void Test1()
    {
        Test.startTest();
        String brfQuery = QueryBase2.getSobjectAllFieldsSOQL('Benfit_Request_Form__c','Id != NULL limit 1');
        Benfit_Request_Form__c nbrf = Database.query(brfQuery);
                
        String ppQuery = QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c','Id != NULL limit 1');
        Proposed_Products__c pp0 = Database.query(ppQuery);
        list<Proposed_Products__c> relatedPPList = new list<Proposed_Products__c>();
        relatedPPList.add(pp0);
        
        String planQuery = QueryBase2.getSobjectAllFieldsSOQL('AIA_Plan__c','Id != NULL limit 1');
        AIA_Plan__c plan = Database.query(planQuery);
        
        AIA_Grouper__c grouper= AIA_TestUtil.createGrouper(pp0.id+'');
        AIA_RxMandate__c testRxMandate = AIA_TestUtil.createRxMandate(pp0.id+'');
        testRxMandate.Mandate_Apply__c = True;
        upsert testRxMandate;
        
        AIA_Benefits__c benefits = AIA_TestUtil.createBenefit(grouper.Id);   
        Limitations__c comments = AIA_TestUtil.createBenefitComentCode(benefits.Id, True ,'Comment');
        insert comments;
                
        Proposed_Products__c pp1= AIA_TestUtil.createBRFProposedProducts(nbrf.Id,plan.id, 'Drug');
        insert pp1;
        String ppQuery2 = QueryBase2.getSobjectAllFieldsSOQL('Proposed_Products__c','Id != NULL ');
        List<Proposed_Products__c> pplist = Database.query(ppQuery2);
        //pp1.PP_REcordtypeDeveloperName__c='Drug';
        //update pp1;
        relatedPPList.clear();
        relatedPPList.addAll(pplist);
        
         PageReference pageRef = Page.AIA_ADD_PRODUCTS_ON_BRF;
            Test.setCurrentPage(pageRef);       
            ApexPages.currentPage().getParameters().put('id', nbrf.Id);
           // ApexPages.currentPage().getParameters().put('fileContents', 'Test Content');
            
            List<AIA_ADD_PRODUCTS_ON_BRF_CLS.MainWrapper> PageLst = new List<AIA_ADD_PRODUCTS_ON_BRF_CLS.MainWrapper>();
            for(Proposed_Products__c pp: ppList){                
                PageLst.add(new AIA_ADD_PRODUCTS_ON_BRF_CLS.MainWrapper(pp));
            }
            
            AIA_ADD_PRODUCTS_ON_BRF_CLS controller = new AIA_ADD_PRODUCTS_ON_BRF_CLS();    
            for(AIA_ADD_PRODUCTS_ON_BRF_CLS.MainWrapper mw1:PageLst){
                mw1.Selected = true;                 
            }
            AIA_Document__c aiaDoc = new AIA_Document__c();
            aiaDoc.Document_Status__c = 'Complete';
            aiaDoc.Document_Type__c = 'Signed Quote';
            aiaDoc.Active__c = True;
            aiadoc.Document_Name__c = 'Test';
            aiadoc.source__c = 'Benefit Request Form';
            aiaDoc.Start_Date__c = System.today();
            aiaDoc.End_Date__c = System.today()+10;
            aiaDoc.Approval_Status__c = 'Approved';
            aiaDoc.Proposed_Products__c = ppList[0].id;
            aiadoc.Benefit_Request_Form__c = nbrf.id;
            aiaDoc.Sub_Department__c = 'Benefits Summaries';
            insert aiaDoc;
        
            Attachment attch = AIA_TestUtil.createAttachment(aiaDoc.id);
            update aiaDoc;
            
            controller.selectedId = ppList[0].Id; 
            controller.selectedFlg = false;
            controller.AutoSelectAncillaryProducts();
            controller.selectedId = ppList[1].Id;
            controller.AutoSelectAncillaryProducts();
            controller.cloneSelRecords(PageLst, nbrf.Id); 
            controller.callSave();
            controller.backToBRF();
            controller.displayError('Test ErrorMsg');
            controller.cloneSelRecords(new List<AIA_Add_Products_On_BRF_Cls.MainWrapper>(), 'Testexception');
          controller.msg = 'Record Saved';
          controller.displayPopUp= true;
          controller.returnToBRF();
        Test.stopTest();
    }
    
    
    
}