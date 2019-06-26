/*===================================================================================================================
 * Date       : 4/19/2018
 * Developer  : Arshia Gulati
 * Purpose    : This is the controller class to Create Custom Task US-890
 *
 *                                 Update History
 *                                 ---------------
 * Date         Developer   Tag         Description
 *===================================================================================================================
 * 04/19/2018 | Arshia    | T01 | This class is used to Create Custom Task on Implementation record.
 * 05/03/2018 | Gayathri  | T02 | Updated the controller for creating custom task in BRF as part of US228.
 * 05/07/2018 | Arshia    | T03 | Updated to populate Team Role and corresponding Team Members in dropdown for US1790
 * 05/11/2018 | Arshia    | T04 | Updated to populate number of active task for each Team Member US1691
 * 06/05/2018 | Arshia    | T05 | Updated to populate SLA Days based on Due Date US890 enhancement
 * 06/11/2018 | Asif K    | T06 | Added changes for US463.Replaced impl.ID to ImplementationID.
 * 06/18/2018 | Arshia    | T07 | Updated for Design Change. Impl Manager should see all the roles.
 * 03/27/2019 | Naga. K   | T08 | Changed reference from standard object to custom object
 *===================================================================================================================
*/
public without sharing class AIA_Custom_Task_Controller {
    public String slSubProcess{get; set;}
    public String reSubProcess{get; set;}
    List<Sub_Process__c> SubProcessList = new List<Sub_Process__c>();
    List<SelectOption> lstSubProcess;
    public Workplan_Task__c objTask{get; set;}
    public boolean isClassic{get; set;}
    public AIA_Implementation__c objImpl {get;set;}      
    public string strDueDate{get;set;}          //T05
    public string daytype{get;set;}
    final string DAYTYPE_BUSINESS = 'Business';
    final string DAYTYPE_CALENDAR = 'Calendar';     
    // T03 - Start
    public List<SelectOption> TeamRoleList {get; set;}            
    public List<SelectOption> TeamMemberList {get; set;}   
    static final String MGRRECORDTYPE = 'Manager';
    public string selected_TeamRole{get;set;} 
    public string selected_TeamMember{get;set;}     
    static final String ADMINROLE= 'AIA Admin';
    Boolean systemAdmin,isAIAAdminRoleUser,IsImpManager; //T07 
    public Boolean IsAuthorized{get;set;}      
    Map<String,Map<Id,String>> MapRolewithmember;
    static final string USED_FOR = 'Post-Sales';    
    static final String IPMROLE = 'Implementation Manager';   
    // T03 - End
    //T04 - Start
    static final String INPROGRESS = 'In Progress';
    static final String ACTIVETASK = ' Active tasks';
    public Map<Id,Integer> mapUserIDToTasksCount;
    //T04 - End
    //T02 Start
    string brfId;
    public string returnURL{get;set;}
    public Benfit_Request_Form__c brfRec{get;set;}
    
    String ImplementationID = ''; //T06
    String SubProcID = ''; //T06
    
    /* T02 -- Added a default constructor as part of US228*/
    public AIA_Custom_Task_Controller(){
        isClassic = AIA_Utils.isClassic();
        //Assigning the related record id from URL
        brfId = ApexPages.currentPage().getParameters().get('brfid');
        System.debug('inside standard controller constructor BRF.Id--'+brfId);
        objTask = new Workplan_Task__c();
        //Querying the related record details with respect the source
        if(brfId!=null)
        {
            brfRec = [select id,name,Opportunity__c from Benfit_Request_Form__c where id =: brfId];
            SubProcessList = [select Id,Process__c,Sequence_Number__c,Stage__c,Opportunity__c 
                          from Sub_Process__c 
                          where Used_For__c =:USED_FOR AND Opportunity__c =:brfRec.Opportunity__c order by Sequence_Number__c];
            returnURL = brfRec.Id;
            lstSubProcess = new List<SelectOption>();            
            for(Sub_Process__c temp : SubProcessList)
            {        
                lstSubProcess.add(new SelectOption(temp.Id,temp.Stage__c));                
            } 
            if(lstSubProcess.size() > 0)
                reSubProcess = (lstSubProcess.get(0)).getValue();
      
        
            daytype=DAYTYPE_BUSINESS;
        }
                
        
    } 
    //T02 End
    public AIA_Custom_Task_Controller(ApexPages.StandardController controller){
      objImpl = (AIA_Implementation__c) controller.getRecord();       
      isClassic = AIA_Utils.isClassic(); 
      
      //T06 - Start - Added ImplementationID & subProcID
      System.debug('inside standard controller constructor Impl.Id--'+objImpl.Id);
      if(String.isBlank(objImpl.Id)) {
          ImplementationID = ApexPages.currentPage().getParameters().get('ImplementationID');     
          SubProcID = ApexPages.currentPage().getParameters().get('SubProcID');          
      } else {
          ImplementationID = objImpl.Id;
      }
      System.debug('inside standard controller constructor ImplementationID--'+ImplementationID);
      System.debug('inside standard controller constructor subProcID--'+subProcID);
      //T06 - Start - Added ImplementationID & subProcID

      //get the implementation record in context
      objImpl = [select id,Account__c,Benefit_Request_Form__c,Opportunity__c,Benefit_Request_Form__r.Account_Executive_Account_Team__c,Benefit_Request_Form__r.Account_Manager_Account_Team__c,
                    Benefit_Request_Form__r.Implementation_Manager_Account_Team__c, Benefit_Request_Form__r.Opportunity_Type__c,Docusign_Document_sending_user__c
                 from AIA_Implementation__c 
                 where id =:ImplementationID ];
        returnURL = ImplementationID;
        objTask = new Workplan_Task__c();               
         System.debug('inside standard controller check1');
        SubProcessList = [select Id,Process__c,Sequence_Number__c,Stage__c 
                          from Sub_Process__c 
                          where Used_For__c = :USED_FOR and Implementation__c =:ImplementationID order by Sequence_Number__c]; 
            
          lstSubProcess = new List<SelectOption>();  
            for(Sub_Process__c temp : SubProcessList)
            {        
                lstSubProcess.add(new SelectOption(temp.Id,temp.Stage__c)); 
                if(String.isNotBlank(SubProcID) && SubProcID==temp.Id) { slSubprocess = temp.Id; } //T06
            } 
        if(lstSubProcess.size() > 0)
                reSubProcess = (lstSubProcess.get(0)).getValue();
      
        daytype=DAYTYPE_BUSINESS;      
      
        // T03 - Start
        AssignTeamMember();
        // T03 - End
    }
    
   //This method will check current user permissions and populate roles and members accordingly
    public Void AssignTeamMember(){
        Id CurrentUser = UserInfo.getUserId(); 
        Id ManagerRTId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get(MGRRECORDTYPE).getRecordTypeId(); 
        IsAuthorized = false;
        string strAreasManaged='';
        IsImpManager = false;
        AIA_Area_Manager__c  areaMang_rec = new AIA_Area_Manager__c();
        List<AIA_Area_Manager__c>  areaMang_recLSt = [SELECT id,Areas__c,Area_Belong_to__c
                                                      from AIA_Area_Manager__c 
                                                      where Area_Manager__c =:CurrentUser //and RecordTypeid=:managerRTId //T07
                                                      and AIA_isActive__c = TRUE limit 1
                                                       ];  
        
        List<String> areasManaged = new List<String>();
         if(!areaMang_recLSt.isEmpty()){
            areaMang_rec = areaMang_recLSt[0];
             //T07-Start - Added null check
             if(areaMang_rec.Areas__c != null){
            for(string rec:areaMang_rec.Areas__c.split(';'))
            {
                areasManaged.add(rec);
            }
             } 
             //T07-End
            for(string a:areasManaged)
            {
             if(strAreasManaged == '')
                strAreasManaged = '\''+a+'\'' ;
             else
                strAreasManaged = strAreasManaged + ',\''+a+'\'' ;
            }
         }        
        if(AIA_Utils.checkIf_AIA_Admin_Profile_User() || AIA_Utils.checkIf_AIA_Admin_User()){
            systemAdmin = True;
        }
        else 
        {
            if(areaMang_rec != null){     
               if (!(areaMang_rec.Area_Belong_to__c == '' || areaMang_rec.Area_Belong_to__c == null))
                    {
                        if ((areaMang_rec.Area_Belong_to__c).contains(IPMROLE))
                        {
                            IsImpManager = true;
                        }
                        if((areaMang_rec.Area_Belong_to__c).contains(ADMINROLE)){
                            isAIAAdminRoleUser = true;
                         }
                    }
            }
        }
         System.debug('IsImpManager'+IsImpManager);
        if(systemAdmin == TRUE || isAIAAdminRoleUser == TRUE || (areaMang_rec != null && IsImpManager)){
            IsAuthorized = true;
            populateRoles(areaMang_rec);          
            populateMembers(strAreasManaged);
        }        
    }
    //This method will populate Team members that belong to the area managed by current user
    public void populateMembers(string strAreasManaged){
        string query;
        MapRolewithmember = new Map<String,Map<Id,String>>();
        Map<Id,String> userMap = new Map<Id,String>();
        Map<Id,String> TeamMemberMap = new Map<Id,String>();
        //T04-Start
        Map<Id,String> salesUsersMap = new Map<Id,String>();
        mapUserIDToTasksCount = new Map<Id,Integer>();
        //T04-End
       System.debug('IsImpManager'+IsImpManager);
         if(systemAdmin == TRUE || isAIAAdminRoleUser == TRUE || IsImpManager)      //T07   
            {
                query = 'select id,Area_Belong_to__c,Area_Manager__r.Id,Area_Manager__r.Name from AIA_Area_Manager__c WHERE AIA_isActive__c = TRUE';
            }
        //T07-Start
         /*   else{
                query = 'select id,Area_Belong_to__c,Area_Manager__r.Id,Area_Manager__r.Name from AIA_Area_Manager__c where Area_Belong_to__c INCLUDES (';
                query+= strAreasManaged+') AND AIA_isActive__c = TRUE';
            }
        */
        //T07-End
        System.Debug('query: '+query);
        System.Debug('strAreasManaged: '+strAreasManaged);
        List<AIA_Area_Manager__c>  areaMang_recLSt = Database.query(query);
        System.Debug('areaMang_recLSt: '+areaMang_recLSt);          
        for(AIA_Area_Manager__c areaMng:areaMang_recLSt){
             List<String> lstarea = new List<String>();
              if(areaMng.Area_Belong_to__c != null){
                  lstarea = areaMng.Area_Belong_to__c.split(';');
                  for(string area:lstarea){
                        if(MapRolewithmember.keySet().contains(area)){
                            userMap = MapRolewithmember.get(area);
                            userMap.put(areaMng.Area_Manager__r.Id,areaMng.Area_Manager__r.Name);
                            MapRolewithmember.put(area,userMap);  
                            System.Debug('userMap'+userMap);
                            System.Debug('MapRolewithmember'+MapRolewithmember);
                        }
                        else{
                            userMap = new Map<Id,String>();
                            userMap.put(areaMng.Area_Manager__r.Id,areaMng.Area_Manager__r.Name);
                            MapRolewithmember.put(area,userMap);  
                            System.Debug('userMap'+userMap);
                            System.Debug('MapRolewithmember'+MapRolewithmember);
                         }
                      //T04-Start
                      if(!salesUsersMap.keyset().contains(areaMng.Area_Manager__r.Id))
                          salesUsersMap.put(areaMng.Area_Manager__r.Id,areaMng.Area_Manager__r.Name);
                      //T04-End
                     }
                 }            
            }
        TeamMemberList = new List<SelectOption>();
        TeamMemberList.add(new SelectOption('', '--Select--')); 
        selected_TeamMember = (TeamMemberList.get(0)).getValue(); 
        
        //T04-Start
         //Get the count of active tasks that each new assignee has, to dispaly to the assigner
            for(WorkPlan_Task__c tasks :[select id, ownerId 
                                         from WorkPlan_Task__c 
                                         where ownerId IN :salesUsersMap.Keyset() and Status__c = :INPROGRESS]){
                if(mapUserIDToTasksCount.containskey(tasks.ownerId)){
                    mapUserIDToTasksCount.put(tasks.ownerId,mapUserIDToTasksCount.get(tasks.ownerId)+1);                   
                }else {
                    mapUserIDToTasksCount.put(tasks.ownerId,1);                    
               }
            }
        //T04-End
    }
    //To populate the roles depending on the login user (AIA Admin/System Admin/Manager)
    //This method will populate Team Roles managed by current user
    public void populateRoles(AIA_Area_Manager__c areaMang_rec){
        System.Debug('Inside populateRoles');
         List<String> allowedRolesList = new List<String>();
        TeamRoleList = new List<SelectOption>();
        TeamRoleList.add(new SelectOption('', '--Select--'));           
        //Get roles if user is System Admin/ AIA Admin
        if((systemAdmin == True || isAIAAdminRoleUser == True || IsImpManager)){        //T07
            System.Debug('Inside systemAdmin');
            //Schema.DescribeFieldResult fieldResult = Accountteammember.TeamMemberRole.getDescribe(); T08
            Schema.DescribeFieldResult fieldResult = Account_Team__c.TeamMemberRole__c.getDescribe(); //T08
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry pickListEntry : ple){     
                allowedRolesList.add(pickListEntry.getValue());                        
            }           
        }
        //Get roles if user is Area Manager
        /*  T07 - Else will never execute
        else{       
            System.Debug('Inside else');
            allowedRolesList = getRoles(areaMang_rec); 
        } 
        */
        System.Debug('Inside allowedRolesList : ' + allowedRolesList);
        for(String s : allowedRolesList){            
            TeamRoleList.add(new SelectOption(s,s));             
        }
        System.Debug('TeamRoleList : ' + TeamRoleList);
        selected_TeamRole = (TeamRoleList.get(0)).getValue();
        System.Debug('selected_TeamRole : ' + selected_TeamRole);
    }
    //This method return list of areas managed by current user
    /* T07-Start
    public List<String> getRoles(AIA_Area_Manager__c userMapping){
        List<String> areas = new List<String>();       
        if(userMapping != NULL){
            String Area = userMapping.Areas__c;
            areas = Area.split(';');
        }
        return areas; 
    }   
    */ //T07-End
    //This method will populate team members according to the team role selected
     public Void SelectTeamMember(){
        Map<Id,String> TeamMemberMap = new Map<Id,String>();
        System.debug('selected_TeamRole : '+ selected_TeamRole);
        TeamMemberMap = MapRolewithmember.get(selected_TeamRole);
        System.debug('TeamMemberMap : '+ TeamMemberMap);
        String strName;
        Integer activeTasks = 0;        //T04
        TeamMemberList.clear();
        TeamMemberList.add(new SelectOption('', '--Select--')); 
        if(TeamMemberMap != null){
         for (ID idKey : TeamMemberMap.keyset()) 
         {
             //T04-Start
             if(mapUserIDToTasksCount.keyset().contains(idKey)){
                 activeTasks = mapUserIDToTasksCount.get(idKey);
                  strName = TeamMemberMap.get(idKey) + '#' + activeTasks + ACTIVETASK;
                 System.Debug('318 : activeTasks '+activeTasks);
             }
             else
             {
                 activeTasks = 0;
                    strName = TeamMemberMap.get(idKey) + '#' + 'No' + ACTIVETASK;
                 System.Debug('324 : activeTasks '+activeTasks);
             }
             //T04-End
                    TeamMemberList.Add(new SelectOption(idKey,strName));
        }
        }
        selected_TeamMember = (TeamMemberList.get(0)).getValue();
    }
    // T03 - End    
    //This method calculate SLA days based on the Day Type
    //T05 - Start
    public void SetDueDate(){
        if(daytype == null || objTask.Total_Days_to_Complete_Task_SLA__c == null) return;
        Date dt = System.today();
        if(daytype==DAYTYPE_CALENDAR){
            strDueDate = String.valueOf(dt.addDays(Integer.valueOf(objTask.Total_Days_to_Complete_Task_SLA__c)));
        }else
        {
            AIA_CalculateDaysDiffExcludingHoliday calDate = new AIA_CalculateDaysDiffExcludingHoliday();
            strDueDate = String.valueOf(calDate.addBussinessDays(dt, Integer.valueOf(objTask.Total_Days_to_Complete_Task_SLA__c)));            
        }
        objTask.ExpectedDate__c = Date.valueOf(strDueDate);
        System.debug('ExpectedDate__c ' + objTask.ExpectedDate__c);      
    }
   //T05-End
    public List<SelectOption> getSubprocessList() {
        return lstSubProcess;
    }
    //This method check for errors and Creates task with user input values
    public PageReference SaveTask(){
      System.Debug('objTask.Task_Name__c'+objTask.Task_Name__c);
        if (objTask.Task_Name__c=='' || objTask.Task_Name__c==null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AIA_CONSTANTS.ERRMESSAGE_TASKNAME));
            return ApexPages.currentPage();
        }
        if (objTask.Description__c=='' || objTask.Description__c==null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AIA_CONSTANTS.ERRMESSAGE_TASKDESCRIPTION));
            return ApexPages.currentPage();
        }
        // T03 - Start
        System.Debug('selected_TeamRole'+selected_TeamRole);
        System.Debug('selected_TeamMember'+selected_TeamMember);
        if (selected_TeamRole==null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AIA_CONSTANTS.ERRMESSAGE_TEAMROLE));
            return ApexPages.currentPage();
        }
       System.Debug('selected_TeamMember : '+selected_TeamMember);
        if (selected_TeamMember==null || selected_TeamMember=='') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AIA_CONSTANTS.ERRMESSAGE_TEAMMEMBER));
            return ApexPages.currentPage();
        }
         objTask.OwnerId = selected_TeamMember;
       
        // T03 - End
        // T05 - Start
        if (objTask.Total_Days_to_Complete_Task_SLA__c==null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,AIA_CONSTANTS.ERRMESSAGE_TOTALDAYS));
            return ApexPages.currentPage();
        }
        // T05 - End
        objTask.Sub_Process__c = slSubprocess;
        /* T02 Start -- Populating Workplan plan task with respect to the source object*/
        if(brfId!=null)
        {
            objTask.Benefit_Request_Form__c = brfRec.Id;
            objTask.RelatedObjectId__c = brfRec.Id;
            objTask.Opportunity__c = brfRec.Opportunity__c;
        }
        else
        {
           objTask.Opportunity__c = objImpl.Opportunity__c; 
           objTask.Implementation__c = ImplementationID; 
           objTask.Opportunity_Implementation_ID__c = ImplementationID; 
           objTask.RelatedObjectId__c = ImplementationID;           
        }
        //T02 -- End
        objTask.SLA_Day_Type__c = daytype;   
        objTask.Status__c = INPROGRESS; 
        objTask.Task_Owner__c = selected_TeamRole;
        objTask.Used_For__c = USED_FOR;        
        objTask.Start_Date__c = System.today();
        System.Debug('objTask.Start_Date__c'+objTask.Start_Date__c);        
        System.Debug('objInsTask'+objTask);
        try{
        insert objTask;
         Sub_Process__c objSP =  [Select id from Sub_Process__c where id = :slSubProcess limit 1];
            objSP.Status__c = AIA_CONSTANTS.STATUS_INPROGRESS;
            update objSP;
        return new PageReference('/'+returnURL);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));           
             return ApexPages.currentPage();   
        }
    }
    //This method redirects user to list view
     public PageReference CancelTask() {
         System.Debug('Cancel page');
         //T02 -- Updated the return URL
         return new PageReference('/'+returnURL);
    }   
    
}