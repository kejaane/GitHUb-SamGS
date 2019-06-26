/*****************************************************************************************************
 * Date: 04-19-2017
 * Developer: Bill Dodson
 * Purpose: Test the controller extension which is used to submit a BRF for Arc Approval. 
 *=========================================================================================
 * Update History
 * Date         Developer               Description
 *=========================================================================================
 * 04-19-2017    Bill Dodson  |   |  Initial Development
 * 04-23-2017    Bill Dodson         Days to Approve is null until approved.
 * 04-26-2017    Bill Dodson         Add tests for record lock/unlock.  Add tests for auto approve with
 *                                   sold source BRF.  Add test for BRF Renewal with Custom Products.
 * 05-02-2017    Bill Dodson         Split Pharmacy Management and RX Marketing into two groups.
 * 05-07-2017    Bill Dodson         Add additional tests to achieve 100% code coverage.
 * 05-08-2017    Bill Dodson         Add logic to validate auto approve groups.
 * 05-09-2017    Bill Dodson         Add additional auto approve tests.
 * 05-30-2017    Bill Dodson         Bulkify inserts in setUpTestData to get around SOQL query limits.
 * 05-31-2017    Bill Dodson         Add test methods for disease / wellness Set-up and Off-Cycle.
 * 06-07-2017    Bill Dodson         Add test methods for auto approve non standard medial and tests
 *                                   methods for empty group or address lists.
 * 07-06-2017    Bill Dodson         Add tests for BCM approval during auto approve.
 * 07-13-2017    Bill Dodson         Modify committe approval tests to require BCM approval when
 *                                   Risk non-standard drug or dental are in the BRF.
 * 09-21-2017    Bill Dodson         Add tests for VA Zip Code fill in logic.
 * 09-25-2017    Bill Dodson         Add debug statements.
 * 09-26-2017    Bill Dodson         Update Approval Responses one at a time to avoid Process
 *                                   Builder and Flow optimizations on Winter '18.
 * 09-11-2018    Naeem T-Pearson |T01| Remove MHP check before arc submission
 * 01-17-2019    Chaithra        |T02| Added groups as part of US1702 and US1730 
 * 02/08/2019		Chaithra	 |T03|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
 *=========================================================================================
 *******************************************************************************************************/
@isTest
public class AIA_BRFSubmitArcAppCtrlExten_Test
{
     // This method will set up the test data needed for each test method in this class.
     @testSetup
     static void setUpTestData()
     {
        System.debug('At the top of setUpTestData');
        Test.startTest();
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        Profile adminPro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        System.debug('Inserting user');
        List <User> uList= new List<User>();
        User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TesrBRF35@testorg.com.test');
        //insert u4;
        uList.add(u4);
        User u5 = new User(Alias = 'TAlias55', Email='TestRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        //insert u5;
        uList.add(u5);
        User u6 = new User(Alias = 'TAlias45', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUseF35@testorg.com.test');
        //insert u6;
        uList.add(u6);
        User u7 = new User(Alias = 'TAlias45', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer212', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = adminPro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUseF356@testorg.com.test');
        //insert u7;
        uList.add(u7);
        insert uList;
        //System.debug('1.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        Account acc;
        //Create Account
        System.debug('Inserting account');
         system.runAs(u7){
             acc =AIA_TestUtil.createAccount('TestOEMAcc');}
         
         Id rt_Con_X51 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_X51;
        con.email           ='con@email.con';
        con.AccountId       = acc.id;
        insert con;
         
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
        //T03 Starts
        System.debug('Inserting Account Team Member');                   
        /*AccountTeamMember atm3 = new AccountTeamMember ();
        atm3.TeamMemberRole = 'Contract Tech';
        atm3.AccountId = acc.id;
        atm3.UserId = u4.id;
        insert atm3;  
                         
        AccountTeamMember atm4 = new AccountTeamMember ();
        atm4.TeamMemberRole = 'Account Executive';
        atm4.AccountId = acc.id;
        atm4.UserId = u5.id;
        insert atm4;  
                           
        AccountTeamMember atm5 = new AccountTeamMember ();
        atm5.TeamMemberRole = 'Account Manager';
        atm5.AccountId = acc.id;
        atm5.UserId = u6.id;
        insert atm5; */
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u6.id,'Account Manager'));
         insert acctMbrList;
		//T02 Ends
		
        System.debug('Inserting first BRF');
        List<Benfit_Request_Form__c> brfList = new List<Benfit_Request_Form__c>();
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        brfList.add(brf);
        
        System.debug('Inserting second BRF');
        // This second brf is used when a sourced from reference is needed.
        Benfit_Request_Form__c brf2 = new Benfit_Request_Form__c();
        brf2.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf2.Contract_Count__c = 456;
        brf2.Request_Type__c = 'Renew As-is';
        brf2.Benefit_Effective_Date__c = system.today();
        brf2.Account__c = acc.id;
        brf2.ARC_Approval_Status__c = null;
        brf2.Escalated_to_Senior_Management__c = true;
        brf2.Status__c = 'new';
        brf2.Opportunity__c = opp.id;
        brf2.Jurisdiction__c = 'MD';
        brf2.Enrollment_Type__c = 'Cafeteria';
        brf2.EGWP_Picklist__c = 'Yes';
        brf2.FlexLink_Picklist__c = 'Yes';
        brf2.Benefit_Effective_Date__c = system.today();
        brf2.Benefit_Period__c = 'Contract';
        brf2.Control_Plan__c = '690';
        brf2.Sales_Segment_Size__c = 'Commercial 200-999';
        brf2.Contract_Period__c = 'Standard - 12 Months';
        brf2.Grandfathered_Status__c = 'Non-Grandfathered';
        brf2.Grandfathered_PPACA_Status__c = 'Yes';
        brf2.Stop_Loss__c = 'Carefirst';
        brf2.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf2.Broker_Consultant_Amount__c = 50;
        brf2.Identity_Protection__c = 'Yes';
        brf2.Enrollment_Type__c = 'Parallel';
        brfList.add(brf2);
        insert brfList;       
        
        //Query for the Account record types.
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();      
        
        System.debug('Inserting first product');
        List<Proposed_Products__c> ppList = new List<Proposed_Products__c>();
        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = brf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom__c = false;
        aiaPP.RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1   
        aiaPP.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        aiaPP.Funding_Arrangement__c = 'ASO';
         aiaPP.Non_Standard_Fee_Schedule__c='No';
        aiaPP.FirstHelp__c = 'Yes';
        aiaPP.Custom_Core_DM_Wellness__c = True;
        aiaPP.Custom_Wellness__c = false;
        //aiaPP.Stand_Alone_Wellness__c = 'No';
        //aiaPP.Stand_Alone_Disease_Management__c = 'No';
        ppList.add(aiaPP);
        
        System.debug('Inserting second product');
        Proposed_Products__c aiaPP2 = new Proposed_Products__c();
        aiaPP2.Benefit_Request_Form__c = brf.id;
        aiaPP2.Blue_Rewards__c = 'Standard';
        aiaPP2.Custom__c = false;
        aiaPP2.RecordTypeId = ppRecordTypes.get('Drug');
        aiaPP2.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        aiaPP2.Funding_Arrangement__c = 'Risk';
        aiaPP2.OralChemoMandateApply__c = 'Yes';
        aiaPP2.FirstHelp__c = 'Yes'; // T01
        aiaPP2.Exclusive_Specialty_Provider_Network__c = 'Yes';
        aiaPP2.ExtraCare_Health_Care_Card__c = 'No';
        aiaPP2.Network__c = 'National'; 
        aiaPP2.Custom_Core_DM_Wellness__c = True;
        aiaPP2.Custom_Wellness__c = false;
        //aiaPP2.Stand_Alone_Wellness__c = 'No';
        //aiaPP2.Stand_Alone_Disease_Management__c = 'No';
        ppList.add(aiaPP2);
        insert ppList;             
        
        AIA_Document__c aiaDoc1 = new AIA_Document__c();
        aiaDoc1.Document_Status__c = 'Complete';
        aiaDoc1.Document_Type__c = 'Marked Up Benefit Summary';
        aiaDoc1.Active__c = True;
        aiaDoc1.Start_Date__c = System.today();
        aiaDoc1.End_Date__c = System.today()+10;
        aiaDoc1.Approval_Status__c = 'Pending';
        aiaDoc1.Proposed_Products__c = aiaPP.id;
        aiaDoc1.Adj_Summ_Revision__c = 1;       
   //     insert aiaDoc1; // Disabled because no longer needed.  Was once required by a Validation Rule.
        
        System.debug('Inserting grouper');
        AIA_Grouper__c aiaGrpr = new AIA_Grouper__c();
        aiaGrpr.Proposed_Products__c = aiaPP.id;
        insert aiaGrpr;
        
        System.debug('Inserting first benefit');
        List<AIA_Benefits__c> benList = new List<AIA_Benefits__c>();
        AIA_Benefits__c aiaBen1 = new AIA_Benefits__c();
        aiaBen1.Grouper__c = aiaGrpr.id;
        benList.add(aiaBen1);       
        
        System.debug('Inserting second benefit');
        AIA_Benefits__c aiaBen2 = new AIA_Benefits__c();
        aiaBen2.Grouper__c = aiaGrpr.id;
        benList.add(aiaBen2); 
        insert benList; 
        
        // Make sure we are starting out with cleared out ARC Approval fields in the BRF.                              
        System.assertEquals(null, brf.ARC_Approval_Date__c, 'BRF approval date not empty');
        System.assertEquals(null, brf.ARC_Approval_Initial_Submission_Date__c, 'BRF submitted date not empty');
        System.assertEquals(null, brf.ARC_Approval_Status__c, 'ARC status not empty');
        System.assertEquals(null, brf.Days_to_Approve_BRF__c, 'BRF days to approve not empty');
        
        // Populate the custom setting with an email value.
        AIA_Workflow_Emails__c settings = AIA_Workflow_Emails__c.getOrgDefaults();
        settings.ARC_Approval_Request_BCM_Email__c = 'william.dodson@carefirst.com';
        upsert settings custSettings__c.Id;
        Test.stopTest();
        System.debug('At the bottom of setUpTestData');               
    } 
    
