//=========================================================================================
//      Date: 04/15/2018
// Developer: Tom Barrett (TPB)
//   Purpose: This class is a test class to get code coverage for the SM_User_Trigger Trigger
//      Note: Technically we don't need this test class as the code gets covered from the
//            SM_DUservice_Test class but built in any way in case it is needed for some
//            future functionality.
//            
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
@isTest (SeeAllData=false)
public class SM_User_Trigger_Test {
    @testSetup static void createUsers() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];         
        List<User> UserList = new List<User>();
        Blob b;
        String h;
        String uid;
        
        //User 1
        b = Crypto.GenerateAESKey(128);
        h = EncodingUtil.ConvertTohex(b);
        uid = h.SubString(0,8);
        User u1 = new User(Alias = uid, Email= uid + '@somecompany.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id,                               
                           TimeZoneSidKey='America/New_York', UserName= uid + '@somecompany.com',
                           IsActive = true,
                           SM_Bypass_SM_Deprovision__c = true);                
        UserList.add(u1);   
            
        b = Crypto.GenerateAESKey(128);
        h = EncodingUtil.ConvertTohex(b);
        uid = h.SubString(0,8); 
        
        //User 2
        User u2 = new User(Alias = uid, Email= uid + '@somecompany.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id,                               
                           TimeZoneSidKey='America/New_York', UserName= uid + '@somecompany.com',
                           IsActive = false,
                           SM_Bypass_SM_Deprovision__c = true);                
        UserList.add(u2);  
        
        //User 3
        b = Crypto.GenerateAESKey(128);
        h = EncodingUtil.ConvertTohex(b);
        uid = h.SubString(0,8);            
        User u3 = new User(Alias = uid, Email= uid + '@somecompany.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id,                               
                           TimeZoneSidKey='America/New_York', UserName= uid + '@somecompany.com',
                           IsActive = true,
                           SM_Bypass_SM_Deprovision__c = false);                
        UserList.add(u3);               

        insert(UserList);
    } 
    
    static testmethod void testCaseUser1() {
        String Username;        
        User user =  [SELECT id, Username, IsActive, SM_Bypass_SM_Deprovision__c
                      FROM User 
                      WHERE Username LIKE '%@somecompany%' AND IsActive = TRUE AND SM_Bypass_SM_Deprovision__c = TRUE LIMIT 1];
        user.IsActive = false;  
        Username = user.Username;
        
        test.startTest();       
            Update user;  
        
            User U =  [SELECT id, Username, IsActive, SM_Bypass_SM_Deprovision__c 
                       FROM User 
                       WHERE Username =: Username LIMIT 1]; 
            System.assertEquals(False, User.isActive, 'User should be inactive!');    
        test.stopTest();
    }
    
    //WHen the user is activated the trigger should change the SM_Bypass_SM_Deprovision__c to False
    static testmethod void testCaseUser2() {
        String Username;
        User user =  [SELECT id, Username, isActive, SM_Bypass_SM_Deprovision__c 
                      FROM User 
                      WHERE Username LIKE '%@somecompany%' AND IsActive = FALSE AND SM_Bypass_SM_Deprovision__c = TRUE LIMIT 1];
        user.IsActive = TRUE; 
        Username = user.Username;
        
        test.startTest();       
            Update user;
        
            User U =  [SELECT id, Username, IsActive, SM_Bypass_SM_Deprovision__c 
                          FROM User 
                          WHERE Username =: Username LIMIT 1];          
                System.assertEquals(True, U.IsActive, 'User should be active');
                System.assertEquals(false, U.SM_Bypass_SM_Deprovision__c, 'Bypass_SM_Deprovision should be false!'); 
        test.stopTest();         
    }  

    static testmethod void testCaseUser3() {
        String Username;
        User user =  [SELECT id, Username, IsActive, SM_Bypass_SM_Deprovision__c 
                      FROM User 
                      WHERE Username LIKE '%@somecompany%' AND IsActive = TRUE AND SM_Bypass_SM_Deprovision__c = FALSE LIMIT 1];
        user.IsActive = FALSE; 
        Username = user.Username;
        
        test.startTest();       
            Update user;
        
            User U =  [SELECT id, Username, IsActive, SM_Bypass_SM_Deprovision__c 
                       FROM User 
                       WHERE Username =: Username LIMIT 1];         
            System.assertEquals(False, User.IsActive, 'User should be inactive!');   
        test.stopTest();         
    }       
}