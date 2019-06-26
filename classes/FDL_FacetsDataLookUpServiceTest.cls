/*=========================================================================================
 * Date         : 11/13/17
 * Developer    : Arshia Gulati
 * Purpose      :  
 * 
 * This class contains unit tests for Facets DataLookUp Service Integration related classes
 *   
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/13/17  |  AG    | Initial Version 
 *           |        | 
 *=========================================================================================
 */
@isTest
public class FDL_FacetsDataLookUpServiceTest {
    @isTest static void test_setEnvVariables( ) {
        FDL_FacetsDataLookUpService.loadConfigurationFromEnvironmentVariables();
        System.assertEquals(false, FDL_FacetsDataLookUpService.isInitialized);
        setupEnvironmentData();
        FDL_FacetsDataLookUpService.loadConfigurationFromEnvironmentVariables();
        System.assertEquals(true, FDL_FacetsDataLookUpService.isInitialized);
    }
    @isTest static void test_getRelatedEntities( ) {
        setupEnvironmentData();
        FDL_FacetsDataLookUpServiceMock mock = new FDL_FacetsDataLookUpServiceMock();        
        mock.sStatusCode = 200;
        mock.sStatus = 'OK';        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);        
        Test.startTest();
        FDL_FacetsDataLookUpResponse response;        
        try {
        	FDL_FacetsDataLookUpRequest request = new FDL_FacetsDataLookUpRequest();
        	request.groupID = '01VF';
        	response = FDL_FacetsDataLookUpService.getRelatedEntities( request);
        } catch( Exception e) {
            System.assert( False , 'Failed to get response. Exception = ' + e.getMessage());
        }
        Test.stopTest();
        System.assertEquals( 'SUCCESS', response.status);
        System.assertEquals( 'S002', response.statusCode);   
        System.assert( true, response.relatedEntity.size()>0); 
    }
	@isTest static void test_getRelatedEntitiesFailure( ) {       
        setupEnvironmentData();
        FDL_FacetsDataLookUpServiceMock mock = new FDL_FacetsDataLookUpServiceMock();        
        mock.sStatusCode = 500;
        mock.sStatus = 'Internal Server Error';        
        Test.setMock(HttpCalloutMock.class, mock);        
        Test.startTest();
        FDL_FacetsDataLookUpResponse response;        
        try {
        	FDL_FacetsDataLookUpRequest request = new FDL_FacetsDataLookUpRequest();
        	request.groupID = '$%^&';
        	response = FDL_FacetsDataLookUpService.getRelatedEntities( request);
        } catch( Exception e) {
            System.assert( False , 'Failed to get response. Exception = ' + e.getMessage());
        }
        Test.stopTest();
        System.Debug('response.status : ' + response.status);
        System.Debug('response.statusCode : ' + response.statusCode);
        System.assertEquals( 'FAILURE', response.status);
        System.assertEquals( 'SOAP-ENV:Server', response.statusCode);   
    }
    @isTest static void test_getRelatedEntitiesException() {
        setupEnvironmentData();
        FDL_FacetsDataLookUpServiceMock mock = new FDL_FacetsDataLookUpServiceMock();        
        mock.sStatusCode = 100;
        mock.sStatus = 'Internal Server Error';        
        Test.setMock(HttpCalloutMock.class, mock);        
        Test.startTest();
        FDL_FacetsDataLookUpResponse response;        
        try {
        	FDL_FacetsDataLookUpRequest request = new FDL_FacetsDataLookUpRequest();
        	request.groupID = '$%^&';
        	response = FDL_FacetsDataLookUpService.getRelatedEntities( request);
        } catch( Exception e) {
            System.assert( False , 'Failed to get response. Exception = ' + e.getMessage());
        }
        Test.stopTest();
        System.Debug('response.status : ' + response.status);
        System.Debug('response.statusCode : ' + response.statusCode);
        System.assertEquals( 'ERROR', response.status);
        System.assertEquals( 'REMOTE_ERROR', response.statusCode);  
    }
    public static void setupEnvironmentData() {
    	List<EnvironmentVariable__c> envVars = new List<EnvironmentVariable__c>();
    	EnvironmentVariable__c ev;   
        ev = new EnvironmentVariable__c(  Variable_Name__c = 'FDL_RE_SFDC_Support_Email', Value__c = 'arshia.gulati@carefirst.com', Module__c = 'Related Entity');
    	envVars.add(ev);
        ev = new EnvironmentVariable__c(  Variable_Name__c = 'FDL_RE_Support_Email', Value__c = 'arshia.gulati@carefirst.com', Module__c = 'Related Entity');
    	envVars.add(ev);
        ev = new EnvironmentVariable__c(  Variable_Name__c = 'FDL_RE_EndPoint', Value__c = 'https://sitapi.gateway.carefirst.com/sitb/facets/datalookup/v1/', Module__c = 'Related Entity');
    	envVars.add(ev);      
        ev = new EnvironmentVariable__c(  Variable_Name__c = 'FDL_RE_RequestTimeout', Value__c = '12000', Module__c = 'Related Entity');
    	envVars.add(ev);      
    	insert envVars;     
    }    
}