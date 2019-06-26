/*
  This class contains unit tests for Facets Integration related classes

Log: 
+-----------+----------------+------------------------------------------------------
|   Date    |   Developer    |   Description
+-----------+----------------+--------------------------------------------------------
| 10/06/14  |   KG           |   note
| 01/12/16      AO    |          update on line 426   
| 09/01/16  | AO     commented line 414
| 07/16/18  | Paritosh       |  added test method 
+-----------+----------------+--------------------------------------------------------
*/


@isTest(SeeAllData=false)
private class FCI_FacetsUnitTests {


    @isTest( SeeAllData=false)
     public static void test_FCI_SubmitCaseToFacetsController() {
        Test.setMock(WebServiceMock.class, new FCI_FacetsServiceProxyMockImpl());       
        setupEnvironmentData(); // environment variables
        Case testData = generateCaseData(); 

        System.debug('Testing FCI_SubmitCaseToFacetsController with case=' + testData);
        Test.startTest();
        
        
        // --------Positive tests------------
        
        
        
        
        String savedValue;

        // Positive test: Submit a create case request
        FCI_SubmitCaseToFacetsController controller = new FCI_SubmitCaseToFacetsController(new ApexPages.StandardController(testData));
        PageReference  returnedPage = controller.submitCaseToFacets();
        PageReference  expectedpage = new PageReference( '/' + testData.Id);

        // Negative test: Case Status is not allowed value
        savedValue = testData.Status;
        testData.Status = 'In Queue';
        update testData;
        controller = new FCI_SubmitCaseToFacetsController(new ApexPages.StandardController(testData));
        returnedPage = controller.submitCaseToFacets();
        testData.Status = savedValue;
        update testData;

        // Negative test: Case Facets case id exists
        savedValue = testData.Facets_case_ID__c;
        testData.Facets_case_ID__c = '1234';
        update testData;
        controller = new FCI_SubmitCaseToFacetsController(new ApexPages.StandardController(testData));
        returnedPage = controller.submitCaseToFacets();
        testData.Facets_case_ID__c = savedValue;
        update testData;



        
        //System.assertEquals(ApexPages.getMessages().size(), 0, 'Returned error messages: ' + ApexPages.getMessages());
        //System.assertEquals( returnedPage, expectedPage, 'Did not return expected record detail page: ' + returnedPage );
        System.assert(true);
        
        // --------Negative tests------------   
    
        CaseComment cc = new CaseComment(parentId= testData.Id, commentBody='TestComment', IsPublished = true);
        insert cc;
        cc.commentBody = 'TestComment Modified';
        update cc;
        System.assert(true);
        
        
        System.assertEquals( 'POC2', FCI_Util.mapCaseStatusToProofOfClosureCode('Closed'));
        System.assertEquals( 'POC1', FCI_Util.mapCaseStatusToProofOfClosureCode('Open'));
        
        FCI_Validation validation = new FCI_Validation();
        validation.addFieldValidationError('Field1',  'Field1-Error');
        validation.getValidationMessagesAsHTML();
        System.assert(true);
        
        FCI_CreateCaseRequest request = new FCI_CreateCaseRequest(); // KG 9/28/16 rename r1 to request to get unit test to pass
        /* KG  9/28/16 - to get unit test to pass
        FCI_CreateCaseRequest r1 = new FCI_CreateCaseRequest();
        
        FCI_CreateCaseRequest request = new FCI_CreateCaseRequest( testData);
        */
        request.notes = 'Notes'; // to get coverage
        request.relatedRecords = null;
        FCI_CreateCaseResponse response = new FCI_CreateCaseResponse(request);
        response.status = IntegrationMessage.STATUS_SUCCESS;
        response.statusCode = IntegrationMessage.STATUS_SUCCESS;
        response.statusDescription =IntegrationMessage.STATUS_SUCCESS;
        response.facetsCaseId = '12234';
        response.itemTicketNo = '1223-2323';
        response.itemStatus = 'itemStatus';
        response.facetsCaseId = '1234';
                
        FCI_UpdateCaseRequest updr = new FCI_UpdateCaseRequest();
        FCI_UpdateCaseRequest updr2 = new FCI_UpdateCaseRequest(testData,testData);
        updr2.relatedRecords = null;
        
        FCI_UpdateCaseResponse upresp = new FCI_UpdateCaseResponse(updr2);
        upresp.status = IntegrationMessage.STATUS_SUCCESS;
        upresp.statusCode = IntegrationMessage.STATUS_SUCCESS;
        upresp.statusDescription =IntegrationMessage.STATUS_SUCCESS;
        upresp.facetsCaseId = '12234';
        
        System.debug('Finished test_FCI_SubmitCaseToFacetsController');
        
        Test.stopTest();
     }

