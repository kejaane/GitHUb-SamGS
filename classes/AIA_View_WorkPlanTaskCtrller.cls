/*===================================================================================================================
* Date       : 05/14/2018
* Developer  : Phanishankar P
* Purpose    : This is the controller class for VF page "AIA_View_WorkPlanTasks" which contains the logic
*              to populate the active workplans and sort them 
*
*                                 Update History
*                                 ---------------
* Date        |     Developer        | Tag |   Description
*=================================================================================================================
* 05/14/2018  | Phanishankar P       |     | Initial Creation
*============+============+=========================================================================================*/
public without sharing class AIA_View_WorkPlanTaskCtrller {
    public List<String> workplanTasks;
    public List<Account> userAccs{get;set;}
    public List<Workplan_Task__c> userTasks{get;set;}
    public List<Workplan_Task__c> userTotalTasks{get;set;}
    public  Integer listSize;
    public String sortField{get;set;}
    public String SortFieldSave {get;set;}
    public String sortFieldLabel {get;set;}
    public String sortDirection{get;set;}
    public boolean showallTsk {get;set;}
    private String QueryTask;   
    public Integer taskCount{get;set;}
    public Integer totalTaskCount{get;set;}
    Private Integer taskCounter=0;
    public static final String inProgress = 'In Progress';
   // public static final String blocked = 'Blocked';
    public Integer limitRows = 10;
    public String userid;
    private Map<string,String> sortFieldlabelMap = new map<string,string>{'Name'=>'Task ID','Description__c' => 'Task Description', 'Opportunity__r.Name' => 'Opportunity' , 'Status__c' => 'Status','SLA_Indicator__c' => 'Due Date'};
    
    public AIA_View_WorkPlanTaskCtrller(){
        userAccs = new List<Account>();
        SortField = 'Name';
        SortDirection = 'Desc';
        SortFieldSave = sortField;
       	sortFieldLabel = sortFieldlabelMap.get(SortFieldSave);
        showallTsk = false;  
        //userId = userinfo.getUserId();
        userid = ApexPages.currentPage().getParameters().get('id');
        showallTsk = (Apexpages.currentPage().getParameters().get('showallTsk') == 'true'?true:false);
        listSize = showallTsk?50:10;
        BuildQuery(); 
    }
    //Toggle sort direction or sort field based on user click
    public void SortToggle(){
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        system.debug('sorty****'+SortField);
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
            SortFieldSave = SortField;
            sortFieldLabel = sortFieldlabelMap.get(SortFieldSave);
        }
        // run the query again
        BuildQuery();
    }
    //To build SOQL query for retrieving Workplans based on user requested sorting order
     public void BuildQuery() { 
        //String QueryWhere = '';        
         //string userid = userinfo.getUserId();         
         system.debug('sorty22****'+SortField);
         
         QueryTask = 'SELECT Id,Name,Description__c,Opportunity__c,Opportunity__r.Name,Status__c,SLA_Indicator__c FROM Workplan_Task__c WHERE OwnerId = \'';
         QueryTask = QueryTask + userid +'\' ' ;
         QueryTask = QueryTask + 'AND (Status__c = \''  + inProgress+'\')';
         QueryTask = QueryTask + ' Order by ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) ;
         userTotalTasks = (list<Workplan_Task__c>)Database.query(QueryTask);
         totalTaskCount = userTotalTasks.size();    	
             QueryTask = QueryTask + ' LIMIT '+ listSize + ' OFFSET '+ taskCounter;        
         System.debug(QueryTask);
         userTasks = (list<Workplan_Task__c>)Database.query(QueryTask);
         taskCount = userTasks.size();
         System.debug('Query Count:'+ Limits.getQueries());       
     }
    
    //Displays the next set of records
    public void nextTask(){        
        taskCounter=taskCounter+listSize;
        BuildQuery();
    }
    
    //Displays the previous set of records
    public void previousTask(){
        taskCounter=taskCounter-listSize;
        BuildQuery();
    }
       
    //Displays the first set of records irrespective of current position
    public void previousFirstTask(){
        taskCounter=0;
        BuildQuery();
    } 
    //To disable/enable previous button 
    public boolean getprev()
    {
        if(taskCounter == 0)
        return true;
        else
        return false;
    }  
    //To disable/enable next button
    public boolean getnxt()
    {
        if((taskCounter + listSize) >= totalTaskCount)
        return true;
        else
        return false;
    }   
    //For moving to last page irrespective of current page
    public void  nextLastTask(){
        if(math.mod(totalTaskCount,listSize)==0)
         taskCounter= totalTaskCount - listSize; 
        else
        taskCounter = totalTaskCount - math.mod(totalTaskCount,listSize);
        BuildQuery();
    }
	//Method useful to display all workplan tasks in a separate window
    public pageReference viewAll(){
        showallTsk = true;     
       PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        pageRef.getParameters().put('showallTsk','true');
        return pageRef;
    }      
}