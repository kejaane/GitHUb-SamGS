/**
 *  @Author: Acumen Solutions
 *  @Purpose: Trigger for OpportunityLineItem related processes (after insert, after update , after delete)
 */

trigger OpportunityProductProcessor on OpportunityLineItem (after insert, after update , after delete) {
    System.debug('***************Within OpportunityProductProcessor Trigger***************');
    OpportunityProcessorManager  oppManager = new OpportunityProcessorManager();

/*
 * @Purpose: Populate Opportunity Fields on OpportunityProduct Creation / Update / Delete. 
 * @Description : When OpportunityProduct inserted / updated ( Product_Sold check box or Quantity change) or deleted , 
 * Opportunity Fields - 
 *                      1.Product Offered, 
 *                      2.Product Offered Quantity , 
 *                      3.Product Sold, 
 *                      4.Product Sold Quantity  will be updated with proper value.
 * @ Method : Static populateOpportunityFieldValueForProductsSoldOrOffered() of Apex Class: OpportunityProcessorManager.cls has been implemented to hold the 
 * logic for this process. 
 *
 */
     
    Set<Id> oppIds = new Set<Id>();
    /* trigger if OpportunityProduct inserted */   
    if(trigger.isInsert){
        /* looping over the OpportunityProducts to create the set of Opportunity Ids*/
        for(OpportunityLineItem oppProduct:Trigger.new){
            oppIds.add(oppProduct.OpportunityId);
        } 
        /* Called static method populateOpportunityFieldValueForProductsSoldOrOffered() */      
        if(oppIds.size()>0){
            System.debug('Within OpportunityProductProcessor Trigger...After Insert Operation....');
            OpportunityProcessorManager.populateOpportunityFieldValueForProductsSoldOrOffered(oppIds);
        }        
    }
    /* trigger if OpportunityProduct updated */   
    if(trigger.isUpdate){
    /* looping over the OpportunityProducts to create the set of Opportunity Ids*/
    for(OpportunityLineItem oppProduct:Trigger.new){
         OpportunityLineItem beforeUpdate = Trigger.oldmap.get(oppProduct.id);
          if(beforeUpdate.Product_Sold__c != oppProduct.Product_Sold__c 
                || beforeUpdate.Quantity != oppProduct.Quantity  ){
            oppIds.add(oppProduct.OpportunityId);
          }
    }
        /* Called static method populateOpportunityFieldValueForProductsSoldOrOffered() */  
        if(oppIds.size()>0){
            System.debug('Within OpportunityProductProcessor Trigger..After Update Operation....');
            OpportunityProcessorManager.populateOpportunityFieldValueForProductsSoldOrOffered(oppIds);            
        }    
    }
    /* trigger if OpportunityProduct deleted */   
    if(trigger.isdelete){
        /* looping over the OpportunityProducts to create the set of Opportunity Ids*/
        for(OpportunityLineItem oppProduct:Trigger.old){
            oppIds.add(oppProduct.OpportunityId);
        }
        
        /* Called static method populateOpportunityFieldValueForProductsSoldOrOffered() */  
        if(oppIds.size()>0){
            System.debug('Within OpportunityProductProcessor Trigger...After Delete Operation....');
            OpportunityProcessorManager.populateOpportunityFieldValueForProductsSoldOrOffered(oppIds);
        }
    }   
    
}