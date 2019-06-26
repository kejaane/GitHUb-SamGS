/*==================================================================================================================
* Date         : 05/19/2016
* Developer    : Chidananda Nagaraj 
* Purpose      : User can mark the Opportunity as sold (contract was awarded) if there is a Benefit Request Form 
*                marked as sold. This is called from OpportunityTriggerHandler
*==================================================================================================================
*  Update History
*  ---------------
* Date       | Developer  | Tag |       Description
*============+============+========================================================================================
* 05/19/2016 | Chida      |     | Initial Version. Story B-02108 
* 09/16/2016 | Chida      |     | Added method AIA_Update_Underwriter_TeamMember
* 12/09/2016 | Asif K     |     | Added method createImplementation, moved it from OpportunityTriggerHandler
* 12/09/2016 | Asif K     |     | Added code to populate Parent_Account__c value when creating implementation
* 12/13/2016 | Asif K     |     | If there are multiple sold BRFs for an opportunity, then added code to ensure 
*                                 implementation is created for all of them
* 03/30/2017 | Sree HArsha| T01 | Made the method initializeImplementation public as invoking that in AIA_BRFTriggerHelper 
*                                 to create Implementation
* 10/12/2017 | Goutham R  | T05 | Added method in Beforeinsert/update to check if AccountTeamMember is available before inserting 
*                                 and before updating a 200+ Opportunity US230.
* 12/04/2017 | Goutham R  | T06 | Added logic in AIA_Verify_AccountTeamMember method to get AccountTeamMember and update into
*                                 Opp fields (Service Rep(s) = Account Manager & Lead Rep Name = Account Executive) as per US249.
* 9/26/2018  | Chaithra   | T07 | Add changes to exclude validation rule for users enabled with permission set 
*                                 AIA Skip BRF Validation Rules
* 11/09/2018 | Chaithra   | T08 | Added if Condition to allow the update with Account Manager value only when there is no value assigned to it and 
*                                 to ignore assigning Account Manager when the user inputs any other value to the Service Reps
* 12/14/2018 | Chaithra   | T09 | Removed logic of updating Service Rep(s) and Lead Rep Name fields with AccountTeamMember as per US6528
* 02/01/2019 | Satya T    | T10 | Replaced standard Account Team Member with Custom Account Team Member. 
*============+============+=====+==================================================================================
*/

public class AIA_Opportunity_Helper
{
    public static final string UNDERWRITER = 'Underwriter'; 
    public static final string ACCOUNTMANAGER = 'Account Manager'; 
    public static final string ERROR1 = 'The following roles need to be defined in the Account Team before saving the Opportunity:';
    public static final string ERROR2 = 'The following roles are defined multiple times in the Account Team:';
    public static final string ERROR3 = 'Please define these roles only once before saving the Opportunity.';
    public static final Id opp200Id = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId; // Record Id for the 200+ Opportunity        
    public static boolean IgnoreValidations = CF_CustomPermissionsReader_Helper.Permissions.ignoreVRs;//T07
    public static boolean hasSkipBRFVRs_CustPerm = CF_CustomPermissionsReader_Helper.Permissions.skipBRFVRs;//T07
    //List of Opportunities
    public void AIA_Opportunity_Helper(List<Opportunity> listOppty)
    {
        //Get Opportunity Id 
        Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId; // Record Id for the 200+ Opportunity        
        Set<Id> setOpportunityId=new Set<Id>();
        list<Opportunity> oppList = new list<Opportunity>();     
        for(Opportunity opp:listOppty){
            if(opp.RecordTypeId == opptwohundredplusId ){
                setOpportunityId.add(opp.id);
                oppList.add(opp);
            }
        }  
        //Query BRf object where status is sold for a given Opprtunity Id
        List<Benfit_Request_Form__c> BRF=[select ID from Benfit_Request_Form__c where Status__c = 'Sold' AND Opportunity__c in: setOpportunityId limit 1];
        if(oppList != null && oppList.size()>0){
            for(Opportunity opt: oppList)
            {  
                if(BRF.size() < 1)
                {
                    if(opt.StageName  == 'Sold')
                    {
                        //T07 - Start - Added if check
                        if(!hasSkipBRFVRs_CustPerm||!IgnoreValidations){
                        //  User can mark the Opportunity as sold  if there is a Benefit Request Form marked as sold
                        opt.adderror('There are no "Sold" Benefit Request Forms under it');
                            }
                        //T07 -End
                    }
                }
            }
        }
    }
    
