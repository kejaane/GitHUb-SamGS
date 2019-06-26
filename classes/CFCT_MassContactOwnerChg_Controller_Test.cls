@isTest
// This test is for the CFCT_MassContactOwnerChange_Controller class
// 6/27/2014 : Changed profile name to Profile Record id
private class CFCT_MassContactOwnerChg_Controller_Test {
    static testMethod void CFCT_MassContactOwnerChg_Controller_Test1() {      
        String CurrentOwnerId;
        String NewOwnerId;
        
        // Creat a new user and log in as them to create the records necessary
        // for the Current Owner portion of the page test below
        // 50 contact records will be created and owned by this user
        // 6/27/2014 : Changed profile name to Profile Record id
        Profile p = [select id from profile where Id = '00e60000000oSNM'];
        User u = new User(alias = 'admuser', email='userTest1@userTestbobby.com',
        emailencodingkey='UTF-8', firstname='firstname', lastname='UserTest1', 
        languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,    
        timezonesidkey='America/Los_Angeles', username='userTest1@userTest1qxi.com');
        System.runAs(u) {  
            /* create account */           
            Account testAcc1 = new Account();
            testAcc1.Name = 'Test Account1';
            insert testAcc1;    
            List<Contact> Contacts = new List<Contact>();
            for (Integer i=0;i<50;i++) {     
                Contact c = new Contact(FirstName = 'TestFirstName1' + i,
                                        LastName = 'TestLastName1' + i,
                                        Phone = '555-555-554' + i,
                                        Email = 'TestFirstName1' + i + '@test.com',
                                        AccountID = testAcc1.id);
                Contacts.add(c);             
            }             
            insert Contacts;
            
            /* get info from record that is needed for the page test */
            CurrentOwnerId = u.id; //testContact.id;
        }  
        
        // Creat a new user for the New Owner portion of the page test below
        // 50 contact records will be created and owned by this user
        Profile p2 = [select id from profile where Id = '00e60000000oSNM'];
        User u2 = new User(alias = 'admuser', email='userTest2@userTest2.com',
        emailencodingkey='UTF-8', firstname='firstname', lastname='UserTest2', 
        languagelocalekey='en_US', localesidkey='en_US', profileid = p2.Id,    
        timezonesidkey='America/Los_Angeles', username='userTest2@userTest2golf.com');
        
        System.runAs(u2) {        
            /* create account */           
            Account testAcc2 = new Account();
            testAcc2.Name = 'Test Account2';
            insert testAcc2;    
            List<Contact> Contacts2 = new List<Contact>();    
            for (Integer i=0;i<50;i++) {     
                    Contact c = new Contact(FirstName = 'TestFirstName2' + i,
                                            LastName = 'TestLastName2' + i,
                                            Phone = '555-555-555' + i,
                                            Email = 'TestFirstName2' + i + '@test.com',
                                            AccountID = testAcc2.id,
                                            ownerid = u2.id);
                Contacts2.add(c);             
            }
            insert Contacts2;
            
            NewOwnerId = u2.id;
        }
                    
        Test.StartTest();
        //ApexPages.StandardController sc = new ApexPages.StandardController(testContacts);            
        CFCT_MassContactOwnerChange_Controller  pageCon = new CFCT_MassContactOwnerChange_Controller();            
        Pagereference pageRef1 = Page.CFCT_OwnerLeadRepNoMatch;  
        pageCon.getNewContactOwners();  
        pageCon.setNewContactOwner(NewOwnerId); 
        pageCon.getNewContactOwner();   
        pageCon.getCurrentContactOwners();     
        pageCon.setCurrentContactOwner(CurrentOwnerId);
        pageCon.getCurrentContactOwner();        
        PageReference changeOwner = pageCon.changeOwner(); 
        PageReference myResults = pageCon.myResults();        
        String pageResults = pageCon.getSummaryResults();        
        Test.StopTest();        
    } 
    
    //************
    // Second Test
    //************
    static testMethod void CFCT_MassChgOwnerChange_Controller_Test2() {
        Contact testContact = new Contact();
        String CurrentOwnerId;
        String NewOwnerId;
        
        // Creat a new user and log in as them to create the records necessary
        // to for the Current Owner portion of the page test below
        Profile p = [select id from profile where Id = '00e60000000oSNM'];
        User u = new User(alias = 'admuser', email='userTest1@userTest1.com',
        emailencodingkey='UTF-8', firstname='firstname', lastname='UserTest1', 
        languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id,    
        timezonesidkey='America/Los_Angeles', username='userTest1@userTest1xzeye.com');
        System.runAs(u) {  
            /* create account */           
            Account testAcc1 = new Account();
            testAcc1.Name = 'Test Account1';
            insert testAcc1 ;
            testContact.AccountID = testAcc1.id;      
            testContact.FirstName = 'Test1FirstName';
            testContact.LastName = 'Test1LastName'; 
            testContact.Phone = '555-555-5555';
            testContact.Email = 'Test1FirstName@Test1.com';    
            insert testContact;
            

            /* get info from record that is needed for the page test */
            CurrentOwnerId = testContact.id;
        }  
        
        // Creat a new user for the New Owner portion of the page test below
        Profile p2 = [select id from profile where Id = '00e60000000oSNM'];
        User u2 = new User(alias = 'admuser', email='userTest2@userTest2.com',
        emailencodingkey='UTF-8', firstname='firstname', lastname='UserTest2', 
        languagelocalekey='en_US', localesidkey='en_US', profileid = p2.Id,    
        timezonesidkey='America/Los_Angeles', username='userTest2@userTest2parisbn.com');
        
        NewOwnerId = u2.id;
                    
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);            
        CFCT_MassContactOwnerChange_Controller  pageCon = new CFCT_MassContactOwnerChange_Controller();            
        
        // Test validation for no values in the 
        // Current and New owner fields
        PageReference changeOwner = pageCon.changeOwner();        
        changeOwner = pageCon.changeOwner();
        
        // Test validation Where both Current and New
        // owner fields have the same value
        pageCon.setCurrentContactOwner(CurrentOwnerId);
        pageCon.setNewContactOwner(CurrentOwnerId);
        changeOwner = pageCon.changeOwner();
		pageCon.getIsClassic();        
              
        Test.StopTest();        
    }   
  
}