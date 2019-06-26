@isTest
private class CFCT_OppWithoutPartners_schedule_Test {  
    static testMethod void CFCT_OppWithoutPartners_schedule_Test() {
        Test.StartTest();
        CFCT_OppWithoutPartners_schedule sh = new CFCT_OppWithoutPartners_schedule();
        String sch = '0 0 5 * * ?';
        system.schedule('Schedule TEST', sch, sh);
        Test.stopTest();
    }
}