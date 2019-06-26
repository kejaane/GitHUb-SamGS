@isTest
private class MissingOpportunityPartnersChk_sched_Test {  
    static testMethod void MissingOpportunityPartnersChk_sched_Test() {
        Test.StartTest();
        MissingOpportunityPartnersCheck_schedule sh = new MissingOpportunityPartnersCheck_schedule();
        String sch = '0 0 5 * * ?';
        system.schedule('Schedule TEST', sch, sh);
        Test.stopTest();
    }
}