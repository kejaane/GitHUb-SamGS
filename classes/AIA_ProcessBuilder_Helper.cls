/*=====================================================================================================================
* Date         : 04/13/2017
* Developer    : Asif K
* Purpose      : Helper class which has methods that can be called by Process Builder Handler class named 
*                AIA_ProcessBuilder_Handler.             
*======================================================================================================================
*                                 Update History
* -----------------------------------------------------------------------------------------------------------------
* Date       | Developer  | Tag | Description
*============+============+=====+======================================================================================
* 08/08/2016 | Asif K     |     | Initial Version                                       
*============+============+=====+======================================================================================
*/

public without sharing class AIA_ProcessBuilder_Helper {
    
    /* Method to perform No action. This is useful in cases where there is a condition in Process Builder, when   *
     * satisfied, no action should be performed but when it is not satisfied there is a series of further actions *
     * including further criteria checks that need to be performed                                                */
    public void DoNothing()
    {
        
    }
}