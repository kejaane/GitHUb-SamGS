/*=========================================================================================
 * Date      : 07/24/2016
 * Developer : Rajesh Pennam
 * Purpose   : This class is the extention controller for the VisualForce Page Initiative Process
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer         Description
 *===========+============+================================================================
 * 07/24/2016  |  RajeshPennam     | Initial Version                                         
 *             |          | 
 *=============+==========+================================================================
 */
public class InitiativeProcessCtrl{
    public Initiative__c Iniobj;
    public string ProcessLst{get;set;}
    public string ProcessLstOrdr{get;set;}
    //Cotroller Extention Constructor
    public InitiativeProcessCtrl(ApexPages.StandardController stdController){
        this.Iniobj = (Initiative__c)stdController.getRecord();
        system.debug('i am in constructor');
        ProcessLst =  '[\''; // This have names of the Picklist
        ProcessLstOrdr = '[\''; // This have the order for Picklist
        prepareProcessLst();
    }
    public void prepareProcessLst(){
        Schema.DescribeFieldResult PP = Initiative__c.Step_To_Step_Process_State__c.getDescribe();
        List<Schema.PicklistEntry> PPL = PP.getPicklistValues();
        system.debug(PPL.size());
        Integer i = 1;
        for(Schema.PicklistEntry p:PPL){
            ProcessLst += p.getValue()+ '\', \'';
            ProcessLstOrdr += i + '\', \'';
            i += 1;
        }
        ProcessLst = ProcessLst.substring(0, ProcessLst.length()-3);
        ProcessLst = ProcessLst + ']';
        
        ProcessLstOrdr = ProcessLstOrdr.substring(0, ProcessLstOrdr.length()-3);
        ProcessLstOrdr = ProcessLstOrdr + ']';
    }
    
}