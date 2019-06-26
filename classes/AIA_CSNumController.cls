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
 * 05/10/2018| Rajesh Pennam     | T02 | Updated the logic to show the Records in Active/Inactive Panels
 * 05/18/2018| Gayathri          | T03 | Added Access for Workforce Management user instead of ADR - 1562 
 * 06/08/2018| Gayathri 		 | T04 | Added logic to display render the page in Account related list
 *==================================================================================================
 */
public without sharing class AIA_CSNumController {
    public static final String WORKFORCE_MANAGEMENT = 'AIA_Workforce_Management';
    public static final String AIA_ADMIN = 'AIA_Admin';
    public static final String SYSTEM_ADMIN = 'System Administrator';
    public List < Customer_Service__c > csnLSt {get;set;}
    public List < Customer_Service__c > csnLStActive {get;set;} // List used for display and process of Inactive records
    public List < Customer_Service__c > csnLStInActive {get;set;} // List used for display and process of active records
    public Id csnid {get;set;}
    Public boolean formdisplay {set;get;}
    public Integer rowToRemove {get;set;} // To remove the row
    //public Integer multipleRowsize {get;set;}
    public boolean showAddPkg {get;set;}
    public final Id acct;
    public final Customer_Service__c custSer;
    public boolean isClassic {get;set;} // This is used to render the Theme 3 and work in both classic and lightning
    public boolean hasCreateOpt {get;set;}
    public Boolean displayPopUp {get;set;}
    public Integer recordsCount {get;set;}
    public Boolean editMode {get;set;}
    public String tabSelected {get;set;}
    public Boolean inactEditMode {get;set;}
    //1562--T04--Start
    public Boolean enablePage {get;set;}
    public string source;
    //T04--End
    //Constructor
    //public AIA_CSNumController(ApexPages.StandardSetController stdController) {
    public AIA_CSNumController() {
        //custSer = (Customer_Service__c) stdController.getRecord();
        acct = ApexPages.currentPage().getParameters().get('id');
        //T04
        source = ApexPages.currentPage().getParameters().get('source');//Url parameter to render the page from inline vf
        system.debug('acct**' + acct);
        system.debug('custSer######' + custSer);
        csnLSt = new List < Customer_Service__c > ();
        csnLStActive = new List < Customer_Service__c > ();
        csnLStInActive = new List < Customer_Service__c > ();
        //1562 - T04-- start
        if(source != null && source == 'CSNum')
        	enablePage = true;
        //1562 - T04-- End
        showAddPkg = false;
        hasCreateOpt = false;
        formdisplay = true;
        Customer_Service__c csn = new Customer_Service__c();
        isClassic = AIA_Utils.isClassic();
        accessValid();
        displayPopUp = false;
        tabSelected = 'Active';
        addrow();
    }

    public void accessValid() {
        Map < string, String > aiaMap = new Map < String, String > ();
        //1562 -T03-- start
        /*Integer temcont = [SELECT count() FROM AccountTeamMember where AccountId =: acct and TeamMemberRole =: aiaMap.get('Workforce_Management') and UserId =: userInfo.getUserid()];
        if (temCont == 0) {*/
        //integer adminCount;
        //adminCount = [SELECT count() From user where id =:userinfo.getuserid() and Profile.name=:SYSTEM_ADMIN];
        //Checks whether the logged in user is a system Admin
        //if(adminCount==0)
        if(!AIA_Utils.checkIf_AIA_Admin_Profile_User())
        {
            system.debug('tercount***0**');
            integer psCont;
            psCont = [SELECT count() FROM PermissionSetAssignment WHERE (PermissionSet.name =: AIA_ADMIN or PermissionSet.name =: WORKFORCE_MANAGEMENT) and AssigneeId =: USerinfo.GetUSerid()];
			//Checks whether the logged in user is either AIA Admin or AIA Workforce Management user
            if (pscont > 0) {
                hasCreateOpt = true;
            }
        }
        Else {
            hasCreateOpt = true;
        }
		//1562 -T03-- End
        // Commented this since 51 users wants to see the screen          
        /*integer psCont2 = [SELECT count() FROM user where id =:userinfo.getuserid() and Profile.name=:aiaMap.get('X51Profile')];                 
        if(psCont2 >0){
        Integer psContread = [SELECT count() FROM PermissionSetAssignment WHERE (PermissionSet.name =:aiaMap.get('X200Permission') OR PermissionSet.name =:aiaMap.get('AIARul')) and AssigneeId =: USerinfo.GetUSerid()];
        formdisplay = psContread>0;   
        } */


    }

    //This method to redirect to new page

    public pagereference addRowRedirect() {

        String accid = apexpages.currentpage().getparameters().get('id');
        pagereference pr = new Pagereference('/apex/AIA_Customer_Service_Redirect?id=' + accid);
        pr.setRedirect(false);
        return pr;
    }

    // This method is used to redirect to Accounts Detail Page
    public pagereference addrowcancel() {

        String accid = apexpages.currentpage().getparameters().get('id');
        pagereference pr = new Pagereference('/' + accid);
        pr.setRedirect(true);
        return pr;
    }


    // This method is used to add the row 
    public void addrow() {
        showAddPkg = true;
        Customer_Service__c csnNewRow = new Customer_Service__c();
        csnNewRow.Account__c = acct;
        csnLSt.add(csnNewRow);
        displayPopUp = false;

    }

    //This method to remove row in the line items
    public void removerow() {
        Integer i = csnLSt.size();
        if (i > 0) {
            csnLSt.remove(i - 1);
        }
    }
    /*public void multipleRows(){
    for(integer i=0;i<multipleRowsize;i++){
    addrow();
    }
    }*/

    public void removeRowFromList() {
        Integer i = csnLSt.size();
        if (i > 0) {
            csnLSt.remove(rowToRemove - 1);
        }
    }

    //This method to save records in the redirected page
    public PageReference saveRec() {
        try {
            insert csnLSt;
            system.debug('CSN****' + csnLSt);
            showAddPkg = false;
            recordsCount = csnLSt.size();
            csnLSt.clear();
            //PageReference home = new PageReference('/apex/AIA_CustomerServiceNumber');
            //home.setRedirect(false);
            refreshCNSNew();
            displayPopUp = true;
            return null;
        } catch (exception e) {
            system.debug('exception***' + e.getMessage());
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


    Public Integer noOfRecords {
        get;
        set;
    }
    Public Integer size {
        get;
        set;
    }
    public ApexPages.StandardSetController setCon {

        get {
            // String accid = apexpages.currentpage().getparameters().get('id');
            if (setCon == null) {
                size = 5;
                //T02 Updated the query
                //string queryString = 'SELECT Id, Name,Account__c,Area__c,Other_Area__c,Comments__c,Effective_Date__c,Phone_Number__c,Service_Hours__c,Service_Number__c,Term_Date__c,Term_Date_Verification__c FROM Customer_Service__c where Term_Date__c = null and account__c = :acct ORDER BY sequence__c';
                string queryString = 'SELECT Id, Name,Account__c,Area__c,Other_Area__c,Comments__c,Effective_Date__c,Phone_Number__c,Service_Hours__c,Service_Number__c,Term_Date__c,Term_Date_Verification__c FROM Customer_Service__c where Term_Date_Verification__c = false and account__c = :acct ORDER BY sequence__c';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }
        set;
    }

    Public List < Customer_Service__c > getActiveCSN() {
        csnLStActive = new List < Customer_Service__c > ();
        for (Customer_Service__c a: (List < Customer_Service__c > ) setCon.getRecords())
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

    Public Integer inActnoOfRecords {
        get;
        set;
    }
    Public Integer inActsize {
        get;
        set;
    }
    public ApexPages.StandardSetController inActSetCon {
        get {
            //String accid = apexpages.currentpage().getparameters().get('id');
            if (inActSetCon == null) {
                inActsize = 5;
                //T02 Updated the query logic
                string queryString = 'SELECT Id, Name,Account__c,Area__c,Other_Area__c,Comments__c,Effective_Date__c,Phone_Number__c,Service_Hours__c,Service_Number__c,Term_Date__c,Term_Date_Verification__c  FROM Customer_Service__c where Term_Date_Verification__c = true and Account__c =:acct ORDER BY sequence__c';
                inActSetCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                inActSetCon.setPageSize(inActsize);
                inActnoOfRecords = inActSetCon.getResultSize();
            }
            return inActSetCon;
        }
        set;
    }

    Public List < Customer_Service__c > getInActiveCSN() {
        csnLStInActive = new List < Customer_Service__c > ();
        for (Customer_Service__c a: (List < Customer_Service__c > ) inActSetCon.getRecords())
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
        system.debug('csnLStActive***' + csnLStActive);
        try {
            update csnLStActive;
            refreshCNSNew();
            // return null;
            editMode = false;
            return null;
        } catch (exception e) {
            //PageReference home = new PageReference('/apex/AIA_CustomerServiceNumber');
            //home.setRedirect(true);
            system.debug('exception***' + e.getMessage());
            //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            //ApexPages.addMessage(msg);
            return null;
        }
    }

    // THis function is for saving the records in active panel
    public PageReference saveinAct() {
        system.debug('csnLStInActive***' + csnLStInActive);
        try {
            update csnLStInActive;
            refreshCNSNew();
            inactEditMode = false;
            //PageReference home = new PageReference('/apex/AIA_CustomerServiceNumber');
            //home.setRedirect(true);
            return null;
        } catch (exception e) {
            system.debug('exception***' + e.getMessage());
            //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            //ApexPages.addMessage(msg);
            return null;

        }
    }


    //This is used for deleting the record in Active/Inactive tab
    public void deleteRec() {
        String myId = System.currentPageReference().getParameters().get('recid');
        system.debug('myId***' + myId);
        Customer_Service__c cs = new Customer_Service__c(id = myID);
        system.debug('cs***' + cs);
        delete cs;
        refreshCNSNew();

    }

    public PageReference canceDetails() {
        PageReference home = new PageReference(ApexPages.currentPage().getUrl());
        system.debug('@@@home'+home);
        home.setRedirect(true);
        return home;
    }
    public pageReference editTable() {
        editMode = true;
        tabSelected = 'Active';
        displayPopUp = false;
        PageReference home = new PageReference('/apex/AIA_CS_Number_page');
        home.getParameters().put('id', acct);
        home.setRedirect(false);
        system.debug('edit Mode Active'+editMode);
        return home;
    }
    public pageReference editInactTable() {
        inactEditMode = true;
        tabSelected = 'InActive';
        displayPopUp = false;
        PageReference home = new PageReference('/apex/AIA_CS_Number_page');
        home.getParameters().put('id', acct);
        home.setRedirect(false);
        system.debug('edit Mode In Active'+inactEditMode);
        return home;
    }
    
    //1562 --T04-- start
    public pageReference viewEditCSNum(){
      string url = '/apex/AIA_CS_Number_page?id='+acct+'&source=CSNum';
      system.debug('URL&&&'+url);
      PageReference home = new PageReference(url);
      system.debug('home&&&'+home); 
      home.setRedirect(true);
      return home;
    }
    //1562 --T04-- End
}