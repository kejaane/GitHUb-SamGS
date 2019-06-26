/*======================================================================================================================
* Date         : 11/26/2016
* Developer    : Asif Kutagulla
* Purpose      : Helper class for AIA_ImplementationTriggerHandler class. 
*                Contains method updateBD_RevNum_RevDate to update fields BD Revision Number & Revision Date
*======================================================================================================================
*                                 Update History
* -----------------------------------------------------------------------------------------------------------------
* Date       | Developer      | Tag |     Description
*============+================+=====+==================================================================================
* 11/26/2016 | Asif Kutagulla | T01 | Initial Version with method updateBD_RevNum_RevDate. This is to update the 
*                                     fields Benefit Design Revision Number Technical & Benefit Design Revision Date, 
*                                     when a new implementation is created for a BRF and there are other Implementation 
*                                     records with associated Benefit Design records available.
* 03/16/2017 | Sree Harsha    | T02 | Added method updateAccountRoles to update Account Team Roles Implementation PM
*                                     and Implementation Coordinator on Implementation object for backed use to send 
*                                     emails to those guys as part of user story B-03470.
* 06/15/2017 | Satya          | T03 | Added logic so that when multiple implemnetation is created, it checks for the 
duplicates of the account team roles for the individual accounts.
* 05/03/2018 | Gayathri       | T04 | Added a method to update the owner of Implementation as part of US-465
* 06/12/2018 | Gayathri       | T06 | Added a method to notify the Implementation owner when selected from Area mapping US 465
* 06/29/2018 | Gayathri       | T07 | Added a method to update related active Workplan tasks to Not Required of Implementation when it is completed
* 09/18/2018 | Raviteja       | T08 | Updated the code handle multiple imp to check account team members
* 10/15/2018 | Phani          | T09 | Added isActive condition in SOQL query
* 10/22/2018 | Chaithra       | T10 | Error message change.
* 02/01/2019 | Satya T        | T11 | Replaced standard Account Team Member with Custom Account Team Member. 
* 25/04/2019 | Petricia       | T12 | US6195 - NCR Implementations should have implementation coordinator as the owner.
* 25/04/2019 | Govind         | T13 | US6367 Getting the Implementation Coordinator from the related Accounts
*============+============+============================================================================================
*/
public class AIA_ImplementationTriggerHelper {
    
