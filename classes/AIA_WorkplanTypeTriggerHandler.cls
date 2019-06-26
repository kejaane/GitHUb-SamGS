/*=========================================================================================
 * Date     : 07/22/2016
 * Developer    : Sandeep S
 * Purpose      : This class is the extension point of the Trigger Framework for adding Workplantype trigger handlers.
 *                
 *               
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 07/22/2016|  Sandeep   			|			  | Initial Version                                         
 * 10/17/2017|  Raviteja Vadapalli  |	T-01      | Commented lines as per US 209
 *===========+============+================================================================
 */
 
/*@Author: Sandeep S
* @Purpose: This class is completly for AIA- workplan type trigger framework
*/
 public with sharing class AIA_WorkplanTypeTriggerHandler extends TriggerHandler{
/*	T-01
    protected override void beforeDelete(){
     
        List<AIA_Workplan_Type__c> oldWptList=Trigger.old;
        List<AIA_Workplan_Type__c> workPlanTypeList=[select id,(select id from Opportunities__r),(select id from Implementations__r) from AIA_Workplan_Type__c where id=:oldWptList];
        
        for(AIA_Workplan_Type__c awt:workPlanTypeList){
         List<Opportunity> oppList=awt.Opportunities__r;
         List<AIA_Implementation__c> impList=awt.Implementations__r;
         Boolean flag=false;
            If(oppList!=null && oppList.size()>0){
                flag=true;
            }
            
            if(impList!=null && impList.size()>0){
                flag=true;
            }
            
            if(flag){
                If(Trigger.oldMap!=null && Trigger.oldMap.containsKey(awt.Id)){
                   AIA_Workplan_Type__c aw=(AIA_Workplan_Type__c)Trigger.oldMap.get(awt.Id);
               	   aw.addError('Error Message - In process workplan can\'t be deleted ');
                }
            }
            
        }
	
    }T-01 - end */
}