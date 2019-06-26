/*===================================================================================================================
* Date       : 4/13/2018
* Developer  : Phanishankar Polisetty
* Purpose    : This is the controller class for VF page "AIA_Account_Team_member_Add" which contains the logic
*              to populate the roles and users depending on the login user (AIA Admin/System Admin/Manager)
*
*                                 Update History
*                                 ---------------
* Date       |     Developer        | Tag |   Description
*============+============+=========================================================================================
* 4/13/2018  | Phanishankar P       |     | Initial Creation
* 04/30/2018 | Rajesh Pennam        | T01 | Variable to Render the Page depedning on the user logs in
* 05/03/2018 | Phanishankar P       | T02 | US1790:If Account team member being replaced/deleted has active workplan assignments 
*                                           associated to that specific account then code reassigns them to new member 
* 05/17/2018 | Rajesh Pennam        | T03 | Updated the logic to do page redirect if user tries to update the team member role from
*                                           user page instead of account list view
* 06/08/2018 | Arshia Gulati        | T04 | Updated to be available from Detail Page as well
*============+============+=========================================================================================*/
public without sharing class AIA_Acc_TeamMemAdd_controller {
    private List<Account> accLst = new List<Account>();   
    public String accountNames {get;set;}
    public list<ATMWrapperCls> lstATMWrappercls{get;set;} 
    public Set<String> acctIds_Selcted = new Set<String>();    
    public boolean isImpManager{get;set;}
    public boolean systemAdmin{get;set;}
    public List<String> allowedRolesList{get;set;}
    public List<SelectOption> allowedRoles{get;set;}
    public Id ManagerRTId{get;set;}    
    public Map<Id,Map<String,Id>> accIdTeamMap = new Map<Id,Map<String,Id>>();    
    public Map<Id,Map<String,Id>> accIdRoleMap = new Map<Id,Map<String,Id>>();
    private AIA_Area_Manager__c  areaMang_rec;
    public Integer rowToRemove {get;set;}    
    public Boolean displayPopUp{get; set;}
    public Boolean displayFinalPopUp{get; set;}
    public string recCount{get; set;}    
    public Boolean displayEditPopup{get; set;} //Boolean to show edit popup for allowed Users T01
    public String selRol{get;set;}   
    public Integer rowNum{get;set;}
    public ATMWrapperCls atmwrap;
    //Public Map<String,String> totalTaskCntMap;
    public static final String adminRole= 'AIA Admin';
    public static final String inProgress = 'In Progress';
    //public static final String blocked = 'Blocked';
    public static final String mgrRecordType = 'Manager';
    public static final String no_string = 'No';
    public static final String impManagerRole = 'Implementation Manager';
    Boolean IsDetailPage;    //T04
        
    //To retrieve user selected role and calls method to populate team members belong to that role    
    public void populateRole(){
        selRol = Apexpages.currentPage().getParameters().get('param1');
        rowNum = Integer.valueOf(Apexpages.currentPage().getParameters().get('param2'));
        System.debug('selROl::'+selRol);
        System.debug('rowNum'+rowNum);
        populateTeamMembers();
    }
    
    public void addRow() {
        atmwrap = new ATMWrapperCls();
        atmwrap.users = new List<SelectOption>();
        lstATMWrappercls.add(atmwrap);      
        System.debug('lstATMWrappercls1'+lstATMWrappercls);
    }
    //T04 - Start
      public AIA_Acc_TeamMemAdd_controller(ApexPages.StandardController controller) {   
        lstATMWrappercls = new list<ATMWrapperCls>();
        //totalTaskCntMap = new Map<String,String>();
        //isAIAAdminRoleUser = false;
        systemAdmin = false;
        isImpManager = false;
        displayPopUp = false;
        displayFinalPopUp =false;
        displayEditPopup = false;//T01
        recCount = '0';          
        IsDetailPage = true;
        //Get Manager Record Type ID.
        ManagerRTId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get(mgrRecordType).getRecordTypeId();          
        accLst.add((Account) controller.getRecord());
        
        //Rajesh 0515 T03
        string inputacc = ApexPages.currentPage().getParameters().get('accLst');
        if(inputacc == null){
            for(account acc :accLst){
                acctIds_Selcted.add(acc.id);
            }
        }else{
            acctIds_Selcted.addall(inputacc.split(','));
        }
        
        system.debug('acctIds_Selcted***'+acctIds_Selcted);
        //Rajesh added 15-05
        recCount = String.valueOf(accLst.size());
        accountNames = '$';
        for(account accNewLst : [select id,name from Account where id=:acctIds_Selcted]){
            accountNames+=accNewLst.name+';';
        }
        system.debug('accountNames***'+accountNames);
        accountNames = accountNames.removeStart('$');        
        addrow();
    }
  //T04 - End
    public AIA_Acc_TeamMemAdd_controller(ApexPages.StandardSetController controller) {   
        lstATMWrappercls = new list<ATMWrapperCls>();
        //totalTaskCntMap = new Map<String,String>();
        //isAIAAdminRoleUser = false;
        systemAdmin = false;
        isImpManager = false;
        displayPopUp = false;
        displayFinalPopUp =false;
        displayEditPopup = false;//T01
        recCount = '0';      
    IsDetailPage = false;       //T04
        
        //Get Manager Record Type ID.
        ManagerRTId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get(mgrRecordType).getRecordTypeId();          
        accLst = (Account[])controller.getSelected(); 
        
        //Rajesh 0515 T03
        string inputacc = ApexPages.currentPage().getParameters().get('accLst');
        if(inputacc == null){
            for(account acc :accLst){
                acctIds_Selcted.add(acc.id);
            }
        }else{
            acctIds_Selcted.addall(inputacc.split(','));
        }
        
        system.debug('acctIds_Selcted***'+acctIds_Selcted);
        //Rajesh added 15-05
        recCount = String.valueOf(accLst.size());
        accountNames = '$';
        for(account accNewLst : [select id,name from Account where id=:acctIds_Selcted]){
            accountNames+=accNewLst.name+';';
        }
        system.debug('accountNames***'+accountNames);
        accountNames = accountNames.removeStart('$');        
        addrow();
    }
    
    //Method verifies logged in user is Admin/Area Manager using Area mapping object
    public void AIA_AccountTeamMember(){     
        Id CurrentUser = UserInfo.getUserId();       
        allowedRoles = new List<SelectOption>();
        Boolean adminUser; 
        Boolean adminPsetUser;
        List<AIA_Area_Manager__c>  areaMang_recLSt = [SELECT id,Areas__c,Area_Belong_to__c
                                                      from AIA_Area_Manager__c 
                                                      where Area_Manager__c =:CurrentUser and RecordTypeid=:managerRTId and AIA_isActive__c = TRUE
                                                      LIMIT 1 ];        
        if(!areaMang_recLSt.isEmpty()){
            areaMang_rec = areaMang_recLSt[0];
            displayEditPopup = true; //T01
        }
        adminUser = AIA_Utils.checkIf_AIA_Admin_Profile_User();
        adminPsetUser = AIA_Utils.checkIf_AIA_Admin_User();
        if(adminUser || adminPsetUser){
            systemAdmin = True;
            displayEditPopup = true;//T01
        }
        else if(systemAdmin == False){
            if(areaMang_rec != null){
                //checkAIAAdmin(areaMang_rec);
                checkImpManager(areaMang_rec);
                displayEditPopup = true;//T01
            }
        }
        
        if(systemAdmin == TRUE || isImpManager == TRUE ||areaMang_rec != null){
            //getExistingTeam(acctIds_Selcted);
            populateRoles();
        }
    }
    
    //populate users depending on the login user (AIA Admin/System Admin/Manager)
    public void populateTeamMembers(){    
        System.debug('selRol'+selRol);
        map<String,String> allowedUserMap = new map<String,String>();
        Map<String,Map<String,String>> allowedRoleUserMap = new Map<String,Map<String,String>>();
        Map<String,String> workplancountMap = new Map<String,String>();
        Set<Id> allowedIds = new Set<Id>();
        List<SelectOption> allowedUsers1 = new List<SelectOption>();
        List<AIA_Area_Manager__c> teamMemList = new List<AIA_Area_Manager__c>();
        String count;
        
        if(!allowedRolesList.isEmpty()){   
            String query;
            String roles='$';
            for(String str : allowedRolesList){
                roles = roles + '\''+str+'\',' ;
            }
            roles = roles.removeStart('$');
            roles = roles.removeEnd(',');
            System.debug('roles'+roles);
            //If System Admin he can assign any user from AIA_Area_Manager__c to Accounts
            if((systemAdmin == TRUE || isImpManager == TRUE))
            {
                query = 'select id,Area_Belong_to__c,Area_Manager__r.Id,Area_Manager__r.Name from AIA_Area_Manager__c WHERE AIA_isActive__c = TRUE';
            }
            //If not System Admin he can only assign users from his managing areas
            else{
                query = 'select id,Area_Belong_to__c,Area_Manager__r.Id,Area_Manager__r.Name from AIA_Area_Manager__c where Area_Belong_to__c INCLUDES (';
                query+= roles+') AND AIA_isActive__c = TRUE';
            }
            
            system.debug('query '+query);
            //Querying the area mapping with respect to area belong to
            teamMemList =(List<AIA_Area_Manager__c>)Database.query(query);   
            System.debug('teamMemList'+teamMemList);
            for(String role : allowedRolesList){
                //System.debug('allowedRolesList@@'+allowedRolesList);
                for(AIA_Area_Manager__c mem : teamMemList){  
                    //05162018  
                    if(mem.Area_Belong_to__c!=NULL ){
                        List<String> roleList= mem.Area_Belong_to__c.split(';'); //mem.Area_Belong_to__c.contains(role)
                                                                                //giving issues if role is 'Account Dedicated Rep' &'Account Dedicated Rep - backup'
                        for(String rol : roleList){
                            //if(mem.Area_Belong_to__c!=NULL && mem.Area_Belong_to__c.contains(role)){
                            if(rol == role ){
                                if(allowedRoleUserMap.keySet().contains(role)){
                                    allowedRoleUserMap.get(role).put(mem.Area_Manager__r.Id,mem.Area_Manager__r.Name);
                                    allowedIds.add(mem.Area_Manager__r.Id);
                                }
                                else{
                                    Map<String,String> usrIdNameMap = new Map<String,String>();
                                    usrIdNameMap.put(mem.Area_Manager__r.Id,mem.Area_Manager__r.Name);
                                    allowedRoleUserMap.put(role,usrIdNameMap);
                                    allowedIds.add(mem.Area_Manager__r.Id);
                                }
                            }
                        }
                    }
                }
            }
            System.debug('allowedRoleUserMap'+allowedRoleUserMap);
            System.debug('selRol@@@'+selRol);
            allowedUserMap = allowedRoleUserMap.get(selRol);            
            System.debug('allowedUserMap'+allowedUserMap);
            workplancountMap =  getActiveWorkplanTasks(allowedIds);
           //totalTaskCntMap =  getActiveWorkplanTasks(allowedIds);
            allowedUsers1.add(new SelectOption('', '--None--'));
            if(allowedUserMap != NULL){
                for(String usr : allowedUserMap.keySet()){
                    System.debug('usr'+usr);
                    count = workplancountMap.get(usr);
                    if(count == null){
                        count = no_string;
                    }
                    allowedUsers1.add(new SelectOption(usr,(allowedUserMap.get(usr)+'#'+count+' Active Tasks')));
                } 
            }
            System.debug('rowNum'+rowNum);  
            lstATMWrappercls.get(rowNum-1).users = allowedUsers1;      
        }        
    }
    
    public Map<String,String> getActiveWorkplanTasks(Set<Id> usrIds){
        Map<String,String> usrTaskCntMap = new Map<String,String>();
        List<AggregateResult> workplanList = [SELECT OwnerId, count(Id)
                                              FROM Workplan_Task__c
                                              WHERE   OwnerId IN: usrIds and Status__c = :inProgress 
                                              Group By OwnerId];
       /* List<AggregateResult> wplanListforUser = [SELECT OwnerId, count(Id)
                                              FROM Workplan_Task__c
                                              WHERE  OwnerId IN: usrIds and Status__c = :inProgress 
                                              Group By OwnerId];
        for(AggregateResult ar : wplanListforUser){
            String owner = String.valueOf(ar.get('OwnerId'));
            String count = String.valueOf(ar.get('expr0'));
            totalTaskCntMap.put(owner,count);
        }*/
        for(AggregateResult ar : workplanList ){    
            String owner = String.valueOf(ar.get('OwnerId'));
            String count = String.valueOf(ar.get('expr0'));
            usrTaskCntMap.put(owner,count);
        } 
        return usrTaskCntMap;
    }
    //To populate the roles depending on the login user (AIA Admin/System Admin/Manager)
    public void populateRoles(){
        //Get roles if user is System Admin/ AIA Admin
        if((systemAdmin == True || isImpManager == True) ){ 
            allowedRolesList = new List<String>();
            //Schema.DescribeFieldResult fieldResult = Accountteammember.TeamMemberRole.getDescribe(); T05 change
            Schema.DescribeFieldResult fieldResult = Account_Team__c.TeamMemberRole__c.getDescribe(); //T05 change
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry pickListEntry : ple){     
                allowedRolesList.add(pickListEntry.getValue());                        
            }           
        }
        //Get roles if user is Area Manager
        else{       
            allowedRolesList = getRoles(areaMang_rec); 
        }
        // if(allowedRolesList.size() > 1){
        allowedRoles.add(new SelectOption('', '--None--'));           
        //}                     
        for(String s : allowedRolesList){            
            allowedRoles.add(new SelectOption(s,s));             
        }
        
    }
    public List<String> getRoles(AIA_Area_Manager__c userMapping){
        List<String> areas = new List<String>();       
        if(userMapping != NULL){
            String Area = userMapping.Areas__c;
            areas = Area.split(';');
        }
        return areas; 
    }        
    
    //This method is used to check if the login user is having aia admin role in account team roles
    /*public void checkAIAAdmin(AIA_Area_Manager__c impUser){             
String areasManaged = impUser.Areas__c;
if(areasManaged.contains(adminRole)){
isAIAAdminRoleUser = true;
displayEditPopup = true; //T01
}        
}*/
    //This method is used to check if the login user is having  implementation manager role in account team roles
    public void checkImpManager(AIA_Area_Manager__c impUser){             
        String areasBelongs = impUser.Area_Belong_to__c;
        System.debug('areasBelongs'+areasBelongs) ;
        if(areasBelongs != NULL && areasBelongs.contains(impManagerRole)){
            isImpManager = true;
            displayEditPopup = true; //T01
        }        
    }
    
    
    //Method to fetch existing Account Team members for selected Accounts
    public void getExistingTeam(Set<String> selectedAccs){     
        System.debug('selectedAccs'+selectedAccs);
        //List<AccountTeamMember> existingAccTeamMemList = new List<AccountTeamMember>(); //t05
        List<Account_Team__c> existingAccTeamMemList = new List<Account_Team__c>(); //t05
        Map<Id,Map<String,Id>> roleTeamMemRecIdMap = new Map<Id,Map<String,Id>>();
        Id accId;        
        existingAccTeamMemList = [SELECT Id,UserId__r.Name,UserId__c,TeamMemberRole__c,AccountId__c
                                  FROM Account_Team__c
                                  where AccountId__c IN :selectedAccs Order by AccountId__c];
        for(Account_Team__c existMem : existingAccTeamMemList){ 
            accId = existMem.AccountId__c;
            if(accIdTeamMap.get(accId) == NULL){
                Map<String,Id> accTeamMap = new Map<String,Id>();
                Map<String,Id> roleTeamMemIdMap = new Map<String,Id>();
                accTeamMap.put(existMem.TeamMemberRole__c,existMem.UserId__c);
                roleTeamMemIdMap.put(existMem.TeamMemberRole__c,existMem.Id);
                accIdTeamMap.put(accId,accTeamMap);         
                accIdRoleMap.put(accId,roleTeamMemIdMap);
            }
            else{
                accIdTeamMap.get(accId).put(existMem.TeamMemberRole__c,existMem.UserId__c);
                accIdRoleMap.get(accId).put(existMem.TeamMemberRole__c,existMem.Id);
            }
        }
        System.debug('accIdTeamMap'+accIdTeamMap);
    }
    
    //To show pop-up after clicking on Add/Replace team members
    public void addTeamMemberPopup(){
        displayPopUp = true;
    }
    
    public void cancelTeamPop(){
        displayPopUp = false;
        displayFinalPopUp = false;
    }
    //This method is used to add the new team member to Account
    public PageReference addTeamMember(){
        List<Account_Team__c> memList = new List<Account_Team__c>();     
        Map<Id,Account_Team__c> deleteMemMap = new Map<Id,Account_Team__c>(); 
        List<Workplan_Task__c> tskListUpdate = new List<Workplan_Task__c>();
        //T02 - Start
        Map<Id,Map<Id,String>> oldAccRoleMap = new Map<Id,Map<Id,String>>();
        Map<Id,Map<String,Id>> newAccRoleMap = new Map<Id,Map<String,Id>>();
       // Map<String,AccountTeamMember> memListToIns = new Map<String,AccountTeamMember>();
       List<Map<String,Account_Team__c>> memListMap = new List<Map<String,Account_Team__c>>();
        Map<String,Account_Team__c> memListToIns;
        List<Account_Team__c> membersToIns = new List<Account_Team__c>();
        //T02 - End
        getExistingTeam(acctIds_Selcted);
        for(String accId : acctIds_Selcted){
            memListToIns = new Map<String,Account_Team__c>();
            Map<String,Id> teamMap =  accIdTeamMap.get(accId);
            Map<String,Id> memIdMap = accIdRoleMap.get(accId);
            System.debug('teamMap'+teamMap);
            System.debug('memIdMap'+memIdMap);
            System.debug('lstATMWrappercls***'+lstATMWrappercls);
            for(ATMWrapperCls  wrap:lstATMWrappercls)
            {
                //System.debug(teamMap.keySet().contains(wrap.ATM.TeamMemberRole));
                //System.debug(teamMap.get(wrap.ATM.TeamMemberRole));
                //System.debug(wrap.ATM.UserId);
                Boolean insertEntry = true;
                //If added role already exists Account Team then delete that member and add new team member
                if(teamMap != NULL && teamMap.keySet().contains(wrap.ATM.TeamMemberRole__c) 
                   && (teamMap.get(wrap.ATM.TeamMemberRole__c)) != wrap.ATM.UserId__c){
                       Account_Team__c mem = new Account_Team__c();
                       String memId = memIdMap.get(wrap.ATM.TeamMemberRole__c);   
                       mem.id =  memId;
                       deleteMemMap.put(mem.Id,mem); 
                       insertEntry = true;
                   }   
                else if(teamMap != NULL && teamMap.keySet().contains(wrap.ATM.TeamMemberRole__c) 
                   && (teamMap.get(wrap.ATM.TeamMemberRole__c)) == wrap.ATM.UserId__c){
                    insertEntry = false;
                }
               if(insertEntry){
                Account_Team__c mem = new Account_Team__c();
                mem.AccountId__c = accId;
                mem.TeamMemberRole__c= wrap.ATM.TeamMemberRole__c;
                System.debug('wrap.ATM.User.Id'+wrap.ATM.UserId__c);
                mem.userId__c = wrap.ATM.UserId__c;
                //memList.add(mem);   
                
                memListToIns.put(wrap.ATM.TeamMemberRole__c,mem);
                }
                // Re-assign active workplan assignments of that specific account to the new Account team member if 
                // user selects TRANSFER ACTIVE WORKPLAN TASKS? = Yes
                //T02 - Start
                if(teamMap != NULL && wrap.transferable == 'Yes'){  
                    Id userId = teamMap.get(wrap.ATM.TeamMemberRole__c);
                    Id newUserId = wrap.ATM.UserId__c;
                    if(oldAccRoleMap.get(accId) != NULL){
                        //oldAccRoleMap.get(accId).put(wrap.ATM.TeamMemberRole,userId);
                        oldAccRoleMap.get(accId).put(userId,wrap.ATM.TeamMemberRole__c);
                    }
                    else{
                        Map<Id,String> oldroleMemIdMap = new Map<Id,String>();
                        //oldroleMemIdMap.put(wrap.ATM.TeamMemberRole,userId);
                        oldroleMemIdMap.put(userId,wrap.ATM.TeamMemberRole__c);
                        oldAccRoleMap.put(accId,oldroleMemIdMap);                            
                    }         
                    if(newAccRoleMap.get(accId) != NULL){
                        newAccRoleMap.get(accId).put(wrap.ATM.TeamMemberRole__c,newUserId);
                    }
                    else{
                        Map<String,Id> newroleMemIdMap = new Map<String,Id>();
                        newroleMemIdMap.put(wrap.ATM.TeamMemberRole__c,newUserId);
                        newAccRoleMap.put(accId,newroleMemIdMap);                            
                    }                               
                }
                ////T02 - End                                
            }
           memListMap.add(memListToIns);
        }
        
        try{    
            for(Map<String,Account_Team__c> memMap:memListMap){
                membersToIns.addAll(memMap.values());
            }
            //upsert memListToIns.values();
            
            delete deleteMemMap.values();   
            Database.insert(membersToIns,false);
            updateAccRoles();             
            //T02 - Start
            List<Workplan_Task__c> tasks = [SELECT Id,AccountID__c,OwnerId 
                                            FROM Workplan_Task__c 
                                            WHERE AccountID__C IN :acctIds_Selcted and Status__c = :inProgress ];
            for (String acctId : acctIds_Selcted){
                Map<Id,String> oldRoleIdMap = oldAccRoleMap.get(acctId);
                Map<String,Id> newRoleIdMap = newAccRoleMap.get(acctId);
                //newAccRoleMap.get(acctId);
                for(Workplan_Task__c tsk: tasks){
                    if(tsk.AccountID__C == acctId && oldRoleIdMap != NULL && oldRoleIdMap.keySet().contains(tsk.OwnerId)){
                        String role = oldRoleIdMap.get(tsk.OwnerId);
                        tsk.OwnerId =  newRoleIdMap.get(role);
                        tskListUpdate.add(tsk);
                    }
                }                
            }
            System.debug('tskListUpdate::'+tskListUpdate);
            update tskListUpdate;
            //T02 - End
        }
        Catch(Exception e){
            System.debug(e);
            AIA_Utils errLogExp = new AIA_Utils();
            errLogExp.logException(e);
        }        
        return listView();
    }
    
    //To populate Account's role field with all Team member roles available under that Account team roles
    public void updateAccRoles(){
        Map<Id,List<String>> accRolesMap = new Map<Id,List<String>>();
        List<Account> updateAccList = new List<Account>();
        List<SelectOption> roles = new List<SelectOption>();
        List<Account_Team__c> teamMemberList =  [SELECT TeamMemberRole__c,AccountId__c,AccountId__r.Role__c 
                                                   FROM Account_Team__c
                                                   WHERE AccountId__c IN :acctIds_Selcted ];
        //Fetch roles for all selected account
        for(Account_Team__c accMem : teamMemberList){
            
            Id currentAccId = accMem.AccountId__c;
            if(!accRolesMap.keySet().contains(currentAccId)){ 
                List<String> roleList = new List<String>();
                roleList.add(accMem.TeamMemberRole__c);                
                accRolesMap.put(currentAccId,roleList);
            }
            else{
                accRolesMap.get(currentAccId).add(accMem.TeamMemberRole__c);
            }
        }
        
        //Add newly added roles to existing roles and update those values in Account Role__c field       
        for(Id accId : accRolesMap.keySet()){
            List<String> allRoles = new List<String>();
            Account acc = new Account();
            acc.Id = accId;
            allRoles = accRolesMap.get(accId);   
            for(ATMWrapperCls  wrap:lstATMWrappercls)
            {
                if(!allRoles.contains(wrap.ATM.TeamMemberRole__c)){
                    allRoles.add(wrap.ATM.TeamMemberRole__c);
                }
            }
            acc.Role__c = String.join(allRoles,';');
            updateAccList.add(acc);
        }   
        update updateAccList;
    }
    //Wrapper Class to have ATM record and User Name.
    public class ATMWrapperCls
    {
        public Account_Team__c ATM{get;set;}
        public string username{get;set;}
        public String transferable{get;set;}   
        public List<SelectOption> users{get;set;}
        public ATMWrapperCls()
        {
            ATM = new Account_Team__c();    
            //users = new List<SelectOption>();
        }        
    }
    
    //This method is used to return to the list view T03
    public PageReference listView() {        
        string inputacc = ApexPages.currentPage().getParameters().get('accLst');
        if(inputacc!=null){
            //T04 - Start
            if(IsDetailPage){
                return new PageReference('/'+(new list<string>(acctIds_Selcted))[0]);
            }
            else
            {
              return new pageReference('/'+userinfo.getUserId());
            }
            //T04 - End
            
        }
        else{
            //T04 - Start
            if(IsDetailPage){
                return new PageReference('/'+(new list<string>(acctIds_Selcted))[0]);
            }
            else
            {
              return new ApexPages.Action('{!List}').invoke();
            }
            //T04 - End
        }
        
        //System.PageReference[/a09?fcf=00B24000004cfLK]        
    }
    
    //This method is used to remove the rows 
    public void removeRowFromList() {
        Integer i = lstATMWrappercls.size();
        system.debug('lstATMWrappercls**'+lstATMWrappercls);
        system.debug('rowToRemove****'+rowToRemove);
        if (i > 1) {
            lstATMWrappercls.remove(rowToRemove - 1);
        }
        system.debug('lstATMWrappercls22**'+lstATMWrappercls);
    }

       
}