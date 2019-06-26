/*=========================================================================================
 * Date         : 11/14/17
 * Developer    : Arshia Gulati
 * Purpose      : This class holds the mock response for web service callout for Related Entities Test Classes
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/14/17  |  AG    | Initial Version developed for User story B-03752                                         
 *=========================================================================================
 */
@isTest
global class FDL_FacetsDataLookUpServiceMock implements HttpCalloutMock
{
    public string sstatus {get;set;}
    public integer sStatusCode {get;set;}
    global HttpResponse respond(HttpRequest request){
        HttpResponse response = new HttpResponse();
        response.setHeader('content-type', 'text/xml');
        response.setStatus(sstatus);
        response.setStatusCode(sStatusCode);
        if(sStatusCode == 200)   {
         	if (sstatus == 'INVALID')   response.setBody(invalidResponseBody);
            else   response.setBody(successResponseBody);
        }
        else if(sStatusCode == 500) response.setBody(failureResponseBody);
        else response.setBody(exceptionResponseBody);
        return response;
    }
    string failureResponseBody = '<?xml version="1.0" encoding="UTF-8"?>'+
        '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">'+
    	'<SOAP-ENV:Body> <SOAP-ENV:Fault>'+
        '<faultcode>SOAP-ENV:Server</faultcode>'+
        ' <faultstring>500:No Match For Request filter failed:[invalid field]</faultstring>'+
        ' <faultactor>Id-3065075aa553df1c13b15aaf</faultactor> '+
        '</SOAP-ENV:Fault></SOAP-ENV:Body></SOAP-ENV:Envelope>';
  
    string exceptionResponseBody = '<?xml version="1.0" encoding="UTF-8"?>'+
        '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"> '+
        '<SOAP-ENV:Body><ns0:groupResponseMessage xmlns:ns0="http://carefirst.com/facets/Salesforce/FacetsDataLookup/GroupDetails.xsd">'+
    	'<ns0:groupID></ns0:groupID><ns0:groupCK></ns0:groupCK>' +
     	'<ns0:groupRelatedEntDetails> </ns0:groupRelatedEntDetails>' +
        '<ns0:StatusBlock><ns0:status>SUCCESS</ns0:status>' +
        '<ns0:Message><ns0:msgCode>S002</ns0:msgCode><ns0:msgDesc></ns0:msgDesc>' +
        '</ns0:Message></ns0:StatusBlock></ns0:groupResponseMessage></SOAP-ENV:Body></SOAP-ENV:Envelope>';
      
    string successResponseBody = '<?xml version="1.0" encoding="UTF-8"?>'+
        '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"> '+
        '<SOAP-ENV:Body><ns0:groupResponseMessage xmlns:ns0="http://carefirst.com/facets/Salesforce/FacetsDataLookup/GroupDetails.xsd">'+
    	'<ns0:groupID>01VF</ns0:groupID><ns0:groupCK>9281</ns0:groupCK>' +
     	'<ns0:groupRelatedEntDetails><ns0:relatedEntityName>Elizabeth C Braid</ns0:relatedEntityName>' +
      	'<ns0:relatedEntityType>GR</ns0:relatedEntityType>' +
        '<ns0:relatedEntityID>220822546</ns0:relatedEntityID>' +
        '<ns0:relatedEntityAddrline1>Velco Insurance Agency Inc</ns0:relatedEntityAddrline1>' +
        '<ns0:relatedEntityAddrline2>9215 Liberty Road PO Box 683</ns0:relatedEntityAddrline2>' +
        '<ns0:relatedEntityAddrline3>Suite 200</ns0:relatedEntityAddrline3>' +
        '<ns0:relatedEntityZip>21133</ns0:relatedEntityZip>' +
        '<ns0:relatedEntityCounty> </ns0:relatedEntityCounty>' +
        '<ns0:relatedEntityCity>Randallstown</ns0:relatedEntityCity>' +
        '<ns0:relatedEntityState>MD</ns0:relatedEntityState>' +
        '<ns0:relatedEntityCtryCd> </ns0:relatedEntityCtryCd>' +
        '<ns0:relatedEntityEmail>none@carefirst.com</ns0:relatedEntityEmail>' +
        '<ns0:relatedEntityPhone>4109220912</ns0:relatedEntityPhone>' +
        '<ns0:relatedEntityFax>4109222455</ns0:relatedEntityFax>' +
        '<ns0:groupRelationshipCategory>BR - Broker</ns0:groupRelationshipCategory>' +
        '<ns0:groupRelationshipType>SB</ns0:groupRelationshipType>' +
        '<ns0:groupRelationshipEffDt>12-01-2009</ns0:groupRelationshipEffDt>' +
        '<ns0:groupRelationshipTermDt>12-31-9999</ns0:groupRelationshipTermDt>' +
        '<ns0:groupRelationshipTermReason> </ns0:groupRelationshipTermReason>' +
        '</ns0:groupRelatedEntDetails>' +
        '<ns0:groupRelatedEntDetails><ns0:relatedEntityName>Lacey Weber</ns0:relatedEntityName>' +
        '<ns0:relatedEntityType>GR</ns0:relatedEntityType><ns0:relatedEntityID>5617</ns0:relatedEntityID>' +
        '<ns0:relatedEntityAddrline1>10455 Mill Run Circle OM1-515</ns0:relatedEntityAddrline1>' +
        '<ns0:relatedEntityAddrline2> </ns0:relatedEntityAddrline2><ns0:relatedEntityAddrline3> </ns0:relatedEntityAddrline3>' +
        '<ns0:relatedEntityZip>21117</ns0:relatedEntityZip><ns0:relatedEntityCounty>Baltimore</ns0:relatedEntityCounty>' +
        '<ns0:relatedEntityCity>Owings Mills</ns0:relatedEntityCity><ns0:relatedEntityState>MD</ns0:relatedEntityState>' +
        '<ns0:relatedEntityCtryCd> </ns0:relatedEntityCtryCd>' +
        '<ns0:relatedEntityEmail>NONE@CAREFIRST.COM</ns0:relatedEntityEmail>' +
        '<ns0:relatedEntityPhone>4109987005</ns0:relatedEntityPhone><ns0:relatedEntityFax> </ns0:relatedEntityFax>' +
        '<ns0:groupRelationshipCategory>OT - Other</ns0:groupRelationshipCategory>' +
        '<ns0:groupRelationshipType>AE</ns0:groupRelationshipType>' +
        '<ns0:groupRelationshipEffDt>12-01-2009</ns0:groupRelationshipEffDt>' +
        '<ns0:groupRelationshipTermDt>12-31-9999</ns0:groupRelationshipTermDt>' +
        '<ns0:groupRelationshipTermReason> </ns0:groupRelationshipTermReason></ns0:groupRelatedEntDetails>' +
        '<ns0:groupRelatedEntDetails><ns0:relatedEntityName>CareFirstBlueChoice</ns0:relatedEntityName>' +
		'<ns0:relatedEntityType>GR</ns0:relatedEntityType><ns0:relatedEntityID>BHHLOCGR</ns0:relatedEntityID>' +
        '<ns0:relatedEntityAddrline1> </ns0:relatedEntityAddrline1>' +
		'<ns0:relatedEntityAddrline2> </ns0:relatedEntityAddrline2><ns0:relatedEntityAddrline3> </ns0:relatedEntityAddrline3>' +
        '<ns0:relatedEntityZip> </ns0:relatedEntityZip><ns0:relatedEntityCounty> </ns0:relatedEntityCounty>' +
        '<ns0:relatedEntityCity> </ns0:relatedEntityCity><ns0:relatedEntityState> </ns0:relatedEntityState>' +
		'<ns0:relatedEntityCtryCd> </ns0:relatedEntityCtryCd>' +
		'<ns0:relatedEntityEmail> </ns0:relatedEntityEmail>' +
		'<ns0:relatedEntityPhone>4437382922</ns0:relatedEntityPhone><ns0:relatedEntityFax> </ns0:relatedEntityFax>' +
		'<ns0:groupRelationshipCategory>OT - Other</ns0:groupRelationshipCategory>' +
		'<ns0:groupRelationshipType>SVL1</ns0:groupRelationshipType>' +
		'<ns0:groupRelationshipEffDt>12-01-2009</ns0:groupRelationshipEffDt>' +
		'<ns0:groupRelationshipTermDt>12-31-9999</ns0:groupRelationshipTermDt>' +
		'<ns0:groupRelationshipTermReason> </ns0:groupRelationshipTermReason>' +
		'</ns0:groupRelatedEntDetails>' +
        '<ns0:StatusBlock><ns0:status>SUCCESS</ns0:status>' +
        '<ns0:Message><ns0:msgCode>S002</ns0:msgCode><ns0:msgDesc>Successfully retrieved the Group related entities information Facets DB</ns0:msgDesc>' +
        '</ns0:Message></ns0:StatusBlock></ns0:groupResponseMessage></SOAP-ENV:Body></SOAP-ENV:Envelope>';
    
    
     string invalidResponseBody = 
         '<?xml version="1.0" encoding="UTF-8"?>' +
         '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">' +
         '<SOAP-ENV:Body><ns0:groupResponseMessage xmlns:ns0="http://carefirst.com/facets/Salesforce/FacetsDataLookup/GroupDetails.xsd">' +
         '<ns0:StatusBlock><ns0:status>FAILURE</ns0:status><ns0:Message><ns0:msgCode>E006</ns0:msgCode>' +
         '<ns0:msgDesc>Group Details not found</ns0:msgDesc></ns0:Message></ns0:StatusBlock></ns0:groupResponseMessage>' +
         '</SOAP-ENV:Body></SOAP-ENV:Envelope>';
}