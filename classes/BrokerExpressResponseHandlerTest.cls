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
private class BrokerExpressResponseHandlerTest {

    /**
     * Tests the parsing logic for a successful response
     */
    static testMethod void successResponseParserTest() {
        Test.startTest();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall';
        OPP.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
//TPB - 12/19/2013        
        Date effectiveDate = opp.CloseDate.addDays(35);        
        opp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = opp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        opp.Contract_End_Date__c = contractEndDate;
                   
        insert opp;

        // Create a look up entry to simulate a successful transaction
        BE_Prospect_Lookup__c transactionLog = new BE_Prospect_Lookup__c();
        transactionLog.Transaction_Id__c = String.valueOf(DateTime.now().getTime());
        transactionLog.Opportunity_ID__c = opp.Id;
        transactionLog.BE_Prospect_ID__c = '';
        insert transactionLog;

        Dom.Document successResponse = createSuccessResponse('PR-16981');
        BrokerExpressResponseHandler handler = new BrokerExpressResponseHandler(opp, '0001');

        System.assert(handler.successResponse == true);
        System.assertEquals('Test opp', opp.Name);
        System.assertEquals(null, opp.BE_Prospect_ID__c);

        // Parse the response and verify that the opp now has a BE prospect ID
        handler.parseResponse(successResponse);

        transactionLog = 
            [SELECT BE_Prospect_ID__c FROM BE_Prospect_Lookup__c 
             WHERE Id =: transactionLog.Id];

        // Verify the opportnity and look up table have the be prospect Id parsed
        System.assert(handler.successResponse == true);
        System.assertEquals('PR-16981', opp.BE_Prospect_ID__c);
        System.assertEquals('PR-16981', transactionLog.BE_Prospect_ID__c);
        Test.stopTest();
    }

    /**
     * Tests the parsing logic for a failed/errored response 
     */
    static testMethod void errorResponseParserTest() {
        Test.startTest();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall';
        OPP.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
//TPB - 12/19/2013        
        Date effectiveDate = opp.CloseDate.addDays(35);        
        opp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = opp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        opp.Contract_End_Date__c = contractEndDate;     
              
        insert opp;

        Dom.Document failureResponse = createErrorResponse();

        BrokerExpressResponseHandler handler = new BrokerExpressResponseHandler(opp, '0001');
        System.assert(handler.successResponse == true);
        handler.parseResponse(failureResponse);
        System.assert(handler.successResponse == false);
        Test.stopTest();
    }

    /**
     * Tests the parsing logic for a duplicate response 
     */
    static testMethod void duplicateResponseParserTest() {
        Test.startTest();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall';
        OPP.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
//TPB - 12/19/2013        
        Date effectiveDate = opp.CloseDate.addDays(35);        
        opp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = opp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        opp.Contract_End_Date__c = contractEndDate;      
                
        insert opp;

        Dom.Document duplicateResponse = createDuplicateResponse();

        BrokerExpressResponseHandler handler = new BrokerExpressResponseHandler(opp, '0001');
        System.assert(handler.successResponse == true);
        handler.parseResponse(duplicateResponse);
        System.assert(handler.successResponse == false);
        Test.stopTest();
    }

    /**
     * Tests the parsing logic for a multiple faults response 
     */
    static testMethod void multipleFaultsResponseParserTest() {
        Test.startTest();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall';
        OPP.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
//TPB - 12/19/2013        
        Date effectiveDate = opp.CloseDate.addDays(35);        
        opp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = opp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        opp.Contract_End_Date__c = contractEndDate;      
                
        insert opp;

        Dom.Document multipleFaultsResponse = createDuplicateAndMultipleFaultsResponse();
        Dom.Document beDownResponse = createBEDownResponse();

        BrokerExpressResponseHandler handler = new BrokerExpressResponseHandler(opp, '0001');
        System.assert(handler.successResponse == true);
        handler.parseResponse(multipleFaultsResponse);
        System.assert(handler.successResponse == false);
        Test.stopTest();
    }

    /**
     * Tests the parsing logic for a "broker express down" response 
     */
    static testMethod void brokerExpressDownResponseParserTest() {
        Test.startTest();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall';
        OPP.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
//TPB - 12/19/2013        
        Date effectiveDate = opp.CloseDate.addDays(35);        
        opp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = opp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        opp.Contract_End_Date__c = contractEndDate;      
                
        insert opp;

        Dom.Document beDownResponse = createBEDownResponse();

        BrokerExpressResponseHandler handler = new BrokerExpressResponseHandler(opp, '0001');
        System.assert(handler.successResponse == true);
        handler.parseResponse(beDownResponse);
        System.assert(handler.successResponse == false);
        Test.stopTest();
    }

