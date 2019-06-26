/*=========================================================================================
 * Date         : 08/21/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This is a trigger handler class for custom partner object(Partner__c). 
 *                It contains methods called from PartnerTrigger when the records are inserted and deleted
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 * 1/12/2017  Satya             Added update method to update Std Partner related list when there is a change in Custom Related list when opp is in proposal stage
 * 3/16/2017  satya      TO1    Added If condition in the updateStdPartnerInsert method to check if thre is a match for custom object record in the standard object
 *===========+============+================================================================

 *=========================================================================================
 */
 
public class PartnerTriggerHandler extends TriggerHandler {

    // This method will be called when there is a before insert operation
    protected override void beforeInsert(){
            
          createStdPartnerInsert(trigger.new);
    }
    
    // This method will be called when there is a before update operation
    protected override void beforeUpdate(){
          //Delete and insert new standard Partner records when custome partner record updated
          updateStdPartnerInsert(trigger.new, (Map<ID,Partner__c>)trigger.oldMap);
    }
    
    // This method will be called when there is a after insert operation
    protected override void afterInsert(){
           
          processBrokerHubPartnerInsert(trigger.new);
    }
    
    // This method will be called when there is a before delete operation
    protected override void beforeDelete(){
             
          deleteStdPartnerInsert(trigger.old);
    }
     // This method will be called when there is a after delete operation
    protected override void afterDelete(){
             
          deleteCustomPartner(trigger.old);
    }
    private void deleteCustomPartner(list<Partner__c> pList){       
        Database.emptyRecycleBin(pList);
    }
    
    //Method to delete the standard partner records corresponding to the seleted custom opportunity partner record
    private void deleteStdPartnerInsert(list<Partner__c> pList){
            try{
                String bccProfileName = 'BCC RUL Custom';    //for all no delete access  
                Set<String> nonBCCProfiles = new Set<String>{'2+ Standard User - Custom','51+ Standard User - Custom'};//if sold & primary no delete option
                String strProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
                system.debug('strProfileName>>>> '+strProfileName);
                list<Partner> deleteStdPartnerList = new list<Partner>();
                Set<Id> oppIdSet = new Set<Id>();
                for(Partner__c c : pList){
                    oppIdSet.add(c.Opportunity__c);
                }
                Map<id, Opportunity> oppMap;
                if(oppIdSet.size()>0){
                    oppMap = new Map<id, Opportunity>([Select id, StageName from Opportunity where id in: oppIdSet]);
                }
                for(Partner__c c : pList){
                    if(strProfileName == bccProfileName){
                        c.addError('This Profile user dont have access to delete Partner ');
                    }else if(nonBCCProfiles.contains(strProfileName) && oppMap != null && oppMap.get(c.Opportunity__c).StageName == 'Sold' && c.Primary__c == true){
                        c.addError('This Profile user dont have access to delete Partner for Primary records');
                    }else{
                        //Partner p = new Partner(id=c.Standard_Partner_ID__c);
                       List<Partner> PartnerList = [select id from Partner where id= :c.Standard_Partner_ID__c ];
                       if(PartnerList[0] != null && PartnerList.size() > 0){
                        
                        deleteStdPartnerList.add(PartnerList[0]);
                        }
                    }   
                }
                
                //deleting the standard partners
                if(deleteStdPartnerList.size() > 0){
                    delete deleteStdPartnerList ;
                }
            }
            catch(Exception e){
                system.debug('***Exception Message***'+e.getMessage());
                for(Partner__c c : pList){
                    c.addError('There was a problem deleting the Partner');
                }
            }
    }
    
