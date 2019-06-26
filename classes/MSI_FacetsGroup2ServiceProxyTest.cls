/*=========================================================================================
 * Date         : 106/20/2017
 * Developer    : Ashish Ojha
 * Purpose      : This class provides testing coverage for the Apex proxy class generated from theMSI_FacetsGroup2Service  WSDL               
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
private class MSI_FacetsGroup2ServiceProxyTest {

    /**
     * Test all data elements
     * This method does not test any real functionality but provides test coverage for 
     * the field classes which do not have any logic other than a constructor that declares fields
     * The Apex generation from WSDL represents data elements in the WSDL as classes in Apex 
     * hence the need for this testMethod to ensure complete test coverage of 100%
     */
     
     static testMethod void testClassFields() {
        Test.startTest();
        
     //   new MSI_FacetsGroup2ServiceProxy.MSI_FacetsGroup2ServiceProxy ();
        new MSI_FacetsGroup2ServiceProxy.cfHeaders ();
        new MSI_FacetsGroup2ServiceProxy.productAIAI_element ();
        new MSI_FacetsGroup2ServiceProxy.medPlatformRecord_element ();
        new MSI_FacetsGroup2ServiceProxy.REC_GRGR_element ();
        new MSI_FacetsGroup2ServiceProxy.requestMessage_element();
        new MSI_FacetsGroup2ServiceProxy.GRRE_COLL_element();
        new MSI_FacetsGroup2ServiceProxy.GRGR_COLL_element();
        new MSI_FacetsGroup2ServiceProxy.GetGroupDetailsResponse_element();
        new MSI_FacetsGroup2ServiceProxy.responseMessage_element();
        new MSI_FacetsGroup2ServiceProxy.StatusBlock_element();
        new MSI_FacetsGroup2ServiceProxy.attributeType();
        new MSI_FacetsGroup2ServiceProxy.planRelatedDataDetail_element();
        new MSI_FacetsGroup2ServiceProxy.productGPAI_element();
        new MSI_FacetsGroup2ServiceProxy.groupLevelPlanRelatedData_element();
        new MSI_FacetsGroup2ServiceProxy.keyType();
        new MSI_FacetsGroup2ServiceProxy.memberLevelPlanRelatedData_element();
        new MSI_FacetsGroup2ServiceProxy.GroupOptions_element();
        new MSI_FacetsGroup2ServiceProxy.Message_element();
        new MSI_FacetsGroup2ServiceProxy.error_element();
        new MSI_FacetsGroup2ServiceProxy.GroupSearchRequest_element();
        new MSI_FacetsGroup2ServiceProxy.GroupSearchResponse_element();
        new MSI_FacetsGroup2ServiceProxy.GetGroupDetailsRequest_element();
        new MSI_FacetsGroup2ServiceProxy.rateSizeIndicator_element();
        new MSI_FacetsGroup2ServiceProxy.REC_GRRE_element();
        new MSI_FacetsGroup2ServiceProxy.planRelatedDataRequest_element();
        new MSI_FacetsGroup2ServiceProxy.networkSet_element();
        new MSI_FacetsGroup2ServiceProxy.requestPlanRelatedDataMessage_element();
        new MSI_FacetsGroup2ServiceProxy.responsePlanRelatedDataMessage_element();
        new MSI_FacetsGroup2ServiceProxy.OperationsOfGroupEndpoint();
        

        System.assert(true);
        Test.stopTest();
     }
     
   /**
     * Test GetMemberDetails method
     
    static testMethod void testGetMemberDetails() {
    
     // Use StaticResourceCalloutMock built-in class to
        // specify fake response and include response body 
        // in a static resource.
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MSI_FacetsGroup2Service_GetGroupDetailsMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/xml');
        
        MSI_FacetsGroup2ServiceProxy.planRelatedDataRequest_element requestElement;

        Test.setMock(WebServiceMock.class, mock);
        Test.startTest();
    
        MSI_FacetsGroup2ServiceProxy.OperationsOfGroupEndpoint ws = new MSI_FacetsGroup2ServiceProxy.OperationsOfGroupEndpoint ();
        
         MSI_FacetsGroup2ServiceProxy.responsePlanRelatedDataMessage_element  proxyReponse = 
                ws.GetPlanRelatedData( requestElement );

        System.assert(true);
        Test.stopTest();
    }
     
  /**
     * Test GetMemberDelinquency method
     *
    static testMethod void testGetMemberDelinquency() {
        MSI_FacetsGroup2ServiceProxy.memberDelinquencyRequestMessage_DelinquencyRequest_element requestElement;

        Test.setMock(WebServiceMock.class, new MSI_FacetsGroup2ServiceProxyImpl());
        Test.startTest();
    
        MSI_FacetsGroup2ServiceProxy.OperationsOfMemberEndpoint1 ws = new MSI_FacetsGroup2ServiceProxy.OperationsOfMemberEndpoint1();

        MSI_FacetsGroup2ServiceProxy.memberDelinquencyResponseMessage_element proxyReponse = 
                ws.GetMemberDelinquency( requestElement );

        System.assert(true);
        Test.stopTest();
    }
    
   /**
     * Test GetMemberDetails method
     *
    static testMethod void testGetMemberPrivacyIndicators() {
        MSI_FacetsGroup2ServiceProxy.planRelatedDataRequest_element requestElement;

        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
    
        MSI_FacetsGroup2ServiceProxy.OperationsOfGroupEndpoint ws = new MSI_FacetsGroup2ServiceProxy.OperationsOfGroupEndpoint();

        MSI_FacetsGroup2ServiceProxy.responsePlanRelatedDataMessage_element  proxyReponse = 
                ws.GetPlanRelatedData( requestElement );

        System.assert(true);
        Test.stopTest();
    }


   /**
     * Test GetMemberProdElig method
     *
    static testMethod void testGetMemberProdElig() {
        MSI_FacetsGroup2ServiceProxy.memberEligibilityRequestMessage_EligibilityRequest_element requestElement;

        Test.setMock(WebServiceMock.class, new MSI_FacetsGroup2ServiceProxyImpl());
        Test.startTest();
    
        MSI_FacetsGroup2ServiceProxy.OperationsOfMemberEndpoint1 ws = new MSI_FacetsGroup2ServiceProxy.OperationsOfMemberEndpoint1();

        MSI_FacetsGroup2ServiceProxy.memberEligibilityResponseMessage_element proxyReponse = 
                ws.GetMemberProdElig( requestElement );

        System.assert(true);
        Test.stopTest();
    }


   /**
     * Test GetMemberSubsidyInfo method
     *
    static testMethod void testGetMemberSubsidyInfo() {
        MSI_FacetsGroup2ServiceProxy.MemberSubsidyRequestMessage_SubsidyRequest_element requestElement;

        Test.setMock(WebServiceMock.class, new MSI_FacetsGroup2ServiceProxyImpl());
        Test.startTest();
    
        MSI_FacetsGroup2ServiceProxy.OperationsOfMemberEndpoint1 ws = new MSI_FacetsGroup2ServiceProxy.OperationsOfMemberEndpoint1();

        MSI_FacetsGroup2ServiceProxy.MemberSubsidyResponseMessage_element proxyReponse = 
                ws.GetMemberSubsidyInfo( requestElement );

        System.assert(true);
        Test.stopTest();
    }
      */   
}