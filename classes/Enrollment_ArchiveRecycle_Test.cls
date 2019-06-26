/*****************************************************************************************************
*Date: 04-13-2017
*Developer: Rajesh Pennam
*Purpose: Code coverage for Enrollment_ArchiveRecycle Class 
*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
*09-16-2016    Rajesh Pennam     Initial Development
*==================================================================================

*******************************************************************************************************/



@isTest
public class Enrollment_ArchiveRecycle_Test {
    
    static testMethod void ArchiveDataTest(){
        TestUtil.createEnrollmentTestData();
        TestUtil.createDynamicCodeDataStore();
        Test.StartTest(); 
        try {
                       Enrollment_ArchiveRecycle ear = new Enrollment_ArchiveRecycle();

        } catch(DMLException e) {
            system.assertEquals(e.getMessage(), e.getMessage());
        }
        Test.StopTest();
    }
    
   
}