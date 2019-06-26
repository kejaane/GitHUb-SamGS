/*=========================================================================================
 * Date      : 06/08/2016
 * Developer : Rajesh Pennam
 * Purpose   : This class is having the logic to update the due date with +7 days when user
               leave the Due field blank for tasks(MIT)              
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer         Description
 *===========+============+================================================================
 * 06/03/2016  |  Rajesh Pennam    | Initial Version                                         
 *             |          | 
 *=============+==========+================================================================
 */
public class MIT_Tasks {
    public static void UpdateDueDate(List<Task> TskLst){
        Id RecTypeId = QueryBase.getRecordTypeId('Task', 'MIT');
        
        System.debug('RecordTypeId: ' + RecTypeId);
        
        for ( Task t: TskLst )  {
            if ( t.RecordTypeId == RecTypeId && t.ActivityDate == NULL ) {                
                t.ActivityDate = System.toDay() + 7;                
            }
        }        
    }

 }