@isTest
global class AIA_WebServiceMOCKPCSIntegrationError implements HttpCalloutMock {
   global HTTPResponse respond(HTTPRequest req) {
        system.debug('@@req in mockwebservice'+req);
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');        
        res.setBody('{"ResponseCode":"BC-0001"}'); //put your Json response here
        res.setStatusCode(200);
        return res;
    }
}