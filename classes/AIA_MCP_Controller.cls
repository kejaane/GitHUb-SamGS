/*===================================================================================================================
* Date       : 17/08/2017
* Developer  : Sajitha Yalamanchili
* Purpose    : Controler for MCP creation page. 
               Auto populate Outpatient Authorization Program section based on Funding Arrangement selection.
               Auto populate DM/Wellness section details from Proposed product on one of the selected Benefit Design product.
               Save, SaveandNew and Cancel Buttons functionality.
               
*                                 Update History
*                                 ---------------
* Date       |     Developer                        | Tag |   Description
*============+============+=========================================================================================
* 08/17/2017 | Sajitha Yalamanchili,Rajesh Nagandla |     | Updated code as per US250
* 02/02/2018 | Gayathri Palanisamy					| T02 | Added a method to differentiate classic and lightning view
* 04/11/2018 | Raviteja								| T03 | To revert all bdp values to none on clicking cancel on mcp form
*============+============+=========================================================================================
*/
public class AIA_MCP_Controller {
    public AIA_Benefit_Design_Product__c bdp{get;set;}
    public AIA_Benefit_Design_Form__c rec{get;set;}
    public list<AIA_Benefit_Design_Product__c> lstbdp {get;set;}
    public String  fundArg{ get; set; }
    public String  jurisdiction{ get; set; }
    public String  pname{ get; set; }
    /*public String  dmwellness{ get; set; }
    public String  standalonemgnt{ get; set; }
    public String  standalonewellness{ get; set; }
    public String  customwellness{ get; set; }*/
    public Id id ;
    public Id bdid;
    String retURL='';
    public String mcpmode;
    public string src;
    public string bdpid;
    public string selectedbdpid;
    boolean dW;
    boolean cW;
    public AIA_MCP_Controller(ApexPages.StandardController controller) {
        lstbdp = new list<AIA_Benefit_Design_Product__c>();
        bdp = new AIA_Benefit_Design_Product__c();
        rec = new AIA_Benefit_Design_Form__c();
        fundArg='';
        jurisdiction='';
        id = apexpages.currentpage().getparameters().get('RecordType');
        bdid = apexpages.currentpage().getparameters().get('bdid');
        mcpmode = apexpages.currentpage().getparameters().get('mcpmode');
        bdpid = apexpages.currentpage().getparameters().get('bdpid');
        src = apexpages.currentpage().getparameters().get('src');
        retURL = apexpages.currentpage().getparameters().get('retURL');
        rec = (AIA_Benefit_Design_Form__c)controller.getRecord();
        rec.RecordTypeId = id;
        fundArg = rec.Funding_Arrangement__c;
        if(mcpmode == 'new'){
            rec.Benefit_Design__c= bdid;
        }
        getselectedBDPs(bdid);
        getDMWellnessfields(bdid);
    }
    
    //T02--Start--Method to check whether the page is in Classic or lightning
    public Boolean getIsClassic() {
    	return AIA_Utils.isClassic();
    }
    //T02--End
    
    //Gets BDP's Selected from selection page.
    public void getselectedBDPs(id bdid){
        lstbdp = [select id,name,SelectBDP__c,Plan_Product_Name__c,Jurisdiction__c,Benefit_Design_Form__c from AIA_Benefit_Design_Product__c where Benefit_Design__c= :bdid AND SelectBDP__c = true] ;
        for(AIA_Benefit_Design_Product__c bdp:lstbdp){
            if(bdp.Plan_Product_Name__c.contains('Smart Selections')){
                rec.Attended_Sleep_Studies__c='Yes';
                break;
            }
        }
    }
   
