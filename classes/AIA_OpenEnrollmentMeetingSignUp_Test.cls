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
@isTest
private class AIA_OpenEnrollmentMeetingSignUp_Test{
    static testMethod void testSignUp(){
        AIA_TestUtil.AIA_Implemenation_Test();
        event e =[select id from event ];
        user u = AIA_TestUtil.AIA_createUser('Signup');
        
        System.runAs(u) {
            AIA_OpenEnrollmentMeetingSignUp.signUp(e.id);
        }
    }
    /********************************Negative Test with incorrect parameters*************************/
    static testMethod void testFalseSignUp(){
        AIA_TestUtil.AIA_Implemenation_Test();
        event e =[select id from event ];
        e.Current__c=null;
        update e;
        user u = AIA_TestUtil.AIA_createUser('Signup');
        
        System.runAs(u) {
            AIA_OpenEnrollmentMeetingSignUp.signUp(e.id);
        }
    }
    /************************************************************************************************/
 
    /************************************************************************************************/
}