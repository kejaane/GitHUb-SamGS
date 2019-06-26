/*=================================================================================================
* Date         : 08/16/2017
* Developer    : Debkanti
* Purpose      : This class function is to create Custom Record type selection page, redirect 
                    to the record creation page based on the selected record type
                    and redirect to the edit page based on record type
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date           Developer         Tag     Description
*==================================================================================================
* 08/16/2017  | Debkanti        |     | Initial Version 
* 09/26/2017  | Rajesh Pennam   | T01 | Updated the controller to handler Admin VF Page. Currenlty it is 
*                                       redirected to Std Page but now after chagnes it will redirect to
*                                       VF Page 
* 12/11/2017  | Rajesh Pennam   | T02 | Updated the pref and added variable Bdmode                                  
* 02/01/2018  | Rajesh Nagandla | T03 | Added SLDS to all components in page
* 02/13/2018  | Gayathri P      | T04 | Updated the Page reference URL for Domestic Partner form
*                                       with respect to the source
*===========+============+=====+===================================================================
*/
/**
* @Author: Debkanti 
* @Record creation page based on the selected record type
and redirect to the edit page based on the record type
* @param -  None
* @Output - Redirect to new record creation page and edit page based on the record type
*           
*/


public class AIA_Ben_Form_RedirectExtensionController{
    private List<SelectOption> items;
    public string Selected{get; set;}
    public string sObjectType {get;set;}
    public string bdFormid{get;set;}
    public string retURL='';
    public string bdid='';
    public string bdbacken='';
    public string bdpid='';
    public string bdpbacken='';
    public string bdpval='';
    public string src='';
    /*T03 - Start*/
    public static final string Managedcare = 'Managed Care Programs';
    public static final string mcpmanaged = 'MCP - Full Managed Care';
    public static final string mcpnonstnd = 'MCP - Non Standard';
    public static final string domesticpartner = 'Domestic Partner - Self Insured Only';
    public static final string ADMIN = 'Admin';
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    /*T03 - End*/ 
    public AIA_Ben_Form_RedirectExtensionController(ApexPages.StandardController controller) {
        //Initializing object type
        sObjectType = 'AIA_Benefit_Design_Form__c';
        
        retURL = apexpages.currentpage().getparameters().get('retURL');
       system.debug('Required'+apexpages.currentpage());

       system.debug('Required'+retURL);
       
        bdid = apexpages.currentpage().getparameters().get('CF00N60000002jAke');
        bdbacken = apexpages.currentpage().getparameters().get('CF00N60000002jAke_lkid');
        bdpid = apexpages.currentpage().getparameters().get('CF00N60000002jAm4');
        bdpbacken = apexpages.currentpage().getparameters().get('CF00N60000002jAm4_lkid');
        
        bdpval= apexpages.currentPage().getparameters().get('bdpid');
        src= apexpages.currentPage().getparameters().get('src');
    }
    
