/*=========================================================================================
 * Date         : 08/19/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This is the trigger based on the custom partner object - Partner__c
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================

 *=========================================================================================
 */
 
 trigger PartnerTrigger on Partner__c(after delete, after insert, after undelete, 
                                      after update, before delete, before insert, before update){
 
 
    new PartnerTriggerHandler().run();
    
}