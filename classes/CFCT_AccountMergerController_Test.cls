//=========================================================================================
//      Date: 06/21/2016
// Developer: Tom Barrett (TPB)
//   Purpose: This test class tests the CFCT_AccountMergerController class
//            Current date it is 100% code coverage with asserts
//
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
@isTest
public class CFCT_AccountMergerController_Test {
    public static testMethod void positiveTest() {
        buildTestData();
        
        Test.StartTest();
            PageReference pageRef = Page.CFCT_AccountMerger;
            Test.setCurrentPage(pageRef);
            //Instantiate controller
            CFCT_AccountMergerController controller = new CFCT_AccountMergerController();                
            //Get source Account
            Account sourceAccount = [ SELECT Id, Name, Merged_Account__c FROM Account WHERE Name = 'Source Account' ];        
            System.assertEquals(sourceAccount.Name, 'Source Account'); 
            
            controller.source = sourceAccount;
            controller.source.Merged_Account__c = sourceAccount.Id;        
            System.assertEquals(controller.source.Merged_Account__c, sourceAccount.Id);
           
            //Get destination Account
            Account destinationAccount = [ SELECT Id, Name, Merged_Account__c FROM Account WHERE Name = 'Destination Account' ];        
            System.assertEquals(destinationAccount.Name, 'Destination Account');  
            
            controller.destination = destinationAccount;
            controller.destination.Merged_Account__c = destinationAccount.Id;        
            System.assertEquals(controller.destination.Merged_Account__c, destinationAccount.Id);      
            
            controller.destination = destinationAccount;    
            controller.getSourceContacts();
            controller.showProcessButton = true;
            controller.disableCopySelectedContactsButton = false;
            controller.copySelectedContacts();
            
            
            //Get the one contact that should have been created
            Contact destinationContact = [ SELECT Id, Name, Email, MailingStreet FROM Contact LIMIT 1 ];
            System.assertNotEquals(destinationContact, NULL);
        Test.StopTest();
    }
    
    //Testing some Visualforce, apexPages.addMessage methods that send to the Visualforce page
    public static testMethod void negativeTest() {       
        buildTestData();
        
        Test.StartTest();
            PageReference pageRef = Page.CFCT_AccountMerger;
            Test.setCurrentPage(pageRef);
    
            //Instantiate controller
            CFCT_AccountMergerController controller = new CFCT_AccountMergerController();  
            
            //Simulate clicking the Source Contacts button and confirm Account Source and Destination are blank
            controller.getSourceContacts();         
            System.assert(wasMessageAdded(new ApexPages.Message(ApexPages.Severity.Warning, 'Please select a Source Account and Destination Account!')));        
            
            //Get source Account and set the source and destination values the same
            //to test error message on VF page
            Account sourceAccount = [ SELECT Id, Name, Merged_Account__c FROM Account WHERE Name = 'Source Account' ];        
            System.assertEquals(sourceAccount.Name, 'Source Account');  
            controller.source = sourceAccount;
            controller.source.Merged_Account__c = sourceAccount.Id;  
            controller.destination = sourceAccount;
            controller.destination.Merged_Account__c = sourceAccount.Id; 
            controller.getSourceContacts();         
            System.assert(wasMessageAdded(new ApexPages.Message(ApexPages.Severity.Warning, 'Source and Destination Accounts cannot be the same!')));
            
            //Test that no Conect was selected to process but the process button was clicked          
            // We know we only created one contact for this testing so lets delete it
            Contact deleteContact = [ SELECT id FROM Contact LIMIT 1 ];
            Delete deleteContact;
            controller.getContacts();      
            controller.copySelectedContacts();
            System.assert(wasMessageAdded(new ApexPages.Message(ApexPages.Severity.Warning, 'Select at least one contact to copy!')));      
        Test.StopTest();
    }  
    
    public static testMethod void negativeDMLExceptionTest() {
        buildTestData();
        
        Test.StartTest();
            PageReference pageRef = Page.CFCT_AccountMerger;
            Test.setCurrentPage(pageRef);
            //Instantiate controller
            CFCT_AccountMergerController controller = new CFCT_AccountMergerController();  
            //Force DML Error 
            controller.isTesting = TRUE;              
            //Get source Account
            Account sourceAccount = [ SELECT Id, Name, Merged_Account__c FROM Account WHERE Name = 'Source Account' ];        
            System.assertEquals(sourceAccount.Name, 'Source Account'); 
            
            controller.source = sourceAccount;
            controller.source.Merged_Account__c = sourceAccount.Id;        
            System.assertEquals(controller.source.Merged_Account__c, sourceAccount.Id);
           
            //Get destination Account
            Account destinationAccount = [ SELECT Id, Name, Merged_Account__c FROM Account WHERE Name = 'Destination Account' ];        
            System.assertEquals(destinationAccount.Name, 'Destination Account');  
            
            controller.destination = destinationAccount;
            controller.destination.Merged_Account__c = destinationAccount.Id;        
            System.assertEquals(controller.destination.Merged_Account__c, destinationAccount.Id);      
            
            controller.destination = destinationAccount;    
            controller.getSourceContacts();
            controller.showProcessButton = true;
            controller.disableCopySelectedContactsButton = false;
            controller.copySelectedContacts();
            controller.getIsClassic();
            
            //Get the one contact that should have been created
            Contact destinationContact = [ SELECT Id, Name, Email, MailingStreet FROM Contact LIMIT 1 ];
            System.assertNotEquals(destinationContact, NULL);
        Test.StopTest();
    }    
         
    
     
    /***************
     * HELP METHODS 
     ***************/
    //Determines the message from the Visualforce page matches the message passed to this method
    private static Boolean wasMessageAdded(ApexPages.Message message) {            
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        Boolean messageFound = false;
    
         for(ApexPages.Message msg : pageMessages) {
             if(msg.getSummary() == message.getSummary()
                 && message.getDetail() == message.getDetail()
                 && message.getSeverity() == message.getSeverity()) {
                 messageFound = true;        
             }
         }
    
         return messageFound;
    }  
       

 
    
    //Build Test Data
    static void buildTestData() {  
        //Create source and destination accounts 
        List<Account> accountList = new List<Account>();
        Account sourceAccount = new Account(Name='Source Account', Type='Partner', RecordTypeId = QueryBase.getRecordTypeId('Account', 'X51'));
        accountList.add(sourceAccount);
        Account destinationAccount = new Account(Name='Destination Account', Type='Partner', RecordTypeId = QueryBase.getRecordTypeId('Account', 'X51'));
        accountList.add(destinationAccount);
        insert accountList;
        
        //Create source account's related contact
        Contact contact = new Contact(FirstName = 'Source', LastName = 'Contact', Phone = '123-123-456', Email = 'source.contact@test.com', 
                                      Entity_id__c = '123456', AccountId = sourceAccount.id,  RecordTypeId = QueryBase.getRecordTypeId('Contact', 'X51'));
        insert contact;
    }
}