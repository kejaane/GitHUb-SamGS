/*=========================================================================================
 * Date         : 09/01/2016
 * Developer    : Ahilesh Radhakrishnan
 * Purpose      : This is the controller class for the VF page - FSP_GP_RelatedList_Page.
 *                It will contain method to create/update the custom FSP/GP records.
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer        Tag     Description
 *===========+===============+=======+========================================================
   01/18/2018|Rajesh Nagandla| T01   | Added SLDS to page.
 *=========================================================================================
 */
 
 public class FSP_GP_RelatedList_Class{
    
    // Instance of wrapper class - Output list to show as non-editable rows
    public list<wrapperFSPGP> wrapOutputListFSPGP{get; set;}
    // Instance of wrapper class - Input list to show as editable rows
    public list<wrapperFSPGP> wrapInputListFSPGP{get; set;}
    
    public list<wrapperFSPGP> wraplistFSPGP{get; set;}
     
    public string oppName{get; set;}
    public string oppStage{get; set;} 
    public string errorMsg{get; set;}
    list<Opportunity> opp = new list<Opportunity>();
    list<FSP_GP__c> upsertlistFSPGP = new list<FSP_GP__c>();
    list<FSP_GP__c> listFSPGP{get; set;}
    boolean errorMsgReturn = false;
    PageReference pageRef;
    Id oppId;
    
    public integer noPrimary{get; set;} 
    public integer currentPrimary{get; set;} 
    public integer selectedCR{get; set;} 
    
    public Boolean soldnonNpnProfile{set;get;}
    public String strProfileName;
    public String bccProfileName = 'BCC RUL Custom'; 
    public Set<String> adminProfiles = new Set<String>{'System Administrator'};
    public Set<String> nonBCCProfiles = new Set<String>{'2+ Standard User - Custom','51+ Standard User - Custom'};
    
     // Flags to use in data input validations
    Date oppEndDate,oppEffDate,currentEffDateFSPGP;
    integer ind,countFSPGP=0;
    //T01  -   start
    public Boolean getIsClassic() {
        return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }
   public PageReference returnToOpp()
    {
        return new PageReference('/' + oppId);
    }
     public String msg{get; set;}
    public Boolean displayPopUp{get; set;}
    //T01  -   end
    //Constructor
    public FSP_GP_RelatedList_Class(ApexPages.StandardController controller){
        try{
        
            noPrimary =  currentPrimary = 100;
            selectedCR = null;
            
            strProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
            system.debug('strProfileName>>>> '+strProfileName);
            
              // To get the Opportunity ID
            FSP_GP__c fspgp = (FSP_GP__c)controller.getRecord();
            oppId = fspgp.Opportunity__c;
            
            if(oppId == null)
              oppId=ApexPages.currentPage().getParameters().get('oppid');
                        
            if(oppId != null){
            
                // To query the Opportunity's name to display in the page block title
                opp = [ SELECT Name,Effective_Date__c,Contract_End_Date__c ,StageName
                            FROM Opportunity where id =: oppId];
                
                // Get the Opportunity name,effective and end dates      
                for(Opportunity o : opp){
                    oppName = o.Name;
                    oppEffDate = o.Effective_Date__c;
                    oppEndDate = o.Contract_End_Date__c;
                    oppStage = o.StageName;
                }
            
                // To query all the FSP/GPs from the custom object for the current Opportunity
                listFSPGP = [SELECT id,Effective_Date__c,End_Date__c,FSP_GP__c,Partner__c,Primary__c,Opportunity__c
                             FROM FSP_GP__c
                             WHERE Opportunity__c =: oppId ORDER BY Effective_Date__c asc];
                countFSPGP = listFSPGP.size();
            }
            
            //if(oppStage == 'Proposal'){
            if(oppStage == 'Proposal' || oppStage == 'RFP' || oppStage == 'Benefit Request' || oppStage == 'Underwriting' || oppStage == 'Quote Delivered' || oppStage == 'ARC Approval'){
            // To populate the instances of the wrapper class
                if(wraplistFSPGP == null){                       
                    wraplistFSPGP = new List<wrapperFSPGP>();
                }
                // To populate instances of Contact roles(3 empty rows)
                for(integer i=0;i<3;i++){               
                    FSP_GP__c newFSPGP = new FSP_GP__c();
                    newFSPGP.Effective_Date__c = oppEffDate;
                    newFSPGP.End_Date__c = oppEndDate ;
                    listFSPGP.add(newFSPGP);
                }
                ind=1;   
                for(FSP_GP__c a : listFSPGP){
                    if(a.Primary__c == true){
                        currentPrimary = ind;
                    }
                    wraplistFSPGP.add(new wrapperFSPGP(a,ind,'',true));
                    ind++;
                } 
            }
            if(oppStage == 'Sold'){
                // Populate the wrapper class list to display as non-editable rows
                if(wrapOutputListFSPGP== null){                       
                    wrapOutputListFSPGP = new List<wrapperFSPGP>();
                }
                for(FSP_GP__c a : listFSPGP){
                    if(a.Primary__c == true){
                            currentEffDateFSPGP = a.Effective_Date__c;
                    }
                    wrapOutputListFSPGP.add(new wrapperFSPGP(a,1,'',true));
                }
                system.debug('wrapOutputListFSPGP>>>'+wrapOutputListFSPGP);
                //Populate the wrapper class list to display as editable row(1 row)
                if(wrapInputListFSPGP == null){                       
                    wrapInputListFSPGP = new List<wrapperFSPGP>();
                    FSP_GP__c newFSPGP = new FSP_GP__c();
                    newFSPGP.Effective_Date__c = oppEffDate;
                    newFSPGP.End_Date__c = oppEndDate ;
                    boolean isenable = true;
                    if(nonBCCProfiles.contains(strProfileName)){
                        isenable = false;
                        wrapInputListFSPGP.add(new wrapperFSPGP(newFSPGP,1,'',false));
                    }else{
                        wrapInputListFSPGP.add(new wrapperFSPGP(newFSPGP,1,'',true));
                    }
                    system.debug('isenable>>>>'+isenable);
                    
                }
            }
            //system.debug('wrapInputListFSPGP>>>>>'+wrapInputListFSPGP);
        }
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()); 
            ApexPages.addMessage(Msg);
        }
    }
    
    //Save Button - To create/update the Custom Opportunity Contact Roles
    public pagereference saveFSPGP(){
        
            //if(oppStage == 'Proposal'){
            if(oppStage == 'Proposal' || oppStage == 'RFP' || oppStage == 'Benefit Request' || oppStage == 'Underwriting' || oppStage == 'Quote Delivered' || oppStage == 'ARC Approval'){
                pagereference p = saveFSPGPonProposal();
                return p;
            }
            else if(oppStage == 'Sold'){
                pagereference p = saveFSPGPonSold();
                return p;
            }
            else{
                return null;
            }
    }
    
    //save method for classic
    private pagereference saveFSPGPonProposal(){
    
         // To get all the FSP/GP Account record id from the custom setting - FSP_GP_Account_Lookup__c
         list<FSP_GP_Account_Lookup__c> fspgpIds= FSP_GP_Account_Lookup__c.getall().values();
        upsertlistFSPGP = new list<FSP_GP__c>();
            
        for(wrapperFSPGP crP : wrapListFSPGP){
            crP.errorMsg = '';
            if(crP.FSPGPInst.Partner__c != null && crP.FSPGPInst.FSP_GP__c != null){
                    if(strProfileName == bccProfileName){
                        crP.errorMsg = 'Error: This Profile user is not allowed to save FSP/GP';
                        return null;
                    }
                
                    if(crP.FSPGPInst.Opportunity__c == null){
                        crP.FSPGPInst.Opportunity__c = oppId;
                    }
                    
                    // Set the Account__C lookup field from the custom setting - FSP_GP_Account_Lookup__c
                    for(FSP_GP_Account_Lookup__c  fspgp : fspgpIds){
                        
                        if(crP.FSPGPInst.Partner__c == fspgp.Partner_Name__c){
                            crP.FSPGPInst.Account__c = fspgp.Partner_ID__c;
                        }
                    }    
                    
                    if(selectedCR != 0){
                         // To retrieve the selected primary contact role and update the Primary checkbox
                         if(crP.index == selectedCR) {    
                             crP.FSPGPInst.Primary__c = true;
                         }
                         else{
                             crP.FSPGPInst.Primary__c = false;
                         }
                     }
                     // Add the modified/new Contact roles into a list
                     upsertlistFSPGP.add(crP.FSPGPInst);                     
                }
                    
                }
                // Upserting the FSP/GPs
                try{
                    
                if(upsertlistFSPGP.size() > 0){
                    system.debug('upsertlistFSPGP 218-->'+upsertlistFSPGP);
                    upsert upsertlistFSPGP;
                    
                    if(!getIsClassic())
                    {
                    msg = 'Record Saved';
                    displayPopUp = true;
                    return null;
                    }
                }
                //  Re-directing it to the Oportunity page    
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
    
    //Save Button for classic sold
    private pagereference saveFSPGPonSold(){
        try{
            errorMsgReturn = false;
            upsertlistFSPGP = new list<FSP_GP__c>();
            system.debug('wrapInputListFSPGP in sold>>>>>>>>'+wrapInputListFSPGP);
            // To validate the filled in dates and display error messages if needed, and block the save
            for(wrapperFSPGP f : wrapInputListFSPGP){
                f.errorMsg = '';
                if(f.FSPGPInst.Partner__c != null){
                                   
                    if(f.FSPGPInst.Effective_Date__c == null || f.FSPGPInst.End_Date__c == null){
                        f.errorMsg = 'Error:Effective Date and End Date must be filled';
                        errorMsgReturn = true;
                    }
                     //Effective Date should be same as Opportunity Effective Date when a FSP/GP is selected for the first time
                    else if(countFSPGP == 0 && f.FSPGPInst.Effective_Date__c != oppEffDate){
                        f.errorMsg = 'Error:Effective Date should be same as Opportunity Effective Date';
                        errorMsgReturn = true;
                    }
                    //Effective Date has to be first of a month
                    else if(f.FSPGPInst.Effective_Date__c.day() != 1){
                        f.errorMsg = 'Error:Effective Date has to be first of a month';
                        errorMsgReturn = true;
                    }
                     //Effective Date of the selected role's must be between current effective date and Opportunity contract end date
                    else if(f.FSPGPInst.Effective_Date__c <= currentEffDateFSPGP || f.FSPGPInst.Effective_Date__c >= oppEndDate){
                        f.errorMsg = 'Error:Effective Date must fall between the current FSP/GP effective date and Opportunity Contract End Date';
                        errorMsgReturn = true;
                    }
                    //End Date must be same as Opportunity End Date       
                    else if(f.FSPGPInst.End_Date__c != oppEndDate){
                        f.errorMsg = 'Error:End Date must be same as Opportunity End Date';
                        errorMsgReturn = true;
                    }
                    else if(nonBCCProfiles.contains(strProfileName)){
                        f.errorMsg = 'Error: This Profile user is not allowed to save FSP/GP';
                        system.debug('Inside else if>>:'+f.errorMsg);   
                        errorMsgReturn = true;
                        //f.oppRoleErrorMsg = true;
                    }
                }
            }
            if(errorMsgReturn == true){
                return null;      
            }
            else{
                // To get all the FSP/GP Account record id from the custom setting - FSP_GP_Account_Lookup__c
                list<FSP_GP_Account_Lookup__c> fspgpIds= FSP_GP_Account_Lookup__c.getall().values();
                system.debug('fspgpIds>>>>>'+fspgpIds);
                system.debug('wrapInputListFSPGP>>>>>'+wrapInputListFSPGP);
                for(wrapperFSPGP currentFSPGP : wrapInputListFSPGP){
                     system.debug('currentFSPGP>>>>>'+currentFSPGP);
                     if(currentFSPGP.FSPGPInst.Partner__c != null){
                        
                        // Set the Account__C lookup field from the custom setting - FSP_GP_Account_Lookup__c
                        for(FSP_GP_Account_Lookup__c  fspgp : fspgpIds){
                            
                            if(currentFSPGP.FSPGPInst.Partner__c == fspgp.Partner_Name__c){
                                currentFSPGP.FSPGPInst.Account__c = fspgp.Partner_ID__c;
                            }
                        }      
                        
                        // Link to the Opportunity record   
                        if(currentFSPGP.FSPGPInst.Opportunity__c == null){
                            currentFSPGP.FSPGPInst.Opportunity__c = oppId;
                        }
                        
                        // Set the first FSP or GP as primary
                        if(countFSPGP == 0){
                            currentFSPGP.FSPGPInst.Primary__c = true;
                        }
                        else{
                            for(wrapperFSPGP previousFSPGP : wrapOutputListFSPGP){
                                 if(previousFSPGP.FSPGPInst.Primary__c == true){
                                     
                                     // Set the new Partner as Current and reset the previous Current Record
                                     currentFSPGP.FSPGPInst.Primary__c = true;
                                     previousFSPGP.FSPGPInst.Primary__c = false;
                                     
                                     // Set the end date of the previous current record as one day prior to new effective date
                                     previousFSPGP.FSPGPInst.End_Date__c = currentFSPGP.FSPGPInst.Effective_Date__c- 1;
                                     upsertlistFSPGP.add(previousFSPGP.FSPGPInst); 
                                 }
                             }
                        }
                        // Add the new FSP/GPs into a list
                        upsertlistFSPGP.add(currentFSPGP.FSPGPInst); 
                        
                        
                    }
                }
                // Upserting the FSP/GPs
                if(upsertlistFSPGP.size() > 0){
                    upsert upsertlistFSPGP;
                    if(!getIsClassic())
                    {
                    msg = 'Record Saved';
                    displayPopUp = true;
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
    public pagereference cancelFSPGP(){
        pageRef = new PageReference('/'+oppId);
        return pageRef;
    }
    
    // Wrapper class to bind the FSP/GP and an index for each row
    @TestVisible Private class wrapperFSPGP{
        public FSP_GP__c FSPGPInst {get; set;}
        public integer index {get; set;}
        public string errorMsg {get; set;}
        public Boolean isPrimary{get; set;}
        public Boolean isEnable{get; set;}
       
        public wrapperFSPGP(FSP_GP__c a,integer b,string c, Boolean isEnable1){
            FSPGPInst = a;
            index = b;
            errorMsg =  c;
            isPrimary = a.Primary__c;
            isEnable = isEnable1;
        }
    }

 } // End of Class