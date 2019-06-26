/*****************************************************************************************************
 *Date: 03-07-2017
 *Developer: Bill Dodson
 *Purpose: Used to test the Benefit Design Product Trigger Handler class.
 *=========================================================================================
 * Update History
 * Date         Developer               Description
 *==================================================================================
 * 03-07-2017    Bill Dodson  |   |  Initial Development
 * 03-24-2017    Bill Dodson  |   |  Modify to work in QA environment.
 * 02-07-2019 	Chaithra 	  |T02| Replaced std AccountTeamMember with custom AccountTeamMember as per US1736 
 *==================================================================================

 *******************************************************************************************************/
@isTest
private class AIA_BenefitDesignProductTriggerHdlr_Test{
    
    @testSetup
    static void testdata()
    {
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u4;
        
        //System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        //Create Account
        Account acc =AIA_TestUtil.createAccount('TestOEMAcc');
        //Create Opportunity
        
        /*R1 added team members */ 
   List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        u1.Lead_Rep__c=true;
        /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('aliasmmm');
         userList.add(u2);
        insert userList;
   
   //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();T02
   List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'Account Manager')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Account Executive'));
      
        insert acctMbrList;
/*R1 added team members */

        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
        
        //System.debug('2.Number of Queries used in this apex code so far: ' + Limits.getQueries());            
        //T02 starts
        /*AccountTeamMember atm3 = new AccountTeamMember ();
        atm3.TeamMemberRole = 'Contract Tech';
        atm3.AccountId = acc.id;
        atm3.UserId = u4.id;
        insert atm3;*/
        Account_Team__c atm3 = new Account_Team__c();
        atm3.AccountId__c=acc.id;
        atm3.UserId__c=u4.id;
        atm3.TeamMemberRole__c='Contract Tech';
        insert atm3;
		//T02 Ends
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = acc.id;
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Opportunity__c = opp.id;
        nbrf.Jurisdiction__c = 'MD';
        insert nbrf;
        
        //System.debug('3.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
        
        //Create Benefit Design
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        insert Imp;
        
        //System.debug('4.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
         Test.startTest();
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = nbrf.Id;
        insert aiaBD;
        
        //System.debug('5.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c = aiaBD.id;
        insert aiaBDP1;  
        
        //System.debug('6.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();
        aiaBDP2.Benefit_Design__c = aiaBD.id;
        aiaBDP2.Related_Medical_Product__c = aiaBDP1.id;        
        insert aiaBDP2; 
        
        
        
        //System.debug('7.Number of Queries used in this apex code so far: ' + Limits.getQueries());                
        
        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = nbrf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom__c = false;
        aiaPP.Rider__c= 'Hearing Care Rider';
        insert aiaPP;
        
        // This had to be moved up because we were running out of SOQL queries from the inserts.
       
                
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
        insert aiaDoc1; 
        
        AIA_Grouper__c aiaGrpr = new AIA_Grouper__c();
        aiaGrpr.Benefit_Design_Product__c = aiaBDP1.id;
        aiaGrpr.Proposed_Products__c = aiaPP.id;
        insert aiaGrpr;
        
        AIA_Benefits__c aiaBen1 = new AIA_Benefits__c();
        aiaBen1.Grouper__c = aiaGrpr.id;
        insert aiaBen1;
        
        //System.debug('8.Number of Queries used in this apex code so far: ' + Limits.getQueries());        
        
        AIA_Benefits__c aiaBen2 = new AIA_Benefits__c();
        aiaBen2.Grouper__c = aiaGrpr.id;
        insert aiaBen2;         
        
