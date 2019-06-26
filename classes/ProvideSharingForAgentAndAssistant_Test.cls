/* =========================================================================================
 * Date         : 09/1/2016
 * Developer    : Laveen Kattela
 * Purpose      : This Test Class is for Case Apex Sharing i.e. for ProvideSharingForAgentAndAssistant class . 
 *                a)Unit test covers for both funtionalities i.e. for Creation and updation.
 *                
 *                Two main points of Methods to code coverage in main class :
 *                1.provideSharingForBrokerAgent  -- This method Shares the case to  Assistant based on both the Accounts (51+ & 2-50) when Assiatnt name in Contact Name
 *                2.provideSharingForAssistant    --  This method shares the case to  Primary Agent based on group. (When Contact Name is an Broker Agent)  
 *                
 *                  
 *=========================================================================================
 * Update History
 *  ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 09/1/16   |  Laveen Kattela    | Initial Version                                          
 *===========+============+================================================================
 */
@isTest
private class ProvideSharingForAgentAndAssistant_Test {
    
    static testMethod void provideSharingForBrokerAgentAndAssistant_Test() {
    
        // user Creation 
        Id p = [select id from profile where name='Customer Community Plus Login User'].id;
        Account ac = new Account(name ='TestAccount') ;
        insert ac; 
        Account ac2 = new Account(name ='TestAccount2') ;
        insert ac2; 
        Id cucRtid = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Community User Contact').RecordTypeId;
        Contact con1 = new Contact(LastName ='Assistant',AccountId = ac.Id,email='test@test.com',RecordTypeId =cucRtid,Phone='9999999999');
        insert con1;
        Contact con2 = new Contact(LastName ='Broker Agent',AccountId = ac.Id,email='test@test.com',RecordTypeId =cucRtid,Phone='9999999999');
        insert con2;
        Group__c tg = new Group__c();
            tg.Group_ID__c = '1234';
            tg.Name ='Test Group';
            tg.Agent_ID__c = '1';
            tg.Agency_ID__c = '1';
            tg.Agency_Agent_Id__c ='TAID-0001';
            insert tg;
            Group__c tg2 = new Group__c();
            tg2.Group_ID__c = '9876';
            tg2.Agent_ID__c = '2';
            tg2.Agency_ID__c = '2';
            tg2.Name ='Test Group2';
            tg2.Agency_Agent_Id__c ='TAID-0002';
            insert tg2;
                    
        Contact tcon = new Contact(Agency_Agent_Id__c='TAID-0001', LastName ='Test comm user',RecordTypeId =cucRtid,AccountId = ac.Id,email='test@test.com',X2_50_Account__c =ac.Id,Community_User_Type__c ='Assistant',Phone='9999999999' );
        insert tcon;
        Contact tcon2 = new Contact(Agency_Agent_Id__c='TAID-0002', LastName ='Test comm user',RecordTypeId =cucRtid,AccountId = ac.Id,email='test@test.com',X51_Account__c =ac.Id,Community_User_Type__c ='Assistant',Phone='9999999999');
        insert tcon2;
        Contact tcon3 = new Contact(Agency_Agent_Id__c='TAID-0003', LastName ='Test comm user',RecordTypeId =cucRtid,AccountId = ac.Id,email='test@test.com',X2_50_Account__c =ac2.Id,Community_User_Type__c ='Assistant',Phone='9999999999' );
        insert tcon3;
        Contact tcon4 = new Contact(Agency_Agent_Id__c='TAID-0004', LastName ='Test comm user',RecordTypeId =cucRtid,AccountId = ac.Id,email='test@test.com',X51_Account__c =ac2.Id,Community_User_Type__c ='Assistant',Phone='9999999999');
        insert tcon4;
        User user1 = new User(alias = 'test1', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = con1.Id,Broker_Role__c='Assistant',
                timezonesidkey='America/Los_Angeles', username='tester1@noemail.com');
        insert user1 ;
        User user2 = new User(alias = 'test2', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = con2.Id,Broker_Role__c='Broker Agent',
                timezonesidkey='America/Los_Angeles', username='tester2@noemail.com');
        insert user2 ;
        User user3 = new User(alias = 'test3', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing3', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = tcon.Id,Broker_Role__c='Broker Agent',
                timezonesidkey='America/Los_Angeles', username='tester3@noemail.com');
        insert user3 ;
        User user4 = new User(alias = 'test4', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing4', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = tcon2.Id,Broker_Role__c='Broker Agent',
                timezonesidkey='America/Los_Angeles', username='tester4@noemail.com');
        insert user4 ;
        User user5 = new User(alias = 'test5', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing5', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = tcon3.Id,Broker_Role__c='Broker Agent',
                timezonesidkey='America/Los_Angeles', username='tester5@noemail.com');
        insert user5 ;
        User user6 = new User(alias = 'test6', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing6', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = tcon4.Id,Broker_Role__c='Broker Agent',
                timezonesidkey='America/Los_Angeles', username='tester6@noemail.com');
        insert user6 ;
         Test.startTest();
        system.runAs(user1) {
            Case c1 = new Case();
            c1.ContactId =con1.id;
            c1.Subject='Test Subject';
            c1.Description = 'Test Discription';
            c1.Group__c = tg.id;
            insert c1;
            c1.Group__c = tg2.id;
            update c1;
            
        
        }
        system.runAs(user2) {
            Case c1 = new Case();
            c1.ContactId =con1.id;
            c1.Subject='Test Subject';
            c1.Description = 'Test Discription';
            c1.X2_50_Account__c = ac.id;
            c1.X51_Account__c = ac.id;
            insert c1;
            c1.X2_50_Account__c = ac2.id;
            c1.X51_Account__c = ac2.id;
            update c1;
            
        
        }
        Test.stopTest(); 
    
    }

}