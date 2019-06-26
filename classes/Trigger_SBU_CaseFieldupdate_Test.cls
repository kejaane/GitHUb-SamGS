@isTest
private class Trigger_SBU_CaseFieldupdate_Test {
    static testMethod void Test1() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Origin = 'Email: Broker Sales MD'; 
        cas.Subject = 'Test';
        insert cas;
        
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
   
    // Test error condition
    static testMethod void Test2() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Retro activity Request';
        insert cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    
    // Test error condition
    static testMethod void Test4() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: SBC Project';
        insert cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    // Test error condition
    static testMethod void Test5() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: BCS Specialist';
        insert cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    // Test error condition
    static testMethod void Test6() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Small Medium Group';
        insert cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    // Test error condition
    static testMethod void Test7() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Royal';
        insert cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    // Test error condition
    static testMethod void Test8() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Indigo';
        insert cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    // Test error condition
    static testMethod void Test9() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Ocean';
        insert cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    // Test error condition
    static testMethod void Test10() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Sapphire';
        insert cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    // Test error condition
    static testMethod void Test11() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Sky';
        insert cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    // Test error condition
    static testMethod void Test12() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Teal';
        insert cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    // Test error condition
    static testMethod void Test13() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Compliance';
        insert cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    // Test error condition
    static testMethod void Test14() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Teal';
        insert cas;
        
        cas.Subject = 'Test1';
        update cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
    // Test error condition
    static testMethod void Test15() {
        Test.startTest();
        //Create account
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Broker Sales 4';
        insert cas;
        
        cas.Subject = 'Test1';
        update cas;
        Test.stopTest();        
        System.assert([select Id from Case where Id=:cas.id].size() == 1);
    }
}