/*=================================================================================================================
* Date         : 12/07/2017
* Developer    : Goutham Rapolu
* Purpose      : Controller for New Benefit Request Form page on Opportunity Related Lists. 
*               logic to create new BRF based on Funding Arrangement of Opportunity and autopopulate fields
*=================================================================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 12/07/2017 | Goutham Rapolu |     | Initial Version 
* 03/30/2018 | Debkanti		  | T01 | Added Try catch and modified the logic on UpdateOpp method to show user friendly error.
*===========+=================+=====+=============================================================================
*/
public class AIA_BRF_RecordTypeRedirect {
    public id Oppid{get;set;}
    public id PRFid{get;set;}
    public Opportunity Opp{get;set;}
    //BRF RecrodType ID's
    public id BRFASO{get;set;}
    public id BRFRisk{get;set;}
    public id BRFBoth{get;set;}
    public id BRFOther{get;set;}
    public string OppFundingArrangement{get;set;}
    public boolean showMsg{get;set;}
    public boolean LegalAccountNameVerified{get;set;}
    public string RTypeId{get;set;}
    public string RedirectURL{get;set;}
    public string SSSize{get;set;}
    public string Jur{get;set;}
    public string Controlplan{get;set;}
    public string OppMS{get;set;}
    public string BC_Name{get;set;}
    public string accname{get;set;}
    //Error Messages Final String.
    public final String OppFABlank = 'Funding Arrangement on the Opportunity is Blank. Please go back and select Funding Arrangement to create a new Benefit Request Form';
    public final String LegalAccountName = 'Account Legal Name is not Verified for this Account. Please Verify the Account Legal Name below.';
    /*-- T01 Start --*/
    public final String FSPGPError = ' Please add FSP/GP on the Opportunity and then verify the Account Legal Name'; 
    /*-- T01 End --*/
    
    //Constructor.
    Public AIA_BRF_RecordTypeRedirect(apexPages.StandardController controller){
        try{
            string pgurl = ApexPages.currentPage().getUrl();
            system.debug('!!!pgurl!!!'+pgurl);
            //Opportunity ID.
            Oppid = ApexPages.currentPage().getParameters().get('oppid'); 
            system.debug('!!!Oppid!!!'+Oppid);
            Opp = new Opportunity();
            //Query Opp fields.
            Opp = [Select id, Name, Risk_Non_Risk__c, Account_Name__c, AccountId, Legal_Account_Name_Verified__c, AIA_Account_Legal_Name__c,
                   Effective_Date__c,Account.Control_Plan__c,Account.Jurisdiction__c,Market_Segment_New__c,Broker_Consultant_Name__r.name
                   from Opportunity 
                   where id =:Oppid];
            showMsg = False;
            system.debug('!!!Opp!!!'+Opp);
            //BRF RecrodType ID's
            BRFASO = Schema.SObjectType.Benfit_request_form__c.getRecordTypeInfosByName().get('ASO').getRecordTypeId();
            BRFRisk = Schema.SObjectType.Benfit_request_form__c.getRecordTypeInfosByName().get('Risk').getRecordTypeId();
            BRFBoth = Schema.SObjectType.Benfit_request_form__c.getRecordTypeInfosByName().get('Both').getRecordTypeId();
            BRFOther = Schema.SObjectType.Benfit_request_form__c.getRecordTypeInfosByName().get('Other').getRecordTypeId();
            RTypeId = '';
            //Get Opp Funding Arrangement.
            OppFundingArrangement = Opp.Risk_Non_Risk__c;
            //Get Opportunity Account Legal Name Verified.
            LegalAccountNameVerified = Opp.Legal_Account_Name_Verified__c;
            AIA_BRF_RecordType(); 
        }
        catch(Exception e){
            system.debug(Logginglevel.INFO,'Exception in cloning of Records INFO :'+e.getLineNumber()+' Message:'+e.getmessage());
			Apexpages.addMessages(e);
        }
        
    }
    
