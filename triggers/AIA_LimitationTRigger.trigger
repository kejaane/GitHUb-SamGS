// 03/23/2017  Bill Dodson   Add "before delete"
trigger AIA_LimitationTRigger on Limitations__c (after insert,after update, before delete) {
       //Invokes the run method in the TriggerHandler class
           new AIA_BenefitCommentCodesTriggerHandler().run();
}