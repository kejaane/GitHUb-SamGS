/* =========================================================================================
 * Date         : 02/23/17
 * Developer    : Laveen Kattela
 * Purpose      : This test class is for TaskTriggerHandler apex class. 
 *                
 *                   
 *=========================================================================================
 * Update History
 *  ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 02/23/17   |  Laveen Kattela            | Initial Version                                       
 *===========+============+================================================================
 */
@isTest
private class TaskTriggerHandler_Test{
    static testMethod void Test1() {
    
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
         
         t.Subject ='Test2';
         update t;
    
    }

}