    /**
     * Tests the parsing logic for an unexpected response 
     */
    static testMethod void unexpectedResponseParserTest() {
        Test.startTest();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test opp';
        opp.FullServiceProducer__c = 'BenefitMall';
        OPP.StageName = 'Proposal';
        opp.CloseDate = Date.today() + 7;
//TPB - 12/19/2013        
        Date effectiveDate = opp.CloseDate.addDays(35);        
        opp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = opp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        opp.Contract_End_Date__c = contractEndDate;      
                
        insert opp;

        Dom.Document unexpectedResponse = createUnexpectedResponse();

        BrokerExpressResponseHandler handler = new BrokerExpressResponseHandler(opp, '0001');
        System.assert(handler.successResponse == true);
        handler.parseResponse(unexpectedResponse);
        System.assert(handler.successResponse == false);
        
        handler.parseResponse(null);
        Test.stopTest();
    }


    /****************************************************************************/
    /***************************** HELPER FUNCTIONS *****************************/
    /****************************************************************************/


    public static Dom.Document createSuccessResponse(String prospectId) {
        String xml = 
            //'<?xml version="1.0" encoding="UTF-8"?>' +
            '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
                '<SOAP-ENV:Body>' +
                    '<ns0:GSAServiceResponse xmlns:ns0="http://www.carefirst.com/schemas/LoadGSA/Response.xsd">' +
                        '<ns0:ProspectId>' + prospectId + '</ns0:ProspectId>' +
                        '<ns0:StatusCode>1</ns0:StatusCode>' +
                        '<ns0:StatusDesc>Prospect Created Sucessfully with the status New</ns0:StatusDesc>' +
                    '</ns0:GSAServiceResponse>' +
                '</SOAP-ENV:Body>' +
            '</SOAP-ENV:Envelope>';
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        return doc;
    }

    private static Dom.Document createErrorResponse() {
        String xml = 
            '<?xml version="1.0" encoding="UTF-8"?>' +
            '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
                '<SOAP-ENV:Body>' +
                    '<ns0:GSAServiceResponse xmlns:ns0="http://www.carefirst.com/schemas/LoadGSA/Response.xsd">' +
                        '<ns0:Faults>' +
                            '<ns0:fault>' +
                                '<ns0:faultCode>GSA207</ns0:faultCode>' +
                                '<ns0:faultMsg>Broker Express Cannot Create Prospect Record - Tax ID for DBE/ Wholesaler cannot be same as Broker Tax ID</ns0:faultMsg>' +
                            '</ns0:fault>' +
                        '</ns0:Faults>' +
                    '</ns0:GSAServiceResponse>' +
                '</SOAP-ENV:Body>' +
            '</SOAP-ENV:Envelope>';
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        return doc;
    }

    private static Dom.Document createBEDownResponse() {
        String xml = 
            '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
                '<SOAP-ENV:Body>' +
                    '<ns0:GSAServiceResponse xmlns:ns0="http://www.carefirst.com/schemas/LoadGSA/Response.xsd">' +
                        '<ns0:Faults>' +
                            '<ns0:fault>' +
                                '<ns0:faultCode>GSA105</ns0:faultCode>' +
                                '<ns0:faultMsg>Unknown error occurred during execution - System not available</ns0:faultMsg>' +
                            '</ns0:fault>' +
                        '</ns0:Faults>' +
                    '</ns0:GSAServiceResponse>' +
                '</SOAP-ENV:Body>' +
            '</SOAP-ENV:Envelope>'; 
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        return doc;
    }

    private static Dom.Document createDuplicateResponse() {
        String xml = 
            '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
                '<SOAP-ENV:Body>' +
                    '<ns0:GSAServiceResponse xmlns:ns0="http://www.carefirst.com/schemas/LoadGSA/Response.xsd">' +
                         '<ns0:Faults>' +
                            '<ns0:fault>' +
                               '<ns0:faultCode>GSA110</ns0:faultCode>' +
                               '<ns0:faultMsg>Duplicate Transaction found in Broker Express - Transaction Id : [ 1316634394894 ]</ns0:faultMsg>' +
                            '</ns0:fault>' +
                         '</ns0:Faults>' +
                      '</ns0:GSAServiceResponse>' +
                   '</SOAP-ENV:Body>' +
                '</SOAP-ENV:Envelope>';
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        return doc;
    }

