//=========================================================================================
//      Date: 12/18/2015
// Developer: Tom Barrett (TPB)
//   Purpose: This class is called by the opportunity trigger.  This class updates the 
//            Account.Type field based on the latest related Opportunity.StageName, excluding
//            an opportunity in proposal.  If the Stage is Dead then the Account.Type will be
//            set to Prospect.  if the StageName is Sold then the Account.Type will be set
//            to Customer.
//            If the Account.Type field is already set appropriately then the DML update on
//            the Account does not occur. 
//            This process only updates the Account.Type field for 51+ record types.
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
// 04/20/2016 TPB            Updated to include more details from the error message 
//
// 06/09/2016 TPB            Updated to include the new 200+ (AIA_200) RecordType at the
//                           code that queries the Opportunity level. 
//                           It was determined not to include the new RecordType at the 
//                           Enrollment__c object level.   
//=========================================================================================

public class UpdateAccountBasedOnLatestOppStageChange {
    public class UpdateAccountBasedOnLatestOppStageChangeException extends Exception{}
    public static Boolean TestWorkAround = false; 
    public static Id RecType51Plus = QueryBase.getRecordTypeId('Opportunity', 'X51');
    public static id RecTypeAIA_200 = Querybase.getRecordtypeId('Opportunity', 'AIA_200'); //Added 06/09/2016 TPB 
    public static void UpdateAccountTypeField(List<Opportunity> opportunities, Map<Id,Opportunity> oldOpportunitiesMap) { 
        // This variable is used to determine if there are any opps tied to the account at all.  For exmaple, if we 
        // have only one opportunity and it is SOLD that would mean the Account.Type = 'Customer'  If the opporuntiy 
        // is deleted we would never hit the inner FOR LOOP to set the Account.Type to 'Prospect'.  
        //This flag field helps to accomplish this situation.
        Boolean oppExists = false; 
        Set<Id> accIdsSet = new Set<Id>();
        Map<Id, Account> accIdsMap = new Map<Id, Account>();        
        // Holds the Account records that will be updated (Type field only)        
        Map<Id, Account> accsToUpdateMap = new Map<Id, Account>();
        // Get a Set of Account Ids related to the Opportunities
        for (Opportunity o : opportunities) {
            // Only build a set of accounts that are associated to opportunities 
            // that are RecordType 51+ Opportunities as this process should only
            // deal with 51+ and not 2-50 record types.
            
            //BEGIN CHANGE TPB 06/09/2016            
            //if ( o.RecordTypeId == RecType51Plus ) {
            if ( o.RecordTypeId == RecType51Plus || o.RecordTypeId == RecTypeAIA_200 ) {
            //END CHANGE TPB 06/09/2016
                accIdsSet.Add(o.AccountId);   
            }
        }         
        // if we don't have any 51+ record types then we don't need to process
        // any further as this entire process is for 51+ record types only.
        if ( accIdsSet.size() == NULL || accIdsSet.size() == 0 ) return;
        
        for (Account a: [ SELECT Id, Type FROM Account WHERE Id IN: accIdsSet ]) {
            accIdsMap.put(a.Id, a);  
        }                      
       
        // This query returns all accounts associated to the Opportunities in the Trigger
        // It also only returns a sub query of Opportunities in a sorted order that brings
        // the latest opportunities to the top of the list.  Because it sorts by Stage 
        // in ascending order it ensures that if more than one are in the active range based
        // on effective date and contract end date we get the Sold first if there is a Sold
        // and multiple Dead opportunities for a given account.  We limit to 1 because if there
        // is a Sold first we make the Account.Type equal Customer, if it is a Dead then
        // we make the Account.Type equal Prospect.
        // NOTE: Salesforce sorts picklists (StageName) based on the order they are entered
        // in the field setup.  So with that said, the sort order below is Sold then Dead
        // even though it is in Ascending order.  That is because the values as of current
        // Date (01/05/2016 are entered in order of Proposal, Sold, and Dead.
        // Here is a post about this behavior:
        // https://developer.salesforce.com/forums/?id=906F00000008yJ1IAI     
//BEGIN CHANGE TPB 06/09/2016 - Changed the WHERE Clause from "RecordType.Name = '51+'"
//                              to "(RecordTypeId = :RecType51Plus OR RecordTypeId = :RecTypeAIA_200)"    
        for ( Account a : [ SELECT Id, Type, 
                                  (SELECT Id, AccountId, Effective_Date__c, StageName
                                   FROM Opportunities 
                                   WHERE (RecordTypeId = :RecType51Plus OR RecordTypeId = :RecTypeAIA_200) AND StageName IN('Dead','Sold') AND
                                         Effective_Date__c <= TODAY AND Contract_End_Date__c > TODAY                                   
                                   ORDER BY StageName LIMIT 1)
                            FROM Account  
                            WHERE Id IN :accIdsSet ] ) {
            oppExists = false;
            for ( Opportunity o : a.Opportunities ) { 
                oppExists = true; 
                // If the oldOpportunityMap returns NULL we assume user changed the Stage to Proposal so
                // lets check if the account is not already a Prospect and add to map for updating
                // it to a Prospect only if the Account is not already a Prospect 
                if ( oldOpportunitiesMap == Null ) {  
                    if ( accIdsMap.get(a.Id).Type != 'Prospect' ) {
                        accsToUpdateMap.put(o.AccountId, new Account(id=o.AccountId, Type='Prospect'));
                    }                               
                    Continue;
                } 
                // We only want to worry about updating the Account's Type field if the Opportunity
                // StageName field has actually changed    
                if ( o.StageName == 'Dead' && a.Type != 'Prospect' ) {
                    // Only add to the update map if values are different.  We do not want update
                    // an account unnecessarily
                    accsToUpdateMap.put(o.AccountId, new Account(id=o.AccountId, Type='Prospect'));  
                // Only add to the update map if values are different.  We do not want update
                // an account unnecessarily                    
                } else if ( o.StageName == 'Sold' && a.Type != 'Customer' ) {             
                    accsToUpdateMap.put(o.AccountId, new Account(id=o.AccountId, Type='Customer'));
                }  
            } 
            //Using this oppExists flag was the only way to insure that the Account.Type field is 
            //set to Prospect when there are no Opportunities associated to the account
            if (!oppExists) accsToUpdateMap.put(a.Id, new Account(id=a.Id, Type='Prospect'));      
        }
System.debug('zz accsToUpdateMap.size: ' + accsToUpdateMap.size());        
        Try {
            update accsToUpdateMap.values();
            //Only to catch the generic exception below for test class testing.
            if ( Test.isRunningTest() && TestWorkAround ) Integer tst = 1/0;
        } catch(DMLexception e) {    
            String errMsg;                          
            if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, 013')) {   
                errMsg = ' *** Please go to the associated account, add a Billing County Code and try updating the Opportunity again! *** ';                   
               //throw new UpdateAccountBasedOnLatestOppStageChangeException(errMsg);
                for(Opportunity opp:opportunities)
                {
                   opp.addError(errMsg); 
                }
            } else { // catch any other DML errors
                errMsg = '*** A DML Exception Occurred - Contact your System Administrator with a screen shot of this error ***';
                errMsg = errMsg + e.getMessage();    //04/20/2016 TPB                
                throw new UpdateAccountBasedOnLatestOppStageChangeException(errMsg, e);            
            }                
        } catch(exception e) {   
            throw new UpdateAccountBasedOnLatestOppStageChangeException(e.getMessage(), e);               
        }
    }    
}