/*=============================================================================================================
 * Date         : 03/30/2017
 * Developer    : Bill Dodson
 * Purpose      : This class is the extension point of the Trigger Framework for adding 
 *                Benefit Design Form trigger handlers.         
 *=============================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date        | Developer   | Tag  | Description
 *=============+=============+==================================================================================
 * 03/30/2017  | Bill Dodson |      | Initial Version    
 * 04/28/2017  | Bill Dodson | T01  | Add TestVisible to variable.   
 * 08/31/2017  | Sajitha Y   | T02  | calling AIA_MCP_FieldUpdates class in before update method     
 * 02/27/2017  | Phani		 | T03	| created before delete method for Defect 38848        
 *=============+=============+==================================================================================
 */

public with sharing class AIA_BenefitDesignFormTriggerHandler extends TriggerHandler {

 @TestVisible private static Boolean adjustmentPreviouslyCalled = false;  // T01

 protected override void beforeInsert() {

 }
 
 protected override void afterInsert() {

 }
 
 protected override void beforeUpdate() {
    //AIA_MCP_FieldUpdates.updatevendorph(Trigger.New);
}
 
 protected override void afterUpdate() {
    if(!adjustmentPreviouslyCalled)
    { 
        System.debug('Calling populateAdjustmentSummary from AIA_BenefitDesignFormTriggerHandler.afterInsert');
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(trigger.new, trigger.oldMap);   
    
        adjustmentPreviouslyCalled = true;
    }
    else
    {
        System.debug('Skipping populateAdjustmentSummary in AIA_BenefitDesignFormTriggerHandler.afterInsert');
    }
 }
//T03--Start
 protected override void beforeDelete(){
 //To make corresponding medical BDPs available for new BDF creation, if existing BDF is deleted
     AIA_BenefitDesignFormTriggerHelper.updateBdpStatus();  
 }
    //T03-- End
}