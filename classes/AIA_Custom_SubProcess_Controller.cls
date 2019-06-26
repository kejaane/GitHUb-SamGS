/*
 *                                 Update History
 *                                 ---------------
 * Date        Developer    Tag         Description
 *==========================================================================================
* 04/16/2018| Arshia   |  | This class is used to Create Custom Subprocess on Implementation record.
 *==========================================================================================
*/
public without sharing class AIA_Custom_SubProcess_Controller {
    public String slProcess{get; set;}
    public String slSubProcess{get; set;}
    public String reSubProcess{get; set;}
    public List<Process__c> ProcessTemp = new List<Process__c>();
    public List<Sub_Process__c> SubProcessTemp = new List<Sub_Process__c>();
    public List<SelectOption> lstProcess;
    public List<SelectOption> lstSubProcess;
    public boolean isClassic{get; set;}
    public AIA_Implementation__c objImpl {get;set;}     
    public string NewSubprocess {get;set;}     
    public boolean returnValue{get;set;} 
   
    //T02-Start
    public Boolean IsAuthorized{get;set;}  
	public static final String mgrRecordType = 'Manager';
    public static final String adminRole= 'AIA Admin';
    public static final String IPMRole = 'Implementation Manager';
    public Boolean systemAdmin,isAIAAdminRoleUser; 
    //T02-End
    
    public AIA_Custom_SubProcess_Controller(ApexPages.StandardController controller){
      objImpl = (AIA_Implementation__c) controller.getRecord();
      isClassic = AIA_Utils.isClassic(); 
      //get the implementation record in context
      objImpl = [select id,Account__c,Benefit_Request_Form__c,Opportunity__c,Benefit_Request_Form__r.Account_Executive_Account_Team__c,Benefit_Request_Form__r.Account_Manager_Account_Team__c,
                    Benefit_Request_Form__r.Implementation_Manager_Account_Team__c, Benefit_Request_Form__r.Opportunity_Type__c,Docusign_Document_sending_user__c
                 from AIA_Implementation__c 
                 where id =:objImpl.Id ];

                
        // T03 - Start
        CheckAuthorization();
        System.Debug('IsAuthorized :'+IsAuthorized);
        if (IsAuthorized)
        	ProcessList();       
        // T03 - End
    }
     public Void CheckAuthorization(){
        Id CurrentUser = UserInfo.getUserId(); 
        Id ManagerRTId = Schema.SObjectType.AIA_Area_Manager__c.getRecordTypeInfosByName().get(mgrRecordType).getRecordTypeId(); 
        IsAuthorized = false;
        Boolean IsImpManager = false;
        AIA_Area_Manager__c  areaMang_rec = new AIA_Area_Manager__c();
        List<AIA_Area_Manager__c>  areaMang_recLSt = [SELECT id,Areas__c,Area_Belong_to__c
                                                      from AIA_Area_Manager__c 
                                                      where Area_Manager__c =:CurrentUser and RecordTypeid=:managerRTId and AIA_isActive__c = TRUE limit 1
                                                       ];  
        if( areaMang_recLSt.size() > 0)
        {
            areaMang_rec = areaMang_recLSt[0];
        }
        if(AIA_Utils.checkIf_AIA_Admin_Profile_User() || AIA_Utils.checkIf_AIA_Admin_User()){
            systemAdmin = True;
        }
        else 
        {
            if(areaMang_rec != null){     
               if (!(areaMang_rec.Area_Belong_to__c == '' || areaMang_rec.Area_Belong_to__c == null))
        			{
            			if ((areaMang_rec.Area_Belong_to__c).contains(IPMRole))
                        {
                            IsImpManager = true;
                        }
                        if((areaMang_rec.Area_Belong_to__c).contains(adminRole)){
            			    isAIAAdminRoleUser = true;
          		  		 }
       				}
            }
        }
        
        if(systemAdmin == TRUE || isAIAAdminRoleUser == TRUE || (areaMang_rec != null && IsImpManager)){
            IsAuthorized = true;
        }        
    }
    public void  changeSelection()
    {
        System.Debug('AG slProcess'+reSubProcess);
        
        lstSubProcess = new List<SelectOption>();            
            for(Sub_Process__c temp : SubProcessTemp)
            {        
                if(temp.Process__c == slProcess){
                     System.Debug('AG temp : ' + temp);
                    System.Debug('AG temp.Process__c '+slProcess + ' ' + temp.Process__c + ' ' + temp.Stage__c);
                    if(temp.Id != null && temp.Stage__c != null)
                    lstSubProcess.add(new SelectOption(temp.Id,temp.Stage__c));
                }
            } 
        if(lstSubProcess.size() > 0)
        reSubProcess = (lstSubProcess.get(0)).getValue();
        System.Debug('AG slSubProcess ' + reSubProcess);
   }
    
    public void ProcessList()
    {
            ProcessTemp = [select Process_Name__c 
                           from Process__c 
                           where Used_For__c = 'Post-Sales' and Implementation__c =:objImpl.Id ];
             lstProcess = new List<SelectOption>();
            for(Process__c temp : ProcessTemp)
            {
                lstProcess.add(new SelectOption(temp.Id,temp.Process_Name__c));
            }  
        if(lstProcess.size() > 0)
            slProcess = (lstProcess.get(0)).getValue();
            SubProcessTemp = [select Id,Process__c,Sequence_Number__c,Stage__c 
                              from Sub_Process__c 
                              where Used_For__c = 'Post-Sales' and Implementation__c =:objImpl.Id order by Sequence_Number__c]; 
        	System.Debug('AG SubProcessTemp : ' + SubProcessTemp);    
        changeSelection();
    }
   

    public List<SelectOption> getProcessList() {
        return lstProcess;
    } 
    public List<SelectOption> getItems() {
        return lstSubProcess;
    } 
    public void  changeSubProcess()
    {
        integer seqno;
        System.Debug('AG slSubProcess'+slSubProcess);
        for(Sub_Process__c temp : SubProcessTemp)
            {
                if(temp.Id == slSubProcess){
                    seqno = Integer.valueOf(temp.Sequence_Number__c) + 1;                    
                }
            }
        System.Debug('AG seqno'+seqno);
        
   }
    
    public PageReference SaveSubProcess(){
        returnValue = false;
        if (NewSubprocess=='') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter New Subprocess Name.'));
            return ApexPages.currentPage();
        }
        System.Debug('NewSubprocess'+NewSubprocess);
       List<Sub_Process__c> updSubProcess = new List<Sub_Process__c>();
        lstSubProcess.clear();
        integer seq=1;
            for(Sub_Process__c temp : SubProcessTemp)
            {
                if(temp.Id == slSubProcess){
                    seq = Integer.valueOf(temp.Sequence_Number__c) + 1;                    
                }
            }
        System.Debug('AG seq'+seq);
            for(Sub_Process__c temp : SubProcessTemp)
            {
                 if(Integer.valueOf(temp.Sequence_Number__c) >= seq){
                    temp.Sequence_Number__c = Integer.valueOf(temp.Sequence_Number__c) + 1;
                }
                updSubProcess.add(temp);
                if(temp.Id != null && temp.Stage__c != null)
                lstSubProcess.add(new SelectOption(temp.Id,temp.Stage__c));
            } 
        
        Sub_Process__c recSubProcess = new Sub_Process__c();
        recSubProcess.Active__c = true; 
        recSubProcess.Implementation__c = objImpl.Id;
        recSubProcess.Opportunity__c = objImpl.Opportunity__c;
        recSubProcess.Process__c = slProcess;
        recSubProcess.Sequence_Number__c = seq;
        recSubProcess.Stage__c = NewSubprocess;     
        recSubProcess.Used_For__c = 'Post-Sales'; 
        recSubProcess.Status__c = AIA_CONSTANTS.STATUS_NOTSTARTED;
        System.Debug('recSubProcess'+recSubProcess);
        try{
        insert recSubProcess;
        
        lstSubProcess.add(new SelectOption(recSubProcess.Id,recSubProcess.Stage__c));
        update updSubProcess;        
        returnValue = true;
        return new PageReference('/'+objImpl.id);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage())); 
            return ApexPages.currentPage();     
        }
    }
     public PageReference CancelSubProcess() {
        return new PageReference('/'+objImpl.id);
    }   
    
}