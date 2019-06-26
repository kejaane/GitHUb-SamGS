/*=================================================================================================================
 * Date         : 04/11/2016
 * Developer    : Satya Tirumalasetti
 * Purpose      : The purpose of this class is to display list of proposed products of particular BRF so that user 
 *                can select some products and get displayed on the screen after hitting save.
 *                                 Update History
 *                                 ---------------
 * Date         Developer    Tag   Description
 *============+============+=====+================================================================================
 * 04/18/2017 | Satya      |     | Initial Version  
 * 02/12/2018 | Debaknti   | T01 | Added logic to distinguish between classic and lightning
 * 02/12/2018 | Satya      | T02 | Removed T01 and added T02 to distinguish between classic and lightning using 
 *                                 custom metadata. 
 *=================================================================================================================
 */

public class AIA_IDCardExtController {
    public ID_Card__c idCardRec{set;get;}
    public boolean showTable {set;get;}
    public boolean isClassic {get;set;} //T02 change
    public string Id{get; set;}
    public string brfId{get; set;}
    public List<Proposed_Products__c> proposedProductList{get; set;}
    public List<ppWrapperClass> ppWrapperList{get; set;}  
    
    //controller
      
    public AIA_IDCardExtController(ApexPages.StandardController controller) {
        showTable = false;
        isClassic = AIA_Utils.isClassic(); //T02 change
        id = ((ID_Card__c)controller.getRecord()).id;
        if(id != null && id != ''){
        //get the current record
         idCardRec= [select Name,BRF_Id__c,Date_of_submission_form__c,Member_level_products_comments__c,Implementation__r.BRFId__c,
                            Will_a_Non_CareFirst_Vendor_Logo_be_Need__c,Member_level_Products__c,Effective_Date__c,status__c,
                            Will_ID_Card_Require_a_Logo__c,Implementation__c,Approved_by_Legal__c,Member_level_products_comments1__c
                     from ID_Card__c  
                     where id  =: id];
         if(String.isNotBlank(idCardRec.Implementation__r.BRFId__c)){
             brfId = idCardRec.Implementation__r.BRFId__c;
         }
        }else {
         idCardRec = new ID_Card__c ();
        }
        
        //iterate through the list of proposed products and assign to the wrapper class
        ppWrapperList = new List<ppWrapperClass>();
        if(String.isNotBlank(brfId)){
            proposedProductList = [select id, Name, Plan_Name__r.Full_Plan_Name__c, Product_Category__c, Custom_New__c 
                                    from Proposed_Products__c 
                                    where Benefit_Request_Form__c = : brfId ];
            for(Proposed_Products__c pp : proposedProductList ){
                ppWrapperClass ppwrp = new ppWrapperClass();
                ppwrp.isSelected = false;
                ppwrp.Name = pp.Name;
                ppwrp.PlanName = pp.Plan_Name__r.Full_Plan_Name__c;
                ppwrp.ProductCategory  = pp.Product_Category__c ;
                ppwrp.Custom  = pp.Custom_New__c ;
                
                ppWrapperList.add(ppwrp);
            }            
        }    
        showProducts();
    }
    /* T01 Start 
    //Check whether the page is in Classic or lightning
    //US-677
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    } 
    /* T01 End */
    
    //method to decide whether to show wrapper table or not
    public void showProducts(){
        if(idCardRec.Member_level_Products__c == 'Yes')
            showTable  = true;
        else
            showTable  = false;
    }
    
    //wrapper class to hold checkbox and products
    public class ppWrapperClass{
        public boolean isSelected {set;get;}
        public String Name {set;get;}
        public String PlanName{set;get;}
        public String ProductCategory {set;get;}
        public String Custom  {set;get;}
        
    }    
    
    //method to save the selected products and display them on the comment section
    public PageReference saveData(){
        String selectedProdcts = '';
        Integer count=0;
        
        for(ppWrapperClass pwrp : ppWrapperList){
           if(pwrp.isSelected == true){
               //selectedProdcts = selectedProdcts+pwrp.Name + '-' + pwrp.PlanName +'\n';
               selectedProdcts = selectedProdcts+ pwrp.PlanName +'\n';
               count += 1;
           }
        }
        selectedProdcts =  selectedProdcts + '\n' ;
        selectedProdcts = returnStaticText(selectedProdcts);
        idCardRec.Member_level_products_comments__c = selectedProdcts;
        idCardRec.products_selected_count__c = count;
        try{
        upsert idCardRec;
        
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        pagereference pr = new pagereference('/' + idCardRec.id);
        return pr;
        }
        
        
    // method to reset the comment field    
    public PageReference resetToNo(){
        String selectedProdcts = ''; 
        selectedProdcts = returnStaticText(selectedProdcts);
        idCardRec.Member_level_products_comments__c = selectedProdcts;
        idCardRec.Member_level_Products__c = 'No';
        idCardRec.products_selected_count__c = 0;
        upsert idCardRec;
        pagereference pr = new pagereference('/' + idCardRec.id);
        return pr;
    }
    
    public String returnStaticText(String selectedProdcts){
        selectedProdcts =  selectedProdcts + 'Member level or Contract level ID cards \n';
        selectedProdcts  = selectedProdcts + 'All ID cards with PCPs are Member level \n';
        selectedProdcts  = selectedProdcts + 'If Cafeteria benefits, non-PCP products cannot be done at Member level \n';
        selectedProdcts  = selectedProdcts + 'if Cafeteria benefits with PCP products, then non PCP products will be at Contract level \n';
        return selectedProdcts;
    }
}