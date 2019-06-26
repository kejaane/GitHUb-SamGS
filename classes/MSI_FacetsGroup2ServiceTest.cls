@isTest
private class MSI_FacetsGroup2ServiceTest {

    @isTest static void test_getService() {
        Test.startTest();
        MSI_FacetsGroup2ServiceProxy.OperationsOfGroupEndpoint service = MSI_FacetsGroup2Service.getService();
        System.assert( service != null, 'Failed to return a service endpoint object');
        Test.stopTest();
    }
    
    
    @isTest static void test_getTerminatedStatus( ) {
        // setupData();

        // Use StaticResourceCalloutMock built-in class to
        // specify fake response and include response body 
        // in a static resource.
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('MSI_FacetsGroup2Service_GetGroupDetailsMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/xml');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        //setupEnvironmentData();
                
        MSI_FacetsGroup2Response response;
        
        try {
        MSI_FacetsGroup2Request request = new MSI_FacetsGroup2Request();
        request.groupID = '{GROUPID}' ;

        response = MSI_FacetsGroup2Service.getTerminatedStatusUsingHTTP( request);
 

        } catch( Exception e) {
            System.assert( False , 'Failed to get response. Exception = ' + e.getMessage());
        }

        System.assertEquals( Null, response.isTerminated,'Expecting Group status to be Active not Terminated');
        Test.stopTest();
    }


    @testSetup
    static void setupData() {

    MSI_FacetsGroup2ServiceTest.setupEnvironmentData();
    
           
    }

    
        // Setup environment variables needed to configure FCI_FacetsService
    public static void setupEnvironmentData() {
    List<EnvironmentVariable__c> envVars = new List<EnvironmentVariable__c>();
    EnvironmentVariable__c ev;
    
    String sfdcEmail = UserInfo.getUserEmail();

    // MSI related environment variables
    String msiEmail = sfdcEmail;

    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_ClientCertificateName', Value__c = 'salesforce_int_carefirst_com' , Name = 'MSI_ClientCertificateName', 
    Module__c = 'MSI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'SFDC_Support_Email', Value__c = sfdcEmail , Name = 'SFDC_Support_Email', Module__c = 'MSI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_Support_Email', Value__c = msiEmail , Name = 'MSI_Support_Email', Module__c = 'MSI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_EndPoint', Value__c = 'https://servicestt.carefirst.com/facets/FacetsSalesForce_Interfaces/BusinessProcesses/Common/FacetsSalesForceService.serviceagent/OperationsOfFacetsSalesForceEndpoint1' , Name = 'MSI_EndPoint', Module__c = 'MSI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'RequestTimeout', Value__c = '60000' , Name = 'RequestTimeout', Module__c = 'MSI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_UserPassword', Value__c = 'XYSSDDFFDSFD' , Name = 'MSI_UserPassword', Module__c = 'MSI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_UserName', Value__c = 'tibws_fxifacets_sfuser_salesforce' , Name = 'MSI_UserName', Module__c = 'MSI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'ClientCertificateName', Value__c = 'salesforce_dev3_carefirst_com' , Name = 'ClientCertificateName', Module__c = 'Common', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    

// MSI FacetsGroup2 Service Integration related
    

    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_GRP2SRV_SFDC_Support_Email', Value__c = 'kirat.gill@carefirst.com' , Name = 'MSI_GRP2SRV_SFDC_Support_Email', 
    Module__c = 'MSI Group2Service', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_GRP2SVC_EndPoint', Value__c = 'https://servicestt.carefirst.com/GroupServices/BusinessProcesses/GroupSearch/MainProcesses/Group.serviceagent/OperationsOfGroupEndpoint' , Name = 'MSI_GRP2SVC_EndPoint', 
    Module__c = 'MSI Group2Service', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_GRP2SRV_UserName', Value__c = 'na-for-dev3' , Name = 'MSI_GRP2SRV_UserName', 
    Module__c = 'MSI Group2Service', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_GRP2SRV_Support_Email', Value__c = 'kirat.gill@carefirst.com' , Name = 'MSI_GRP2SRV_Support_Email', 
    Module__c = 'MSI Group2Service', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_GRP2SRV_RequestTimeout', Value__c = '120000' , Name = 'MSI_GRP2SRV_RequestTimeout', 
    Module__c = 'MSI Group2Service', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_GRP2SRV_UserPassword', Value__c = 'na-for-dev3' , Name = 'MSI_GRP2SRV_UserPassword', 
    Module__c = 'MSI Group2Service', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
        
    // FCI Integration related
    String fciEmail = sfdcEmail;
    

    ev = new EnvironmentVariable__c(  Variable_Name__c = 'FCI_ClientCertificateName', Value__c = 'salesforce_dev3_carefirst_com' , Name = 'FCI_ClientCertificateName', 
    Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'SFDC_Support_Email', Value__c = sfdcEmail , Name = 'SFDC_Support_Email', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'FCI_Support_Email', Value__c = fciEmail , Name = 'FCI_Support_Email', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'FCI_EndPoint', Value__c = 'https://servicestt.carefirst.com/facets/FacetsSalesForce_Interfaces/BusinessProcesses/Common/FacetsSalesForceService.serviceagent/OperationsOfFacetsSalesForceEndpoint1' , Name = 'FCI_EndPoint', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'RequestTimeout', Value__c = '60000' , Name = 'RequestTimeout', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'FCI_UserPassword', Value__c = 'SDFDSFDShlpZ' , Name = 'FCI_UserPassword', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'FCI_UserName', Value__c = 'tibws_fxifacets_sfuser_salesforce' , Name = 'FCI_UserName', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'ClientCertificateName', Value__c = 'salesforce_dev3_carefirst_com' , Name = 'ClientCertificateName', Module__c = 'Common', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
        // add EGP related parameters

    ev = new EnvironmentVariable__c(  Variable_Name__c = 'EGP_EndPoint', Value__c = 'xx' , Name = 'EGP_EndPoint', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'EGP_ClientCertificateName', Value__c = 'salesforce_dev3_carefirst_com' , Name = 'EGP_ClientCertificateName', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'RequestTimeout', Value__c = '60000' , Name = 'RequestTimeout', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'EGP_Support_Email', Value__c = sfdcEmail , Name = 'EGP_Support_Email', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'SFDC_Support_Email', Value__c = sfdcEmail , Name = 'SFDC_Support_Email', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    upsert envVars;     
    }
    
}