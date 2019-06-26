@isTest
private class ValidateFailedSubmissionsToBE_sched_Test {  
    static testMethod void ValidateFailedSubmissionsToBE_sched_Test() {
        Test.StartTest();
            ValidateFailedSubmissionsToBE_schedule sh = new ValidateFailedSubmissionsToBE_schedule();
            String sch = '0 0 5 * * ?';
            system.schedule('Schedule TEST', sch, sh);
        Test.stopTest();
    }
}