@isTest
                        
global class EGPServiceProxyMockImpl implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

            System.debug('EGPServiceProxyMockImpl invoked');    
            if(request instanceof EGPServiceProxy.manageUserRequest_element) {
                EGPServiceProxy.manageUserResponse_element response_x
                    = new EGPServiceProxy.manageUserResponse_element();
                // populate any fields you care to
                // ...
                response.put('response_x', response_x); 
            }
            
            if(request instanceof EGPServiceProxy.accountUpdateRequest_element) {
                EGPServiceProxy.accountUpdateResponse_element response_x
                    = new EGPServiceProxy.accountUpdateResponse_element();
                // populate any fields you care to
                // ...
                response.put('response_x', response_x); 
            }
   }
}