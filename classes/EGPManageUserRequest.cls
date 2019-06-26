/*=========================================================================================
 * Date     : 10/21/2014
 * Developer    : Ken Gill
 * Purpose      : This class models an EGP Manage User request. It holds the data that is used to construct an EGP web
 *                service request. In addition, it provides for fields to hold related data records that were queried to 
 *                construct the request. It participates in the Integration logging framework
 *                by inheriting from EGPMessage which in turn extends IntegrationMessage base class.
 *                data field values received from the EGP web service invocation.
 *                It implements the necessary interface and fields to allow participation in the Integration
 *                logging and transaction frameworks.
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 10/21/14  |  KG    | Initial Version                                         
 * 10/06/2015|  TPB   | Added code to include the Opportunity.Effective_Date__c
 *===========+============+================================================================
 */
 
 public with sharing class EGPManageUserRequest extends EGPMessage {

 private Contact contact;
 private String errorCode { get; set; }
 private String errorMessage { get; set; }
 
 // used for logging related records used to build request data
 public Map<String,String> relatedRecords { get; set; } 
 
 
    // Reference for field names and values: 
    // Interface Agreement Document (IAD) 
    // File: TIBCO_Design_EmployerPortal_SalesForce_Service.docx
    

        // Possible EGP Admin User provisioning actions
        // CREATE for Provision EGP admin, 
        // TERMINATE for De-Provision EGP admin

    public static final String CREATE = 'CREATE';
    public static final String TERMINATE = 'TERMINATE';

        //  provisioning action
    public String action;   

        // Entity type being provisioned for EGP admin
        // Possible value: EMPLOYER, PROVIDER       
    public static final String  ENTITY_EMPLOYER = 'EMPLOYER';
    public static final String  ENTITY_PROVIDER = 'PROVIDER';

            // always set to EMPLOYER when calling from SFDC
    public static final String entity = EGPManageUserRequest.ENTITY_EMPLOYER;

        // submitter user id is a fixed string per EGP web service developer guidance
    public static final String submittedById = 'SALESFORCEADMIN';

    public String contactFirstName { get; set; }        
    public String contactLastName { get; set; }
    public String contactEmail { get; set; }
    public String accountName { get; set; }
    public String accountOwnerFirstName { get; set; }
    public String accountOwnerLastName { get; set; }
    public String accountOwnerEmail { get; set; }
    public String accountType { get; set; }
    public String opportunityFacets { get; set; }
    public String opportunitySystem { get; set; }
    public String opportunityEnrollmentPlatform { get; set; }   // Enrollment platform
    public String opportunityEffectiveDate { get; set; } //ADD TPB 10/06/2015
  

    public String groupID { get; set; }
        // List of Groups with group detail for each group
    public list<EGPServiceProxy.group_element> groups { get; set; }

    public string ASOIndicator; // ASO Indicator. Possible: 'Y' or 'N'

    public EGPManageUserRequest( Contact c) {
        super();
        this.msgType = IntegrationMessage.REQUEST;
        this.contact = c;
        this.isValid = true;    // by default
        this.groups = new List<EGPServiceProxy.group_element>();
    }

}