    // Helper method to get the proposed product record types.
    private static Map<String,String> getProposedProductsRecordTypes()
    {
        Map<String,String> ppRecordTypes = new Map<String,String>{};
        List<RecordType> rtypes = [Select Name, Id From RecordType  
                                   WHERE sObjectType='Proposed_Products__c' and isActive=true];         
        
        //Create a map between the Record Type Name and Id for easy retrieval 
        for(RecordType rt: rtypes)
        {
            ppRecordTypes.put(rt.Name,rt.Id);
        }         
        
        return ppRecordTypes;
    }
 
    // This method will test all the condtions that cause the submit to be rejected.
    public static testMethod void TestSubmitRejection()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                              

        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();
        
        System.assertEquals(false, controller.displayPopup, 'Failed to show form without the popup hidden');
        
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        
        // Simulate approval status is not blank during a submit.        
        brf.ARC_Approval_Status__c = 'Pending';
        update brf;
        
        controller.submitBrfForArchApproval();
        
       /* System.assertEquals('Rejecting request because the ARC Approval Status is not blank, status: Pending',
                             controller.msg,
                            'Failed to detect an invalid ARC status upon submission');*/
                            
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');                     
                            
        // Reset status and test for invalid MHP.                   
        brf.ARC_Approval_Status__c = '';
        brf.Request_Type__c = 'Renewal - Benefit Changes';
        //brf.MHP_Test_Result__c = 'Fail';
        update brf; 
        
        controller.submitBrfForArchApproval();
        
        /*System.assertEquals('The Benefit Request Form cannot be submitted for ARC Approval since the Mental Health Parity Test has failed',
                             controller.msg,
                            'Failed to detect an invalid MHP status upon submission');*/

        // Test the other MHP rejection condition.
        //brf.MHP_Test_Result__c = null;
        update brf;         
        
        controller.submitBrfForArchApproval();
        
        /*System.assertEquals('The Benefit Request Form cannot be submitted for ARC Approval since the Mental Health Parity Test has not been completed',
                             controller.msg,
                            'Failed to detect an invalid MHP status upon submission');*/

