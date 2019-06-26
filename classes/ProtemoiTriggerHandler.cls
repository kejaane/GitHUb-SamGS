/*=========================================================================================
 * Date      : 10/19/2016
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
public with sharing class ProtemoiTriggerHandler extends TriggerHandler {
    public ProtemoiTriggerHandler() {}
    
        /* context override */
    protected override void beforeUpdate() {
        processProtemoi();
    }
    
    protected override void beforeInsert() {
        processProtemoi();
    }
    
    /*protected override void afterInsert() {
    }
    
    protected override void afterUpdate() {
     
    }*/

    /***************************    
     * ENTER HELPER METHODS HERE     
     ***************************/
         
     private void processProtemoi() {
        ProtemoiAccountUpdate.UpdateAccount(trigger.new);
     }
     
}