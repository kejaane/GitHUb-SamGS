/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
// TODO: 6/22 - Add Header 
 
@isTest
private class AIA_DE_OpportunityStageClass_Test{
    static testMethod void testOppStage(){
        // TODO: Create Test Data which include Sales Process
        // 1. Create Sales Process
        // 2. Create Account
        // 3. Create Opportunity
        // 4. Test that the correct stages have been retrieved
    
        Test.startTest();
        //Create Opportunity
        Opportunity opp = new Opportunity(name='Testopp',closeDate=system.today()+90,stageName='Prospecting');
        
        ApexPages.StandardController con = new ApexPages.StandardController(opp);
        AIA_DE_OpportunityStageClass dos = new AIA_DE_OpportunityStageClass(con );
        dos.getPickListValues();
        Test.stopTest(); 
        
        // TODO: 6/22 - Add assert statements
       
    }
}