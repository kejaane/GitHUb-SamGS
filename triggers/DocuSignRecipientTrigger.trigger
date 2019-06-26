/*****************************************************************************************************
*Date: 11-13-2017  
*Developer: Satya Tirumalasetti
*Purpose: This trigger will be called whenever a record is inserted DocuSign Recipient Record.
*=========================================================================================
* Update History
* Date         Developer     Tag          Description
*==================================================================================
* 11-13-2017    Satya                    Initial Development
*==================================================================================

*******************************************************************************************************/

trigger DocuSignRecipientTrigger on dsfs__DocuSign_Recipient_Status__c(after insert, after Update) {
     new AIA_DocuSign_RecipientHandler().run();
}