    ///Chida 09/16/2016
    public void AIA_Update_Underwriter_TeamMember(List<Opportunity> listOppty)
    {
        //Get Opportunity Id 
        Id opptwohundredplusId = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId; // Record Id for the 200+ Opportunity        
        Set<Id> setOpportunityId=new Set<Id>();
        list<Opportunity> oppList = new list<Opportunity>();     
        for(Opportunity opp:listOppty){
            if(opp.RecordTypeId == opptwohundredplusId ){
                setOpportunityId.add(opp.id);
                oppList.add(opp);
            }
        }  
        Set<Id> setAccountId=new Set<Id>();
        for(Opportunity opt : oppList)
        {
            //Get Account Id's
            setAccountId.add(opt.Accountid);
        }
        System.Debug('>>>> the value of Account id is ' + setAccountId); 
        List<string> accRoleName = New List<String>{UNDERWRITER};
            Map<String,String> mapRoleWithUserId = new Map<String,String>();
        Map<String,Integer> mapRoleWithCount = new Map<String,Integer>();
        Integer Underwriter1 = 0;
        
        /* T10 -- Start */
        /*For(AccountTeamMember accTeam : [select UserId,AccountId,TeamMemberRole from AccountTeamMember where AccountId IN : setAccountId and TeamMemberRole IN: accRoleName]){
            mapRoleWithUserId.put(accTeam.TeamMemberRole,accTeam.UserID);
            If(accTeam.TeamMemberRole == UNDERWRITER){
                Underwriter1++;
                mapRoleWithCount.put(accTeam.TeamMemberRole,Underwriter1);
            }
        }*/
        For(Account_Team__c accTeam : [select UserId__c,AccountId__c,TeamMemberRole__c from Account_Team__c where AccountId__c IN : setAccountId and TeamMemberRole__c IN: accRoleName]){
            mapRoleWithUserId.put(accTeam.TeamMemberRole__c ,accTeam.UserId__c);
            If(accTeam.TeamMemberRole__c == UNDERWRITER){
                Underwriter1++;
                mapRoleWithCount.put(accTeam.TeamMemberRole__c,Underwriter1);
            }
        }
        /* T10 -- End */
        System.Debug('>>>> the value of Underwriter Value ' + Underwriter1); 
        for(Opportunity opt : oppList)
        {
            if( mapRoleWithUserId != null && !mapRoleWithUserId.isEmpty())
            {
                if(mapRoleWithUserId.containskey(UNDERWRITER))
                {
                    if(mapRoleWithCount != null && mapRoleWithCount.containsKey(UNDERWRITER) && mapRoleWithCount.get(UNDERWRITER) == 1) // if mapRoleWithCount is 1, then assigning the values
                        opt.UnderwriterUser__c = mapRoleWithUserId.get(UNDERWRITER);
                    else if(mapRoleWithCount != null && mapRoleWithCount.containsKey(UNDERWRITER) && mapRoleWithCount.get(UNDERWRITER) != 1){ // if mapRoleWithCount is not 1, then throwing the error
                        opt.addError(ERROR2 + ' ' + UNDERWRITER+ '. ' + ERROR3);
                    }
                }
            }               
            if(Underwriter1 == 0)
                opt.addError(ERROR1 + UNDERWRITER);
            
            else{
                if(Underwriter1 == 0)
                    opt.addError(ERROR1 + UNDERWRITER);
            }          
            
        }
    }
    
