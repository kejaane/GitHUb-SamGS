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
public with sharing class AIA_RelatedBDPTriggerHelper{
    
/* @Author: Satya 
* @This method will be called from AIArbdpTrigger when any new record is inserted in Related Benefit Design Product
* @param -  list<AIA_Related_Benefit_Design_Product__c> 
* @Output - updates a field in BDP with Related plan name.
*/
    
    Public static void updateField(List<AIA_Related_Benefit_Design_Product__c> BDPList){
        
        list<AIA_Benefit_Design_Product__c> updatelist = new list<AIA_Benefit_Design_Product__c>();
        map<id,AIA_Benefit_Design_Product__c> bdmap = new map<id,AIA_Benefit_Design_Product__c>();
        set<id> bdlist = new set<id>();
        
        //Looping through all the bdp's coming from trigger
        for(AIA_Related_Benefit_Design_Product__c bp :BDPList){
            //bdmap.put(bp.Benefit_Design_Product__c,bp);
            bdlist.add(bp.Benefit_Design_Product__c);
        }
        
        map<id,AIA_Benefit_Design_Product__c> recMap = new map<id,AIA_Benefit_Design_Product__c>([select id, drawloop_product__c from AIA_Benefit_Design_Product__c where id in:bdlist]);
        
        
        for(AIA_Related_Benefit_Design_Product__c bp :BDPList){
            if(!String.isblank(bp.AIA_Related_Plan_Name__c)){
                AIA_Benefit_Design_Product__c rec = recMap.get(bp.Benefit_Design_Product__c);
                
                
                //check if the field in BDP is blank or not
                
                if(!String.isblank(rec.drawloop_product__c)){
                    //rec.drawloop_product__c= bp.AIA_Related_Plan_Name__c;
                    rec.drawloop_product__c = rec.drawloop_product__c+'\n'+ bp.Product_full_Name__c;//asif -check if full name needs to be added
                }else{
                    system.debug('outputbeforeadidng>>>>>'+rec.drawloop_product__c);
                    rec.drawloop_product__c = bp.Product_full_Name__c;
                }
                
                updatelist.add(rec);
            }
        }
        
        //check the list size, if not blank, update the list
        //asif- use list.isempty
        try{
        if(!updatelist.isEmpty()){
            update updatelist;
        }
        }catch(exception e){
            system.debug('@@ exception'+e.getMessage());
        }
    }
    
}