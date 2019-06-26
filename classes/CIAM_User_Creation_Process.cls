/* =========================================================================================
 * Date         : 08/30/2016
 * Developer    : Chandra Byreddy
 * Description  : This class is used to insert  data in user object from CIAM
 *                This batch will run once to insert the records from CIAM Import Object.
 *                This batch has to be run Only after  CIAM_Contact_Creation_Process is ran.
 * Purpose      : This code will only run once in production as part of the initial Community user creation.
 *                Added upsert functionality by laveen
 *                User contact will be based on Entity_ID from CIAM table to Entity ID in Contact.
 * Execution    :  Execute Anonymous on Developer Console 
 *                CIAM_User_Creation_Process bc = new CIAM_User_Creation_Process(null);
 *                database.executeBatch(bc); 
 *=========================================================================================
 * Update History
 *  ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 08/30/16   |  Chandra Byreddy    | Initial Version  
 * 04/25/2017 |  Laveen Kattela     | Updated upsert funcationlity                                     
 *===========+============+================================================================
 */

global class CIAM_User_Creation_Process implements Database.Batchable<sObject> {

    private static final String Subject = 'Apex: CIAM_User_Creation_Process'; 
    private String NonTrappableErrorMsg = '';
    private Boolean NonTrappableError = FALSE; 
    private String failedRecordIds = '';
    public class CIAMException extends Exception{}
    private String aquery=null;
         
    private integer BatchCount = 0;
    Integer totfailure = 0;
    Integer totUpserts = 0;
    Integer totprocessed = 0;
    private String EmailBody = '';
    Integer Failed_Records = 0;
    Integer Processed_Records = 0;
    Integer Total_Records = 0;

    Boolean sendUserEmail = false;
    Boolean allOrNone = FALSE;


        //Constants to feed user record
        Id communityProfileId ='00e600000016Bb9';
        String userLicenseString ='Customer Community Plus Login';
        //String userRoleString='Dummy 3rd contact Customer User';
        String licenseCategoryString ='Small/Mid Community User';
        
        //Constructor to execute query from dev console
        public CIAM_User_Creation_Process(String query) {
        this.aquery = query;
        }


            global Database.QueryLocator start(Database.BatchableContext bc) {
            String Query = 'SELECT id, Agent_First_Name__c, Agent_Last_Name__c, Agent_Middle_Initial__c, Agent_Name__c, Agency_Name__c, Broker_Title__c, Agent_ID__c, Email_Address__c, User_ID__c, Federation_ID__c, Agency_Agent_ID__c from CIAM_Import_Table__C';
            if(aquery != NULL)
             {
             query=aquery;  
             }  
                return Database.getQueryLocator(query);
            }
            
            global void execute (Database.BatchableContext bc, List<CIAM_Import_Table__C> ciamTableList) {
                BatchCount += 1;
                String firstLetterInFirstName;
                
                List<User> newUserList = new List<User>();
                set<string>  agency_agentid = new set<string>();  
                Map<id,id> userMap = new Map<id,id>(); // 4-25-2017 Added by laveen for upsert funcationality 
                Map<id,Contact> contactMap = new Map<id,Contact>(); // Added by laveen

            
                    if (ciamTableList != null && ciamTableList.size()>0)
                    {
                        for(CIAM_Import_Table__c cim: ciamTableList){
                            agency_agentid.add(cim.Agency_Agent_ID__c);
                        }
                                    
                        Map<String, Contact> contMap = new Map<String, Contact> ();
                        List<Contact> contList =[SELECT id, Community_User_Type__c, Agency_Agent_ID__c from Contact where Agency_Agent_ID__c IN :agency_agentid ];
                        contactMap.putAll(contList); // laveen Code starts
                        List<User> userList = [Select id, ContactId from user where contactId in :contactMap.keyset()]; 
                        
                        for(User uobj: userList){
                            userMap.put(uobj.ContactId,uobj.id);
                        }
                         // laveen Code end
                        for ( Contact co : contList)
                        {
                            contMap.put(co.Agency_Agent_ID__c, co);
                        }
                        for (CIAM_Import_Table__C c : ciamTableList) {
                                System.debug('@@@Iterating from Actual loop'); 
                                Contact cont = new Contact();
                                if (contMap.containsKey(c.Agency_Agent_ID__c))
                                cont = contMap.get(c.Agency_Agent_ID__c);
                                String trimFirstName;
                                if(c.Agent_First_Name__c.length()>=8 )
                                {
                                    trimFirstName = c.Agent_First_Name__c.substring(0,7);
                                    System.debug('@@@ Trimmed First Name ==>' + trimFirstName);
                                }
                                else
                                {
                                    trimFirstName = c.Agent_First_Name__c;
                                }
                                String trimLastName;
                                //String trimLastName1;
                                if(c.Agent_Last_Name__c.length() >= 8)
                                {
                                    trimLastName = c.Agent_Last_Name__c.substring(0,7);
                                    System.debug('@@@ Trimmed Last Name ==>' + trimLastName);
                                    //trimLastName1 = c.Agent_Last_Name__c.substring(0,7);
                                }
                                else
                                {
                                    trimLastName = c.Agent_Last_Name__c;
                                    //trimLastName1 = c.Agent_Last_Name__c.substring(0,7);
                                }
                                String alias = trimFirstName.subString(0,1) + trimLastName ;
                                System.debug('@@@ Agent Alias which is ==>' + alias );
                                String nickName = trimFirstName+'.'+trimLastName;
                                 // laveen start
                                ID userId =null;
                                if(cont.id != null && userMap.containskey(cont.id))
                                userId = userMap.get(cont.id);
                                // laveen end
                                User newUser = new User(
                                FirstName = c.Agent_First_Name__c,
                                LastName = c.Agent_Last_Name__c,                                
                                Alias = alias,
                                Email = c.Email_Address__c,
                                UserName = c.Email_Address__c+'.'+c.Federation_ID__c,  //Added by laveen
                                CommunityNickName = c.Agent_First_Name__c+'.'+c.Agent_Last_Name__c +'.'+c.Federation_ID__c,  //Added by laveen
                               /* link to the contact and to the account through the contact... */ 
                                ContactId = cont.Id,
                                Id = userId,
                                ProfileId = communityProfileId,
                                IsActive = TRUE,
                                License__c= licenseCategoryString,
                                FederationIdentifier=c.Federation_ID__c,
                                Broker_Role__c = cont.Community_User_Type__c,
                                CompanyName = c.Agency_Name__c,
                                emailencodingkey = 'UTF-8',
                                languagelocalekey = 'en_US',
                                LocaleSidKey = 'en_US',
                                TimeZoneSidKey = 'America/New_York'  );
                                
                        
                                System.debug('@@@ New User record formed ==>' + newUser);   
                                Database.DMLOptions dmo = new Database.DMLOptions();
                                dmo.EmailHeader.triggerUserEmail = sendUserEmail;
                                newUser.setOptions(dmo);
                
                                newUserList.add(newUser);
                                    System.debug('@@@ New User List formed ==>' + newUserList);
                        }
                    try{
                        if (!newUserList.isEmpty()) {
                            //Database.SaveResult[] results = Database.insert(newUserList, allOrNone);    commented by laveen
                                Schema.SObjectField f = User.Fields.Id; // laveen code start
                              Database.UpsertResult[] results = Database.upsert(newUserList,f,false);// laveen code end
                           }
                                                      
                     }catch(System.Exception e){
                         System.debug(LoggingLevel.ERROR, 'Exception in CIAM_Import.Execute: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
                         NonTrappableErrorMsg += '<b>Exception in CIAM_Import.Execute: Error at line</b> ' + e.getLineNumber() + ' - ' + e.getMessage() + '<br/>'; 
                         NonTrappableErrorMsg += '<b>Error occured during batch #</b>' + BatchCount + '<br/>';  
                         NonTrappableError     = true; 
                         totfailure += newUserList.size();                  
                         throw new CIAMException(NonTrappableErrorMsg);      
                        }                            
                     }
                    // totupserts = totprocessed - totfailure;
            
            }
            
            // Execute Finish method
            global void finish(Database.BatchableContext bc) {
            
                try {
                        AsyncApexJob a = [ SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                                           FROM AsyncApexJob 
                                           WHERE Id = :BC.getJobId() and JobType <> 'BatchApexWorker' ];
                                           
                        if (NonTrappableError || Test.isRunningTest()) {
                            EmailBody += '<br/><b>*** SERIOUS ISSUE OCCURED ***</b><br/>';
                            EmailBody += NonTrappableErrorMsg + '<br/><br/>';
                            EmailBody += '<b>Check the logs for details.</b><br/>';
                        }
                                        
                    } catch(System.Exception e) {
                        System.debug(LoggingLevel.ERROR, 'Exception in BrokerImport.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                     
                    } 
                    
            }
            
            
}