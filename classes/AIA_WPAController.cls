//===================================================================================
//Date: 04/19/2016
//Developer: Sree Harsha Akkala
//Purpose: Saves the Workplan Assignment and links it with Proposal Request Form.
//=========================================================================================
// Update History
// Date         Developer               Description
//==================================================================================
//04/19/2016    Sree Harsha Akkala      Initial Development
//04/16/2018    Gayathri           T01  Commented the lines related to WP Assignment
//    								  	as part of US 209
//==================================================================================
public with sharing class AIA_WPAController {
    
    //public AIA_Workplan_Assignment__c wpa{get;set;}//T01
    /**
     * Sets the owner to current user.  
     * @Constructor AIA_WPAController    
    */
    /* T01 -- Start
    public AIA_WPAController(ApexPages.StandardController controller) {
        
        wpa = new AIA_Workplan_Assignment__c();
        wpa.ownerId=userinfo.getuserId();
		
    }
  T01 -- End*/
     /**
     * Saves the Workplan Assignment and links it with Proposal Request Form.   
     * @method save  
    */ 
     /*T01 - Start
    public pagereference save(){
       
        try{
            id prfId = apexpages.currentpage().getparameters().get('PRFid');
            wpa.Proposal_Request_Form__c= prfId;
            PRF__c prf=[select opportunity__c,Opportunity__r.AccountId from PRF__c where id =: prfId];
            wpa.Account__c = prf.Opportunity__r.AccountId;
            insert wpa;
        }
        catch(exception e){
            system.debug(e.getMessage());
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error while creating the Workplan Assignment'));
        }        
        return new pagereference('/'+wpa.id); 
		
        return null;//Added as part of US209
    }    
    T01 -- End*/        
}