@isTest
public class QueryBase2_TEST{    
    //Positive Test
    static testMethod void testMethod1(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

        System.runAs(u) {        
            TestUtil.createChatterGroups();                                            
        }
        
        Test.StartTest();     
            QueryBase2.PostToChatterGroup('SFDC ProcessesX', 'FeedTitleTest', 'This is for testing QueryBase2 class', TRUE);   
            QueryBase2.getDynamicCodeDataStore('Testing');                    
        Test.StopTest();
          
    }   

    //Negative Test
    static testMethod void testMethod2(){ 
  
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

        System.runAs(u) {                
            insert new DynamicCodeDataStore__c(Name = 'TestingZ', Email__c = 'ZTest@email.com');
                                            
        }
        Test.StartTest(); 
        QueryBase2.PostToChatterGroup('SFDC ProcessesZ', 'FeedTitleTest', 'This is for testing QueryBase2 class', TRUE);            
        QueryBase2.getDynamicCodeDataStore('TestingZ');                    
        Test.StopTest();
         
    }      
     static testMethod void testMethod3(){ 
  
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

        System.runAs(u) {                
            Account testAccount = new Account();
            testAccount.Name='Test Account' ;
            testAccount.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X2_50'); 
            testAccount.Account_Alias_1__c='TAcc';
            testAccount.Account_Alias_2__c='TAcc2';
            testAccount.Account_Legal_Name__c='Test ACC';
            insert testAccount;
            string s=testAccount.RecordTypeId;            
            Opportunity o = new opportunity();
            o.AccountId = testAccount.id;
            o.name = 'Test Opportunity';
            o.StageName = 'RFP';
            o.Effective_Date__c =  Date.newInstance(2014,10,1);
            o.CloseDate = o.Effective_Date__c.addDays(-11);
            insert o;
           }
            Test.StartTest(); 
            QueryBase2.getCreatableFieldsSOQL('Account', 'Name=Test Account');
            QueryBase2.getSobjectAllFieldsSOQL('Account', 'Name=Test Account');
            QueryBase2.getSobjectAllFieldsSOQLWithChildObjects('Opportunity', 'Name=Test Opportunity','Account','Opportunities');
            QueryBase2.getSobjectAllFieldsSOQLWithSelectedFileds('Account', 'Name=Test Account','Account_Legal_Name__c');
            QueryBase2.findObjectNameFromRecordIdPrefix('s');
            Test.StopTest();
         }       
}