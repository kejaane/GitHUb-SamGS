/*=========================================================================================
 * Date         : 08/21/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This is the controller class for the VF page-Partner_RelatedList_Page.
 *                It will contain method to save the custom partner records.
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer          Tag        Description
 *===========+=================+=====+===========================================================
    1/17/2018 | Gayathri       | T01 | Added boolean to return if user is logged into lightning or classic.
    1/23/2018 |Rajesh Nagandla | T02 | Added conformation window for lightning
    7/6/2018  | Arshia Gulati  | T03 | Get OppId from parameter
    9/6/2018  |Naga Kandukoori | T04 | Added None(Direct Sale) if condition, Changed error msg  RITM0635114
 *=========================================================================================
 */
 
 public class Partner_RelatedList_Class{
    
    // Instance of wrapper class - Output list to show as non-editable rows
    public list<wrapperPartner> wrapOutputListPartner{get; set;}
    // Instance of wrapper class - Input list to show as editable rows
    public list<wrapperPartner> wrapInputListPartner{get; set;}
    
    public list<wrapperPartner> wrapListPartner{get; set;}
    
    public string oppName{get; set;}
    public string oppStage{get; set;}
    list<Opportunity> opp = new list<Opportunity>();
    list<Partner__c> upsertlistPartner = new list<Partner__c>();
    list<Partner__c> listPartner = new list<Partner__C>();
    PageReference pageRef;
    Id oppId;
    public integer noPrimary{get; set;} 
    public integer currentPrimary{get; set;} 
    public integer selectedCR{get; set;} 
    public String strProfileName;
    public String bccProfileName = 'BCC RUL Custom';     
    public Set<String> nonBCCProfiles = new Set<String>{'2+ Standard User - Custom','51+ Standard User - Custom'};
    public string accntId;
    
    // Flags to use in data input validations(get the count of Partner records based on Roles)
    boolean errorMsgReturn = false;
    Date oppEndDate, oppEffDate, currentEffDateBroker, currentEffDateConsultant;
    integer ind,countActuary = 0, countNone = 0, countBroker = 0, countConsultant= 0, entrycountActuary, entrycountNone, entrycountBroker, entrycountConsultant ;
    /** T02 - Start **/
    public PageReference returnToOpp()
    {
        return new PageReference('/' + oppId);
    }
    public String msg{get; set;}
    public Boolean displayPopUp{get; set;}
    /** T02 - End **/
    
    //Constructor
    public Partner_RelatedList_Class(ApexPages.StandardController controller){
        try{
        
            noPrimary =  currentPrimary = 100;
            selectedCR = null;

            strProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
            system.debug('strProfileName>>>> '+strProfileName);
            
            //To get the Opportunity ID
            Partner__c part = (Partner__c)controller.getRecord();
            oppId = part.Opportunity__c;
            
            //Start-T03
            if(oppId == null)
              oppId=ApexPages.currentPage().getParameters().get('oppid');
            //End-T03            
            
            //refreshPage = false;
            if(oppId != null){
            opp = [SELECT Name,AccountId,Effective_Date__c,Contract_End_Date__c,StageName
                       FROM Opportunity 
                       WHERE id =: oppId];
                       
                // Get the Opportunity name,effective and end dates      
                for(Opportunity o : opp){
                    oppName = o.Name;
                    oppEffDate = o.Effective_Date__c;
                    oppEndDate = o.Contract_End_Date__c;
                    oppStage = o.StageName;
                    accntId = o.AccountId;
                }
            
            // To query all the Partners from the custom object for the current Opportunity
            listPartner= [SELECT id,Partner__c,Opportunity__c,Role__c,Effective_Date__c,End_Date__c,Primary__c
                          FROM Partner__c 
                          WHERE Opportunity__c =: oppId ORDER BY Role__c asc];
            }
            //if(oppStage == 'Proposal'){
            if(oppStage == 'Proposal' || oppStage == 'RFP' || oppStage == 'Benefit Request' || oppStage == 'Underwriting' || oppStage == 'Quote Delivered' || oppStage == 'ARC Approval' || oppStage == 'Prospecting'){
            // To populate the instances of the wrapper class
                if(wrapListPartner== null){                       
                    wrapListPartner= new List<wrapperPartner>();
                }
                                
                // To populate instances of Contact roles(3 empty rows)
                for(integer i=0;i<3;i++){               
                    Partner__c newP = new Partner__c ();
                    newP.Effective_Date__c = oppEffDate;
                    newP.End_Date__c = oppEndDate ;
                    listPartner.add(newP);
                }
                ind=1;   
                for(Partner__c a : listPartner){
                    if(a.Primary__c == true){
                        currentPrimary = ind;
                    }
                    wrapListPartner.add(new wrapperPartner(a,ind,''));
                    ind++;
                }
            }
            else if(oppStage == 'Sold'){
                if(wrapOutputListPartner== null){                       
                    wrapOutputListPartner= new List<wrapperPartner>();
                }
                // iterate the current partners and calculate the count against each role and get the current effective date
                for(Partner__c p : listPartner){
                    if(p.Role__c == 'Broker'){
                        countBroker++;
                        if(p.Primary__c == true){
                            currentEffDateBroker = p.Effective_Date__c;
                        }
                    }
                    if(p.Role__c == 'Consultant'){
                        countConsultant++;
                        if(p.Primary__c == true){
                            currentEffDateConsultant = p.Effective_Date__c;
                        }
                    }
                    
                    if(p.Role__c == 'Actuary'){
                        countActuary++;
                    }
                    // Start T04 9/6/18
                    if(p.Role__c == 'None (Direct Sale)'){
                        countNone++;
                    }
                    // End T04 9/6/18
                    
                     // Populate the wrapper class list to display as non-editable rows
                    wrapOutputListPartner.add(new wrapperPartner(p,ind,''));
                
                }
                // To populate instances of Partners(5 rows)
                if(wrapInputListPartner == null){                      
                    wrapInputListPartner = new List<wrapperPartner>();
                }
                for(integer i=1;i<=5;i++){               
                    Partner__c newP = new Partner__c();
                    newP.Effective_Date__c = oppEffDate;
                    newP.End_Date__c = oppEndDate ;
                    wrapInputListPartner.add(new wrapperPartner(newP,1,''));
                }
            }
        }
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
            ApexPages.addMessage(Msg);
        }
    }
     
    //T01--Start--Method to check whether the page is in Classic or lightning
    public Boolean getIsClassic() {
    return (AIA_Utils.isClassic());
    }
    //T01--End
    
    //Save Button - To create/update the Custom Partners in classic
    public pagereference savePartner(){
        
        //if(oppStage == 'Proposal'){
        if(oppStage == 'Proposal' || oppStage == 'RFP' || oppStage == 'Benefit Request' || oppStage == 'Underwriting' || oppStage == 'Quote Delivered' || oppStage == 'ARC Approval' || oppStage == 'Prospecting'){
            pagereference p = savePartneronProposal();
            return p;
        }
        else if(oppStage == 'Sold'){
            pagereference p = savePartneronSold();
            return p;
        }
        else{
            return null;
        }
    }
    
    //Save Button for Proposal opportunities
    private pagereference savePartneronProposal(){
    
            errorMsgReturn = false;
            
            for(wrapperPartner crP : wrapListPartner){
                crP.errorMsg = '';
                
                if(crP.partnerInst.Partner__c != null && crP.partnerInst.Role__c != null){
                    
                    //Effective Date and End Date must be always filled         
                    if(crP.index == selectedCR && crP.partnerInst.Role__c != 'Broker'){
                        crP.errorMsg = 'Error:Selling Agency can only be selected for Broker role';
                        errorMsgReturn = true;                       
                    }
                    // for BCC profile users only primary Role allowed to save when opp is sold       
                    else if(strProfileName == bccProfileName  ){
                        crP.errorMsg = 'Error:This profile user not allowed to save Partner when Opportunity is not sold';
                        errorMsgReturn = true;
                    }
                    else if(crP.partnerInst.Partner__c == accntId  ){
                        crP.errorMsg = 'Error:An account cannot partner to itself';
                        errorMsgReturn = true;
                    }
                }
             }
            
             if(errorMsgReturn == true){
                return null;      
             }
             else{
                for(wrapperPartner cr : wrapListPartner){
                                
                    if(cr.partnerInst.Partner__c != null && cr.partnerInst.Role__c != null){
                        if(cr.partnerInst.Opportunity__c == null){
                            cr.partnerInst.Opportunity__c = oppId;
                        }
                        if(selectedCR != 0){
                             // To retrieve the selected primary contact role and update the Primary checkbox
                             if(cr.index == selectedCR) {    
                                 cr.partnerInst.Primary__c = true;
                             }
                             else{
                                 cr.partnerInst.Primary__c = false;
                             }
                         }
                         // Add the modified/new Contact roles into a list
                         upsertlistPartner.add(cr.partnerInst);                     
                    }
                }
             }
            
        // Upserting the new/modified contact roles [Replicate the same in the standard Contact Roles thru trigger-OpportunityContactRoleTrigger]
        try{
        if(upsertlistPartner.size() > 0){  
            upsert upsertlistPartner; 
            if(!getIsClassic())
            {
                liRecordSave(); 
                return null;
            }
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
    private pagereference savePartneronSold(){
        try{
            errorMsgReturn = false;
            entrycountActuary= 0; entrycountNone= 0; entrycountBroker= 0;entrycountConsultant = 0;
            
            // Date input Validations        
            for(wrapperPartner wp : wrapInputListPartner){
                wp.errorMsg = '';
                if(wp.partnerInst.Partner__c != null){
                    
                    //Role must be filled        
                    if(wp.partnerInst.Role__c == null){
                        wp.errorMsg = 'Error:Please select a Role';
                        errorMsgReturn = true;
                    }
                    //Effective Date and End Date must be always filled         
                    else if(wp.partnerInst.Effective_Date__c == null || wp.partnerInst.End_Date__c == null){
                        wp.errorMsg = 'Error:Effective Date and End Date must be filled';
                        errorMsgReturn = true;
                    }
                    //Effective Date should be same as Opportunity Effective Date when a Role is selected for the first time
                    else if(((countBroker == 0 && wp.partnerInst.Role__c == 'Broker') || 
                            (wp.partnerInst.Role__c != 'Broker')) && wp.partnerInst.Effective_Date__c != oppEffDate){
                        wp.errorMsg = 'Error:Effective Date should be same as Opportunity Effective Date';
                        errorMsgReturn = true;
                    }
                    //Effective Date of the selected role's must be between current effective date and Opportunity contract end date
                    else if(wp.partnerInst.Role__c == 'Broker' && (wp.partnerInst.Effective_Date__c <= currentEffDateBroker || wp.partnerInst.Effective_Date__c >= oppEndDate)){
                        wp.errorMsg = 'Error:Effective Date must fall between the current ' +wp.partnerInst.Role__c+ ' effective date and Opportunity contract end date';
                        errorMsgReturn = true;
                    }
                    //Effective Date has to be first of a month
                    else if(wp.partnerInst.Effective_Date__c.day() != 1){
                        wp.errorMsg = 'Error:Effective Date has to be first of a month';
                        errorMsgReturn = true;
                    }
                    //End Date must be same as Opportunity End Date       
                    else if(wp.partnerInst.End_Date__c != oppEndDate){
                        wp.errorMsg = 'Error:End Date must be same as Opportunity End Date';
                        errorMsgReturn = true;
                    }
                    // for BCC profile  users only primary Role data allowed to save when opp is sold       
                    else if(strProfileName == bccProfileName && wp.partnerInst.Role__c != 'Broker'){
                        wp.errorMsg = 'Error:Only Broker Role is allowed to save for this profile user';
                        errorMsgReturn = true;
                    }                   
                    // for Non BCC profile users only non primary data allowed to save when opp is sold                     
                    else if(nonBCCProfiles.contains(strProfileName) && wp.partnerInst.Role__c == 'Broker'){
                        wp.errorMsg = 'Error: Broker Role is not allowed to save for this profile user when Opportunity is sold';
                        system.debug('Inside else if>>:'+wp.errorMsg);  
                        errorMsgReturn = true;
                    }
                    else if(wp.partnerInst.Partner__c == accntId  ){
                        wp.errorMsg = 'Error:An account cannot partner to itself';
                        errorMsgReturn = true;
                    }
                    
                    if(wp.partnerInst.Role__c == 'Actuary'){
                        entrycountActuary++;
                    }
                    //Start T04 9/6/18
                    if(wp.partnerInst.Role__c == 'None (Direct Sale)'){
                        entrycountNone++;
                    }
                    //End T04 9/6/18
                    
                    if(wp.partnerInst.Role__c == 'Broker'){
                        entrycountBroker++;
                    }
                    if(wp.partnerInst.Role__c == 'Consultant'){
                        entrycountConsultant ++;
                    }
                }
            }
            // Do not allow the user to save if a role has been chosen in more than one row
            if(entrycountBroker> 1){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Broker role cannot be selected in multiple rows');
                ApexPages.addMessage(msg);
                return null;
            }
            else if(errorMsgReturn == true){
                return null;      
            }
            else{
                for(wrapperPartner wp : wrapInputListPartner){
                    
                    if(wp.partnerInst.Partner__c!= null){
                        if(wp.partnerInst.Opportunity__c == null){
                            wp.partnerInst.Opportunity__c = oppId;
                        }
                        // Set the first Broker and Consultant as primary
                        if((countBroker == 0 && wp.partnerInst.Role__c == 'Broker') /*|| 
                            (countConsultant == 0 && wp.partnerInst.Role__c == 'Consultant')*/){
                                 wp.partnerInst.Primary__c = true;
                        }
                        else{
                            for(wrapperPartner previousPart : wrapOutputListPartner){
                                 if(((previousPart.partnerInst.Role__c == 'Broker' && wp.partnerInst.Role__c == 'Broker')/*|| 
                                     (previousPart.partnerInst.Role__c == 'Consultant' && wp.partnerInst.Role__c == 'Consultant')*/) && previousPart.partnerInst.Primary__c == true){
                                         
                                         // Set the new Partner as Current and reset the previous Current Record
                                         wp.partnerInst.Primary__c = true;
                                         previousPart.partnerInst.Primary__c = false;
                                         
                                         // Set the end date of the previous current record as one day prior to new effective date
                                         previousPart.partnerInst.End_Date__c = wp.partnerInst.Effective_Date__c- 1;
                                         upsertlistPartner.add(previousPart.partnerInst); 
                                 }
                             }
                        }
                        // Add the new partners into a list 
                        upsertlistPartner.add(wp.partnerInst);
                    }
                }
                
                // upserting the partners [Replicate the same in the standard Partner thru trigger-PartnerTrigger]  
                if(upsertlistPartner.size() > 0){
                    upsert upsertlistPartner; 
                    if(!getIsClassic())
                    {
                       liRecordSave();
                        return null;
                    }
                }
                //  Re-directing it to the Oportunity page    
                pageRef = new PageReference('/'+oppId);                   
                return pageRef;   
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
    
    // Cancel button - To go back to the Opportunity page
    public pagereference cancelPartner(){
        pageRef = new PageReference('/'+oppId);
        return pageRef;
    }
    
    public void enableDates(){
        system.debug('strProfileName>>>>'+strProfileName);
        if(strProfileName == bccProfileName || strProfileName == 'System Administrator'){
            for(wrapperPartner wrp : wrapInputListPartner){
                if(wrp.partnerInst.Role__c == 'Broker'){
                    wrp.oppDatesEnable = true;                  
                }else{
                    wrp.oppDatesEnable = false;
                }
                system.debug('wrp>>>>'+wrp);
            }
            system.debug('wrapInputListPartner>>>>'+wrapInputListPartner);
        }       
    }
     
     public void liRecordSave() {
       msg = 'Record Saved';
       displayPopUp = true;
    }

    // Wrapper class to bind the Partner and an index, to retrieve the primary Partner
    public class wrapperPartner{
        public Partner__c partnerInst {get; set;}
        public integer index {get; set;}
        public string errorMsg {get; set;}
        public boolean oppDatesEnable{get;set;}
        //Constructor
        public wrapperPartner(Partner__c a,integer b,string c){
            partnerInst = a;
            index = b;
            errorMsg = c;
        }
    }
}