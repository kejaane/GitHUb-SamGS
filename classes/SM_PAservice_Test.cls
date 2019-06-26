//=========================================================================================
//      Date: 07/30/2018
// Developer: Tom Barrett (TPB)
//   Purpose: This class is a test class to get code coverage for the SM_PAservice class
//            
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
@istest
public class SM_PAservice_Test {   
    @testSetup static void createUsers() {
        Profile pf= [Select Id from profile where Name='System Administrator'];
        List<User> UserList = new List<User>();       
        String orgId=UserInfo.getOrganizationId(); 
        String uniqueName=orgId + System.currentTimeMillis(); 
        User u = new User(firstname = 'Test1', 
                         lastName = 'Tester', 
                         email = 'test1.tester' + '@somecompany' + orgId + '.org', 
                         Username = 'test1.tester' + '@somecompany' + orgId + '.org', 
                         isActive = true,
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        UserList.add(u);
        //Second User not active
        User u2= new User(firstname = 'Test2', 
                         lastName = 'Tester', 
                         email = 'test2.tester' + '@somecompany' + orgId + '.org', 
                         Username = 'test2.tester' + '@somecompany' + orgId + '.org', 
                         isActive = true,
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        UserList.add(u2);
        
        insert UserList; 	
        System.assertEquals(2, userList.size());
	}
 
	static testMethod void  testPostRestService_ActiveUser(){       
        String orgId = UserInfo.getOrganizationId(); 
		Test.startTest(); 
            RestRequest request = new RestRequest();
            RestResponse res = new RestResponse();        
            request.httpMethod = 'POST';
            request.addHeader('Content-Type', 'application/json');
            request.requestURI = 'https://test.salesforce.com/services/apexrest/SM_PAservice';
            
        	//Build the JSON data format using the test record built above and also a record that does not exist in the database.
/*
            String ReqTestData = '[{"UsernameAdjusted":"test1.tester@somecompany' + orgId + '.org' + '", "userName":"test1.tester@somecompany' + orgId + '.org", "isActive":true}, ';
                   ReqTestData += '{"UsernameAdjusted":"test2.tester@somecompany' + orgId + '.org' + '", "userName":"test2.tester@somecompany' + orgId + '.org", "isActive":true}]';
*/
            //This line must be updated if you add additional records to the custom metadata type setting
            String ReqTestData = '{"UserWrapperMap":{"DummyRecord":{"SandboxName":"sm2","LogGrouping":"1545452762014","EmailGrouping":"1545452761808"}},"SettingWrapperMap":{"Email_Log_Delay":{"TextArea255Setting":"","QualifiedApiNameSetting":"Email_Log_Delay","NumberSetting":10,"CheckboxSetting":false},"Deprovision_Sandbox_Limit_List":{"TextArea255Setting":"","QualifiedApiNameSetting":"Deprovision_Sandbox_Limit_List","NumberSetting":0,"CheckboxSetting":false},"NC_Chunk_Setting":{"TextArea255Setting":"","QualifiedApiNameSetting":"NC_Chunk_Setting","NumberSetting":3,"CheckboxSetting":false},"Sandbox_Manager":{"TextArea255Setting":"","QualifiedApiNameSetting":"Sandbox_Manager","NumberSetting":0,"CheckboxSetting":true},"Profile_Audit":{"TextArea255Setting":"","QualifiedApiNameSetting":"Profile_Audit","NumberSetting":0,"CheckboxSetting":true},"Email_That_SM_Module_Executed":{"TextArea255Setting":"thomas.barrett@carefirst.com","QualifiedApiNameSetting":"Email_That_SM_Module_Executed","NumberSetting":0,"CheckboxSetting":false},"Profile_Audit_Profile_List":{"TextArea255Setting":"system administrator, system administrator - read only, off shore testing - custom","QualifiedApiNameSetting":"Profile_Audit_Profile_List","NumberSetting":0,"CheckboxSetting":false},"Profile_Audit_Sandbox_Limit_List":{"TextArea255Setting":"","QualifiedApiNameSetting":"Profile_Audit_Sandbox_Limit_List","NumberSetting":0,"CheckboxSetting":false},"Timeout":{"TextArea255Setting":"","QualifiedApiNameSetting":"Timeout","NumberSetting":20000,"CheckboxSetting":false},"Log_Deletion":{"TextArea255Setting":"","QualifiedApiNameSetting":"Log_Deletion","NumberSetting":90,"CheckboxSetting":false},"Deactivate_Users":{"TextArea255Setting":"","QualifiedApiNameSetting":"Deactivate_Users","NumberSetting":0,"CheckboxSetting":true},"Provision_Sandbox_Limit_List":{"TextArea255Setting":"","QualifiedApiNameSetting":"Provision_Sandbox_Limit_List","NumberSetting":0,"CheckboxSetting":false},"Provision_Users":{"TextArea255Setting":"","QualifiedApiNameSetting":"Provision_Users","NumberSetting":0,"CheckboxSetting":true}, "Profile_Audit_Exclude_Frozen_Users":{"TextArea255Setting":"","QualifiedApiNameSetting":"Profile_Audit_Exclude_Frozen_Users","NumberSetting":0,"CheckboxSetting":false}}}';
                
            System.debug('ReqTestData: ' + ReqTestData);    
            
        	request.requestBody = Blob.valueOf(ReqTestData);
            RestContext.request = request;
            RestContext.response = res;         
            SM_PAservice.doProfileAudit();
        Test.stopTest(); 
	}     
}