/*=========================================================================================
 * Date         : 4/15/2018
 * Developer    : Sree Uma Ponnoju
 * Purpose      : This class is a test class for the IntegrationCredentialService
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *============+=======+====================================================================
 *   
 *============+=======+====================================================================
 */
@istest
Private class IntegrationCredentialServiceTest{
    static testMethod void testGetMethod()
    {
        Test.startTest();
        Boolean isValid = true;
        IntegrationRequest iReq = new IntegrationRequest();
        Integer Req_ts_1 = new IntegrationRequest().Req_ts;
        String reqBody= '/services/apexrest/IntegrationCredential' ;
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri ='/services/apexrest/IntegrationCredentialService';
        req.httpMethod = 'GET';
        req.requestBody = Blob.valueof(reqBody);
        RestContext.request = req;
        RestContext.response = res;
        System.debug('======> RestContext.request ' + req);  
        System.debug('======> RestContext.response ' + res);  
        IntegrationCredentialService.doGet();
        IntegrationResponse iRes = new IntegrationResponse(iReq);
        Integer Res_ts_2 = new IntegrationResponse(iReq).Res_ts;
        String responseTime1 = new IntegrationResponse(iReq).responseTime;
    }
    static testMethod void testGetAccount()
    {
       Test.startTest();
       Boolean isValid = true;
       IntegrationRequest iReq = new IntegrationRequest();
       Integer Req_ts_1 = new IntegrationRequest().Req_ts;
       RestRequest req = new RestRequest();
       RestResponse res = new RestResponse();
       Org_Credential_Location_Mapping__mdt ocl = [select id, DeveloperName, UserName__c 
                                                   from Org_Credential_Location_Mapping__mdt 
                                                   limit 1];
       String dname = ocl.DeveloperName;
       String uname = ocl.UserName__c;
       //req.params.put('accountName', uname );     
       System.debug('======> req params ' + req.params.put('accountName', 'BTVERF4H64'));  
       req.httpMethod = 'GET';
       req.requestUri ='/services/apexrest/IntegrationCredentialService';
       RestContext.request = req;
       RestContext.response = res;
       System.debug('======> RestContext.request val ' + req);  
       System.debug('======> RestContext.response val ' + res); 
       IntegrationCredentialService.doGet();
       IntegrationResponse iRes = new IntegrationResponse(iReq);
       Integer Res_ts_2 = new IntegrationResponse(iReq).Res_ts;
       String responseTime1 = new IntegrationResponse(iReq).responseTime;
    }
   
    static testMethod void testValidateRequest(){
    String localOrgName = getLocalOrgName(UserInfo.getOrganizationId());
    System.debug('====> localOrgName ' + localOrgName); 
        
    List<Org_Credential_Location_Mapping__mdt> oclList = new List<Org_Credential_Location_Mapping__mdt>();
    oclList = [select id, DeveloperName, UserName__c, OrgName__c 
               from Org_Credential_Location_Mapping__mdt 
               where locationType__c = 'Environment Variable'  ]; 
       
    System.debug('====> oclList ' + oclList );                                            
    List<CF_Organization__mdt> orgList = [Select isActive__c, OrgId__c, OrgName__c, OrgNamedCred__c
                                          From CF_Organization__mdt]; 
    String uname ;                                                                                
    for(Org_Credential_Location_Mapping__mdt ocl : oclList){
       if(ocl.OrgName__c == localOrgName){
           uname = ocl.UserName__c;
       }
    }  
    system.debug('=====> uname ' + uname);       
    String jsonRequest= '{"credentials": [{  "newPassword": "pass19" },{  "accountName": "",  "newPassword": "pass19"  },{  "accountName": "AIO8RDL",  "newPassword": ""  },{  "accountName": "' +uname+'",   "newPassword": "pass19"  }]}' ; 
    System.debug('JsonRequest in validate method' + jsonRequest);
    Test.startTest();         
    //Mock callouts
    IntegrationCredentialHttp_Mock fakeResp = 
    new IntegrationCredentialHttp_Mock(200,'OK', '{"credentialUpdates":[{"status":"Success","message":"Password rotation at Environment variable FDL_ev","accountName":"TLRVY13TWT"}]}',null);                                                                
    Test.setMock(HttpCalloutMock.class, fakeResp); 
    IntegrationCredentialHttp_Mock fakeResp1 = 
    new IntegrationCredentialHttp_Mock(200,'OK', '{"ConcurrentAsyncGetReportInstances":{"Max":200,"Remaining":200},"ConcurrentSyncReportRuns":{"Max":20,"Remaining":20},"DailyAnalyticsDataflowJobExecutions":{"Max":40,"Remaining":40},"DailyApiRequests":{"Max":5000000,"Remaining":4999935,"Ant Migration Tool":{"Max":0,"Remaining":0},"ApexMDAPI1":{"Max":0,"Remaining":0},"Chatter Desktop":{"Max":0,"Remaining":0},"Chatter Mobile for BlackBerry":{"Max":0,"Remaining":0},"DDP Admin for Office":{"Max":0,"Remaining":0},"Dataloader Bulk":{"Max":0,"Remaining":0},"Dataloader Partner":{"Max":0,"Remaining":0},"Force.com IDE":{"Max":0,"Remaining":0},"Nintex DocGen for Salesforce":{"Max":0,"Remaining":0},"Qualtrics Survey":{"Max":0,"Remaining":0},"Salesforce Chatter":{"Max":0,"Remaining":0},"Salesforce Files":{"Max":0,"Remaining":0},"Salesforce Mobile Dashboards":{"Max":0,"Remaining":0},"Salesforce Touch":{"Max":0,"Remaining":0},"Salesforce for Android":{"Max":0,"Remaining":0},"Salesforce for Outlook":{"Max":0,"Remaining":0},"Salesforce for iOS":{"Max":0,"Remaining":0},"SalesforceA":{"Max":0,"Remaining":0},"Workbench":{"Max":0,"Remaining":0}},"DailyAsyncApexExecutions":{"Max":250000,"Remaining":249993},"DailyBulkApiRequests":{"Max":10000,"Remaining":10000,"Ant Migration Tool":{"Max":0,"Remaining":0},"ApexMDAPI1":{"Max":0,"Remaining":0},"Chatter Desktop":{"Max":0,"Remaining":0},"Chatter Mobile for BlackBerry":{"Max":0,"Remaining":0},"DDP Admin for Office":{"Max":0,"Remaining":0},"Dataloader Bulk":{"Max":0,"Remaining":0},"Dataloader Partner":{"Max":0,"Remaining":0},"Force.com IDE":{"Max":0,"Remaining":0},"Nintex DocGen for Salesforce":{"Max":0,"Remaining":0},"Qualtrics Survey":{"Max":0,"Remaining":0},"Salesforce Chatter":{"Max":0,"Remaining":0},"Salesforce Files":{"Max":0,"Remaining":0},"Salesforce Mobile Dashboards":{"Max":0,"Remaining":0},"Salesforce Touch":{"Max":0,"Remaining":0},"Salesforce for Android":{"Max":0,"Remaining":0},"Salesforce for Outlook":{"Max":0,"Remaining":0},"Salesforce for iOS":{"Max":0,"Remaining":0},"SalesforceA":{"Max":0,"Remaining":0},"Workbench":{"Max":0,"Remaining":0}},"DailyDurableGenericStreamingApiEvents":{"Max":1000000,"Remaining":1000000},"DailyDurableStreamingApiEvents":{"Max":1000000,"Remaining":1000000},"DailyGenericStreamingApiEvents":{"Max":10000,"Remaining":10000,"Ant Migration Tool":{"Max":0,"Remaining":0},"ApexMDAPI1":{"Max":0,"Remaining":0},"Chatter Desktop":{"Max":0,"Remaining":0},"Chatter Mobile for BlackBerry":{"Max":0,"Remaining":0},"DDP Admin for Office":{"Max":0,"Remaining":0},"Dataloader Bulk":{"Max":0,"Remaining":0},"Dataloader Partner":{"Max":0,"Remaining":0},"Force.com IDE":{"Max":0,"Remaining":0},"Nintex DocGen for Salesforce":{"Max":0,"Remaining":0},"Qualtrics Survey":{"Max":0,"Remaining":0},"Salesforce Chatter":{"Max":0,"Remaining":0},"Salesforce Files":{"Max":0,"Remaining":0},"Salesforce Mobile Dashboards":{"Max":0,"Remaining":0},"Salesforce Touch":{"Max":0,"Remaining":0},"Salesforce for Android":{"Max":0,"Remaining":0},"Salesforce for Outlook":{"Max":0,"Remaining":0},"Salesforce for iOS":{"Max":0,"Remaining":0},"SalesforceA":{"Max":0,"Remaining":0},"Workbench":{"Max":0,"Remaining":0}},"DailyStreamingApiEvents":{"Max":1000000,"Remaining":1000000,"Ant Migration Tool":{"Max":0,"Remaining":0},"ApexMDAPI1":{"Max":0,"Remaining":0},"Chatter Desktop":{"Max":0,"Remaining":0},"Chatter Mobile for BlackBerry":{"Max":0,"Remaining":0},"DDP Admin for Office":{"Max":0,"Remaining":0},"Dataloader Bulk":{"Max":0,"Remaining":0},"Dataloader Partner":{"Max":0,"Remaining":0},"Force.com IDE":{"Max":0,"Remaining":0},"Nintex DocGen for Salesforce":{"Max":0,"Remaining":0},"Qualtrics Survey":{"Max":0,"Remaining":0},"Salesforce Chatter":{"Max":0,"Remaining":0},"Salesforce Files":{"Max":0,"Remaining":0},"Salesforce Mobile Dashboards":{"Max":0,"Remaining":0},"Salesforce Touch":{"Max":0,"Remaining":0},"Salesforce for Android":{"Max":0,"Remaining":0},"Salesforce for Outlook":{"Max":0,"Remaining":0},"Salesforce for iOS":{"Max":0,"Remaining":0},"SalesforceA":{"Max":0,"Remaining":0},"Workbench":{"Max":0,"Remaining":0}},"DailyWorkflowEmails":{"Max":922000,"Remaining":922000},"DataStorageMB":{"Max":209,"Remaining":208},"DurableStreamingApiConcurrentClients":{"Max":2000,"Remaining":2000},"FileStorageMB":{"Max":209,"Remaining":205},"HourlyAsyncReportRuns":{"Max":1200,"Remaining":1200},"HourlyDashboardRefreshes":{"Max":200,"Remaining":200},"HourlyDashboardResults":{"Max":5000,"Remaining":5000},"HourlyDashboardStatuses":{"Max":999999999,"Remaining":999999999},"HourlyODataCallout":{"Max":10000,"Remaining":10000},"HourlySyncReportRuns":{"Max":500,"Remaining":500},"HourlyTimeBasedWorkflow":{"Max":500,"Remaining":500},"MassEmail":{"Max":5000,"Remaining":5000},"Package2VersionCreates":{"Max":50,"Remaining":50},"SingleEmail":{"Max":5000,"Remaining":5000},"StreamingApiConcurrentClients":{"Max":2000,"Remaining":2000}}',null); 
    Test.setMock(HttpCalloutMock.class, fakeResp1); 
    Test.setMock(WebServiceMock.class, new IntegrationCredentialWebService_Mock()); 
          
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/IntegrationCredentialService';  
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(jsonRequest);
    RestContext.request = req;
    RestContext.response = res;
    IntegrationCredentialService.doPost();
    Test.stopTest();
    }
    
    static testMethod void testNamedCrednUpadte(){
    String localOrgName = getLocalOrgName(UserInfo.getOrganizationId()); 
    System.debug('====> localOrgName ' + localOrgName);
    List<Org_Credential_Location_Mapping__mdt> oclList = new List<Org_Credential_Location_Mapping__mdt>();
    oclList = [select id, DeveloperName, UserName__c, OrgName__c 
               from Org_Credential_Location_Mapping__mdt 
               where locationType__c = 'Named Credential'  ]; 
    System.debug('====> oclList ' + oclList );                                            
    List<CF_Organization__mdt> orgList = [Select isActive__c, OrgId__c, OrgName__c, OrgNamedCred__c
                                              From CF_Organization__mdt]; 
    String uname ;                                                                                
    for(Org_Credential_Location_Mapping__mdt ocl : oclList){
        if(ocl.OrgName__c == localOrgName){
           uname = ocl.UserName__c;
        }
    }  
    system.debug('=====> uname' + uname);
    //Mock callouts
    IntegrationCredentialHttp_Mock fakeResp = 
    new IntegrationCredentialHttp_Mock(200,'OK', '{"ConcurrentAsyncGetReportInstances":{"Max":200,"Remaining":200},"ConcurrentSyncReportRuns":{"Max":20,"Remaining":20},"DailyAnalyticsDataflowJobExecutions":{"Max":40,"Remaining":40},"DailyApiRequests":{"Max":5000000,"Remaining":4999935,"Ant Migration Tool":{"Max":0,"Remaining":0},"ApexMDAPI1":{"Max":0,"Remaining":0},"Chatter Desktop":{"Max":0,"Remaining":0},"Chatter Mobile for BlackBerry":{"Max":0,"Remaining":0},"DDP Admin for Office":{"Max":0,"Remaining":0},"Dataloader Bulk":{"Max":0,"Remaining":0},"Dataloader Partner":{"Max":0,"Remaining":0},"Force.com IDE":{"Max":0,"Remaining":0},"Nintex DocGen for Salesforce":{"Max":0,"Remaining":0},"Qualtrics Survey":{"Max":0,"Remaining":0},"Salesforce Chatter":{"Max":0,"Remaining":0},"Salesforce Files":{"Max":0,"Remaining":0},"Salesforce Mobile Dashboards":{"Max":0,"Remaining":0},"Salesforce Touch":{"Max":0,"Remaining":0},"Salesforce for Android":{"Max":0,"Remaining":0},"Salesforce for Outlook":{"Max":0,"Remaining":0},"Salesforce for iOS":{"Max":0,"Remaining":0},"SalesforceA":{"Max":0,"Remaining":0},"Workbench":{"Max":0,"Remaining":0}},"DailyAsyncApexExecutions":{"Max":250000,"Remaining":249993},"DailyBulkApiRequests":{"Max":10000,"Remaining":10000,"Ant Migration Tool":{"Max":0,"Remaining":0},"ApexMDAPI1":{"Max":0,"Remaining":0},"Chatter Desktop":{"Max":0,"Remaining":0},"Chatter Mobile for BlackBerry":{"Max":0,"Remaining":0},"DDP Admin for Office":{"Max":0,"Remaining":0},"Dataloader Bulk":{"Max":0,"Remaining":0},"Dataloader Partner":{"Max":0,"Remaining":0},"Force.com IDE":{"Max":0,"Remaining":0},"Nintex DocGen for Salesforce":{"Max":0,"Remaining":0},"Qualtrics Survey":{"Max":0,"Remaining":0},"Salesforce Chatter":{"Max":0,"Remaining":0},"Salesforce Files":{"Max":0,"Remaining":0},"Salesforce Mobile Dashboards":{"Max":0,"Remaining":0},"Salesforce Touch":{"Max":0,"Remaining":0},"Salesforce for Android":{"Max":0,"Remaining":0},"Salesforce for Outlook":{"Max":0,"Remaining":0},"Salesforce for iOS":{"Max":0,"Remaining":0},"SalesforceA":{"Max":0,"Remaining":0},"Workbench":{"Max":0,"Remaining":0}},"DailyDurableGenericStreamingApiEvents":{"Max":1000000,"Remaining":1000000},"DailyDurableStreamingApiEvents":{"Max":1000000,"Remaining":1000000},"DailyGenericStreamingApiEvents":{"Max":10000,"Remaining":10000,"Ant Migration Tool":{"Max":0,"Remaining":0},"ApexMDAPI1":{"Max":0,"Remaining":0},"Chatter Desktop":{"Max":0,"Remaining":0},"Chatter Mobile for BlackBerry":{"Max":0,"Remaining":0},"DDP Admin for Office":{"Max":0,"Remaining":0},"Dataloader Bulk":{"Max":0,"Remaining":0},"Dataloader Partner":{"Max":0,"Remaining":0},"Force.com IDE":{"Max":0,"Remaining":0},"Nintex DocGen for Salesforce":{"Max":0,"Remaining":0},"Qualtrics Survey":{"Max":0,"Remaining":0},"Salesforce Chatter":{"Max":0,"Remaining":0},"Salesforce Files":{"Max":0,"Remaining":0},"Salesforce Mobile Dashboards":{"Max":0,"Remaining":0},"Salesforce Touch":{"Max":0,"Remaining":0},"Salesforce for Android":{"Max":0,"Remaining":0},"Salesforce for Outlook":{"Max":0,"Remaining":0},"Salesforce for iOS":{"Max":0,"Remaining":0},"SalesforceA":{"Max":0,"Remaining":0},"Workbench":{"Max":0,"Remaining":0}},"DailyStreamingApiEvents":{"Max":1000000,"Remaining":1000000,"Ant Migration Tool":{"Max":0,"Remaining":0},"ApexMDAPI1":{"Max":0,"Remaining":0},"Chatter Desktop":{"Max":0,"Remaining":0},"Chatter Mobile for BlackBerry":{"Max":0,"Remaining":0},"DDP Admin for Office":{"Max":0,"Remaining":0},"Dataloader Bulk":{"Max":0,"Remaining":0},"Dataloader Partner":{"Max":0,"Remaining":0},"Force.com IDE":{"Max":0,"Remaining":0},"Nintex DocGen for Salesforce":{"Max":0,"Remaining":0},"Qualtrics Survey":{"Max":0,"Remaining":0},"Salesforce Chatter":{"Max":0,"Remaining":0},"Salesforce Files":{"Max":0,"Remaining":0},"Salesforce Mobile Dashboards":{"Max":0,"Remaining":0},"Salesforce Touch":{"Max":0,"Remaining":0},"Salesforce for Android":{"Max":0,"Remaining":0},"Salesforce for Outlook":{"Max":0,"Remaining":0},"Salesforce for iOS":{"Max":0,"Remaining":0},"SalesforceA":{"Max":0,"Remaining":0},"Workbench":{"Max":0,"Remaining":0}},"DailyWorkflowEmails":{"Max":922000,"Remaining":922000},"DataStorageMB":{"Max":209,"Remaining":208},"DurableStreamingApiConcurrentClients":{"Max":2000,"Remaining":2000},"FileStorageMB":{"Max":209,"Remaining":205},"HourlyAsyncReportRuns":{"Max":1200,"Remaining":1200},"HourlyDashboardRefreshes":{"Max":200,"Remaining":200},"HourlyDashboardResults":{"Max":5000,"Remaining":5000},"HourlyDashboardStatuses":{"Max":999999999,"Remaining":999999999},"HourlyODataCallout":{"Max":10000,"Remaining":10000},"HourlySyncReportRuns":{"Max":500,"Remaining":500},"HourlyTimeBasedWorkflow":{"Max":500,"Remaining":500},"MassEmail":{"Max":5000,"Remaining":5000},"Package2VersionCreates":{"Max":50,"Remaining":50},"SingleEmail":{"Max":5000,"Remaining":5000},"StreamingApiConcurrentClients":{"Max":2000,"Remaining":2000}}',null); 
    Test.setMock(HttpCalloutMock.class, fakeResp); 
    IntegrationCredentialHttp_Mock fakeResp1 = 
    new IntegrationCredentialHttp_Mock(200,'OK', '{"credentialUpdates":[{"status":"Success","message":"Password rotation at Named Credential","accountName":"BTVERF4H64"}]}',null);       
    Test.setMock(HttpCalloutMock.class, fakeResp1);  
        
    Test.setMock(WebServiceMock.class, new IntegrationCredentialWebService_Mock());
    String jsonRequest = '{"credentials": [{  "accountName": "' + uname + '",   "newPassword": "pass19"  }]}' ;
    Test.startTest();         
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    req.requestURI = '/services/apexrest/IntegrationCredentialService'; 
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(jsonRequest);
    RestContext.request = req;
    RestContext.response = res;
    IntegrationCredentialService.doPost(); 
    Test.stopTest();        
    }    
    
    static testMethod void testRemoteCredUpdate(){
        String localOrgName = getLocalOrgName(UserInfo.getOrganizationId()); 
        List<Org_Credential_Location_Mapping__mdt> oclList = new List<Org_Credential_Location_Mapping__mdt>();
        oclList = [select id, DeveloperName, UserName__c, OrgName__c 
                   from Org_Credential_Location_Mapping__mdt  ];                                           
        List<CF_Organization__mdt> orgList = [Select isActive__c, OrgId__c, OrgName__c, OrgNamedCred__c
                                              From CF_Organization__mdt]; 
        String uname ;                                                                                
        for(Org_Credential_Location_Mapping__mdt ocl : oclList){
            if(ocl.OrgName__c != localOrgName){
               uname = ocl.UserName__c;
            }
        }
        //Mock callouts
        IntegrationCredentialHttp_Mock fakeResp = 
        new IntegrationCredentialHttp_Mock(200,'OK', '{"credentialUpdates":[{"status":"Success","message":"Password rotation at Environment variable FDL_ev","accountName":"TLRVY13TWT"}]}',null);       
        Test.setMock(HttpCalloutMock.class, fakeResp);  
        
        Test.setMock(WebServiceMock.class, new IntegrationCredentialWebService_Mock());        
        
        String jsonRequest = '{"credentials": [{  "accountName": "' + uname + '",   "newPassword": "pass19"  }]}' ;
        System.debug('========> jsonRequest in remote method' + jsonRequest);
        Test.startTest();  
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IntegrationCredentialService';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonRequest);
        RestContext.request = req;
        RestContext.response = res;
        IntegrationCredentialService.doPost(); 
        Test.stopTest();
    }
    
    public static testMethod void testCallout(){
        String localOrgName = getLocalOrgName(UserInfo.getOrganizationId());
        List<Org_Credential_Location_Mapping__mdt> oclList = new List<Org_Credential_Location_Mapping__mdt>();
        oclList = [select id, DeveloperName, UserName__c, OrgName__c 
                   from Org_Credential_Location_Mapping__mdt  ];                                           
        List<CF_Organization__mdt> orgList = [Select isActive__c, OrgId__c, OrgName__c, OrgNamedCred__c
                                              From CF_Organization__mdt]; 
        String uname ;                                                                                
        for(Org_Credential_Location_Mapping__mdt ocl : oclList){
            if(ocl.OrgName__c != localOrgName){
               uname = ocl.UserName__c;
            }
        }  
        IntegrationCredentialService.Credential crdTst = new IntegrationCredentialService.Credential();
        Map<Integer, IntegrationCredentialService.Credential> credMap = new Map<Integer, IntegrationCredentialService.Credential>();  
        crdTst.isValid = true;
        crdTst.authProvider = 'Salesforce';
        crdTst.accountName= uname;
        crdTst.newPassword = 'passwordnew';
        crdTst.orgName = 'CD';
        crdTst.locationType = 'Environment variable';
        crdTst.locationName ='Pega';
        Integer i =1;
        credMap.put(i,crdTst );  
        System.debug('=====> credMap testmethod' + credMap);
        CF_Organization__mdt cfVar =   [Select isActive__c, OrgId__c, OrgName__c, OrgNamedCred__c
                                         From CF_Organization__mdt limit 1];
        String namedCred = cfVar.OrgNamedCred__c;
        Integer keyOffVal = 100;
        Test.startTest();   
        IntegrationCredentialHttp_Mock fakeResp = 
        new IntegrationCredentialHttp_Mock(200,'OK', '{"credentialUpdates":[{"status":"Success","message":"Password rotation at Environment variable FDL_ev","accountName":"TLRVY13TWT"}]}',null);                                                                
        Test.setMock(HttpCalloutMock.class, fakeResp);   
        System.debug('====> value of doRemoteCallout method' +IntegrationCred_Remote_Queue.doRemoteCallout(credMap, namedCred , keyOffVal ));
        Test.stopTest();       
    }
    
    public static testMethod void testUpdateEnvVar(){
        String localOrgName = getLocalOrgName(UserInfo.getOrganizationId()); 
        List<Org_Credential_Location_Mapping__mdt> oclList = new List<Org_Credential_Location_Mapping__mdt>();
        oclList = [select id, DeveloperName, UserName__c, OrgName__c 
                   from Org_Credential_Location_Mapping__mdt 
                   where locationType__c = 'Environment Variable'  ];                                       
        List<CF_Organization__mdt> orgList = [Select isActive__c, OrgId__c, OrgName__c, OrgNamedCred__c
                                              From CF_Organization__mdt];
        String uname ;                                                                                
        for(Org_Credential_Location_Mapping__mdt ocl : oclList){
            if(ocl.OrgName__c == localOrgName){
               uname = ocl.UserName__c;
            }
        }  
         IntegrationCredentialHttp_Mock fakeResp = 
        new IntegrationCredentialHttp_Mock(200,'OK', '{"credentialUpdates":[{"status":"Success","message":"Password rotation at Environment variable FDL_ev","accountName":"TLRVY13TWT"}]}',null);       
        Test.setMock(HttpCalloutMock.class, fakeResp);  
        
        Test.setMock(WebServiceMock.class, new IntegrationCredentialWebService_Mock());        
        String jsonRequest = '{"credentials": [{  "accountName": "' + uname + '",   "newPassword": "pass19"  }]}' ;
        System.debug('======> jsonRequest in env method' + jsonRequest);
        Test.startTest();    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IntegrationCredentialService';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonRequest);
        RestContext.request = req;
        RestContext.response = res;
        IntegrationCredentialService.doPost(); 
        Test.stopTest();        
    } 
    
    public static string getLocalOrgName(Id id) {
        String localOrg = 'Default';
        List<CF_Organization__mdt> orgList = [
            Select isActive__c, OrgId__c, OrgName__c, OrgNamedCred__c
                From CF_Organization__mdt Where OrgId__c = :id];
        if (orgList != null && !orgList.isEmpty()){
            localOrg = orgList[0].OrgName__c; 
        }
        System.debug('==>localOrgName: '+localOrg);
        return localOrg;    
    }
    
    public static testMethod void testUpdateUser(){
        String localOrgName = getLocalOrgName(UserInfo.getOrganizationId());
        List<Org_Credential_Location_Mapping__mdt> oclList = new List<Org_Credential_Location_Mapping__mdt>();
        oclList = [select id, DeveloperName, UserName__c, OrgName__c 
                   from Org_Credential_Location_Mapping__mdt 
                   where authProvider__c = 'Salesforce'  ];                                            
        List<CF_Organization__mdt> orgList = [Select isActive__c, OrgId__c, OrgName__c, OrgNamedCred__c
                                              From CF_Organization__mdt];
        String uname ;                                                                                
        for(Org_Credential_Location_Mapping__mdt ocl : oclList){
            if(ocl.OrgName__c == localOrgName){
               uname = ocl.UserName__c;
            }
        } 
        IntegrationCredentialHttp_Mock fakeResp = 
        new IntegrationCredentialHttp_Mock(200,'OK', '{"credentialUpdates":[{"status":"Success","message":"Password rotation at Salesforce process user","accountName":"infabi250.process@carefirst.com.int"}]}',null);       
        Test.setMock(HttpCalloutMock.class, fakeResp);  
        
        Test.setMock(WebServiceMock.class, new IntegrationCredentialWebService_Mock()); 
        String jsonRequest = '{"credentials": [{  "accountName": "' + uname + '",   "newPassword": "pass19"  }]}' ;
        System.debug('======> jsonRequest in user method' + jsonRequest);
        Test.startTest();    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/IntegrationCredentialService';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jsonRequest);
        RestContext.request = req;
        RestContext.response = res;
        IntegrationCredentialService.doPost(); 
        Test.stopTest();
            
    } 
    
}