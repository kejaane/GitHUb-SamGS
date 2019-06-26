/*=========================================================================================
 * Date     : 08/28/2015
 * Developer    : Ashish Ojha
 * Purpose      : This class is the extension point of the Trigger Framework for adding Case trigger handlers.
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 08/28/15   |  AO    | Initial Version                                         
 * 07/20/16   |  LK    | Laveen Kumar
 * 08/20/16   |  RP    | Added the changes for UpdateContactOnCaseCreate 
 * 11/12/16   |  Goutham    | Added the code to update OwnerID for AIA BD Case
 * 12/08/16   |  RP    | Added code to insert implementation record when the approval status of case changes to approved
 * 12/09/16   |  RP    | Added code to update the case owner once case is inserted
 *===========+============+================================================================
 */

public without sharing class CaseTriggerHandler extends TriggerHandler {

    public CaseTriggerHandler() {}
    
        /* context override */
    protected override void beforeUpdate() {
        processFacetsIntegrationBeforeCaseUpdate();       
        InsertImplementationObj(); // 12/08/2016 - Added by @Rajesh for implementation record insertion
    }
    
    protected override void beforeInsert() {
            processBeforeEmailCaseInsert();
            updateOwnerId();
            populateOwnerOfCase(); // 12/09/2016 - Added by @Rajesh for populating owner name of case         
            
    }
    
    protected override void beforeDelete() {
           // processDeleteOnCase(); // processes delete activity on case
    }
    
    protected override void afterInsert() {
       
        UpdateContactOnCaseOfGroup(); // 08/20/16 added new function for the updates in case creation @Rajesh Pennam
        provideSharingForBrokerAgentAndAssistant();// 08/20/2016 - Added by @Laveen for Case Apex Sharing
        InsertImplementationObj(); // 12/08/2016 - Added by @Rajesh for implementation record insertion
    }
      
 
    protected override void afterUpdate() {
        processFacetsIntegrationAfterCaseUpdate();  // hook to Facets integration 
        UpdateContactOnCaseOfGroup(); // 08/20/16 added new function for the updates in case creation @Rajesh Pennam
        provideSharingForBrokerAgentAndAssistant(); // 08/20/2016 -  Added by @Laveen for Case Apex Sharing
          
    }


private void processBeforeEmailCaseInsert() {     
      // Note on casting below:
      // Outside a trigger, the trigger collections Trigger.new,.old have to be explicitly cast to the SOBject type
      // When working inside a trigger, this casting happens implicitly
      SBU_CaseFieldUpdate.CaseFieldUpdateOnEmailOrigin(( List<Case>) Trigger.new);
}

// Entry point for processing Case field updates for the Facets Integration - KGill
private void processFacetsIntegrationAfterCaseUpdate() {
    if(System.isBatch()|| System.isFuture()) {
        System.debug('FCI_CaseTriggerHandler: Bypassing Facets Integration Case.update trigger processing when called from a batch job');
        return;
    }   
    
    // Note on casting below: Outside a trigger, the trigger collections Trigger.new,.old have to be explicitly cast to the SOBject type
    // When working inside a trigger, this casting happens implicitly
    FCI_FacetsService.processCaseUpdates(( List<Case>) Trigger.new, (Map<Id,Case>) Trigger.oldMap);
}


private void processFacetsIntegrationBeforeCaseUpdate() {
    FCI_FacetsService.processUpdatesFromFacetsSystem( (List<Case>) Trigger.new);
}

private void processDeleteOnCase() {
   // SBU_CaseDelete.CaseDelete((List<Case>) Trigger.old);
}


 //08/20/16 added new function for the updates in case creation @Rajesh Pennam
 
private void UpdateContactOnCaseOfGroup(){
   Case sendCase = (Case)Trigger.new[0];
   Map<id,Case> oldMap = new Map<id,Case>();
   oldMap = (Map<id,Case>) Trigger.oldMap;
   if(Trigger.isAfter && Trigger.isInsert){
       UpdateContactOnCaseByGroup.updateContactByGrp(sendCase);
   }
   if(Trigger.isAfter && Trigger.isUpdate){
       if((sendCase.Group__c != oldMap.get(sendCase.id).Group__c) || (sendCase.ContactID != null && sendCase.ContactID != oldMap.get(sendCase.id).ContactID)){
           UpdateContactOnCaseByGroup.updateContactByGrp(sendCase);
       }
   }
}

/* 08/20/2016 - Added by @Laveen for Apex Case Sharing to Agent and Assistant */

private void provideSharingForBrokerAgentAndAssistant(){
   
    List<Case> CaseList = new List<Case>();       //List of Cases 
    CaseList = (List<Case>) Trigger.new;         // New Trigger cases
    
    Map<id,Case> oldMap = new Map<id,Case>();    // Delcared Old Mapped cases with their Id's 
    // Checking if it is for the update case
    if(Trigger.isUpdate)    
    oldMap = (Map<id,Case>) Trigger.oldMap;        // Old mapped cases 
    Map<id,User> userMap = new Map<id,User>();     // Map for the User's and their Id's 
    
    Set<id> cidset = new Set<id>();                // Contact id Set
    // Looping the caselist and checking id ContactId is not null
    for(Case obj: CaseList){
        if(obj.ContactID != null )
        {
            cidset.add(obj.ContactID);            // Adding values to set 
        }
    }
    
    //checking if the set has values or not and getting the user list from the contact set i.e. cidset
    if(cidset != null && cidset.size()>0){
        List<User> userlist =[Select id,Broker_Role__c, contactid from User where contactId in : cidSet];      
        //Looping through the list of users and adding them to userMap
        for(User uobj: userlist){
            userMap.put(uobj.contactId,uobj);     
        }
    }
    
    //Two new list of cases for both Agents and Asistants i.e. to identify wheather he is agent or assistant and process records accordingly 
    List<case> cBAgentlist = new List<case>();
    List<case> cAssistantlist = new List<case>();
    for(Case obj: CaseList){
        // Checking the contactId is not null and user map has the value
        if(obj.ContactID != null && userMap.containskey(obj.ContactID))     
        {
           // uobj - Assigning the ContactId user from the usermap
           User uobj = userMap.get(obj.ContactID);                          
           //Checking the user value is not null and he is Broker Agent 
           if((uobj.Broker_Role__c  != null && uobj.Broker_Role__c=='Broker Agent') || (uobj.Broker_Role__c  != null && uobj.Broker_Role__c=='Assistant'))
           {
                if(Trigger.isInsert )    // For the New Triggers 
                cBAgentlist.add(obj);    // Adding that to the Particular list 
                // If this is for update scenario based on the conditions i.e. update ,change in value of both the accounts 2-50 & 51+ 
                if(Trigger.isUpdate && (obj.X2_50_Account__c != oldMap.get(obj.id).X2_50_Account__c || obj.X51_Account__c != oldMap.get(obj.id).X51_Account__c  ))
                {
                    cBAgentlist.add(obj); // Adding case objects to the List 
                }
           }
           
           //Checking If The user is assistant
           if(uobj.Broker_Role__c  != null && uobj.Broker_Role__c=='Assistant')
           {
                // Checking For the New Triggers 
                if(Trigger.isInsert)
                cAssistantlist.add(obj);    //Adding to the list  
                System.debug(Trigger.isUpdate);
                System.debug(obj.Group__c);
                //Checking of the scenario for update
                if(Trigger.isUpdate && obj.Group__c != oldMap.get(obj.id).Group__c )
                {
                    cAssistantlist.add(obj);  // Adding the values to the list
                }
           }
        }
    }
        // checking the null values of the list
        if(cBAgentlist!= null && cBAgentlist.size()>0)
        ProvideSharingForAgentAndAssistant.provideSharingForBrokerAgent(cBAgentlist);   // Invloking the class to provide sharing for Broker Agent  Case to Assistant
        if(cAssistantlist!= null && cAssistantlist.size()>0){
        ProvideSharingForAgentAndAssistant.provideSharingForAssistant(cAssistantlist);  // Invloking the class to provide sharing for Assistant Case to Broker Agent 
        }
    
}
/* Goutham - update OwnerID for AIA BD Case
 * Date: 11/12/2016
 */
 Private void updateOwnerId(){
     set<id> bnfId = new set<id>();
     
     String rcid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA Benefit Design Cases').getRecordTypeId();
     List<Case> CaseList = new List<Case>();       //List of Cases 
     CaseList = (List<Case>) Trigger.new;  
     for(Case C:CaseList){
         if(rcid ==c.RecordTypeId)
         bnfId.add(C.AIA_Benefit_Design__c);
        }
     if(bnfId.size()>0 && bnfId!=null){   
         Map<Id, AIA_Benefit_Design__c> bnfMap = new Map<Id, AIA_Benefit_Design__c>([select Id, Name,OwnerId from AIA_Benefit_Design__c where Id IN: bnfId]);
         
         for(Case Obj:CaseList){
             if(bnfMap.Containskey(obj.AIA_Benefit_Design__c)){
                 obj.OwnerId = bnfMap.get(obj.AIA_Benefit_Design__c).OwnerId;
             }
         }
   }
 }
 
 // 12/09/16 This method is implemented by @Rajesh for insertion of implementation records
    private void InsertImplementationObj(){
        system.debug('trigger called');
        ImplementationInsertForApprovedCases.InsertImplementation((Case) Trigger.new[0]);
    }
    
 // 12/09/16 This method is implemented by @Rajesh for case owner update
   
    private void populateOwnerOfCase(){
        ImplementationInsertForApprovedCases.populateOwner((Case) Trigger.new[0]);
    }

}