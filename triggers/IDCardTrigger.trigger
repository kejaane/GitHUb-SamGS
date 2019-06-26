/*****************************************************************************************************
*Date: 05-20-2017 
*Developer: Satya Tirumalasetti
*Purpose: This trigger will be called whenever a record is inserted or updated in ID CARD Record.
*=========================================================================================
* Update History
* Date         Developer     Tag          Description
*==================================================================================
* 05-20-2017   Satya                    Initial Development
*==================================================================================

*******************************************************************************************************/

trigger IDCardTrigger on ID_Card__c (before insert,after insert,after update,before update) {
  new IDCardTriggerHandler().run();
}