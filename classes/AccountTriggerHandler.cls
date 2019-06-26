/*=========================================================================================
 * Date     : 10/21/2014
 * Developer    : Ken Gill
 * Purpose      : This class is the extension point of the Trigger Framework for adding Account trigger handlers.
 *                
 *               
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/17/14  |  KG            | Initial Version                                         
 *           |                | 
 * 08/21/17  |  Bill Dodson   | Generate adjustment summary records for account field
 *                              for 200+ records.
 * 03/01/18  | SAM            | AR CHange
 * 05/15/2018|  Sajitha Y |T01| Calling AIA_CreateDefaultAccountTeamMember to get default Account team  
 *                                when Account is created as per US1789
 * 6/26/2019 10:28 | Alex change
 *===========+============+================================================================
 */


public with sharing class AccountTriggerHandler extends TriggerHandler {
//Alex
    @TestVisible private static Boolean adjustmentPreviouslyCalled = false; // Bill
    private static Boolean otherTriggersRunning = false; // Bill 

    public AccountTriggerHandler() {}
    
        /* context override */
    protected override void beforeUpdate() {
        otherTriggersRunning = true;  // Bill
        RenewalDateUpdate((List<Account>) Trigger.new);
        otherTriggersRunning = false; // Bill
    }
    
    protected override void beforeInsert() {
        otherTriggersRunning = true;  // Bill
        RenewalDateUpdate((List<Account>) Trigger.new);
        otherTriggersRunning = false; // Bill
    }
    
    protected override void afterInsert() {
       otherTriggersRunning = true;  // Bill
       
       otherTriggersRunning = false; // Bill
        // T01 - Start
      AIA_CreateDefaultAccountTeamMember.getAccounts(Trigger.new);
        // T01 - End
    }
    
    protected override void afterUpdate() {
        // Bill 8/21/2017 begin
        if(!otherTriggersRunning && !adjustmentPreviouslyCalled) {  
            adjustmentPreviouslyCalled = true;
            // If its a large group account then generate Adjustment Summary records.
            List<Account> lgAcctList = new List<Account>();
            for(Account acct : (List<Account>)trigger.new) {
                if(acct.X200_Account__c == true) {
                    lgAcctList.add(acct);
                } 
            }
            System.debug('Found ' + lgAcctList.size() + ' large group account records for Adjustment Summary');
            if(lgAcctList.size() > 0) {
                AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(lgAcctList, trigger.oldMap);
                System.debug('In after update account trigger handler, returned from populateAdjustmentSummary');
            }  
        } 
        else {
            System.debug('In after update account trigger handler, populateAdjustmentSummary NOT called' +
                         ', otherTriggersRunning: ' + otherTriggersRunning +
                         ', adjustmentPreviouslyCalled: ' + adjustmentPreviouslyCalled);
        } // Bill 8/21/2017 end     
    
        processAfterEGPAccountUpdate();
        
        // For 632.0
        processBrokerHubAccountUpdate();
    }

private void processAfterEGPAccountUpdate() {
        if(System.isBatch() || System.isFuture()) {
        System.debug('AccountTriggerHandler: Bypassing EGP Account update processing when called from a batch job');
        return;
    }   
    
      // Note on casting below:
      // Outside a trigger, the trigger collections Trigger.new,.old have to be explicitly cast to the SOBject type
      // When working inside a trigger, this casting happens implicitly
      EGPService.processAccountUpdateChanges(( List<Account>) Trigger.new, (Map<Id,Account>) Trigger.oldMap);
}

private  void  RenewalDateUpdate(list<account> accountList){
    for(account acc:accountList){   
        // If renewal date is less then the first day of the current month
        if(acc.Renewal_Date__c < system.today().toStartOfMonth()){            
            // Set the final renewal date to the current renewal date + 1 year
            acc.Final_Renewal_Date__c =acc.Renewal_Date__c.addYears(1);
        }
        else{
            // Set the final renewal date to the current date
            acc.Final_Renewal_Date__c =acc.Renewal_Date__c;
        }

    }
}

// Added by Ahilesh for 632.0 project
 public static boolean isFirstTime = true;
 private void processBrokerHubAccountUpdate(){
     
     Map<id,Account> tnewMap = new Map<id,Account>();        //opp Mapping for new value
     Map<id,Account> toldMap = new Map<id,Account>();        //opp Mapping for old value
     list<Id> updatedAcctIds = new list<Id>();
     list<Id> oppIds = new list<Id>();
     list<Opportunity> oppList = new list<Opportunity>();
     
     tnewMap  = (Map<id,Account>)Trigger.newMap;
     toldMap  = (Map<id,Account>)Trigger.oldMap;
    
        for(Account a:tnewMap.values()){
            if(a.Agency_NPN__c != toldMap.get(a.id).Agency_NPN__c || a.Name != toldMap.get(a.id).Name ){
                updatedAcctIds.add(a.Id);
            }
        }
        list<Partner__c> pList = [SELECT id,Opportunity__c FROM Partner__c where Partner__c IN: updatedAcctIds];
        
        for(Partner__c p :PList){
            oppIds.add(p.Opportunity__c);
        }
        
        oppList = [SELECT id,stagename,NASCO_Acct_ID__c,Business_Type__c,Account.AccountNumber,Account.Name,Effective_Date__c,
            Contract_End_Date__c,System__c,Lead_Rep_Name_User__r.Name,Lead_Rep_Number__c,Division__c FROM Opportunity where Id IN: oppIds and stagename = 'Sold'  AND Effective_Date__c <= TODAY AND Contract_End_Date__c > TODAY];
         
         //BrokerHubServiceNew.processSoldOpportunityDetails(oppList);
         if(isFirstTime == true){     
         BrokerHubServiceNew.processSoldOpportunityDetails(oppList);
         isFirstTime = false;
         }
 }

}