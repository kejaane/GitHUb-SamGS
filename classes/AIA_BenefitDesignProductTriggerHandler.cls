/*=============================================================================================================
 * Date         : 03/7/2017
 * Developer    : Bill Dodson
 * Purpose      : This class is the extension point of the Trigger Framework for adding 
 *                Benefit Design Product trigger handlers.         
 *=============================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date        | Developer      | Tag  | Description
 *=============+=============+==================================================================================
 * 05/31/2016  | Bill Dodson    |      | Initial Version    
 * 03-20-2017  | Bill Dodson    |      | Enable adjustment summary code that was commented out.   
 * 05/23/2017  | satya          |  T01 | Added a method from AIAProductNamesDrawloop class that is used for Drawloop
                                      Purpose   
 * 06/27/2017  | Rajesh Pennam  |  T02 | Added a method AIARelatedAncillaryProductDrawloop that is used for Drawloop  
                                         and commented the unwanted logic  
 * 06/30/2017  | Rajesh Pennam  |  T03 | Added recursive check to insert and delete functionality                                                           
 *=============+=============+==================================================================================
 */

public with sharing class AIA_BenefitDesignProductTriggerHandler extends TriggerHandler {

 private static Boolean adjustmentPreviouslyCalled = false;    
 public  static Boolean CheckRecursion = True;
 protected override void beforeInsert() {

 }
 
 protected override void afterInsert() {
  //if(CheckRecursion)
    //{ 
        system.debug('Loop Trigger');
        //AIAProductNamesDrawloop.updateBDFproductFields(trigger.new);  //T02 Rajesh Pennam Commented this class since this logic is no longer in use
        AIARelatedAncillaryProductDrawloop.UpdateBDPFields(trigger.new);//T02
    
        CheckRecursion = false;
    //}
    
 }
 
 protected override void beforeUpdate() {
    
 }
 
 protected override void afterUpdate() {
    if(!adjustmentPreviouslyCalled)
    { 
        System.debug('Calling populateAdjustmentSummary from AIA_BenefitDesignProductTriggerHandler.afterInsert');
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(trigger.new, trigger.oldMap);//Bill    
    
        adjustmentPreviouslyCalled = true;
    }
 }
 
 protected override void beforedelete() {
  if(CheckRecursion)
    { 
        System.debug('Calling populateAdjustmentSummary from AIA_BenefitDesignProductTriggerHandler.beforedelete');
        AIARelatedAncillaryProductDrawloop.deleteBDPFields(trigger.old);//T02
    
        CheckRecursion = false;
    }
    
 }

}