/* =========================================================================================
 * Date         : 05/01/17
 * Developer    : Laveen Kattela
 * Purpose      : This test class is for CIAM USer creation process apex class. 
 *                
 *                   
 *=========================================================================================
 * Update History
 *  ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 05/01/17   |  Laveen Kattela            | Initial Version                                       
 *===========+============+================================================================
 */
@isTest
public class CIAM_User_Creation_Process_TEST {

    static testmethod void testCIAM_User_Creation_Process() {
    
            CIAM_Import_Table__C cobj = new CIAM_Import_Table__C();
            cobj.Agency_Agent_ID__c ='TESTAGENTID';
            cobj.Agent_First_Name__c ='TESTFirst Name';
            cobj.Agent_Last_Name__c ='last name';
            cobj.Email_Address__c = 'test@test.com';
            cobj.Federation_ID__c='FEDID1111';
            insert cobj;
            
            CIAM_Import_Table__C cobj2 = new CIAM_Import_Table__C();
            cobj2.Agency_Agent_ID__c ='TESTAGENTID2';
            cobj2.Agent_First_Name__c ='TESTFirst Name';
            cobj2.Agent_Last_Name__c ='last name';
            cobj2.Email_Address__c = 'test@test.com';
            cobj2.Federation_ID__c='FEDID1111';
            insert cobj2;
    
            Account portalAccount = new Account(name = 'portalAccount');//create a portal account first
            insert portalAccount;
            Contact portalContact = new contact(LastName = 'portalContact', AccountId = portalAccount.Id,Agency_Agent_ID__c='TESTAGENTID',phone='11111111111',
                                                            email='test@test.com'); //create a portal contact
            insert portalContact;
            User u1 = new User( email='spmss.process@carefirst.com',
                profileid = System.label.Customer_Community_Plus_Login_User, 
                UserName='test.test@test123.com' , 
                Alias = 'GDS',
                TimeZoneSidKey='America/New_York',
                EmailEncodingKey='ISO-8859-1',
                LocaleSidKey='en_US', 
                LanguageLocaleKey='en_US',
                ContactId = portalContact.Id,
                PortalRole = 'Manager',
                FirstName = 'spmss',
                LastName = 'process');
                 String Query = 'SELECT id, Agent_First_Name__c, Agent_Last_Name__c, Agent_Middle_Initial__c, Agent_Name__c, Agency_Name__c, Broker_Title__c, Agent_ID__c, Email_Address__c, User_ID__c, Federation_ID__c, Agency_Agent_ID__c from CIAM_Import_Table__C LIMIT 5';
                  
                CIAM_User_Creation_Process sc = new CIAM_User_Creation_Process(query);
                Database.executeBatch(sc, 5);
        
 
    }
 
}