        // Test the Sales Management required rejection logic.
        Benfit_Request_Form__c brf2 = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 456 LIMIT 1];
        //brf.MHP_Test_Result__c = 'Pass';
        brf.Source_Benefit_Request_Form__c = brf2.id;
        brf.Request_Type__c = 'Off-Cycle - Benefit Change';
        update brf;          
        
        controller.submitBrfForArchApproval(); 
        
       /* System.assertEquals('The Benefit Request Form cannot be submitted for ARC Approval since it is an off-cycle change and it has not been approved by Sales Management, Sales Management Approval Status: null',
                             controller.msg,
                            'Sales Management approval required');  */      
        
        // Remove the proposed product form the BRF to test the no product condition.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c];
        delete ppList;  
        
        controller.displayPopup = false; // Reset to test that it goes back to true;
        controller.submitBrfForArchApproval(); 
                
      /*  System.assertEquals('The Benefit Request Form cannot be submitted for ARC Approval since there are no products related to it',
                             controller.msg,
                            'Failed to detect no products upon submission');
                            
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user'); */
                            
        // Simulate user returning to the BRF.
        PageReference brfPage = controller.returnToBrf();
        
      /*  System.assertEquals('/' + brf.Id, brfPage.getUrl(), 'Failed to return the user to the BRF detail page');
        
        System.assertEquals(false, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should not be locked if the submission was rejected');
          */           
        test.stopTest();                    
    }
    
    // This method will test VA Zip Code reject logic.
    public static testMethod void TestApproveVA()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];       
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        // Test with no zip code fields populated.
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Request_Type__c = 'RFP'; 
        brf.Jurisdiction__c = 'VA';
        update brf;  
    
        controller.submitBrfForArchApproval(); 
        
        System.assertEquals('Please complete Zip Code verification before submitting the BRF for ARC approval',
                             controller.msg,
                            'Failed to reject for VA missing zip code verification');
                            
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');                    
        
        // Test with ALL zip code fields populated.
        brf.Zip_Code_Validation__c = 'Within the CareFirst service area'; 
        brf.Verified_By__c = 'Bill Dodson';
        brf.Verification_Date__c = Date.Today();
        update brf;  

        controller.submitBrfForArchApproval(); 
        
        /*System.assertEquals('Successfully Auto Approved the Benefit Request Form',
                             controller.msg,
                            'Failed to auto approve'); 
          */                  
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');                                                                   
        
        test.stopTest();
    }     
    
    // This method will test for auto approval.
    public static testMethod void TestAutoApprove()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c,createdById, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                                       

        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);   
        system.debug('controller'+controller);
        test.startTest();
        
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        
                
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Request_Type__c = 'RFP';      
        update brf;  

        controller.submitBrfForArchApproval(); 
        /* System.assertEquals('Successfully Auto Approved the Benefit Request Form',
                             controller.msg,
                            'Failed to auto approve');*/
                            
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, Owner__c, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,createdById
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Make sure the ARC Approval fields were set correctly.
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        //System.assertEquals('Auto-Approved by System', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        //System.assertEquals(0, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
    
        List<FeedItem> feedItems = [SELECT ParentId, Body FROM FeedItem where ParentId=:brf.CreatedById];
        
        //System.assertEquals(1, feedItems.size(), 'Failed to post one item to chatter'); 
        //System.assertEquals(brf.createdById, feedItems[0].ParentId, 'Failed to post chatter to record owner');  
        
        //System.assertEquals(false, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should not be locked if it was auto approved');  
    
        // Validate the groups that were notified.
        validateAutoApprovedGroups(7, controller, false, false, false, false,true, false,true,false, false, true, true, true);
    
        test.stopTest();
    }   
    
    // This method will test for auto approval that requires BCM Approval because of a
    // non standard risk product.
    public static testMethod void TestAutoApproveRequiresBCMApproval()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                                       

        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);   

        test.startTest(); 
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        
        // Make BRF with a Non Standard product. 
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Funding_Arrangements__c = 'Risk';
        brf.Request_Type__c = 'RFP';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'Risk');
        update brf;           
        delete [SELECT id FROM Proposed_Products__c];    
        
        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = brf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom_New__c = 'Non - Standard';
        aiaPP.Custom__c = false;
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes(); 
        aiaPP.RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        aiaPP.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        aiaPP.Funding_Arrangement__c = 'Risk';
        aiaPP.FirstHelp__c = 'Yes';
        //aiaPP.MHP_Test_Result__c = 'Pass';  
        //aiaPP.Non_Standard_Fee_Schedule__c='No';
        insert aiaPP;                
        
        List<Proposed_Products__c> ppList = [SELECT id, Funding_Arrangement__c, Custom_New__c FROM Proposed_Products__c];

        System.assert(ppList[0].Funding_Arrangement__c == 'Risk', 'Product funding arrangement is not Risk: ' + ppList[0].Funding_Arrangement__c);
        System.assert(ppList[0].Custom_New__c == 'Non - Standard', 'Product is not non-standard');

        brf = [SELECT id, Count_of_Risk_Non_Standard__c, Count_of_Custom_Products__c, Count_of_Medical_CDH_BlueFund__c,
               Count_of_Medical_Custom_Wellness__c, Count_of_Medical_FSA_BlueFund__c, Count_of_Risk_Non_Standard_Drug_Dental__c           
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
               
        // Make sure all the roll up fields are correct.       
        System.assert(brf.Count_of_Custom_Products__c == 0, 'Count_of_Custom_Products__c is not zero'); 
        System.assert(brf.Count_of_Medical_CDH_BlueFund__c == 0, 'Count_of_Medical_CDH_BlueFund__c is not zero');
        System.assert(brf.Count_of_Medical_Custom_Wellness__c == 0, 'Count_of_Medical_Custom_Wellness__c is not zero');
        System.assert(brf.Count_of_Medical_FSA_BlueFund__c == 0, 'Count_of_Medical_FSA_BlueFund__c is not zero');
        System.assert(brf.Count_of_Risk_Non_Standard_Drug_Dental__c  == 0, 'Count_of_Risk_Non_Standard_Drug_Dental__c  is not zero');               
        System.assert(brf.Count_of_Risk_Non_Standard__c > 0, 'BRF does not contain any Risk Non - Standard products');      

        controller.submitBrfForArchApproval(); 
        
        System.assertEquals('Successfully submitted the Benefit Request Form for BCM Approval',
                             controller.msg,
                            'Failed to submit for BCM approval');
                            
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Make sure the ARC Approval fields were set correctly.
        System.assertEquals(null, brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        System.assertEquals('Pending', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        System.assertEquals(null, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(1, brf.Id, true, true, true, false,true,true,true, true, true, true, true, true);
        
        System.assertEquals(true, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should be locked');  
        
        test.stopTest();
    }  
    
    // This method will test for auto approval when BRF has a sold source BRF and requires
    // BCM approval.
    public static testMethod void TestAutoApproveWithSoldRequiresBCMApproval()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                                       

        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest(); 
        
        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf2 = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 456 LIMIT 1];  
        brf2.Status__c = 'Sold';
        AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
        update brf2;         
        
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        // Make BRF with a Non Standard product. 
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Funding_Arrangements__c = 'Risk';
        brf.Request_Type__c = 'Renew As-is';
        brf.Source_Benefit_Request_Form__c = brf2.id;
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'Risk');
        update brf;           
        delete [SELECT id FROM Proposed_Products__c];    
        
        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = brf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom_New__c = 'Non - Standard';
        aiaPP.Custom__c = false;
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes(); 
        aiaPP.RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        aiaPP.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        aiaPP.Funding_Arrangement__c = 'Risk';
        aiaPP.FirstHelp__c = 'Yes';
        //aiaPP.MHP_Test_Result__c = 'Pass';    
        insert aiaPP;         

        controller.submitBrfForArchApproval(); 
        
        System.assertEquals('Successfully submitted the Benefit Request Form for BCM Approval',
                             controller.msg,
                            'Failed to submit for BCM approval');
                            
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Make sure the ARC Approval fields were set correctly.
        System.assertEquals(null, brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        System.assertEquals('Pending', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        System.assertEquals(null, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(1, brf.Id, true, true, true, false,true,true,true,true, true, true, true, true);
        
        System.assertEquals(true, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should be locked');  
  
        test.stopTest();
    }      
    
    // This method will test for auto approval with Integrated DM Welleness
    public static testMethod void TestAutoApproveIntegratedDMWEllness()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                                       

        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Standard';
        ppList[0].Non_Standard_Fee_Schedule__c='Yes';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        ppList[0].Custom_Core_DM_Wellness__c = true;  // Label is Integrated DM/Wellness
        update ppList[0]; 
        
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Request_Type__c = 'RFP';      
        update brf;  
    
        controller.submitBrfForArchApproval(); 
        
       /* System.assertEquals('Successfully Auto Approved the Benefit Request Form',
                             controller.msg,
                            'Failed to auto approve');
         */                   
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, Owner__c, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,CreatedById
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Make sure the ARC Approval fields were set correctly.
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        //System.assertEquals('Auto-Approved by System', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        //System.assertEquals(0, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
    
        List<FeedItem> feedItems = [SELECT ParentId, Body FROM FeedItem where ParentId=:brf.CreatedById];
        
        //System.assertEquals(1, feedItems.size(), 'Failed to post one item to chatter'); 
        //System.assertEquals(brf.Owner__c, feedItems[0].ParentId, 'Failed to post chatter to record owner');  
        
        //System.assertEquals(false, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should not be locked if it was auto approved');  
    
        // Validate the groups that were notified.
       // validateAutoApprovedGroups(8, controller, false, false, false, false, false, false, false, false, true, true);
    
        test.stopTest();
    }     
    
    
    
    // This method will test for auto approval with Dental product.
    public static testMethod void TestAutoApproveDentalProduct()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                                       

        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Standard';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Dental');
        ppList[0].Non_Standard_Fee_Schedule__c='No';
        update ppList[0];
        
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Request_Type__c = 'RFP';      
        update brf;  
    
        controller.submitBrfForArchApproval(); 
        
        /*System.assertEquals('Successfully Auto Approved the Benefit Request Form',
                             controller.msg,
                            'Failed to auto approve');
        */                    
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, Owner__c, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,CreatedById
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Make sure the ARC Approval fields were set correctly.
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        //System.assertEquals('Auto-Approved by System', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        //System.assertEquals(0, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
    
        List<FeedItem> feedItems = [SELECT ParentId, Body FROM FeedItem where ParentId=:brf.CreatedById];
        
        //System.assertEquals(1, feedItems.size(), 'Failed to post one item to chatter'); 
        //System.assertEquals(brf.Owner__c, feedItems[0].ParentId, 'Failed to post chatter to record owner');  
        
        //System.assertEquals(false, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should not be locked if it was auto approved');  
    
        // Validate the groups that were notified.
        validateAutoApprovedGroups(8, controller, false, false, false, false,true,false,true,false, false, true, false, true);    
    
        test.stopTest();
    }       
    
    // This method will test for auto approval with Vision product.
    public static testMethod void TestAutoApproveVisionProduct()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                                       

        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
                
        test.startTest();    
        
        // Create a vision product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c];
        ppList[0].Custom_New__c = 'Standard';
        ppList[0].Non_Standard_Fee_Schedule__c='No';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Vision');
        update ppList[0]; 

        // Make sure Vision is the only product.
        delete ppList[1];               
        
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Request_Type__c = 'RFP';      
        update brf;  
    
        controller.submitBrfForArchApproval(); 
        
        /*System.assertEquals('Successfully Auto Approved the Benefit Request Form',
                             controller.msg,
                            'Failed to auto approve');
        */                    
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, Owner__c, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,CreatedById
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Make sure the ARC Approval fields were set correctly.
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        //System.assertEquals('Auto-Approved by System', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        //System.assertEquals(0, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
    
        List<FeedItem> feedItems = [SELECT ParentId, Body FROM FeedItem where ParentId=:brf.CreatedById];
        
        //System.assertEquals(1, feedItems.size(), 'Failed to post one item to chatter'); 
        //System.assertEquals(brf.Owner__c, feedItems[0].ParentId, 'Failed to post chatter to record owner');  
        
        //System.assertEquals(false, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should not be locked if it was auto approved');  
    
        // Validate the groups that were notified.
        validateAutoApprovedGroups(5, controller, false, false, false, false,true,false,true, true, true, true, true, true);    
    
        test.stopTest();
    }        
 
    
    // This method will test for auto approval with CDH product.
    public static testMethod void TestAutoApproveCDHProduct()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,CreatedById
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                                       

        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Standard';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        ppList[0].CDH__c = 'Yes';
        ppList[0].Non_Standard_Fee_Schedule__c='No';
        update ppList[0];
        
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Request_Type__c = 'RFP';      
        update brf;  
    
        controller.submitBrfForArchApproval(); 
        
        /*System.assertEquals('Successfully Auto Approved the Benefit Request Form',
                             controller.msg,
                            'Failed to auto approve');
        */                    
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, Owner__c, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,CreatedById
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Make sure the ARC Approval fields were set correctly.
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        //System.assertEquals('Auto-Approved by System', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        //System.assertEquals(0, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
    
        List<FeedItem> feedItems = [SELECT ParentId, Body FROM FeedItem where ParentId=:brf.CreatedById];
        
        //System.assertEquals(1, feedItems.size(), 'Failed to post one item to chatter'); 
        //System.assertEquals(brf.Owner__c, feedItems[0].ParentId, 'Failed to post chatter to record owner');  
        
        //System.assertEquals(false, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should not be locked if it was auto approved');  
    
        // Validate the groups that were notified.
        validateAutoApprovedGroups(8, controller, false, false, false, false,true,false,true,false, false, true, true, false);      
    
        test.stopTest();
    }
    
    // This method will test for auto approval when BRF has a sold source BRF.
    public static testMethod void TestAutoApproveWithSoldSourceBRF()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                                       

        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest(); 
        
        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf2 = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 456 LIMIT 1];  
        brf2.Status__c = 'Sold';
        AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
        update brf2;         
        
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Request_Type__c = 'Renew As-is';
        brf.Source_Benefit_Request_Form__c = brf2.id;      
        update brf;  
    
        controller.submitBrfForArchApproval(); 
        
        /*System.assertEquals('Successfully Auto Approved the Benefit Request Form',
                             controller.msg,
                            'Failed to auto approve');
        */                    
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, Owner__c, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,CreatedById
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Make sure the ARC Approval fields were set correctly.
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        //System.assertEquals('Auto-Approved by System', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        //System.assertEquals(0, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
    
        List<FeedItem> feedItems = [SELECT ParentId, Body FROM FeedItem where ParentId=:brf.CreatedById];
        
        //System.assertEquals(1, feedItems.size(), 'Failed to post one item to chatter'); 
        //System.assertEquals(brf.Owner__c, feedItems[0].ParentId, 'Failed to post chatter to record owner');  
        
        //System.assertEquals(false, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should not be locked if it was auto approved');  
    
        test.stopTest();
    }  
    
    // This method will test for auto approval with non standard medical product.
    public static testMethod void TestAutoApproveNonStandardMedicalProduct()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                                       

        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c];
        ppList[0].Custom_New__c = 'Non - Standard';
        ppList[0].Non_Standard_Fee_Schedule__c='No';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        update ppList[0]; 
        delete ppList[1];
        
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Request_Type__c = 'RFP';      
        update brf;  
    
        controller.submitBrfForArchApproval(); 
        
        /*System.assertEquals('Successfully Auto Approved the Benefit Request Form',
                             controller.msg,
                            'Failed to auto approve');
        */                   
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, Owner__c, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,CreatedById
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Make sure the ARC Approval fields were set correctly.
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        //System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        //System.assertEquals('Auto-Approved by System', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        //System.assertEquals(0, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
    
        List<FeedItem> feedItems = [SELECT ParentId, Body FROM FeedItem where ParentId=:brf.CreatedById];
        
        //System.assertEquals(1, feedItems.size(), 'Failed to post one item to chatter'); 
        //System.assertEquals(brf.Owner__c, feedItems[0].ParentId, 'Failed to post chatter to record owner');  
        
        //System.assertEquals(false, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should not be locked if it was auto approved');  
    
        // Validate the groups that were notified.
        validateAutoApprovedGroups(4, controller, false, false, false, false, true,true,true, true, true, true, true, true);      
    
        test.stopTest();
    }     
    
    // This method will test for committee approval.
    public static testMethod void TestCommitteeApprove()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];       
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();
        
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        
        //brf.MHP_Test_Result__c = 'Pass';
        brf.ARC_Comments__c = 'Some test comments';
        update brf;  
    
        controller.submitBrfForArchApproval(); 
        
        System.assertEquals('Successfully submitted the Benefit Request Form',
                             controller.msg,
                            'Failed to submit to committee approve');
                            
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Make sure the ARC Approval fields were set correctly.
        System.assertEquals(null, brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        System.assertEquals('Pending', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        System.assertEquals(null, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(3, brf.Id, false, false, false,true,true,true, true, true, true, true, true, true);
        
        List<Approval_Response__c> arList = [SELECT Benefit_Request_Form__c, Business_Area__c, Response__c 
                                             FROM Approval_Response__c ORDER BY Business_Area__c];
     
        System.assertEquals(true, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should be locked for committee approval');  
    
        System.debug('Updating responses to Accept');
        
        // Approve the BRF.
        for(Approval_Response__c ar : arList)
        {
            ar.Response__c = 'Accept';
            
            // Update one at a time because to more closely mimic user interaction. 
            update ar;
        }
        
        System.debug('Finished updating responses to Accept');
        
        //System.assertEquals(false, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should be unlocked after committee approval');  
    
        brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
               
        // Make sure the ARC Approval fields were set correctly.
        System.assertEquals(Date.Today(), brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        System.assertEquals('Approved by Committee', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        System.assertEquals(0, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');  
        
        // Simulate a rejection.
        arList[0].Response__c = 'Reject';
        arList[0].Comments__c = 'I do not think this is a good BRF, sorry';
        try{
        update arList[0];
        }catch(exception e){
            
        }
        
        brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
               
        // Make sure the ARC Approval fields were set correctly.
       // System.assertEquals(null, brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
       // System.assertEquals('Rejected by Committee', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
       // System.assertEquals(null, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');  
        
        // Test lock failure condition.
        try
        {
            controller.lockBrfRec(null);   
            
            System.assert(false, 'Exception not thrown when attempting to lock a null record');
        }
        catch (Exception e)
        {
            System.debug('Correctly threw an exception when attempting to lock a null BRF: ' + e.getMessage());
        }     
        
        // Test send email failure condition.
        try
        {
            controller.sendEmail(new List<String>(), 'Dummy Subject', 'Dummy Body');  
            
            System.assert(false, 'Exception not thrown when attempting to send email with empty To Address list');
        }
        catch (Exception e)
        {
            System.debug('Correctly threw an exception when attempting send email to empty To Address list: ' + e.getMessage());
        }                 
    
        test.stopTest();
    }   
    
    // This method will test for committee approval with a BRF Renewal with Custom Product.
    public static testMethod void TestCommitteeApproveRenewalCustomProduct()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF a Renewal with a Custom product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Custom';
        update ppList[0];

        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Request_Type__c = 'Renewal';    
        update brf;  

        controller.submitBrfForArchApproval(); 
        
        System.assertEquals('Successfully submitted the Benefit Request Form',
                             controller.msg,
                            'Failed to submit to committee approve');
                            
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Make sure the ARC Approval fields were set correctly.
        System.assertEquals(null, brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        System.assertEquals('Pending', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        System.assertEquals(null, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(4, brf.Id, false, false, false, false, true,true,true, true, true, true, true, true);
     
        System.assertEquals(true, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should be locked for committee approval');                       
    
        test.stopTest();
    }
    
    
    // This method will test for committee approval with Custom Drug Product.
    public static testMethod void TestCommitteeApproveCustomDrug()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF with a Custom Drug product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Custom';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes(); 
        ppList[0].RecordTypeId = ppRecordTypes.get('Drug');
        ppList[0].Funding_Arrangement__c = 'ASO';
        ppList[0].Network__c = 'National';
        update ppList[0];         
        //brf.MHP_Test_Result__c = 'Pass';  
        update brf;
        

        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(7, brf.Id, false, false, false, false,true,true,false, false, true, true, true, false);                    
    
        test.stopTest();
    }    
    
    // This method will test for committee approval with Custom Vision Product.
    public static testMethod void TestCommitteeApproveCustomVision()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF with a Custom Vision product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c];
        ppList[0].Custom_New__c = 'Custom';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Vision');
        update ppList[0];  
        
        // Make sure vision is the only product.
        delete ppList[1];
               
        //brf.MHP_Test_Result__c = 'Pass';  
        update brf;  

        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(5, brf.Id, false, false, false, false,true,true,false, true, true, true, true, true);                    
    
        test.stopTest();
    }      
    
    // This method will test for committee approval with Non Standard Drug Product.
    public static testMethod void TestCommitteeApproveNonStandardDrug()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
               
        // Make BRF with a Non Standard Drug product. 
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Funding_Arrangements__c = 'Risk';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'Risk');
        update brf;           
        delete [SELECT id FROM Proposed_Products__c LIMIT 1];
        
        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = brf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom_New__c = 'Non - Standard';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        aiaPP.RecordTypeId = ppRecordTypes.get('Drug');     
        aiaPP.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        aiaPP.Funding_Arrangement__c = 'Risk';
        aiaPP.Network__c = 'National';
        aiaPP.Exclusive_Specialty_Provider_Network__c = 'Yes';
        aiaPP.ExtraCare_Health_Care_Card__c = 'No';
        aiaPP.OralChemoMandateApply__c = 'Yes';
        insert aiaPP;          

        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(6, brf.Id, false, false, false, false, true,true,true, false, true, true, true, false);                    
    
        test.stopTest();
    }          


   // This method will test for committee approval with a Custom Wellness Product.
    public static testMethod void TestCommitteeApproveCustomWellness()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF with a Custom Wellness product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Custom';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        ppList[0].Custom_Wellness__c = true;
        ppList[0].Custom_Core_DM_Wellness__c = True;
        ppList[0].Custom_Wellness__c = false;
        ppList[0].Stand_Alone_Wellness__c = 'No';
        ppList[0].Stand_Alone_Disease_Management__c = 'No';
        update ppList[0];         
        //brf.MHP_Test_Result__c = 'Pass';  
        update brf;  

        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(5, brf.Id, false, false, false, false, true,true,true, true, false, true, true, true);                    
    
        test.stopTest();
    }  
    
    // This method will test for committee approval with a Stand Alone Disease Management.
    public static testMethod void TestCommitteeApproveStandAloneDiseaseManagement()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF with a Custom Wellness product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Standard';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        //ppList[0].Stand_Alone_Disease_Management__c = 'Yes';
        ppList[0].Custom_Wellness__c = true;
        ppList[0].Custom_Core_DM_Wellness__c = True;
        ppList[0].Custom_Wellness__c = false;
        ppList[0].Stand_Alone_Wellness__c = 'No';
        ppList[0].Stand_Alone_Disease_Management__c = 'No';
        update ppList[0];         
        //brf.MHP_Test_Result__c = 'Pass';  
        update brf;  

        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(4, brf.Id, false, false, false, true, true,true,true, true, false, true, true, true);                    
    
        test.stopTest();
    }     

    // This method will test for committee approval with a Stand Alone Disease Management with a Set-up BRF.
    // Wellness should not be an approver in this case.
    public static testMethod void TestCommitteeApproveStandAloneDiseaseManagementWithSetupBrf()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf  = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        Benfit_Request_Form__c brf2 = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 456 LIMIT 1]; 
                
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF with a Custom Wellness product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Standard';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
       // ppList[0].Stand_Alone_Disease_Management__c = 'Yes';
        ppList[0].Custom_New__c = 'Custom';
        ppList[0].Custom_Wellness__c = true;
        ppList[0].Custom_Core_DM_Wellness__c = True;
        ppList[0].Custom_Wellness__c = false;
        ppList[0].Stand_Alone_Wellness__c = 'No';
        ppList[0].Stand_Alone_Disease_Management__c = 'No';
        update ppList[0];         
        //brf.MHP_Test_Result__c = 'Pass';  
        brf.Source_Benefit_Request_Form__c = brf2.id;
        brf.Request_Type__c = 'Set-up Change - Benefit Changes';
        update brf;          

        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(4, brf.Id, false, false, false, false, true,true,true, true, true, true, true, true);                    
    
        test.stopTest();
    }  

    // This method will test for committee approval with a Stand Alone Wellness.
    public static testMethod void TestCommitteeApproveStandAloneWellness()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF with a Custom Wellness product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Standard';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        ppList[0].Stand_Alone_Wellness__c = 'Yes';
        ppList[0].Custom_Wellness__c = true;
        ppList[0].Custom_Core_DM_Wellness__c = True;
        ppList[0].Custom_Wellness__c = false;
        ppList[0].Stand_Alone_Wellness__c = 'No';
        ppList[0].Stand_Alone_Disease_Management__c = 'No';
        update ppList[0];         
        //brf.MHP_Test_Result__c = 'Pass';  
        update brf;  

        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(4, brf.Id, false, false, false, true, true,true,true, true, false, true, true, true);                    
    
        test.stopTest();
    }   
    
    // This method will test for committee approval with a Stand Alone Wellness with an Off-Cycle BRF.
    // Wellness should not be an approver in this case.
    public static testMethod void TestCommitteeApproveStandAloneWellnessWithOffcycleBrf()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf  = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        Benfit_Request_Form__c brf2 = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 456 LIMIT 1]; 
         
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF with a Custom Wellness product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Standard';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        ppList[0].Stand_Alone_Wellness__c = 'Yes';
        ppList[0].Custom_New__c = 'Custom';
        ppList[0].Custom_Wellness__c = true;
        ppList[0].Custom_Core_DM_Wellness__c = True;
        ppList[0].Custom_Wellness__c = false;
        ppList[0].Stand_Alone_Wellness__c = 'No';
        ppList[0].Stand_Alone_Disease_Management__c = 'No';
        update ppList[0];         
        //brf.MHP_Test_Result__c = 'Pass';
        brf.Source_Benefit_Request_Form__c = brf2.id; 
        brf.Request_Type__c = 'Off-Cycle - Benefit Change'; 
        update brf;  
        
        // A separate update is needed because of workflow rule overwrite.
        brf.sales__c = 'Approved';
        update brf;
        
        brf  = [SELECT id, Sales__c FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];

        System.debug('brf.Sales__c before submitting for approval: ' + brf.Sales__c);

        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(4, brf.Id, false, false, false, false, true,true,true, true, true, true, true, true);                    
    
        test.stopTest();
    }   

    // This method will test for committee approval with a Custom Dental Product.
    public static testMethod void TestCommitteeApproveCustomDental()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF with a Custom Dental product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Custom';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Dental');
        ppList[0].Funding_Arrangement__c = 'ASO';
        update ppList[0];         
        //brf.MHP_Test_Result__c = 'Pass';  
        update brf;  

        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(5, brf.Id, false, false, false, false,true,true, true, true, true, false, true, true);                    
    
        test.stopTest();
    }      

    // This method will test for committee approval with a Non Standard Dental Product.
    public static testMethod void TestCommitteeApproveNonStandardDental()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF with a Non Standard Dental product. 
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Funding_Arrangements__c = 'Risk';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'Risk');
        update brf;           
        delete [SELECT id FROM Proposed_Products__c LIMIT 1];
        
        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = brf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom_New__c = 'Non - Standard';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        aiaPP.RecordTypeId = ppRecordTypes.get('Dental');     
        aiaPP.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        aiaPP.Funding_Arrangement__c = 'Risk';
        insert aiaPP;        
            
        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(5, brf.Id, false, false, false, false,true,true, true, true, true, false, true, true);                    
    
        test.stopTest();
    }  
    
    // This method will test for committee approval with a Medical CDH Blue Fund.
    public static testMethod void TestCommitteeApproveMedicalCDHBlueFund()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF with a Custom Wellness product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Standard';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        ppList[0].CDH_Fund_Type__c = 'BlueFund';
        update ppList[0];         
        //brf.MHP_Test_Result__c = 'Pass';  
        update brf;  

        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(4, brf.Id, false, false, false, true,true,true,true,true, true, true, false, true);                    
    
        test.stopTest();
    }     
    
    // This method will test for committee approval with a Medical CDH Blue Fund.
    public static testMethod void TestCommitteeApproveMedicalFSABlueFund()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();    
        
        // Make BRF with a Custom Wellness product.
        List<Proposed_Products__c> ppList = [SELECT id FROM Proposed_Products__c LIMIT 1];
        ppList[0].Custom_New__c = 'Standard';
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes();
        ppList[0].RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        ppList[0].FSA_BlueFund__c = true;
        update ppList[0];         
        //brf.MHP_Test_Result__c = 'Pass';  
        update brf;  

        controller.submitBrfForArchApproval(); 
        
        brf = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(4, brf.Id, false, false, false, true,true,true,true, true, true, true, false, true);                    
    
        test.stopTest();
    }     
    
    // Validate the Approval Respoonse records.  If there are committees that should not have been included then
    // pass in 'true' for the corresponding flag value to avoid failing an assert.
    private static void validateApprovalRecords(Integer numRecs,
                                                String brfId, 
                                                Boolean nascoBenefitCodingFlag,
                                                Boolean benefactCodingFlag,
                                                Boolean mastFlag,
                                                Boolean bcmFlag,
                                                Boolean benefitCodingFlag,
                                                Boolean visionAnalystFlag,
                                                Boolean benefitTesterFlag,
                                                Boolean pharmacyManagementAndRxMarketingFlag,
                                                Boolean wellnessFlag,
                                                Boolean dentalTeamFlag,
                                                Boolean cdhTeamFlag,
                                                Boolean rxMarketingFlag)
    {
        List<Approval_Response__c> arList = [SELECT Benefit_Request_Form__c, Business_Area__c, Response__c 
                                             FROM Approval_Response__c ORDER BY Business_Area__c];
                                             
        System.debug('Approval Respones: ' + arList);
                                             
        // Make sure each record is associated with the BRF and has the correct status.
        for(Approval_Response__c ar : arList)
        {
            System.assertEquals(brfId, ar.Benefit_Request_Form__c, 'Failed to associate Approval Response to the BRF');
            System.assertEquals('Pending', ar.Response__c, 'Failed to associate Approval Response to the BRF');
            
            // Set the presense of business units flags.
            if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.NASCO_BENEFIT_CODING)
            {
                nascoBenefitCodingFlag = true;
            }
            else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.BENEFACT_CODING)
            {
                benefactCodingFlag = true;
            }
            else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.MAST)
            {
                mastFlag = true;
            }
            else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.BCM)
            {
                bcmFlag = true;
            }
            
            /*else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.ANCILLARY_ANALYST_SETUP)
            {
                ancillaryAnalystSetupFlag = true;
            }*/
            else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.AIA_VISION_GROUP)
            {
                visionAnalystFlag = true;
            }
            else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.BENEFIT_CODING)
            {
                benefitCodingFlag = true;
            }
            else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.BENEFIT_TESTING)
            {
                benefitTesterFlag = true;
            }
            else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.PHARMACY_MANAGEMENT)
            {
                pharmacyManagementAndRxMarketingFlag = true;
            }
            
            else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.WELLNESS)
            {
                wellnessFlag = true;
            }
            
            else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.DENTAL_TEAM)
            {
                dentalTeamFlag = true;
            }
            
            else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.CDH_TEAM)
            {
                cdhTeamFlag = true;
            } 
            else if(ar.Business_Area__c == AIA_BRFSubmitArcApprovalCtrlExtension.RX_MARKETING)
            {
                rxMarketingFlag = true;
            }    
        }  
        
     /* System.assert(nascoBenefitCodingFlag,   'No Approval Response record for NASCO Benefit Coding was found');
        System.assert(benefactCodingFlag,       'No Approval Response record for Benefact Coding was found');
        System.assert(mastFlag,                 'No Approval Response record for MAST was found');
        System.assert(bcmFlag,                  'No Approval Response record for BCM was found');        
        System.assert(ancillaryAnalystSetupFlag,'No Approval Response record for Ancillary Analyst was found');  
        System.assert(pharmacyManagementAndRxMarketingFlag,'No Approval Response record for Pharmacy Mgmt was found');
        System.assert(wellnessFlag,             'No Approval Response record for Wellness was found');
        System.assert(dentalTeamFlag,           'No Approval Response record for Dental Team was found');
        System.assert(cdhTeamFlag,              'No Approval Response record for CDH Team was found');
        System.assert(rxMarketingFlag ,         'No Approval Response record for RX Marketing was found');
        
        System.assertEquals(numRecs, arList.size(), 'Failed to create correct number of Approval Responses');   */                                                                            
    }                                          
      
    // Validate the auto approve groups. If there are groups that should not have been included then
    // pass in 'true' for the corresponding flag value to avoid failing an assert.
    private static void validateAutoApprovedGroups(Integer numGroups,
                                                   AIA_BRFSubmitArcApprovalCtrlExtension controller,
                                                   Boolean nascoBenefitCodingFlag,
                                                   Boolean benefactCodingFlag,
                                                   Boolean mastFlag,
                                                   Boolean bcmFlag,
                                                   Boolean benefitCodingFlag,
                                                   Boolean visionAnalystFlag,
                                                   Boolean benefitTesterFlag,
                                                   Boolean pharmacyManagementAndRxMarketingFlag,
                                                   Boolean rxMarketingFlag,
                                                   Boolean wellnessFlag,
                                                   Boolean dentalTeamFlag,
                                                   Boolean cdhTeamFlag)
    {                                             
        System.debug('Auto approve groups: ' + controller.autoApproveGrpList);
                                             
        // Make sure each record is associated with the BRF and has the correct status.
        for(String ag : controller.autoApproveGrpList)
        {   
            // Set the presense of business units flags.
            if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.NASCO_BENEFIT_CODING)
            {
                nascoBenefitCodingFlag = true;
            }
            else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.BENEFACT_CODING)
            {
                benefactCodingFlag = true;
            }
            else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.MAST)
            {
                mastFlag = true;
            }
            else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.BCM)
            {
                bcmFlag = true;
            }
            
            /*else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.ANCILLARY_ANALYST_SETUP)
            {
                ancillaryAnalystSetupFlag = true;
            }*/
              else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.AIA_VISION_GROUP)
            {
                visionAnalystFlag = true;
            }
            else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.BENEFIT_CODING)
            {
                benefitCodingFlag = true;
            }
            else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.BENEFIT_TESTING)
            {
                benefitTesterFlag = true;
            }
            
            else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.PHARMACY_MANAGEMENT)
            {
                pharmacyManagementAndRxMarketingFlag = true;
            }
            
            else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.WELLNESS)
            {
                wellnessFlag = true;
            }
            
            else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.DENTAL_TEAM)
            {
                dentalTeamFlag = true;
            }
            
            else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.CDH_TEAM)
            {
                cdhTeamFlag = true;
            } 
            else if(ag == AIA_BRFSubmitArcApprovalCtrlExtension.RX_MARKETING)
            {
                rxMarketingFlag = true;
            }    
        }  
        
       /* //System.assert(nascoBenefitCodingFlag,   'No committe group for NASCO Benefit Coding was found');
        System.assert(benefactCodingFlag,       'No committe group for Benefact Coding was found');
        System.assert(mastFlag,                 'No committe group for MAST was found');
        System.assert(bcmFlag,                  'No committe group for BCM was found');        
        //System.assert(ancillaryAnalystSetupFlag,'No committe group for Ancillary Analyst was found');  
        System.assert(benefitTesterFlag,'No committe group for Benefit Tester was found');
        System.assert(visionAnalystFlag,'No committe group for Vision Analyst was found');
        System.assert(benefitCodingFlag,'No committe group for Benefit Coder was found');
        System.assert(pharmacyManagementAndRxMarketingFlag,'No committe group for Pharmacy Mgmt was found');
        System.assert(rxMarketingFlag ,         'No committe group for RX Marketing was found'); 
        System.assert(wellnessFlag,             'No committe group for Wellness was found');
        System.assert(dentalTeamFlag,           'No committe group for Dental Team was found');
        System.assert(cdhTeamFlag,              'No committe group for CDH Team was found'); */
        
    //    System.assertEquals(numGroups, controller.autoApproveGrpList.size(), 
     //                       'Failed to notify correct number of committee groups');                                                                                                                                                           
    }        
                                                    
    // This method will test for record unlock errors.
    public static testMethod void TestUnlockFailureConditions()
    {
        // Test the empty list condition.
        try
        {
            AIA_BRFSubmitArcApprovalCtrlExtension.unlockBrf(new List<ID>());
            
            System.assert(false, 'Exception not thrown when empty ID list passed to in to unlock BRF');
        }
        catch (Exception e)
        {
            System.assertEquals('ERROR unlocking BRF record, no ID was passed to unlockBrf', e.getMessage(), 'Invalid error message in exception');
        }  
        
        try
        {
            AIA_BRFSubmitArcApprovalCtrlExtension.unlockBrf(new List<ID>{null});
            
            System.assert(false, 'Exception not thrown when NULL ID passed to in to unlock BRF');
        }
        catch (Exception e)
        {
            System.debug('Caught error unlocking BRF record, NULL ID was passed to unlockBrf: ' + e.getMessage());
        }           
    }
    
    // This method will test for the empty arc committee group list exception.
    public static testMethod void TestEmptyArcCommitteeGroupList()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
                
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);

        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Request_Type__c = 'Renewal';      
        update brf; 

        // Delete all products. 
        delete [SELECT id FROM Proposed_Products__c];  
    
        // Test the empty group list condition.
        try
        {
            controller.getArcCommitteeGroups(brf);
            
            System.assert(false, 'Exception not thrown when expecting an empty ARC Committe List to be detected');
        }
        catch (Exception e)
        {
            /*System.assertEquals('ERROR no ARC committe groups were found', e.getMessage(), 'Invalid error message in exception');*/
        }            
    }  
    
    // This method will test for the empty email list exception.
    public static testMethod void TestEmptyEmailList()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
                
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);  
    
        // Test the empty email list condition.
        try
        {
            List<String> grpList = new List<String>();
        
            controller.getGroupMemberEmailAddresses(grpList);
            
            System.assert(false, 'Exception not thrown when expecting an empty Email List to be detected');
        }
        catch (Exception e)
        {
            System.assertEquals('ERROR no group member email addresses were found', e.getMessage(), 'Invalid error message in exception');
        }            
    } 
    
    // This method will test for the empty email list exception.
    public static testMethod void TestUpdateBrfFailure()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
                
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);  
    
        // Test the empty email list condition.
        try
        {
            // A null ID on an update will throw an exception.  
            controller.brfRecId = null;
        
            controller.updateBrfRec(null, 'Approved',true);
            
            System.assert(false, 'Exception not thrown when expecting an update BRF error to be detected');
        }
        catch (Exception e)
        {
            System.debug('Exception correctly being thrown for BRF update exception: ' + e);
        }            
    }            

    // This method will test failures when processing a submitted BRF.
    public static testMethod void TestProcessSubmitErrors()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
                
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();
        
        // Pass in a null BRF to cause an exception.
        controller.processAutoApproved(null);
            
        System.debug('controller.msg: ' + controller.msg);    
        System.assert(controller.msg.contains('Failed during auto approval, aborted'), 'processAutoApproved did not detect the failure');
        
        // Pass in a null BRF to cause an exception.
        controller.processSubmitForApproval(null);
            
        System.debug('controller.msg: ' + controller.msg);    
        System.assert(controller.msg.contains('Failure during ARC submit to committee, submit aborted'), 'processSubmitForApproval did not detect the failure');        

        // Pass in a null BRF to cause an exception.
        controller.processSubmitForBcmApproval(null);
            
        System.debug('controller.msg: ' + controller.msg);    
        System.assert(controller.msg.contains('Failure during ARC submit for BCM approval, submit aborted:'), 'processSubmitForBcmApproval did not detect the failure');        

        test.stopTest();        
    }    
    
    public static testMethod void TestNewOppBRF()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Account acc =[select id from Account limit 1];
        
        
        test.startTest();
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
        opp.Business_Type__c = 'New';
        update opp;
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Renew As-is';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        insert brf;
                
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        controller.submitBrfForArchApproval();
        test.stopTest();        
    }  
    
    public static testMethod void TestOffcycleBRF()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        System.debug('Inserting user'); 
        User u4 = new User(Alias = 'TAlias26', Email='TestUserBRF345@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF36@testorg.com.test');
        insert u4;
        
        Account acc =[select id from Account limit 1];
        
        Id rt_Con_X51 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_X51;
        con.email           ='con@email.con';
        con.AccountId       = acc.id;
        insert con;
        
        
        test.startTest();
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
        
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Off-Cycle - Benefit Change';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        insert brf;
                
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        controller.submitBrfForArchApproval();
        
        test.stopTest();        
    }  
    
    public static testMethod void TestOffcycleBRF2()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        System.debug('Inserting user'); 
        User u4 = new User(Alias = 'TAlias26', Email='TestUserBRF345@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF36@testorg.com.test');
        insert u4;
        
        Account acc =[select id from Account limit 1];
        
        Id rt_Con_X51 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_X51;
        con.email           ='con@email.con';
        con.AccountId       = acc.id;
        insert con;
        
        
        test.startTest();
        
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
        
        system.runAs(u4){
            
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Off-Cycle - Benefit Change';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        insert brf;
                
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        controller.submitBrfForArchApproval();
        
        }
        
        test.stopTest();        
    }  
    
     public static testMethod void TestOffcycleBRF3()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        System.debug('Inserting user'); 
        User u4 = new User(Alias = 'TAlias26', Email='TestUserBRF345@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF36@testorg.com.test');
        insert u4;
        
       Account acc =[select id from Account limit 1];
        
        Id rt_Con_X51 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_X51;
        con.email           ='con@email.con';
        con.AccountId       = acc.id;
        insert con;
        
       
        
        test.startTest();
        
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
   
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Off-Cycle - Benefit Change';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        brf.sales__c = 'In Review';
        brf.Submit_to_Underwriting__c = true;
        insert brf;
                
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        controller.submitBrfForArchApproval();
        
        test.stopTest();        
    } 
    
     public static testMethod void TestOffcycleBRF4()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        System.debug('Inserting user'); 
        User u4 = new User(Alias = 'TAlias26', Email='TestUserBRF345@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF36@testorg.com.test');
        insert u4;
        
        Account acc =[select id from Account limit 1];
        
        Id rt_Con_X51 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_X51;
        con.email           ='con@email.con';
        con.AccountId       = acc.id;
        insert con;
        
       
        
        test.startTest();
        
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
   
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Off-Cycle - Benefit Change';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        
        brf.Submit_to_Underwriting__c = true;
        insert brf;
        
        brf.sales__c = 'Approved';
        update brf;
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        controller.submitBrfForArchApproval();
        
        test.stopTest();        
    } 
    
     public static testMethod void TestOffcycleBRF5()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        System.debug('Inserting user'); 
        User u4 = new User(Alias = 'TAlias26', Email='TestUserBRF345@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF36@testorg.com.test');
        insert u4;
        
        Account acc =[select id from Account limit 1];
        
        Id rt_Con_X51 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_X51;
        con.email           ='con@email.con';
        con.AccountId       = acc.id;
        insert con;
        
        
        
        test.startTest();
        
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
   
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Off-Cycle - Benefit Change';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Carefirst';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        insert brf;
        
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes(); 
        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = brf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom__c = false;
        aiaPP.RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1     
        aiaPP.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        aiaPP.Funding_Arrangement__c = 'Risk';
        aiaPP.FirstHelp__c = 'Yes';
        aiaPP.Custom_Core_DM_Wellness__c = True;
        aiaPP.Custom_Wellness__c = false;
        aiaPP.Stand_Alone_Wellness__c = 'No';
        aiaPP.Stand_Alone_Disease_Management__c = 'No';
        insert aiaPP;
        
        brf.ARC_Approval_Status__c = 'Pending';
        brf.sales__c = 'Approved';
        brf.Submit_to_Underwriting__c = true;
        update brf;
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        controller.submitBrfForArchApproval();
        
        test.stopTest();        
    } 
    
     public static testMethod void TestOffcycleBRF6()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        System.debug('Inserting user'); 
        User u4 = new User(Alias = 'TAlias26', Email='TestUserBRF345@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF36@testorg.com.test');
        insert u4;
        
       Account acc =[select id from Account limit 1];
        
        Id rt_Con_X51 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_X51;
        con.email           ='con@email.con';
        con.AccountId       = acc.id;
        insert con;
        
        
        
        test.startTest();
        
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
   
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Off-Cycle - Benefit Change';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Preferred - HM';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        BRF.Funding_Arrangements__c = 'ASO';
        insert brf;
        
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes(); 
        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = brf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom__c = false;
        aiaPP.RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1     
        aiaPP.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        aiaPP.Funding_Arrangement__c = 'Risk';
        aiaPP.FirstHelp__c = 'Yes';
        aiaPP.Custom_Core_DM_Wellness__c = True;
        aiaPP.Custom_Wellness__c = false;
        aiaPP.Stand_Alone_Wellness__c = 'No';
        aiaPP.Stand_Alone_Disease_Management__c = 'No';
        insert aiaPP;
        
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.sales__c = 'Approved';
        update brf;
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        controller.submitBrfForArchApproval();
        
        test.stopTest();        
    } 
    
     public static testMethod void TestOffcycleBRF7()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        System.debug('Inserting user'); 
        User u4 = new User(Alias = 'TAlias26', Email='TestUserBRF345@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF36@testorg.com.test');
        insert u4;
        
        Account acc =[select id from Account limit 1];
        
        Id rt_Con_X51 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_X51;
        con.email           ='con@email.con';
        con.AccountId       = acc.id;
        insert con;
        
        
        test.startTest();
        
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
   
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Set-up Change - Administrative Changes';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Preferred - HM';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        BRF.Funding_Arrangements__c = 'ASO';
        insert brf;
        
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes(); 
        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = brf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom__c = false;
        aiaPP.RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1     
        aiaPP.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        aiaPP.Funding_Arrangement__c = 'Risk';
        aiaPP.FirstHelp__c = 'Yes';
        aiaPP.Custom_Core_DM_Wellness__c = True;
        aiaPP.Custom_Wellness__c = false;
        aiaPP.Stand_Alone_Wellness__c = 'No';
        aiaPP.Stand_Alone_Disease_Management__c = 'No';
        insert aiaPP;
        
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.sales__c = 'Approved';

       // brf.Submit_to_Underwriting__c = true;
        update brf;
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        controller.submitBrfForArchApproval();
        
        test.stopTest();        
    } 
    
    public static testMethod void TestOffcycleBRF8()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        System.debug('Inserting user'); 
        User u4 = new User(Alias = 'TAlias26', Email='TestUserBRF345@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF36@testorg.com.test');
        insert u4;
        
        Account acc =[select id from Account limit 1];
        
        Id rt_Con_X51 = QueryBase.getRecordtypeId('Contact', 'X51');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_X51;
        con.email           ='con@email.con';
        con.AccountId       = acc.id;
        insert con;
        
        
        test.startTest();
        
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id); 
   
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
        brf.Request_Type__c = 'Prospect/New';
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'Both');
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.Account__c = acc.id;
        brf.ARC_Approval_Status__c = null;
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Opportunity__c = opp.id;
        brf.Jurisdiction__c = 'MD';
        brf.Enrollment_Type__c = 'Cafeteria';
        //brf.MHP_Test_Result__c = 'Pass';
        brf.EGWP_Picklist__c = 'Yes';
        brf.FlexLink_Picklist__c = 'Yes';
        brf.Benefit_Effective_Date__c = system.today();
        brf.Benefit_Period__c = 'Contract';
        brf.Control_Plan__c = '690';
        brf.Sales_Segment_Size__c = 'Commercial 200-999';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Non-Grandfathered';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Stop_Loss__c = 'Preferred - HM';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 50;
        brf.Identity_Protection__c = 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        BRF.Funding_Arrangements__c = 'Both';
        insert brf;
        
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes(); 
        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = brf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom__c = false;
        aiaPP.RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1     
        aiaPP.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        aiaPP.Funding_Arrangement__c = 'Risk';
        aiaPP.FirstHelp__c = 'Yes';
        aiaPP.Custom_Core_DM_Wellness__c = True;
        aiaPP.Custom_Wellness__c = false;
        aiaPP.Stand_Alone_Wellness__c = 'No';
        aiaPP.Stand_Alone_Disease_Management__c = 'No';
        insert aiaPP;
        
        brf.ARC_Approval_Status__c = 'Pending';
        brf.sales__c = 'Approved';

       // brf.Submit_to_Underwriting__c = true;
        update brf;
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        controller.submitBrfForArchApproval();
        
        test.stopTest();        
    } 
    
     public static testMethod void TestSoldBRF()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                                       

       
        
        test.startTest(); 
        
        Account acc = [select id,name from Account limit 1];
        set<id> setid = new set<id>();
       setid.add(acc.id);
        
        opportunity o = [select id from opportunity limit 1];
            
        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf2 = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 456 LIMIT 1];  
        brf2.Status__c = 'Sold';
        brf2.ARC_Approval_Status__c = 'Approved by Committee';
        brf2.Submit_to_Underwriting__c = false;
        AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
        update brf2;         
        
        
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Request_Type__c = 'Renew As-is';
        brf.Source_Benefit_Request_Form__c = brf2.id;  
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Submit_to_Underwriting__c = false;
        AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
        update brf;  
        
        List<Benfit_Request_Form__c> brflist = new List<Benfit_Request_Form__c>();
        brflist.add(brf);
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
       
        controller.submitBrfForArchApproval(); 
    
        
        brf = [SELECT id, Owner__c, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];
        
          //  insert brflist;
            //AIA_BRFTriggerHelper BTH = new AIA_BRFTriggerHelper();
            AIA_BRFTriggerHelper.processEmail(brflist,setid);
            
    
        List<FeedItem> feedItems = [SELECT ParentId, Body FROM FeedItem];
        
        
    
        test.stopTest();
    }  
    
    public static testMethod void TestApprovalstatusnotnull()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,Submit_to_Underwriting__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];       
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        // Test with Approval status not null
        brf.ARC_Approval_Status__c = 'Rejected'; 
        brf.Request_Type__c = 'RFP'; 
         //brf.MHP_Test_Result__c='Pass';
             update brf;  
    
        controller.submitBrfForArchApproval(); 
        
       /* System.assertEquals('Please complete Zip Code verification before submitting the BRF for ARC approval',
                             controller.msg,
                            'Failed to reject for VA missing zip code verification'); */
                            
                brf.Submit_to_Underwriting__c=true;
        update brf;  

        controller.submitBrfForArchApproval(); 
        
      
        test.stopTest();
    }     
   public static testMethod void Teststoplossnoncarefirstsetup()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,Submit_to_Underwriting__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];       
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        // Test with Approval status not null
        brf.Funding_Arrangements__c='Other';
        brf.ARC_Approval_Status__c = 'Auto-Approved by System'; 
        brf.Request_Type__c = 'Set-up Change - Admin and Benefit Changes'; 
         brf.Stop_Loss__c='Non-Preferred';
        //brf.MHP_Test_Result__c='Pass';

             update brf;  
    
        controller.submitBrfForArchApproval(); 
        
       /* System.assertEquals('Please complete Zip Code verification before submitting the BRF for ARC approval',
                             controller.msg,
                            'Failed to reject for VA missing zip code verification'); */
                            
              //  brf.Submit_to_Underwriting__c=true;
       // update brf;  

        //controller.submitBrfForArchApproval(); 
        
      
        test.stopTest();
    } 
    
     public static testMethod void TestApprovalstatusPending()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,Submit_to_Underwriting__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];       
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        // Test with Approval status not null
        brf.ARC_Approval_Status__c = 'Pending'; 
        brf.Request_Type__c = 'RFP'; 
         //brf.MHP_Test_Result__c='Pass';
             update brf;  
    
        controller.submitBrfForArchApproval(); 
        
       /* System.assertEquals('Please complete Zip Code verification before submitting the BRF for ARC approval',
                             controller.msg,
                            'Failed to reject for VA missing zip code verification'); */
                            
               // brf.Submit_to_Underwriting__c=true;
        //update brf;  

        //controller.submitBrfForArchApproval(); 
        
      
        test.stopTest();
    }
     public static testMethod void TestApprovalsalesRejected()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,Submit_to_Underwriting__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];       
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        // Test with Approval status not null
       // brf.ARC_Approval_Status__c = 'Pending'; 
        brf.Request_Type__c = 'Off-Cycle - Benefit Change'; 
        brf.Sales__c='Rejected';
         //brf.MHP_Test_Result__c='Pass';
             update brf;  
    
        controller.submitBrfForArchApproval(); 
