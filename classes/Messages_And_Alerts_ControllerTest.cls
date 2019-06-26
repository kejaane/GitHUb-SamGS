/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================
* 9/25/2018   |     Paritosh          |     Initial Creation
*==================================================================================

*******************************************************************************************************/

@isTest
public class Messages_And_Alerts_ControllerTest {
    
    public static testmethod void testConstructor(){
        
        //create user                                    
        User u = AIA_TestUtil.AIA_createUser('alias1');
        insert u;
        ApexPages.StandardController stdcont = new ApexPages.StandardController(u);
        Messages_And_Alerts_Controller cont = new Messages_And_Alerts_Controller(stdcont);
        
        
    }
    

}