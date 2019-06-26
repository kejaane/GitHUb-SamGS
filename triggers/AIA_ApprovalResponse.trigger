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
trigger AIA_ApprovalResponse on Approval_Response__c (after insert,after update) {
     new AIA_ApprovalResponseHandler().run();
}