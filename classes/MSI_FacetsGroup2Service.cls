/*=========================================================================================
 * Date         : 1/13/17
 * Developer    : Ken Gill, Laveen
 * Purpose      : This service class provides access to the  Group active/termed status and termination
 *                date field information. This is useful for computing the Member Eligilbity Rollup
 *                indicator.
 *                It provides 2 implementations - a client stub based on WSDL generated code and a raw
 *                HTTPRequest/Response based implementation. The HTTP based implementation is used as the 
 *                endpoint webservice could not resolve name space conflicts from the client stub based implementation.
 *                The client stub based implementation ( getTerminatedStatus) is deprecated. 
 * 
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 *  1/13/2017|   KG       | Initial implementation 
 *  7/20/2017|   LAVEEN   | API Gateway Authentication request and Eligibility Rollup Indicator Fix
 *=========================================================================================
 */ 
 

public with sharing class MSI_FacetsGroup2Service {

public class MSI_Exception extends Exception {}

public static String grp2service_EndPointURL;
public static String grp2service_ClientCertificateName;
public static String grp2service_RequestTimeout = '120000';
public static String grp2service_SFDCSupportEmailAddress = 'kirat.gill@carefirst.com';
public static String grp2service_FacetsSupportEmailAddress = 'kirat.gill@carefirst.com';
public static String grp2service_UserName = '';
public static String grp2service_UserPassword = '';
public static Boolean isInitialized = false;

public static String environmentModuleName = 'MSI Group2Service';
public static String environmentCommonModuleName = 'Common';
public static String environmentVariableName_group2ServiceSFDCSupportEmailAddress = 'MSI_GRP2SRV_SFDC_Support_Email';
public static String environmentVariableName_group2ServiceFacetsSupportEmailAddress = 'MSI_GRP2SRV_Support_Email';
public static String environmentVariableName_endPointURL = 'MSI_GRP2SVC_EndPoint';
public static String environmentVariableName_commonClientCertificateName = 'ClientCertificateName';
public static String environmentVariableName_group2ServiceRequestTimeout = 'MSI_GRP2SRV_RequestTimeout';
public static String environmentVariableName_group2ServiceUserName = 'MSI_GRP2SRV_UserName';
public static String environmentVariableName_group2ServiceUserPassword = 'MSI_GRP2SRV_UserPassword';
public static List<String> environmentVariableNames = new List<String>();
 
// The following are constants used as Group status values returned by the service.
public static String GroupStatus_ACTIVE = 'Active';
public static String GroupStatus_TERMINATED = 'Terminated';
public static String GroupStatus_UNAVAILABLE = 'Unavailable';

// one time initialization block when MSI_FacetsGroup2Service class is first loaded
static {
    System.debug('MSI_FacetsGroup2Service: static initializer block loading');
    MSI_FacetsGroup2Service.environmentVariableNames = new List<String>();
    MSI_FacetsGroup2Service.environmentVariableNames.add ( MSI_FacetsGroup2Service.environmentVariableName_endPointURL );
    MSI_FacetsGroup2Service.environmentVariableNames.add ( MSI_FacetsGroup2Service.environmentVariableName_commonClientCertificateName );
    MSI_FacetsGroup2Service.environmentVariableNames.add ( MSI_FacetsGroup2Service.environmentVariableName_group2ServiceSFDCSupportEmailAddress );
    MSI_FacetsGroup2Service.environmentVariableNames.add ( MSI_FacetsGroup2Service.environmentVariableName_group2ServiceFacetsSupportEmailAddress );
    MSI_FacetsGroup2Service.environmentVariableNames.add ( MSI_FacetsGroup2Service.environmentVariableName_group2ServiceRequestTimeout );
    MSI_FacetsGroup2Service.environmentVariableNames.add ( MSI_FacetsGroup2Service.environmentVariableName_group2ServiceUserName);
    MSI_FacetsGroup2Service.environmentVariableNames.add ( MSI_FacetsGroup2Service.environmentVariableName_group2ServiceUserPassword);
                                                         
    MSI_FacetsGroup2Service.loadConfigurationFromEnvironmentVariables();
               
}   // end static initializer
    


public static void loadConfigurationFromEnvironmentVariables() {
    
    System.debug('Loading MSI_FacetsGroup2Service environment variables');    
    Map<String, EnvironmentVariable__c> envVarMap = new Map<String,EnvironmentVariable__c>();
    EnvironmentVariables.getEnvironmentVariablesForModule(MSI_FacetsGroup2Service.environmentModuleName, envVarMap);
    EnvironmentVariables.getEnvironmentVariablesForModule(MSI_MemberService.environmentModuleName, envVarMap);    
    EnvironmentVariables.getEnvironmentVariablesForModule(MSI_FacetsGroup2Service.environmentCommonModuleName, envVarMap);
    
    if(envVarMap.isEmpty()) {
        System.debug('Error: No MSI Group2Service related environment variables configured in EnvironmentVariable__c table. Retrieved envVarMap=' + String.valueOf(envVarMap));
        MSI_FacetsGroup2Service.isInitialized = false;
        return;
    }
         
    String value =  (envVarMap.get(MSI_FacetsGroup2Service.environmentVariableName_endPointURL)).Value__c;
    if(String.isNotBlank(value)) { MSI_FacetsGroup2Service.grp2service_EndPointURL = value;}
    System.debug( 'grp2service_EndPointURL=' + value);
    
    value = (envVarMap.get(MSI_FacetsGroup2Service.environmentVariableName_commonClientCertificateName)).Value__c;
    if( String.isNotBlank(value)) MSI_FacetsGroup2Service.grp2service_ClientCertificateName = value;
    System.debug( 'grp2service_ClientCertificateName=' + value);
    
    value = (envVarMap.get(MSI_FacetsGroup2Service.environmentVariableName_group2ServiceSFDCSupportEmailAddress)).Value__c;
    if( String.isNotBlank(value)) MSI_FacetsGroup2Service.grp2service_SFDCSupportEmailAddress = value;
    System.debug( 'grp2service_SFDCSupportEmailAddress=' + value);
    
    value = (envVarMap.get(MSI_FacetsGroup2Service.environmentVariableName_group2ServiceFacetsSupportEmailAddress)).Value__c;
    if( String.isNotBlank(value)) MSI_FacetsGroup2Service.grp2service_FacetsSupportEmailAddress = value;
    System.debug( 'grp2service_FacetsSupportEmailAddress=' + value);
    
    value = (envVarMap.get(MSI_FacetsGroup2Service.environmentVariableName_group2ServiceRequestTimeout)).Value__c;
    if( String.isNotBlank(value)) MSI_FacetsGroup2Service.grp2service_RequestTimeout = value;
    System.debug( 'grp2service_RequestTimeout=' + value);

    value = (envVarMap.get(MSI_FacetsGroup2Service.environmentVariableName_group2ServiceUserName)).Value__c;
    if( String.isNotBlank(value)) MSI_FacetsGroup2Service.grp2service_UserName = value;
    System.debug( 'grp2service_UserName=' + value);

    value = (envVarMap.get(MSI_FacetsGroup2Service.environmentVariableName_group2ServiceUserPassword)).Value__c;
    if( String.isNotBlank(value)) MSI_FacetsGroup2Service.grp2service_UserPassword = value;
    System.debug( 'grp2service_UserPassword=' + value);

    MSI_FacetsGroup2Service.isInitialized = true;
}

/*************************************************************************************
 * Purpose   : This is a asynchronous version of the loadConfigurationFromEnvironmentVariables()  
 *             method that can be called from a trigger
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
@future
public static void reloadConfigurationFromEnvironmentVariables() {
     MSI_FacetsGroup2Service.loadConfigurationFromEnvironmentVariables();
}

/*************************************************************************************
 * Purpose   : DEPRECATED
 *             This implementation is based on the WSDL2Apex generated client stubs (MSI_FacetsGroup2ServiceProxy)
 *             class and is DEPRECATED. The client stub generates a request where the GroupID element namespace cannot
 *             be resolved by the web service endpoint so it does not process the request correctly. The reason is the generated
 *             request <GroupID> element does not have a namespace prefix  that the service endpoint is expecting it to have. This 
 *             seems to be a wsdl2apex bug and their is no method to modify namespace of individual elements from the client stub
 *             exposed methods.
 * 
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
 
 /*
public static MSI_FacetsGroup2Response getTerminatedStatus( MSI_FacetsGroup2Request request ) {

    MSI_FacetsGroup2Response response = null;
    try {
        
        MSI_FacetsGroup2ServiceProxy.OperationsOfGroupEndpoint service = MSI_FacetsGroup2Service.getService();       
        MSI_FacetsGroup2ServiceProxy.GetGroupDetailsResponse_element proxyResponse =
                              service.GetGroupDetails(request.groupID, null, null, null, null, null);
                      
        System.debug( proxyResponse);
        System.debug('Received response from MSI_Group2Service.GetGroupDetails() service operation: ' + String.valueOf(proxyResponse));  
                      
       
       // Note: this response log message should be created after callout otherwise you will get a callout exception 
        // message 'You have uncommitted work pending. Please commit or rollback before calling out'
        response = new MSI_FacetsGroup2Response(request);                    
        response.status = IntegrationMessage.STATUS_SUCCESS;    // default

        if( proxyResponse.success == true && proxyResponse.GRGR_COLL.REC_GRGR[0] != null) {
            response.statusCode = String.valueOf(proxyResponse.success);
            response.statusDescription = ' ';
             
            response.isTerminated = proxyResponse.GRGR_COLL.REC_GRGR[0].GRGR_STS == 'Acc' ? true : false;
            response.terminationDate = proxyResponse.GRGR_COLL.REC_GRGR[0].GRGR_TERM_DT;
        } else {
            response.statusCode = (String) proxyResponse.error.msgCode; 
            response.statusDescription = proxyResponse.error.msg;
        }
        
        response.setIsValid(true);

    } catch (Exception e) {
        response = new MSI_FacetsGroup2Response(request);
        response.status = IntegrationMessage.STATUS_ERROR;
        response.statusCode = IntegrationMessage.REMOTE_ERROR;
        response.statusDescription = 'Exception type= ' + e.getTypeName() + ' , message= ' + e.getMessage();
        response.setIsValid(false);
        System.debug('Exception encountered. Request=' + request.toString() + ';  Response=' + response);
       
    } // end try-catch  
    
    return response;
}

*/



/*************************************************************************************
 * Purpose   : This method uses HTTPRequest/Response classes to control the generated XML request more precisely
 *             to match the requirements of the FacetsGroup2Service endpoint TIBCO service. The XML handling uses
 *             the Apex XML DOM library classes. 
 *             Sends the API Gateway Basic Authentication request to the service. 
  
 * Parameters: MSI_FacetsGroup2Request request
 *
 * Return    : MSI_FacetsGroup2Response - contains the Group Active Status and Termination Date (if applicable)
 
 *************************************************************************************/

public static MSI_FacetsGroup2Response getTerminatedStatusUsingHTTP( MSI_FacetsGroup2Request request ) {
    
    MSI_FacetsGroup2Response response = new MSI_FacetsGroup2Response(request);  
    try {
        String responseBody;
   
        String requestBody = GroupDetailsRequestTemplate.replace('{GROUPID}', request.groupID);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(MSI_FacetsGroup2Service.grp2service_EndPointURL );
        req.setMethod('POST');
        req.setHeader('content-type', 'text/xml');
        //req.setHeader('content-type', 'application/x-www-form-urlencoded');
        req.setHeader('Accept-Encoding', 'gzip');
        req.setHeader( 'Soapaction',  '/GroupServices/BusinessProcesses/GroupSearch/MainProcesses/Group.serviceagent/OperationsOfGroupEndpoint/GetGroupDetails');
        
        //Added by Laveen for API Gateway URL changes 
         Map<String,String> securityHeaders = new Map<String,String>();
         String username = MSI_FacetsGroup2Service.grp2service_UserName;
         String password = MSI_FacetsGroup2Service.grp2service_UserPassword;
         //system.debug('****user and password  ****'+username+'_'+password  );   
         Blob headerValue = Blob.valueOf(username + ':' + password);
         system.debug('****headeuser id and password Value ****'+headerValue );
            
        String authorizationHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);
        system.debug('****authorizationHeader  ****'+authorizationHeader );
        //securityHeaders.put( 'Authorization', authorizationHeader);
        req.setHeader('Authorization', authorizationHeader);
        
        req.setBody(requestBody); 
        system.debug('*******Request from MSIg2s'+req);           
        Http http = new Http();
        
        system.debug('*******Group2serivce cert name'+MSI_FacetsGroup2Service.grp2service_ClientCertificateName);
        req.setClientCertificateName(MSI_FacetsGroup2Service.grp2service_ClientCertificateName);
        HTTPResponse res = http.send(req);
        responseBody = res.getBody();
        
        System.debug( '*****responseBody****'+responseBody );
        System.debug( responseBody );
        //Laveen changes End
        // Note: this response log message should be created after callout otherwise you will get a callout exception 
        // message 'You have uncommitted work pending. Please commit or rollback before calling out'
                       

        String[] xmlParseResult = MSI_FacetsGroup2Service.extractStatusFromResponseXML( responseBody );
        System.debug( '****Group2service xml'+ xmlParseResult);

        if( xmlParseResult[0] != GroupStatus_UNAVAILABLE ) {    // sucessful parse of response
            if( xmlParseResult[0] == GroupStatus_ACTIVE ) {
               response.isTerminated = false;
               response.terminationDate = '';
               system.debug('Active response**'+response);
             } else {
                response.isTerminated = true; 
                response.terminationDate = xmlParseResult[1];
                system.debug('Term response**'+response);
             }
            response.status = IntegrationMessage.STATUS_SUCCESS;    // default
            response.setIsValid(true);
        } else {
            response.status = IntegrationMessage.STATUS_ERROR;
            response.statusCode = IntegrationMessage.REMOTE_ERROR;
            response.statusDescription = xmlParseResult[1];
            response.setIsValid( false );
        }

    } catch (Exception e) {
        response.status = IntegrationMessage.STATUS_ERROR;
        response.statusCode = IntegrationMessage.REMOTE_ERROR;
        response.statusDescription = 'Exception type= ' + e.getTypeName() + ' , message= ' + e.getMessage();
        response.setIsValid(false);
        System.debug('Exception encountered. Request=' + request.toString() + ';  Response=' + response);
       
    } // end try-catch  
    
    request.msgData = JSON.serializePretty ( request );
    response.msgData = JSON.serializePretty( response); 
    // log request and response messages to Integration log 
    // Note: if called from a context where a database transaction (record update) is happening, these calls need to happen after the web service callout to the external system
    // otherwise you get an exception message "System.CalloutException: You have uncommitted work pending"
    // because integration log records have not been committed
    /* TBD: 1/18/17 - causing unsaved work exception because of being called from MSI_Memberservice resulting in pending transacation 
    Integration.logFuture ( JSON.serialize ( request) );
    Integration.logFuture( JSON.serialize (response) );  
    */
          
    return response;
}