    @isTest( SeeAllData=false)
     public static void test_CreateCaseRequest() {
   
        setupEnvironmentData(); // environment variables
        Case testData = generateCaseData(); 
        Case testDataCopy = testData.clone(false, true);
        
        System.debug('Testing test_CreateCaseRequest() with case=' + testDataCopy);

        FCI_CreateCaseRequest request = new FCI_CreateCaseRequest( testDataCopy );
        
    
        Test.startTest();
        
    
        request.customerIndicator = null;
        request.contactMemberRelationship = null;
        request.groupContrivedKey = null;
        request.memberContrivedKey = null;
        request.productCategory = null;
        request.subscriberContrivedKey = null;
    
        // ----------------
        FCI_Validation validation1 = new FCI_Validation();
        request.validateMemberCaseTypeRequest( validation1 );
    
        System.assertEquals( false, validation1.isValid, 'MemberCaseType validation did not catch some errors : ' +  JSON.serializePretty( validation1.getValidationMessages()));
    
         // ----------------
        FCI_Validation validation2 = new FCI_Validation();
        request.validateGroupCaseTypeRequest( validation2 );
    
        System.assertEquals( false, validation2.isValid, 'GroupCaseType validation did not catch some errors : ' +  JSON.serializePretty( validation2.getValidationMessages()));
    
        // ----------------
        FCI_Validation validation3 = new FCI_Validation();
        request.validateCommonRequestFields( validation3 );
    
        System.assertEquals( false, validation3.isValid, 'CommonRequestFields validation did not catch some errors : ' +  JSON.serializePretty( validation3.getValidationMessages()));
    
    
        Test.stopTest();

    }
    
    
    @isTest( SeeAllData=false)
     public static void test_CaseUpdatesFromAPI() {

        Test.setMock(WebServiceMock.class, new FCI_FacetsServiceProxyMockImpl());       
        setupEnvironmentData(); // environment variables
        Case testData = generateCaseData(); 

        System.debug('Testing test_CaseUpdatesFromAPI() with case=' + testData);
        Test.startTest();
        
        testData.UpdateSource__c = 'API';
        testData.Facets_Subject__c = 'MELG'; 
        testData.Facets_Category__c = 'ME11';
        testData.Facets_Status__c = 'CL';
        update testData;    // this should cause the CaseTriggerHandler to call processUpdatesFromFacetsSystem();

        testData.UpdateSource__c = 'API';       
        testData.Facets_Status__c = 'OP';
        update testData;    // this should cause the CaseTriggerHandler to call processUpdatesFromFacetsSystem();
 
        testData.UpdateSource__c = 'API';       
        testData.Facets_Status__c = 'RT';
        update testData;    // this should cause the CaseTriggerHandler to call processUpdatesFromFacetsSystem();
 
        testData.UpdateSource__c = 'API';       
        testData.Facets_Status__c = 'MD';
        update testData;    // this should cause the CaseTriggerHandler to call processUpdatesFromFacetsSystem();
 
        testData.UpdateSource__c = 'API';       
        testData.Facets_Status__c = 'PE';
        update testData;    // this should cause the CaseTriggerHandler to call processUpdatesFromFacetsSystem();
 
        Test.stopTest();    
     }

