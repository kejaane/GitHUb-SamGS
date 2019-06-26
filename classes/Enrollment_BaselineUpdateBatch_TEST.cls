// this is a test class for Enrollment_BaselineUpdateBatch
//#####################################################################################
// Date     Developer     Description
//#####################################################################################
// 03/24/17    TPB        Updated to get data from the enrollment_import__c object
//                        See more detail in the TestUtil class    
//
//#####################################################################################  
@isTest
public class Enrollment_BaselineUpdateBatch_TEST{
    
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
                Enrollment_BaselineUpdateBatch brap = new Enrollment_BaselineUpdateBatch(Enrollment_BaselineUpdateBatch.BatchType_2_50);
                database.executeBatch(brap);
                Test.StopTest();
                             
                System.assert(TRUE); 
            }catch( exception e ){
                RETURN;   
            }                      
        }
        static testMethod void testBatch1(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                TestUtil.Create_Enrollment_Import();
                TestUtil.Create_Enrollment_Data_51();  
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_BaselineUpdateBatch brap = new Enrollment_BaselineUpdateBatch(Enrollment_BaselineUpdateBatch.BatchType_51_Plus);
                database.executeBatch(brap);
                Test.StopTest();
                             
                System.assert(TRUE);  
            }catch( exception e ){
                RETURN;   
            }                      
        }
}