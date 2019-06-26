/*===================================================================================================================
* Date       : 09/27/2017
* Developer  : Raviteja
* Purpose    : US-117,US-106 This is controller class for VF pages AIA_GSM_RejectedByAccount, AIA_GSM_ApprovedByAccount.
               Allow user to modify Group structure status to Approved by Account/Rejected by Account.
               Checking some validations Before changing to Approved by Account/Rejected by Account.
               Posting chatter notification on Approved by Account.
*                                 Update History
*                                 ---------------
* Date       |      Developer        | Tag |   Description
*============+============+=========================================================================================
* 09/27/2017 |      Raviteja         |     | Initial Version
* 02/09/2018 | Rajesh Nagandla       | T01 | Added SLDS to all components in page
*============+============+=========================================================================================
*/

public class AIA_GSRF_StatusByAccount {
    //T01  -   start
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    //T01  -   end
    AIA_Group_Structure_Request_Form__c rec;
    public static string errorGSRF='';
    public static boolean showError=false;
    public AIA_GSRF_StatusByAccount(ApexPages.StandardController stdController) {
        //id = apexpages.currentpage().getparameters().get('id');    
         rec = (AIA_Group_Structure_Request_Form__c)stdController.getRecord();
        
    
    }
    //This method is called when Account by Account is clicked
    public pagereference saveRecForApproved(){
        //check the conditions and then change status to Approved by Account
        if(rec.Status__c=='Approved by Internal Team'){
            rec.Status__c='Approved by Account';  
            }
        else{
            errorGSRF='Incorrect Status selected';
            showError=true;
        }
        //If it is not one of the above statuses,then throw error
        if(showError==true){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,errorGSRF);
            ApexPages.addMessage(msg);
            return null;
        }else{
            try{
                 update rec;
                 postFeedonAccount();
            }
            catch(Exception e){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(msg);
                return null;
            }
         PageReference pr = new PageReference('/'+rec.id );
         pr.setRedirect(true);
         return pr;      
        }
    }
    
    //This method is called when Rejected by Account is clicked
    public pagereference saveRecForRejected(){
        //check the conditions and then change status to Approved by Account
         if(rec.Status__c=='Approved by Internal Team'){
           if(!String.isEmpty(rec.Rejected_comments_by_Account__c)){
                rec.Status__c='Rejected by Account';  
           }
           else{
                errorGSRF='Please provide reject Comments by Account.';
                showError=true;
           }
       }
       else{
           errorGSRF='Incorrect Status selected';
           showError=true;
       }
        
        //If it is not one of the above statuses,then throw error
        if(showError==true){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,errorGSRF);
            ApexPages.addMessage(msg);
            return null;
        }else{
            update rec;
            PageReference pr = new PageReference('/'+rec.id );
            pr.setRedirect(true);
            return pr;      
        }
    }
    
    //send chatter notification on account
    public void postFeedonAccount(){
        String yesno='';
                if(rec.Base_Group_Impact__c==True){
                    yesno='Y';
                }
                else{
                    yesno='N'; 
                }
        //String subject= rec.Account_Legal_Name__c+' - Effective Date '+
         //               rec.Effective_date_format__c+' - Approved group structure for distribution\n';
        String message= rec.Account_Legal_Name__c+' - Effective Date '+
                        rec.Effective_date_format__c+', BGI = '+yesno+' - Approved group structure for distribution.\n';
        //String url='GSRF - '+system.URL.getSalesforceBaseUrl().toExternalForm()+'/'+rec.Id; as per us 251
        system.debug('message'+message);
        AIA_Implementation__c imp = [select Account__c from AIA_Implementation__c where id =: rec.Implementation__c];
    
    // Bulk post to the account feeds.

    List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
        
        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        
        input.subjectId = imp.Account__c;
        
        ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
        body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = message;

        body.messageSegments.add(textSegment);
        input.body = body;

        ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
        batchInputs.add(batchInput);
    

    ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
            
            
            
    }
    public pagereference backtogsrf(){
        PageReference pref = new PageReference('/'+rec.id );
        pref.setRedirect(true);
        return pref;
    }
    
}