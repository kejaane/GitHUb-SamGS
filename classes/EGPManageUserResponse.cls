/*=========================================================================================
 * Date		: 10/21/2014
 * Developer	: Ken Gill
 * Purpose   	: This class holds the data field values received from the EGP web service invocation.
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
 
public with sharing class EGPManageUserResponse extends EGPMessage {

	public String status { get; set;}	// SUCESS or ERROR
	public String statusCode { get; set;}
	public String statusDescription { get; set;}
 
 
 	public  EGPManageUserResponse( EGPManageUserRequest request ) {
 	  super();
 	  msgType = IntegrationMessage.RESPONSE;
 	  transactionID = request.transactionID;
	 }
 	
 }