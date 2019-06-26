/*******************************************************************************************************************
 * Class Name: AIA_PlanDataCall_Test
 * Purpose   : This is test class for the class AIA_PlanDataCall
 * Modification Log:
 * ModifiedBy       DateModified            Description
 * -------------------------------------------------------------------------
 * Asif K           10/25/2016              Created
 * 
 * *****************************************************************************************************************/
@isTest
private class AIA_PlanDataCall_Test {

	private static testMethod void test() {
        AIA_Plan__c p = new AIA_Plan__c ();
        p.Product_Category__c = 'Medical';
        p.Product_Line__c = 'Health Maintenance Organization';
        p.CDH__c = 'Yes';
        p.CDH_Type__c = 'HSA';
        p.CDH_Fund_Type__c = 'BlueFund';
        p.Plan_Id__c = 'testsdglksdgjlsldgkjs';
        p.Effective_Date__c = system.today();
        p.Termination_Date__c = system.today();
        p.Product_Status__c ='Active';
        p.Jurisdiction__c = 'MD';
        p.Product_Last_Updated_String_Format__c = '2016-10-25 07:04:03 AM';
        insert p;
        
        Test.startTest();
        
        Boolean result1 = AIA_PlanDataCall.getPlanDetails(p.Id);
        System.assertEquals(True, result1);

        Boolean result2 = AIA_PlanDataCall.getPlanDetails('');
        System.assertEquals(False, result2);
        
        Test.stopTest();
	}

}