/*=================================================================================================
* Date     : 08/08/2016
* Developer    : Sandeep S
* Purpose      : This is service class for persisting PCS-SFDC request/response communication
*                in Integration Log.             
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 08/08/2016| Sandeep    |     | Initial Version                                         
* 01/31/2017| Asif K     | T01 | Updated final constants BENEFIT_SUMMARY_LOGTYPE and
* 						         BENEFIT_DESIGN_LOGTYPE to better track brf and bd response json
* 04/30/2017| Asif K     | T02 | Updated final constants starting with name as Benefit to log
*                                both request and response for BRF and BD records. 
* 04/30/2017| Asif K     | T03 | Added changes to capture timestamp in milliseconds 
* 06/15/2017|Debkanti	 | T04 | For name change to log
*===========+============+=====+===================================================================
*/
public class AIA_IntegrationLogService {
    //T02-Start
    public static final String BENEFIT_SUMMARY_LOGTYPE_REQ='BRFreqJson';
    public static final String BENEFIT_DESIGN_LOGTYPE_REQ='BDreqJson'; //T01
    public static final String BENEFIT_SUMMARY_LOGTYPE_RESP='BRFrespJson';
    public static final String BENEFIT_DESIGN_LOGTYPE_RESP='BDrespJson'; //T01
    //T02-End
    //T04-Start
    public static final String PCS_ORG='PCS_ORG';
    public static final String SDFC_ORG='SFDC_ORG';
    public static final String BENEFIT_DESIGN_LOGTYPE_OP4RESP='BDrespJson_OP4';
    public static final String BENEFIT_DESIGN_LOGTYPE_OP4REQ='BDreqJson_OP4';
    //T04-End
 
    
    /**
    * To save PCS-SFDC communication log into IntegrationLog__c object.
    * @param String : related data.
    * @param String : JSON string.
    * @param String :logtype(BFSUMMARY,BFDESIGN).
    * @param String: targetOrg(PCS_ORG,SFDC_ORG)
    * @param String: sourceOrg(PCS_ORG,SFDC_ORG)
    **/
    public void saveLog(String passedId,String jsonStr,String logType,String targetOrg,String sourceOrg){
        try{
            Blob jsonBlob=Blob.valueOf(jsonStr);
            String logName=logType+'_'+'AIA-PCS-Integration';
            String ts_millisec = String.valueOf(System.now())+'.'+System.now().millisecond();//T03
            IntegrationLog__c itgLog= new IntegrationLog__c(relatedData__c=passedId,msgType__c=logType,name=logName,
                                                            source__c=sourceOrg,target__c=targetOrg,timeStamp__c=System.now(),
                                                            transactionID__c=1.0,Time_Stamp_milli_seconds__c = ts_millisec);//T03
            insert itgLog;
            System.debug('Integration log id--->'+itgLog.Id);
            Attachment att= new Attachment(body=jsonBlob,parentId=itgLog.Id,Name=logName,ContentType = 'text/plain');
            insert att;
            System.debug('attachment id--->'+att.Id);
        }
        catch(Exception e){
            System.debug('Exception is---->'+e.getMessage());
            System.debug('Error while creating integration log for PCS-SFDC communication');
            System.debug('Passed id is :-'+passedId);
            System.debug('Error while persisting json:-'+jsonStr);            
        }
    }    
}