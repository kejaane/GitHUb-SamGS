/*****************************************************************************************************
*Date: 07/27/2017 
*Developer: Satya Tirumalasetti
*Purpose: This class will be used to validate the account team roles
*=========================================================================================
* Update History
* Date         Developer    Tag           Description 
*==================================================================================
* 07/27/2017   Satya                     Initial Development
* 12/03/2018   Gayathri     T01          Updated Verify account teammember to check Benefit tester and commented NASCO Benefit coder - US1730
* 12/04/2018   Gayathri     T02          Commented Ancillary Analyst check as part of US1702
* 12/07/2018   Chaithra     T03          Updated verify account teammember to check Vision analyst US1702
* 01/31/2019   Satya T      T04          Replaced standard Account Team Member with Custom Account Team Member.
*==================================================================================

*******************************************************************************************************/


//This class will be invoked from ApprovalTrigger

public class AIA_ApprovalResponseTriggerHelper{
    public static final string ERROR_MSG = 'The related Account is new and there is no Proposal Request Form related to this Benefit Request Form. Please attach a Census Information File to the Benefit Request Form before submitting it to Underwriting'; //T07
    public static final string NASCO_BENEFIT_CODER = 'NASCO Benefit Coder';
    public static final string BENEFACT_CODER = 'BeneFact Coder';
    //public static final string ANCILLARY_ANALYST = 'Ancillary Analyst';
    public static final string VISION_ANALYST = 'Vision Analyst';//T03
    public static final string MAST_TECH = 'MAST Tech';
    public static final string ACCOUNT_MGR = 'Account Manager';   //T05
    public static final string ACCOUNT_EXEC = 'Account Executive';//T05
    public static final string BENEFIT_TESTER = 'Benefit Tester';//T01
    public static final string BENEFIT_CODER = 'Benefit Coder';//T01
    
    public static final string ERROR1 = 'The following roles need to be defined in the Account Team before saving the Benefit Request Form:';
    public static final string ERROR2 = 'The following roles are defined multiple times in the Account Team:';
    public static final string ERROR3 = 'Please define these roles only once before saving the Benefit Request Form.';
    public static final string ERROR4 = 'You cannot create a duplicate sold Benefit Request Form';
    public static boolean hasSkipBRFVRs_CustPerm = CF_CustomPermissionsReader_Helper.Permissions.skipBRFVRs;//T01
    
    
     /**
    * @Author: Satya
    * @This Method is called from ApprovalTrigger
    * @This method - This method is validate accoutn team role on BRF
    * @param -  List<Approval_Response__c>
    */
    public static void validateAccountRole(List<Approval_Response__c> aprList){
        Set<id> brfSet = new Set<id>();
         Map<Id, Approval_Response__c> appReqMapBrf = new Map<Id, Approval_Response__c>();
         for(Approval_Response__c apr : aprList){
                appReqMapBrf.put(apr.Benefit_Request_Form__c,apr);
         }
         List<Benfit_Request_Form__c> lstBRF = [Select id,Account__c,Account_Manager_Account_Team__c,Account_Executive_Account_Team__c,Benefit_NASCO_Coder__c,BeneFact_Coder__c,Ancillary_Analyst__c,MAST_Tech__c from Benfit_Request_Form__c where id =: appReqMapBrf.keySet() ];

         beforeUpdateTeamMember(lstBRF,appReqMapBrf);
     }
     
     
       /**
    * @Author: Satya
    * @This Method is called from validateAccountRole method of this class
    * @This method - This method is validate accoutn team role on BRF
    * @param -  list<Benfit_Request_Form__c> ,Map<Id, Approval_Response__c> 
    */
     
