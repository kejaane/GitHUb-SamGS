public virtual class EGPMessage extends IntegrationMessage {

 public boolean isValid = true;	// default

 public EGPMessage() {
 	super();
 	this.isValid = true;	// default
 	this.source = 'SFDC';
 	this.target = 'EGP';
 	this.sourceAddress = URL.getSalesforceBaseUrl().toExternalForm();
 	this.targetAddress = EGPService.egpEndPointURL;
 }
 
  public boolean isValid() {
 	return isValid;
 }
 
 public void setIsValid(boolean isValid) { 
 	this.isValid = isValid; 
 	result = isValid? IntegrationMessage.STATUS_SUCCESS : IntegrationMessage.STATUS_ERROR;
 	}

 
}