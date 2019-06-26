/*=========================================================================================
 * Date         : 10/21/2014
 * Developer    : Ken Gill
 * Purpose      : This class is the extension point of the Trigger Framework for adding Contact trigger handlers.               
 *                For EGP updates
 *                 1. The beforeInsert & beforeUpdate are routed through processBeforeUpdateorInsert() to validate submitted EGP updates
 *                 for single EGP contact per account business rule check
 *                 2. The afterInsert & afterUpdate are routed through processAfterUpdateOrInsert() to EGPService process updates to external system
 *                 via web service callout
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/21/14  |  KG                | Initial Version                                         
 * 10/18/16  |  Rajesh Pennam     |  Added the functionality for the auto-populaiton of account when community contact is created or updated 
 * 12/21/16  |  Satya             |  added Date condition to where clause so that Opp ID's with null dates will not be in the List
 *===========+============+================================================================
*/

public with sharing class ContactTriggerHandler extends TriggerHandler {

public ContactTriggerHandler() {}

    /* context override */
protected override void beforeUpdate() {
    processBeforeUpdateOrInsert();
   }

protected override void beforeInsert() {
    processBeforeUpdateOrInsert();
    processAccountUpdate(); // @Rajesh for the Account auto population
}

protected override void afterInsert() {
    processAfterUpdateOrInsert();
   }

protected override void afterUpdate() {
    processAfterUpdateOrInsert();
    processFacetsIntegrationCaseContactUpdates();
    
    
    //Added by Ahilesh for 632.0 Project
    processBrokerHubAccountUpdate();
    
    
    
}


private void processBeforeUpdateOrInsert() {
    
    if(System.isBatch()) {
        System.debug('ContactTriggerHandler: Bypassing EGP Processing when called from a batch job');
        return;
    }
    // Validate any records before saving them
    EGPService.validateSubmittedEGPUpdates();
}

// Handle any callouts to the EGP web service after submitted Contact update records are validated
// by the processBeforeUpdateOrInsert() method
private void processAfterUpdateOrInsert() {

    if(System.isBatch()) {
        System.debug('ContactTriggerHandler: Bypassing EGP Processing when called from a batch job');
        return;
    }   
    
      // Note on casting below:
      // Outside a trigger, the trigger collections Trigger.new,.old have to be explicitly cast to the SOBject type
      // When working inside a trigger, this casting happens implicitly
      EGPService.processManageUserChanges(( List<Contact>) Trigger.new, (Map<Id,Contact>) Trigger.oldMap);
}

 // Handle Contact modifications for Contacts related to SBU_Broker Cases
 private void   processFacetsIntegrationCaseContactUpdates() {
        if(System.isBatch() || System.isFuture()) {
        System.debug('FCI_CaseContactTriggerHandler: Bypassing Facets Integration FCI_CaseContactTriggerHandler AfterUpdate trigger processing when called from Batch or Future job');
            return;
        }
     // Note on casting below:
     // Outside a trigger, the trigger collections Trigger.new,.old have to be explicitly cast to the SOBject type
     // When working inside a trigger, this casting happens implicitly
     FCI_FacetsService.processCaseContactModifications(( Map<Id,Contact>) Trigger.newMap, (Map<Id,Contact>) Trigger.oldMap);    
 }  
 
 public static boolean isFirstTime = true;
 //Added by Ahilesh for 632.0 Project
 private void processBrokerHubAccountUpdate(){
     Map<id,Contact> tnewMap = new Map<id,Contact>();        //opp Mapping for new value
     Map<id,Contact> toldMap = new Map<id,Contact>();        //opp Mapping for old value
     list<Id> updatedContIds = new list<Id>();
     list<Id> oppIds = new list<Id>();
     list<Opportunity> oppList = new list<Opportunity>();
     
     tnewMap  = (Map<id,Contact>)Trigger.newMap;
     toldMap  = (Map<id,Contact>)Trigger.oldMap;
    
        for(Contact a:tnewMap.values()){
            if(a.Broker_NPN__c != toldMap.get(a.id).Broker_NPN__c || a.Email != toldMap.get(a.id).Email ||
               a.Phone != toldMap.get(a.id).Phone || a.FirstName != toldMap.get(a.id).FirstName){
                updatedContIds.add(a.Id);
            }
        }
        list<Opportunity_Contact_Role__c> crList = [SELECT id,Opportunity__c FROM Opportunity_Contact_Role__c where Contact_Name__c  IN: updatedContIds];
        
        for(Opportunity_Contact_Role__c p :crList ){
            oppIds.add(p.Opportunity__c);
        }
        
        //Satya || 12/21 added Date condition to where clause so that Opp ID's with null dates will not be in the List
        oppList = [SELECT id,stagename,NASCO_Acct_ID__c,Business_Type__c,Account.AccountNumber,Account.Name,Effective_Date__c,
            Contract_End_Date__c,System__c,Lead_Rep_Name_User__r.Name,Lead_Rep_Number__c,Division__c FROM Opportunity where Id IN: oppIds and stagename = 'Sold' AND Effective_Date__c <= TODAY AND Contract_End_Date__c > TODAY];
        
        //BrokerHubServiceNew.processSoldOpportunityDetails(oppList);
         if(isFirstTime == true){   
         BrokerHubServiceNew.processSoldOpportunityDetails(oppList);
         isFirstTime = false;
         }
 }
 
 //This function is used to update the Account Name for Community Contact
 // @Rajesh for the Account auto population
  private void processAccountUpdate(){
      AccountUpdateForCommunityContact.UpdateAccountForCommunityContact(trigger.new);
  }
 
}