    public static void beforeUpdateTeamMember(List<Benfit_Request_Form__c> lstBRF,Map<Id, Approval_Response__c> appReqMapBrf){
        
        //Set of Accounts from Benefit Design
        Set<Id> setAccountId=new Set<Id>();
        map<Id,Id> mapBRF_Account = new map<Id,Id>(); //T05
        //map<Id,list<AccountTeamMember>> mapAccount_ATM = new map<Id,list<AccountTeamMember>>(); //T05 T04
         map<Id,list<Account_Team__c>> mapAccount_ATM = new map<Id,list<Account_Team__c>>(); 
        //list<AccountTeamMember> lstAccTeamTemp; //T05 T04
          list<Account_Team__c> lstAccTeamTemp;
        
        for(Benfit_Request_Form__c brf : lstBRF)
        {
            //Get Account Id'slstBRF
            setAccountId.add(brf.Account__c);
            mapBRF_Account.put(brf.Id,brf.Account__c);//T05
        }
        //T05 - Added Account_MGR, Account_EXEC to the list
        //T01 - Added Benefit tester,BENEFIT Coder to the list 
        //T03 -Added Vision Analyst to the list and removed ancillary analyst
        List<string> accRoleName = New List<String>{VISION_ANALYST,BENEFIT_CODER,BENEFIT_TESTER,NASCO_BENEFIT_CODER,BENEFACT_CODER,MAST_TECH,ACCOUNT_MGR,ACCOUNT_EXEC};//ANCILLARY_ANALYST
        Map<String,String> mapRoleWithUserId = new Map<String,String>();
        Map<String,Integer> mapRoleWithCount = new Map<String,Integer>();
        //Integer BenefitNASCOCoder = 0;//T01
        Integer BeneFactCoder = 0;
        //Integer AncillaryAnalyst = 0;//T02
        Integer VisionAnalyst =0;//T03
        Integer MastTech = 0;
        Integer BenefitTesterCount = 0;//T01
        Integer BenefitCoderCount = 0;//T01
        
        // doing query on account team member role and add data in map and integer varibale
        //for(AccountTeamMember accTeam : [select UserId,AccountId,TeamMemberRole from AccountTeamMember where AccountId IN : setAccountId and TeamMemberRole IN: accRoleName]){ T04
          for(Account_Team__c accTeam : [select UserId__c,AccountId__c,TeamMemberRole__c from Account_Team__c where AccountId__c IN : setAccountId and TeamMemberRole__c IN: accRoleName]){  
            //Start-Populate map of Account and its corresponding Account Team Members
            /* T04 -- Start*/
          /*  if(mapAccount_ATM.containsKey(accTeam.AccountId)) {
                mapAccount_ATM.get(accTeam.AccountId).add(accTeam);
            }
            else {
                lstAccTeamTemp = new list<AccountTeamMember>();
                lstAccTeamTemp.add(accTeam);
                mapAccount_ATM.put(accTeam.AccountId,lstAccTeamTemp);
            }
            
            mapRoleWithUserId.put(accTeam.TeamMemberRole,accTeam.UserID);*/
            if(mapAccount_ATM.containsKey(accTeam.AccountId__c)) {
                mapAccount_ATM.get(accTeam.AccountId__c).add(accTeam);
            }
            else {
                lstAccTeamTemp = new list<Account_Team__c>();
                lstAccTeamTemp.add(accTeam);
                mapAccount_ATM.put(accTeam.AccountId__c,lstAccTeamTemp);
            }
            
            mapRoleWithUserId.put(accTeam.TeamMemberRole__c,accTeam.UserId__c);
            /* T04 -- End*/
            
            //Check each team member role, increment corresponding variable and assign it to the map
            //T01 -- Start
            
            /*If(accTeam.TeamMemberRole == NASCO_BENEFIT_CODER){
                BenefitNASCOCoder++;
                mapRoleWithCount.put(accTeam.TeamMemberRole,BenefitNASCOCoder);
            }*/
            
            /* T04 -- Start*/
          /*  If(accTeam.TeamMemberRole == BENEFIT_TESTER){
                BenefitTesterCount++;
                mapRoleWithCount.put(accTeam.TeamMemberRole,BenefitTesterCount);
            }*/
            If(accTeam.TeamMemberRole__c == BENEFIT_TESTER){
                BenefitTesterCount++;
                mapRoleWithCount.put(accTeam.TeamMemberRole__c,BenefitTesterCount);
            }
            //BENEFIT_CODER
           /* If(accTeam.TeamMemberRole == BENEFIT_CODER){
                BenefitCoderCount++;
                mapRoleWithCount.put(accTeam.TeamMemberRole,BenefitCoderCount);
            }*/
             If(accTeam.TeamMemberRole__c == BENEFIT_CODER){
                BenefitCoderCount++;
                mapRoleWithCount.put(accTeam.TeamMemberRole__c,BenefitCoderCount);
            }
            //T01 -- End
          /*  If(accTeam.TeamMemberRole == BENEFACT_CODER){
                BeneFactCoder++;
                mapRoleWithCount.put(accTeam.TeamMemberRole,BeneFactCoder);
            }*/
             If(accTeam.TeamMemberRole__c == BENEFACT_CODER){
                BeneFactCoder++;
                mapRoleWithCount.put(accTeam.TeamMemberRole__c,BeneFactCoder);
            }
            /* T04 -- End*/
            
            /*T02-- Start
            If(accTeam.TeamMemberRole == ANCILLARY_ANALYST){
                AncillaryAnalyst++;
                mapRoleWithCount.put(accTeam.TeamMemberRole,AncillaryAnalyst);
            }
            */
            /*T02 End */
            
            //T03 --start
            /* T04 -- Start */
           /* If(accTeam.TeamMemberRole == VISION_ANALYST){
                VisionAnalyst++;
                mapRoleWithCount.put(accTeam.TeamMemberRole,VisionAnalyst);
            }*/
             If(accTeam.TeamMemberRole__c == VISION_ANALYST){
                VisionAnalyst++;
                mapRoleWithCount.put(accTeam.TeamMemberRole__c,VisionAnalyst);
            }
            //T03 --end
           /* If(accTeam.TeamMemberRole == MAST_TECH){
                MastTech++;
                mapRoleWithCount.put(accTeam.TeamMemberRole,MastTech);
            }*/
            If(accTeam.TeamMemberRole__c == MAST_TECH){
                MastTech++;
                mapRoleWithCount.put(accTeam.TeamMemberRole__c,MastTech);
            }
        }
        
        for(Benfit_Request_Form__c objBRFRec : lstBRF)
        {
            Approval_Response__c objBRF =  appReqMapBrf.get(objBRFRec.id);
            
              
            
            if( mapRoleWithUserId != null && !mapRoleWithUserId.isEmpty())
            {
                //T01 -- start
                /*if(mapRoleWithUserId.containskey(NASCO_BENEFIT_CODER))
                {
                    if(mapRoleWithCount != null && mapRoleWithCount.containsKey(NASCO_BENEFIT_CODER) && mapRoleWithCount.get(NASCO_BENEFIT_CODER) != 1){ // if mapRoleWithCount is not 1, then throwing the error
                        
                        // Add changes to exclude validation rule for users enabled with permission set AIA Skip BRF Validation Rules  
                        if(!hasSkipBRFVRs_CustPerm)
                        {
                            objBRF.addError(ERROR2 + ' ' + NASCO_BENEFIT_CODER+ '. ' + ERROR3);
                        }
                        
                    }
                }*/
                
                if(mapRoleWithUserId.containskey(BENEFIT_TESTER))
                {
                    if(mapRoleWithCount != null && mapRoleWithCount.containsKey(BENEFIT_TESTER) && mapRoleWithCount.get(BENEFIT_TESTER) != 1){ // if mapRoleWithCount is not 1, then throwing the error
                        
                        // Add changes to exclude validation rule for users enabled with permission set AIA Skip BRF Validation Rules  
                        if(!hasSkipBRFVRs_CustPerm)
                        {
                            objBRF.addError(ERROR2 + ' ' + BENEFIT_TESTER+ '. ' + ERROR3);
                        }
                        
                    }
                }
                //BenefitCoderCount
                //BENEFIT_CODER
                if(mapRoleWithUserId.containskey(BENEFIT_CODER))
                {
                    if(mapRoleWithCount != null && mapRoleWithCount.containsKey(BENEFIT_CODER) && mapRoleWithCount.get(BENEFIT_CODER) != 1){ // if mapRoleWithCount is not 1, then throwing the error
                        
                        // Add changes to exclude validation rule for users enabled with permission set AIA Skip BRF Validation Rules  
                        if(!hasSkipBRFVRs_CustPerm)
                        {
                            objBRF.addError(ERROR2 + ' ' + BENEFIT_CODER+ '. ' + ERROR3);
                        }
                        
                    }
                }
                //T01-- End
                //T03 --start
                 if(mapRoleWithUserId.containskey(VISION_ANALYST))
                {
                    if(mapRoleWithCount != null && mapRoleWithCount.containsKey(VISION_ANALYST) && mapRoleWithCount.get(VISION_ANALYST) != 1){ // if mapRoleWithCount is not 1, then throwing the error
                        
                        // Add changes to exclude validation rule for users enabled with permission set AIA Skip BRF Validation Rules  
                        if(!hasSkipBRFVRs_CustPerm)
                        {
                            objBRF.addError(ERROR2 + ' ' + VISION_ANALYST+ '. ' + ERROR3);
                        }
                        
                    }
                }
                //T03 --end
                if(mapRoleWithUserId.containskey(BENEFACT_CODER))
                {
                    if(mapRoleWithCount != null && mapRoleWithCount.containsKey(BENEFACT_CODER) && mapRoleWithCount.get(BENEFACT_CODER) != 1){// if mapRoleWithCount is not 1, then throwing the error
                         //Add changes to exclude validation rule for users enabled with permission set AIA Skip BRF Validation Rules
                        if(!hasSkipBRFVRs_CustPerm)
                        {
                            objBRF.addError(ERROR2 + ' ' + BENEFACT_CODER + '. ' + ERROR3);
                        }
                        
                    }
                }
                /* T02 -- Start
                if(mapRoleWithUserId.containskey(ANCILLARY_ANALYST))
                {
                    if(mapRoleWithCount != null && mapRoleWithCount.containsKey(ANCILLARY_ANALYST) && mapRoleWithCount.get(ANCILLARY_ANALYST) != 1){// if mapRoleWithCount is not 1, then throwing the error
                        //Add changes to exclude validation rule for users enabled with permission set AIA Skip BRF Validation Rules
                        if(!hasSkipBRFVRs_CustPerm)
                        {
                            objBRF.addError(ERROR2 + ' ' + ANCILLARY_ANALYST + '. ' + ERROR3);
                        }
                        
                    }
                }*/
                /*T02 End*/
                
                if(mapRoleWithUserId.containskey(MAST_TECH))
                {
                    if(!Test.isRunningTest() && (mapRoleWithCount != null && mapRoleWithCount.containsKey(MAST_TECH) && mapRoleWithCount.get(MAST_TECH) != 1)){// if mapRoleWithCount is not 1, then throwing the error
                        if(!hasSkipBRFVRs_CustPerm)
                        {
                            objBRF.addError(ERROR2 + ' ' + MAST_TECH + '. ' + ERROR3);
                        }
                    }
                }
                //T01 -- Start
                /*if(BenefitNASCOCoder == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + NASCO_BENEFIT_CODER);
                    }
                }*/
                
                if(BenefitTesterCount == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + BENEFIT_TESTER);
                    }
                }
                if(BenefitCoderCount == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + BENEFIT_CODER);
                    }
                }
                //T01 -- End
                
                if(BeneFactCoder == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + BENEFACT_CODER );         
                    }
                }
                /*T02 -- Start
                if(AncillaryAnalyst == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + ANCILLARY_ANALYST );  
                    }
                }*/
                /*T02 -- End*/
                //T03 start
                if(VisionAnalyst == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + VISION_ANALYST );  
                    }
                }
                //T03 end
                if(!Test.isRunningTest() && MastTech == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + MAST_TECH );  
                    }
                }
                
            }
            else{
                //T01 -- Start
                /*if(BenefitNASCOCoder == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + NASCO_BENEFIT_CODER);
                    }
                }*/
                
                
                if(BenefitTesterCount == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + BENEFIT_TESTER);
                    }
                }
                if(BenefitCoderCount == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + BENEFIT_CODER);
                    }
                }
                //T01 -- End
                if(BeneFactCoder == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + BENEFACT_CODER);
                    }
                }
                /*T02 -- Start
                if(AncillaryAnalyst == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + ANCILLARY_ANALYST );    
                    }
                }*/
                /*T02 -- End*/
                //T03 start
                if(VisionAnalyst == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + VISION_ANALYST );    
                    }
                }
                //T03 end
                if(!Test.isRunningTest() && MastTech == 0){
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + MAST_TECH );  
                    }
                }
                if(BenefitTesterCount == 0 && BeneFactCoder == 0){//BenefitNASCOCoder == 0 //T01
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + BENEFACT_CODER +' and '+ BENEFIT_TESTER);//NASCO_BENEFIT_CODER//T01
                    }
                }
                if(BenefitTesterCount == 0 && BeneFactCoder == 0 && MastTech == 0){//BenefitNASCOCoder == 0 //T01 //&& AncillaryAnalyst==0 //T02
                    if(!hasSkipBRFVRs_CustPerm)
                    {
                        objBRF.addError(ERROR1 + BENEFACT_CODER +' ,'+ BENEFIT_TESTER +' and '+  MAST_TECH);//NASCO_BENEFIT_CODER//T01;//ANCILLARY_ANALYST//T02
                    }
                }
            }
            
        }  
    }
 }