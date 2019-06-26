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
@isTest
private class AIA_WPAController_Test{
    static testMethod void testSave(){
        try{
        Test.startTest();
         //Create Account
        Account acc =AIA_TestUtil.createAccount('TestOEMAcc');
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id);     
        //Create PRF
        PRF__c prf = AIA_TestUtil.createPRF(opp.id);        
        /*Test.setCurrentPageReference(new PageReference('Page.WorkPlanAssignmentPage')); 
        System.currentPageReference().getParameters().put('PRFid', prf.id);
        AIA_Workplan_Assignment__c wp = new AIA_Workplan_Assignment__c();
        ApexPages.StandardController con = new ApexPages.StandardController(wp);
        AIA_WPAController wpaCtrl = new AIA_WPAController(con);
        //wpaCtrl.wpa.Process_Request_Form__c = prf.id;
        wpaCtrl.save();*/
        Test.stopTest();
        }
        catch(exception e){}
    }
     static testMethod void testnegativeSave(){
        try{
        Test.startTest();
        /*Test.setCurrentPageReference(new PageReference('Page.WorkPlanAssignmentPage')); 
        System.currentPageReference().getParameters().put('PRFid', null);
        AIA_Workplan_Assignment__c wp = new AIA_Workplan_Assignment__c();
        ApexPages.StandardController con = new ApexPages.StandardController(wp);
        AIA_WPAController wpaCtrl = new AIA_WPAController(con);        
        wpaCtrl.save();*/
        Test.stopTest();
        }
        catch(exception e){}
    }
}