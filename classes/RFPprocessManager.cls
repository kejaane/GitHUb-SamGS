//=========================================================================================
//      Date: 05/23/2012
// Developer: Tom Barrett (TPB)
//   Purpose: This class's primary purpose is to handle all RFP__c object functionality
//
// Method/Function           Description
//=========================================================================================
// UpdateRFPNameField        Updates the RFP's Name field with the account name
// UpdatePRFNameField        Updates the PRF's Name field with the account name
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
public class RFPprocessManager { 
    /* Updates the RFP__c object's Name field with the
     * related Opportunity's Account Name
    */
    public static void UpdateRFPNameField( RFP__c[] rfpList ) {          
        Map<Id, Opportunity> opps = new Map<Id, Opportunity>(); 
        try {            
            // get list of opportunity ids and store in opps Map        
            for (RFP__c rfp : rfpList) {
                opps.put(rfp.Opportunity_Name__c, null);
            }
            // overlay opps map with matching keyset and account name
            opps.putAll([Select id, account.name from Opportunity Where id in :opps.keyset()]);
            // Loop through the rfp list and update the rfp Name with account name
            for ( RFP__c rfp : rfpList ) { 
                // only if an opportunity is selected do we attempt the update of the RFP name field
                if ( rfp.Opportunity_Name__c != null ) {
                    rfp.Name = opps.get(rfp.Opportunity_Name__c).account.name;
                }
            }
        } catch (Exception e) {           
            EmailAlerts.emailAdmins('The Apex RFPprocessManager.UpdateRFPNameField method threw the following exception: ', 'Error at line: ' +  e.getLineNumber() + ', ' +  e.getMessage());
        }
    }
    
    /* Updates the PRF__c object's Name field with the 
     * related RFP Name if one exists.
    */
    public static void UpdatePRFNameField( PRF__c[] prfList ) {     
        Map<Id, RFP__c> rfps = new Map<Id, RFP__c>();         
        try {
            // get list of opportunity ids and store in opps Map        
            for (PRF__c prf : prfList) {
                rfps.put(prf.RFP_Name__c, null);
            }
            // overlay rfps map with matching keyset and account name
            rfps.putAll([Select id, Opportunity_Name__r.Account.Name, Opportunity_Name__c from RFP__c Where id in :rfps.keyset()]);
            // Loop through the rfp list and update the rfp Name with account name
            for ( PRF__c prf : prfList ) { 
                // only if an opportunity is selected do we attempt the update of the RFP name field
                if ( prf.RFP_Name__c != null && rfps.get(prf.RFP_Name__c).Opportunity_Name__r.Account.Name != null ) {
                    prf.Name = rfps.get(prf.RFP_Name__c).Opportunity_Name__r.Account.Name;
                }
            }
        } catch (Exception e) {            
            EmailAlerts.emailAdmins('The Apex RFPprocessManager.UpdatePRFNameField method threw the following exception: ', 'Error at line: ' +  e.getLineNumber() + ', ' +  e.getMessage());
        }      
    }
}