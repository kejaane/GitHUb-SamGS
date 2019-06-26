//=========================================================================================
//      Date: 07/28/2011
// Developer: Tom Barrett (TPB)
//   Purpose: This controller retrieves all opportunties from last year forward.
//            If a non admin user is detected only opportunities that the current user owns
//            are retrieved.  If an admin is detected all users opportunities are retrieved
//            In addition, the OwnerLeadRepNonMatch VF page uses this controller
//            Another feature is the ability to mass email owners of the opportunities
//
//=========================================================================================
//                                 Update History
// Date       Developer      	Description
//=========================================================================================
//08/14/2018 Debkanti	|T01|	Added method to check classic or lightning  
//=========================================================================================

public with sharing class CFCT_OwnerLeadRepNoMatch_Controller {  
    List<Opportunity> oppList = new Opportunity[]{};
    ID[] userIds = new ID []{};   
    integer pageSize = 25;    
    private boolean sysAdmin { get; set; }
    
    /* Constructor */
    public CFCT_OwnerLeadRepNoMatch_Controller() {        
        sysAdmin = CFCT_QueryBase.adminLoggedIn();    // Is current user an admin                
        If ( !sysAdmin ) {    // User logged in         
            oppList = CFCT_QueryBase.getOppsCurUserOwnsDateLimit();
        } else {
            oppList = CFCT_QueryBase.getOppsDateLimit();       
        }        
        ssc = new ApexPages.StandardSetController(oppList);
        ssc.setPageSize(pageSize);
    }
    
    /* All below is used to communicate with the VF page */
        
    public ApexPages.StandardSetController ssc { get; set; } 
        
    /* user clicks the Email User link on the VF Page */    
    public PageReference emailUsers() {
        CFCT_ProcessorManager.ownerLeadRepNoMatchEmailUsers(oppList);
        return null;  
    } 
    
    public List<Opportunity> getOpps() {
        return (List<Opportunity>)ssc.getRecords();
    }
     
    public integer getRecCount() { 
        return ssc.getResultSize();
    }
    
    public integer getPageNumber() {
        return ssc.getPageNumber();
    }
    
    public boolean getSysAdmin() {
        return sysAdmin;
    }
    
    public integer getTotalPages() {        
        integer ResultSize = ssc.getResultSize();
        integer remainder = math.mod(ResultSize, pageSize);
        If ( remainder == 0 ) {
            return (ssc.getResultSize() / pageSize);
        } else {
            return (ssc.getResultSize() / pageSize) + 1;
        }        
    }
    /*-T01-Start-*/
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    /*-T01-End-*/
}