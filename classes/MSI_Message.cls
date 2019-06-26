/*=========================================================================================
 * Date		: 11/6/15
 * Developer	: Ken Gill
 * Purpose   	:  
 * 
 *               This is a base class for message objects of the Member Service integration like 
 *               MSI_MemberSummaryRequest, MSI_MemberSummaryResponse and it extends the IntegrationMessage 
 *               class in order allow message objects of the Member Service integration package to use 
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

public virtual class MSI_Message extends IntegrationMessage {

 public boolean isValid = true;	// default

 public MSI_Message() {
 	super();
 	this.isValid = true;	// default
 	this.source = 'SFDC';
 	this.target = 'MSI';
 	this.sourceAddress = URL.getSalesforceBaseUrl().toExternalForm();
 	//this.targetAddress = MSI_MemberService.msiEndPointURL;
 }
 
  public boolean isValid() {
 	return isValid;
 }
 
 public void setIsValid(boolean isValid) { 
 	this.isValid = isValid; 
 	result = isValid? IntegrationMessage.STATUS_SUCCESS : IntegrationMessage.STATUS_ERROR;
 	}

}