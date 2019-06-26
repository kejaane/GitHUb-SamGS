/*=======================================================================================================
* Date         : 05/05/2018
* Developer    : Laveen Kattela
* Purpose      : This class is invoked to Start the Implementation which makes status from 
*                Not Started to In-Progress. Created this as part of US362.
*========================================================================================================
*                                 Update History
*                                 ---------------
* Date         Developer        Tag   Description
*============+================+=====+====================================================================
* 05/05/2018 | Laveen         |     | Initial version
* 06/10/2018 | Asif Kutagulla | T01 | US463. Setting Start Date
*============+================+=====+====================================================================*/  
public with sharing class AIA_StartImplementationController
{
    Static Final String IN_PROGRESS_STATUS = 'In-Progress';
    Static Final String COMPLETED_STATUS = 'Completed';
    Static Final String ID_STRING = 'id';
    
    public AIA_StartImplementationController(ApexPages.StandardController stdCon) {
        
    }
    
    //this method changes the status of Implementation to In-Progress
    public pagereference ChangeStatus()
    {
     AIA_Implementation__c am = new AIA_Implementation__c();
     am.Id = ApexPages.currentPage().getParameters().get(ID_STRING);
     
     /** T01 - Start **/
     am = [Select Id,Date_Implementation_Started__c,status__c From AIA_Implementation__c Where Id = :am.Id];
     if(am.Date_Implementation_Started__c == NULL) { am.Date_Implementation_Started__c = Date.Today(); }
     /** T01 - End **/
        if(am.status__c==COMPLETED_STATUS){
            ApexPages.Message PageMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'User cannot change the status once it is "Completed"'); 
            ApexPages.addMessage(PageMessage); 
          	return null;
        }
        
     am.Status__c = IN_PROGRESS_STATUS;
     
     update am;
   
     
     /** Call method to update Task counts on Sub Process **/
     list<Workplan_Task__c> lstWPTask = new list<Workplan_Task__c>();
     lstWPTask = [Select Id,Sub_Process__c,Status__c,SLA_Broken__c From Workplan_Task__c Where Implementation__c = :am.Id];
     if(!lstWPTask.isEmpty()) { AIA_WorkPlanController.updateSubProcessStatus(lstWPTask, new map<Id,Workplan_Task__c>(), True); }
     
     PageReference pf = new PageReference('/' + ApexPages.currentPage().getParameters().get(ID_STRING));
     pf.setRedirect(true);
     return pf;
    }
}