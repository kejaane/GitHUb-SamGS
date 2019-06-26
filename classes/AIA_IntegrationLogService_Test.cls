/*=========================================================================================
 * Date     : 08/08/2016
 * Developer    : Sandeep S
 * Purpose      : This is test class for validating functionality of persisting log for
 *                PCS-SFDC communication i..e AIA_IntegrationLogService .
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
@isTest
public class AIA_IntegrationLogService_Test {

     @isTest static void testCalloutWithMultipleStaticResources() {
         
         AIA_IntegrationLogService service = new AIA_IntegrationLogService();
         StaticResource sr = [select id,body from StaticResource Where Name = 'BenefitSummaryJSON'];
         String jsonStr=sr.body.toString();
         //String jsonStr=AIA_PCSIntegrationHandler.callPCS();
         System.debug('Return JOSN is-->'+jsonStr);
         service.saveLog('12342342342332',jsonStr, AIA_IntegrationLogService.BENEFIT_DESIGN_LOGTYPE_RESP,AIA_IntegrationLogService.PCS_ORG, AIA_IntegrationLogService.SDFC_ORG);
         Test.startTest();
         List<IntegrationLog__c> ilog=[select id from IntegrationLog__c where name like 'BDresp%' order by createdDate limit 1];
         Attachment att=null;
         if(ilog.size()>0){
             att=[select id,body from Attachment where parentId=:ilog.get(0).Id];
         }
        System.assert(att!=null,'Attachment not saved successfully'); 
         Test.stopTest();
     }
    
}