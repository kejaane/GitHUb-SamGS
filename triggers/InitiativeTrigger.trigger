trigger InitiativeTrigger on Initiative__c (before insert,before update){
       new InitiativeTriggerHandler().run();
}