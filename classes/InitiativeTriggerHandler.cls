/*=========================================================================================
 * Date      : 07/11/2016
 * Developer : Rajesh Pennam
 * Purpose   : This class is the extension point of the Trigger Framework for adding Initiatives trigger handlers.
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer         Description
 *===========+============+================================================================
 * 06/03/2016  |  Rajesh Pennam    | Initial Version                                         
 *             |          | 
 *=============+==========+================================================================
 */
public with sharing class InitiativeTriggerHandler extends TriggerHandler {
    public InitiativeTriggerHandler() {}
    
        /* context override */
    protected override void beforeUpdate() {
        processInitiative();
    }
    
    protected override void beforeInsert() {
        processInitiative();
    }
    
    /*protected override void afterInsert() {
    }
    
    protected override void afterUpdate() {
     
    }*/

    /***************************    
     * ENTER HELPER METHODS HERE     
     ***************************/
         
     private void processInitiative() {
        InitiativesAccountUpdate.UpdateAccount(trigger.new);
     }
     
}