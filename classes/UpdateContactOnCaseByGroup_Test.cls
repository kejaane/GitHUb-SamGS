/*=========================================================================================
 * Date         : 08/20/2016
 * Developer    : Rajesh Pennam
 * Purpose      : This class contains the test class logic for the UpdateContactOnCaseByGroup
 *                
 *               
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 07/31/16  |  Rajesh Pennam    | Initial Version                                         
 *           |        | 
 *===========+============================================================================
 */
@istest(seeAllData=false)
 Public class UpdateContactOnCaseByGroup_Test{
     public static testmethod void test1(){
         // Commented out by SD - 12/21/2016
         //Test.startTest();
             //get Profile
             User u = [select Id,Name from User where Id = '00560000001gp81'];
             
             Profile p1 = [SELECT Id FROM Profile WHERE Name='Customer Community Plus Login User'];
             
             //Get Required Recdtypes
             Id rt_con_Comm = QueryBase.getRecordtypeId('Contact', 'Community_User_Contact');
             Id rt_con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
             Id rt_con_51 = QueryBase.getRecordtypeId('Contact', 'X51');
             Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
             Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
             
             Group__c g1 = new Group__c();
             Group__c g2 = new Group__c();
             Group__c g3 = new Group__c();
             Group__c g4 = new Group__c();
             
             System.runAs(u){
             
               List <Account> AccLst = new List <Account>();
                 //create Commuunity user Records
                 Account a = new Account();
                 a.Name = 'Community Account 2-50';
                 a.Type = 'Partner';
                 a.RecordTypeId = rt_Acc_2_50;
                 a.Entity_ID__c = '1111';
                 //a.RecType_Entity_ID__c = '2-50_1111';
                 //insert a;
                 AccLst.add(a);
                 
                 Account a1 = new Account();
                 a1.Name = 'Community Account 51';
                 a1.Type = 'Partner';
                 a1.RecordTypeId = rt_acc_51;
                 a1.Entity_ID__c = '2222';
                 //a1.RecType_Entity_ID__c = '51+_2222';
                 //insert a1;
                 AccLst.add(a1);
                 Insert AccLst;
                 
                 List<Contact>ConLst = new List <Contact>();
                  
                 Contact c = new Contact();
                 c.FirstName = 'Community Contact';
                 c.LastName = '2-50';
                 c.RecordTypeId = rt_con_2_50;
                 c.AccountId = a.Id;
                  c.Phone = '111111111';
                 c.Email = 'Test@gmail.com';
                 //insert c;
                 ConLst.add(c);
                 
                 Contact c1 = new Contact();
                 c1.FirstName = 'Community Contact';
                 c1.LastName = '51';
                 c1.RecordTypeId = rt_con_51;
                 c1.AccountId = a1.Id;
                 c.AccountId = a1.Id;
                 c1.Phone = '1234567890';
                 c1.Email = 'Test@gmail.com';
                 //insert c1;
                 ConLst.add(c1);
                 Insert ConLst;
                 
                
                 Contact c2 = new Contact();
                 c2.FirstName = 'Community User';
                 c2.LastName = 'Contactx';
                 c2.RecordTypeId = rt_con_Comm;
                 c2.X2_50_Account__c = a.Id;
                 c2.X2_50_Contact__c = c.Id;
                 c2.X51_Account__c = a1.Id;
                 c2.X51_Contact__c = c1.Id;
                 c2.Agency_Agent_Id__c = '7_7';
                 c2.AccountId = a.Id;
                 c2.Phone = '1234567890';
                 c2.Email = 'Test@gmail.com';
                 c2.X2_50_Contact__c = c.id;
                 c2.X51_Contact__c  = c1.id;
                 //insert c2;
                 insert c2;
                 
                 List <Group__c> GrpLst = New List <Group__c> ();
                
                 //create Group Records
                 g1 = new Group__c();
                 g1.Name = 'Groyp Test1 All';
                 g1.Group_ID__c = '1111';
                 //g1.Agency_Agent_Id__c = '77';
                 g1.Agency_ID__c = '7';
                 g1.Agent_ID__c = '7';
                 //insert g1;
                 GrpLst.add(g1);
                 
                 g2 = new Group__c();
                 g2.Name = 'Groyp Test2 ';
                 g2.Group_ID__c = '2222';
               //  g2.Agency_Agent_Id__c = '33';
                 g2.Agency_ID__c = '3';   
                 g2.Agent_ID__c = '3';
                 g2.FSP_GP_ID__c = '3333';
                 g2.Market_Segment__c = '2-50';
                 //insert g2; 
                 GrpLst.add(g2);  
                 
                 g3 = new Group__c();
                 g3.Name = 'Groyp Test3';
                 g3.Group_ID__c = '4444';
               //  g3.Agency_Agent_Id__c = '55';
                 g3.Agency_ID__c = '5';   
                 g3.Agent_ID__c = '5';
                 g3.FSP_GP_ID__c = '5555';
                 g3.Market_Segment__c = '51+';
                // insert g3;
                GrpLst.add(g3);
                 
                 g4 = new Group__c();
                 g4.Name = 'Groyp Test4';
                 g4.Group_ID__c = '0000';
                 //insert g4; 
                 GrpLst.add(g4);
                 insert GrpLst;
                    
                 //create Partner Accounts of 2-50 Record Type
                 List <Account>AccLst1 = new List <Account> ();
                 Account a2 = new Account();
                 a2.Name = 'TestAccount1';
                 a2.Type = 'Partner';
                 a2.RecordTypeId = rt_Acc_2_50;
                 a2.Entity_ID__c = '3333';
                 //a2.RecType_Entity_ID__c = '2-50_3333';
                 //insert a2;
                 AccLst1.add(a2);
                 
                 //create Partner Accounts of 51+ Record Type
                 Account a3 = new Account();
                 a3.Name = 'TestAccount2';
                 a3.Type = 'Partner';
                 a3.RecordTypeId = rt_acc_51;
                 a3.Entity_ID__c = '5555';
                 //a3.RecType_Entity_ID__c = '51+_5555';
                 //insert a3;
                 AccLst1.add(a3);
                 
                 //create Customer Accounts of 2-50 Record Type
                 Account a4 = new Account();
                 a4.Name = 'TestAccount3';
                 a4.Type = 'Customer';
                 a4.RecordTypeId = rt_Acc_2_50;
                 a4.Facets_Account_Number__c = '2222';
               //  a4.RecType_Facets_Account_Number__c = '2-50_2222';
                // insert a4;
                AccLst1.add(a4);
                 
                 //create Partner Accounts of 51+ Record Type
                 Account a5 = new Account();
                 a5.Name = 'TestAccount4';
                 a5.Type = 'Customer';
                 a5.RecordTypeId = rt_acc_51;
                 a5.Facets_Account_Number__c = '4444';
               //  a5.RecType_Facets_Account_Number__c = '51+_4444';
                 //insert a5;
                 AccLst1.add(a5);
                 Insert AccLst1;
                 
                 List <Contact>ConLst1 = New List <Contact>();
                 //create Contacts
                 Contact c3 = new Contact();
                 c3.FirstName = 'Test';
                 c3.LastName = 'Name1';
                 c3.RecordTypeId = rt_con_2_50;
                 c3.AccountId = a.Id;
                 c3.Phone = '1234567890';
                 c3.Email = 'Test@gmail.com';
                // insert c3;
                ConLst1.add(c3);
                 
                 Contact c4 = new Contact();
                 c4.FirstName = 'Test';
                 c4.LastName = 'Name2';
                 c4.RecordTypeId = rt_con_51;
                 c4.AccountId = a1.Id;
                 c4.Phone = '1234567890';
                 c4.Email = 'Test@gmail.com';
                 //insert c4;
                 ConLst1.add(c4);
                 
                 Contact c5 = new Contact();
                 c5.FirstName = 'First';
                 c5.LastName = 'LAst';
                 c5.RecordTypeId = rt_con_Comm;
                 c5.X2_50_Account__c = a2.Id;
                 c5.X2_50_Contact__c = c4.Id;
                 c5.X51_Account__c = a3.Id;
                 c5.X51_Contact__c = c5.Id;
                 c5.Agency_Agent_Id__c = '3_3';
                 c5.AccountId = a.Id;
                 c5.Phone = '1234567890';
                 c5.Email = 'Test@gmail.com';
                 //insert c5;
                 ConLst1.add(c5);
                 
                 Contact c6 = new Contact();
                 c6.FirstName = 'First';
                 c6.LastName = 'LAst';
                 c6.RecordTypeId = rt_con_Comm;
                 c6.X2_50_Account__c = a2.Id;
                 c6.X2_50_Contact__c = c4.Id;
                 c6.X51_Account__c = a3.Id;
                 c6.X51_Contact__c = c5.Id;
                 c6.Agency_Agent_Id__c = '5_5';
                 c6.AccountId = a.Id;
                 c6.Phone = '1234567890';
                 c6.Email = 'Test@gmail.com';
                 //insert c6;
                 ConLst1.add(c6);
                 Insert ConLst1;
                 
             }
          //   Test.startTest();
             Contact Cont = [select Id,Name from Contact where FirstName = 'Community User' Limit 1];
             //create User for Community 
             User u1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p1.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com',ContactId=Cont.Id);
             System.runAs(u1){
             
               List <Case> CsLst = New List <Case>();
                 Case ca = new Case();
                 ca.Subject = 'Hi';
                 ca.Description = 'Desc';
                 //insert ca;
                 CsLst.add(ca);
     
                 Case ca3 = new Case();
                 ca3.Group__c = g3.Id;
                 ca3.Subject = 'Hi';
                 ca3.Description = 'Desc';
                 //insert ca3; 
                 CsLst.add(ca3);
                 
                 Case ca2 = new Case();
                 ca2.Group__c = g2.Id;
                 ca2.Subject = 'Hi';
                 ca2.Description = 'Desc';
                 //insert ca2;
                 CsLst.add(ca2);
                 
                 Case ca1 = new Case();
                 ca1.Group__c = g1.Id;
                 ca1.Subject = 'Hi';
                 ca1.Description = 'Desc';
                 //insert ca1;
                 CsLst.add(ca1);
                 insert CsLst;
                 
                 // Added by SD - 12/21/2016
                 Test.StartTest();
              
                 Communities_NewCasePage obj = new Communities_NewCasePage();
                                 
                 Communities_NewCasePage.BrokerPhone = '121314';
                 Communities_NewCasePage.createNewCase();
                 
                 Communities_NewCasePage.BrokerPhone = '1213148909';
                 Communities_NewCasePage.SubId = '123';
                 Communities_NewCasePage.createNewCase();
                 
                 Communities_NewCasePage.BrokerPhone = '1213148909';
                 Communities_NewCasePage.SubId = '1235';
                 Communities_NewCasePage.MemType = Null;
                 Communities_NewCasePage.createNewCase();
                 
                 Communities_NewCasePage.BrokerPhone = '1213148909';
                 Communities_NewCasePage.GroupId = '33';
                 Communities_NewCasePage.FileSize = 123;
                 Communities_NewCasePage.createNewCase();
                 
                 Communities_NewCasePage.GroupId = '1111';
                 Communities_NewCasePage.createNewCase();
                 
                 Communities_NewCasePage.GroupId = '3333';
                 Communities_NewCasePage.SubId = '123456789';
                 Communities_NewCasePage.FileSize = 10000022;
                 Communities_NewCasePage.createNewCase();
         
                 
                 Communities_NewCasePage.BrokerPhone = '1213141516';
                 Communities_NewCasePage.GroupId = '3333';
                 Communities_NewCasePage.SubId = '123456789';
                 Communities_NewCasePage.MemType = 'Spouse';
                 Communities_NewCasePage.FileSize = 123;
                 Communities_NewCasePage.createNewCase();
                 
               //  Test.startTest();
                 Communities_NewCasePage.BrokerPhone = '1213141516';
                 Communities_NewCasePage.GroupId = '3333';
                 Communities_NewCasePage.SubId = '123456789';
                 Communities_NewCasePage.MemType = 'Spouse';
                 Communities_NewCasePage.FileSize = 10000022;
                 Communities_NewCasePage.createNewCase();
                 
                 // Added by SD - 12/21/2016
                 Test.stopTest();
           
            }
            
         // Commented out by SD = 12/21/2016   
         //Test.stopTest();
     }
     
     @isTest
     public static void testUpdateContactOnCaseByGroup(){
         
         Test.startTest();  
         
         //Get Required Recdtypes
         Id rt_con_Comm = QueryBase.getRecordtypeId('Contact', 'Community_User_Contact');
         Id rt_con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
         Id rt_con_51 = QueryBase.getRecordtypeId('Contact', 'X51');
         Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
         Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
         
         
         List <Account> AccLst = new List <Account>();
         //create Commuunity user Records
         Account a = new Account();
         a.Name = 'Community Account 2-50';
         a.Type = 'Partner';
         a.RecordTypeId = rt_Acc_2_50;
         a.Entity_ID__c = '3333';
         a.Facets_Account_Number__c = '2222';
         insert a;
         
         List<Contact>ConLst = new List <Contact>();
         
         Contact c = new Contact();
         c.FirstName = 'Community Contact';
         c.LastName = '2-50';
         c.RecordTypeId = rt_con_2_50;
         c.AccountId = a.Id;
         c.Phone = '111111111';
         c.Email = 'Test@gmail.com';
         ConLst.add(c);
         
         Contact c1 = new Contact();
         c1.FirstName = 'Community Contact';
         c1.LastName = '51';
         c1.RecordTypeId = rt_con_51;
         c1.AccountId = a.Id;
         c1.Phone = '1234567890';
         c1.Email = 'Test@gmail.com';
         ConLst.add(c1);
         Insert ConLst;
         
         Contact c2 = new Contact();
         c2.FirstName = 'Community User';
         c2.LastName = 'Contact';
         c2.RecordTypeId = rt_con_Comm;
         c2.X2_50_Account__c = a.Id;
         c2.X2_50_Contact__c = c.Id;
         c2.X51_Account__c = a.Id;
         c2.X51_Contact__c = c1.Id;
         c2.Agency_Agent_Id__c = '3_3';
         c2.AccountId = a.Id;
         c2.Phone = '1234567890';
         c2.Email = 'Test@gmail.com';
         insert c2;
         
         Group__c g2 = new Group__c();
         g2.Name = 'Groyp Test2 ';
         g2.Group_ID__c = '2222';
         g2.Agency_ID__c = '3';
         g2.Agency_Agent_Id__c = '3';
         g2.Agent_ID__c = '3';
         g2.FSP_GP_ID__c = '3333';
         g2.Market_Segment__c = '2-50';
         insert g2;  
         
         Case ca = new Case();
         ca.Subject = 'Hi';
         ca.Description = 'Desc';
         ca.Group__c = g2.id;
         insert ca;
         
         UpdateContactOnCaseByGroup.updateContactByGrp(ca);
         
         Test.stopTest();
     }
     
     @isTest
     public static void testUpdateContactOnCaseByGroup2(){
         
         Test.startTest();  
         
         //Get Required Recdtypes
         Id rt_con_Comm = QueryBase.getRecordtypeId('Contact', 'Community_User_Contact');
         Id rt_con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
         Id rt_con_51 = QueryBase.getRecordtypeId('Contact', 'X51');
         Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
         Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
         
         
         List <Account> AccLst = new List <Account>();
         //create Commuunity user Records
         Account a = new Account();
         a.Name = 'Community Account 2-50';
         a.Type = 'Partner';
         a.RecordTypeId = rt_Acc_2_50;
         a.Entity_ID__c = '3333';
         a.Facets_Account_Number__c = '2222';
         insert a;
         
         List<Contact>ConLst = new List <Contact>();
         
         Contact c = new Contact();
         c.FirstName = 'Community Contact';
         c.LastName = '2-50';
         c.RecordTypeId = rt_con_2_50;
         c.AccountId = a.Id;
         c.Phone = '111111111';
         c.Email = 'Test@gmail.com';
         insert c;
         
         Group__c g2 = new Group__c();
         g2.Name = 'Groyp Test2 ';
         g2.Group_ID__c = '2222';
         g2.Agency_ID__c = '3';
         g2.Agency_Agent_Id__c = '3';
         g2.Agent_ID__c = '3';
         g2.FSP_GP_ID__c = '3333';
         g2.Market_Segment__c = '2-50';
         insert g2;  
         
         Case ca = new Case();
         ca.Subject = 'Hi';
         ca.Description = 'Desc';
         ca.Group__c = g2.id;
         insert ca;
         
         UpdateContactOnCaseByGroup.updateContactByGrp(ca);
         
         Test.stopTest();
     } 
     
     @isTest
     public static void testUpdateContactOnCaseByGroup3(){
         
         Test.startTest();  
         
         //Get Required Recdtypes
         Id rt_con_Comm = QueryBase.getRecordtypeId('Contact', 'Community_User_Contact');
         Id rt_con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
         Id rt_con_51 = QueryBase.getRecordtypeId('Contact', 'X51');
         Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
         Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
         
         
         List <Account> AccLst = new List <Account>();
         //create Commuunity user Records
         Account a = new Account();
         a.Name = 'Community Account 2-50';
         a.Type = 'Partner';
         a.RecordTypeId = rt_Acc_2_50;
         a.Entity_ID__c = '3333';
         a.Facets_Account_Number__c = '2222';
         insert a;
         
         List<Contact>ConLst = new List <Contact>();
         
         Contact c2 = new Contact();
         c2.FirstName = 'Community User';
         c2.LastName = 'Contact';
         c2.RecordTypeId = rt_con_Comm;
         c2.X2_50_Account__c = a.Id;
         c2.X51_Account__c = a.Id;
         c2.Agency_Agent_Id__c = '3_3';
         c2.AccountId = a.Id;
         c2.Phone = '1234567890';
         c2.Email = 'Test@gmail.com';
         insert c2;
         
         Case ca2 = new Case();
         ca2.Subject = 'Hi';
         ca2.Description = 'Desc';
         ca2.ContactId = c2.id;
         insert ca2;

         UpdateContactOnCaseByGroup.updateContactByGrp(ca2);
         
         Test.stopTest();
     }
     
      @isTest
     public static void testUpdateContactOnCaseByGroup4(){
         
         Test.startTest();  
         
         //Get Required Recdtypes
         Id rt_con_Comm = QueryBase.getRecordtypeId('Contact', 'Community_User_Contact');
         Id rt_con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
         Id rt_con_51 = QueryBase.getRecordtypeId('Contact', 'X51');
         Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
         Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
         
         
         List <Account> AccLst = new List <Account>();
         //create Commuunity user Records
         Account a = new Account();
         a.Name = 'Community Account 2-50';
         a.Type = 'Partner';
         a.RecordTypeId = rt_Acc_2_50;
         a.Entity_ID__c = '3333';
         a.Facets_Account_Number__c = '2222';
         insert a;
         
         List<Contact>ConLst = new List <Contact>();
         
         Contact c1 = new Contact();
         c1.FirstName = 'Community Contact';
         c1.LastName = '51';
         c1.RecordTypeId = rt_con_51;
         c1.AccountId = a.Id;
         c1.Phone = '1234567890';
         c1.Email = 'Test@gmail.com';
         insert c1;
         
         Contact c2 = new Contact();
         c2.FirstName = 'Community User';
         c2.LastName = 'Contact';
         c2.RecordTypeId = rt_con_Comm;
         c2.X2_50_Account__c = a.Id;
         c2.X51_Account__c = a.Id;
         c2.X51_Contact__c = c1.Id;
         c2.Agency_Agent_Id__c = '3_3';
         c2.AccountId = a.Id;
         c2.Phone = '1234567890';
         c2.Email = 'Test@gmail.com';
         insert c2;
         
         Case ca2 = new Case();
         ca2.Subject = 'Hi';
         ca2.Description = 'Desc';
         ca2.ContactId = c2.id;
         insert ca2;

         UpdateContactOnCaseByGroup.updateContactByGrp(ca2);
         
         Test.stopTest();
     }
 }