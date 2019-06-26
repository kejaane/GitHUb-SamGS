/*=================================================================================================
* Date         : 28/08/2017
* Developer    : Raviteja/Debkanti
* Purpose      : Group Structure Request form trigger handler
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer              Tag     Description
*===========+======================+=====+===================================================================
* 28/08/2017| Raviteja/Debkanti    |     | Initial Version
* 21/09/2017| Debkanti             | T01 | Added "gsmGSRFFieldUpdate" method to update "Processing Type" on 
*                                           newly created group structure request form.
*===========+============+=====+===================================================================
*/
public class AIA_GroupStructureTriggerHandler extends TriggerHandler  {
    public AIA_GroupStructureTriggerHandler() {}
    /* context override */
    protected override void afterInsert() {
        //Call method to create the GSP
        AIA_GroupStructureFormTriggerHelper.createGSParentProducts((list<AIA_Group_Structure_Request_Form__c>) trigger.new);
        /*T01 Start*/
        //Call the method to update "Processing Type" on new GSRF
        AIA_GSM_GSRFFieldUpdate.updateProcessingType((list<AIA_Group_Structure_Request_Form__c>) trigger.new);
        /*T01 End*/
        
         AIA_GSM_GSRFTriggerHelper.sendreqmail(trigger.new,trigger.oldMap,'insert');

    }
    
    //T02 changes-For workplan tasks
    protected override void afterUpdate() {
        
         AIA_GSM_GSRFTriggerHelper.sendreqmail(trigger.new,trigger.oldMap,'notinsert');
        AIA_GSM_GSRFHelperClass.accRejectedEmail(trigger.new,trigger.oldMap);
        AIA_GSM_GSRFHelperClass.accapprovedEmail(trigger.new,trigger.oldMap);
    }  //T02 Ends
  
   
    
    protected override void beforeUpdate() {
        AIA_GSM_GSRFTriggerHelper.parplanvalidation(trigger.new);
    	AIA_GSM_GSRFTriggerHelper.sendreqmail(trigger.new,trigger.oldMap,'notinsert');
    }
    
    protected override void beforeInsert() {
      AIA_GSM_GSRFHelperClass.numberofgsrfrecords(trigger.new);
      AIA_GSM_GSRFTriggerHelper.parplanvalidation(trigger.new);
      //AIA_GSM_GSRFTriggerHelper.sendreqmail(trigger.new,trigger.oldMap,'insert');
    }
    
}