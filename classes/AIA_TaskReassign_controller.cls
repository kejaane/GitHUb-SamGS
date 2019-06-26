/*==========================================================================================================
* Date         : 04/30/2018
* Developer    : satya Tirumalasetti
* Purpose      : This class is used for reassigning the workplan tasks to other users of same area. Done as
*                part of US366.
*===========================================================================================================
*                                 Update History
*                                 ---------------
* Date      | Developer  | Tag  | Description
*===========+============+======+===========================================================================
* 04/30/2018| satya      |      | Initial Version 
* 09/19/2018| Phani/Raj  | T01  | Added without sharing
*===========+============+======+===========================================================================
*/

public without sharing class AIA_TaskReassign_controller {

    
    List<Workplan_Task__c> taskList = new List<Workplan_Task__c>();
    public Set<String> selctedtsIds = new Set<String>();
    List<Workplan_Task__c> taskListRec = new List<Workplan_Task__c>(); 
    public static final String InProgress = 'In Progress';
    public static final String ActiveTask = ' Active tasks';
    public boolean IsIdsSlected{get;set;}
    public boolean IsError{get;set;}
    public String errorMessage{get;set;}
    public List<TaskWrapperCls> lstTaskWrapper {get;set;}
    public AIA_TaskReassign_controller(ApexPages.StandardSetController controller) {
                 
                taskList = (WorkPlan_Task__c[])controller.getSelected(); 
                lstTaskWrapper = new List<TaskWrapperCls>();
                Set<String> currentTaskOwners = new Set<String>(); 
                IsIdsSlected = false;
                IsError = false;
                errorMessage = '';
                for(WorkPlan_Task__c tsk :taskList){
                     selctedtsIds.add(tsk.id);
                 }
                 
                 //If user selects the workplan tasks to reassign, proceed with the process
                 if(selctedtsIds.size()>0)
                 {
                    IsIdsSlected = true;
                 
                   string taskroles = '';
             
             
             //Get the account team roles from the records in context and form an string to be used in dynamic query
             for(WorkPlan_Task__c tskNewLst : [select id,name,Task_Owner__c,OwnerId,Owner.Name,Description__c 
                                              from WorkPlan_Task__c 
                                              where id=:selctedtsIds])
             {
                taskListRec.add(tskNewLst);
                currentTaskOwners.add(tskNewLst.Task_Owner__c);
                if(taskroles == '')
                    taskroles = '\'' + tskNewLst.Task_Owner__c + '\'';
                else
                    taskroles = taskroles + ' , ' + '\'' + tskNewLst.Task_Owner__c + '\'';
             }
             
             
            system.debug('currentTaskOwners>>'+currentTaskOwners); 
            system.debug('taskroles>>'+taskroles); 
            
            //Form a dynamic query using the string created above and get the list of AIA Mapping object
            string query = 'SELECT id,Areas__c,Area_Belong_to__c,Area_Manager__c,OwnerId,Area_Manager__r.Name from AIA_Area_Manager__c where Area_Belong_to__c INCLUDES (' + taskroles + ')';         
            List<AIA_Area_Manager__c>  areaMang_recLSt =(List<AIA_Area_Manager__c>)Database.query(query);
            system.debug('areaMang_recLSt>>>' + areaMang_recLSt);
            Map<String,Set<String>> mapAreaToUserId = new map<String,Set<String>>();
            Map<String,String> mapUserIDToUserName = new map<String,String>();
            Map<String,integer> mapUserIDToTasksCount = new map<String,integer>();
            
            //For each of the AIA Mapping record, compare if the roles we got from workplan task record exist in the area_belongs to field
            for(AIA_Area_Manager__c areaManager : areaMang_recLSt)
            {
                for(String str: currentTaskOwners)
                {
                   string aManager = areaManager.Area_Belong_to__c;
                   
                   //if the role exists in the user area belongs to field, put them in the maps 
                    if(aManager.indexOf(str) > -1)
                    {
                        if(mapAreaToUserId.containskey(str))
                        {
                            mapAreaToUserId.get(str).add(areaManager.Area_Manager__c);
                        }
                        else
                        {
                            mapAreaToUserId.put(str,new set<string>{areaManager.Area_Manager__c});
                        }
                        mapUserIDToUserName.put(areaManager.Area_Manager__c,areaManager.Area_Manager__r.Name);
                        break;
                    }
                    
                }
                
            }
            
            //Get the count of active tasks that each new assignee has, to dispaly to the assigner
            for(WorkPlan_Task__c tasks :[select id, ownerId 
                                         from WorkPlan_Task__c 
                                         where ownerId IN :mapUserIDToUserName.Keyset() and Status__c = :InProgress]){
                if(mapUserIDToTasksCount.containskey(tasks.ownerId)){
                    mapUserIDToTasksCount.put(tasks.ownerId,mapUserIDToTasksCount.get(tasks.ownerId)+1);
                }else {
                    mapUserIDToTasksCount.put(tasks.ownerId,1);
                }
            }
            system.debug('mapUserIDToUserName>>>' + mapUserIDToUserName);
            
            //For each of the worplan task rec in context, generate a dynamic piclist values of users based on the Account team role of the task 
            for(WorkPlan_Task__c tskNewLst : taskListRec){
               List<Selectoption> TeamRole = new List<Selectoption>();
                if(mapAreaToUserId.containskey(tskNewLst.Task_Owner__c))
                {
                    set<String> lstStr = mapAreaToUserId.get(tskNewLst.Task_Owner__c);
                    TeamRole.add(new SelectOption('', '--None--'));
                   
                   //prepare the list of picklist dropdown values
                    for(String str:lstStr){
                        Integer activetasks = 0;
                        if(mapUserIDToTasksCount.containskey(str) && mapUserIDToTasksCount.get(str) != null)
                            activetasks = mapUserIDToTasksCount.get(str);
                        if(str != tskNewLst.OwnerId)
                            TeamRole.add(new SelectOption(str, mapUserIDToUserName.get(str)+'#'+activetasks +' '+ActiveTask));
                    }      
                
                }
                TaskWrapperCls taskWraper = new TaskWrapperCls(tskNewLst.Name,tskNewLst.description__c,TeamRole,tskNewLst.Task_Owner__c,tskNewLst,tskNewLst.Owner.Name);              
                lstTaskWrapper.add(taskWraper);
             }
             }
    }
    
    
    //Method to save the workplan tasks record after updating the ownerfield
    public PageReference SaveWorkPlanTask(){
        List<Workplan_Task__c> lstWPTask = new List<Workplan_Task__c>();
        boolean isSave = true;
        for(TaskWrapperCls taskWraper:lstTaskWrapper)
        {
            //Check if the new user is selected 
            if(taskWraper.SelectedTeamMember == '' || taskWraper.SelectedTeamMember == null)
            {
                isSave = false;
                IsError = true;             
                continue;
            }
            //Assign the user to task selected from UI
            taskWraper.WPtask.OwnerId = taskWraper.SelectedTeamMember;
            lstWPTask.add(taskWraper.WPtask);
        }
        
        //update the tasks list
        if(isSave){
            if(!lstWPTask.isEmpty()){
                update lstWPTask;
             }  
        }else 
            return null;
        
        //Redirect the user back to list view page
        return new ApexPages.Action('{!List}').invoke();    
    }
    
    //method to redirect user back to List View page on cancel
    public PageReference CancelWorkPlanTask(){
        //Redirect the user back to list view page       
       return new ApexPages.Action('{!List}').invoke();    
    }
    
    
    //wrapper class to hold the workplan task record values and the user selected values
    public class TaskWrapperCls
    {
        public string TaskName{get;set;}        
        public string TaskDesc{get;set;}
        public string TaskRole{get;set;}
        public string CurrentOwnerName{get;set;}
        public string SelectedTeamMember{get;set;}
        public Workplan_Task__c WPtask{get;set;}      
        public List<Selectoption> TeamRoles{get;set;}
        public TaskWrapperCls(String tskName,String tskDesc,List<Selectoption> TeamRl,string tskRole,Workplan_Task__c taskObj,string CntName)
        {
            this.TaskName = tskName;
            this.TaskDesc = tskDesc;
            this.TeamRoles = TeamRl;
            this.TaskRole = tskRole;
            this.WPtask = taskObj;
            this.CurrentOwnerName = CntName;
            this.SelectedTeamMember = taskObj.OwnerId;
        }
    }

}