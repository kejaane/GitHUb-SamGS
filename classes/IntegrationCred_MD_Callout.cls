/*===========================================================================================
 * Date         : 07/01/2018
 * Developer    : Mike Horne, Sree Uma Ponnoju
 * Purpose      : Creating this Queueable class, to make a callout to Apex Metadata API which
                  allows in updating named credentials
 *                
 *===========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *============+=======+======================================================================
 * 
 *============+=======+======================================================================
 */
//@isTest
public class IntegrationCred_MD_Callout implements Queueable, Database.AllowsCallouts  {  

    List<MetadataService.NamedCredential> updateNamedcred = new List<MetadataService.NamedCredential>();
    
    public IntegrationCred_MD_Callout(List<MetadataService.NamedCredential> namedcreds) {
        System.debug('Value of namedcreds is' + namedcreds);
        this.updateNamedcred = namedcreds;
        /*for (MetadataService.NamedCredential NC : namedcreds) {               
                updateNamedcred.add(NC);                
        }*/
    }

    public void execute(QueueableContext context) {
        System.debug('The value of updateNamedCred is ' + updateNamedCred);
        if (!updateNamedcred.isEmpty()) {
            MetadataService.MetadataPort service = createService();
            service.updateMetadata(updateNamedcred);
        }
    }
    
    /*************************************************************************************
    * Purpose   : Create connection object for interactions with Apex metadata API
    * Return    : Service  
    *************************************************************************************/  
    //@isTest
    private static MetadataService.MetadataPort createService() {
         // First do a throw-away REST API call which correctly returns a 401 error code when a 
         //   session has expired. Thus allowing OAuth to refresh session token. 
         //   The SOAP API doesn't allow for this due to returning a non-standard 500 error for 
         //   an invalid session.
         String restUrl = 'callout:ApexMDAPI/services/data/v39.0/limits';
         Http h = new Http();
         HttpRequest req = new HttpRequest();
         req.setEndpoint(restUrl);
         req.setMethod('GET');
         
         HttpResponse res = h.send(req);
         
         String responseBody = res.getBody(); 
         System.debug( '====> responseBody : ' + responseBody ); 
                       
         // Now do your Metadata Service calls here.
         MetadataService.MetadataPort service = new MetadataService.MetadataPort();
         // Pointing to NC can be done here instead of modifying MetadataService class
         //    Which has already been updated in mwhorne org
         service.endpoint_x = 'callout:ApexMDAPI/services/Soap/m/38.0';
         service.SessionHeader = new MetadataService.SessionHeader_element();
         //service.SessionHeader.sessionId = UserInfo.getSessionId();
         service.SessionHeader.sessionId = '{!$Credential.OAuthToken}';
         System.debug('Value of Service is ' + service);
         return service;
         }
}