/*=========================================================================================
 * Date		: 11/6/15
 * Developer	: Ken Gill
 * Purpose   	:  
 * 
 *               This is a base class for message objects of the Facets integration like 
 *               FCI_CreateCaseRequest, FCI_UpdateCaseRequest and it extends the IntegrationMessage 
 *               class in order allow message objects of the Facets integration package to use 
 *               the common logging framework.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/6/15   |  KG    |	Initial Version                                         
 *   	     |        | 
 *=========================================================================================
 */

public virtual class FCI_Message extends IntegrationMessage {

 public boolean isValid = true;	// default

 public FCI_Message() {
 	super();
 	this.isValid = true;	// default
 	this.source = 'SFDC';
 	this.target = 'FCI';
 	this.sourceAddress = URL.getSalesforceBaseUrl().toExternalForm();
 	this.targetAddress = FCI_FacetsService.fciEndPointURL;
 }
 
  public boolean isValid() {
 	return isValid;
 }
 
 public void setIsValid(boolean isValid) { 
 	this.isValid = isValid; 
 	result = isValid? IntegrationMessage.STATUS_SUCCESS : IntegrationMessage.STATUS_ERROR;
 	}

}