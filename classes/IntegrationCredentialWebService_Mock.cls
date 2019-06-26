/*===========================================================================================
 * Date         : 07/10/2018
 * Developer    : Sree Uma Ponnoju
 * Purpose      : This class is a generic WebServiceMock class needed to test callouts.
 *                
 *===========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *============+=======+======================================================================
 * 
 *============+=======+======================================================================
 */
public class IntegrationCredentialWebService_Mock implements WebServiceMock {    
       
    public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
            ){
             
            if (request instanceof MetadataService.updateMetadata_element) {

            MetadataService.SaveResult result = new MetadataService.SaveResult();
            result.success = true;

            MetadataService.updateMetadataResponse_element responseElement = new MetadataService.updateMetadataResponse_element();
            responseElement.result = new MetadataService.SaveResult[] {result};
            response.put('response_x', responseElement);
        
        }  else {
            System.debug('====> Exception ' );
        }
    }
}