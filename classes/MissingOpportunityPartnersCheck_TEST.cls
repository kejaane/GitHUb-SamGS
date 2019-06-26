@isTest
private class MissingOpportunityPartnersCheck_TEST {
/*
    static testMethod void Test() {     
         
        Test.startTest();
        MissingOpportunityPartnersCheck c = new MissingOpportunityPartnersCheck();        
        c.check();   
        Test.stopTest();        
    }
*/   
    static testMethod void Test2() {  
        Test.startTest();        
        MissingOpportunityPartnersCheck c = new MissingOpportunityPartnersCheck();
        c.TestMode();
        c.check();   
        Test.stopTest();
    }
    
    static testMethod void Test3() {  
        Test.startTest();
        MissingOpportunityPartnersCheck c = new MissingOpportunityPartnersCheck();
        c.TestMode2();
        c.check();   
        Test.stopTest();
    }
}