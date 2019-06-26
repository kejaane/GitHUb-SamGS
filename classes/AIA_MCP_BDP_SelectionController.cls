/*===================================================================================================================
* Date       : 07/11/2017
* Developer  : Rajesh Nagandla
* Purpose    : This is controller class for AIA_MCP_BDP_SelectionPage
*                                 Update History
*                                 ---------------
* Date       |     Developer        | Tag |   Description
*============+============+=========================================================================================
* 04/11/2017 | Rajesh Nagandla      |     | Initial Version
* 11/17/2017 | Raviteja             | T01 | Initial Version
* 02/05/2018 | Gayathri Palanisamy  | T02 | Added a method to differentiate classic and lightning
*============+============+=========================================================================================
*/
public class AIA_MCP_BDP_SelectionController {
    AIA_Benefit_Design_Form__c rec;
    Public AIA_Benefit_Design__c bd{get;set;}
    public List<bdpwrapper> bdpWrappers{get;set;}
    public string selectedbp{get;set;}
    public set<String> bdpnames= new set<String>();
    public list<AIA_Benefit_Design_Product__c> lstbdp {get;set;}
    public AIA_Benefit_Design_Product__c bdprec{get;set;}
    public Boolean panaltysecren{get;set;}
    public Boolean isselected{get;set;}
    //public Boolean repeatrender{get;set;}
    public Id rectypeid ;
    public string bdid;
    public string mcpid;
    public string mcpmode;
    public string src;
    public string bdpid;
    public Boolean displaymsg{get;set;}
    
    public AIA_MCP_BDP_SelectionController(ApexPages.StandardController controller) {
        displaymsg = false;
        selectedbp = null;
        bdpWrappers = new List<bdpwrapper>();
        lstbdp = new list<AIA_Benefit_Design_Product__c>();
        rectypeid = apexpages.currentpage().getparameters().get('RecordType');
        bdid = apexpages.currentpage().getparameters().get('bdid');
        mcpid = apexpages.currentpage().getparameters().get('mcpid');
        mcpmode = apexpages.currentpage().getparameters().get('mcpmode');
        bdpid = apexpages.currentpage().getparameters().get('bdpid');
        src = apexpages.currentpage().getparameters().get('src');
        system.debug('****rec id'+rectypeid);
        rec = (AIA_Benefit_Design_Form__c)controller.getRecord();
        rec.RecordTypeId = rectypeid;
        system.debug('****rec bdid'+bdid);
        if(bdid!='null'){
            rec.Benefit_Design__c = bdid; 
        }
        bdprec = new AIA_Benefit_Design_Product__c();
        panaltysecren = false;
    }
    //T02--Start--Method to check whether the page is in Classic or lightning
    public Boolean getIsClassic() {
    	return AIA_Utils.isClassic();
    }
    //T02--End
    public void getproducts(){
        Integer bdpRecordNumber = 0;
        bdpWrappers = new List<bdpwrapper>();
        string bdname = Apexpages.currentPage().getParameters().get('node');
        system.debug('**'+bdname);
        lstbdp = [select id, name, SelectBDP__c, AIA_Magellan_Behavioral_Health__c, AIA_INN_Contracted_Provider_Penalty__c,
            Fully_Insured__c, AIA_Percent_and_Dollar_Penalty__c, AIA_Dollar_Penalty__c, 
            Percentage_and_Dollar_Penalty_Other_Nons__c, AIA_Percent_Penalty__c, AIA_Up_to__c,
            Percentage_Penalty_Other_Nonstandard__c,Plan_Product_Name__c, Benefit_Design_Form__c from AIA_Benefit_Design_Product__c where Benefit_Design__c= :bdname 
            AND Product_Category__c ='Medical'] ; 
        system.debug('**'+lstbdp);
        /*if(lstbdp.size()==0){
            system.debug('**'+lstbdp);
             ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'There are no Medical products to associate with the MCP form.You must select atleast one medical plan in order to complete the mcp form.');
            ApexPages.addMessage(msg);
          }*/
        for (AIA_Benefit_Design_Product__c bdps : lstbdp){
            bdpRecordNumber++;
            bdpwrapper wap = new bdpwrapper(bdps,bdps.SelectBDP__c);
            system.debug('---out-->'+bdps.SelectBDP__c);
            if(!bdps.SelectBDP__c){
                system.debug('---1st if-->'+bdps.SelectBDP__c);
                bdpWrappers.add(wap);
            }
            if(bdps.SelectBDP__c && mcpid != 'null'){
                system.debug('---2nd if-->'+bdps.SelectBDP__c+' -mcpid- '+mcpid);
                if(mcpid == bdps.Benefit_Design_Form__c){
                    bdpWrappers.add(wap);
                }
            }
        }
        if(bdpWrappers.isEmpty()){
            displaymsg = true;
        }
    }
    public class bdpwrapper {
        public Boolean isSelected {get;set;}
        public AIA_Benefit_Design_Product__c bdprorec{get;set;}
        
