public with sharing class MSI_FacetsGroup2Response extends MSI_Message {

 	public String status { get; set;}	// SUCESS or ERROR
	public String statusCode { get; set;}
	public String statusDescription { get; set;}
	
	public String terminationDate {get; set;}
	public Boolean isTerminated {get; set;}	
	

	public MSI_FacetsGroup2Response( MSI_FacetsGroup2Request request) {
 	  super();
 	  msgType = IntegrationMessage.RESPONSE;
 	  transactionID = request.transactionID;
 	}

 
}