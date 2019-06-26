/*=========================================================================================
 * Date         : 11/1/17
 * Developer    : Arshia Gulati
 * Purpose      : This class provides a service layer for the rest of the application to access functionality of
 * 				  the Facets Data LookUp Service to fetch Related Entities for a Group. 
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/01/17  |  AG    | Initial Version developed for User story B-03752                                         
 *=========================================================================================
 */

public class FDL_FacetsDataLookUpService {

public static String SFDCSupportEmailAddress;
public static String FacetsSupportEmailAddress;
public static Boolean isInitialized = false;
public static String EndPointURL;
 public static String RequestTimeout;
 public static String environmentVariableName_endPointURL = 'FDL_RE_EndPoint';
 public static List<String> environmentVariableNames = new List<String>();
 public static  String environmentModuleName = 'Related Entity';
 public static String environmentVariableName_RequestTimeout = 'FDL_RE_RequestTimeout';
 public static String environmentVariableName_SFDCSupportEmailAddress = 'FDL_RE_SFDC_Support_Email';
 public static String environmentVariableName_FacetsSupportEmailAddress = 'FDL_RE_Support_Email';
 public static final string RETURN_TYPE_RE = 'GRRE';
 public static final string HEADER_SOAPACTION = '/FACETSDataLookUp/BusinessProcesses/Common/FacetsDataLookupService.serviceagent/FacetsDataLookupPortEndpoint/GroupDetails';
 public static final string SOAPNAMESPACE = 'http://schemas.xmlsoap.org/soap/envelope/'; 
 public static final string NAMESPACE = 'http://carefirst.com/facets/Salesforce/FacetsDataLookup/GroupDetails.xsd';
               
 // one time initialization block when FDL_ class is first loaded
static {
    System.debug('FDL_FacetsDataLookUpService: static initializer block loading');
    environmentVariableNames = new List<String>();
    environmentVariableNames.add ( environmentVariableName_endPointURL );    
    environmentVariableNames.add ( environmentVariableName_RequestTimeout ); 
    environmentVariableNames.add ( environmentVariableName_SFDCSupportEmailAddress );
    environmentVariableNames.add ( environmentVariableName_FacetsSupportEmailAddress );
    loadConfigurationFromEnvironmentVariables();             
}   // end static initializer
    

/*************************************************************************************
 * Purpose   : This method loads FDL integration related configuration variables when this class 
 * 			   is first loaded and automatically called from the static initializer block  
 * 
 * Parameters: None
 *
 * Return    : None
 *************************************************************************************/
public static void loadConfigurationFromEnvironmentVariables() {    
    System.debug('Loading FDL_FacetsDataLookUpService environment variables');    
    Map<String, EnvironmentVariable__c> envVarMap = new Map<String,EnvironmentVariable__c>();
    EnvironmentVariables.getEnvironmentVariablesForModule(environmentModuleName, envVarMap);
    
    if(envVarMap.isEmpty()) {
        System.debug('Error: No related entity environment variables configured in EnvironmentVariable__c table. Retrieved envVarMap=' + String.valueOf(envVarMap));
        FDL_FacetsDataLookUpService.isInitialized = false;
        return;
    }
    String value;
         
    value =  (envVarMap.get(FDL_FacetsDataLookUpService.environmentVariableName_endPointURL)).Value__c;
    if(String.isNotBlank(value))  EndPointURL = value;
 
    value = (envVarMap.get(FDL_FacetsDataLookUpService.environmentVariableName_RequestTimeout)).Value__c;
    if( String.isNotBlank(value)) RequestTimeout = value;
    
    value = (envVarMap.get(FDL_FacetsDataLookUpService.environmentVariableName_SFDCSupportEmailAddress)).Value__c;
    if( String.isNotBlank(value)) SFDCSupportEmailAddress = value;
    
    value = (envVarMap.get(FDL_FacetsDataLookUpService.environmentVariableName_FacetsSupportEmailAddress)).Value__c;
    if( String.isNotBlank(value)) FacetsSupportEmailAddress = value;
     FDL_FacetsDataLookUpService.isInitialized = true;
}

