@isTest private class Top10PartnerPurge_TEST {    
    static testMethod void purgeIt() { 
        Test.startTest();        
        Top10PartnerPurge t = new Top10PartnerPurge();
        t.purgeIt();              
        Test.stopTest();
    }
}