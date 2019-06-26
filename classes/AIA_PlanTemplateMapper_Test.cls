@isTest
public  class AIA_PlanTemplateMapper_Test {
    
    @isTest static void testSaveToSetUpObjects() {
        StaticResource sr = [select id,body from StaticResource Where Name = 'PLAN2097BDJSONFORTESTCLASS'];
        String jsonStr=sr.body.toString();
        AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
        AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
        mapper.saveToSetUp(apbroot,'BDD');
        System.assert(apbroot!=null);
    }
    
        
    @isTest static void testSaveToSetUpObjectsBRF() {
        StaticResource sr = [select id,body from StaticResource Where Name = 'BenefitSummaryJSONBRF'];
        String jsonStr=sr.body.toString();
        AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
        AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
        mapper.saveToSetUp(apbroot,'BRF');
        System.assert(apbroot!=null);
    }
    
}