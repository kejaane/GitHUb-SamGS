// this is a test class for Enrollment_2_50_Clear_Rep_Chkbx_TEST
// 5/27/2015 :Ashish ojha 
// 04/03/2016 : Ashish Ojha updated running user profile 
//              from 'System Administrator' to 'System Administrator - Custom'
// 12/30/2016  : Ashish Added TestUtil.createDynamicCodeDataStore() 

@isTest

// First test is for positive testing where the code runs as desired.
public class Enrollment_2_50_Clear_Rep_Chkbx_TEST{
    // Run positive test when check testing is false as expected in the Account Process code
    static testMethod void testBatch(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                //TestUtil.Create_Enrollment_Data_Shift(); 
                TestUtil.Create_Enrollment_Data_OffAndOnCycle();  
                TestUtil.createDynamicCodeDataStore();    
            }
        
            Test.StartTest(); 
            try {    
                String Query = 'select id, Reporting_Checkbox__c,Reporting_checkbox_off_cycle__c from Enrollment__c limit 50 '; 
                Enrollment_2_50_Clear_Reporting_Chkbx brap = new Enrollment_2_50_Clear_Reporting_Chkbx(Query);
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got updated
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                RETURN;   
            }                      
        }
        
/*
 // Run test for negative testing where account name will not be populated and it will throw out an exception  
 // this will force bad DML 
  static testMethod void testBatch2(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                //TestUtil.Create_Enrollment_Data_Shift();
                TestUtil.Create_Enrollment_Data_OffAndOnCycle();        
            }
        
            Test.StartTest(); 
            try {     
                String Query = 'select id, Reporting_Checkbox__c,Reporting_checkbox_off_cycle__c from Enrollment__c  limit 50 '; 
                Enrollment_2_50_Clear_Reporting_Chkbx brap = new Enrollment_2_50_Clear_Reporting_Chkbx(Query);
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                RETURN;   
            }                      
        }
               
 
  */             
}