/*************************************************************************************
 * Purpose   :  
 *              
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/

public static MSI_FacetsGroup2ServiceProxy.OperationsOfGroupEndpoint getService() {
    MSI_FacetsGroup2ServiceProxy.OperationsOfGroupEndpoint  service = new MSI_FacetsGroup2ServiceProxy.OperationsOfGroupEndpoint();
    
    if(!MSI_FacetsGroup2Service.isInitialized) {  
        throw new MSI_MemberService.MSI_Exception('MSI_FacetsGroup2Service is not initialized'); 
    }
    
    String clientCertificateName = MSI_FacetsGroup2Service.grp2service_ClientCertificateName;
    String endPointURL = MSI_FacetsGroup2Service.grp2service_EndPointURL;
    
        Integer requestTimeout;
        try {
         requestTimeout = Integer.valueof(MSI_FacetsGroup2Service.grp2service_RequestTimeout );
        } catch (Exception e) {
        System.debug('Error processing timeout value=' + MSI_FacetsGroup2Service.grp2service_RequestTimeout  + ': defaulting to 60,000 (60 seconds)');
        requestTimeout = 60000;
    }

    // Create BASIC authentication headers. 
    Map<String,String> securityHeaders = new Map<String,String>();
    String username = MSI_FacetsGroup2Service.grp2service_UserName;
    String password = MSI_FacetsGroup2Service.grp2service_UserPassword;

    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
    securityHeaders.put( 'Authorization', authorizationHeader);


    System.debug('Using MSI_FacetsGroup2Service web service settings: grp2service_ClientCertificateName=' + clientCertificateName + 
                  ', grp2service_RequestTimeout =' + requestTimeout + ', grp2service_EndPointURL=' + endPointURL +
                  ', grp2service_UserName=' + username + ', grp2service_UserPassword=' + password);
    
    service.clientCertName_x = clientCertificateName;
    service.timeout_x = requestTimeout;
    service.endpoint_x = endPointURL;
    service.inputHttpHeaders_x = securityHeaders;
    return service;
}




//-------------------------- HTTP callout based implementation

public static String GroupDetailsRequestTemplate =
    '<?xml version="1.0"?> ' +
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soap="http://carefirst.com/Enterprise/Operations/SoapHeader" xmlns:ns="http://carefirst.com/facets/group/types/200809">' +
    '   <soapenv:Header>' +
    '      ' +
    '   </soapenv:Header>' +
    '   <soapenv:Body>' +
    '      <ns:GetGroupDetailsRequest>' +
    '         <!--Optional:-->' +
    '         <ns:GroupId>{GROUPID}</ns:GroupId>' +
    '         <!--Optional:-->' +
    '         <ns:GroupCK/>' +
    '         <!--Optional:-->' +
//  '         <ns:AsOfDate></ns:AsOfDate>' +
    '         <ns:AsOfDate/>' + 
    '         <!--Optional:-->' +
    '         <ns:GroupCategory/>' +
    '         <!--Optional:-->' +
    '         <ns:GroupType/>' +
    '         <!--Optional:-->' +
    '         <ns:GroupOptions>' +
    '            <!--1 or more repetitions:-->' +
    '            <ns:Attribute>' +
    '               <ns:Name>ListGroupGRREFlag</ns:Name>' +
    '               <ns:Value>N</ns:Value>' +
    '               <!--Zero or more repetitions:-->' +
    '            </ns:Attribute>' +
    '         </ns:GroupOptions>' +
    '      </ns:GetGroupDetailsRequest>' +
    '   </soapenv:Body>' +
    '</soapenv:Envelope>' +
    '';


/*************************************************************************************
 * Purpose   :  This method parses the response XML to extract Group Status and Group Term date from
 *              the webservice response
 *              
 * Parameters: None
 *
 * Return    : Returns a 2 part String array. Index[0] contains Group Status, Index[1] - contains Group Termination date
 *             if applicable otherwise blank
 *************************************************************************************/

