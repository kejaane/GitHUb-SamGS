//=========================================================================================
//      Date: 03/30/2019    
// Developer: Tom Barrett
//   Purpose: This class controller is used to provide the ability to run the SM_PA class 
//            so that we no longer need to execute the profile audit process from the 
//            developer console.  See the SM_ProfileAudit Visualforce page too.
//                                        
//=========================================================================================
//                                 Update History
// Date       Developer     	Tag     Description
//=========================================================================================
//
//=========================================================================================
public class SM_PAcontroller {
    public SM_PAcontroller(ApexPages.StandardSetController controller) {
        //Need this method because the button is used in a list
    }

    public PageReference doIt() {
        SM_QueueableDispatch.dispatch(SM_Support.ModuleName.Profile_Audit);
        PageReference pr = new PageReference('/' + Schema.SObjectType.SM_LOG__c.getKeyPrefix());
        return pr;      
    }
}