    public List<SelectOption> getItems() {
        //Defining the list for selection record type
        List<SelectOption> items = new List<SelectOption>();
        //default value
        // items.add(new SelectOption('','--Select Record Type --'));
        
        //query force.com database to get the record type of the requested object.
        /*T03 - Start: Modified below code as per review comments*/
        //for(RecordType rt: [select id,name from recordtype where sobjecttype=:sObjectType and name != 'Managed Care Programs']) {
        for(RecordType rt: [select id,name from recordtype where sobjecttype=:sObjectType]) {
            if(rt.name != Managedcare){
                items.add(new SelectOption(rt.id,rt.name));
            }
        }
        /*T03 - End*/
        System.debug('Enter here1: '+items);
        return items;
    }
    //Page redirection based on record type
    public pagereference selectedvalue(){
        //Querying the record type name and id based on the selected name on page
        RecordType rt = [select id,name from RecordType where id =:Selected];
        //Initilizing record type id
        String csRtId = rt.id;
        
        //fatching Url from custom setting
        //String Url=AIA_RetUrl__c.getValues('AIA_Record_Type_Link').Url_Text__c;
        //Based on the record type redirection 
        If(rt.name == Managedcare){
            pagereference pref ;
            if(bdid=='null'||bdbacken=='null'||bdid==null||bdbacken==null){
                 pref = new pagereference('/a1U/e?retURL='+retURL+'&RecordType='+csRtId+'&ent=AIA_Benefit_Design_Form__c');
            }
            else
                 pref = new pagereference('/a1U/e?retURL='+retURL+'&RecordType='+csRtId+'&ent=AIA_Benefit_Design_Form__c&CF00N60000002jAke='+bdid+'&CF00N60000002jAke_lkid='+bdbacken);
            pref.getParameters().put('nooverride','1');
            pref.setredirect(true);
            return pref;
        }
        else if( rt.name == mcpmanaged || rt.name == mcpnonstnd){
          // pagereference pref = new pagereference('/apex/AIA_MCP_BDP_SelectionPage?RecordType='+csRtId+'&CF00N60000002jAke='+bdid+'&CF00N60000002jAke_lkid='+bdbacken+'&retURL='+retURL);
            //pagereference pref = new pagereference('/apex/AIA_MCP_BDP_SelectionPage?bdid='+bdbacken+'&mcpid=null&mcpmode=new&RecordType='+csRtId);
            // pagereference pref = new pagereference('/apex/AIA_MCP_BDP_SelectionPage?RecordType='+csRtId+'&bdid='+bdbacken+'&retURL='+retURL);
           pagereference pref;
            system.debug(apexpages.currentpage().getparameters());
           if(bdbacken==null){
                system.debug('bdpbackeninif'+bdpbacken);
                AIA_Benefit_Design_Product__c bdp=[select Benefit_Design__c from AIA_Benefit_Design_Product__c where id =: bdpbacken limit 1];
                pref = new pagereference('/apex/AIA_MCP_BDP_SelectionPage?bdid='+String.valueOf(bdp.Benefit_Design__c)+'&mcpid=null&mcpmode=new&src=bdp&bdpid='+bdpbacken+'&RecordType='+csRtId);
            }else{
                pref = new pagereference('/apex/AIA_MCP_BDP_SelectionPage?bdid='+bdbacken+'&mcpid=null&mcpmode=new&src=bd&bdpid=null&RecordType='+csRtId);
            }
          pref.setredirect(true);
           system.debug('***page ref'+pref);
          return pref;
           
        }
        else if(rt.name == domesticpartner){
            pagereference pref;
            //T04  Start
            String bdpRecId=bdpbacken; 
            if(bdbacken==null){
                if(bdpbacken==null && bdpVal!=null)
                {
                  bdpRecId=bdpVal;  
                }
                AIA_Benefit_Design_Product__c bdp=[select Benefit_Design__c,Benefit_Design__r.Name from AIA_Benefit_Design_Product__c where id =: bdpRecId limit 1];
                pref = new pagereference('/apex/AIA_Domestic_Partner_DL?RecordType='+csRtId+'&CF00N60000002jAke='+String.valueOf(bdp.Benefit_Design__r.Name)+'&CF00N60000002jAke_lkid='+String.valueOf(bdp.Benefit_Design__c)+'&src=bdp&bdid='+String.valueOf(bdp.Benefit_Design__c)+'&bdpid='+bdpRecId+'&retURL='+bdpRecId);
            }
            else{ pref = new pagereference('/apex/AIA_Domestic_Partner_DL?RecordType='+csRtId+'&CF00N60000002jAke='+bdid+'&CF00N60000002jAke_lkid='+bdbacken+'&src=bd&bdid='+bdid+'&bdpid=null&retURL='+bdbacken);
            }
            //T04  End
            pref.setredirect(true);
            return pref;
        } // Rajesh Changes Starts Here T01
        else if(rt.name =='ADMIN'){
            pagereference pref ;
           if(bdid != null ){
               pref = new pagereference('/apex/AIA_BDF_Admin_Form?RecordType='+csRtId+'&CF00N60000002jAke='+bdid+'&CF00N60000002jAke_lkid='+bdbacken+'&Bdmode=new&retURL='+bdbacken); //T02 added variable Bdmode
               

           }
           else if(bdpbacken != null){
             AIA_Benefit_Design_Product__c bdp=[select Benefit_Design__c,Benefit_Design__r.Name from AIA_Benefit_Design_Product__c where id =: bdpbacken limit 1];

               pref = new pagereference('/apex/AIA_BDF_Admin_Form?RecordType='+csRtId+'&CF00N60000002jAke='+string.valueof(bdp.Benefit_Design__r.Name)+'&CF00N60000002jAke_lkid='+string.valueof(bdp.Benefit_Design__c)+'&CF00N60000002jAm4='+bdpid+'&CF00N60000002jAm4_lkid='+bdpbacken+'&Bdmode=new&retURL='+bdpbacken); //T02 added variable Bdmode
          

           
           }
           pref.setredirect(true);
               return pref;
        } // Rajesh Changes Ends Here T01
        else 
            return null;
    }
    //Page redirection based on record type while click on the edit button 
    public pageReference RedirectToSumaryPage(){
        //Initilizing and Storing the id of record type from page 
        bdFormid = ApexPages.currentPage().getParameters().get('id');
        //retURL = apexpages.currentpage().getparameters().get('retURL');
        SYSTEM.debug('ID IS: '+bdFormid);
        //Creating the list of the benefit design form
        List<AIA_Benefit_Design_Form__c> record = new List<AIA_Benefit_Design_Form__c>();
        String rcdID;
        String rcdTypeName;
        //Querying record type and record type id from benefit design form object based on the record id
        record = [SELECT Record_Type__c,RecordTypeId  FROM AIA_Benefit_Design_Form__c WHERE id =:bdFormid];
        system.debug('record type: '+record);
        //Iterating on and storing on the string 
        for(AIA_Benefit_Design_Form__c str :record){
            rcdTypeName = str.Record_Type__c;
            rcdID = str.RecordTypeId;
        }
        system.debug('rcdTypeName: '+rcdTypeName);
        system.debug('rcdID: '+rcdID);
        //Fatring all the field values based on the record id
        String QueryStr=QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefit_Design_Form__c','Id=:bdFormid Limit 1');
        //fatching Url from custom setting
       // String Url=AIA_RetUrl__c.getValues('AIA_Record_Type_Link').Url_Text__c;
        //Based on the record type redirection 
        If(rcdTypeName == Managedcare){
            pagereference pref = new pagereference('/a1U/e?retURL='+retURL+'&ent=AIA_Benefit_Design_Form__c');
            system.debug('Id===' + ApexPages.currentPage().getParameters().get('id')); 
            pref.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
            pref.getParameters().put('nooverride','1');
            pref.setredirect(true);
            return pref;
        }
        else if( rcdTypeName == mcpmanaged || rcdTypeName == mcpnonstnd){
            pagereference pref = new pagereference('/apex/AIA_MCP_DL_ManagedCare?RecordType='+rcdID+'&retURL='+bdFormid);
            system.debug('Id===' + ApexPages.currentPage().getParameters().get('id')); 
            pref.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
            pref.setredirect(true);
            return pref;
        }
        else if(rcdTypeName == domesticpartner){
            pagereference pref = new pagereference('/apex/AIA_Domestic_Partner_DL?RecordType='+rcdID+'&retURL='+bdFormid);
            system.debug('Id===' + ApexPages.currentPage().getParameters().get('id')); 
            pref.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
            pref.setredirect(true);
            return pref;
        }//Rajesh Changes Starts Here T01
        else if(rcdTypeName =='ADMIN'){
            pagereference pref = new pagereference('/apex/AIA_BDF_Admin_Form?RecordType='+rcdID+'&retURL='+bdFormid);
            system.debug('Id===' + ApexPages.currentPage().getParameters().get('id')); 
            pref.getParameters().put('id',ApexPages.currentPage().getParameters().get('id'));
            pref.setredirect(true);
            return pref;
        } // Rajesh Changes Ends Here T01
        else 
            return null;
        
    }
     public PageReference cancel(){
       
        PageReference pr;
        if(bdbacken==null){
                pr = new PageReference('/'+bdpbacken );
        }
        //T04--start
        else if(src=='bdp' && bdpval != null && bdpval != ''){
                pr = new PageReference('/'+bdpval );
        }
        //T04--End
        else{
                 pr = new PageReference('/'+bdbacken ); 
        }
        pr.setRedirect(true);
        return pr;
    }
}
/////the visualforce code should be changed to fix that
/*<apex:inputField value="{!bdf.Benefit_Design__c}" /> 
should be 
<apex:inputField value="{!AIA_Benefit_Design_Form__c.Benefit_Design__c}" /> 
same for other fields 
in vf page it is referring to bdf right
so it is resetting the data */