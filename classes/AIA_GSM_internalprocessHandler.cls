/*===================================================================================================================
 * Date       : 9/25/2017
 * Developer  : Rajesh Nagandla
 * Purpose    : AIA_GSM_internalprocessHandler will have logic to AIA_GSM_Approval_ResponseTrigger
 * 				is to submit for approval on GSRF for internal and change the status
 * 				of Group structure Request form status according to the approval repsonses.
 *                                 Update History
 *                                 ---------------
 * Date       |     Developer        | Tag |   Description
 *============+============+=========================================================================================
 *============+============+=========================================================================================
*/
//Removing with sharing as locking and unlocking is happening here
public class AIA_GSM_internalprocessHandler extends TriggerHandler{
	@TestVisible public Static Boolean AfterUpdateRecursive=false; 

    public AIA_GSM_internalprocessHandler(){}
    
    protected override void afterUpdate(){
        AIA_GSM_internalprocessHelper.renewalDateUpdate(Trigger.new);
    }
    
    
}