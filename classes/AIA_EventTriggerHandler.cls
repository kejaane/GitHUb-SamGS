/*=========================================================================================
* Date         : 05/31/2016
* Developer    : Sree Harsha Akkala
* Purpose      : This class is the extension point of the Trigger Framework for adding 
*                Event trigger handlers.    
*==========================================================================================
*                                 Update History
*                                 ---------------
* Date          Developer             Tag   Description
*==========================================================================================
* 05/31/16   | Sree Harsha Akkala   |     | Initial Version                                         
* 06/01/17   | Goutham Rapolu       | T01 | Remove references to Update ARC fields from 
*                                           AIA Event as per US B-04016
* 01/30/2018 | Asif Kutagulla       | T02 | Fix for null pointer exception
* 01/31/2019 | Satya T              | T03 | Replaced standard Account Team Member with Custom Account Team Member.
*==========================================================================================
*/
public with sharing class AIA_EventTriggerHandler extends TriggerHandler {
    public static boolean firstRun=false;

    
        public AIA_EventTriggerHandler() {}
        
            /* context override */
        protected override void beforeUpdate() {
            OpenEnrollmentMeetingChk(trigger.new,(Map<id,event>)trigger.oldMap);
        }
        
        protected override void beforeInsert() {
            
        }
           
        protected override void afterInsert() {
         if(!firstRun)    
            BidMeetingUpdate((Map<id,event>) trigger.oldMap,(list<event>) trigger.new);
        }
        
        protected override void afterUpdate() {
         if(!firstRun)   
            BidMeetingUpdate((Map<id,event>) trigger.oldMap,(list<event>) trigger.new);
        }

    public static final string BID_MEETING ='Bid Meeting';
    public static final string BID ='Bid';
    public static final string NO_BID ='No Bid';
    public static final string NO_DECISION='No Decision';
    public static Id rt_acc_51= QueryBase.getRecordtypeId('Event', 'AIA_Meeting');
    public static Id rt_Open_EMeeting= QueryBase.getRecordtypeId('Event', 'AIA_Open_Enrollment_Meeting');
    public static final string IMPLEMENTATION_PM = 'Implementation Manager';
    public static final string SALES_ASSISTANT = 'Sales Assistant';
    public static final string ERROR1 = 'Please contact your System Administrator for modification on the record';
    public static final string accountPreFix ='001';

    private  void  BidMeetingUpdate(Map<id,event> eventOldMap,list<event> eventList){
        try{
        list<event> PRFeventList = new list<event>();
        list<event> BRFeventList = new list<event>();
        list<event> updateEventList = new list<event>();
       

        for(event e: eventList){
            //if(schema.PRF__c.sObjectType == id.valueof(e.whatId).getsObjectType() || schema.Benfit_Request_Form__c.sObjectType == id.valueof(e.whatId).getsObjectType()){
            //Puts all the events related to a PRF into a list
            Id rcdId= QueryBase.getRecordtypeId('Event','AIA_Meeting');
            if(e.whatId!=null && rcdId!=null && schema.PRF__c.sObjectType == id.valueof(e.whatId).getsObjectType()){
                if(trigger.isInsert)
                   PRFeventList.add(e);
                if(trigger.isUpdate){
                    if(eventOldMap.get(e.id).Bid_Meeting_Decision__c!=null)
                    PRFeventList.add(e);
                    else
                    updateEventList.add(e);
                }
            }
            //Puts all the events related to a BRF into a list
            if(e.whatId!=null && rcdId!=null && schema.Benfit_Request_Form__c.sObjectType == id.valueof(e.whatId).getsObjectType()){
                 BRFeventList.add(e);
            }
            
           
        }
        //Invokes the PrevDuplicateBidDecisions method upon Inserting an event for a PRF
        if(trigger.isInsert && PRFeventList!=null)
            PrevDuplicateBidDecisions(PRFeventList);

        //Invokes the PrevDuplicateBidDecisions,PrevEditing,updatePRF methods upon updating an event for a PRF
        if(trigger.isUpdate && PRFeventList!=null){
            PrevDuplicateBidDecisions(updateEventList);
            //AIA_EventHandler.PrevEditing(PRFeventList);
            updatePRF(updateEventList);
        }

    /***************************T01 START*******************/
        //Invokes the UpdateBRF method to update the related BRF record
        if(BRFeventList!=null){
            UpdateBRF(BRFeventList);
        }
    /***************************T01 END********************/   
        
        }
        catch(exception e){
          system.debug('@@ in exception'+e.getMessage());
        }
        }   
    /*******************************************************************
    Purpose:  The method prevents creation of events with BID or NO BID if the meeting decision is taken
    Parameters: List<event>
    Returns: None                                                        
    ********************************************************************/    

    public static void PrevDuplicateBidDecisions(list<event> NewPRFEvents){
        try{
        set<id> PRFIdSet = new set<id>();
        set<id> eventIdSet = new set<id>();
        for(event e:NewPRFEvents){
            PRFIdSet.add(e.whatId);
            eventIdSet.add(e.id);
        }
        
        list<event> ExistingPRFEvents = [select id,Bid_Meeting_Decision__c,Meeting_Type__c,whatId,RecordTypeId from event where whatId in:PRFIdSet AND isdeleted = false and  id NOT IN :eventIdSet];
        //Id rt_acc_51= QueryBase.getRecordtypeId('Event', 'AIA_Meeting');
        if(rt_acc_51 != null){
            for(event existingEvent:ExistingPRFEvents){
                for(event newEvent: NewPRFEvents){
                    if(existingEvent.whatId==newEvent.whatId && rt_acc_51 == newEvent.RecordTypeId){
                        if(newEvent.Meeting_Type__c == BID_MEETING && existingEvent.Meeting_Type__c != null){
                            if(newEvent.Bid_Meeting_Decision__c != null){
                                if((existingEvent.Bid_Meeting_Decision__c == BID|| existingEvent.Bid_Meeting_Decision__c == NO_BID) && (newEvent.Bid_Meeting_Decision__c == BID || newEvent.Bid_Meeting_Decision__c == NO_BID)){
                                   newEvent.addError('You cannot create another event when it is already '+existingEvent.Bid_Meeting_Decision__c); 
                                }
                            }else if(existingEvent.Bid_Meeting_Decision__c == null){
                                if(newEvent.Bid_Meeting_Decision__c == BID || newEvent.Bid_Meeting_Decision__c == NO_BID){
                                    newEvent.addError('You cannot create another event when it is already '+existingEvent.Bid_Meeting_Decision__c); 
                                }
                            }
                        }
                    }
                }           
            }
            updatePRF(NewPRFEvents);
        }
        }
        catch(exception e){
            system.debug('@@ in exception'+e.getMessage());
        }
    }

    /*******************************************************************
    Purpose:  The method updates the PRF record fields finalmeetingdecision,OriginalBidDate,FinalDecisionDate & NoBidCommments
    Parameters: List<event>
    Returns: None                                                        
    ********************************************************************/    
    public static void updatePRF(list<event> NewPRFEvents){
        try{
        set<id> PRFIdSet = new set<id>();
        for(event e:NewPRFEvents){
            PRFIdSet.add(e.whatId);
        }

        list<event> ExistingPRFEvents = [select id,createdDate,Bid_Meeting_Decision__c,Meeting_Type__c,No_Bid_Comments__c,whatId from event  where whatId in:PRFIdSet and isdeleted = false order by createdDate ASC];
        list<PRF__c> PRFList = new list<PRF__c>();
        PRFList=[select id,Final_Bid_Decision__c from PRF__c where id in:PRFIdSet];
        Map<id,list<event>> PRFEventsMap = new Map<id,list<event>>();

        if(ExistingPRFEvents.size()>0){
            for(event e: ExistingPRFEvents){
                list<event> tempEventList = new list<event>();
                if(PRFEventsMap.get(e.whatId)==null){
                    tempEventList.add(e);
                    PRFEventsMap.put(e.whatId,tempEventList);
                }
                else{
                    tempEventList.addAll(PRFEventsMap.get(e.whatId));
                    tempEventList.add(e);
                    PRFEventsMap.put(e.whatId,tempEventList);
                }
            }
        }

        if(PRFList.size()>0 || PRFList != null){
        for(PRF__c prf: PRFList){
            for(event e:PRFEventsMap.get(prf.id)){
                if(e.Meeting_Type__c == BID_MEETING){
                prf.Original_Bid_Date__c = e.createdDate.date();
                break;
                }
            }
        }
        for(PRF__c prf: PRFList){
            for(event e:PRFEventsMap.get(prf.id)){
                
                if(e.Bid_Meeting_Decision__c==BID){
                    prf.Final_Bid_Decision__c=BID;
                    prf.Final_Decision_Date__c=e.createdDate.date();
                    break;
                }
                if(e.Bid_Meeting_Decision__c==NO_BID){
                    prf.Final_Bid_Decision__c=NO_BID;
                    prf.Final_Decision_Date__c=e.createdDate.date();
                    if(e.No_Bid_Comments__c!=null)
                    prf.No_Bid_Comments__c= e.No_Bid_Comments__c;
                    break;
                }
                if(e.Bid_Meeting_Decision__c==NO_DECISION){
                    prf.Final_Bid_Decision__c=NO_DECISION;                    
                }               
            }
        }
        update PRFList;             
    }
    }
    catch(exception e){
          system.debug('@@ in exception'+e.getMessage());
       }
    }

    /*******************************************************************
    Purpose:  The method updates the BRF record with ARCApprovalStatus & ARCcomments
    Parameters: List<event>
    Returns: None                                                        
    ********************************************************************/    
  /***************************T01 START*******************/
    public static void updateBRF(list<event> NewBRFEvents){
        try{
        set<id> BRFIdSet = new set<id>();
        for(event e:NewBRFEvents){
            BRFIdSet.add(e.whatId);
        }
        AIA_Senior_Management__c AIASMCS = AIA_Senior_Management__c.getOrgDefaults();
        AIASMCS.AIA_Senior_Management__c = true;
        upsert AIASMCS; 
        list<event> ExistingBRFEvents = [select id,createdDate,Approval_Meeting_Decision__c,ARC_Meeting_Comments__c,Meeting_Type__c,No_Bid_Comments__c,whatId,RecordTypeId 
                                         from event  
                                         where whatId in:BRFIdSet and 
                                                isdeleted = false and 
                                                RecordType.DeveloperName='AIA_Meeting' 
                                         order by createdDate ASC 
                                         limit 1000];
        list<Benfit_Request_Form__c> BRFList = new list<Benfit_Request_Form__c>();
        BRFList=[select id,ARC_Approval_Status__c,ARC_Comments__c from Benfit_Request_Form__c where id in:BRFIdSet];
        Map<id,list<event>> BRFEventsMap = new Map<id,list<event>>();
        if(ExistingBRFEvents.size()>0){
            for(event e: ExistingBRFEvents){
                list<event> tempEventList = new list<event>();
                if(BRFEventsMap.get(e.whatId)==null){
                    tempEventList.add(e);
                    BRFEventsMap.put(e.whatId,tempEventList);
                }
                else{
                    tempEventList.addAll(BRFEventsMap.get(e.whatId));
                    tempEventList.add(e);
                    BRFEventsMap.put(e.whatId,tempEventList);
                }
            }
        }
        system.debug('BRFList>>>>'+BRFList);
        if(BRFList.size()>0 || BRFList != null){
            for(Benfit_Request_Form__c brf: BRFList){
                if(BRFEventsMap.containskey(brf.id)) { //T02
                    for(event e:BRFEventsMap.get(brf.id)){
                        if(rt_acc_51 != null){
                            system.debug('BRFList>>>trigger.isUpdate>'+trigger.isUpdate);
                            if(e.Meeting_Type__c == 'ARC Approval Meeting' && rt_acc_51 == e.RecordTypeId && e.Approval_Meeting_Decision__c!=null){
                                if(e.Approval_Meeting_Decision__c=='No Decision' )
                                brf.Escalated_to_Senior_Management__c = true;
                                break;
                            }
                        }
                    }
                }
            }
            
            update BRFList;
            AIASMCS.AIA_Senior_Management__c = false;
            upsert AIASMCS;
        }
        }
        catch(exception e){
            String S1 = e.getMessage();
            if(S1.containsIgnoreCase('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                S1 = S1.substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION, ' , ': [');    
            }
            for(event et : newBRFEvents){
                et.addError(S1);
            }
        }
        }   
 /***************************T01 END*******************/
            
   /*******************************************************************
    Purpose:  The method checks if current user is system admin/creator/having accRoleName, then can do updation. Otherwise through error
    Parameters: List<event>
    Returns: None                                                        
    ********************************************************************/ 
    
    public static void OpenEnrollmentMeetingChk(list<event> NewBRFEvents,Map<id,event> OldBRFEventMap){
       try{
        List<Profile> profileId =[select id from profile where name='System Administrator' limit 1]; // to get system admin profile Id
        ID Sys_Admin_ID;
        if(profileId != null && profileId.size()>0)
            Sys_Admin_ID = profileId[0].id;
        ID currentUserProfileId = userinfo.getProfileId(); // to get current user profile Id
        Id CurrentUserID = userinfo.getuserId();
        String accIdPrefix=''; 
     
        // To store account Id
        set<Id> setAccountId = new set<Id>();
        for(event e:NewBRFEvents){ 
            //checking if whatId is related to account, then storing it in setAccountId
            system.debug('e.CreatedById>>>>'+e.CreatedById +'currentUserProfileId'+ currentUserProfileId);
            system.debug(rt_Open_EMeeting+'e.RecordTypeId>>>>'+e.RecordTypeId);
            if(rt_Open_EMeeting != null && rt_Open_EMeeting == e.RecordTypeId){         
            if(e.whatId!=null){
            accIdPrefix =  String.valueOf(e.whatId).substring(0,3);
            system.debug('accIdPrefix>>>>'+accIdPrefix);
            
                if(accIdPrefix != null && accountPreFix != null && accIdPrefix == accountPreFix)
                setAccountId.add(e.whatId);
                system.debug('setAccountId>>>>'+ setAccountId);
                }
            }
        }

        //Adding Team role in list
        List<string> accRoleName = New List<String>{IMPLEMENTATION_PM,SALES_ASSISTANT};
        Map<String,String> mapRoleWithUserId = new Map<String,String>();
        if(setAccountId != null){
            /* T03 -- Start*/
            /*For(AccountTeamMember accTeam : [select UserId,AccountId,TeamMemberRole from AccountTeamMember where AccountId IN : setAccountId and TeamMemberRole IN: accRoleName]){
                mapRoleWithUserId.put(accTeam.UserID,accTeam.TeamMemberRole);
            }*/
            For(Account_Team__c accTeam : [select UserId__c,AccountId__c,TeamMemberRole__c from Account_Team__c where AccountId__c IN : setAccountId and TeamMemberRole__c IN: accRoleName]){
                mapRoleWithUserId.put(accTeam.UserId__c,accTeam.TeamMemberRole__c );
            }
             /*T03 --- End*/
        }
        system.debug('mapRoleWithUserId>>>>'+mapRoleWithUserId);
        system.debug('rt_Open_EMeeting>>>>'+rt_Open_EMeeting);
        system.debug('currentUserProfileId>>>>'+currentUserProfileId);
        system.debug('Sys_Admin_ID>>>>'+Sys_Admin_ID);
        for(event e:NewBRFEvents){
            system.debug('e.CreatedById>>>>'+e.CreatedById +'currentUserProfileId'+ currentUserProfileId);
            system.debug(rt_Open_EMeeting+'e.RecordTypeId>>>>'+e.RecordTypeId);
            if(rt_Open_EMeeting != null && rt_Open_EMeeting == e.RecordTypeId){
                boolean allowSignUp=true;
                if(OldBRFEventMap.get(e.id).meeting_status__c!=null && e.meeting_status__c!=null && OldBRFEventMap.get(e.id).current__c!=null && e.current__c!=null){
                if(OldBRFEventMap.get(e.id).meeting_status__c ==e.meeting_status__c && OldBRFEventMap.get(e.id).current__c==e.current__c)
                    allowSignUp=false;
                }
                if(mapRoleWithUserId != null && !mapRoleWithUserId.isEmpty()){
                    
                     if(!mapRoleWithUserId.containskey(UserInfo.getUserId()) && (currentUserProfileId != Sys_Admin_ID) && (e.CreatedById != CurrentUserID) && !allowSignUp){
                        e.addError(ERROR1);
                        system.debug('1');
                     }
                }else if(currentUserProfileId != null && Sys_Admin_ID != null && CurrentUserID != null){
                    if(currentUserProfileId != Sys_Admin_ID && e.CreatedById != CurrentUserID && !allowSignUp){
                        e.addError(ERROR1); 
                        system.debug('3');
                    }
                }
            }   
        }
       }
       catch(exception e){
          system.debug('@@ in exception'+e.getMessage());
       }
    }
     
    }