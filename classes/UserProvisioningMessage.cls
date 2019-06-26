public virtual class UserProvisioningMessage extends IntegrationMessage {

 public boolean isValid = true;	// default

 public UserProvisioningMessage() {
 	super();
 	this.isValid = true;	// default
 	this.source = 'CIAM';
 	this.target = 'SFDC';
 	this.targetAddress = URL.getSalesforceBaseUrl().toExternalForm();
 	this.sourceAddress = 'CIAM';
 }
 
  public boolean isValid() {
 	return isValid;
 }
 
 public void setIsValid(boolean isValid) { 
 	this.isValid = isValid; 
 	result = isValid? IntegrationMessage.STATUS_SUCCESS : IntegrationMessage.STATUS_ERROR;
 	}

}