public static List<String>  extractStatusFromResponseXML(String responseXML) {
    
    if( String.isBlank( responseXML ) ) {
        System.debug( 'extractStatusFromResponseXML(String responseXML): Received empty or null responseXML string to parse');
        return new List<String> { GroupStatus_UNAVAILABLE, ''} ;
    }
    
    try {
        Dom.Document response = new Dom.Document();
        response.load(responseXML);
        Dom.XmlNode node = response.getRootElement();   // will get <soapenv:Envelope> element
        
        String soapNameSpace = 'http://schemas.xmlsoap.org/soap/envelope/'; 
        String namespace = 'http://carefirst.com/facets/group/types/200809';
        
        node = node.getChildElement( 'Body', soapNameSpace);        
        node = node.getChildElement( 'GetGroupDetailsResponse', namespace);
         
        String successElementValue = node.getChildElement( 'success', '').getText();    
        
        node = node.getChildElement( 'GRGR_COLL', '');
        node = node.getChildElement('REC_GRGR', '');


        String GRGR_STS_ElementValue = node.getChildElement('GRGR_STS', '').getText();
        String GRGR_TERM_DT_ElementValue = node.getChildElement('GRGR_TERM_DT', '').getText();
        system.debug('GRGR_TERM_DT_ElementValue**'+GRGR_TERM_DT_ElementValue);        

        if( ! 'true'.equalsIgnoreCase( successElementValue) ) {
            String message = 'Operation error reported from remote web service in GetGroupDetailsResponse.success XML element';
            System.debug( message );
            return new List<String> { GroupStatus_UNAVAILABLE, message } ;
        }

        String groupActiveStatus ;      
        if( !String.isBlank( GRGR_STS_ElementValue ) && 'AC'.equals( GRGR_STS_ElementValue ) ) 
            groupActiveStatus = GroupStatus_ACTIVE;
        else 
            groupActiveStatus = GroupStatus_TERMINATED;
            
        System.debug('Group Active Status received: ' + GRGR_STS_ElementValue + ' translated to :' + groupActiveStatus);
        System.debug('Group Active Status received -TERM DATE: ' + GRGR_TERM_DT_ElementValue);
        
        return new List<String> { groupActiveStatus, GRGR_TERM_DT_ElementValue } ;
        
    } catch( System.XMLException e) {
        String message = 'Internal Error: XMLException <br><br>' + e.getMessage();
        System.debug( message );
        return new List<String> { GroupStatus_UNAVAILABLE, message } ;  
    }   
}

