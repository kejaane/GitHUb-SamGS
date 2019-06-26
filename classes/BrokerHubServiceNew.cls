/*=========================================================================================
 * Date         : 9/26/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This is a core class for the Broker Hub module and implements the business layer 
 *                logic for Broker Hub processing. This includes processing inputs passed from the 
 *                Opportunity,Opportunity Contact Role,Partner,FSP GP Triggers
 *                (It implements low level web service request/response construction).
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 12/21/16 | satya | Removed isLuminx condition since this is not necesssary becuase we are not sending luminx opportunties to the BrokerHub
 * 02/23/18 | Sajitha | T01 | Added API Gateway change using Named Credential      
 * 12/18/18 | Satya T | T02 | BDM Issue Fix , new  change start for effective date and end date 
 * 12/21/18 | Satya T | T03 | 101 Error fix. Removed the SOQL queries present inside the 'for' loop.
 * 12/27/18 | Satya T | T04 | Used schema class to get the recordTypeId instead of Soql query                            
 *=========================================================================================
 */

public with sharing class BrokerHubServiceNew {

    public class BHException extends Exception {}
    
    public static String bhEndPointURL;
    public static String bhClientCertificateName='';
    public static String bhRequestTimeout;
    public static String bhSFDCSupportEmailAddress;
    public static String bhPortalSupportEmailAddress;
    public static Boolean isInitialized = false;
    
    public static String environmentModuleName = 'BrokerHub Integration';
    public static String environmentCommonModuleName = 'Common';
    public static String environmentVariableName_bhSFDCSupportEmailAddress = 'SFDC_Support_Email';
    public static String environmentVariableName_bhPortalSupportEmailAddress = 'BH_Support_Email';
    //T01 START
    /**public static String environmentVariableName_bhEndPointURL = 'BH_EndPoint';
    public static String environmentVariableName_bhClientCertificateName = 'BH_ClientCertificateName';**/
     //T01 END
    public static String environmentVariableName_bhRequestTimeout = 'RequestTimeout';
    public static List<String> environmentVariableNames = new List<String>();
    

    // one time initialization block when BrokerHubServiceNew class is first loaded
    static {
        BrokerHubServiceNew.environmentModuleName = 'BrokerHub Integration';
        BrokerHubServiceNew.environmentVariableNames = new List<String>();
        //T01 Start 
       /** BrokerHubServiceNew.environmentVariableNames.add ( BrokerHubServiceNew.environmentVariableName_bhEndPointURL );
        BrokerHubServiceNew.environmentVariableNames.add ( BrokerHubServiceNew.environmentVariableName_bhClientCertificateName );**/
         //T01 END
        BrokerHubServiceNew.environmentVariableNames.add ( BrokerHubServiceNew.environmentVariableName_bhSFDCSupportEmailAddress );
        BrokerHubServiceNew.environmentVariableNames.add ( BrokerHubServiceNew.environmentVariableName_bhPortalSupportEmailAddress );
        BrokerHubServiceNew.environmentVariableNames.add ( BrokerHubServiceNew.environmentVariableName_bhRequestTimeout );
                                                             
        BrokerHubServiceNew.loadConfigurationFromEnvironmentVariables();
    }
    
    /*************************************************************************************
    * Purpose   : This method loads BrokerHub integration related configuration variables when either: 
    *             1. This class is first loaded and automatically called from the static initializer block  
    *             2. OR when the BHconfiguration settings are modified through the EnvironmentVariables tab which 
    *             triggers EnvironmentVariableTrigger which calls this method to reload env vars.
    * Parameters: None
    *
    * Return    : None
    *************************************************************************************/
    public static void loadConfigurationFromEnvironmentVariables() {
        
        System.debug('Loading BrokerHubServiceNew environment variables');    
        
        Map<String, EnvironmentVariable__c> envVarMap = new Map<String,EnvironmentVariable__c>();
        EnvironmentVariables.getEnvironmentVariablesForModule(BrokerHubServiceNew.environmentModuleName, envVarMap);
        EnvironmentVariables.getEnvironmentVariablesForModule(BrokerHubServiceNew.environmentCommonModuleName, envVarMap);
        System.debug('envVarMap***'+envVarMap); 
       /** if(envVarMap.isEmpty()) {
            System.debug('Error: No BrokerHub related environment variables configured in EnvironmentVariable__c table. Retrieved envVarMap=' + String.valueOf(envVarMap));
            BrokerHubServiceNew.isInitialized = false;
            return;
        }**/
        system.debug('envVarMap*****'+envVarMap);
        String value;
        //String value = 'https://servicestt.carefirst.com/SFASita/eProxy/service/SalesForceAccount';// (envVarMap.get(BrokerHubServiceNew.environmentVariableName_bhEndPointURL)).Value__c;
       //T01 START - Deprecated as part of Named credentials implementation 
       /** if(envVarMap.get(BrokerHubServiceNew.environmentVariableName_bhEndPointURL) != null){
            value =  (envVarMap.get(BrokerHubServiceNew.environmentVariableName_bhEndPointURL)).Value__c;
            if(String.isNotBlank(value)) { BrokerHubServiceNew.bhEndPointURL = value;}
            System.debug( 'bhEndPointURL=' + value);
        }
        
        if(envVarMap.get(BrokerHubServiceNew.environmentVariableName_bhClientCertificateName) != null){
            value = (envVarMap.get(BrokerHubServiceNew.environmentVariableName_bhClientCertificateName)).Value__c;
            if( String.isNotBlank(value)) BrokerHubServiceNew.bhClientCertificateName = value;
            System.debug( 'bhClientCertificateName=' + value);
        }**/
        //T01 END
        if(envVarMap.get(BrokerHubServiceNew.environmentVariableName_bhSFDCSupportEmailAddress) != null){
            value = (envVarMap.get(BrokerHubServiceNew.environmentVariableName_bhSFDCSupportEmailAddress)).Value__c;
            if( String.isNotBlank(value)) BrokerHubServiceNew.bhSFDCSupportEmailAddress = value;
            System.debug( 'bhSFDCSupportEmailAddress=' + value);
        }
        
        if(envVarMap.get(BrokerHubServiceNew.environmentVariableName_bhPortalSupportEmailAddress) != null){
            value = (envVarMap.get(BrokerHubServiceNew.environmentVariableName_bhPortalSupportEmailAddress)).Value__c;
            if( String.isNotBlank(value)) BrokerHubServiceNew.bhPortalSupportEmailAddress = value;
            System.debug( 'bhPortalSupportEmailAddress=' + value);
        }
        
        if(envVarMap.get(BrokerHubServiceNew.environmentVariableName_bhRequestTimeout) != null){
            value = (envVarMap.get(BrokerHubServiceNew.environmentVariableName_bhRequestTimeout)).Value__c;
            if( String.isNotBlank(value)) BrokerHubServiceNew.bhRequestTimeout = value;
            System.debug( 'bhRequestTimeout=' + value);
        }
     /*
    BrokerHubService.bhEndPointURL = 'https://servicestt.carefirst.com/SFASita/eProxy/service/SalesForceAccount';
    BrokerHubService.bhClientCertificateName = 'salesforce_dev3_carefirst_com';
    BrokerHubService.bhSFDCSupportEmailAddress = 'SFDCTeam@CareFirst.com';
    BrokerHubService.bhPortalSupportEmailAddress = 'SFDCTeam@CareFirst.com';
    BrokerHubService.bhRequestTimeout = '50000';*/
    
    System.debug( '@@@ Exiting from loadConfigurationFromEnvironmentVariables and returning TRUE');
    BrokerHubServiceNew.isInitialized = true;
    }

    
    /*************************************************************************************
     * Purpose   : This method is called by the after update OpportunityTriggerHandler. It accepts
     *             a list of opportunities that have updates and after the list is filtered for relevant
     *             Account updates by the buildBrokerHubSoldOpportunityRequestData() method, it serializes 
     *             the requests and schedules them for asynchronous (future call) execution via 
     *             BrokerHubServiceNew.sendBrokerHubSoldOpportunityRequestsInFuture()
     *
     * Parameters: List<Opportunity> selectedOpps- the updated opportunities
     *             
     * Return    : None
    ************************************************************************************   */
    public static void processSoldOpportunityDetails(List<Opportunity> selectedOpps) {
         processSoldOpportunityDetails(selectedOpps, false);
    }

    public static void processSoldOpportunityDetails(List<Opportunity> selectedOpps, Boolean isOppProptoSold) {
        if(selectedOpps.size() > 0){ //new changes for prod null issue 20Dec16 
            System.debug('@@Calling from processSoldOpportunityDetails ==>1'+selectedOpps); 
            System.debug('@@ Added to selectedopps  ==> 8');
                
            System.debug('@@ Calling buildBHServiceSoldOppsRequestData  ==> 9');    
            
            BrokerHubSoldOpportunityRequestNew builtRequests = BrokerHubServiceNew.buildBHServiceSoldOppsRequestData(selectedopps, isOppProptoSold);
            System.debug('@@ Returned from buildBHServiceSoldOppsRequestData  ==> 30(2)'+builtRequests ); 
            
               
            // first use JSON library class to serialize the List of request objects since a future method can only accept arguments of primitive/List of primitive types
            System.debug('@@ Adding builtRequests to JSON.serialize  ==> 31'); 
            String serializedList = JSON.serialize( builtRequests);

            // now send the Stringified built requests using an asynchronous future method
            // this is necessary because this code is executed in a Trigger context and makes web service callouts 
            // that are not allowed to be invoked synchronously. Doing so would generate an Exception
            System.debug('@@ Calling  sendBrokerHubSoldOppsRequestsInFuture ==> 32'+serializedList );
            //sendBrokerHubSoldOppsRequestsInFuture( serializedList);
            if(!Test.isRunningTest()){
                sendBrokerHubSoldOppsRequestsInFuture( serializedList);
            }
    }   
    }    
       
    
     /*************************************************************************************
     * Purpose   : This is a asynchronous version of the loadConfigurationFromEnvironmentVariables()  
     *             method that can be called from a trigger
     * Parameters: None
     *
     * Return    : None
     *************************************************************************************/
        @future
        public static void reloadConfigurationFromEnvironmentVariables() {
             BrokerHubServiceNew.loadConfigurationFromEnvironmentVariables();
        }
    
  
    /**********************************************************************************************************************************************
     * Purpose   : This method takes a list of Opportunity objects and shortlists those Opportunities which
     *             correspond to NASCO or LuminX and SOLD opportunities.
     *             a Sold opportunity exists.
     *
     * Parameters: List<Opportunity> - the list of opportunity records that have updates on them
     * Return    : BrokerHubSoldOpportunityRequestNew
     ************************************************************************************************************************************************/
    
    public static BrokerHubSoldOpportunityRequestNew buildBHServiceSoldOppsRequestData( List<Opportunity> inputOpportunities) {
        return buildBHServiceSoldOppsRequestData(inputOpportunities,false);
    }    
    public static BrokerHubSoldOpportunityRequestNew buildBHServiceSoldOppsRequestData( List<Opportunity> inputOpportunities, Boolean isOppProptoSold) {
        
        BrokerHubSoldOpportunityRequestNew requestObject;
        System.debug('@@@@@ Executing from buildBHServiceSoldOppsRequestData ==>10');
        
        List<Opportunity> inputSoldOpportunities  = new List<Opportunity>();
        
        for( Opportunity o : inputOpportunities){
            System.debug('@@@@@ Entering applyRules_BH_OpportunityUpdate =>11 ' + applyRules_BH_OpportunityUpdate(o));
            
            if(applyRules_BH_OpportunityUpdate(o) == true ){    
                
                // add this to the list of opportunities for which broker hub update should be sent 
                System.debug('@@@@@ Returned from  applyRules_BH_OpportunityUpdate =>14 ');
                inputSoldOpportunities.add(o);
                System.debug('@@@@@ Added to  inputSoldOpportunities =>15 ');
            }
        }
        
        System.debug('@@@@@ COUNT of inputSoldOpportunities =>16 ' + inputSoldOpportunities.size());
        
        if(inputSoldOpportunities.size() == 0) return requestObject; // return empty list if no Sold opportunities
        
        
        //T04 Changes start
        
     /* String opp51recordTypeID = QueryBase.getRecordTypeID( 'Opportunity', 'X51');
        String opp200recordTypeID = QueryBase.getRecordTypeID( 'Opportunity', 'AIA_200'); //This has to be changed to X200 in Test1 since the record type is not present in this Org.
        */
        
        String opp51recordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('X51').getRecordTypeId();
        String opp200recordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('AIA_200').getRecordTypeId();
        //T04 changes end
        
        
        Set<Id> opportunityIdSet = new Set<Id>();
        for( Opportunity opp : inputSoldOpportunities) 
            opportunityIdSet.add( opp.ID);
            
        System.debug('@@@@@ Executing Opportunity query to get the details =>17 '+opportunityIdSet);
        
        Map<Id, Opportunity> soldOpportunityDetails = new Map<Id,Opportunity>( 
            [SELECT Id, Account.AccountNumber, NASCO_Acct_ID__c, Business_Type__c, Account.Name, Effective_Date__c, Contract_End_Date__c, 
                    opportunity.System__c,  opportunity.Division__c, Lead_Rep_Name_User__c,Lead_Rep_Name_User__r.Name,Lead_Rep_Number_User__c, FullServiceProducer__c, GeneralProducer__c, FSP_GP_NPN__c,Lead_Rep_Number__c          
                    FROM Opportunity 
                    WHERE (recordTypeID = :opp51recordTypeID OR recordTypeID = :opp200recordTypeID) AND Id IN :opportunityIdSet]); 
            
        System.debug('@@@@@ Query executed =>18 ');
        System.debug('@@@@@ recordTypeID => '+opp51recordTypeID );
        System.debug('@@@@@ recordTypeID => '+opp200recordTypeID);
        
        requestObject = buildBrokerHubSoldOpportunityRequestData(soldOpportunityDetails.values(), isOppProptoSold);
        
        if(!requestObject.isValid()){
            // there was an error in constructing the BrokerHubRequest
            System.debug('@@@@ Error constructing BrokerHubSoldOpportunityRequest. Request data=' + String.valueOf(requestObject));
            
            // log to Integration log as input validation error
            Integration.log( requestObject); 
        } 
        
        System.debug('@@@@@ Executing requests => '+ String.valueof(requestObject) );
        System.debug('@@@@@ Exiting from buildBHServiceSoldOppsRequestData Returning Requests =>30 ');
        return requestObject;
    }
         
    /*************************************************************************************
    * Purpose   : This is a utility method Apply business rules to check an opportunity 
    *             to be a NASCO or LuminX and SOLD opportunity with a non-blank NASCO Account #.
    *             
    * Parameters: Opportunity - the opportunity object to which the rule is to be applied
    *             
    * Return    : Boolean. Returns true if the opportunity satisfies the business rule otherwise false
    *************************************************************************************/

    public static boolean applyRules_BH_OpportunityUpdate( Opportunity o) {
        
        // Rule: Input check - opportunity object cannot be null
        System.debug('@@@@ Executing from applyRules_BH_OpportunityUpdate  ==>12 ');
        if( o == null) 
            return false;
        
        // Rule: Stage must be Sold 
        if( o.stageName != 'Sold'){
            System.debug('Business Rule Check Failed: BH Update -  Opportunity must be in stage=SOLD, opportunit=' + o); 
            return false;   
        }
        
        // Rule: System should not be blank
        String systemName = o.System__c;
        if( String.isBlank(o.System__c)){
            System.debug('Business Rule Check Failed: BH Update - System__c cannot be blank');
            return false;
        }   
        
        // Rule: System should be NASCO. Other System values should not be sent   
        Boolean isNASCO = systemName.toLowerCase().contains('Nasco'.toLowerCase());
        // 12/21/16 | satya |Removed isLumix condition since this is not necessary and Luminx opportunties shouldn't be going to brokerhub
        //Boolean isLuminx = systemName.toLowerCase().contains('Luminx'.toLowerCase());
        
        // 12/21/16 | satya | Removed isLumix condition since this is not necessary and Luminx opportunties shouldn't be going to brokerhub
        //if(!( isNASCO) && !(isLuminx)){
        if(!( isNASCO) ){
            System.debug('Business Rule Check Failed: BH Update - System__c should be NASCO');
            return false;               
        }
        
        // Rule: Group Id cannot be blank
        if( isNASCO && String.isBlank(o.NASCO_Acct_ID__c)){
            System.debug('Business Rule Check Failed: BH Update : Do not send BH update if system=NASCO and NASCO Group ID is blank. Opportunity=' + String.valueOf(o));
            return false; 
        } 
         
        // All business rule checks passed
         System.debug('@@@ Exiting applyRules_BH_OpportunityUpdate. Returning TRUE  ==> 13');
         return true;
    }

    /*************************************************************************************
     * Purpose   : This method takes a list of opportunities to build an BrokerHubServiceProxyNew.accountInformation_element
     *             request per the IAD (Interface Agreement Document) specification.
     *
     * Parameters: list<Opportunity>
     *
     * Return    : BrokerHubSoldOpportunityRequestNew
     *************************************************************************************/
    public static BrokerHubSoldOpportunityRequestNew buildBrokerHubSoldOpportunityRequestData(list<Opportunity> opps) {
        return buildBrokerHubSoldOpportunityRequestData(opps,false);
    }
 
    public static BrokerHubSoldOpportunityRequestNew buildBrokerHubSoldOpportunityRequestData(list<Opportunity> opps, Boolean isOppProptoSold) {
        
        List<BrokerHubServiceProxyNew.accountInformation_element> acctInfoList =new list<BrokerHubServiceProxyNew.accountInformation_element>();
        
        System.debug(' @@@ Executing from buildBrokerHubSoldOpportunityRequestData Input opportunity ==> 20 : ' + String.valueOf(opps));
        
        BrokerHubSoldOpportunityRequestNew requestNew = new BrokerHubSoldOpportunityRequestNew();
        requestNew.msgData = '';
        
        System.debug(' @@@ values are assigning to request at Opportunity Level ==>21 ');
        
        //T03 new changes start 
        
        map<id,list<Opportunity_Contact_Role__c>>  oppCrMap = new map<id,list<Opportunity_Contact_Role__c>>();
        map<id,list<Partner__c>>  oppPartMap = new map<id,list<Partner__c>>();
        map<id,list<FSP_GP__c>>  oppfspGpMap = new map<id,list<FSP_GP__c>>();
        set<id> opportunityset = new set<id>();
        for(Opportunity opp : opps){
            opportunityset.add(opp.id);
            
        }
        
        //Add all the CR records of that Opportunity to the map
        for(Opportunity_Contact_Role__c cr :[SELECT id,Contact_Name__r.Name,Contact_Name__r.Broker_NPN__c,Effective_Date__c,End_Date__c,Email__c,Phone__c,Role__c,Primary__c ,Opportunity__c
                                                                    FROM Opportunity_Contact_Role__c 
                                                                    WHERE  Opportunity__c in :opportunityset order by Effective_Date__c desc] ){
                                                                        if(!oppCrMap.containskey(cr.Opportunity__c)){
                                                                            oppCrMap.put(cr.Opportunity__c,new List<Opportunity_Contact_Role__c>{cr});
                                                                        }else {
                                                                            oppCrMap.get(cr.Opportunity__c).add(cr);
                                                                        }
                                                                        
                                                                    }
        //Add all the partner records of the Opportunity to the map
        for(Partner__c pr : [SELECT id, Effective_Date__c, End_Date__c, Role__c,Partner__r.Name,Partner__r.Agency_NPN__c,Primary__c,Opportunity__c 
                             FROM Partner__c  
                             WHERE  Opportunity__c in :opportunityset order by Effective_Date__c desc]){
                                 if(!oppPartMap.containskey(pr.Opportunity__c)){
                                    oppPartMap.put(pr.Opportunity__c,new List<Partner__c>{pr});
                            }else {
                                oppPartMap.get(pr.Opportunity__c).add(pr);
                                }
                             }
         
         
          //Add all the FSP/GP records of the Opportunity to the map                    
        for(FSP_GP__c fpgp : [SELECT id,Partner__c,Account__r.Agency_NPN__c,Effective_Date__c,End_Date__c,FSP_GP__C,Opportunity__c 
                                      FROM FSP_GP__c 
                                      WHERE Opportunity__c in :opportunityset order by Effective_Date__c desc]){
                                          if(!oppfspGpMap.containskey(fpgp.Opportunity__c)){
                                                oppfspGpMap.put(fpgp.Opportunity__c,new List<FSP_GP__c>{fpgp});
                                            }else {
                                                    oppfspGpMap.get(fpgp.Opportunity__c).add(fpgp);
                                                    }
                                      } 
        
        //T03 new changes end
        
        
        
        
        
        for(Opportunity opp : opps){
         
        // ************** Building ACCOUNTINFORMARTION_ELEMENT ---  OPPORTUNITY AND RELATED OBJECTS  **************
             BrokerHubServiceProxyNew.accountInformation_element acctInfo =new BrokerHubServiceProxyNew.accountInformation_element();
             
             acctInfo.accountId= opp.Account.AccountNumber;
             acctInfo.nascoAccountId = opp.NASCO_Acct_ID__c;
             acctInfo.businessType = opp.Business_Type__c;
             acctInfo.accountName = opp.Account.Name;
             Date effDt1 =opp.Effective_Date__c;
             acctInfo.contractEffectiveDate= '';
             if(effDt1 != null){//new changes for prod null issue 20Dec16
                 Datetime effdtformat1 = datetime.newInstance(effDt1.year(), effDt1.month(),effDt1.day());
                 acctInfo.contractEffectiveDate= effdtformat1.format('MM/dd/yyyy');//string.valueof(opp.Effective_Date__c);
             }   
             Date effDt2 =opp.Contract_End_Date__c;
             acctInfo.contractEndDate='';
             if(effDt2 != null){//new changes for prod null issue 20Dec16
                Datetime effdtformat2 = datetime.newInstance(effDt2.year(), effDt2.month(),effDt2.day());
                acctInfo.contractEndDate= effdtformat2.format('MM/dd/yyyy');//string.valueof(opp.Contract_End_Date__c);
             }
             acctInfo.sourceSystem= opp.System__c;
             acctInfo.accountManagerName= opp.Lead_Rep_Name_User__r.Name;
             //acctInfo.accountManagerCode= opp.Lead_Rep_Number__c;
             acctInfo.accountManagerCode= opp.Lead_Rep_Number_User__c;
             if(opp.System__c == 'LuminX'){
                acctInfo.CFA_NCAS_Flag= opp.Division__c;
             }
             
        // ************** Building BROKERONRECORD_ELEMENT ---  CONTACT ROLES(BROKERS)  **************
            
            //T03 changes - commented  SOQL query which is inside for loop
           /* List<Opportunity_Contact_Role__c > contactBrokerList = [SELECT id,Contact_Name__r.Name,Contact_Name__r.Broker_NPN__c,Effective_Date__c,End_Date__c,Email__c,Phone__c,Role__c,Primary__c 
                                                                    FROM Opportunity_Contact_Role__c 
                                                                    WHERE  Opportunity__c = :opp.id order by Effective_Date__c desc];  */
            system.debug('contactBrokerList>>> '+oppCrMap.values() );
            boolean isPrimaryAdded = false;
            boolean isSecondaryAdded = false;
            Date effDtPrimary;
            List<Opportunity_Contact_Role__c > contactBrokerList = new List<Opportunity_Contact_Role__c >();
            
            List<BrokerHubServiceProxyNew.brokerOnRecord_element> contactInfoList = new List<BrokerHubServiceProxyNew.brokerOnRecord_element>();
           
             //check if map contains the current opportunity, if so, add list of CR records of that opp to the list
            if(oppCrMap.containskey(opp.id)){
                contactBrokerList.addall(oppCrMap.get(opp.id));
            }
           
            
            for (Opportunity_Contact_Role__c cbl : contactBrokerList){
            
                BrokerHubServiceProxyNew.brokerOnRecord_element contactInfo = new BrokerHubServiceProxyNew.brokerOnRecord_element();
                
                contactInfo.Name=cbl.Contact_Name__r.Name;
                contactInfo.role = cbl.Role__c;
                system.debug('cbl>>>>'+cbl);
                
                if(cbl.Role__c == 'Primary Broker' && cbl.Primary__c == true && isPrimaryAdded == false){
                    contactInfo.NPN = cbl.Contact_Name__r.Broker_NPN__c;
                    contactInfo.EmailAddress = cbl.Email__c;   
                    contactInfo.PhoneNum = cbl.Phone__c;
                    Date effDt =cbl.Effective_Date__c;
                    if(effDt != null){//new changes for prod null issue 20Dec16
                        Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                        contactInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                        effDtPrimary = cbl.Effective_Date__c;
                    }   
                    
                    Date endDt =cbl.End_Date__c;
                    if(endDt != null){//new changes for prod null issue 20Dec16                 
                        Datetime enddtformat = datetime.newInstance(endDt.year(), endDt .month(),endDt .day());
                        contactInfo.termDate = enddtformat.format('MM/dd/yyyy');
                    }
                    
                    isPrimaryAdded =true;
                    contactInfoList.add(contactInfo);
                }else {//if(effDtPrimary != null /*&& cbl.Primary__c != true && cbl.End_Date__c == effDtPrimary.addDays(-1)*/)
                    system.debug('effDtPrimary**'+effDtPrimary);
                    system.debug('role**'+cbl.Role__c);
                    system.debug('Enddate**'+cbl.End_Date__c);
                    system.debug('isSecondaryAdded**'+isSecondaryAdded);
                    system.debug('isOppProptoSold**'+isOppProptoSold);
                    if(cbl.Role__c == 'Consultant'){
                    
                        //T02 new  change start for effective date and end date
                        /**Date effDt =cbl.Effective_Date__c;
                        contactInfo.NPN = cbl.Contact_Name__r.Broker_NPN__c;
                        contactInfo.EmailAddress = cbl.Email__c;   
                        contactInfo.PhoneNum = cbl.Phone__c;                    
                        if(effDt != null){
                        Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                        contactInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                        }
                        Date endDt =cbl.End_Date__c;
                        if(endDt != null){          
                            Datetime enddtformat = datetime.newInstance(endDt.year(), endDt.month(),endDt.day());
                            contactInfo.termDate = enddtformat.format('MM/dd/yyyy');
                        }**/
                        
                        //T02 new  change ends for effective date and end date
                        
                        contactInfoList.add(contactInfo);
                    }

                    else if(effDtPrimary != null && cbl.Role__c == 'Primary Broker' && cbl.End_Date__c == effDtPrimary.addDays(-1) &&  isSecondaryAdded == false && isOppProptoSold == false){
                        contactInfo.NPN = cbl.Contact_Name__r.Broker_NPN__c;
                        contactInfo.EmailAddress = cbl.Email__c;   
                        contactInfo.PhoneNum = cbl.Phone__c;
                        
                        Date effDt =cbl.Effective_Date__c;
                        if(effDt != null){//new changes for prod null issue 20Dec16
                            Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                            contactInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                        }
                        if(effDtPrimary != null){//new changes for prod null issue 20Dec16
                            Date endDt1 =effDtPrimary; 
                            system.debug('endDt1  >>>'+endDt1);
                            Date endDt = endDt1-1;//.addDays(-1);
                            system.debug('endDt  >>>'+endDt);    
                            Datetime enddtformat = datetime.newInstance(endDt.year(), endDt.month(),endDt.day());
                            contactInfo.termDate = enddtformat.format('MM/dd/yyyy');
                        }   
                        contactInfoList.add(contactInfo);
                        isSecondaryAdded  = true;
                    }else if(effDtPrimary != null && cbl.Role__c == 'Primary Broker' && cbl.Primary__c == true &&  isSecondaryAdded == false && isOppProptoSold == false){
                        contactInfo.NPN = cbl.Contact_Name__r.Broker_NPN__c;
                        contactInfo.EmailAddress = cbl.Email__c;   
                        contactInfo.PhoneNum = cbl.Phone__c;
                        
                        Date effDt =cbl.Effective_Date__c;
                        if(effDt != null){//new changes for prod null issue 20Dec16
                            Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                            contactInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                        }
                        if(effDtPrimary != null){//new changes for prod null issue 20Dec16
                            Date endDt1 =effDtPrimary; 
                            system.debug('endDt1  >>>'+endDt1);
                            Date endDt = endDt1-1;//.addDays(-1);
                            system.debug('endDt  >>>'+endDt); 
                            Datetime enddtformat = datetime.newInstance(endDt.year(), endDt.month(),endDt.day());
                            contactInfo.termDate = enddtformat.format('MM/dd/yyyy');
                        }
                        contactInfoList.add(contactInfo);
                        isSecondaryAdded  = true;
                    }
                }   
                System.debug(' @@@ values are built for Broker on Record ==>22 '+contactInfoList.size()+'; contactInfoList: '+contactInfoList);
            } 
                        
        // ************** Building BROKERAGENCYINFO_ELEMENT ---  PARTNERS(AGENCIES) **************
           system.debug('opportunityid**'+opp.id);
           //T03 changes - commented  SOQL query which is inside for loop
           /* List<Partner__c> partnersBrokerList = [SELECT id, Effective_Date__c, End_Date__c, Role__c,Partner__r.Name,Partner__r.Agency_NPN__c,Primary__c 
                                                   FROM Partner__c  
                                                   WHERE  Opportunity__c = :opp.id order by Effective_Date__c desc];    */
            system.debug('partnersBrokerList**'+oppPartMap.values());
            
            boolean isSecondaryAddedPrtnr = false;
            boolean isPrimaryAddedPrtnr = false;
            List<Partner__c> partnersBrokerList = new List<Partner__c>();
            List<BrokerHubServiceProxyNew.brokerAgencyInfo_element> agencyInfoList =new List<BrokerHubServiceProxyNew.brokerAgencyInfo_element>();
                effDtPrimary = null;
               
                //check if map contains the current opportunity, if so, add list of partner records of that opp to the list
               if(oppPartMap.containskey(opp.id)){
                partnersBrokerList.addall(oppPartMap.get(opp.id));
                        }
               
                
               for (Partner__c  op : partnersBrokerList){
                    system.debug('op>>> '+op);
                    BrokerHubServiceProxyNew.brokerAgencyInfo_element agencyInfo =new BrokerHubServiceProxyNew.brokerAgencyInfo_element();
                         
                    agencyInfo.Name=op.Partner__r.Name;
                    system.debug('role1**'+op.Role__c );
                    system.debug('primary1**'+op.Primary__c );
                    system.debug('isPrimaryAddedPrtnr1**'+isPrimaryAddedPrtnr);
                    
                    if(op.Role__c == 'Broker' && op.Primary__c == true && isPrimaryAddedPrtnr == false){
                        agencyInfo.role='Agency';
                        
                        agencyInfo.NPN=op.Partner__r.Agency_NPN__c;
                       
                        Date effDt =op.Effective_Date__c;
                        if(effDt != null){//new changes for prod null issue 20Dec16
                            Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                            agencyInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                        }
                        effDtPrimary = op.Effective_Date__c;//new
                        Date endDt =op.End_Date__c;
                        if(endDt != null){//new changes for prod null issue 20Dec16
                            Datetime enddtformat = datetime.newInstance(endDt.year(), endDt.month(),endDt.day());
                            agencyInfo.termDate = enddtformat.format('MM/dd/yyyy');
                        }   
                        agencyInfoList.add(agencyInfo);
                        isPrimaryAddedPrtnr = true;
                    }else {
                        system.debug('effDtPrimary'+effDtPrimary+'; isSecondaryAddedPrtnr'+isSecondaryAddedPrtnr+' op.Role__c'+op.Role__c);
                        if(op.Role__c == 'Consultant'){
                            agencyInfo.role='Consultant Company name';
                            
                            //-----------Start t2--------------
                            agencyInfo.NPN=op.Partner__r.Agency_NPN__c;
                            
                            Date effDt =op.Effective_Date__c;
                        if(effDt != null){//new changes for prod null issue 20Dec16
                            Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                            agencyInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                        }
                        effDtPrimary = op.Effective_Date__c;//new
                        Date endDt =op.End_Date__c;
                        if(endDt != null){//new changes for prod null issue 20Dec16
                            Datetime enddtformat = datetime.newInstance(endDt.year(), endDt.month(),endDt.day());
                            agencyInfo.termDate = enddtformat.format('MM/dd/yyyy');
                        }
                            //---------End T2---------
                            
                            agencyInfoList.add(agencyInfo);
                        }else{//if(effDtPrimary != null && op.End_Date__c == effDtPrimary.addDays(-1)){
                            
                            if(op.Role__c == 'Consultant'){
                                agencyInfoList.add(agencyInfo);
                            }else if(effDtPrimary != null && op.End_Date__c == effDtPrimary.addDays(-1) && isSecondaryAddedPrtnr == false && op.Role__c == 'Broker' && isOppProptoSold == false){
                                //agencyInfo.role='Agency';
                                agencyInfo.role='Agency';
                                agencyInfo.NPN=op.Partner__r.Agency_NPN__c;
                               
                                Date effDt =op.Effective_Date__c;
                                if(effDt != null){//new changes for prod null issue 20Dec16 
                                    Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                                    agencyInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                                }
                                
                                /*Date endDt =op.End_Date__c;
                                Datetime enddtformat = datetime.newInstance(endDt.year(), endDt .month(),endDt .day());*/
                                if(effDtPrimary != null){//new changes for prod null issue 20Dec16
                                    Date endDt1 =effDtPrimary; 
                                    system.debug('endDt1  >>>'+endDt1);
                                    Date endDt = endDt1-1;//.addDays(-1);
                                    system.debug('endDt  >>>'+endDt);
                                    Datetime enddtformat = datetime.newInstance(endDt.year(), endDt.month(),endDt.day());
                                    agencyInfo.termDate = enddtformat.format('MM/dd/yyyy');
                                }
                                agencyInfoList.add(agencyInfo);
                                isSecondaryAddedPrtnr = true;
                            }else if(effDtPrimary != null && op.Primary__c == true && isSecondaryAddedPrtnr == false && op.Role__c == 'Broker' && isOppProptoSold == false){
                                agencyInfo.role='Agency';
                                agencyInfo.NPN=op.Partner__r.Agency_NPN__c;
                               
                                Date effDt =op.Effective_Date__c;
                                if(effDt != null){//new changes for prod null issue 20Dec16 
                                    Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                                    agencyInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                                }
                                
                                /*Date endDt =op.End_Date__c;
                                Datetime enddtformat = datetime.newInstance(endDt.year(), endDt .month(),endDt .day());*/
                                if(effDtPrimary != null){//new changes for prod null issue 20Dec16
                                    Date endDt1 =effDtPrimary; 
                                    system.debug('endDt1  >>>'+endDt1);
                                    Date endDt = endDt1-1;//.addDays(-1);
                                    system.debug('endDt  >>>'+endDt);    
                                    Datetime enddtformat = datetime.newInstance(endDt.year(), endDt.month(),endDt.day());
                                    agencyInfo.termDate = enddtformat .format('MM/dd/yyyy');
                                }
                                agencyInfoList.add(agencyInfo);
                                isSecondaryAddedPrtnr = true;
                            }
                        }
                        }
                    
                    System.debug(' @@@ values are built for Agency on Record ==>23 ');
                }
            
        // ************** Building FSPAGENCYINFO_ELEMENT **************
                
           /* List<FSP_GP__c> fspList = [SELECT id,Partner__c,Account__r.Agency_NPN__c,Effective_Date__c,End_Date__c
                                       FROM FSP_GP__c 
                                       WHERE Opportunity__c = :opp.id and FSP_GP__C = 'FSP' and Primary__c = true];    
            List<BrokerHubServiceProxyNew.FSPAgencyInfo_element > fspInfoList=new List<BrokerHubServiceProxyNew.FSPAgencyInfo_element >();
                system.debug('fspList >>> '+fspList);
                for (FSP_GP__c op : fspList )
                {
                    BrokerHubServiceProxyNew.FSPAgencyInfo_element fspInfo =new BrokerHubServiceProxyNew.FSPAgencyInfo_element();
                    
                    fspInfo.Name=op.Partner__c;
                    fspInfo.NPN=op.Account__r.Agency_NPN__c;
                   
                    Date effDt =op.Effective_Date__c;
                    Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                    fspInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                    
                    Date endDt =op.End_Date__c;
                    Datetime enddtformat = datetime.newInstance(endDt.year(), endDt .month(),endDt .day());
                    fspInfo.termDate = enddtformat .format('MM/dd/yyyy');
                    
                    fspInfoList.add(fspInfo);
                    System.debug(' @@@ values are built for Agency on Record ==>23 ');
                }
                 
        // ************** Building GPAGENCYINFO_ELEMENT **************
                
            List<FSP_GP__c> gpList = [SELECT id,Partner__c,Account__r.Agency_NPN__c,Effective_Date__c,End_Date__c
                                      FROM FSP_GP__c 
                                      WHERE Opportunity__c = :opp.id and FSP_GP__C = 'GP' and Primary__c = true];    
            
            List<BrokerHubServiceProxyNew.GPAgencyInfo_element > gpInfoList =new List<BrokerHubServiceProxyNew.GPAgencyInfo_element >();
                system.debug('gpList>>> '+gpList);
                for (FSP_GP__c op : gpList )
                {
                    BrokerHubServiceProxyNew.GPAgencyInfo_element gpInfo =new BrokerHubServiceProxyNew.GPAgencyInfo_element();
                         
                    gpInfo.Name=op.Partner__c;
                    gpInfo.NPN=op.Account__r.Agency_NPN__c;
                           
                    Date effDt =op.Effective_Date__c;
                    Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                    gpInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                    
                    Date endDt =op.End_Date__c;
                    Datetime enddtformat = datetime.newInstance(endDt.year(), endDt .month(),endDt .day());
                    gpInfo.termDate = enddtformat .format('MM/dd/yyyy');
                    
                    
                    gpInfoList.add(gpInfo);
                    System.debug(' @@@ values are built for Agency on Record ==>23 ');
                }*/
                
            //************************Phani** to send primary and previous FSPGP data***********
            
            //T03 changes - commented  SOQL query which is inside for loop
           /* List<FSP_GP__c> fspgpList = [SELECT id,Partner__c,Account__r.Agency_NPN__c,Effective_Date__c,End_Date__c,FSP_GP__C 
                                      FROM FSP_GP__c 
                                      WHERE Opportunity__c = :opp.id order by Effective_Date__c desc];    */
            List<FSP_GP__c> fspgpList = new List<FSP_GP__c>();
            List<BrokerHubServiceProxyNew.GPAgencyInfo_element > gpInfoList =new List<BrokerHubServiceProxyNew.GPAgencyInfo_element >();
            List<BrokerHubServiceProxyNew.FSPAgencyInfo_element > fspInfoList=new List<BrokerHubServiceProxyNew.FSPAgencyInfo_element >();    
                system.debug('fspgpList>>> '+oppfspGpMap.values());
                integer count = 0;
                Date effDtPrimary1;
                
                 //check if map contains the current opportunity, if so, add list of FSP/GP records of that opp to the list
                if(oppfspGpMap.containskey(opp.id)){
                    fspgpList.addall(oppfspGpMap.get(opp.id));
                   }
                
                for (FSP_GP__c op : fspgpList)
                {
                    BrokerHubServiceProxyNew.GPAgencyInfo_element gpInfo =new BrokerHubServiceProxyNew.GPAgencyInfo_element();
                    BrokerHubServiceProxyNew.FSPAgencyInfo_element fspInfo = new BrokerHubServiceProxyNew.FSPAgencyInfo_element();
                    if(op.FSP_GP__C =='GP'){   
                        gpInfo.Name=op.Partner__c;
                        //gpInfo.NPN=op.Account__r.Agency_NPN__c;
                        if(op.Partner__c =='Direct'){
                           gpInfo.NPN='00000';
                           }else
                               {gpInfo.NPN=op.Account__r.Agency_NPN__c;}
                               
                        Date effDt =op.Effective_Date__c;
                        if(effDt != null){//new changes for prod null issue 20Dec16 
                            Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                            gpInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                        }
                        Date endDt =op.End_Date__c;
                        if(count == 0){
                            
                            effDtPrimary1 = effDt ;
                        }else{
                            Date endDt1 =effDtPrimary1; 
                            system.debug('endDt1  >>>'+endDt1);
                            if(endDt1 != null){//new changes for prod null issue 20Dec16    
                                endDt = endDt1-1;//.addDays(-1);
                                system.debug('endDt  >>>'+endDt);
                            }
                        } 
                        if(endDt != null){//new changes for prod null issue 20Dec16 
                            Datetime enddtformat = datetime.newInstance(endDt.year(), endDt.month(),endDt.day());
                            gpInfo.termDate = enddtformat.format('MM/dd/yyyy');
                        }   
                        
                        
                        gpInfoList.add(gpInfo);
                        System.debug(' @@@ values are built for Agency on Record ==>23 ');
                        count++;
                     }else if(op.FSP_GP__C =='FSP'){
                        fspInfo.Name=op.Partner__c;
                        //fspInfo.NPN=op.Account__r.Agency_NPN__c;
                        if(op.Partner__c =='Direct'){
                           fspInfo.NPN='00000';
                           }else
                               {fspInfo.NPN=op.Account__r.Agency_NPN__c;}
                       
                        Date effDt =op.Effective_Date__c;
                        if(effDt != null){//new changes for prod null issue 20Dec16
                            Datetime effdtformat = datetime.newInstance(effDt.year(), effDt.month(),effDt.day());
                            fspInfo.effectiveDate = effdtformat.format('MM/dd/yyyy');
                        }
                        
                        Date endDt =op.End_Date__c;
                        if(count == 0){
                            
                            effDtPrimary1 = effDt ;
                        }else{
                            Date endDt1 =effDtPrimary1; 
                            system.debug('endDt1  >>>'+endDt1);
                            if(endDt1 != null){//new changes for prod null issue 20Dec16
                                endDt = endDt1-1;//.addDays(-1);
                                system.debug('endDt  >>>'+endDt); 
                            }                               
                        }
                        if(endDt != null){//new changes for prod null issue 20Dec16 
                            Datetime enddtformat = datetime.newInstance(endDt.year(), endDt .month(),endDt .day());
                            fspInfo.termDate = enddtformat .format('MM/dd/yyyy');
                        }
                        
                        fspInfoList.add(fspInfo);
                        System.debug(' @@@ values are built for Agency on Record ==>23 ');
                        count++;
                        
                     }
                     if(count==2){
                         break;
                     }
                }
                
            //************************Phani** to send primary and previous FSPGP data*********** 
            
                
            List<BrokerHubServiceProxyNew.brokerAgencyDetails_element> brokerAgencyDetailList = new List<BrokerHubServiceProxyNew.brokerAgencyDetails_element>();
            
            BrokerHubServiceProxyNew.brokerAgencyDetails_element brokerAgencyDetail = new BrokerHubServiceProxyNew.brokerAgencyDetails_element();    
            
            brokerAgencyDetail.brokerOnRecord = contactInfoList;
            brokerAgencyDetail.brokerAgencyInfo = agencyInfoList;
            brokerAgencyDetail.FSPAgencyInfo = fspInfoList;
            brokerAgencyDetail.GPAgencyInfo = gpInfoList;
            brokerAgencyDetailList.add(brokerAgencyDetail);
                
            acctInfo.brokerAgencyDetails = brokerAgencyDetailList;
            
            System.debug(' @@@ Request is built for Additional Information ==>26 ');
              
            // log actual request data that is sent in the BH Request to the other side
            requestNew.msgData = requestNew.msgData +
            'accountId=' + acctInfo.accountId+ 
            ',accountName=' + acctInfo.accountName+ 
            ',nascoAccountId=' + acctInfo.nascoAccountId+ 
            ',businessType=' + acctInfo.businessType+ 
            ',LeadRepName=' + acctInfo.accountManagerName+
            ',LeadRepNumber=' + acctInfo.accountManagerCode+
            ',sourceSystem=' + acctInfo.sourceSystem +
            ',DivisionFlag=' + acctInfo.CFA_NCAS_Flag+
            ',opportunityEffectiveDate=' + acctInfo.contractEffectiveDate+
            ',OpportunityEndDate=' +acctInfo.contractEndDate+ 
            ',OpportunityAdditionalInformation=' +acctInfo.brokerAgencyDetails ;
            
            System.debug(' @@@ Request build completed: Values are ==>27 ' + requestNew.msgData);
            
            acctInfoList.add(acctInfo);
        }
        
        requestNew.accountInformation = acctInfoList;
        requestNew.result = IntegrationMessage.STATUS_SUCCESS; 
        System.debug(' @@@ Exitingfrom buildBrokerHubSoldOpportunityRequestData. Returning Request ==>28 '+requestNew);
        
        return requestNew;
    }

/*************************************************************************************
 * Purpose   : This is a future (asynchronous) method which allows the Opportunity  
 *             after update trigger events to communicate updates to the 
 *             external broker hub portal system. The method receives BrokerHubSoldOpportunityRequest objects 
 *             that have been serialized using JSON.serialize() (since future methods can 
 *             only except primitive data types not Objects). It then converts the serialized
 *             objects back into first class objects using the complementary JSON.deSerialize 
 *             method. Once the original objects are rehydrated, it loops over them sending 
 *             out one request via the single request version of the same method (which in 
 *             turn calls out using the BrokerHubServiceProxyNew). 
 *
 * Parameters: String - serialized version of List<BrokerHubSoldOpportunityRequest> object
 * Return    : None
 *************************************************************************************/

    @future (callout=true)
    public static void sendBrokerHubSoldOppsRequestsInFuture( String serializedRequests) { 
        //System.debug(' @@@ Executing from sendBrokerHubSoldOppsRequestsInFuture. ==> 33 '+serializedRequests);
        // rehydrate the request list from the serialized input string representation to type List<EGPManageUserRequest>
        if(!String.isBlank(serializedRequests)){//Satya for null check
            BrokerHubSoldOpportunityRequestNew builtRequests = (BrokerHubSoldOpportunityRequestNew) JSON.deSerialize(serializedRequests, BrokerHubSoldOpportunityRequestNew.class);
            if(builtRequests != null){
                System.debug(' @@@ Entering sendSingleBrokerHubSoldOppRequest. ==> 34 '+builtRequests);
                BrokerHubServiceNew.sendSingleBrokerHubSoldOppRequest(builtRequests);
            }
        }
    }
    
/*************************************************************************************
 * Purpose   : This is a utility method which supports the sendBrokerHubSoldOpportunityRequest(String 
 *             serializedrequests method and it's key function is to call the brokerhub web service
 *             via the BrokerHubServiceProxy class. It takes care of setting up the actual request element
 *             in the format expected by BrokerHubServiceProxy. The BrokerHubServiceProxy class itself is generated
 *             from WSDL using the WSDL2Apex feature of Salesforce which creates Apex stub classes to
 *             enscapsulate the SOAP level marshalling/unmarshalling of inputs and outputs.
 *
 *
 * Parameters: BrokerHubSoldOpportunityRequestNew - the callout request data object
 * Return    : None
 *************************************************************************************/
    public static void sendSingleBrokerHubSoldOppRequest(BrokerHubSoldOpportunityRequestNew request) {
    
        System.debug(' @@@ Executing from sendSingleBrokerHubSoldOppRequest. ==> 35 ' + String.valueOf(request));
        
        BrokerHubSoldOpportunityResponseNew  response = new BrokerHubSoldOpportunityResponseNew(request);
        
        try{
            System.debug(' @@@ Calling getService . ==> 36 ');
            
            BrokerHubServiceProxyNew.SalesForceEndpoint1  service = BrokerHubServiceNew.getService();
            
            BrokerHubServiceProxyNew.soldAccountUpdateResponse_element  proxyResponse =  service.SoldAccountUpdates(request.accountInformation); 
            
            System.debug(' @@@ SoldAccountUpdates is built . ==> 43'+proxyResponse);
                                    
            response.status = IntegrationMessage.STATUS_SUCCESS;
            response.statusCode = proxyResponse.statusCode;
            response.statusDescription = proxyResponse.statusDescription;
            
            if( (response.statusCode).startsWith('Err') ) {
                //  sendEGPErrorNotification( request, response);
            }
            System.debug(' @@@ Setting the response to Valid ==> 44 ');
            response.setIsValid(true);
        
        } 
        catch (Exception e){
            response.status = IntegrationMessage.STATUS_ERROR;
            response.statusCode = IntegrationMessage.REMOTE_ERROR;
            response.statusDescription = 'Exception type= ' + e.getTypeName() + ' , message= ' + e.getMessage();
            response.setIsValid(false);
        }
        
        response.msgData = 'Remote response fields status=' + response.status + 
                            ', statusCode=' + response.statusCode + 
                          ', statusDescription= ' + response.statusDescription;
        response.relatedData = 'None.';
        
        // log request to integration log 
        // these calls need to happen after the web service callout to the external broker hub system
        // otherwise you get an exception message "System.CalloutException: You have uncommitted work pending"
        // because integration log records have not been committed
        Integration.log (request);
        Integration.log( response);
        system.debug('@@@@@ Printing the response ==> ' + response );
    }
    
/*************************************************************************************
 * Purpose   : This is a utility method that consolidates some common setup code to get 
 *             a callable BrokerHubServiceProxy endpoint. It returns an instance of the web service callout
 *             BrokerHubServiceProxy endpoint - SalesForceEndpoint1(). It takes care of configuring broker hub
 *             specific parameters like the endpoint URL (which varies by environment), client certificate
 *             name to use etc. 
 *             The returned service callout object is used by the higher level methods.
 *
 * Parameters: None
 * Return    : BrokerHubServiceProxyNew.SalesForceEndpoint1
 *************************************************************************************/
 //T01 START - Depreciated this method and return in new method as part of Named Credentials Implementation
   /** public static BrokerHubServiceProxyNew.SalesForceEndpoint1 getService() {
        System.debug('@@ Executing from getService ==> 37');
        
        BrokerHubServiceProxyNew.SalesForceEndpoint1  service = new BrokerHubServiceProxyNew.SalesForceEndpoint1();
        
        if(!BrokerHubServiceNew.isInitialized) {  
            throw new BrokerHubServiceNew.BHException('BrokerHubService is not initialized'); 
        }
        System.debug('@@ BrokerHubServiceNew.isInitialized returned TRUE ==> 38');
        
        String clientCertificateName = BrokerHubServiceNew.bhClientCertificateName;
        System.debug('@@ clientCertificateName Value ==> 39' + clientCertificateName);
        
        String endPointURL = BrokerHubServiceNew.bhEndPointURL;
        System.debug('@@ endPointURL Value ==> 40' + endPointURL);
        
        Integer requestTimeout = Integer.valueof(BrokerHubServiceNew.bhRequestTimeout);
        
        System.debug('@@@ Using BrokerHubServiceNew web service settings: ===> 41 bhClientCertificateName=' + clientCertificateName + ', bhRequestTimeout=' + requestTimeout + ', bhEndPointURL=' + endPointURL);
        
        service.clientCertName_x = clientCertificateName;
        service.timeout_x = requestTimeout;
        service.endpoint_x = endPointURL;
        //service.endpoint_x = 'http://requestb.in/16q0q651';
        
        
        
        
        System.debug('@@ Exiting getService returned service ==> 42');
        return service;
    }**/
    //T01 END
/*************************************************************************************
 * Purpose   : This is a utility method that consolidates some common setup code to get 
 *             a callable BrokerHubServiceProxy endpoint. It returns an instance of the web service callout
 *             BrokerHubServiceProxy endpoint - SalesForceEndpoint1(). It takes care of configuring broker hub
 *             specific parameters like the endpoint URL (which varies by environment), client certificate
 *             name to use etc. 
 *             The returned service callout object is used by the higher level methods.
 *
 * Parameters: None
 * Return    : BrokerHubServiceProxyNew.SalesForceEndpoint1
 *************************************************************************************/
    //T01 START
    public static BrokerHubServiceProxyNew.SalesForceEndpoint1 getService(){
     BrokerHubServiceProxyNew.SalesForceEndpoint1  service = new BrokerHubServiceProxyNew.SalesForceEndpoint1();
    
    if(!BrokerHubServiceNew.isInitialized) {  
            throw new BrokerHubServiceNew.BHException('BrokerHubService is not initialized'); 
        }
    
    String endPointURL = 'callout:Brokerhub_EGP_Integrations';
    
        Integer requestTimeout;
        try {
         requestTimeout = Integer.valueof(BrokerHubServiceNew.bhRequestTimeout);
        } catch (Exception e) {
        System.debug('Error processing timeout value=' + BrokerHubServiceNew.bhRequestTimeout + ': defaulting to 120000 (120 seconds)');
        requestTimeout = 120000;
    }
    
    service.timeout_x = requestTimeout;
    service.endpoint_x = endPointURL;
     system.debug('***service'+service);
    return service;
}
 //T01 END            
} // End of class