    public static Id RecType200Plus = QueryBase.getRecordTypeId('Opportunity', 'AIA_200');
    /**************-----------------Method to create implementations-----------------**************/
    public static Boolean createImplementation(list<opportunity> opportunityList, Map<id,opportunity> oppOldMap, Boolean firstRun){              
        system.debug('@@ in createImplementation');
        list<Benfit_Request_Form__c> brfList = [SELECT id,name,Status__c,Opportunity__c,Sub_Group_Account__c,Account__r.Has_Sub_Groups__c,
                                                        (SELECT Id,Sub_Group_Account__c FROM Proposed_Products__r)
                                                FROM Benfit_Request_Form__c  
                                                WHERE Opportunity__c in: opportunityList and Status__c = 'Sold'];
        map<id,list<Benfit_Request_Form__c>> mapOppId_BRFlist = new map<id,list<Benfit_Request_Form__c>>();//T02
        
        //for loop to populate map of opportunity versus corresponding list of benefit request forms
        for(opportunity opp: opportunityList){
            for(Benfit_Request_Form__c brf:brfList){
                if(brf.Opportunity__c==opp.id){
                    //T02-Start
                    if(mapOppId_BRFlist.containsKey(opp.id)) {
                        mapOppId_BRFlist.get(opp.id).add(brf);
                    }
                    else {
                        list<Benfit_Request_Form__c> tempBrfList = new list<Benfit_Request_Form__c>();
                        tempBrfList.add(brf);
                        mapOppId_BRFlist.put(opp.id,tempBrfList);
                    }
                    //T02-End
                }   
            }
        }
        system.debug('@@ opportunityList'+opportunityList);
        list<AIA_Implementation__c> PSIlist = new list<AIA_Implementation__c>();
        set<Id> PPsetDupeCheck = new set<Id>();//set used to check for duplicates
        boolean alreadySold;
        AIA_Implementation__c imp;

        for(opportunity opp: opportunityList){
            alreadySold = false; 
            if(oppOldMap!=null){ 
                if(oppOldMap.get(opp.id).stageName=='Sold')
                    alreadySold=true;       
                //system.debug('@@ alreadySold'+alreadySold);     
            }
            
            if(opp.recordtypeId==RecType200Plus && opp.stageName=='Sold' && (!alreadySold)){ 
                /*T02 - if there are multiple sold BRFs for an opportunity, then implementation is created for all of them*/
                if(mapOppId_BRFlist.containsKey(opp.id)) {//T02
                    for(Benfit_Request_Form__c brf : mapOppId_BRFlist.get(opp.id)) {//T02
                        PPsetDupeCheck.clear();
                        //system.debug('@@ inside if stage sold'); 
                        //Condition to check if BRF is related to an Account with Sub-Groups
                        if(String.isNotBlank(brf.Account__c) && brf.Account__r.Has_Sub_Groups__c) {
                            //If condition to check if it is multiple BRFs for Parent Account, each specific to a Sub Group Account
                            if(String.isNotBlank(brf.Sub_Group_Account__c)) {
                                imp = initializeImplementation(brf.Sub_Group_Account__c, opp.AccountId, opp.Id, brf.Id, opp.name, opp.Description);
                                PSIlist.add(imp);
                            }
                            //Else condition to check if it is multiple BRFs for Parent Account, each specific to a Sub Group Account
                            else {
                                list<Proposed_Products__c> lstPP = brf.Proposed_Products__r;
                                if(lstPP.size()>0) {
                                    //Create implementations for all proposed products which have unique sub group accounts
                                    for(Proposed_Products__c pp : lstPP) {
                                        if(!PPsetDupeCheck.contains(String.valueOf(pp.Sub_Group_Account__c))) {
                                            imp = initializeImplementation(pp.Sub_Group_Account__c, opp.AccountId, opp.Id, brf.Id, opp.name, opp.Description);
                                            PPsetDupeCheck.add(String.valueOf(pp.Sub_Group_Account__c));
                                            PSIlist.add(imp);
                                        }
                                        //system.debug('PPsetDupeCheck---'+PPsetDupeCheck);
                                    }
                                }
                            }
                        }
                        else {
                            imp = initializeImplementation(opp.AccountId, NULL, opp.Id, brf.Id, opp.name, opp.Description);
                            PSIlist.add(imp);
                        }
                    }//end for
                }//end if
            }//end if
        }//end for
        system.debug('@@ PSIlist'+PSIlist);
        if(PSIlist.size()>0){
            firstRun =true;
            try {
                insert PSIlist;
            }
            catch(DMLException ex) {
                opportunityList[0].addError(ex.getDmlMessage(0));
            }
        }
        return firstRun;
    }
    
