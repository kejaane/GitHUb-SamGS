/***********************************************************************************
     Date: 11/05/2013
Developer: Tom Barrett
  Purpose: To test the EmployerGroupPortal Class  
------------------------------------------------------------------------------------
                       ----===[ HISTORY ]===---
Date        Developer        Description
------------------------------------------------------------------------------------
11/05/2013  Tom Barrett      Origin: 
***********************************************************************************/
@isTest
private class EmployerGroupPortal_Test {
    static testMethod void Test1() { 
        //Sree - Changed profile to 'System Administrator - Custom' from 'System Administrator'  
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

        System.runAs(u) {        
            TestUtil.createTestAccounts();
            TestUtil.createTestOpportunities();
            TestUtil.createTestContacts();
        }
        
        Test.startTest();
        List<Contact> contacts = [ SELECT Employer_Group_Portal__c FROM Contact LIMIT 5 ];
        List<Contact> updateContacts = new List<Contact>();
        for ( Contact c : contacts ) {
            c.Employer_Group_Portal__c = TRUE;  
            updateContacts.add(c);         
        }
        try {
            Update updateContacts; 
        }
        catch ( exception ex ) {
            // expected
        }    
        Test.stopTest();
    }  
}