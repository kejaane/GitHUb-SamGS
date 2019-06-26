//===================================================================================
//Date: 04/19/2016
//Developer: Sree Harsha Akkala
//=========================================================================================
// Update History
// Date         Developer               Description
//==================================================================================
//04/19/2016    Sree Harsha Akkala      Initial Development
//==================================================================================
public with sharing class AIA_DE_OpportunityStageClass {

// TODO: 6/22 - There were customizations that were made to this class to only show opportunity stages
//              tied to the sales process associated with the current opportunity.

    private final Opportunity mysObject;
    public String oppStageList {get;set;}
    public String oppStageNum {get;set;}
    
    // Constructor
    public AIA_DE_OpportunityStageClass(ApexPages.StandardController stdController) {
        this.mysObject = (Opportunity)stdController.getRecord();
        oppStageList = '[\'';
        oppStageNum = '[\'';
        getPicklistValues();
    }

    // Get pickclist values for Opportunity Stage
    public void getPicklistValues()
    {
        //Set Stage Number 
        Integer i = 1;
        //Query for All Stages in list that aren't 0% Probable (aka 'Closed Lost')
        for (OpportunityStage os : [select MasterLabel, SortOrder from OpportunityStage 
            where IsActive=true and DefaultProbability!=null and DefaultProbability!=0.0 and ApiName != 'Proposal' order by SortOrder])
        {
            oppStageList += os.MasterLabel + '\', \'';
            oppStageNum += i + '\', \'';
            i += 1;
        }

        oppStageList = oppStageList.substring(0, oppStageList.length()-3);
        oppStageList = oppStageList + ']';

        oppStageNum = oppStageNum.substring(0, oppStageNum.length()-3);
        oppStageNum = oppStageNum + ']';
    }
}