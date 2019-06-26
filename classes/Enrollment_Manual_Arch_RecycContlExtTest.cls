/*****************************************************************************************************
*Date: 04-13-2017
*Developer: Rajesh Pennam
*Purpose: Code coverage for Enrollment_Manual_Arch_RecycContlExt Class 
*=========================================================================================
* Update History
* Date         Developer        Tag        Description
*==================================================================================
*09-16-2016    Rajesh Pennam    T01         Removed is all data true
*==================================================================================

*******************************************************************************************************/


@isTest
public class Enrollment_Manual_Arch_RecycContlExtTest {
    // Test with selected Recycle records
    public static boolean runningTest = false;
    static testMethod void testSelected(){ 
            testUtil.createEnrollmentTestData(); 
       
            List<Enrollment_Recycle__c> ers = [ SELECT id, Rpt_Dt__c, Account_Name__c, Account_Number__c, Contracts__c, Error_Message__c,
                                                       Sales_Rep__c, Error_Number__c, Processed_Type__c, SFDC_Product__c, Risk__c, Run_Dt__c, System__c, Rating_State__c, New_Business_Indicator__c  
                                                FROM Enrollment_Recycle__c ];                                                                                          

            System.assert(ers.size() > 0);    
            runningTest = TRUE;
        
        Test.StartTest();
            ApexPages.StandardSetController setCon = new ApexPages.standardSetController(ers);
            setCon.setSelected(ers);         
            Enrollment_Manual_Arch_Recycle_ContrlExt ext = new Enrollment_Manual_Arch_Recycle_ContrlExt(setCon);    
            ext.enrollmentList = null;
        	ext.NotRecycledList=null;
        	ext.getIsClassic();
        	ext.ArchiveSelection();
       	 	Test.StopTest();
    } 
    // Test without selected Recycle Records
    static testMethod void testNoneSelected() {
        List<Enrollment_Recycle__c> ers = [ SELECT id, Rpt_Dt__c, Account_Name__c, Account_Number__c, Contracts__c, Error_Message__c,
                                                   Sales_Rep__c, Error_Number__c, Processed_Type__c, SFDC_Product__c, Risk__c, Run_Dt__c, System__c, Rating_State__c, New_Business_Indicator__c  
                                            FROM Enrollment_Recycle__c Where Rpt_Dt__c = 'NO RECORDS' ];     
        ApexPages.StandardSetController setCon = new ApexPages.standardSetController(ers);
        Test.StartTest();     
            Enrollment_Manual_Arch_Recycle_ContrlExt ext = new Enrollment_Manual_Arch_Recycle_ContrlExt(setCon);
            ext.ArchiveSelection();
        Test.StopTest(); 
    }   
}