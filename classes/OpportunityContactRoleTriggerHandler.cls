/*=========================================================================================
 * Date         : 08/21/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This is a trigger handler class for custom opportunity contact role object(Opportunity_Contact_Role__c). 
 *                It contains methods called from OpportunityContactRoleTrigger  when the records are inserted and deleted
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================

 *=========================================================================================
 */
 
public class OpportunityContactRoleTriggerHandler extends TriggerHandler {

    // This method will be called when there is a before insert operation
    protected override void beforeInsert(){
           
            createStdContactRoleInsert(trigger.new);
    }
    // This method will be called when there is a before update operation
    protected override void beforeUpdate(){
           
            updateStdContactRoleUpdate(trigger.new);
    }
    
    // This method will be called when there is a after insert operation
    protected override void afterInsert(){
           
            processBrokerHubOppContactRoleInsert(trigger.new);
    }
    
    // This method will be called when there is a before delete operation
    protected override void beforeDelete(){
            
            deleteStdContactRoleInsert(trigger.old);
    }
     // This method will be called when there is a after delete operation
    protected override void afterDelete(){
             
          hardDeleteCustomOCR(trigger.old);
    }
    private void hardDeleteCustomOCR(list<Opportunity_Contact_Role__c> ocrList){        
          Database.emptyRecycleBin(ocrList);
    }
    //Method to delete the standard contact role records corresponding to the seleted custom opportunity contact role record
    private void deleteStdContactRoleInsert(list<Opportunity_Contact_Role__c> ocrList){
            try{
                String bccProfileName = 'BCC RUL Custom';//'51+ NPN Management-Custom';    //for all no delete access  
                Set<String> nonBCCProfiles = new Set<String>{'2+ Standard User - Custom','51+ Standard User - Custom'};//if sold & primary no delete option
                String strProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
                system.debug('In Trigger strProfileName>>>> '+strProfileName);
                list<OpportunityContactRole> deleteOCRList = new list<OpportunityContactRole>();
                Set<Id> oppIdSet = new Set<Id>();
                for(Opportunity_Contact_Role__c c : ocrList){
                    oppIdSet.add(c.Opportunity__c);
                }
                Map<id, Opportunity> oppMap;
                if(oppIdSet.size()>0){
                    oppMap = new Map<id, Opportunity>([Select id, StageName from Opportunity where id in: oppIdSet]);
                }
                // To retrieve the standard contact roles based on the Standard_Contact_Role_ID__c field in deleted custom contact roles
                for(Opportunity_Contact_Role__c c : ocrList){
                    
                    if(strProfileName == bccProfileName){
                        c.addError('This Profile user dont have access to delete contact role');
                    }else if(nonBCCProfiles.contains(strProfileName) && oppMap != null && oppMap.get(c.Opportunity__c).StageName == 'Sold' && c.Primary__c == true){
                        c.addError('This Profile user dont have access to delete contact role for Primary records');
                    }else{
                        OpportunityContactRole ocr = new OpportunityContactRole(id=c.Standard_Contact_Role_ID__c);
                        deleteOCRList.add(ocr);
                    }
                }
                system.debug('deleteOCRList>>>>>'+deleteOCRList);
                //deleting the standard contact roles
                if(deleteOCRList.size() > 0){
                    delete deleteOCRList;
                }
            }
            catch(Exception e){
                system.debug('***Exception Message***'+e.getMessage());
                for(Opportunity_Contact_Role__c c : ocrList){
                    c.addError('There was a problem deleting the Contact Role');
                }
            }
    }
     //Method to create the standard contact role records corresponding to the newly created custom opportunity contact role record
    private void updateStdContactRoleUpdate(list<Opportunity_Contact_Role__c> ocrList){ 
            try{
                system.debug('In updateStdContactRoleUpdate'+ocrList.size());
                list<OpportunityContactRole> updateOCRList = new list<OpportunityContactRole>();
                list<OpportunityContactRole> currentOCRList= new list<OpportunityContactRole>();
                Set<Id> ocrStndrdIds = new Set<Id>();
                Map<String,Id> ocrIdMap = new Map<String,Id>();
                Database.SaveResult[] srList;
                Map<Id, Opportunity_Contact_Role__c> ocrMap = new Map<Id, Opportunity_Contact_Role__c> ([select Id,Standard_Contact_Role_ID__c,Contact_Name__c,Primary__c,Role__c,Opportunity__r.StageName from Opportunity_Contact_Role__c where id in :ocrList ]);
                system.debug('In updateStdContactRoleUpdate ocrMap>> '+ocrMap);
                if(ocrMap.size() > 0){
                    for(Opportunity_Contact_Role__c c : ocrList){                    
                        if(ocrMap.containsKey(c.id)){
                            system.debug('In updateStdContactRoleUpdate c>> '+c);
                            ocrStndrdIds.add(c.Standard_Contact_Role_ID__c);
                        }
                    }
                    system.debug('In updateStdContactRoleUpdate ocrStndrdIds>> '+ocrStndrdIds);
                    Map<Id,OpportunityContactRole> standaardOCRMap = new Map<Id, OpportunityContactRole> ([select Id,ContactId,IsPrimary,Role from OpportunityContactRole where id in: ocrStndrdIds]);
                    system.debug('In updateStdContactRoleUpdate standaardOCRMap>> '+standaardOCRMap);
                    for(Opportunity_Contact_Role__c c : ocrList){
                        system.debug('In updateStdContactRoleUpdate stndrd c>> '+c);
                        if(standaardOCRMap.containsKey(c.Standard_Contact_Role_ID__c)){
                            OpportunityContactRole stndrdOcr = standaardOCRMap.get(c.Standard_Contact_Role_ID__c);
                            stndrdOcr.ContactId = c.Contact_Name__c;
                            stndrdOcr.Role = c.Role__c;
                            stndrdOcr.IsPrimary = c.Primary__c;
                            updateOCRList.add(stndrdOcr);
                            system.debug('In updateStdContactRoleUpdate stndrdOcr>> '+stndrdOcr);                       
                        }
                    }
                    system.debug('In updateStdContactRoleUpdate updateOCRList.size()>> '+updateOCRList.size()); 
                    //inserting the standard contact roles
                    if(updateOCRList.size() > 0){
                        srList = Database.update(updateOCRList, false);
                    }
                    
                    // iterate the save results list and map the corresponding custom and standard contact role records
                    if(srList != null){
                        for(Database.SaveResult sr : srList){
                                                
                            if (sr.isSuccess()){
                                
                            }
                            else{
                                for(Database.Error err : sr.getErrors()){
                                    System.debug('The following error has occurred.'+err.getMessage());                   
                                }
                            }
                            
                        }
                    }
                }
            }
            catch(Exception e){
                system.debug('***Exception Message***'+e.getMessage());
                for(Opportunity_Contact_Role__c c : ocrList){
                    c.addError('There was a problem updating the Contact Role');
                }
            }
        
    }
    //Method to create the standard contact role records corresponding to the newly created custom opportunity contact role record
    private void createStdContactRoleInsert(list<Opportunity_Contact_Role__c> ocrList){ 
            try{
                list<OpportunityContactRole> insertOCRList = new list<OpportunityContactRole>();
                list<OpportunityContactRole> currentOCRList= new list<OpportunityContactRole>();
                list<Id> oppIds = new list<Id>();
                Map<String,Id> ocrIdMap = new Map<String,Id>();
                Database.SaveResult[] srList;
            
                for(Opportunity_Contact_Role__c c : ocrList){
                    oppIds.add(c.Opportunity__c);
                    OpportunityContactRole ocr = new OpportunityContactRole();
                    
                    // inserts to contact roles
                    ocr = new OpportunityContactRole(ContactId = c.Contact_Name__c,OpportunityId = c.Opportunity__c,Role = c.Role__c);
                    if(c.Role__c == 'Primary Broker'){
                        ocr.IsPrimary = true;
                    }
                      
                    insertOCRList.add(ocr);
                }
                
                //inserting the standard contact roles
                if(insertOCRList.size() > 0){
                    srList = Database.insert(insertOCRList, false);
                }
                
                // iterate the save results list and map the corresponding newly created custom and standard contact role records
                integer i=0,j;
                for(Database.SaveResult sr : srList){
                    j=0;
                    
                    if (sr.isSuccess()){
                        for(Opportunity_Contact_Role__c c : ocrList){
                            if(i == j){
                                // Store the standard Contact role record ID in the custom field Standard_Contact_Role_ID__c on the custom record
                                c.Standard_Contact_Role_ID__c   = sr.getId();
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
                for(Opportunity_Contact_Role__c c : ocrList){
                    c.addError('There was a problem creating the Contact Role');
                }
           }
        
    }
    
    // Call out to the BrokerHubService Class
    private void processBrokerHubOppContactRoleInsert(list<Opportunity_Contact_Role__c> ocrList){
        if(System.isBatch() || System.isFuture()){
            return;
        }   
        else{
            list<Opportunity> oppList = new list<Opportunity>();
            list<Id> oppIds = new list<Id>();
            for(Opportunity_Contact_Role__c ocr : ocrList){
                oppIds.add(ocr.Opportunity__c);
            }
            oppList = [SELECT id,stagename,NASCO_Acct_ID__c,Business_Type__c,Account.AccountNumber,Account.Name,Effective_Date__c,
            Contract_End_Date__c,System__c,Lead_Rep_Name_User__r.Name,Lead_Rep_Number__c,Lead_Rep_Number_User__c,Division__c FROM Opportunity where Id IN: oppIds];
            system.debug('oppList*****'+oppList);
            if(!Test.isRunningTest()){
            BrokerHubServiceNew.processSoldOpportunityDetails(oppList);
            }
        }
    }
    
   
}