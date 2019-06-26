/*****************************************************************************************************
*Date: 24/08/2017
*Developer: Debkanti
*Purpose: AIA_Group_Structure_Request_Form Trigger
          Create group structure products on Group structure request form creation.  
*=========================================================================================
* Update History
* Date         Developer       Version            Description
*==================================================================================
*08-24-2017    Debkanti                         Initial Development
*14-09-2017    Debkanti                         Added Trigger for AIA_GSM_GSRFFieldUpdate
*25-09-2017    Rajesh Nagandla   T01            Added Send email notification for Account Team on approved by account
*==================================================================================

*******************************************************************************************************/

trigger AIA_GroupStructureRequestFormTrigger on AIA_Group_Structure_Request_Form__c (before insert,before update,after update,after insert) {
        new AIA_GroupStructureTriggerHandler().run();
   
}