test.stopTest();
    } 
     public static testMethod void TestApprovalsalesNA()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,Submit_to_Underwriting__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];       
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        // Test with Approval status not null
       // brf.ARC_Approval_Status__c = 'Pending'; 
        brf.Request_Type__c = 'Off-Cycle - Benefit Change'; 
        brf.Sales__c='N/A';
         //brf.MHP_Test_Result__c='Pass';
        brf.Submit_to_Underwriting__c=true;
             update brf;  
    
        controller.submitBrfForArchApproval(); 
test.stopTest();
    } 
    
    public static testMethod void Teststoplossnoncarefirstoffcycle()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,Submit_to_Underwriting__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];       
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        // Test with Approval status not null
        brf.Funding_Arrangements__c='Other';
        brf.ARC_Approval_Status__c = 'Auto-Approved by System'; 
        brf.Request_Type__c = 'Off-Cycle - Administrative and Benefit Change'; 
         brf.Stop_Loss__c='Non-Preferred';
        //brf.MHP_Test_Result__c='Pass';

             update brf;  
    
        controller.submitBrfForArchApproval(); 
        
       /* System.assertEquals('Please complete Zip Code verification before submitting the BRF for ARC approval',
                             controller.msg,
                            'Failed to reject for VA missing zip code verification'); */
                            
              //  brf.Submit_to_Underwriting__c=true;
       // update brf;  

        //controller.submitBrfForArchApproval(); 
        
      
        test.stopTest();
    }
    
    
     // This method will test for auto approval when BRF has a sold source BRF and requires
    // BCM approval.
    public static testMethod void TestAutoApproveWithSoldRequiresBCMApprovalNonStandard()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);

        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];                                       

        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest(); 
        
        // Retrieve a reference of the BRF.
        Benfit_Request_Form__c brf2 = [SELECT id FROM Benfit_Request_Form__c WHERE Contract_Count__c = 456 LIMIT 1];  
        brf2.Status__c = 'Sold';
        AIA_BRFTriggerHandler.hasSkipBRFVRs_CustPerm = true;
        update brf2;         
        
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        // Make BRF with a Non Standard product. 
        //brf.MHP_Test_Result__c = 'Pass'; 
        brf.Funding_Arrangements__c = 'Risk';
        brf.Request_Type__c = 'Renew As-is';
        brf.Source_Benefit_Request_Form__c = brf2.id;
        brf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'Risk');
        update brf;           
        delete [SELECT id FROM Proposed_Products__c];    
        
        Proposed_Products__c aiaPP = new Proposed_Products__c();
        aiaPP.Benefit_Request_Form__c = brf.id;
        aiaPP.Blue_Rewards__c = 'Standard';
        aiaPP.Custom_New__c = 'Non - Standard';
        aiaPP.Non_Standard_Fee_Schedule__c = 'Yes';
        aiaPP.Custom__c = false;
        Map<String,String> ppRecordTypes = getProposedProductsRecordTypes(); 
        aiaPP.RecordTypeId = ppRecordTypes.get('Medical Risk');  // changed by raj for R1E1 
        aiaPP.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';
        aiaPP.Funding_Arrangement__c = 'Risk';
        aiaPP.FirstHelp__c = 'Yes';
        //aiaPP.MHP_Test_Result__c = 'Pass';    
        insert aiaPP;         

        controller.submitBrfForArchApproval(); 
        
        System.assertEquals('Successfully submitted the Benefit Request Form for BCM Approval',
                             controller.msg,
                            'Failed to submit for BCM approval');
                            
        System.assertEquals(true, controller.displayPopup, 'Failed to display popup message to the user');
        
        brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                      ARC_Approval_Status__c, Days_to_Approve_BRF__c
               FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];        
        
        // Make sure the ARC Approval fields were set correctly.
        System.assertEquals(null, brf.ARC_Approval_Date__c, 'Failed to set BRF approval date correctly');
        System.assertEquals(Date.Today(), brf.ARC_Approval_Initial_Submission_Date__c, 'Failed to set BRF submitted date correctly');
        System.assertEquals('Pending', brf.ARC_Approval_Status__c, 'Failed to set ARC status correctly');
        System.assertEquals(null, brf.Days_to_Approve_BRF__c, 'Failed to set BRF days to approve correctly');
        
        // Pass in 'true' if the committee group should not be included to avoid assertion.
        validateApprovalRecords(1, brf.Id, true, true, true, false,true,true,true,true, true, true, true, true);
        
        System.assertEquals(true, Approval.isLocked(new List<String>{brf.id}).get(brf.Id), 'The record should be locked');  
  
        test.stopTest();
    }      
    
     
    
     public static testMethod void TestDeleteContact()
    {
        // Create the page.
        PageReference pageRef = Page.AIA_Arc_Approval_Submit;
        Test.setCurrentPage(pageRef);
        Account acc = [SELECT id, Name FROM Account WHERE Name = 'TestOEMAcc' LIMIT 1];
                                      
        contact con = [SELECT id, Name FROM contact WHERE Name = 'LastName' LIMIT 1];
             delete con;        

        Benfit_Request_Form__c brf = [SELECT id, ARC_Approval_Date__c, ARC_Approval_Initial_Submission_Date__c,
                                      ARC_Approval_Status__c, Days_to_Approve_BRF__c,Submit_to_Underwriting__c
                                      FROM Benfit_Request_Form__c WHERE Contract_Count__c = 123 LIMIT 1];       
        
        // Create an instance of the standard controller.
        ApexPages.StandardController stdCtrlr = new ApexPages.StandardController(brf);
  
        // Create an instance of the controller extension.
        AIA_BRFSubmitArcApprovalCtrlExtension controller = new AIA_BRFSubmitArcApprovalCtrlExtension(stdCtrlr);
        
        test.startTest();
        //Create AIA Document under the BRF
        AIA_Document__c fileNetDoc = new AIA_Document__c();
        fileNetDoc.Document_Type__c='Census Information';
        fileNetDoc.Benefit_Request_Form__c = brf.id;
        insert fileNetDoc;
        // Test with Approval status not null
       // brf.ARC_Approval_Status__c = 'Pending'; 
        brf.Request_Type__c = 'Off-Cycle - Benefit Change'; 
        brf.Sales__c='N/A';
         //brf.MHP_Test_Result__c='Pass';
             update brf;  
    
        controller.submitBrfForArchApproval(); 
test.stopTest();
    }   
}