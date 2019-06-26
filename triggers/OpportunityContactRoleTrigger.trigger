/*=========================================================================================
 * Date         : 08/19/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This is the trigger based on the custom opportunity contact role object - Opportunity_Contact_Role__c  
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================

 *=========================================================================================
 */

 trigger OpportunityContactRoleTrigger on Opportunity_Contact_Role__c  (after delete, after insert, after undelete, 
                             after update, before delete, before insert, before update){
 
     new OpportunityContactRoleTriggerHandler().run();
    
}