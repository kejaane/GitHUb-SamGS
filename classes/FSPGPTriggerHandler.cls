/*=========================================================================================
 * Date         : 08/21/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This is a trigger handler class for custom object(FSP_GP__c). 
 *                It contains methods called from FSPGPTrigger when the records are inserted and deleted
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================

 *=========================================================================================
 */
 
public class FSPGPTriggerHandler extends TriggerHandler{
    
    // This method will be called when there is a after insert operation
    protected override void afterInsert(){
            
         updateFSPGPOppField(trigger.new);
          
         processBrokerHubFSPGPInsert(trigger.new);
    }
    // This method will be called when there is a before delete operation
    protected override void beforeDelete(){
            
            deleteFSPGPValidation(trigger.old);
    }
    // Method for validating the profile user to delete records
    private void deleteFSPGPValidation(list<FSP_GP__c> fspgpList){
        try{
                String bccProfileName = 'BCC RUL Custom';    //for all no delete access  
                Set<String> nonBCCProfiles = new Set<String>{'2+ Standard User - Custom','51+ Standard User - Custom'};//if sold & primary no delete option
                String strProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
                system.debug('strProfileName>>>> '+strProfileName);
                Set<Id> oppIdSet = new Set<Id>();
                for(FSP_GP__c c : fspgpList){
                    oppIdSet.add(c.Opportunity__c);
                }
                Map<id, Opportunity> oppMap;
                if(oppIdSet.size()>0){
                    oppMap = new Map<id, Opportunity>([Select id, StageName from Opportunity where id in: oppIdSet]);
                }
                for(FSP_GP__c c : fspgpList){
                    if(strProfileName == bccProfileName){
                        c.addError('This Profile user dont have access to delete FSPGP ');
                    }else if(nonBCCProfiles.contains(strProfileName) && oppMap != null && oppMap.get(c.Opportunity__c).StageName == 'Sold' ){
                        c.addError('This Profile user dont have access to delete FSPGP');
                    }
                }
                
                
            }
            catch(Exception e){
                system.debug('***Exception Message***'+e.getMessage());
                for(FSP_GP__c c : fspgpList){
                    c.addError('There was a problem deleting the FSP GP');
                }
            }
    }
    
    // Method to update the Opportunity picklist fields FullServiceProducer__c  and GeneralProducer__c
    private void updateFSPGPOppField(list<FSP_GP__c> fspgpList){
        List<Opportunity> updateOppList = new List<Opportunity>();
        Map<ID,Opportunity> oppMap = new Map<ID,Opportunity>();
        // iterate the new FSP or GP record
        for(FSP_GP__c f : fspgpList){
            if(!oppMap.containsKey(f.Opportunity__c)){
                Opportunity opp = new Opportunity(id = f.Opportunity__c);
                
                // Update the opportunit
                if(f.FSP_GP__c == 'FSP'){
                    opp.FullServiceProducer__c = f.Partner__c;
                    opp.GeneralProducer__c = '';
                }
                else if(f.FSP_GP__c == 'GP'){
                    opp.FullServiceProducer__c = '';
                    opp.GeneralProducer__c= f.Partner__c;
                }
                updateOppList.add(opp);
                oppMap.put(f.Opportunity__c,opp);
             }   
        }
        
        // Updating the Opportunity
        if(updateOppList.size() > 0){
            update updateOppList;
        }    
    }
    
    
    private void processBrokerHubFSPGPInsert(list<FSP_GP__c> fspgpList){
        if(System.isBatch() || System.isFuture()){
            return;
        }   
        else{
            list<Opportunity> oppList = new list<Opportunity>();
            list<Id> oppIds = new list<Id>();
            for(FSP_GP__c ocr : fspgpList){
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