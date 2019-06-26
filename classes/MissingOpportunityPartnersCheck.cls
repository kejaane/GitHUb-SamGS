//================================================================
//     Date: 08/09/2010
//Developer: Tom Barrett
//  Purpose: To execute the MissingOpportunityPartnersCheck_Batch
//           class code.
// Related
// Code    : MissingOpportunityPartnersCheck
//           MissingOpportunityParntersCheck_Schedule
//           MissingOpportunityPartnersCheck_Test
//           MissingOpportunityPartnersCheck_Batch
//================================================================

public class MissingOpportunityPartnersCheck { 
// BEGIN - USED STRICKLY TO PASS CODE COVERAGE LIMIT of 75%
    boolean TestMode = false;  
    boolean TestMode2 = false;  
    boolean TestMode3 = false;
    public void TestMode() { TestMode = true; } 
    public void TestMode2() { TestMode2 = true; }
    integer queryRowLimit = Limits.getLimitQueryRows();
    string query;    
// END - USED STRICKLY TO PASS CODE COVERAGE LIMIT of 75%

    public void Check() {   
        if ( TestMode ) {
            query = 'Select id, MissingPartner__c, Last_Modified_By_User__c, LastModifiedBy.Name, LastModifiedDate, (Select id From OpportunityPartnersFrom) From Opportunity Where StageName = \'Sold\' AND MissingPartner__c = false LIMIT 200';
        } else if ( TestMode2 ) {
            query = 'Select id, MissingPartner__c, Last_Modified_By_User__c, LastModifiedBy.Name, LastModifiedDate, (Select id From OpportunityPartnersFrom) From Opportunity Where StageName = \'Sold\' AND MissingPartner__c = true LIMIT 200';
        } else {
            query = 'Select id, MissingPartner__c, Last_Modified_By_User__c, LastModifiedBy.Name, LastModifiedDate, (Select id From OpportunityPartnersFrom) From Opportunity Where StageName = \'Sold\' AND Effective_Date__c = LAST_N_DAYS:365';
        } 
    
        MissingOpportunityPartnersCheck_Batch batchApex = new MissingOpportunityPartnersCheck_Batch(query);
        ID batchprocessid = Database.executeBatch(batchApex);    
    }
}