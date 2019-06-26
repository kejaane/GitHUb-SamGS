/*====================================================================================================================
* Date         : 10/28/2016
* Developer    : Harsha
* Purpose      : Controller class for visualforce page AIA_BenefitDesignEditPage
*=====================================================================================================================
*                                 Update History
* -----------------------------------------------------------------------------------------------------------------
* Date       | Developer      | Tag |     Description
*============+============+===========================================================================================
* 10/28/2016 | Harsha         |     | Initial Version                                         
* 11/21/2016 | Asif Kutagulla | T01 | added exception handling in save and saveandnew methods
* 02/27/2017 | Asif Kutagulla | T02 | Modify query to include field Parent_Account__c & auto-populate the value 
*                                     from related Implementation
* 02/27/2017 | Ramakrishna    | T03 | Adding validation (user story #B-03548) while creating a new DB under limitation. 
* 04/12/2017 | Asif Kutagulla | T04 | B-03894. Populating Identity_Protection__c from associated BRF
* 01/31/2018 | Satya T        | T05 | Method to check whether the user is in Classic or lightning
* 03/14/2018 | Debkanti 	  | T06 | Added 'implementationName','accountName','benefitRequestFormName','parentAccountName'
									  to prepolulate the field values while creating bd from implementation.
* 11/08/2018 | Raviteja V     | T07 | Changed from Standardcontroller to standardsetcontroller to enable this page for list button 
									  with content src as VF page (change done for page reload error BD error)
* 11/08/2018 | Raviteja V     | T08 | commented setredirect so that vf page open and loads in same subtab
*============+============+===========================================================================================
*/
public with sharing class AIA_BenefitDesignEditPageController {    
    public AIA_Benefit_Design__c benefitDesign {set; get;}
    public String owner{set; get;}
    public String implId;
    public List<AIA_Benefit_Design__c> BDList;  //T03
    public boolean showError {get;set;}   //T03
    public boolean isClassic {get;set;}
    Public string implementationName{get;set;}//T06
    Public string accountName{get;set;} //T06
    Public string benefitRequestFormName{get;set;} //T06
    Public string parentAccountName{get;set;} //T06
    public ApexPages.StandardsetController ctrlr;
    public AIA_BenefitDesignEditPageController(ApexPages.StandardsetController controller) { //T07
        ctrlr = controller;
        showError = false;
        isClassic = AIA_Utils.isClassic(); //T05 cahnge
        owner = userinfo.getName();
        benefitDesign = new AIA_Benefit_Design__c();    
        implId = ApexPages.currentPage().getParameters().get('id');
        //Start T03
        BDList = new List<AIA_Benefit_Design__c>([select Id,name from AIA_Benefit_Design__c where Implementation__c =:implId]); 
        if(BDList!=null && BDList.size()>0){
            showError = true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Only 1 Benefit Design record can be created per implementation');
            ApexPages.addMessage(myMsg);            
        }
        //End T03
        benefitDesign.Implementation__c = implId;
        if(!String.isBlank(implId)){
           AIA_Implementation__c implrec = [select Id, Account__c, Parent_Account__c,
                                                   Name, Benefit_Request_Form__c,Account__r.name,Benefit_Request_Form__r.name,Parent_Account__r.name,
                                                   Benefit_Request_Form__r.Identity_Protection__c //T04
                                            from AIA_Implementation__c 
                                            where id = :implId LIMIT 1];
           benefitDesign.Implementation__c = implrec.id;
           benefitDesign.Account__c = implrec.Account__c;
           benefitDesign.Benefit_Request_Form__c = implrec.Benefit_Request_Form__c;
           benefitDesign.Parent_Account__c = implrec.Parent_Account__c;//T02  
           benefitDesign.Identity_Protection__c = implrec.Benefit_Request_Form__r.Identity_Protection__c;//T04
            /*-- T06 -- Start --*/
           implementationName = implrec.name;
           accountName = implrec.Account__r.name;
           benefitRequestFormName = implrec.Benefit_Request_Form__r.name;
           parentAccountName = implrec.Parent_Account__r.name;
            /*-- T06 -- End --*/
        }    
        
    }
    
    
    public PageReference save(){
        try {
            upsert benefitDesign;
            PageReference  pgRef = new pageReference('/'+benefitDesign.id);
            //pgRef.setRedirect(true);//T08
            return pgRef;
        }
        //T01 Start
        catch(DMLException dmlex) { ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,dmlex.getDmlMessage(0));
            ApexPages.addMessage(myMsg);return null; } return null; //T01 End
    }
   /* public PageReference saveandNew(){     //Start T03
        try {            
            upsert benefitDesign;
            PageReference  pgRef = new pageReference('/apex/AIA_BenefitDesignEditPage?Impid='+implId);
            pgRef.setRedirect(true);
            return pgRef;            
        }
        //T01 Start
        catch(DMLException dmlex) { ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,dmlex.getDmlMessage(0));
            ApexPages.addMessage(myMsg); return null; } return null;//T01 End        
    } */
    
     
    public PageReference cancel(){        
            PageReference  pgRef = new pageReference('/'+implId);
           // pgRef.setRedirect(true);//T08
            return pgRef;
    }  //End T03 
}