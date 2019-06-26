/*=========================================================================================
 * Date       : 5/24/16
 * Developer  : Rajesh Pennam
 * Purpose    : The purpose of this class is to identify the survey contacts for Qualtrics
 *              and to update the field for those contact
 *
 *Check with the survey contacts related list in opportunity where the “Executive” or “Day to Day” 
 *This Job should make the value of the field(contact.SBU_Market_Segment__c) to null then our batch should run to give new value
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 05/24/16  |  Rajesh Pennam   |  Initial Version                                         
 *           |        | 
 *=========================================================================================*/

global class UpdateSurveyContactsToNull implements Database.Batchable<Sobject>, Database.Stateful{
    global String query;
    private String EmailBody = '';
    private String NonTrappableErrorMsg = '';
    private Boolean NonTrappableError = FALSE; 
    private static final String Subject = 'Apex: Update survey contact Field SBU_Market_Segment__c To NULL Process...'; 

    global Database.QueryLocator start(Database.BAtchableContext BC){
                                 
        return Database.getQueryLocator(QueryBase.getQueryToNull());    
        
    }
    global void execute(Database.BatchableContext BC,List<Survey_Contacts__c> scope){
        //Store Contact Ids in Set from Survey Contact List On Opportunity Record to update Contacts.
        system.debug('Values in Query'+scope);
        set<string> conIds = new set<string>();
        for(Survey_Contacts__c s: scope){
            //Add Contact Ids to Set
            conIds.add(s.Contact__c);
        }
        //Get Contacts from Contact Object where Contact Ids in Set.
        List<Contact> conlst = [select Id,Name from Contact where Id IN :conIds AND SBU_Market_Segment__c != NULL];
        //Check Return List in Execute Batch have any null values if No Null Values just update the Contact List.
        //First Update Contacts With Null Value for SBU_Market_Segment__c Field
        if(scope != null && scope.size()>0){
            for(Contact c: conlst){
                c.SBU_Market_Segment__c = null;
            }
        }
        try{
            //Update Contact List with SBU/Market Segment as NULL
            if(conlst.size()>0 && conlst != null)
                update conlst;
        }catch(DMLException ex){
            system.debug(ex+'');
        }
    }
    global void finish(Database.BatchableContext BC){
         // Query the AsyncApexJob object to retrieve the current job's information.
        try {
            AsyncApexJob a = [ SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                               FROM AsyncApexJob 
                               WHERE Id = :BC.getJobId() and JobType <> 'BatchApexWorker' ];
            //Build email message                             
            EmailBody += '<b>The Batch Apex job</b> ' + a.Status + '.<br/>';               
            EmailBody += '<b>The Batch Apex job processed</b> ' + a.TotalJobItems + ' <b>batches with</b> ' + a.NumberOfErrors + ' <b>failures.</b><br/>';
            EmailBody += '<b>The job was executed by:</b> ' + a.CreatedBy.Email + '.<br/><br/>';
                     
        DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('sfdcTeamEmail');
        String[] toAddresses = cs.Email__c.Split(',');
        Utils.EmailUtil EmailSupport = new Utils.EmailUtil(toAddresses); 
        EmailSupport.subject(subject);
        EmailSupport.replyTo(UserInfo.getUserEmail());
        EmailSupport.htmlBody(emailBody);
        EmailSupport.sendEmail();
                                     
                             
        } catch(System.Exception e) {
            System.debug(LoggingLevel.ERROR, 'Exception in Survey Contact Update Batch.finish: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());                     
        } 
    }
}