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
private class MSI_MemberServiceProxyTest {

    /**
     * Test all data elements
     * This method does not test any real functionality but provides test coverage for 
     * the field classes which do not have any logic other than a constructor that declares fields
     * The Apex generation from WSDL represents data elements in the WSDL as classes in Apex 
     * hence the need for this testMethod to ensure complete test coverage of 100%
     */
     
     static testMethod void testClassFields() {
        Test.startTest();
        
		new MSI_MemberServiceProxy.memberDelinquencyRequestMessage_DelinquencyRequest_element();
		new MSI_MemberServiceProxy.memberDelinquencyRequestMessage_element();
		new MSI_MemberServiceProxy.memberDelinquencyResponseMessage_DelinquencyResponse_element();
		new MSI_MemberServiceProxy.memberDelinquencyResponseMessage_DelinquencyResponse_MemberDelinquencyDetails_element();
		new MSI_MemberServiceProxy.memberDelinquencyResponseMessage_element();
		new MSI_MemberServiceProxy.MemberSubsidyRequestMessage_element();
		new MSI_MemberServiceProxy.MemberSubsidyRequestMessage_SubsidyRequest_element();
		new MSI_MemberServiceProxy.MemberSubsidyResponseMessage_element();
		new MSI_MemberServiceProxy.MemberSubsidyResponseMessage_SubsidyResponse_element();
		new MSI_MemberServiceProxy.MemberSubsidyResponseMessage_SubsidyResponse_MemberSubsidyDetails_element();
		new MSI_MemberServiceProxy.memberSummaryRequestMessage_element();
		new MSI_MemberServiceProxy.memberSummaryRequestMessage_MemberSummaryRequest_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_AdditionalDetails_BSBSDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_AdditionalDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_AdditionalDetails_PDDSAppTypeDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_MemberClaimHoldDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_MemberCOBDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_MemberEligibilityDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_MemberHandicapDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_MemberMedicareDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_MemberPrimaryProvider_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_MemberProcessEligibilityDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_MemberStudentDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberAddressDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberClassDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberEligibilityDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberRateModifier_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberRateRecordTypeDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberSalaryDetails_element();
		new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberSubGroupDetails_element();
		new MSI_MemberServiceProxy.privacyRequestMessage_element();
		new MSI_MemberServiceProxy.privacyRequestMessage_PrivacyRequest_element();
		new MSI_MemberServiceProxy.privacyResponseMessage_element();
		new MSI_MemberServiceProxy.privacyResponseMessage_PrivacyResponse_element();
		new MSI_MemberServiceProxy.privacyResponseMessage_PrivacyResponse_PrivacyGroup_element();
		new MSI_MemberServiceProxy.privacyResponseMessage_PrivacyResponse_PrivacyGroup_PrivacyIndicators_element();
		new MSI_MemberServiceProxy.memberEligibilityRequestMessage_element();
		new MSI_MemberServiceProxy.memberEligibilityRequestMessage_EligibilityRequest_element();
		new MSI_MemberServiceProxy.memberEligibilityResponseMessage_element();
		new MSI_MemberServiceProxy.memberEligibilityResponseMessage_EligibilityResponse_element();
		new MSI_MemberServiceProxy.memberEligibilityResponseMessage_EligibilityResponse_MemberEligibilityDetails_element();
		new MSI_MemberServiceProxy.memberEligibilityResponseMessage_EligibilityResponse_MemberEligibilityDetails_ProductEligibilityDetails_element();
		new MSI_MemberServiceProxy.StatusBlock_element();
		new MSI_MemberServiceProxy.StatusBlock_Message_element();
		new MSI_MemberServiceProxy.StatusBlock_element();
		new MSI_MemberServiceProxy.StatusBlock_Message_element();
		new MSI_MemberServiceProxy.cfHeaders();
		new MSI_MemberServiceProxy.faultDetailValue_element();
		new MSI_MemberServiceProxy.OperationsOfMemberEndpoint1();

        System.assert(true);
        Test.stopTest();
     }
     
   /**
     * Test GetMemberDetails method
     */
    static testMethod void testGetMemberDetails() {
    	MSI_MemberServiceProxy.memberSummaryRequestMessage_MemberSummaryRequest_element requestElement;

    	Test.setMock(WebServiceMock.class, new MSI_MemberServiceProxyImpl());
    	Test.startTest();
	
		MSI_MemberServiceProxy.OperationsOfMemberEndpoint1 ws = new MSI_MemberServiceProxy.OperationsOfMemberEndpoint1();

		MSI_MemberServiceProxy.memberSummaryResponseMessage_element proxyReponse = 
				ws.GetMemberSummary( requestElement );

	    System.assert(true);
	    Test.stopTest();
    }
     
  /**
     * Test GetMemberDelinquency method
     */
    static testMethod void testGetMemberDelinquency() {
    	MSI_MemberServiceProxy.memberDelinquencyRequestMessage_DelinquencyRequest_element requestElement;

    	Test.setMock(WebServiceMock.class, new MSI_MemberServiceProxyImpl());
    	Test.startTest();
	
		MSI_MemberServiceProxy.OperationsOfMemberEndpoint1 ws = new MSI_MemberServiceProxy.OperationsOfMemberEndpoint1();

		MSI_MemberServiceProxy.memberDelinquencyResponseMessage_element proxyReponse = 
				ws.GetMemberDelinquency( requestElement );

	    System.assert(true);
	    Test.stopTest();
    }
    
   /**
     * Test GetMemberDetails method
     */
    static testMethod void testGetMemberPrivacyIndicators() {
    	MSI_MemberServiceProxy.privacyRequestMessage_PrivacyRequest_element  requestElement;

    	Test.setMock(WebServiceMock.class, new MSI_MemberServiceProxyImpl());
    	Test.startTest();
	
		MSI_MemberServiceProxy.OperationsOfMemberEndpoint1 ws = new MSI_MemberServiceProxy.OperationsOfMemberEndpoint1();

		MSI_MemberServiceProxy.privacyResponseMessage_element proxyReponse = 
				ws.GetMemberPrivacyIndicators( requestElement );

	    System.assert(true);
	    Test.stopTest();
    }


   /**
     * Test GetMemberProdElig method
     */
    static testMethod void testGetMemberProdElig() {
    	MSI_MemberServiceProxy.memberEligibilityRequestMessage_EligibilityRequest_element requestElement;

    	Test.setMock(WebServiceMock.class, new MSI_MemberServiceProxyImpl());
    	Test.startTest();
	
		MSI_MemberServiceProxy.OperationsOfMemberEndpoint1 ws = new MSI_MemberServiceProxy.OperationsOfMemberEndpoint1();

		MSI_MemberServiceProxy.memberEligibilityResponseMessage_element proxyReponse = 
				ws.GetMemberProdElig( requestElement );

	    System.assert(true);
	    Test.stopTest();
    }


   /**
     * Test GetMemberSubsidyInfo method
     */
    static testMethod void testGetMemberSubsidyInfo() {
    	MSI_MemberServiceProxy.MemberSubsidyRequestMessage_SubsidyRequest_element requestElement;

    	Test.setMock(WebServiceMock.class, new MSI_MemberServiceProxyImpl());
    	Test.startTest();
	
		MSI_MemberServiceProxy.OperationsOfMemberEndpoint1 ws = new MSI_MemberServiceProxy.OperationsOfMemberEndpoint1();

		MSI_MemberServiceProxy.MemberSubsidyResponseMessage_element proxyReponse = 
				ws.GetMemberSubsidyInfo( requestElement );

	    System.assert(true);
	    Test.stopTest();
    }
         
}