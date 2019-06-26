/*****************************************************************************************************
*Date: 05-25-2017 
*Developer: Satya Tirumalasetti
*Purpose: This class will be used for drawloop purpose to pull drug,vision,dental products
related to medical Product.
*=========================================================================================
* Update History
* Date         Developer    Tag           Description 
*==================================================================================
* 05-25-2017   Satya                Initial Development
*==================================================================================

*******************************************************************************************************/


//This class will be invoked from RelatedBenefitDesignProductTrigger
public class RelatedBDPTriggerHandler extends TriggerHandler {
    
    
    protected override void beforeInsert() {
        AIA_RelatedBDPTriggerHelper.updateField((List<AIA_Related_Benefit_Design_Product__c>)trigger.new);
    }
    
}