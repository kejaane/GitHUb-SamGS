public with sharing class UserProvisioningRequest extends UserProvisioningMessage {

     // used for IntegrationLog logging related records used to build request data
    public Map<String,String> relatedRecords { get; set; }  


   public Map<String,String> webserviceRequest {get;set; }  // related webservice call inputs

    // no-arg constructor. Useful for unit testing to allow setting field values without requiring a UProv Request object
    // calling code sets each field individually
    public UserProvisioningRequest() {
     super();
     this.msgType = IntegrationMessage.REQUEST;
     this.isValid = true;   // by default
    }
    
    public UserProvisioningRequest( Map<String,String> inRequest) {
     super();
     this.msgType = IntegrationMessage.REQUEST;
     if( inRequest == null || inRequest.isEmpty()) {
        this.isValid = false;
        System.debug('Received null/empty UserProvisioning request attributes in UserProvisioningRequest(Map<String,String> inRequest) constructor');
        return;
     }
     webserviceRequest = inRequest; 
     msgData = JSON.serializePretty(webserviceRequest);
     result = IntegrationMessage.STATUS_SUCCESS; 
     this.isValid = true;   // by default
    }


 }