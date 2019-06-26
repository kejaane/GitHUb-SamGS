/*=========================================================================================
 * Date         : 08/19/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This is the controller class for the visualforce page -  Opp_Contact_Role_RelatedList_Page
                  This will support the custom creation page for Opportunity Contact roles(custom records).
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer     Tag       Description
 *===========+============+================================================================
    01/17/2018|Raviteja     | T01   |   Added SLDS changes
 *  01/25/2018|Gayathru     | T02   |   To display the popup while saving record in Lightning
 * 7/6/2018  | Arshia Gulati  | T03 | Get OppId from parameter
  * 9/12/2018 | Naga Kandukoori| T04 | Changed the error msg
 *=========================================================================================
 */
 
 
 public class Opp_Contact_Role_RelatedList_Class{
    
    // Instance of wrapper class - Output list to show as non-editable rows
    public list<wrapperOCR> wrapOutputListOCR{get; set;}
    // Instance of wrapper class - Input list to show as editable rows
    public list<wrapperOCR> wrapInputListOCR{get; set;}
    
    public list<wrapperOCR> wraplistOCR{get; set;}
    
    public string oppName{get; set;} 
    public string oppStage{get; set;} 
    public string errorMsg{get; set;}
    list<Opportunity> opp = new list<Opportunity>();
    list<Id> acctId = new list<Id>();
    set<Id> cIds= new set<Id>();
    list<Contact> listContact = new list<Contact>();
    list<Opportunity_Contact_Role__c> listOCR = new list<Opportunity_Contact_Role__c>();
    list<Opportunity_Contact_Role__c> listOCRfromAccount = new list<Opportunity_Contact_Role__c>();
    list<Opportunity_Contact_Role__c> upsertlistOCR = new list<Opportunity_Contact_Role__c>();
    PageReference pageRef;
    Id oppId;
     
    public String strProfileName;
    public Boolean isBCCProfile{get; set;}
    //T02--Start
    public String msg{get; set;}
    public Boolean displayPopUp{get; set;}
    //T02--End
    public integer noPrimary{get; set;} 
    public integer currentPrimary{get; set;} 
    public integer selectedCR{get; set;} 
    
    public String bccProfileName = 'BCC RUL Custom'; 
    public Set<String> adminProfiles = new Set<String>{'System Administrator'};
    public Set<String> nonBCCProfiles = new Set<String>{'2+ Standard User - Custom','51+ Standard User - Custom'};
    
    // Flags to use in data input validations(get the count of Opportuntiy Contact Role records based on Roles)
    boolean errorMsgReturn = false;
    Date oppEndDate, oppEffDate, currentEffDatePB, currentEffDateConsultant;
    integer ind,countAdmin= 0, countPrimaryBroker= 0,countBroker = 0, countConsultant  = 0, countFirmExecutive = 0, countFSP= 0, countGP = 0, countGroupAdmin = 0, countSurveyor = 0;
    integer entrycountAdmin, entrycountPrimaryBroker, entrycountBroker, entrycountConsultant, entrycountFirmExecutive, entrycountFSP, entrycountGP, entrycountGroupAdmin, entrycountSurveyor;
    
    //Constructor
    public Opp_Contact_Role_RelatedList_Class(ApexPages.StandardController controller){
        try{
            
            
            
            noPrimary =  currentPrimary = 100;
            selectedCR = null;
            isBCCProfile = false;
            
            // To get the Opportunity ID
            Opportunity_Contact_Role__c ocr = (Opportunity_Contact_Role__c)controller.getRecord();
            oppId = ocr.Opportunity__c;
            
             //Start-T03
            if(oppId == null)
              oppId=ApexPages.currentPage().getParameters().get('oppid');
            //End-T03            
            
            
            strProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
            system.debug('strProfileName>>>> '+strProfileName);
            
            if(oppId != null){
            
                // To query the Opportunity's name and AccountID
                opp = [SELECT Name,AccountId,Effective_Date__c,Contract_End_Date__c,StageName
                       FROM Opportunity 
                       WHERE id =: oppId];
                
                //To fetch the Account ID          
                for(Opportunity o : opp){
                    acctId.add(o.AccountId);
                    
                    // Get the Opportunity name,effective and end dates
                    oppName = o.Name;
                    oppEffDate = o.Effective_Date__c;
                    oppEndDate = o.Contract_End_Date__c;
                    oppStage = o.StageName;
                }
                system.debug('oppStage >>>> '+oppStage );
                // To query existing contacts from the Opportunity's Account           
                listContact = [SELECT Id,Name 
                               FROM Contact 
                               WHERE AccountId IN: acctId];
               
                // To query all the Opportunity Contact roles from the custom object for the current Opportunity
                listOCR = [SELECT id,Contact_Name__c,Contact_Name__r.Name,Opportunity__c,Primary__c,Role__c,Effective_Date__c,End_Date__c
                          FROM Opportunity_Contact_Role__c 
                          WHERE Opportunity__c =: oppId ORDER BY Role__c,Effective_Date__c asc];
            }
            
            // To auto populate the existing contacts from the Opportunity's Account as new rows
            for(Opportunity_Contact_Role__c ocr1 : listOCR){
                 cIds.add(ocr1.Contact_Name__c);
            }
            for(Contact c : listContact){
                // Check if the Contact is not present in the current contact roles list
                if(!cIds.contains(c.Id)){
                     Opportunity_Contact_Role__c newCR = new Opportunity_Contact_Role__c(Contact_Name__c= c.Id);
                     listOCRfromAccount.add(newCR);
                 }
            }
            
            //if(oppStage == 'Proposal'){
            if(oppStage == 'Proposal' || oppStage == 'RFP' || oppStage == 'Benefit Request' || oppStage == 'Underwriting' || oppStage == 'Quote Delivered' || oppStage == 'ARC Approval' || oppStage == 'Prospecting'){
                            
                // To populate the instances of the wrapper class
                if(wraplistOCR== null){                       
                    wraplistOCR= new List<wrapperOCR>();
                }
                
                for(Opportunity_Contact_Role__c ocr2 : listOCRfromAccount){
                     ocr2.Effective_Date__c = oppEffDate;
                     ocr2.End_Date__c = oppEndDate ;
                    listOCR.add(ocr2);
                }
                // To populate instances of Contact roles(3 empty rows)
                for(integer i=0;i<3;i++){               
                    Opportunity_Contact_Role__c newCR = new Opportunity_Contact_Role__c();
                    newCR.Effective_Date__c = oppEffDate;
                    newCR.End_Date__c = oppEndDate ;
                    listOCR.add(newCR);
                }
                ind=1;   
                for(Opportunity_Contact_Role__c a : listOCR){
                    if(a.Primary__c == true){
                        currentPrimary = ind;
                    }
                    wraplistOCR.add(new wrapperOCR(a,ind,''));
                    ind++;
                }
            }
            else if(oppStage == 'Sold'){
                
                if(wrapOutputListOCR== null){                       
                    wrapOutputListOCR= new List<wrapperOCR>();
                }
                // iterate the current contact roles and calculate the count against each role and get the current effective date
                ind =1;
                for(Opportunity_Contact_Role__c ocr1 : listOCR){
                    if(ocr1.Role__c == 'Primary Broker'){
                        countPrimaryBroker++;
                        if(ocr1.Primary__c == true){
                            currentEffDatePB = ocr1.Effective_Date__c;
                            currentPrimary = ind;
                        }
                    }
                    if(ocr1.Role__c == 'Consultant'){
                        countConsultant ++;
                        if(ocr1.Primary__c == true){
                            currentEffDateConsultant = ocr1.Effective_Date__c;
                        }
                    }
                    if(ocr1.Role__c == 'Administrator'){
                        countAdmin++;
                    }
                    if(ocr1.Role__c == 'Broker'){
                        countBroker++;
                    }
                    if(ocr1.Role__c == 'Firm Executive'){
                        countFirmExecutive++;
                    }
                    if(ocr1.Role__c == 'Full Service Producer'){
                        countFSP++;
                    }
                    if(ocr1.Role__c == 'General Producer'){
                        countGP++;
                    }
                    if(ocr1.Role__c == 'Group Administrator'){
                        countGroupAdmin++;
                    }
                    if(ocr1.Role__c == 'Surveyor'){
                        countSurveyor++;
                    }
                    
                    // Populate the wrapper class list to display as non-editable rows
                    wrapOutputListOCR.add(new wrapperOCR(ocr1,ind,''));
                }
                
                for(Opportunity_Contact_Role__c ocr2 : listOCRfromAccount){
                     ocr2.Effective_Date__c = oppEffDate;
                     ocr2.End_Date__c = oppEndDate ; 
                }
                          
                // To populate instances of Contact roles(5 empty rows)
                for(integer i=0;i<5;i++){               
                    Opportunity_Contact_Role__c newCR = new Opportunity_Contact_Role__c();
                    newCR.Effective_Date__c = oppEffDate;
                    newCR.End_Date__c = oppEndDate ;
                    listOCRfromAccount.add(newCR);
                }
                
                //Populate the wrapper class list to display as editable rows
                if(wrapInputListOCR == null){                       
                    wrapInputListOCR = new List<wrapperOCR>();
                }
                for(Opportunity_Contact_Role__c a : listOCRfromAccount){
                    wrapInputListOCR.add(new wrapperOCR(a,1,''));
                }
            }
        }
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
            ApexPages.addMessage(Msg);
        }
    }
    
     //T01  -   start
     public Boolean getIsClassic() {
        return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }
      //T01  -   end
      //T02--Start
     public PageReference returnToOpp()
    {
        return new PageReference('/' + oppId);
    }  
    //T02--End
    //Save Button - To create/update the Custom Opportunity Contact Roles
    public pagereference saveContactRole(){
        
            //if(oppStage == 'Proposal'){
            if(oppStage == 'Proposal' || oppStage == 'RFP' || oppStage == 'Benefit Request' || oppStage == 'Underwriting' || oppStage == 'Quote Delivered' || oppStage == 'ARC Approval' || oppStage == 'Prospecting'){
                pagereference p = saveCRonProposal();
                return p;
            }
            else if(oppStage == 'Sold'){
                pagereference p = saveCRonSold();
                return p;
            }
            else{
                return null;
            }
    }
     
    // Cancel button - To go back to the Opportunity page
    public pagereference cancelContactRole(){
        pageRef = new PageReference('/'+oppId);
        return pageRef;
    }
    
    //Save Button for Proposal opportunities
    private pageReference saveCRonProposal(){
        
        errorMsgReturn = false;
        
        for(wrapperOCR crP : wrapListOCR){
            crP.errorMsg = '';
            crP.oppEndDateErrorrenderv =false;
            crP.oppEffDateErrorrenderv =false;
            crP.oppRoleErrorMsg =false;
            
            if(crP.OCRInst.Contact_Name__c != null && crP.OCRInst.Role__c != null){
                
                //Effective Date and End Date must be always filled         
                if(crP.index == selectedCR && (crP.OCRInst.Role__c != 'Primary Broker')){
                    crP.errorMsg = 'Error:Primary can only be selected for Broker Agent of Record role'; // T04 9/12/18
                    crP.oppRoleErrorMsg = true;
                    errorMsgReturn = true;
                    
                }
                // for profile  users only primary Role allowed to save when opp is sold       
                else if(strProfileName == bccProfileName  ){
                    crP.errorMsg = 'Error:This profile user not allowed to save Contact role when Opportunity is not sold';
                    errorMsgReturn = true;
                    crP.oppRoleErrorMsg = true;
                }
            }
        }
        if(errorMsgReturn == true){
            return null;      
        }
        else{
            for(wrapperOCR cr : wraplistOCR){
                            
                if(cr.OCRInst.Contact_Name__c != null && cr.OCRInst.Role__c != null){
                    if(cr.OCRInst.Opportunity__c == null){
                        cr.OCRInst.Opportunity__c = oppId;
                    }
                    if(selectedCR != 0){
                         // To retrieve the selected primary contact role and update the Primary checkbox
                         if(cr.index == selectedCR) {    
                             cr.OCRInst.Primary__c = true;
                         }
                         else{
                             cr.OCRInst.Primary__c = false;
                         }
                     }
                     // Add the modified/new Contact roles into a list
                     upsertlistOCR.add(cr.OCRInst);                     
                }
            }
        }
        
        // Upserting the new/modified contact roles [Replicate the same in the standard Contact Roles thru trigger-OpportunityContactRoleTrigger]
        try{
        if(upsertlistOCR.size() > 0){  
            upsert upsertlistOCR;
            //T02--Start
            if(!getIsClassic())
            {
                msg = 'Record Saved';
                displayPopUp = true;
                return null;
            }
            //T02--End
        }   
        pageRef = new PageReference('/'+oppId);
        return pageRef;
        }
                catch(Exception exp)
                {
                     String S1 = exp.getMessage();
                     if(S1.containsIgnoreCase('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                     S1 = S1.substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION, ' , ': [');    
                     }
                     ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,S1); 
                     ApexPages.addMessage(Msg);
                     return null;  
                }
    }
    
    //Save Button for Sold opportunities
    private pageReference saveCRonSold(){
        try{
            errorMsgReturn = false;
            entrycountPrimaryBroker= 0;entrycountConsultant  = 0;entrycountAdmin= 0;entrycountBroker  = 0;
            entrycountFirmExecutive= 0;entrycountFSP  = 0;entrycountGP= 0;entrycountGroupAdmin  = 0;entrycountSurveyor  = 0;
                     
            //oppEndDateErrorrenderv = false;
            for(wrapperOCR cr : wrapInputListOCR){
                cr.errorMsg = '';
                cr.oppEndDateErrorrenderv =false;
                cr.oppEffDateErrorrenderv =false;
                cr.oppRoleErrorMsg =false;
                if(cr.OCRInst.Contact_Name__c != null && cr.OCRInst.Role__c != null){
                    system.debug('nonBCCProfiles>>:'+nonBCCProfiles);   
                    system.debug('strProfileName>>:'+strProfileName);   
                    system.debug('nonBCCProfiles.contains(strProfileName)>>:'+nonBCCProfiles.contains(strProfileName)); 
                    //Effective Date and End Date must be always filled         
                    if(cr.OCRInst.Effective_Date__c == null || cr.OCRInst.End_Date__c == null){
                        cr.errorMsg = 'Error:Effective Date and End Date must be filled';
                        cr.oppEffDateErrorrenderv =true;
                        errorMsgReturn = true;
                    }
                    //Effective Date should be same as Opportunity Effective Date (Primary Broker - first record only)
                    else if(((countPrimaryBroker== 0 && cr.OCRInst.Role__c == 'Primary Broker') || 
                             (cr.OCRInst.Role__c != 'Primary Broker')) && cr.OCRInst.Effective_Date__c != oppEffDate){
                                cr.errorMsg = 'Error:Effective Date should be same as Opportunity Effective Date if Broker Agent of Record is added for First Time';  //T04
                                cr.oppEffDateErrorrenderv =true;
                                errorMsgReturn = true;
                    }
                    //Effective Date of the selected role's must be between current effective date and Opportunity contract end date
                    else if(cr.OCRInst.Role__c == 'Primary Broker' && (cr.OCRInst.Effective_Date__c <= currentEffDatePB || cr.OCRInst.Effective_Date__c >= oppEndDate)){
                        cr.errorMsg = 'Error:Effective Date must fall between the current Broker Agent of Record effective date and Opportunity Contract End Date';
                        cr.oppEffDateErrorrenderv =true;
                        errorMsgReturn = true;
                    }
                    //Effective Date has to be first of a month
                    else if(cr.OCRInst.Effective_Date__c.day() != 1){
                        cr.errorMsg = 'Error:Effective Date has to be first of a month';
                        cr.oppEffDateErrorrenderv =true;
                        errorMsgReturn = true;
                    }
                    //End Date must be same as Opportunity End Date       
                    else if(cr.OCRInst.End_Date__c != oppEndDate){
                        cr.errorMsg = 'Error:End Date must be same as Opportunity End Date';
                        errorMsgReturn = true;
                        cr.oppEndDateErrorrenderv = true;
                    }
                    // for BCC profile  users only primary Role data allowed to save when opp is sold       
                    else if(strProfileName == bccProfileName && cr.OCRInst.Role__c != 'Primary Broker'){
                        cr.errorMsg = 'Error:Only Broker Agent of Record Role is allowed to save for this profile user'; //T04
                        errorMsgReturn = true;
                        cr.oppRoleErrorMsg = true;
                    }
                    // for Non BCC profile users only non primary Role data allowed to save when opp is sold   
                                        
                    else if(nonBCCProfiles.contains(strProfileName) && cr.OCRInst.Role__c == 'Primary Broker'){
                        cr.errorMsg = 'Error: Broker Agent of Record Role is not allowed to save for this profile user';
                        system.debug('Inside else if>>:'+cr.errorMsg);  
                        errorMsgReturn = true;
                        cr.oppRoleErrorMsg = true;
                    }
                    
                    
                    
                    // Count the number of rows selected for Primary Broker role
                    if(cr.OCRInst.Role__c == 'Primary Broker'){
                        entrycountPrimaryBroker++;
                    }
                }
            }
            
            
            // Do not allow the user to save if a role has been chosen in more than one row
            if(entrycountPrimaryBroker > 1){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Broker Agent of Record role cannot be selected in multiple rows');
                ApexPages.addMessage(msg);
                return null;
            }
            else if(errorMsgReturn == true){
                return null;      
            }    
            else if(oppStage == 'Sold'){
                for(wrapperOCR currentCR : wrapInputListOCR){
                        
                    if(currentCR.OCRInst.Contact_Name__c != null && currentCR.OCRInst.Role__c != null){
                        if(currentCR.OCRInst.Opportunity__c == null){
                            currentCR.OCRInst.Opportunity__c = oppId;
                        }
                        // Set the first Primary Broker and Consultant as primary
                        if((countPrimaryBroker == 0 && currentCR.OCRInst.Role__c == 'Primary Broker') /*|| 
                           (countConsultant  == 0 && currentCR.OCRInst.Role__c == 'Consultant')*/){//Satya : only for Primary broker Primary is true
                                 currentCR.OCRInst.Primary__c = true;
                        }
                        else{
                            for(wrapperOCR previousCR : wrapOutputListOCR){
                                     if(((previousCR.OCRInst.Role__c == 'Primary Broker' && currentCR.OCRInst.Role__c == 'Primary Broker')/*|| 
                                        (previousCR.OCRInst.Role__c == 'Consultant' && currentCR.OCRInst.Role__c == 'Consultant')*/) && previousCR.OCRInst.Primary__c == true){
                                         
                                         // Set the new Contact Role as Current and reset the previous Current Record
                                         currentCR.OCRInst.Primary__c = true;
                                         previousCR.OCRInst.Primary__c = false;
                                         
                                         // Set the end date of the previous current record as one day prior to new effective date
                                         previousCR.OCRInst.End_Date__c = currentCR.OCRInst.Effective_Date__c- 1;
                                         upsertlistOCR.add(previousCR.OCRInst); 
                                 }
                             }
                        }
                        // Add the modified/new Contact roles into a list
                        upsertlistOCR.add(currentCR.OCRInst);                     
                    }
                }
                // Upserting the new/modified contact roles [Replicate the same in the standard Contact Roles thru trigger-OpportunityContactRoleTrigger]
                if(upsertlistOCR.size() > 0){  
                    upsert upsertlistOCR;
                    //T02--Start
                    if(!getIsClassic())
                    {
                    msg = 'Record Saved';
                    displayPopUp = true;
                    return null;
                    }
                    //T02--End
                }                                              
                
                //  Re-directing it to the Oportunity page    
                pageRef = new PageReference('/'+oppId);                   
                return pageRef;  
            }    
            else{
                system.debug('In save sold else');
                
                //commented for coverage this code never executes because OppStage = sold
                /*for(wrapperOCR cr: wrapListOCR){
                    if(cr.OCRInst.Contact_Name__c != null && cr.OCRInst.Role__c != null){
                        if(cr.OCRInst.Opportunity__c == null){
                            cr.OCRInst.Opportunity__c = oppId;
                        }
                        if(selectedCR != 0){
                             // To retrieve the selected primary contact role and update the Primary checkbox
                             if(cr.index == selectedCR) {    
                                 cr.OCRInst.Primary__c = true;
                             }
                             else{
                                 cr.OCRInst.Primary__c = false;
                             }
                     }
                     // Add the modified/new Contact roles into a list
                     upsertlistOCR.add(cr.OCRInst);                     
                    }
                }
                // Upserting the new/modified contact roles [Replicate the same in the standard Contact Roles thru trigger-OpportunityContactRoleTrigger]
                if(upsertlistOCR.size() > 0){  
                    upsert upsertlistOCR;     
                }                                              
                
                //  Re-directing it to the Oportunity page    
                pageRef = new PageReference('/'+oppId);                   
                return pageRef; */return null;
            }
        }
        catch(DMlException e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
            ApexPages.addMessage(Msg);
            system.debug('getNumDml'+e.getNumDml());
            return null;
        }
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
            ApexPages.addMessage(Msg);
            return null;
        }      
    }
    public void enableDates(){
        system.debug('strProfileName>>>>'+strProfileName);
        if(strProfileName == bccProfileName || adminProfiles.contains(strProfileName)){
            for(wrapperOCR wrp : wrapInputListOCR){
                if(wrp.OCRInst.Role__c == 'Primary Broker'){
                    wrp.oppDatesEnable = true;
                }else{
                    wrp.oppDatesEnable = false;
                }                   
            }
        }
        
            
    }
    
    // Wrapper class to bind the Contact role and an error message
    public class wrapperOCR{
        public Opportunity_Contact_Role__c OCRInst {get; set;}
        public integer index {get; set;}
        public string errorMsg {get; set;}
        public boolean oppEffDateErrorrenderv{get;set;}
        public boolean oppEndDateErrorrenderv{get;set;}
        public boolean oppRoleErrorMsg{get;set;}
        public boolean oppDatesEnable{get;set;}
        
        //Constructor
        public wrapperOCR(Opportunity_Contact_Role__c a,integer b,string c){
            OCRInst = a;
            index = b;
            errorMsg = c;
            oppDatesEnable = false;
        }
    }

}// End of Class