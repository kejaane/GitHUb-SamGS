/*****************************************************************************************************
*Date:      03-21-2018
*Developer: Satya Tirumalasetti
*Purpose:   This class contains the logic for the chatter  message to be posted on the user
*           Record when the Account team role or Account Team is mentioned in the post.
*           Assuming there won't be any bulk uploads to chatter, wrote for single record
*================================================================================================
* Update History
* Date         Developer    Tag           Description 
*================================================================================================
* 03-21-2018   Satya                  Initial Development
* 01-28-2019   Satya        T01       Replaced Standard Acc Team with Custom object (Account Team)
*=================================================================================================

*******************************************************************************************************/


//This class will be invoked from AIA_FeedItem_TriggerHandler
public with sharing class AIA_FeedItem_TriggerHelper{
    
    public static final string ActTeam = 'AccountTeam';
    public static final string NCRCASE = 'AIA_NCR_Cases';
    public static final string ACCTCASE = 'AIA_Account_Issue';
    public static final string BDCASE = 'AIA_BD_Cases';
    public static final String Casename = 'Case';

    
    //This method will post chatter msg to Account team or individual user record depending upon what is mentioned
    // in the chatter post 
    Public static void postChatterFeed(List<FeedItem> FeedList){
        
        list<string> bodyList = new list<string>();
        Map<id,list<string>> feedMap = new Map<id,list<string>>();
       // list<AccountTeamMember> accteamlst; T01
        list<Account_Team__c> accteamlst; //T01
        set<Id> userId = new set<Id>();
        List<FeedItem> fItems = new List<FeedItem>();
        List<FeedItem> fItemsSingle = new List<FeedItem>();
        Map<String,Id> mapTeamroleUserid = new Map<String,Id>();
        Map<String,Id> mapTeamroleUseridWithHypen = new Map<String,Id>();
        Id objectID;
        Id AcctId;
        string feed;
        string feedstring;
        String name;
         String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        try{
        //Loop through all the records in the trigger context and get the ParentId and Body
        //for (FeedItem rec : [select ID, body,ParentId FROM FeedItem where id in:FeedList]){
        FeedItem rec = (FeedItem)FeedList[0];
            feed = rec.body;
            system.debug('feed'+feed);
            objectID = rec.ParentId;
            //string feedtrimmed = feed.replaceall('<p>','').trim();
            //string feedstr = feedtrimmed.replaceall('</p>','').trim();
            //feedstring = feedstr.replaceAll('<[^>]+>',' ').trim();
            string feedtrimmed = feed.replaceall('<li>','\\r\\n').trim();
            feedstring = feedtrimmed.stripHtmlTags();
            system.debug('feedstring'+feedstring);
        //}
        
        if(objectID.getSobjectType() != Case.sObjectType){
        name = (string)Database.query('select Name,Id  from ' + objectID.getSobjectType() + ' where id = :objectID')[0].get('Name');
        } else {
        name = Casename;
        }
        
        //Check whether the post is made to record other than user record and if so, continue with the process
        if(objectID.getSobjectType() != user.sObjectType){
            
            //get the account Id
            AcctId = getAccountId(objectID);
            
            system.debug('+++++accId+++'+AcctId);
            
            //If we have an Account ID, then get the list of Account Team Roles and theirs User Id's
            if(!string.isBlank(AcctId)){
              
               //T01 changes start  
              /*  accteamlst = [SELECT UserId,TeamMemberRole 
                                FROM AccountTeamMember 
                                WHERE AccountId =: AcctId AND User.IsActive = TRUE];*/
                                
                 accteamlst = [SELECT TeamMemberRole__c,UserId__c,AccountId__c
                                FROM Account_Team__c
                                where AccountId__c =: AcctId AND UserId__r.IsActive = TRUE];
                
              /* for (AccountTeamMember user : accteamlst){
                    mapTeamroleUserid.put(user.TeamMemberRole.contains(' ')?user.TeamMemberRole.replaceAll(' ','').toUpperCase():user.TeamMemberRole.toUpperCase(),user.UserId);
                    mapTeamroleUseridWithHypen.put(user.TeamMemberRole.contains(' ')?user.TeamMemberRole.replaceAll(' ','')+'_Team':user.TeamMemberRole+'_Team',user.UserId);
                }*/
                system.debug('accteamlst@@@'+accteamlst);
                for (Account_Team__c user : accteamlst){
                    mapTeamroleUserid.put(user.TeamMemberRole__c.contains(' ')?user.TeamMemberRole__c.replaceAll(' ','').toUpperCase():user.TeamMemberRole__c.toUpperCase(),user.UserId__c);
                    mapTeamroleUseridWithHypen.put(user.TeamMemberRole__c.contains(' ')?user.TeamMemberRole__c.replaceAll(' ','')+'_Team':user.TeamMemberRole__c+'_Team',user.UserId__c);
                }
                
                //T01 changes End
                
                system.debug('++mapTeamroleUseridWithHypen++'+mapTeamroleUseridWithHypen);
               
                string feedConverted = feed.toUpperCase();
                system.debug('feedConverted'+feedConverted);
                //Check whether AccountTeam is mentioned in the Chatter Post, if so send chatter post to all members of the Accout Team.
                if(feedConverted.containsIgnoreCase(ActTeam)){
                
                //Get the Account Team member's user Id's
                userId = getUserIdForAccountTeam(feedConverted,mapTeamroleUseridWithHypen);
                
                    system.debug('++inside team post++'+userId);
                    if(userId.size()>0){
                        For(Id uId : userId){
                            FeedItem post = new FeedItem();
                            post.ParentId = uId;
                            post.Body = feedstring + '\n'+'\n'+'Link for '+ name + ' :'+'\n' +sfdcBaseURL+'/'+objectID ;
                            //post.Body = feedstring + '\n'+'\n'+'Link to '+objectID.getSobjectType()+' is :'+'\n' +sfdcBaseURL+'/'+objectID ;
                            if(String.isNotBlank(post.ParentId)){
                                fItems.add(post);
                            }
                        }
                    }
                    
                    if(!fItems.isEmpty()){
                        insert fItems;
                    }
                    
                } else {
                    
                    set<id> usId = new set<id>();
                    system.debug('++inside individual post++');
                  //Get the User Id's  
                  usId = getUserIdForRoles(feedConverted,mapTeamroleUserid);
                   system.debug('usId@@'+usId);                   
                    //If userid set is not empty, create the chatter feed to the user record
                    if(usId.size()>0){
                    
                        For(Id uId : usId){
                            FeedItem post = new FeedItem();
                            post.ParentId = uId;
                            post.Body = feedstring + '\n'+'\n'+'Link for '+ name + ' :'+'\n' +sfdcBaseURL+'/'+objectID ;
                            // post.Body = feedstring + '\n'+'\n'+'Link to '+objectID.getSobjectType()+' is :'+'\n' +sfdcBaseURL+'/'+objectID ;
                            //post.LinkUrl = sfdcBaseURL+'/'+objectID;
                            system.debug('post debug--'+post);
                            if(String.isNotBlank(post.ParentId)){
                                fItemsSingle.add(post);
                            }
                        }
                    }
                    
                    if(!fItemsSingle.isEmpty()){
                        insert fItemsSingle;
                    }
                    
                }
            }
        }
        
        
        
         }catch(Exception e){AIA_Utils util=new AIA_Utils();util.logException(e); }
    } 
    
    
    //Method to get the Account Id by checking the type of Sobject
    Private static string getAccountId(Id objectID){
            
             Id AcctId;
             
            //Check the SobjectType of the parentId that we got from trigger contect records and depending upon that get the Account Id from the record.
            if(objectID.getSobjectType() == Account.sObjectType){
                AcctId = objectID;
            }
            if(objectID.getSobjectType() == Opportunity.sObjectType){
                AcctId = [Select id, AccountId from opportunity where id = :objectID].AccountId;
            }
            if(objectID.getSobjectType() == Benfit_Request_Form__c.sObjectType){
                AcctId = [Select id, Account__c from Benfit_Request_Form__c where id = :objectID].Account__c;
            }
            if(objectID.getSobjectType() == PRF__c.sObjectType){
                AcctId = [Select id, Account_Id__c from PRF__c where id = :objectID].Account_Id__c;
            }
            if(objectID.getSobjectType() == Proposed_Products__c.sObjectType){
                AcctId = [Select id, Account__c from Proposed_Products__c where id = :objectID].Account__c;
            }
            if(objectID.getSobjectType() == AIA_Implementation__c.sObjectType){
                AcctId = [Select id, Account__c from AIA_Implementation__c where id = :objectID].Account__c;
            }
            if(objectID.getSobjectType() == AIA_Benefit_Design__c.sObjectType){
                AcctId = [Select id, Account__c from AIA_Benefit_Design__c where id = :objectID].Account__c;
            }
            if(objectID.getSobjectType() == AIA_Benefit_Design_Product__c.sObjectType){
                AcctId = [Select id, Benefit_Design__r.Account__c from AIA_Benefit_Design_Product__c where id = :objectID].Benefit_Design__r.Account__c;
            }
            if(objectID.getSobjectType() == AIA_Benefit_Design_Form__c.sObjectType){
                AcctId = [Select id, Benefit_Design__r.Account__c from AIA_Benefit_Design_Form__c where id = :objectID].Benefit_Design__r.Account__c;
            }
            if(objectID.getSobjectType() == AIA_Group_Structure_Request_Form__c.sObjectType){
                AcctId = [Select id, Implementation__r.Account__c from AIA_Group_Structure_Request_Form__c where id = :objectID].Implementation__r.Account__c;
            }
            if(objectID.getSobjectType() == AIA_Document__c.sObjectType){
                AcctId = [Select id, Account__c from AIA_Document__c where id = :objectID].Account__c;
            }
            if(objectID.getSobjectType() == ID_Card__c.sObjectType){
                AcctId = [Select id, Implementation__r.Account__c from ID_Card__c where id = :objectID].Implementation__r.Account__c;
            }
            if(objectID.getSobjectType() == Case.sObjectType){
                Case cs = [Select id, RecordType.DeveloperName,Opportunity__c,AIA_Benefit_Design__c,Opportunity__r.AccountId,AIA_Benefit_Design__r.Account__c,AccountId from case where id = :objectID];
                if(cs.RecordType.DeveloperName == NCRCASE){
                    if(!string.isBlank(cs.Opportunity__c)){
                        AcctId = cs.Opportunity__r.AccountId;
                    }else if(!string.isBlank(cs.AIA_Benefit_Design__c)){
                        AcctId = cs.AIA_Benefit_Design__r.Account__c;
                    }
                }
                if(cs.RecordType.DeveloperName == ACCTCASE){
                    if(!string.isBlank(cs.AccountId)){
                        AcctId = cs.AccountId;
                    }
                }
                if(cs.RecordType.DeveloperName == BDCASE){
                    if(!string.isBlank(cs.AIA_Benefit_Design__c)){
                        AcctId = cs.AIA_Benefit_Design__r.Account__c;
                    }
                }
                
            }
          system.debug('AcctId'+AcctId); 
          return AcctId;
        }
        
        
        //Method to get the User Id when individual role is mentioned in the chatter post
        
        Private static set<id> getUserIdForRoles(string feedConverted,Map<String,Id> mapTeamroleUserid){
        set<id> usId = new set<id>();
                    
                    //Get the list of Account Team roles from the Custom MetaData and loop through them to see if any Account Team Role is mentioend
                    // in the chatter post
                    For(AIA_Chatter_Notification_Roles__mdt FRole :[Select id,DeveloperName,Parameter_Value__c 
                                                                    from AIA_Chatter_Notification_Roles__mdt
                                                                    limit 1000]){
                        string role = FRole.DeveloperName;
                        string rolename = role.contains('_Team')?role.Substring(0,role.length()-5):role;
                                                                        
                         system.debug('rolename@@'+rolename);                                             
                        if(feedConverted.containsIgnoreCase(rolename)){
                            system.debug('<<FRole.Parameter_Value__c>>'+FRole.Parameter_Value__c);
                            system.debug('<<mapTeamroleUserid>>'+mapTeamroleUserid);
                            system.debug('<<mapTeamroleUserid.get(FRole.Parameter_Value__c)>>'+mapTeamroleUserid.get(FRole.Parameter_Value__c));
                            usId.add(mapTeamroleUserid.get(FRole.Parameter_Value__c));
                        }
                        
                    }
            	system.debug('usId@@'+usId);
                 return usId;   
         }
         
         
        //Method to get the User Id's when Account Team is mentioned in the chatter post 
        Private static set<id> getUserIdForAccountTeam(string feedConverted,Map<String,Id> mapTeamroleUseridWithHypen){
        set<id> userId = new set<id>();
                    
                    //Get the list of Account Team roles from the Custom MetaData and loop through them to see if any Account Team Role is mentioend
                    // in the chatter post
                    For(AIA_Chatter_Notification_Roles__mdt FRole :[Select id,DeveloperName,Parameter_Value__c 
                                                                    from AIA_Chatter_Notification_Roles__mdt 
                                                                    where DeveloperName LIKE '%_Team']){
                       
                       if(mapTeamroleUseridWithHypen.containsKey(FRole.DeveloperName)){ 
                           userId.add(mapTeamroleUseridWithHypen.get(FRole.DeveloperName));
                       }
                        
                    }
                 return userId;   
         }
    
    
}