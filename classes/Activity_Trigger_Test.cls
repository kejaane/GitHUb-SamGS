//=========================================================================================
//      Date: 08/02/2017
// Developer: Tom Barrett - origin
//   Purpose: To test the Activity_Trigger Trigger
//
//     Usage: Enrollment_ArchiveRecycle ear = new Enrollment_ArchiveRecycle();           
//====================================================================================================
//                                 Update History
// Date          Developer    Tag    Description
//====================================================================================================
// 08/02/2017    Tom Barrett  T001   Modified to fix an issue that was causing the VR023 to trigger.
//                                   The error was reported in the test class as...
//                                   The Close Date must be less than the Effective Date: [CloseDate]
//
//                                   Basically, I set the effective date first and derived the close 
//                                   date from the effective date minus 10 whereas, it was not doing
//                                   that before.  
//====================================================================================================

@isTest
private class Activity_Trigger_Test {
    static testMethod void Test1() {
        Test.startTest();
        //Create account
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        insert a;
        //Create Opportunity
        Opportunity o = new Opportunity();
        o.Name = 'OppTest' + Date.Today(); 
        o.AccountId = a.id;
        o.StageName = 'Proposal';
//        o.CloseDate = Date.Today()-1; //T001
        o.GeneralProducer__c = 'Direct';
//TPB - 12/19/2013        
//        Date effectiveDate = o.CloseDate.addDays(30);   //T001  
        Date effectiveDate = Date.Today();    //T001        
        o.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        o.CloseDate = o.Effective_Date__c.addDays(-10);    //T001
        Date contractEndDate = o.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        o.Contract_End_Date__c = contractEndDate;  
             
        insert o; 
                 
        Task t = new Task();
        t.Subject = 'PCMH Presentation';
        t.Status = 'Completed';
        t.OwnerId = UserInfo.getUserId();

        t.Whatid = o.id;
        t.PCMH_Presentation_Date__c = Date.Today();
        t.PCMH_Effective_Date__c = Date.Today() + 1;
        t.PCMH_Decision__c = 'Yes';        
        insert t;
        Test.stopTest();
        System.assert([select Id from Task where Id=:t.id].size() == 1);
    }
    
    // Test TR001 error condition
    static testMethod void Test2() {
        Test.startTest();
        //Create account
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        insert a;
        //Create Opportunity
        Opportunity o = new Opportunity();
        o.Name = 'OppTest' + Date.Today();  
        o.AccountId = a.id;
        o.StageName = 'Proposal';
//        o.CloseDate = Date.Today()-1;    //T001
        o.GeneralProducer__c = 'Direct';
//TPB - 12/19/2013        
//T001  Date effectiveDate = o.CloseDate.addDays(30);  //T001 
        Date effectiveDate = Date.Today();    //T001 
        o.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        o.CloseDate = o.Effective_Date__c.addDays(-10);    //T001 
        Date contractEndDate = o.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        o.Contract_End_Date__c = contractEndDate; 
                
        insert o; 
                 
        Task t = new Task();
        t.Subject = 'PCMH Presentation';
        t.Status = 'Completed';
        t.ActivityDate = Date.Today() + 2;
        t.OwnerId = UserInfo.getUserId();
        t.Whatid = o.id;
        t.PCMH_Presentation_Date__c = Date.Today();
        t.PCMH_Effective_Date__c = Date.Today() + 1;        
        t.PCMH_Decision__c = 'Yes';        
        // We need the try catch block in order to 
        // to get 100% code coverage
        try {
        insert t;
          System.assert(false);
        }
        catch (Exception e)
        {
           // expected
        } 
                
        Test.stopTest();
        System.assert([select Id from Task where Id=:t.id].size() == 0);
    }

}