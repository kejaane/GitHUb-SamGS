/*########################################################################################################################
Class        :   BrokerActivityAccountsProcess
Author       :   Tom Barrett and Ashish Ojha
Created Date :   6/28/2014
Description  :   This class is used to upsert the data in Accounts Object based on the Entity Id and Entity Type of Broker
                 Import Object.This batch will run once to upsert the records from Broker Import Object. 
                 
Note         :   This code is not designed to handle situtations when the prior value of entity types change on the account.
                 Say for example Entity type changes from AG to GP for the same entity ID, the account record will update with 
                 Both AG and GP even though now this account record is no more an AG type entity. It was not coded to handle this
                 situation because the business told development that that situation should never happen.According to the business, 
                 this situation is extremely rare and may account for less than 1% of the situation.

Update: 10/26/2015 : Ashish Ojha
                 Introduced RecType_Entity_ID__c 
                 Used RecType_Entity_ID__C for the upsert function               
                 
Execution    :   Execute Anonymous on Developer Console 
                 BrokerActivityAccountsProcess bc = new BrokerActivityAccountsProcess(null);
                 database.executeBatch(bc);
*/
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
// 10/26/2015    Ashish Ojha    Introduced RecType_Entity_ID__c. Used RecType_Entity_ID__C for the upsert function
// 03/28/2016    Tom Barrett    Made changes to handle a new custom setting field that will allow for
//                              muliple email addresses to be entered dynamically without changing code  
//08/03/2017     Ashish Ojha    made updates to the code to check the checkbox for PDB if the parter account entity type is PDB
//====================================================================================================
global class BrokerActivityAccountsProcess implements Database.Batchable<SObject>,database.stateful{
    Integer totfailure = 0;
    Integer totUpserts = 0;
    Integer totprocessed = 0;
    // This variable is used to when we are passing the query from the developer console
    private String aquery=null;
    private String entType = null;
    private String EmailBody = '';
    private integer BatchCount = 0; 
    private static final String Subject = 'Apex: BrokerActivityAccountsProcess'; 
    private String NonTrappableErrorMsg = '';
    private Boolean NonTrappableError = FALSE; 
    private String failedRecordIds = '';
    public class BrokerException extends Exception{}
    //Constructor for the batch : to pass the query from developer console.
    public BrokerActivityAccountsProcess(String query) {
        this.aquery = query;        
    }
    global database.querylocator start(Database.BatchableContext bc) {     
       String Query = 'Select id, Name, Account_Name__c, Address_Line__c, City__c, County__c, Entity_ID__c, Entity_Type__c, Phone__c, State__c, Zipcode__c ' +
                       'FROM Broker_Import_2_50__c ' + 
                       'WHERE Entity_Type__c != \'SB\' AND Processed__c = false ';                        //'ORDER BY Entity_ID__c';  
                       
        if(aquery != NULL)
        {
           query=aquery;  
        }  
       
        return Database.getQueryLocator(query);   
    }
    
    global void execute(Database.BatchableContext bc, Broker_Import_2_50__c[] brokerImpList) { 
        BatchCount += 1;
        string RtId = querybase.getRecordtypeId('Account', 'X2_50');
        List<Account>   accListToUpsert = new List<Account>();
        Map<String, Account> accountMap = new Map<String, Account>();
        Account acc;         
            
        /******************* Iterating on all the Broker Import Records ***********************************/   
         
        //List of broker import object which we are getting from Start method 
        if(brokerImpList != null && brokerImpList.size() > 0){         
            for(Broker_Import_2_50__c brk: brokerImpList){
                totprocessed += 1;
                // If account has not been put into the map then put it there
                // for the first time
                acc = new Account();
                if( accountMap.get(brk.Entity_ID__c) == NULL ){                   
                    // Map broker import fields with account fields
                    acc.Type = 'Partner';
                    acc.recordtypeid =  RtId; 
                    acc.Name = brk.Account_Name__c;                    
                    acc.Entity_id__c = brk.Entity_id__c;
                    //AO 10262015 Changes Begin
                    acc.RecType_Entity_ID__c = '2-50_' + brk.Entity_id__c;
                    //AO  changes End
                    acc.BillingStreet = brk.Address_Line__c;
                    acc.BillingCity = brk.City__c;
                    acc.BillingState = brk.State__c;
                    acc.BillingPostalCode = brk.Zipcode__c;
                    acc.BillingCountry = brk.County__c;
                    acc.Phone = brk.Phone__c;                    
                    // Check for the Entity Type and set the account fields accordingly 
                    if(brk.Entity_Type__c == 'AG'){
                        acc.Entity_Type_AG__c  = true;
                    }
                    else if(brk.Entity_Type__c == 'FSP'){
                        acc.Entity_Type_FSP__c = true;
                    } 
                    else if(brk.Entity_Type__c == 'GP'){
                        acc.Entity_Type_GP__c  = true; 
                   }
                   //AO 08/03/17 changes Begin
                    else if(brk.Entity_Type__c == 'PDB'){
                        acc.Entity_Type_PDB__c  = true; 
                    }
                    //AO changes end
                    
                    accountMap.put(brk.Entity_ID__c,acc);  
                } else {
                    // Must have already added a matching entity id to the map
                    // so let's get the map record and update only the entity type
                    // and put it back in the map           
                    acc = accountMap.get(brk.Entity_ID__c);  
                        
                    if(brk.Entity_Type__c == 'AG'){
                        acc.Entity_Type_AG__c  = true;
                    }
                    else if(brk.Entity_Type__c == 'FSP'){
                        acc.Entity_Type_FSP__c = true;
                    } 
                    else if(brk.Entity_Type__c == 'GP'){
                        acc.Entity_Type_GP__c  = true; 
                    }
                    //AO 08/03/17 changes Begin
                    else if(brk.Entity_Type__c == 'PDB'){
                        acc.Entity_Type_PDB__c  = true; 
                    }
                    //AO changes end
                    accountMap.put(brk.Entity_ID__c, acc);     
                }                 
                // After processing each record we check off the processed field on the Broker import object 
                // so we do not reprocess the record again should we have to run again due to some batch failures  
                brk.Processed__c = true;
            }             
        }
        // put all map data into a list          
        accListToUpsert = accountMap.values();
         
        // upsert the account data
        if(accListToUpsert != null && accListToUpsert.size() > 0) {
        
        Savepoint sp = Database.setSavepoint(); 
                
        try{
            //AO Changes 10/26/2015
            //upsert accListToUpsert Entity_Id__c;
            
            upsert accListToUpsert RecType_Entity_ID__c;
            //End Change
            if(brokerImpList != null && brokerImpList.size() > 0){
                update brokerImpList;
            }                              
         }catch(System.Exception e){
             Database.rollback(sp);
             System.debug(LoggingLevel.ERROR, 'Exception in Broker_Import.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
             NonTrappableErrorMsg += '<b>Exception in Broker_Import.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>'; 
             NonTrappableErrorMsg += '<b>Error occured during batch #</b>' + BatchCount + '<br/>';  
             NonTrappableError     = true; 
             totfailure += accListToUpsert.size();                  
             throw new BrokerException(NonTrappableErrorMsg);      
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
            EmailBody += '<b>Total Broker Import Records Processed: </b> ' + totprocessed + '<br/>';                
            EmailBody += '<b>Total Broker Import Records Upserts: </b> ' + totUpserts + '<br/>';
            EmailBody += '<b>Total Broker Import Records Failure: </b> ' + totfailure + '<br/>';
                               
            // EmailBody += '<b>Total Broker Import Records Failures: </b> ' + totFailures + '<br/>';
            //EmailBody += '<b>Total Broker Import Records Failures Record Ids: </b> ' + failedRecordIds + '<br/>';
            if (NonTrappableError || Test.isRunningTest()) {
                EmailBody += '<br/><b>*** SERIOUS ISSUE OCCURED ***</b><br/>';
                EmailBody += NonTrappableErrorMsg + '<br/><br/>';
                EmailBody += '<b>Check the logs for details.</b><br/>';
            }
               
//BEGIN CHANGE TPB 03/26/2016 
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
// END CHANGE TPB 03/26/2016                             
        } catch(System.Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception in BrokerImport.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                     
        }   
    }    
}