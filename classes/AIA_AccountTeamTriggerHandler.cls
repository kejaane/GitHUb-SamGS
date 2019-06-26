/***********************************************************************************************************
*Date: 02-04-2019
*Developer: Satya Tirumalasetti
*Purpose: This class will be called from Account Team Trigger Trigger when a feed is posted to chatter enabled object.
*=========================================================================================================
* Update History
* Date         Developer    Tag           Description 
*========================================================================================================
* 02-04-2019    Satya                Initial Development
*==========================================================================================================

*************************************************************************************************************/


public class AIA_AccountTeamTriggerHandler extends TriggerHandler {
    
    
    protected override void afterInsert() {
        AIA_AccountTeam_TriggerHelper.populateAccountRoles((List<Account_Team__c>)trigger.new);
    }
    
    protected override void afterUpdate() {
        AIA_AccountTeam_TriggerHelper.populateAccountRoles((List<Account_Team__c>)trigger.new);
    }
    
    
   
}