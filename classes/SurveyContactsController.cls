//=========================================================================================
//      Date: 07/12/2016
// Developer: Rajesh Pennam
//   Purpose: Populate the custom Survey_Contacts__c object with Opportunity Contact Role
//            Data.
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
// 07/12/2016 Rajesh Pennam    Removed the ContactId and Contact Name text field and replaced with lookup
// 08/22/2016 Rajesh Pennam    Renamed the class name from SurveyContactsController2 to SurveyContactsController
//=========================================================================================


public with sharing class SurveyContactsController {

    public Boolean refreshPage { get; set; }
    private Id oppId;
   
    public SurveyContactsController(ApexPages.StandardController controller) {
        oppId = Controller.getRecord().id;
        refreshPage = false;
    }

    public PageReference SurveyContactsController() {
        PageReference pageRef = null;
        //List used to get details from the OpportunityContactRole Object
        List<OpportunityContactRole> ContactRoleList = [SELECT ContactID, Contact.Title, Contact.Name, Contact.Email, Contact.Phone FROM OpportunityContactRole WHERE OpportunityId = :oppId];
    
                    
       
        Map<id, OpportunityContactRole> ocrMap = new Map<id, OpportunityContactRole>();
        //Set used to store Contactid's from the OpportunityContactRole Object
        Set<id> idSet = new Set<id>();  
        for ( OpportunityContactRole cr : ContactRoleList ) {
            idSet.add(cr.ContactId);
            ocrMap.put(cr.ContactID, cr);
            
           
       
            
        }
        // List used to get all Contact__c's from Survey_Contacts__c object that are related to the current Opportunity 
        // @Rajesh Replaced ContactID__c with Contact__c
        List<Survey_Contacts__c> scList = [ SELECT Contact__c FROM Survey_Contacts__c WHERE Opportunity__c = :oppId ];        
       
   
       
       // Map used to store Contact__c's from Survey contacts object (Key - Contact__c, Value - Contact__c)
       // @Rajesh Replaced ContactID__c with Contact__c
        Map<id, id> scMap = new Map<id, id>();
        for ( Survey_Contacts__c sc : scList ) {
            scMap.put(sc.Contact__c, sc.Contact__c); // @Rajesh Replaced ContactID__c with Contact__c
        }
        
    
        
        if (ContactRoleList.size()>0){
            //Adding contacts from ContactRole Object to Survey Contacts related list by iterating the ContactRoles list
            //List used to store all records that have to be inserted
            List<Survey_Contacts__c> scInsertList = new List<Survey_Contacts__c>(); 
            for ( OpportunityContactRole cr : ContactRoleList ) { 
                // If a new contact is added to ContactRole and does not exist in Survey contact, then add it to the list  
                            
                // @Rajesh Replaced ContactID__c with Contact__c in the below assignment
                 if ( scMap.get(cr.Contactid) == NULL ) {           
                    Survey_Contacts__c surv = new Survey_Contacts__c(Title__c = cr.Contact.Title,Contact__c = cr.ContactID, Phone__c = cr.Contact.Phone, Email__c = cr.Contact.Email, Opportunity__c = oppId, Surveys__c = '');
                    scInsertList.add(surv);     
                }                
            }
            Insert scInsertList;                 
        }  
        
        //update survey contacts when a contact role is deleted
        // List used to get all ContactID's from ContactRoles object that are related to the current Opportunity 
        List<OpportunityContactRole> ContactRole2List = [ SELECT ContactID FROM OpportunityContactRole WHERE OpportunityId = :oppId ];        
        
        Map<id, id> crMap = new Map<id, id>();
        OpportunityContactRole ocrRecord;
        for ( OpportunityContactRole c :  ContactRole2List ) {
            crMap.put(c.ContactID, c.ContactID);
        }
        if (ContactRole2List.size()>=0){
            //List used to get details from the Survey Contacts Object
            // @Rajesh Replaced ContactID__c with Contact__c
            List<Survey_Contacts__c> scList4 = [ SELECT id, Title__c, Contact__c, Phone__c, Email__c FROM Survey_Contacts__c WHERE Opportunity__c = :oppId ];
            // List used to store records that have to be deleted from the Survey Contacts related list
            List<Survey_Contacts__c> scDeleteList = new List<Survey_Contacts__c>(); 
            //List used to store records that have to be updated in the Survey Contacts related list
            List<Survey_Contacts__c> scUpdateList = new List<Survey_Contacts__c>();   
            
            //Deleting survey contacts that do not exist in OpportunityContactRole Object
            for ( Survey_Contacts__c scl : scList4 ) { 
                // If the contactID is not found on the ContactRole, then add the id to the list and delete the list  
                if ( crMap.get(scl.Contact__c) == NULL ) {           
                    Survey_Contacts__c surv = new Survey_Contacts__c(id = scl.id);
                    scDeleteList.add(surv);  
                // Updating Survey contacts when fields in the OpportunityContactRole Object are updated
                //Getting the details of the records from the OpportunityContactRole Map using the matching Contact__c of the Survey Contacts 
                } else {                
                    ocrRecord = ocrMap.get(scl.Contact__c); // @Rajesh Replaced ContactID__c with Contact__c
                    scl.Phone__c = ocrRecord.Contact.Phone;
                    scl.Email__c = ocrRecord.Contact.Email;
                    scl.Title__c = ocrRecord.Contact.Title;
                    scUpdateList.add(scl);                   
                }                
            }
            Delete scDeleteList; 
            update scUpdateList;               
        }    
        refreshPage=true;
        return pageRef;
    } 
}