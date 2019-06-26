/*=========================================================================================
 * Purpose      : This is the controller class for the VF AIA_MCP_SavePage.
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date        Developer          Tag        Description
 *============+=================+=====+===========================================================
 * 01/17/2018 | Gayathri        | T01 | Added a method to differentiate classic and lightning
 * 02/28/2018 | Debkanti        | T02 | Added Logic to display different button for "MCP - Non Standard" and "MCP - Full Managed Care"
 *=========================================================================================
 */

public class AIA_MCP_SavepageController {
    public id bdid;
    public id mcpid;
    public AIA_Benefit_Design_Form__c rec{get; set;}
    public list<AIA_Benefit_Design_Product__c> lstbdp{get;set;}
    public boolean exportddp{get; set;}
    public boolean exportMcpFull{get; set;} //T02
    public final string MCPFullManaged = 'MCP - Full Managed Care';
    public final string MCPNonStandard = 'MCP - Non Standard';
    public AIA_MCP_SavepageController(ApexPages.StandardController controller) {
        //System checks weather logedin user has AIA_Admin permissionset
        Map<ID,Schema.RecordTypeInfo> bdfrtmap = AIA_Benefit_Design_Form__c.sObjectType.getDescribe().getRecordTypeInfosById();
        List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =: Userinfo.getUserId() ];
        Boolean userhasadminpermission = false;
        for ( PermissionSetAssignment psa : lstcurrentUserPerSet ){
            System.debug('##psa.PermissionSet.Name' + psa.PermissionSet.Name);
            if ( psa.PermissionSet.Name.equals('AIA_Admin') ) {
                userhasadminpermission = true;
            }
        }
        //Gets loggedin user profile name.
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        rec = new AIA_Benefit_Design_Form__c();
        lstbdp = new list<AIA_Benefit_Design_Product__c>();
        mcpid = apexpages.currentpage().getparameters().get('id');
        rec = (AIA_Benefit_Design_Form__c)controller.getRecord();
        if(bdfrtmap.get(rec.recordtypeid).getName() == 'MCP - Full Managed Care' ){
            exportMcpFull = true;//T02
        }
        if(bdfrtmap.get(rec.recordtypeid).getName() == 'MCP - Full Managed Care' && (userhasadminpermission == true || profileName == 'System Administrator')){
            exportddp = true;
        }
        else if(bdfrtmap.get(rec.recordtypeid).getName() == 'MCP - Non Standard'  && (userhasadminpermission == true || profileName == 'System Administrator')){
            exportddp = false;
        }
        getselectedBDPs(rec.Benefit_Design__c);
    }
    //T01--Start--Method to check whether the page is in Classic or lightning
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    //T01--End
    public void getselectedBDPs(id bdid){
        lstbdp = [select id, name,Plan_Product_Name__c, SelectBDP__c, AIA_Magellan_Behavioral_Health__c, AIA_INN_Contracted_Provider_Penalty__c,
            Fully_Insured__c, AIA_Percent_and_Dollar_Penalty__c, AIA_Dollar_Penalty__c, 
            Percentage_and_Dollar_Penalty_Other_Nons__c, AIA_Percent_Penalty__c, AIA_Up_to__c,
            Percentage_Penalty_Other_Nonstandard__c from AIA_Benefit_Design_Product__c where Benefit_Design__c=:bdid
            AND SelectBDP__c = true and Benefit_Design_Form__c =: mcpid] ;
    }
    public PageReference export(){
        string ddpIds='';
        Map<ID,Schema.RecordTypeInfo> bdfrtmap = AIA_Benefit_Design_Form__c.sObjectType.getDescribe().getRecordTypeInfosById();
        //T01--Start updated the ddpIds based on the record type
        if(bdfrtmap.get(rec.recordtypeid).getName() == 'MCP - Full Managed Care')
        {
            //ddpIds='a19V0000001QvpU';
             AIA_Drawloop_Package_ID__c ddppackage = AIA_Drawloop_Package_ID__c.getValues(MCPFullManaged);
             ddpIds=ddppackage.DDP_ID__c;
             
        }
        else if(bdfrtmap.get(rec.recordtypeid).getName() == 'MCP - Non Standard')
        {
            //ddpIds='a190R0000001IveQAE';
            AIA_Drawloop_Package_ID__c ddppackage = AIA_Drawloop_Package_ID__c.getValues(MCPNonStandard);
            ddpIds=ddppackage.DDP_ID__c;
        }
        //T01--End 
      PageReference   pageref = new PageReference('/apex/loop__looplus?sessionId={!$Api.Session_ID}&eid='+rec.id+'&hidecontact=true&ddpIds='+ddpIds);
            pageref.setRedirect(true);
            return pageRef;
    }
    public PageReference mcpedit(){
      string mcpmode = 'edit';
      PageReference pageref = new PageReference('/apex/AIA_MCP_BDP_SelectionPage?bdid='+rec.Benefit_Design__c+'&RecordType='+rec.recordtypeid+'&mcpmode='+mcpmode+'&mcpid='+rec.id);
            pageref.setRedirect(true);
            return pageRef;
    }
     
     
}