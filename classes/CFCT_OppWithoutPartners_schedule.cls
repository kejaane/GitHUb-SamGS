global class CFCT_OppWithoutPartners_schedule implements Schedulable{
   global void execute(SchedulableContext SC){   
        List<Opportunity> oppList = new Opportunity[]{};
        oppList = CFCT_QueryBase.getOppsDateLimitWithoutPartners();      
        CFCT_ProcessorManager.opportunitiesWithoutPartnersEmailUsers(oppList);      
   }
}