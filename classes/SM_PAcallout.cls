//=========================================================================================
//      Date: 07/22/2018//      
// Developer: Tom Barrett (TPB)
//   Purpose: This class performs the callout to the SM_PAservice which creates a list of
//            users with profiles that match the SM_Setting__mdt Profile_Audit_Profile_List
//            record's Text_Area_255__c values that actually are set in production. 
//            Before the callout the SM_PAcallout class collects the same thing from production.  
//            Once all is collected the information is sent out in an email.   
//            
//     Usage: SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Profile_Audit);
//                       
//      NOTE: Before building a package don't forget to uncomment out the 
//            line mentioned below.  Forgetting to do so can produce unexpected results.  
//            Currently, the other class that also requires updating is SM_User_Trigger_Logic.                                      
//=========================================================================================
//                                 Update History
// Date       Developer     Tag     Description
//=========================================================================================
//
//=========================================================================================
public class SM_PAcallout implements Queueable, Database.AllowsCallouts {   
    private final List<NamedCredential> NamedCredentialList;
    Static integer LoopCounter = 0;    
    public String EmailGrouping;
    public Boolean GetProdInfoOnce;
    public SM_PAcallout(List<NamedCredential> NC, String EmailGrouping, Boolean GetProdInfoOnce) {
        System.debug('---SM_PAcallout---');
        this.NamedCredentialList = NC;
        this.EmailGrouping = EmailGrouping;
        this.GetProdInfoOnce = GetProdInfoOnce;
    }    
    
