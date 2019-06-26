/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class BrokerHubServiceNewTest {
    
    static testMethod void BrokerHubServicenewunitTest1() {    
        Test.startTest();
        String moduleName = 'BH_EndPoint';
        String environmentCommonModuleName = 'Common';
        String CertificateName = 'BH_ClientCertificateName';
        String EmailAddress = 'SFDC_Support_Email';
        String environmentVariableName_bhPortalSupportEmailAddress = 'BH_Support_Email';
        String environmentVariableName_bhEndPointURL = 'BH_EndPoint';
        String environmentVariableName_bhClientCertificateName = 'BH_ClientCertificateName';
        String environmentVariableName_bhRequestTimeout = 'RequestTimeout';
        List<EnvironmentVariable__c> vars = new List<EnvironmentVariable__c> ();
        
        EnvironmentVariable__c v1 = new EnvironmentVariable__c();
        v1.Module__c=moduleName;
        v1.Variable_Name__c= moduleName;
        v1.Value__c='v1Value';
        v1.Is_Required__c=true;
        v1.Is_Editable__c=true;
        v1.IsEncrypted__c=true;
        vars.add(v1);
        
        EnvironmentVariable__c v2 = new EnvironmentVariable__c();
        v2.Module__c = moduleName;
        v2.Variable_Name__c= moduleName;
        v2.Value__c = 'v2Value';
        v2.Is_Required__c=true;
        v2.Is_Editable__c=true;
        v2.isEncrypted__c=false;
        vars.add(v2);
        
        EnvironmentVariable__c v3 = new EnvironmentVariable__c();
        v3.Module__c = CertificateName;
        v3.Variable_Name__c= CertificateName;
        v3.Value__c = 'v3Value';
        v3.Is_Required__c=true;
        v3.Is_Editable__c=true;
        v3.isEncrypted__c=false; 
        vars.add(v3);
        
        EnvironmentVariable__c v4 = new EnvironmentVariable__c();
        v4.Module__c = EmailAddress ;
        v4.Variable_Name__c= EmailAddress ;
        v4.Value__c = 'v4Value';
        v4.Is_Required__c=true;
        v4.Is_Editable__c=true;
        v4.isEncrypted__c=false; 
        vars.add(v4);
        
        EnvironmentVariable__c v5 = new EnvironmentVariable__c();
        v5.Module__c = environmentVariableName_bhPortalSupportEmailAddress ;
        v5.Variable_Name__c= environmentVariableName_bhPortalSupportEmailAddress ;
        v5.Value__c = 'v5Value';
        v5.Is_Required__c=true;
        v5.Is_Editable__c=true;
        v5.isEncrypted__c=false;
        vars.add(v5); 
        
        EnvironmentVariable__c v6 = new EnvironmentVariable__c();
        v6.Module__c = environmentVariableName_bhEndPointURL ;
        v6.Variable_Name__c= environmentVariableName_bhEndPointURL ;
        v6.Value__c = 'v6Value';
        v6.Is_Required__c=true;
        v6.Is_Editable__c=true;
        v6.isEncrypted__c=false;
        vars.add(v6); 
        
        EnvironmentVariable__c v7 = new EnvironmentVariable__c();
        v7.Module__c = environmentVariableName_bhClientCertificateName ;
        v7.Variable_Name__c= environmentVariableName_bhClientCertificateName ;
        v7.Value__c = 'v7Value';
        v7.Is_Required__c=true;
        v7.Is_Editable__c=true;
        v7.isEncrypted__c=false; 
        vars.add(v7);
        
        EnvironmentVariable__c v8 = new EnvironmentVariable__c();
        v8.Module__c = environmentVariableName_bhRequestTimeout ;
        v8.Variable_Name__c= environmentVariableName_bhRequestTimeout ;
        v8.Value__c = 'v8Value';
        v8.Is_Required__c=true;
        v8.Is_Editable__c=true;
        v8.isEncrypted__c=false;
        vars.add(v8);
        
        
        insert vars;
        Map<String,EnvironmentVariable__c> retrieveVars1 = EnvironmentVariables.getEnvironmentVariablesForModule(moduleName);
        Map<String,EnvironmentVariable__c> retrieveVars2 = EnvironmentVariables.getEnvironmentVariablesForModule(CertificateName );
        Map<String,EnvironmentVariable__c> retrieveVars3 = EnvironmentVariables.getEnvironmentVariablesForModule(environmentVariableName_bhRequestTimeout );
        Map<String,EnvironmentVariable__c> retrieveVars4 = EnvironmentVariables.getEnvironmentVariablesForModule(environmentVariableName_bhClientCertificateName );
        Map<String,EnvironmentVariable__c> retrieveVars5 = EnvironmentVariables.getEnvironmentVariablesForModule(environmentVariableName_bhEndPointURL );
        Map<String,EnvironmentVariable__c> retrieveVars6 = EnvironmentVariables.getEnvironmentVariablesForModule(moduleName);
        Map<String,EnvironmentVariable__c> retrieveVars7 = EnvironmentVariables.getEnvironmentVariablesForModule(moduleName);
                
        Date firstDayOfMonth = System.today().toStartOfMonth();
        list<Opportunity> lstopp=new list<Opportunity>();
        Opportunity objOpp=new Opportunity();
        objOpp.Name='TestOppertunity';
        objOpp.CloseDate=System.today().addMonths(1);            
        objOpp.Contract_End_Date__c=firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
        objOpp.StageName='Proposal';
        objOpp.System__c='Facets';
        objOpp.Won_Lost_Reason__c='Acquisition';
        objOpp.FullServiceProducer__c='Direct';
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1); 
        //testOpp.OwnerId = oldUser.Id;
        objOpp.CloseDate = closedDate;
        objOpp.Effective_Date__c = effectiveDate;       
        insert objOpp;        
        lstopp.add(objOpp);  
        
        Opportunity_Contact_Role__c Objoppcr=new Opportunity_Contact_Role__c();
        Objoppcr.Opportunity__c=objOpp.id;
        Objoppcr.Role__c='Primary Broker';
        Objoppcr.Primary__c=true;
        Objoppcr.Effective_Date__c=effectiveDate;
        //Objoppcr.End_Date__c=System.today().addMonths(1); 
        Objoppcr.End_Date__c=effectiveDate.addDays(-1); 
        insert Objoppcr;
         
        Partner__c Objpart=new Partner__c();
        Objpart.Opportunity__c=objOpp.id;
        Objoppcr.Role__c='Primary Broker';
        Objoppcr.Primary__c=true;  
        Objpart.Effective_Date__c= effectiveDate;
        insert Objpart;    
        
        FSP_GP__c fsp_gp=new FSP_GP__c();
        fsp_gp.Opportunity__c=objOpp.Id;
        fsp_gp.FSP_GP__C='FSP';
        fsp_gp.Partner__c='BenefitMall';
        fsp_gp.Effective_Date__c=effectiveDate;
        fsp_gp.End_Date__c=date.newinstance(2016, 10, 14);
        Insert fsp_gp;
            
        BrokerHubServiceNew objBrokerh=new BrokerHubServiceNew();
        BrokerHubServiceNew.reloadConfigurationFromEnvironmentVariables();
        BrokerHubServiceNew.loadConfigurationFromEnvironmentVariables();
        BrokerHubServiceNew.processSoldOpportunityDetails(lstopp);
        BrokerHubServiceNew.buildBrokerHubSoldOpportunityRequestData(lstopp,false);
        //BrokerHubServiceNew.getService();
        //Map<String, EnvironmentVariable__c> envVarMap = new Map<String,EnvironmentVariable__c>();
        //EnvironmentVariables.getEnvironmentVariablesForModule(moduleName, retrieveVars1 );
        Test.stopTest();
        }
        
    static testMethod void BrokerHubServicenewunitTest2() {
        //Test.startTest();
        
         Account acc = new Account();
        acc.name = 'Test Acc';
        acc.Sic = '7377';
        acc.Status__c = 'Active';
        acc.Facets_Account_Number__c = '0X84';
        acc.RecType_Facets_Account_Number__c = '2-50_0X84s';
        insert acc;
               
        Date firstDayOfMonth = System.today().toStartOfMonth();
        list<Opportunity> lstopp=new list<Opportunity>();
        Opportunity objOpp=new Opportunity();
        objOpp.AccountId = acc.id;
        objOpp.Name='TestOppertunity';
        objOpp.CloseDate=System.today().addMonths(1);            
        objOpp.Contract_End_Date__c=firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
        objOpp.StageName='Proposal';//'Sold';//new change 9Nov16
        objOpp.System__c='Nasco';
        objOpp.NASCO_Acct_ID__c='12345,23456,34567,45678';
        objOpp.Incumbent_Successor__c='ACO';
        objOpp.Won_Lost_Reason__c='Acquisition';
        objOpp.FullServiceProducer__c='Direct';
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1); 
        //testOpp.OwnerId = oldUser.Id;
        objOpp.CloseDate = closedDate;
        objOpp.Effective_Date__c = effectiveDate;       
        insert objOpp;        
        //lstopp.add(objOpp);//new change 9Nov16
        
        //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=objOpp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        
        Test.startTest();
        objOpp.StageName = 'Sold';
        objOpp.Probability = Decimal.valueOf('100');
        objOpp.Won_Lost_Reason__c = 'Acquisition';
        objOpp.Incumbent_Successor__c = 'Aetna';
        update objOpp;
        lstopp.add(objOpp);
        //end new change 9Nov16
        
        Opportunity_Contact_Role__c Objoppcr=new Opportunity_Contact_Role__c();
        Objoppcr.Opportunity__c=objOpp.id;
        Objoppcr.Role__c='Administrator';
        Objoppcr.Primary__c=true;
        Objoppcr.Effective_Date__c=effectiveDate;
        Objoppcr.End_Date__c=System.today().addMonths(1);  
        insert Objoppcr;
         
        Partner__c Objpart=new Partner__c();
        Objpart.Opportunity__c=objOpp.id;
        Objoppcr.Role__c='Broker';
        Objoppcr.Primary__c=true;  
        Objpart.Effective_Date__c= effectiveDate; 
        insert Objpart;   
        
       
        FSP_GP__c fsp_gp=new FSP_GP__c();
        fsp_gp.Opportunity__c=objOpp.Id;
        fsp_gp.FSP_GP__C='GP';
        fsp_gp.Partner__c='CBIZ';
        fsp_gp.Effective_Date__c=effectiveDate;
        fsp_gp.End_Date__c=date.newinstance(2016, 10, 14);
        Insert fsp_gp;
        
        
        
        BrokerHubServiceNew objBrokerh=new BrokerHubServiceNew();
        BrokerHubServiceNew.loadConfigurationFromEnvironmentVariables();
        
        BrokerHubServiceNew.processSoldOpportunityDetails(lstopp);
       // BrokerHubServiceNew.buildBrokerHubSoldOpportunityRequestData(lstopp);
        //BrokerHubServiceNew.getService();
        //Map<String, EnvironmentVariable__c> envVarMap = new Map<String,EnvironmentVariable__c>();
        //EnvironmentVariables.getEnvironmentVariablesForModule(moduleName, retrieveVars1 );
        Test.stopTest();
    }
    
    static testMethod void BrokerHubServicenewunitTest3() {
        Test.startTest();
        BrokerHubServiceProxyNew.GPAgencyInfo_element  agency = new BrokerHubServiceProxyNew.GPAgencyInfo_element();
        BrokerHubServiceProxyNew.accountUpdateRequest_element accUpdate = new BrokerHubServiceProxyNew.accountUpdateRequest_element ();
        BrokerHubServiceProxyNew.brokerAgencyInfo_element agencyInfo = new BrokerHubServiceProxyNew.brokerAgencyInfo_element ();
        BrokerHubServiceProxyNew.manageUserRequest_element managerUpdate = new BrokerHubServiceProxyNew.manageUserRequest_element ();
        BrokerHubServiceProxyNew.manageUserResponse_element userRes = new BrokerHubServiceProxyNew.manageUserResponse_element ();
        BrokerHubServiceProxyNew.brokerOnRecord_element element = new BrokerHubServiceProxyNew.brokerOnRecord_element ();
        BrokerHubServiceProxyNew.group_element grpElement = new BrokerHubServiceProxyNew.group_element ();
        BrokerHubServiceProxyNew.accountUpdateResponse_element updateRes = new BrokerHubServiceProxyNew.accountUpdateResponse_element ();
        BrokerHubServiceProxyNew.FSPAgencyInfo_element fancyElement = new BrokerHubServiceProxyNew.FSPAgencyInfo_element ();
        BrokerHubServiceProxyNew.soldAccountUpdateData_element dataElement = new BrokerHubServiceProxyNew.soldAccountUpdateData_element ();
        BrokerHubServiceProxyNew.brokerAgencyDetails_element details = new BrokerHubServiceProxyNew.brokerAgencyDetails_element ();
        BrokerHubServiceProxyNew.accountInformation_element infoElement = new BrokerHubServiceProxyNew.accountInformation_element  ();
        BrokerHubServiceProxyNew.soldAccountUpdateResponse_element accResElement = new BrokerHubServiceProxyNew.soldAccountUpdateResponse_element ();
        BrokerHubServiceProxyNew.attribute_element attElement = new BrokerHubServiceProxyNew.attribute_element ();
        BrokerHubServiceProxyNew.attributes_element attsElement = new BrokerHubServiceProxyNew.attributes_element ();
        BrokerHubServiceProxyNew.SalesForceEndpoint1 endPoint = new BrokerHubServiceProxyNew.SalesForceEndpoint1 ();
        BrokerHubServiceProxyNew.SOAPHeader_element soapHeader = new BrokerHubServiceProxyNew.SOAPHeader_element ();
        BrokerHubServiceProxyNew.SourceSpecificFields_element  sourceElement= new BrokerHubServiceProxyNew.SourceSpecificFields_element ();
        BrokerHubServiceProxyNew.SystemUnavailableFault_element unavailable= new BrokerHubServiceProxyNew.SystemUnavailableFault_element ();
        BrokerHubServiceProxyNew.DataNotFound_element notFound= new BrokerHubServiceProxyNew.DataNotFound_element();
        BrokerHubServiceProxyNew.AuthenticationException_element exceptionEle = new BrokerHubServiceProxyNew.AuthenticationException_element ();
        BrokerHubServiceProxyNew.InputDataInvalid_element inputInvalid = new BrokerHubServiceProxyNew.InputDataInvalid_element ();
        BrokerHubServiceProxyNew.SourceSystemInvalid_element sourceInvElement = new BrokerHubServiceProxyNew.SourceSystemInvalid_element();
        BrokerHubServiceProxyNew.fault_element fault= new BrokerHubServiceProxyNew.fault_element ();
        BrokerHubServiceProxyNew.SystemTimeOutException_element tomeOut= new BrokerHubServiceProxyNew.SystemTimeOutException_element ();
        BrokerHubServiceProxyNew.faultType_element faultType = new BrokerHubServiceProxyNew.faultType_element ();
        BrokerHubServiceProxyNew.DefaultFault_element defFault = new BrokerHubServiceProxyNew.DefaultFault_element();
        BrokerHubServiceProxyNew.PackageNotCompiled_element packageExc = new BrokerHubServiceProxyNew.PackageNotCompiled_element ();
        BrokerHubServiceProxyNew.ApplicationException_element  appExcep = new BrokerHubServiceProxyNew.ApplicationException_element ();
        
        Test.stopTest();
    }
    
    static testMethod void BrokerHubServicenewunitTest4() {
        //Test.startTest();
        Account acc = new Account();
        acc.name = 'Test Acc';
        acc.Sic = '7377';
        acc.Status__c = 'Active';
        acc.Facets_Account_Number__c = '0X84';
        acc.RecType_Facets_Account_Number__c = '2-50_0X84s';
        insert acc;
               
        Date firstDayOfMonth = System.today().toStartOfMonth();
        list<Opportunity> lstopp=new list<Opportunity>();
        
        Opportunity objOpp=new Opportunity();
        objOpp.AccountId = acc.id;
        objOpp.Name='TestOppertunity';
        objOpp.CloseDate=System.today().addMonths(1);            
        objOpp.Contract_End_Date__c=firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
        objOpp.StageName='Proposal';//'Sold';//new change 9Nov16
        objOpp.System__c='Nasco';
        objOpp.NASCO_Acct_ID__c='12345,23456,34567,45678';
        objOpp.Incumbent_Successor__c='ACO';
        objOpp.Won_Lost_Reason__c='Acquisition';
        objOpp.FullServiceProducer__c='Direct';
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1); 
        //testOpp.OwnerId = oldUser.Id;
        objOpp.CloseDate = closedDate;
        objOpp.Effective_Date__c = effectiveDate;       
        insert objOpp;        
        //lstopp.add(objOpp);//new change 9Nov16
        
        //start new change 9Nov16
        Product2 pro2 = new Product2(Product_Line__c='POS',Family='POS',Name='BC Advantage',Product_category__c='Medical', isActive=true);
        insert pro2;
        PricebookEntry pbe2 =new PricebookEntry(unitprice=2,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                         isActive=true,UseStandardPrice = false);
        insert pbe2;
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, OpportunityId=objOpp.Id,UnitPrice=3,PriceBookEntryId=pbe2.Id,Product_Sold__c=true);
        insert OPplineitem2;
        Test.startTest();
        objOpp.StageName = 'Sold';
        objOpp.Probability = Decimal.valueOf('100');
        objOpp.Won_Lost_Reason__c = 'Acquisition';
        objOpp.Incumbent_Successor__c = 'Aetna';
        update objOpp;
        lstopp.add(objOpp);
        //end new change 9Nov16     
        
        Opportunity_Contact_Role__c Objoppcr=new Opportunity_Contact_Role__c();
        Objoppcr.Opportunity__c=objOpp.id;
        Objoppcr.Role__c='Consultant';
        Objoppcr.Primary__c=false;
        Objoppcr.Effective_Date__c=null;
        Objoppcr.End_Date__c=System.today().addMonths(1);  
        insert Objoppcr;
         
        Partner__c Objpart=new Partner__c();
        Objpart.Opportunity__c=objOpp.id;
        Objpart.Role__c='Consultant';
        Objpart.Primary__c=false;  
        Objpart.Effective_Date__c= null; 
        insert Objpart;   
        
        
        FSP_GP__c fsp_gp=new FSP_GP__c();
        fsp_gp.Opportunity__c=objOpp.Id;
        fsp_gp.FSP_GP__C='GP';
        fsp_gp.Partner__c='CBIZ';
        fsp_gp.Effective_Date__c=effectiveDate;
        fsp_gp.End_Date__c=date.newinstance(2016, 10, 14);
        Insert fsp_gp;

        
        BrokerHubServiceNew objBrokerh=new BrokerHubServiceNew();
        BrokerHubServiceNew.loadConfigurationFromEnvironmentVariables();
        BrokerHubServiceNew.processSoldOpportunityDetails(lstopp);
       // BrokerHubServiceNew.buildBrokerHubSoldOpportunityRequestData(lstopp);
        
        //BrokerHubServiceNew.getService();
        //Map<String, EnvironmentVariable__c> envVarMap = new Map<String,EnvironmentVariable__c>();
        //EnvironmentVariables.getEnvironmentVariablesForModule(moduleName, retrieveVars1 );
        Test.stopTest();
    }

    static testMethod void BrokerHubServicenewunitTest5(){
        Test.startTest();
        BrokerHubServiceNew objBrokerh=new BrokerHubServiceNew();
        //Changes for Method loadConfigurationFrom EnvironmentVariable() begins
          
        BrokerHubServiceNew.loadConfigurationFromEnvironmentVariables();
        //Changes for Method getservice() begins
        BrokerHubServiceProxyNew.SalesForceEndpoint1  service = new BrokerHubServiceProxyNew.SalesForceEndpoint1();
        BrokerHubServiceNew.isInitialized=true;
        service=BrokerHubServiceNew.getService();
        //Changes for Method getservice() ends
        //Changes for Method sendBrokerHubSoldOppsRequestsInFuture() begins
        BrokerHubSoldOpportunityRequestNew hub=new BrokerHubSoldOpportunityRequestNew();
        String str=JSON.serialize(hub);

        BrokerHubServiceNew.sendBrokerHubSoldOppsRequestsInFuture(str);
        //Changes for Method sendBrokerHubSoldOppsRequestsInFuture() ends
        Test.stopTest();
        
    }
        static testMethod void BrokerHubServicenewunitTest6() {    
        Test.startTest();
        String moduleName = 'BH_EndPoint';
        String environmentCommonModuleName = 'Common';
        String CertificateName = 'BH_ClientCertificateName';
        String EmailAddress = 'SFDC_Support_Email';
        String environmentVariableName_bhPortalSupportEmailAddress = 'BH_Support_Email';
        String environmentVariableName_bhEndPointURL = 'BH_EndPoint';
        String environmentVariableName_bhClientCertificateName = 'BH_ClientCertificateName';
        String environmentVariableName_bhRequestTimeout = 'RequestTimeout';
        List<EnvironmentVariable__c> vars = new List<EnvironmentVariable__c> ();
        
        EnvironmentVariable__c v1 = new EnvironmentVariable__c();
        v1.Module__c=moduleName;
        v1.Variable_Name__c= moduleName;
        v1.Value__c='v1Value';
        v1.Is_Required__c=true;
        v1.Is_Editable__c=true;
        v1.IsEncrypted__c=true;
        vars.add(v1);
        
        EnvironmentVariable__c v2 = new EnvironmentVariable__c();
        v2.Module__c = moduleName;
        v2.Variable_Name__c= moduleName;
        v2.Value__c = 'v2Value';
        v2.Is_Required__c=true;
        v2.Is_Editable__c=true;
        v2.isEncrypted__c=false;
        vars.add(v2);
        
        EnvironmentVariable__c v3 = new EnvironmentVariable__c();
        v3.Module__c = CertificateName;
        v3.Variable_Name__c= CertificateName;
        v3.Value__c = 'v3Value';
        v3.Is_Required__c=true;
        v3.Is_Editable__c=true;
        v3.isEncrypted__c=false; 
        vars.add(v3);
        
        EnvironmentVariable__c v4 = new EnvironmentVariable__c();
        v4.Module__c = EmailAddress ;
        v4.Variable_Name__c= EmailAddress ;
        v4.Value__c = 'v4Value';
        v4.Is_Required__c=true;
        v4.Is_Editable__c=true;
        v4.isEncrypted__c=false; 
        vars.add(v4);
        
        EnvironmentVariable__c v5 = new EnvironmentVariable__c();
        v5.Module__c = environmentVariableName_bhPortalSupportEmailAddress ;
        v5.Variable_Name__c= environmentVariableName_bhPortalSupportEmailAddress ;
        v5.Value__c = 'v5Value';
        v5.Is_Required__c=true;
        v5.Is_Editable__c=true;
        v5.isEncrypted__c=false;
        vars.add(v5); 
        
        EnvironmentVariable__c v6 = new EnvironmentVariable__c();
        v6.Module__c = environmentVariableName_bhEndPointURL ;
        v6.Variable_Name__c= environmentVariableName_bhEndPointURL ;
        v6.Value__c = 'v6Value';
        v6.Is_Required__c=true;
        v6.Is_Editable__c=true;
        v6.isEncrypted__c=false;
        vars.add(v6); 
        
        EnvironmentVariable__c v7 = new EnvironmentVariable__c();
        v7.Module__c = environmentVariableName_bhClientCertificateName ;
        v7.Variable_Name__c= environmentVariableName_bhClientCertificateName ;
        v7.Value__c = 'v7Value';
        v7.Is_Required__c=true;
        v7.Is_Editable__c=true;
        v7.isEncrypted__c=false; 
        vars.add(v7);
        
        EnvironmentVariable__c v8 = new EnvironmentVariable__c();
        v8.Module__c = environmentVariableName_bhRequestTimeout ;
        v8.Variable_Name__c= environmentVariableName_bhRequestTimeout ;
        v8.Value__c = 'v8Value';
        v8.Is_Required__c=true;
        v8.Is_Editable__c=true;
        v8.isEncrypted__c=false;
        vars.add(v8);
        
        
        insert vars;
        Map<String,EnvironmentVariable__c> retrieveVars1 = EnvironmentVariables.getEnvironmentVariablesForModule(moduleName);
        Map<String,EnvironmentVariable__c> retrieveVars2 = EnvironmentVariables.getEnvironmentVariablesForModule(CertificateName );
        Map<String,EnvironmentVariable__c> retrieveVars3 = EnvironmentVariables.getEnvironmentVariablesForModule(environmentVariableName_bhRequestTimeout );
        Map<String,EnvironmentVariable__c> retrieveVars4 = EnvironmentVariables.getEnvironmentVariablesForModule(environmentVariableName_bhClientCertificateName );
        Map<String,EnvironmentVariable__c> retrieveVars5 = EnvironmentVariables.getEnvironmentVariablesForModule(environmentVariableName_bhEndPointURL );
        Map<String,EnvironmentVariable__c> retrieveVars6 = EnvironmentVariables.getEnvironmentVariablesForModule(moduleName);
        Map<String,EnvironmentVariable__c> retrieveVars7 = EnvironmentVariables.getEnvironmentVariablesForModule(moduleName);
         
          // BrokerHubServiceNew.effDtPrimary = date.newinstance(2010, 3, 1);   
        Date firstDayOfMonth = System.today().toStartOfMonth();
        list<Opportunity> lstopp=new list<Opportunity>();
        Opportunity objOpp=new Opportunity();
        objOpp.Name='TestOppertunity';
        objOpp.CloseDate=System.today().addMonths(1);            
        objOpp.Contract_End_Date__c=firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
        objOpp.StageName='Proposal';
        objOpp.System__c='LuminX';
        objOpp.Won_Lost_Reason__c='Acquisition';
        objOpp.FullServiceProducer__c='Direct';
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1); 
        //testOpp.OwnerId = oldUser.Id;
        objOpp.CloseDate = closedDate;
        objOpp.Effective_Date__c = effectiveDate;       
        insert objOpp;        
        lstopp.add(objOpp);  
        
        Opportunity_Contact_Role__c Objoppcr=new Opportunity_Contact_Role__c();
        Objoppcr.Opportunity__c=objOpp.id;
        Objoppcr.Role__c='Primary Broker';
        Objoppcr.Primary__c=false;
        Objoppcr.Effective_Date__c=effectiveDate;
        //Objoppcr.End_Date__c=System.today().addMonths(1); 
        Objoppcr.End_Date__c=effectiveDate.addDays(-1); 
        insert Objoppcr;

        Partner__c Objpart=new Partner__c();
        Objpart.Opportunity__c=objOpp.id;
        Objpart.Role__c='Broker';
        Objpart.Primary__c=true;  
        Objpart.Effective_Date__c= effectiveDate;
        Objpart.End_Date__c=date.newinstance(2016, 10, 14);
        insert Objpart;    
        
        FSP_GP__c fsp_gp=new FSP_GP__c();
        fsp_gp.Opportunity__c=objOpp.Id;
        fsp_gp.FSP_GP__C='FSP';
        fsp_gp.Partner__c='Benefit Design Group, LLC';
        fsp_gp.Effective_Date__c=effectiveDate;
        fsp_gp.End_Date__c=date.newinstance(2016, 10, 14);
        Insert fsp_gp;
            
        BrokerHubServiceNew.buildBHServiceSoldOppsRequestData(lstopp);
        BrokerHubServiceNew.buildBrokerHubSoldOpportunityRequestData(lstopp);
        
        //BrokerHubServiceNew.getService();
        //Map<String, EnvironmentVariable__c> envVarMap = new Map<String,EnvironmentVariable__c>();
        //EnvironmentVariables.getEnvironmentVariablesForModule(moduleName, retrieveVars1 );
        Test.stopTest();
        }
       
     static testMethod void BrokerHubServicenewunitTest7() {    
        Test.startTest();
        
          // BrokerHubServiceNew.effDtPrimary = date.newinstance(2010, 3, 1);   
        Date firstDayOfMonth = System.today().toStartOfMonth();
        list<Opportunity> lstopp=new list<Opportunity>();
        Opportunity objOpp=new Opportunity();
        objOpp.Name='TestOppertunity';
        objOpp.CloseDate=System.today().addMonths(1);            
        objOpp.Contract_End_Date__c=firstDayOfMonth.addDays(Date.daysInMonth(firstDayOfMonth.year(), firstDayOfMonth.month()) - 1);
        objOpp.StageName='Proposal';
        objOpp.System__c='LuminX';
        objOpp.Won_Lost_Reason__c='Acquisition';
        objOpp.FullServiceProducer__c='Direct';
        Date closedDate = date.newinstance(1900, 2, 15);
        Date effectiveDate = date.newinstance(2010, 3, 1); 
        //testOpp.OwnerId = oldUser.Id;
        objOpp.CloseDate = closedDate;
        objOpp.Effective_Date__c = effectiveDate;       
        insert objOpp;        
        lstopp.add(objOpp);  
        
        Opportunity_Contact_Role__c Objoppcr=new Opportunity_Contact_Role__c();
        Objoppcr.Opportunity__c=objOpp.id;
        Objoppcr.Role__c='Primary Broker';
        Objoppcr.Primary__c=false;
        Objoppcr.Effective_Date__c=effectiveDate;
        //Objoppcr.End_Date__c=System.today().addMonths(1); 
        Objoppcr.End_Date__c=effectiveDate.addDays(-1); 
        insert Objoppcr;

        Partner__c Objpart=new Partner__c();
        Objpart.Opportunity__c=objOpp.id;
        Objpart.Role__c='Broker';
        Objpart.Primary__c=true;  
        Objpart.Effective_Date__c= effectiveDate;
        insert Objpart;    
        
        FSP_GP__c fsp_gp=new FSP_GP__c();
        fsp_gp.Opportunity__c=objOpp.Id;
        fsp_gp.FSP_GP__C='GP';
        fsp_gp.Partner__c='Benefit Design Group, LLC';
        fsp_gp.Effective_Date__c=effectiveDate;
        fsp_gp.End_Date__c=date.newinstance(2016, 10, 14);
        Insert fsp_gp;

        BrokerHubServiceNew.buildBHServiceSoldOppsRequestData(lstopp);
        BrokerHubServiceNew.buildBrokerHubSoldOpportunityRequestData(lstopp);
        Test.stopTest();
        }
       
     
 }