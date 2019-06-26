//=======================================================================================================================
// Date:       02/02/2017
// Developer:  Satya
// Purpose: AIA_GrouperHandler Class, called by the trigger framework whenever the Grouper trigger fires.
//=======================================================================================================================
// Update History
// Date         Developer               Description
//=======================================================================================================================
// 03-01-2017    Bill Dodson  |   | Comment out calls to populateAdjustmentSummary.  The uesr is not able to add or edit
//                                  Grouper records so do not create Adjustment Summary records for these record
//                                  inserts and updates.
// 03-27-2017    Bill Dodson        Delete adjustment summary code no longer used.
// 05-03-2017    Bill Dodson        User Story B-03921 says changes to Grouper must be tracked.
//=======================================================================================================================

public class AIA_GrouperHandler extends TriggerHandler {
    
    public AIA_GrouperHandler(){}

    protected override void afterUpdate() {
        System.debug('In AIA_GrouperHandler, calling populateAdjustmentSummary');
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(trigger.new, trigger.oldMap);//Bill
    }
    
    protected override void afterInsert() {
    
    }    
}