/*=========================================================================================
 * Date		: 11/6/15
 * Developer	: Ken Gill
 * Purpose   	:  
 * 
 *               This is a Mock class implementation of the FCI_FacetsServiceProxy web service class
 *               and is used as a replacement to support Unit Test code.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 11/6/15   |  KG    |	Initial Version                                         
 *   	     |        | 
 *=========================================================================================
 */

@isTest                     
global class FCI_FacetsServiceProxyMockImpl implements WebServiceMock {
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

            System.debug('FCI_FacetsServiceProxyMockImpl invoked');    
            if(request instanceof FCI_FacetsServiceProxy.createCaseRequestMessage_element) {
                FCI_FacetsServiceProxy.createCaseResponseMessage_element response_x
                    =  new  FCI_FacetsServiceProxy.CreateCaseResponseMessage_element();
                    
                response_x.StatusBlock =  new FCI_FacetsServiceProxy.StatusBlock_element();
                FCI_FacetsServiceProxy.Message_element success_me = new FCI_FacetsServiceProxy.Message_element();
                success_me.mesgCode= '119';
                success_me.mesgDesc ='Success in Updating Facets DB';
                FCI_FacetsServiceProxy.Message_element[] messageElement_Array = new FCI_FacetsServiceProxy.Message_element[]{ success_me };
                response_x.StatusBlock.statusCode = '00';
                response_X.StatusBlock.Message = messageElement_Array;
                                       
                response_x.CreateCaseResponse = new FCI_FacetsServiceProxy.CreateCaseResponse_element();   
                response_x.CreateCaseResponse.itemTicketNo = '135EEBE4-84D0-4FD9-9359-2716F3704388'; 
                response_x.CreateCaseResponse.itemStatus='3'; 
                response_x.CreateCaseResponse.custSrvcID = '153140000019';    
                            
                response.put('response_x', response_x); 
                System.debug('FCI_FacetsServiceProxyMockImpl CreateCaseRequest handled');
            }
            
            if(request instanceof FCI_FacetsServiceProxy.updateCaseRequestMessage_element) {
                FCI_FacetsServiceProxy.updateCaseResponseMessage_element response_x
                    = new FCI_FacetsServiceProxy.updateCaseResponseMessage_element();
                // populate any fields you care to
                // ...
                FCI_FacetsServiceProxy.Message_element success_me = new FCI_FacetsServiceProxy.Message_element();
                success_me.mesgCode= '119';
                success_me.mesgDesc ='Success in Updating Facets DB';
                FCI_FacetsServiceProxy.Message_element[] messageElement_Array = 
                        new FCI_FacetsServiceProxy.Message_element[]{ success_me };
                        
    			FCI_FacetsServiceProxy.StatusBlock_element statusBlock = new FCI_FacetsServiceProxy.StatusBlock_element();
                statusBlock.statusCode = '00'; 
    			statusBlock.Message = messageElement_Array;
    			               
                response_x = new FCI_FacetsServiceProxy.updateCaseResponseMessage_element();
                response_x.StatusBlock = statusBlock;
                response.put('response_x', response_x); 
                System.debug('FCI_FacetsServiceProxyMockImpl UpdateCaseRequest handled');
            }
   }
}