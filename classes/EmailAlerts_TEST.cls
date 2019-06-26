@isTest
private class EmailAlerts_TEST {
    static testMethod void Test() {
        Test.startTest();
        EmailAlerts.emailAdmins('Subject Test', 'Body Test');
        EmailAlerts.emailDeactivateRecipients('Subject Test', 'Boddy Test');       
        Test.stopTest();
    }
}