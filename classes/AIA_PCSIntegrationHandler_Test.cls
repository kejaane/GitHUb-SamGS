/*==========================================================================================================
* Date         : 08/15/2016
* Developer    : Sree Harsha           
*===========================================================================================================
*                                 Update History
*                                 ---------------
* Date      + Developer      +  Tag  + Description
*===========+================+=======+======================================================================
* 08/08/2016| Sree Harsha    |       | Initial Version                                         
* 01/05/2017| Asif Kutagulla |       | Removed commented code. Removed dependency on Authorization token
*                                      since it is not being used
* 07/07/2017|Debkanti		 |		 | Added test method testCallPCS1
*===========+============+==================================================================================
*/

/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers
 *
    **/

@isTest
public class AIA_PCSIntegrationHandler_Test{
    static testmethod void testCallPCS(){
        API_ENDPOINT_URLS__c cs = new API_ENDPOINT_URLS__c();
        cs.name='PCS_APIDetails';
        cs.ENDPOINT_URL__c = 'https://servicestt.carefirst.com/pcs7devb/PRRestService/PCSSFDCIntegrator/RESTJSON/SendPlanDetails';        
        insert cs;
        AIA_Plan__c plan = AIA_TestUtil.CreatePlan('PLAN - 1111');
        Test.setMock(HttpCalloutMock.class, new AIA_WebServiceMOCKPCSIntegration());
        Test.startTest();
        AIA_PCSIntegrationHandler.callPCS(plan.plan_id__c,'BRF','a0N000000236s','2017-01-05');
        Test.stopTest();
        
    }
    static testmethod void testCallPCS2(){
        API_ENDPOINT_URLS__c cs = new API_ENDPOINT_URLS__c();
        cs.name='PCS_APIDetails';
        cs.ENDPOINT_URL__c = 'https://servicestt.carefirst.com/pcs7devb/PRRestService/PCSSFDCIntegrator/RESTJSON/SendPlanDetails';        
        insert cs;
        AIA_Plan__c plan = AIA_TestUtil.CreatePlan('PLAN - 1111');
        Test.setMock(HttpCalloutMock.class, new AIA_WebServiceMOCKPCSIntegration());
        Test.startTest();
        AIA_PCSIntegrationHandler.callPCS(plan.plan_id__c,'BDD','a0N000000236s','2017-01-05');
        Test.stopTest();
        
    }
    
    public static AIA_Benefit_Design__c cCreateBenefitDesignWImpFromBrf(Account acc, string oppid, string brfid){
          
            
     AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = oppid;
        Imp.Account__c = acc.id;
        // Imp.Account__c = Imp.Opportunity__r.AccountId;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        //  insert Imp;
                
     AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        //aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.id;
        aiaBD.Benefit_Request_Form__c = brfId;
        aiaBD.Approval_Status__c = 'Approved';
         insert aiaBD;
        return aiaBD;
    } 
    
    
    
    static testmethod void testCallPCS1(){
        API_ENDPOINT_URLS__c cs = new API_ENDPOINT_URLS__c();
        cs.name='AIA OP4 PCS EndPoint URL';
        cs.ENDPOINT_URL__c = 'https://servicestt.carefirst.com/pcs7devb/PRRestService/PCSSFDCIntegrator/RESTJSON/CreatePlan';        
        insert cs;
        
     //Creating Account Test Data 
    Account accnt = AIA_TestUtil.acc();
         
    //Creating WorkPlan Type Test Data 
    //AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales'); //Removed per US210
        
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
      /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
      /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        //Creating User Test Data T01 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T01 ends
         insert userList;
    
    
    //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        //Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u20.id,'Pharmacy Operations'));
		//T01 ends
         insert acctMbrList;
       
     
    //Creating Opportunity Test Data   
    Opportunity o = AIA_TestUtil.opp(accnt.Id);//Removed WP per US210
    //Creating benefit Request Form Test Data 
    Benfit_Request_Form__c brf = AIA_TestUtil.benForm(accnt.Id,o.id);
    //Creating AIA Plan Test Data 
    AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
    //Creating Proposed Plan Test Data 
    Proposed_Products__c proPrd = AIA_TestUtil.proposedProduct(brf.id,aiapln.id);
    //Creating Benefit Design Test Data  
    AIA_Benefit_Design__c bd=AIA_TestUtil.cCreateBenefitDesignWImpFromBrf(accnt.id,o.id,brf.id);
    //Creating AIA_PCS_Op4_ErrorCodes__c data:
    AIA_PCS_Op4_ErrorCodes__c errorCode = AIA_TestUtil.errCode('BC-0001','BC-0001');
    //Creating Benefit Design Product Test Data 
    AIA_Benefit_Design_Product__c bdp= AIA_TestUtil.CreateBDP(bd.id,aiapln.id,proPrd.id);
        
        Test.setMock(HttpCalloutMock.class, new AIA_WebServiceMOCKPCSIntegration());
        Test.startTest();
        AIA_PCSIntegrationHandler.callPCS(bdp.id);
        Test.stopTest();
        
    }
}