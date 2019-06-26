/*===================================================================================
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
*===================================================================================
* Date:         04/12/2017
* Developer:    Sree Harsha
* Purpose:      Test class for AIA_WorkplanAssignmentTriggerHandler
* 
*==================================================================================
* Update History
* Date          Developer       	Tag	       Description
*==================================================================================
* 04/12/2017    Sree Harsha         	   	Initial Development
* 10/23/2017 	Rajesh Nagandla     T01		Commenting Code related to objects AIA_Workplan_Type__c,Workplan_Type_Stage__c,
*											AIA_Workplan_Type_Task__c, Workplan_Stage__c, AIA_Workplan_Assignment__c 
*==================================================================================
*/

@isTest
private class AIA_WPATriggerHandler_Test{

    static testmethod void testWorkPlanAssignmentTriggerHandler(){
        /*T01 Start*/
		/*
		Test.startTest();
        List<Workplan_Stage__c> wpStageList = AIA_TestUtil.createWPS();
        //system.assertEquals(5,wpStageList.size());
        account acc = AIA_TestUtil.AIA_createAccount();
        opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);
        
        // Create PRF
        PRF__c prf = AIA_TestUtil.CreatePRF(opp.Id);
        system.assertNotEquals(null,prf.id);
        string cv = 'document';
        Blob cvBlob = Blob.toPdf('document');
        // Create Workplan Stage
        list<Workplan_Stage__c> aiawsList = AIA_TestUtil.createWPS();
        system.assertNotEquals(0,aiawsList.size());
        // Create Workplan Assignment
        AIA_Workplan_Assignment__c wpa = AIA_TestUtil.createWPAssignment(aiawsList,prf.id);
        system.assertNotEquals(null,wpa);
        
        opportunity opp1 = AIA_TestUtil.AIA_createopportunity(acc.id);
        system.assertNotEquals(null,opp1);
        list<PRF__c> prfList1 = AIA_TestUtil.AIA_CreatePRF(opp.id);
        system.assertNotEquals(0,prfList1.size());
        list<Workplan_Stage__c> aiawsList1 = AIA_TestUtil.createWPS();
        system.assertNotEquals(0,aiawsList1.size());
        list<AIA_Workplan_Assignment__c> wpaList1 = AIA_TestUtil.createWPA(aiawsList1,prfList1);
        system.assertNotEquals(0,wpaList1.size());
        AIA_TestUtil.updateWPA(wpalist1);
        
        update wpa;        
        delete wpa;
        update wpaList1;
        Test.stopTest();
		*/
		/*T01 End*/
    }
    
}