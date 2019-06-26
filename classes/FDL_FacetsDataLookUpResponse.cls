/*=========================================================================================
 * Date         : 11/3/17
 * Developer    : Arshia Gulati
 * Purpose      : This class holds the field values specific to related entities received 
 * 				  from the Facets DataLookUp service invocation.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/03/17  |  AG    | Initial Version developed for User story B-03752                                         
 *=========================================================================================
 */
public with sharing class FDL_FacetsDataLookUpResponse extends FDL_Message {
 	public String status { get; set;}	
	public String statusCode { get; set;}
	public String statusDescription { get; set;}   
    public String groupID {get; set;}
    public FDL_RelatedEntity[] relatedEntity {get; set;}
    public class FDL_RelatedEntity {
 	public String relatedEntityName { get; set;}
    public String groupRelationshipCategory { get; set;}
    public String relatedEntityType { get; set;}
    public String groupRelationshipEffDt { get; set;}
    public String groupRelationshipTermDt { get; set;}
    public String relatedEntityID { get; set;}
    public String relatedEntityEmail { get; set;}
    public String relatedEntityFax { get; set;}
    public String relatedEntityPhone { get; set;}
    public String groupRelationshipTermReason { get; set;}
    public String relatedEntityAddrline1 { get; set;}
    public String relatedEntityAddrline2 { get; set;}
    public String relatedEntityAddrline3 { get; set;}
    public String relatedEntityCity { get; set;}	
    public String relatedEntityCounty { get; set;}	
    public String relatedEntityState { get; set;}
    public String relatedEntityZip { get; set;}
    }    
	public FDL_FacetsDataLookUpResponse( FDL_FacetsDataLookUpRequest request) {
 	  super();
 	  msgType = IntegrationMessage.RESPONSE;
 	  transactionID = request.transactionID;
 	}
}