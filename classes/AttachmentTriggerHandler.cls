/*=========================================================================================
 * Date     : 02/01/2016
 * Developer    : Ashish Ojha
 * Purpose      : This class is the extension point of the Trigger Framework for adding Attachment trigger handlers.
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 02/01/16|  AO    | Initial Version                                         
 *===========+============+================================================================
===========+============+================================================================
 * 09/29/16|  Indira Das    | updated attachements for Benefit design Form generated from Drawloop                                         
 *===========+============+================================================================
 */

public with sharing class AttachmentTriggerHandler extends TriggerHandler {

    public AttachmentTriggerHandler() {}
    
    
    protected override void beforeInsert() {
    // Note on casting below:
      // Outside a trigger, the trigger collections Trigger.new,.old have to be explicitly cast to the SOBject type
      // When working inside a trigger, this casting happens implicitly
            SBU_Attachment_on_Case.PreventAddAttachmentonCase((list<attachment>) Trigger.new);
    }
    
    protected override void afterInsert() {
        //update AIA document details when Attachment is added to this object.
            AIADocumentAttachment.updateAIADocumentAttachmentID((list<attachment>) Trigger.new);
    }
     protected override void beforeDelete() {
            SBU_Attachment_On_Case.PreventDelAttachmentonCase((list<attachment>) Trigger.old);
            
    }


}