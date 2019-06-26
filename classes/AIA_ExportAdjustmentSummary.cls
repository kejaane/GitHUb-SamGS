public class AIA_ExportAdjustmentSummary {
    AIA_Benefit_Design__c rec=new AIA_Benefit_Design__c();
    public Boolean displaypopup{get;set;}
    public string msg {get;set;}
    public final AIA_Drawloop_Package_ID__c ddppackage;
    public PageReference pageref;
    public String ddpid ='';
    public AIA_ExportAdjustmentSummary (ApexPages.StandardController controller) {
		rec = (AIA_Benefit_Design__c)controller.getRecord();
        ddppackage = AIA_Drawloop_Package_ID__c.getValues(AIA_Constants.BD_ADJUSTMENT_DDPNAME);
    }
    
    public Pagereference isApproved(){
        if(rec.Status__c!=AIA_Constants.BD_STATUS_APPROVED){
         	displayPopUp=true;
            msg=AIA_Constants.BDDDPmsg;
            return null;
        }
        else{
        	ddpid = ddppackage.DDP_ID__c;
            pageref = new PageReference('/apex/loop__looplus?sessionId='+UserInfo.getSessionId()+'&eid='+rec.id+'&ddpIds='+ddpid);
         	pageref.setRedirect(true);
         	return pageref; 
        }
    }
    
    //Page redirection to gsrf.
    public pagereference backtoBD(){
        PageReference pref = new PageReference('/'+rec.Id);
        pref.setRedirect(true);
        return pref;
    }

}