//=========================================================================================
//      Date: 10/19/2018     
// Developer: Tom Barrett (TPB)
//   Purpose: This class schedules the SM_PAcallout_Schedulable class.
//            The schedule is every Monday at 6am.
//=========================================================================================
//                                 Update History
// Date       Developer     Tag     Description
//=========================================================================================
//
//=========================================================================================
public class SM_PAcallout_Schedulable implements Schedulable { 
    //default schedule    
    public static final String cronExp = '0 0 6 ? * MON';
    
    //Used by the package post action to schedule the job
    public static String scheduleIt() {
        SM_PAcallout_Schedulable job = new SM_PAcallout_Schedulable();
        return System.schedule('Sandbox Manager: SM_PAcallout - Profile Audit Job', cronExp, job);
    }
    
    //The code that is executed by the job once it is initially scheduled
    public void execute(SchedulableContext sc) {
		SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Profile_Audit);
    }
}