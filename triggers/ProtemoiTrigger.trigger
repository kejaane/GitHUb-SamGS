trigger ProtemoiTrigger on Protemoi__c (before insert,before update){
       new ProtemoiTriggerHandler().run();
}