    private void updateStdPartnerInsert(List<Partner__c> pList, Map<ID,Partner__c> partnerOldMap){
        //List<Partner__c> partList = [select Id,Standard_Partner_ID__c,Partner__c,Primary__c,Role__c,Opportunity__r.StageName from Partner__c where id in :pList];
        Map<Id, Partner__c> partListMap = new Map<Id, Partner__c> ([select Id,Standard_Partner_ID__c,Partner__c,Primary__c,Role__c,Opportunity__r.StageName from Partner__c where id in :pList]);
        Map<Id,Partner__c> partnerMap = new Map<Id,Partner__c>();
        List<Partner__c> newstndrdPtnrLst = new List<Partner__c> ();
        for(Partner__c newpartnerRec : pList){
            if(partListMap.containsKey(newpartnerRec.id)){
                system.debug('newpartnerRec>>>>>'+newpartnerRec);
                Partner__c  oldPartnerRec = partnerOldMap.get(newpartnerRec.id);
                if(oldPartnerRec.Partner__c != newpartnerRec.Partner__c || oldPartnerRec.Role__c != newpartnerRec.Role__c ){
                    system.debug('in if Map newpartnerRec>>'+newpartnerRec);
                    partnerMap.put(newpartnerRec.Standard_Partner_ID__c, newpartnerRec);
                    newstndrdPtnrLst.add(newpartnerRec);
                }
            }   
        }
        system.debug('newstndrdPtnrLst >>>> '+newstndrdPtnrLst);
        system.debug('partList.size >>>> '+partnerMap.keySet().size());
        if(partnerMap.keySet().size()>0){
            //Partner standardPartnerList = [select id from Partner where id in : partnerMap.keySet() ];
            List<Partner> standardPartnerList = [select id from Partner where id in : partnerMap.keySet() ];
            // SATYA TO1- This was added to resolve when the standard object is missing the match record on custom object
            if(standardPartnerList != null && standardPartnerList.size() > 0){
                delete standardPartnerList;
             }   
            system.debug('newstndrdPtnrLst >>>> '+newstndrdPtnrLst);
            createStdPartnerInsert(newstndrdPtnrLst);
        }
        
    
    }
    
     //Method to create the standard partner records corresponding to the newly created custom partner record
    private void createStdPartnerInsert(list<Partner__c> pList){ 
            try{
                list<Partner> insertStdPartnerList = new list<Partner>();
                list<Partner> currentPartnerList= new list<Partner>();
                list<Id> oppIds = new list<Id>();
                Map<String,Id> partnerIdMap = new Map<String,Id>();
                Database.SaveResult[] srList;
                
                for(Partner__c c : pList){
                    oppIds.add(c.Opportunity__c);
                    Partner p = new Partner();
                    
                    // inserts to standard partners
                    p = new Partner(AccountToId = c.Partner__c,OpportunityId = c.Opportunity__c,Role = c.Role__c);
                    if(c.Role__c == 'Broker'){
                        p.IsPrimary = true;
                    }
                    insertStdPartnerList.add(p);
                }    
                
                //inserting the standard partners
                if(insertStdPartnerList.size() > 0){
                    srList = Database.insert(insertStdPartnerList, false);
                }
                
                 // iterate the save results list and map the corresponding newly created custom and standard partner records
                integer i=0,j;
                for(Database.SaveResult sr : srList){
                    j=0;
                    
                    if(sr.isSuccess()){
                        for(Partner__c c : pList){
                            if(i == j){
                                // Store the standard Partner record ID in the custom field Standard_Partner_ID__c on the custom record
                                c.Standard_Partner_ID__c= sr.getId();
                             }
                             j++;   
                        }
                    }
                    else{
                        for(Database.Error err : sr.getErrors()){
                            System.debug('The following error has occurred.'+err.getMessage());                   
                        }
                    }
                    i++;
                }    
            }
            catch(Exception e){
                system.debug('***Exception Message***'+e.getMessage());
                for(Partner__c c : pList){
                    c.addError('There was a problem creating the Partner');
                }
            }
    
    }
    private void processBrokerHubPartnerInsert(list<Partner__c> pList){
        if(System.isBatch() || System.isFuture()){
            return;
        }   
        else{
            list<Opportunity> oppList = new list<Opportunity>();
            list<Id> oppIds = new list<Id>();
            for(Partner__c ocr : pList){
                oppIds.add(ocr.Opportunity__c);
            }
            oppList = [SELECT id,stagename,System__c,NASCO_Acct_ID__c FROM Opportunity where Id IN: oppIds];
            system.debug('oppList*****'+oppList);
             if(!Test.isRunningTest()){
            BrokerHubServiceNew.processSoldOpportunityDetails(oppList);
            }
       }
    }
         
}