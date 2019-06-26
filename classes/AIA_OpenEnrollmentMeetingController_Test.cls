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
@IsTest
private class AIA_OpenEnrollmentMeetingController_Test{
    static testmethod void testFetchAllOEMs(){
        test.startTest();
        //Create  OpenEnrollment Meetings
        AIA_TestUtil.AIA_CreateEvents();
        AIA_OpenEnrollmentMeetingController omc = new AIA_OpenEnrollmentMeetingController();
        omc.getInitialEventSet();
        system.assert(omc.events.size()>0);
        omc.isOpen=true;
        omc.getInitialEventSet();
        system.assert(omc.events.size()>0);
        omc.isFull=true;
        omc.getInitialEventSet();
        system.assert(omc.events.size()>0);
        omc.isCompleted=true;
        omc.getInitialEventSet();
        system.assert(omc.events.size()>0);
        omc.isOpen=false;
        omc.getInitialEventSet();
        system.assert(omc.events.size()>0);                             
        
        test.stopTest();
    }
    
    static testmethod void testgetPickList(){
         AIA_OpenEnrollmentMeetingController omc = new AIA_OpenEnrollmentMeetingController();
         List<SelectOption> lst=omc.getPickList();
        system.assert(lst.size()>0);
    }
    
    static testmethod void testNavigation(){
         Test.startTest();
         AIA_TestUtil.AIA_CreateEvents();
         AIA_OpenEnrollmentMeetingController omc = new AIA_OpenEnrollmentMeetingController();
         omc.pageSize=1;
         omc.getInitialEventSet();
         omc.next(); 
         system.assert(omc.pageNumber>1);
         omc.isFull=true;
         omc.previous();
         system.assert(omc.pageNumber==1);
         omc.lastPage();
         system.assert(omc.pageNumber==2,'this is'+omc.noOfPages);
         omc.isCompleted=true;
         omc.firstPage();
         system.assert(omc.pageNumber==1);
         Test.stopTest();
    }
    
}