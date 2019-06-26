/*=================================================================================================
* Date         : 06/08/2017
* Developer    : Debkanti
* Purpose      : This class function is to send the modified date to PCS for sync
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 06/08/2017| Debkanti    |     | Initial Version                                         
*
*===========+============+=====+===================================================================
*/
/**
* @Author: Debkanti 
* @This batch class send the benefit design product id to AIA_PCSIntegrationHandler
* @param -  None
* @Output - if return response is success updating the record's  PCS_Sync__c field to 'In Progress'
*           else if updating the record's  PCS_Sync__c field to 'Failed' and sendong the failure list mail to aia.
*/

global class AIA_OP4synchCustomizedPlansWithPCS_Batch implements Database.Batchable<sobject>,Database.AllowsCallouts,Database.Stateful,schedulable  {
    //Start Method
    List<AIA_Benefit_Design_Product__c> successList = new List<AIA_Benefit_Design_Product__c>();
    List<AIA_Benefit_Design_Product__c> failureList = new List<AIA_Benefit_Design_Product__c>();
    Integer falureListSize = 0;
    Integer successListSize = 0;
    String bdpURL='';
    AIA_Utils errLogExp = new AIA_Utils();
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        //Querying all the redord of Benefit Design Product based on the criteria
        String query = 'Select id,name from AIA_Benefit_Design_Product__c where (Benefit_Design__r.Approval_Status__c = \'Approved\' and ARC_Approved__c = true and PCS_Custom_Plan_Id__c = null and (PCS_Sync__c = \'Not Started\') and (Custom_New__c = \'Custom\' OR Custom_New__c = \'Non - Standard\'))'; //OR PCS_Sync__c = \'Failed\' Removed by RG
        //string query1 = 'Select id,name,Benefit_Design__r.Approval_Status__c,ARC_Approved__c,PCS_Custom_Plan_Id__c,Custom_New__c,PCS_Sync__c    from AIA_Benefit_Design_Product__c where Benefit_Design__r.Approval_Status__c = \'Approved\' and ARC_Approved__c = true and PCS_Sync__c = \'Not Started\'  and PCS_Custom_Plan_Id__c = null and (Custom_New__c = \'Custom\' or Custom_New__c = \'Non - Standard\')';
        return Database.getQueryLocator(query);
        
    }
   //Added by RG 7/25 - start 
     global void execute(SchedulableContext sc) {
        AIA_OP4synchCustomizedPlansWithPCS_Batch OP4Batch= new AIA_OP4synchCustomizedPlansWithPCS_Batch ();
        database.executebatch(OP4Batch,1);
        
    }
   //Added by RG 7/25 - end
    
    //Execute method
    global void execute(Database.BatchableContext bc, List<AIA_Benefit_Design_Product__c> scope) {
        try{
            //Creating list of Benefit design product
            AIA_Benefit_Design_Product__c bdp = new AIA_Benefit_Design_Product__c();
            AIA_Benefit_Design_Product__c bDPtoUpdate = new AIA_Benefit_Design_Product__c();
            
            //Fatching the error codes
            List<AIA_PCS_Op4_ErrorCodes__c> errorCode = new List<AIA_PCS_Op4_ErrorCodes__c>();
            Set<String> errorSet = new Set<String>();
            errorCode = AIA_PCS_Op4_ErrorCodes__c.getall().values();
            //Iterating the errorcode and adding to set.
            for(AIA_PCS_Op4_ErrorCodes__c eC : errorCode){
                errorSet.add(ec.Name);
            }
            system.debug('allErrorCode :'+errorSet);
            
            //Iterating the list of data fatched by query
            for(Sobject s : scope){
                bdp = (AIA_Benefit_Design_Product__c)s;
                bDPtoUpdate = new AIA_Benefit_Design_Product__c();
                
                //Sending the http request
                    String pcsValue;
                    pcsValue = AIA_PCSIntegrationHandler.callPCS(string.valueof(bdp.id));
                    system.debug('enter thre : '+pcsValue);
                    system.debug('BDPID : '+bdp.id);
                
                       
                    
                    //Chaecking if pcsValue is success or not and creating the list
                if(errorSet.contains(pcsValue)){ bDPtoUpdate.id = bdp.id;bDPtoUpdate.PCS_Sync__c = 'In Progress';
                                                successList.add(bDPtoUpdate); successListSize += successList.size();
                        system.debug('Success ListSize :'+successListSize);
                    }
                    else  {
                        bDPtoUpdate.id = bdp.id;
                        bDPtoUpdate.PCS_Sync__c = 'Failed';
                        failureList.add(bDPtoUpdate); falureListSize += failureList.size();
                        bdpURL = bdpURL+URL.getSalesforceBaseUrl().toExternalForm() + '/' + bDPtoUpdate.id+'\n';
                        system.debug('Falure List : '+failureList);
                        //system.debug('Url are: '+bdpURL);
                    }
                system.debug('size : '+failureList.size());
                system.debug('size1 : '+falureListSize);
            }
            
        }
        catch (Exception e) {System.debug('MainERROR:' + e); errLogExp.logException(e);}
    }
    
    global void finish(Database.BatchableContext bc) {
        Try{  //Updating the record for success
            If(successListSize>0){
                update successList;
            }
            
            if(falureListSize>0)
            {
                //Sending the mail for list of failure record
                String emailbody = 'Operation 4 of AIA PCS Integration with Salesforce failed'+'\n'+'\n'+'\n'+'\n'+bdpURL+'\n';
                AIA_Workflow_Emails__c workFlowEmails = AIA_Workflow_Emails__c.getInstance();
                System.debug('PCS Email: ' + workFlowEmails.AIA_OP4_Email_Address__c);
                String setToAddress = workFlowEmails.AIA_OP4_Email_Address__c;
                String emailSubject = 'Operation 4 Failed – SFDC PCS Integration';
                System.debug('Enter the finish method'+failureList.size());
                Utils.SendMail(emailbody, emailSubject, setToAddress);
                
                //Updating the record for failure
                update failureList;
            }
        }
        Catch (Exception e) {System.debug('finish:' + e); errLogExp.logException(e);}
    }
    
}