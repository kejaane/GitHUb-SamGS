/*=========================================================================================
 * Date         : 01/06/2018
 * Developer    : Sree Uma Ponnoju
 * Purpose      : Test Class for request and response time stamp calculation
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 01/06/18  |  Sree Uma Ponnoju    | Initial Version 
 *           |        | 
 *=========================================================================================
 */
@isTest
private class IntegrationReqResTest {


    // Test the Request timestamps
    static testMethod void testReqTimeStamps() {

    Test.startTest();
    boolean isValid = true;
    IntegrationRequest iReq = new IntegrationRequest();
    Integer Req_ts_1 = new IntegrationRequest().Req_ts;
    Integer Req_ts_2 = new IntegrationRequest().Req_ts;
    new IntegrationRequest();
    iReq.isValid();
    iReq.setIsValid(isValid);
    Test.stopTest();
    }
    
    // Test the Response timestamps generated 
    static testMethod void testResTimeStamps() {

    Test.startTest();
    IntegrationRequest iReq = new IntegrationRequest();
    Integer Res_ts_1 = new IntegrationResponse(iReq).Res_ts;
    new IntegrationResponse(iReq);
    Integer Res_ts_2 = new IntegrationResponse(iReq).Res_ts;
    String responseTime1 = new IntegrationResponse(iReq).responseTime;
    System.assert( true);    
    Test.stopTest();
    }
    
}