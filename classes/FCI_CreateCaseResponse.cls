/*=========================================================================================
 * Date		: 10/21/2014
 * Developer	: Ken Gill
 * Purpose   	: This class holds the data field values received from the Create/Update Facets web service invocation.
 *                It implements the necessary interface and fields to allow participation in the Integration
 *                logging and transaction frameworks.
 *                
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/21/14  |  KG	  |	Initial Version                                         
 *           |  	  |	
 *===========+============+================================================================
 */
 
public with sharing class FCI_CreateCaseResponse extends FCI_Message {

	public String status { get; set;}	// SUCESS or ERROR
	public String statusCode { get; set;}
	public String statusDescription { get; set;}
 
	public String itemTicketNo {get;set; }
	public String itemStatus { get; set; }
	public String facetsCaseId { get; set; }
 
 
 	public  FCI_CreateCaseResponse( FCI_CreateCaseRequest request ) {
 	  super();
 	  msgType = IntegrationMessage.RESPONSE;
 	  transactionID = request.transactionID;
	 }
 	
 }