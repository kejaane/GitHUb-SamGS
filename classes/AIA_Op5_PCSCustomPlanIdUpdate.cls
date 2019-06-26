/*=========================================================================================
* Date         : 05/13/2017
* Developer    : RaviTeja
* Purpose      : This REST webservice class exposes method to update PCS Custom Plan ID
*                value in Benefit Design Product object
*=========================================================================================
*                                 Update History
*                                 ---------------
* Date       | Developer   | Tag |   Description
*-----------------------------------------------------------------------------------------
* 05/13/2017 | RaviTeja    |     | Initial build
* 08/11/2017 | Asif K      | T01 | Updated URL mapping,class name. Added class description
*=========================================================================================
*/

@RestResource(urlMapping='/AIA_BenefitDesignProduct/UpdatePCSplanID')
global with sharing class AIA_Op5_PCSCustomPlanIdUpdate {
    
    /** POST method to update the PCS Custom Plan Id onto the BDP record sent by PCS system **/
    @HttpPost
    global static void doPost()
    {        
        //Start - variables for framing webservice response
        final string SUCCESS_RESP_CODE = '1111';
        final string SUCCESS_RESP_DESC = 'Successfully updated custom Plan Id';
        
        final string ERR_RESP_CODE_DML_EXCEP = '0001';
        final string ERR_RESP_DESC_DML_EXCEP = 'Update Failed. Please contact Salesforce Admin.';
        final string ERR_RESP_CODE_GEN_EXCEP = '0002';
        final string ERR_RESP_DESC_GEN_EXCEP = 'Exception occurred. Please contact Salesforce Admin.';
        final string ERR_RESP_CODE_REQFORMAT_EXCEP = '0003';
        final string ERR_RESP_DESC_REQFORMAT_EXCEP = 'Request is not in proper format. Please check.';
        
        final string TAG_NAME_RESP_CODE = 'RespCode';
        final string TAG_NAME_RESP_DESC = 'RespDescription';
        //End - variables for framing webservice response
     
        RestResponse res = RestContext.response;  
        RestContext.response.addHeader('Content-Type', 'application/json');
        Map<String, Object> mapJson;
        String sfdcid='';
        String PCSPlanId='';
        list<Database.SaveResult> srList;
        map<string,string> respBody;
        
        try{
            //get request sent by external system
            String jsonReqString = RestContext.request.requestBody.toString(); 
            
            //deserialize request json
            mapJson = (map<String,Object>)JSON.deserializeUntyped(jsonReqString);
            system.debug('--mapJson--'+mapJson);
            
            //extract sfdc id and pcs plan id
            sfdcid = (mapJson.containsKey('SFDCId'))?String.valueOf(mapJson.get('SFDCId')):'';
            PCSPlanId = (mapJson.containsKey('PCSPlanId'))?String.valueOf(mapJson.get('PCSPlanId')):'';
            
            if(!String.isBlank(sfdcid) && !String.isBlank(PCSPlanId)){
                //get the bdp record using the id sent in the request
                list<AIA_Benefit_Design_Product__c> bdpToUpdate = [SELECT id,PCS_Custom_Plan_Id__c 
                                                                   FROM AIA_Benefit_Design_Product__c 
                                                                   WHERE id = :sfdcid];
                //update bdp record with pcs plan id
                if(!bdpToUpdate.isEmpty()){
                    bdpToUpdate[0].PCS_Custom_Plan_Id__c = PCSPlanId;
                    srList = Database.update(bdpToUpdate,False);
                }
                
                //Frame response to be sent back to calling system when there is a DML success & error
                respBody = new map<string,string>();
                if(srList[0].isSuccess()){
                    respBody.put(TAG_NAME_RESP_CODE, SUCCESS_RESP_CODE);
                    respBody.put(TAG_NAME_RESP_DESC, SUCCESS_RESP_DESC);
                }
                else {
                    respBody.put(TAG_NAME_RESP_CODE, ERR_RESP_CODE_DML_EXCEP);
                    respBody.put(TAG_NAME_RESP_DESC, ERR_RESP_DESC_DML_EXCEP);
                }
                if(!respBody.keySet().isEmpty()) {
                    res.responseBody = Blob.valueOf(JSON.serialize(respBody));
                }
            } 
            else {
                //Frame response to be sent back to calling system when there is a request format error 
                respBody = new map<string,string>();
                respBody.put(TAG_NAME_RESP_CODE, ERR_RESP_CODE_REQFORMAT_EXCEP);
                respBody.put(TAG_NAME_RESP_DESC, ERR_RESP_DESC_REQFORMAT_EXCEP);
                if(!respBody.keySet().isEmpty()) {
                    res.responseBody = Blob.valueOf(JSON.serialize(respBody));
                }
            }
            
        }
        catch(Exception e){
            AIA_Utils auobj = new AIA_Utils(); auobj.logException(e);
            //Frame error response to be sent back to calling system when exception has occurred
            respBody = new map<string,string>();
            respBody.put(TAG_NAME_RESP_CODE, ERR_RESP_CODE_GEN_EXCEP);
            respBody.put(TAG_NAME_RESP_DESC, ERR_RESP_DESC_GEN_EXCEP);
            if(!respBody.keySet().isEmpty()) {
                res.responseBody = Blob.valueOf(JSON.serialize(respBody));
            }
        }
    }
}