    public static final Set<Id> setAccountId = new Set<Id>();
    public static final string Implementation_Coordinator = 'Implementation Coordinator';
    public static final string Implementation_Manager = 'Implementation Manager';
    public static final string Implementation_PM = 'Implementation Manager';
    public static final string ERROR2 = 'The following roles are defined multiple times in the Account Team:';  
    //Commented as part of T09 public static final string ERROR3 = 'Please define these roles only once before saving the Group Structure.';
    public static final string ERROR3 = 'Please define these roles only once.';//T09
    public static final string MANAGER = 'Manager';
    public static final string Completed = 'Completed';
    public static final string NOT_REQUIRED = 'Not Required';
    /* T02 - Start
* @Author: Sree Harsha 
* @This Method is called from AIA_ImplementationTriggerHandler
* @param -  list<AIA_Implementation__c> 
* @Output - Updates Implementation PM and Implementation Coordinator fields.
*/
    public static void updateAccountRoles(list<AIA_Implementation__c> lstImplRecs){
        Integer Implementation_PM_Count = 0;
        Integer Implementation_Coordinator_Count = 0;
        for(AIA_Implementation__c impl : lstImplRecs){
            //Get Account Id's
            setAccountId.add(impl.Account__c);            
        }
        List<string> accRoleName = New List<String>{Implementation_Coordinator,Implementation_PM};
            //set<id> userIdSet = new set<id>();
            Map<string,integer> mapRoleWithCount = new Map<string,integer>();
        // Map<string,id> mapRoleWithUserId = new Map<string,id>();
        // Map<Id,integer> mapAccntIdWithCount = new Map<Id,integer>();
        Map<Id,Map<String,String>> mapAccRoleWithUserId = new Map<Id,Map<String,String>>();
        Map<Id,Map<String,Integer>> mapAccRoleWithCount = new Map<Id,Map<String,Integer>>();
        // doing query on account team member role and add data in map and integer varibale
        /* T11 -- Start*/
        /* For(AccountTeamMember accTeam : [select UserId,AccountId,TeamMemberRole from AccountTeamMember where AccountId IN : setAccountId and TeamMemberRole IN: accRoleName]){

//T06 -- Start
//mapRoleWithUserId.put(accTeam.TeamMemberRole,accTeam.UserID);
if(mapAccRoleWithUserId.containsKey(accTeam.AccountId))
{
mapAccRoleWithUserId.get(accTeam.AccountId).put(accTeam.TeamMemberRole,accTeam.UserID); 
}
else
{
mapAccRoleWithUserId.put(accTeam.AccountId,new Map<String,String>{accTeam.TeamMemberRole=>accTeam.UserID});  
}
if(mapAccRoleWithCount.containsKey(accTeam.AccountId))
{
Map<String,Integer> roleCount=mapAccRoleWithCount.get(accTeam.AccountId);
if(roleCount.containsKey(accTeam.TeamMemberRole))
{
roleCount.put(accTeam.TeamMemberRole,roleCount.get(accTeam.TeamMemberRole)+1); 
}
else
{
roleCount.put(accTeam.TeamMemberRole,1);  
}
}
else
{
mapAccRoleWithCount.put(accTeam.AccountId,new Map<String,Integer>{accTeam.TeamMemberRole=>1});  
}


}*/
        For(Account_Team__c accTeam : [select UserId__c,AccountId__c,TeamMemberRole__c from Account_Team__c where AccountId__c IN : setAccountId and TeamMemberRole__c IN: accRoleName]){
            
            //T06 -- Start
            //mapRoleWithUserId.put(accTeam.TeamMemberRole,accTeam.UserID);
            if(mapAccRoleWithUserId.containsKey(accTeam.AccountId__c))
            {
                mapAccRoleWithUserId.get(accTeam.AccountId__c).put(accTeam.TeamMemberRole__c,accTeam.UserId__c); 
            }
            else
            {
                mapAccRoleWithUserId.put(accTeam.AccountId__c,new Map<String,String>{accTeam.TeamMemberRole__c=>accTeam.UserId__c});  
            }
            if(mapAccRoleWithCount.containsKey(accTeam.AccountId__c))
            {
                Map<String,Integer> roleCount=mapAccRoleWithCount.get(accTeam.AccountId__c);
                if(roleCount.containsKey(accTeam.TeamMemberRole__c))
                {
                    roleCount.put(accTeam.TeamMemberRole__c,roleCount.get(accTeam.TeamMemberRole__c)+1); 
                }
                else
                {
                    roleCount.put(accTeam.TeamMemberRole__c,1);  
                }
            }
            else
            {
                mapAccRoleWithCount.put(accTeam.AccountId__c,new Map<String,Integer>{accTeam.TeamMemberRole__c=>1});  
            }
            
            
        }
        /*T11 -- End*/
        
        for(AIA_Implementation__c objImpl : lstImplRecs){
            
            //T08 start to handle multiple implementations per account
            if( mapAccRoleWithUserId != null && !mapAccRoleWithUserId.isEmpty() && mapAccRoleWithUserId.containsKey(objImpl.Account__c) && 
               mapAccRoleWithCount !=null && mapAccRoleWithCount.containsKey(objImpl.Account__c)){
                   if(mapAccRoleWithUserId.get(objImpl.Account__c).containskey(Implementation_Coordinator)){
                       if(mapAccRoleWithCount.get(objImpl.Account__c) != null && mapAccRoleWithCount.get(objImpl.Account__c).containsKey(Implementation_Coordinator) && mapAccRoleWithCount.get(objImpl.Account__c).get(Implementation_Coordinator) == 1) // if mapRoleWithCount is 1, then assigning the values
                           objImpl.Imp_Coordinator__c = mapAccRoleWithUserId.get(objImpl.Account__c).get(Implementation_Coordinator);
                       
                       else if(mapAccRoleWithCount.get(objImpl.Account__c) != null && mapAccRoleWithCount.get(objImpl.Account__c).containsKey(Implementation_Coordinator) && mapAccRoleWithCount.get(objImpl.Account__c).get(Implementation_Coordinator) != 1){ // if mapRoleWithCount is not 1, then throwing the error
                           objImpl.addError(ERROR2 + ' ' + Implementation_Coordinator+ '. ' + ERROR3); //T02 change
                       } 
                   }
                   
                   if(mapAccRoleWithUserId.get(objImpl.Account__c).containskey(Implementation_PM)){
                       if(mapAccRoleWithCount.get(objImpl.Account__c) != null && mapAccRoleWithCount.get(objImpl.Account__c).containsKey(Implementation_PM) && mapAccRoleWithCount.get(objImpl.Account__c).get(Implementation_PM) == 1) // if mapRoleWithCount is 1, then assigning the values
                           objImpl.Imp_PM__c= mapAccRoleWithUserId.get(objImpl.Account__c).get(Implementation_PM);
                       else if(mapAccRoleWithCount.get(objImpl.Account__c) != null && mapAccRoleWithCount.get(objImpl.Account__c).containsKey(Implementation_PM) && mapAccRoleWithCount.get(objImpl.Account__c).get(Implementation_PM) != 1){// if mapRoleWithCount is not 1, then throwing the error
                           objImpl.addError(ERROR2 + ' ' + Implementation_PM + '. ' + ERROR3);
                       }
                   }
               }
        }
        //T08 End
    } //T02 - End
    
