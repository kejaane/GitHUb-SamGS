/*==============================================================================================
 * Date         : 06/12/2018
 * Developer    : Asif Kutagulla
 * Purpose      : Helper class for ProcessTriggerHandler class.
 *==============================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer        Tag      Description
 *============+================+=====+==========================================================
 * 06/12/2018 | Asif Kutagulla | T01 | Initial Version. Added method to updated end date of the
 *                                     Implementation & Totaal number of blocked tasks on it.
 * 09/03/2018 | Rajesh Nagandla| T02 | Added logic to Auto close task - 'Group Structure & Admin Setup'
                                        once all other Tasks under implementation is completed.
 * 04/16/2019 | Satya           |T03 |  Commented Debug statementts inside for loop
 *============+================+=====+==========================================================
 */
public without sharing class AIA_ProcessTriggerHelper {
    
    /** Method to update Implementation End Date and Blocked Tasks **/
    public void UpdateImplementationMetrics(list<Process__c> processesModified) {
        try {
            map<Id,list<Process__c>> mapImpl_Proc = new map<Id,list<Process__c>>();
            list<Id> lstImplIDs = new list<Id>();
            for(Process__c proc : processesModified) {
                if(String.isNotBlank(proc.Implementation__c)) {
                    lstImplIDs.add(proc.Implementation__c);
                }
            }  
            
            if(!lstImplIDs.isEmpty()) {
                list<Process__c> lstProc;
                for(Process__c proc : [SELECT Id,Name,Total_BlockedTasks_All_SubProcesses__c,Total_Completed_Tasks_All_SubProcesses__c,
                                              Implementation__c, Total_NotRequired_Tasks_All_SubProcesses__c,Total_Tasks_All_SubProcesses__c,
                                              Number_of_Tasks_SLA_Broken__c
                                       FROM Process__c 
                                       WHERE Implementation__c IN :lstImplIDs]) 
                {
                   if(mapImpl_Proc.containskey(proc.Implementation__c)) {
                       mapImpl_Proc.get(proc.Implementation__c).add(proc);
                   }
                   else {
                       lstProc = new list<Process__c>();
                       lstProc.add(proc);
                       mapImpl_Proc.put(proc.Implementation__c,lstProc);
                   }
                }//end for
            }
            
            list<AIA_Implementation__c> lstImplToUpdate = new list<AIA_Implementation__c>();
            Decimal tempBlockedTaskCount = 0;
            Decimal tempSLAbrokenTaskCount = 0;
            Integer tempImplNotComplete = 0;
            
            for(Id implID : mapImpl_Proc.keySet()) {
                
                tempBlockedTaskCount = 0;
                tempSLAbrokenTaskCount = 0;
                tempImplNotComplete = 0;
                
                for(Process__c prc : mapImpl_Proc.get(implID)) {
                    tempBlockedTaskCount = tempBlockedTaskCount + prc.Total_BlockedTasks_All_SubProcesses__c;
                    tempSLAbrokenTaskCount = tempSLAbrokenTaskCount + prc.Number_of_Tasks_SLA_Broken__c;
                    
                    //system.debug('prc.Id==='+prc.Id); T03
                    //system.debug('prc.Total_Tasks_All_SubProcesses__c===' + prc.Total_Tasks_All_SubProcesses__c); //T03
                    //system.debug('prc.Total_Completed_Tasks_All_SubProcesses__c===' + prc.Total_Completed_Tasks_All_SubProcesses__c);//T03
                    //system.debug('prc.Total_NotRequired_Tasks_All_SubProcesses__c===' + prc.Total_NotRequired_Tasks_All_SubProcesses__c);//T03
                    
                    if(prc.Total_Tasks_All_SubProcesses__c == 0 || prc.Total_Tasks_All_SubProcesses__c == NULL ||  
                       (prc.Total_Tasks_All_SubProcesses__c != (prc.Total_Completed_Tasks_All_SubProcesses__c + prc.Total_NotRequired_Tasks_All_SubProcesses__c))) {
                        tempImplNotComplete++;
                        //system.debug('prc.Id--'+prc.Id+'tempImplNotComplete--'+tempImplNotComplete);//T03
                    }
                }
                
                AIA_Implementation__c implToUpd = new AIA_Implementation__c(Id = implID);
                implToUpd.Number_of_Blocked_Tasks__c = tempBlockedTaskCount;
                implToUpd.Number_of_Tasks_SLA_Broken__c = tempSLAbrokenTaskCount;
                if(tempImplNotComplete==0) { implToUpd.Date_Implementation_Ended__c = Date.today(); }
                lstImplToUpdate.add(implToUpd);
            }
            
            if(!lstImplToUpdate.isEmpty()) { Database.update(lstImplToUpdate,false); }
        }//end try
        catch(Exception ex) {
            AIA_Utils utils = new AIA_Utils(); utils.logException(ex); 
        }
        
    }//End Method
    /**T02 - Start**/
    public void finalTaskCloseUpdate(list<Process__c> processesModified) {
        string PROCESS_NAME = 'Group Structure & Admin Setup';
        string PROCESS_COMPLETED = 'Completed';
        string PROCESS_NOTREQ = 'Not Required';
        string PROCESS_INPROG = 'In Progress';
        string FINAL_DES = 'Complete Account Implementation Review/Approval';
        list<Id> lstImplIDs = new list<Id>();
        list<Workplan_Task__c> wptlst = new list<Workplan_Task__c>();
            
        try {
            for(Process__c proc : processesModified) {
                //Checking Funding Arrangement in not equal to ASO, to make sure that FINAL_DES is generated under
                if(String.isNotBlank(proc.Implementation__c) && proc.Status__c == PROCESS_COMPLETED && proc.Implementation__r.BRF_Funding_Arrangement__c != 'ASO') {
                    lstImplIDs.add(proc.Implementation__c);
                }
            }  
            
            if(!lstImplIDs.isEmpty()) {
                list<Process__c> processlst = [SELECT Id, Stage__c, Implementation__c, Implementation__r.BRF_Funding_Arrangement__c, 
                                                (Select id, Description__c, Status__c from Workplan_Tasks__r where 
                                                Status__c != 'Completed' and Status__c != 'Not Required') 
                                                FROM Process__c WHERE Implementation__c IN :lstImplIDs AND Status__c != 'Completed'];
                if(processlst.size() == 1){
                    for(Process__c proc :processlst){
                        if(proc.Workplan_Tasks__r.size() == 1 && proc.Stage__c == PROCESS_NAME){
                            for(Workplan_Task__c wpt:proc.Workplan_Tasks__r){
                                if(wpt.Status__c == PROCESS_INPROG && wpt.Description__c == FINAL_DES){
                                    wpt.Status__c = PROCESS_COMPLETED;
                                    wptlst.add(wpt);
                                }
                            }
                        }
                    }
                    if(!wptlst.isEmpty()){
                        update wptlst;
                    }
                }
            }
        }//end try
        catch(Exception ex) {
            AIA_Utils utils = new AIA_Utils(); utils.logException(ex); 
        }
        
    }//End Method
    /**T02 - End**/

}