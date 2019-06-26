/*=================================================================================================================
 * Date         : 02/15/2017
 * Developer    : Asif Kutagulla 
 * Purpose      : Batch class to be run only in sandbox environments. This job will purge data in related to Plan 
 *                Setup & Runtime objects and also Adjustment object. This is created for the purpose of keeping 
 *                the data within maximum storage limits.
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 02/15/2017 | Asif Kutagulla |     | Initial Version                                         
 *===========+=================+=====+=============================================================================
 */
global class AIA_Batch_SandboxDataDeletion implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    global final String Query = 'SELECT id FROM AIA_PCS_Transaction_Table__c LIMIT 7';
    global Integer iterationCount = 1;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(SchedulableContext sc) {
        AIA_Batch_SandboxDataDeletion DataDelJob = new AIA_Batch_SandboxDataDeletion();
        database.executebatch(DataDelJob,1);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        if(UserInfo.getUserName().containsIgnoreCase('spmss.process@carefirst.com'))
        {
            if(iterationCount == 1 || Test.isRunningTest()) {
                list<Adjustment__c> lstAdjustment = [SELECT Id 
                                                     FROM Adjustment__c 
                                                     WHERE createddate < LAST_N_DAYS:4 
                                                     LIMIT 10000];
                delete(lstAdjustment);            
            }
            if(iterationCount == 2 || Test.isRunningTest()) {
                list<AIA_Grouper__c> lstGrouper = [SELECT Id 
                                                   FROM AIA_Grouper__c 
                                                   WHERE createddate < LAST_N_DAYS:4
                                                   LIMIT 10000];
                delete lstGrouper;
            }
            if(iterationCount == 3 || Test.isRunningTest()) {
                list<AIA_Plan_Network__c> lstPlanNetwork = [SELECT Id 
                                                            FROM AIA_Plan_Network__c 
                                                            WHERE createddate < LAST_N_DAYS:4
                                                            LIMIT 10000];
                delete lstPlanNetwork;
            }
            if(iterationCount == 4 || Test.isRunningTest()) {
                AIA_Plan__c RefPlan = [SELECT Id 
                                       FROM AIA_Plan__c 
                                       WHERE Plan_Id__c = 'PLAN-1382'];
                delete RefPlan;
            }
            if(iterationCount == 5 || Test.isRunningTest()) {
                list<AIA_Plan_Copay_Type__c> lstPlanCopayType = [SELECT id 
                                                                 FROM AIA_Plan_Copay_Type__c 
                                                                 WHERE createddate < LAST_N_DAYS:4
                                                                 LIMIT 10000];
                delete lstPlanCopayType;
            }
            if(iterationCount == 6 || Test.isRunningTest()) {
                list<AIA_Plan_Limitation__c> lstPlanLimitation = [SELECT id 
                                                                  FROM AIA_Plan_Limitation__c 
                                                                  WHERE createddate < LAST_N_DAYS:4
                                                                  LIMIT 10000];
                delete lstPlanLimitation;
            }
            if(iterationCount == 7 || Test.isRunningTest()) {
                list<AIA_Benefits__c> lstBenefit = [SELECT id 
                                                    FROM AIA_Benefits__c 
                                                    WHERE createddate < LAST_N_DAYS:4
                                                    LIMIT 10000];
                delete lstBenefit;
            }

        }
        iterationCount++;
    }
    
    global void finish(Database.BatchableContext BC){
        StaticResource sr = [select id,body from StaticResource Where Name = 'BenefitSummaryJSONBRF'];
        String jsonStr=sr.body.toString();
        AIA_PCS_BenefitSummary apbroot=AIA_PCS_BenefitSummary.parse(jsonStr);
        AIA_PlanTemplateMapper mapper = new AIA_PlanTemplateMapper();
        mapper.saveToSetUp(apbroot,'BRF');
        
        StaticResource sr1 = [select id,body from StaticResource Where Name = 'BenefitSummaryJSONBDD'];
        String jsonStr1=sr1.body.toString();
        AIA_PCS_BenefitSummary apbroot1=AIA_PCS_BenefitSummary.parse(jsonStr1);
        AIA_PlanTemplateMapper mapper1 = new AIA_PlanTemplateMapper();
        mapper1.saveToSetUp(apbroot1,'BDD');        
                
        AIA_Plan__c RefPlan = [SELECT Id,Product_Last_Updated_String_Format__c,BDF_Configuration_Last_Updated__c,Configuration_Last_Updated__c 
                               FROM AIA_Plan__c 
                               WHERE Plan_Id__c = 'PLAN-1382'];
        RefPlan.Product_Last_Updated_String_Format__c = '2017-02-06  07:59:58 PM';
        RefPlan.Configuration_Last_Updated__c = DateTime.newInstance(2017, 1, 1);
        RefPlan.BDF_Configuration_Last_Updated__c = DateTime.newInstance(2017, 1, 1);
        update RefPlan;
    }

}