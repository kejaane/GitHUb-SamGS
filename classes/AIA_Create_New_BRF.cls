/*=================================================================================================================
* Date         : 01/24/2018
* Developer    : Goutham Rapolu
* Purpose      : Controller for New Benefit Request Form page on Opportunity Related Lists. 
*               logic to create new BRF based on Funding Arrangement of Opportunity and autopopulate fields
*=================================================================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 01/24/2018 | Goutham Rapolu |     | Initial Version                                         
* 10/12/2018 | Paritosh		  | T01 | Added code to tailor Validation Error message
*===========+=================+=====+=============================================================================
*/

public with sharing class AIA_Create_New_BRF {
    
    @AuraEnabled
    public static PRF__c getPRF(string PRF) {
        //Get PRF id & Name to display on screen
        PRF__c PrpRF = [Select id, Name
                        from PRF__c 
                        where id =:PRF];
        System.debug('AIA_Create_New_BRF::PrpRF::'+PrpRF);
        return PrpRF; 
    }
    @AuraEnabled
    public static Opportunity getOpp(string Oppid) {
        //Get Related Opp data to display on screen
        Opportunity Oppr = [Select id, Name, Risk_Non_Risk__c, Account_Name__c, AccountId, Legal_Account_Name_Verified__c, AIA_Account_Legal_Name__c,
                            Effective_Date__c,Account.Control_Plan__c,Account.Jurisdiction__c,Market_Segment_New__c,Broker_Consultant_Name__c,
                            Broker_Consultant_Name__r.Full_Name__c,Broker_Consultant_Name__r.LastName,Broker_Consultant_Name__r.FirstName,
                            Broker_Consultant_Name__r.id
                            from Opportunity 
                            where id =:Oppid];
        System.debug('AIA_Create_New_BRF::Oppr::'+Oppr);
        return Oppr; 
    }
    @AuraEnabled
    public static List<String> getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    
    @AuraEnabled  
    public static Map<String,List<String>> getDependentOptionsImpl(string objApiName , string contrfieldApiName , string depfieldApiName){
        system.debug(objApiName + '##' + contrfieldApiName + '###' + depfieldApiName);
        String objectName = objApiName.toLowerCase();
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        if (!Schema.getGlobalDescribe().containsKey(objectName)){
            System.debug('OBJNAME NOT FOUND --.> ' + objectName);
            return null;
        }
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        if (objType==null){
            return objResults;
        }
        Bitset bitSetObj = new Bitset();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        //Check if picklist values exist
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            System.debug('FIELD NOT FOUND --.> ' + controllingField + ' OR ' + dependentField);
            return objResults;     
        }
        List<Schema.PicklistEntry> contrEntries = objFieldMap.get(controllingField).getDescribe().getPicklistValues();
        List<Schema.PicklistEntry> depEntries = objFieldMap.get(dependentField).getDescribe().getPicklistValues();
        objFieldMap = null;
        List<Integer> controllingIndexes = new List<Integer>();
        for(Integer contrIndex=0; contrIndex<contrEntries.size(); contrIndex++){            
            Schema.PicklistEntry ctrlentry = contrEntries[contrIndex];
            String label = ctrlentry.getLabel();
            objResults.put(label,new List<String>());
            controllingIndexes.add(contrIndex);
        }
        List<Schema.PicklistEntry> objEntries = new List<Schema.PicklistEntry>();
        List<PicklistEntryWrapper> objJsonEntries = new List<PicklistEntryWrapper>();
        for(Integer dependentIndex=0; dependentIndex<depEntries.size(); dependentIndex++){            
            Schema.PicklistEntry depentry = depEntries[dependentIndex];
            objEntries.add(depentry);
        } 
        objJsonEntries = (List<PicklistEntryWrapper>)JSON.deserialize(JSON.serialize(objEntries), List<PicklistEntryWrapper>.class);
        List<Integer> indexes;
        for (PicklistEntryWrapper objJson : objJsonEntries){
            if (objJson.validFor==null || objJson.validFor==''){
                continue;
            }
            indexes = bitSetObj.testBits(objJson.validFor,controllingIndexes);
            for (Integer idx : indexes){                
                String contrLabel = contrEntries[idx].getLabel();
                objResults.get(contrLabel).add(objJson.label);
            }
        }
        objEntries = null;
        objJsonEntries = null;
        system.debug('objResults--->' + objResults);
        return objResults;
    }
    
    @AuraEnabled
    public static Benfit_Request_Form__c saveBRF(Benfit_Request_Form__c NBRF) {
        //Save BRF method
        system.debug('@@saveBRFstart'+NBRF);
        string error='';
        system.debug('@@saveBRF'+NBRF);
        id RTypeId;
        string BRFFundingArrangement= NBRF.Funding_Arrangements__c ;
        system.debug('@@BRFFundingArrangement'+BRFFundingArrangement);
        id BRFASO = Schema.SObjectType.Benfit_request_form__c.getRecordTypeInfosByName().get('ASO').getRecordTypeId();
        id BRFRisk = Schema.SObjectType.Benfit_request_form__c.getRecordTypeInfosByName().get('Risk').getRecordTypeId();
        id BRFBoth = Schema.SObjectType.Benfit_request_form__c.getRecordTypeInfosByName().get('Both').getRecordTypeId();
        id BRFOther = Schema.SObjectType.Benfit_request_form__c.getRecordTypeInfosByName().get('Other').getRecordTypeId();
        
        system.debug('@@BRFASO'+BRFASO+'@@@@BRFRisk'+BRFRisk+'@@BRFBoth'+BRFBoth+'@@@@BRFOther'+BRFOther);
        //Assigning RecordTypeID's
        if(BRFFundingArrangement == 'ASO'){ RTypeId = BRFASO;}
        if(BRFFundingArrangement == 'Risk'){ RTypeId = BRFRisk;}
        if(BRFFundingArrangement == 'Both'){ RTypeId = BRFBoth;}
        if(BRFFundingArrangement == 'Other'){ RTypeId = BRFOther;}
        
        system.debug('@@RTypeId'+RTypeId+'@@@@'+NBRF.RecordTypeId);
		//Set recordtype before saving.
        try{
            NBRF.RecordTypeId = RTypeId;
            upsert NBRF;
            return NBRF;
        }catch(exception e){
            //T01 Start
            String msg = e.getMessage();
            
            if (msg.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                list <String> split = msg.split('VALIDATION_EXCEPTION');
                msg = split[1].split('. You can look up')[0];
                msg = msg.removeStart(':');
                msg = msg.removeStart(',');
            }
			//Catch exception and display on screen.
            throw new AuraHandledException(' '+msg);
            //T01 End
        }
    }
    
    @AuraEnabled
    public static Boolean getBRFFields(string fld) {
		// Perform isCreateable() check here
        string BRFField = fld;
        Boolean ISFieldAccess = False;
        system.debug('@@@@getBRFFields::BRFField::'+BRFField);
        // Obtain the field name/token map for the Expense object
        Map<String,Schema.SObjectField> m = Schema.SObjectType.Benfit_Request_Form__c.fields.getMap();
        system.debug('@@@@getBRFFields2::m::'+m);
    	// Check if the user has access to view field
        if (!m.get(BRFField).getDescribe().isCreateable()) {
			ISFieldAccess = true;
        }
		system.debug('@@saveBRF::ISFieldAccess::'+ISFieldAccess); 
		return ISFieldAccess;
    }
}