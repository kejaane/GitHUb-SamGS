/*=================================================================================================
* Date         : 11/17/2017
* Developer    : Raviteja
* Purpose      : Drawloop This class function is to check count of all line items and update in gsp
*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 11/17/2017| Raviteja    |     | Initial Version                                         
*===========+============+=====+===================================================================
*/
public class AIA_PackageTriggerHandler extends TriggerHandler{
public Static Boolean AfterinsertRecursive=false;
	public Static Boolean AfterupdateRecursive=false;  
    public Static Boolean AfterdeleteRecursive=false;

    protected override void afterUpdate() {
        AIA_PackageTriggerHelper.updateGroupCount(Trigger.new);
    }
    
    protected override void afterInsert() {
		
         AIA_PackageTriggerHelper.updateGroupCount(Trigger.new);

    }
    
    protected override void afterDelete() {
		
        AIA_PackageTriggerHelper.updateGroupCount(Trigger.old);

    }
}