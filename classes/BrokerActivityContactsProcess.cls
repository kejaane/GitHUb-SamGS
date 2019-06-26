/*############################################################################################################################
Class        :   BrokerActivitytContactsProcess
Author       :   Ashish Ojha
Created Date :   7/3/2014
Description  :   This class is used to upsert the data in the Contact Object based on the Entity Id and the entity type (SB) of the 
                 Broker_Import_2_50__c object.  This batch will run to upsert the records from Broker Import Object into contacts.
                 The batch will run such that if the Entity id on contact matches with the entity id of and existing Account record in
                 Salesforce, it will associate that contact to the Account else it will associate the contact with Account named 
                 2_50_Default Account.
Update       : 10/30/2015 : Ashish Ojha
               Introduced RecType_Entity_ID__c 
                
                 
Execution    :   BrokerActivityContactsProcess bc = new BrokerActivityContactsProcess(null);
                 database.executeBatch(bc);                 
*/
//====================================================================================================
//                                 Update History
// Date          Developer      Description
//====================================================================================================
// 03/28/2016    Tom Barrett    Made changes to handle a new custom setting field that will allow for
//                              muliple email addresses to be entered dynamically without changing code 
//
// 07/08/2016    Tom Barrett    Made code change to include Type in the SELECT statement for and 
//                              Account.Type = 'Partner' in the WHERE caluse for Accounts because we 
//                              were getting a 'Too many query rows: 50001' error.
//====================================================================================================
global class BrokerActivityContactsProcess implements Database.Batchable<SObject>,database.stateful{
 
    private String aquery=null;
    private String EmailBody = '';
    private integer BatchCount = 0; 
    private String NonTrappableErrorMsg = '';
    private Boolean NonTrappableError = FALSE; 
    private String failedRecordIds = '';
    Integer totfailure = 0;
    Integer totUpserts = 0;
    Integer totprocessed = 0;
    private static final String Subject = 'Apex: BrokerActivityContactsProcess';
    public class BrokerException extends Exception{}
 
    //Constructor for the batch : to pass the query from developer console.
    public BrokerActivityContactsProcess(String query) 
     {
    this.aquery = query;
     }
    global database.querylocator start(Database.BatchableContext bc)
         {
           //Query on the Broker Import 2-50 Objects, and querying all records provided that it is A Sb type record and has not been processed previously.
           String Query = 'Select id, Name, Account_Name__c, Address_Line__c,Email__c,Last_Name__c, First_Name__c, City__c, County__c, Entity_ID__c, Entity_Type__c, Phone__c, State__c, Zipcode__c ' +
                       'FROM Broker_Import_2_50__c ' + 
                       'WHERE Entity_Type__c = \'SB\' AND Processed__c = false'; 
           if(aquery!=NULL)
           {
              query=aquery;  
           }      
           return Database.getQueryLocator(query);   
         }
    global void execute(Database.BatchableContext bc, Broker_Import_2_50__c[] brokerImpList)
         {
/*****************************************************  Variable Declaration *********************************************/
         //Map to store Entity Id of account and the account record.
         BatchCount += 1;
         string RtId = querybase.getRecordtypeId('Contact', 'X2_50'); 
         Map<String,Account> mapEntityIdAndAccount = new Map<String,Account>();
         List<Account>   accListToUpsert           = new List<Account>();
         List<Contact>   conListToUpsert           = new List<Contact>();
         Map<String,Contact> mapEntityIdAndContact = new Map<String,Contact>();
 
         Id rt = QueryBase.getRecordtypeId('Account', 'X2_50');
 /************************** Map of All Accounts Entity Ids and associated Account records. ******************/
 //CHANGE TPB 07/08/2016 added the Type field to the SELECT and Type = 'Partner to the WHERE clause
         for(Account acc: [Select id,Type,Entity_ID__c,Entity_Type_AG__c,Entity_Type_FSP__c,Entity_Type_GP__c,Name,BillingStreet,BillingCountry,BillingState
                           From Account
                           Where RecordTypeId = :rt AND Type = 'Partner' ]){
             mapEntityIdAndAccount.put(acc.Entity_ID__c,acc);
         }    
         
         rt = QueryBase.getRecordtypeId('Contact', 'X2_50');
 /************************** Map of All Contacts Entity Ids and associated Contact records. ******************/
         for(Contact con: [Select id,Entity_ID__c,FirstName,LastName 
                           From Contact
                           Where RecordTypeId = :rt]){
             mapEntityIdAndContact.put(con.Entity_ID__c,con);
         }
         /******************* Iterating on all the Broker Import Records ***********************************/
         //List of broker import object which we are getting from Start method 
         if(brokerImpList != null && brokerImpList.size() > 0){ 
             for(Broker_Import_2_50__c brk: brokerImpList){
                 totprocessed += 1;
                 // If the Broker_Import__c Entity ID exists on the Salesforce Account Record
                 if(brk.Entity_ID__c != null && mapEntityIdAndAccount != null && mapEntityIdAndAccount.containsKey(brk.Entity_ID__c)){                   
 // we are getting the account Id of account with which the entity id matches the contact entity id                  
                    string accId = mapEntityIdAndAccount.get(brk.Entity_ID__c).id;
                    if(mapEntityIdAndContact.containsKey(brk.Entity_ID__c)){
                        Contact con = new Contact(id = mapEntityIdAndContact.get(brk.Entity_ID__c).id);
                        con.AccountId =  accId;
                        con.LastName  = brk.Last_Name__c;
                        con.firstName = brk.First_Name__c;
                        con.Entity_ID__c = brk.Entity_ID__c;
                    //AO 10/30/2015 Changes Begin
                        con.RecType_Entity_ID__c = '2-50_' + brk.Entity_id__c;
                    //AO  changes End
                        con.MailingStreet = brk.Address_Line__c;
                        con.MailingCity = brk.City__c;
                        con.MailingCountry = brk.County__c;
                        con.MailingState = brk.State__c;
                        con.MailingPostalCode =brk.Zipcode__c;
                        con.Phone =brk.Phone__c;
                        con.Email = brk.Email__c;
                        con.Entity_Type_SB__c = true;
                        con.recordtypeid =  RtId;
                        conListToUpsert.add(con);                                                        
                    }else{
 // sencond case if Entity Id matches with the one in account and contact entity does not exist, we insert the contact
                    
                        Contact con = new Contact();
                        con.AccountId =  accId;
                        con.LastName  = brk.Last_Name__c;
                        con.firstName = brk.First_Name__c;
                        con.Entity_ID__c = brk.Entity_ID__c;
                    //AO 10/30/2015 Changes Begin
                        con.RecType_Entity_ID__c = '2-50_' + brk.Entity_id__c;
                    //AO  changes End
                        con.MailingStreet = brk.Address_Line__c;
                        con.MailingCity = brk.City__c;
                        con.MailingState = brk.State__c;                        
                        con.MailingCountry = brk.County__c;
                        con.MailingPostalCode =brk.Zipcode__c;
                        con.Phone =brk.Phone__c;
                        con.Email = brk.Email__c;
                        con.Entity_Type_SB__c = true;
                        con.recordtypeid =  RtId;
                        conListToUpsert.add(con);
                    }                    
                }else{                 
                    // for the condition where  Account entity id does not match with Contact entity id but contact already exists                 
                    if(mapEntityIdAndContact.containsKey(brk.Entity_ID__c)){
                        Contact con = new Contact(id = mapEntityIdAndContact.get(brk.Entity_ID__c).id);
                        con.AccountId =  [Select id from Account where Name = '2_50_Default_Account'].id;
                        con.LastName  = brk.Last_Name__c;
                        con.firstName = brk.First_Name__c;
                        con.Entity_ID__c = brk.Entity_ID__c;
                    //AO 10/30/2015 Changes Begin
                        con.RecType_Entity_ID__c = '2-50_' + brk.Entity_id__c;
                    //AO  changes End
                        con.MailingStreet = brk.Address_Line__c;
                        con.MailingCity = brk.City__c;
                        con.MailingCountry = brk.County__c;
                        con.MailingState = brk.State__c;
                        con.MailingPostalCode =brk.Zipcode__c;
                        con.Phone =brk.Phone__c;
                        con.Email = brk.Email__c;
                        con.Entity_Type_SB__c = true;
                        con.recordtypeid =  RtId;                            
                        conListToUpsert.add(con);
                    }else{                    
                    // for the condition where  Account entity id does not match with Contact entity id but contact does not exist                                     
                            Contact con = new Contact();
                            con.AccountId =  [Select id from Account where Name = '2_50_Default_Account'].id;
                            con.LastName  = brk.Last_Name__c;
                            con.firstName = brk.First_Name__c;
                            con.Entity_ID__c = brk.Entity_ID__c;
                      //AO 10/30/2015 Changes Begin
                            con.RecType_Entity_ID__c = '2-50_' + brk.Entity_id__c;
                      //AO  changes End
                            con.MailingStreet = brk.Address_Line__c;
                            con.MailingCity = brk.City__c;
                            con.MailingState = brk.State__c;                           
                            con.MailingCountry = brk.County__c;
                            con.MailingPostalCode =brk.Zipcode__c;
                            con.Phone =brk.Phone__c;
                            con.Email = brk.Email__c;
                            con.Entity_Type_SB__c = true;
                            con.recordtypeid =  RtId;
                            conListToUpsert.add(con);
                         }
                     }
                 // After processing each record we check off the processed field on the Broker import object   
                 brk.Processed__c = true;
                }             
             }
         
 //Upserting the list of contact.
        /// Begin DML Updates  
        
          // upsert the contact data
         if(conListToUpsert != null && conListToUpsert.size() > 0) {        
       /// Begin DML Updates         
        Savepoint sp = Database.setSavepoint();                  
        try{
               upsert conListToUpsert;
             
             if(brokerImpList != null && brokerImpList.size() > 0){
                 upsert brokerImpList;
             }                             
        }catch(System.Exception e){
            Database.rollback(sp);
            System.debug(LoggingLevel.ERROR, 'Exception in Broker_Import.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
            NonTrappableErrorMsg += '<b>Exception in Broker_Import.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>'; 
            NonTrappableErrorMsg += '<b>Error occured during batch #</b>' + BatchCount + '<br/>';  
            NonTrappableError     = true; 
            totfailure += conListToUpsert.size();                  
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
            // Build email message
           // Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                         
            EmailBody += '<b>The Batch Apex job</b> ' + a.Status + '.<br/>';               
            EmailBody += '<b>The Batch Apex job processed</b> ' + a.TotalJobItems + ' <b>batches with</b> ' + a.NumberOfErrors + ' <b>failures.</b><br/>';
            EmailBody += '<b>The job was executed by:</b> ' + a.CreatedBy.Email + '.<br/><br/>';
            EmailBody += '<b>Begin Main Process</b><br/>';
            EmailBody += '<b>Total Broker Import Records Processed: </b> ' + totprocessed + '<br/>';                
            EmailBody += '<b>Total Broker Import Records Upserts: </b> ' + totUpserts + '<br/>';
            EmailBody += '<b>Total Broker Import Records Failure: </b> ' + totfailure + '<br/>';
                           
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