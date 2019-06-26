public with sharing class UserProvisioningResponse extends UserProvisioningMessage {

	public String status { get; set;}	// SUCESS or ERROR
	public String statusCode { get; set;}
	public String statusDescription { get; set;}
 
	public  UserProvisioningService.Response serviceResponse;
	public  UserProvisioningService.Configuration configuration;
 
 
 	public  UserProvisioningResponse( UserProvisioningRequest request ) {
 	  super();
 	  msgType = IntegrationMessage.RESPONSE;
 	  transactionID = request.transactionID;
	 }
	 
	public UserProvisioningResponse( UserProvisioningRequest request, UserProvisioningService.Response response, 
									 UserProvisioningService.Configuration configuration) {
		this( request );
		setServiceResponse( response );
	}
	 
	 public void setServiceResponse( UserProvisioningService.Response response) {
	 	this.serviceResponse = response;
	 	msgData = msgData == null ? '' : msgData;
	 	msgData += ' Response= ' + JSON.serializePretty( serviceResponse );
	 }
	 
	 public void setServiceConfiguration( UserProvisioningService.Configuration configuration) {
	 	this.configuration = configuration;
	 	msgData = msgData == null ? '' : msgData;
	 	msgData += 'Service Configuration= ' + JSON.serializePretty( configuration );
	 }
	 
 	
 }