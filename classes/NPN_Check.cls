/*=========================================================================================
 * Date         : 09/12/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This class will be called when an opportunity stage is updated as SOLD. 
                  If the associated the brokers/agencies /FSP/FP
                  do not hold a NPN value,the update will be blocked.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 12/20/216  Satya   | Added condition Primary to be True in the where clause 
 *=========================================================================================
 */
 
public class NPN_Check{

    public void updateNPN(list<Opportunity> opp){
    
        String Msg = ' TR - Opportunity Stage cannot be marked as Sold when the Primary Partner and/or Primary Broker Contact Role does not have NPN value(s). <br/> Please click cancel and check the Request NPN field (on the opportunity page) to send an email to the BCC team requesting them to update the missing NPN value(s).'; 
        list<Id> oppIds = new list<Id>();
        integer noNPNList = 0;
        for(Opportunity o : opp){
            oppIds.add(o.Id);
        }
        Map<id, Opportunity_Contact_Role__c> ocrMap = new Map<id, Opportunity_Contact_Role__c>();
        // Check whether the NPN is available on the contact roles (brokers)
        // 12/20/2106 satya. Added primary to be True in the where clause
        List<Opportunity_Contact_Role__c> ocrList = [SELECT id,Opportunity__c,Contact_Name__c,Contact_Name__r.Broker_NPN__c,Contact_Name__r.Name,Role__c FROM Opportunity_Contact_Role__c WHERE Opportunity__c IN: oppIds and Role__c = 'Primary Broker' and Contact_Name__r.Broker_NPN__c = null and Primary__c = True];
        if(ocrList.size() > 0){
           for(Opportunity_Contact_Role__c ocr : ocrList){
                 ocrMap.put(ocr.Opportunity__c,ocr);                  
           }
           for(Opportunity o : opp){
                if(ocrMap.containsKey(o.id)){
                   o.addError(Msg,false);
                   Break;
                }
           }
        }            
        
        Map<id, Partner__c> pMap = new Map<id, Partner__c>();
        // 12/20/2106 satya. Added primary to be True in the where clause
        List<Partner__c> pList = [SELECT id,Partner__c,Opportunity__c,Partner__r.Agency_NPN__c,Role__c FROM Partner__c WHERE Opportunity__c IN: oppIds and Role__c = 'Broker' and Partner__r.Agency_NPN__c = null and Primary__c = True];
        if(pList.size() > 0){
           for(Partner__c p : pList){
                 pMap.put(p.Opportunity__c,p);                  
           }
           for(Opportunity o : opp){
                if(pMap.containsKey(o.id)){
                   o.addError(Msg,false);
                }
           }
        }    
        
     }

} //End of Class