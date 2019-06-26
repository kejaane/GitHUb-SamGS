/********************************************************************************
********************************************************************************    
 *  Class            : AIA_WP_SubProcess_Controller
 *  Author           : Goutham Rapolu
 *  Version History  : 1.0
 *  Creation         : 06/6/16
 *  Description      : WP Subprocess assignment creation.
 *
 ********************************************************************************
 *                                Update History
 *                                 ---------------
 * Date       Developer      Tag       Description
 *===========+============+================================================================
 * 04/16/2018|  Gayathri  |	T01  | Commented WP task related functionalities as per US 209
 *===========+============+================================================================

 ********************************************************************************/

public with sharing class AIA_WP_SubProcess_Controller {
   /* T01 -- Start
    //Variable Declaration 
    public static string wpStageId {get;set;}
    //stores the type of action param: Start SubProcess or Mark as Not required
    public string actionType {get;set;}
    //current wpStage in context
    //public static Workplan_Stage__c wpStage {get;set;}//T01
    //information message
    public static string infoMsg = '';
    //string variable to check which process to execute
    public static final string SSP_ACTION = 'ssp'; //Start Sub Process
    public static final string MNR_ACTION = 'mnr'; //Mark Not Required
    public static map<Id,list<Id>> mapQIdwithQmbrs = new map<Id,list<Id>>(); 
    public static map<string,List<string>> mapAccIdToTeamRole = new map <string,List<string>>();
    public static map<string,integer> mapTeamRoleCount = new map<string,integer>();
    public static map<string,string> wpttRoles = new map<string,string>();
    public static final string ROLE_UNDEFINED = 'The following roles need to be defined in the Account Team before starting this SubProcess:';
    public static final string MULTIPLE_ROLE1 = 'The following roles are defined multiple times in the Account Team:';
    public static final string MULTIPLE_ROLE2 = '. Please define these roles only once before starting this SubProcess.';
    public static list<AccountTeamMember> ateamlist = new list<AccountTeamMember>(); 
    public static string roleName ='';
    //constructor
    public AIA_WP_SubProcess_Controller(apexPages.StandardController controller){
        
        wpStageId = apexPages.currentPage().getParameters().get('Id');  
        actionType = apexPages.currentPage().getParameters().get('type');
        wpStage = new Workplan_Stage__c();
		
    } 
    T01 -- End */
    /*
        This method is called from VF page "Action" attribute and based on action type it will invoke the desired process.
        It will query Workplan Stage record based on workplan stage record Id passed in URL. 
        @param: none
        @return: pageReference (null)
    */
    /* T01 -- Start
    public pageReference onPageLoad(){
        
        if(string.isNotBlank(wpStageId) && string.isNotBlank(actionType)){
            infoMsg = '';
            Savepoint sp = Database.setSavepoint();
            try{
                //get the Workplan_Stage__c record from the database
                wpStage = getWPstage();
                //if actionType param is SSP, initiate sup Process
                if(actionType.equalsIgnoreCase(SSP_ACTION))
                    startSubProcess();
                //if actionType param is MNR, initiate mark not required action
                if(actionType.equalsIgnoreCase(MNR_ACTION))
                    MarkNotRequired();
                if(string.isNotBlank(infoMsg))
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.INFO, infoMsg));
            }
            catch(exception e){
                system.debug('Exception Caught'+e);
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
                Database.rollback(sp);
            }
            
        }
		
        return null;
    }
    T01 -- End */
    /*
        This method is called from "onPageLoad" method when the actionType param is "ssp". It will create Workplan_Assignment__c records
        from Workplan_Type_Task__c records of Workplan_Type_Stage__c record. It will also set the ownerId of Workplan_Assignment__c records
        based on Assignee_Type__c field on Workplan_Type_Task__c records. It calls "sendEmail" method to send emails to external or internal users.
        @param: none
        @return: none
    */
    /* T01 -- Start
    public static void startSubProcess(){
        
        map<string,Workplan_Type_Stage__c> WPTSmap = new map<string,Workplan_Type_Stage__c>();
        set<Id> externalUserIds = new set<Id>();
        set<Id> internalUserIds = new set<Id>();
        list<AIA_Workplan_Assignment__c> newWPAlist = new list<AIA_Workplan_Assignment__c>();
            if(wpStage != NULL && wpStage.Id != NULL){
                infoMsg = '';
                roleName= '';
                Savepoint sp1 = Database.setSavepoint();
                try{
                    wpStage.Status__c = 'In Progress';
                    checkAccTeamRoles(wpStage);
                    update wpStage;
                    infoMsg = 'Workplan Sub Process Started!';
                  
                }
                catch(CustomException ce){
                    infoMsg = '';
                    String exMsg = String.ValueOf(ce.getMessage());
                    if(exMsg.contains(ROLE_UNDEFINED)){
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, ROLE_UNDEFINED+roleName)); 
                    }
                    
                    if(exMsg.contains(MULTIPLE_ROLE1)){
                        ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, MULTIPLE_ROLE1+roleName+MULTIPLE_ROLE2));
                    }
                    Database.rollback(sp1);
                }
                catch(exception e){
                    infoMsg = '';
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
                    Database.rollback(sp1);
                }
                
            }
	
    }
    T01 -- End */
     /*
        This method is called from "onPageLoad" method when the actionType param is "mnr". It will update the Status of workplan stage to "Not Required".
        @param: none
        @return: none
    */
     /* T01 -- Start
    public static void MarkNotRequired(){
       
        infoMsg = '';
        if(wpStage != NULL && wpStage.Id != NULL){
            wpStage.Status__c = 'Not Required';
            update wpStage;
            infoMsg = 'Workplan Sub Process Marked as not Required!';
        }
		
    }
  
    public static void checkAccTeamRoles(Workplan_Stage__c obj){
        	/* T01 -- Start
            //Query the particular set from AccountTeamMember 
           if(obj != null ){
               integer count = 1;
               for(AccountTeamMember accMbr :[SELECT AccountAccessLevel,AccountId,Id,TeamMemberRole,UserId FROM AccountTeamMember where AccountId =: obj.Account__c]){
                    ateamlist.add(accMbr);
                    if(mapTeamRoleCount.containsKey(accMbr.TeamMemberRole)){
                        count++;
                        mapTeamRoleCount.put(accMbr.TeamMemberRole, count);
                    }
                    else{
                        mapTeamRoleCount.put(accMbr.TeamMemberRole, 1);
                    }
                        
                    string accId = string.valueOf(accMbr.AccountId).substring(0,15);
                    if(mapAccIdToTeamRole.containsKey(accId)){
                        mapAccIdToTeamRole.get(accId).add(accMbr.TeamMemberRole);
                    }
                    else{
                        mapAccIdToTeamRole.put(accId, new list<string>{accMbr.TeamMemberRole});
                    }
                    
                }//for loop ends
                
                List<AIA_Workplan_Type_Task__c> wpttlist =[select Id, Action__c, Role__c,Assignee_Type__c,Queue_Id__c,Default_Owner__c,Workplan_Type_Stage__c,Task_Code__c,Task_Name__c,Assignment_Description__c,Workplan_Type_Stage__r.Stage__c, 
                                                          Expected_Days_To_Complete__c,Send_Notification__c,Assgin_To_Non_AIA_Contact__c,X60_Day_Offset__c,X90_Day_Offset__c,X120_Day_Offset__c,X180_Day_Offset__c from AIA_Workplan_Type_Task__c
                                                          where Workplan_Type_Stage__c =: obj.Workplan_Type_Stage__c and Active__c=true];
               // Add workplan type Assignments to map
               for(AIA_Workplan_Type_Task__c wptt: wpttlist)
               {
                    
                    wpttRoles.put(wptt.Role__c,wptt.Role__c);
                    
               }
               system.debug('wpttRoles++++'+wpttRoles);
               boolean roleExists = false;
               if(obj.Workplan_Type_Stage__c != null){
                if(mapAccIdToTeamRole.containsKey(obj.Account__c)){
                    if(wpttRoles != NULL){
                        for(string wpttRl : wpttRoles.keyset()){
                            for(string accTmRole : mapAccIdToTeamRole.get(obj.Account__c)){
                            
                            }
                        }
                     }
                    
                    if(wpttRoles != NULL){
                        set<string> teamRoleNotInWptt = new set<string>();
                        teamRoleNotInWptt.addAll(wpttRoles.keyset());
                        system.debug('teamRoleNotInWptt>> Before'+ teamRoleNotInWptt);
                        teamRoleNotInWptt.removeAll(mapAccIdToTeamRole.get(obj.Account__c));
                        system.debug('teamRoleNotInWptt>> after'+ teamRoleNotInWptt);
                        for(string wpttRl : teamRoleNotInWptt){ //if any WPTT role doesn't contain account team role throw error
                            if(string.isBlank(roleName))
                                roleName = wpttRl;
                            else
                                roleName = roleName+' , '+wpttRl;
                        }//for loop ends
                        if(string.isNotBlank(roleName))
                            throw new CustomException(ROLE_UNDEFINED);
                    }
                    
                    for(string accTmRole : mapAccIdToTeamRole.get(obj.Account__c)){ //get Account Team role names
                        if(mapTeamRoleCount != NULL && mapTeamRoleCount.containsKey(accTmRole)){
                            if(mapTeamRoleCount.get(accTmRole) > 1){ //if wptt has multiple roles, throw error
                                roleName = accTmRole;
                                throw new CustomException(MULTIPLE_ROLE1);
                            }
                        }   
                    }//outer for loop ends
                }
                system.debug('mapAccIdToTeamRole>>>'+mapAccIdToTeamRole);
                system.debug('wpttRoles>>>'+wpttRoles);
                system.debug('ateamlist>>>'+ateamlist);
                if(ateamlist.size() == 0 && wpttRoles != NULL){
                	set<string> teamRoleInWptt = new set<string>();
                	teamRoleInWptt.addAll(wpttRoles.keyset());
                	system.debug('teamRoleInWptt>>>'+teamRoleInWptt);
                	for(string wpttRl : teamRoleInWptt){ //if any WPTT role doesn't contain account team role throw error
                    if(string.isBlank(roleName))
                        roleName = wpttRl;
                    else
                        roleName = roleName+' , '+wpttRl;
                }//for loop ends
                if(string.isNotBlank(roleName))
                    throw new CustomException(ROLE_UNDEFINED); 
                }
                
                }
           }
		
    }
    T01 -- End*/
    /*
        Send email to External & Internal Contacts/Users
        @param1: set<Id> - set of unique Ids, either contact or user
        @param2: list<AIA_Workplan_Assignment__c> - list of AIA_Workplan_Assignment__c records which will be used to merge data in email body.
    */
    /* T01 -- Start
    public static void sendMail(set<Id> idSet, list<AIA_Workplan_Assignment__c> wpAsgnList){
        
        //Key-UserId, Value-User email
        map<string,string> userToAddr = new map<string,string>();
        //Key-Contact Id, Value-Contact email
        map<string,string> contToAddr = new map<string,string>();
        //list to store single email messages
        list<Messaging.SingleEmailMessage> msgList = new list<Messaging.SingleEmailMessage>();
        boolean isUser = false;
        boolean isContact = false;
        string msgBody = '';
        list<Id> recIds = new list<Id>();
        recIds.addAll(idSet);
        if(recIds != NULL && recIds.size() > 0){
            if(Schema.Contact.SObjectType == Id.valueOf(recIds[0]).getSObjectType()){//if contact Ids are passed
                isContact = true;
                for(Contact cont : [Select Id, email from contact where Id IN : recIds]){
                    if(cont.email != NULL)
                        contToAddr.put(cont.Id, cont.email);
                }
            }
            
            if(Schema.User.SObjectType == Id.valueOf(recIds[0]).getSObjectType()){ //if User Ids are passed
                isUser = true;
                for(User usr : [Select Id, email from User where Id IN : recIds]){
                    if(usr.email != NULL)
                        userToAddr.put(usr.Id, usr.email);
                }
            }
        system.debug('userToAddr'+ userToAddr);
        if(wpAsgnList != NULL && wpAsgnList.size() > 0){
            for(AIA_Workplan_Assignment__c wpAsgn : wpAsgnList){
                if(isContact && contToAddr != NULL && contToAddr.size() >0 && contToAddr.containsKey(wpAsgn.External_Assignee__c)){
                    //get email address from contact map
                    string emailAdr = contToAddr.get(wpAsgn.External_Assignee__c);
                    //list of merge fields which will replace placeholders in a custom label to generate email body
                    list<string> replaceVars = new list<string>{wpStage.Implementation__r.account__r.name, wpAsgn.owner.name, wpAsgn.owner.email, string.valueOf(wpAsgn.Assigned_Date_Time__c),string.valueOf(wpAsgn.Due_Date__c), wpAsgn.Task_Description__c}; 
                    //replace the placeholders with actual content
                    string msg = string.format(system.label.AIA_WP_SubProcess_EmailTemplate,replaceVars);
                    msgList.add(generateEmailMsg(emailAdr,msg));    
                }
                if(isUser && userToAddr != NULL && userToAddr.size() >0 && userToAddr.containsKey(wpAsgn.ownerId)){
                    //get email address from user map
                    string emailAdr = userToAddr.get(wpAsgn.ownerId);
                    //generate link to WPA record
                    string link = '<a href="'+system.label.AIA_SFDC_Org_Domain+'/'+wpAsgn.Id+'">'+'Click Here</a>';
                    //list of merge fields which will replace placeholders in a custom label to generate email body
                    list<string> replaceVars = new list<string>{wpStage.Implementation__r.account__r.name,link}; 
                    //replace the placeholders with actual content
                    string msg = string.format(system.label.AIA_WP_SubProcess_EmailTemplate_2,replaceVars);
                    msgList.add(generateEmailMsg(emailAdr,msg));    
                }
            
            }
        }   
        
        if(msgList != NULL && msgList.size() > 0)
            Messaging.sendEmail(msgList);  
            
        }
		
    }
    T01 -- End*/
    /*
        This method is called from "sendMail" method to generate email content.
        @param1: string - email address
        @param2: string - html body of email
        @return: Messaging.SingleEmailMessage - email message with email address and body
    */
     /* T01 -- Start
    private static Messaging.SingleEmailMessage generateEmailMsg(string emailAddr, string msgbody){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
        list<string> toAddresses = new list<string>();
        toAddresses.add(emailAddr);
        mail.setToAddresses(toAddresses);
        mail.setSubject('Assignment Notification');
        mail.setHtmlBody(msgbody);
   		
        return mail;
    }
    T01 -- End*/
    /*
        This method will query Workplan_Stage__c record from database based on Workplan_Stage__c record Id passed in the page URL.
        @param: none
        @return: Workplan_Stage__c - Workplan Stage record 
    */
    /* T01 -- Start
    @testVisible
    private static Workplan_Stage__c getWPstage(){
        
        list<Workplan_Stage__c> thisWpsList = new list<Workplan_Stage__c>();
        Workplan_Stage__c thisWPstage;
        thisWpsList = [select Id, Workplan_Type__c, Status__c,Account__c,End_Date__c,Start_Date__c,Implementation__c,Implementation__r.account__r.name,Implementation__r.Account__c,Implementation__r.Implementation_Plan_Timeline_Days__c,Implementation__r.Effective_Date__c,Workplan_Type_Stage__c,Workplan_Type__r.ownerId from Workplan_Stage__c where Id=: wpStageId];
        if(thisWpsList != NULL && thisWpsList.size() > 0)
            thisWPstage = thisWpsList[0];
        return thisWPstage;
		
        return null;//Added as part of T01
    }
  T01 -- End */
}