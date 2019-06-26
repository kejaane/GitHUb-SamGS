/*=========================================================================================
 * Date			: 9/26/16
 * Developer	: Ken Gill
 * Purpose   	:  
 * 
 *               This is a Mock class implementation of the MSI_MemberServiceProxy web service class
 *               and is used as a replacement to support Unit Test code.
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 9/26/16   |  KG    |	Initial Version                                         
 *   	     |        | 
 *=========================================================================================
 */

@isTest                     
global class MSI_MemberServiceProxyImpl implements WebServiceMock {
	

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

	       System.debug('MSI_MemberServiceProxyImpl invoked');    
           if(request instanceof MSI_MemberServiceProxy.MemberSummaryRequestMessage_element) {
//                MSI_MemberServiceProxy.MemberSummaryResponseMessage_element response_x
 //                   =  new  MSI_MemberServiceProxy.MemberSummaryResponseMessage_element();
           	//------         
           			MSI_MemberServiceProxy.memberSummaryResponseMessage_element response_x = new MSI_MemberServiceProxy.memberSummaryResponseMessage_element();

				MSI_MemberServiceProxy.StatusBlock_element validStatusBlock = new MSI_MemberServiceProxy.StatusBlock_element();
				MSI_MemberServiceProxy.StatusBlock_element inValidStatusBlock = new MSI_MemberServiceProxy.StatusBlock_element();
		
		
				validStatusBlock.statusCode = '00';
				validStatusBlock.Message = new List<MSI_MemberServiceProxy.StatusBlock_Message_element>(); 
				
				inValidStatusBlock.statusCode = '01';
				inValidStatusBlock.Message = new List<MSI_MemberServiceProxy.StatusBlock_Message_element>(); 
				MSI_MemberServiceProxy.StatusBlock_Message_element me = new MSI_MemberServiceProxy.StatusBlock_Message_element();
				me.mesgCode = '1';
				me.mesgDesc = 'mesgDesc';
				inValidStatusBlock.Message.add( me);
		
				response_x.StatusBlock = validStatusBlock;
				// 		proxyResponse.StatusBlock = inValidStatusBlock;
		
		
				MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_element[] MemberSummaryResponseList = 
				             new List<MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_element>();
		
				MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_element memSumResponse = 
				             new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_element();
		
				MemberSummaryResponseList.add(memSumResponse);
				response_x.MemberSummaryResponse = MemberSummaryResponseList;	
		
				// Now populate the memSumResponse element
		
				memSumResponse.subscriberContrivedKey = 'x';
				memSumResponse.groupContrivedKey = 'x';
				memSumResponse.groupID = 'x';
				memSumResponse.grpName = 'x';
				memSumResponse.subscriberID = 'x';
				memSumResponse.subLastName = 'x';
				memSumResponse.subFirstName = 'x';
				memSumResponse.subMiddleName = 'x';
				memSumResponse.subTitle = 'x';
				memSumResponse.subOrgEffDate = 'x';
				memSumResponse.subFamilyInd = 'x';
				memSumResponse.subFamilyIndDesc = 'x';
				memSumResponse.bankRelationshipContrivedKey = 'x';
				memSumResponse.subHomeAddressType = 'x';
				memSumResponse.subMailingAddressType = 'x';
				memSumResponse.subHireDate = 'x';
				memSumResponse.subRetireDate = 'x';
				memSumResponse.subStatus = 'x';
		
				memSumResponse.SubscriberClassDetails = new List<MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberClassDetails_element>();
				memSumResponse.SubscriberEligibilityDetails = new List<MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberEligibilityDetails_element>(); 
		
				memSumResponse.SubscriberAddressDetails = new List<MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberAddressDetails_element>();
				memSumResponse.SubscriberSubGroupDetails = new List<MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberSubGroupDetails_element>();
				memSumResponse.SubscriberSalaryDetails = new List<MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberSalaryDetails_element>();
				memSumResponse.SubscriberRateModifier  = new List<MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberRateModifier_element>();
				memSumResponse.SubscriberRateRecordTypeDetails= new List<MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_SubscriberRateRecordTypeDetails_element>();
				memSumResponse.MemberDetails = new List<MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_MemberDetails_element>();
				memSumResponse.AdditionalDetails = new MSI_MemberServiceProxy.memberSummaryResponseMessage_MemberSummaryResponse_AdditionalDetails_element();
                            
                response.put('response_x', response_x); 
                System.debug('MSI_MemberServiceProxyMockImpl CreateCaseRequest handled');
            }

/*                        
            if(request instanceof MSI_MemberServiceProxy.createCaseRequestMessage_element) {
                MSI_MemberServiceProxy.createCaseResponseMessage_element response_x
                    =  new  MSI_MemberServiceProxy.CreateCaseResponseMessage_element();
                    
                response_x.StatusBlock =  new MSI_MemberServiceProxy.StatusBlock_element();
                MSI_MemberServiceProxy.Message_element success_me = new MSI_MemberServiceProxy.Message_element();
                success_me.mesgCode= '119';
                success_me.mesgDesc ='Success in Updating Facets DB';
                MSI_MemberServiceProxy.Message_element[] messageElement_Array = new MSI_MemberServiceProxy.Message_element[]{ success_me };
                response_x.StatusBlock.statusCode = '00';
                response_X.StatusBlock.Message = messageElement_Array;
                                       
                response_x.CreateCaseResponse = new MSI_MemberServiceProxy.CreateCaseResponse_element();   
                response_x.CreateCaseResponse.itemTicketNo = '135EEBE4-84D0-4FD9-9359-2716F3704388'; 
                response_x.CreateCaseResponse.itemStatus='3'; 
                response_x.CreateCaseResponse.custSrvcID = '153140000019';    
                            
                response.put('response_x', response_x); 
                System.debug('MSI_MemberServiceProxyMockImpl CreateCaseRequest handled');
            }
*/            
            
   }            
   
   
}