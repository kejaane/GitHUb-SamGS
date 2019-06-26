/*Class      :   Enrollment_2_50_Opportunity_Process
Author       :   Ashish Ojha
Created Date :   10/21/2014
Description  :  This class is used upsert data from Enrollment_2_50__c to Opportunity object, ContactRole
                and Partner. Opportunitis are inserted or upserted based on the concatination of
                Facets_Account_Number__c + Recordtype name and Contract Effective date as the Key.
                The batch will run through all the records in Enrollment_2_50__c object and populate Opportunity
                based on the mapping document and also Set Stage field with either 'Termed'
                or 'Active' Based on if Term_Date__c is filled in the import object.
                Also, this Creates partner and contact roles to the opportunities that get inserted  
                This process also inserts all enrollments into enrollment object and assigns the opportunity based 
                on ID that matches the concatination of Account_Number__c + Contract_Effective_Date__c+'X2_50'
                on enrollment import object.                     
Instantiate  :   Enrollment_2_50_Opportunity_Process ep = new Enrollment_2_50_Opportunity_Process();
          OR :   Enrollment_2_50_Opportunity_Process ep = new Enrollment_2_50_Opportunity_Process(TRUE);
Execution    :   Enrollment_2_50_Opportunity_Process bc = new Enrollment_2_50_Opportunity_Process(FALSE);
                 database.executeBatch(bc);
*/
//====================================================================================================
//                                 Update History
// Date       	  Tag	   Developer      Description
//====================================================================================================
// 10/30/2015    		   Ashish Ojha	   Added Record type in the where clause when selecting contact Role or partner role 
//               		   Ashish Ojha     Added Record type in the where clause when selecting accountId for opportunity    
// 03/29/2016    		   Tom Barrett     Made changes to handle a new custom setting field that will allow for
//                              		   muliple email addresses to be entered dynamically without changing code 
// 06/21/2016    		   Ashish Ojha     Added EIN__c in the query and the mapping when creating opportunity and enrollment
// 08/17/2017     T01      Arshia Gulati   Added Direct_Plus_Broker_CF_Hub__c in the query and the mapping 
// 										   when creating opportunity and enrollment and the related changes 
// 										   for PDB_Id and PDB_Name according to the user story B-04020.
// 										   
//====================================================================================================
global class Enrollment_2_50_Opportunity_Process implements Database.Batchable<SObject>,database.stateful{
    Integer totOppFailures = 0;
    Integer totOppUpserts = 0;
    Integer totprocessed = 0;
    Integer totEnrlInserts =0;
    Integer totEnrlFailure =0;
   
    String fmtDate;
    DateTime dt; 
    Time fmtTime; 
    // This variable is used to when we are passing the query from the developer console
    private Boolean ForTestingOnly = False;
    private String entType = null;
    private String EmailBody = '';
    private integer BatchCount = 0;
    private static final String Subject = 'Apex: Enrollment_2_50_Opportunity_Process';
    private String NonTrappableErrorMsg = '';
    private Boolean NonTrappableError = FALSE;
    private String failedRecordIds = '';
    Map<Id,Id> mapOpptyIdandContactId = new Map<Id,Id>();
    private integer countAGNotFound  = 0;//AG Not Found Counter
    private integer countFSPNotFound = 0;//FSP Not Found Counter
    private integer countPDBNotFound = 0;//PDB Not Found Counter  		// |T01| 08/17/2017  
    private integer countGPNotFound  = 0;//GP Not Found Counter
    private integer countSBNotFound  = 0;//SB Not Found Counter
    private integer enrolmentFailureCount  = 0;//Enrollment Failure Count
    private integer enrolmentInsertCount  = 0;//Enrollment insert Count
    public class Enrollment_2_50_Opportunity_ProcessException extends Exception{}
    //Constructor for the batch : to pass the query from developer console.
    // Also for testing purpose only, we are passing a boolean value to be false
    public Enrollment_2_50_Opportunity_Process(boolean ForTestingOnly) {
        this.ForTestingOnly = ForTestingOnly;      
    }
    //Start |T01| 08/17/2017  - Added PDB_Id__c, PDB_Name__c in the query
    global database.querylocator start(Database.BatchableContext bc) {   
       String Query = 'Select id, Name,Ag_Id__c,Ag_Name__c,Contracts__c,Group_type__c, ' +
                       'Renewal_Anniversary_Date__c, On_Cycle__c, ' +
                       'Metal_Level__c, Processed_type__c,Run_dt__c,Rpt_dt__c, '+
                       'Break_Out_Level__c,AE_Id__c,FSP_Id__c,GP_Id__c, AE_Name__c, ' +
                       'FSP_Name__c,New_Business_Indicator__c, ' +
                       'Term_Reason__c,Market_Segment__c,SFDC_Product__c,Underwriting_entity__c, ' +
                       'Legal_entity__c,GP_Name__c, Term_Date__c,SB_id__c, Sb_Name__c,Account_Name__c, ' +
                       'Risk__c,Reinstatement_date__c,system__c, Contract_Effective_date__c, ' + 
                       'Account_Effective_date__c,Renewal_date__C,AM_Id__c,Am_Name__c, EIN__c, '+
                       'Account_Number__c,External_Key__c, ' +
           			   'PDB_Id__c, PDB_Name__c ' +				
                       'FROM Enrollment_Import_2_50__c ' +
                       'WHERE processed_opportunity__c = false';                        
       //End |T01| 08/17/2017                
          
       System.Debug('query :' + query);
        return Database.getQueryLocator(query); 
    }
  
    global void execute(Database.BatchableContext bc, Enrollment_Import_2_50__c[] EnrollmentImpList) {
        BatchCount += 1;
        string OppRtId = querybase.getRecordtypeId('Opportunity', 'X2_50');
        string EnrlRtId = querybase.getRecordtypeId('Enrollment__c', 'X2_50');
 
        string RtName = 'X2_50';
        list<Enrollment__c> enrollmentlisttoInsert = new list<Enrollment__c>();
        List<Opportunity>   OppListToUpsert = new List<Opportunity>();
        Map<String, Opportunity> OpportunityMap = new Map<String, Opportunity>();
        Opportunity Opp;       
        
        Set<String> sbIdsSet = new Set<String>();
        Set<String> agIds = new Set<String>();
        Set<String> GPIds = new Set<String>();
        Set<String> FSPIds = new Set<String>();
        Set<String> PDBIds = new Set<String>();			// |T01| 08/17/2017
        
        Map<String,Id> AgIdAndAccountIdMap  = new Map<String,Id>();
        // Maps for FSP id and GP id
        Map<String,Id> fspIdAndAccountIdMap = new Map<String,Id>();
        Map<String,Id> gpIdAndAccountIdMap  = new Map<String,Id>();
              
        Map<String,Id> pdbIdAndAccountIdMap = new Map<String,Id>();   //|T01| 08/17/2017
        
        Map<String,Id> SbIdAndContactIdMap  = new Map<String,Id>();
        Map<String,Id> FacetAndAccIdMap     = new Map<String,Id>();
        Map<String,Id> oppKeyAndOppIdMap    = new Map<String,Id>();
        Set<String> accNumber               = new Set<String>();
       
        /******************* Iterating on all the Enrollment 2-50 Import Records ***********************************/ 
         if(EnrollmentImpList != null && EnrollmentImpList.size() > 0){       
            for(Enrollment_Import_2_50__c enrl: EnrollmentImpList){
                accNumber.add(enrl.Account_Number__c);
            }
         } 
         //AO Changes 10/30/2015 added 'and Recordtype.Name = '2-50' ' into the where clause
         for(Account acc : [Select id,Facets_Account_Number__c from Account where Facets_Account_Number__c in :accNumber and Recordtype.Name = '2-50' ]){
             FacetAndAccIdMap.put(acc.Facets_Account_Number__c , acc.id);
         }

        System.Debug('EnrollmentImpList :' + EnrollmentImpList.size());
        //List of Enrollment 2-50 import object which we are getting from Start method
        System.Debug('129 before if');
        if(EnrollmentImpList != null && EnrollmentImpList.size() > 0){       
            for(Enrollment_Import_2_50__c enrl: EnrollmentImpList){
              System.Debug('132 inside loop');
              totprocessed += 1;
                // If Opportunity has not been put into the map then put it there
                // for the first time
                Opp = new Opportunity();
                if(FacetAndAccIdMap != null && FacetAndAccIdMap.containsKey(enrl.Account_Number__c)){
                    opp.AccountId = FacetAndAccIdMap.get(enrl.Account_Number__c);
                }
                if(enrl.SB_Id__c != null){
                    sbIdsSet.add(enrl.SB_Id__c);
                }
                                             
                 if(enrl.Ag_Id__c != null){
                    agIds.add(enrl.Ag_Id__c);
                }
                  if(enrl.GP_Id__c != null){
                    GPIds.add(enrl.GP_Id__c);
                }
                  if(enrl.FSP_Id__c != null){
                    FSPIds.add(enrl.FSP_Id__c);
                }
                
                //Start |T01| 08/17/2017
                if(enrl.PDB_Id__c != null){
                    PDBIds.add(enrl.PDB_Id__c);
                }
               //End |T01| 08/17/2017
               System.Debug('159 before oppmap check');
                if( OpportunityMap.get(enrl.Account_Number__c) == NULL ){                 
                    //  Map enrollment 2-50 import fields with Opportunity fields
                    Opp.recordtypeid =  OppRtId;                   
                    opp.System__c = enrl.system__c;
                    opp.Risk_Non_Risk__c = enrl.Risk__c;                                     
                  //opp.Effective_Date__c = enrl.Revised_Contract_Effective_Date__c;
                    opp.Effective_Date__c = enrl.Contract_Effective_Date__c;
                    opp.contract_end_date__c =enrl.Renewal_date__C;
                    /*if(enrl.Revised_Contract_Effective_Date__c < enrl.Contract_Effective_Date__c) {
                    opp.contract_end_date__c =enrl.Renewal_date__C.addyears(-1);
                    opp.Passive_Effective_Date__c = enrl.Contract_Effective_Date__c;
                    }*/
                    System.Debug('172');
                    opp.Renewal_Anniversary_Date__c = enrl.Renewal_Anniversary_Date__c;
                    opp.Reinstatement_date__c = enrl.Reinstatement_Date__c;
                    opp.Termination_Date__c = enrl.Term_Date__c;
                    opp.Won_Lost_reason__c = enrl.Term_Reason__c;                    
                    opp.SBU__c = 'Small/Medium';
                    Opp.Market_Segment_New__c = '2-50';
                    opp.Legal_Entity__c = enrl.Legal_Entity__C;                  
                    opp.AM_ID__c = enrl.AM_id__C;
                    opp.AM_Name__c = enrl.AM_Name__c;
                    opp.AE_ID__c = enrl.AE_id__C;
                    opp.AE_Name__c = enrl.AE_Name__c;
                    System.Debug('184');
                    // this Ag id is goign to be used to match with partner
                    Opp.AG_Id__c = enrl.Ag_Id__c;
                    opp.AG_Name__c = enrl.AG_Name__c;
                    // this sb id is going to be used to match with contact role
                    Opp.SB_Id__c = enrl.SB_Id__c;
                    opp.SB_Name__c = enrl.SB_Name__c;
                    opp.FullServiceProducer__c = enrl.FSP_Name__c;
                    opp.GeneralProducer__c = enrl.GP_Name__c;
                    System.Debug('193');
                    opp.Direct_Plus_Broker_CF_Hub__c = enrl.PDB_Name__c;		//|T01| 08/17/2017
                    
                    // close date is a required field
                    if ( enrl.New_Business_Indicator__c == 'N' ) {
                       opp.Division__c = '2-50 Renewal Business';
                        Opp.Business_Type__c = 'Renewal';
                       
                       } else {
                        Opp.Business_Type__c = 'New';
                        opp.Division__c = '2-50 New Business';
                    }
                    System.Debug('205');
                    opp.Underwriting_Entity__c =enrl.Underwriting_entity__c;
                    // AO changes begin 06/21/2016
                    opp.EIN__c = enrl.EIN__c;
                    // AO changes end 06/21/2016
                    //if(enrl.Revised_Contract_Effective_Date__c != null)
                    System.Debug('enrl.Account_Name__c' + enrl.Account_Name__c);
                    System.Debug('211: ' + enrl.Contract_Effective_Date__c);
                    opp.closeDate = utils.getCloseDate(enrl.Contract_Effective_Date__c);
                    System.Debug('213');
                    opp.External_Key__c = enrl.Account_Number__c + enrl.Contract_Effective_Date__c+RtName;                                                         
                    // if we are not testing then we assign the Opportunity name from enrollment import 2-50
                    // that is when the senario is not false we assign Opportunity Name and facets Opportunity number
                    //
                    System.Debug('215');
                    if(!ForTestingOnly){
                        /*format the date for appending to the opp name */
                        fmtTime = Time.newInstance(0, 0, 0, 0);
                        dt = DateTime.newInstance(enrl.Contract_Effective_Date__c, fmtTime);
                        fmtDate =dt.format('MM/yy');
                    
                        Opp.Name = enrl.Account_Name__c + ' ' + fmtDate;               
                        Opp.Facets_Grp_Num__c = enrl.Account_Number__c;
                        opp.System__c = 'Facets';
                        System.Debug('Opp.Name1 :' + Opp.Name);
                    }
                 //   System.Debug('Opp.Name2 :' + Opp.Name);
                    System.Debug('enrl.Term_Date__c :' + enrl.Term_Date__c);
                    if ( enrl.Term_Date__c != NULL ) {
                        Opp.StageName = 'Dead';
                        opp.Termination_Date__c = enrl.Term_Date__c;
                   } else {
                        Opp.StageName = 'Sold';
                    }          
                        System.Debug('Opp.Facets_Grp_Num__c :' + Opp.Facets_Grp_Num__c);
                    OpportunityMap.put(Opp.Facets_Grp_Num__c,Opp);              
                }               
                // After processing each record we check off the processed field on the enrollment 2-50 import object
                // so we do not reprocess the record again should we have to run again due to some batch failures
                        
                 System.Debug('237');
                enrl.Processed_Opportunity__c = true;
                System.Debug('enrl.Processed_Opportunity__c :' + enrl.Processed_Opportunity__c);
            }           
        }
        System.Debug('238');
        //10/30/2015 AO Changes. Added Record type in the where clause 
        for(Contact con :[Select Entity_Id__c,ID from Contact where Entity_Type_SB__c = TRUE and Recordtype.Name = '2-50' and Entity_Id__c in :sbIdsSet]){
            SbIdAndContactIdMap.put(con.Entity_Id__c,con.id);
        }
        System.Debug('243');
        // put all the entity ID and the account Id in a map     
        for(Account acc :[Select id,Entity_Id__c from Account where Entity_Type_AG__c = TRUE and Recordtype.Name = '2-50'and Entity_Id__c in :agIds]){
            AgIdAndAccountIdMap.put(acc.Entity_Id__c,acc.id);
        }
         for(Account acc :[Select id,Entity_Id__c from Account where Entity_Type_GP__c = TRUE and Recordtype.Name = '2-50'and Entity_Id__c in :GPIds]){
            GPIdAndAccountIdMap.put(acc.Entity_Id__c,acc.id);           
        }
        for(Account acc :[Select id,Entity_Id__c from Account where Entity_Type_FSP__c = TRUE and Recordtype.Name = '2-50' and Entity_Id__c in :FSPIds]){
            FSPidAndAccountIdMap.put(acc.Entity_Id__c,acc.id);
        }
        //Start |T01| 08/17/2017
        for(Account acc :[Select id,Entity_Id__c from Account where Entity_Type_PDB__c = TRUE and Recordtype.Name = '2-50' and Entity_Id__c in :PDBIds]){
            PDBidAndAccountIdMap.put(acc.Entity_Id__c,acc.id);
        }
        //End |T01| 08/17/2017
        System.Debug('259');
        // END AO Changes
        // put all map data into a list        
        OppListToUpsert = OpportunityMap.values();
       System.Debug('263');
        // upsert the Opportunity data
        if(OppListToUpsert != null && OppListToUpsert.size() > 0) {
      
        Savepoint sp = Database.setSavepoint();
               
        try{            
            System.Debug('OppListToUpsert :' + OppListToUpsert);
            upsert OppListToUpsert External_Key__c;    //commented for testing - AG
            //Create a set to hold the Id's of all opportunity that get upserted
            Set<Id> insertedIdsSet = new Set<Id>();
            if(OppListToUpsert != null && OppListToUpsert.size() > 0){
                for(Opportunity op :OppListToUpsert){
                  
            // Add the Id's of the inserted opportunity to the set we created
                    insertedIdsSet.add(op.id);
                    
                }
                 
            }
            // Create a list of opportunitie's ID, SB_id and Ag_id of all the inserted opportunities
            List<Opportunity> insertedOppList = [Select id,SB_ID__c,AG_Id__C,External_Key__c from Opportunity where id in :insertedIdsSet];
            Map<String,OpportunityContactrole> OpportunityContactroleMap = new Map<String, OpportunityContactrole>();
            //Create a Map of Opportunity Contact role to hold key( concatination of contact id and Opportunity Id) and OpportunityContactRole
            String OppConId;
            Id ConId;
            // Create a list of OpportunityContactRole with its ID, ContactId and OpportunityId of those Opportinties upserted
            // querying all the ContactRole against the inserted opportunities' id into the partner list
            List<OpportunityContactRole> contactRoleList = [Select id,contactid,OpportunityId from OpportunityContactRole where OpportunityId in :insertedidsSet];
            if(contactRoleList != null && contactRoleList.size() > 0){
            //loop through ContactRoleList list and insert key( opportunity id + ContactId) and the Partner record into the map
                    for(OpportunityContactRole oppConRole : contactRoleList){
                       OppConId = oppConRole.OpportunityId + '-' + OppConRole.ContactId;
              // map of concatinated value of opportnity id and Contact id as the key and partner record as a value        
                        OpportunityContactroleMap.put(OppConId,oppConRole);
                    }
            }
                      
            Map<String,Partner> PartnerMap = new Map<String, Partner>();
            // Similar logic as creation of OpportunityContactRole
                
            String OppAcctId;
            Id accId;
           
                // querying all the partner against the inserted opportunities' id into the partner list
            List<partner> partnerList = [Select id,OpportunityId,AccountToId from partner where OpportunityId in :insertedIdsSet];
            if(partnerList != null && partnerList.size() > 0){
                    for(partner part : partnerList){
                //loop through partner list and insert key( opportunity id + AccountToId) and the Partner record into the map
   
                        OppAcctId = part.OpportunityId + '-' + part.AccountToId;
                // map of concatinated value of opportnity id and account as the key and partner record as a value
                        PartnerMap.put(OppAcctId, part);
                    }
            }
           // list to be used to insert the opportunityContactRole
            List<OpportunityContactRole> contactRoleToInsert = new List<OpportunityContactRole>();
           // list to insert the partners
            List<partner> partnerlisttoinsert = new List<partner>();
            
                               
           // itarating through all inserted opportunities and adding partners to the parterlist which we are going to insert                             
           if(insertedOppList != null && insertedOppList.size() > 0){      
                for(Opportunity op :insertedOppList){
                                                                  oppKeyAndOppIdMap.put(op.External_Key__c,op.id);
               // Loop through the inserted Opportunity list and assign accId and ConId such that we get the respective Account and Contact ID's
               // of accounts/Contacts that have the mactching Entity Id to the AG_Id__c/Sb_Id__c                  
                    
                    accId = AgIdAndAccountIdMap.get(op.AG_Id__c);
                    ConId = SbIdAndContactIdMap.get(op.SB_Id__c);
               //Logic to Create Partner
                   
              //If ( accId == NULL ) System.debug('zz: ' + op.Id + '-' + accId);
                        // Assign the concatination of the AccountId we just got from the Maching Entity id with AG_id on opportunity to oppAccId
                        oppAcctId = op.Id + '-' + accId;
                        // Now if the partner is not exiting against the opportunity then we add that to the list to insert
                        if ( PartnerMap.get(oppAcctId) == NULL ) {
                            partnerListToInsert.add(utils.CreatePartner(op.Id, accId, 'BROKER', true));
                        }
                      
             // If ( ConId == NULL ) System.debug('zz: ' + op.Id + '-' + accId);
                       //Assign the concatination of the ContactId we just got from the Maching Entity id with SB_id on opportunity to oppConId
                        oppConId = op.Id + '-' + ConId;
                        if ( OpportunityContactroleMap.get(oppConId) == NULL ) {
                       // Now if the ContactRole is not exiting against the opportunity then we add that to the list to insert   
                            ContactRoleToInsert.add(utils.CreateOpportuntyContactRole(op.Id, ConId, 'BROKER', true));
                        }
                        
                }
            }
                                               
                                                //Creation of enrollment
                                                //Create a list of enrollment that we need to insert
                                                Id sbId;
                                                Id agId;
                                                Id fspId;
                                                Id gpId;
                                                ID CustId;
            									Id pdbId;		// |T01| 
            
                                                String AGNotFound;
                                                String FSPNotFound;
                                                String GPNotFound;
                                                String SBNotFound; 
                                                String runDtEnrl;
            									String PDBNotFound;  		// |T01| 
            
                                                //list<Enrollment__c> enrollmentlisttoInsert = new list<Enrollment__c>();
                                                // loop through the Enrollment Import List 
                                               
                                                if(EnrollmentImpList != null && EnrollmentImpList.size() > 0){       
                                                                for(Enrollment_Import_2_50__c enrl: EnrollmentImpList){
                                                                    AGNotFound = '';
                                                                    FSPNotFound = '';
                                                                    GPNotFound = '';
                                                                    SBNotFound = '';
                                                                    runDtEnrl = '';
                                                                    PDBNotFound = '';				// |T01|
                                                                    sbId = NULL;
                                                                    agId = NULL;
                                                                    fspId = NULL;                                                                    
                                                                    gpId = NULL;
                                                                    CustId = NULL;
                                                                    pdbId = NULL;				// |T01|
                                                                    
                                                                    // if AG_id__c Field in Enrollment import is not null we assign the 
                                                                    //account id to the Agid variable 
                                                                    if(enrl.Ag_id__c != NULL ){
                                                                    agId = AgIdAndAccountIdMap.get(enrl.Ag_Id__c);                                                   
                                                                        // if we do not find a matching Account, we assign the Ag__id__c
                                                                        // to a variable AGnotFound and will be populated Ag_Not_Found__c Field in Enrollment
                                                                        // then we set the counter for that
                                                                        if(agId == NULL){
                                                                            AGNotFound = enrl.Ag_Id__c; 
                                                                            countAGNotFound ++;
                                                                        }   
                                                                    }
                                                                    // if FSP_id__c Field in Enrollment import is not null we assign the 
                                                                    //account id to the Fspid variable 
                                                                    if(enrl.FSP_id__c != NULL ){
                                                                    fspId = FspIdAndAccountIdMap.get(enrl.FSP_Id__c);
                                                                       // if we do not find a matching Account, we assign the Ag__id__c
                                                                        // to a variable FSPnotFound and will be populated FSP_Not_Found__c Field in Enrollment
                                                                        // then we set the counter for that
                                                                        if(fspId == NULL){
                                                                            FSPNotFound= enrl.FSP_Id__c;
                                                                            countFSPNotFound ++;
                                                                        }                                                                      
                                                                    }
                                                                    
                                                                    // Start - |T01|
                                                                    // if PDB_id__c Field in Enrollment import is not null we assign the 
                                                                    //account id to the Pdbid variable 
                                                                    if(enrl.PDB_id__c != NULL ){
                                                                    pdbId = PdbIdAndAccountIdMap.get(enrl.PDB_id__c);
                                                                       // if we do not find a matching Account, we assign the PDB__id__c
                                                                        // to a variable PDBnotFound and will be populated PDB_Not_Found__c Field in Enrollment
                                                                        // then we set the counter for that
                                                                        if(pdbId == NULL){
                                                                            PDBNotFound= enrl.PDB_Id__c;
                                                                            countPDBNotFound ++;
                                                                        }                                                                      
                                                                    }
                                                                    // End - |T01|
                                                                    
                                                                    // if GP_id__c Field in Enrollment import is not null we assign the 
                                                                    //account id to the GPid variable 
                                                                    if(enrl.GP_id__c != NULL ){       
                                                                    gpId = GpIdAndAccountIdMap.get(enrl.GP_Id__c);
                                                                        // if we do not find a matching Account, we assign the Ag__id__c
                                                                        // to a variable GPnotFound and will be populated GP_Not_Found__c Field in Enrollment
                                                                        // then we set the counter for that
                                                                        if(gpId == NULL){
                                                                            GPNotFound = enrl.GP_Id__c;
                                                                            countGPNotFound ++;
                                                                        }   
                                                                    }
                                                                    // if SB_id__c Field in Enrollment import is not null we assign the 
                                                                    //account id to the SBid variable 
                                                                    if(enrl.SB_Id__c != NULL ){
                                                                    sbId = SbIdAndContactIdMap.get(enrl.SB_Id__c);
                                                                        // if we do not find a matching Contact, we assign the Ag__id__c
                                                                        // to a variable SBnotFound and will be populated SB_Not_Found__c Field in Enrollment
                                                                        // then we set the counter for that
                                                                        if(sbId == NULL){ 
                                                                            SBNotFound = enrl.SB_Id__c;
                                                                            countSBNotFound ++;
                                                                        }
                                                                     } 
                                                                                                                           
                                                                    // Assign Customer Account  look up based upon the mapping of Account_Number__c on Enrollment import 
                                                                    // to the matching Facets_Account_Number__c of Account.
                                                                    if(FacetAndAccIdMap.containsKey(enrl.Account_Number__c)){
                                                                            CustId = FacetAndAccIdMap.get(enrl.Account_Number__c);
                                                                    }
                                                                    
                                                                    if(enrl.Run_Dt__c != null){
                                                                        runDtEnrl = enrl.Run_Dt__c; 
                                                                    }
                                                                   
                                                                    
                                                                    //Passing Parameters from enrollment import into the enrollment creation method to creat enrollment
                                                                    // also notice that The opportunity id for the enrollment is based on the mapping where Id is derived from match
                                                                    // concatination of Enrollment import's Account number + Revised_Contract_Effective_Date__c+'X2_50' 
                                                                    // updated code to take Contract effective date as the part of the the unique key
                                                                    if(oppKeyAndOppIdMap.containsKey(enrl.Account_Number__c + enrl.Contract_Effective_Date__c+'X2_50')){

// Start - |T01|  - Commented code below to pass the object enrl itself instead of passing individual field 
// parameters since there is a limit of passing maximum 32 parameters in the method call                                                                               
                                                      /*
                                                                                     enrollmentlisttoInsert.add(CreateEnrollment(enrlrtid,CustId,(oppKeyAndOppIdMap.get(enrl.Account_Number__c + enrl.Contract_Effective_Date__c+RtName)),
                                                                                      agId,fspId,pdbId,gpId,sbId,enrl.Account_Number__c, enrl.Break_Out_Level__c, enrl.Contracts__c , enrl.Group_Type__c, enrl.Processed_Type__c, 
                                                                                     enrl.SFDC_Product__c, enrl.Rpt_Dt__c, runDtEnrl,
                                                                                      enrl.Reinstatement_Date__c,enrl.Metal_Level__c,enrl.New_Business_Indicator__c,enrl.Term_Date__c ,enrl.Term_Reason__c,
                                                                                      enrl.Renewal_Anniversary_Date__c,enrl.on_Cycle__c,AGNotFound, FSPNotFound, GPNotFound, SBNotFound,
                                                                                      enrl.AE_id__C, enrl.AE_Name__c, enrl.Am_id__C, enrl.Am_Name__c,enrl.EIN__c  
                                                                                                                               ));   
														*/                                                                        
    enrollmentlisttoInsert.add(CreateEnrollment(enrlrtid,CustId,
   (oppKeyAndOppIdMap.get(enrl.Account_Number__c + enrl.Contract_Effective_Date__c+RtName)),
   agId,fspId,pdbId,gpId,sbId,enrl,runDtEnrl,AGNotFound, FSPNotFound, PDBNotFound, GPNotFound, SBNotFound));        
 // End - |T01|
                                                                    }
                                                                }
                                                }
            if(contactRoleToInsert != null && contactRoleToInsert.size() > 0){
                Database.Saveresult[] srList = database.insert(contactRoleToInsert,false);
            }
            if(partnerListToInsert != null && partnerListToInsert.size() > 0){
                Database.Saveresult[] srList = database.insert(partnerListtoinsert,false);
            }
            system.debug('**********************enrollmentlisttoInsert'+enrollmentlisttoInsert);
             if(enrollmentlisttoInsert!= null && enrollmentlisttoInsert.size() > 0){
                Database.Saveresult[] srList = database.insert(enrollmentlisttoInsert, True);
                enrolmentInsertCount += enrollmentlisttoInsert.size();
                // Iterate through each returned result
              /* for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {  
                    enrolmentInsertCount ++;                      
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            enrolmentFailureCount ++; //enrollmentlisttoInsert.size();
                        }
                    }
                }
                 */           }
            if(EnrollmentImpList != null && EnrollmentImpList.size() > 0){
                update EnrollmentImpList;
            }                            
         }catch(System.Exception e){
             Database.rollback(sp);
             System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_2_50_Opportunity_Process.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
             NonTrappableErrorMsg += '<b>Exception in Enrollment_2_50_Opportunity_Process.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>';
             NonTrappableErrorMsg += '<b>Error occured during batch #</b>' + BatchCount + '<br/>';
             NonTrappableError     = true;
             totOppFailures += OppListToUpsert.size(); 
             totEnrlFailure += enrollmentlisttoInsert.size();              
             throw new Enrollment_2_50_Opportunity_ProcessException(NonTrappableErrorMsg);    
            }                          
         }
         totOppUpserts = totprocessed - totOppFailures ;
         //totEnrlFailure = totprocessed - enrolmentInsertCount ;
         /***************************************************End Variable Declaration*********************************************/
     }
   
    global void finish(Database.BatchableContext bc) {
        // Query the AsyncApexJob object to retrieve the current job's information.
        try {
            AsyncApexJob a = [ SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                               FROM AsyncApexJob
                               WHERE Id = :BC.getJobId() and JobType <> 'BatchApexWorker' ];
            //Build email message                            
            EmailBody += '<b>The Batch Apex job</b> ' + a.Status + '.<br/>';             
            EmailBody += '<b>The Batch Apex job processed</b> ' + a.TotalJobItems + ' <b>batches with</b> ' + a.NumberOfErrors + ' <b>failures.</b><br/>';
            EmailBody += '<b>The job was executed by:</b> ' + a.CreatedBy.Email + '.<br/><br/>';
            EmailBody += '<b>Begin Main Process</b><br/>';
            EmailBody += '<b>Total Enrollment 2-50 Opportunity Import Records Processed: </b> ' + totprocessed + '<br/>';              
            EmailBody += '<b>Total Enrollment 2-50 Opportunity Record Upserts: </b> ' + totOppUpserts + '<br/>';
            EmailBody += '<b>Total Enrollment 2-50 Opportunity Records Failure: </b> ' + totOppFailures + '<br/>';
            EmailBody += '<b>Total Inserted Enrollment Records : </b> ' + enrolmentInsertCount + '<br/>';
            EmailBody += '<b>Total Failed Enrollment Records : </b> ' + totEnrlFailure + '<br/>';
            //Counts of AG , GP ,FSP and SB not found
            EmailBody += '<b>Total AG Not Found : </b> ' + countAGNotFound + '<br/>';
            EmailBody += '<b>Total GP Not Found : </b> ' + countGPNotFound + '<br/>';
            EmailBody += '<b>Total FSP Not Found : </b> ' + countFSPNotFound + '<br/>';
            EmailBody += '<b>Total SB Not Found : </b> ' + countSBNotFound + '<br/>';
            EmailBody += '<b>Total PDB Not Found : </b> ' + countPDBNotFound + '<br/>';  // |T01|
            
            // EmailBody += '<b>Total Enrollment 2-50 Import Records Failures: </b> ' + totOppFailuress + '<br/>';
            //EmailBody += '<b>Total Enrollment 2-50 Import Records Failures Record Ids: </b> ' + failedRecordIds + '<br/>';
            if (NonTrappableError || Test.isRunningTest()) {
                EmailBody += '<br/><b>*** SERIOUS ISSUE OCCURED ***</b><br/>';
                EmailBody += NonTrappableErrorMsg + '<br/><br/>';
                EmailBody += '<b>Check the logs for details.</b><br/>';
            }
              
//BEGIN CHANGE TPB 03/29/2016 
//NOTE: Before 03/26/2016 update the testEmail was used.
//      this is no longer needed.  Go to the DynamicCodeDataStore record 'EmailSupportTeams' when testing       
    // BEGIN: THIS CODE SHOULD ONLY BE UNCOMMENTED DURING TESTING       
                /*
                Utils.EmailUtil testEmail = new Utils.EmailUtil(new List<String>{UserInfo.getUserEmail()}); 
                testEmail.subject(subject);
                testEmail.replyTo(UserInfo.getUserEmail());
                testEmail.htmlBody(emailBody);
                testEmail.sendEmail();     
                */              
    // END: THIS CODE SHOULD ONLY BE UNCOMMENTED DURING TESTING   
    // BEFORE MOVING TO PRODUCTION COMMENT OUT THE CODE ABOVE AND UNCOMMENT THE LINE BELOW
    //         EmailAlerts.emailAdmins(subject, emailBody); 
     
           DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
           string[] toAddresses = cs.Text_255__c.Split(',');
           Utils.EmailUtil Email = new Utils.EmailUtil(toAddresses); 
           Email.subject(subject);
           Email.replyTo(UserInfo.getUserEmail());
           Email.htmlBody(emailBody);
           Email.sendEmail();                                   


// END CHANGE TPB 03/29/2016                                        
                             
        } catch(System.Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_2_50_Opportunity_Process.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                    
        } 
    }
    
    // Create enrollment method. This method will create Enrollment Record upon passing following parameters to create enrollment.
  /* 
    private Enrollment__c CreateEnrollment(String EnrlRtId,id CustId, Id oppId, Id agId, Id fspId,Id pdbId, Id gpId , Id sbId, String accNo,
                                                    String bkLevel,decimal contracts,string gpType,String prType,String product,
                                                    String rptDt, String runDt, date Reinstatement_date,string MetalLevel,string nbi,date td,String Tr,
                                                    date rad, boolean oc, String AgN, String FspN, String GpN, String SbN, String AEid, 
                                           String AEN, String AMId,String AMN,String EIN){
*/
   private Enrollment__c CreateEnrollment(String EnrlRtId,id CustId, Id oppId, 
                                          Id agId, Id fspId,Id pdbId, Id gpId , Id sbId, Enrollment_Import_2_50__c p_enrl,
                                          String runDt, String AgN, String FspN,String PdbN, String GpN, String SbN){                                          
       
        Enrollment__c enrl              = new Enrollment__c();
        enrl.Opportunity__c             = oppId;
        enrl.AG__c                      = agId;
        enrl.FSP__c                     = fspId;
        enrl.PDB__c                     = pdbId;			// |T01|
        enrl.GP__c                      = gpId;
        enrl.RecordTypeId               = EnrlRtId;
        enrl.SB__c                      = sbId;
        enrl.Customer_account_Name__c   = Custid;
        enrl.Account_Number__c          = p_enrl.Account_Number__c; //accNo;
        enrl.Break_Out_Level__c         = p_enrl.Break_Out_Level__c; //bkLevel;
        enrl.Contracts__c               = p_enrl.Contracts__c; //contracts;
        enrl.Group_Type__c              = p_enrl.Group_Type__c; //gpType;
        enrl.Processed_Type__c          = p_enrl.Processed_Type__c; //prType;
        enrl.Product__c                 = p_enrl.SFDC_Product__c; //product;
        enrl.Risk__c                    = 'Risk';
        enrl.Rpt_Dt__c                  = p_enrl.Rpt_Dt__c; //rptDt;
        enrl.Run_Dt__c                  = runDt;
        enrl.System__c                  = 'Facets';
        enrl.Reinstatement_Date__c      = p_enrl.Reinstatement_Date__c; //Reinstatement_date;
        enrl.Metal_Level__c             = p_enrl.Metal_Level__c; //MetalLevel;
        enrl.New_Business_Indicator__c  = p_enrl.New_Business_Indicator__c; //nbi;
        enrl.Termination_Date__c        = p_enrl.Term_Date__c; //td;
        enrl.Termination_Reason__c      = p_enrl.Term_Reason__c; //tr;
        enrl.Renewal_Anniversary_Date__c= p_enrl.Renewal_Anniversary_Date__c; //rad;
        enrl.On_Cycle__c = p_enrl.On_Cycle__c; //oc;
        //enrl.Reporting_Checkbox__c      = rcb;
        if ( enrl.Termination_Date__c!= NULL ) {
             Enrl.Status__c = 'Termed';
            } else {
           Enrl.Status__c = 'Active';
        }        
        enrl.AG_Not_Found__c            = AgN;
        enrl.FSP_Not_Found__c           = FspN;
        enrl.PDB_Not_Found__c           = PdbN; 						// |T01|
        enrl.GP_Not_Found__c            = GpN;
        enrl.SB_Not_Found__c            = SbN;
        enrl.AE_id__C                   = p_enrl.AE_id__C; //AEid;
        enrl.AE_Name__c                 = p_enrl.AE_Name__c; //AEN;
        enrl.Am_id__C                   = p_enrl.Am_id__C; //Amid;
        enrl.Am_Name__c                 = p_enrl.Am_Name__c; //AmN;
        // AO changes begin 06/21/2016 
        enrl.EIN__c                     = p_enrl.EIN__c; //EIN;
        // AO changes end 06/21/2016
        
        return enrl;
     }
}