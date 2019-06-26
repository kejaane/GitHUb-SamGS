/*=================================================================================================
* Date         : 11/04/2017
* Developer    : Raviteja
* Purpose      : US-234 This class function tocheck all alpha prefix fields in gsp and make the
				 alpha prefix field in GSRF field completed.

*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+=============+=====+===================================================================
* 11/04/2017| Raviteja	  |		| initial creation
*
*===========+============+=====+===================================================================
*/
public class AIA_GSM_GSRFProductTriggerHandler  extends TriggerHandler {
    public Static Boolean beforeinsertRecursive=false;
    public Static Boolean beforeupdateRecursive=false;
    public Static Boolean afterdeleteRecursive=false;
    protected override void beforeInsert() {
    	AIA_GSM_GSRFProductTriggerHelper.checkAlphaPrefixMissing(Trigger.new);
    } 
	protected override void beforeUpdate() {
    	AIA_GSM_GSRFProductTriggerHelper.checkAlphaPrefixMissing(Trigger.new);
    }  
    protected override void afterUpdate() {
    	AIA_GSM_GSRFProductTriggerHelper.checkAlphaPrefixCompleted(Trigger.new);
    }
    protected override void afterDelete() {
    	AIA_GSM_GSRFProductTriggerHelper.checkAlphaPrefixCompleted(Trigger.old);
    }
}