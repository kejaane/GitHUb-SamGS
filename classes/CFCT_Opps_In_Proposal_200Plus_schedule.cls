global class CFCT_Opps_In_Proposal_200Plus_schedule implements Schedulable{
   global void execute(SchedulableContext SC){   
        List<Opportunity> oppList = new Opportunity[]{};
        oppList = CFCT_QueryBase.getOppsinproposalfor_200Plus();      
        CFCT_ProcessorManager.opportunitiesInProposalEmailUsers_200plus(oppList);      
   }
}