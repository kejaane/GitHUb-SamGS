/*===========================================================================================================
 * Date         : 02/06/2018
 * Developer    : Rajesh Pennam
 * Purpose      : Test class for AIA_EventSignUpExtn
 *===========================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer       Tag         Description
 *===========================================================================================================
 *02/06/2018   Rajesh Pennam                This test class is used for checking the code coverage for contoller
                                            AIA_EventSignUpExtn
 *==========================================================================================================
 */

@istest
private class AIA_EventSignUpExtn_Test{

     public static Id rt_acc_51= QueryBase.getRecordtypeId('Event', 'AIA_Meeting');

   
     static testMethod void SignUpTest1(){
     
       User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     LastName = 'last',
     Email = 'puser000@Test.com',
     Username = 'puser000@Test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
);
     insert u;
      system.runAs(u){

        Account acct = new Account(); 
        acct.Name = 'Test10';
        acct.NumberOfEmployees = 45; // Num employees should always be <= 50
        acct.Sic = '0111';
        acct.EIN__c = '123456789'; // Has field validation, cannot be longer than 9 chars
        acct.BillingStreet = '1660 International Drive St. #518 Ste.500e ' +
        '1660 International Drive St. #518 Ste.500e' +
        '1660 International Drive St. #518 Ste.500e';
        acct.BillingCity = 'McLean123456789012345678902345678901';
        acct.BillingState = 'VA';
        acct.BillingPostalCode = '22102-4501'; // Has a validation rule in place 
        //acct.Billing_County_Code__c = 'MD';
        acct.Renewal_Anniversary_Month__c = 'Nov';
        acct.Account_Legal_Name__c= 'test Account';
        insert acct;
     
        event AccountEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=acct.id,Meeting_Type__c='ARC Approval Meeting',recordTypeId=rt_acc_51,Approval_Meeting_Decision__c='arc',Meeting_Status__c='Full');
        insert AccountEvent ;
        
        
        Test.StartTest();

     
        ApexPages.StandardController sc = new ApexPages.StandardController(AccountEvent);
        AIA_EventSignUpExtn  eventSignUp = new AIA_EventSignUpExtn(sc);

        eventSignUp.SignUpOnload();
        
        system.assertEquals([Select count() From EventRelation Where EventId =:AccountEvent.id],1);
      
        Test.StopTest();

       

      }
     
     }
     

        static testMethod void SignUpTest2(){
     
       User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     LastName = 'last',
     Email = 'puser000@Test.com',
     Username = 'puser000@Test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
);
     insert u;
      system.runAs(u){

        Account acct = new Account(); 
        acct.Name = 'Test10';
        acct.NumberOfEmployees = 45; // Num employees should always be <= 50
        acct.Sic = '0111';
        acct.EIN__c = '123456789'; // Has field validation, cannot be longer than 9 chars
        acct.BillingStreet = '1660 International Drive St. #518 Ste.500e ' +
        '1660 International Drive St. #518 Ste.500e' +
        '1660 International Drive St. #518 Ste.500e';
        acct.BillingCity = 'McLean123456789012345678902345678901';
        acct.BillingState = 'VA';
        acct.BillingPostalCode = '22102-4501'; // Has a validation rule in place 
        //acct.Billing_County_Code__c = 'MD';
        acct.Renewal_Anniversary_Month__c = 'Nov';
        acct.Account_Legal_Name__c= 'test Account';
        insert acct;
     
        event AccountEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=acct.id,Meeting_Type__c='ARC Approval Meeting',recordTypeId=rt_acc_51,Approval_Meeting_Decision__c='arc',Meeting_Status__c='Completed');
        insert AccountEvent ;
     
       Test.StartTest();

     
        ApexPages.StandardController sc = new ApexPages.StandardController(AccountEvent);
        AIA_EventSignUpExtn  eventSignUp = new AIA_EventSignUpExtn(sc);

        eventSignUp.SignUpOnload();
      
        Test.StopTest();
       system.assertEquals([Select count() From EventRelation Where EventId =:AccountEvent.id],1);


      }
     
     }
     
      static testMethod void SignUpTest3(){
     
       User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
     LastName = 'last',
     Email = 'puser000@Test.com',
     Username = 'puser000@Test.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US'
);
     
     insert u;

        Account acct = new Account(); 
        acct.Name = 'Test10';
        acct.NumberOfEmployees = 45; // Num employees should always be <= 50
        acct.Sic = '0111';
        acct.EIN__c = '123456789'; // Has field validation, cannot be longer than 9 chars
        acct.BillingStreet = '1660 International Drive St. #518 Ste.500e ' +
        '1660 International Drive St. #518 Ste.500e' +
        '1660 International Drive St. #518 Ste.500e';
        acct.BillingCity = 'McLean123456789012345678902345678901';
        acct.BillingState = 'VA';
        acct.BillingPostalCode = '22102-4501'; // Has a validation rule in place 
        //acct.Billing_County_Code__c = 'MD';
        acct.Renewal_Anniversary_Month__c = 'Nov';
        acct.Account_Legal_Name__c= 'test Account';
        insert acct;
     
        event AccountEvent = new event(DurationInMinutes=60,ActivityDateTime=system.now(),whatId=acct.id,Meeting_Type__c='ARC Approval Meeting',recordTypeId=rt_acc_51,Approval_Meeting_Decision__c='arc',Meeting_Status__c='Open');
        insert AccountEvent ;
     
        Test.StartTest();
        
        system.runAs(u){
        ApexPages.StandardController sc = new ApexPages.StandardController(AccountEvent);
        AIA_EventSignUpExtn  eventSignUp = new AIA_EventSignUpExtn(sc);

        eventSignUp.SignUpOnload();
      
        Test.StopTest();
        
        system.assertEquals([Select count() From EventRelation Where EventId =:AccountEvent.id],2);


      }
     
     }
     


}