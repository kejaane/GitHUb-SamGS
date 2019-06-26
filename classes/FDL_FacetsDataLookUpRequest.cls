/*=========================================================================================
 * Date         : 11/3/17
 * Developer    : Arshia Gulati
 * Purpose      : This class holds the field values required to invoke Facets DataLookUp Service 
 * 				  to retrieve related entities for a group.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/03/17  |  AG    | Initial Version developed for User story B-03752                                         
 *=========================================================================================
 */
public with sharing class FDL_FacetsDataLookUpRequest extends FDL_Message {
	
 	 public String groupID {get; set;}
	 	 
     public FDL_FacetsDataLookUpRequest() {
	     super();
	     this.msgType = IntegrationMessage.REQUEST;
	     this.isValid = true;   // by default
    }
		
}