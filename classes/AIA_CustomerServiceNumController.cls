/*=================================================================================================
* Date         : 03/23/2018
* Developer    : Rajehs Pennam
* Purpose      : This class contains logic is to create Customer Service Number 
*                Details depending on the ADR Role and AIA Admin Permisson set users
*                
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date         Developer      Tag    Description
*==================================================================================================
* 03/23/2018| Rajesh Pennam     |     | Initial Version, It is the controller class for AIA_CustomerServiceNumber                                        
* 02/01/2019 | Satya T          | T01 | Replaced standard Account Team Member with Custom Account Team Member. 
*==================================================================================================
*/

public with sharing  class AIA_CustomerServiceNumController {
    public List<Customer_Service__c> csnLSt {get;set;}
    public List<Customer_Service__c> csnLStActive {get;set;} // List used for display and process of Inactive records
    public List<Customer_Service__c> csnLStInActive {get;set;} // List used for display and process of active records
    public Id csnid {get;set;}
    Public boolean formdisplay {set;get;}
    public Integer rowToRemove {get;set;} // To remove the row
    //public Integer multipleRowsize {get;set;}
    public boolean showAddPkg{get;set;}
    public final Account acct;
    public boolean isClassic {get;set;} // This is used to render the Theme 3 and work in both classic and lightning
    public boolean hasCreateOpt {get;set;}
    public Boolean displayPopUp{get; set;}
    
    //Constructor
    public AIA_CustomerServiceNumController(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
        system.debug('acct**'+acct);
        system.debug('in const#################');
        csnLSt = new List<Customer_Service__c>();
        csnLStActive = new List<Customer_Service__c>();
        csnLStInActive = new List<Customer_Service__c>();
        showAddPkg = false;
        hasCreateOpt = false;
        formdisplay = true;
        Customer_Service__c csn = new Customer_Service__c();
        isClassic = AIA_Utils.isClassic();
        accessValid();
        displayPopUp = false;
        
               
                             
    }
    
    
    // User with AIA Admin Permission Set or User with Account Dedicated Rep Role should be able to edit/delete records remainig all users should have only readonly access
        
    
    public void accessValid(){
        Map<string ,String> aiaMap = new Map<String,String>();
        List<AIA_Configurations__mdt> aiaList = [SELECT id,DeveloperName,Parameter_Value__c FROM AIA_Configurations__mdt WHERE DeveloperName IN ('X51Profile','ADR','AIARul','AIA_Admin','X200Permission')];
        for(AIA_Configurations__mdt aiaRec : aiaList)
        {
            aiaMap.put(aiaRec.DeveloperName , aiaRec.Parameter_Value__c);              
        }
        //Integer temcont = [SELECT count() FROM AccountTeamMember where AccountId =: acct.id and TeamMemberRole =:aiaMap.get('ADR') and UserId =:userInfo.getUserid()];T01
          Integer temcont = [SELECT count() FROM Account_Team__c where AccountId__c =: acct.id and TeamMemberRole__c =:aiaMap.get('ADR') and UserId__c =:userInfo.getUserid()]; //T01
        
        if(temCont==0){
            integer psCont;
            psCont = [SELECT count() FROM PermissionSetAssignment WHERE PermissionSet.name =:aiaMap.get('AIA_Admin') and AssigneeId =: USerinfo.GetUSerid()];
                     
            if(pscont >0){           
                hasCreateOpt = true;              
            } 
        }
        Else{
            hasCreateOpt = true;
        }
        
         // Commented this since 51 users wants to see the screen          
        /*integer psCont2 = [SELECT count() FROM user where id =:userinfo.getuserid() and Profile.name=:aiaMap.get('X51Profile')];                 
        if(psCont2 >0){
            Integer psContread = [SELECT count() FROM PermissionSetAssignment WHERE (PermissionSet.name =:aiaMap.get('X200Permission') OR PermissionSet.name =:aiaMap.get('AIARul')) and AssigneeId =: USerinfo.GetUSerid()];
                formdisplay = psContread>0;   
        } */
        
        
    }
    
   //This method to redirect to new page
   
   public pagereference addRowRedirect(){  
     
     String accid = apexpages.currentpage().getparameters().get('id');
     pagereference pr = new Pagereference('/apex/AIA_Customer_Service_Redirect?id='+accid);
     pr.setRedirect(false);
     return pr;
   }
   
   // This method is used to redirect to Accounts Detail Page
   public pagereference addrowcancel(){  
     
     String accid = apexpages.currentpage().getparameters().get('id');
     pagereference pr = new Pagereference('/'+accid);
     pr.setRedirect(true);
     return pr;
   }
   
   
    // This method is used to add the row 
    public void addrow() {
        showAddPkg = true;
        Customer_Service__c csnNewRow = new Customer_Service__c();
        csnNewRow.Account__c =acct.id; 
        csnLSt.add(csnNewRow);
    }
    
    //This method to remove row in the line items
    public void removerow(){
        Integer i = csnLSt.size();
        if(i>0){
            csnLSt.remove(i-1);
        }
    }
    /*public void multipleRows(){
        for(integer i=0;i<multipleRowsize;i++){
            addrow();
        }
    }*/
    
    public void removeRowFromList(){
        Integer i = csnLSt.size();
        if(i>0){
        csnLSt.remove(rowToRemove-1);
        }
    }

    //This method to save records in the redirected page
    public PageReference saveRec() {
        try{
            insert csnLSt ;
            system.debug('CSN****'+csnLSt);
            showAddPkg = false;
            csnLSt.clear();
            //PageReference home = new PageReference('/apex/AIA_CustomerServiceNumber');
            //home.setRedirect(false);
            //refreshCNSNew();
            displayPopUp = true;
            return null;
        }
        catch(exception e){
            system.debug('exception***'+e.getMessage());
            //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            //ApexPages.addMessage(msg);
            return null;
        }
    }
    
    
    //This method to redirect to accounts page
    public PageReference cancelRec() {
        showAddPkg = false;
        csnLSt.clear();
        PageReference home = new PageReference('/apex/AIA_CustomerServiceNumber');
        home.setRedirect(true);
        return null;
    }

     public PageReference refreshCNSNew() {
         system.debug('in refrsh csNew');
        refresh();
        InActrefresh();
         return null;
    }
    
    
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
    public ApexPages.StandardSetController setCon {
        
        get{
            String accid = apexpages.currentpage().getparameters().get('id');
            if(setCon == null){
                size = 10;
                string queryString = 'SELECT Id, Name,Account__c,Area__c,Other_Area__c,Comments__c,Effective_Date__c,Phone_Number__c,Service_Hours__c,Service_Number__c,Term_Date__c FROM Customer_Service__c where Term_Date__c = null and account__c = :accid ORDER BY sequence__c';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }set;
    }
     
    Public List<Customer_Service__c> getActiveCSN(){
        csnLStActive = new List<Customer_Service__c>();
        for(Customer_Service__c a : (List<Customer_Service__c>)setCon.getRecords())
            csnLStActive.add(a);
        return csnLStActive;
    }
     
    public pageReference refresh() {
        setCon = null;
        getActiveCSN();
        setCon.setPageNumber(1);
        return null;
    }
    
    //This code is used to display and process records in Inactive Tab
    
        Public Integer inActnoOfRecords{get; set;}
    Public Integer inActsize{get;set;}
    public ApexPages.StandardSetController inActSetCon {
        get{
             String accid = apexpages.currentpage().getparameters().get('id');
            if(inActSetCon == null){
                inActsize = 10;
                string queryString = 'SELECT Id, Name,Account__c,Area__c,Other_Area__c,Comments__c,Effective_Date__c,Phone_Number__c,Service_Hours__c,Service_Number__c,Term_Date__c FROM Customer_Service__c where Term_Date__c != null and Account__c =:accid ORDER BY sequence__c';
                inActSetCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                inActSetCon.setPageSize(inActsize);
                inActnoOfRecords = inActSetCon.getResultSize();
            }
            return inActSetCon;
        }set;
    }
     
    Public List<Customer_Service__c> getInActiveCSN(){
        csnLStInActive = new List<Customer_Service__c>();
        for(Customer_Service__c a : (List<Customer_Service__c>)inActSetCon.getRecords())
            csnLStInActive.add(a);
        return csnLStInActive;
    }
     
    public pageReference InActrefresh() {
        inActSetCon = null;
        getInActiveCSN();
        inActSetCon.setPageNumber(1);
        return null;
    }
    
    //This function is used for Inline edit
   public PageReference save1() {
         system.debug('csnLStActive***'+csnLStActive);
         try{
         update csnLStActive;
         refreshCNSNew();
         return null;
       }
       catch (exception e){
        //PageReference home = new PageReference('/apex/AIA_CustomerServiceNumber');
        //home.setRedirect(true);
        system.debug('exception***'+e.getMessage());
           // ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
           // ApexPages.addMessage(msg);
        return null;  
        }  
    }
    
    // THis function is for saving the records in active panel
   public PageReference saveinAct() {
         system.debug('csnLStInActive***'+csnLStInActive);
         try{
         update csnLStInActive;
       refreshCNSNew();
        //PageReference home = new PageReference('/apex/AIA_CustomerServiceNumber');
        //home.setRedirect(true);
        return null;
        }
        catch(exception e){
            system.debug('exception***'+e.getMessage());
            //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            //ApexPages.addMessage(msg);
        return null;
        
        }    
    } 
    
    
    //This is used for deleting the record in Active/Inactive tab
    public void deleteRec(){
        String myId = System.currentPageReference().getParameters().get('recid');   
        system.debug('myId***'+myId);
        Customer_Service__c cs= new Customer_Service__c (id=myID);
        system.debug('cs***'+cs);
        delete cs;     
        refreshCNSNew();
         
    }
    
    public PageReference refreshRedirect() {
        PageReference home = new PageReference(ApexPages.currentPage().getUrl());
        home.setRedirect(true);
        return home;
    }
    
}