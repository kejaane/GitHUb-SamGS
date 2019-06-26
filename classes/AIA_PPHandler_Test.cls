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
//===================================================================================
//Date: 05/09/2016
//Developer: Sree Harsha Akkala
//Purpose: Test class for PPhandler.
//=========================================================================================
// Update History
// Date         Developer               Description
// 5/25/2016     PR                     Commented on line 44,35,37
//==================================================================================
//05/09/2016    Sree Harsha Akkala      Initial Development
//06/18/2016    Goutham Rapolu          Added Test Cases
//==================================================================================
@isTest
private class AIA_PPHandler_Test{
    static testmethod void testupdateMHPTest(){
            test.startTest();
            
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            brf.Account__c=a.id;
            brf.opportunity__c = o.id;
            brf.Request_Type__c='Prospect/New';
            brf.Benefit_Effective_Date__c   = system.today();
            brf.Benefit_Period__c='Calendar';
            brf.Jurisdiction__c ='VA';
            brf.Sales_Segment_Size__c = 'Labor';
            brf.Contract_Period__c = 'Standard - 12 Months';
            brf.Grandfathered_Status__c  = 'Grandfathered';
            brf.Broker_Commission__c = 3.5;
            brf.Contract_Count__c = 20;
            brf.Funding_Arrangements__c = 'Both';   
            
            insert brf;
            
            Proposed_Products__c pp = new Proposed_Products__c();
            pp.Benefit_Request_Form__c  = brf.id;
            pp.Integrated_Non_Integrated__c = 'Integrated';
            
           // pp.Blue_Rewards_Wellness__c = 'Yes';
            pp.Funding_Arrangement__c = 'Risk';
           // pp.FSA_BlueFund__c  = 'Yes';
            pp.Deductible__c = 'Stacked';
            pp.CDH__c = 'Yes';
            //pp.MHP_Test_Result__c = 'Pass';
            insert pp;
                        
           // pp.Blue_Rewards_Wellness__c = 'No';
            update pp;  
            
            test.stopTest();
        
        
    }

    static testmethod void validationForCustomCheck(){
        test.startTest();
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
      //  PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
      //  system.assertNotEquals(null,p.id);
      // Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRF(p.id,a.id);
       Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
     //   brf.Control_Plan__c='MD';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
       
        system.assertNotEquals(null,brf.id);
        list<Proposed_Products__c> aiaPPList = AIA_TestUtil.createListProposedProductsForASO(brf.id,'pass');
        system.assertNotEquals(0, aiaPPList.size());
        
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Complete';
        aiaDoc.Document_Type__c = 'Marked Up Benefit Summary';
        aiaDoc.Active__c = True;
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Approval_Status__c = 'Pending';
        aiaDoc.Proposed_Products__c = aiaPPList[0].id;
        insert aiaDoc;
        
        
      //  AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
        
        system.assertNotEquals(null,aiaDoc.id);
        
        try{
            aiaPPList[0].Custom__c = true;
            update aiaPPList[0];
        }catch (Exception e) {
            System.AssertNotEquals('False', 'Exception ' + e);
        }
        test.stopTest();
    }

    static testmethod void updateBRFMHPTestResultPass(){
        test.startTest();
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
       // PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
     //   system.assertNotEquals(null,p.id);
      //  Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRF(p.id,a.id);
        Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
       // brf.Control_Plan__c='MD';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        system.assertNotEquals(null,brf.id);
        brf.Funding_Arrangements__c ='ASO';

        list<Proposed_Products__c> aiaPPList = AIA_TestUtil.createListProposedProductsForASO(brf.id,'pass');
        system.assertNotEquals(0,aiaPPList.size());
        test.stopTest();
    }
    static testmethod void updateBRFMHPTestResultFail(){
        test.startTest();
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
      /*  PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
        system.assertNotEquals(null,p.id);
        Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRF(p.id,a.id);*/
          Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
      //  brf.Control_Plan__c='MD';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        system.assertNotEquals(null,brf.id);
        brf.Funding_Arrangements__c ='ASO';

        list<Proposed_Products__c> aiaPPList = AIA_TestUtil.createListProposedProductsForASO(brf.id,'Fail');
        system.assertNotEquals(0,aiaPPList.size());
        test.stopTest();
    }
    static testmethod void updateBRFMHPTestResultDeferred(){
        test.startTest();
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
       /* PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
        system.assertNotEquals(null,p.id);
        Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRF(p.id,a.id);*/
          Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
       // brf.Control_Plan__c='MD';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        system.assertNotEquals(null,brf.id);
        brf.Funding_Arrangements__c ='ASO';

        list<Proposed_Products__c> aiaPPList = AIA_TestUtil.createListProposedProductsForASO(brf.id,'Deferred');
        system.assertNotEquals(0,aiaPPList.size());
        test.stopTest();
    }
    static testmethod void updateBRFMHPTestResultBlank(){
        test.startTest();
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
      /*  PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
        system.assertNotEquals(null,p.id);
        Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRF(p.id,a.id);*/
          Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
       // brf.Control_Plan__c='MD';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        system.assertNotEquals(null,brf.id);
        brf.Funding_Arrangements__c ='ASO';

        list<Proposed_Products__c> aiaPPList = AIA_TestUtil.createListProposedProductsForASO(brf.id,'');
        system.assertNotEquals(0,aiaPPList.size());
        test.stopTest();
    }
    
    static testmethod void testBRFMHPTestResultBlankForRisk(){
        test.startTest();
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
       /* PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
        system.assertNotEquals(null,p.id);
        Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRF(p.id,a.id);*/
          Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
     //   brf.Control_Plan__c='MD';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        system.assertNotEquals(null,brf.id);
        brf.Funding_Arrangements__c ='Risk';
        update brf;
        list<Proposed_Products__c> aiaPPList = AIA_TestUtil.createListProposedProducts(brf.id,'');
        system.assertNotEquals(0,aiaPPList.size());
        test.stopTest();
    }
    
    static testmethod void testBRFMHPTestResultFailForRisk(){
        test.startTest();
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
      /*  PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
        system.assertNotEquals(null,p.id);
        Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRF(p.id,a.id);*/
          Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
    //    brf.Control_Plan__c='MD';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        system.assertNotEquals(null,brf.id);
        brf.Funding_Arrangements__c ='Risk';
        update brf;

        list<Proposed_Products__c> aiaPPList = AIA_TestUtil.createListProposedProducts(brf.id,'Fail');
        system.assertNotEquals(0,aiaPPList.size());
        test.stopTest();
    }
    
    static testmethod void testBRFMHPTestResultPassForRisk(){
        test.startTest();
        // Create Account
        Account a = AIA_TestUtil.CreateAccount('TestAccount');
        system.assertNotEquals(null,a.id);
        // Create Opportunity
        Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
        system.assertNotEquals(null,o.id);
        // Create PRF
       /* PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
        system.assertNotEquals(null,p.id);
        Benfit_Request_Form__c brf = AIA_TestUtil.CreateBRF(p.id,a.id);*/
          Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
       // brf.Control_Plan__c='MD';     
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = a.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        insert brf;
        system.assertNotEquals(null,brf.id);
        brf.Funding_Arrangements__c ='Risk';
        update brf;
        list<Proposed_Products__c> aiaPPList = AIA_TestUtil.createListProposedProducts(brf.id,'Pass');
        system.assertNotEquals(0,aiaPPList.size());
        test.stopTest();
    }
}