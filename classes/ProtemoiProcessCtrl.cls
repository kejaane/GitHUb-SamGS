/*=========================================================================================
 * Date      : 07/24/2016
 * Developer : Rajesh Pennam
 * Purpose   : This class is the extention controller for the VisualForce Page Protemoi Process
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer         Description
 *===========+============+================================================================
 * 07/24/2016  |  RajeshPennam     | Initial Version                                         
 *             |          | 
 *=============+==========+================================================================
 */

public class ProtemoiProcessCtrl{
    public Protemoi__c Iniobj;
    public string ProcessLst{get;set;}
    public string ProcessLstOrdr{get;set;}
    //Cotroller Extention Constructor
    public ProtemoiProcessCtrl(ApexPages.StandardController stdController){
        this.Iniobj = (Protemoi__c)stdController.getRecord();
        system.debug('i am in constructor');
        ProcessLst =  '[\''; // This have names of the Picklist
        ProcessLstOrdr = '[\''; // This have the order for Picklist
        prepareProcessLst();
    }
    public void prepareProcessLst(){
        Schema.DescribeFieldResult PP = Protemoi__c.Path_To_Raving_Fan__c.getDescribe();
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