        /*public string bdp {get;set;}
        public string bdpid {get;set;}
        public String bdpRecID {get; set;}
        public list<AIA_Benefit_Design_Product__c> bdprolst{get;set;}*/
        public bdpwrapper(AIA_Benefit_Design_Product__c bdpro,Boolean selected) {
           // bdprolst = new list<AIA_Benefit_Design_Product__c>();
            this.isSelected = selected;
            this.bdprorec = bdpro;
            /*this.bdp = bdpName;
            this.bdpid = bdpid;
            this.bdpRecID = 'bdpRec'+String.valueOf(bdpRecNum);
            bdprolst.add(bdpro);*/
        }
    }
    //T01 - Start
    //Added cancel method to go back
    public PageReference cancel(){
        String src = apexpages.currentpage().getparameters().get('src');
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
            pr = new PageReference('/apex/AIA_MCP_SavePage?id='+mcpid+'&RecordType='+rec.RecordTypeId);
        }
        pr.setRedirect(true);
        return pr;
    }
    //T01 - Start

    public PageReference Next(){
        list<AIA_Benefit_Design_Product__c> bdprolst = new list<AIA_Benefit_Design_Product__c>();
        system.debug('-----isselected----->'+bdpWrappers);
        if(!bdpWrappers.isEmpty()){
            system.debug('-----in fst if----->');
            for(bdpwrapper bdpw:bdpWrappers){
                if(bdpw.isselected){
                    system.debug('-----in is selected if----->');
                    bdpw.bdprorec.SelectBDP__c = bdpw.isselected;
                    if(rectypeid == '01260000000YMUbAAO'){
                        bdpw.bdprorec.MCP_Product_Type__c = 'Full Managed Care';
                    }
                    else{
                        bdpw.bdprorec.MCP_Product_Type__c = 'Non-Standard';
                    }
                    bdprolst.add(bdpw.bdprorec);
                }
            }
        }
        system.debug('-----in----->'+bdprolst);
        if(bdprolst.isEmpty()){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'You must select atleast one Medical Plan in order to complete the MCP Form.');
            ApexPages.addMessage(msg);
            return null;
        }
        try{
            if(!bdprolst.isEmpty()){
                system.debug('-----in update----->'+bdprolst);
                update bdprolst;
            }
            PageReference pr;
            if(mcpmode == 'edit'){
                pr = new PageReference('/apex/AIA_MCP_DL_ManagedCare?id='+mcpid+'&bdid='+bdid+'&RecordType='+rec.RecordTypeId+'&mcpmode='+mcpmode+'&src='+src+'&bdpid='+bdpid+'&selectedbdpid='+selectedbp);
            }
            else{
                pr = new PageReference('/apex/AIA_MCP_DL_ManagedCare?bdid='+bdid+'&RecordType='+rec.RecordTypeId+'&mcpmode='+mcpmode+'&src='+src+'&bdpid='+bdpid+'&selectedbdpid='+selectedbp);
            }
            pr.setRedirect(true);
            return pr;
        }
        catch(exception ex){system.debug('--------->'+ex);
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0));
            ApexPages.addMessage(msg);
            return null;
        } 
        
    }
    //Method to update respective BDP with default values on BDP Unseletion
    public void updateBdp(){
        system.debug('-----isselected----->'+isselected);
        system.debug('-----selectedbp ----->'+selectedbp);
        
        if(isselected){
            bdprec = [select id,AIA_INN_Contracted_Provider_Penalty__c,AIA_Magellan_Behavioral_Health__c,Fully_Insured__c,AIA_Percent_and_Dollar_Penalty__c,AIA_Dollar_Penalty__c, Percentage_and_Dollar_Penalty_Other_Nons__c, AIA_Percent_Penalty__c, AIA_Up_to__c, Percentage_Penalty_Other_Nonstandard__c from AIA_Benefit_Design_Product__c where id =: selectedbp ];
            bdprec.SelectBDP__c = false;
            bdprec.AIA_INN_Contracted_Provider_Penalty__c = '';
            bdprec.AIA_Magellan_Behavioral_Health__c = '';
            bdprec.Fully_Insured__c = '';
            bdprec.AIA_Percent_and_Dollar_Penalty__c = '';
            bdprec.AIA_Dollar_Penalty__c = null;
            bdprec.Percentage_and_Dollar_Penalty_Other_Nons__c = '';
            bdprec.AIA_Percent_Penalty__c = '';
            bdprec.AIA_Up_to__c = null;
            bdprec.Percentage_Penalty_Other_Nonstandard__c = '';
            bdprec.Benefit_Design_Form__c = null;
            try{
                update bdprec;
            }
            catch(exception ex){
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0));
                ApexPages.addMessage(msg);
            }
        }
    }
}