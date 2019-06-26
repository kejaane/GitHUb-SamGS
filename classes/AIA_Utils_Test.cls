/*===================================================================================
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
*===================================================================================
* Date:         12/15/2017 
* Developer:    Goutham Rapolu
* Purpose:      Test class for AIA_Utils Utility class.
* 
*==================================================================================
* Update History
* Date          Developer               Description
*==================================================================================
* 12/15/2017    Goutham Rapolu         Initial Development
* 09/21/2018    Paritosh				Added coverage
*==================================================================================
*/


@istest
public class AIA_Utils_Test{
    public static testmethod void Test_AIA_Utils(){
        
            string param1 = 'testparam';
            string param2;
        User u1 = [SELECT id from User WHERE id=:userinfo.getUserId()];
       
        System.runas(u1)  {  
        test.starttest();
            
            try{
                integer i = 0;
                integer j = 1/i;
            } catch (Exception e){
            system.debug('Main Error'+e.getMessage()+'Line Number'+e.getLineNumber());
            AIA_Utils util=new AIA_Utils();util.logException(e); 
                
            }
           
            
            AIA_Utils.isNullOrEmpty(param1);
            AIA_Utils.isNullOrEmpty(param2);
            AIA_Utils.getEnclosedByQuote(param2);
            AIA_Utils.getEnclosedByQuote(param1);
            AIA_Utils.checkIf_AIA_Admin_User();
            AIA_Utils.getDateInYYDDMMFormat(date.today());
            AIA_Utils.isClassic();
            AIA_Utils.checkIf_AIA_Admin_Profile_User();
        	//R1E1 start
        	AIA_Utils.Case_Oppty_Lkup();
        	insert new Apex_Trigger_Control__c(Name='Account',Bypass_Trigger_Execution__c=true);
        	AIA_Utils.isTriggerBypassed('Account');
        	//R1E1 end
        test.stoptest();
    }
    }
}