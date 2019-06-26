//=========================================================================================
//      Date: 04/10/2018
// Developer: Tom Barrett (TPB)
//   Purpose: This class is a test class to get code coverage for the SM_DUcallout class
//            
//=========================================================================================
//                                 Update History
// Date       Developer     Tag     Description
//=========================================================================================
// 
//=========================================================================================
@isTest //(SeeAllData=true)
global class SM_DUcallout_Test { 

    @testSetup static void createUsers() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];         
        List<User> UserList = new List<User>();
        while (UserList.size() < 3) {
            Blob b = Crypto.GenerateAESKey(128);
            String h = EncodingUtil.ConvertTohex(b);
            String uid = h.SubString(0,8);
            User u = new User(Alias = uid, Email= uid + '@myorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,                               
                              TimeZoneSidKey='America/New_York', UserName= uid + '@myorg.com',
                              isActive = true,
                              SM_Bypass_SM_Deprovision__c = true);                
            UserList.add(u);
            UserList[0].SM_Bypass_SM_Deprovision__c = false;
        } 
        insert UserList;
    }
    
    static testMethod void testDeprovisionWithBypassTrue() {        
        List<User> user =  [SELECT id FROM User WHERE isActive = True and SM_Bypass_SM_Deprovision__c = true LIMIT 1];
        Set<Id> UserId = new Set<Id>();
        for (User u : user) {
            UserId.add(u.id);
            u.IsActive = false;
        } 
        test.startTest();
            try {
                Database.update(user,false);
            } catch (Exception e) {
                System.debug('Error: ' + e.getMessage() + ' - occurred at line number: ' + e.getLineNumber());
            }
        test.stopTest();
    } 

    
    
    static testMethod void testDeprovisionWithBypassFalse() {
        List<User> user =  [SELECT id FROM User WHERE isActive = True and SM_Bypass_SM_Deprovision__c = FALSE LIMIT 1];
        Set<Id> UserId = new Set<Id>();
        for (User u : user) {
            UserId.add(u.id);
            u.IsActive = false;
        }
        test.startTest();
            try {
                Database.update(user,false);
            } catch (Exception e) {
                System.debug('Error: ' + e.getMessage() + ' - occurred at line number: ' + e.getLineNumber());
            }
        test.stopTest();
    }     
   
    static testMethod void testCase1_200() {
        User user =  [SELECT id FROM User WHERE isActive = True and SM_Bypass_SM_Deprovision__c = FALSE LIMIT 1];
        Set<Id> UserId = new Set<Id>{user.id};

        SM_RequestMock fakeResponse = new  
                SM_RequestMock(200,'Complete', 
                               '[{"UsernameAdjusted":"test1.tester@somecompany.org.devx", "UserName":"test1.tester@somecompany.org","isActive":false}]', null, false);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
       
        Test.startTest();
            SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Deprovision_User, UserId);
        Test.stopTest();

    }  
    
    static testMethod void testCase2_401() {
        User user =  [SELECT id FROM User WHERE isActive = True and SM_Bypass_SM_Deprovision__c = FALSE LIMIT 1];
        Set<Id> UserId = new Set<Id>{user.id};
        SM_RequestMock fakeResponse = new  
                SM_RequestMock(401,'Complete', 
                               '[{"UsernameAdjusted":"test1.tester@somecompany.org.devx", "UserName":"test1.tester@somecompany.org","isActive":false}]', null, false);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
            SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Deprovision_User, UserId);
        Test.stopTest();
    }   
    
    static testMethod void testCase2_404() {
        User user =  [SELECT id FROM User WHERE isActive = True and SM_Bypass_SM_Deprovision__c = FALSE LIMIT 1];
        Set<Id> UserId = new Set<Id>{user.id};
        SM_RequestMock fakeResponse = new  
                SM_RequestMock(404,'Complete', 
                               '[{"UsernameAdjusted":"test1.tester@somecompany.org.devx", "UserName":"test1.tester@somecompany.org","isActive":false}]', null, false);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
            SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Deprovision_User, UserId);
        Test.stopTest();
    }     
    
    static testMethod void testCase3_500() {
        User user =  [SELECT id FROM User WHERE isActive = True and SM_Bypass_SM_Deprovision__c = FALSE LIMIT 1];
        Set<Id> UserId = new Set<Id>{user.id};
        SM_RequestMock fakeResponse = new  
                SM_RequestMock(500,'Complete', 
                               '[{"UsernameAdjusted":"test1.tester@somecompany.org.devx", "UserName":"test1.tester@somecompany.org","isActive":false}]', null, false);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
            SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Deprovision_User, UserId);
        Test.stopTest();
    }      

    //Used to assist with test code coverage
    static testMethod void testExceptionTrap() {        
        User user =  [SELECT id FROM User WHERE isActive = True and SM_Bypass_SM_Deprovision__c = FALSE LIMIT 1];
        Set<Id> UserId = new Set<Id>{user.id};
        SM_RequestMock fakeResponse = new  
                SM_RequestMock(200,'Complete', 
                               '[{"UsernameAdjusted":"test1.tester@somecompany.org.devx", "UserName":"test1.tester@somecompany.org","isActive":false}]', null, true);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        
        Test.startTest();
            SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Deprovision_User, UserId);
        Test.stopTest();
    }

}