    // gets values from Benefit Design. 
    public void getFundar(){
        fundArg = Apexpages.currentPage().getParameters().get('node');
        system.debug('**fundi'+fundArg);
        if(fundArg == 'Risk')
        {
            rec.Home_Health_Care__c='Yes';
            rec.Clinical_Trials__c='Yes';
            rec.Hospice_Care__c='Yes';
            rec.Habilitative_Services_for_Children__c='Yes';
            rec.Artificial_Insemination_IVF__c='Yes';
            rec.IVF__c='Yes';
            rec.General_Anesthesia_for_Dental_care__c='Yes';
            rec.Patient_Centered_Medical_Home__c='Yes';
            rec.TCCI_Cost_Share_Waiver__c='Yes';
        }
        else if( fundArg=='ASO'){
            rec.Home_Health_Care__c='';
            rec.Clinical_Trials__c='';
            rec.Hospice_Care__c='';
            rec.Habilitative_Services_for_Children__c='';
            rec.Artificial_Insemination_IVF__c='';
            rec.IVF__c='';
            rec.General_Anesthesia_for_Dental_care__c='';
            rec.Patient_Centered_Medical_Home__c='Yes';
            rec.TCCI_Cost_Share_Waiver__c='Yes';
        }
        system.debug('-----rec----->'+rec.Home_Health_Care__c+'-'+rec.Clinical_Trials__c);
    }
    //Auto populate DM/Wellness section details from Proposed product on one of the selected Benefit Design product.
    public void getDMWellnessfields(id bdid){
        Proposed_Products__c pps = new Proposed_Products__c();
        selectedbdpid = apexpages.currentpage().getparameters().get('selectedbdpid');
        
        try{
            if(selectedbdpid != null){
                bdp = [Select id, Proposed_Products__c, Jurisdiction__c From AIA_Benefit_Design_Product__c
                        where id =: selectedbdpid ];
                pps = [Select id, Custom_Core_DM_Wellness__c, Stand_Alone_Disease_Management__c, Stand_Alone_Wellness__c,
                        Custom_Wellness__c from Proposed_Products__c where id =:bdp.Proposed_Products__c limit 1];
            }
            else{
                bdp = [Select id, Proposed_Products__c, Jurisdiction__c From AIA_Benefit_Design_Product__c
                        where Benefit_Design__c=:bdid AND SelectBDP__c = true Limit 1];
                pps = [Select id, Custom_Core_DM_Wellness__c, Stand_Alone_Disease_Management__c, Stand_Alone_Wellness__c,
                        Custom_Wellness__c from Proposed_Products__c where id =:bdp.Proposed_Products__c limit 1];
            }
           
            //, Integrated_DM_Wellness__c,Stand_Alone_Disease_Management__c,Stand_Alone_Wellness__c, Custom_Wellness__c
            if(pps.Custom_Core_DM_Wellness__c){
                rec.Integrated_DM_Wellness__c='Yes';
            }
            else{
                rec.Integrated_DM_Wellness__c='No';
            }
            if(pps.Custom_Wellness__c){
                rec.Customized_Wellness_Services__c='Yes';
            }
            else{
                rec.Customized_Wellness_Services__c='No';
            }
            rec.Stand_Alone_Disease_Management__c =  pps.Stand_Alone_Disease_Management__c;
            rec.Stand_Alone_Wellness__c = pps.Stand_Alone_Wellness__c;
             if(bdp.Jurisdiction__c =='VA'){
                rec.Early_Intervention_Services__c ='Yes';
            }
            if(bdp.Jurisdiction__c =='VA' || bdp.Jurisdiction__c =='MD'){
                rec.Early_Intervention_Services__c ='Yes';
            }
        
        }
        catch(Exception e){
            pname ='';  
        } 
    }
    // save functionality and redirection to Detail page.
    public PageReference save(){
        try{
            if(src == 'bdp' && mcpmode == 'new'){
                system.debug('----insideif--->');
                rec.Benefit_Design_Product__c = bdpid;
            }
            upsert rec;
            updateselectedBDPs(rec.id);
            //con.save();
            PageReference pr = new PageReference('/apex/AIA_MCP_SavePage?id='+rec.id+'&RecordType='+rec.RecordTypeId );
            pr.setRedirect(true);
            return pr;
        }
        catch(exception ex){
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0));
            ApexPages.addMessage(msg);
            return null;
        }
    }
    
    // Redirect to save & New button
    public PageReference mcpsavenew(){
        try{
            if(src == 'bdp' && mcpmode == 'new'){
                system.debug('----insideif--->');
                rec.Benefit_Design_Product__c = bdpid;
            }
            upsert rec;
            updateselectedBDPs(rec.id);
            AIA_Benefit_Design__c bdrec = [select id,name from AIA_Benefit_Design__c where id=:rec.Benefit_Design__c];
            PageReference pr = new PageReference('/apex/AIA_Ben_Form_Redirect_RecordType?CF00N60000002jAke='+bdrec.name+'&CF00N60000002jAke_lkid='+rec.Benefit_Design__c+'&mcpmode=new&src='+src+'&bdpid='+bdpid);
            pr.setRedirect(true);
            return pr;
        }
        catch(exception ex){
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0));
            ApexPages.addMessage(msg);
            return null;
        }
    }
    //Updating BDP with related MCP id
    public void updateselectedBDPs(id bdid){
        list<AIA_Benefit_Design_Product__c> bdplstupdate = new list<AIA_Benefit_Design_Product__c>();
        try{
            for(AIA_Benefit_Design_Product__c bdp:lstbdp){
                if(bdp.Benefit_Design_Form__c == null){
                    bdp.Benefit_Design_Form__c = bdid;
                    bdplstupdate.add(bdp);
                }
            }
            if(!bdplstupdate.isEmpty()){
                update bdplstupdate;
            }
        }
        catch(exception ex){
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0));
            ApexPages.addMessage(msg);
        }
    }
    // Redirect to Cancel button
    public PageReference cancelcustom(){
        //T03	-	Start
        AIA_BenefitDesignFormTriggerHelper.updateBdpStatusfromCancel(bdid);
        //T03	-	End
        string recid;
        PageReference pr;
        if(mcpmode == 'new'){
            if(src == 'bdp'){
                pr = new PageReference('/'+bdpid);
            }
            else if(src == 'bd'){
                pr = new PageReference('/'+bdid);
            }
        }
        else{
            recid = apexpages.currentpage().getparameters().get('id');
            pr = new PageReference('/apex/AIA_MCP_SavePage?id='+rec.id+'&RecordType='+rec.RecordTypeId);
        }
        pr.setRedirect(true);
        return pr;
    }
}