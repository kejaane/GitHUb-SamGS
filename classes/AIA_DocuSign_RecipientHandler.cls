/*****************************************************************************************************
*Date: 11-13-2017 
*Developer: Satya Tirumalasetti
*Purpose: This class will be called from Docusign Trigger 
*=========================================================================================
* Update History
* Date         Developer    Tag           Description 
*==================================================================================
* 11-13-2017    Satya                Initial Development
*==================================================================================

*******************************************************************************************************/


//This class will be invoked from DocuSignTrigger  
public class AIA_DocuSign_RecipientHandler extends TriggerHandler {
    
    
    protected override void afterInsert() {
        AIA_DocuSign_RecipientHelper.populateNameandEMail((List<dsfs__DocuSign_Recipient_Status__c>)trigger.new);
    }
    
    protected override void afterUpdate() {
        AIA_DocuSign_RecipientHelper.SendEmailToSubmitter((List<dsfs__DocuSign_Recipient_Status__c>)trigger.new,(Map<id,dsfs__DocuSign_Recipient_Status__c>)trigger.oldmap);
    }
   
}