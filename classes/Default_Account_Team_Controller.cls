/* 
   *===================================================================================================
   * Date         : 02/20/2019
   * Developer    : Gayathri Palanisamy
   * Purpose      : This is the Controller for Default_Account_Team_Add VF page .
   *===================================================================================================
   *                                 Update History
   *                                 ---------------
   * Date          Developer     Tag   Description
   *===================================================================================================
   * 02/20/2019 |  Gayathri |         | Initial Version
   *===================================================================================================
   */

public class Default_Account_Team_Controller {
    public List<Default_Account_Team__c> addAccountTeamLst{get;set;}
    public List<Default_Account_Team__c> viewAccountTeamLst{get;set;}
    
    public static boolean addTeam{get;set;}
    public static boolean viewAllRec{get;set;}
    public static boolean isInRelatedLst{get;set;}
    public static boolean displayPopUp{get;set;}
    public string userId{get;set;}
    public Default_Account_Team_Controller(ApexPages.StandardController controller)
    {
        system.debug('Inside Constructor');	
        User datm = (User)controller.getRecord();
        userId = datm.id;
        if(userId == null)
        {
            userId = Apexpages.currentPage().getParameters().get('userId') ;  
        }
        system.debug('userId'+userId);
        
        isInRelatedLst = (Apexpages.currentPage().getParameters().get('relatedLst') == 'false'?false:true);
        viewTeamMember();
        addTeam = (Apexpages.currentPage().getParameters().get('addTeam') == 'true' ?true:false);
        
        system.debug('addTeam@@@@'+addTeam);	 
        
        if(addTeam)
        {
            
            addAccountTeamLst = new List<Default_Account_Team__c>();
            for(integer i=1;i<=5;i++){               
                Default_Account_Team__c newAtm = new Default_Account_Team__c();
                newAtm.OwnerId = userId;
                newAtm.Account_Access__c = 'Read/Write';
                newAtm.Contact_Access__c = 'Read Only';
                newAtm.Opportunity_Access__c = 'Read/Write';
                newAtm.Case_Access__c = 'Private';
                addAccountTeamLst.add(newAtm);
                system.debug('ghjgj');
            }
            
        }
        
        system.debug('Inside add team1'+addAccountTeamLst);
        
        
    }
    
    public void viewTeamMember()
    {
        viewAccountTeamLst = new List<Default_Account_Team__c>();
        String queryATM  = 'SELECT Id, UserId__c, Team_Role__c, Contact_Access__c, Account_Access__c,'+ 
            'Opportunity_Access__c, Case_Access__c,UserId__r.Name,OwnerId FROM Default_Account_Team__c where ownerId=:userId';
        viewAccountTeamLst =(List<Default_Account_Team__c>)Database.query(queryATM);
    }
    
    public PageReference saveDATM()
    {
        system.debug('Inside save');
        List<Default_Account_Team__c> recordsToInsertLst = new List<Default_Account_Team__c>();
        Map<string,Default_Account_Team__c> recordsToInsertMap = new Map<string,Default_Account_Team__c>();
        system.debug('addAccountTeamLst'+addAccountTeamLst);
        
        Map<Id,List<String>> existingMemberMap = new Map<Id,List<string>>();
        for(Default_Account_Team__c DAT : viewAccountTeamLst)
        {
           if(existingMemberMap.containsKey(DAT.UserId__c))
           {
               existingMemberMap.get(DAT.UserId__c).add(DAT.Team_Role__c);
           }
            else
            {
                existingMemberMap.put(DAT.UserId__c,new List<string>{DAT.Team_Role__c});
            }
        }
        
        
        for(Default_Account_Team__c atm:addAccountTeamLst)
        {
            if(!(existingMemberMap != null && existingMemberMap.containsKey(atm.UserId__c) 
               && existingMemberMap.get(atm.UserId__c).contains(atm.Team_Role__c)) && (atm.UserId__c != null && atm.Team_Role__c!=null))
            {
            	// recordsToInsertLst.add(atm);
                recordsToInsertMap.put(atm.UserId__c+atm.Team_Role__c,atm);
            }
        }
        system.debug('recordsToInsertLst'+recordsToInsertLst);
        try{
           if(!recordsToInsertMap.isEmpty())
        {
            insert recordsToInsertMap.values();
        } 
        }
        catch(Exception e)
        {
            system.debug('Error Occured. Exception Details:'+e.getMessage());
        }
        PageReference pageRef = new PageReference('/'+userId);
        return pageRef;
    }
    
    public PageReference cancelDATM()
    {
        PageReference pageRef = new PageReference('/'+userId);
        return pageRef; 
    }
    public PageReference enableAllRec()
    {
        PageReference pageRef = new PageReference('/apex/Default_Account_Team_Add');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('addTeam','true');
        pageRef.getParameters().put('relatedLst','false');
        PageRef.getParameters().put('userId',userId);
        return pageRef; 
    }
    
    public void showPopup(){
        displayPopUp = true;
    }
    //Method to cancel popup
    public void cancelTeamPop(){
        displayPopUp = false;
    }
    
    public pagereference deleteAccTM()
    {
        String AccTMid =  ApexPages.currentPage().getParameters().get('atmid');
        system.debug('Delete ATM'+AccTMid);
        List<Default_Account_Team__c> lstatm = [Select id from Default_Account_Team__c where id =:AccTMid];
        if(lstatm !=null && lstatm.size()>0){
            delete lstatm;
            
        }
        displayPopUp = false;
        return null;
        
    } 
    
    
}