/*=========================================================================================
 * Date         : 11/16/17
 * Developer    : Arshia Gulati
 * Purpose      :  
 * 
 * This class contains unit tests for Related Entities Controller classe
 *   
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/16/17  |  AG    | Initial Version 
 *           |        | 
 *=========================================================================================
 */@isTest
public class RelatedEntitiesControllerTest {
    public static  testMethod void test_getRelatedEntities_NullInput(){
        Related_Entity__c objRelEnt = new Related_Entity__c();
        RelatedEntitiesController relEnt = new RelatedEntitiesController(new ApexPages.StandardController(objRelEnt));
        relEnt.getRelatedEntities();
        System.assertEquals(0,relEnt.lstRelEnt.size()); 
        System.assertEquals('Please enter a Group ID.',ApexPages.getMessages()[0].getDetail()); 
    }
    public static  testMethod void test_getRelatedEntities_InvalidInput(){
        Related_Entity__c objRelEnt = new Related_Entity__c();        
        objRelEnt.Group_ID__c = '01V';
        RelatedEntitiesController relEnt = new RelatedEntitiesController(new ApexPages.StandardController(objRelEnt));
        relEnt.getRelatedEntities();
        System.assertEquals(0,relEnt.lstRelEnt.size()); 
        System.assertEquals('Group Id entered is not valid.',ApexPages.getMessages()[0].getDetail()); 
    }
    public static  testMethod void test_getRelatedEntities_Success(){
        Related_Entity__c objRelEnt = new Related_Entity__c();        
        objRelEnt.Group_ID__c = '01VF';
        setupEnvironmentData();
        FDL_FacetsDataLookUpServiceMock mock = new FDL_FacetsDataLookUpServiceMock();        
        mock.sStatusCode = 200;
        mock.sStatus = 'OK';        
        Test.setMock(HttpCalloutMock.class, mock);        
        Test.startTest();
        FDL_FacetsDataLookUpResponse response;        
        try {
        RelatedEntitiesController relEnt = new RelatedEntitiesController(new ApexPages.StandardController(objRelEnt));
        
        relEnt.getRelatedEntities();
        System.assert(relEnt.lstRelEnt.size()>0); 
        System.assert(relEnt.showREList); 
        
        relEnt.selectedEntityId = '220822546-SB';            
        relEnt.ShowREDetails();
        System.assert(relEnt.showREDet);           
            
        Pagereference pg = relEnt.CustomCancel();                 
        System.assert(pg.getRedirect()); 
        System.assertEquals('/apex/RelatedEntityPage', pg.getUrl());             
            
        }catch( Exception e) {
            System.assert( False , 'Failed to get response. Exception = ' + e.getMessage());
        }        
    }
    public static  testMethod void test_getRelatedEntities_FailureResponse(){
        Related_Entity__c objRelEnt = new Related_Entity__c();        
        objRelEnt.Group_ID__c = '01VF';
        setupEnvironmentData();
        FDL_FacetsDataLookUpServiceMock mock = new FDL_FacetsDataLookUpServiceMock();        
        mock.sStatusCode = 500;
        mock.sStatus = 'OK';                
        Test.setMock(HttpCalloutMock.class, mock);        
        Test.startTest();
        FDL_FacetsDataLookUpResponse response;        
        try {
        RelatedEntitiesController relEnt = new RelatedEntitiesController(new ApexPages.StandardController(objRelEnt));
        relEnt.getRelatedEntities();
        System.assertEquals(0,relEnt.lstRelEnt.size());             
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        System.assertEquals('Error response received from Facets Service. Support team has been notified.',ApexPages.getMessages()[0].getDetail()); 
        }catch( Exception e) {
            System.assert( False , 'Failed to get response. Exception = ' + e.getMessage());
        }
    }
    public static  testMethod void test_getRelatedEntities_InvalidResponse(){
        Related_Entity__c objRelEnt = new Related_Entity__c();        
        objRelEnt.Group_ID__c = '0111';
        setupEnvironmentData();
        FDL_FacetsDataLookUpServiceMock mock = new FDL_FacetsDataLookUpServiceMock();        
        mock.sStatusCode = 200;
        mock.sStatus = 'INVALID';                
        Test.setMock(HttpCalloutMock.class, mock);        
        Test.startTest();
        FDL_FacetsDataLookUpResponse response;        
        try {
        RelatedEntitiesController relEnt = new RelatedEntitiesController(new ApexPages.StandardController(objRelEnt));
        relEnt.getRelatedEntities();
        System.assertEquals(0,relEnt.lstRelEnt.size());             
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
        System.assertEquals('Group ID entered does not exist in Facets system.',ApexPages.getMessages()[0].getDetail()); 
        }catch( Exception e) {
            System.assert( False , 'Failed to get response. Exception = ' + e.getMessage());
        }
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