/*****************************************************************************************************
 *Date: 02-26-2018 
 *Developer: Goutham Rapolu
 *Purpose: Added logic to track Adjustments for Approval Response on BRF when BRF is resubmitted for ARC.
 *         as part of US713
 *====================================================================================================
 * Update History
 * Date         Developer               Description
 *====================================================================================================
 *     
 *======================================================================================================

*******************************************************************************************************/


public class AIA_ApprovalResponseHandler extends TriggerHandler{

    @TestVisible private static Boolean adjustmentPreviouslyCalled = false; 
    private static Boolean otherTriggersRunning = false; 
    
    public AIA_ApprovalResponseHandler(){}
    
    protected override void afterUpdate(){
    
    if(!otherTriggersRunning && !adjustmentPreviouslyCalled) {              
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(trigger.new, trigger.oldMap);//Call Adjustment Summary
        System.debug('In after update brf trigger handler, returned from populateAdjustmentSummary');
        adjustmentPreviouslyCalled = true;
    }else{
    System.debug('In after update brf trigger handler, populateAdjustmentSummary NOT called' +
                 ', otherTriggersRunning: ' + otherTriggersRunning +
                 ', adjustmentPreviouslyCalled: ' + adjustmentPreviouslyCalled);
        }
    }
}