    private static Dom.Document createDuplicateAndMultipleFaultsResponse() {
        String xml = 
            '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
                '<SOAP-ENV:Body>' +
                    '<ns0:GSAServiceResponse xmlns:ns0="http://www.carefirst.com/schemas/LoadGSA/Response.xsd">' +
                         '<ns0:Faults>' +
                            '<ns0:fault>' +
                               '<ns0:faultCode>GSA110</ns0:faultCode>' +
                               '<ns0:faultMsg>Duplicate Transaction found in Broker Express - Transaction Id : [ 1316634394894 ]</ns0:faultMsg>' +
                            '</ns0:fault>' +
                            '<ns0:fault>' +
                               '<ns0:faultCode>GSA101</ns0:faultCode>' +
                               '<ns0:faultMsg>Data Invalid:  [ SourceName ,ZipCode/Zip ,ZipCode/AddOn ,Address/County ]</ns0:faultMsg>' +
                            '</ns0:fault>' +
                         '</ns0:Faults>' +
                      '</ns0:GSAServiceResponse>' +
                   '</SOAP-ENV:Body>' +
                '</SOAP-ENV:Envelope>';
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        return doc;
    }

    public static Dom.Document createUnexpectedResponse() {
        String xml = 
            '<soap:Envelope xmlns:soap="http://www.w3.org/2001/12/soap-envelope" soap:encodingStyle="http://www.w3.org/2001/12/soap-encoding">' +
                '<soap:Body xmlns:m="http://www.example.org/stock">' +
                    '<m:GetStockPriceResponse>' +
                        '<m:Price>34.5</m:Price>' +
                    '</m:GetStockPriceResponse>' +
                '</soap:Body>' +
            '</soap:Envelope>';
            /*
            //'<?xml version="1.0" encoding="UTF-8"?>' +
            '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
                '<SOAP-ENV:Unexpected>' +
                    '<ns0:SomeResponse xmlns:ns0="http://www.carefirst.com/schemas/LoadGSA/Response.xsd">' +
                        '<ns0:StatusCode>1</ns0:StatusCode>' +
                        '<ns0:StatusDesc>Prospect Created Sucessfully with the status New</ns0:StatusDesc>' +
                    '</ns0:SomeResponse>' +
                '</SOAP-ENV:Unexpected>' +
            '</SOAP-ENV:Envelope>';
            */
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        return doc;
    }


    /*
     ** OLD SUCCESS **
    '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
       '<SOAP-ENV:Body>' +
          '<ns0:GSAServiceResponse xmlns:ns0="http://www.carefirst.com/schemas/LoadGSA/Response.xsd">' +
             '<ns0:ProspectId>PR-SFTEST</ns0:ProspectId>' +
             '<ns0:StatusCode>BE501</ns0:StatusCode>' +
             '<ns0:StatusDesc>Prospect created successfully</ns0:StatusDesc>' +
          '</ns0:GSAServiceResponse>' +
       '</SOAP-ENV:Body>' +
    '</SOAP-ENV:Envelope>';
    */

    /*
     ** OLD FAULT MESSAGE **
        '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
            '<SOAP-ENV:Body>' +
                '<SOAP-ENV:Fault>' +
                    '<faultcode>GSA204</faultcode>' +
                    '<faultstring>Broker Express Cannot Create Prospect Record - Missing DBEWHInd</faultstring>' +
              '</SOAP-ENV:Fault>' +
           '</SOAP-ENV:Body>' + 
        '</SOAP-ENV:Envelope>';
    */

    /* 
    ** OLD DUPLICATE VERSION **
        '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">' +
            '<SOAP-ENV:Body>' +
                '<SOAP-ENV:Fault>' +
                    '<faultcode>SOAP-ENV:Server</faultcode>' + 
                    '<faultstring>This is an operation implementation generated fault</faultstring>' + 
                    '<faultactor />' + 
                    '<detail>' +
                        '<ns:fault xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns="http://carefirst.com/LoadGSA/SOAPFault" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/">' +
                            '<ns:faultCode>GSA201</ns:faultCode>' + 
                            '<ns:faultMsg>Duplicate Prospect Exists [ PR - 54321]</ns:faultMsg>' + 
                        '</ns:fault>' +
                    '</detail>' +
                '</SOAP-ENV:Fault>' +
            '</SOAP-ENV:Body>' +
        '</SOAP-ENV:Envelope>';
    */

}