/* This response template is useful for returning a mock response for unit test code 
  The template parameter {GROUPID} in the body can be replaced with a desired GroupID value
*/

public static String GroupDetailsResponseTemplate = 
    '<?xml version="1.0" encoding="UTF-8"?> ' +
    '<SOAP-ENV:Envelope ' +
    '   xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"> ' +
    '   <SOAP-ENV:Body> ' +
    '       <ns0:GetGroupDetailsResponse ' +
    '           xmlns:ns0="http://carefirst.com/facets/group/types/200809"> ' +
    '           <success xmlns="">true  </success> ' +
    '           <GRGR_COLL xmlns=""> ' +
    '               <REC_GRGR xmlns=""> ' +
    '                   <GRGR_CK xmlns="">34995  </GRGR_CK> ' +
    '                   <CICI_ID xmlns="">KA  </CICI_ID> ' +
    '                   <GRGR_ID xmlns="">{GROUPID}</GRGR_ID> ' +
    '                   <PAGR_CK xmlns="">0  </PAGR_CK> ' +
    '                   <GRGR_NAME xmlns="">Consortium of Private Schools/Roland/Gilman/Bryn M  </GRGR_NAME> ' +
    '                   <GRGR_ADDR1 xmlns="">5204 Roland Avenue  </GRGR_ADDR1> ' +
    '                   <GRGR_CITY xmlns="">Baltimore  </GRGR_CITY> ' +
    '                   <GRGR_STATE xmlns="">MD  </GRGR_STATE> ' +
    '                   <GRGR_ZIP xmlns="">21210  </GRGR_ZIP> ' +
    '                   <GRGR_COUNTY xmlns="">Baltimore City  </GRGR_COUNTY> ' +
    '                   <GRGR_PHONE xmlns="">4103233800  </GRGR_PHONE> ' +
    '                   <GRGR_PHONE_EXT xmlns="">250  </GRGR_PHONE_EXT> ' +
    '                   <GRGR_MCTR_TYPE xmlns="">LOCR  </GRGR_MCTR_TYPE> ' +
    '                   <GRGR_MCTR_VIP xmlns="">6  </GRGR_MCTR_VIP> ' +
    '                   <GRGR_STS xmlns="">AC  </GRGR_STS> ' +
    '                   <GRGR_ORIG_EFF_DT xmlns="">2011-01-01T00:00:00  </GRGR_ORIG_EFF_DT> ' +
    '                   <GRGR_TERM_DT xmlns="">9999-12-31T00:00:00  </GRGR_TERM_DT> ' +
    '                   <GRGR_RNST_DT xmlns=""/> ' +
    '                   <GRGR_CONV_DT xmlns="">2010-12-11T00:00:00  </GRGR_CONV_DT> ' +
    '                   <GRGR_RENEW_MMDD xmlns="">1101  </GRGR_RENEW_MMDD> ' +
    '                   <GRGR_PREV_ANNV_DT xmlns="">2015-01-01T00:00:00  </GRGR_PREV_ANNV_DT> ' +
    '                   <GRGR_CURR_ANNV_DT xmlns="">2016-01-01T00:00:00  </GRGR_CURR_ANNV_DT> ' +
    '                   <GRGR_NEXT_ANNV_DT xmlns="">2017-01-01T00:00:00  </GRGR_NEXT_ANNV_DT> ' +
    '                   <GRGR_MCTR_PTYP xmlns="">6  </GRGR_MCTR_PTYP> ' +
    '                   <GRGR_CAP_IND xmlns="">N  </GRGR_CAP_IND> ' +
    '                   <GRGR_LAST_CAP_DT xmlns=""/> ' +
    '                   <GRGR_CAP_BAT_STS xmlns="">1  </GRGR_CAP_BAT_STS> ' +
    '                   <GRGR_BILL_LEVEL xmlns="">S  </GRGR_BILL_LEVEL> ' +
    '                   <GRGR_LMT_ADJ_MOS xmlns="">12  </GRGR_LMT_ADJ_MOS> ' +
    '                   <GRGR_BL_CONV_DT xmlns="">2011-01-01T00:00:00  </GRGR_BL_CONV_DT> ' +
    '                   <GRGR_NAME_XLOW xmlns="">consorti  </GRGR_NAME_XLOW> ' +
    '                   <GRGR_CITY_XLOW xmlns="">baltimor  </GRGR_CITY_XLOW> ' +
    '                   <WMDS_SEQ_NO xmlns="">0  </WMDS_SEQ_NO> ' +
    '                   <GRGR_TOTAL_EMPL xmlns="">250  </GRGR_TOTAL_EMPL> ' +
    '                   <GRGR_TOTAL_ELIG xmlns="">0  </GRGR_TOTAL_ELIG> ' +
    '                   <GRGR_TOTAL_CONTR xmlns="">0  </GRGR_TOTAL_CONTR> ' +
    '                   <GRGR_EIN xmlns="">520591604  </GRGR_EIN> ' +
    '                   <GRGR_ERIS_MMDD xmlns="">101  </GRGR_ERIS_MMDD> ' +
    '                   <GRGR_RECD_DT xmlns=""/> ' +
    '                   <GRGR_CAP_CONV_DT xmlns="">2011-01-01T00:00:00  </GRGR_CAP_CONV_DT> ' +
    '                   <GRGR_RUNOUT_DT xmlns=""/> ' +
    '                   <GRGR_TRANS_ACCEPT xmlns="">N  </GRGR_TRANS_ACCEPT> ' +
    '                   <GRGR_AUTONUM_IND xmlns="">N  </GRGR_AUTONUM_IND> ' +
    '                   <GRGR_LOCK_TOKEN xmlns="">1  </GRGR_LOCK_TOKEN> ' +
    '                   <ATXR_SOURCE_ID xmlns="">3242-01-01T00:00:31.43  </ATXR_SOURCE_ID> ' +
    '                   <GRGR_MCTR_TYPE_DESC xmlns="">Local/Regional  </GRGR_MCTR_TYPE_DESC> ' +
    '                   <GRGR_MCTR_VIP_DESC xmlns="">Calendar/Dedicated CSR  </GRGR_MCTR_VIP_DESC> ' +
    '                   <GRGR_CAP_BAT_STS_DESC xmlns="">1  </GRGR_CAP_BAT_STS_DESC> ' +
    '                   <GRGR_BILL_LEVEL_DESC xmlns="">Subgroup  </GRGR_BILL_LEVEL_DESC> ' +
    '                   <GRGR_CONT_EFF_DT xmlns=""/> ' +
    '                   <GRGR_TERM_PREM_MOS xmlns="">0  </GRGR_TERM_PREM_MOS> ' +
    '                   <GRGR_RNST_VAL xmlns="">0  </GRGR_RNST_VAL> ' +
    '               </REC_GRGR> ' +
    '           </GRGR_COLL> ' +
    '       </ns0:GetGroupDetailsResponse> ' +
    '   </SOAP-ENV:Body> ' +
    '</SOAP-ENV:Envelope>  ' +
    '';





}