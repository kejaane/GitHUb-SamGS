/*=========================================================================================
 * Date         : 9/26/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This class holds the data field values received from Broker Hub web service invocation.
 *                It implements the necessary interface and fields to allow participation in the Integration
 *                logging and transaction frameworks.
 *                
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
  
 *===========+============+================================================================
 */
 
public with sharing class BrokerHubSoldOpportunityRequestNew extends EGPMessage {

    private Opportunity opportunity;
    private String errorCode { get; set; }
    private String errorMessage { get; set; }
    public Map<String,String> relatedRecords { get; set; } 
    public static final String UPDATE_ACTION = 'UPDATE';
    public String action;   
     /*
    public String accountId{ get; set; }
    public String nascoAccountId{ get; set; }
    public String businessType{ get; set; }   
    public String accountName { get; set; }
    public String OpportunityEffectiveDate; 
    public String OpportunityEndDate{ get; set; } 
    public String sourceSystem{ get; set; } 
    public String LeadRepName{ get; set; } 
    public String LeadRepNumber{ get; set; }
    public String DivisionFlag{ get; set; }
    public BrokerHubServiceProxyNew.brokerAgencyDetails_element OppAdditionalDetails { get; set; }*/
    
     public BrokerHubServiceProxyNew.accountInformation_element[] accountInformation { get; set; }
     
     
     
    public static final String submittedById = 'SALESFORCEADMIN';
        
    public BrokerHubSoldOpportunityRequestNew() {
        super();
        this.msgType = IntegrationMessage.REQUEST;
        this.isValid = true;    // by default
      //  this.accountInformation = new BrokerHubServiceProxyNew.accountInformation_element[]();
    }
    
    public BrokerHubSoldOpportunityRequestNew( Opportunity o) {
        super();
        this.msgType = IntegrationMessage.REQUEST;
        this.opportunity = o;
        this.isValid = true;    // by default
       // this.accountInformation = new BrokerHubServiceProxyNew.accountInformation_element[]();
    }
    
} // End of Class