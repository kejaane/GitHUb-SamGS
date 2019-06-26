/*=================================================================================================
* Date         : 08/16/2017
* Developer    : Debkanti
* Purpose      : This class function is to create Custom VF page for Domestic partner and implement 
*                the validations accordingly which are not possible in standard page
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer        Tag     Description
*===========+=================+=====+===================================================================
* 08/16/2017| Raviteja        |     | Initial Version                                         
* 10/03/2017| Asif K          |     | Removed save method since it was not being used.
* 02/02/2018| Rajesh Nagandla | T01 | Modified cancel button redirection for lightning
* 02/08/2018| Gayathri P      | T02 | Added a method to differentiate classic and lightning view
*===========+============+=====+===================================================================
*/
public class AIA_Domestic_Partner_Controller {
    ApexPages.StandardController con; 
    AIA_Benefit_Design_Form__c rec;
    Id id;
    String retURL='';
    String src='';
    String bdpid='';
    String bdid='';
    public String grouperNums{ get; set; }
    public String legalEntity{ get; set; }
    public AIA_Domestic_Partner_Controller(ApexPages.StandardController controller) {
        id = apexpages.currentpage().getparameters().get('RecordType');
        rec = (AIA_Benefit_Design_Form__c)controller.getRecord();
        retURL = apexpages.currentpage().getparameters().get('retURL');
        src = apexpages.currentpage().getparameters().get('src');
        bdpid = apexpages.currentpage().getparameters().get('bdpid');
        bdid = apexpages.currentpage().getparameters().get('bdid');
        rec.RecordTypeId = id;
        con =  controller;
    }
    //T02--Start--Method to check whether the page is in Classic or lightning
    public Boolean getIsClassic() {
    	return AIA_Utils.isClassic();
    }
    //T02--End
    
    //save and new method to save and open new record page
    public PageReference savenew(){
        con.save();
        //T02 Modified the Page Reference URL
        AIA_Benefit_Design__c bdrec = [select id,name from AIA_Benefit_Design__c where id=:rec.Benefit_Design__c];
        PageReference pr = new PageReference('/apex/AIA_Ben_Form_Redirect_RecordType?CF00N60000002jAke='+bdrec.name+'&CF00N60000002jAke_lkid='+rec.Benefit_Design__c+'&src='+src+'&bdid'+bdid+'&bdpid='+bdpid);
        pr.setRedirect(true);
        return pr;
    }
    //cancel method override
    public PageReference cancel(){
        PageReference pr;
        /*T01 - Start*/
        pr = new PageReference(retURL);
        /*T01 - End*/
        pr.setRedirect(true);
        
        return pr;
    }
    //get the grouper values to autopouplate from Admin
    public void getGroupers() {
        try{
            string bdname = Apexpages.currentPage().getParameters().get('node');
            system.debug('bdname:'+bdname);
            Id RecordTypeId = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
            List<AIA_Benefit_Design__c> bdid=[select id from AIA_Benefit_Design__c where name=:bdname limit 1];
            system.debug('bdid:'+bdid);
            
            if(bdid.size()>0){
                AIA_Benefit_Design_Form__c  bdf = new AIA_Benefit_Design_Form__c();
                
                bdf=[SELECT Id, Group_Numbers__c,Legal_Entity__c
                     FROM AIA_Benefit_Design_Form__c 
                     WHERE Benefit_Design__c = :bdid[0].id AND 
                           recordtypeid=:RecordTypeId limit 1];
                grouperNums=bdf.Group_Numbers__c;
                legalEntity=bdf.Legal_Entity__c;
                
                system.debug('grouperNums:'+grouperNums);
            }
            
        }
        catch(Exception e){
            grouperNums='';
        }
        
    }
    
}