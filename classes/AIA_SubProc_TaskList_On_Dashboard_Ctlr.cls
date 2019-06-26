/*====================================================================================================================
* Date       : 05/20/2018
* Developer  : Asif Kutagulla
* Purpose    : Controller for Visualforce component AIA_SubProc_TaskList_On_Dashboard_Comp to show list of tasks   
*              associated with a sub-process. The component shows as a pop-up when Process hyperlink is clicked on   
*              Implementation Dashboard on the Implementation record. Story:US463
*                               ========[Update History]=======
*                     -----------------------------------------------------
* Date         Developer    Tag         Description
*====================================================================================================================
* 05/20/2018 | Asif K     |     | Initial version
* 08/02/2018 | Arshia     | T01 | Added hyperlink on Task Name and Owner Name
*====================================================================================================================*/

public without sharing class AIA_SubProc_TaskList_On_Dashboard_Ctlr {
    public list<Workplan_Task__c> lstWPtasks {get; set;}
    public String sortDirection{get;set;}
    public String SortFieldSave {get;set;}
    public String sortFieldLabel {get;set;}
    public integer get_set_execution_counter = 0;
    public String baseUrl{get;set;}       // T01
        
    private Map<string,String> sortFieldlabelMap = new map<string,string>{
                                                                          'Name'=>'Task ID',
                                                                          'Description__c' => 'Task Description', 
                                                                          'Status__c' => 'Status',
                                                                          'Owner.Name' => 'Owner',
                                                                          'Start_Date__c' => 'Start Date',
                                                                          'SLA_Indicator__c' => 'Alerts',
                                                                          'ExpectedDate__c' => 'Due Date'
                                                                         };

    /**Code for re-assigning the value to attribute-Start**/
            /** When a visualforce component is called from visualforce page and an assignTo attribute is used: **
             ** the constructor of component is evaluated before assignTo attribute & getters & setters of the  **
             ** component. so the value passed from visualforce page using assignTo attribute is always null,   **
             ** if data population methods are called from component constructor. To avoid this issue, calling  **
             ** initial data population methods inside the setter attribute of assignTo variable.               **/
    public Boolean getterSetterFlag = true;
    public String subProcessID; 
    public void setsubProcessID (String s) {
        subProcessID = s;
        if(getterSetterFlag) {
            system.debug(subProcessID); 
            //getterSetterFlag = false; Commented to resolve issue related to same sub-process & tasks showing up for click on any sub process
            lstWPtasks = new list<Workplan_Task__c>();
            if(get_set_execution_counter <= 3) {
                SortField = 'Description__c';
                SortDirection = 'ASC';
                sortFieldLabel = 'Task Description';
            }
            Build_And_Run_Query();
            get_set_execution_counter++;
        }
    }
    public String getsubProcessID() {
        return subProcessID;
    }
    
    public String sortField;
    public String setsortField(String str) {
        sortField = str;
        return sortField;
    }
    public String getsortField() {
        return sortField;
    }
    /**Code for re-assigning the value to attribute-End**/
    
    /** Constructor **/
    public AIA_SubProc_TaskList_On_Dashboard_Ctlr() {
        //getWPtaskList();
        baseUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/';  // T01
    }
    
    //Toggle sort direction or sort field based on user click
    public void SortToggle(){
        SortDirection = SortDirection.equals('ASC') ? 'DESC NULLS LAST' : 'ASC';
        system.debug('sorty****'+SortField);
        if (SortFieldSave != SortField) {
            SortDirection = 'ASC';
            SortFieldSave = SortField;
            sortFieldLabel = sortFieldlabelMap.get(SortFieldSave);
        }
        // run the query again
        Build_And_Run_Query();
    }
    
    //To build SOQL query for retrieving Workplans based on user requested sorting order
     public void Build_And_Run_Query() { 
         system.debug('SortField****'+SortField);
         system.debug('SortDirection****'+SortDirection);
         system.debug('sortFieldLabel****'+sortFieldLabel);
         system.debug('SortFieldSave****'+SortFieldSave);
         
         String taskQuery;
         taskQuery = 'SELECT Id, SLA_Broken__c, SLA_Indicator__c, Stage__c, Status__c, Start_Date__c, ExpectedDate__c, Name, '+
                             'Sub_Process__r.Percent_Complete__c,Sub_Process__r.Total_Task_Count__c,Sub_Process__r.Process__r.Name, '+
                             'Sub_Process__r.AIA_Number_of_Completed_tasks__c, Sub_Process__r.AIA_Number_of_Not_Required_Tasks__c, '+
                             'Sub_Process__r.Stage__c,Sub_Process__r.Process__r.Implementation__r.Name,Description__c,Owner.Name, '+
                             'Sub_Process__r.Number_of_Blocked_Tasks__c, Sub_Process__r.Number_of_Tasks_SLA_Broken__c, '+
                             'Sub_Process__r.Process__r.Stage__c '+
                      'FROM Workplan_Task__c ';
         taskQuery = taskQuery + 'WHERE Sub_Process__c = '+ '\'' + subProcessID + '\'';
         taskQuery = taskQuery + ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) ;
         System.debug(taskQuery);
         lstWPtasks = (list<Workplan_Task__c>)Database.query(taskQuery);
         System.debug('Query Count:'+ Limits.getQueries()); 
     }
     
     //Method to redirect page to custom task creation page
     public PageReference RedirectToCustomTaskPage() {
         String ImplementationID = ApexPages.currentPage().getParameters().get('Id');
         system.debug('inside AIA_SubProc_TaskList_On_Dashboard_Ctlr = '+ImplementationID);
         PageReference pgRef = new PageReference('/apex/AIA_CreateCustomTask_Dashboard?ImplementationID='+ImplementationID+'&SubProcID='+subProcessID);
         pgRef.setRedirect(true);
         return pgRef;
     }
    
}

/***References****
 * https://salesforce.stackexchange.com/questions/69279/order-of-execution-for-visualforce-page-get-requests *
 * 
 ***/