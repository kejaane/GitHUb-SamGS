/*=====================================================================================================================
* Date         : 04/13/2017
* Developer    : Asif K
* Purpose      : Test class for Handler class which has methods that can be called by Process Builder             
*======================================================================================================================
*                                 Update History
* -----------------------------------------------------------------------------------------------------------------
* Date       | Developer  | Tag | Description
*============+============+=====+======================================================================================
* 08/08/2016 | Asif K     |     | Initial Version                                       
*============+============+=====+======================================================================================
*/
@isTest
private class AIA_ProcessBuilder_Handler_Test {
	private static testMethod void callDoNothingMethod_Test() {
	    //no asserts in this method since this is a dummy method.
	    AIA_ProcessBuilder_Handler.callDoNothingMethod();
	}
}