@isTest(SeeAllData=true)
private class Enrollment_ArchiveRecycle_schedule_Test {  
    static testMethod void CFCT_OwnerLeadRepNoMatch_schedule_Test() {
        Test.StartTest();
        Enrollment_ArchiveRecycle_schedule sh = new Enrollment_ArchiveRecycle_schedule();
        String sch = '0 0 5 * * ?';
        system.schedule('Schedule TEST', sch, sh);
        Test.stopTest();
    }
}