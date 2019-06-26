/*=================================================================================================
* Date         : 09/21/2017
* Developer    : Raviteja
* Purpose      : US-63 This trigger is to pass the groups list to helper class to check for missing
				 Alpha prefixes
*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 09/21/2017| Raviteja    |      | Initial Version                                         
* 10/06/2017| Raviteja    |  T01 | Added before update to check Main tech role is loggedin user
* 10/06/2017| Sajitha Y   |  T02 | Calling helper class AIA_GroupNumbersHelper to update Group Numbers on GSRF US - 87
* 10/06/2017| Raviteja    |  T03 | commented as per us 234 changes
*===========+============+=====+===================================================================
*/
public with sharing class AIA_GroupHandler extends TriggerHandler{
public Static Boolean AfterinsertRecursive=false;
public Static Boolean beforeupdateRecursive=false;   
public Static Boolean beforedeleteRecursive=false;   
public Static Boolean AfterUpdateRecursive=false; // T04 added TestVisible.

    //check masttechrole before updating if he is updating only alpha prefix value.
    protected override void beforeUpdate() {
        system.debug('Trigger.newMap'+Trigger.newMap);
        AIA_GroupHelper.checkMaintech(Trigger.newMap,Trigger.oldMap);
    }
    protected override void afterUpdate() {
        //AIA_GroupHelper.checkAlphaPrefixMissing(Trigger.new,'not delete');    T03
        // T02 - start
        AIA_GroupNumbersHelper.UpadteGroupNumbers(Trigger.new,'not delete');
        // T02 - End
        AIA_GroupHelper.updateGroupCount(Trigger.new);
    }
    
    protected override void afterInsert() {
        //AIA_GroupHelper.checkAlphaPrefixMissing(Trigger.new,'not delete');    T03
        // T02 - start
         AIA_GroupNumbersHelper.UpadteGroupNumbers(Trigger.new,'not delete');
         // T02 - End 
         AIA_GroupHelper.updateGroupCount(Trigger.new);

    }
    
    protected override void afterDelete() {
        //AIA_GroupHelper.checkAlphaPrefixMissing(Trigger.old,'delete');    T03
        // T02 - start
        AIA_GroupNumbersHelper.UpadteGroupNumbers(Trigger.old,'delete');
        // T02 - End
        AIA_GroupHelper.updateGroupCount(Trigger.old);

    }
    
    protected override void beforeDelete() {
        //AIA_GroupHelper.checkAlphaPrefixMissing(Trigger.old,'delete');    T03
        // T02 - start
       // AIA_GroupHelper.updateGroupCount(Trigger.old);
        // T02 - End
    }
}