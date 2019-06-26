/*****************************************************************************************************
*Date: 04-13-2017
*Developer: Rajesh Pennam
*Purpose: Code coverage for Enrollment_ProcessMedicalImport_sch Class 
*=========================================================================================
* Update History
* Date         Developer        Tag        Description
*==================================================================================
*04-13-2017    Rajesh Pennam    T01         Removed See all data true
*==================================================================================

*******************************************************************************************************/

@isTest 
private class Enrollment_ProcessMedicalImport_sch_Test {  
    static testMethod void Enrollment_ProcessMedicalImport_sch_Test() {
    TestUtil.createEnrollmentTestData(); //T01
    TestUtil.Create_Enrollment_Import(); //T01
    TestUtil.Create_Error_Message(); //T01
        Test.StartTest();
            Enrollment_ProcessMedicalImport_schedule sh = new Enrollment_ProcessMedicalImport_schedule();        
            String sch = '0 0 5 * * ?';
            system.schedule('Schedule TEST', sch, sh);
        Test.StopTest();
       
    }
}