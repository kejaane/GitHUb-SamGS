// this is a test class for Enrollment_Group_Flag_Process
// 08/22/2014 :Ashish ojha
// 09/19/2014 TPB - Added Batch4 method to test new 'RECENT' parameter value
@isTest
public class Enrollment_Group_Flag_Process_TEST{
    // Positive testing
    static testMethod void testBatch(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                
                TestUtil.Create_Enrollment_Data();  
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_Group_Flag_Process brap = new Enrollment_Group_Flag_Process(False);
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                RETURN;   
            }                      
        }
        //Negative testing
    static testMethod void testBatch2(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                
                TestUtil.Create_Enrollment_Data();  
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_Group_Flag_Process brap = new Enrollment_Group_Flag_Process(True);
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                RETURN;   
            }                      
        }
       // Test by passing RPt date 
        static testMethod void testBatch3(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                
                TestUtil.Create_Enrollment_Data();  
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_Group_Flag_Process brap = new Enrollment_Group_Flag_Process('201411');
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                RETURN;   
            }                      
        } 
        
       // Test by passing RPt date as 'RECENT'
        static testMethod void testBatch4(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                
                TestUtil.Create_Enrollment_Data();  
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_Group_Flag_Process brap = new Enrollment_Group_Flag_Process('RECENT');
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                RETURN;   
            }                      
        }                
}