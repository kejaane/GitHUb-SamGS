/*****************************************************************************************************
*Date: 05-20-2017 
*Developer: Satya Tirumalasetti
*Purpose: This class will be used to send email to MASAT Tech
*=========================================================================================
* Update History
* Date         Developer    Tag           Description 
*==================================================================================
* 05-20-2017   Satya                Initial Development
*==================================================================================

*******************************************************************************************************/


//This class will be invoked from IDCardTrigger 
public class IDCardTriggerHandler extends TriggerHandler {
    
    
    protected override void afterInsert() {
        AIA_IDCardTriggerHelper.sendEmail((List<ID_Card__c>)trigger.new);
    }
    protected override void afterUpdate() {
        AIA_IDCardTriggerHelper.sendEmail((List<ID_Card__c>)trigger.new);
    }
    protected override void beforeUpdate() {
        AIA_IDCardTriggerHelper.validateBeforeUpdate((List<ID_Card__c>)trigger.new,(Map<id,ID_Card__c>)trigger.oldMap,(Map<id,ID_Card__c>)trigger.newMap);
    }
    
    //validateBeforeUpdte();
    
}