/*****************************************************************************************************
*Date: 09-16-2016 
*Developer: Indira Das
*Purpose: handle class foe Limitation trigger 
This is used to merge all teh comment codes and max rows and tier rows and update the benefit
*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
*09-16-2016    Indira Das     Initial Development
*03-23-2017    Bill Dodson   T01   Merge in adjustment summary code.
*05-06-2017    Bill Dodson   T02   Add TestVisible to adjustmentPreviouslyCalled attribute.
*==================================================================================

*******************************************************************************************************/


public class AIA_BenefitCommentCodesTriggerHandler extends TriggerHandler  {
    public static boolean FirstRun = false;
    // T01 begin
    @TestVisible private static Boolean adjustmentPreviouslyCalled = false; // T02
    @TestVisible private static Boolean otherTriggersRunning = false; 
    @TestVisible private static Boolean allowAdjustmentsOnInserts = false;   

    public static void enableAdjustmentsOnInserts() {  
        System.debug('In AIA_BenefitCommentCodesTriggerHandler, enabling adjustment inserts');  
        allowAdjustmentsOnInserts = true;
    }
    
    public static void disableAdjustmentsOnInserts() { 
        System.debug('In AIA_BenefitCommentCodesTriggerHandler, disabling adjustment inserts');     
        allowAdjustmentsOnInserts = false;
    }    
    
    public static void enableAdjustmentsOnUpdates() {  
        System.debug('In AIA_BenefitCommentCodesTriggerHandler, enabling adjustment updates');  
        adjustmentPreviouslyCalled = false;
    }
    // T01 end
    
    public static void disableAdjustmentsOnUpdates() { 
        System.debug('In AIA_BenefitCommentCodesTriggerHandler, disabling adjustment updates');     
        adjustmentPreviouslyCalled = true;
    }    
     
    public AIA_BenefitCommentCodesTriggerHandler(){}
    
    protected override void afterUpdate() {
       // T01 begin
       System.debug('At the top of AIA_BenefitCommentCodesTriggerHandler.afterUpdate');
      /*if(FirstRun == false){
       AIA_BenefitCommentCodeTRiggerHelper.concatenateBenefitCommentsCode((Map<id,Limitations__c> )trigger.newMap,(Map<id,Limitations__c> )trigger.oldMap );  
      FirstRun = true;
      }*/
      AIA_BenefitCommentCodeTRiggerHelper.concatenateBenefitCommentsCode((Map<id,Limitations__c> )trigger.newMap,(Map<id,Limitations__c> )trigger.oldMap );
       if(!otherTriggersRunning && !adjustmentPreviouslyCalled){
           System.debug('Calling populateAdjustmentSummary from AIA_BenefitTriggerHandler.afterUpdate');
           AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(trigger.new, trigger.oldMap);
           adjustmentPreviouslyCalled = true;
       }
       // T01 end
       System.debug('At the bottom of AIA_BenefitCommentCodesTriggerHandler.afterUpdate'); // T01
    }
    
    protected override void afterInsert() {
       System.debug('At the top of AIA_BenefitCommentCodesTriggerHandler.afterInsert'); // T01
       if(FirstRun == false){
       AIA_BenefitCommentCodeTRiggerHelper.concatenateBenefitCommentsCode((Map<id,Limitations__c> )trigger.newMap,null); 
        FirstRun = true;
        }
       otherTriggersRunning = true; // T01
       // T01 begin
       if(allowAdjustmentsOnInserts) 
       {
           System.debug('In AIA_BenefitCommentCodesTriggerHandler.afterUpdate, calling populateAdjustmentSummaryAfterInsert');
           AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterInsert(trigger.new);
       } 
       otherTriggersRunning = false; 
       System.debug('At the bottom of AIA_BenefitCommentCodesTriggerHandler.afterInsert');
       // T01 end                
    }    
    
    // T01, newly added method.
    protected override void beforeDelete() {
        System.debug('In AIA_BenefitCommentCodesTriggerHandler.afterDelete, calling populateAdjustmentSummaryAfterDelete');
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterDelete(trigger.old);
    }         
}