    //T01 - Start
    public static void updateBD_RevNum_RevDate(list<AIA_Implementation__c> lstImplRecs)
    {
        list<Id> lstBRFIds = new list<Id>();
        Date mostRecentBD_RevisionDate = Date.newInstance(1900, 1, 1); //initialize to an old date
        Decimal mostRecentBD_RevisionNumber = -1; //initialize to never possible - negative version number
        map<Id,list<AIA_Implementation__c>> mapBRF_Impls = new map<Id,list<AIA_Implementation__c>>();
        list<AIA_Implementation__c> lstImplTemp;
        
        try {
            //Get BRF id's of all implementations inserted/updated
            for(AIA_Implementation__c impl : lstImplRecs) {
                if(String.isNotBlank(impl.Benefit_Request_Form__c)) {
                    lstBRFIds.add(impl.Benefit_Request_Form__c);
                }
            }
            
            //Query implementation to prepare a map of BRF vs associated Implemenation Records
            for(AIA_Implementation__c impl : [SELECT Benefit_Request_Form__c, Benefit_Design_Revision_Date__c, 
                                              Benefit_Design_Revision_Number_Technical__c, Id, CreatedDate
                                              FROM AIA_Implementation__c 
                                              WHERE Benefit_Request_Form__c IN :lstBRFIds]) {
                                                  if(mapBRF_Impls.containsKey(impl.Benefit_Request_Form__c)) {
                                                      mapBRF_Impls.get(impl.Benefit_Request_Form__c).add(impl);       
                                                  }
                                                  else {
                                                      lstImplTemp = new list<AIA_Implementation__c>();
                                                      lstImplTemp.add(impl);
                                                      mapBRF_Impls.put(impl.Benefit_Request_Form__c,lstImplTemp);
                                                  }
                                              }
            
            //For each implementation iterate over associated implemenations & get most recent BD revision date & number
            for(AIA_Implementation__c implementation : lstImplRecs) {
                lstImplTemp = new list<AIA_Implementation__c>();
                if(mapBRF_Impls.containsKey(implementation.Benefit_Request_Form__c)) {
                    lstImplTemp = mapBRF_Impls.get(implementation.Benefit_Request_Form__c);
                    if(!lstImplTemp.isEmpty()) {
                        for(AIA_Implementation__c impl : lstImplTemp) {
                            if(impl.Benefit_Design_Revision_Date__c != null && impl.Benefit_Design_Revision_Date__c > mostRecentBD_RevisionDate)
                            {
                                mostRecentBD_RevisionDate = impl.Benefit_Design_Revision_Date__c;
                                mostRecentBD_RevisionNumber = impl.Benefit_Design_Revision_Number_Technical__c;
                            }
                        }//end for                
                    }
                }
                
                //if revision number is not initialized dummy value then assign
                if(mostRecentBD_RevisionNumber >= 0) {
                    implementation.Benefit_Design_Revision_Number_Technical__c = mostRecentBD_RevisionNumber;    
                }
                
                //if date is not initialized dummy date then assign value
                if(mostRecentBD_RevisionDate.year() != 1900) {
                    implementation.Benefit_Design_Revision_Date__c = mostRecentBD_RevisionDate;
                }
            }//end for
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
            if(lstImplRecs.size() == 1) { lstImplRecs[0].addError('An error occurred. Please raise OneStop request.'+ex.getMessage()); } }//end catch
    }//end method
    //T01 - End
    
