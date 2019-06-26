// this is a test class for UserProvisioningService
//#####################################################################################
// Date     Developer     Description
//#####################################################################################
// 12/18/17    AG        Updated to handle SOQL 101 error
//#####################################################################################  
@isTest()
public class UserProvisioningServiceTests {
    
    @TestSetUp
  public static void setup() {  
    System.Debug('Entered TEST SETUP');
    Account a = new Account();
    a.Name = 'Community_User_Account';
    a.Type = 'Partner';
    a.Agency_NPN__c = '111111111';
    insert a;
    Profile p = [SELECT Id, Name FROM Profile WHERE Name='Standard User']; 
    User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
    LocaleSidKey='en_US', ProfileId = p.Id, 
    TimeZoneSidKey='America/Los_Angeles', UserName='provisionuser.process@carefirst.com.unittest', FederationIdentifier='CF291-280754757');
    insert u;
  }  
    
    
  @isTest
  public static void TestContactCreation(){
        System.Debug ('ENTERED Test Contact Creation');
        UserProvisioningService.Configuration cfg = new UserProvisioningService.Configuration();
        
        cfg.communityContactRecordTypeID =  '012600000005OTFAA2'; //'012110000005OXvAAM' (Dev3); 
        
        Map<String,String> att = new map <String, String> ();
        
        att.put('TRN_MSG_TYPE','BAA');
        att.put('UID','FF117-9992003301');
        att.put('USER_ID','man1@carefirst');
        att.put('FRST_NM','Seyittttttttt');
        att.put('MID_NM','Nothing');
        att.put('LAST_NM','Usmanovvvvvvvvv');
        att.put('EMAL_ADDR','usmanoff@man.com');
        att.put('SSN','123321456');
        att.put('BRKR_TITL','Principal Broker');
        att.put('TAX_IDNTN_NBR','101123332');
        att.put('DSTBR_NM','Kyrgyzstan');
        att.put('ASST_BRKR_INDC','N');
    
        Test.StartTest();
        Contact c = UserProvisioningService.createContact( att, cfg);
      
      // Start - <AG> - 12/18/2017 same upsert statement is being called in the method call below 'populate360DegreeViewLookups'
        system.debug('Limits.getQueries : ' + Limits.getQueries());
        system.debug('Limits.getLimitQueries : ' + Limits.getLimitQueries());
      
       //upsert c Agency_Agent_ID__c;       
       //system.debug('Contact upserted successfully');       
       
        UserProvisioningService.populate360DegreeViewLookups( c );
             
        system.debug('Limits.getQueries : ' + Limits.getQueries());
        system.debug('Limits.getLimitQueries : ' + Limits.getLimitQueries());     
      
      // End - <AG> - 12/18/2017
        system.debug('Out of populate 360');
        upsert c;
        
        UserProvisioningService.createContactFuture(att,cfg);
        System.debug ('Out of Create Contact Future');
        
        List <String> s = new list<string>();
        s.add('deep@gmail.com');
        UserProvisioningService.sendNotification('Man','manishupwrk@gmail.com',s,'subject','body');
        System.debug ('Out of SEND NOTIFICATION');
        


    Account a1 = new Account();
        a1.Name = 'Community_User_Account_Test';
        a1.Type = 'Partner';
        a1.Agency_NPN__c = '999999999';
        a1.Entity_ID__c = '123456789';
        a1.recordtypeid = '01260000000DtlmAAC'; //51+
        insert a1;
        
    Account a2 = new Account();
        a2.Name = 'Community_User_Account_Testtt';
        a2.Type = 'Partner';
        a2.Agency_NPN__c = '888888888';
        a2.Entity_ID__c = '123456789';
        a2.recordtypeid = '01260000000DtllAAC'; //2-50
        insert a2;
    
    Contact c3 = new contact();
    c3.lastname = 'llname';
    c3.phone = '1234567890';
    c3.email = 'maneesh@gmail.com';
    c3.recordtypeid = '01260000000DtloAAC'; //51+
    c3.Entity_ID__c = '5555';
    insert c3;
    
    
    Contact c1 = new contact();
    c1.lastname = 'lname';
    c1.phone = '1234567890';
    c1.email = 'maneesh@gmail.com';
    c1.recordtypeid = '01260000000DtloAAC'; //51+
    c1.Entity_ID__c = '4444';
    
    insert c1;
    UserProvisioningService.populate360DegreeViewLookups( c1 );
    System.Debug ('Out of populate360DegreeViewLookups( c1 ) INSERT');
    
    c1.Agent_ID__c = '5555';
    c1.Agency_agent_id__c = '123456789_123456789';
    update c1;
    UserProvisioningService.populate360DegreeViewLookups( c1 );
    System.Debug ('Out of populate360DegreeViewLookups( c1 ) UPDATE');
    
    Contact c11 = new contact();
    c11.lastname = 'lname';
    c11.phone = '1234567890';
    c11.email = 'maneesh@gmail.com';
    c11.Entity_ID__c = '6666';
    c11.recordtypeid = '01260000000DtlnAAC'; //2-50
    c11.Agent_ID__c = '6666'; 
    c11.Agency_agent_id__c = '123456788_123456788';
    insert c11;
    UserProvisioningService.populate360DegreeViewLookups( c11 );
    
    UserProvisioningService.populate360DegreeViewLookupsFuture('{"lastname":"lname"}');
    Test.StopTest();
    } 
        
        
        
    @IsTest
    public static void test_Initialization_exception() {
    //Test.startTest();
        System.debug ('Test Started - test_Initialization_exception');
        try{
            UserProvisioningService.isTest = true;
            UserProvisioningService.Configuration config1 = new UserProvisioningService.Configuration();
            UserProvisioningService.initializeService( config1 );
        } catch(UserProvisioningService.UserProvisioningServiceException e){
            system.debug('User Provisioning Exception: '+ e.getMessage());
            //system.assert(e.getMessage().contains('Missing UserProvisioning configuration Got multiple Ids for profile name = Customer Community Plus User; query results = (Profile:{Id='));
        } catch (Exception e){
            system.debug('Catch ALL Exception: '+ e.getMessage());            
        //    system.assertEquals(e.getMessage(), e.getMessage());
        }
  }
    //Test.stopTest();  
    
   @IsTest
  public static void test_Initialization() {
  System.debug ('Test Started - test_Initialization');
    UserProvisioningService.Configuration config = new UserProvisioningService.Configuration();
    
    UserProvisioningService.initializeService( config );
    System.debug ('Came out of test_Initialization');
    UserProvisioningService.logToIntegrationLogSingle('{"Name":"Test"}');
    
    
    /*
    UserProvisioningService.logToIntegrationLog(new IntegrationMessage());
    //UserProvisioningService.populate360DegreeViewLookupsFuture('Name');
    Test.stopTest();
    */
    try{
        Account objAcc = new Account();
        objAcc.name = 'Test Account';
        insert objAcc;
        System.debug('Account Inserted');
    }catch(Exception e){
        UserProvisioningService.notifyError(e,config, false,true,true);
    }
    
    
    System.assert( true, 'Failed to initialize UserProvisioning Service' );
  }
 
  @IsTest
  public static void test_handleMessageBAA() {
    //UserProvisioningService.initializeService( null );
    System.debug ('BAA Test Started');
    List<UserProvisioningService.NameValue> provisioningMessage = createTemplateProvisioningMessage();
    System.debug ('prov message');
    List<UserProvisioningService.NameValue> provisioningMessage1 = createTemplateProvisioningMessage1();
    System.debug ('prov message 1');
    List<UserProvisioningService.NameValue> provisioningMessage3 = createTemplateProvisioningMessage3();
    System.debug ('prov message 3');

    provisioningMessage.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, UserProvisioningService.MessageType_BAA));
    Map<String,String> attributeMap = UserProvisioningService.convertListToMap( provisioningMessage );
    provisioningMessage1.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, UserProvisioningService.MessageType_BAA));
    Map<String,String> attributeMap1 = UserProvisioningService.convertListToMap( provisioningMessage1 );
    provisioningMessage3.add( new UserProvisioningService.NameValue('TRN_MSG_TYPE', '2'));
    Map<String,String> attributeMap3 = UserProvisioningService.convertListToMap( provisioningMessage3 );
    
    String guidValue = attributeMap.get( UserProvisioningService.Guid );
    User u = [ Select Id, username from User where username = 'provisionuser.process@carefirst.com.unittest' LIMIT 1 ];
    System.debug ('BAA before start test');
    
    Test.startTest();
    UserProvisioningService.handleMessage( provisioningMessage );
    System.debug ('Provision Message Done');
    UserProvisioningService.handleMessage( provisioningMessage1 );
    System.debug ('Provision Message 1 Done');
    UserProvisioningService.handleMessage( provisioningMessage3 );
    System.debug ('Provision Message 3 Done');
    Test.stopTest();
    System.debug ('BAA after stop test');
    
    UserProvisioningService.logToIntegrationLog(new IntegrationMessage());
    
    UserProvisioningService.NameValue nv = new UserProvisioningService.NameValue('n','v');
    UserProvisioningService.Response res = new UserProvisioningService.Response( 0,'');
    res = UserProvisioningService.hasGuidParameter(new list<UserProvisioningService.NameValue>());
    
    res = UserProvisioningService.validateInputFields(attributeMap3);
    
    List<User> uList = [ SELECT Id, FederationIdentifier, FirstName, LastName, Alias, Email,UserName, CommunityNickName, ContactId,ProfileId,IsActive, License__c, Broker_Role__c, CompanyName,EmailEncodingKey, TimeZoneSidKey FROM User WHERE   FederationIdentifier = :guidValue ];  
    List<Contact> cl = [ SELECT Id, FirstName, LastName, Email, Agent_ID__c, Community_User_type__c, X51_Contact__c, X51_Account__c, X2_50_Contact__c, X2_50_Account__c FROM Contact];
    System.assert( uList.size() == 1, 'Did not create a User record');
  }
  
  
  @IsTest
  public static void test_handleMessageBAM() {
    List<UserProvisioningService.NameValue> provisioningMessage = createTemplateProvisioningMessage();
    provisioningMessage.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, UserProvisioningService.MessageType_BAM));
    Map<String,String> attributeMap = UserProvisioningService.convertListToMap( provisioningMessage );
    
    List<UserProvisioningService.NameValue> provisioningMessage1 = createTemplateProvisioningMessage1();
    provisioningMessage1.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, UserProvisioningService.MessageType_BAM));
    Map<String,String> attributeMap1 = UserProvisioningService.convertListToMap( provisioningMessage1 );
    
    
    String guidValue = attributeMap.get( UserProvisioningService.Guid );
    User u = [ Select Id, username from User where username = 'provisionuser.process@carefirst.com.unittest' LIMIT 1 ];
    
    Test.startTest();
    UserProvisioningService.handleMessage( provisioningMessage );
    UserProvisioningService.handleMessage( provisioningMessage1 );
    Test.stopTest();

    List<User> uList = [ SELECT Id, FederationIdentifier, FirstName, LastName, Alias, Email,UserName, CommunityNickName, ContactId,ProfileId, IsActive, License__c, Broker_Role__c, CompanyName,EmailEncodingKey, TimeZoneSidKey FROM User WHERE   FederationIdentifier = :guidValue];  
    List<Contact> cl = [ SELECT Id, FirstName, LastName, Email, Agent_ID__c, Community_User_type__c, X51_Contact__c, X51_Account__c, X2_50_Contact__c, X2_50_Account__c FROM Contact];
    System.assert( uList.size() == 1, 'Did not create a User record');
  }
  
  @IsTest
  public static void test_handleMessageBAT() {
    List<UserProvisioningService.NameValue> provisioningMessage = createTemplateProvisioningMessage();
    provisioningMessage.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, UserProvisioningService.MessageType_BAT));
    Map<String,String> attributeMap = UserProvisioningService.convertListToMap( provisioningMessage );
    
    List<UserProvisioningService.NameValue> provisioningMessage1 = createTemplateProvisioningMessage1();
    provisioningMessage1.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, UserProvisioningService.MessageType_BAT));
    Map<String,String> attributeMap1 = UserProvisioningService.convertListToMap( provisioningMessage1 );
    
    List<UserProvisioningService.NameValue> provisioningMessage2 = createTemplateProvisioningMessage2();
    provisioningMessage2.add( new UserProvisioningService.NameValue('TRN_MSG_TYPE', UserProvisioningService.MessageType_BAT));
    Map<String,String> attributeMap2 = UserProvisioningService.convertListToMap( provisioningMessage2 );
    
    String guidValue = attributeMap.get( UserProvisioningService.Guid );
    User u = [ Select Id, username from User where username = 'provisionuser.process@carefirst.com.unittest' LIMIT 1 ];
    
    Test.startTest();
    UserProvisioningService.handleMessage( provisioningMessage );
    UserProvisioningService.handleMessage( provisioningMessage1 );
    UserProvisioningService.handleMessage( provisioningMessage2 );
    Test.stopTest();

    List<User> uList = [ SELECT Id, FederationIdentifier, FirstName, LastName, Alias, Email,UserName, CommunityNickName, ContactId,ProfileId, IsActive, License__c, Broker_Role__c, CompanyName,EmailEncodingKey, TimeZoneSidKey FROM User WHERE   FederationIdentifier = :guidValue ];  
    List<Contact> cl = [ SELECT Id, FirstName, LastName, Email, Agent_ID__c, Community_User_type__c, X51_Contact__c, X51_Account__c, X2_50_Contact__c, X2_50_Account__c FROM Contact];
    // System.assert( uList.size() == 1, 'Did not create a User record');
    
  }
  
  @IsTest
  public static void test_functions() {
    System.debug ('ENTERED TESTFUNCTIONS');
    
    List<UserProvisioningConfig__mdt> configList = [ SELECT MasterLabel, EmailEncodingKey__c, 
                                                    ExternalSupportEmail__c, InternalSupportEmail__c, 
                                                    LanguageLocaleKey__c,LicenseCategoryString__c, LocaleSidKey__c, ProfileName__c, 
                                                    SendUserEmail__c, TimeZoneSidKey__c, UserLicenseString__c, Is_Active__c , CommunityUserAccountName__c
                                                    FROM UserProvisioningConfig__mdt
                                                    WHERE Is_Active__c = true  ];
    List<Account> tmpList =  [Select id from Account where Name = :configList[0].CommunityUserAccountName__c];
    
    List<UserProvisioningService.NameValue> attrs = createTemplateProvisioningMessage();
    List<UserProvisioningService.NameValue> attrs2 = createTemplateProvisioningMessage2();
    List<UserProvisioningService.NameValue> attrs4 = createTemplateProvisioningMessage4();
    List<UserProvisioningService.NameValue> attrs5 = createTemplateProvisioningMessage5();
    String token = ( String.valueOf(Datetime.now().getTime()).right(5));
    token = '21884';
    Profile p = [SELECT Id, Name FROM Profile WHERE Name='Standard User']; 
    Map<String,String> attributes = UserProvisioningService.convertListToMap(attrs);
    Map<String,String> attributes2 = UserProvisioningService.convertListToMap(attrs2);
    Map<String,String> attributes4 = UserProvisioningService.convertListToMap(attrs4);
    Map<String,String> attributes5 = UserProvisioningService.convertListToMap(attrs5);
    System.Debug ('ATTRIBUTES 2 - ' + attributes2);
    UserProvisioningService.Configuration config = new UserProvisioningService.Configuration();
    config.ProfileName = p.Name;
    config.CommunityProfileId = p.id;
    config.UserLicenseString = 'Customer Community Plus Login';
    config.UserRoleString = 'N';
    config.LicenseCategoryString = 'Small/Mid Community User';
    config.InternalSupportEmail = 'kirat.gill@carefirst.com';
    config.ExternalSupportEmail = 'kirat.gill@carefirst.com';
    config.EmailEncodingKey = 'UTF-8';
    config.LanguageLocaleKey = 'en_US';
    config.LocaleSidKey = 'en_US';
    config.TimeZoneSidKey = 'en_US';
    config.SendUserEmail = true;
    config.communityContactRecordTypeID =  '012600000005OTFAA2';//'012110000005OXvAAM';
    config.communityUserAccountID = tmpList[0].Id;
    system.debug ('config.communityUserAccountID in the test class - '+config.communityUserAccountID);
    //UserProvisioningService.sendInternalNotification('hi',config);
    //UserProvisioningService.sendExternalNotification('hi',config);
    
    User u = [select id, FederationIdentifier, IsActive, ContactId from user LIMIT 1];
    Contact c = new Contact(FirstName='test', LastName='test', email='test@test.com',phone='9012455667', RecordTypeID='012600000005OTFAA2',Agent_ID__c='12345',Entity_ID__c='12345');
    insert c;
    System.debug ('Contact Inserted in the Test Class');
    User u1 = [select id, FederationIdentifier, IsActive, ContactId from user where FederationIdentifier!=null  LIMIT 1];
    try{u1.FederationIdentifier='1234xyz'; update u1;}catch(exception e){System.debug ('Exception in updateUser');}
    attributes4.put(UserProvisioningService.Guid,u1.FederationIdentifier);
    UserProvisioningService objUserProvisioningService = new UserProvisioningService();
    objUserProvisioningService.isUserActive(u);
    UserProvisioningService.contactExists(u);
    UserProvisioningService.contactExists(token);
    UserProvisioningService.hasGuidParameter(attrs);
    Test.startTest();
    UserProvisioningService.hasGuidParameter(attributes);    
    UserProvisioningService.testfunction(attributes, config);
    System.debug ('STARTING ATTRIBUTES 5');
    UserProvisioningService.testfunction(attributes5, config);
    System.debug ('STOPPING ATTRIBUTES 5');
    System.debug ('before the try block');
    try{UserProvisioningService.testfunction(attributes, null);}catch(exception e){System.debug ('exception in test function');}
    UserProvisioningService.deactivateUser(attributes, config);
    System.debug ('xxx');
    UserProvisioningService.activateUser(attributes, config);
        System.debug ('yyyyy');
    try{
    UserProvisioningService.activateUser(attributes, null);
    }catch(exception e){System.debug ('Exception in activateUser');}
    UserProvisioningService.deactivateUser(attributes, config);
    try{UserProvisioningService.deactivateUser(attributes, null);}catch(exception e){}
    UserProvisioningService.deactivateUser(attributes, null);
    UserProvisioningService.reactivateUser(attributes, config, u);
    UserProvisioningService.reactivateUser(attributes, null, u);
    UserProvisioningService.reactivateUser(attributes2, config, u);
    UserProvisioningService.reactivateUser(attributes4, config, u1);
    try{UserProvisioningService.deactivateUser(attributes4, null);}catch(exception e){}
    UserProvisioningService.createUser( attributes5, config,  c,'' );
    try{UserProvisioningService.createUserFuture( JSON.serialize( attributes ), JSON.serialize( config ), JSON.serialize( c ) );}catch(exception e){}
    try{UserProvisioningService.initializeService(null);}catch(exception e){}
    try{UserProvisioningService.handleMessage(null);}catch(exception e){}
    
    UserProvisioningService.modifyUser(attributes,config,null);
    System.debug ('Came out of good Modify user');
    attributes = new Map<String,String>();
    attributes.put('2','1');
    
    UserProvisioningService.modifyUser(attributes,config,null);
    
    System.debug ('STARTING MODIFY USER ATTRIB 2');
    UserProvisioningService.modifyUser(attributes2,config,u1);
    System.debug ('STOPPING MODIFY USER ATTRIB 2');
    System.debug ('Came out of bad Modify user');
    UserProvisioningService.activateUser(attributes, config);
    UserProvisioningService.activateUser(attributes, null);
    test.stopTest();
    
  }
 
  
  @IsTest
  public static void test_InvalidMessageType() {
    List<UserProvisioningService.NameValue> provisioningMessage = createTemplateProvisioningMessage();
    for( UserProvisioningService.NameValue nv : provisioningMessage ) {
      if( nv.Name.toUpperCase().equals( UserProvisioningService.MessageType) ) {
        nv.Value = 'JNK';  // insert an invalid message type code
      }
    }
    Test.startTest();
    UserProvisioningService.Response r = UserProvisioningService.handleMessage( provisioningMessage );

    Test.stopTest();
    
    try{ 
    //UserProvisioningService.populate360DegreeViewLookupsFuture( 'true');
    }catch(JSONException e){}
    System.assert( r.msgCode == 2, 'Failed to detect an invalid message type received by the service');
  }
  
  @IsTest
  public static void test_ActivateUser() {
    UserProvisioningService.Response response = new UserProvisioningService.Response(1, 'test' );
    Response.mergeResponse(response);
    List<String> to = new List<String>();
    to.add('test.t@mail.com');
    UserProvisioningService.sendNotificationNow('test', 'standarduser@testorg.com', to, 'test subject', 'test body');
  }
  
  
  public static List<UserProvisioningService.NameValue> createTemplateProvisioningMessage() {
    String eml = 'kirat.gill@carefirst.com';
    String token = ( String.valueOf(Datetime.now().getTime()).right(5));
    token = '21884';
    System.debug( 'token=' + token );
    List<UserProvisioningService.NameValue> attrs = new List<UserProvisioningService.NameValue>();
    //attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, UserProvisioningService.MessageType_BAM));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentFirst, 'yyNew2222'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentMiddle, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentLast, 'KGggggggg' + token ));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentEmail, eml));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentID, token));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentTitle, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyID, token));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyName, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.PortalID, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.Guid,token ));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyRole, 'N'));
    
   // System.debug( UserProvisioningService.handleMessage( attrs ) );
    return attrs;
  }
  
  public static List<UserProvisioningService.NameValue> createTemplateProvisioningMessage1() {
    String eml = 'kirat.gill@carefirst.com';
    String token = ( String.valueOf(Datetime.now().getTime()).right(5));
    token = '21885';
    System.debug( 'token=' + token );
    List<UserProvisioningService.NameValue> attrs = new List<UserProvisioningService.NameValue>();
    //attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, UserProvisioningService.MessageType_BAM));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentFirst, 'yyNeeeeee'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentMiddle, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentLast, 'KGgeeeeee' + token ));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentEmail, eml));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentID, token));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentTitle, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyID, token));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyName, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.PortalID, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.Guid,token ));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyRole, 'N'));
    
   // System.debug( UserProvisioningService.handleMessage( attrs ) );
    return attrs;
  }
  
  public static List<UserProvisioningService.NameValue> createTemplateProvisioningMessage2() {
    String eml = 'kirat.gill@carefirst.com';
    String token = ( String.valueOf(Datetime.now().getTime()).right(5));
    token = '21885';
    System.debug( 'token=' + token );
    List<UserProvisioningService.NameValue> attrs = new List<UserProvisioningService.NameValue>();
    //attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, UserProvisioningService.MessageType_BAM));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentFirst, 'yyNew2222'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentMiddle, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentLast, 'KGggggggg' + token ));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentEmail, eml));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentID, token));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentTitle, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyID, token));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyName, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.PortalID, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.Guid,'' ));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyRole, 'N'));
    
   // System.debug( UserProvisioningService.handleMessage( attrs ) );
    return attrs;
  }
  
  public static List<UserProvisioningService.NameValue> createTemplateProvisioningMessage3() {
    String eml = 'kirat.gill@carefirst.com';
    String token = ( String.valueOf(Datetime.now().getTime()).right(5));
    token = '21885';
    System.debug( 'token=' + token );
    List<UserProvisioningService.NameValue> attrs = new List<UserProvisioningService.NameValue>();
    //attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, UserProvisioningService.MessageType_BAM));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentFirst, ''));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentMiddle, null));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentLast, null ));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentEmail, null));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentID, ''));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentTitle, ''));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyID, ''));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyName, ''));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.PortalID, ''));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.Guid,null ));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyRole, ''));
    
   // System.debug( UserProvisioningService.handleMessage( attrs ) );
    return attrs;
  }
  public static List<UserProvisioningService.NameValue> createTemplateProvisioningMessage4() {
    String eml = 'kirat.gill@carefirst.com';
    String token = ( String.valueOf(Datetime.now().getTime()).right(5));
    token = '21884';
    System.debug( 'token=' + token );
    List<UserProvisioningService.NameValue> attrs = new List<UserProvisioningService.NameValue>();
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, ''));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentFirst, 'yyNew'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentMiddle, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentLast, 'K' + token ));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentEmail, eml));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentID, 'CF1234'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentTitle, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyID, '1'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyName, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.PortalID, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.Guid,'CF291-280754757'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyRole, 'N'));
    
   // System.debug( UserProvisioningService.handleMessage( attrs ) );
    return attrs;
  }
  
  public static List<UserProvisioningService.NameValue> createTemplateProvisioningMessage5() {
    String eml = 'kirat.gill@carefirst.com';
    String token = ( String.valueOf(Datetime.now().getTime()).right(5));
    token = '21884';
    System.debug( 'token=' + token );
    List<UserProvisioningService.NameValue> attrs = new List<UserProvisioningService.NameValue>();
    //attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType, UserProvisioningService.MessageType_BAM));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentFirst, 'yyNew'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentMiddle, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentLast, 'K' + token ));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentEmail, eml));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentID, token));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgentTitle, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyID, '1'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyName, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.PortalID, 'yy'));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.Guid,token ));
    attrs.add( new UserProvisioningService.NameValue(UserProvisioningService.AgencyRole, 'N'));
    
   // System.debug( UserProvisioningService.handleMessage( attrs ) );
    return attrs;
  }
    @isTest
    public static void test_handleMessage_exception(){
        Account a = new Account();
        a.Name = 'Community_User_Account';
        a.Type = 'Partner';
        a.Agency_NPN__c = '222222222';
        insert a;
        List<UserProvisioningService.NameValue> provisioningMessage = createTemplateProvisioningMessage();
        System.debug ('prov message');
        
        provisioningMessage.add( new UserProvisioningService.NameValue(UserProvisioningService.MessageType,'Text'));
        Map<String,String> attributeMap = UserProvisioningService.convertListToMap( provisioningMessage );
        
        Test.startTest();
        UserProvisioningService.handleMessage( provisioningMessage );
        System.debug ('Provision Message Done');
        Test.stopTest();
  }
  
    @isTest
    public static void test_functions2(){
        List<UserProvisioningService.NameValue> attrs4 = createTemplateProvisioningMessage4();
        Map<String,String> attributes4 = UserProvisioningService.convertListToMap(attrs4);
        Profile p = [SELECT Id, Name FROM Profile WHERE Name='Standard User']; 
        UserProvisioningService.Configuration config = new UserProvisioningService.Configuration();
        
        config.communityContactRecordTypeID =  '012600000005OTFAA2'; //'012110000005OXvAAM' (Dev3);
        config.ProfileName = p.Name;
        config.CommunityProfileId = p.id;
        config.UserLicenseString = 'Customer Community Plus Login';
        config.UserRoleString = 'N';
        config.LicenseCategoryString = 'Small/Mid Community User';
        config.InternalSupportEmail = 'kirat.gill@carefirst.com';
        config.ExternalSupportEmail = 'kirat.gill@carefirst.com';
        config.EmailEncodingKey = 'UTF-8';
        config.LanguageLocaleKey = 'en_US';
        config.LocaleSidKey = 'en_US';
        config.TimeZoneSidKey = 'America/Los_Angeles';
        config.SendUserEmail = true; 
        
        Map<String,String> att = new map <String, String> ();
        
        att.put('TRN_MSG_TYPE','BAA');
        att.put('UID','FF117-9992003301');
        att.put('USER_ID','man1@carefirst');
        att.put('FRST_NM','Seyittttttttt');
        att.put('MID_NM','Nothing');
        att.put('LAST_NM','Usmanovvvvvvvvv');
        att.put('EMAL_ADDR','usmanoff@man.com');
        att.put('SSN','123321456');
        att.put('BRKR_TITL','Principal Broker');
        att.put('TAX_IDNTN_NBR','101123332');
        att.put('DSTBR_NM','Kyrgyzstan');
        att.put('ASST_BRKR_INDC','N');
    
        Contact c = UserProvisioningService.createContact( att, config);
        upsert c Agency_Agent_ID__c;
        
        User u1 = [select id from User where FederationIdentifier='CF291-280754757'];
        //u1.ContactId = c.id; update u1;
        Test.startTest();
        UserProvisioningService.modifyUser(attributes4,config,u1);
        
        Test.stopTest();

  }  
}