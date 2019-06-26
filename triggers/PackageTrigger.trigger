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
trigger PackageTrigger on AIA_Package__c (after insert,after update,after delete) {
if(Trigger.isupdate &&	Trigger.isAfter){
        if(!AIA_PackageTriggerHandler.AfterinsertRecursive){
            AIA_PackageTriggerHandler.AfterinsertRecursive=true;
       		new AIA_PackageTriggerHandler().run();
        }
    }
    else if(Trigger.isinsert && Trigger.isAfter){
        if(!AIA_PackageTriggerHandler.AfterUpdateRecursive){
            AIA_PackageTriggerHandler.AfterUpdateRecursive=true;
        	new AIA_PackageTriggerHandler().run();
        }
    }
    else if(Trigger.isdelete && Trigger.isAfter){
        if(!AIA_PackageTriggerHandler.AfterdeleteRecursive){
            AIA_PackageTriggerHandler.AfterdeleteRecursive=true;
        	new AIA_PackageTriggerHandler().run();
        }
    }
}