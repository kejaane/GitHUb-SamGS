/*=========================================================================================
 * Date		: 11/6/17
 * Developer	: Arshia Gulati
 * Purpose   	:  
 * 
 *               This is a base class for message objects of the Facets DataLookUp Service integration and
 * 				 it extends the IntegrationMessage class in order to allow message objects of the Facets 
 * 				 DataLookUp Service integration package to use the common logging framework.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/6/17   |  AG    |	Initial Version                                         
 *   	     |        | 
 *=========================================================================================
 */

public virtual class FDL_Message extends IntegrationMessage {

 public boolean isValid = true;	// default

 public FDL_Message() {
 	super();
 	this.isValid = true;	// default
 	this.source = 'SFDC';
 	this.target = 'FDL';
 	this.sourceAddress = URL.getSalesforceBaseUrl().toExternalForm();
 	this.targetAddress = FDL_FacetsDataLookUpService.EndPointURL;     
 }
  
 public void setIsValid(boolean isValid) { 
 	this.isValid = isValid; 
 	result = isValid? IntegrationMessage.STATUS_SUCCESS : IntegrationMessage.STATUS_ERROR;
 	}

}