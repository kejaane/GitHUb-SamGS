/*==============================================================================================
 * Date         : 04/18/2018
 * Developer    : Laveen Kattela
 * Purpose      : This class is the extension point of the Trigger Framework for adding 
 *                Process Type trigger handlers.
 *==============================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer        Tag      Description
 *============+================+=====+==========================================================
 * 04/30/2018 | Laveen         | T01 | Initial Version. Updated method call which is used to 
 *                                      create subprocess in both pre-sales and post-sales
 * 06/13/2018 | Asif Kutagulla | T02 | Added method call to update implementation end date and
 *                                      number of associated blocked tasks
 * 09/03/2018 | Rajesh Nagandla| T03 | Added logic to Auto close task - 'Group Structure & Admin Setup'
										once all other Tasks under implementation is completed.
 *============+================+=====+==========================================================
 */

public class ProcessTriggerHandler extends TriggerHandler {
    public static Boolean firstRunAfterInsert = true;
    public static Integer firstRunAfterUpdate = 0;

    public ProcessTriggerHandler() {
        
    }
      
    protected override void beforeUpdate() {
         
    }
    
    protected override void beforeInsert() {
        
    }
    
    protected override void afterInsert() {
        /*** T01 - Start ***/ 
        if(firstRunAfterInsert){
            firstRunAfterInsert = false;
            AIA_SubProcessController.createSubProcess(Trigger.New , True);
        }
        /*** T01 - End   ***/
    }
    
    protected override void afterUpdate() {
        /*** T02 - Start ***/
        if(firstRunAfterUpdate < 2) {
             firstRunAfterUpdate++;
             AIA_ProcessTriggerHelper pth = new AIA_ProcessTriggerHelper();
             pth.UpdateImplementationMetrics(trigger.new);
			 /**T03 - Start**/
			 pth.finalTaskCloseUpdate(trigger.new);
			 /**T03 - End**/

        }
        /*** T02 - End   ***/
    }
}