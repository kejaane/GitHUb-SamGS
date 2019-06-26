/******************************************************************************************************
* Date: 05/31/2016
* Developer: Spandhan Zangam 
* Purpose: AIA_Document
*******************************************************************************************************
* 							Update History
* Date         Developer           Tag           Description
*******************************************************************************************************
* 06/14/2016 | Spandhan Zangam    |     | Initial Development
* 08/29/2017 | Raviteja Vadapalli | T01 | Added beforeDelete function 
* 10/04/2017 | Goutham Rapolu     | T02 | Added AfterInsert function 
* 10/04/2018 | Rajesh Nagandla    | T03 | Add code related to activate/Deactivate trigger 
*                                     	  from Custom setting 'Activate Deactivate Triggers'
* 01/24/2019 | Rajesh Nagandla    | T04 | Added code to bypass triggers using Utils method  
*******************************************************************************************************/

trigger AIA_DocumentTrigger on AIA_Document__c(before insert,after insert, before update, before delete,after delete,after update) {
    
    /*T03 - Start*/    
    if(!AIA_Utils.isTriggerBypassed('AIA_Document__c')) { //T04
        
        // Get a handler appropriate to the object being processed        
        AIA_DocumentTriggerHandler handler=new AIA_DocumentTriggerHandler();
        
        // Iterate through the records to be inserted passing them to the handler.        
        if(Trigger.isInsert)
        {    
            if(Trigger.isBefore)
            {   
                handler.beforeInsert(Trigger.new);
            }
            else if(Trigger.isAfter)
            {   
                handler.AfterInsert(Trigger.new,Trigger.newMap);
            }
        }
        
        // Iterate through the records to be updated passing them to the handler.        
        if(Trigger.isUpdate)
        {
            if(Trigger.isBefore)
            {   
                handler.beforeUpdate(Trigger.new,Trigger.oldMap);
            }
            else if(Trigger.isAfter)
            {   
                handler.AfterUpdate(Trigger.new,Trigger.oldMap);
            }
        }
        
        /** T01 start **/
        // Iterate through the records to be updated passing them to the handler.
        if(Trigger.isDelete)
        {
            if(Trigger.isBefore)
            {
                handler.beforeDelete(Trigger.old);
            }
            else if(Trigger.isAfter)
            {
                handler.AfterDelete(Trigger.old);
            }
        }        
        /** T01 End **/        
    }    
    /*T03 - End*/    
}