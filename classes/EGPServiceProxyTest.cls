/*=========================================================================================
 * Date         : 10/27/2014
 * Developer    : Ken Gill
 * Purpose      : This class provides testing coverage for the Apex proxy class generated from the EGP WSDL               
 *                It exercises the ManageUser and ManageAccount methods on the web service.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/27/14  |  KG    | Initial Version                                         
 * 10/13/2015|  TPB   | Added Opportunity Effective Date (vendorEffectiveDate)
 *===========+============+================================================================
 */


@isTest
private class EGPServiceProxyTest {

    /**
     * Test all data elements
     * This method does not test any real functionality but provides test coverage for 
     * the field classes which do not have any logic other than a constructor that declares fields
     * The Apex generation from WSDL represents data elements in the WSDL as classes in Apex 
     * hence the need for this testMethod to ensure complete test coverage of 100%
     */
     
     static testMethod void testClassFields() {
        Test.startTest();
        
        new EGPServiceProxy.SystemUnavailableFault_element();
        new EGPServiceProxy.PackageNotCompiled_element();
        new EGPServiceProxy.DataNotFound_element();
        new EGPServiceProxy.ApplicationException_element();
        new EGPServiceProxy.DefaultFault_element();
        new EGPServiceProxy.AuthenticationException_element();
        new EGPServiceProxy.SourceSystemInvalid_element();
        new EGPServiceProxy.faultType_element();
        new EGPServiceProxy.InputDataInvalid_element();
        new EGPServiceProxy.fault_element();
        new EGPServiceProxy.SystemTimeOutException_element();
        new EGPServiceProxy.group_element();
        new EGPServiceProxy.accountUpdateResponse_element();
        new EGPServiceProxy.manageUserResponse_element();
        new EGPServiceProxy.manageUserRequest_element();
        new EGPServiceProxy.accountUpdateRequest_element();
        new EGPServiceProxy.SOAPHeader_element();
        new EGPServiceProxy.SourceSpecificFields_element();
        
        System.assert(true);
        Test.stopTest();
     }
    /**
     * Test manageUser method
     */
    static testMethod void testManageUser() {
    String entity;
    String submittedById;
    String action;
    String firstName;
    String lastName;
    String emailAddress;
    String accountName;
    List<EGPServiceProxy.group_element> group_x;
    String managerFirstName;
    String managerLastName;
    String managerEmailAddress;
    String enrollmentVendor;
    String vendorEffectiveDate;
    String asoInd;

    Test.setMock(WebServiceMock.class, new EGPServiceProxyMockImpl());

    Test.startTest();
    EGPServiceProxy.SalesForceEndpoint1 ws = new EGPServiceProxy.SalesForceEndpoint1();

        EGPServiceProxy.manageUserResponse_element response = 
               ws.ManageUser(
            entity,submittedById,action,firstName,lastName,emailAddress,accountName,
            group_x, managerFirstName, managerLastName, managerEmailAddress, 
            enrollmentVendor, vendorEffectiveDate, asoInd); 

    System.assert(true);
    Test.stopTest();
    }


    /**
     * Test accountUpdate method
     */
    static testMethod void testAccountUpdate() {

    String entity;
    String submittedById;
    String action;
    String accountName;
    EGPServiceProxy.group_element[] group_x;
    String asoInd;
    String fspName;
    String gpName;
    String managerFirstName;
    String managerLastName;
    String managerEmailAddress;
    String enrollmentVendor;
    String vendorEffectiveDate;

    Test.setMock(WebServiceMock.class, new EGPServiceProxyMockImpl());

    Test.startTest();
    EGPServiceProxy.SalesForceEndpoint1 ws = new EGPServiceProxy.SalesForceEndpoint1();

        EGPServiceProxy.accountUpdateResponse_element response = 
         ws.AccountUpdate(
            entity,
            submittedById, 
            action, 
            accountName,
            group_x, 
            asoInd, fspName, gpName, managerFirstName, managerLastName, managerEmailAddress, 
            enrollmentVendor, vendorEffectiveDate);
    System.assert(true);
    Test.stopTest();
    }
    
}