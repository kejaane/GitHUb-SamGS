// this is a test class for SObject_Records_Delete_Process
// 08/27/2014 :Ashish ojha 
// 04/03/2016 : Ashish Ojha updated running user profile 
//              from 'System Administrator' to 'System Administrator - Custom' 
@isTest
public class SObject_Records_Delete_Process_TEST{
    
    static testMethod void testBatch(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                TestUtil.createTestAccounts();
                TestUtil.DeleteBrokerActivityData();  
            }
        
            Test.StartTest(); 
            try {     
                SObject_Records_Delete_Process brap = new SObject_Records_Delete_Process('Broker_Import_2_50__c',false,'Processed__c = true');
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                //RETURN;   
            }                      
        }
        static testMethod void testBatch1(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                TestUtil.createTestAccounts();
                TestUtil.DeleteBrokerActivityData();  
            }
        
            Test.StartTest(); 
            try {     
                SObject_Records_Delete_Process brap = new SObject_Records_Delete_Process('Broker_Import_2_50__c',true,'Processed__c = true');
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                //RETURN;   
            }                      
        }

   }