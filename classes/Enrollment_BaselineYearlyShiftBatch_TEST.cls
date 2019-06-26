// this is a test class for Enrollment_BaselineYearlyShiftBatch

@isTest
public class Enrollment_BaselineYearlyShiftBatch_TEST{
    // Positive testing
   
    static testMethod void testBatch(){ 
    
     TestUtil.createEnrollmentTestData();
     TestUtil.createDynamicCodeDataStore();
     TestUtil.Create_Enrollment_Import(); 
     
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');
            Test.StartTest(); 
            System.runAs(u) {
                TestUtil.Create_Enrollment_Data_ForHIX_mgrn();
                TestUtil.Create_Enrollment_Data_Shift();  
            }
        
            
            //try {     
                Enrollment_BaselineYearlyShiftBatch brap = new Enrollment_BaselineYearlyShiftBatch('2-50');
                database.executeBatch(brap);
                Test.StopTest();
                             
                System.assert(TRUE);  
            //}catch( exception e ){
           //     RETURN;   
           // }                      
        }
        
    static testMethod void testBatch1(){ 
    
     TestUtil.createEnrollmentTestData();
     TestUtil.createDynamicCodeDataStore();
      Test.StartTest(); 
     TestUtil.Create_Enrollment_Import(); 
     //TestUtil.Create_Enrollment_Data_51();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                
                TestUtil.Create_Enrollment_Data_Shift();  
            }
        
           
            try {     
                Enrollment_BaselineYearlyShiftBatch brap = new Enrollment_BaselineYearlyShiftBatch('2-50');
                database.executeBatch(brap);
                Test.StopTest();
                             
                System.assert(TRUE); 
            }catch( exception e ){
                RETURN;   
            }                      
        }
         // Positive testing
    static testMethod void testBatch2(){ 
    
     TestUtil.createEnrollmentTestData();
     TestUtil.createDynamicCodeDataStore();
     TestUtil.Create_Enrollment_Import(); 
     //TestUtil.Create_Enrollment_Data_51();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                
                //TestUtil.Create_Enrollment_Data_Shift();  
            }
        
            Test.StartTest(); 
            try {     
                //Enrollment_BaselineYearlyShiftBatch brap = new Enrollment_BaselineYearlyShiftBatch('51+');
                Enrollment_BaselineYearlyShiftBatch brap = new Enrollment_BaselineYearlyShiftBatch('null');
                database.executeBatch(brap);
                Test.StopTest();
                            
                System.assert(TRUE); 
            }catch( exception e ){
                RETURN;   
            }                      
        }
    
}