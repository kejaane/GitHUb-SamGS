@isTest
private class CFCT_Opps_In_Proposal_51to199_sch_Test {  
    static testMethod void CFCT_OwnerLeadRepNoMatch_schedule_Test() {
        Test.StartTest();
        CFCT_Opps_In_Proposal_51to199_schedule sh = new CFCT_Opps_In_Proposal_51to199_schedule();
        String sch = '0 0 5 * * ?';
        system.schedule('Schedule TEST', sch, sh);
        Test.stopTest();
    }
}