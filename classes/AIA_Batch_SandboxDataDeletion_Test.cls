@isTest
private class AIA_Batch_SandboxDataDeletion_Test {
	private static testMethod void test() {
	    User usr = [Select Id From User where firstname = 'spmss'];
	    system.runAs(usr)
	    {
	        list<AIA_PCS_Transaction_Table__c> datalist = new list<AIA_PCS_Transaction_Table__c>();
	        AIA_PCS_Transaction_Table__c apt1 = new AIA_PCS_Transaction_Table__c(Name='1',PCS_Tag__c='test', Salesforce_Display_Name__c='test');
	        datalist.add(apt1);
	        AIA_PCS_Transaction_Table__c apt2 = new AIA_PCS_Transaction_Table__c(Name='2',PCS_Tag__c='test', Salesforce_Display_Name__c='test');
	        datalist.add(apt2);
	        AIA_PCS_Transaction_Table__c apt3 = new AIA_PCS_Transaction_Table__c(Name='3',PCS_Tag__c='test', Salesforce_Display_Name__c='test');
	        datalist.add(apt3);
	        AIA_PCS_Transaction_Table__c apt4 = new AIA_PCS_Transaction_Table__c(Name='4',PCS_Tag__c='test', Salesforce_Display_Name__c='test');
	        datalist.add(apt4);
	        AIA_PCS_Transaction_Table__c apt5 = new AIA_PCS_Transaction_Table__c(Name='5',PCS_Tag__c='test', Salesforce_Display_Name__c='test');
	        datalist.add(apt5);
	        AIA_PCS_Transaction_Table__c apt6 = new AIA_PCS_Transaction_Table__c(Name='6',PCS_Tag__c='test', Salesforce_Display_Name__c='test');
	        datalist.add(apt6);
	        AIA_PCS_Transaction_Table__c apt7 = new AIA_PCS_Transaction_Table__c(Name='7',PCS_Tag__c='test', Salesforce_Display_Name__c='test');
	        datalist.add(apt7);
	        insert datalist;
	        AIA_Plan__c ap = new AIA_Plan__c(Plan_Id__c='PLAN-1382');
	        insert ap;
	        
	        Test.startTest();
            AIA_Batch_SandboxDataDeletion DataDelJob = new AIA_Batch_SandboxDataDeletion();
            database.executebatch(DataDelJob);
            Test.stopTest();
            AIA_Plan__c RefPlan = [SELECT Id,Plan_Id__c 
                                   FROM AIA_Plan__c 
                                   WHERE Plan_Id__c = 'PLAN-1382'];
            system.assertEquals('PLAN-1382',RefPlan.Plan_Id__c);
	    }
	}
	    /*
    private static testMethod void scheduleTop10PartnerPurge_Test() {
            list<AIA_PCS_Transaction_Table__c> datalist = new list<AIA_PCS_Transaction_Table__c>();
	        AIA_PCS_Transaction_Table__c apt1 = new AIA_PCS_Transaction_Table__c(Name='1',PCS_Tag__c='test', Salesforce_Display_Name__c='test');
	        datalist.add(apt1);
	        AIA_PCS_Transaction_Table__c apt2 = new AIA_PCS_Transaction_Table__c(Name='2',PCS_Tag__c='test', Salesforce_Display_Name__c='test');
	        datalist.add(apt2);
	        AIA_PCS_Transaction_Table__c apt3 = new AIA_PCS_Transaction_Table__c(Name='3',PCS_Tag__c='test', Salesforce_Display_Name__c='test');
	        datalist.add(apt3);
	        AIA_PCS_Transaction_Table__c apt4 = new AIA_PCS_Transaction_Table__c(Name='4',PCS_Tag__c='test', Salesforce_Display_Name__c='test');
	        datalist.add(apt4);
	        insert datalist;
	        AIA_Plan__c ap = new AIA_Plan__c(Plan_Id__c='PLAN-1382');
	        insert ap;
	        
	        Test.StartTest();
            AIA_Batch_SandboxDataDeletion sh = new AIA_Batch_SandboxDataDeletion();
            String sch = '0 0 5 * * ?';
            system.schedule('Schedule TEST', sch, sh);
            Test.stopTest();
        }
        */
}