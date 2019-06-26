/*=================================================================================================================
* Date         : 11/10/2017
* Developer    : Goutham Rapolu
* Purpose      : Logic to show Account Team related List on Acocunt Page & Redirect to Add/Edit/Replace 
*                Account Team Member. US138.
*=================================================================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 11/10/2017 | Goutham Rapolu |     | Initial Version  
* 05/16/2018 | Sajitha Y      | T01 | Added a method to differentiate classic and lightning view as per US 1789
* 07/02/2018 | Asif Kutagulla | T02 | Added condition for filtering inactive users AND removing condition to check
                                      if the user is AE or AM or Sales Assistant
* 07/05/2018 | Sajitha Y      | T03 | Added code for Add default team button , if role or user already presents in Account
                                      then it should replace existing role and team member
* 08/10/2018 | Arshia Gulati  | T04 | Added accountId filter for delete AccountTeamMember
* 01/23/2019 | Gayathri P     | T05 | Replaced standard Account Team Member with Custom Account Team Member.
* 02/26/2019 | Gayathri P     | T06 | Updated conditions to add defaul account team member as part of US6713
* 04/24/2019 | Satya T        | T07 | To check if logged in user has " AIA Default Account Team" permission set
*============+================+=====+=============================================================================
*/

public without sharing class AIA_AccountTeamMemberController {
    
    //public List<AccountTeamMember> ATMList {get; set;}
    public List<Account_Team__c> ATMList {get;set;}//T05
    public List<AIA_Area_Manager__c> AMList {get; set;}
    public List<PermissionSetAssignment> PermissionList{get;set;}
    public List<String> AreaList{get;set;}
    public set<String> AreaSet{get;set;}
    public Map<String,String> mapAreaToArea{get;set;}
    public string accountid {get;set;}
    public string AddATM {get;set;}
    public string DeleteATM {get;set;}
    public string ISAdmin_User {get;set;}
    public string ISAccountExe {get;set;}
    public string isDefaultTeam_User {get;set;}//t07
    //public string ISAIA_Admin {get;set;}
    public string EditATMTrue {get;set;}
    public string AreaManagerUser {get;set;}
    public ID CurrentUser {get;set;}
    public ID AreaManager {get;set;}
    public ID DelUser1 {get;set;}
    public string SID {get;set;}
    public Account acc{get;set;}
    public Id NonManagerRTId{get;set;}
    public Id ManagerRTId{get;set;}
    public Boolean displayPopUp{get; set;} 
    public final string AIA_DEFAULTTEAM_PERMSET = 'AIA_Default_Account_Team';//t07
    public AIA_AccountTeamMemberController(ApexPages.StandardController controller) {
        PermissionList= new List<PermissionSetAssignment>();
        mapAreaToArea= new Map<String,String>();
        AreaSet = new Set<String>();
        acc = (Account) controller.getRecord(); //Get Account.
        accountid = acc.id; //Account ID.
        CurrentUser = UserInfo.getUserId(); //Current User ID.
        SID = UserInfo.getSessionId(); // Session ID.
        AreaList= new List<String>();
        AMList= new List<AIA_Area_Manager__c>();
        AIA_AccountTeamMember(); //Call AIA_AccountTeamMember method.
    }
    
    // T01 - Start Method to check whether the page is in Classic or lightning
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    //T01 - End
    
        
    
    public void AIA_AccountTeamMember(){
        //Get Non-Manager RecordType ID.
        NonManagerRTId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Non-Manager').getRecordTypeId();
        //Get Manager RecordType ID.
        ManagerRTId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get('Manager').getRecordTypeId();
        
        ISAdmin_User = 'FALSE';
        EditATMTrue = 'FALSE';
        ISAccountExe= 'FALSE';
        //ISAIA_Admin= 'FALSE';
        AreaManagerUser = 'FALSE';
        isDefaultTeam_User = 'FALSE';
        
        //ReDirect URL's.
        DeleteATM = '/setup/own/deleteredirect.jsp?delID=';
        //Query AccountTeamMember List to Display.
        /*T05 -- Start*/
        /*ATMList = [SELECT Id, AccountAccessLevel,createdbyid ,LastModifiedById , AccountId, Account.Name, TeamMemberRole,UserId, User.Name FROM AccountTeamMember where AccountId =: acc.Id];
        system.debug(logginglevel.INFO,'==ATMList=='+ATMList);*/
        
        ATMList = [SELECT Id,AccountAccessLevel__c,createdbyId,LastModifiedById, AccountId__c,
                    AccountId__r.Name,TeamMemberRole__c,UserId__c,UserId__r.Name FROM 
                    Account_Team__c where AccountId__c =:acc.Id];
       
        /*T05 -- End*/
        //Query Area Manager.
        AMList = [SELECT id,Areas__c, Area_Belong_to__c,RecordTypeid, Delegated_User__c,Area_Manager__c,Delegated_Manager_1__c,Delegated_Manager_2__c from AIA_Area_Manager__c 
                  WHERE (Area_Manager__c =:CurrentUser OR Delegated_User__c=:CurrentUser) AND AIA_isActive__c = TRUE
                  LIMIT 1 ];
        system.debug(logginglevel.INFO,'==AMList=='+AMList);
        
        //Check if logged in user is AIA_Admin.    
        if(AIA_Utils.checkIf_AIA_Admin_User() == True){
            ISAdmin_User = 'TRUE';
            EditATMTrue = 'TRUE';
        }
        system.debug(logginglevel.INFO,'==ISAdmin_User@@AIAAdmin =='+ISAdmin_User );
        //Check the  Area belongs in AIA_AreaMapping object
        If(!AMList.ISEMPTY() ){
            
            /*** T02 - Start ***/
            If(String.isNotBlank(AMList[0].Areas__c)) {
                AreaManagerUser = 'TRUE';
            }
            /*** T02 - End ***/
            
            
            // DelUser1 = AMList[0].Delegated_User__c;
            // AreaManager = AMList[0].Area_Manager__c;
            if(AMList[0].Area_Belong_to__c!=null){
                AreaList = AMList[0].Area_Belong_to__c.split(';');    
            }
            
         if(!AreaList.ISEMPTY()){
                for(string a:AreaList ){
                    if(a== 'Sales Assistant'|| a == 'Account Executive' || a == 'Account Manager'){
                        ISAccountExe = 'TRUE';
                    }
                }
            }  
              
        } 
        
          
       /* T07 changes start*/ 
       if( AIA_Utils.checkIf_user_has_PS(userinfo.getuserid(),'AIA_Default_Account_Team') == True){
           isDefaultTeam_User = 'TRUE';
         }            
        /*T07 changes End*/
        
        
        system.debug(logginglevel.INFO,'==AreaList=='+AreaList);
        system.debug(logginglevel.INFO,'==ISAdmin_UserEND@@ =='+ISAdmin_User );
    } 
    // Method to show popup
    public void showPopup(){
        displayPopUp = true;
    }
    //Method to cancel popup
    public void cancelTeamPop(){
        displayPopUp = false;
    }
    //Logic to Delete Account Team Member.
    public pagereference deleteAccTM()
    {
        system.debug(logginglevel.INFO,'==atmid=='+ApexPages.currentPage().getParameters().get('accountid'));
        // displayPopUp = true;
        String AccTMid =  ApexPages.currentPage().getParameters().get('atmid');
        String accountid =  ApexPages.currentPage().getParameters().get('accountid');
        system.debug('***atmid'+AccTMid);
        //Query Selected Account Team member & Delete.
        /* T05 -- Start*/
        //List<Accountteammember> lstatm = [select id from Accountteammember where id=:AccTMid];
        List<Account_Team__c> lstatm = [Select id from Account_Team__c where id =:AccTMid];
        /*if(lstatm !=null && lstatm.size()>0){
            delete lstatm;
            
        }*/
        if(lstatm !=null && lstatm.size()>0){
            delete lstatm;
            
        }
        /* T05 -- End*/
        displayPopUp = false;
        return null;
        
    } 
    
    public void DefaultAccountTeam(){
        /* T05 -- Start*/
        //List<UserAccountTeamMember> DefaultAccountteam = New List<UserAccountTeamMember>();
        List<Default_Account_Team__c> DefaultAccountteam = New List<Default_Account_Team__c>();
        //List<Accountteammember> AccountTeam = New List<Accountteammember>();
        List<Account_Team__c> AccountTeam = New List<Account_Team__c>();
       // List<AccountTeamMember> existingAccTeamMemList = new List<AccountTeamMember>();
        List<Account_Team__c> existingAccTeamMemList = new List<Account_Team__c>();
        Map<String,Id> accTeamMap = new Map<String,Id>();
        set<string> accteamdelete = new set<string>();
        //T02 - Added where clause filter inactive users
       /* DefaultAccountteam = [SELECT AccountAccessLevel,CaseAccessLevel,ContactAccessLevel,OpportunityAccessLevel,OwnerId,SystemModstamp,TeamMemberRole,UserId 
                              FROM UserAccountTeamMember 
                              WHERE OwnerId = :CurrentUser AND 
                              User.isActive = TRUE];
        system.debug(logginglevel.INFO,'==DefaultAccountteam =='+DefaultAccountteam );*/
        
        
        DefaultAccountteam = [Select Account_Access__c,Case_Access__c,Contact_Access__c,Opportunity_Access__c,OwnerId,SystemModstamp,Team_Role__c,UserId__c
                              FROM Default_Account_Team__c
                              WHERE OwnerId =:CurrentUser AND
                              UserId__r.isActive = TRUE];
        system.debug('DefaultAccountteam'+DefaultAccountteam);
        //T03 - Start
        //Get existing Account team members list
        /*existingAccTeamMemList = [SELECT Id,User.Name,user.id,TeamMemberRole,AccountId
                                  FROM AccountTeamMember 
                                  where AccountId = :accountid];*/
        existingAccTeamMemList = [SELECT Id,UserId__r.Name,UserId__r.Id,TeamMemberRole__c,AccountId__c
                                  FROM Account_Team__c 
                                  where AccountId__c = :accountid];
        system.debug('existingAccTeamMemList'+existingAccTeamMemList);
        /*If(!existingAccTeamMemList.ISEMPTY()){
        for(AccountTeamMember existMem : existingAccTeamMemList){ 
            //put role, userid in map
               accTeamMap.put(existMem.TeamMemberRole,existMem.user.Id);
          }
        }*/
        If(!existingAccTeamMemList.ISEMPTY()){
        for(Account_Team__c existMem : existingAccTeamMemList){ 
            //put role, userid in map
               accTeamMap.put(existMem.TeamMemberRole__c,existMem.UserId__r.Id);
          
          }
              system.debug('Existing member map'+accTeamMap);
        }
        /*If(!DefaultAccountteam.ISEMPTY()){
            For(UserAccountTeamMember UATM: DefaultAccountteam){
                //check if existing role presents in default team but user is different
                if(accTeamMap!= null && accTeamMap.keySet().contains(UATM.TeamMemberRole) 
                   && (accTeamMap.get(UATM.TeamMemberRole)) != UATM.UserId){
                    accteamdelete.add(UATM.TeamMemberRole);  
                   }
                 //check if existing role does not presents in default team but user is present
                 if(accTeamMap!= null && !accTeamMap.keySet().contains(UATM.TeamMemberRole) 
                   && (accTeamMap.get(UATM.TeamMemberRole)) == UATM.UserId){
                    accteamdelete.add(UATM.TeamMemberRole);  
                   }
                Accountteammember AT = new Accountteammember();
                AT.AccountAccessLevel     = UATM.AccountAccessLevel;
                AT.TeamMemberRole         = UATM.TeamMemberRole;
                AT.CaseAccessLevel        = UATM.CaseAccessLevel;
                AT.ContactAccessLevel     = UATM.ContactAccessLevel;
                AT.OpportunityAccessLevel = UATM.OpportunityAccessLevel;
                AT.UserId                 = UATM.UserId;
                AT.AccountID              = accountid;
                AccountTeam.add(AT);
                }
            }
            system.debug(logginglevel.INFO,'==AccountTeam=='+AccountTeam);
           // Get the Accoun team members to delete
           List<AccountTeamMember> deletelist =[SELECT Id,User.Name,user.id,TeamMemberRole
                                  FROM AccountTeamMember 
                                  where TeamMemberRole IN :accteamdelete and AccountId=:accountid];   //T04
               If(!deletelist.ISEMPTY()){
                   delete deletelist;
               }
        //T03 - End
               If(!AccountTeam.ISEMPTY()){
                   insert AccountTeam;
               }
        */
        If(!DefaultAccountteam.ISEMPTY()){
            For(Default_Account_Team__c UATM: DefaultAccountteam){
                system.debug('DATM @@@@ role==>'+UATM.Team_Role__c+'  @@@@@ User ==>'+UATM.UserId__c);
                //check if existing role presents in default team but user is different
                if(accTeamMap!= null && accTeamMap.keySet().contains(UATM.Team_Role__c) 
                   && (accTeamMap.get(UATM.Team_Role__c)) != UATM.UserId__c){
                    accteamdelete.add(UATM.Team_Role__c);  
                   }
                //T06 -- Start
                /*//check if existing role does not presents in default team but user is present
                 if(accTeamMap!= null && !accTeamMap.keySet().contains(UATM.Team_Role__c) 
                   && (accTeamMap.get(UATM.Team_Role__c)) == UATM.UserId__c){
                    accteamdelete.add(UATM.Team_Role__c);  
                   }*///Commenting as part of US6713
                
                if(accTeamMap!= null && accTeamMap.keySet().contains(UATM.Team_Role__c) 
                   && (accTeamMap.get(UATM.Team_Role__c)) == UATM.UserId__c){
                    accteamdelete.add(UATM.Team_Role__c);  
                   }
                //T06 -- Stop
                Account_Team__c AT = new Account_Team__c();
                AT.AccountAccessLevel__c     = UATM.Account_Access__c;
                AT.TeamMemberRole__c         = UATM.Team_Role__c;
                AT.CaseAccessLevel__c        = UATM.Case_Access__c;
                AT.ContactAccessLevel__c     = UATM.Contact_Access__c;
                AT.OpportunityAccessLevel__c = UATM.Opportunity_Access__c;
                AT.UserId__c                 = UATM.UserId__c;
                AT.AccountID__c              = accountid;
                AccountTeam.add(AT);
                }
            }
        // Get the Accoun team members to delete
           List<Account_Team__c> deletelist =[SELECT Id,UserId__r.Name,UserId__r.id,TeamMemberRole__c
                                  FROM Account_Team__c 
                                  where TeamMemberRole__c IN :accteamdelete and AccountId__c=:accountid];   //T04
           If(!deletelist.ISEMPTY()){
                   delete deletelist;
               }
        //T03 - End
               If(!AccountTeam.ISEMPTY()){
                   insert AccountTeam;
               }    
        /* T05 -- End*/
        } 
   public PageReference ManageTeamMember(){
        return new PageReference('/apex/AIA_Account_Team_Member_Add_Detail?accLst='+acc.id);
    }
    
}