@istest 
public class SBU_MyCasesPageController_TEST{
private testmethod static void TestMethod1(){

Account acc = new Account();
       id rt = QueryBase.getRecordtypeId('Account', 'X51');
       acc.name='Community_User_Account';     
       acc.type = 'partner';
       acc.recordtypeid=rt;
       insert acc;
        
        //Create Test contact record for 250 record type
       id rt25 = QueryBase.getRecordtypeId('Contact', 'Community_User_Contact');
       Contact con1= new Contact();
       con1.Lastname='test';
       con1.email = 'test@testy.com';
       con1.phone = '123456789';
       con1.Accountid=acc.id;
       con1.Recordtypeid=rt25;
       
       insert con1;
       
       Contact con2= new Contact();
       con2.Lastname='test';
       con2.email = 'test@testy.com';
       con2.phone = '123456789';
       con2.Accountid=acc.id;
       con2.Recordtypeid=rt25;
       
       insert con2;
       
       profile p = [SELECT Id FROM Profile WHERE Name='Customer Community Plus Login User']; 
       User newUser = new User(
            FirstName = 'FirstName',
            LastName = 'LastName',
            Alias = 'FLastN',
            Email = 'test1test@test.com',
            UserName = 'test1@test.com',
            CommunityNickName = 'Firstname.Lastname' ,
            ContactId = con1.ID,
            ProfileId = p.id,
            IsActive = TRUE,
            License__c= 'Customer Community Plus Login',
            FederationIdentifier='C0011221',
            Broker_Role__c = 'Assistant',
            CompanyName = 'ABC Ltd',
            emailencodingkey = 'UTF-8',
            languagelocalekey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'  );
           
        
           
        insert newUser;
        
        User newUser1 = new User(
            FirstName = 'FirstName',
            LastName = 'LastName1' ,
            Alias = 'FLastN',
            Email = 'test2test@test.com',
            UserName = 'test2@test.com',
            CommunityNickName = 'Firstname.Lastname1' ,
            ContactId = con2.ID,
            ProfileId = p.id,
            IsActive = TRUE,
            License__c= 'Customer Community Plus Login',
            FederationIdentifier='C0011220',
            Broker_Role__c = 'Broker Agent',
            CompanyName = 'ABC Ltd',
            emailencodingkey = 'UTF-8',
            languagelocalekey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/New_York'  );
           
          
        insert newUser1;
       
       //Create Test case with contact id as community user id
       Case cas = new Case();
       cas.subject = 'Test';
       cas.contactid = newuser1.contactid;
       cas.Origin = 'Web';
       cas.Priority = 'High';
       cas.Resolution_Reason_Posted_Date__c =System.today();
       cas.Reason  = 'Test';
       cas.Status  = 'Open';
       cas.Subject = 'Test';
       cas.Type = 'Problem';
       
       insert cas;
       
       //Create Test case with contact id as community user id
       Case cas1 = new Case();
       cas1.subject = 'Test';
       cas1.contactid = newuser.contactid;
       cas1.Origin = 'Web';
       cas1.Priority = 'High';
       cas1.Resolution_Reason_Posted_Date__c = System.today();
       cas1.Reason  = 'Test';
       cas1.Status  = 'Open';
       cas1.Subject = 'Test';
       cas1.Type = 'Problem';
       
       insert cas1;
       



    system.runas(newuser){
    SBU_MyCasesPageController.getCaseSummary();
    SBU_MyCasesPageController.getContacts();
    }
    
    system.runas(newuser1){
    SBU_MyCasesPageController.getCaseSummary();
    SBU_MyCasesPageController.getContacts();
    }
    
        
     
    }
    }