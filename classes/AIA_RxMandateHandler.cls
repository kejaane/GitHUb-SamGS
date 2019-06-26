//=======================================================================================================================
// Date:       05/03/2017
// Developer:  Bill Dodson
// Purpose: AIA_RxMandateHandler Class, called by the RX Mandate trigger to perform processing.
//=======================================================================================================================
// Update History
// Date         Developer               Description
//=======================================================================================================================
// 03-01-2017    Bill Dodson  Initial development
//=======================================================================================================================

public class AIA_RxMandateHandler extends TriggerHandler {
    
    public AIA_RxMandateHandler(){}

    protected override void afterUpdate() {
        System.debug('In AIA_RxMandateHandler, calling populateAdjustmentSummary');
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(trigger.new, trigger.oldMap);//Bill
    }  
}