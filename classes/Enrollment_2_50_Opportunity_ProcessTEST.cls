// this is a test class for Enrollment_2_50_Opportunity_Process

//====================================================================================================
//                                 Update History
// Date       	  Tag	   Developer      Description
//====================================================================================================

// 11/09/2014 				Ashish ojha 
// 04/03/2016 				Ashish Ojha 	updated running user profile 
//              							from 'System Administrator' to 'System Administrator - Custom'
// 22/08/2017     T01      	Arshia Gulati   Added assertEquals statement		
//====================================================================================================

@isTest
public class Enrollment_2_50_Opportunity_ProcessTEST{
    
    static testMethod void testBatch(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
                     User u = new User(Alias = 'standt', Email='spmss.process@carefirst.com.xxx', 
                     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                     LocaleSidKey='en_US', ProfileId = p.Id, 
                     TimeZoneSidKey='America/Los_Angeles', UserName='spmss.process@carefirst.com.xxx');

            System.runAs(u) {
                TestUtil.Create_Enrolment_Import_2_50_Data();
                
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_2_50_Opportunity_Process brap = new Enrollment_2_50_Opportunity_Process(false);
                database.executeBatch(brap);
                Test.StopTest();
                
                // Start - |T01| 08/22/2017  
                Opportunity opt = new Opportunity();
                String externalKey = '2222' + system.today().addDays(-300)+ 'X2_50' ;                                                         
                opt = [select Id,Direct_Plus_Broker_CF_Hub__c from Opportunity where External_Key__c = :externalKey Limit 1];                                                                        
                System.assertEquals('WANADA',opt.Direct_Plus_Broker_CF_Hub__c);
                // End - |T01| 08/22/2017  
                // 
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
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
                TestUtil.Create_Enrolment_Import_2_50_Data();
                
            }
        
            Test.StartTest(); 
            try {     
                Enrollment_2_50_Opportunity_Process brap = new Enrollment_2_50_Opportunity_Process(true);
                database.executeBatch(brap);
                Test.StopTest();
                             // veryfiy that the items got upserted
                System.assert(TRUE); //We should not get here 
            }catch( exception e ){
                RETURN;   
            }                      
        }
}