/*****************************************************************************************************
*Date: 07-23-2018
*Developer: Paritosh
*Purpose: Test class for PicklistFieldController
*=========================================================================================
* Update History
* Date         Developer               Description
*==================================================================================
*07-23-2018   Paritosh            Initial Development
*==================================================================================

*******************************************************************************************************/

@isTest
public class PicklistFieldControllerTest {
    
    @isTest
    public static void test1(){
        
        //correct parameters
        final Map<String,List<String>> result = PicklistFieldController.getDependentOptionsImpl('opportunity','SBU__c','Market_Segment_New__c');
        system.assertNotEquals(NULL, result);
        
        //incorrect parameters
        PicklistFieldController.getDependentOptionsImpl('nonexistingobj','SBU__c','Market_Segment_New__c');
        PicklistFieldController.getDependentOptionsImpl('opportunity','nonexistingfield','Market_Segment_New__c');
        PicklistFieldController.getDependentOptionsImpl('opportunity','SBU__c','nonexistingfield');
        PicklistFieldController.getDependentOptionsImpl('opportunity','SBU__c','SBU__c');
        
        //test wrapper class
        PicklistEntryWrapper wrapper = new PicklistEntryWrapper();
        String str = wrapper.active + wrapper.defaultValue + wrapper.label + wrapper.value + wrapper.validFor;

    }
}