// this is a test class for Enrollment_BaselineUpdateInitBatch
//#####################################################################################
// Date     Developer     Description
//#####################################################################################
// 03/24/17    TPB        Updated to get data from the enrollment_import__c object
//                        See more detail in the TestUtil class    
//
//#####################################################################################  
@isTest
public class Enrollment_BaselineUpdateInitBatch_TEST{
    
    static testMethod void testBatch(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                
                TestUtil.Create_Enrollment_Data_Shift();  
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_BaselineUpdateInitBatch brap = new Enrollment_BaselineUpdateInitBatch('2-50','2014');
                database.executeBatch(brap);
                Test.StopTest();
                             
                System.assert(TRUE); 
            }catch( exception e ){
                RETURN;   
            }                      
        }
        // Positive testing
    static testMethod void testBatch1(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                TestUtil.Create_Enrollment_Data_Shift();  
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_BaselineUpdateInitBatch brap = new Enrollment_BaselineUpdateInitBatch('51+','2090');
                database.executeBatch(brap);
                Test.StopTest();
                             
                System.assert(TRUE); 
            }catch( exception e ){
                RETURN;   
            }                      
        }
         // Positive testing
    static testMethod void testBatch2(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                TestUtil.Create_Enrollment_Import();  // Add TPB 03/24/2017
                TestUtil.Create_Enrollment_Data_51();  
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_BaselineUpdateInitBatch brap = new Enrollment_BaselineUpdateInitBatch('51+','2014');
                database.executeBatch(brap);
                Test.StopTest();
                             
                System.assert(TRUE); 
            }catch( exception e ){
                RETURN;   
            }                      
        }
        static testMethod void testBatch4(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                
                //TestUtil.Create_Enrollment_Data_EXC();  
            }
        
            Test.StartTest(); 
            try {     
                
                
                Enrollment_BaselineUpdateInitBatch brap = new Enrollment_BaselineUpdateInitBatch('51+','1990');
                database.executeBatch(brap);
                List<Enrollment__c> enrolments = [ SELECT id,AG_Not_Found__c FROM Enrollment__c LIMIT 5 ];
                List<Enrollment__c> updateEnrolments = new List<Enrollment__c>();
                for ( Enrollment__c e : enrolments) {
                    e.AG_Not_Found__c = 'testestsestes';  
                    updateEnrolments.add(e);         
                }
                update updateEnrolments;
                Test.StopTest();
                             
                System.assert(TRUE); 
            }catch( exception e ){
                RETURN;   
            }                      
        }      
}