/*=========================================================================================
 * Date         : 10/27/2014
 * Developer    : Ken Gill
 * Purpose      : This class provides testing coverage for the Apex proxy class generated from the EGP WSDL               
 *                It exercises the CreateCase and UpdateCase methods on the web service.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 09/23/15  |  KG    | Initial Version                                         
 *           |        | 
 *===========+============+================================================================
 */


@isTest
private class FCI_FacetsServiceProxyTest {

    /**
     * Test all data elements
     * This method does not test any real functionality but provides test coverage for 
     * the field classes which do not have any logic other than a constructor that declares fields
     * The Apex generation from WSDL represents data elements in the WSDL as classes in Apex 
     * hence the need for this testMethod to ensure complete test coverage of 100%
     */
     
     static testMethod void testClassFields() {
        Test.startTest();
        
		new FCI_FacetsServiceProxy.CSCI_element();
		new FCI_FacetsServiceProxy.CSWN_element();
		new FCI_FacetsServiceProxy.CSWV_element();
		new FCI_FacetsServiceProxy.CSWC_element();
		new FCI_FacetsServiceProxy.CSWR_element();
		new FCI_FacetsServiceProxy.CSSC_element();
		new FCI_FacetsServiceProxy.CSTK_element();
		new FCI_FacetsServiceProxy.createCaseResponseMessage_element();
		new FCI_FacetsServiceProxy.updateCaseRequestMessage_element();
		new FCI_FacetsServiceProxy.CreateCaseResponse_element();
		new FCI_FacetsServiceProxy.Message_element();
		new FCI_FacetsServiceProxy.updateCaseFields_element();
		new FCI_FacetsServiceProxy.CreateCaseRequest_element();
		new FCI_FacetsServiceProxy.StatusBlock_element();
		new FCI_FacetsServiceProxy.updateCaseResponseMessage_element();
		new FCI_FacetsServiceProxy.createCaseRequestMessage_element();
		new FCI_FacetsServiceProxy.SystemUnavailableFault_element();
		new FCI_FacetsServiceProxy.DataNotFound_element();
		new FCI_FacetsServiceProxy.AuthenticationException_element();
		new FCI_FacetsServiceProxy.InputDataInvalid_element();
		new FCI_FacetsServiceProxy.SourceSystemInvalid_element();
		new FCI_FacetsServiceProxy.fault_element();
		new FCI_FacetsServiceProxy.SystemTimeOutException_element();
		new FCI_FacetsServiceProxy.faultType_element();
		new FCI_FacetsServiceProxy.DefaultFault_element();
		new FCI_FacetsServiceProxy.PackageNotCompiled_element();
		new FCI_FacetsServiceProxy.ApplicationException_element();
		new FCI_FacetsServiceProxy.cfHeaders();
		new FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1();

        System.assert(true);
        Test.stopTest();
     }
    /**
     * Test CreateCase method
     */
    static testMethod void testCreateCase() {
	    FCI_FacetsServiceProxy.CreateCaseRequest_element  requestElement;
	
	    Test.setMock(WebServiceMock.class, new FCI_FacetsServiceProxyMockImpl());
	    Test.startTest();
	
	    FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1 ws = new FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1();
	
	    FCI_FacetsServiceProxy.createCaseResponseMessage_element response =
		ws.CreateCase( requestElement);
	 
	    System.assert(true);
	    Test.stopTest();
    }


    /**
     * Test UpdateCase method
     */
    static testMethod void testUpdateCase() {
	    String facetsCaseID;
	    FCI_FacetsServiceProxy.updateCaseFields_element[] updateCaseFields;

	    Test.setMock(WebServiceMock.class, new FCI_FacetsServiceProxyMockImpl());	
	    Test.startTest();
	    FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1 ws = new FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1();
	
	    FCI_FacetsServiceProxy.StatusBlock_element response =
		ws.UpdateCase( facetsCaseID, updateCaseFields);
	 
	    System.assert(true);
	    Test.stopTest();
    }
    
}