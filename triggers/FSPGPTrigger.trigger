/*=========================================================================================
 * Date         : 08/19/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This is the trigger based on the custom object - FSP_GP__c
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================

 *=========================================================================================
 */
 
 trigger FSPGPTrigger on FSP_GP__c(after insert, before delete){
 
    new FSPGPTriggerHandler().run();

}