    /*T04 -- Start 
* @Author: Gayathri 
* @This Method is called from AIA_ImplementationTriggerHandler
* @param -  list<AIA_Implementation__c> 
* @Output - This Method will update the Implementation Manager as owner of the Implementation on creation
*/
    public static void updateOwner(list<AIA_Implementation__c> lstImplRecs)
    {
        AIA_Utils errLogExp = new AIA_Utils();
        try{
            system.debug('+++imp list+++'+lstImplRecs);
            Set<Id> accountIds = new Set<Id>();
            set<Id> NCRaccountIds = new Set<Id>();//T12
            
            
            Map<Id,Id> accountTeamMap = new Map<Id,Id>();
            Map<Id,Id> NCRmap = new Map<Id,Id>();//T12
            
            
           // Map<Id,Id> accountTeamMap1 = new Map<Id,Id>(); //T13
            
            for(AIA_Implementation__c impl : lstImplRecs){
               if(impl.Business_Type__c != 'NCR')//T12 - Added a if condition to restrict the ncr implementations  - us6195
                {  
                    accountIds.add(impl.Account__c);
                }
                //T12 start - US6195
              else if(impl.Business_Type__c == 'NCR')
                {
                    NCRaccountIds.add(impl.Account__c);
                }
                //T12 end
            }
            //Getting the Implementation Manager from the related Accounts
            /* T11 -- Start */
            /*  for(AccountTeamMember team:[select id,UserId,AccountId,TeamMemberRole from AccountTeamMember where AccountId IN:accountIds])
{
if(team.TeamMemberRole == Implementation_Manager)
{
accountTeamMap.put(team.AccountId,team.UserId);
}
}*/
            for(Account_Team__c team:[select id,UserId__c,AccountId__c,TeamMemberRole__c from Account_Team__c where AccountId__c IN:accountIds])
            {
                system.debug('4');
                if(team.TeamMemberRole__c == Implementation_Manager)
                {
                    system.debug('5');
                    accountTeamMap.put(team.AccountId__c,team.UserId__c);
                }
                /* T13 START 
                if(team.TeamMemberRole__c == Implementation_Coordinator)
                {
                    system.debug('6');
                    accountTeamMap1.put(team.AccountId__c,team.UserId__c);
                }
                 T13 END */
                
            }/* T11 - End*/
            //T12 start Getting the Implementation Coordinators from the related Account
            for(Account_Team__c team:[select id,UserId__c,AccountId__c,TeamMemberRole__c from Account_Team__c where AccountId__c IN:NCRaccountIds])
            {
               
                if(team.TeamMemberRole__c == 'Implementation Coordinator')
                {
                    
                    NCRmap.put(team.AccountId__c,team.UserId__c);
                   
                }
            }
            //T12 end
            //Getting Implementation Managers from Area Mapping
            Id managerRecordTypeId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get(MANAGER).getRecordTypeId();
            List<AIA_Area_Manager__c> impManager = [select id,Area_Manager__c,Area_Belong_to__c from AIA_Area_Manager__c where Area_Manager__r.isActive=true AND Area_Belong_to__c INCLUDES (:Implementation_Manager) AND RecordTypeId=:managerRecordTypeId]; //T09
           
            //T12 - Start - Getting Implementation Coordinators from Area Mapping
            List<AIA_Area_Manager__c> impCoordinator = [select id,Area_Manager__c,Area_Belong_to__c from AIA_Area_Manager__c where Area_Manager__r.isActive=true AND Area_Belong_to__c INCLUDES (:Implementation_Coordinator) AND RecordTypeId=:managerRecordTypeId];
			//T12 - End
            for(AIA_Implementation__c implRec : lstImplRecs){ 
                //Assigning Implementation Manager from Account as owner, if it is not available assigning
                //the Implementation Manager from the Area Mapping
                    if(accountTeamMap.containsKey(implRec.Account__c))
                    {
                        implRec.OwnerId = accountTeamMap.get(implRec.Account__c);
                       // implRec.Coordinator_Id__c = accountTeamMap1.get(implRec.Account__c); //T13
                        
                    } 
                //T12 - Start - Assigning Implementation Coordinator from Account as owner for NCR type of Implementations, if it is not available assigning
                //the Implementation Coordinator from the Area Mapping
                	else if(NCRmap.containsKey(implRec.Account__c))
                    {
                        implRec.OwnerId = NCRmap.get(implRec.Account__c);
                    }
               		else
                    {
                        if(implRec.Business_Type__c == 'NCR')
                        {
                            if(impCoordinator.size()>0){
                            system.debug('12');
                            implRec.OwnerId = impCoordinator[0].Area_Manager__c;
                            implRec.AIA_Send_Notification__c = true;
                        	}
                        }
                        else 
                        {
                            if(impManager.size()>0){
                            system.debug('12');
                            implRec.OwnerId = impManager[0].Area_Manager__c;
                            //T06
                            implRec.AIA_Send_Notification__c = true;
                        	}
                        }
                    }
                //T12 - end
                implRec.Risk_Type__c = implRec.BRF_Funding_Arrangement__c;
            }            
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
            errLogExp.logException(ex);
        }
    }
    //T04 -- End
    
