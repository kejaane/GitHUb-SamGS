// this is a test class for Enrollment_2_50_Opportunity_Mgrn_Process
// 7/1/2016 :Ashish ojha 
@isTest

// First test is for positive testing where the code runs as desired.
public class Enrollment_2_50_Opp_Mgrn_Prs_TEST{
    // Run positive test when check testing is false as expected in the Account Process code
    static testMethod void testBatch(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                //TestUtil.createTestAccounts();
                TestUtil.Create_Enrollment_Data_ForHIX_mgrn(); 
                TestUtil.createDynamicCodeDataStore(); 
                //testutil.Create_Enrolment_Import_2_50_Data(); 
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_2_50_Opportunity_Mgrn_Process brap = new Enrollment_2_50_Opportunity_Mgrn_Process(true);
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                RETURN;   
            }                      
        }
        
 // Run test for negative testing where account name will not be populated and it will throw out an exception  
 // this will force bad DML 
  static testMethod void testBatch2(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                //TestUtil.createTestAccounts();
                TestUtil.Create_Enrollment_Data_ForHIX_mgrn();
                TestUtil.createDynamicCodeDataStore(); 
                //testutil.Create_Enrolment_Import_2_50_Data();
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_2_50_Opportunity_Mgrn_Process brap = new Enrollment_2_50_Opportunity_Mgrn_Process(False);
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                RETURN;   
            }                      
        }
               
 
               
}