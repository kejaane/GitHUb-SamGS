/**
 *  @Author: Acumen Solutions
 *  @Purpose: Manager class for Opportunity related processes. 
 *
 *------------------------------------------------------------------------------------
 *                      ----===[ HISTORY ]===---
 * Date        Developer        Description
 *------------------------------------------------------------------------------------
 * 12/27/2011 Tom Barrett (TPB) Add code to default the Account_in_Jeopardy__c field
 *                              to 'No' so that the validation rule did not make the
 *                              cloning code fail.
 * 12/03/2012 Varun Nagarajan   Fields: Market_Segment_c and Business__c have been 
 *                              replaced with Market_Segment_New__c, SBU__c, 
 *                              Division__c and Business_Type__c to represent the
 *                              new ReOrg. The old fields will no longer be populated
 *                              in the cloning process
 *
 * 12/19/2013 Tom Barrett (TPB) Deprecated the calculateNewDates method and replaced
 *                              it with a new method called calculateNewDates2.
 *                              Like the old method the new method adjusts the 
 *                              Effective_Date__c, CloseDate but it also adjusts
 *                              the new field Contract_End_Date__c.  This new method
 *                              is for the Gap Date Effort from Sprint 13
 *
 * 06/06/2014 Tom Barrett (TPB) Made change to prevent Won_Lost_Reason__c from being
 *                              cloned.
 *
 * 07/18/2015 Ashish Ojha (AO)  Added methods to clone Survey Contacts and program from
 *                              opportunity when opportunity is cloned
 *
 *10/17/2017 Vivek Sharma (VS) |T01|   Added check for termination tracking opportunities 
 *                                      B-05295
 * 8/9/2018  Thejaswi Ganesh   |T02|   INC0443507 fix for Request for NPN checkbox 
 *                                     and notification carried over from Cloned Opportunity
 * 11/16/2018 Chaithra P V	   |T03|   Added condition to skip cloning of Contact Role if the role is deactivated.
 * 
 * 11/19/2018 Chaithra P V 	   |T04|   Added logic to copy over active roles to cloned Opportunity and 
 * 									   Commented out the methods used for cloning survey contact.
 *
 *************************************************************************************
*/