    //Main method to validate the Funding Arrangement of Opp to BRF RecordType.
    Public pageReference AIA_BRF_RecordType(){
        
        //Assign Record Type ID from Funding Arrangement of Opportunity.
        if(OppFundingArrangement == 'Non-Risk'){ RTypeId = string.valueof(BRFASO); }
        if(OppFundingArrangement == 'Risk'){ RTypeId = string.valueof(BRFRisk); }
        if(OppFundingArrangement == 'Both'){ RTypeId = string.valueof(BRFBoth); }
        if(OppFundingArrangement == 'Other'){ RTypeId = string.valueof(BRFOther); }
        //If Funding Arrangement is Blank or RecordTypeID is blank throw error message.
        if(AIA_Utils.isNullOrEmpty(OppFundingArrangement) || AIA_Utils.isNullorEmpty(RTypeId)) {
            showMsg = True;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.error, OppFABlank);
            ApexPages.AddMessage(myMsg);
        } 
        //If Account Legal name is not Verified throw an error message.
        if(!LegalAccountNameVerified){
            showMsg = True;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.error, LegalAccountName);
            ApexPages.AddMessage(myMsg);
            return null; 
        }
        User currentuser= [SELECT Manager.Id,Manager.name FROM User WHERE Id = :UserInfo.getUserId()]; // Get the manager Id of the current, logged in User
        String Manager = currentuser.Manager.name;
        system.debug('@@UserManager@@'+Manager);
        string oppdate = Opp.Effective_Date__c.month()+'/'+Opp.Effective_Date__c.day()+'/'+Opp.Effective_Date__c.year();
        Controlplan=opp.Account.Control_Plan__c;
        OppMS = opp.Market_Segment_New__c;
        BC_Name = opp.Broker_Consultant_Name__r.name;
        SSSize ='';//Sales_Segment_Size__c in BRF
        accname = Opp.Account_Name__c;
        string IDProtect = 'Yes';
        if(opp.Market_Segment_New__c == '200-999'){SSSize = 'Commercial 200-999';}
        if(opp.Market_Segment_New__c == '1000+'){SSSize = 'Commercial 1,000%2B';}
        
        system.debug('@@SSSSS@@'+SSSize);   
        jur = opp.Account.Jurisdiction__c;
        if(opp.Account.Jurisdiction__c == 'MD'){
            if(Controlplan == null){
                Controlplan = '690';   
            }
            if(OppFundingArrangement == 'Risk'){
                IDProtect = 'No';     
            }
        }else if(opp.Account.Jurisdiction__c == 'DC' || opp.Account.Jurisdiction__c == 'VA'){
            if(Controlplan == null){
                Controlplan = '580';      
            }
            IDProtect = 'Yes';  
        }
        
        string BRFAccountName=AIA_Field_ID_List__c.getInstance('BRF.AccountName').Field_ID__c;
        string BRFOppName = AIA_Field_ID_List__c.getInstance('BRF.OppName').Field_ID__c;
        string BRFObjectID = AIA_Field_ID_List__c.getInstance('BRFObjectID').Field_ID__c;
        string BRFEff_Date = AIA_Field_ID_List__c.getInstance('BRF.Benefit_Effective_Date').Field_ID__c;
        string BRFBen_Period = AIA_Field_ID_List__c.getInstance('BRF.Benefit_Period').Field_ID__c;
        string BRFControl_Plan = AIA_Field_ID_List__c.getInstance('BRF.Control_Plan').Field_ID__c;
        string BRFJur = AIA_Field_ID_List__c.getInstance('BRF.Jurisdiction').Field_ID__c;
        string BRFSSS = AIA_Field_ID_List__c.getInstance('BRF.Sales_Segment_Size').Field_ID__c;
        string BRFCon_Period = AIA_Field_ID_List__c.getInstance('BRF.Contract_Period').Field_ID__c;
        string BRFEGWP = AIA_Field_ID_List__c.getInstance('BRF.EGWP_Picklist').Field_ID__c;
        string BRFFlexLink = AIA_Field_ID_List__c.getInstance('BRF.FlexLink_Picklist').Field_ID__c;
        string BRFIdentityProtection = AIA_Field_ID_List__c.getInstance('BRF.Identity_Protection').Field_ID__c;
        string BRFEnrolType = AIA_Field_ID_List__c.getInstance('BRF.EnrollmentType').Field_ID__c;
        string BRFGrandfatheredStatus = AIA_Field_ID_List__c.getInstance('BRF.Grandfathered_Status').Field_ID__c;
        string BRFGFPPACA_Status = AIA_Field_ID_List__c.getInstance('BRF.Grandfathered_PPACA_Status').Field_ID__c;
        string BrokerConName = AIA_Field_ID_List__c.getInstance('BRF.Broker/Consultant Compensation').Field_ID__c;
        string BrokerConAmount = AIA_Field_ID_List__c.getInstance('BRF.Broker/ConsultantAmount').Field_ID__c;
        
        string BrokerConValue = 'Commission (%25)';
        system.debug('@@@@BrokerConValue'+BrokerConValue);
        
        RedirectURL = '/a0q/e?RecordType='+RTypeId+'&'+BRFAccountName+'='+Opp.Account_Name__c+'&'+BRFAccountName+'_lkid='+Opp.AccountId;
        RedirectURL += '&'+BRFOppName+'='+Opp.Name+'&'+BRFOppName+'_lkid='+Oppid+'&ent='+BRFObjectID+'&retURL='+Oppid;
        RedirectURL += '&'+BRFEff_Date+'='+oppdate+'&'+BRFBen_Period+'=Contract&'+BRFControl_Plan+'='+Controlplan+'&'+BRFJur+'='+opp.Account.Jurisdiction__c;
        RedirectURL += '&'+BRFCon_Period+'=Standard - 12 Months&'+BRFEGWP+'=No&'+BRFFlexLink+'=No&'+BrokerConName+'='+BrokerConValue+'&'+BrokerConAmount+'=3.5';
        RedirectURL += '&'+BRFIdentityProtection+'='+IDProtect+'&'+BRFGrandfatheredStatus +'=Non-Grandfathered&'+BRFGFPPACA_Status+'=Yes&'+BRFEnrolType+'=Parallel';
        if(Manager!=null && Manager!='')
            RedirectURL += '&CF00N63000001S5Y0='+Manager;
        if(BC_Name!=null && BC_Name!='')
            RedirectURL += '&CF00N600000030UEj='+BC_Name;
        if(SSSize!='')
            RedirectURL += '&'+BRFSSS+'='+SSSize;
        
        system.debug('@@@@RedirectURL'+RedirectURL);
        
        //Redirect to BRF by auto selecting RecordType based on Funding Arrangement field on Opportunity.
        if(!AIA_Utils.isNullorEmpty(RTypeId)){
            PageReference pgRef = new PageReference(RedirectURL);
            return pgRef; 
        }  
        
        return null;         
    }
    //Back to Opportunity if error message is shown on the VF page.
    public PageReference Back() {
        return new PageReference('/'+Oppid);
    }
    //Update Opportunity
    public PageReference UpdateOpp(){
        Try{
        update opp;
        /*   PageReference CurrentPage = ApexPages.currentPage();            
CurrentPage.setRedirect(true);
return CurrentPage;*/
        //   return new PageReference('/c/AIA_Create_New_BRF.app');
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
        }
        catch(DmlException e){
            if(String.valueOf(e.getmessage()).contains('EOPP070')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.error, LegalAccountName);
            ApexPages.AddMessage(myMsg);
           	Return null;
            }
            else if(String.valueOf(e.getmessage()).contains('E071')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.error, FSPGPError);
                ApexPages.AddMessage(myMsg);
                Return null;
            }
            else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.error, 'Please Contact System Admin');
                ApexPages.AddMessage(myMsg);
                Return null;
            }
            
        }
    }
    //detect the User's current theme
    public Boolean getIsClassic() {
        return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }
    public PageReference SaveBRF(){
        Benfit_Request_form__c BRF = [select id 
                                      from Benfit_Request_form__c
                                      WHERE Createdbyid=:UserInfo.getUserId()  LIMIT 1];
        return new PageReference('/'+BRF.Id);
    }
    
    
}