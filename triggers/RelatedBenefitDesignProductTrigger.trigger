/*****************************************************************************************************
*Date: 05-25-2017 
*Developer: Satya Tirumalasetti
*Purpose: This trigger will be called whenever a record is inserted into related Benefit Design Product.
*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
* 05-25-2017   Satya                Initial Development
*==================================================================================

*******************************************************************************************************/
//asif - rename to RelatedBenefitDesignProductTrigger
trigger RelatedBenefitDesignProductTrigger on AIA_Related_Benefit_Design_Product__c (before insert,after insert,after update) {
    new RelatedBDPTriggerHandler().run();
}