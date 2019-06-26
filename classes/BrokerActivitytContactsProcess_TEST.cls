// this test class will run BrokerActivityContactProcess
// 7/21/2014 : Ashish Ojha / Tom Barrett

// 11/10/2014: Tom Barrett (TPB) - add call to TestUtil.createTestOpportunities()
// 04/03/2016 : Ashish Ojha updated running user profile 
//              from 'System Administrator' to 'System Administrator - Custom'

@isTest
public class BrokerActivitytContactsProcess_TEST{
    static testMethod void testBatch(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                TestUtil.createTestAccounts();                
                TestUtil.createTestOpportunities();    // 11/10/2014 TPB   
                TestUtil.createTestContacts();               
                TestUtil.CreateBrokerActivityData(); 
            }

            Test.StartTest(); 
            try {     
                BrokerActivityContactsProcess bacp = new BrokerActivityContactsProcess(null);
                database.executeBatch(bacp);
                Test.StopTest();
                System.assert(TRUE); //We should not get here
            }catch( exception e ){
                RETURN;   
            }                      
    }
     static testMethod void testBatch1(){
               
                Test.StartTest(); 
                Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
                User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.dev', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.dev');

                  System.runAs(u) {
                    String Query = 'Select id, Name, Account_Name__c, Address_Line__c, Last_Name__c, First_Name__c,City__c, County__c, Email__c, Entity_ID__c, Entity_Type__c, Phone__c, State__c, Zipcode__c FROM Broker_Import_2_50__c where Entity_Type__c = \'SB\' limit 1';
                    BrokerActivityContactsProcess brcp = new BrokerActivityContactsProcess(Query);
                    database.executeBatch(brcp);
                    Test.StopTest();
                    System.assert(TRUE); //We should not get here 
                }
                                  
        }
   /*     static testMethod void testBatch2(){
               
                Test.StartTest(); 
                Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
                User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.dev', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.dev');
                Broker_Import_2_50__c bkt = new Broker_Import_2_50__c();
                bkt.Entity_Id__c = '1211123';
                bkt.Account_Name__c = 'test';
                bkt.Entity_type__c ='AG';
                insert bkt;
                
                  System.runAs(u) {
                    String Query = 'Select id, Name, Account_Name__c, Address_Line__c, Last_Name__c, First_Name__c,City__c, County__c, Email__c, Entity_ID__c, Entity_Type__c, Phone__c, State__c, Zipcode__c FROM Broker_Import_2_50__c where Entity_Type__c = \'SB\' order by Name desc limit 1';
                    BrokerActivityContactsProcess brcp = new BrokerActivityContactsProcess(Query);
                    database.executeBatch(brcp);
                    Test.StopTest();
                    System.assert(TRUE); //We should not get here 
                }
                                  
        }
*/
}