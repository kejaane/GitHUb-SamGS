/*=========================================================================================
 * Date     : 06/16/2016
 * Developer    : Sree Harsha Akkala
 * Purpose      : This class is the extension point of the Trigger Framework for adding Contract trigger handlers.
 *                
 *               
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer        Tag               Description
 *===========+============+================================================================
 * 06/16/2016  |  HA       | Initial Version                                         
 * 01/29/2019  |  Satya T  | T01              | Changed the Account Team member references  
 *                                                      from Standard to Custom object 
 *===========+============+================================================================
 */
 
/**
* @This class is invoked from ContractTrigger 
*/ 
 
public with sharing class AIA_ContractTriggerHandler extends TriggerHandler {
public AIA_ContractTriggerHandler() {}
public static boolean firstRun=false;
 protected override void afterInsert(){
     if(!firstRun)
     validateContract((list<contract>) trigger.new);
 }
 protected override void afterUpdate(){
     if(!firstRun)
     validateContract((list<contract>) trigger.new);
 }
 
 /**
* @Author: Sree Harsha Akkala
* @This Method is called from ContractTrigger during insertion or updation of Contract
* @This method - The method validates the contract to see if the approvers are present in the respective Account team.
* @param -  list<contract> 
* @Output - Display an error message if there are no account team roles associated with the approvers.
*/
public static void validateContract(list<contract> contractList){
    try{
        system.debug('@@ in validateContract list'+contractList);
        set<id>implementationIdSet = new set<id>();
        for(contract contractRec: contractList){
             if(contractRec.Implementation__c!=null){
                 implementationIdSet.add(contractRec.Implementation__c);
             }
        }
         //Map<id,Implementation__c> implementationAccMap = new Map<id,implementation__c>([select id,name,account__c from implementation__c where id in:implementationIdSet]);
        List<contract> finalContractList = [select id,name,implementation__c,implementation__r.account__c from contract where id  in:contractList];
        system.debug('@@ in finalContractList '+finalContractList );
        set<id> accIdSet = new set<id>();
        for(contract cont: finalContractList){
            if(cont.implementation__r.account__c!=null)
            accIdSet.add(cont.implementation__r.account__c);        
        }
        //Map<id, Account> acctsWithTeams = new Map<id, Account>([Select Id, (Select Id, AccountId From AccountTeamMembers ) From Account Where Id in :accIdSet]);
     
     //T01 changes start
     /*   list<AccountTeamMember> accountTeamList = [select id,AccountId,TeamMemberRole,UserId from AccountTeamMember where accountId in :accIdSet];
        system.debug('@@AccountId'+accIdSet);

        system.debug('@@accountTeamList'+accountTeamList);
        Map<id,AccountTeamMember> accountTeamMemberMap = new Map<id,AccountTeamMember>();   
        for(accountTeamMember atm: accountTeamList){
            accountTeamMemberMap.put(atm.AccountId,atm);
        }*/
        
         list<Account_Team__c> accountTeamList = [select id,AccountId__c,TeamMemberRole__c,UserId__c from Account_Team__c where AccountId__c in :accIdSet];
        system.debug('@@AccountId'+accIdSet);

        system.debug('@@accountTeamList'+accountTeamList);
        Map<id,Account_Team__c> accountTeamMemberMap = new Map<id,Account_Team__c>();   
        for(Account_Team__c atm: accountTeamList){
            accountTeamMemberMap.put(atm.AccountId__c,atm);
        }
        //T01 changes End
        
        Map<id,boolean> contractAccountTeamMap = new Map<id,boolean>();
        Map<id,string> contractMissedRolesMap = new Map<id,string>();
        Map<id,string> contractExcessRolesMap = new Map<id,string>();
        Map<id,boolean> countAccountTeamMap = new Map<id,boolean>();
                 boolean hasCompleteAccountTeam;
        for(contract con:finalContractList){
            hasCompleteAccountTeam = false;     
            integer AuditCount=0;
            integer CCCount=0;
            integer ContractSupervisorCount=0;
            integer LegalCount=0;
            integer SalesServiceRepCount=0;
            
            //T01 changes start
       /*     for(AccountTeamMember atm: accountTeamList){ 
            if(atm.AccountId==con.implementation__r.account__c){
                con.AccountId=con.implementation__r.account__c;
                if(atm.TeamMemberRole==AIA_Constants.AUDIT){
                    system.debug('@@ in teamRole Audit');
                    con.Approver_Audit__c=atm.UserId;
                    AuditCount++;               
                }           
                if(atm.TeamMemberRole==AIA_Constants.CC_CONTACT){  
                    con.Approver_C_C__c=atm.UserId;
                    CCCount++;
                }
                if(atm.TeamMemberRole==AIA_Constants.CONTRACT_SUPERVISOR){
                    con.Approver_Contract_Supervisor__c=atm.UserId;
                    ContractSupervisorCount++;
                }
                if(atm.TeamMemberRole==AIA_Constants.LEGAL){
                    con.Approver_Legal__c=atm.UserId;    
                    LegalCount++;
                }
                
                if(atm.TeamMemberRole==AIA_Constants.SALES_SERVICE_REP){
                    con.Approver_Sales_Service_Rep__c=atm.UserId;   
                    SalesServiceRepCount++;
                }}
            }*/
            
             for(Account_Team__c atm: accountTeamList){ 
                if(atm.AccountId__c==con.implementation__r.account__c){
                    con.AccountId=con.implementation__r.account__c;
                    if(atm.TeamMemberRole__c==AIA_Constants.AUDIT){
                        system.debug('@@ in teamRole Audit');
                        con.Approver_Audit__c=atm.UserId__c;
                        AuditCount++;               
                    }           
                    if(atm.TeamMemberRole__c==AIA_Constants.CC_CONTACT){  
                        con.Approver_C_C__c=atm.UserId__c;
                        CCCount++;
                    }
                    if(atm.TeamMemberRole__c==AIA_Constants.CONTRACT_SUPERVISOR){
                        con.Approver_Contract_Supervisor__c=atm.UserId__c;
                        ContractSupervisorCount++;
                    }
                    if(atm.TeamMemberRole__c==AIA_Constants.LEGAL){
                        con.Approver_Legal__c=atm.UserId__c;    
                        LegalCount++;
                    }
                    
                    if(atm.TeamMemberRole__c==AIA_Constants.SALES_SERVICE_REP){
                        con.Approver_Sales_Service_Rep__c=atm.UserId__c;   
                        SalesServiceRepCount++;
                    }}
            }
            
            //T01 changes end
            
            system.debug('@@ AuditCount,CCCount,ContractSupervisorCount,LegalCount,SalesServiceRepCount'+AuditCount+CCCount+ContractSupervisorCount+LegalCount+SalesServiceRepCount);
            if( AuditCount==1 && CCCount==1 && ContractSupervisorCount==1 && LegalCount==1 && SalesServiceRepCount==1){
                hasCompleteAccountTeam=true;
                contractAccountTeamMap.put(con.id,hasCompleteAccountTeam);
            }
            else{
                string missedRoles='';
                if(AuditCount==0)
                missedRoles=AIA_Constants.Audit;
                if(CCCount==0){
                    if(missedRoles!=null)
                    missedRoles=missedRoles+','+AIA_Constants.CC_CONTACT;
                    else
                    missedRoles=AIA_Constants.CC_CONTACT;
                }
                if(ContractSupervisorCount==0){
                    if(missedRoles!=null)
                    missedRoles=missedRoles+','+AIA_Constants.CONTRACT_SUPERVISOR;
                    else
                    missedRoles=AIA_Constants.CONTRACT_SUPERVISOR;
                }
                if(LegalCount==0){
                    if(missedRoles!=null)
                    missedRoles=missedRoles+','+AIA_Constants.LEGAL;
                    else
                    missedRoles=AIA_Constants.LEGAL;
                }
                if(SalesServiceRepCount==0){
                    if(missedRoles!=null)
                    missedRoles=missedRoles+','+AIA_Constants.SALES_SERVICE_REP;
                    else
                    missedRoles=AIA_Constants.SALES_SERVICE_REP;
                }
                if(missedRoles!=null){
                    if(missedRoles.startsWith(','))
                    missedRoles=missedRoles.substring(1,missedRoles.length());
                    contractMissedRolesMap.put(con.id,missedRoles);
                }
            }
            string excessRoles='';
            if(AuditCount>1)
            excessRoles=AIA_Constants.Audit;
            if(CCCount>1){
                if(excessRoles!=null)
                excessRoles=excessRoles+','+ AIA_Constants.CC_CONTACT;
                else
                excessRoles=AIA_Constants.CC_CONTACT;
            }
            if(ContractSupervisorCount>1){
                if(excessRoles!=null)
                excessRoles=excessRoles+','+ AIA_Constants.CONTRACT_SUPERVISOR;
                else
                excessRoles=AIA_Constants.CONTRACT_SUPERVISOR;
            }
            if(LegalCount>1){
                if(excessRoles!=null)
                excessRoles=excessRoles+','+AIA_Constants.LEGAL;
                else
                excessRoles=AIA_Constants.LEGAL;
            }
            if(SalesServiceRepCount>1){
                if(excessRoles!=null)
                excessRoles=excessRoles+','+ AIA_Constants.SALES_SERVICE_REP;
                else
                excessRoles=AIA_Constants.SALES_SERVICE_REP;
            }
            if(excessRoles!=null){
                if(excessRoles.startsWith(','))
                excessRoles=excessRoles.substring(1,excessRoles.length());
                contractexcessRolesMap.put(con.id,excessRoles);
            }
            
                
        }           
        
        for(contract finalCon:contractList){
            system.debug('@@missedRoleMap'+contractMissedRolesMap.get(finalCon.id));
            system.debug('@@excessRoleMap'+contractexcessRolesMap.get(finalCon.id));
            if(contractMissedRolesMap.get(finalCon.id)!=null)
            finalCon.addError('The '+ contractMissedRolesMap.get(finalCon.id) +' role/roles is not configured on the Account Team. Please assign a user to this role before saving the Benefit Contract');
            if(contractexcessRolesMap.get(finalCon.id)!='' || !(string.isBlank(contractexcessRolesMap.get(finalCon.id))))
            finalCon.addError('There is more than one user configured for the '+ contractexcessRolesMap.get(finalCon.id) +' role/roles on the Account. Please make sure only one user is configured for the'+ contractexcessRolesMap.get(finalCon.id) +'role/roles');
        }
        if(hasCompleteAccountTeam)
        {
            firstRun=true;
            update finalContractList;
        }
    }
    catch(exception e){
        system.debug('@@ in exception '+e.getMessage());
    }
}

}