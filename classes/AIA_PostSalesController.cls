/******************************************************************************** 
 *  Class            : AIA_PostSalesController
 *  Author           : Sandip Dhara
 *  Version History  : 1.0
 *  Creation         : 06/07/16
 *  Description      : This class will have the logic for the post sales control.
 *
 ********************************************************************************
 *                                 Update History
 *                                ----------------
 * Date       Developer      Tag       Description
 *===========+============+================================================================
 * 04/16/2018|  Gayathri  |	T-01  | Commented WP task related functionalities as per US 209
 *===========+============+================================================================
 ********************************************************************************/

public class AIA_PostSalesController {
    private AIA_Implementation__c implementation;
    private Id implementationId;
    
    
    public List<AIA_Process> aiaProcessList {get;set;}
    public String debug{get;set;}

    public AIA_PostSalesController(ApexPages.StandardController controller) {
        implementation = (AIA_Implementation__c)controller.getRecord();
        implementationId = controller.getId();
        aiaProcessList = new List<AIA_Process>();
        
        System.Debug('Implementation Id: ' + implementationid);
        //debug = String.ValueOf(implementationId);
    }
    
    public void getWorkplanData() {
        // TODO: Add Error Handling
        /*T01 -- Start
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm()+'/';        
        AIA_Process aiaProcObj;
        for( Workplan_Stage__c wp : [Select Id, Name, Workplan_Stage_Category__c,Workplan_Stage__c, Tasks_Completed__c, (SELECT Id, Name, Tasks_Completed__c, Workplan_Stage__c FROM Workplan_Stage__r ORDER BY Display_Order__c ASC) 
                                    FROM Workplan_Stage__c WHERE Implementation__c = :implementationId AND RecordType.Name = 'Process'
                                    ORDER BY Order__c] ) {
            aiaProcObj = new AIA_Process();
            List<AIA_SubProcess> aiaSubprocessList = new List<AIA_SubProcess>();
            for( Workplan_Stage__c wsObj : wp.Workplan_Stage__r ) {
                AIA_SubProcess obj = new AIA_SubProcess();
                obj.subProcessName = wsObj.Workplan_Stage__c;
                obj.subProcessStatus = wsObj.Tasks_Completed__c;
                obj.subProcessURL = sfdcBaseURL+wsObj.id;
                aiaSubprocessList.add(obj);
            }
            
            aiaProcObj.processName = wp.Workplan_Stage_Category__c;
            aiaProcObj.processCompletePercentage = wp.Tasks_Completed__c;
            aiaProcObj.subProcess = aiaSubprocessList;
            aiaProcessList.add(aiaProcObj);
        }
        T01 -- End*/
        System.Debug('Debug: ' + debug);
    }    
    
    public class AIA_Process {
        public String processName {get;set;}
        public Decimal processCompletePercentage {get;set;}
        public String processStatus {get;set;}
        public List<AIA_SubProcess> subProcess {get;set;}
    }
     
    public class AIA_SubProcess {
        public String subProcessName {get;set;}
        public String subProcessURL {get;set;}
        public Decimal subProcessStatus {get;set;}
    }
}