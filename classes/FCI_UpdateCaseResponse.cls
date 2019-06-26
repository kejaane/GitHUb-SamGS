/*=========================================================================================
 * Date		: 10/01/2015
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
 * 10/01/15  |  KG	  |	Initial Version                                         
 *           |  	  |	
 *===========+============+================================================================
 */
 
public with sharing class FCI_UpdateCaseResponse extends FCI_Message {

	public String status { get; set;}	// SUCCESS or ERROR
	public String statusCode { get; set;}
	public String statusDescription { get; set;}
 
	public String facetsCaseId { get; set; }
 
 
 	public  FCI_UpdateCaseResponse( FCI_UpdateCaseRequest request ) {
 	  super();
 	  msgType = IntegrationMessage.RESPONSE;
 	  transactionID = request.transactionID;
	 }
 	
 }