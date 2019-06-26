/*==========================================================================================================
* Date         : 04/26/2018 
* Developer    : Gayathri Palanisamy
* Purpose      : This class is a helper class for SubProcessTriggerHandler with methods for various 
*                functionalities
*===========================================================================================================
*                                 Update History
*                                 ---------------
* Date      | Developer  | Tag  | Description
*===========+============+======+===========================================================================
* 04/26/2018| Gayathri P |      | Initial Version                                         
* 10/21/2018| Gayathri P | T01  | Method 'updateImpFields' is added as part of US5425 to update 'AIA BD Not 
								  Required' or 'AIA GS Not Required' fields in Implementation when 'Benefit 
								  Design' or 'Group Structure' sub process is marked as Not Required. 
*===========+============+======+===========================================================================
*/
public with sharing class AIA_SubProcessTriggerHelper {
    /*T01 -- Start*/
    public static String NOT_REQUIRED = 'Not Required';
    
    /*T01 -- End */
	AIA_Utils errLogExp = new AIA_Utils();
    public void updateActualSLA(List<Sub_Process__c> subProcessLst)
    {
      try{
        List<Sub_Process__c> recordsToUpdate = new  List<Sub_Process__c>();
        for(Sub_Process__c subPro : subProcessLst){
            if(subPro.Status__c == AIA_Constants.COMPLETED_STATUS){
                //T02 -- Start Adding condition to check SLA day type
                if(subPro.SLA_Day_Type__c == AIA_Constants.CALENDER_TYPE)
                	subPro.Actual_SLA__c = subPro.AIA_Sub_Process_Start_date__c.daysBetween(subPro.AIA_Sub_Process_End_Date__c) ;
                 else
                    subPro.Actual_SLA__c = AIA_CalculateDaysDiffExcludingHoliday.CalculateWorkingDays(subPro.AIA_Sub_Process_Start_date__c, subPro.AIA_Sub_Process_End_Date__c);
                recordsToUpdate.add(subPro);
               
            }
        }
        }
        catch(Exception e)
        {
          System.debug('MainERROR:' + e);
          errLogExp.logException(e);
             
        }
        //T02 End
          
    }
    
    /*T01 -- Start*/
    Public void updateImpFields(List<Sub_Process__c> newSubProc , Map<Id,Sub_Process__c> oldMap)
    {
     system.debug('Inside Update Imp Fields method helper sp Method');
     Map<Id,Boolean> bdRequired = new Map<Id,Boolean>();
     Map<Id,Boolean> gsRequired = new Map<Id,Boolean>();
     Set<Id> impIds = new Set<Id>();
     List<AIA_Implementation__c> recordsToUpdate = new List<AIA_Implementation__c>();
     
    /*Loop through all the updated subprocess to get the Implementation Id's for 
      the Benefit Design and Group Structure sub process that are changed to 
	  Not-started or In Progress status from 
      not-required status or that are marked as Not Required.*/
     for(Sub_Process__c sub:newSubProc) 
     {
         
         if(sub.Stage__c == AIA_Constants.BENEFIT_DESIGN_DOC)//Benefit Design Sub Process
         {
             if(sub.Status__c == NOT_REQUIRED && oldMap.get(sub.Id).status__c != NOT_REQUIRED)
             {
                 bdRequired.put(sub.Implementation__c,true);
                 impIds.add(sub.Implementation__c);
             }
             else if(sub.Status__c != NOT_REQUIRED && oldMap.get(sub.Id).status__c == NOT_REQUIRED)
             {
                 bdRequired.put(sub.Implementation__c,false);
                 impIds.add(sub.Implementation__c);
             }
         }
     
     if(sub.Stage__c == AIA_Constants.GROUP_STRUCTURE) // Group Structure Sub Process
         {
             if(sub.Status__c == NOT_REQUIRED && oldMap.get(sub.Id).status__c != NOT_REQUIRED)
             {
                 gsRequired.put(sub.Implementation__c,true);
                 impIds.add(sub.Implementation__c);
             }
             
             else if(sub.Status__c != NOT_REQUIRED && oldMap.get(sub.Id).status__c == NOT_REQUIRED)
             {
                 gsRequired.put(sub.Implementation__c,false);
                 impIds.add(sub.Implementation__c);
             }
         }
    }
        
        //Loop through the Implementations to update BD Not Required and GS Not Required Fields
        for(AIA_Implementation__c imp:[Select id,AIA_BD_Not_Required__c,AIA_GS_Doc_Not_Required__c
                                      from AIA_Implementation__c where Id In:impIds])
        {
            if(bdRequired.containsKey(imp.Id) && bdRequired.get(imp.Id) != null)
            {
               imp.AIA_BD_Not_Required__c = bdRequired.get(imp.Id);
                recordsToUpdate.add(imp);
            }
            if(gsRequired.containsKey(imp.Id) && gsRequired.get(imp.Id) != null)
            {
               imp.AIA_GS_Doc_Not_Required__c = gsRequired.get(imp.Id); 
               recordsToUpdate.add(imp);
            }
        }
        if(recordsToUpdate.size()>0)
        {
            try{
                system.debug('Inside Update Workplan Task Status Method update call');
                update recordsToUpdate;
            }
            catch(Exception exp)
            {
              	System.debug('MainERROR:' + exp);
          		errLogExp.logException(exp);  
            }
        }
    }
    /*T01 -- End */
}