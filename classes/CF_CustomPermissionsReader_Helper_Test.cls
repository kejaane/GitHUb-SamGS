@isTest
private class CF_CustomPermissionsReader_Helper_Test {

	private static testMethod void test() {
	    User usr = [SELECT id,name FROM User WHERE name = 'spmss process'];
        Test.startTest();
	    //Assuming spmss process user is assigned with the custom permission - ignore validation rules
        System.runAs(usr)
        {
            system.assertEquals(true, CF_CustomPermissionsReader_Helper.Permissions.ignoreVRs);
        }
        Test.stopTest();
	}
	
}