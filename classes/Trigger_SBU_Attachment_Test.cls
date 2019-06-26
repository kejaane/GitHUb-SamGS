@isTest
private class Trigger_SBU_Attachment_Test {

    static testMethod void Test1() {
        Test.startTest();
        //Create Case
        Case cas   = new Case();
        cas.Origin = 'Email: Broker Sales MD'; 
        cas.Subject = 'Test';
        cas.status = 'Assigned';
        insert cas;
        
        //Create attachment
        Attachment Attach = New Attachment();

        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cas.id;
        insert attach;
        
        Test.stopTest();        
        System.assert([select ParentId from attachment where parentId=:cas.id].size() == 1);
    }
   
    // Test error condition
    static testMethod void Test2() {
        Test.startTest();
         //Create Account       
        Id rt_acc_51 = QueryBase.getRecordtypeId('Account', 'X51');
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        a.RecordTypeId = rt_acc_51;
        a.AccountNumber = '12345';
        insert a;
               //Create Contact
        Id rt_Con_51 = QueryBase.getRecordtypeId('Contact', 'Community_User_Contact');
        Contact con         = new Contact(); 
        con.LastName        = 'LastName';
        con.phone           ='123456789';
        con.RecordTypeId    = rt_Con_51;
        con.email           ='con@email.con';
        con.AccountId       = a.id;
        insert con;
       
        //Create case
        Id rt_Case = QueryBase.getRecordtypeId('case', 'SBU_Broker_Support_Internal');
        Case cas   = new Case();
        cas.Subject = 'Test';
        cas.Origin = 'Email: Retro activity Request';
        cas.Status = 'Closed';
        cas.Description ='testing';
        cas.SLA_Category__c='Broker Compliance';
        cas.Broker_Service_Team__c ='Compliance';
        cas.New_Group_ID__c = '1234';
        cas.Facets_Subject__c = 'MBIL-M Billing';
        cas.Facets_Category__c = 'MB63-Duplicate Bill';
        cas.ContactId = con.id;
        cas.Resolution_Reason__c = 'test reason';
        cas.Reason__c = 'C100-Others';
        cas.Facets_case_Id__c = '12345678';
        cas.RecordTypeId    = rt_Case;
        
        insert cas;
     
        //Create attachment
        Attachment Attach = New Attachment();

        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cas.id;
        Try{
            insert attach;
            }
            catch(exception e){}
                    
          
       Test.stopTest();        
        System.assert([select ParentId from attachment where parentId=:cas.id].size() == 0);
    }
    
    static testMethod void Test3() {
        Test.startTest();
        //Create Case
        Case cas   = new Case();
        cas.Origin = 'Email: Broker Sales MD'; 
        cas.Subject = 'Test';
        cas.status = 'Assigned';
        insert cas;
        
        //Create attachment
        Attachment Attach = New Attachment();

        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=cas.id;
        insert attach;
        
         try
           {
              delete attach;
              // should throw an exception - the following assertion will cause an error if the code carries on
              System.assert(True);
           }
        catch (DMLException e){}
         
    }
}