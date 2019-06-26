/*########################################################################################################################
Class        :   CIAM_Contact_Creation_Process
Author       :   Ashish Ojha
Created Date :   8/28/2016
Description  :   This class is used to upsert the data in Contact Object based on the Agency_Agent_id from CIAM
                 Import Object.This batch will run once to upsert the records from CIAM Import Object. 
                 
Note         :   This code will only run once in production as part of the initial Community user Contact creation.
                 The record type for this new upsert will be “Community User Contact” Record type. 
                 The Community user contact will have 4 new custom Look up field that will get populated in this batch process
                 The look up relationships(both 2-50 and 51+ contact) will be established when available 
                 based on the entity id of a contact record with matching Agent id on Ciam import table 
                 The look up relationships(both 2-50 and 51+ contact) will be established when available 
                 based on the entity id of a contact record with matching Agency id on Ciam import table
                 Uses Agency_Agent_ID__c for the upsert key.               
                 
Execution    :   Execute Anonymous on Developer Console 
                 CIAM_Contact_Creation_Process bc = new CIAM_Contact_Creation_Process(null);
                 database.executeBatch(bc);
*/
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
//====================================================================================================
global class CIAM_Contact_Creation_Process implements Database.Batchable<SObject>,database.stateful{
    Integer totfailure = 0;
    Integer totUpserts = 0;
    Integer totprocessed = 0;
    // This variable is used to when we are passing the query from the developer console
    private String aquery=null;
    private String entType = null;
    private String EmailBody = '';
    private integer BatchCount = 0; 
    private static final String Subject = 'Apex: CIAM_Contact_Creation_Process'; 
    private String NonTrappableErrorMsg = '';
    private Boolean NonTrappableError = FALSE; 
    private String failedRecordIds = '';
    public class CIAMException extends Exception{}
    //Constructor for the batch : to pass the query from developer console.
    public CIAM_Contact_Creation_Process(String query) {
        this.aquery = query;        
    }
    global database.querylocator start(Database.BatchableContext bc) {     
       String Query = 'Select id, Name, Agency_Agent_ID__c, Agent_ID__c, Agency_ID__c, Broker_Title__c, Email_Address__c, Agent_first_name__c, Agent_last_Name__c, Agency_name__C, Processed__c ' +
                       'FROM CIAM_Import_Table__c ' +
                       'WHERE Processed__c = false'; 
                       
                       
        if(aquery != NULL)
        {
           query=aquery;  
        }  
     
        return Database.getQueryLocator(query);   
    }
    
    global void execute(Database.BatchableContext bc, CIAM_Import_Table__c[] ciamLst) { 
        BatchCount += 1;
        string conRtId = querybase.getRecordtypeId('Contact', 'Community_User_Contact');
       // string AccId  =  [Select id from Account where Name = 'Community_User_Account'].id;
        List<Contact>   conListToUpsert = new List<Contact>();
        
        Map<String, id> account250Map = new Map<String, id>();
        Map<String, id> account51Map = new Map<String, id>();
        Map<String, id> contact250Map = new Map<String, id>();
        Map<String, id> contact51Map = new Map<String, id>();
        Map<string,contact> conUpsMap = new Map<string,contact>();
        set<string>  agentid = new set<string>();
        set<string> agencyid = new set<string>();
        id accid = [Select id from Account where Name = 'Community_User_Account'].id;
        Contact con;         
            
        /******************* Iterating on all the CIAM Import Records ***********************************/   
         
        //List of Ciam import object which we are getting from Start method 
        if(ciamLst != null && ciamLst.size() > 0){
        System.debug('ciamlist' +ciamlst);
        
            for(CIAM_Import_Table__c cim: ciamLst){
                agentid.add(cim.Agent_ID__c);
                agencyid.add(cim.Agency_ID__c);
            }
            if(agentid.size()>0) {
               
                for(account acc:[select id,Entity_ID__c,recordType.DeveloperName from account where Entity_ID__c  != NULL AND Entity_ID__c IN :agencyid AND recordType.DeveloperName = 'X2_50']){
                        account250Map.put(acc.Entity_ID__c, acc.id); 
                    
                  }
               for(account acc1:[select id,Entity_ID__c,recordType.DeveloperName from account where Entity_ID__c  != NULL AND Entity_ID__c IN :agencyid AND  recordType.DeveloperName = 'X51']){
    
                        account51Map.put(acc1.Entity_ID__c, acc1.id);
                    
                }
                for(Contact co:[select id,Entity_ID__c,recordType.DeveloperName from Contact where Entity_ID__c  != NULL AND Entity_ID__c IN :agentid AND recordType.DeveloperName = 'X2_50' ]){
                        contact250Map.put(co.Entity_ID__c, co.id); 
                    
                   }
                for(Contact co1:[select id,Entity_ID__c,recordType.DeveloperName from Contact where Entity_ID__c  != NULL AND Entity_ID__c IN :agentid AND  recordType.DeveloperName = 'X51']){
                    
                        contact51Map.put(co1.Entity_ID__c, co1.id); 
                    
                }
                
            }    
               
            for(CIAM_Import_Table__c cim: ciamLst){
                totprocessed += 1;
                // If account has not been put into the map then put it there
                // for the first time
                con = new Contact();
                    con.AccountId =  accid;
                    con.Firstname    = cim.Agent_First_Name__c;
                    //Con.MiddleName   = cim.Agent_Middle_Initial__c;
                    con.lastName     =cim.Agent_Last_Name__c;
                    con.Agent_ID__c = cim.Agent_ID__c;
                    con.Recordtypeid = conRtid;
                    con.email        = cim.Email_Address__c;
                    Con.Agency_Agent_Id__c = cim.Agency_Agent_Id__c;
                    con.Community_User_type__c = cim.Broker_Title__c == 'Assistant'?'Assistant':'Broker Agent';
                    con.X51_Contact__c = contact51Map.containsKey(cim.Agent_ID__c)?contact51Map.get(cim.Agent_ID__c):null;
                    con.X51_Account__c = account51Map.containsKey(cim.Agency_ID__c)?account51Map.get(cim.Agency_ID__c):null;
                    con.X2_50_Contact__c = contact250Map.containsKey(cim.Agent_ID__c)?contact250Map.get(cim.Agent_ID__c):null;
                    System.debug('------'+Con.X2_50_Contact__c);
                    con.X2_50_Account__c = account250Map.containsKey(cim.Agency_ID__c)?account250Map.get(cim.Agency_ID__c):null;
              conUpsMap.put(cim.Agency_Agent_id__c, con); 
            cim.Processed__c = True;
            }  
                       
        }
        // put all map data into a list          
        conListToUpsert = conUpsMap.values();
         
        
        if(conListToUpsert!= null && conListToUpsert.size() > 0) {
        
        Savepoint sp = Database.setSavepoint(); 
                
        try{
           
            //upsert accListToUpsert Agency_Agent_ID__c;
            if (conListToUpsert != NULL && conListToUpsert.size() > 0){
            upsert conListToUpsert Agency_Agent_ID__c;
            }
            if(ciamLst != null && ciamLst.size() > 0){
                update ciamLst;
                }
                                          
         }catch(System.Exception e){
             Database.rollback(sp);
             System.debug(LoggingLevel.ERROR, 'Exception in CIAM_Import.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
             NonTrappableErrorMsg += '<b>Exception in CIAM_Import.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>'; 
             NonTrappableErrorMsg += '<b>Error occured during batch #</b>' + BatchCount + '<br/>';  
             NonTrappableError     = true; 
             totfailure += conListToUpsert.size();                  
             throw new CIAMException(NonTrappableErrorMsg);      
            }                            
         }
         totupserts = totprocessed - totfailure;
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
            EmailBody += '<b>Total CIAM Import Records Processed: </b> ' + totprocessed + '<br/>';                
            EmailBody += '<b>Total CIAM Import Records Upserts: </b> ' + totUpserts + '<br/>';
            EmailBody += '<b>Total CIAM Import Records Failure: </b> ' + totfailure + '<br/>';
                               
            // EmailBody += '<b>Total Broker Import Records Failures: </b> ' + totFailures + '<br/>';
            //EmailBody += '<b>Total Broker Import Records Failures Record Ids: </b> ' + failedRecordIds + '<br/>';
            if (NonTrappableError || Test.isRunningTest()) {
                EmailBody += '<br/><b>*** SERIOUS ISSUE OCCURED ***</b><br/>';
                EmailBody += NonTrappableErrorMsg + '<br/><br/>';
                EmailBody += '<b>Check the logs for details.</b><br/>';
            }
               
               
           DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');
           string[] toAddresses = cs.Text_255__c.Split(',');
           Utils.EmailUtil Email = new Utils.EmailUtil(toAddresses); 
           Email.subject(subject);
           Email.replyTo(UserInfo.getUserEmail());
           Email.htmlBody(emailBody);
           Email.sendEmail();      
           
                                         
        } catch(System.Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception in BrokerImport.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                     
        }   
    }    
}