/*=======================================================================================================
 * Date         : 11/22/2017
 * Developer    : Satya Tirumalasetti
 * Purpose      : Trigger for Docusign Approval Response object                 
 *=======================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date      +  Developer   + Tag + Description
 *===========+==============+============================================================================
 * 11/22/2017|  Satya       |     | Initial Version.
 *===========+==============+=====+======================================================================
*/

trigger AIA_Docusign_ApprovalResponse on AIA_Docusign_Approval_Response__c (after update) {
  new AIA_Docusign_ApprovalResponseHandler().run();
}