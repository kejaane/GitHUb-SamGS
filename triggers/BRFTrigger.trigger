/*=====================================================================================================
// Date: 05/31/2016
// Developer: Sree Harsha Akkala
// Purpose: BRFTrigger.
//=====================================================================================================
// 									Update History
// Date         Developer                        Description
//=====================================================================================================
// 05/31/2016 | Sree Harsha Akkala |     | Initial Development
// 07/27/2016 | Bill Dodson        | T01 | Remove recursive check logic from afterUpdate.
// 10/04/2018 | Rajesh Nagandla    | T02 | Add code related to activate/Deactivate trigger 
//                                     	   from Custom setting 'Activate Deactivate Triggers'
// 01/24/2019 | Rajesh Nagandla    | T03 | Added code to bypass triggers using Utils method  
//=====================================================================================================*/
trigger BRFTrigger on Benfit_Request_Form__c(after delete, after insert, after undelete, 
                                             after update, before delete, before insert, before update) 
{    
    /*T02 - Start*/
    if(!AIA_Utils.isTriggerBypassed('Benfit_Request_Form__c')) { //T03        
        
        //Invokes the run method in the TriggerHandler class
        if(Trigger.isUpdate && Trigger.isBefore){
            if(!AIA_BRFTriggerHandler.beforeUpdateRecursive){
                AIA_BRFTriggerHandler.beforeUpdateRecursive=true;
                new AIA_BRFTriggerHandler().run();
            }
        }
        
        if(Trigger.isUpdate && Trigger.isAfter){
            // if(!AIA_BRFTriggerHandler.AfterUpdateRecursive){     // T01, comment out
            //    AIA_BRFTriggerHandler.AfterUpdateRecursive=true;  // T01, comment out
            	new AIA_BRFTriggerHandler().run();
            //}                                                     // T01, comment out
        }
        
        if(Trigger.isInsert || Trigger.ISDelete){
            new AIA_BRFTriggerHandler().run();            
        }
        
    }
    /*T02 - End*/
}