/*****************************************************************************************************
*Date: 04-13-2017
*Developer: Rajesh Pennam
*Purpose: Code coverage for Enrollment_DeleteData Class 
*=========================================================================================
* Update History
* Date         Developer        Tag        Description
*==================================================================================
*09-16-2016    Rajesh Pennam    T01         Initial Development
*==================================================================================

*******************************************************************************************************/


@isTest
public class Enrollment_DeleteData_Test {
    static testMethod void DeleteDataTest(){
        TestUtil.createEnrollmentTestData();
        TestUtil.createDynamicCodeDataStore();//T01
        Test.StartTest(); 
            Enrollment_DeleteData d = new Enrollment_DeleteData();
            d.query = 'SELECT id FROM Enrollment_Import__c';
            ID batchprocessId = Database.executeBatch(d);
        Test.StopTest();
    }
}