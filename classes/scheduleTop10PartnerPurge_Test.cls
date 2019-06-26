@isTest
private class scheduleTop10PartnerPurge_Test {  
    static testMethod void scheduleTop10PartnerPurge_Test() {
        Test.StartTest();
        scheduleTop10PartnerPurge sh = new scheduleTop10PartnerPurge();
        String sch = '0 0 5 * * ?';
        system.schedule('Schedule TEST', sch, sh);
        Test.stopTest();
    }
}