    //T05 --START
    
    /* public void completeWPTasksstatus(List<AIA_Implementation__c> listImp,Map<id,AIA_Implementation__c> oldListImp){
set<id> impId = new set<id>();
list<Workplan_Task__c> wpTasktoUpdate = new list<Workplan_Task__c>();
for(AIA_Implementation__c imp: listImp)
{
if(imp.Status__c == Completed && oldListImp.get(imp.id).Status__c != Completed ){
impId.add(imp.id);
}
}

for(Workplan_Task__c task:[Select Id,name,status__c,Implementation__c from Workplan_Task__c where Implementation__c IN:impId AND (status__c='In Progress' OR status__c = 'Not started')])
{
task.status__c = Completed;
wpTasktoUpdate.add(task);
}

if(!wpTasktoUpdate.isEmpty()){
update wpTasktoUpdate;
}

}*/
    
    //T05 --END
    
    //T06 -- Start --Method to send Notification to the Implementation owner
    public static void sendNotification(List<AIA_Implementation__c> listImp)
    {
        String emailSubject = 'Notification for Implementation Assignment';
        String body = 'Please click the link and review the Implementation assigned to you';
        Map<Id,Id> impOwnerMap = new Map<Id,Id>();
        Set<Id> userIds = new Set<Id>();
        Map<Id,String> userEmail = new Map<Id,String>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(AIA_Implementation__c imp:listImp)
        {
            if(imp.AIA_Send_Notification__c)
            {
                impOwnerMap.put(imp.Id,imp.OwnerId);
                userIds.add(imp.OwnerId); 
            }
        }
        
        if(userIds.size()>0)
        {
            for(User owner:[Select Id,Email from User where Id IN : userIds])
            {
                userEmail.put(owner.Id,owner.Email);
            }
            
            for(Id recId:impOwnerMap.keySet())
            {
                list<string> toAddresses = new list<string>();
                toAddresses.add(userEmail.get(impOwnerMap.get(recId)));
                string viewUrl = URL.getSalesforceBaseUrl().toExternalForm()+'/'+recId;
                string Link = '<a href="'+viewUrl+'">'+'Click Here</a>';  
                string emailBody = body+'\r\n'+'\r\n'+Link+'\r\n';
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(toAddresses);
                mail.setSubject(emailSubject);
                mail.setHtmlBody(emailbody);
                mails.add(mail);  
                
            }
            if(mails.size()>0)
            {
                Messaging.sendEmail(mails); 
            }
        }
    }
    //T06 -- End
    //T07 -- Start
    public static void updatetaskNotRequired(List<AIA_Implementation__c> listImp,Map<Id,AIA_Implementation__c> impOldMap)
    {
        AIA_Utils errLogExp = new AIA_Utils();
        Set<Id> completedImp = new Set<Id>();
        List<Workplan_Task__c> wpTaskToUpdate = new List<Workplan_Task__c>();
        for(AIA_Implementation__c imp:listImp)
        {
            if(impOldMap.get(imp.Id).Status__c != imp.Status__c && imp.Status__c == Completed)
            {
                completedImp.add(imp.Id); 
            }
        }
        try{
            if(completedImp.size()>0)
            {
                for(Workplan_Task__c task:[Select Id, Status__c,Implementation__c from Workplan_Task__c where Implementation__c IN:completedImp AND Status__c!= :Completed])
                {
                    task.Status__c = NOT_REQUIRED;
                    wpTaskToUpdate.add(task);
                }
            }
            
            if(wpTaskToUpdate.size()>0)
            {
                update wpTaskToUpdate;
            }
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
            errLogExp.logException(ex);
        }
    }
    //T07 -- End
}