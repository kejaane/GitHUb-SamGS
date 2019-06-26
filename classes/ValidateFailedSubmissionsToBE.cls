//=========================================================================================
//      Date: 12/13/2012
// Developer: Tom Barrett (TPB)
//   Purpose: The purpose of this class is to validate any errors written to the 
//            integration_err_log__c object that where created when the opportunity button 
//            'Submit To BE' was clicked by the user.  If the Source_Id__c value matches
//            an opportunity that has a BE_Prospect_ID__c value then the Integraation_Err_Log__c
//            field 'Validated__c' and 'Validate_Adjusted__c' are set to TRUE.
//
//            If BE_Prospect_ID__c does not have a value and the Stage is Dead or Sold then
//            Validate_Adjusted__c is set to TRUE.  This field should be used in a report to
//            assist the administrator in reaching out to the user asking them to submit the
//            opportunity to BE again in hopes to get the PR# on the opportunity.  This field
//            is the sole driver to flag the administrator into action if it is FALSE
//
//            When reviewing a errors that have the Validated_Adjusted__c field false and 
//            when you go to the related opportunity record and discovered that it was deleted
//            then the administrator should manually set Validated_Adjusted__c field to true
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
public class ValidateFailedSubmissionsToBE { 
    static {
        
        // Get list of all errors associated with Opportunities that have not been validated or adjusted    
        // NOTE: All opportunity ids start with '006'     
        List<Integration_Err_Log__c> errorList = [ SELECT Id, Source_Id__c 
                                                    FROM Integration_Err_Log__c
                                                    WHERE Source_Id__c Like '006%' AND                                                          
                                                          CreatedDate = LAST_N_DAYS:365 AND
                                                          (Validated__c = FALSE OR
                                                          Validate_Adjusted__c = FALSE) ];                                                          
        System.debug ('zzz1: ' + errorList.size());  
   
        // Get a list of all errorList ids to be used to get a Set of all associated opportunities
        Set<Id> setMatchingOpps = new Set<Id>(); 
        for ( Integration_Err_Log__c err : errorList ){
            setMatchingOpps.add(err.Source_Id__c);
        }  
        System.debug ('zzz2: ' + setMatchingOpps.size());                                 
        
        // Get the list of opportunties associated with the errorList above
        List<Opportunity> oppList = [ SELECT id, StageName, BE_Prospect_ID__c 
                                      FROM Opportunity 
                                      WHERE id = :setMatchingOpps ];
        
        //Iterate through the list of Opportunities associated with the errors and
        //seperate their ids into to seperate Sets                        
        set<Id> setOppsWithProspectID = new Set<Id>();
        set<Id> setOppsWithoutProspectID = new Set<Id>();
        for ( Opportunity opp : oppList ) {
            //get the ids of opportunties that have a prospect ID 
            if ( opp.BE_Prospect_ID__c <> NULL ) {                     
                setOppsWithProspectID.add(opp.id);
            }
            //get the ids of opportunities that are missing the prospect id and are closed (dead or sold)
            if ( opp.BE_Prospect_ID__c == NULL && (opp.StageName.containsIgnoreCase('Dead') || opp.StageName.containsIgnoreCase('Sold')) ) {
                setOppsWithoutProspectID.add(opp.id);  
            }
        }
        System.debug ('zzz3: ' + setOppsWithProspectID.size());
        System.debug ('zzz4: ' + setOppsWithoutProspectID.size()); 
              
        //Get list of errors based on the setOppsWithProspectID.  This gives us the list of errors
        //that we have confirmed have an associated opportunity that has a prospect Id
        List<Integration_Err_Log__c> errorsToValidate = [ SELECT Source_id__c, Validated__c, Validate_Adjusted__c 
                                                          FROM Integration_Err_Log__c
                                                          WHERE Source_id__c = :setOppsWithProspectID ];
                                                          
        //update both the validated__c and Validate_Adjusted__c to TRUE                                                 
        for ( Integration_Err_Log__c err : errorsToValidate ) {
            err.Validated__c = TRUE;          
            err.Validate_Adjusted__c = TRUE;
        }
        try {
            update errorsToValidate;
        } catch (Exception e) {
            EmailAlerts.emailAdmins('The Apex ValidateFailedSubmissionToBE.Static method threw the following exception: ', 
                    'Error at line: ' +  e.getLineNumber() + ', ' +  e.getMessage());
        }
        
        //Get list of errors based on the setOppsWithoutProspectID.  This gives us the list of errors
        //that we have confirmed have an associated opportunity that are missing the prospect Id but are closed (dead or sold)
        List<Integration_Err_Log__c> errorsToAdjust = [ SELECT Source_id__c, Validate_Adjusted__c 
                                                          FROM Integration_Err_Log__c
                                                          WHERE Source_id__c = :setOppsWithoutProspectID ];
                                                          
        //update the Validate_Adjusted__c to TRUE                                                 
        for ( Integration_Err_Log__c err : errorsToAdjust ) {        
            err.Validate_Adjusted__c = TRUE;
        }
        try {
            update errorsToAdjust;
        } catch (Exception e) {
            EmailAlerts.emailAdmins('The Apex ValidateFailedSubmissionToBE.Static method threw the following exception: ', 
                    'Error at line: ' +  e.getLineNumber() + ', ' +  e.getMessage());
        }
              
    }
}