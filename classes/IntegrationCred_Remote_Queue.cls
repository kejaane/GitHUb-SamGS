/*===========================================================================================
 * Date         : 07/10/2018
 * Developer    : Mike Horne, Sree Uma Ponnoju
 * Purpose      : Creating this Queueable class, to make a callout to remote org which
                  allows in updating remote org's credentials
 *===========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *============+=======+======================================================================
 * 
 *============+=======+======================================================================
 */
public class IntegrationCred_Remote_Queue implements Queueable, Database.AllowsCallouts  {  

    Map<Integer,IntegrationCredentialService.Credential> remoteCalloutMap = new Map<Integer,IntegrationCredentialService.Credential>();
    
    public IntegrationCred_Remote_Queue(Map<Integer,IntegrationCredentialService.Credential> m){
       System.debug('Value of m is' + m);
       this.remoteCalloutMap = m;
       System.debug('Value of this.remoteCalloutMap' + this.remoteCalloutMap);
       /*for (MetadataService.NamedCredential NC : namedcreds) {               
               updateNamedcred.add(NC);                
       }*/
    }
        
    public void execute(QueueableContext context) {
        System.debug('The value of remoteCalloutMap is ' + remoteCalloutMap);
        if (!remoteCalloutMap.isEmpty()) {
            Map<Integer,IntegrationCredentialService.Credential> newRemoteCalloutMap = doRemoteOrgUpdates(remoteCalloutMap);
        }
    }        
    
    /*****************************************************************************************
    * Purpose   : Iterate over the remote org credentails objects map 
                  segregates each remote org's credentails and puts them in a map
                  basing on OrgName                
    * Parameters: Map of Credential objects 
    *****************************************************************************************/     
    private static Map<Integer,IntegrationCredentialService.Credential> doRemoteOrgUpdates(Map<Integer,IntegrationCredentialService.Credential> remoteCalloutMap) {
        // Create Map of remote orgs requiring a callout
        // Each callout map entry will contain a map of credentials to serialize as JSON
        Map<String, Map<Integer, IntegrationCredentialService.Credential>> calloutMap = new Map<String, Map<Integer, IntegrationCredentialService.Credential>>();  
        // Map of remote Orgs with orgName as key; populated by custom metadata
        Map<String, CF_Organization__mdt> orgMap = new Map<String, CF_Organization__mdt>();
        for (CF_Organization__mdt org : [Select isActive__c, OrgId__c, OrgName__c, OrgNamedCred__c
                                         From CF_Organization__mdt]) {
            // Add valid remote orgs to lookup map 
            orgMap.put(org.OrgName__c, org);
            System.debug('=====> orgMap' + orgMap); 
            // Add org with initial (empty) map to remote callout map
            //   If there are no credentials in map after iterating requests (m map)
            //      the remote callout map entry will be removed
            //calloutMap here initially holds orgName and empty remote credentail objects Map
            calloutMap.put(org.OrgName__c, new Map<Integer, IntegrationCredentialService.Credential>()); 
            system.debug('====> Initial calloutMap is' + calloutMap);
        }
        // Interate over remote credentials passed into method
        for (Integer key : remoteCalloutMap.keySet()) {
            IntegrationCredentialService.Credential cred = remoteCalloutMap.get(key);
            String orgNameLookup = cred.orgName; 
            //system.debug('====> orgNameLookup is' + orgNameLookup);
            CF_Organization__mdt remoteOrg = orgMap.get(orgNameLookup);
            system.debug('======> remoteOrg is' + remoteOrg);
            if (remoteOrg == null) {
                System.debug('Org name ('+orgNameLookup+') in credential not found');
                cred.isValid = false;
                cred.errorMsg = 'Update error: Salesforce org location '+ orgNameLookup +
                    ' is not valid or was not found';
            } else {
                // add this credential to map for the proper entry in the remote Map
                //Here calloutmap holds credntail objects related to a specific
                calloutMap.get(orgNameLookup).put(key, cred);
                System.debug('====>calloutMap value is '+calloutMap);
            }   
        }
        // Iterate over calloutMap and do callout when callout map entry's credMap is not empty
        for (String calloutKey : calloutMap.keySet()) {
            Map<Integer, IntegrationCredentialService.Credential> credMap = calloutMap.get(calloutKey).clone();
            System.debug('==>credMap-bf callout' + credMap+' calloutKey-'+calloutKey);
            if (credMap.size() > 0) {
                String calloutNC = orgMap.get(calloutKey).OrgNamedCred__c;
                system.debug('==>calloutNC  '+calloutNC);
                Integer newKeyOffset = 1000; // don't want to overlay main cred map
                credMap = doRemoteCallout(credMap, calloutNC, newKeyOffset);
                //System.debug('==>credMap-af callout ' + credMap);
                // save callout results back to main map containing credentials to update 
                remoteCalloutMap.putAll(credMap);    
            }
        }
        System.debug('==>value of remoteCalloutMap *****' + remoteCalloutMap);
        return remoteCalloutMap;
    }
    