 /*************************************************************************************
 * Purpose   : Call Facets DataLookUp Service to retrieve related entities 
 *             
 * Parameters: FDL_FacetsDataLookUpRequest request - the request object with groupId captured at RelatedEntities Tab.
 *
 * Return    : FDL_FacetsDataLookUpResponse - a response object that describes the result of the operation
 *             returned by the Facets DataLookUp service.
 *************************************************************************************/
    public static FDL_FacetsDataLookUpResponse getRelatedEntities( FDL_FacetsDataLookUpRequest request ) {
      	FDL_FacetsDataLookUpResponse responseOut = new FDL_FacetsDataLookUpResponse(request);  
        FDL_FacetsDataLookUpResponse.FDL_RelatedEntity relatedEntity;  
        List<FDL_FacetsDataLookUpResponse.FDL_RelatedEntity> lstRelatedEntity = new List<FDL_FacetsDataLookUpResponse.FDL_RelatedEntity>();  
        
    	Boolean notifySupportTeam = false;
        
    try {          
        String responseBody;   
        String requestBody = GroupDetailsRequestTemplate.replace('{GROUPID}', request.groupID).replace('{RETURNRECORD}', RETURN_TYPE_RE);        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:FacetsDataLookUp' );
        req.setTimeout(Integer.valueof(requestTimeout));
        req.setMethod('POST');     
        req.setHeader('content-type', 'text/xml');
        req.setHeader('Accept-Encoding', 'gzip');
        req.setHeader('Soapaction',  HEADER_SOAPACTION);        
        System.Debug('requestBody : ' + requestBody);
        req.setBody(requestBody); 
        Http http = new Http();
        System.Debug('req : '+ req);
        HTTPResponse res = http.send(req);
        System.debug( 'res : ' + res );
        responseBody = res.getBody();        
        System.debug( 'responseBody : ' + responseBody );
        Dom.Document response = new Dom.Document();
        response.load(responseBody);
        Dom.XmlNode node,fnode,snode = response.getRootElement();   // will get <soapenv:Envelope> element        
        System.Debug('res.getStatusCode() : ' + res.getStatusCode());
     	if(res.getStatusCode() == 200) {        		
        	   	snode = snode.getChildElement( 'Body', SOAPNAMESPACE).getChildElement( 'groupResponseMessage', NAMESPACE);
            	responseOut.status = snode.getChildElement( 'StatusBlock', NAMESPACE).getChildElement( 'status', NAMESPACE).getText();    
       			responseOut.statusCode = snode.getChildElement( 'StatusBlock', NAMESPACE).getChildElement( 'Message', NAMESPACE).getChildElement( 'msgCode', NAMESPACE).getText(); 
        		responseOut.statusDescription = snode.getChildElement( 'StatusBlock', NAMESPACE).getChildElement( 'Message', NAMESPACE).getChildElement( 'msgDesc', NAMESPACE).getText();    
  				if('SUCCESS'.equalsIgnoreCase( responseOut.status) ) 
                {                       			
                	Integer NoOfRelatedEntities = snode.getChildElements().size();
	       			node = response.getRootElement();   
                    
    		    	for(Integer i=2; i < NoOfRelatedEntities-1; i++)  
        			{       			
          				node = snode.getChildElements()[i];
                    	relatedEntity = new FDL_FacetsDataLookUpResponse.FDL_RelatedEntity();
          				relatedEntity.relatedEntityName = node.getChildElement( 'relatedEntityName', NAMESPACE).getText() ; 
          				relatedEntity.groupRelationshipCategory = node.getChildElement( 'groupRelationshipCategory', NAMESPACE).getText().split('-')[1] ;
          				relatedEntity.relatedEntityType = node.getChildElement( 'groupRelationshipType', NAMESPACE).getText() ;
                        relatedEntity.groupRelationshipEffDt = node.getChildElement( 'groupRelationshipEffDt', NAMESPACE).getText();
                   		relatedEntity.groupRelationshipTermDt = node.getChildElement( 'groupRelationshipTermDt', NAMESPACE).getText();
                   		relatedEntity.relatedEntityID = node.getChildElement( 'relatedEntityID', NAMESPACE).getText();
          				relatedEntity.relatedEntityEmail = node.getChildElement( 'relatedEntityEmail', NAMESPACE).getText();
                        relatedEntity.relatedEntityFax = node.getChildElement( 'relatedEntityFax', NAMESPACE).getText();
                        relatedEntity.relatedEntityPhone = node.getChildElement( 'relatedEntityPhone', NAMESPACE).getText();
          				relatedEntity.groupRelationshipTermReason = node.getChildElement( 'groupRelationshipTermReason', NAMESPACE).getText();
          				relatedEntity.relatedEntityAddrline1 = node.getChildElement( 'relatedEntityAddrline1', NAMESPACE).getText();
         				relatedEntity.relatedEntityAddrline2 = node.getChildElement( 'relatedEntityAddrline2', NAMESPACE).getText();
          				relatedEntity.relatedEntityAddrline3 = node.getChildElement( 'relatedEntityAddrline3', NAMESPACE).getText();
                        relatedEntity.relatedEntityCounty = node.getChildElement( 'relatedEntityCounty', NAMESPACE).getText();
                        relatedEntity.relatedEntityCity = node.getChildElement( 'relatedEntityCity', NAMESPACE).getText();
                        relatedEntity.relatedEntityState = node.getChildElement( 'relatedEntityState', NAMESPACE).getText();
                        relatedEntity.relatedEntityZip = node.getChildElement( 'relatedEntityZip', NAMESPACE).getText();
            			string sDate = relatedEntity.groupRelationshipTermDt.substring(6,6+4) + '-' + relatedEntity.groupRelationshipTermDt.substring(0,2) + '-' + relatedEntity.groupRelationshipTermDt.substring(3,5) + ' 00:00:00';
        				Date termDate = Date.valueOf(sDate);
            			if(termDate < system.today() && relatedEntity.relatedEntityType.substring(0,2) == 'SV') continue;	
							lstRelatedEntity.add(relatedEntity);          			
         			}
                	responseOut.relatedEntity = lstRelatedEntity;
            		responseOut.groupId = snode.getChildElement('groupID', NAMESPACE).getText();
                	responseOut.setIsValid(true);
               		notifySupportTeam = false;
                }
        	}
           else
           {
                fnode = response.getRootElement();   
                fnode = fnode.getChildElement( 'Body', SOAPNAMESPACE).getChildElement( 'Fault', SOAPNAMESPACE); 
                responseOut.status = 'FAILURE';
                responseOut.statusCode = fnode.getChildElement( 'faultcode', null).getText();
                responseOut.statusDescription = fnode.getChildElement( 'faultstring', null).getText();
                string faultactor = fnode.getChildElement( 'faultactor', null).getText(); 
               	responseOut.setIsValid(false);
               	notifySupportTeam = true;
           
            if(responseOut.groupID == null){
           		responseOut.groupID = request.groupID;        
            }
        }
    } catch (Exception e) {
  			responseOut.Status = IntegrationMessage.STATUS_ERROR;
        	responseOut.statusCode = IntegrationMessage.REMOTE_ERROR;
        	responseOut.statusDescription = 'Exception type= ' + e.getTypeName() + ' , message= ' + e.getMessage();        	       
        	responseOut.setIsValid(false);
        	System.debug('Exception encountered. Request=' + request.toString() + ';  Response=' + responseOut);  
        	notifySupportTeam = true;
    } //end try
    responseOut.msgData = 'Remote response: status=' + responseOut.status + ', statusCode=' + responseOut.statusCode + ', statusDescription= ' + responseOut.statusDescription;
    responseOut.relatedData = '';
        
    if(notifySupportTeam) {
         sendFDLErrorNotification(request, responseOut); 
    }
    // log request and response messages to Integration log     
    Integration.log (request);
    Integration.log( responseOut);    
    return responseOut;
}
    
