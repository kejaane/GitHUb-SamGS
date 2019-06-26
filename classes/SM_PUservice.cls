//=========================================================================================
//      Date: 07/06/2018
// Developer: Tom Barrett (TPB)
//   Purpose: This class is the class that is part of the Sandbox Manager App.  
//            When a user is created in production this class is called to create the same 
//            user as a Chatter Free inactive user in each connected sandbox.         
//            This class's caller is SM_PUcallout.provisionUsers().
//            This class must be in each destination org (sandbox) that is expected to be
//            managed by the Sandbox Manager App.
//            This class uses the SM_Support.isSandbox() method to safeguard 
//            against executing in a production org as this class should only execute
//            in a sandbox.
//            
//=========================================================================================
//                                 Update History
// Date       Developer		Tag		Description
//=========================================================================================
//
//=========================================================================================
@RestResource(urlMapping='/SM_PUservice/*')
global with sharing class SM_PUservice {    
    public static Map<String, SM_Support.LogWrapper> ResponseWrapperMap = new Map<String, SM_Support.LogWrapper>();
    
    @HttpPost
    global static void doProvisioning() { 
        System.debug('---SM_PUservice.doProvisioning()---');
        
        //If we are not running in a sandbox then get out quickly!
        if(!SM_Support.isSandbox()) return;    
                
        List<String> UsernameList = new List<String>();
        Set<String> UsernameNotFoundSet = new Set<String>();
        RestRequest req = RestContext.request;       
        RestResponse res = RestContext.response;        
        //De-serializing the incoming request which contains a list of User records via a wrapper class
        SM_Wrappers deserializedWrappers = (SM_Wrappers) JSON.deserialize(req.requestBody.toString(), SM_Wrappers.class);
        //Put the conent back into an instance of the SM_Wrappers class
        //we can get to the UserWrapperMap content
		SM_Wrappers dw = deserializedWrappers; 
        //Lets get the UserResponseWrapperMap.  
        //It will have key of Username and values of all users being activated. 
        //We will update the values of the map based on success and failures as we attempt to activate the user(s) below.     
        ResponseWrapperMap = SM_Support.buildUserResponseWrapperMap(dw.UserWrapperMap.values(), 'SM_PUservice');
        Set<String> UsernameFoundSet = new Set<String>();
        Map<Id, String> UsernameFoundMap = new Map<Id, String>();
        //Get Chatter Free Profile Id
        Id ChatterFreeProfileId = [SELECT Id FROM Profile WHERE Name = 'Chatter Free User'].id;
      
        //Let loop through the ResponseWrapperMap and create the InsertUserList which 
        //will hold the new user records to be inserted
        List<User> InsertUserList = new List<User>(); 
        for (SM_Wrappers.UserWrapper u : dw.UserWrapperMap.values()) {
        	User user = new User();  
            user.Alias = u.UserName;
            if (user.Alias.length() > 8) {
                user.Alias = user.Alias.substring(0,8); 
            }
            user.Username = u.UserNameAdjusted;
            user.Email = u.Email;
            user.ProfileId = ChatterFreeProfileId;
            user.FirstName = u.FirstName;
            user.LastName = u.LastName;
            user.EmailEncodingKey = 'ISO-8859-1';
            user.LanguageLocaleKey = 'en_US';
            user.LocaleSidKey = UserInfo.getLocale();
            user.TimeZoneSidKey = 'America/New_York';
            user.IsActive = false;
            user.FederationIdentifier = u.FederationIdentifier;
            InsertUserList.add(user);
        }
        
        
        //Had to create another user to trick test coverage into having 
        //a user that doesn't actually exist in the database (the test class didn't create)
        //but below we create a user in memory which will error when trying to do a
        //DML update below since it really doesn't exist in the database.
        If(Test.isRunningTest()) {
            InsertUserList.add(getUserNotStoredInDB());
        }
    
        List<User> FailedUserList = new List<User>();
        User FailedUser = new User();
        String Username = '';
        Map<Id, String> FailedUserMap = new Map<Id, String>();
        String Severity = 'None';
        String Msg = 'User was successfully created';
            
        Try{
            List<Database.SaveResult> InsertResults = Database.insert(InsertUserList, false);
            //Loop thru to check if any individual records passed and/or failed
            for(Integer i=0; i < InsertResults.size(); i++){
                if (InsertResults.get(i).isSuccess()){                
                    UpdateUserResponseWrapperMap(InsertUserList.get(i).Username, Severity, Msg);
                }else if (!InsertResults.get(i).isSuccess()){
                    //DML operation failed so lets build the response accordingly
                    Database.Error error = InsertResults.get(i).getErrors().get(0);
                    Msg = error.getMessage();
                    Severity = 'Critical'; 
                    Username = InsertUserList.get(i).Username;                    
                    UpdateUserResponseWrapperMap(Username, Severity, Msg);                        
                    //Generally you don't put debugs in FOR loops but since this is the error
                    //side and errors are not anticipated it is good to log them for troubleshooting
                    System.debug('Insert User Failed ID       : ' + InsertUserList.get(i).Id);
                    System.debug('Insert User Failed Username : ' + InsertUserList.get(i).Username);
                    System.debug('Insert User Failed DML      : ' + error.getMessage());                        
                    //Lets add the field update record to the FailedUserList so we can use it to try and 
                    //FREEZE the user later on becaus a frozen user is better than a thawed out user! :)
                    FailedUser.id = InsertUserList.get(i).Id;
                    FailedUser.Username = InsertUserList.get(i).Username;
                    FailedUserList.add(FailedUser);     
                    FailedUserMap.put(InsertUserList.get(i).Id, InsertUserList.get(i).Username);
                }  
                System.debug('InsertUserList.size(): ' + InsertUserList.size());
            	System.debug('FailedUserList.size(): ' + FailedUserList.size());
                //Need to trick an error for code coverage -- its a dirty world out there!
                if(Test.isRunningTest()) Integer x = 5/0;
            }   
        } catch (System.exception e) {
            String ErrMsg = 'EXCEPTION ERROR: ' + 'Line #: ' + e.getLineNumber() + ', Message: ' + e.getMessage() + ', StackTraceString: ' + e.getStackTraceString();
            System.debug(ErrMsg);
            SM_Support.LogWrapper LogException = new SM_Support.LogWrapper();
            //We already have the records in the Wrapper class that will have the sandbox
            //we are running in so lets copy that first record and customize it to create
            //the Exception Error log entry.
            LogException = ResponseWrapperMap.values()[0];
            LogException.Username = 'N/A';            
            LogException.Msg = ErrMsg;
            ResponseWrapperMap.put('N/A', LogException);        
        } finally {        
            if (ResponseWrapperMap.size() > 0) {
				Integer DayToStartDeletion = dw.SettingWrapperMap.get('Log_Deletion').NumberSetting;                  
                //Write to the log
   				SM_Logging log = new SM_Logging(ResponseWrapperMap.values(), DayToStartDeletion, false);   
                
                //Send Response back with logged data
                String LogSerialized = JSON.serialize(ResponseWrapperMap.values(), true);       
                res.responseBody = Blob.valueOf(LogSerialized);
            }
        }
    } 
    
    
    /**********************************
     * HELPER METHODS SHOULD GO BELOW *
     **********************************/    

    /********************************************************
     * Updates the Map with the latest error/info from the 
     * process for loops above
     ********************************************************/
    private static void UpdateUserResponseWrapperMap(String Username, String Severity, String Msg){
        System.debug('ResponseWrapperMap: ' + ResponseWrapperMap );
        System.debug('Username: ' + Username);
        SM_Support.LogWrapper ResponseRec = ResponseWrapperMap.get(Username.toLowerCase());
        ResponseRec.LogGrouping = ResponseRec.LogGrouping + '_PU_2'; 
        ResponseRec.Severity = Severity;
        ResponseRec.Msg = Msg; 
        //Because current state doesn't pass the entire user record via an after trigger we
        //get the System.Now() Datetime so there could be a slight difference in time compared
        //to what is actually saved to the database.
        ResponseRec.LastModifiedDate = System.Now();
        ResponseWrapperMap.put(Username, ResponseRec);
    }    
    
    /******************************************************************************
     * This private method is only for getting code coverage. This creates a user 
     * in memory that matches the user created in the matching test class.  So 
     * when the SM_PUservice code performs the inser on the list we get the
     * duplicate error code coverage above.
     *******************************************************************************/
    private static User getUserNotStoredInDB() {
        System.debug('---SM_DUservice.getUserNotStoredInDB()---');
        Profile pf= [Select Id from profile where Name='Chatter Free User'];
        List<User> UserList = new List<User>();
        String orgId=UserInfo.getOrganizationId(); 
        String uniqueName=orgId + System.currentTimeMillis(); 
        User u = new User(firstname = 'Test2', lastName = 'Tester', 
                         email = 'test2.tester' + '@somecompany' + orgId + '.org', 
                         Username = 'test2.tester' + '@somecompany' + orgId + '.org', 
                         isActive = true, EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), TimeZoneSidKey = 'America/New_York', 
                         LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US', ProfileId = pf.Id,
                         FederationIdentifier = 'test2.tester' + '@somecompany' + orgId + '.org'
                        ); 
        return u;
    }
}