    /*****************************************************************************************
     * Purpose   : Iterate over the remote credentails objects map 
                   makes a callout to remote org to process passwords
     * Parameters: Map of Credential objects, named credential, newKeyOffset 
    *****************************************************************************************/ 
    @TestVisible
    private static Map<Integer, IntegrationCredentialService.Credential> doRemoteCallout(Map<Integer, IntegrationCredentialService.Credential> credRequestMap, String namedCred, Integer newKeyOffset) {
        // Create new request wrapper for remote callout
        String calloutEP;
        IntegrationCredentialService.CredentialWrapper credWrap = new IntegrationCredentialService.CredentialWrapper();
        List<IntegrationCredentialService.Credential> remoteCredList = new List<IntegrationCredentialService.Credential>();
        Map<Integer, IntegrationCredentialService.Credential> credResponseMap = new Map<Integer, IntegrationCredentialService.Credential>();
        for(IntegrationCredentialService.Credential cred : credRequestMap.values()){
            remoteCredList.add(cred);
            credWrap.credentials = remoteCredList;
            //System.debug('The value of credWrap.credentials' + credWrap.credentials );
        }
        
        /*AsyncApexJob qJobID = [SELECT Id, Status, JobItemsProcessed,TotalJobItems, NumberOfErrors
                                 FROM AsyncApexJob 
                                 WHERE ID =: queueablejobID];
        System.debug('==>qJobID value   '  + qJobID);
        System.debug('==>qJobID.status value   '  + qJobID.status);*/
        /*if(qJobID.status == 'Completed'){
            calloutEP = 'callout:'+namedCred;
        }*/
        calloutEP = 'callout:'+namedCred;
        String requestBody = JSON.serialize(credWrap, true);
        System.Debug('======> requestBody : ' + requestBody);
        HttpRequest req = new HttpRequest();
        req.setBody(requestBody); 
        req.setEndpoint(calloutEP);
        req.setMethod('POST'); 
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String responseBody = res.getBody(); 
        System.debug( '====> responseBody : ' + responseBody ); 
        // Turn remote response back to a list of credentialUpdates
        //  1. Deserialize json response into a CredentialStatus list
        IntegrationCredentialService.CredentialUpdate deserialized = 
            (IntegrationCredentialService.CredentialUpdate) JSON.deserialize(responseBody, IntegrationCredentialService.CredentialUpdate.class);
        Set<Integer> credReqKS = credRequestMap.keySet();
        Integer credReqSize = credReqKS.size();  // original number of request keys
        Integer i = 0;
        List<IntegrationCredentialService.CredentialStatus> csList = deserialized.credentialUpdates;
        //  2. Iterate over CredentialStatus list
        System.debug('====> csList '+ cslist);
        for (IntegrationCredentialService.CredentialStatus cs : csList) {
            IntegrationCredentialService.Credential cred = new IntegrationCredentialService.Credential();
            cred.accountName = cs.accountName;
            cred.isValid = true;
            //System.debug('====> credRequestMap '+credRequestMap);
            if (cs.status == 'Error') {
                cred.isValid = false;
                cred.errorMsg = cs.message;
            }
            if (!credReqKS.isEmpty()) {
                Integer aKey = (new list<Integer>(credReqKS)[i]);
                if (credRequestMap.containsKey(aKey)) {
                    cred.locationName = credRequestMap.get(aKey).locationName; 
                    cred.locationType = credRequestMap.get(aKey).locationType;                
                }
                credResponseMap.put(aKey, cred);
                System.debug('==>aKey-'+aKey+' credReq size-'+credReqSize+' key set-'+credReqKS);
                credReqKS.remove(aKey);
                System.debug('==>key set-'+credReqKS);
            } else {
                Integer newKey = credReqSize + i + newKeyOffset;
                System.debug('==>newKey-'+newKey);
                cred.locationName = 'at a location undefined in local Org'; 
                cred.locationType = 'Remote Org';
                credResponseMap.put(newKey, cred);                
            }
        }
        return credResponseMap;
    }      
}