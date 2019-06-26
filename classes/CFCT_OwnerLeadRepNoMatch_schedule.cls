global class CFCT_OwnerLeadRepNoMatch_schedule implements Schedulable{
   global void execute(SchedulableContext SC){   
        List<Opportunity> oppList = new Opportunity[]{};
        oppList = CFCT_QueryBase.getOppsDateLimit();      
        CFCT_ProcessorManager.ownerLeadRepNoMatchEmailUsers(oppList);      
   }
}