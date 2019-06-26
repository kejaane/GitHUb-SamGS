@isTest
global class AIA_WebServiceMOCKPCSIntegration implements HttpCalloutMock {
   global HTTPResponse respond(HTTPRequest req) {
        system.debug('@@req in mockwebservice'+req);
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');        
        res.setBody('{"response":[{"TierCount":3,"TermDate":"yyyy-mm-dd"}]}'); //put your Json response here
        res.setStatusCode(200);
        system.debug('@@res in mockwebservice'+res);
        system.debug('@@response in mockwebservice'+res.getBody());
        return res;
    }
}