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
trigger DepartmentTrigger on AIA_Department__c (after insert,after update,after delete) {
if(Trigger.isupdate &&	Trigger.isAfter){
        if(!AIA_DepartmentTriggerHandler.AfterinsertRecursive){
            AIA_DepartmentTriggerHandler.AfterinsertRecursive=true;
       		new AIA_DepartmentTriggerHandler().run();
        }
    }
    else if(Trigger.isinsert && Trigger.isAfter){
        if(!AIA_DepartmentTriggerHandler.AfterUpdateRecursive){
            AIA_DepartmentTriggerHandler.AfterUpdateRecursive=true;
        	new AIA_DepartmentTriggerHandler().run();
        }
    }
    else if(Trigger.isdelete && Trigger.isAfter){
        if(!AIA_DepartmentTriggerHandler.AfterdeleteRecursive){
            AIA_DepartmentTriggerHandler.AfterdeleteRecursive=true;
        	new AIA_DepartmentTriggerHandler().run();
        }
    }
}