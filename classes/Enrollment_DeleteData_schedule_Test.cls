@isTest
private class Enrollment_DeleteData_schedule_Test {  
    static testMethod void Enrollment_DeleteData_schedule_Test() {
        Test.StartTest();
            Enrollment_DeleteData_schedule sh = new Enrollment_DeleteData_schedule();
            String sch = '0 0 5 * * ?';
            system.schedule('Schedule TEST', sch, sh);
        Test.StopTest();
    }
}