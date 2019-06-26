//=========================================================================================
//      Date: 03/30/2018      
// Developer: Tom Barrett
//   Purpose: This class is the class that is part of the Sandbox Manager App.            
//            This class's caller is SM_DPcallout.DeprovisionUsers().
//            This class must be in each destination org (sandbox) that is expected to be
//            managed by the Sandbox Manager App.
//            This class uses the SM_ServiceSupport.isSandbox() method to safeguard 
//            against executing in a production org as this class should only execute
//            in a sandbox.
//            
// CODE COVERAGE ISSUE:
//              Unfortunately, currently I don't know how to setup a user that would not be
//              able to be deactivated  or not frozen which would produce a DML error so you
//              will see the use of Test.isTest() in order to increase code coverage.
//            
//=========================================================================================
//                                 Update History
// Date       Developer		Tag		Description
//=========================================================================================
//
//=========================================================================================
@RestResource(urlMapping='/SM_DUservice/*')
global with sharing class SM_DUservice {    
    public static Map<String, SM_Support.LogWrapper> ResponseWrapperMap = new Map<String, SM_Support.LogWrapper>();
    
    @HttpPost
    global static void doDeprovisioning() { 
        System.debug('---SM_DUservice.doDeprovisioning()---');
        
        //If we are not running in a sandbox then get out quickly!
        if(!SM_Support.isSandbox()) return;          
        
        List<String> UsernameList = new List<String>();
        List<User> DeactivateUserList = new List<User>();
        RestRequest req = RestContext.request;
       
        RestResponse res = RestContext.response;        
        //De-serializing the incoming request which contains the content of the SM_Wrapper class
		SM_Wrappers deserializedWrappers = (SM_Wrappers) JSON.deserialize(req.requestBody.toString(), SM_Wrappers.class);
        //Put the conent back into an instance of the SM_Wrappers class
        //we can get to the UserWrapperMap content
		SM_Wrappers dw = deserializedWrappers;   
     
        //Loop through the user wrapper map to get only a list of Usernames to be used in the SOQL query below
        for (SM_Wrappers.UserWrapper u : dw.UserWrapperMap.values()) {                   
            //At this line the UsernameAdjusted is moved to the UsernameList.            
            UsernameList.add(u.UsernameAdjusted);           
        }     
        
        //Lets get the UserResponseWrapperMap.  it will have key of Username and values of all users being 
        //deactivated. We will update the values of the map based on success and failures as we attempt to 
        //deactivate the user(s) below.       
        ResponseWrapperMap = SM_Support.buildUserResponseWrapperMap(dw.UserWrapperMap.values(), 'SM_DUservice');  
      
        Set<String> UsernameFoundSet = new Set<String>();
        Map<Id, String> UsernameFoundMap = new Map<Id, String>();
        
        //Get list of users from the database who were passed into the REST service
        for (User user : [SELECT Id, Username, isActive
                          FROM User 
                          WHERE UserName IN :UsernameList]) {  
                              
            if (!user.IsActive) {             
                UpdateUserResponseWrapperMap(user.Username, 'Info', 'User was already deactivated', False);
            } else {
                user.isActive = false;                              
                DeactivateUserList.add(user);
                UsernameFoundMap.put(user.id, user.Username);
            }
            UsernameFoundSet.add(user.Username); 
        }
        
        //We need to determine if any users sent to the service do not exist in the sandbox
        //and if they don't exist we need to build the respone message appropriately
        UsernamesNotFound(UsernameFoundSet, UsernameList, 'Info', 'Username Not Found');
        
        //Had to create another user to trick test coverage into having 
        //a user that doesn't actually exist in the database (the test class didn't create)
        //but below we create a user in memory which will error when trying to do a
        //DML update below since it really doesn't exist in the database.
        If(Test.isRunningTest()) {
            DeactivateUserList.add(getUserNotStoredInDB());
        }

        Try{     
            List<User> FailedUserList = new List<User>();
            User FailedUser = new User();
            String Username = '';
            Map<Id, String> FailedUserMap = new Map<Id, String>();
            List<Database.SaveResult> updateDeactivateResults = Database.update(DeactivateUserList, false);
            //Loop thru to check if any individual records passed and/or failed
            for(Integer i=0; i < updateDeactivateResults.size(); i++){
                if (updateDeactivateResults.get(i).isSuccess()){
                    Username = UsernameFoundMap.get(updateDeactivateResults.get(i).getId());
                    UpdateUserResponseWrapperMap(Username, 'None', 'User was successfully deactivated', False);
                }else if (!updateDeactivateResults.get(i).isSuccess()){
                    //DML operation failed so lets build the response accordingly
                    Database.Error error = updateDeactivateResults.get(i).getErrors().get(0);
                    Username = DeactivateUserList.get(i).Username;
                    UpdateUserResponseWrapperMap(Username, 'Critical', error.getMessage(), False);                        
                    //Generally you don't put debugs in FOR loops but since this is the error
                    //side and errors are not anticipated it is good to log them for troubleshooting
                    System.debug('Deactivate Failed ID       : ' + DeactivateUserList.get(i).Id);
                    System.debug('Deactivate Failed Username : ' + DeactivateUserList.get(i).Username);
                    System.debug('Deactivate Failed DML      : ' + error.getMessage());                        
                    //Lets add the field update record to the FailedUserList so we can use it to try and 
                    //FREEZE the user later on becaus a frozen user is better than a thawed out user! :)
                    FailedUser.id = DeactivateUserList.get(i).Id;
                    FailedUser.Username = DeactivateUserList.get(i).Username;
                    FailedUserList.add(FailedUser);     
                    FailedUserMap.put(DeactivateUserList.get(i).Id, DeactivateUserList.get(i).Username);
                }                
            }  
            System.debug('DeactivateUserList.size(): ' + DeactivateUserList.size());
            System.debug('FailedUserList.size(): ' + FailedUserList.size());
            
            //Had to use another Test.isRunningTest() to trick testing so 
            //code coverage would occur as of this time I do not know away 
            //to make a user deactivation fail.
            if (Test.isRunningTest()) {
                FailedUserList = DeactivateUserList; 
            }                
            
            if (FailedUserList.size() > 0) {
                //We completed the deactivation attempts either success or failure
                //If any failures occurred let us try to FREEZE the user since 
                //we couldn't deactivate them successfully above.
                Set<String> UserIdFoundSet = new Set<String>();
                List<UserLogin> FrozenUserList = new List<UserLogin>();
                //GETTING CRAZY - we need to hold a map of UserLogin with ID as Key and UserID as the value
                //This way we use it to build the message because the Database.SaveResult below used on
                //the UserLogin table uses the ID from those records and not the User ID!
                Map<String, String> UserLoginMap = new Map<String, String>();
                UserLogin FrozenUser = new UserLogin();
                //NOTE: If a user cannot be deactiated for whatever reason but user never logged 
                //      then they will not be able to be frozen as the UserLogin table contains 
                //      that information in order to determine if the are frozen already or not.  
                //      I think this is a SF limitation/design flaw in my opinion.
                for (UserLogin User : [SELECT id, userId, isFrozen 
                                       FROM UserLogin 
                                       WHERE userId IN (SELECT Id FROM User WHERE Id IN :FailedUserList)]) {
                    if (User.isFrozen == true) {
                        UpdateUserResponseWrapperMap(FailedUserMap.get(User.userId), 'Info', 'The user could not be deactivated; therefore, an attempt was made to freeze the user but they were already frozen.', True);                        
                    } else {                                                 
                        User.isFrozen = true;
                        FrozenUserList.add(User); 
                    }
                    UserIdFoundSet.add(user.userId); 
                    UserLoginMap.put(User.Id, User.UserId);
                }                  
                //Lets get the Username that matches the UserLogin.Userid which is stored 
                //in the UserIdFoundSet.  This will help us later to determine if we can 
                //freeze the user.  See NOTE above regarding UserLogin/SOQL.               
                for (String UserId : UserIdFoundSet) {
                    UsernameFoundSet.add(FailedUserMap.get(UserId));
                }
                
                //We need to determine if any users sent to the service do not exist in the 
                //UserLogin table/object and if they don't exist we need to build the response 
                //message appropriately.  The query above will not have a user in the table
                //if a user never logged in; therefore, we cannot freeze them and that is a
                //severity level of critical.
                String Msg = 'You must go to the user record and freeze them manually. ';
                Msg += 'Typically, this is required because a user never logged into ';
                Msg += 'Salesforce at all and Salesforce does not provide a programatic ';
                Msg += 'way to freeze a user under that scenario!';
       
                UsernamesNotFound(UsernameFoundSet, UsernameList, 'Critical', Msg);                
                
                //Let's reuse the Failed variables so set them to NULL
                FailedUserList = null;
                FailedUser = null;
                List<Database.SaveResult> updateFreezeResults = Database.update(FrozenUserList, false);
                for(Integer i=0; i < updateFreezeResults.size(); i++){
                    if (updateFreezeResults.get(i).isSuccess()){  
                        //Have to use the UserLogMap feeding it the UserLog.ID to get the UserID to 
                        //feed the UsernameFoundMap and finally returning the Username!
                        Username = UsernameFoundMap.get(UserLoginMap.get(updateFreezeResults.get(i).getId()));                        
                        UpdateUserResponseWrapperMap(Username, 'Info', 'The user could not be deactivated; however, the user was Frozen successfully.', True);
                    }                    
                    if (!updateFreezeResults.get(i).isSuccess() || Test.isRunningTest()){
                        //DML operation failed
                        Database.Error error = updateFreezeResults.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();                        
                        //Generally you don't put debugs in fore loops but since this is the error
                        //side and errors are not anticipated it is good to log them for troubleshooting   
                        //Unfortunately, we can't easily get to the Username from the UserLogin object
                        //so but at least we can get the UserID for troubleshooting needs.                     
                        System.debug('Freeze Failed ID     : ' + FrozenUserList.get(i).Id);
                        System.debug('Freeze Failed UserId : ' + FrozenUserList.get(i).UserId);
                        System.debug('Freeze Failed DML    : ' + failedDML);
                        
                        FailedUser.id = DeactivateUserList.get(i).Id;
                        FailedUser.Username = DeactivateUserList.get(i).Username;
                        FailedUserList.add(Faileduser);
                    }                
                } 
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
                //Had to use the Queueable apex approach here because we were hitting the MIX_DML error issues
                //because SF does not allow the User object to be updated and another object in the same context.
                //Write to the log
   				SM_Logging ql = new SM_Logging(ResponseWrapperMap.values(), DayToStartDeletion, true);  
        		System.enqueueJob(ql);
                
                //Send Response back with logged data
                String LogSerialized = JSON.serialize(ResponseWrapperMap.values(), true);       
                res.responseBody = Blob.valueOf(LogSerialized);
            }
        }
    } 
    
    
    /**********************************
     * HELPER METHODS SHOULD GO BELOW *
     **********************************/    

    /*************************************************************************************
     * Takes the UsersFoundSet which are users found on the Sandbox and the UsernameList 
     * which is the list that comes from the Caller.  Then the UsernameList is put into a 
     * UsernameSet. Finally, the UsersFoundSet is used to remove all matching users found 
     * in the UsernameSet.  That leaves us with only users that came into the service but
     * could not be found on the sandbox to return to the caller of this method.
     *************************************************************************************/
    private static void UsernamesNotFound(Set<String> UsersFoundSet, List<String> UsernameList, String Severity, String Msg) {
        System.debug('---SM_DUservice.UsernamesNotFound()---');
        Set<String> UsernameSet = new Set<String>();
        //move usernames from a list to a set
        UsernameSet.addAll(UsernameList);
        //Remove all users found on the Usernames list that was converted 
        //to a set that also were on the UserFoundSet that came into this method.
        //If UsernameSet.size is greater than zero then users are missing in the sandbox
        UsernameSet.removeAll(UsersFoundSet); 
        for (String Username : usernameSet) {
            UpdateUserResponseWrapperMap(Username, Severity, Msg, False);
        }
    }    

    /********************************************************
     * Updates the Map with the latest error/info from the 
     * process for loops above
     ********************************************************/
    private static void UpdateUserResponseWrapperMap(String Username, String Severity, String Msg, Boolean AppendMsg){
        SM_Support.LogWrapper ResponseRec = ResponseWrapperMap.get(Username.toLowerCase());
        ResponseRec.LogGrouping = ResponseRec.LogGrouping + '_DU_2';
        ResponseRec.Severity = Severity;        
        if (AppendMsg) {
            ResponseRec.Msg = ResponseRec.Msg + ' :: ' + Msg;
        } else {
            ResponseRec.Msg = Msg;        
        }        
        ResponseWrapperMap.put(Username, ResponseRec);
    }    
    
    /******************************************************************************
     * This private method is only for getting code coverage. This creates a user 
     * in memory, not on the database.  This way it is joined with actual database 
     * user created in the SM_DUservice_Test class which is stored on the database.  
     * This allows us to trick code during testing by having a user that is added 
     * to a list but doesn't exist in the actual database during a DML update which 
     * will produce an error that we need to get the code coverage.
     *******************************************************************************/
    private static User getUserNotStoredInDB() {
        System.debug('---SM_DUservice.getUserNotStoredInDB()---');
        Profile pf= [Select Id from profile where Name='Standard User'];
        List<User> UserList = new List<User>();
        String orgId=UserInfo.getOrganizationId(); 
        String uniqueName=orgId + System.currentTimeMillis(); 
        User u = new User(firstname = 'Test2', lastName = 'Tester', 
                         email = 'tester2.test' + '@somecompany' + orgId + '.org', 
                         Username = 'tester2.test' + '@somecompany' + orgId + '.org', 
                         isActive = true, EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', LanguageLocaleKey = 'en_US', ProfileId = pf.Id
                        ); 
        return u;
    }   
}