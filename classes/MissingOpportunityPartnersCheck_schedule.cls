global class MissingOpportunityPartnersCheck_schedule implements Schedulable{
   global void execute(SchedulableContext SC){
       MissingOpportunityPartnersCheck c = new MissingOpportunityPartnersCheck(); 
       c.check();
   }
}