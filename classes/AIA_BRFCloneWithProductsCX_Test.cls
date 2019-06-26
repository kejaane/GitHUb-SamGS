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
//Date: 06/18/2016
//Developer: Goutham Rapolu
//Purpose: Test class for AIA_BRFCloneWithProductsCX
//==================================================================================
// Update History
// Date         Developer               Description
// 
//==================================================================================
//06/18/2016    Goutham Rapolu     Initial Development
//==================================================================================

@isTest
public with sharing class AIA_BRFCloneWithProductsCX_Test {

    static testMethod void testBRFCloneWithProductsCX() {
    
        User u = AIA_TestUtil.createTestUser();
          System.runAs(u) {    
            
             // Create Account
             Account a = AIA_TestUtil.CreateAccount('TestAccount');
             system.assertNotEquals(null,a.id);
             
             // Create Opportunity
             Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
             system.assertNotEquals(null,o.id);
             
             // Create BRF
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
            
             
             List<Proposed_Products__c> aiaPPList = AIA_TestUtil.createListProposedProductsForASO(brf.id,'Pass');
             system.assertNotEquals(0,aiaPPList.size());
             
             // setup a reference to the page the controller is expecting with the parameters
            PageReference pref = Page.AIA_BRFCloneWithProducts;
            Test.setCurrentPage(pref);
            
            // Construct the standard controller
            ApexPages.StandardController con = new ApexPages.StandardController(brf);
    
            // create the controller
            AIA_BRFCloneWithProductsCX ext = new AIA_BRFCloneWithProductsCX(con);
    
            // Switch to test context
            Test.startTest();
    
            // call the cloneWithProducts method
            PageReference ref = ext.cloneWithProducts();
            // create the matching page reference
            PageReference redir = new PageReference('/'+ext.newBRF.id+'/e?retURL=%2F'+ext.newBRF.id);
    
            // make sure the user is sent to the correct url
            System.assertEquals(ref.getUrl(),redir.getUrl());
            
            // TODO: 6/22 - Validate that the BRF was created
    
            // check that the new Benfit_Request_Form__c was created successfully
            Benfit_Request_Form__c newBRF = [select id from Benfit_Request_Form__c where id = :ext.newBRF.id];
            System.assertNotEquals(newBRF, null);
            // check that the line item was created
            List<Proposed_Products__c> newItems = [Select p.Id,p.Benefit_Request_Form__c From Proposed_Products__c p where Benefit_Request_Form__c = :newBRF.id];
            system.assertNotEquals(0,newItems.size());
            system.assertEquals(newItems[0].Benefit_Request_Form__c,newBRF.id);
            // Switch back to runtime context
            Test.stopTest();
             
          }

    }

}