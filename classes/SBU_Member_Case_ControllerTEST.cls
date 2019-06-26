@isTest(seealldata=false)
public class SBU_Member_Case_ControllerTEST {
 private class RestMock implements HttpCalloutMock {
        Id sobId;
        RestMock(Id claimId) {
            claimId = sobId;
        }
        public HTTPResponse respond(HTTPRequest req) {
            // Can assert that the request is correct here
            // Generate a typical response
            String fullJson = '{"foo":"bar"}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }

//Variable declaration
 public static Case objCase;
 public static Account objAcc;
  public static Account objAcc1; public static Contact objCon;
 // Create test records
   Public Static void CreateCase(){
         objCase = new Case();
         objCase.E_description__c='Test';
         objCase.ownerid=userInfo.getUserid();
        // objCase.recordTypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('SBU_Member_Case').getRecordTypeId();
         objCase.M_First_Name__c='First';
         objCase.M_last_Name__c='Last';
         objCase.M_age__c=12;
         objCase.E_Plan_ID__c='plan';
         objCase.E_Plan_description__c='E plan description';
         objCase.E_Termination_date__c=system.today();
         objCase.E_Effective_date__c=system.today();
         objCase.E_Product__c='123';
         objCase.M_Street__C='Street';
         objCase.M_State__c='State';
         objCase.Subscriber_Id__c='012345678';
        // objCase.Member_Type__c = 'Subscriber';
         objCase.M_Country__c='Country';
         objCase.M_Relationship__c='01';
         objCase.M_ID__c='mid';
         objCase.M_Zip_Code__c='Bs2';
         objCase.M_Date_of_Birth__c=system.today();
         objCase.M_Phone__c='12345678';
         objCase.ContactId = objCon.Id;
         insert objCase;
 
     }
    
    Public static void CreateAccount(){
        objAcc = new Account();
        objAcc.Name='Test Account';
        insert objAcc;
    } 
    
    Public static void CreateAccount1(){
        objAcc1 = new Account();
        objAcc1.Name='Community_User_Account';
        insert objAcc1;
    } 
  
   Public static void CreateContact(){
        objCon = new Contact();
        objCon.FirstName='First';
        objCon.LastName='Last';
        objCon.email='test@test.com';
        objCon.Accountid=objAcc.id;
        objCon.Phone= '0993456789';
        objCon.recordTypeId = QueryBase.getRecordtypeId('Contact', 'Community_User_Contact');
        insert objCon;
    }
    public static testMethod void validate1(){ 
     Test.startTest();
     CreateAccount();
     CreateAccount1();
     CreateContact();
     CreateCase();
     
    
     Test.StopTest(); 
     MSI_MemberSummaryRequest request = new MSI_MemberSummaryRequest();
     request.subscriberId = objCase.Subscriber_Id__c;
     SBU_Member_Case_Controller cntrlSBU = new SBU_Member_Case_Controller();
    SBU_Member_Case_Controller ctrlSBU = new SBU_Member_Case_Controller(new ApexPages.StandardController(objCase));
    //Test.setMock(HttpCalloutMock.class, new RestMock(objCase.Id));
      MSI_MemberSummaryResponse response = MSI_MemberService.getMemberDetails(request);
    ctrlSBU.callWithSubscriberId();
   ctrlSBU.selectGroup='3438';
   
   ctrlSBU.createCase();
   ctrlSBU.selectmember = 'test';
    ctrlSBU.assignPlan();
    ctrlSBU.callWithSubscriberId();
    ctrlSBU.setEligibility();
    ctrlSBU.planid= 243;
    
    ctrlSBU.assignEligibility();
   /* ctrlSBU.getEligibiltyTable();*/
    //Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SBU_Member_Case').getRecordTypeId();
    id accId = ApexPages.currentPage().getParameters().put('def_account_id',objAcc.id); // get account id
    ctrlSBU.getRedir();
    id entId = ApexPages.currentPage().getParameters().put('def_entitlement_id',objAcc.id ); // get Entitlement id
    id conId = ApexPages.currentPage().getParameters().put('def_contact_id',objCon.id); // get Contact id
    ctrlSBU.getRedir();
    //id RecType = ApexPages.currentPage().getParameters().put('RecordType',devRecordTypeId); // get record type id
    
    ctrlSBU.getRedir();
    
      }
 }