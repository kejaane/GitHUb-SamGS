//=========================================================================================
//      Date: 04/15/2018
// Developer: Tom Barrett (TPB)
//   Purpose: This class is a generic HTTPcalloutMock class needed to test callouts.
//            
//=========================================================================================
//                                 Update History
// Date       Developer     Tag		Description
//=========================================================================================
//
//=========================================================================================
@isTest
global class SM_RequestMock implements HttpcalloutMock { 
	protected Integer statusCode;
    protected String status;
    protected String bodyAsString;
    protected Blob bodyAsBlob;
    protected Map<String, String> responseHeaders;    
    protected Boolean throwCalloutException;	
 
    public SM_RequestMock(Integer statusCode, String status, String body, Map<String, String> responseHeaders, Boolean throwCalloutException) {
        this.statusCode = statusCode;
        this.status = status;
        this.bodyAsString = body;
        this.responseHeaders = responseHeaders;    
        this.throwCalloutException = throwCalloutException;
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
        if (this.throwCalloutException) {
            CalloutException e = new CalloutException();
            e.setMessage('This is a custom contructed exception!');
            throw e;
        }        
        return response;
    }           
}