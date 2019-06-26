//=========================================================================================
//      Date: 05/13/2016
// Developer: Tom Barrett (TPB)
//   Purpose: This controller is used by the CFCT_AccountMerger VF Page.
//            Currently, it is used to merge accounts based on specific rules that are not
//            the normal merging of data approach.  The data is not really merged but rather
//            related contacts copied and accounts coupled together by referrencing each other.
//         1. The merge copies the source account's related contacts that are selected
//            on the VF page to the destination account's related contacts.
//         2. Renames the source selected contact's first name and email by prefixing the 'merged_'.
//         3. The destinatino contacts mailing information is populated with the destination 
//            accounts billing information.
//         4. Finally, sources Merged Account field is populated with the destination
//            account's id (lookup field) and the destination Account's Merged Account 
//            field is populated with the source Account's id.
//            Step 3 provide a full 360 view on merged accounts.
//
//=========================================================================================
//                                 Update History
// Date       Developer      	Description
//=========================================================================================
//08/14/2018 Debkanti	|T01|	Added method to check classic or lightning   
//=========================================================================================
public with sharing class CFCT_AccountMergerController {
    public Boolean disableCopySelectedContactsButton { get; set; }
    public Boolean showPageBlockTable { get; set; }
    public Boolean showProcessButton { get; set; }
    //For Account lookup capability at the VF page
    public Account source { get; set; } 
    public Account destination { get; set; }  
    //Our collection of the class/wrapper objects cContact 
    public List<cContact> contactList {get; set;}
    private Account sourceAccountRec = new Account();
    private Account destinationAccountRec = new Account();
    public List<FeedItem> feedPostList = new List<FeedItem>();
    //Used only for test class when forcing a DML failure to get code coverage
    public Boolean isTesting = false;
    
    //Controller Constructor
    public CFCT_AccountMergerController() {
    // BEGIN SPECIAL NOTE
        //Orginally used Opportunity to provide the lookup fields
        //but if criteria filter is turned on at Opportunity's standard lookup field to the account object
        //then the refernces below will no longer work.
        //Since discoving this behavior the new references are at the account page using
        //the custom lookup field called Merged_Account__c which is a lookup to the account itself.       
        //These references are so that we can produce the default out of the box
        //Looup fields (source account and destination account) with the magnify glass
        //icon capability.  Later in the code we use source.Merged_Account__c and
        // destination.Merged_Account__c only to get the AccountId of the selected
        // source and destination account.      
        source = new Account(); 
        destination = new Account();
    // END SPECIAL NOTE   
           
        //Defaults to hide processButton and PageBlockTable
        disableCopySelectedContactsButton = true;
        showPageBlockTable = false;        
    }        
    

    //This method uses a simple SOQL query to return a List of Contacts
    public List<cContact> getContacts() {   
        if(contactList == null) {
            contactList = new List<cContact>();
            for(Contact c: [SELECT id, AccountId, RecordType.Name, RecordTypeId, Name, Email, Phone, FirstName, LastName, 
                                   Entity_Id__c, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry
                            FROM Contact 
                            WHERE AccountId = :source.Merged_Account__c  
                            ORDER BY Name ]) {
                // As each contact is processed we create a new cContact object and add it to the contactList
                contactList.add(new cContact(c));
            }
        }        
        return contactList;
    }
    
    public PageReference getSourceContacts() { 
        contactList = null;  // set contactList to null so that the VF page rerenders    
        
        if ( source.Merged_Account__c == null || destination.Merged_Account__c == null ) {                       
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Warning,'Please select a Source Account and Destination Account!'));            
            return null;        
        }
               
        if ( source.Merged_Account__c == destination.Merged_Account__c ) {           
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Warning,'Source and Destination Accounts cannot be the same!'));            
            return null;
        }  
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.info,'Now select the desired contacts to copy but make sure to only click the button once or duplicate contacts will be created per extra click!!!'));    
        showPageBlockTable = true;    
        disableCopySelectedContactsButton = false;        
        return null;
    }    

    /********************************************
     * VF page's Copy Selected Contacts button calls 
     * this method.  This is were most of the magic
     * work happens.
     ********************************************/
    public PageReference CopySelectedContacts() {
        //We create a new list of Contacts that we be populated only with Contacts if they are selected
        List<Contact> selectedContacts = new List<Contact>();
        List<Contact> insertContacts = new List<Contact>();
        List<Contact> updateSourceContacts = new List<Contact>();
        Map<id, String> changeEmailMap = new Map<id, String>();        
        Map<id, Contact> contactMap = new Map<id, Contact>();        
        String changeEmail;
        String entityId;
        Boolean SomethingSelected = false;
                                          
       //Get the source account information
        sourceAccountRec = [ SELECT id, Name, Owner.Name
                             FROM Account 
                             WHERE id = :source.Merged_Account__c LIMIT 1 ];                
       
        //Get the desination account billing information so that it can be used to store on the destination contacts
        //mailing information.  This mimics the standard out of the box Salesforce functionality when you create a
        //Contact from the Account page.
        destinationAccountRec = [ SELECT id, Name, Owner.Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry
                                  FROM Account 
                                  WHERE id = :destination.Merged_Account__c LIMIT 1 ];     

        //We will cycle through our list of cContacts and will check to see if the selected property is set to true, if it is we add the Contact to the selectedContacts list
        for(cContact cCon: getContacts()) {
            if(cCon.selected == true) {   
                SomethingSelected = true;            
                selectedContacts.add(cCon.con); 
                //Build map with contact id and Change Email field from VF page
                changeEmailMap.put(cCon.con.id, cCon.changeEmail);                  
                contactMap.put(cCon.con.id, cCon.con);                       
            }            
        }
        
        //Nothing selected to process so lets get out of method as soon as possible.
        //But this doesn't seem to work!!!
        if ( !SomethingSelected) {            
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Warning,'Select at least one contact to copy!'));  
            return null;
        }        

        //Loop through the selectedContacts, clone the record and update source related contacts
        //and create a new copy of the source contact and assign it to the destination account     
        for(Contact con: selectedContacts) {             
            // Clone source accounts related contact, clone it, assign the cloned contact to the destination account and add it to the insertContacts list
            Contact insertContact = new Contact();
            insertContact = con.clone(false, false);                  
                                       
            insertContact.AccountId = destination.Merged_Account__c;  
            
            //Get the value of the Change Email field on the VF page for contact 
            changeEmail = changeEmailMap.get(con.id);
            //Set insertContact.email equal to changeEmail if it has a value
            if ( changeEmail != null && changeEmail != '' ) insertContact.email = changeEmail;  
            
            //If entity__id__c exists on source copy it to destination
            // and remove it from the source account
            entityId = contactMap.get(con.id).Entity_Id__c;
            if ( entityId != null && entityId != '' ) {
                insertContact.Entity_Id__c = entityId;
                con.Entity_Id__c = '';
            }
            
            //Populate the Destination contacts Mailing Address with Destination Account's Billing Address
            //This will serve as the intial default address for the contact. The user may have to manually
            //change this information later.
            insertContact.MailingStreet = destinationAccountRec.BillingStreet;
            insertContact.MailingCity = destinationAccountRec.BillingCity;
            insertContact.MailingState = destinationAccountRec.BillingState;
            insertContact.MailingPostalCode = destinationAccountRec.BillingPostalCode;
            insertContact.MailingCountry = destinationAccountRec.BillingCountry;
                    
            insertContacts.add(insertContact);
            
            //Update the source accounts related selected contact so they
            //are identified as merged (copied) to the destinoation account's
            //related contacts
            con.email = 'merged_' + con.email;
            con.firstName = 'merged_' + con.firstName; 
            updateSourceContacts.add(con);            
        }
        
        //setup the tie between the source and destination accounts so that reporting
        //can bring a 360 degree view on the merged accounts.
        List<Account> updateAccounts = new List<Account>();
        updateAccounts.add(new Account(id=source.Merged_Account__c, Merged_Account__c=destination.Merged_Account__c));        
        updateAccounts.add(new Account(id=destination.Merged_Account__c, Merged_Account__c=source.Merged_Account__c));
        
        //Clear list so we don't get errors if user clicks the "Get Source Contacts" button again.
        if ( !feedPostList.isEmpty() ) feedPostList.clear();
        //Build Chatter FeedItemPostList for source and destination accounts
        feedPostList.add(FeedItemPost(sourceAccountRec.id, 'This account has merged with ' + destinationAccountRec.Name + 
                                      '. Please do not add any contacts to this account!  Refer to the ' + destinationAccountRec.Name + ' account.'));
                                      
        feedPostList.add(FeedItemPost(destinationAccountRec.id, 'This account was merged with ' + sourceAccountRec.Name + 
                                      '.  Only update or add new contacts to this account from now on.'));
       
        //Fore DML Exception for testing
        if ( Test.IsRunningTest() && isTesting ) feedPostList = NULL;
        //DML Statements
        Savepoint sp = Database.setSavepoint();
        try { 
            update updateAccounts;
            update updateSourceContacts;
            insert insertContacts;
            insert feedPostList;
//            feedPostList.clear();
        }catch(Exception e){
            Database.rollback(sp);
            // Add the error to the page for the user to see
            ApexPages.addMessages(e);
            return null;
        }
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.confirm,'Process Completed Successfully.  Go to the Destination Account and review.'));
        disableCopySelectedContactsButton = true;
        
        contactList=null; // we need this line if we performed a write operation  because getContacts gets a fresh list now
        return null;                
    }   
    
      
    /**********************************************************************************************************
     *This is our wrapper/container class. A container class is a class, a data structure, or an abstract data 
     *type whose instances are collections of other objects. 
     *In this example a wrapper class contains both the standard salesforce object Contact and a Boolean value
     **********************************************************************************************************/
    public class cContact {
        public Contact con { get; set; }
        public String changeEmail { get; set; }
        public Boolean selected { get; set; }

        //This is the constructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public cContact(Contact c) {
            con = c;
            selected = true;
            changeEmail = null;
        }
    }
    
    /*Build FeedItem List*/
    private FeedItem FeedItemPost(Id ParentId, String Msg) {
        FeedItem post = new FeedItem();
        post.ParentId = ParentId;
        post.Body = Msg;       
        return post;         
    }
    /*-T01-Start-*/
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    /*-T01-End-*/
}