public without sharing class OpportunityProcessorManager {

/* Instantiate  valiables, properties */    
    List<Account> accList = new List<Account>();
    Map <id , Opportunity> accIdOpportunityMap = new Map <id , Opportunity>();
    Set<Id> oppIds = new Set<Id>();
    private Boolean isCloneWithProduct { get; set; }
    public static boolean isCloned=false;
    
/*
* @purpose : The public method used for changing Account Owner . This method is called from the OpportunityProcessor Trigger.
* @param : accIds - set of Ids of the Accounts whose owner need to be changed
* @param: accIdOppMap - Map of Account Id and Opportunity records. 
* @return: void 
*/
     public  void changeAccountOwnerForOpportunityOwnerChange(Set<Id> accIds , Map <id , Opportunity> accIdOppMap){
        /* Static method getAllAccountByIds() from class QueryBase to get all Account records for a set of account Ids*/        
        this.accList = QueryBase.getAllAccountByIds(accIds);
        this.accIdOpportunityMap = accIdOppMap;
        /* Called private method processAccountRecord()to populate account owner */        
        processAccountRecord();
        
     }
/*
* @purpose : The private method used for changing Account Owner and update the records . After successful update of account owner, it calls 
* another private method sendEmailToAccountOwner() to send email to the account owner.
* @param : null 
* @return: void 
*/    
     private void processAccountRecord(){
        /* list to hold all the accounts that need to be updated with new owner */      
        List<Account> accToUpdate = new List<Account>();
        
        for (Account acc:accList){
            if(accIdOpportunityMap.containsKey(acc.id)){
                Opportunity opp = accIdOpportunityMap.get(acc.id);
                // If the account owner is same as the opportunity owner , do not send the coount owner change email.
                if(acc.OwnerId != opp.OwnerId){
                    acc.OwnerId = opp.OwnerId ; 
                    accToUpdate.add(acc); 
                }     
            }
        }
        
        if(accToUpdate.size()>0){
            /* list to hold all updated accounts */
            List<Account> updatedList = new List<Account>();
            /* Static method updateAccountRecords() from class QueryBase to update Account records */               
            updatedList = QueryBase.updateAccountRecords(accToUpdate);
            if(updatedList.size()>0){
                    /* called private method sendEmailToAccountOwner() to send email on successful update of account */
                   sendEmailToAccountOwner(updatedList);
            }
        }
        
        System.debug('OpportunityProcessorManager::Account updated with new Owner :   ' + accToUpdate.size());
     }
     
/*
* @purpose : The private method used for changing Account Owner and update the records . After successful update of account owner, it calls 
* another private method sendEmailToAccountOwner() to send email to the account owner.
* @param : acc - List of Account whose owner has changed.  
* @return: void 
*/     
     private void sendEmailToAccountOwner(List<Account> acc){
        System.debug('OpportunityProcessorManager.sendEmailToAccountOwner :   ' + acc);
        Set<id> accOwnerId = new Set<ID>();
        List<User> ownersWithEmail = new List<User>();
        User currentUser = new User();
        for (Account a:acc){
            accOwnerId.add(a.OwnerId);
        }
        /* Static method getUserByIds() from class QueryBase to get all owner with email id */    
        ownersWithEmail = QueryBase.getUserByIds(accOwnerId);
        /* Static method getCurrentUser() from class QueryBase to get the logged in user with email id */ 
        currentUser = QueryBase.getCurrentUser();
        if(ownersWithEmail.size()>0){
            for(Account a:acc){
                for(User user:ownersWithEmail){
                    if(a.OwnerId == user.Id){
                        String  accURL= a.Test_Account_URL__c + a.Id  ; 
                        List<String> toAddresses = new List<String> {user.Email};
                        String replyToAddress = currentUser.Email;
                        PageReference pageRef = new PageReference(accURL);
                        /* initialize inner class EmailUtil from class Utils.cls to set all params to create the email and then process the email */
                        Utils.EmailUtil emailUtil = new Utils.EmailUtil(toAddresses);
                        system.debug('Email toAddresses is :'+ toAddresses);
                        // String emailBody = 'Account <b> ' + a.name + '  </b> has been assigned to you.Please click on the link below to view the record.<br>' +  '<b><a href="'+ accURL  + '">Click Link</a></b>' ;
                        String emailBody = 'Account ' + a.name + ' has been assigned to you. Please click on the link below to view the record. \n ' + pageRef.getUrl() +'\n' ;                 
                        /* set email body */
                        emailUtil.plainTextBody(emailBody);
                        /* set sender name as current user */
                        emailUtil.senderDisplayName(currentUser.Name);
                         /* set subject line */
                        emailUtil.subject('Account transferred to you');
                         /* set reply to address as current user email id */
                        emailUtil.replyTo(replyToAddress);
                        /* Call public method sendEmail() for processing of the email */
                        emailUtil.sendEmail()  ;
                    }

                }
            }
        }
        
     }
/*
* @purpose : The public method used for Cloning Opportunity and its related records - OpportunityLineItem,OpportunityContactRole,
* OpportunityPartner. This method is called from the OpportunityProcessor Trigger on Opportunity Stage update to 'Sold'.
* @param : oppToClone - Opportunity to be cloned 
* @return: void 
*/
  
    public  void cloneOpportunityOnOpportunityStageUpdate(Opportunity oppToClone){ 
        
        system.debug(' Within OpportunityProcessorManager.cloneOpportunityOnOpportunityStageUpdate() Method.......' ); 
        /* called private method cloneOpportunity() to clone the opportunity 'oppToClone'and populate some fields with new values as required */
        Opportunity clonedOpp  = cloneOpportunity(oppToClone);
        /* set the param 'isCloneWithProduct' true to clone the related products */
        this.isCloneWithProduct = true;
         /* called private method cloneOpportunityRelatedObjects() to clone Opportunity related records such as OpportunityLineItem,
        OpportunityContactRole,OpportunityPartner  */
        if(clonedOpp != null && oppToClone!= null ){
            cloneOpportunityRelatedObjects(oppToClone , clonedOpp);
        }
       isCloned=true; 
    }
    
/*
* @purpose : The public method used for Cloning Opportunity and its related records - OpportunityLineItem,OpportunityContactRole,
* OpportunityPartner. This method is called from the controller class OpportunityDeepCloneController
* @param : oppToClone - Opportunity to be cloned 
* @return: Opportunity - new cloned opportunity
*/    
    public Opportunity cloneOpportunityWithProduct(Opportunity oppToClone){
        system.debug(' Within OpportunityProcessorManager.cloneOpportunityWithProduct() Method.....oppToClone..'+ oppToClone );
        Opportunity clonedOpp  = cloneOpportunity(oppToClone);
        system.debug('Cloned Opp is ------------'+ clonedOpp);
        /* set the param 'isCloneWithProduct' true to clone the related products */
        this.isCloneWithProduct = true;
        /* called private method cloneOpportunityRelatedObjects() to clone Opportunity related records such as OpportunityLineItem,
        OpportunityContactRole,OpportunityPartner  */
        if(clonedOpp != null && oppToClone!= null ){
            cloneOpportunityRelatedObjects(oppToClone , clonedOpp);
            clonedOpp.StageName = 'Proposal';
            clonedOpp.Probability = 50;
            //clonedOpp.Won_Lost_Reason__c = oppToClone.Won_Lost_Reason__c;
            clonedOpp.Incumbent_Successor__c = oppToClone.Incumbent_Successor__c;
            clonedOpp.FullServiceProducer__c = oppToClone.FullServiceProducer__c;
            clonedOpp.GeneralProducer__c = oppToClone.GeneralProducer__c;
            update clonedOpp;
        }
        
        return clonedOpp;
    }

/*
* @purpose : The public method used for Cloning Opportunity and its related records - OpportunityContactRole,OpportunityPartner. 
* This method is called from the controller class OpportunityDeepCloneController .
* @param : oppToClone - Opportunity to be cloned 
* @return: Opportunity - new cloned Opportunity
*/    
    public Opportunity cloneOpportunityWithoutProduct(opportunity oppToClone){
        system.debug(' Within OpportunityProcessorManager.cloneOpportunityWithoutProduct() Method.......' );
        Opportunity clonedOpp  = cloneOpportunity(oppToClone);
        /* set the param 'isCloneWithProduct' false to restrict cloning of related products */
        this.isCloneWithProduct = false;
        /* called private method cloneOpportunityRelatedObjects() to clone Opportunity related records such as 
            OpportunityContactRole,OpportunityPartner  */
        if(clonedOpp != null && oppToClone!= null ){
            cloneOpportunityRelatedObjects(oppToClone , clonedOpp);
        }
        
        return clonedOpp;
    }

/*
* @purpose : The private method used for cloning Opportunity and populate some of the fields as required. 
* @param : opp -  Opportunity to clone
* @return: Opportunity  - new cloned Opportunity
*/     
    private Opportunity cloneOpportunity(Opportunity opp){
            
            System.debug('Within OpportunityProcessorManagerc.cloneOpportunity()................');
            String fmtDate;
            DateTime dt; 
            Time fmtTime; 
            /* clone the oppoetunity */
            Opportunity cloneOpp = opp.clone(false);
            
            String currentUserId = UserInfo.getUserId();
            Id oppOwnerId =opp.OwnerId;
            User oppOwner = QueryBase.getUserById(oppOwnerId);
            /* if the owner of the opportunity is inactive then make the new clone opportunity owner as the login user,
            otherwise copy the original owner*/
            if(oppOwner.IsActive){
                cloneOpp.OwnerId = opp.OwnerId;     
            }
            else {
                cloneOpp.OwnerId = (Id)currentUserId;
            }

// BEGIN CHANGE TPB 12/19/2013           
                //Date[] newDates = calculateNewDates(opp.Effective_Date__c);    // DEPRECATED 12/19/2013
                Date[] newDates = calculateNewDates2(opp.Effective_Date__c, opp.Contract_End_Date__c);
// END CHANGE TPB 12/19/2013
            cloneOpp.Effective_Date__c = newDates[0];
            cloneOpp.CloseDate = newDates[1];
            cloneOpp.Contract_End_Date__c = newDates[2];    // Add TPB 12/19/2013  
            
            /*format the date for appending to the opp name */
            fmtTime = Time.newInstance(0, 0, 0, 0);
            dt = DateTime.newInstance(cloneOpp.Effective_Date__c, fmtTime);
            fmtDate =dt.format('MM/yy');
            
            cloneOpp.StageName = 'Proposal';
            cloneOpp.Probability = 50;
            /* the Account name is null for the opportunity processing in trigger context . Added this code to fetch the Account name . */            
            if(opp.Account.name == null || opp.Account.name ==''){
                Account  acc = [select name from Account where id =: opp.AccountId];
                cloneOpp.Name = acc.Name + ' ' + fmtDate ;
            }
            else{
                cloneOpp.Name = opp.Account.Name +' ' +  fmtDate ;  
            }
            /* populate fields as required */
            cloneOpp.Products_Sold__c = null;
            cloneOpp.Products_Offered__c = null;
            cloneOpp.Related_Products_Offered__c = null;
            cloneOpp.Related_Products_Offered_Quantity__c = null;
            cloneOpp.Related_Products_Sold__c = null;
            cloneOpp.Related_Products_Sold_Quantity__c = null;
            cloneOpp.Est_Actual_Contracts__c = null;
            cloneOpp.Legal_Account_Name_Verified__c = false;
            
            // Begin Change 12/03/2012 VN
            cloneOpp.Market_Segment__c = null;
            cloneOpp.Business__c = null;
            cloneOpp.AVP__c = null;
            // End Change 12/03/2012 VN
            
            cloneOpp.Transitioned__c = false;
            cloneOpp.MissingPartner__c = false;    
            cloneOpp.Last_Modified_By_User__c = ''; 
            cloneOpp.Lead_Rep__c ='';
            cloneOpp.Lead_Rep_Name__c ='';
            cloneOpp.Lead_Rep_Number__c ='';
            cloneOpp.Description ='';
            
            // Begin Change 12/27/2011 TPB
            cloneOpp.Account_In_Jeopardy__c = 'No';
            // End Change 12/27/2011 TPB
            
            // Begin Change 06/06/2014 TPB
            cloneOpp.Won_Lost_Reason__c = null;
            // End Change 06/06/2014 TPB
            // T01 - BEGIN CHANGE VS 10/17/2017
            //make sure termination tracking fields are null when opportunity is cloned            
            cloneOpp.number_of_Contracts__c = null;
            cloneOpp.number_of_Member_Months__c = null;
            cloneOpp.Rating_Type__c = null;
            cloneOpp.Actual_Increase__c = null;
            cloneOpp.Demo_Increase__c = null;
            cloneOpp.Blend_Increase__c = null;
            cloneOpp.Delivered_Increase__c = null;
            cloneOpp.Floor__c = null;
            cloneOpp.Pooled_Amount__c = null;
            cloneOpp.Gain_Loss__c = null;
            cloneOpp.Overall_Loss_as_a_of_Revenue__c = null;
            cloneOpp.Final_Rate_Increase__c = null;
            cloneOpp.U_W_Sales_Management_Involved__c = null;
            cloneOpp.Successor_Benefit_Comparison__c = null;
            cloneOpp.Savings__c = null;
            cloneOpp.Loss_Ratio_Year_1__c = null;
            cloneOpp.Loss_Ratio_Year_2__c = null;
            cloneOpp.Loss_Ratio_Year_3__c = null;
            cloneOpp.Request_NPN__c = FALSE ; // T02 INC0443507 , Setting Request NPN field to FALSE(UNCHECKED) by default.
            // T01 - END CHANGE VS 10/17/2017

            
            /* called Static method insertOpportunity() from QueryBase.cls to insert the clone opportunity */
            cloneOpp =  QueryBase.insertOpportunity(cloneOpp) ; 
            System.debug('Oportunity inserted :' + cloneOpp.Name);  
            return cloneOpp; 
    
    }
/*
* @purpose : The private method used for calculating EffectiveDate and CloseDate
* @param : oldEffectiveDate -  EffectiveDate of the old opportunity
* @return: Date[]  - Arry of Dates{EffectiveDate , CloseDate}
*/     

// BEGIN CHANGE TPB 12/19/2013  
/* DEPRECATED the calculateNewDates method and 
   replaced it with the new calculateNewDates2 method
   
    private Date[] calculateNewDates(Date oldEffectiveDate){
        
        Date newEffectiveDate ;
        Date newCloseDate ;
        
        Integer day = oldEffectiveDate.day();
        Integer month = oldEffectiveDate.month();
        Integer dayOfYear = oldEffectiveDate.dayOfYear(); 
        Integer year = oldEffectiveDate.year();
                
    if(Date.isLeapYear(year)){
        // if the date is before 29'Feb 
        if(dayOfYear<60)
            {
                newEffectiveDate = oldEffectiveDate.addDays(366);
                newCloseDate = oldEffectiveDate.addDays(345);
            }
        // if the date is 29'Feb or after that  
        else if(dayOfYear>=60)
            {
                newEffectiveDate = oldEffectiveDate.addDays(365);
                newCloseDate = oldEffectiveDate.addDays(344);
            }
    }
    
    else if( !Date.isLeapYear(year) && Date.isLeapYear(year+1)) {
            // if the date is after 28th Feb
            if(dayOfYear>59){
                newEffectiveDate = oldEffectiveDate.addDays(366);
                newCloseDate = oldEffectiveDate.addDays(345);
            }
            else {
                newEffectiveDate = oldEffectiveDate.addDays(365);
                newCloseDate = oldEffectiveDate.addDays(344);
            }   
    }
    else {
            newEffectiveDate = oldEffectiveDate.addDays(365);
            newCloseDate = oldEffectiveDate.addDays(344);
    }

        return New Date[]{newEffectiveDate,newCloseDate} ;  
    }
*/ 

//BEGIN NEW TPB 12/19/2013
/*
* @purpose: This method supercedes the calculateNewDate method
*           It takes in the Effective Daate and the 
*           Contract End Date value as input
*           and returns a new Effective Date, Close Date
*           and Contract End Date in an Date array
*           If the Contract End Date is NULL use the Effective
*           Date to calculate the new dates; otherwise, use
*           the Contract End Date*          
*/     
    private Date[] calculateNewDates2(Date oldEffectiveDate, Date oldContractEndDate){          
        Date newEffectiveDate;
        Date newCloseDate;
        Date newContractEndDate; 

        if ( oldContractEndDate == NULL ) {
            newEffectiveDate = oldEffectiveDate.addYears(1); 
        } else {
            newEffectiveDate = oldContractEndDate.addDays(1);      
        }     

        newCloseDate = newEffectiveDate.addDays(-20); 
        newContractEndDate = newEffectiveDate.addYears(1).addDays(-1);  
        System.debug('OpportunityProcessManager.calculateNewDates2(): ' + newEffectiveDate + ', ' + newCloseDate + ', ' + newContractEndDate);
        return New Date[]{newEffectiveDate,newCloseDate, newContractEndDate}; 
    } 
//END NEW TPB 12/19/2013       
//END CHANGE TPB 12/19/2013


/*
* @purpose : The private method used for Cloning  related records - OpportunityLineItem, OpportunityContactRole,OpportunityPartner. This method
* internally calls other private methods to clone individual related objects. 
* @param : oppToClone - Opportunity to be cloned 
* @param : clonedOpp - new cloned Opportunity 
* @return: void 
*/     
    private void cloneOpportunityRelatedObjects(Opportunity oppToClone , Opportunity clonedOpp){
        /* Instantiate  valiables, Objects */        
        List<OpportunityLineItem> oppProductList = new List<OpportunityLineItem>();
        List<OpportunityContactRole> oppContactRoleList = new List<OpportunityContactRole>();
        List<Opportunity_Contact_Role__c> oppCustomContactRoleList = new List<Opportunity_Contact_Role__c>();
        List<FSP_GP__c> oppFSPGPList = new List<FSP_GP__c>();
        List<OpportunityPartner> oppPartnerList = new List<OpportunityPartner>();
        List<Partner__c> oppCustomPartnerList = new List<Partner__c>();
        List<Partner> partnerList = new List<Partner>();
        List<Programs__c> programsList = new List<Programs__c>();
        //List<Survey_Contacts__c> surveyssList = new List<Survey_Contacts__c>(); //T04 
        if(isCloneWithProduct){
            /* called Static method getAllOpportunityLineItemByOpportunityId() from QueryBase.cls to fetch all OpportunityLineItems by opp id */
            oppProductList = QueryBase.getAllOpportunityLineItemByOpportunityId(oppToClone.id);     
        }
        
            Integer effDateDfrnce = oppToClone.Effective_Date__c.monthsBetween(clonedOpp.Effective_Date__c);
            system.debug('effDateDfrnce>>>>'+effDateDfrnce);
            Integer endDateDfrnce = oppToClone.Contract_End_Date__c.monthsBetween(clonedOpp.Contract_End_Date__c);          
            system.debug('endDateDfrnce>>>>'+endDateDfrnce);
        
            /* called Static method getAllOpportunityContactRoleByOpportunityId() from QueryBase.cls to fetch all OpportunityContactRoles by opp id */
            //oppContactRoleList = QueryBase.getAllOpportunityContactRoleByOpportunityId(oppToClone.id);//Satya
            oppCustomContactRoleList = QueryBase.getAllcustomOpportunityContactRoleByOpportunityId(oppToClone.id);//satya
            oppFSPGPList = QueryBase.getAllcustomFSPGPByOpportunityId(oppToClone.id);
            /* called Static method getAllOpportunityPartner()from QueryBase.cls to fetch all OpportunityPartners by opp id  */
            //oppPartnerList = QueryBase.getAllOpportunityPartner(oppToClone.id , clonedOpp.AccountId);//Satya
            
            oppCustomPartnerList = QueryBase.getAllcustomOpportunityPartner(oppToClone.id , clonedOpp.AccountId);//Satya
            
//AO Changes 07/23/2015
            /* called Static method getAllOpportunityProgram() from QueryBase.cls to fetch all OpportunityPrograms by opp id  */ 
            /* called Static method getAllOpportunitySurveyContact() from QueryBase.cls to fetch all OpportunitySurveys by opp id  */            
            programsList   = QueryBase.getAllOpportunityPrograms(oppToClone.id);
            //surveyssList   = QueryBase.getAllOpportunitySurveyContact(oppToClone.id); //T04 
                        
        if(oppProductList.size()>0){
            /* called private method cloneOpportunityProduct to clone OpportunityProduct */
            oppProductList = cloneOpportunityProduct(clonedOpp ,oppProductList );
        }
        if(oppContactRoleList.size()>0){
            /* called private method cloneOpportunityContactRole to clone OpportunityContactRole */
            //oppContactRoleList = cloneOpportunityContactRole(clonedOpp ,oppContactRoleList );      //Satya     
        }
        if(oppCustomContactRoleList.size()>0){
            oppCustomContactRoleList = cloneCustomOpportunityContactRole(clonedOpp ,oppCustomContactRoleList,effDateDfrnce, endDateDfrnce );       //satya P    
        }
        if(oppFSPGPList.size()>0){
           oppFSPGPList = cloneCustomFSPGP(clonedOpp, oppFSPGPList,effDateDfrnce, endDateDfrnce);//satya P
        }
        if(oppPartnerList.size()>0){
            /* called private method cloneOpportunityPartner to clone OpportunityPartner */
            //partnerList = cloneOpportunityPartner(clonedOpp, oppPartnerList);//Satya
        }
        if(oppCustomPartnerList.size()>0){
            oppCustomPartnerList = cloneCustomOpportunityPartner(clonedOpp, oppCustomPartnerList,effDateDfrnce, endDateDfrnce);//satya P
        }
        if(programsList.size()>0){
            /* called private method cloneOpportunityPrograms to clone cloneOpportunityPrograms */
            programsList = cloneOpportunityPrograms(clonedOpp, programsList);
        }
        /* T04 Starts 
        if(surveyssList.size()>0){
             //called private method cloneOpportunitySurveys to clone OpportunitySurveys 
            surveyssList = cloneOpportunitySurveys(clonedOpp, surveyssList);
        }
    	T04  Ends*/
    }
    
/*
* @purpose : The private method used for Cloning OpportunityLineItem .
* @param : clonedOpp - new cloned Opportunity  
* @param : oppLineItems - OpportunityLineItems need to be cloned . 
* @return: List OpportunityLineItem 
*/     
    private List<OpportunityLineItem> cloneOpportunityProduct(Opportunity clonedOpp, List<OpportunityLineItem> oppLineItems){
        List<OpportunityLineItem> clonedProducts = new List<OpportunityLineItem>();
        /* for each OpportunityLineItem , cloning it and populating some fields with required values*/
        for(OpportunityLineItem product:oppLineItems){
            OpportunityLineItem newProduct = product.clone(false);
            newProduct.OpportunityId = clonedOpp.Id;
            newProduct.Product_Sold__c = false;//Satya P
            clonedProducts.add(newProduct);
        }
        /* called Static method insertOpportunityLineItemRecords() from QueryBase.cls to insert the clone OpportunityLineItems */
        clonedProducts = QueryBase.insertOpportunityLineItemRecords(clonedProducts);
        return clonedProducts; 
    }

/*
* @purpose : The private method used for Cloning OpportunityContactRole
* @param : clonedOpp - new cloned Opportunity  
* @param : oppContactRoles - OpportunityContactRoles need to be cloned 
* @return: List OpportunityContactRole 
*/ 
    @testVisible // VS for test coverage    
    private List<OpportunityContactRole> cloneOpportunityContactRole(Opportunity clonedOpp, List<OpportunityContactRole> oppContactRoles){
        List<OpportunityContactRole> clonedOpportunityContactRole = new List<OpportunityContactRole>();
        /* for each OpportunityContactRole , cloning it and populating some fields with required values*/
        for(OpportunityContactRole role:oppContactRoles){
            OpportunityContactRole newContactRole = role.clone(false);
            newContactRole.OpportunityId = clonedOpp.id;
            clonedOpportunityContactRole.add(newContactRole);
            
        }
        /* called Static method insertOpportunityContactRoleRecords() from QueryBase.cls to insert the clone OpportunityContactRoles */
        clonedOpportunityContactRole = QueryBase.insertOpportunityContactRoleRecords(clonedOpportunityContactRole);
        system.debug('clonedOpportunityContactRole are :::' + clonedOpportunityContactRole);
        return clonedOpportunityContactRole; 
    }
/*
* @purpose : The private method used for Cloning Opportunity_Contact_Role__c
* @param : clonedOpp - new cloned Opportunity  
* @param : oppContactRoles - custom OpportunityContactRoles need to be cloned 
* @return: List Opportunity_Contact_Role__c 
*/     
    private List<Opportunity_Contact_Role__c> cloneCustomOpportunityContactRole(Opportunity clonedOpp, List<Opportunity_Contact_Role__c> oppContactRoles,Integer effDateDfrnce, Integer endDateDfrnce){
        Schema.DescribeFieldResult F =Opportunity_Contact_Role__c.Role__c.getDescribe();//Added as a part of T03 
        List<Opportunity_Contact_Role__c> clonedCustomOpportunityContactRole = new List<Opportunity_Contact_Role__c>();
        /* for each OpportunityContactRole , cloning it and populating some fields with required values*/
        for(Opportunity_Contact_Role__c role:oppContactRoles){
            for(PicklistEntry pe : F.getPicklistValues()){//Added as a part of T04
                if(role.Role__c==pe.getvalue()){//Added as a part of T04
            		Opportunity_Contact_Role__c newContactRole = role.clone(false);
            		newContactRole.Opportunity__c = clonedOpp.id;
            		newContactRole.Effective_Date__c = role.Effective_Date__c.addMonths(effDateDfrnce);
            		newContactRole.End_Date__c = role.End_Date__c.addMonths(endDateDfrnce);
            		clonedCustomOpportunityContactRole.add(newContactRole);
            
                }//T04
        	}//T04
        }
        /* called Static method insertOpportunityContactRoleRecords() from QueryBase.cls to insert the clone OpportunityContactRoles */
        clonedCustomOpportunityContactRole = QueryBase.insertCustomOpportunityContactRoleRecords(clonedCustomOpportunityContactRole);
        system.debug('clonedCustomOpportunityContactRole are :::' + clonedCustomOpportunityContactRole);
        return clonedCustomOpportunityContactRole; 
    }   
    
/*
* @created : Ashish Ojha
* @purpose : The private method used for Cloning Programs
* @param : clonedOpp - new cloned Opportunity  
* @param : Programs - Programs need to be cloned 
* @return: List programs 
*/     
    private List<Programs__c> cloneOpportunityPrograms(Opportunity clonedOpp, List<Programs__c> oppPrograms){
        List<Programs__c> programsList = new List<Programs__c>();
        /* for each Programs__c , cloning it and populating some fields with required values*/
        for(Programs__c pp : oppPrograms){
            Programs__c prog = pp.clone(false);
            prog.Opportunity_Name__c = clonedOpp.id;
            programsList.add(prog);
            
        }
        /* called Static method insertProgramRecords() from QueryBase.cls to insert the cloned Programs__c */
        programsList = QueryBase.insertProgramRecords(programsList);
        system.debug('programsList are :::' + programsList);
        return programsList; 
    }

/*
* @created : Ashish Ojha
* @purpose : The private method used for Cloning Survey Contacts
* @param : clonedOpp - new cloned Opportunity  
* @param : Survey Contacts - Survey Contacts need to be cloned 
* @return: List Survey Contacts 
*/ 
/* Commented this method as a part of T04 .
    private List<Survey_Contacts__c> cloneOpportunitySurveys(Opportunity clonedOpp, List<Survey_Contacts__c> oppSurveys){
        List<Survey_Contacts__c> survContactList = new List<Survey_Contacts__c>();
         //for each Survey_Contacts__c , cloning it and populating some fields with required values
        for(Survey_Contacts__c sv : oppSurveys){
            Survey_Contacts__c ss = sv.clone(false);
            ss.Opportunity__c = clonedOpp.id;
            survContactList.add(ss);
            
        }
        //called Static method insertSurveyContactRecords() from QueryBase.cls to insert the cloned Survey_Contacts__c 
        survContactList = QueryBase.insertSurveyContactRecords(survContactList);
        system.debug('survContactList are :::' + survContactList);
        return survContactList; 
    }
T04 ends*/
    
/*
* @purpose : The private method used for Cloning OpportunityPartner
* @param : clonedOpp - new cloned Opportunity  
* @param : oppPartners - OpportunityPartners need to be cloned 
* @return: List OpportunityPartner 
*/ 
    @testVisible //VS for test coverage          
    private List<Partner> cloneOpportunityPartner( Opportunity clonedOpp , List<OpportunityPartner> oppPartners){
        System.debug('****Within cloneOpportunityPartner *****');
        List<Partner> clonedPartner = new List<Partner>();
        
        /* For each OpportunityPartner , create Partner record. We can't directly create OpportunityPartner records as per some restriction 
         * forced by SFDC. Alternalively, SFDC allows us to create Partner records, and behind the scenes they actually create the second 
         * record on the OpportunityPartner object when an insert is executed on the Partner object.
         */
         
        for(OpportunityPartner oppPartner:oppPartners){
            System.debug(' Cloned Opportunity Id is >>>>>>>>' + clonedOpp.Id);
              Partner newPartner = new Partner();
              newPartner.AccountToId = oppPartner.AccountToId;
              newPartner.OpportunityId= clonedOpp.Id;
              newPartner.IsPrimary=oppPartner.IsPrimary;
              newPartner.Role=oppPartner.Role;
              
              clonedPartner.add(newPartner);
        }
        /* called Static method insertOpportunityPartnerRecords() from QueryBase.cls to insert the clone Partners */
        clonedPartner = QueryBase.insertOpportunityPartnerRecords(clonedPartner);
        System.debug('****clonedPartner *****' + clonedPartner);
        return clonedPartner;
    }
    
    /*
* @purpose : The private method used for Cloning OpportunityPartner
* @param : clonedOpp - new cloned Opportunity  
* @param : oppPartners - OpportunityPartners need to be cloned 
* @return: List OpportunityPartner 
*/         
    private List<Partner__c> cloneCustomOpportunityPartner( Opportunity clonedOpp , List<Partner__c> oppPartners,Integer effDateDfrnce, Integer endDateDfrnce){
        System.debug('****Within cloneCustomOpportunityPartner *****');
        List<Partner__c> clonedPartner = new List<Partner__c>();
        
        /* For each OpportunityPartner , create Partner record. We can't directly create OpportunityPartner records as per some restriction 
         * forced by SFDC. Alternalively, SFDC allows us to create Partner records, and behind the scenes they actually create the second 
         * record on the OpportunityPartner object when an insert is executed on the Partner object.
         */
         
        for(Partner__c oppPartner:oppPartners){
            System.debug(' Cloned Opportunity Id is >>>>>>>>' + clonedOpp.Id);
              Partner__c newPartner = new Partner__c();
              newPartner.Partner__c = oppPartner.Partner__c;
              newPartner.Opportunity__c= clonedOpp.Id;
              newPartner.Primary__c=oppPartner.Primary__c;
              newPartner.Role__c=oppPartner.Role__c;
              newPartner.Effective_Date__c=oppPartner.Effective_Date__c.addMonths(effDateDfrnce);
              newPartner.End_Date__c=oppPartner.End_Date__c.addMonths(endDateDfrnce);
                
              
              clonedPartner.add(newPartner);
        }
        /* called Static method insertOpportunityPartnerRecords() from QueryBase.cls to insert the clone Partners */
        clonedPartner = QueryBase.insertCustomOpportunityPartnerRecords(clonedPartner);
        System.debug('**** cloneCustomOpportunityPartner clonedPartner *****' + clonedPartner);
        return clonedPartner;
    }
    
    
       /*
* @purpose : The private method used for Cloning OpportunityPartner
* @param : clonedOpp - new cloned Opportunity  
* @param : oppfspGp - OpportunityPartners need to be cloned 
* @return: List OpportunityPartner 
*/         
    private List<FSP_GP__c> cloneCustomFSPGP( Opportunity clonedOpp , List<FSP_GP__c> oppfspGp,Integer effDateDfrnce, Integer endDateDfrnce){
        System.debug('****Within cloneCustomOpportunityPartner *****');
        List<FSP_GP__c> clonedFSPGP = new List<FSP_GP__c>();
                
        for(FSP_GP__c oppfspgprec :oppfspGp){
            System.debug(' Cloned Opportunity Id is >>>>>>>>' + clonedOpp.Id);
              FSP_GP__c newFSPGP = new FSP_GP__c();
              newFSPGP.Partner__c = oppfspgprec.Partner__c;
              newFSPGP.Opportunity__c = clonedOpp.Id;
              newFSPGP.Primary__c = oppfspgprec.Primary__c;
              newFSPGP.FSP_GP__c = oppfspgprec.FSP_GP__c;
              newFSPGP.Account__c = oppfspgprec.Account__c;
              newFSPGP.Effective_Date__c = oppfspgprec.Effective_Date__c.addMonths(effDateDfrnce);
              newFSPGP.End_Date__c = oppfspgprec.End_Date__c.addMonths(endDateDfrnce);
              
              clonedFSPGP.add(newFSPGP);
        }
        /* called Static method insertOpportunityPartnerRecords() from QueryBase.cls to insert the clone Partners */
        clonedFSPGP = QueryBase.insertFSPGPRecords(clonedFSPGP);
        System.debug('**** cloneCustomOpportunityPartner clonedFSPGP *****' + clonedFSPGP);
        return clonedFSPGP;
    }
    
/*
* @purpose : The static method used for updating OpportunityFields - 
*                       1.Product Offered, 
*                       2.Product Offered Quantity , 
*                       3.Product Sold, 
*                       4.Product Sold Quantity  . 
* This method is called from the OpportunityProductProcessor Trigger. 
* NOTE:: Also this method is used for the DATA MIGRATION activity. So to support migration work , method has been implemented as Asynchronous 
* using @Future .
* @param : oppIds - set of Opportunity Ids for which above fields need to be updated
* @return: void 
*/

@Future   
    public static void populateOpportunityFieldValueForProductsSoldOrOffered(set<Id> oppIds){
        System.debug('**************Within populateOpportunityFieldValueForProductsSoldOrOffered **********');
        /* Instantiate valiables, Objects */
        List<Opportunity> oppToUpdate = new List<Opportunity>();
        List<Opportunity> updatedOpportunity = new List<Opportunity>();
        List<Opportunity> oppList = QueryBase.getAllOpportunityByIds(oppIds);
        List<OpportunityLineItem> oppProductList = QueryBase.getAllOpportunityLineItemByOpportunityIds(oppIds); 
            /* looping over the opportunities list to populate the fields */
             for (Opportunity opp:oppList){
                  String products_Sold = '';
                  String products_Sold_Quantity = '' ; 
                  String products_Offered = ''; 
                  String products_Offered_Quantity = '';
                  for(OpportunityLineItem oppProduct:oppProductList){
                     if(oppProduct.OpportunityId == opp.Id){
                         /* populate 'product sold','product sold quantity' string only if Product_sold__c is true */
                         if(oppProduct.Product_Sold__c){
                            if( (products_Sold =='' || products_Sold == null) && (products_Sold_Quantity == '' || products_Sold_Quantity == null)){
                                    products_Sold = oppProduct.PricebookEntry.Name ;
                                    products_Sold_Quantity = oppProduct.PricebookEntry.Name + ':' + ' ' + oppProduct.Quantity.round() ; 
                                    
                                }
                            else{
                                    products_Sold = products_Sold + ',' + ' '+ oppProduct.PricebookEntry.Name ;
                                    products_Sold_Quantity = products_Sold_Quantity + ','+ ' '+ oppProduct.PricebookEntry.Name + ':'+ ' ' + oppProduct.Quantity.round() ; 
                                    
                                }
                         }
                         /* populate 'product offered','product offered quantity' string */

                            if((products_Offered =='' || products_Offered == null) && (products_Offered_Quantity =='' || products_Offered_Quantity == null)){
                                    products_Offered = oppProduct.PricebookEntry.Name ;
                                    products_Offered_Quantity = oppProduct.PricebookEntry.Name + ':' + ' '+ oppProduct.Quantity.round() ;
                                    
                            }
                            else{
                                    products_Offered = products_Offered + ',' + ' '+ oppProduct.PricebookEntry.Name ;
                                    products_Offered_Quantity = products_Offered_Quantity + ','+ ' '+ oppProduct.PricebookEntry.Name + ':' + ' ' + oppProduct.Quantity.round() ;
                                    
                                
                            }   
                     }
                    
                }
                /* populate the Opportunity fields with formated string for product sold/offered as required */
                opp.Related_Products_Sold__c = products_Sold;
                opp.Related_Products_Sold_Quantity__c = products_Sold_Quantity;
                opp.Related_Products_Offered__c = products_Offered;
                opp.Related_Products_Offered_Quantity__c = products_Offered_Quantity;
                /* add opportunity to list for update */
                oppToUpdate.add(opp);
             }
                /* called Static method updateOpportunityRecords() from QueryBase.cls to update the clone Opportunity Records */
                updatedOpportunity = QueryBase.updateOpportunityRecords(oppToUpdate);

    }

}