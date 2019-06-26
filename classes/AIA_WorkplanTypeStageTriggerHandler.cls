/*=========================================================================================
 * Date     : 07/22/2016
 * Developer    : Sandeep S
 * Purpose      : This class is the extension point of the Trigger Framework for adding WorkPlam Type Stage trigger handlers.
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 07/22/2016|  SS    | Initial Version  
 * 10/17/2017|  Raviteja Vadapalli  |	T-01      | Commented lines as per US 209
 *===========+============+================================================================
 */
public with sharing class AIA_WorkplanTypeStageTriggerHandler extends TriggerHandler{
/*	T-01 
     protected override void beforeDelete(){
        
         List<Workplan_Type_Stage__c> oldWptList=Trigger.old;
         List<Workplan_Type_Stage__c> workPlanTypeStageList=[select id,(select id from Workplan_Type_Stage__r) from Workplan_Type_Stage__c where id=:oldWptList];
         
         for(Workplan_Type_Stage__c awt:workPlanTypeStageList){
         	List<Workplan_Stage__c > wptsList=awt.Workplan_Type_Stage__r;
            If(wptsList!=null && wptsList.size()>0){
                if(Trigger.oldMap!=null && Trigger.oldMap.containsKey(awt.Id)){
                    Workplan_Type_Stage__c wtsc= (Workplan_Type_Stage__c)Trigger.oldMap.get(awt.Id);
                     wtsc.addError('Error Message - In process workplan type stage can\'t be deleted');
                }
               
            }
         }
	
     }
    T-01 - end */
}