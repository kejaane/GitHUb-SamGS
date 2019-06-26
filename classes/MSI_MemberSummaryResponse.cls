/*=========================================================================================
 * Date		: 10/21/2014
 * Developer	: Ken Gill
 * Purpose   	: This class holds the data field values received from the Create/Update Facets web service invocation.
 *                It implements the necessary interface and fields to allow participation in the Integration
 *                logging and transaction frameworks.
 *                
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 8/12/16   |  KG	  |	Initial Version                                         
 *           |  	  |	
 * 8/30/16   |  KG	  | Added fields for memberProcessEligDesc, memProcessEligInd, productCategoryDescription	
 *           |  	  |	
 * 12/5/16   |  KG	  | Added Subscriber fields subEligibilityIndicator, subOriginalSubscriberID. The former is populated
 *           |        | In MSI_MemberService from the Member whose memberID = subscriber.SubscriberID in the MEPE segment processing
 *           |        | The subOriginalSubscriberID is a place holder and is not available in current MemberSummary service response.	
 *===========+============+================================================================
 */
 
 
 
public with sharing class MSI_MemberSummaryResponse extends MSI_Message {

 	public String status { get; set;}	// SUCESS or ERROR
	public String statusCode { get; set;}
	public String statusDescription { get; set;}

	 public class Eligibility {
	 	public String effectiveDate {get; set;}
	 	public String terminationDate {get; set;}
	 	public String seqDate {get; set;}
	 	public String typex {get; set;} 	// use typex because type is a keyword in Apex
	 	public String typeDescription {get; set;}
	 	
	 	public String productCategory {get; set;}
	 	public String productCategoryDescription {get;set;}	// only available for subscriber eligibility details
 		public String productDesc {get; set;}
	 	public String productID {get; set;}
	 	 		
	 	public String classId {get; set;}
	 	public String classPlanID {get; set;}


	 	public String planDescription {get; set;}
	 	public String familyID {get; set;}
	 	public String reasonCode {get; set;}
	 	public String voidIndicator {get; set;} 	
	 	
	 	public String memProcessEligInd {get;set;}
 		public String memProcessEligIndDesc {get;set;} 
 		//public String EligibilityDescrption {get;set;}
	 }
	
	public class Member {
		public String firstName { get; set;}
		public String lastName { get; set;}
 		public String memberSuffix {get; set;}
		public String relationshipCode {get; set;}  // Enum 01-09
		public String relationshipCodeDesc {get;set;}
		
		public String relationship { get; set;} 	// Enum M,W,D,S etc.
		public String relationshipDescription {get;set;}
		public String memberID { get; set;}
		public String memberContrivedKey {get; set;}
		public String dateOfBirth { get; set;}
		public String streetAddress1 { get; set;}
		public String streetAddress2 { get; set;}
		public String streetAddress3 { get; set;}
		public String city { get; set;}
		public String state { get; set;}
		public String zipCode { get; set;}
		public String phone { get; set;}		
		public Map<String, List<MSI_MemberSummaryResponse.Eligibility>> eligibilityMap {get; set; }
		
			// this map flattens the eligibilityMap using an integer index for key merges all the by classplan id key indexed
			// Lists of eligibilitiles from the eligibilityMap. This is to facilitate easier UI rendering on the VF page.
		public Map<Integer, MSI_MemberSummaryResponse.Eligibility> flatEligibilityMap {get; set;}
		
		public Member() {
			// eligibilityMap = new Map<String,MSI_MemberSummaryResponse.Eligibility>();
			
			eligibilityMap = new Map<String, List<MSI_MemberSummaryResponse.Eligibility>> ();
			flatEligibilityMap = new Map<Integer, MSI_MemberSummaryResponse.Eligibility>();
		}
	}



	public class Subscriber {
	 
	// Subscriber Fields
	 public String subscriberID { get; set;}
	 public String subscriberContrivedKey {get; set; }
	 
	 public String groupID { get; set;}
	 public String groupName {get; set;}
	 public String groupContrivedKey {get; set; }
	 public String subscriberLastName {get; set;}
	 public String subscriberFirstName {get; set;}
   	 public String subscriberStreetAddress1 { get; set;}
 	 public String subscriberStreetAddress2 { get; set;}
 	 public String subscriberStreetAddress3 { get; set;}	 
	 public String subscriberCity {get; set;}
	 public String subscriberState {get; set;}
	 public String subscriberZip {get; set;}
	 
	 public String subOrgEffectiveDate {get; set;}
	 public String subEligibilityIndicator {get;set;}
	 public String subOriginalSubscriberID {get;set;}	// TBD in future. Not available in current MemberSummary service response KG 12/5/16
	 
	 public Map<String,MSI_MemberSummaryResponse.Eligibility> subEligibilityMap {get; set; }	// key: Product type i.e. M,V,D (medical,vision,dental etc)

	// Map of MemberID -> Member 
     public Map<String,MSI_MemberSummaryResponse.Member> memberDetailsMap { get; set;}
     
     public Subscriber() {
     	memberDetailsMap = new Map< String, MSI_MemberSummaryResponse.Member>();
     }
	
	} 

	// Map of Subscriber Member summaries. The key is the GroupID and value is the Subscriber record that contains Member details. A subscriber has multiple MemberSummaries by GroupID because a Subscriber can be associated with multiple Groups
	 public Map<String,MSI_MemberSummaryResponse.Subscriber> subscriberByGroupMap { get; set;}
	  
	 
	 public MSI_MemberSummaryResponse( MSI_MemberSummaryRequest request) {
	 	  super();
	 	  msgType = IntegrationMessage.RESPONSE;
	 	  transactionID = request.transactionID;
	 	  // memberDetailsMap = new Map<String,MSI_MemberSummaryResponse.Member>();
	 	  subscriberByGroupMap = new Map<String, MSI_MemberSummaryResponse.Subscriber>();	 	
	 }
	 
	// Get all Subscriber records 
	public Map<String,MSI_MemberSummaryResponse.Subscriber> getSubscriberMembers() { return subscriberByGroupMap; }
	
	// Get Subscriber record for particular GroupID
	public MSI_MemberSummaryResponse.Subscriber getSubscriberByGroupID( String groupID ) {
			return ( String.isBlank( groupID) ?  null :  subscriberByGroupMap.get( groupID ));
	}

	@TestVisible
 	 public void addMemberDetails( MSI_MemberSummaryResponse.Subscriber subscriber, MSI_MemberSummaryResponse.Member member) {
 	 	//if( subscriber == null ) { String message = 'MSI_MemberSummaryResponse.addMemberDetails(): Received null subscriber'; System.debug( message ); throw new MSI_MemberService.MSI_Exception( message ); }  
 	 	//if( subscriber != null && subscriber.memberDetailsMap == null) { String message = 'MSI_MemberSummaryResponse.addMemberDetails(): Received null subscriber.memberDetailsMap'; System.debug( message ); throw new MSI_MemberService.MSI_Exception( message ); }
 	 	   
		subscriber.memberDetailsMap.put(member.memberID, member);
	}
	
	@TestVisible
	public void addSubscriber( MSI_MemberSummaryResponse.Subscriber subscriber ) {
 	 	//if( subscriber == null ) { String message = 'MSI_MemberSummaryResponse.addSubscriber(): Received null subscriber'; System.debug( message ); throw new MSI_MemberService.MSI_Exception( message ); }
		//if( String.isBlank( subscriber.groupID)) { String message = 'MSI_MemberSummaryResponse.addSubscriber(): subscriber.groupID is null or blank'; System.debug( message ); throw new MSI_MemberService.MSI_Exception( message ); }
		
		subscriberByGroupMap.put( subscriber.groupID, subscriber);
	}
	
	public static void flattenEligibilityMaps( MSI_MemberSummaryResponse response) {
		for( MSI_MemberSummaryResponse.Subscriber subscriber : response.subscriberByGroupMap.values() ) {
			for( MSI_MemberSummaryResponse.Member member : subscriber.memberDetailsMap.values() ) {
				MSI_MemberSummaryResponse.flattenEligibilityMap( member );
			}
		}
	}
	
	
	public static void flattenEligibilityMap(  MSI_MemberSummaryResponse.Member member ) {

		if( member.flatEligibilityMap == null)
			member.flatEligibilityMap = new Map<Integer, MSI_MemberSummaryResponse.Eligibility>();
			
		Integer i = 0;			
		for( String classplanId : member.eligibilityMap.keySet() ) {
			
			List<MSI_MemberSummaryResponse.Eligibility> eligListForClassPlanID = member.eligibilityMap.get( classplanID);
			for( MSI_MemberSummaryResponse.Eligibility e : eligListForClassPlanID ) {		
				member.flatEligibilityMap.put( i, e);
				i++;
			}
		}
	}
	
}