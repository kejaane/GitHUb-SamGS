/***********************************************************************************************************
*Date: 03-21-2018
*Developer: Satya Tirumalasetti
*Purpose: This class will be called from FeedItem Trigger when a feed is posted to chatter enabled object.
*=========================================================================================================
* Update History
* Date         Developer    Tag           Description 
*========================================================================================================
* 03-21-2018    Satya                Initial Development
*==========================================================================================================

*************************************************************************************************************/


public class FeedItemTriggerHandler extends TriggerHandler {
    
    
    protected override void afterInsert() {
        AIA_FeedItem_TriggerHelper.postChatterFeed((List<FeedItem>)trigger.new);
    }
    
    
   
}