    /** Method to set implementation record fields and return the same **/
    public static AIA_Implementation__c initializeImplementation(Id acntID, Id parentAcntID, Id oppID, Id brfID, String strName, String strDescription) {
        AIA_Implementation__c psi = new AIA_Implementation__c();
        psi.name__c = strName;
        psi.Description__c = strDescription;
        psi.Status__c ='Not Started';
        psi.Account__c = acntID;
        psi.Parent_Account__c = parentAcntID; 
        psi.Benefit_Request_Form__c = brfID;
        psi.Opportunity__c = oppID;
        return psi;
    }
    
//T05 - Start.
  Public Void AIA_Verify_AccountTeamMember(List<Opportunity> listOppty){
      List<opportunity> OpptoUpdate = new List<opportunity>();
      //Set to save Account ID's
      Set<String> accids = new Set<String>();
        Map<String,String> mapAccIDTeamNameToCount = new Map<String,String>(); 
        for(Opportunity opp:listOppty){
            if(opp.RecordTypeId == opp200Id){
            //Get Accid's if Opp recordtype is 200+;    
            accids.add(opp.Accountid);
            }
        }
      //List of AccountTeams availble from the Set of Accid's  
      /* T10 -- Start */
    /*  List<AccountTeamMember> ATMList = [select Userid,user.name,TeamMemberRole,accountid  from AccountTeamMember WHERE accountid In: accids]; 
        if(!ATMList.ISEMPTY()){
        for(AccountTeamMember accTeamMem:ATMList)
        {
            if(accTeamMem.TeamMemberRole !=null)
            {
                //If Account Team not present in the Account Team Role.
                String AccAndTeamRole = accTeamMem.accountid + '#' + accTeamMem.TeamMemberRole ;
                    if(mapAccIDTeamNameToCount.containskey(AccAndTeamRole))
                    {
                        
                        //If Account Team present Twice once in the Account Team Role.
                        mapAccIDTeamNameToCount.put(AccAndTeamRole,'2# ' );
                    }
                    else{
                    //If Account Team present only once in the Account Team Role.
                    mapAccIDTeamNameToCount.put(AccAndTeamRole,'1#'+accTeamMem.Userid );
                    }
                }  
            }
        }*/
         List<Account_Team__c> ATMList = [select UserId__c,UserId__r.name,TeamMemberRole__c,accountid__c  from Account_Team__c WHERE accountid__c In: accids]; 
        if(!ATMList.ISEMPTY()){
        for(Account_Team__c accTeamMem:ATMList)
        {
            if(accTeamMem.TeamMemberRole__c !=null)
            {
                //If Account Team not present in the Account Team Role.
                String AccAndTeamRole = accTeamMem.accountid__c + '#' + accTeamMem.TeamMemberRole__c ;
                    if(mapAccIDTeamNameToCount.containskey(AccAndTeamRole))
                    {
                        
                        //If Account Team present Twice once in the Account Team Role.
                        mapAccIDTeamNameToCount.put(AccAndTeamRole,'2# ' );
                    }
                    else{
                    //If Account Team present only once in the Account Team Role.
                    mapAccIDTeamNameToCount.put(AccAndTeamRole,'1#'+accTeamMem.Userid__c );
                    }
                }  
            }
        }
        
        /* T10 -- End*/
        for(Opportunity opp:listOppty){
            if(opp.RecordTypeId == opp200Id){ //Recordtype check
               opportunity oppupdate = new opportunity(id=opp.id); 
                String AE = '0# ';//ACCOUNTEXECUTIVE
                String AM = '0# ';//ACCOUNTEXECUTIVE
                String PS = '0# ';//PROPOSALSPECIALIST
                
                ID AMUser;
                ID AEUser;   
                
                string AccAndAE = opp.Accountid + '#' + AIA_Constants.ACCOUNTEXECUTIVE;
                string AccAndPS = opp.Accountid + '#' + AIA_Constants.PROPOSALSPECIALIST;
                string AccAndAM = opp.Accountid + '#' + ACCOUNTMANAGER;
                
                String NoATM = '';
                String DupATM = '';
                //Check if related account has specified AccountTeamMember assigned in Account Team Role.
                if(mapAccIDTeamNameToCount.containskey(AccAndAE))
                {
                    AE = mapAccIDTeamNameToCount.get(AccAndAE);
                }
                if(mapAccIDTeamNameToCount.containskey(AccAndPS))
                {
                    PS = mapAccIDTeamNameToCount.get(AccAndPS);
                }
                 if(mapAccIDTeamNameToCount.containskey(AccAndAM))
                {
                    AM = mapAccIDTeamNameToCount.get(AccAndAM);
                }
                
                
                //Split AIA_VerifyATM result.
                String [] AEstring = AE.split('#');            //ACCOUNTEXECUTIVE
                Integer AECount = Integer.valueof(AEstring[0]);
                if(!String.ISBLANK(AEstring[1]))
                AEUser = ID.valueof(AEstring[1]);
                
                //If result ==  0 means no Account Team Member with specified role.
                if(AECount == 0){
                    NoATM = AIA_Constants.ACCOUNTEXECUTIVE;
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(AECount > 1){
                    DupATM =  AIA_Constants.ACCOUNTEXECUTIVE;
                }
                /* T09 Start
                if(AECount == 1){
                    opp.AIA_Lead_Rep_Name__c =  AEUser;      //T06   
                } T09 Ends*/
                
                String [] PSstring = PS.split('#');
                Integer PSCount = Integer.valueof(PSstring[0]);
                //If result ==  0 means no Account Team Member with specified role.
                if(PSCount == 0){
                    if(NoATM != '' ){
                    NoATM = NoATM + ', ' + AIA_Constants.PROPOSALSPECIALIST;
                    }
                    else{
                    NoATM = AIA_Constants.PROPOSALSPECIALIST;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(PSCount > 1){
                    if(DupATM != '' ){
                    DupATM = DupATM + ', ' + AIA_Constants.PROPOSALSPECIALIST;
                    }
                    else{
                    DupATM = AIA_Constants.PROPOSALSPECIALIST;
                    }
                }
                //Account Manager
                String [] AMstring = AM.split('#');
                Integer AMCount = Integer.valueof(AMstring[0]);
                if(!String.ISBLANK(AMstring[1]))
                AMUser = ID.valueof(AMstring[1]);
                //If result ==  0 means no Account Team Member with specified role.
                if(AMCount == 0){
                    if(NoATM != '' ){
                    NoATM = NoATM + ', ' + ACCOUNTMANAGER;
                    }
                    else{
                    NoATM = ACCOUNTMANAGER;
                    }
                }
                //If result > 1 means Duplicate Account Team Member with specified role.
                if(AMCount > 1){
                    if(DupATM != '' ){
                    DupATM = DupATM + ', ' + ACCOUNTMANAGER;
                    }
                    else{
                    DupATM = ACCOUNTMANAGER;
                    }
                }
                /* T09 Starts
                if(AMCount == 1){ 
                    if(opp.Service_Rep_s__c==null)// Added condition as a part of T08
                    opp.Service_Rep_s__c =  AMUser;      //T06   
                } T09 Ends */
                
                //Do not throw error message if Ignore Validations is present.
                If(!IgnoreValidations){   
                   //If No duplicate Account Team Member present & No required Account Team member.
                   if(!String.ISBLANK(NoATM) && String.ISBLANK(DupATM)){
                       opp.adderror(ERROR1 + ' ' + NoATM);
                   } 
                   //If required Account Team member present & duplicate Account Team Member.
                   if(!String.ISBLANK(DupATM) && String.ISBLANK(NoATM)){
                       opp.adderror(ERROR2 + ' ' + DupATM + ' ' + ERROR3);
                   }
                   //If Account has Duplicate Account Team Member & does not have required Account Team member.
                   if(!String.ISBLANK(DupATM) && !String.ISBLANK(NoATM)){
                       opp.adderror(ERROR1 + ' ' + NoATM + ' & ' + ERROR2 + ' ' + DupATM + ' ' + ERROR3);
                   }
               }
               opptoupdate.add(oppupdate); 
            }    
        }
        if(!opptoupdate.ISEMPTY()){
            //update opptoupdate;
        }    
    }
//T05 - END.

}