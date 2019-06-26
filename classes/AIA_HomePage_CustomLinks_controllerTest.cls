/*=========================================================================================
 * Date         : 01/25/2018
 * Developer    : Gayathri Palanisamy
 * Purpose      : This is the test class for AIA_HomePage_CustomLinks_Controller class
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer          Tag        Description
 *===========+=================+=====+=====================================================
 *=========================================================================================
 */
@isTest
public class AIA_HomePage_CustomLinks_controllerTest {

    private static testmethod void testGetURL()
    {
       Test.startTest();
       Map<String,String> config = new Map<String,String>(); 
       config = AIA_HomePage_CustomLinks_Controller.getUrl(); 
       system.assertEquals(config.get('classic_theme'),'Theme3');
       Test.stopTest();
    }
}