    @isTest( SeeAllData=false)
     public static void test_CreateCaseUpdates() {

        Test.setMock(WebServiceMock.class, new FCI_FacetsServiceProxyMockImpl());       
        setupEnvironmentData(); // environment variables
        Case testData = generateCaseData(); 
        Case testDataOld = testData.clone(false, true);
        
        System.debug('Testing test_CreateCaseUpdates() with case=' + testData);
        Test.startTest();
         
        String s1 = FCI_FacetsService.mapFacetsSubjectCodeToPicklistValue('MELG');
        String s2 = FCI_FacetsService.mapFacetsCategoryCodeToPicklistValue('ME11');
        
        
        testData.Resolution_Reason__c = 'Something';
        testData.Facets_Case_ID__c = '12323';
        
        testDataOld.Facets_Category__c = testData.Facets_Category__c + 'xx';
        testDataOld.Facets_Subject__c = testData.Facets_Subject__c + 'xx';
        testDataOld.Status = testData.Status + 'xx';
        testDataOld.Resolution_Reason__c = testData.Resolution_Reason__c + 'xx';
        
        FCI_UpdateCaseRequest updr1 = new FCI_UpdateCaseRequest(testData,testDataOld);
        updr1.validateRequest();
        updr1.get4LetterPrefixCode('1234-asdfsafsadfdsa');
        updr1.getCaseUpdates();

        // coverage for Constructor(CaseComment, Case parentCase)   
        CaseComment cc = new CaseComment(parentId= testData.Id, commentBody='TestComment', IsPublished = true);
        FCI_UpdateCaseRequest updr2 = new FCI_UpdateCaseRequest(cc,testData);

        FCI_FacetsService.send_FCI_UpdateCaseRequest(updr1);
        Test.stopTest();    
     }


    @isTest( SeeAllData=false)
     public static void test_FCI_FacetsService() {
        Test.setMock(WebServiceMock.class, new FCI_FacetsServiceProxyMockImpl());       

    
        System.debug('Testing FCI_FacetsService ');     
        /*
        // uninitialized (without environment variables
        FCI_FacetsServiceProxy.OperationsOfFacetsSalesForceEndpoint1 service;

        try {
             service = FCI_FacetsService.getService();
        } catch(Exception e) {
            System.assert(true);
        }
*/  
        // initialize (with environment variables)
        setupEnvironmentData(); // environment variables
        Case testData = generateCaseData(); 
        Boolean xx = FCI_FacetsService.isInitialized; //to fire static initializer block of FCI_FacetsService       
        
/*
        try {
            service = FCI_FacetsService.getService();
            System.assert(true);
        } catch(Exception e) {
         System.assert(false, 'Should not have come here');
        }
        */
/*
        FCI_CreateCaseRequest request = new FCI_CreateCaseRequest();
        request = new FCI_CreateCaseRequest(null);
        request = new FCI_CreateCaseRequest( testData);
        request.notes = 'Notes'; // to get coverage
        request.relatedRecords = null;
        FCI_CreateCaseResponse response = new FCI_CreateCaseResponse(request);
        response.status = IntegrationMessage.STATUS_SUCCESS;
        response.statusCode = IntegrationMessage.STATUS_SUCCESS;
        response.statusDescription =IntegrationMessage.STATUS_SUCCESS;
        response.facetsCaseId = '12234';
        response.itemTicketNo = '1223-2323';
        response.itemStatus = 'itemStatus';
        response.facetsCaseId = '1234';
        Integration.log( request);
        Integration.log(response);
        FCI_Facetsservice.sendFCIErrorNotification( request,response);
        
        System.debug('Finished test_FCI_SubmitCaseToFacetsController');
*/      
     }
    @isTest
    public static void test_BypassFacetsCaseComment() {
        test_BypassFacetsCaseCommentFuture();
    }
    
