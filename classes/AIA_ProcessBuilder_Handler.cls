/*=====================================================================================================================
* Date         : 04/13/2017
* Developer    : Asif K
* Purpose      : Handler class which has methods that can be called by Process Builder             
*======================================================================================================================
*                                 Update History
* -----------------------------------------------------------------------------------------------------------------
* Date       | Developer  | Tag | Description
*============+============+=====+======================================================================================
* 08/08/2016 | Asif K     |     | Initial Version                                       
*============+============+=====+======================================================================================
*/

public without sharing class AIA_ProcessBuilder_Handler {
    
    @InvocableMethod
    public static void callDoNothingMethod()
    {
        AIA_ProcessBuilder_Helper obj = new AIA_ProcessBuilder_Helper();
        obj.DoNothing();
    }
}