/*=========================================================================================
 * Date     : 08/08/2016
 * Developer    : Sandeep S
 * Purpose      : This is test class which mocks PCS web service and test JSON response
 * 				  from PCS.
 *                
 *               
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 08/08/2016|  Sandeep    | Initial Version                                         
 *           |        | 
 *===========+============+================================================================
 */
@isTest(seeALLdata=false)
public class AIA_PCS_BenefitSummary_Test {

    @isTest static void testCalloutWithPCSForBenefitSummary() {
       
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(
            'http://api.salesforce.com/getBenefitSummaryJSON', 'BenefitSummaryJSON');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, multimock);
        
        // Call the method for  endpoint
        HTTPResponse res = getInfoFromExternalService('http://api.salesforce.com/getBenefitSummaryJSON');
      
        String jsonStr=res.getBody();
        
        AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
        System.debug('----->'+apbroot);
        System.assert(apbroot!=null, 'JSON Parsing Exception ,AIA_PCS_BenefitSummary is null');
        System.assert(apbroot.planId=='PLAN-001', 'AIA_PCS_BenefitSummary Values are not populated');
    }
    
    @isTest static void testCalloutWithPCSForBenefitSummaryBRF() {
       AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
		aiapln.Plan_Name__c='Test Plan';
		aiapln.Plan_Id__c='PLAN-Test';
		aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
		aiapln.Jurisdiction__c = 'MD';
		aiapln.Has_Benefit_Summary__c=true;
		insert aiapln;
        
       StaticResource sr = [select id,body from StaticResource Where Name = 'BenSumJSONBRF_Test'];
		String jsonStr=sr.body.toString();
		AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
		AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
		mapper.saveToSetUp(apbroot,'BRF');
    }
     @isTest static void testCalloutWithPCSForBenefitSummaryBRFDrug() {
       AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Drug','Test');
		aiapln.Plan_Name__c='Test Plan';
		aiapln.Plan_Id__c='PLAN-TEST-RX';
		aiapln.Product_Last_Updated_String_Format__c='2016-10-18  08:17:23 PM';
		aiapln.Jurisdiction__c = 'MD';
		aiapln.Has_Benefit_Summary__c=true;
		insert aiapln;
        
       StaticResource sr = [select id,body from StaticResource Where Name = 'BenSumJSONBRF_Test_RX'];
		String jsonStr=sr.body.toString();
		AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
		AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
		mapper.saveToSetUp(apbroot,'BRF');
    }
    
    public static HttpResponse getInfoFromExternalService(String endpoint) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        return res;
    }
        
}