//=========================================================================================
//      Date: 10/19/2018     
// Developer: Tom Barrett (TPB)
//   Purpose: This class performs tests the SM_PAcallout_Schedulable class
//=========================================================================================
//                                 Update History
// Date       Developer     Tag     Description
//=========================================================================================
//
//=========================================================================================
@isTest
public class SM_PAcallout_Schedulable_Test {
    static testMethod void schedulerTest() {
        String cronExp = '0 0 0 15 3 ? *';
        Test.startTest();
            String jobId = System.schedule('ScheduleApexClassTest', cronExp, new SM_PAcallout_Schedulable());           
        Test.stopTest();
    }
    
    static testMethod void scheduulerTest2() {
        Test.startTest();
        try {
            SM_PAcallout_Schedulable.scheduleIt();
        } catch(exception e){
            //If job is already scheduled an expected error is thrown so we 
            //catch it and force pass the test; otherwise force fail the test.            
            if(e.getMessage().contains('already scheduled for execution')) {
            	System.assert(true);
            }else{
                System.assert(false);
            }  
        }
        Test.stopTest();
    }
}