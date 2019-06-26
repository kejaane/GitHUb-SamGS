/*****************************************************************************************************
 *Date: 03-30-2017
 *Developer: Bill Dodson
 *Purpose: Used to test the Benefit Design Product Trigger Handler class.
 *=========================================================================================
 * Update History
 * Date         Developer               Description
 *==================================================================================
 * 03-30-2017    Bill Dodson  |   |  Initial Development
 * 05-05-2017    Bill Dodson  |T01|  Add call to setUpTestData.
 * 02-28-2018    Gayathri P   |T02|  Added a test method for checking BDF Delete
 *==================================================================================

 *******************************************************************************************************/
@isTest
private class AIA_BenefitDesignFormTriggerHdlr_Test{

     @testSetup
    static  void testdata(){
      AIA_AdjustmentSummaryUtils_Test.setUpTestData();
     }  
    static testmethod void testAdjustementSummary(){
        //AIA_AdjustmentSummaryUtils_Test.setUpTestData(); // T01
        AIA_AdjustmentSummaryUtils_Test.testAdjustmentSummary();
    }  
	
	//T02--Start
    static testmethod void testBDFDelete(){
        //AIA_AdjustmentSummaryUtils_Test.setUpTestData();
 		Test.startTest();
        AIA_Benefit_Design_Form__c bdfRec = [select id,name from AIA_Benefit_Design_Form__c limit 1];
        AIA_Benefit_Design_Product__c bdp= [select id,name,Benefit_Design__c from AIA_Benefit_Design_Product__c Limit 1];
        bdp.Benefit_Design_Form__c = bdfRec.Id;
        bdp.Product_Category__c = 'Medical';
        update bdp;
        system.debug('BDF Record Id:'+bdfRec);
        delete bdfRec;
        Test.stopTest();
            }  
    //T02--End
}