/*****************************************************************************************************
*Date: 11-22-2016 
*Developer: Indira Das
*Purpose: AIA Benefit Triger handler class for Benefits handler

*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
*11-22-2016   Indira Das     Initial Development
*03-23-2017   Bill Dodson    T01   Merge in adjustment summary logic.
*03-24-2017   Bill Dodson    N/A   Uncomment out adjustment summary code that someone 
*                                  commented out.
*07-11-2017   Raviteja V     T01-1 Add recursion check and remove !test.isrunningtest()
*09-06-2017   Bill Dodson    T02   Only create delete adj records for Benefit type records.
*09-08-2017   Bill Dodson    T03   Delete child Limitations so that the Limitation trigger
*                                  will get called.
*==================================================================================

*******************************************************************************************************/

public class AIA_BenefitTriggerHandler extends TriggerHandler  {
    
    
    public AIA_BenefitTriggerHandler(){}
    
    // T01 begin
    // This flag is used to prevent recursion caused by records updates from triggers or workflow rules.
    @TestVisible private static Boolean adjustmentPreviouslyCalled = false;
    private static Boolean allowAdjustmentsOnInserts = false;
    public static Boolean UpdatecustomizedProperties=false;
    private static Boolean drugBenefitUpdate=false;
    
    protected override void beforeUpdate() {
        // T01-1 start    -   removed test method and added recursioncheck
    if(!test.isrunningtest() ){
		  //if(!UpdatecustomizedProperties){
      System.debug('In AIA_BenefitTriggerHandler.beforeUpdate, calling UpdatecustomizedProperties');
      AIA_BenefitTriggerHelperClass.UpdatecustomizedProperties((List<AIA_Benefits__c>) trigger.new); 
          UpdatecustomizedProperties=true;  
        }
    }
    
    public static void enableAdjustmentsOnInserts() {  
        System.debug('In AIA_BenefitTriggerHandler, enabling adjustment inserts');  
        allowAdjustmentsOnInserts = true;
    }
    
    public static void disableAdjustmentsOnInserts() { 
        System.debug('In AIA_BenefitTriggerHandler, disabling adjustment inserts');     
        allowAdjustmentsOnInserts = false;
    }    
    
    // Reset the flag if a form will call update on benefits more than once.
    public static void resetAdjustmentPreviouslyCalledFlag() {
        adjustmentPreviouslyCalled = false;
    }
    
    public static void disableAdjustmentsOnUpdates() { 
        System.debug('In AIA_BenefitTriggerHandler, disabling adjustment updates');     
        adjustmentPreviouslyCalled = true;
    }
    // T01 end    
    
    protected override void afterUpdate() {
       // T01 begin
       System.debug('At the top of AIA_BenefitTriggerHandler.afterUpdate');
       if(!adjustmentPreviouslyCalled){
           System.debug('Calling populateAdjustmentSummary from AIA_BenefitTriggerHandler.afterUpdate');
           AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(trigger.new, trigger.oldMap);//Bill
           adjustmentPreviouslyCalled = true;
       }
       else
       {
           System.debug('Not calling populateAdjustmentSummary from AIA_BenefitTriggerHandler.afterUpdate');
       }
       System.debug('At the bottom of AIA_BenefitTriggerHandler.afterUpdate'); 
       // T01 end   
       // T01-1 start -   removed test method and added recursioncheck
       //if(!test.isrunningtest() ){
       if(!drugBenefitUpdate){
            system.debug('In drugBenefitUpdate');
          AIA_BenefitTriggerHelperClass.drugBenefitUpdate((List<AIA_Benefits__c>)trigger.new,(Map<id,AIA_Benefits__c> )trigger.oldMap); 
           drugBenefitUpdate=true;
       }
     // AIA_BenefitTriggerHelperClass.filterPPTobeProcessIfCustomized((Map<id,AIA_Benefits__c> )trigger.newMap,(Map<id,AIA_Benefits__c> )trigger.oldMap);
   }
   protected override void afterInsert() {
       // T01 begin
       System.debug('At the top of AIA_BenefitTriggerHandler.afterInsert');
       if(allowAdjustmentsOnInserts) 
       {
           System.debug('In AIA_BenefitTriggerHandler.afterUpdate, calling populateAdjustmentSummaryAfterInsert');
           AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterInsert(trigger.new);
       }
       System.debug('At the bottom of AIA_BenefitTriggerHandler.afterInsert');      
       // T01 end
    //   AIA_BenefitTriggerHelperClass.filterPPTobeProcessIfCustomized((Map<id,AIA_Benefits__c> )trigger.newMap,null);
   }
   // T01, add this method.
   protected override void beforeDelete() {
      System.debug('In AIA_BenefitTriggerHandler.beforeDelete, num records: ' + trigger.old.size());
      // Begin T02, do not process mandate and limitation records.
      List<AIA_Benefits__c> benList = new List<AIA_Benefits__c>();
      List<AIA_Benefits__c> limList = new List<AIA_Benefits__c>(); // T03
      for(AIA_Benefits__c ben : (List<AIA_Benefits__c>)trigger.old)
      {
          if(ben.Benefit_Type__c == 'Benefit')
          {
              benList.add(ben);
          }
          else
          {
              limList.add(ben);
          }
      }
      
      System.debug('In AIA_BenefitTriggerHandler.beforeDelete, benList.size(): ' + benList.size() + ', limList.size(): ' + limList.size());

      if(benList.size() > 0)
      {
          System.debug('In AIA_BenefitTriggerHandler.beforeDelete, calling populateAdjustmentSummaryAfterDelete');
          AIA_AdjustmentSummaryUtils.populateAdjustmentSummaryAfterDelete(benList);
      }
      
      if(limList.size() > 0)
      {
          // Delete child limitation records so that the Limitations__c trigger will get invoked to create adjustment records.
          List<Limitations__c> childList = [SELECT id FROM Limitations__c WHERE Benefit__c IN :limList];
          
          System.debug('In AIA_BenefitTriggerHandler.beforeDelete, found ' + childList.size() + ' child records');
          
          delete childList;
      }

      // End T02
   }  
    
  
     
}