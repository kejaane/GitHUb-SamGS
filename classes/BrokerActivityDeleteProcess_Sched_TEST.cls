@isTest
private class BrokerActivityDeleteProcess_Sched_TEST {  
    static testMethod void BrokerActivityDeleteProcess_Sched_test() {
        Test.StartTest();
        BrokerActivityDeleteProcess_Schedule sh = new BrokerActivityDeleteProcess_Schedule();
        String sch = '0 0 5 * * ?';
        system.schedule('Schedule TEST', sch, sh);
        Test.stopTest();
    }
}