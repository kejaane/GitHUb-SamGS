/*=========================================================================================
 * Date         : 05/23/2017
 * Developer    : Ken Gill
 * Purpose      : This class is used to create or update a Community Contact record asynchronously from the corresponding
 *                User record update. This is to get around the platform restriction of not allowing a setup object (User) and
 *                a non-setup object to be DML updated in the same transaction.
 *                This implementation addresses defect 115350 where a BAM message received is only able to update the User
 *                but not the Contact record in the same transaction.  
 *
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 05/23/17  |  KG    | Initial Version                                         
 *           |        | 
 *=========================================================================================
 */

public class UserProvisioningContactCreator implements Queueable {
    
    Map<String,String> attributes;
    UserProvisioningService.Configuration config;

    public UserProvisioningContactCreator( Map<String,String> attributes,UserProvisioningService.Configuration config ) {
        this.attributes = attributes;
        this.config = config;
    }

    public void execute( QueueableContext context ) {
        System.debug( 'UserProvisioningContactCreator() executing as user : ' + UserInfo.getUserName());
        try {
        
            Contact c = UserProvisioningService.createContact( attributes, config);
            upsert c Agency_Agent_ID__c;
            UserProvisioningService.populate360DegreeViewLookups( c );
        
        } catch( Exception e ) {
            
            UserProvisioningService.notifyError( e, config, true, true, true);                  
        }   
    }
}