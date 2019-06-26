//=========================================================================================
//      Date: 05/23/2012
// Developer: Tom Barrett (TPB)
//   Purpose: All RFP__C trigger events start here
//            It's purpose is to handle all RFP__c trigger events
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
trigger RFP_Trigger on RFP__c (before insert, before update ) {
    if (trigger.isBefore) {
        RFPprocessManager.UpdateRFPNameField(Trigger.new);
    }
}