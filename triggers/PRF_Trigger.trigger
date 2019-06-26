//=========================================================================================
//      Date: 06/04/2012
// Developer: Tom Barrett (TPB)
//   Purpose: All PRF__C trigger events start here
//            It's purpose is to handle all PRF__c trigger events
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
trigger PRF_Trigger on PRF__c (before insert, before update) {
    if (trigger.isBefore) {
        RFPprocessManager.UpdatePRFNameField(Trigger.new);
    }
}