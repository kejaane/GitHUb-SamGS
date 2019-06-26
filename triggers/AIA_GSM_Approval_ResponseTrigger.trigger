/*===================================================================================================================
 * Date       : 9/18/2017
 * Developer  : Rajesh Nagandla
 * Purpose    : Trigger is to Update Group Structure Request Form status based on internal approval repsonses.
 *                                 Update History
 *                                 ---------------
 * Date       |     Developer        | Tag |   Description
 *============+============+=========================================================================================
 * 9/21/2017  | Rajesh Nagandla      |      | Initial creation
 *============+============+=========================================================================================
*/
trigger AIA_GSM_Approval_ResponseTrigger on GSM_Approval_Response__c (after update) {
        if(Trigger.isAfter && Trigger.isUpdate){
            if(!AIA_GSM_internalprocessHandler.AfterUpdateRecursive){
                AIA_GSM_internalprocessHandler.AfterUpdateRecursive=true;
                new AIA_GSM_internalprocessHandler().run();
            }
        }
}