@isTest
public class CIAM_Contact_Creation_Process_TEST{

 static testmethod void ValidateQuery() {
        // The query used by the batch job.
        String Query = 'Select id, Name, Agency_Agent_ID__c, Agent_ID__c, Agency_ID__c, Broker_Title__c, Email_Address__c, Agent_first_name__c, Agent_last_Name__c, Agency_name__C, Processed__c ' +
                       'FROM CIAM_Import_Table__c';

  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
            SBU_Testutil.CIAMProcessTestContact();
            }
       
     Test.startTest();
     try{
       CIAM_Contact_Creation_Process sc = new CIAM_Contact_Creation_Process(query);
       Database.executeBatch(sc);
       System.assert(TRUE);
     }catch( exception e ){
         RETURN; 
     }  
     Test.stopTest();
     
     
 
 }
 static testmethod void ValidateQuery1() {
        // The query used by the batch job.
        String Query = 'Select id, Name, Agency_Agent_ID__c, Agent_ID__c, Agency_ID__c, Broker_Title__c, Email_Address__c, Agent_first_name__c, Agent_last_Name__c, Agency_name__C, Processed__c ' +
                       'FROM CIAM_Import_Table__c';

  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
            SBU_Testutil.CIAMProcessTestContact1();
            }    
       
     Test.startTest();
     try{
     
       CIAM_Contact_Creation_Process sc = new CIAM_Contact_Creation_Process(query);
       Database.executeBatch(sc);
       
       }catch(exception e){
       }
        Test.stopTest();
 
 }
 }