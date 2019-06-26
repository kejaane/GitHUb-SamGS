/*===========================================================================================
 * Date         : 05/03/2018
 * Developer    : Sree Uma Ponnoju
 * Purpose      : This class is a generic HTTPcalloutMock class needed to test callouts.
 *                
 *===========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *============+=======+======================================================================
 * 
 *============+=======+======================================================================
 */
@isTest
global class IntegrationCredentialHttp_Mock implements HttpcalloutMock { 
  protected Integer statusCode;
    protected String status;
    protected String bodyAsString;
    protected Blob bodyAsBlob;
    protected Map<String, String> responseHeaders;
    
    public IntegrationCredentialHttp_Mock(Integer statusCode, String status, String body, Map<String, String> responseHeaders) {
        this.statusCode = statusCode;
        this.status = status;
        this.bodyAsString = body;
        this.responseHeaders = responseHeaders;
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HTTPResponse();
        response.setStatusCode(statusCode);
        response.setStatus(status);
        if (bodyAsBlob != null) {
            response.setBodyAsBlob(bodyAsBlob);
        } else {
            response.setBody(bodyAsString);
        }
        if (responseHeaders != null) {
            for (String key : responseHeaders.keySet()) {
                response.setHeader(key, responseHeaders.get(key));
            }
        }
        return response;
    }           
}