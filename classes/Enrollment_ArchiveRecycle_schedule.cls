//=========================================================================================
//      Date: 06/04/2013
// Developer: Tom Barrett (TPB)
//   Purpose: This class is the Enrollment Recycle Archive schedule class.
//=========================================================================================
//                                 Update History
// Date       Developer      Description
//=========================================================================================
//  
//=========================================================================================
global class Enrollment_ArchiveRecycle_schedule implements Schedulable{
    global void execute(SchedulableContext SC){
        Enrollment_ArchiveRecycle ear = new Enrollment_ArchiveRecycle();
   }
}