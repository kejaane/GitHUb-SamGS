/*===================================================================================================================
* Date       : 4/13/2018
* Developer  : Rajesh Pennam
* Purpose    : This is the controller class for VF page "AIA_User_Account_View" which contains the logic
*              to populate the accounts and sort them 
*
*                                 Update History
*                                 ---------------
* Date        |     Developer        | Tag |   Description
*=================================================================================================================
* 05/17/2018  | Rajesh Pennam        |     | Initial Creation
* 05/22/2018  | Rajesh Pennam        | T02 | Updated the controller for sorting on task count using Comparable function
* 03/27/2019  | Naga K               | T03 | Changed reference from standard obj to custom obj
*============+============+=========================================================================================*/


global class AIA_User_Account_View_Controller {
    private list<AccountSubClass> AccountList {get; set;}
    //private List<AccountTeamMember> accTeamLst {get;set;} T03
    private List<Account_Team__c> accTeamLst {get;set;}// T03
    public list<AccountSubClass> CurrentAccountList {get;set;}
    public Static list<AccountSubClass> allAccountTaskList ;
    private set<Id> AccountSelectedSet;
    public String AlphaFilter {get; set;}
    public Integer AccountSelectedCount {get; set;}
    private String QueryAccount;
    public String SortFieldSave {get;set;}
    public String sortFieldLabel {get;set;}
    public  Integer listSize;
    Private Integer accountCounter=0; // Determines how many records to be skipped
    Private Integer accountTotalSize=0;
    public boolean showallAcc {get;set;}
    public boolean selectAllCKbox {get;set;}    
    public Integer accountCount {get;set;}
    public static final String inProgress = 'In Progress';
    public boolean queryFlag {get;set;} 
    private Map<string,String> sortFieldlabelMap = new map<string,string>{'TeamMemberRole'=>'Role','AccountId__r.Name' => 'Account Name', 'CreatedDate' => 'ADDED ON' , 'taskCount' => 'ACTIVE TASK'};
    Id userid;   
    public static String sortBy;
    public AIA_User_Account_View_Controller() {
         userid = ApexPages.currentPage().getParameters().get('id');
         AccountList = new list<AccountSubClass>();
         allAccountTaskList = new list<AccountSubClass>();
         AccountSelectedSet = new set<Id>();
         SortFieldSave = SortField;
        queryFlag = false;
        sortFieldLabel = sortFieldlabelMap.get(SortFieldSave);
        showallAcc = (Apexpages.currentPage().getParameters().get('showallAcc') == 'true'?true:false);
        listSize = showallAcc?50:10;
         BuildQuery();  
    }
    
    //SortField - return sort by field. Default to Name
    
    public String SortField {
        get { if (SortField == null) {SortField = 'AccountId__r.Name'; } return SortField;  }
        set; 
    }
     
    // SortDirection - return sort direction. Default ascending(asc)
    
    public String SortDirection {
        get { if (SortDirection == null) {  SortDirection = 'asc'; sortBy = SortDirection; } return SortDirection;  }
        set;
    }   
    
     public void BuildQuery() {
         selectAllCKbox = false;
        //StdSetControllerAccount = null;
        String QueryWhere = '';
          if (AlphaFilter == null || AlphaFilter.trim().length() == 0) {
            AlphaFilter = 'All';
        }
         //string userid = userinfo.getUserId();
         //accTeamLst = new list<AccountTeamMember>(); T03
         accTeamLst = new list<Account_Team__c>(); //T03
         //QueryAccount = 'SELECT AccountId ,Account.name,CreatedDate,TeamMemberRole FROM AccountTeamMember where UserId =: userid ';
         QueryAccount = 'SELECT AccountId__c,AccountId__r.name,CreatedDate,TeamMemberRole__c FROM Account_Team__c where UserId__c =: userid ';
         if(SortField != 'taskCount'){
             QueryAccount += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) ;
         }
         //list<AccountTeamMember> accTeamsize = (list<AccountTeamMember>)Database.query(QueryAccount); t03
         list<Account_Team__c> accTeamsize = (list<Account_Team__c>)Database.query(QueryAccount);//t03
         set<id> acccount = new Set<id>();
         /*for(AccountTeamMember atm :accTeamsize){t03
             acccount.add(atm.accountid);
         }*/
         for(Account_Team__c atm :accTeamsize){//t03
             acccount.add(atm.AccountId__c);
         }//t03
         accountCount = acccount.size();
         accountTotalSize = accTeamsize.size();

         if(SortField == 'taskCount'){
             accTeamLst = accTeamsize;
             CurrentAccList();
             CurrentAccountList.sort();
             allAccountTaskList = CurrentAccountList;
             CurrentAccountList = new list<AccountSubClass>();
             integer nextLimit = accountCounter+listSize;
             for(Integer i = accountCounter; i< (nextLimit);i++){
                 if(i<allAccountTaskList.size())
                     CurrentAccountList.add(allAccountTaskList[i]);
             }
         }
         else{
             system.debug('listSize***'+listSize + '#####'+accountCounter);
             QueryAccount += ' limit : listSize offset : accountCounter';
             //accTeamLst = (list<AccountTeamMember>)Database.query(QueryAccount); t03
             accTeamLst = (list<Account_Team__c>)Database.query(QueryAccount);//t03
             CurrentAccList();
         }
     }
     
    //AccountSubClass - Sub-Class to hold Account and checkbox for the table
    //T02 Starts Here
    global class AccountSubClass implements Comparable{
        public Boolean aCheckBox {get;set;}
        //public AccountTeamMember aAccount {get;set;}//t03
        public Account_Team__c aAccount {get;set;}//t03
        public String accountName {get;set;}
        public Integer taskCount{get;set;}
        public String addedOn{get;set;}
        
        // sub-class initialization
        //public AccountSubClass(AccountTeamMember a, Boolean chk,String acctName,Integer taskCnt){
        public AccountSubClass(Account_Team__c a, Boolean chk,String acctName,Integer taskCnt){
            aAccount = a;
            aCheckBox = chk;
            accountName = acctName;
            taskCount = taskCnt != null?taskCnt:0;
            addedOn = a.CreatedDate.format('dd-MMM-YYYY');
        }
        //public SORT_BY sortBy = SORT_BY.ByAsc;
        
         global Integer compareTo(Object ObjToCompare) {
             if(AIA_User_Account_View_Controller.sortBy == 'asc'){
                 return Integer.valueOf(taskCount - ((AccountSubClass)objToCompare).taskCount);
             }
             else{
                return Integer.valueOf(((AccountSubClass)objToCompare).taskCount - taskCount);  
             }
        }
        
    }
    
    
    public void CurrentAccList() {
       CurrentAccountList = new list<AccountSubClass>();
        
      //  AccountList= new list<AccountSubClass>();
        set<id> accid = new set<id>();
        //T03 changes start
        /*for (AccountTeamMember a : (list<AccountTeamMember>)accTeamLst) {
           accid.add(a.accountid);
        }*/ //t03
        for (Account_Team__c a : (list<Account_Team__c>)accTeamLst) { 
           accid.add(a.AccountId__c);
        }//T03 changes End
                
        List<Workplan_Task__c > wpStageLst = [SELECT AccountID__c,Id FROM Workplan_Task__c where OwnerId=:userid and AccountID__c IN :accid and Status__c = :inProgress ];
        Map<id,Integer> accTaskMap = new Map<id,Integer>();
        for(Workplan_Task__c  ws : wpStageLst){
            Integer tsk = 0;
            if(accTaskMap.containsKey(ws.AccountID__c )){
                tsk = accTaskMap.get(ws.AccountID__c );
            }
            tsk +=1;
            accTaskMap.put(ws.AccountID__c , tsk);
        }
        
        //T03 changes start
       /* for (AccountTeamMember a : (list<AccountTeamMember>)accTeamLst) {
            CurrentAccountList.add(new AccountSubClass(a, AccountSelectedSet.contains(a.Id),a.Account.name, accTaskMap.get(a.AccountId)));
        }*/
        for (Account_Team__c a : (list<Account_Team__c>)accTeamLst) {
            CurrentAccountList.add(new AccountSubClass(a, AccountSelectedSet.contains(a.Id),a.AccountId__r.name, accTaskMap.get(a.AccountId__c)));
        }//t03 changes End
        //CurrentAccountList = AccountList;
       // return CurrentAccountList;
    }
     public void UpdateAccountSelectedSet(){
    //list<AccountSubClass> CurrentAccountCheckedToggle = CurrentAccountList;
    //CurrentAccountList.clear();
         for (AccountSubClass a : (list<AccountSubClass>)CurrentAccountList) {
             a.aCheckBox = selectAllCKbox;
             
            //CurrentAccountCheckedToggle.add(new AccountSubClass(a,selectAllCKbox,a.Account.name, accTaskMap.get(a.AccountId)));
        }
         //CurrentAccountList = CurrentAccountCheckedToggle;
    }
    
     public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
         sortBy = SortDirection; 
        // reset alpha filter and sort sequence when sorted field is changed
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
             sortBy = SortDirection; 
            AlphaFilter = 'All';
            SortFieldSave = SortField;
            sortFieldLabel = sortFieldlabelMap.get(SortFieldSave);
        }
        // run the query again
        BuildQuery();
    }
    
    //Displays the next set of records
    public void nextAccount(){
        
        accountCounter=accountCounter+listSize;
        BuildQuery();
    }
    
    //Displays the previous set of records
    public void previousAccount(){
        accountCounter=accountCounter-listSize;
        BuildQuery();
    }
    
    //Displays the last set of records irrespective of current position
    public void  nextLastAccount(){
        system.debug('accountCounter***'+accountCounter);
        system.debug('listSize***'+listSize);
        /*if(math.mod(accountTotalSize,listSize)==0)
         accountCounter= accountTotalSize - listSize; 
        else*/
        accountCounter = accountTotalSize - math.mod(accountTotalSize,listSize);
        //counter = total_size - math.mod(total_size, list_size);
        system.debug('accountCounter$$$$***'+accountCounter);
        BuildQuery();
   }

    //Displays the first set of records irrespective of current position
    public void previousFirstAccount(){
        accountCounter=0;
        BuildQuery();  
    } 
    public boolean getprev()
    {
        if(accountCounter == 0)
        return true;
        else
        return false;
    }  
    public boolean getnxt()
    {
        if((accountCounter + listSize) >= accountTotalSize)
        return true;
        else
        return false;
    }     
    public pageReference viewAll(){
        //showallAcc = true;
       // selectAllCKbox = false;
       PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
       //pageReference pageRef = new pageReference('/apex/AIA_Account_Team_Member_Add'); // This will redirect to Manage Team Member Page and udpate the Account Team Member
        pageRef.setRedirect(true);
        pageRef.getParameters().put('showallAcc','true');
        return pageRef;
       // return null;
    }
    public pageReference manageTeamMembers(){
        // CurrentAccountList = new list<AccountSubClass>();
        string accIdSelected ;
        for(AccountSubClass wrapAccSub : CurrentAccountList){
            if(wrapAccSub.aCheckBox == true) {
                accIdSelected += wrapAccSub.aAccount.AccountId__c +',';
            }
        }
        if(accIdSelected!=null){
            accIdSelected = accIdSelected.removeStart('null');
            pageReference pageRef = new pageReference('/apex/AIA_Account_Team_Member_Add'); // This will redirect to Manage Team Member Page and udpate the Account Team Member
            pageRef.setRedirect(true);
            pageRef.getParameters().put('accLst',accIdSelected);
            return pageRef;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select atleast one Account'));
        }
        
       return  null;
        
    }
    
}