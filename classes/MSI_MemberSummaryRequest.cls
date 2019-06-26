/*=========================================================================================
 * Date     : 11/6/15
 * Developer    : Ken Gill
 * Purpose      :  
 * 
 * The MSI_MemberSummaryRequest is a data object that includes all the field needed by 
 * the MSI_MemberService to retrieve subscriber/member details for a specified subscriber Id.
 * It also specifies which of multiple response segments are requested. This is an important parameter
 * as the response data can be large and specifying the segments needed allows optimizing data volumes and
 * needed processing on both provider service (Facets member service) and client side (Salesforce). 
 * 
 * It extends FCI_Message which extends IntegrationMessage so it can be logged by the 
 * Integration log framework.  
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/6/15   |  KG    | Initial Version                                         
 *  9/9/16   |  KG    | remove ADDL segment in response to service change communicted by Facets 
 * 2/8/17    |  KG    | Remove hardcoded asOfDate '03/14/2015' which was causing incorrect eligibility sets to be returned. (Blank defaults)
 *           |        | to today on the Member Summary service side which was the desired date i.e current eligibilites.
 *           |        | 
 *=========================================================================================
 */


public with sharing class MSI_MemberSummaryRequest extends MSI_Message {
	
	 public String subscriberID {get; set;}
	 public String memberSuffix {get; set;}
	 public String groupID {get; set;}
	 public String asOfDate {get; set;}
	 public String returnRecord {get; set;}
	 
	 
     public MSI_MemberSummaryRequest() {
	     super();
	     this.msgType = IntegrationMessage.REQUEST;
	     this.isValid = true;   // by default
	     setHardCodedFields();   
    }
	
	
	
	
	private void setHardCodedFields() {
		memberSuffix = '';
		asOfDate = '';
        returnRecord = 'SBSB,SBSG,MEME,SBCS,SBEL,SBAD,MEEL,MEPE,MEPR,MECB,MEHD,MEST,MECH,MEMD';   // KG - remove ADDL segment in response to service change communicted by Facets team on 9/9/16
	}
	
}