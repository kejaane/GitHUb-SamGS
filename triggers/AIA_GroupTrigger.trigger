/*=================================================================================================
* Date         : 09/18/2017
* Developer    : Raviteja
* Purpose      : DrawLoop(US87): This trigger is to update Group name on GSRF.
*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 09/18/2017| Raviteja    |     | Initial Version                                         
*
*===========+============+=====+===================================================================
*/
trigger AIA_GroupTrigger on AIA_Group__c (after insert,after update,after delete,before update,before delete) {
    if(Trigger.isupdate &&  Trigger.isAfter){
        if(!AIA_GroupHandler.AfterinsertRecursive){
            AIA_GroupHandler.AfterinsertRecursive=true;
            new AIA_GroupHandler().run();
        }
    }
    else if(Trigger.isinsert && Trigger.isAfter){
        if(!AIA_GroupHandler.AfterUpdateRecursive){
            AIA_GroupHandler.AfterUpdateRecursive=true;
            new AIA_GroupHandler().run();
        }
    }
    else if(Trigger.isbefore && Trigger.isupdate){
        if(!AIA_GroupHandler.beforeUpdateRecursive){
            AIA_GroupHandler.beforeUpdateRecursive=true;
            new AIA_GroupHandler().run();
        }
    }
    else if(Trigger.isbefore && Trigger.isdelete){
        if(!AIA_GroupHandler.beforedeleteRecursive){
            AIA_GroupHandler.beforedeleteRecursive=true;
            new AIA_GroupHandler().run();
        }
    }
    else{       
        new AIA_GroupHandler().run();
    }
}