/*****************************************************************************************************
 *Date: 05-05-2017
 *Developer: Bill Dodson
 *Purpose: Used to test the Grouper Trigger Handler class.
 *=========================================================================================
 * Update History
 * Date         Developer               Description
 *==================================================================================
 * 05-05-2017    Bill Dodson  |   |  Initial Development
 * 
 *==================================================================================

 *******************************************************************************************************/
@isTest
private class AIA_GrouperTriggerHdlr_Test{

    @testSetup 
    static  void testAdjustementSummary(){
      AIA_AdjustmentSummaryUtils_Test.setUpTestData();
     }  
     static testmethod void testmethod1(){
      AIA_AdjustmentSummaryUtils_Test.testAdjustmentSummary();
     }      
}