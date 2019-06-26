/*=========================================================================================
 * Date         : 09/08/2016
 * Developer    : Rajesh Pennam
 * Purpose      : This class is used to test the functionlaity of the UpdateContactOnCaseByGroup,Contact
 *                and Communities_NewCasePage
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 09/08/16  |  Rajesh Pennam   | Initial Version                                         
 *           |        | 
 *=========================================================================================
 */
 
 @istest
 
 Public class SBU_TestUtil{
     public static testmethod void test(){
     
         Test.startTest();
         //create Partner Accounts of 2-50 Record Type
         Id rt_acc_2_50 = QueryBase.getRecordtypeId('Account', 'X2_50');
         Account a = new Account();
         a.Name = 'TestAccount1';
         a.Type = 'Partner';
         a.RecordTypeId = rt_Acc_2_50;
         a.Entity_ID__c = '6666';
         a.RecType_Entity_ID__c = '2-50_6666';
         a.Entity_Type_FSP__c = true;
         a.Entity_Type_GP__c = true;
         
         //create Partner Accounts of 51+ Record Type
         Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
         Account a2 = new Account();
         a2.Name = 'TestAccount1';
         a2.Type = 'Partner';
         a2.RecordTypeId = rt_acc_51;
         a2.Entity_ID__c = '6666';
         a2.RecType_Entity_ID__c = '51+_6666';
         a.Entity_Type_FSP__c = true;
         a.Entity_Type_GP__c = true;
         
         //create Customer Accounts of 2-50 Record Type
         Account a3 = new Account();
         a3.Name = 'TestAccount1';
         a3.Type = 'Customer';
         a3.RecordTypeId = rt_Acc_2_50;
         a3.Facets_Account_Number__c = '9999';
         a3.RecType_Facets_Account_Number__c = '2-50_9999';
         
         //create Customer Accounts of 2-50 Record Type
         Account a4 = new Account();
         a4.Name = 'TestAccount1';
         a4.Type = 'Customer';
         a4.RecordTypeId = rt_Acc_2_50;
         a4.Facets_Account_Number__c = '9999';
         a4.RecType_Facets_Account_Number__c = '2-50_9999';
     
     }
     
     public static void createTestContacts() {
        // Create some test contacts
        // NOTE: Entity_Typed hard coded matches broker import record created in the
        //       CreateBrokerActivityData
        Id rt_Con_2_50 = QueryBase.getRecordtypeId('Contact', 'X2_50');
        Id rt_Con_51 = QueryBase.getRecordtypeId('Contact', 'X51');  
        Id rt_Con_comm = QueryBase.getRecordtypeId('Contact', 'Community_User_Contact');       
            
         Contact c = new Contact ();
         c.FirstName = 'Sample';
         c.LastName  = 'Contact';
            }   
            
    
     public static void CIAMProcessTestContact(){
         // Create some test merchandise items to be deleted
       //   by the batch job.
       CIAM_Import_Table__c[] ciamList = new List<CIAM_Import_Table__c>();
       for (Integer i=0;i<10;i++) {
           CIAM_Import_Table__c im = new CIAM_Import_Table__c(
               Name='Merchandise ' + i,
               Agency_Agent_ID__c='D0_2T'+i,
               Agency_ID__c='D0',
               Broker_Title__c='Assistant',
               Email_Address__c='test@test.com',
               Agent_Last_Name__c = 'testlast',
               Agent_ID__c='2T');
           ciamList.add(im);
       }
       insert ciamList;
       
       //Create Test Account for 51 recordtype

       Account acc = new Account();
       id rt = QueryBase.getRecordtypeId('Account', 'X51');
       acc.name='Community_User_Account';
       acc.type = 'partner';
       acc.Entity_ID__c='D0';
       acc.recordtypeid=rt;
       insert acc;
       // for 250 recordtype
       Account acc1 = new Account();
       id rt2 = QueryBase.getRecordtypeId('Account', 'X2_50');
       acc1.name='Test';
       acc.type = 'Partner';
       acc1.Entity_ID__c='D0';
       acc1.recordtypeid=rt2;
       insert acc1;
       
       //Create Test contact record for 51 record type
       id rtc = QueryBase.getRecordtypeId('Contact', 'X51');
       Contact con= new Contact();
       con.Lastname='test';
       con.Accountid=acc.id;
       con.Recordtypeid=rtc;
       con.email = 'test@testy.com';
       con.phone = '123456789';
       con.Entity_ID__c='2T';
       con.Agency_Agent_ID__c=ciamList[0].Agency_ID__c;
       insert con;
       
       //Create Test contact record for 250 record type
       id rt25 = QueryBase.getRecordtypeId('Contact', 'X2_50');
       Contact con1= new Contact();
       con1.Lastname='test';
       con1.email = 'test@testy.com';
       con1.phone = '123456789';
       con1.Accountid=acc1.id;
       con1.Recordtypeid=rt25;
      // con1.Entity_ID__c='2T';
       con1.Agency_Agent_ID__c=ciamList[1].Agency_Agent_ID__c;
       insert con1;       
    }
    
    public static void CIAMProcessTestContact1(){

   
       // Create some test merchandise items to be deleted
       //   by the batch job.
       CIAM_Import_Table__c[] ciamList = new List<CIAM_Import_Table__c>();
       for (Integer i=0;i<10;i++) {
           CIAM_Import_Table__c im = new CIAM_Import_Table__c(
               Name='Merchandise ' + i,
               Agency_Agent_ID__c='D0_2T'+i,
               Agency_ID__c='D0',
               Broker_Title__c='Assistant',
               Email_Address__c='test@test.com',
               Agent_Last_Name__c = 'testlast',
               Agent_ID__c='2T');
           ciamList.add(im);
       }
       insert ciamList;
                
       //Create Test Account for 51 recordtype
       
       Account acc = new Account();
       id rt = QueryBase.getRecordtypeId('Account', 'X51');
       acc.name='Community_User_Account';     
       acc.type = 'partner';
       acc.Entity_ID__c=ciamList[0].Agent_ID__c;
       acc.recordtypeid=rt;
       insert acc;
       // for 250 recordtype
       Account acc1 = new Account();
       id rt2 = QueryBase.getRecordtypeId('Account', 'X2_50');
       acc1.name='Test';
       acc.type = 'Partner';
       acc1.Entity_ID__c='D0';
       acc1.recordtypeid=rt2;
       insert acc1;
       
       //Create Test contact record for 51 record type
       id rtc = QueryBase.getRecordtypeId('Contact', 'X51');
       Contact con= new Contact();
       con.Lastname='test';
       con.Accountid=acc.id;
       con.Recordtypeid=rtc;
       con.email = 'test@testy.com';
       con.phone = '123456789';
       //con.Entity_ID__c='23456789';
       con.Agency_Agent_ID__c=ciamList[0].Agency_ID__c;
       insert con;
       
       //Create Test contact record for 250 record type
       id rt25 = QueryBase.getRecordtypeId('Contact', 'X2_50');
       Contact con1= new Contact();
       con1.Lastname='test';
       con1.email = 'test@testy.com';
       con1.phone = '123456789';
       con1.Accountid=acc1.id;
       con1.Recordtypeid=rt25;
       //con1.Entity_ID__c='87654321';
       con1.Agency_Agent_ID__c=ciamList[1].Agency_Agent_ID__c;
       insert con1;
       }
     
       public static void CIAMProcessTestUser(){
           
       List<Contact> contList = [SELECT ID from CONTACT LIMIT 5];    
       User[] userList = new List<User>();
           For (Contact c : contList)
           {
       for (Integer i=0;i<5;i++) {
           User newUser = new User(
            FirstName = 'FirstName',
            LastName = 'LastName' + i,
            Alias = 'FLastN'+i,
            Email = i+ 'test@test.com',
            UserName = i+'test@test.com',
            CommunityNickName = 'Firstname.Lastname' + i,
            ContactId = c.ID,
            //ProfileId = '00e600000016Bb9',
            IsActive = TRUE,
            License__c= 'Customer Community Plus Login',
            FederationIdentifier='C001122'+i,
            Broker_Role__c = 'Assistant',
            CompanyName = 'ABC Ltd',
            emailencodingkey = 'UTF-8',
            languagelocalekey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'  );
           userList.add(newUser);
        }
           }
        insert userList;
       }
       
       
    
    
 }