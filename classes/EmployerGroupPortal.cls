//=========================================================================================
//      Date: 11/01/2013
// Developer: Tom Barrett (TPB)
//   Purpose: This controller is used for the employer group portal (EGP) functionality
//            Employer Group Portal consists of a check box on the contact object that
//            allows the user to identify the contact record as a primary contact for the 
//            CareFirst Employer Group Portal system
//
//            As of 11/01/2013 the only method that this class contains is for permitting 
//            only one contact to be marked as EGP for a given account
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
public without sharing class EmployerGroupPortal {
    // members for holding Trigger info must be set inside the 
    // trigger before calling the egpValidation method below     
    public Contact[] contacts;    
    public Map<id, Contact> oldMap;
    public boolean isInsert = false;

    /********************************************************************************
     * method checks if the trigger.new list records are from A before inserts or 
     * updates and if they are then process the records.
     * 1. Validate if any given account has multiple contacts that are marked
     *    as EGP and if they are assign an error to that contact record
     * 2. Validate if any given account in the Trigger.new contact records match a
     *    an account already saved in the database and both the trigger.new contact
     *    and contact on the database are both assigned as EGP.  If they are then
     *    an error is assigned for that trigger.new record
     * 3. If both validation above pass then the trigger.new record is inserted
     *    or updated depending on the type of event that fired the trigger    
     *******************************************************************************/
    public void egpValidation() {        
        Map<id, Contact> chkAccountMap = new Map<id, Contact>();
        Map<id, String> accNames = new Map<id, String>();
        Set<id> accIds = new Set<id>(); 
                   
        // build Set of account ids to build map of account ids
        for ( Contact c : Contacts ) {
            accIds.add(c.AccountId);    
        }
        
        // build Map of account Ids and names to be used to get account name using the accIds created above
        for ( Account a : [ SELECT id, Name FROM ACCOUNT WHERE Id IN :accIds ] ) {
            accNames.put(a.id,a.Name);   
        }
        
        // Loop through contacts to determine if there are duplicate EGP assigned contacts in the list or 
        // if one already exists on the database for the associated account.  
        // If not then allow the record to be saved; otherwise set the error.
        for (  Contact c : Contacts ) {
            if ( isInsert || (c.Employer_Group_Portal__c != oldMap.get(c.id).Employer_Group_Portal__c) ) {        
                if ( chkAccountMap.containsKey(c.AccountId) && c.Employer_Group_Portal__c ) {                  
                    c.addError('An Employer Group Portal Contact in the current batch is already assigned to Account \'' + accNames.get(c.AccountId) + '\'.');
                } else {
                    if ( c.Employer_Group_Portal__c )
                        chkAccountMap.put(c.AccountId, c);   
                }
            }
        }    
        for ( Contact c : [ SELECT AccountId, Account.Name FROM Contact WHERE AccountId IN :chkAccountMap.keySet() AND Employer_Group_Portal__c = TRUE ] ) {
            Contact newContact = chkAccountMap.get(c.AccountId);
            newContact.addError('An Employer Group Portal Contact is already assigned to Account \'' + c.Account.Name + '\'.');
        }    
    }
}