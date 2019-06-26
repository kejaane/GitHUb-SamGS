/*=================================================================================================
* Date         : 09/18/2017
* Developer    : Rajehs Pennam
* Purpose      : This class function is to create Custom VF page for Admin Form and implement 
                 the validations accordingly which are not possible in standard page
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date         Developer      Tag    Description
*==================================================================================================
* 08/16/2017| Rajesh Pennam     |     | Initial Version, It is the controller class Admin Form Detail and Edit Page                                         
* 11/14/2017| Raviteja v        | T01 | Adding redirection to redirect to vf page for MCP
* 02/02/2017| Rajesh Nagandla   | T02 | Modified cancel button redirection for lightning
* 03/06/2018| Debkanti          | T03 | Changes made to display export admin button to all
* 03/09/2018| Gayathri          | T04 | Added a method to update Legal Entity value in BD
*==================================================================================================
*/

public with sharing class AIA_Admin_Form_BDF_Controller{
    ApexPages.StandardController con;
    AIA_Benefit_Design_Form__c rec;
    Id id;
    String retURL='';
    public String recordtypeId = '';//new
    public string Bdmode;
    public boolean isClassic {get;set;}
    public string BenefitDesignName{get;set;} //T02 
    //public boolean exportddp{get; set;} //T03
    public String Jurisdiction{get;set;}
    public id Recordtypename{get;set;}
    public id bdfid{get;set;}
    public String FundingArrangement{get;set;}
    public String FirstHelp{get;set;}
    public AIA_Benefit_Design_Form__c bdf{get;set;}
    public String BRFRequestType{get;set;}
    public String BRFStatus{get;set;}
    public String BRFGrandfatherStatus{get;set;}
    public String bdname{get;set;}
    public String bdpname{get;set;}
    public boolean isedit=false;
    public boolean isError{get;set;}
    private static final integer MDAGE= 26;
    private static final string MDMICHELLELAW = 'This Mandate requires that health benefits be provided to an eligible student Dependent with a documented disability who cannot attend school (or attend full-time) until the earlier of one-year or until he/she reaches the Limiting Age for student Dependents. If the student remains disabled after one-year and still has not reached the Limiting Age for student Dependents, the student may remain eligible under Maryland’s part-time students with disabilities law described below. CareFirst may require an enrollee to provide verification of the disability from a disabilities services professional at the school or a health care provider with special expertise in and knowledge of the disability.';
    private static final string MDGRNDCHWAIVERCOMMENTS = 'Per ACA, the limiting age for student Dependents is now up to age 26. This mandate provides for additional coverage for a disabled student Dependent in addition to the benefit provided by Michelle’s Law. After the one-year period provided by Michelle’s Law has expired and the disabled student dependent has not reached the Limiting Age, this Mandate requires that health benefits be provided to the disabled student Dependent who is enrolled less than full-time as a result of the disability but who is maintaining a course load of at least seven (7) credit hours per semester. CareFirst may require an enrollee to provide verification of the disability from a disabilities services professional at the school or a heath care provider with special expertise in and knowledge of the disability. Note: This benefit eliminates the student eligibility requirement of certification for part-time students with disabilities. Student certification is no longer required up to age 25.';
    private static final string MDALLCHLDDEPCOMMENTS= 'Federal Mandate after 6/1/2010 - Limiting age is 26 for Fully- insured accounts.';
    private static final string MDSTUDCOMMENTS = 'Complete a Limiting Age for student Dependents only if the Limiting Age for student Dependents exceeds age 26.';
    private static final string MDADDIDEPDEF= 'Includes: Any child/grandchild in the custody guardianship of the subscriber or spouse pursuant to a court order, testamentary appointment or a child who is the subject of a court/administrative order or Qualified Medical Child Support Order, and Student Dependents with disabilities under Michelle’s Law and the Maryland part-time Students with Disabilities Law.';//Disabled Dependent’s coverage will continue past the limiting age if disabled prior to reaching the limiting age as stated above.'; 
    
    private static final string MDADDIDEPDEF1 = 'Disabled Dependent’s coverage will continue past the limiting age if disabled prior to reaching the limiting age as stated above.';
    
    private static final string MDGDCHLNWAIVERCOMMENTS = 'Applies to fully-insured accounts that provide Dependent coverage. Self-insured accounts may select. For new and renewing fully-insured accounts, the Family Coverage Expansion Act removed the requirement that the grandchild dependent must be in the Court Ordered Custody of the grandparent. Grandchildren dependents shall now follow the Standard Guidelines for Dependent Eligibility.';
    private static final string MDPTSE_DISCOMMENTS = 'Per ACA, the limiting age for student Dependents is now up to age 26. This mandate provides for additional coverage for a disabled student Dependent in addition to the benefit provided by Michelle’s Law. After the one-year period provided by Michelle’s Law has expired and the disabled student dependent has not reached the Limiting Age, this Mandate requires that health benefits be provided to the disabled student Dependent who is enrolled less than full-time as a result of the disability but who is maintaining a course load of at least seven (7) credit hours per semester. CareFirst may require an enrollee to provide verification of the disability from a disabilities services professional at the school or a heath care provider with special expertise in and knowledge of the disability. Note: This benefit eliminates the student eligibility requirement of certification for part-time students with disabilities. Student certification is no longer required up to age 25.';
     
    private static final integer DC_VA_AGE = 26;
    private static final string DC_VA_ALLCHLDDEPCOMMENTS = 'Limiting age is 26 for Fully- insured accounts.';
    private static final string DC_VA_SWDCOMMENTS = 'Effective after  11/1/2009 DC/VA- Applicable to those fully-insured and self-insured accounts that provide a Limiting Age for student Dependents beyond the Limiting Age for all other Dependents. This Mandate requires that health benefits be provided to an eligible student Dependent with a documented disability who cannot attend school (or attend full-time) until the earlier of one-year or until he/she reaches the Limiting Age for student Dependents. CareFirst may require an enrollee to provide verification of the disability from a disabilities services professional at the school or a health care provider with special expertise in and knowledge of the disability.Note:  Virginia state law provides for the exact same benefits for students with disabilities as the Michelle’s Law Federal mandate does';
    
    private static final integer CUSTOM_AGE = 26;
    private static final string CUSTOMMICHELLESLAW = 'Self-insured accounts that provide a Limiting Age for student Dependents beyond the Limiting Age for all Dependents must select.This mandate requires that health benefits be provided to an eligible student Dependent with a documented disability who cannot attend school (or attend full-time) until the earlier of one-year or until he/she reaches the Limiting Age for students.';
    private static final string CUSTOMCHILDDEPCOMMENTS = 'Self-insured accounts MUST select limiting age 26 or greater whether they are grandfathered or non-grandfathered.';
       
    
    public AIA_Admin_Form_BDF_Controller(ApexPages.StandardController controller) {
    isError=false;
    //exportddp = false; //T03
      // id = apexpages.currentpage().getparameters().get('RecordType');
        rec = (AIA_Benefit_Design_Form__c)controller.getRecord();
        isClassic = AIA_Utils.isClassic();
        if(rec!= null){
    recordtypeId = rec.RecordTypeId;
    system.debug('current record type id'+recordtypeId);
    }
        system.debug('page url'+apexpages.currentpage());
        retURL = apexpages.currentpage().getparameters().get('retURL');
         Bdmode = apexpages.currentpage().getparameters().get('Bdmode');
   
       
      con =  controller;
      bdfid=ApexPages.CurrentPage().getparameters().get('id');
     //Recordtypename=apexpages.currentpage().getparameters().get('RecordType');
      bdf= new AIA_Benefit_Design_Form__c ();
      //bdf =(AIA_Benefit_Design_Form__c )controller.getrecord();
      bdf.recordtypeid = apexpages.currentpage().getparameters().get('RecordType');
      system.debug('URL'+apexpages.currentpage()); 
      string bdId1=AIA_Field_ID_List__c.getInstance('BDFobject.Benefit_Design__c').Field_ID__c;
      system.debug('URL'+bdId1); 

      bdname=ApexPages.currentPage().getParameters().get(bdId1);
      if(ApexPages.currentPage().getParameters().containsKey(AIA_Field_ID_List__c.getInstance('BDFobject.BDP').Field_ID__c)){ 
         string bdpId=AIA_Field_ID_List__c.getInstance('BDFobject.BDP').Field_ID__c;
           system.debug('URL'+bdId1); 

         bdpname=ApexPages.currentPage().getParameters().get(bdpId);  
       
       } system.debug('----bdname----'+bdname);
        
      if(bdfid !=null){
      bdf=[select id,Benefit_Design__c,Benefit_Design__r.name,Group_Numbers__c,Benefit_Design_Product__c,Alpha_Prefix__c,Local_K_Group_Numbers__c,Legal_Entity__c ,Child_Dependent_Commnets__c ,
                Market_Segment_Classification__c,Medicare_Secondary_Payer__c,Union_Collective_Bargaining_Agreement__c,Contract_CBA_Collective_Date__c,Part_time_Students_with_Disabilities_Com__c ,
                ERISA_Status__c,Add_Vendor__c,Vendor_CDH_Type__c,Number_Of_Eligibles__c,Union_Name__c,Other_Vendor_Name__c,Salaried_Full_Time__c,
                Salaried_Part_Time__c,Hourly_Full_Time_Hrs__c,Salaried_Part_Time_Hrs__c,Hourly_Full_Time__c,Hourly_Part_Time__c,Hourly_Part_Time_Hrs__c,
                Salaried_Full_Time_Hrs__c,Active_Other_Employees__c,Active_Other_Employees_Desctiption__c,Retirees_Eligible_Fully__c,Retirees_Eligible_Self__c,
                Retirees_Eligible_Fully_Text__c,Retirees_Eligible_Self_Text__c,Dependent_Spouse_Eligible__c,Dependent_Spouse_Eligible_Comments__c,
                Same_Gender_Legal_Marriage_ASO__c,Same_Gender_Marriage_Eligible_Comments__c,Child_Dependents__c,Child_Dependents_Comments__c,
                Domestic_Partner__c,Domestic_Partner_Comments__c,Domestic_Partner_Commnets__c,Child_Dependents_of_Domestic_Partner__c,Medicare_eligible_Retiree__c,
                Medicare_eligible_Domestic_Partner__c,Medicare_eligible_Child_Dependents_of_DP__c,Child_Dependent_Mandates__c,Unmarried_Dep_Child_on_Family_Cont_Type__c,
                All_Child_Dependents_Limiting_Age_4b__c,Child_Dependents_Limit_Age_4a__c,All_Child_Dependents_Limiting_Age__c,All_Child_Dependents_Comments_4a__c,
                All_Child_Dependents_Comments_4b__c,All_Child_Dependents_Comments__c,Students_Limit_Age_4a__c,Students_Limit_Age_4b__c,Students_Limit_Age__c,
                SwD_Limiting_Age_4b__c,SwD_Removal_Method_4b__c,SwD_Comments_4b__c,All_Child_Dependents_Removal_Method_4b__c,Child_Dependents_Removal_Method_4a__c,
                All_Child_Dependents_Removal_Method__c,Students_Removal_Method_4a__c,Students_Removal_Method_4b__c,New_Hire_Enrollment__c,
                Other_New_Hire_Enrollment__c,Effective_Date_New_Hire_Coverage__c,Effective_Date_New_Hire_Other__c,Retires_Under_Age_65__c,Retires_Age_65__c,Actives__c,
                Date_of_Termination__c,Termination_Comments__c,Initial_Enrollment__c,ID_Card_Number__c,Contract_Benefit_Guide__c,Contract_Benefit_Guide_Other__c,
                Subsequent_Enrollment__c,Subrogation__c,Subrogation_Comments__c,Subrogation_Pay_and_Pursue__c,COB_Type__c,COB_Type_Comments__c,Grandchildren_Waiver_Comments__c, 
                COB_Type_Pay_and_Pursue__c,Medicare_COB_Type__c,Workers_Compensation__c,Medicare_Part_B_Carve_Out__c,Medicare_Part_B_Carve_Out_Comments__c,Retroactive_Termination__c,
                Retroactive_Termination_Other__c,Continuation__c,Continuation_Comments__c,Standard_Medicare_Complementary__c,Traditional_ASO__c,FirstHelp__c,FirstHelp_Comments__c,
                FirstHelp_Number_on_ID_Card__c,FirstHelp_Number_Comments__c,External_Review_Processing__c,External_Review_Processing_Comments__c,Account_External_Review_Address__c,
                Account_External_Review_Name__c,Additional_Non_Standard_RTF__c,Michelle_s_Law_4a__c,Michelle_s_Law_Comments_New__c,P_T_Students_with_Disabilities_Comments__c,
                Grandchildren_Waiver__c,Part_time_Students_with_Disabilities_4a__c,Student_Comments_4a__c,Additionall_Dependent_Definition__c,Michelle_s_Law_New__c,Michelle_s_Law_Comments1__c, 
                Grandchildren_Court_Ordered__c,Grandchildren_Court_Ordered_Comments__c,Full_time_Students_Limiting_Age__c,Full_time_Students_Removal_Method__c,Full_time_Students_Comments__c,
                Part_time_Students_w_Disability_Limitin__c,Part_time_Students_w_Disability_Reml_Me__c,Part_time_Students_w_Disability_Comment__c,Student_Comments_4b__c,Funding_Arrangement__c,
                Jurisdiction1__c,recordtypeid
                from AIA_Benefit_Design_Form__c 
                where id=:bdfid limit 1]  ;
                 bdname=bdf.Benefit_Design__r.name;
               system.debug('----bdname----'+bdname);
               isedit=true;
               
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
        
       /* T03 -- Start*/
       /* if(bdfrtmap.get(bdf.recordtypeid).getName() == 'Admin' && (userhasadminpermission == true || profileName == 'System Administrator')){
            exportddp = true;
        }*/
           /* T03 -- End*/    
          }
                    system.debug('----isedit----'+isedit);
    //string bdname=ApexPages.currentPage().getParameters().get('CF00N60000002jAke');
      //Did use custom setting to save the field 
      system.debug('---callingForBDCHeck----'+bdf.Benefit_Design__r.Name);
     BenefitDesignName = bdf.Benefit_Design__r.Name;
     
    if(bdname !=null){
      system.debug('---calling2----'+bdname);
   // bdf.recordtypeid = apexpages.currentpage().getparameters().get('RecordType');
    BDFAdmin(bdname);
     //start    
     //end
     }
     
     
     
        
    }
    
    public PageReference pageRedirect(){
       
        system.debug('current record type id'+recordtypeId);
        //Get our page RecordType Id 
        Id PageRecTypeId = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        system.debug('Page Record Type '+PageRecTypeId);
        PageReference RedirectPage;
        If(recordtypeId == String.valueOf(PageRecTypeId)){
            system.debug('in if');
            return null;
           }
            else{
             RedirectPage = con.view();
             RedirectPage.getParameters().put('nooverride', '1');
            }
             return RedirectPage;        
          
    }

    
    @Testvisible
    private void BDFAdmin(string bdname){
    system.debug('---calling2----'+bdname);
    IF(bdname  !=NULL){
    //try{
    list<AIA_Benefit_Design__c> bdid=[select id,Benefit_Request_Form__r.Funding_Arrangements__c,Benefit_Request_Form__r.FirstHelp_For_Sold_BRF__c,
     Benefit_Request_Form__r.Jurisdiction__c,Benefit_Request_Form__r.Request_Type__c,Benefit_Request_Form__r.Status__c,
     Benefit_Request_Form__r.Grandfathered_Status__c,Both_Checker__c,BlueFund_Checkbox__c,Compatible_Checker__c 
     from AIA_Benefit_Design__c 
     where name=:bdname limit 1];
     list<AIA_Benefit_Design_Product__c> bdpid = new list<AIA_Benefit_Design_Product__c>();
    if(bdpname!= null && bdpname !='') 
       bdpid=[select id from AIA_Benefit_Design_Product__c where name=:bdpname limit 1];
     
     
     FundingArrangement=bdid[0].Benefit_Request_Form__r.Funding_Arrangements__c;
     BRFRequestType=bdid[0].Benefit_Request_Form__r.Request_Type__c;
     Jurisdiction=bdid[0].Benefit_Request_Form__r.Jurisdiction__c;
     FirstHelp=bdid[0].Benefit_Request_Form__r.FirstHelp_For_Sold_BRF__c;
      system.debug('----FundingArrangement----'+FundingArrangement+'----------'+BRFRequestType);
      if(!isedit){
       system.debug('----edit----'+bdid[0]);
       if(bdid[0].Benefit_Request_Form__r.Status__c !=null){
           BRFStatus=bdid[0].Benefit_Request_Form__r.Status__c;
       }
       
       if(bdid[0].Benefit_Request_Form__r.Grandfathered_Status__c !=null){
           BRFGrandfatherStatus=bdid[0].Benefit_Request_Form__r.Grandfathered_Status__c;
       }
      // if(AIA_Utils.isNullOrEmpty(bdf.BD_Approval_Status__c)){bdf.BD_Approval_Status__c = 'In Prssogress';}
       //This is used to PrePopulate the Funding Arrangement From BRF to Admin
       if(bdid[0].Benefit_Request_Form__r.Funding_Arrangements__c!=null && bdid[0].Benefit_Request_Form__r.Funding_Arrangements__c=='ASO'){
           bdf.Funding_Arrangement__c=bdid[0].Benefit_Request_Form__r.Funding_Arrangements__c;
       }
       //This is used to PrePopulate the Funding Arrangement From BRF to Admin
       if(bdid[0].Benefit_Request_Form__r.Funding_Arrangements__c!=null && bdid[0].Benefit_Request_Form__r.Funding_Arrangements__c=='Risk'){
           bdf.Funding_Arrangement__c=bdid[0].Benefit_Request_Form__r.Funding_Arrangements__c;
       }
       //This is used to PrePopulate the Funding Arrangement From BRF to Admin
       if(bdid[0].Benefit_Request_Form__r.Funding_Arrangements__c!=null && bdid[0].Benefit_Request_Form__r.Funding_Arrangements__c=='Other'){
           bdf.Funding_Arrangement__c='ASO';
       }
       
       //This is used to PrePopulate the FirstHelp Field From BRF
       if(bdid[0].Benefit_Request_Form__r.FirstHelp_For_Sold_BRF__c!=null){
           bdf.FirstHelp__c=bdid[0].Benefit_Request_Form__r.FirstHelp_For_Sold_BRF__c;
       }
       
       //This is used to Prepopulate the FirstHelp Number on ID card to Yes if FirstHelp is 'Yes'
       if(bdid[0].Benefit_Request_Form__r.FirstHelp_For_Sold_BRF__c!=null && bdid[0].Benefit_Request_Form__r.FirstHelp_For_Sold_BRF__c== 'Yes'){
           bdf.FirstHelp_Number_on_ID_Card__c='Yes';
       }
       
       //This is used to PrePopulate Jurisdiction from BRF to BDF
       if(bdid[0].Benefit_Request_Form__r.Jurisdiction__c!=null){
           bdf.Jurisdiction1__c = bdid[0].Benefit_Request_Form__r.Jurisdiction__c;
       }
       
       //The below three conditions PrePopulates the CDHFund Type depending on the Type of Product associated for that BRF
       if(bdid[0].Both_Checker__c !=null && bdid[0].Both_Checker__c ==true){
           bdf.Add_Vendor__c='BlueFund/Compatible';
       }
       
       if(bdid[0].Compatible_Checker__c!=null && bdid[0].Compatible_Checker__c==true){
           bdf.Add_Vendor__c='Compatible';
       }
       
       if(bdid[0].BlueFund_Checkbox__c!=null && bdid[0].BlueFund_Checkbox__c==true){
           bdf.Add_Vendor__c='BlueFund';
       }
       
       //This is used to Prepopulate the Michelle's Law field in MD Section
       if(Jurisdiction!=null && Jurisdiction=='MD'){
           bdf.Michelle_s_Law_4a__c='Yes';
       } 
       
       //This is used to PrePopulate Retirees (Self-Insured) to "N/A" for Risk Funding Arrangement
       if(FundingArrangement !=null && FundingArrangement == 'Risk'){
           bdf.Retirees_Eligible_Self__c ='N/A';
       }
       
       //This is used to PrePopulate Retirees (full-Insured) to "N/A" for Risk Funding Arrangement
       if(FundingArrangement !=null && FundingArrangement == 'ASO'){
           bdf.Retirees_Eligible_Fully__c ='N/A';
       }
       
       //This below condition are used to PrePopulate the Child Dependent Mandate Field Depending 
       //on Jurisdiction and Funding Arragnement
       if((Jurisdiction!=null && (Jurisdiction=='VA' || Jurisdiction=='DC' )) && FundingArrangement !=null ){
          if(FundingArrangement =='Risk'){
               bdf.Child_Dependent_Mandates__c='DC/VA';
           }  
       }
   
       if((Jurisdiction!=null && Jurisdiction== 'MD') && FundingArrangement !=null ){
          if(FundingArrangement =='Risk'){
               bdf.Child_Dependent_Mandates__c='Maryland';
           }  
       }
   
       //This condition is used to PrePopulate Michelle's Law field to "Yes" depending on Jurisdiction and Funding Arrangement
       if((Jurisdiction!=null && Jurisdiction=='VA') && FundingArrangement !=null ){
          if(FundingArrangement=='Risk'){
               bdf.Michelle_s_Law_4a__c='Yes';
           }
       }
   
       //This condition is used to PrePopulate Grandchildren Waiver to "Yes" depending on Jurisdiction and Funding Arrangement
       if((Jurisdiction!=null && Jurisdiction=='MD') && FundingArrangement !=null ){
          if(FundingArrangement=='Risk' || FundingArrangement=='Both'){
               bdf.Grandchildren_Waiver__c='Yes';
           }
       }
   
       //This below conditions are used to PrePopulate Continuation to "Yes" depending  Funding Arrangement
       if( FundingArrangement !=null ){
          if(FundingArrangement=='Risk' || bdf.Funding_Arrangement__c =='Risk'){
               bdf.Continuation__c='Yes';
           }
       }
   
       if( FundingArrangement !=null ){
          if((FundingArrangement=='ASO' || bdf.Funding_Arrangement__c =='ASO')){
               bdf.Continuation__c='No';
           }
       }
       system.debug('----edit-id---'+bdid[0].id);
      
       bdf.Benefit_Design__c= bdid[0].id; 
       if(bdpid.size()>0)
         bdf.Benefit_Design_Product__c =  bdpid[0].id;
       system.debug('FundingArrangement======='+FundingArrangement);
       }
     // }catch(exception e){}
        }
    
    }
   // }
    // Redirect to save 
       public PageReference saverec(){
       
       //prepopulatesec();
      
       system.debug('---bdf---'+bdf);
        //con.save();    
      
      // prepopulatesec();
         
       try { 
       
        upsert bdf;
        //T04 Start
        updateLegalEntity(bdf);
        //T04 End
        PageReference pageWhereWeEndUp = new PageReference('/apex/AIA_BDF_Admin_Detail?id='+bdf.id);
        return pageWhereWeEndUp.setRedirect(true);  
        
       }catch(DMLException e) {
       isError=true;
       if(String.valueOf(e.getmessage()).contains('ENTITY_IS_LOCKED')){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter value'));
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getmessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Cannot Create An Admin Form for Approved Benefit Desing.'));
           }
        return null; //return null so DMLException can be displayed to the User
        }                          
        return null;         
      }
      
       // Redirect to save 
       public PageReference quicksave(){
       
       //prepopulatesec();
      
       system.debug('---bdf---'+bdf);
           
      
      // prepopulatesec();
         
       try { 
       
        upsert bdf;
        //T04 Start
        updateLegalEntity(bdf);
        //T04 End
        bdf= new AIA_Benefit_Design_Form__c (); 
      
        PageReference pageWhereWeEndUp = new PageReference(Apexpages.CurrentPage().getURL());
        return pageWhereWeEndUp.setRedirect(true);  
        
       }catch(DMLException e) {
       isError=true;
       if(String.valueOf(e.getmessage()).contains('ENTITY_IS_LOCKED')){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter value'));
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getmessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Cannot Create An Admin Form for Approved Benefit Desing.'));

           }
       //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter value'));
       
        return null; //return null so DMLException can be displayed to the User
        }                          
        return null;         
      }
      
     
     
      //This method is used to cancel the changes and redirect to detail page
      
      public PageReference cancel(){
        String retURL = apexpages.currentpage().getparameters().get('retURL');
        PageReference pr;
        if(Bdmode != 'new'){
            
                pr = new PageReference('/apex/AIA_BDF_Admin_Detail?id='+bdf.id);  
            
        }
        else{
          // T02 - Start 
          system.debug('returl'+returl);
          pr = new PageReference(retURL);
          // T02 - End 
        }
        pr.setRedirect(true);
        return pr;
    }
        
      //This method is used to clone the existing BDF
      public PageReference Clone1(){
         id bdfid1=ApexPages.CurrentPage().getparameters().get('id');
         String QueryString2 = QueryBase2.getSobjectAllFieldsSOQL('AIA_Benefit_Design_Form__c','Id = :bdfid1');
         AIA_Benefit_Design_Form__c bdf = Database.query(QueryString2);
         AIA_Benefit_Design_Form__c clonedbdf = bdf.clone(false, false, false, false);
         insert clonedbdf;
         PageReference pageWhereWeEndUp1 = new PageReference('/apex/AIA_BDF_Admin_Detail?id='+clonedbdf.id);
         return pageWhereWeEndUp1.setRedirect(true);
      }
      
     // This method is use to Prepopulate default values to the fields in MD,DC/VA and Custom Sections US 286
     
     public void prepopulatesec(){
         system.debug('MD Populating'+bdf);
       if((bdf.Unmarried_Dep_Child_on_Family_Cont_Type__c =='MD'  || (bdf.Funding_Arrangement__c == 'Risk' && bdf.Jurisdiction1__c == 'MD') )){
         bdf.Michelle_s_Law_Comments_New__c= MDMICHELLELAW ;
         bdf.Part_time_Students_with_Disabilities_Com__c = MDGRNDCHWAIVERCOMMENTS;
         bdf.Child_Dependents_Limit_Age_4a__c = MDAGE ;
         bdf.All_Child_Dependents_Comments_4a__c = MDALLCHLDDEPCOMMENTS;
         bdf.Students_Limit_Age_4a__c = MDAGE;
         bdf.Student_Comments_4a__c =  MDSTUDCOMMENTS;
         bdf.Grandchildren_Waiver_Comments__c = MDGDCHLNWAIVERCOMMENTS;
         bdf.Additionall_Dependent_Definition__c = MDADDIDEPDEF + '\n' + MDADDIDEPDEF1;
         bdf.Part_time_Students_with_Disabilities_Com__c = MDPTSE_DISCOMMENTS ;
         }
         else if((bdf.Unmarried_Dep_Child_on_Family_Cont_Type__c =='DC/VA' || (bdf.Funding_Arrangement__c == 'Risk' && (bdf.Jurisdiction1__c == 'DC' || bdf.Jurisdiction1__c == 'VA' )) )){
             system.debug('DC/VA Populating'+bdf);
          bdf.All_Child_Dependents_Limiting_Age_4b__c = DC_VA_AGE;
          bdf.All_Child_Dependents_Comments_4b__c = DC_VA_ALLCHLDDEPCOMMENTS;
          bdf.Students_Limit_Age_4b__c = DC_VA_AGE;
          bdf.SwD_Limiting_Age_4b__c = DC_VA_AGE;
          bdf.SwD_Comments_4b__c = DC_VA_SWDCOMMENTS;   
         }
         else if(bdf.Unmarried_Dep_Child_on_Family_Cont_Type__c =='Custom'){
             system.debug('Custom'+bdf);
          bdf.Michelle_s_Law_Comments1__c = CUSTOMMICHELLESLAW;
          bdf.All_Child_Dependents_Comments__c = CUSTOMCHILDDEPCOMMENTS;
          bdf.Full_time_Students_Limiting_Age__c = CUSTOM_AGE;
          bdf.Part_time_Students_w_Disability_Limitin__c = CUSTOM_AGE;
          bdf.All_Child_Dependents_Limiting_Age__c = CUSTOM_AGE;
         
         }
         
         else{}
         
     
     } 
     
     Public pagereference Edit(){
     
      id bdfid1=ApexPages.CurrentPage().getparameters().get('id');
     

       PageReference BDFEditpage = new PageReference('/apex/AIA_BDF_Admin_Form?id='+bdfid1+'&Bdmode=Edit&retURL='+bdfid1);
       return BDFEditpage.setRedirect(true);
     
     
     }  
     
    
    public PageReference exportAdmin(){
        string ddpIds='';
        Map<ID,Schema.RecordTypeInfo> bdfrtmap = AIA_Benefit_Design_Form__c.sObjectType.getDescribe().getRecordTypeInfosById();
        //T01--Start updated the ddpIds based on the record type
        if(bdfrtmap.get(rec.recordtypeid).getName() == 'Admin')
        {
          ddpIds=System.Label.Admin_DDP;
        }
       
        //T01--End 
        PageReference   pageref = new PageReference('/apex/loop__looplus?sessionId={!$Api.Session_ID}&eid='+rec.id+'&hidecontact=true&ddpIds='+ddpIds);
            pageref.setRedirect(true);
            return pageRef;
    }         
    //T04 Method to update Legal Entity value of BD from Admin Form
    public void updateLegalEntity(AIA_Benefit_Design_Form__c bdf)
    {
      try{
        AIA_Benefit_Design__c bdRec = [select id,Admin_Legal_Entity_Drawloop__c 
                                           from AIA_Benefit_Design__c where id=:bdf.Benefit_Design__c];
        
          if (bdf.Legal_Entity__c !=null)
            {
            bdRec.Admin_Legal_Entity_Drawloop__c = bdf.Legal_Entity__c;
            update bdRec;
            }  
        }
        catch(exception ex){
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0));
            ApexPages.addMessage(msg);
        }
        
    }
  }