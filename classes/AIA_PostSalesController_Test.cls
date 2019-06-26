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
//Purpose: Test class for AIA_PostSalesController
//==================================================================================
// Update History
// Date         Developer               Description
// 
//==================================================================================
//06/18/2016    Goutham Rapolu     Initial Development
//==================================================================================
@isTest
public with sharing class AIA_PostSalesController_Test {
    
    static testMethod void testostSalesController() {
     // Switch to test context
     Test.startTest();
     User u = AIA_TestUtil.createTestUser();
     System.runAs(u) {  
         Account a = AIA_TestUtil.CreateAccount('TestAccount');
         system.assertNotEquals(null,a.id);
         
         // Create Opportunity
         Opportunity o = AIA_TestUtil.AIA_createopportunity(a.Id);
         system.assertNotEquals(null,o.id);
         system.debug('Opp'+o);
         
         // Create PRF
         PRF__c p = AIA_TestUtil.CreatePRF(o.Id);
         system.assertNotEquals(null,p.id);
         
         AIA_Implementation__c aiaImp = AIA_TestUtil.CreateImplementation(o.id);
         system.assertNotEquals(null,aiaImp);
         Apexpages.Currentpage().getParameters().put('id',aiaImp.id);
         ApexPages.StandardController testController = new ApexPages.StandardController(aiaImp);
         AIA_PostSalesController controllerObj = new AIA_PostSalesController(testController);
         controllerObj.getWorkplanData();
         AIA_PostSalesController.AIA_Process aiaprocess=new AIA_PostSalesController.AIA_Process();
         AIA_PostSalesController.AIA_SubProcess aiasubprocess=new  AIA_PostSalesController.AIA_SubProcess();
         aiaprocess.processName='test';
         aiaprocess.processCompletePercentage= 95;
         aiaprocess.processStatus = 'Inprogress';
         aiasubprocess.subProcessName='Test sub';
         aiasubprocess.subProcessURL ='';
         aiasubprocess.subProcessStatus =10;
         
     }
       Test.stopTest();
    }
    
}