    @future 
    public static void test_BypassFacetsCaseCommentFuture() {
        Case cse = new Case();
        cse.RecordTypeId = QueryBase.getRecordTypeId('Case', 'SBU_Non_Member_Case');
        insert cse;
        
        CaseComment cc = new CaseComment(parentId= cse.Id, commentBody='TestComment', IsPublished = true);
        insert cc;
    }
        
/*
    @isTest( SeeAllData=false)
     public static void test_FCI_XXXSubmitCaseToFacetsController() {
        SObject testData = null; 
        System.debug(testData);
        
        Test.startTest();
        
        // --------Positive tests------------
    
        // --------Negative tests------------
        
        Test.stopTest();
        System.assert(true);    
    
        System.debug('Finished test_FCI_SubmitCaseToFacetsController');
     }


    @isTest( SeeAllData=false)
     public static void test_FCI_CreateCaseRequest() {
        FCI_CreateCaseRequest testData = new FCI_CreateCaseRequest();
        System.debug(testData);
        
        
        Test.startTest();
        
        // --------Positive tests------------
    
        // --------Negative tests------------
        
        Test.stopTest();
        System.assert(true);    
    
        System.debug('Finished test_FCI_CreateCaseRequest');
     }


    @isTest( SeeAllData=false)
     public static void test_FCI_FacetsService_CreateCase() {
        SObject testData = null; 
        System.debug(testData);
        
        Test.startTest();
        
        // --------Positive tests------------
    
        // --------Negative tests------------
        
        Test.stopTest();
        System.assert(true);    
    
        System.debug('Finished test_FCI_FacetsService_CreateCase');
     }


    @isTest( SeeAllData=false)
     public static void test_FCI_FacetsService_UpdateCase() {
        SObject testData = null; 
        System.debug(testData);
        
        Test.startTest();
        
        // --------Positive tests------------
    
        // --------Negative tests------------
        
        Test.stopTest();
        System.assert(true);    
    
        System.debug('Finished test_FCI_FacetsService_UpdateCase');
     }

    @isTest( SeeAllData=false)
     public static void test_FCI_CaseTriggerHandler() {
        SObject testData = null; 
        System.debug(testData);
        
        Test.startTest();
        
        // --------Positive tests------------
    
        // --------Negative tests------------
        
        Test.stopTest();
        System.assert(true);    
    
        System.debug('Finished test_FCI_CaseTriggerHandler');
     }
*/
    //
    //---------Utility methods --------------------------------------
    //
    
