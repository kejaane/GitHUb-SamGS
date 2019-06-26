/*===================================================================================================================
* Date       : 4/27/2018
* Developer  : Arshia Gulati
* Purpose    : This is the controller class for VF page "AIA_Reassign Task" which contains the logic
*              to reassign the task to another team member  for US-466
*
*                                 Update History
*                                 ---------------
* Date       |     Developer       | Tag |   Description
*============+============+=========================================================================================
* 4/27/2018  | Arshia Gulati       |     | Initial Creation
* 5/14/2018  | Arshia Gulati       | T01 | Added Count of Active Tasks for each member  US1691
* 5/17/2018  | Arshia Gulati       | T02 | Authorize Sales user to re-assign task in their Group to other Team members US-366
											- Map team role to task owner field
											- Show message if tasks displayed are less than selected
* 5/24/2018  | Arshia Gulati       | T03 | Fix for null exception when task owner is MAST
* 06/18/2018 | Arshia Gulati	   | T04 | Updated for Design Change. Impl Manager should see all the roles.
*============+============+=========================================================================================*/
public without sharing class AIA_ReassignTask_Controller {
    public List<TaskWrapperCls > lstTaskWrapper {get;set;}
    public List<WorkPlan_Task__c> taskList{get;set;}
    List<WorkPlan_Task__c> tskLst = new List<WorkPlan_Task__c>();   
    public Set<String> tskIds_Selcted {get;set;}
    public Boolean displayEditPopup{get; set;} 
    public Boolean IsAuthorized{get; set;} 
    public Boolean IsIdSelected{get; set;}     
    public Boolean IsFiltered{get;set;}
    public Boolean LargeNumberSlected{get; set;} 
    public ID currentUser {get;set;}
    public Id ManagerRTId{get;set;}  
    public static final String mgrRecordType = 'Manager';
    public boolean systemAdmin{get;set;}
    public boolean isAIAAdminRoleUser{get;set;}
    private AIA_Area_Manager__c  areaMang_rec; 
    public static final String adminRole= 'AIA Admin';
    public static final String IPMRole= 'Implementation Manager';
    private List<String> areasManaged;
    public boolean IsError{get;set;}
    //T01 - Start
    public static final String InProgress = 'In Progress';
    public static final String ActiveTask = ' Active tasks';
    public Map<Id,Integer> mapUserIDToTasksCount;
    //T01 - End
    //T02 - Start
    public boolean IsSalesUser;
    public Boolean IsImpManager;
    private List<String> areaBelongsTo;    
    //T02 - End
    public AIA_ReassignTask_Controller(ApexPages.StandardSetController controller){
        displayEditPopup = false;
        LargeNumberSlected = false;
        IsError = false;
        tskIds_Selcted = new Set<String>();           
        IsImpManager = false;
        IsSalesUser = false;
        ManagerRTId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get(mgrRecordType).getRecordTypeId(); 
        
        tskLst = (WorkPlan_Task__c[])controller.getSelected();  
        if(tskLst.size()>0)
        {
            IsIdSelected = true;
            displayEditPopup = true;
            if(tskLst.size()<=50)
            {                
                for(WorkPlan_Task__c tsk :tskLst){
                tskIds_Selcted.add(tsk.id);
                }
            }else
            {
                LargeNumberSlected = true;                
                displayEditPopup = false;
            }
        }
        else
        {
             IsIdSelected = false;
             displayEditPopup = false;
        }
        
    }
    //Initialize Task List and User Map. 
    public void AIA_Tasks(){     
        CurrentUser = UserInfo.getUserId();          
        System.debug('CurrentUser'+CurrentUser);
        System.debug('managerRTId'+managerRTId);
        List<AIA_Area_Manager__c>  areaMang_recLSt = [SELECT id,Areas__c,Area_Belong_to__c,RecordTypeid
                                                      from AIA_Area_Manager__c 
                                                      where Area_Manager__c =:CurrentUser and AIA_isActive__c = TRUE 
                                                      limit 1
                                                       ];  
        areasManaged = new List<String>();
        areaBelongsTo = new List<String>();  //T02
        
        if(!areaMang_recLSt.isEmpty()){
            areaMang_rec = areaMang_recLSt[0];
            if(areaMang_rec.Areas__c != null){
            for(string rec:areaMang_rec.Areas__c.split(';'))
            {
                areasManaged.add(rec);
            }
            }
            //T02- Start
            if(areaMang_rec.Area_Belong_to__c != null){            
            for(string rec:areaMang_rec.Area_Belong_to__c.split(';'))
            {
                areaBelongsTo.add(rec);
            }            
            }
            //T02- End
            displayEditPopup = true;
        }
        if(AIA_Utils.checkIf_AIA_Admin_Profile_User() || AIA_Utils.checkIf_AIA_Admin_User()){
            systemAdmin = True;
            IsAuthorized = True;
            displayEditPopup = true;
        }
        else 
        {
            if(areaMang_rec != null){     
                if (!(areaMang_rec.Areas__c == '' || areaMang_rec.Areas__c == null))
                {
                if((areaMang_rec.Areas__c).contains(adminRole)){
                    isAIAAdminRoleUser = true;
                    displayEditPopup = true;
                    IsAuthorized = true;
                }
                }
                if (!(areaMang_rec.Area_Belong_to__c == '' || areaMang_rec.Area_Belong_to__c == null))
                    {
                        //T02-Start
                        IsSalesUser = true;
                        if ((areaMang_rec.Area_Belong_to__c).contains(IPMRole) //&& (areaMang_rec.RecordTypeid==managerRTId) //T04
                           )
                         IsImpManager = true;                                               
                        //T02-End
                    }
            }        
        }
        if(!IsIdSelected || LargeNumberSlected){
            displayEditPopup = false;
            }       
        
        if(systemAdmin == TRUE || isAIAAdminRoleUser == TRUE || (areaMang_rec != null && (IsImpManager || IsSalesUser))){  //T02
            IsAuthorized = true;
            getTaskDetails();
        } else
        {
            displayEditPopup = false;
        }
    }
    //populate task details and available team members
    public void getTaskDetails(){     
        System.debug('tskIds_Selcted'+tskIds_Selcted);
        taskList = new List<WorkPlan_Task__c>();
        lstTaskWrapper = new List<TaskWrapperCls>();
        TaskWrapperCls objTask = new TaskWrapperCls();
        Map<Id,String> MapOwnerwithrole = new Map<Id,String>();
        Map<String,Map<Id,String>> MapRolewithmember = new Map<String,Map<Id,String>>();
        Map<Id,String> userMap = new Map<Id,String>();
        Map<Id,String> TeamMemberMap = new Map<Id,String>();
        List<AIA_Area_Manager__c> areaMang_recLSt = new List<AIA_Area_Manager__c>();
        //T01-Start
        Map<Id,String> salesUsersMap = new Map<Id,String>();
        mapUserIDToTasksCount = new Map<Id,Integer>();
        Integer activeTasks = 0;        
        //T01-End
        string strRoles;
        string strAreasManaged ='';
        string strAreaBelongsTo = '';
        string query;
        for(string a:areasManaged)
        {
            if(strAreasManaged == '')
            strAreasManaged = '\''+a+'\'' ;
            else
            strAreasManaged = strAreasManaged + ',\''+a+'\'' ;
        }
        System.Debug('strAreasManaged'+strAreasManaged);
        //T02- Start
        for(string a:areaBelongsTo)
        {
            if(strAreaBelongsTo == '')
            strAreaBelongsTo = '\''+a+'\'' ;
            else
            strAreaBelongsTo = strAreaBelongsTo + ',\''+a+'\'' ;
        }
        System.Debug('strAreaBelongsTo'+strAreaBelongsTo);
        //T02- End
        taskList = [SELECT Id,Name,Description__c,Task_Owner__c,Owner.Name,OwnerId         //T02
                                  FROM WorkPlan_Task__c 
                                  where Id IN :tskIds_Selcted and Status__c = :InProgress Order by Id];  //T02
	     if(taskList.size() < tskIds_Selcted.size()) IsFiltered = true;    //T02- Show message if tasks displayed are less than selected       

        //query User area mapping object to get all users for admin role and all users that belong to the roles managed by logged-in user.
         if(systemAdmin == TRUE || isAIAAdminRoleUser == TRUE || IsImpManager)   //T04 - Added Imp Manager check       
            {
                query = 'select id,Area_Belong_to__c,Area_Manager__r.Id,Area_Manager__r.Name from AIA_Area_Manager__c WHERE AIA_isActive__c = TRUE';
            }
            else{
                //T02- Start
                //T04-Start
             	/*   if(IsImpManager){
                    	query = 'select id,Area_Belong_to__c,Area_Manager__r.Id,Area_Manager__r.Name from AIA_Area_Manager__c where Area_Belong_to__c INCLUDES (';
                		query+= strAreasManaged+','+strAreaBelongsTo+') AND AIA_isActive__c = TRUE';                	
                }
                else{
				*/
                //T04-End
                query = 'select id,Area_Belong_to__c,Area_Manager__r.Id,Area_Manager__r.Name from AIA_Area_Manager__c where Area_Belong_to__c INCLUDES (';
                query+= strAreaBelongsTo+') AND AIA_isActive__c = TRUE';               
  				// }   //T04
                //T02- End
            }
        system.debug('query '+query);
        system.debug('strRoles '+strRoles);
        
        areaMang_recLSt = Database.query(query);
        //Create a map of owner vs their corresponding roles and a map of each role vs their corresponding members
         for(AIA_Area_Manager__c areaMng : areaMang_recLSt){ 
             strRoles = areaMng.Area_Belong_to__c;
             system.debug('strRoles '+strRoles);
             if(strRoles != null){
             if(MapOwnerwithrole.keySet().contains(areaMng.Area_Manager__r.Id)){
                    strRoles = MapOwnerwithrole.get(areaMng.Area_Manager__r.Id) + ';' + strRoles;
                    MapOwnerwithrole.put(areaMng.Area_Manager__r.Id,strRoles);                    
             }
             else{                  
                  MapOwnerwithrole.put(areaMng.Area_Manager__r.Id,strRoles);  
             }
           }
             List<String> lstarea = new List<String>();
              if(areaMng.Area_Belong_to__c != null){
                  lstarea = areaMng.Area_Belong_to__c.split(';');
                  for(string area:lstarea){
                        if(MapRolewithmember.keySet().contains(area)){
                            userMap = MapRolewithmember.get(area);
                            userMap.put(areaMng.Area_Manager__r.Id,areaMng.Area_Manager__r.Name);
                            MapRolewithmember.put(area,userMap);  
                        }
                        else{
                            userMap = new Map<Id,String>();                             
                            userMap.put(areaMng.Area_Manager__r.Id,areaMng.Area_Manager__r.Name);
                            MapRolewithmember.put(area,userMap);  
                        }
                      //T01-Start
                      if(!salesUsersMap.keyset().contains(areaMng.Area_Manager__r.Id))
                          salesUsersMap.put(areaMng.Area_Manager__r.Id,areaMng.Area_Manager__r.Name);
                      //T01-End
                  }
              }
        }
        //T01-Start
         //Get the count of active tasks that each new assignee has
            for(WorkPlan_Task__c tasks :[select id, ownerId 
                                         from WorkPlan_Task__c 
                                         where ownerId IN :salesUsersMap.Keyset() and Status__c = :InProgress]){
                if(mapUserIDToTasksCount.containskey(tasks.ownerId)){
                    mapUserIDToTasksCount.put(tasks.ownerId,mapUserIDToTasksCount.get(tasks.ownerId)+1);                   
                }else {
                    mapUserIDToTasksCount.put(tasks.ownerId,1);                    
               }
            }
        //T01-End
        for(WorkPlan_Task__c tsk : taskList){ 
            objTask = new TaskWrapperCls();
            objTask.TaskId =tsk.Id;
            objTask.TaskName =tsk.Name;
            objTask.TaskDesc =tsk.Description__c;
            objTask.TaskOwner =tsk.Owner.Name;
            objTask.TeamRole = tsk.Task_Owner__c;			//T02
            System.Debug('objTask.TeamRole'+objTask.TeamRole);
            if(objTask.TeamRole != null){                
            	for(string role:objTask.TeamRole.split(';'))
            	{
                	System.Debug('MapRolewithmember'+MapRolewithmember);
                	System.Debug('role'+role);
                	TeamMemberMap = MapRolewithmember.get(role);
                	objTask.lstTeamMembers = new List<SelectOption>();
                	objTask.lstTeamMembers.add(new SelectOption('', '--Select--')); 
                    
                    if(TeamMemberMap != null){       //T03 - Start         
                	for (ID idKey : TeamMemberMap.keyset()) 
                	{
                    	String strName = TeamMemberMap.get(idKey);                    
                    	//T01-Start
                      	if(mapUserIDToTasksCount.keyset().contains(idKey)){
                        	activeTasks = mapUserIDToTasksCount.get(idKey);
                        	strName = strName + '#' + activeTasks + ActiveTask;
                      	}
                        else
                        {
                        	activeTasks = 0;
                            strName = strName + 
                                '#' + 'No' + ActiveTask;
                        }
                    	//T01-End             
                    	objTask.lstTeamMembers.Add(new SelectOption(idKey,strName));
                	}
                    }  //T03 - End
            	}
            	objTask.selected_TeamMember = (objTask.lstTeamMembers.get(0)).getValue();       
          }
          else{
              	  objTask.lstTeamMembers.add(new SelectOption('', '--Select--')); 
                  //T01-Start
                  String strName = tsk.Owner.Name;
                  if(mapUserIDToTasksCount.keyset().contains(tsk.OwnerId)){
                        activeTasks = mapUserIDToTasksCount.get(tsk.OwnerId);
                        strName = strName + '#' + activeTasks + ActiveTask;
                      }
                       else
                      {
                        activeTasks = 0;
                        strName = strName + '#' + 'No' + ActiveTask;
                      }
                    //T01-End
                  objTask.lstTeamMembers.Add(new SelectOption(tsk.OwnerId,strName));
                  objTask.selected_TeamMember = ((objTask.lstTeamMembers).get(0)).getValue();       
            }
            System.Debug('objTask'+objTask);
            lstTaskWrapper.add(objTask);
        }                
    }
    //Display List view on click of Cancel Button
    public PageReference CancelAssign() {
        
        return new ApexPages.Action('{!List}').invoke();       
    }
    //Assign task to another team member
    public PageReference AssignTask() {
        System.Debug('Inside AssignTask');
        IsError = false;
        try{
        if (taskList!=null){
            List<WorkPlan_Task__c> updated_taskList = new List<WorkPlan_Task__c>();
            for(WorkPlan_Task__c tsk : taskList){ 
                for(TaskWrapperCls wrapper:lstTaskWrapper){
                    if(tsk.Id == wrapper.TaskId){
                        System.Debug('wrapper.selected_TeamMember'+wrapper.selected_TeamMember);
                        if (wrapper.selected_TeamMember==null || wrapper.selected_TeamMember=='') {
                            IsError = true;             
                            continue;
                            }
                        else{
                        tsk.OwnerId = wrapper.selected_TeamMember;
                        updated_taskList.add(tsk);
                        }                     
                    }
                }
            }
            If(IsError) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select New Team Member for all the records'));  
                return ApexPages.currentPage();
            }
            else{
            if(updated_taskList.size() > 0)
                update updated_taskList;   
            }
        }
        }catch(Exception ex){
            System.Debug(ex.getMessage());
            IsError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));           
             return ApexPages.currentPage();
        }
        return new ApexPages.Action('{!List}').invoke();           
    }    
    //Wrapper Class to assign task details
    public class TaskWrapperCls
    {
        public Id TaskId{get;set;} 
        public string TaskName{get;set;}        
        public string TaskDesc{get;set;} 
        public String TaskOwner{get;set;} 
        public String TeamRole{get;set;}         
        public List<SelectOption> lstTeamMembers{get;set;} 
        public String selected_TeamMember{get;set;} 
        public TaskWrapperCls()
        {
            lstTeamMembers = new List<SelectOption>();             
        }       
    }
}