    /************************************************************
     * This method gathers the necessary information that the 
     * SM_DUservice requires in order to profile audit user(s).
     ************************************************************/
    public void execute(QueueableContext context) {       
        System.debug('---SM_PAcallout.execute---');
        //This called just to instantiate its public static variables          
        SM_Wrappers wrp = new SM_Wrappers();
        //Get SM_Support Info        
        SM_Support sms = new SM_Support();
        
        //Uncomment prior to making a package and running in production
        //If you are testing in a sandbox the sandbox that is used to simulate 
        //production must have this line commented out while the destination
        //sandbox(s) must have this line uncommented
        if (SM_Support.isSandbox() && !Test.isRunningTest()) return;        
       
        String LogGrouping = '';                  
        Map<String, String> NamedCredentialToSandboxNameMap = sms.NamedCredentialToSandboxNameMap;
     
        //Holds the callout and response data for storing in the log at the very end of all the callouts
        List<SM_Support.LogWrapper> LogWrapperAccumulativeLogList = new List<SM_Support.LogWrapper>();
        String SandboxName = sms.SandboxName;
        List<String> ProfileAuditSandboxLimitList = SM_Wrappers.ProfileAuditSandboxLimitList;  
        List<String> ProfileAuditProfileList = SM_Wrappers.ProfileAuditProfileList;    
        Boolean ExcludeFrozenUsers = SM_Wrappers.ExcludeFrozenUsersEnabled;    
        List<SM_Support.LogWrapper> LogWrapperProdList = new List<SM_Support.LogWrapper>();
        LoopCounter++;
        LogGrouping = String.valueOf(System.currentTimeMillis() + LoopCounter);
        
        //Get list of users that match the ProfileAuditProfileList 
        //values but only do it once per trigger fire
        if (!GetProdInfoOnce) {          
            LogWrapperProdList = SM_Support.buildLogWrapperForPA(ProfileAuditProfileList, EmailGrouping, LogGrouping+'_PA_1', 'Production', 'SM_PAcallout');
            LogWrapperProdList = SM_Support.getIsFrozen(LogWrapperProdList, ExcludeFrozenUsers);
        }
        //Add the production audit list to the accumulative list which will contains 
        //both production and sandboxes audits by the time all sandboxes are processed.
        LogWrapperAccumulativeLogList.addAll(LogWrapperProdList);        
           
        String EmailBodyStatement = '<b>A Profile Audit User action was detected for user(s), with the following profiles ' + ProfileAuditProfileList + ':</b><br/><br/>';
        Boolean CriticalErrorDetected = false;  //controls sending the critical email with list of errors
       
        //Loop through the named credentials associated to the production org that 
        //start with the name 'Sandbox_Manager_n'.  For each named credential loop 
        //build a dummy record to be able to pass to the service the sandbox name,
        //Email Grouping, and LogGrouping.
        for (NamedCredential nc : NamedCredentialList) { 
            SandboxName = NamedCredentialToSandboxNameMap.get(nc.DeveloperName);
            //For code coverage only becaus SF doesn't allow Named Credential creation in test classes
            if(Test.isRunningTest()) SM_Wrappers.ProfileAuditSandboxLimitList.add(SandboxName);
            //Skip logic 
            if (!ProfileAuditSandboxLimitList.isEmpty() && !ProfileAuditSandboxLimitList.contains(SandboxName)) Continue; 
       
            //Build a dummy user wrapper record because the SM_PAcallout 
            //doesn't run from a user trigger like the SM_PUcallout and 
            //SM_DUcallout classes do.           
            wrp.UserWrapperMap.clear();
            SM_Wrappers.UserWrapper uw = new SM_Wrappers.UserWrapper();
            uw.EmailGrouping = EmailGrouping;
            uw.LogGrouping = LogGrouping;
            uw.SandboxName = SandboxName;
            
            wrp.UserWrapperMap.put('DummyRecord', uw); 

            List<SM_Support.LogWrapper> LogWrapperList = new List<SM_Support.LogWrapper>(); 
            //Make the callout 
            LogWrapperList = MakeCallout(nc.DeveloperName, wrp);
            //Add response to Accumulative list
            LogWrapperAccumulativeLogList.addAll(LogWrapperList);            
        } // END OF for (NamedCredential nc : NamedCredentialList)                        
        
        SM_Logging log = new SM_Logging(LogWrapperAccumulativeLogList, SM_Wrappers.DayToStartDeletion, false);      
    }
    
    
    /*****************************************************
     * This is the actual method that performs the callout
     *****************************************************/
    private static List<SM_Support.LogWrapper> MakeCallout(String NamedCredential, SM_Wrappers wrp) {         
        //Lets get the dummy record content created from caller so we can have 
        //it ready in case we get an error back from the service we can create 
        //an EmailGrouping # that matches the callout EmailGrouping # and 
        //LogGrouping # that matches the callout LogGroup #. 
        String SandboxName = wrp.UserWrapperMap.values()[0].SandboxName;
        String EmailGrouping = wrp.UserWrapperMap.values()[0].EmailGrouping;
        String LogGrouping = wrp.UserWrapperMap.values()[0].LogGrouping;
        LogGrouping += '_PA_2';         
        String MsgExtended = '';
        //Serialize the data to pass to the REST service
        String UsernamesSerialized = JSON.serialize(wrp, true); 
        String Endpoint = 'callout:' + NamedCredential + '/services/apexrest/SM_PAservice';   
        System.debug('Endpoint: ' + Endpoint);     
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(Endpoint);
        req.setMethod('POST');       
        req.setTimeout(SM_Wrappers.Timeout);
        Http http = new Http();
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(UsernamesSerialized);

        try {
            HTTPResponse res = http.send(req);
            //Deserialize response so it can eventually be easily saved to the SM_Log__c table later
            List<SM_Support.LogWrapper> deserializedLogWrapperList = (List<SM_Support.LogWrapper>) JSON.deserialize(res.getBody(), List<SM_Support.LogWrapper>.class);
            //Check for status code errors and log accordingly      
            If (res.getStatusCode() != 200) {
                MsgExtended = SM_Support.getResponseErrorMsg(res.getStatusCode());  
                
                for (SM_Support.LogWrapper lw : deserializedLogWrapperList) {
                    lw.EmailGrouping = EmailGrouping;
                    lw.LogGrouping = LogGrouping;
                    lw.SandboxName = SandboxName;
                    lw.Severity = 'Critical';
                    lw.MsgSource = 'SM_PAservice';
                    lw.Msg = 'StatusCode: ' + res.getStatusCode() + ' - ' + res.getStatus() + MsgExtended;
                }
            }        
            return deserializedLogWrapperList;            
        } catch (Exception e) {
            System.debug('Request Exception: ' + e.getMessage());
            List<SM_Support.LogWrapper> lwList = new List<SM_Support.LogWrapper>();
            SM_Support.LogWrapper lw = new SM_Support.LogWrapper();
            lw.EmailGrouping = EmailGrouping;
            lw.LogGrouping = LogGrouping;
            lw.SandboxName = SandboxName;
            lw.Severity = 'Critical';
            lw.MsgSource = 'SM_PAservice';
            System.debug('LW: ' + lw);
            lw.Msg = 'Error: ' + e.getMessage() + ' - occurred at line number: ' + e.getLineNumber();
            lwList.add(lw);            
            return lwList;
        }
    }
}