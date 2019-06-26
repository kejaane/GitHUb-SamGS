//=========================================================================================
//      Date: 12/27/2012
// Developer: Tom Barrett (TPB)
//   Purpose: This test class is used to test the CFCT_UsersNotInChatterGroups_Controller
//            class.
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
// 06/23/2016 TPB            Updated to handle so the test does not create a group that may
//                           already exist.  Salesforce Architect Sandip helped with this
//                           solution. 
//=========================================================================================
@isTest
private class CFCT_UsersNotInChatterGroups_Test {    

    //Positive test 
    static testMethod void Test1() {     
        //Add a administrator who will be used to create the Chatter Group        
        Id AdminPID = [select id from profile where Name = 'System Administrator'].Id;
        User admin = new User();
        admin.FirstName = 'MrX';
        admin.LastName = 'LastMrx';
        admin.email = 'mrxzz@mytest.com';
        admin.alias = 'zzts';
        admin.communityNickname = 'MrXLastMrx';
        admin.username = 'mrxzzt@mytest.com';
        admin.EmailEncodingKey = 'ISO-8859-1';
        admin.LanguageLocaleKey = 'en_US';
        admin.LocaleSidKey = 'en_US';
        admin.TimeZoneSidKey = 'America/New_York';
        admin.ProfileId = AdminPID;
        insert admin;
        
        //Create a standard user who will be used to validate they are not in the Chatter Group
        Id UserPID = [select id from profile where Name = 'Standard User'].Id;
        User u = new User();
        u.FirstName = 'CGT';
        u.LastName = 'ChatterGroupTest';
        u.email = 'ChatterGroupTest@mytest.com';
        u.alias = 'zzts';
        u.Exclude_From_Chatter_QA__c = FALSE;
        u.communityNickname = 'zzxxy';
        u.isActive = TRUE ;
        u.username = 'ChatterGroupTest@mytest.com';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'America/New_York';
        u.ProfileId = UserPID;
        insert u;
        
        String todaysDate = System.NoW().format(); //TPB 06/23/2016
        
        //Create two Chatter Group Names on the Custom Setting object 
        CFCT_UsersNotInChatterGroups__c[] UserNotInCG = new List<CFCT_UsersNotInChatterGroups__c>();
        //BEGIN CHANGE TPB 2016 by adding + todaysDate
        UserNotInCG.add( new CFCT_UsersNotInChatterGroups__c(
                         Name = 'CH010',
            ChatterGroup__c = 'Test Group'+todaysDate));
        UserNotInCG.add( new CFCT_UsersNotInChatterGroups__c(
                         Name = 'CH020',
                         ChatterGroup__c = 'Test2 Group'+todaysDate));
        //END CHANGE TPB 2016 by adding + todaysDate 
        insert UserNotInCG;   
        
        //Create two Chatter Groups 
        //The second Chatter Group makes sure to get code coverage on what builds the 
        //divider line (===) in the HTML table       
        CollaborationGroup[] cg = new List<CollaborationGroup>();   
        //BEGIN CHANGE TPB 2016 by adding + todaysDate     
        cg.add( new CollaborationGroup( 
                Name = 'Test Group' + todaysDate, 
                CollaborationType='Public'));
        cg.add( new CollaborationGroup( 
                Name = 'Test2 Group' + todaysDate, 
                CollaborationType='Public'));     
        //END CHANGE TPB 2016 by adding + todaysDate        
        insert cg;
        
        Test.StartTest();
            PageReference pageRef = Page.CFCT_UsersNotInChatterGroups;
            Test.setCurrentPage(pageRef);
            CFCT_UsersNotInChatterGroups_Controller con = new CFCT_UsersNotInChatterGroups_Controller();                     
            con.startProcess();
            
            con.emailList();
            
            con.UserChatterGroupList[1].recordSelect = TRUE;
  //          con.ExcludeUserFromProcess();
              try{
            con.AddUserToGroup();
            }catch(Exception Ex){
             System.debug('C:/log'+Ex);
            }
        Test.StopTest();
    }
    
    //Negative Test
    //Get code coverage for the code that builds the HTML message that a Chatter Group name in the 
    //Custom Setting object exists but no actual Chatter Group was found.
    static testMethod void Test2() {     
        //Add a administrator who will be used to create the Chatter Group        
        Id AdminPID = [select id from profile where Name = 'System Administrator'].Id;
        User admin = new User();
        admin.FirstName = 'MrX';
        admin.LastName = 'LastMrx';
        admin.email = 'mrxzz@mytest.com';
        admin.alias = 'zzts';
        admin.communityNickname = 'MrXLastMrx';
        admin.username = 'mrxzzt@mytest.com';
        admin.EmailEncodingKey = 'ISO-8859-1';
        admin.LanguageLocaleKey = 'en_US';
        admin.LocaleSidKey = 'en_US';
        admin.TimeZoneSidKey = 'America/New_York';
        admin.ProfileId = AdminPID;
        insert admin;
        
        //Create a standard user who will be used to validate they are not in the Chatter Group
        Id UserPID = [select id from profile where Name = 'Standard User'].Id;
        User u = new User();
        u.FirstName = 'CGT';
        u.LastName = 'ChatterGroupTest';
        u.email = 'ChatterGroupTest@mytest.com';
        u.alias = 'zzts';
        u.communityNickname = 'zzxxy';
        u.username = 'ChatterGroupTest@mytest.com';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'America/New_York';
        u.ProfileId = UserPID;
        insert u;
        
        String todaysDate = System.Now().format(); //TPB 06/23/2016
        
        //Create a Chatter Group Name on the Custom Setting object 
        CFCT_UsersNotInChatterGroups__c UserNotInCG = new CFCT_UsersNotInChatterGroups__c();
        UserNotInCG.Name = 'CH010';
        UserNotInCG.ChatterGroup__c = 'Test Group' + todaysDate; //BEGIN CHANGE TPB 06/23/2016 by adding + todaysDate
        insert UserNotInCG;                 
      
        Test.StartTest();
            CFCT_UsersNotInChatterGroups_Controller con = new CFCT_UsersNotInChatterGroups_Controller();           
            con.startProcess();
            con.emailList();           
            con.ExcludeUserFromProcess();
            con.AddUserToGroup();
        	con.getIsClassic();
        Test.StopTest();
    }
}