 //-------------------------- HTTP callout request template
    public static String GroupDetailsRequestTemplate =
    '<?xml version="1.0"?> ' +
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soap="http://carefirst.com/Enterprise/Operations/SoapHeader" xmlns:ns="http://carefirst.com/facets/Salesforce/FacetsDataLookup/GroupDetails.xsd">' +
    '   <soapenv:Header>' +
    '      ' +
    '   </soapenv:Header>' +
    '   <soapenv:Body>' +
    '      <ns:groupRequestMessage>' +
    '         <!--Optional:-->' +
    '         <ns:groupID>{GROUPID}</ns:groupID>' +
    '         <!--Optional:-->' +
    '         <ns:startDate/>' +
    '         <!--Optional:-->' +
    '         <ns:endDate/>' +    
    '         <!--Optional:-->' +
    '         <ns:returnRecord>{RETURNRECORD}</ns:returnRecord>' +
    '      </ns:groupRequestMessage>' +
    '   </soapenv:Body>' +
    '</soapenv:Envelope>' +
    '';

/*************************************************************************************
 * Purpose   : This is a utility method for sending out error email notifications related to 
 *             FDL GetRelatedEntities requests. It uses fields from the request and response objects to
 *             compose the message.
 *             
 * Parameters: FDL_Message - the request, response objects of the failing transaction.
 *             
 * Return    : None
 *************************************************************************************/
public static void sendFDLErrorNotification(FDL_Message request, FDL_Message response) {
	String subject = 'Facets Integration request Error';
	String bodyText = 
	'\n The System did not process the following Facets request:' +
	'\n Request = ' + String.ValueOf( request) + 
	'\n Response= ' + String.ValueOf( response);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String supportEmail = SFDCSupportEmailAddress; // default value in case nothing is configured in EnvironmentVariable__c
    String fciTeamEmail = FacetsSupportEmailAddress;
    
    List<String> emailAddresses = new List<String>();
    if(String.isNotBlank(SFDCSupportEmailAddress)) { 
          supportEmail = SFDCSupportEmailAddress;
          emailAddresses.addAll(supportEmail.split(',\\s*'));   // Allow multiple comma separated email addresses
    }           
    if(String.isNotBlank(FacetsSupportEmailAddress)) {
         fciTeamEmail = FacetsSupportEmailAddress;
         emailAddresses.addAll(fciTeamEmail.split(',\\s*'));    // Allow multiple comma separated email addresses
    }     
    mail.setToAddresses(emailAddresses);
    mail.setReplyTo(emailAddresses[0]);
    mail.setSenderDisplayName('CareFirst Salesforce System');
    mail.setSubject(subject);                           
    mail.setPlainTextBody(bodyText);
    Messaging.SendEmailResult[] emailresult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    System.debug('Support team notified :' + 'Subject:' + subject + '; Message body: ' + bodyText + '; Result: ' + emailresult);    
    } 
}