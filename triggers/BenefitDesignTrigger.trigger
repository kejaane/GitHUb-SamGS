/*=========================================================================================
// Date:      05/31/2016
// Developer: Chidananda Nagaraj
// Purpose:   All AIA_Benefir Design trigger events start here
//            It's purpose is to handle all AIA_Implementation trigger events
//=========================================================================================
// 							Update History
// Date        Developer                Description
//=========================================================================================
// 05/31/16   | GN              |     | Initial Version
// 10/04/2018 | Rajesh Nagandla | T02 | Add code related to activate/Deactivate trigger 
//                                      from Custom setting 'Activate Deactivate Triggers'
// 01/24/2019 | Rajesh Nagandla | T03 | Added code to bypass triggers using Utils method                                       
//=========================================================================================*/
trigger BenefitDesignTrigger on AIA_Benefit_Design__c (after delete, after insert, after undelete, after update, 
                                                       before delete, before insert, before update) {
    /*T02 - Start*/
    if(!AIA_Utils.isTriggerBypassed('AIA_Benefit_Design__c')) { //T03
        new AIA_BenefitDesignTriggerHandler().run();
    }
    /*T02 - End*/          
}