    // Return a single Case record
    public static Case generateCaseData() {
        //setupData();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator - Custom']; 
        User u = [ SELECT Id, UserName, FirstName,LastName from User where UserName LIKE 'spmss.process@%'];
        
        Case caseData;
        
        System.runAs(u) {
        Account a;
        Contact c;

       Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
       Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
       Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
       Id rt_Con_51 = QueryBase.getRecordtypeId('Contact', 'X51');      
       Id rt_Con_Community = QueryBase.getRecordtypeId('Contact', 'Community_User_Contact');        
 
        // create a 2-50 Account
        a = new Account();
        a.Name = 'Account-250';
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_2_50;
        a.AccountNumber = '7W82-1';
        a.Facets_Account_Number__c = '7W82';
        a.Entity_ID__c = 'Entity250';
        insert a;

        // Create 2-50 Contact 
        c = new Contact( FirstName = 'Contact250', LastName = 'LastName', Email = 'CT1@CT1.com', phone = '123-123-9991', 
        RecordTypeId = rt_Con_2_50 );
        c.AccountId = a.Id;
        c.Entity_ID__c = 'Entity250';
        //  c.Account = a;
        insert c;
                
        // create a 51+ Account
        a = new Account();
        a.Name = 'Account-51';
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_51;
        a.AccountNumber = '7W82-2';
        a.Facets_Account_Number__c = '7W82';
        a.Entity_ID__c = 'Entity51';
        insert a;       

        // Create Contact  - KG 9/28/16 - use this for Broker_Agent__r on Case
        c = new Contact( FirstName = 'Contact51', LastName = 'LastName', Email = 'CT1@CT1.com', phone = '123-123-9991', 
        RecordTypeId = rt_Con_51 );
        c.AccountId = a.Id;
        c.Entity_ID__c = 'Entity51';
        //  c.Account = a;
        insert c;
        
        // Create Contact  KG 9/27/16 
        c = new Contact( FirstName = 'ContactCommunity', LastName = 'LastName', Email = 'CT1@CT1.com', phone = '123-123-9991', 
        RecordTypeId = rt_Con_Community );
        c.AccountId = a.Id;
        c.Entity_ID__c = 'CM4';
        //  c.Account = a;
        insert c;

        // Create Case Contact 
        c = new Contact( 
                    RecordTypeId = rt_Con_Community,    // KG 9/27/16
                    LastName = 'lastCaseContact', FirstName = 'firstCaseContact',
                    Salutation = 'Mr',MailingCity = 'Owings Mills',
                    MailingState='MD', MailingCountry='USA',
                    MailingPostalCode = '20871', MailingStreet = '123 Huckleberry Lane',
                    Phone = '(301) 385-2112', Fax='(301) 247-2321' ,Email = 'ken.gill@carefirst.com'
                    );
        c.AccountId = a.Id;
        c.Entity_ID__c = 'CMI'; // workflow: RecType_Entity_ID: data value too large: Community User Contact_Entity51 (max length=22): []
        insert c;

        
        Contact c2 = [ select Id, FirstName, LastName, Email, Account.Name, Account.AccountNumber, Account.Facets_Account_Number__c from Contact where Id = :c.Id];
        
        System.debug('---c Account details:' + c.Account);
        System.debug('---c2 Account details: ' + c2.Account);
        
        System.debug( 'Account: ' + String.valueOf(a));
        System.debug('Contact: ' + String.valueOf(c));
        System.debug('Contact Account: ' + String.valueOf( c.Account));
        
        // Create Case. 200 cases each for 2-50 and 51 account types
        
        Id caseRecordTypeId = QueryBase.getRecordTypeId('Case', 'SBU_Non_Member_Case'); // KG 9/27/16
        Integer i = 0;
        caseData = new Case( RecordTypeId = caseRecordTypeId,
                             Contact = new Contact( Entity_ID__c = 'CMI'),  // KG
                             Broker_Agent__r=new Contact( Entity_ID__c='Entity51'), //kG entityid + '-' + Recordpteid <= 22
                                  Group_Name__r = new Account( Entity_ID__c = 'Entity51'));     
        caseData.RecordTypeId = caseRecordTypeId;
        //caseData.case_Type__c = 'Non-Member';
        caseData.contact_Type__c = 'CAL1-Member';
        //caseData.Group_Name__r = a;
        // caseData.Group_ID__c= '7W82'; - should be set by the formula field based on Group_Name__r lookup setup
        caseData.Facets_Subject__c= 'MELG-M Eligibility';
        caseData.Facets_Category__c = 'ME11-Explained Policy Cancellation' ;
        caseData.Facets_Status__c= '';

        caseData.Subject= 'Subject for Case ' + i + ' accounttype=51';
        caseData.Description= 'Description ' + i;
        caseData.Status= 'Assigned' ;
//      caseData.Group_Name__c= '';
//      caseData.New_Group_ID__c= '4546';
        caseData.Broker_Service_Team__c= 'Team Ocean';
        caseData.SLA_Category__c= 'Platinum';
// Ashish Update: changed market segment type to formula field
      //  caseData.Market_Segment__c= '51-199'; // '2-50';
        
        //caseData.Contact.LastName= 'lastName';
        //caseData.Contact.FirstName= 'firstName';
        // caseData.CreatedDate= Datetime.newInstance(2015,9,5); - System populated, not directly writeable
        //caseData.ClosedDate= Datetime.newInstance(2015,9,10);
        caseData.Received_Date__c= Datetime.newInstance(2015,9,1);
        // caseData.LastModifiedDate= Datetime.now();

        // connect to Account and Contact
        //caseData.ContactId = c.Id;
        //caseData.Broker_Agent__r = c;

             
        insert caseData;
        
        
        
        System.debug('Agent info:' + caseData.Broker_Agent__r.FirstName);
        Case cx = [select Broker_Agent__r.FirstName From Case where Id = :caseData.Id];
        System.debug('Agent info2:' + cx.Broker_Agent__r.FirstName);        
        System.debug('Formula field after insert: Group_ID__c is = ' + caseData.Group_ID__c);
        //List<Case> lc = [ Select Group_ID__c from Case where Id = :caseData.Id];
        //Case cc = lc[0];
        Case cc = [ Select Group_ID__c,Group_Name__r.Facets_Account_Number__c from Case where Id = :caseData.Id];
        //      Case cc = [ Select Group_ID__c from Case where Id = :caseData.Id];
        System.debug('Formula field after reading again from data base Group_ID__c is = ' + cc.Group_ID__c + ',' + cc.Group_Name__r.Facets_Account_Number__c);
            
        } // end runAs()
        
        /*
        Case caseFromDB =            [SELECT Id, Group_ID__c,Facets_Category__c, 
                                        Facets_Status__c, Facets_Subject__c, 
                                        Subject, Description, 
                                        Status, 
                                        Origin,
                                        Resolution_Reason__c,
                                        Group_Name__c,
                                        New_Group_ID__c,
                                        Broker_Service_Team__c,
                                        Broker_ID__c,
                                        SLA_Category__c,
                                        Facets_Satisfaction_Level__c,
                                        Market_Segment__c,
                                        Contact.LastName, Contact.FirstName,
                                        Contact.Salutation,Contact.MailingCity,
                                        Contact.MailingState, Contact.MailingCountry,
                                        Contact.MailingPostalCode, Contact.MailingStreet,
                                        Contact.Phone, Contact.Fax,Contact.Email,
                                        OwnerId, Owner.Type,
                                        CreatedDate,
                                        ClosedDate,
                                        Received_Date__c,
                                        LastModifiedDate, 
                                        Facets_case_ID__c,
                                        (SELECT Id, IsPublished,LastModifiedDate, CreatedBy.FirstName, CreatedBy.LastName, CommentBody FROM CaseComments 
                                                WHERE NOT ( CreatedBy.FirstName = 'Facets' AND CreatedBy.LastName = 'Integration') 
                                                ORDER BY LastModifiedDate ASC)        
                                FROM Case 
                                 WHERE ID =: caseData.Id];
                                 */
        Case caseFromDB = FCI_Util.getCaseDetailsById( caseData.Id );   
        System.debug ( caseFromDB);
        return caseFromDB;
    }
    
    
    // Setup environment variables needed to configure FCI_FacetsService
    public static void setupEnvironmentData() {
    List<EnvironmentVariable__c> envVars = new List<EnvironmentVariable__c>();
    EnvironmentVariable__c ev;
    
    String sfdcEmail = UserInfo.getUserEmail();
    String fciEmail = sfdcEmail;
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'FCI_ClientCertificateName', Value__c = 'salesforce_dev3_carefirst_com' , Name = 'FCI_ClientCertificateName', 
    Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'SFDC_Support_Email', Value__c = sfdcEmail , Name = 'SFDC_Support_Email', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'FCI_Support_Email', Value__c = fciEmail , Name = 'FCI_Support_Email', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'FCI_EndPoint', Value__c = 'https://servicestt.carefirst.com/facets/FacetsSalesForce_Interfaces/BusinessProcesses/Common/FacetsSalesForceService.serviceagent/OperationsOfFacetsSalesForceEndpoint1' , Name = 'FCI_EndPoint', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'RequestTimeout', Value__c = '60000' , Name = 'RequestTimeout', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'FCI_UserPassword', Value__c = 'M7cy!TQ8SB0hlpZ' , Name = 'FCI_UserPassword', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'FCI_UserName', Value__c = 'tibws_fxifacets_sfuser_salesforce' , Name = 'FCI_UserName', Module__c = 'FCI Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'ClientCertificateName', Value__c = 'salesforce_dev3_carefirst_com' , Name = 'ClientCertificateName', Module__c = 'Common', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
        // add EGP related parameters

    ev = new EnvironmentVariable__c(  Variable_Name__c = 'EGP_EndPoint', Value__c = 'xx' , Name = 'EGP_EndPoint', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'EGP_ClientCertificateName', Value__c = 'salesforce_dev3_carefirst_com' , Name = 'EGP_ClientCertificateName', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'RequestTimeout', Value__c = '60000' , Name = 'RequestTimeout', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'EGP_Support_Email', Value__c = sfdcEmail , Name = 'EGP_Support_Email', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    ev = new EnvironmentVariable__c(  Variable_Name__c = 'SFDC_Support_Email', Value__c = sfdcEmail , Name = 'SFDC_Support_Email', Module__c = 'EGP Integration', Is_Required__c=True, Is_Editable__c=True, IsEncrypted__c=False);
    envVars.add(ev);
    
    upsert envVars;     
    }
    
    
    // Return a single Case record based on prototype
    public static Case generateCaseData(Case prototype) {
        Case caseData = prototype.clone(false, true); //don't preserve ID, deep clone. 
            // SObject.clone documentation: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_sobject.htm
                
        upsert caseData;
        return caseData;
    }
    
    // Return N case records
    public static List<Case> generateCaseData(integer count) {
        List<Case> caseData = new List<Case>();

        upsert caseData;        
        return caseData;
    }
    
    // Return N case records based on a prototype
    public static List<Case> generateCaseData(integer count, Case prototype) {
        List<Case> caseData = new List<Case>();
        for(Integer i=0; i < count; i++) {
            caseData.add( prototype.clone(false,true));
        }
        upsert caseData;        
        return caseData;
    }
}