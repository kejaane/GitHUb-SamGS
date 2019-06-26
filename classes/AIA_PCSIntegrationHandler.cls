/*=========================================================================================================
* Date         : 08/08/2016
* Developer    : Sree Harsha           
* Purpose      : This class is used to make a callout to PCS from Salesforce using REST API
*==========================================================================================================
*                                 Update History
*                                 ---------------
* Date      + Developer      +  Tag  + Description
*===========+================+=======+=====================================================================
* 08/08/2016| Sree Harsha    |       | Initial Version                                         
* 01/05/2017| Asif Kutagulla |       | Removed commented code. Removed dependency on Authorization token
*                                      since it is not being used.
* 01/05/2017| Asif Kutagulla |       | Add method argument relatedRecordID in callPCS method. Passed
*                                      relatedRecordID in method call service.saveLog.
* 04/01/2017| Sree Harsha    |  T01  | Updated method to send BRF Effective Date to PCS when call is made.   
* 04/30/2017| Asif Kutagulla |  T02  | Add changes for logging request when making call to PCS.
* 06/28/2017| Debkanti		 |	T03	 | Add new method callPCS for OP4 batch job Http call to PCS.
*===========+================+=======+=====================================================================
*/

global class AIA_PCSIntegrationHandler{    
    /**
* @Author : Sree Harsha
* @param  : This method is used to make a callout to PCS from Salesforce using REST API
* @param  : None
* @Output : This method gets the Benefit summary info from PCS through REST callout
* @return : None
*/  
    public static AIA_PCS_BenefitSummary callPCS(string planId,string requestType,string relatedRecordID,string EFFDate){ //T01
        AIA_PCS_BenefitSummary apb=null;
        System.debug('@@planId initial'+planId);
        try{            
            String logType_Req;
            String logType_Resp;
            Map<string,string> reqBody = new Map<string,string>();
            reqBody.put('PlanId', planId);
            System.debug('@@planId'+planId);
            if(String.isNotBlank(requestType) && requestType=='BDD'){
                reqBody.put('RequestType','BDF'); 
                logType_Req = AIA_IntegrationLogService.BENEFIT_DESIGN_LOGTYPE_REQ;
                logType_Resp = AIA_IntegrationLogService.BENEFIT_DESIGN_LOGTYPE_RESP;
            }else{
                reqBody.put('RequestType', requestType);
                logType_Req = AIA_IntegrationLogService.BENEFIT_SUMMARY_LOGTYPE_REQ;
                logType_Resp = AIA_IntegrationLogService.BENEFIT_SUMMARY_LOGTYPE_RESP;
            }        
            reqBody.put('EffDate', EFFDate);    
            
            string jsonReqBody = JSON.serialize(reqBody);
            system.debug('@@ jsonReqBody'+jsonReqBody);
            AIA_IntegrationLogService service = new AIA_IntegrationLogService();
            // Instantiate a new http object
            Http h = new Http();
            
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            //Retrieve the Endpoint from custom setting
            String EndPoint=API_ENDPOINT_URLS__c.getValues('PCS_APIDetails').ENDPOINT_URL__c;            
            req.setEndpoint(EndPoint); //ENDPOINT URL 
            //req.setEndpoint('http://icanhazip.com/'); //for testing purposes and to track the ip from which sfdc generates the rest call
            req.setMethod('POST'); //TYPE OF METHOD
            req.setBody(jsonReqBody);            
            req.setClientCertificateName(label.Saleforce_Certificate);
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setTimeout(120000);
            system.debug('@@ request ENDPOINT=='+req.getEndpoint());
            system.debug('@@ request body=='+req.getBody());
            system.debug('@@ full request=='+req);            
            // Send the request, and return a response
            HttpResponse res = h.send(req);       
            system.debug('@@ response'+res);
            system.debug('@@ response body'+res.getBody());
            service.saveLog(relatedRecordID,req.getBody(), logType_Req,AIA_IntegrationLogService.PCS_ORG, AIA_IntegrationLogService.SDFC_ORG);//logging request in saleforce - T02
            if(!String.isBlank(res.getBody())){
                apb=AIA_PCS_BenefitSummary.parse(res.getBody());
                service.saveLog(relatedRecordID,res.getBody(), logType_Resp,AIA_IntegrationLogService.PCS_ORG, AIA_IntegrationLogService.SDFC_ORG);//logging response in saleforce - T02
                List<AIA_Plan__c> planList=[select id, Plan_Id__c from AIA_Plan__c where Plan_Id__c=:apb.PlanID];
                if(planList.size()>0){
                    AIA_PlanTemplateMapper planMapper=new AIA_PlanTemplateMapper();
                    planMapper.saveToSetUp(apb,requestType);
                }                
            }
        }
        catch(exception e){
            system.debug('@@ in exception'+e.getMessage() +'--line number-->'+e.getLineNumber()+'---->'+e.getCause());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,PlanID +' Not Available in PCS');
            ApexPages.addMessage(myMsg);
            //ApexPages.addMessages(e);
            return null;
        }
        return apb;
    }
    
    /****************************T03 Start******************************/
    /**
* @Author : Debkanti
* @param  : This method is used to make a callout to PCS from Salesforce using REST API
* @param  : None
* @Output : This method gets the bendfit design product summary info from PCS through REST callout
* @return : It will return the error response getting from pcs and send it back to AIA_OP4synchCustomizedPlansWithPCS_Batch
* 			
*/    
    public static String callPCS(string relatedRecordID){
        transient String resCode = null;
        transient String logType_Req;
        transient String logType_Resp;
        transient String msgDataValue = null;
        transient String bdpURL='';
        transient String msgvalue = null;
        transient String bodyValue = null;
        String access='';
        Map<String,String> errorMap = new Map<String,String>();
        try{
            //log name creation
            logType_Req = AIA_IntegrationLogService.BENEFIT_DESIGN_LOGTYPE_OP4REQ;
            logType_Resp = AIA_IntegrationLogService.BENEFIT_DESIGN_LOGTYPE_OP4RESP;
            //Creating instance of logservice and json generator
            AIA_IntegrationLogService service = new AIA_IntegrationLogService();
            AIA_OP4PCSJSONGenerator pcsOP4Json = new AIA_OP4PCSJSONGenerator();
            
            String op4JsonString = pcsOP4Json.getBDP(relatedRecordID);
            //String op4JsonString = batchC.pcsOP4Json.getBDP(relatedRecordID);
            system.debug('---From Batch Heap-->'+Limits.getHeapSize());
            // Instantiate a new http object
            Http h = new Http();
            
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            
            //Retrieve the Endpoint from custom setting
            String EndPoint=API_ENDPOINT_URLS__c.getValues('AIA OP4 PCS EndPoint URL').ENDPOINT_URL__c;            
            req.setEndpoint(EndPoint); //ENDPOINT URL 
            //req.setEndpoint('http://icanhazip.com/'); //for testing purposes and to track the ip from which sfdc generates the rest call
            req.setMethod('POST'); //TYPE OF METHOD
            req.setBody(op4JsonString);
            req.setClientCertificateName(label.Saleforce_Certificate);
            req.setHeader('Content-Type','application/json');
            req.setHeader('Accept','application/json');
            req.setTimeout(120000);
            system.debug('@@ request ENDPOINT=='+req.getEndpoint());
            system.debug('@@ request body=='+req.getBody());
            system.debug('@@ full request=='+req); 
            
            
            HttpResponse res = h.send(req);
            System.debug('JsonBody1'+res);
            System.debug('JsonBody2'+req);
            System.debug('JsonBody3'+res.getStatus());
            //Response body value
            bodyValue = string.valueOf(res.getBody());
            system.debug('---Heap Line 129-->'+Limits.getHeapSize());
            //Fatching error code from custom setting
            List<AIA_PCS_Op4_ErrorCodes__c> mcs = AIA_PCS_Op4_ErrorCodes__c.getall().values();
            System.debug('Mcs : '+mcs);
            
            for(AIA_PCS_Op4_ErrorCodes__c eC : mcs){
                errorMap.put(ec.Code__c, ec.Message__c);
                //system.debug('List of map: '+errorMap);
            }
            errorMap.get(res.getBody());
            system.debug('test1 : ' + errorMap.get(res.getBody()));
            msgvalue = errorMap.get(bodyValue);
            system.debug('test2 : ' +msgvalue);
            msgDataValue = relatedRecordID + bodyValue + msgvalue;
            system.debug('test3 : ' +msgDataValue);
            System.debug('JsonBody'+res.getBody());
            
            //Added for parseing the json responsecode return form PCS
            Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(bodyValue);
            if(!String.isBlank(res.getBody())){
                for (Object item : root.keySet()) {
                    if(String.valueOf(item)=='ResponseCode'){
                        System.debug(root.get(String.valueOf(item)));
                        access=String.valueOf(root.get(String.valueOf(item)));
                    }
                }
            }
            //logging the request
            service.saveLog(relatedRecordID,req.getBody(), logType_Req,AIA_IntegrationLogService.PCS_ORG, AIA_IntegrationLogService.SDFC_ORG);
            //logging the response 
            if(!String.isBlank(res.getBody())){
                system.debug('test4 : '+resCode);
                service.saveLog(relatedRecordID,res.getBody(), logType_Resp,AIA_IntegrationLogService.PCS_ORG, AIA_IntegrationLogService.SDFC_ORG);
            }
        }
        catch(exception e){
            system.debug('@@ in exception'+e.getMessage() +'--line number-->'+e.getLineNumber()+'---->'+e.getCause());
            
        }
        //returning the error response code
        return access;
        //return resCode;
    }
    /****************************T03 End******************************/
    
}