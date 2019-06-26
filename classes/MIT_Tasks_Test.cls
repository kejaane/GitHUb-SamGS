/*
===================================================================
Date : 06/12/2016
Developer : Rajesh Pennam
Purpose: Test Class For TaskTrigger And Related Handler Classes.
===================================================================
*/
@isTest
public class MIT_Tasks_Test{
    
    public static testmethod void mytest2(){
        Id RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('MIT').getRecordTypeId(); 
        
        //insert account
        Account a = new Account();
        a.Name = 'SomeTest' + Date.Today();
        a.Type = 'Customer';
        insert a;
        
         //Insert Tasks
         Task t = new Task();
         t.OwnerId = UserInfo.getUserId();
         t.Status = 'open';
         t.Priority = 'Normal';
         t.Subject = 'Test1';
         t.WhatId = a.id;
         t.RecordTypeId = RecordTypeId;
         insert t;
         
         Task t1 = new Task();
         t1.OwnerId = UserInfo.getUserId();
         t1.Status = 'open';
         t1.Priority = 'Normal';
         t1.Subject = 'Test2';
         t1.WhatId = a.id;
         t1.ActivityDate = Date.today();
         t1.RecordTypeId = RecordTypeId;
         insert t1; 
         
    }
}