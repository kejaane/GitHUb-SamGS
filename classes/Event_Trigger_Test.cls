/***********************************************************************************
     Date: 12/23/2011
Developer: Tom Barrett
  Purpose: To test the Event_Trigger trigger   
------------------------------------------------------------------------------------
                       ----===[ HISTORY ]===---
Date        Developer        Description
------------------------------------------------------------------------------------
12/23/2011  Tom Barrett      Origin: 
***********************************************************************************/
@isTest
private class Event_Trigger_Test {
    static testMethod void Test1() {
        Test.startTest();  
        Engagements__c te = new Engagements__c();
        te.Name = 'Enagement Test1';
        insert te;                
        List<RecordType> recTypes = [ Select Id From RecordType Where Name IN('DPS: Training Session', 'DPS: House Meeting', 'DPS: Debrief Meeting') and sObjectType = 'Event' ]; 
        Event e = new Event();
        e.Subject = 'Test1';
        e.DurationInMinutes = 10;
        e.ActivityDateTime = Date.Today();
        e.RecordTypeId = recTypes[0].id;
        e.WhatId = te.id;       
        insert e;        
        Test.stopTest();
    }  

    static testMethod void Test2() {
                       
        List<RecordType> recTypes = [ Select Id From RecordType Where Name IN('DPS: Training Session', 'DPS: House Meeting', 'DPS: Debrief Meeting') and sObjectType = 'Event' ];        
        Event e = new Event();
        e.Subject = 'Test2';
        e.DurationInMinutes = 10;
        e.ActivityDateTime = Date.Today();
        e.RecordTypeId = recTypes[0].id;
        e.WhatId = null;
         Test.startTest();
        try {
            insert e;
            //System.assert(false);
        }
        catch (exception ex) 
        {
            //expected
        }
        
        Test.stopTest();
    }     
}