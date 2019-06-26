/*=========================================================================================
* Date         : 08/18/2017
* Developer    : Asif Kutagulla
* Purpose      : This is test class for the webservice class AIA_Op5_PCSCustomPlanIdUpdate
*=========================================================================================
*                                 Update History
*                                 ---------------
* Date       | Developer   | Tag |   Description
*-----------------------------------------------------------------------------------------
* 08/18/2017 | Asif K      |     | Initial build
* 01-18-2019    Chaithra        |T01| Created users for account team role as per US1702 and US1730
*=========================================================================================
*/

@isTest
private class AIA_Op5_PCSCustomPlanIdUpdate_Test {  
    @testsetup
    static void createTestData() {
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
         
        User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF35@testorg.com.test');
        insert u4;
        
        //Create Account
        Account acc =AIA_TestUtil.createAccount('TestOEMAcc');
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id);           
        
        /*AccountTeamMember atm3 = new AccountTeamMember ();
        atm3.TeamMemberRole = 'Contract Tech';
        atm3.AccountId = acc.id;
        atm3.UserId = u4.id;
        insert atm3; */
        
                 Account_Team__c atmRole1 =new Account_Team__c();
                 atmRole1.UserId__c=u4.id;
                 atmRole1.TeamMemberRole__c='Contract Tech';
                 atmRole1.AccountId__c =acc.id;   
                 insert atmRole1;
        

        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = acc.id;
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Opportunity__c = opp.id;
        nbrf.Jurisdiction__c = 'MD';
        insert nbrf;    
        
        Test.startTest();
        //Create Benefit Design
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.Id;
        Imp.Account__c = acc.Id;
        //Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
         Imp.Benefit_Request_Form__c = nbrf.id;
        insert Imp;
       
        AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
        aiaBD.Implementation__c = Imp.id;
        aiaBD.Account__c = acc.Id;
        aiaBD.Benefit_Request_Form__c = nbrf.Id;
        insert aiaBD;      
        
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();
        aiaBDP1.Benefit_Design__c = aiaBD.id;
        insert aiaBDP1;
         Test.stopTest();
    }
    
    static testMethod void testDoPost_Success()
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/AIA_BenefitDesignProduct/UpdatePCSplanID';  
        
        map<String,String> reqBody = new map<String,String>();
            
        AIA_Benefit_Design_Product__c bdp = [SELECT Id,PCS_Custom_Plan_Id__c FROM AIA_Benefit_Design_Product__c LIMIT 1];
    
        reqBody.put('SFDCId', bdp.Id);
        reqBody.put('PCSPlanId', '344893');
        req.requestBody = Blob.valueOf(JSON.serialize(reqBody));
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        system.debug('in test class-requestBody string 1---'+RestContext.request);
        system.debug('in test class-requestBody string 2---'+RestContext.request.requestBody.toString());
        
        Test.startTest();
        AIA_Op5_PCSCustomPlanIdUpdate.doPost();
        Test.stopTest();
        
        //Testing if webservice returns successful response code
        String testBlob = res.responseBody.toString();
        system.debug('res.responseBody.toString();--'+res.responseBody.toString());
        System.assert(testBlob.contains('1111'));
        
        //Testing if the BDP record is updated with intended PCSPlanId
        AIA_Benefit_Design_Product__c bdpToTest = [Select Id,PCS_Custom_Plan_Id__c From AIA_Benefit_Design_Product__c LIMIT 1];
        System.assertEquals('344893', bdpToTest.PCS_Custom_Plan_Id__c);
        
    }
    static testMethod void testDoPost_InvalidRequest_Error2()
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/AIA_BenefitDesignProduct/UpdatePCSplanID';  
        
        map<String,String> reqBody = new map<String,String>();
            
        reqBody.put('SFDCId', '0070hg667jhgkk');
        reqBody.put('PCSPlanId', 'sdfdsafs');
        req.requestBody = Blob.valueOf(JSON.serialize(reqBody));
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        AIA_Op5_PCSCustomPlanIdUpdate.doPost();
        Test.stopTest();
        
        //Testing if webservice returns failed response code
        String testBlob = res.responseBody.toString();
        system.debug('res.responseBody.toString();--'+res.responseBody.toString());
        System.assert(testBlob.contains('0002'));
    }
    static testMethod void testDoPost_InvalidRequest_Error3()
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/AIA_BenefitDesignProduct/UpdatePCSplanID';  
        
        map<String,String> reqBody = new map<String,String>();
            
        reqBody.put('SFDCId', '0070hg667jhgkk');
        reqBody.put('PCSPlanId', '');
        req.requestBody = Blob.valueOf(JSON.serialize(reqBody));
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        AIA_Op5_PCSCustomPlanIdUpdate.doPost();
        Test.stopTest();
        
        //Testing if webservice returns failed response code
        String testBlob = res.responseBody.toString();
        system.debug('res.responseBody.toString();--'+res.responseBody.toString());
        //System.assert(testBlob.contains('0002'));
    }
    /*static testMethod void testDoPost_InvalidRequest_Error1()
    {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
    
        req.requestURI = '/services/apexrest/AIA_BenefitDesignProduct/UpdatePCSplanID';  
        
        map<String,String> reqBody = new map<String,String>();
            
        AIA_Benefit_Design_Product__c bdp = [SELECT Id,PCS_Custom_Plan_Id__c FROM AIA_Benefit_Design_Product__c LIMIT 1];
    
        reqBody.put('SFDCId', bdp.Id);
        reqBody.put('PCSPlanId', '344893344893344893344893344893');
        req.requestBody = Blob.valueOf(JSON.serialize(reqBody));
        
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        AIA_Op5_PCSCustomPlanIdUpdate.doPost();
        Test.stopTest();
        
        //Testing if webservice returns failed response code
        String testBlob = res.responseBody.toString();
        system.debug('res.responseBody.toString();--'+res.responseBody.toString());
        System.assert(testBlob.contains('0001'));
    }*/
    
}