/********************************************************************************  
 *  Class            : FCI_SubmitCaseToFacetsController
 *  Author           : Ken Gill
 *  Version History  : 1.0
 *  Creation         : 09/18/15
 *  Description      : This controller will invoke the FCI_FacetsService.createCase service
 *                     
 *                                         
 ********************************************************************************
 *---------------------------------------------------------------------------------------------
 * Date        Developer        Description
 *---------------------------------------------------------------------------------------------
 *
 * 09/18/15 Ken Gill          Initial controller that supports the Submit To Facets custom button added to 
 *                            the Case page layout for Project 51 - Facets Integration
 ********************************************************************************/
 
public with sharing class FCI_SubmitCaseToFacetsController {

    public Case caseObject { get;set; }

   /*
    * The constructor retrieves fields required to build a CreateCase request which includes related objects Contact, Owner and CaseComments
    * The retrieved comments exclude comments received via updates from Facets based on notes added in that system to avoid duplicating those when the 
    * request is sent to Facets. 
    */
    public FCI_SubmitCaseToFacetsController(ApexPages.StandardController stdController) {
        /*
        caseObject =
            [SELECT Id, Group_ID__c,Facets_Category__c, 
                    Facets_Status__c, Facets_Subject__c, 
                    Reason__c, 
                    Subject, Description, 
                    Status, 
                    Origin,
                    Resolution_Reason__c,
                    Group_Name__c,
                    New_Group_ID__c,
                    Broker_Service_Team__c,
                    Broker_ID__c,
                    SLA_Category__c,
                    Facets_Satisfaction_Level__c,
                    Market_Segment__c,
                    Contact.LastName, Contact.FirstName,
                    Contact.Salutation,Contact.MailingCity,
                    Contact.MailingState, Contact.MailingCountry,
                    Contact.MailingPostalCode, Contact.MailingStreet,
                    Contact.Phone, Contact.Fax,Contact.Email,
                    OwnerId, Owner.Type,
                    CreatedDate,
                    ClosedDate,
                    Received_Date__c,
                    LastModifiedDate, 
                    Facets_case_ID__c,
                    (SELECT Id, IsPublished,LastModifiedDate, CreatedBy.FirstName, CreatedBy.LastName, CommentBody FROM CaseComments 
                            WHERE NOT ( CreatedBy.FirstName = 'Facets' AND CreatedBy.LastName = 'Integration') 
                            ORDER BY LastModifiedDate ASC)        
            FROM Case 
             WHERE ID =: stdController.getRecord().Id];
             */
         caseObject = FCI_Util.getCaseDetailsById(stdController.getRecord().Id);
    }

    /*
     * This function handles the event that occurs after the "Submit to Facets"
     * button is clicked.
     * Before submitting the request, a input check is made to ensure
     * a. The case is in a allowed status for submission to Facets
     * b. Required parameters are input on the case detail page.
     *
     * If there are input validation errors, appropriate messages are added to ApexPage and displayed to the user for corrective action
     */
    public PageReference submitCaseToFacets() {
        PageReference pageRef = null;
        try {
            // Enforce preconditions: 
            // SubmitToFacets only allowed if not submitted before (no FacetsCaseId assigned)
            // and case status = Assigned, Awaiting or In Progress
            // Note: for case status=Closed, the FCI_CaseTriggerHandler takes care of submitting the case to Facets for archival purposes
            /*
            Boolean preConditionsMet = true;
                // NOTE: caseObject.Status is a picklist type. Comparing Picklist values requires '==' operator. The .equals() method does not return correct results
            if( !( caseObject.Status == 'Assigned' || 
                    caseObject.Status == 'Awaiting' || 
                    caseObject.Status == 'In Progress' ||
                    caseObject.Status == 'Routed To Other Department' ||
                    caseObject.Status == 'Routed To Management'                 
            ) ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Only a case with Status=Assigned, Awaiting, In Progress, Routed To Other Department or Routed to Management can be submitted to Facets'));
                preConditionsMet = false;
            }
            if( !String.isBlank(caseObject.Facets_case_ID__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Case has already been submitted to Facets. Facets case id=' + caseObject.Facets_case_ID__c));
                preConditionsMet = false;
            }
            if(!preConditionsMet) {
                System.debug(ApexPages.getMessages());
                pageRef=null; 
                return pageRef;
            }    
            */              
            // Create the FacetsCreateCase request 
            FCI_CreateCaseRequest request = new FCI_CreateCaseRequest(caseObject); 
            
            // Validate request has all required fields to create a Facets case
            FCI_Validation validation = request.validateRequest();
            if( ! validation.isValid) {
                ApexPages.Message msg = 
                        new ApexPages.Message(ApexPages.Severity.ERROR, validation.getValidationMessagesAsHTML());
                ApexPages.addMessage(msg);
                System.debug(ApexPages.getMessages());
                pageRef=null; 
                return pageRef;                 
            }
            
            // Send request to FCI_FacetsService
            FCI_CreateCaseResponse response = FCI_FacetsService.send_FCI_CreateCaseRequest(request);
            
            if( response.isValid()) { 
                // Redirect the user back to the case detail page if no errors
                pageRef = new PageReference('/' + caseObject.Id);
                pageRef.setRedirect(true);
            } else {
                String responseString = 'The Facets system could not accept the case submission. Details:<br>' +
                                        'Status Code=' + response.statusCode + '<br>' +
                                        'Status =' + response.status + '<br>' +
                                        'Details: ' + response.statusDescription;                       
                ApexPages.Message msg = 
                        new ApexPages.Message(ApexPages.Severity.ERROR, responseString);
                ApexPages.addMessage(msg);
                System.debug(ApexPages.getMessages());
                pageRef=null; 
                return pageRef;                                         
            }           
        } catch (Exception e) {
            pageRef = null;
            ApexPages.addMessages(e);
            System.debug(ApexPages.getMessages());
        }
        return pageRef;
    }
    
}