/*====================================================================================================================
* Date       : 05/20/2018
* Developer  : Asif Kutagulla
* Purpose    : Extension for Visualforce page AIA_Implementation_Dashboard to show Implmentation Dashboard on the   
*              Implementation record. The VF page is added as a layout component on Implemenation lightning record page. 
*              Story:US463. This gives an Implemenation a comprehensive view of the current status of an Implementation.
*                               ========[Update History]=======
*                     -----------------------------------------------------
* Date         Developer    Tag         Description
*====================================================================================================================
* 05/20/2018 | Asif K     |     | Initial version
*====================================================================================================================*/
public without sharing class AIA_Implementation_Dashboard_Extn {
    AIA_Implementation__c aiaImpl = new AIA_Implementation__c();
    public list<Process__c> lstProcesses {get; set;}
    Static Final String TASK_NOT_GEN_ERROR = 'Tasks are not generated for this Implementation. Please click on the Start Implementation button on this page.';
    Static Final String TASK_PROCESS_COUNT_ERROR = 'Number of processes generated for this Implementation is not correct, please raise a ticket  in OneStop';
    Static Final String STATUS_COMPLETED = 'Completed';
    Static Final String STATUS_PROGRESS ='In-Progress';
    
    public AIA_Implementation_Dashboard_Extn(ApexPages.StandardController impCon) {
        system.debug('In AIA_Implementation_Dashboard_Extn constructor');
        lstProcesses = new list<Process__c>();
        aiaImpl = (AIA_Implementation__c)impCon.getrecord();
        populateProcessesList();
    }
    
    public void populateProcessesList() {
        String implID = ApexPages.currentPage().getParameters().get('Id');
        AIA_Implementation__c imp = [Select id, Status__c from AIA_Implementation__c where id=:implID];
        lstProcesses.addAll([SELECT Id, Name, Process_Name__c, Stage__c,
                                   (SELECT Name, Process__c, Active__c, Stage__c, Sub_Process_Type__c, Total_Task_Count__c,
                                           Parent_Process_Stage__c, AIA_Number_of_Completed_tasks__c, AIA_Number_of_Not_Required_Tasks__c 
                                    FROM Sub_Processes__r
                                    ORDER BY Sequence_Number__c ASC), 
                                   Active__c, Used_For__c, Status__c, Implementation__c 
                            FROM Process__c 
                            WHERE Implementation__c = :implID
                            ORDER BY Sequence_Number__c ASC NULLS LAST]);
        if(lstProcesses!=NULL && lstProcesses.isEmpty() && imp.Status__c != STATUS_COMPLETED && imp.Status__c != STATUS_PROGRESS) {
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.INFO, TASK_NOT_GEN_ERROR);
            ApexPages.addmessage(msg);
            return;
        }
        else if(lstProcesses.size()!=8 && imp.Status__c != STATUS_COMPLETED) {
            ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR, TASK_PROCESS_COUNT_ERROR);
            ApexPages.addmessage(msg);
            return;
        }
    }
}