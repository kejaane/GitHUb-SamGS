//=========================================================================================
//      Date: 07/28/2011
// Developer: Tom Barrett (TPB)
//   Purpose: This controller is used with the CFCT_CustomToolsHomePage VF Page.
//            Currently, it is used to put links too tools that are part of the
//            CareFirst Custom Tools set. 
//            In addition, it has the ability to detect if an admin is viewing
//            the home page and if they are the Administrator Only section is shown;
//            otherwise, the section is hidden.
//
//=========================================================================================
//                                 Update History
// Date       Developer         Description
//=========================================================================================
// 08/14/2018 Debkanti	|T01|	Added method to check classic or lightning 
//=========================================================================================

public with sharing class CFCT_CustomToolsHomePage_controller {

    private boolean sysAdmin { get; set; }
    
    /* Constructor */
    public CFCT_CustomToolsHomePage_controller() {  
        sysAdmin = CFCT_QueryBase.adminLoggedIn();    // Is current user an admin     
    }
    public boolean getSysAdmin() {
        return sysAdmin;
    }
    /*-T01-Start-*/
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    /*-T01-End-*/
}