@isTest
public class Dependent_Picklist_Test {
    
    @isTest
    public static void testGetDependentOptionsImpl(){
        
        //correct parameters
        final Map<String,List<String>> result = Dependent_Picklist.getDependentOptionsImpl('opportunity','SBU__c','Market_Segment_New__c');
        system.assertNotEquals(NULL, result);
        
        //incorrect parameters
        Dependent_Picklist.getDependentOptionsImpl('nonexistingobj','SBU__c','Market_Segment_New__c');
        Dependent_Picklist.getDependentOptionsImpl('opportunity','nonexistingfield','Market_Segment_New__c');
        Dependent_Picklist.getDependentOptionsImpl('opportunity','SBU__c','nonexistingfield');
        Dependent_Picklist.getDependentOptionsImpl('opportunity','SBU__c','SBU__c');

    }
    
    @isTest
    public static void testGetselectOptions(){
        
        sObject sObj = new opportunity();
        final List<String> result = Dependent_Picklist.getselectOptions(sObj,'SBU__c');
        system.assertNotEquals(NULL, result);
    }

}