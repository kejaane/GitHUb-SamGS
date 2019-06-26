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

trigger FeedItemTrigger on FeedItem (after insert) {
    new FeedItemTriggerHandler().run();
}