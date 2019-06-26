// Bill 3/23/2017  Added "before delete".
trigger AIA_Benefit_Trigger on AIA_Benefits__c (after insert,after update,before delete,before Update) {
      //Invokes the run method in the TriggerHandler class
          new AIA_BenefitTriggerHandler().run();
}