        Limitations__c aiaLm1 = new Limitations__c();
        aiaLm1.Benefit__c = aiaBen1.id;
        insert aiaLm1;
        Test.stopTest();
        Limitations__c aiaLm2 = new Limitations__c();
        aiaLm2.Benefit__c = aiaBen2.id;
        insert aiaLm2; 
 
    }

    static testmethod void testUpdateBenefitDesignProduct(){
    
        // Update objects to generate Adjustment records. 
        
        // NOTE: sometimes the record insert causes the after update to be called so you have to reset the flag
        //       because we are still in the same database transaction.
        
        Benfit_Request_Form__c nbrf = [select id,name,ARC_Comments__c from Benfit_Request_Form__c limit 1];
         Test.startTest();
        System.debug('Updating BRF, arc_comments__c being changed');
        AIA_BRFTriggerHandler.adjustmentPreviouslyCalled = false; 
        AIA_BRFTriggerHandler.AfterUpdateRecursive = false;       
        nbrf.ARC_Comments__c = 'Some arc comments';
        update nbrf;
        
        Proposed_Products__c aiaPP = [Select Id,BlueVision_Plus_Comments__c from Proposed_Products__c limit 1];
        AIA_ProposedProductsHandler.adjustmentPreviouslyCalled = false;
        aiaPP.BlueVision_Plus_Comments__c = 'Some blue vision comments';
        update aiaPP;
       
       
        AIA_Benefit_Design__c aiaBD = [Select id,QA_Auditor__c from AIA_Benefit_Design__c limit 1];
        AIA_BenefitDesignTriggerHandler.adjustmentPreviouslyCalled = false; 
        aiaBD.QA_Auditor__c = 'someEmailAddr@fake.com';
        update aiaBD;        
             
        AIA_Benefit_Design_Product__c aiaBDP2 = [select id,Related_Medical_Product__c,Accumulation_Period1__c from AIA_Benefit_Design_Product__c limit 1];
        aiaBDP2.Related_Medical_Product__c = null;
        aiaBDP2.Accumulation_Period1__c = 'some name';
        update aiaBDP2;
        
        List<AIA_Benefits__c> aiaBen2= [select id,Cloned_From_Benefit__c from AIA_Benefits__c];
        AIA_BenefitTriggerHandler.adjustmentPreviouslyCalled = false;
        aiaBen2[0].Cloned_From_Benefit__c = aiaBen2[1].id;
        update aiaBen2;        
        
        Limitations__c aiaLm2 = [select id,Code__c from Limitations__c limit 1];
        aiaLm2.Code__c = 'some code';
        update aiaLm2;
        AIA_BenefitCommentCodesTriggerHandler.allowAdjustmentsOnInserts = false; // added by raj 
        AIA_BenefitCommentCodesTriggerHandler.disableAdjustmentsOnInserts();// added by raj 
       Test.stopTest();
        /** commented for R1
         * List<Adjustment__c> adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c,AIA_Group_Structure__r.Name, New_Value__c, Previous_Value__c, Adjustment_Category__c
                                       FROM Adjustment__c];    **/       
        List<Adjustment__c> adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c,
                                       LastModifiedById, LastModifiedDate
                                       FROM Adjustment__c];
        
        AIA_AdjustmentSummaryUtils.printDbAdjustmentRecords(adjList); 
        
       // System.assertEquals(8, adjList.size(), 'Incorect number of Adjustment records were found after updates'); 
        
        AIA_BenefitCommentCodesTriggerHandler.allowAdjustmentsOnInserts = true; // added by raj 
        //AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterInsert(adjList);
        //AIA_AdjustmentSummaryUtils.beforeDelete();
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterDelete(adjList);
        AIA_BenefitCommentCodesTriggerHandler.enableAdjustmentsOnInserts();// added by raj 
        AIA_BenefitCommentCodesTriggerHandler.disableAdjustmentsOnUpdates();// added by raj 
        AIA_BenefitCommentCodesTriggerHandler.enableAdjustmentsOnUpdates();// added by raj 
         AIA_BenefitCommentCodesTriggerHandler.disableAdjustmentsOnUpdates();// added by raj 
        
         
               
               
    }  

static testmethod void testUpdateBenefitDesignProduct1(){
    
        // Update objects to generate Adjustment records. 
        
        // NOTE: sometimes the record insert causes the after update to be called so you have to reset the flag
        //       because we are still in the same database transaction.
        
        Benfit_Request_Form__c nbrf = [select id,name,ARC_Comments__c from Benfit_Request_Form__c limit 1];
         Test.startTest();
        System.debug('Updating BRF, arc_comments__c being changed');
        AIA_BRFTriggerHandler.adjustmentPreviouslyCalled = false; 
        AIA_BRFTriggerHandler.AfterUpdateRecursive = false;       
        nbrf.ARC_Comments__c = 'Some arc comments';
        update nbrf;
        
        Proposed_Products__c aiaPP = [Select Id,BlueVision_Plus_Comments__c from Proposed_Products__c limit 1];
        AIA_ProposedProductsHandler.adjustmentPreviouslyCalled = false;
        aiaPP.BlueVision_Plus_Comments__c = 'Some blue vision comments';
        update aiaPP;
       
       
        AIA_Benefit_Design__c aiaBD = [Select id,QA_Auditor__c from AIA_Benefit_Design__c limit 1];
        AIA_BenefitDesignTriggerHandler.adjustmentPreviouslyCalled = false; 
        aiaBD.QA_Auditor__c = 'someEmailAddr@fake.com';
        update aiaBD;        
           
        AIA_Benefit_Design_Product__c aiaBDP2 = [select id,Related_Medical_Product__c,Accumulation_Period1__c from AIA_Benefit_Design_Product__c limit 1];
        aiaBDP2.Related_Medical_Product__c = null;
        aiaBDP2.Accumulation_Period1__c = 'some name';
        update aiaBDP2;
        delete aiaBDP2;  
        List<AIA_Benefits__c> aiaBen2= [select id,Cloned_From_Benefit__c from AIA_Benefits__c];
        AIA_BenefitTriggerHandler.adjustmentPreviouslyCalled = false;
        aiaBen2[0].Cloned_From_Benefit__c = aiaBen2[1].id;
        update aiaBen2;        
        
        Limitations__c aiaLm2 = [select id,Code__c from Limitations__c limit 1];
        aiaLm2.Code__c = 'some code';
        update aiaLm2;
       Test.stopTest();
        /* List<Adjustment__c> adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c,AIA_Group_Structure__r.Name, New_Value__c, Previous_Value__c, Adjustment_Category__c
                                       FROM Adjustment__c];    */  

List<Adjustment__c> adjList = [SELECT Benefit_Request_Form__r.Name, Benefit_Design__r.Name, Changed_by_User__r.Name, 
                                       Field_Affected__c, Form_changed__c, New_Value__c, Previous_Value__c, Adjustment_Category__c
                                       FROM Adjustment__c]; 									   
        
        AIA_AdjustmentSummaryUtils.printDbAdjustmentRecords(adjList); 
        
       // System.assertEquals(8, adjList.size(), 'Incorect number of Adjustment records were found after updates'); 
        
               
    }     
}