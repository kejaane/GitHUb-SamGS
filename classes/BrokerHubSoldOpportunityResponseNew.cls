/*=========================================================================================
 * Date    : 9/26/2016
 * Developer  : Ahilesh Radhakrishnan
 * Purpose     : This class holds the data field values received from Broker Hub web service invocation.
 *               No further action is required after receiving response  
 *               
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 
 *===========+============+================================================================
 */
 
public with sharing class BrokerHubSoldOpportunityResponseNew extends EGPMessage {

    public String status { get; set;}  // SUCCESS or ERROR
    public String statusCode { get; set;}
    public String statusDescription { get; set;}
    
    public  BrokerHubSoldOpportunityResponseNew ( BrokerHubSoldOpportunityRequestNew request ) {
        super();
        msgType = IntegrationMessage.RESPONSE;
        transactionID = request.transactionID;
    }
}