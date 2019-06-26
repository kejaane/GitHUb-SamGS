/*****************************************************************************************************
*Date: 03-21-2018
*Developer: Satya Tirumalasetti
*Purpose: This trigger fires when a feed is posted on the chatter enabled objects (other than User obj)
*=========================================================================================
* Update History
* Date         Developer    Tag           Description 
*==================================================================================
* 03-21-2018    Satya                Initial Development
*==================================================================================

*******************************************************************************************************/

trigger AccountTeamTrigger on Account_Team__c (after insert, after update, before insert,before update) {
    new AIA_AccountTeamTriggerHandler ().run();
}