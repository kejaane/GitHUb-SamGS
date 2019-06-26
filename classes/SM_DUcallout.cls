//=========================================================================================
//      Date: 03/30/2018    
// Developer: Tom Barrett
//   Purpose: This class performs the callout to the SM_DUservice which deactivates
//            the user(s). 
//                                        
//=========================================================================================
//                                 Update History
// Date       Developer     	Tag     Description
//=========================================================================================
//
//=========================================================================================
public class SM_DUcallout implements Queueable, Database.AllowsCallouts {       
    private final Set<Id> UserIds;    
    private final List<NamedCredential> NamedCredentialList;
    Static integer LoopCounter = 0;
    public String EmailGrouping;
    public SM_DUcallout(List<NamedCredential> NC, Set<Id> UserIds, String EmailGrouping) {
        this.NamedCredentialList = NC;
        this.UserIds = UserIds;
        this.EmailGrouping = EmailGrouping;           
    }
    
    /************************************************************
     * This method gathers the necessary information that
     * the SM_DUservice requires in order to deprovision user(s).
     ************************************************************/
    public void execute(QueueableContext context) {        
        System.debug('---SM_DUcallout.execute---');         
        
        SM_Support sms = new SM_Support();                           
		SM_Wrappers wrp = new SM_Wrappers();
        wrp.getUsers(UserIds);       
        
		List<SM_Wrappers.UserWrapper> UserWrapperList = new List<SM_Wrappers.UserWrapper>();
        UserWrapperList = wrp.UserWrapperMap.values();

        Map<String, String> NamedCredentialToSandboxNameMap = sms.NamedCredentialToSandboxNameMap;
        //Holds the callout and response data for storing in the log at the very end of all the callouts
        List<SM_Support.LogWrapper> LogWrapperAccumulativeLogList = new List<SM_Support.LogWrapper>();
        String SandboxName = sms.SandboxName;
        String LogGrouping = ''; 

        //Loop through the named credentials associated to the production org that 
        //starts with the name 'Sandbox_Manager_n'.  For each named credential loop 
        //through the users and build the UsernameAdjusted value which appends the 
        //sandbox name to the username and stores it in the UsernameAdjusted variable.
        for (NamedCredential nc : NamedCredentialList) {            
            List<SM_Support.LogWrapper> LogWrapperList = new List<SM_Support.LogWrapper>();   
            SandboxName = NamedCredentialToSandboxNameMap.get(nc.DeveloperName);  
            //For code coverage only becaus SF doesn't allow Named Credential creation in test classes
			if(Test.isRunningTest()) SM_Wrappers.DeprovisionSandboxLimitList.add(SandboxName);
            //Skip Logic
            if (!SM_Wrappers.DeprovisionSandboxLimitList.isEmpty() && !SM_Wrappers.DeprovisionSandboxLimitList.contains(SandboxName)) Continue;            
            //Loop through each user in the list and adjust the username by appending
            //the associated sandbox named which is derived from the named credentials
            //URL field (DeveloperName) from above.
            for (SM_Wrappers.UserWrapper u : UserWrapperList) {                
                //Get milliseconds and increment by 1 just in case the for loop processes
                //two loops within a single millisecond so the number is unique for sure!
                LogGrouping = String.valueOf(System.currentTimeMillis() + LoopCounter);
                LoopCounter++;     
                
                u.Sandboxname = SandboxName;
                u.EmailGrouping = EmailGrouping;
                u.LogGrouping = LogGrouping;
                u.UsernameAdjusted = u.Username + '.' + SandboxName;                
                //Detected running in sandbox to simulate production so the appended sandbox name must be removed from the 
                //user and the calling sandbox name added.  This only applies when running as a client in a sandbox for testing.
                if (SM_Support.isSandbox()) {
                    if (u.Username.Contains('.')) {
                    	u.UsernameAdjusted = u.Username.substring(0, U.Username.lastIndexOf('.')) + '.' + SandboxName;
                    }
                }               
                //Build Callout Log Record
                SM_Support.LogWrapper LogWrapper = new SM_Support.LogWrapper(); 
                LogWrapper.EmailGrouping = EmailGrouping;
                LogWrapper.LogGrouping = LogGrouping + '_DU_1'; 
                LogWrapper.SandboxName = 'Production'; 			//SandboxName;
                LogWrapper.Severity = 'None';
                LogWrapper.MsgSource = 'SM_DUcallout';
                LogWrapper.Msg = 'Deprovision User Action';
                LogWrapper.Username = u.Username; 				// u.UsernameAdjusted;
                LogWrapper.ProfileName = u.ProfileName;
                LogWrapper.LastModifiedDate = u.LastModifiedDate;
                LogWrapper.LastLoginDate = u.LastLoginDate;
                LogWrapper.PermissionSets = u.PermissionSets;
                LogWrapperList.add(LogWrapper); 
            } //END OF for (SM_Support.UserWrapper u : UserWrapperList)            

            //Add Callout to Accumulative list
            LogWrapperAccumulativeLogList.addAll(LogWrapperList);
            //Make the callout but first clear the LogWrapperList
            //so we dont duplicate log entries.
            LogWrapperList = null;
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
        //Lets get the first record from the list so if we have a status 
        //error back from the service we can create an EmailGrouping # 
        //that matches the callout EmailGrouping # and LogGrouping # 
        //that matches the callout LogGroup #.        
        String EmailGrouping = wrp.UserWrapperMap.values()[0].EmailGrouping;
        String LogGrouping = wrp.UserWrapperMap.values()[0].LogGrouping;
        LogGrouping += '_DU_2'; 
        String SandboxName = wrp.UserWrapperMap.values()[0].SandboxName;
        String MsgExtended = '';        
        
        //Serialize the data to pass to the REST service
        String WrpSerialized = JSON.serialize(wrp, true); 
        String Endpoint = 'callout:' + NamedCredential + '/services/apexrest/SM_DUservice';   
        System.debug('Endpoint: ' + Endpoint);
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(Endpoint);
        req.setMethod('POST');
        req.setTimeout(SM_Wrappers.Timeout);
        Http http = new Http();
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');        
        req.setBody(WrpSerialized);

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
                    lw.MsgSource = 'SM_DUservice';
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
            lw.MsgSource = 'SM_DUservice';
            lw.Msg = 'Error: ' + e.getMessage() + ' - occurred at line number: ' + e.getLineNumber();
            lwList.add(lw);            
            return lwList;
        }
    }
}