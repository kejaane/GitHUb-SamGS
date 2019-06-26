/*===========================================================================================================
 * Date         : 05/31/2016
 * Developer    : chidananda Nagaaj
 * Purpose      : This class is the extension point of the Trigger Framework for adding 
 *                Implementation trigger handlers.         
 *===========================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         | Developer  | Tag  | Description
 *===========+============+==================================================================================
 * 05/31/2016  |  GN         |      | Initial Version                                         
 * 11/21/2016   | Asif K     | T01  | Added method call to update revision number & date on the associated 
 *                                    implementation record. 
 * 03/13/2017  | Sree Harsha | T02  | Query the custom setting AIA config and check the value.
 *                                    If value is true and is allowed to run, then execute the method.
 * 03/20/2017  | Sree Harsha | T03  | Added method call AIA_CalculateDaysDiffExcludingHoliday.calApprovalResponseDay 
 *                                    in beforeUpdate which calculates Approval Response in Days based on  
 *                                     Approval Start & End date excluding holidays and business days.
 * 03/23/2017  | Bill Dodson | T04  | Merge in adjustment summary code.
 * 04/16/2017  | Asif K      | T05  | Commented method call updateRevisionNumber & added method call to the
 *                                    to the method setRevisionNumber
 * 07/31/2017  | Rajesh Penam| T06  | Added a method call update the CDHFundType Checker for BDF Admin
 * 08/28/2017  | Bill Dodson | T07  | Add logic to generate adjustment summary records when BD status is 
 *                                    "In Review".
 * 
 *  23/02/2018  | Debkanti   | T08  | Added a logic to change AIA_Approval_Status field value to false
 *  05/11/2018  | Debkanti   | T09  | Change the method to accmodate the group structure on  
 *                                      AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords
 *  05/28/2018  | Gayathri   | T10  | Added as a part of US1728 to send notification to Acc Team when
 *                                    BD status changes to Approved
 *  06/23/3018  | Satya      | T11  | Removed the process builder & added to resolve SOQL 101 error
 *  08/30/2018  |Phani       | T12  |To stop executing trigger in case of batch job execution to avoid issue 
 * 									 with future call
 *===========+============+==================================================================================
 */
 

