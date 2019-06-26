/*=======================================================================================================
 * Date         : 11/22/2017
 * Developer    : Satya Tirumalasetti
 * Purpose      : This will be called from Docusign Aproval Response trigger whenever Docusign Approval 
 *                Response record got updated                  
 *=======================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date      +  Developer   + Tag + Description
 *===========+==============+============================================================================
 * 11/22/2017|  Satya       |     | Initial Version.
 *===========+==============+=====+======================================================================
*/

public class AIA_Docusign_ApprovalResponseHandler extends TriggerHandler {

public AIA_Docusign_ApprovalResponseHandler(){}


 protected override void afterUpdate(){
 
     AIA_Docusign_ApprovalResponseHelper.updateDocOnBaaApproval((list<AIA_Docusign_Approval_Response__c>) trigger.new);
 
 }

}