/*=================================================================================================
* Date         : 06/08/2017
* Developer    : Debkanti
* Purpose      : This class function is to test the AIA_OP4synchCustomizedPlansWithPCS_Batch class.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 06/08/2017| Debkanti    |   | Initial Version                                         
* 01-18-2019 	Chaithra  |T01| Created users for account team role as per US1702 and US1730
*===========+============+=====+===================================================================
*/

@isTest
public class AIA_OP4synchCustomizedPlansWithPCS_Test {
    
    public static testMethod void testMethod1()
    {
        
        //Test.startTest();
        // Create an instance of query locator
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
        //Creating WorkPlan Type Test Data 
        //AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales');//Removed as per US210 
        
        
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
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Removed WP as per US210
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
        
        List<AIA_Benefit_Design_Product__c> BDPlist = new List<AIA_Benefit_Design_Product__c> ();
        BDPlist.add(bdp);
        List<AIA_Benefit_Design_Product__c> BDPlist1 = new List<AIA_Benefit_Design_Product__c> ();
        
        //API_OP4_ENDPOINT_URLS__c cs = new API_OP4_ENDPOINT_URLS__c();
        //cs.name='OP4_PCS_APIDetails';
        //cs.OP4_ENDPOINT_URL__c = 'https://servicestt.carefirst.com/pcs7devb/PRRestService/PCSSFDCIntegrator/RESTJSON/CreatePlan';        
        //insert cs;
        API_ENDPOINT_URLS__c cs = new API_ENDPOINT_URLS__c();
        cs.name='OP4_PCS_APIDetails';
        cs.ENDPOINT_URL__c ='https://servicestt.carefirst.com/pcs7sitb/PRRestService/PCSSFDCIntegrator/RESTJSON/CreatePlan';
        Test.setMock(HttpCalloutMock.class, new AIA_WebServiceMOCKPCSIntegration());
        insert cs;
        //Exception e = null;
        AIA_Utils errLogExp = new AIA_Utils();
        
        AIA_OP4synchCustomizedPlansWithPCS_Batch obj = new AIA_Op4synchCustomizedPlansWithPCS_Batch();
        
        // execute start method
        QL = obj.start(bc);       
        // Create an instance of Query Locator Iterator
        Database.QueryLocatorIterator QLI =  QL.iterator();
        while (QLI.hasNext())
        {
            AIA_Benefit_Design_Product__c bDP1 = (AIA_Benefit_Design_Product__c)QLI.next();
            BDPlist1.add(bDP1);
            
        }
        system.debug('BDPList : '+BDPlist1);
        
        Database.executeBatch(obj,33);
        
    }
    @isTest static void testSaveToSetUpObjects() {
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        AIA_OP4synchCustomizedPlansWithPCS_Batch obj = new AIA_Op4synchCustomizedPlansWithPCS_Batch();
        List<AIA_Benefit_Design_Product__c> BDPlist1 = new List<AIA_Benefit_Design_Product__c> ();
        
        // execute start method
        QL = obj.start(bc);       
        // Create an instance of Query Locator Iterator
        Database.QueryLocatorIterator QLI =  QL.iterator();
        while (QLI.hasNext())
        {
            AIA_Benefit_Design_Product__c bDP1 = (AIA_Benefit_Design_Product__c)QLI.next();
            BDPlist1.add(bDP1);
            
        }
        String schTime = '0 0 12 * * ?';
        system.schedule('TestUpdateConAccJob', schTime, obj);
        //Call Method
        obj.execute(BC, BDPlist1);
        //execute finish method
        obj.finish(BC); 
        //DataBase.executeBatch(obj); 
    }
    
    public static testMethod void testMethod2()
    {
        try{ 
        //Test.startTest();
        // Create an instance of query locator
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        
        //Creating Account Test Data 
        Account accnt = AIA_TestUtil.acc();
        //Creating WorkPlan Type Test Data 
        //AIA_Workplan_Type__c wpt =AIA_TestUtil.wrkPln('Pre-Sales');//Removed per US210 
        
        
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
        //Creating User Test Data T02 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T02 ends
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
        //Creating AccountMember Test Data T02 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u20.id,'Pharmacy Operations'));
		//T02 ends
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
        AIA_Benefit_Design_Product__c bdp1 = AIA_TestUtil.CreateBDP(bd.id,'123',proPrd.id);
        
        List<AIA_Benefit_Design_Product__c> BDPlist = new List<AIA_Benefit_Design_Product__c> ();
        BDPlist.add(bdp);
        BDPlist.add(bdp1);
        List<AIA_Benefit_Design_Product__c> BDPlist1 = new List<AIA_Benefit_Design_Product__c> ();
        
        //API_OP4_ENDPOINT_URLS__c cs = new API_OP4_ENDPOINT_URLS__c();
        //cs.name='OP4_PCS_APIDetails';
        //cs.OP4_ENDPOINT_URL__c = 'https://servicestt.carefirst.com/pcs7devb/PRRestService/PCSSFDCIntegrator/RESTJSON/CreatePlan';        
        //insert cs;
        API_ENDPOINT_URLS__c cs = new API_ENDPOINT_URLS__c();
        cs.name='OP4_PCS_APIDetails';
        cs.ENDPOINT_URL__c ='https://servicestt.carefirst.com/pcs7sitb/PRRestService/PCSSFDCIntegrator/RESTJSON/CreatePlan';
        Test.setMock(HttpCalloutMock.class, new AIA_WebServiceMOCKPCSIntegration());
        insert cs;
        Test.setMock(HttpCalloutMock.class, new AIA_WebServiceMOCKPCSIntegration());
        AIA_Utils errLogExp = new AIA_Utils();
        
        AIA_OP4synchCustomizedPlansWithPCS_Batch obj = new AIA_Op4synchCustomizedPlansWithPCS_Batch();
        
        // execute start method
        QL = obj.start(bc);       
        // Create an instance of Query Locator Iterator
        Database.QueryLocatorIterator QLI =  QL.iterator();
        while (QLI.hasNext())
        {
            AIA_Benefit_Design_Product__c bDP2 = (AIA_Benefit_Design_Product__c)QLI.next();
            BDPlist1.add(bDP2);
            
        }
        system.debug('BDPList : '+BDPlist1);
        String schTime = '0 0 12 * * ?';
        system.schedule('TestUpdateConAccJob', schTime, obj);
        }
        catch (System.Exception e) {
            System.debug('finish:' + e);
        }
        }
    
    
}