public without sharing class AIA_BenefitDesignTriggerHandler extends TriggerHandler {

  @TestVisible private static Boolean adjustmentPreviouslyCalled = false; // T04
  private static Boolean otherTriggersRunning = false; // T04
  @testVisible private static Boolean FirstRun = false;
  @testVisible public static Boolean BDstatus = false;
  map<id,string> BDStatusMap = new map<id,string>();
  
  
  protected override void beforeInsert() {
    otherTriggersRunning = true; // T04
    //Chida - Added for creating the workplan stages on opp
    if(!FirstRun){
    AIA_BenefitDesignApproversHelper.beforeUpdateTeamMember((list<AIA_Benefit_Design__c>) trigger.new);
    }
    //Added by rajesh T06
    AIA_BD_CDHFundType_Checker.updateBDCheck((list<AIA_Benefit_Design__c>) trigger.new);
    otherTriggersRunning = false; // T04
 }
 
 protected override void afterInsert() {
    otherTriggersRunning = true; // T04 
    //check if custom setting has this value - T02 Start      
    AIA_Config__c runMethod = AIA_Config__c.getInstance('BDTHelper.createBenefitDesignProduct'); // Sree Harsha  
    if(!Firstrun){
    //if value found and is allowed to run, then execute the method     
    if(runMethod != null && runMethod.run__c) // Sree Harsha - T02 End
    AIA_BenefitDesignTriggerHelper.createBenefitDesignProduct((Map<id,AIA_Benefit_Design__c>) trigger.newmap); 
    AIA_BenefitDesignTriggerHelper.updateAIADocument((list<AIA_Benefit_Design__c>) trigger.new);
    AIA_BenefitDesignTriggerHelper.setRevisionNumber((list<AIA_Benefit_Design__c>)  trigger.new);//T02
    otherTriggersRunning = false; // T04
    }
 }
 
 protected override void beforeUpdate() {
    otherTriggersRunning = true; // T04
    //Chida - Added for creating the workplan stages on opp
    if(!Firstrun){
        system.debug('before update');
    AIA_BenefitDesignApproversHelper.beforeUpdateTeamMember((list<AIA_Benefit_Design__c>) trigger.new);
    AIA_CalculateDaysDiffExcludingHoliday.calApprovalResponseDay((list<AIA_Benefit_Design__c>) trigger.new); //Sree Harsha - T03
        otherTriggersRunning = false; // T04
    }
 }
 
  protected override void afterUpdate() {
     // T04 begin
     if(!otherTriggersRunning && !adjustmentPreviouslyCalled) { // Bill
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(trigger.new, trigger.oldMap);//Bill
        System.debug('In after update bd trigger handler, returned from populateAdjustmentSummary');
        adjustmentPreviouslyCalled = true;
        // T07
        // If the status changes to In Review then generate Adjustment Summary records.
        List<AIA_Benefit_Design__c> bdInReviewList = new List<AIA_Benefit_Design__c>();
        List<AIA_Benefit_Design__c> bdInReviewListUpdate = new List<AIA_Benefit_Design__c>();
        for(AIA_Benefit_Design__c bd : (List<AIA_Benefit_Design__c>)trigger.new) {
            if(bd.Status__c == 'In Review' && ((AIA_Benefit_Design__c)trigger.oldMap.get(bd.id)).Status__c != 'In Review') {
                bdInReviewList.add(bd);
                BDStatusMap.put(bd.Implementation__c,'In Review');
            } 
             /* T08 Start*/ 
            System.debug('HelloTest: '+bd.Status__c);
             System.debug('HelloTest1: '+((AIA_Benefit_Design__c)trigger.oldMap.get(bd.id)).Status__c);
            system.debug('BdId: '+bd.id);
            system.debug('BdId1: '+bd);
             System.debug('HelloTest12: '+((AIA_Benefit_Design__c)trigger.oldMap.get(bd.id)));
            
            
            if((bd.Status__c == 'Approved' || bd.Status__c == 'Rejected') && ((AIA_Benefit_Design__c)trigger.oldMap.get(bd.id)).Status__c == 'In Review'){
                System.debug('Found3 '+bd.Status__c);
                AIA_Benefit_Design__c bdesign = new AIA_Benefit_Design__c(ID =bd.id);
                System.debug('Found4 '+ bdesign);
                bdesign.AIA_Approval_Status__c = false;
                System.debug('Found5 '+ bdesign.AIA_Approval_Status__c);
                bdInReviewListUpdate.add(bdesign);
                System.debug('Found6 '+bdInReviewListUpdate);
                if(bd.Status__c == 'Approved'){
                BDStatusMap.put(bd.Implementation__c,'Approved');
                }else{BDStatusMap.put(bd.Implementation__c,'Rejected');}
            }
        }
         update bdInReviewListUpdate;
         /* T08 End*/ 
        System.debug('Found ' + bdInReviewList.size() + ' In Review BDs for Adjustment Summary');
        if(bdInReviewList.size() > 0)
        {
            //R1 Deployment
			// AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(null, bdInReviewList, null); //T09 
			 AIA_AdjustmentSummaryUtils.summarizeAdjustmentRecords(null, bdInReviewList);  
        }         
        // T07
    } 
    else {
        System.debug('In after update bd trigger handler, populateAdjustmentSummary NOT called' +
                     ', otherTriggersRunning: ' + otherTriggersRunning +
                     ', adjustmentPreviouslyCalled: ' + adjustmentPreviouslyCalled);
    }
    // T04 end
    if(!Firstrun){
    AIA_BenefitDesignTriggerHelper.updateAIADocument((list<AIA_Benefit_Design__c>) trigger.new);
    }
    /*AIA_BenefitDesignTriggerHelper.updateRevisionNumber((Map<id,AIA_Benefit_Design__c>) trigger.oldMap,
                                                        (Map<id,AIA_Benefit_Design__c>) trigger.newMap);//T01 */ 
    //T10 - changes start
      AIA_SendEmail_Notification notify = new AIA_SendEmail_Notification();
    notify.notifyBDAccTeamMember(trigger.new,(Map<Id,AIA_Benefit_Design__c>) Trigger.OldMap);
      //T10 -- changes ends 
      //
      if(!System.isBatch()){ //T12
     	updateBdStatus(BDStatusMap); //T11  
      } 
  }
  
   /*T11 changes*/
  @future
  private static void updateBdStatus(map<id,string> BDStatusMap){
  list<AIA_Implementation__c > impList = new list<AIA_Implementation__c>();
      if(!BDStatusMap.isEmpty()) {
          for(AIA_Implementation__c imp:[select id,BenefitDesign_Status__c from AIA_Implementation__c where id in:BDStatusMap.keyset()]){
              imp.BenefitDesign_Status__c = BDStatusMap.get(imp.id);
              impList.add(imp);
          }
      }
      if(!impList.isEmpty()){
          update impList;
          
      }
   }
   /* T11 change ends*/
  }