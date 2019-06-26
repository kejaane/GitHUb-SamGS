@isTest
private class CFCT_OwnerLeadRepNoMatch_Schedule_Test {  
    static testMethod void CFCT_OwnerLeadRepNoMatch_schedule_Test() {
        Test.StartTest();
        CFCT_OwnerLeadRepNoMatch_schedule sh = new CFCT_OwnerLeadRepNoMatch_schedule();
        String sch = '0 0 5 * * ?';
        system.schedule('Schedule TEST', sch, sh);
        Test.stopTest();
    }
}