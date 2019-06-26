/*=========================================================================================
 * Date         : 9/1/16
 * Developer    : Ken Gill
 * Purpose      :  
 * 
 * This class contains unit tests for Member Service Integration related classes
 *   
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 09/27/16  |  KG    | Initial Version                                         
 *           |        | 
 *           |        | 
 *=========================================================================================
 */


@isTest(SeeAllData=false)
private class MSI_MemberServiceUnitTests {

   @isTest( SeeAllData=false)
     public static void test_MSI_MemberService() {
     	
        System.debug('Testing MSI_MemberService');     
        Test.setMock(WebServiceMock.class, new MSI_MemberServiceProxyImpl());
        Test.startTest();
        setupEnvironmentData();
		
		Boolean result = MSI_MemberService.isInitialized;
	    
	    MSI_MemberSummaryRequest request = new MSI_MemberSummaryRequest();
		request.subscriberID = '903968722';
		request.returnRecord='SBSB,SBSG,MEME,SBCS,SBEL,SBAD,MEEL,MEPE,MEPR,MECB,MEHD,MEST,MECH,MEMD';
		 
		MSI_MemberSummaryResponse response =
		                      MSI_MemberService.GetMemberDetails(request);
		//MSI_MemberService.prettyPrint(response);
		
     
		System.assert(true);
		Test.stopTest();
    }




    // Setup environment variables needed to configure FCI_FacetsService
    public static void setupEnvironmentData() {
    List<EnvironmentVariable__c> envVars = new List<EnvironmentVariable__c>();
    EnvironmentVariable__c ev;
    
    String sfdcEmail = UserInfo.getUserEmail();

	// MSI related environment variables
    String msiEmail = sfdcEmail;

    ev = new EnvironmentVariable__c(  Variable_Name__c = 'MSI_ClientCertificateName', Value__c = 'salesforce_dev3_carefirst_com' , Name = 'MSI_ClientCertificateName', 
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