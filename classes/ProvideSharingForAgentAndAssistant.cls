/* =========================================================================================
 * Date         : 09/1/2016
 * Developer    : Laveen Kattela
 * Purpose      : This  Class is for Case Apex Sharing(For community functionality) . Sharing the Case to Agent when Assistant creates a case and Vice versa.
 *                a)Funtionality is for both Creation and updation.
 *                b)This Class is invoked from CaseTriggerHandler Class
 *
 *                1.provideSharingForBrokerAgent  -- This method Shares the case to  Assistant based on both the Accounts (51+ & 2-50) when Assiatnt name in Contact Name
 *                2.provideSharingForAssistant    --  This method shares the case to  Primary Agent based on group. (When Contact Name is an Broker Agent)  
 *                
 *                  
 *=========================================================================================
 * Update History
 *  ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 09/1/16   |  Laveen Kattela    | Initial Version                                          
 *===========+============+================================================================
 */

public class ProvideSharingForAgentAndAssistant{

//This mehtod if for sharing the Broker agent case to Assistant 
    public static void provideSharingForBrokerAgent(List<Case> cvar){
    
    System.debug('\n >>>>>>>>>>>>> provideSharingForBrokerAgent2 <<<<<<<<<<<<<<<< ');
    Set<id> cidset = new Set<id>();                            // Contact id Set
    Map<id,Set<id>> cidCaseidMap = new Map<id,Set<id>>();      // Map with contact id with set Case id
    Map<id,User> userMap = new Map<id,User>();                 // Map with contact id and user record
    
    List<Case> CaseList = cvar;                                         //List of cases
    List<CaseTeamMember> caseShareList = new List<CaseTeamMember>();    // New CaseTeamMember - To provide the sharing  
    // query to get the CaseTeamRole - "BrokerAgentAndAssistantAccess" to share the Case (Here we set the read/write access)
    CaseTeamRole ctr = new CaseTeamRole();
    if(Test.isRunningTest())
    {
        ctr = [SELECT Name, AccessLevel, Id FROM CaseTeamRole limit 1];
    }
    else{
        ctr = [SELECT Name, AccessLevel, Id FROM CaseTeamRole where name ='BrokerAgentAndAssistantAccess'] ;
    }
    
    Map<id,Map<String,Id>> cidAccidMap = new Map<id,Map<String,id>>();    //Map for ContactID and Inner map for Account
    Set<id> aid50Set = new Set<id>();                                     //Set for 2-50 Accounts
    Set<id> aid50PlusSet = new Set<id>();                                 //Set for 51+ Account
    
    Map<id,List<Contact>> aid50Clistmap = new Map<id,List<Contact>>();     // map for 2-50 Contacts list
    Map<id,List<Contact>> aid51PlusClistmap = new Map<id,List<Contact>>(); // Map for 51+ Conatct list
    Map<id,Case> oldMap = new Map<id,Case>();                              // Old map for cases 
    
    // Checking if it is for update scenario 
    if(Trigger.isUpdate)
    oldMap = (Map<id,Case>) Trigger.oldMap;   // Assigning trigger.old map  to Old Map 
    
    //Looping throuh case object and checking ContactId is not null
    for(Case obj: CaseList){
        if(obj.ContactID != null )
        {
            //Adding to Contact set
            cidset.add(obj.ContactID);
            //Checking the Case id and contact id which contains the key of ContactID for the present case list process 
            if(cidCaseidMap.containskey(obj.ContactID)){
                cidCaseidMap.get(obj.ContactID).add(obj.id);    // Adding the contact and Case if values to the map 
            }
            else{cidCaseidMap.put(obj.ContactID, new Set<Id>{obj.id});}  //else creating the new set of caseId's and adding that to map
        }
        //Null Checking for the  2-50 Account and adding it to the 2-50 set
        if(obj.X2_50_Account__c != null  ){
            aid50Set.add(obj.X2_50_Account__c);
                      
        }
        //Checking for the update scenario with old map value and null values for 2-50 the Account. Adding it to 2-50 set
        if(Trigger.isUpdate && oldMap.get(obj.id).X2_50_Account__c != null)
        {
            aid50Set.add(oldMap.get(obj.id).X2_50_Account__c);
        }
        
        //Null Checking for the  51+ Account and adding it to the 2-50 set
        if(obj.X51_Account__c != null  ){
            aid50PlusSet.add(obj.X51_Account__c);
           
        }
        //Checking for the update scenario with old map value and null values for 51+ the Account. Adding it to 51+ set
        if(Trigger.isUpdate && oldMap.get(obj.id).X51_Account__c != null)
        {
            aid50PlusSet.add(oldMap.get(obj.id).X51_Account__c);
        }
        System.debug('\n cLog:'+cidAccidMap);
        
    }
    System.debug('\n cLog:'+aid50Set);
    System.debug('\n cLog:'+aid50PlusSet);
    
    //Null check for 2-50 set from the above
    if(aid50Set!= null && aid50Set.size()>0){
        //query for the list of "assitant" for the 2-50 Account
        List<contact> clist = [select id ,X2_50_Account__c from contact where X2_50_Account__c in :aid50Set and Community_User_Type__c ='Assistant' ];
        //looping through contact object and adding it to contactID set
        for(Contact cobj: clist){
            cidSet.add(cobj.id);
            
            //Checking if the map - "aid50Clistmap" has the keyset from the Account 2-50 contact 
            if(aid50Clistmap.containskey(cobj.X2_50_Account__c)){
                aid50Clistmap.get(cobj.X2_50_Account__c).add(cobj);
            }
            //else it creates a new list of contacts for the Account 2-50 and adds it to the Map 
            else{
                aid50Clistmap.put(cobj.X2_50_Account__c,new List<Contact>{cobj});
            }
        }
    }
    
    //Same functionality as above for 51+ Account - contact list
    if(aid50PlusSet!= null && aid50PlusSet.size()>0){
        List<contact> clist = [select id ,X51_Account__c from contact where X51_Account__c in :aid50PlusSet  and Community_User_Type__c ='Assistant' ];
        for(contact cobj: clist){
            cidSet.add(cobj.id);
            if(aid51PlusClistmap.containskey(cobj.X51_Account__c)){
                aid51PlusClistmap.get(cobj.X51_Account__c).add(cobj);
            }
            else{
                aid51PlusClistmap.put(cobj.X51_Account__c,new List<contact>{cobj});
            }
        }
    }
    
    System.debug('\n cLog:'+cidset);
    //Null checkiing for Contact set from  above two loops 
    if(cidset != null && cidset.size()>0){
        List<User> userlist =[Select id, contactid from User where contactId in : cidSet];      //Query for the list of users from the above set 
        //loop through user object and add it to the user map to share the case records 
        for(User uobj: userlist){
            userMap.put(uobj.contactId,uobj);
        }
    }
    System.debug('\n cLog:'+userMap);
    
    //Loop Triggers for new Cases. looping through list of Cases & Null checking the ContactID
    if(Trigger.isInsert)
    for(Case obj: CaseList){

        if(obj.ContactID != null  )
        {
            if(obj.X2_50_Account__c != null  ){
                //Null Checking the Contact map contains the value for 2-50 Accounts - contacts 
                if(aid50Clistmap.containskey(obj.X2_50_Account__c)){
                    //Loop through contacts from the above Contact map values 
                    for(Contact c:aid50Clistmap.get(obj.X2_50_Account__c))
                    {
                        //Checking for the User map if contact exist - community contact user record
                        if(userMap.containsKey(c.id))
                        {
                            System.debug('\n cLog: X2_50_Account__c');
                            CaseTeamMember cs = new CaseTeamMember();           // Creating a new CaseTeam Member to share the case to particular user
                            cs.ParentId = obj.id;                               // Assigning the Case id to the parentId of CS
                            cs.MemberId = userMap.get(c.id).id;                 // Assiging the Contact Id of particular User to the MemberId of CS
                            cs.TeamRoleId = ctr.id;                             // Assigning the CaseTeamRole ID to TeamRoleid of CS
                            caseShareList.add(cs);                              // Adding the value to list - to share the case
                        }
                    }
                }
            }
            //Same has above functionality for 51+ Account - Contacts
            if(obj.X51_Account__c != null  ){
                if(aid51PlusClistmap.containskey(obj.X51_Account__c)){
                    for(Contact c:aid51PlusClistmap.get(obj.X51_Account__c))
                    {
                       if(userMap.containsKey(c.id)) 
                       {
                            System.debug('\n cLog: X51_Account__c');
                            CaseTeamMember cs = new CaseTeamMember();
                            cs.ParentId = obj.id;
                            cs.MemberId = userMap.get(c.id).id;
                            cs.TeamRoleId = ctr.id;
                            caseShareList.add(cs);
                        }
                    }
                }
            }
            
            //Checking for the usermap for that list of case and sharing the Case records
            if(userMap.containskey(obj.ContactID))
            {
                CaseTeamMember cs = new CaseTeamMember();
                cs.ParentId = obj.id;
                cs.MemberId = userMap.get(obj.ContactID).id;
                cs.TeamRoleId = ctr.id;
                caseShareList.add(cs);
            }
               
        }
        
    }
    
    //Map for the Contact Id and set of user id 
    Map<id,Set<id>> cidUserIdMap = new Map<id,Set<id>>();   
    //Triggers For update scenario. Looping for the Case object & Null checking the contactID
    if(Trigger.isUpdate)
    for(Case obj: CaseList){
        if(obj.ContactID != null )
        {
            //Null checking the 2-50 Account value and checking the old map and new map change in value
            if(obj.X2_50_Account__c != null && oldMap.get(obj.id).X2_50_Account__c != obj.X2_50_Account__c ){
                if(aid50Clistmap.containskey(obj.X2_50_Account__c)){
                    for(Contact c:aid50Clistmap.get(obj.X2_50_Account__c))
                    {
                        if(userMap.containsKey(c.id))     //performing the same operation as above for update scenario 
                        {
                            System.debug('\n cLog: X2_50_Account__c');
                            CaseTeamMember cs = new CaseTeamMember();
                            cs.ParentId = obj.id;
                            cs.MemberId = userMap.get(c.id).id;
                            cs.TeamRoleId = ctr.id;
                            caseShareList.add(cs);
                        }
                    }
                }
            }
            //Null checking the 2-50 Account value and checking the old map and new map change in value
            if(oldMap.get(obj.id).X2_50_Account__c != null && oldMap.get(obj.id).X2_50_Account__c != obj.X2_50_Account__c  ){
                 // check for the 2-50 account map Values 
                 if(aid50Clistmap.containskey(oldMap.get(obj.id).X2_50_Account__c)){
                    for(Contact c:aid50Clistmap.get(oldMap.get(obj.id).X2_50_Account__c))
                    {
                        //Checking fo user id map values 
                        if(cidUserIdMap.containskey(obj.id))
                        {
                            cidUserIdMap.get(obj.id).add( userMap.get(c.id).id);  //Adding it to the map
                        }
                        else{
                            cidUserIdMap.put(obj.id,new Set<id>{userMap.get(c.id).id});   //else creating set of user id and adding it to the map
                        }
                    }
                }
            
            }
            
            //Null checking the account and checking the old value with the new one 
            if(obj.X51_Account__c != null && oldMap.get(obj.id).X51_Account__c != obj.X51_Account__c ){
                if(aid51PlusClistmap.containskey(obj.X51_Account__c)){
                    for(Contact c:aid51PlusClistmap.get(obj.X51_Account__c))
                    {
                        if(userMap.containsKey(c.id)) 
                        {
                            System.debug('\n cLog: X51_Account__c');         //performing the same operation as above for update scenario
                            CaseTeamMember cs = new CaseTeamMember();
                            cs.ParentId = obj.id;
                            cs.MemberId = userMap.get(c.id).id;
                            cs.TeamRoleId = ctr.id;
                            caseShareList.add(cs);
                        }
                    }
                }
            }
            //Null checking the  51+ Account and checking the old value with the new one
            if(oldMap.get(obj.id).X51_Account__c != null && oldMap.get(obj.id).X51_Account__c != obj.X51_Account__c){
                 if(aid51PlusClistmap.containskey(oldMap.get(obj.id).X51_Account__c)){
                    for(Contact c:aid51PlusClistmap.get(oldMap.get(obj.id).X51_Account__c))
                    {
                        //Checking fo user id map values
                        if(cidUserIdMap.containskey(obj.id))
                        {
                            cidUserIdMap.get(obj.id).add( userMap.get(c.id).id);   //Adding it to the map
                        }
                        else{
                            cidUserIdMap.put(obj.id,new Set<id>{userMap.get(c.id).id});  // else creating the new set of Id's and adding that to Map
                        }
                    }
                }
            
            }
            //Checking the usermap contains values and perform the same action below 
            if(userMap.containskey(obj.ContactID)){
                CaseTeamMember cs = new CaseTeamMember();
                cs.ParentId = obj.id;
                cs.MemberId = userMap.get(obj.ContactID).id;
                cs.TeamRoleId = ctr.id;
                caseShareList.add(cs);
            }
               
        }
    
    }
    
    /* Additional fucntionality to un-share the case which is been shared to previous contact Name
       When the case is been already shared and there is change in values on both the Accounts(2-50 & 51+) and Group */
        
     
    List<CaseTeamMember> ctmtoDelete = new List<CaseTeamMember>();   //list of caseTeamMember to delete the shared cases
    
    //Check for the Map Null values 
    if(cidUserIdMap != null && cidUserIdMap.size()>0 ){
        //query the list of CaseTeamMember with the Map keyset
        List<CaseTeamMember> ctmList =[Select id,ParentId,MemberId from  CaseTeamMember where ParentId in : cidUserIdMap.keySet() ];
        //Looping through the CaseTeamMembers and checking the Userid Map value
        for(CaseTeamMember ctmobj:ctmList){
            if(cidUserIdMap.containskey(ctmobj.ParentId) )
            {
                Set<id> useridset = cidUserIdMap.get(ctmobj.ParentId);    //Assiging the map ket to a set
                if(useridset.contains(ctmobj.MemberId))                   //Checking the value exists 
                {
                    ctmtoDelete.add(ctmobj);         //Adding list of CaseTeamMember to the list
                }
                
            }
            
        }
    }
    
    //If the list of case share list id not null
    if(caseShareList != null && caseShareList.size()>0)
    {
        DataBase.insert(caseShareList,false);    //Inserting the list to database and commiting it
    }
    
    //If list of delete cases is not null  from the loop
    if(ctmtoDelete != null && ctmtoDelete.size()>0)   
     DataBase.delete(ctmtoDelete,false);            // Deleting the list of cases from the database
    
}

public static void provideSharingForAssistant(List<Case> cvar){
    
    List<Case> CaseList = cvar; 
    List<CaseTeamMember> caseShareList = new List<CaseTeamMember>();
    //CaseTeamRole ctr = [SELECT Name, AccessLevel, Id FROM CaseTeamRole where name ='BrokerAgentAndAssistantAccess'];
    CaseTeamRole ctr = new CaseTeamRole();
    if(Test.isRunningTest())
    {
        ctr = [SELECT Name, AccessLevel, Id FROM CaseTeamRole limit 1];
    }
    else{
        ctr = [SELECT Name, AccessLevel, Id FROM CaseTeamRole where name ='BrokerAgentAndAssistantAccess'] ;
    }   
    Set<id> groupidset = new Set<id>();
    Set<id> oldgroupidset = new Set<id>();
    Map<String,Group__c> groupAgentIdMap = new Map<String,Group__c>();
    Map<id,Group__c> groupMap = new Map<id,Group__c>();
    Map<String,Contact> contactAgentIdMap = new Map<String,Contact>();
    Map<id,Contact> ContactMap = new Map<id,Contact>();
    Map<id,User> userMap = new Map<id,User>();
    Map<id,Case> oldMap = new Map<id,Case>();
    if(Trigger.isUpdate)
    oldMap = (Map<id,Case>) Trigger.oldMap;
    for(Case obj: CaseList){
        if(obj.Group__c != null )
        {
            groupidset.add(obj.Group__c);
        }
        if( Trigger.isUpdate && oldMap.get(obj.id).Group__c != null)
        {
            oldgroupidset.add(oldMap.get(obj.id).Group__c);
        }
        
    }
    if(groupidset != null & groupidset.size() >0){      
        for(Group__c gobj: [Select id, Agency_Agent_Id__c from Group__c where id in :groupidset  ])
        {
            if(gobj.Agency_Agent_Id__c != null && gobj.Agency_Agent_Id__c != '')
            {
                groupAgentIdMap.put(gobj.Agency_Agent_Id__c ,gobj);
                groupMap.put(gobj.id,gobj);
            }
        }
        
    }
    if(oldgroupidset != null & oldgroupidset.size() >0){      
        for(Group__c gobj: [Select id, Agency_Agent_Id__c from Group__c where id in :oldgroupidset  ])
        {
            if(gobj.Agency_Agent_Id__c != null && gobj.Agency_Agent_Id__c != '')
            {
                groupAgentIdMap.put(gobj.Agency_Agent_Id__c ,gobj);
                groupMap.put(gobj.id,gobj);
            }
        }
        
    }
    if(groupAgentIdMap != null && groupAgentIdMap.size()>0){
        Id cucRtid = Schema.SObjectType.Contact.RecordTypeInfosByName.get('Community User Contact').RecordTypeId;
        for(Contact cobj: [select id ,Agency_Agent_Id__c from contact where Agency_Agent_Id__c in : groupAgentIdMap.keyset() and recordTypeid =:cucRtid])
        {   if(cobj.Agency_Agent_Id__c != null && cobj.Agency_Agent_Id__c != '')
            {
                contactAgentIdMap.put(cobj.Agency_Agent_Id__c ,cobj);
                ContactMap.put(cobj.id,cobj);
            }
        }
    
    }
    if(ContactMap != null && ContactMap.size()>0){
        List<User> userlist =[Select id, contactid from User where contactId in : ContactMap.keyset()];      
        for(User uobj: userlist){
            userMap.put(uobj.contactId,uobj);
        }
    }
    Map<id,Set<id>> cidUserIdMap = new Map<id,Set<id>>();   
    for(Case obj: CaseList){        
        if(obj.Group__c != null && groupMap.containskey(obj.Group__c))
        {
                Group__c gobj = groupMap.get(obj.Group__c);
                String agentID = gobj.Agency_Agent_Id__c;
                if(contactAgentIdMap.containskey(agentID)){
                    contact cobj = contactAgentIdMap.get(agentID);
                    if(userMap.containskey(cobj.id)){
                        CaseTeamMember cs = new CaseTeamMember();
                        cs.ParentId = obj.id;
                        cs.MemberId = userMap.get(cobj.id).id;
                        cs.TeamRoleId = ctr.id;
                        caseShareList.add(cs);
                    }                   
                }
                
        }
        if(Trigger.isUpdate)
        {
            if(oldMap.get(obj.id).Group__c != null)
            {
                Group__c gobj = groupMap.get(oldMap.get(obj.id).Group__c);
                String agentID = gobj.Agency_Agent_Id__c;
                if(contactAgentIdMap.containskey(agentID)){
                    contact c = contactAgentIdMap.get(agentID);
                    if(userMap.containskey(c.id)){
                        if(cidUserIdMap.containskey(obj.id))
                        {
                            cidUserIdMap.get(obj.id).add( userMap.get(c.id).id);
                        }
                        else{
                            cidUserIdMap.put(obj.id,new Set<id>{userMap.get(c.id).id});
                        }
                    }
                }
            }
        
        
        }
    } 
     
    List<CaseTeamMember> ctmtoDelete = new List<CaseTeamMember>();
    
    if(cidUserIdMap != null && cidUserIdMap.size()>0 ){
        List<CaseTeamMember> ctmList =[Select id,ParentId,MemberId from  CaseTeamMember where ParentId in : cidUserIdMap.keySet() ];
        for(CaseTeamMember ctmobj:ctmList){
            if(cidUserIdMap.containskey(ctmobj.ParentId) )
            {
                Set<id> useridset = cidUserIdMap.get(ctmobj.ParentId);
                if(useridset.contains(ctmobj.MemberId))
                {
                    ctmtoDelete.add(ctmobj);
                }
                
            }
            
        }
    }
    
    if(caseShareList != null && caseShareList.size()>0)
    {
        DataBase.insert(caseShareList,false);
    }
    if(ctmtoDelete != null && ctmtoDelete.size()>0)
     DataBase.delete(ctmtoDelete,false);
    
}

}