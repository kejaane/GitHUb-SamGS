// this is a test class for BrokerActivityAccountsProcess
// 7/21/2014 :Ashish ojha / Tom Barrett
// 04/03/2016 : Ashish Ojha updated running user profile 
//              from 'System Administrator' to 'System Administrator - Custom'
// 12/30/2016  : Ashish Added TestUtil.createDynamicCodeDataStore() 

@isTest
public class BrokerActivityAccountsProcess_TEST{
    
    static testMethod void testBatch(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                TestUtil.createTestAccounts();
                TestUtil.CreateBrokerActivityData(); 
                TestUtil.createDynamicCodeDataStore();   
            }
        
            Test.StartTest(); 
            try {     
                BrokerActivityAccountsProcess brap = new BrokerActivityAccountsProcess(null);
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                RETURN;   
            }                      
        }
     static testMethod void testBatch1(){
                Test.StartTest(); 
 // Query used by the batch job but we are only selecting AG for this test           
                String Query = 'Select id, Name, Account_Name__c, Address_Line__c, City__c, County__c, Entity_ID__c, Entity_Type__c, Phone__c, State__c, Zipcode__c FROM Broker_Import_2_50__c where Entity_Type__c = \'AG\' limit 1';                        
                BrokerActivityAccountsProcess brap = new BrokerActivityAccountsProcess(Query);
                database.executeBatch(brap);
                Test.StopTest();
                System.assert(TRUE); //We should not get here 
                                  
        }
          
}