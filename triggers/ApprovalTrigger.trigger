//===================================================================================
//Date:0 7/26/2017
//Developer: Satya
//Purpose: Approval Trigger
//=========================================================================================
// Update History
// Date         Developer                    Description
//==================================================================================
//07/26/2017       Satya                        Initial Development
//==================================================================================
trigger ApprovalTrigger on Approval_Response__c (before insert, before update) {
    AIA_ApprovalResponseTriggerHelper.validateAccountRole(trigger.new);

}