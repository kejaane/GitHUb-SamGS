/*****************************************************************************************************
*Date: 24/08/2017
*Developer: Debkanti
*Purpose: Trigger is to check weather Alpha prifix value is provided or not. 
*=========================================================================================
* Update History
* Date         Developer       Version            Description
*==================================================================================
*24-08-2017    Debkanti                         Initial Development
*25-09-2017    Raviteja V      T01              Added Recursion logic
*==================================================================================

*******************************************************************************************************/
trigger AIA_GSRFProductTrigger on AIA_Group_Structure_Form_Product__c(after insert,before insert,before update,after delete,after update) {
    if(Trigger.isinsert && Trigger.isafter){
        AIA_GSM_GSRFProductCount.countofProduct(Trigger.new);
    }
     if((Trigger.isinsert && Trigger.isbefore)){
        if(!AIA_GSM_GSRFProductTriggerHandler.beforeinsertRecursive){
            AIA_GSM_GSRFProductTriggerHandler.beforeinsertRecursive=true;
            new AIA_GSM_GSRFProductTriggerHandler().run();
         }
    }
    if((Trigger.isupdate && Trigger.isbefore)){
        if(!AIA_GSM_GSRFProductTriggerHandler.beforeupdateRecursive){
            AIA_GSM_GSRFProductTriggerHandler.beforeupdateRecursive=true;
            new AIA_GSM_GSRFProductTriggerHandler().run();
         }
    }
    if((Trigger.isdelete && Trigger.isafter)){
        if(!AIA_GSM_GSRFProductTriggerHandler.afterdeleteRecursive){
            AIA_GSM_GSRFProductTriggerHandler.afterdeleteRecursive=true;
            new AIA_GSM_GSRFProductTriggerHandler().run();
         }
    }
    if(Trigger.isupdate && Trigger.isafter){
        new AIA_GSM_GSRFProductTriggerHandler().run();
    }
    
}