global class CFCT_Opps_In_Proposal_51to199_schedule implements Schedulable{
   global void execute(SchedulableContext SC){   
        List<Opportunity> oppList = new Opportunity[]{};
        oppList = CFCT_QueryBase.getOppsInProposalFor_51to199();        
        CFCT_ProcessorManager.opportunitiesInProposalEmailUsers_51to199(oppList);      
   }
}