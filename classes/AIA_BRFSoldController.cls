/*==============================================================================================================
 * Date         : 
 * Developer    : 
 * Purpose      : Back Button after BRF is marked Sold
 *================================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer    Tag   Description
 *============+============+=====+================================================================================                                          
 * 09/03/2018  | Arshia Gulati   |  T01   | Validate MHP input for BRF Sold on BRF Page  
 *============+============+=====+================================================================================
 */

public class AIA_BRFSoldController {

    public AIA_BRFSoldController(ApexPages.StandardController controller) {

    }
     public Boolean getIsClassic() {
        return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }
    
    public String brfId{get;set;}
    public boolean displayerror{get;set;}
    public Benfit_Request_Form__c brfObj{get;set;}
    // T01-Start
    public boolean displayConfirmation{get;set;}
    public boolean displayMHPPanel{get;set;}
    // T01-End
    
    //Initialize and perform validations for BRF Sold
    public PageReference updateBRF(){
        boolean errorfound=false;
        displayMHPPanel=false;
        displayerror= false;
        displayConfirmation=false;
        brfObj=null;
        PageReference pgref=null;
        brfId=ApexPages.currentPage().getParameters().get('id');
        System.debug('Received BRF id --->'+brfId);
        brfObj=[select id,AdjustmentRecordCount__c ,Request_Type__c,Status__c 
              ,Count_of_Risk_Medical_Products__c,Submit_Medical_Plan_s_for_MHP_Testing__c,MHP_Acknowledgement__c
                                       FROM Benfit_Request_Form__c 
                                       WHERE id =:brfid];
       System.debug('Received brfObj --->'+brfObj);    
        errorfound = ValidateInput();
        if(!displayerror && !errorfound)      
         {
            displayConfirmation = true;
        }
                
        return null;
    }
   
 //Validate BRF Page User input for BRF Sold
    private Boolean ValidateInput(){
        Boolean IsError = false;
      if(brfObj.AdjustmentRecordCount__c > 0 && brfObj.Request_Type__c == 'Renew As-is'){ 
            System.Debug('error1');
            displayerror = true;
            IsError = true;
            ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'BRF is no longer a Renew As-Is request type.Please select another request type');
            ApexPages.addMessage(myMsg2);
        }
        else if(brfObj.Status__c == 'Sold'){
            System.Debug('error2');
            displayerror = true;
            IsError = true;
            ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'The Benefit Request Form has already been marked as Sold');
            ApexPages.addMessage(myMsg2);           
        }
        else if((brfObj.Count_of_Risk_Medical_Products__c > 0) && (!brfObj.Submit_Medical_Plan_s_for_MHP_Testing__c)){
            System.Debug('error3');
            IsError = true;
            displayMHPPanel=true;
            ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'The BRF cannot be marked sold because the \'Medical Plan(s) will be MHP Tested\' checkbox is not checked');
            ApexPages.addMessage(myMsg2);            
        }  
        return IsError;
    }
       
    //Mark BRF Sold
    public PageReference Save(){

       // displayerror = false;
       //Validation logic moved to separate method
       /*
        boolean errorfound=false;
        PageReference pgref=null;
        if(brfObj.AdjustmentRecordCount__c > 0 && brfObj.Request_Type__c == 'Renew As-is'){ 
            displayerror = true;
            errorfound = true;
            ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'BRF is no longer a Renew As-Is request type.Please select another request type');
            ApexPages.addMessage(myMsg2);
            return null; 
        }
        else if(brfObj.Status__c == 'Sold'){
            displayerror = true;
            errorfound = true;
            ApexPages.Message myMsg2 = new ApexPages.Message(ApexPages.Severity.ERROR,'The Benefit Request Form has already been marked as Sold');
            ApexPages.addMessage(myMsg2);
            return null;
        }
        
        System.debug('displayerror &&&::'+ displayerror+'@@errorfound::'+errorfound);
*/
        try{
          //if(!displayerror && !errorfound){		//T01
          if(!ValidateInput()){
              brfObj.Status__c='Sold';
              update brfObj;
              System.debug('Updated Sucess'+brfObj.Status__c);
            }
            else
	            {
	                return null;
	            }
        }catch(Exception e){
            System.debug('Error in updating BRF to Sold'+e.getMessage());
            displayerror = true;
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            // pgref=null;
             displayMHPPanel = false;
            displayConfirmation = false;
            return null;
        }
        return Cancel(); 
        //T01-Start
        /* 
        ApexPages.StandardController sc = new ApexPages.StandardController(brfObj);
        sc = new ApexPages.StandardController(brfObj);
        pgref=sc.view();
        pgref.setRedirect(true);
        return pgref;
    	*/
        //T01-End
    }
    
    //Redirect back to BRF Page
    public PageReference Cancel(){
        /*
        Benfit_Request_Form__c brfObj=null;
        brfObj= new Benfit_Request_Form__c (id=ID.valueOf(brfId));
        ApexPages.StandardController sc = new ApexPages.StandardController(brfObj);
        PageReference pgref= sc.view();
        pgref.setRedirect(true);
        return pgref;
        */
        PageReference pref = new PageReference('/'+brfId );
        pref.setRedirect(true);
        return pref;
    }
	
    //display confirmation message 
    public void MHPPass(){
        System.Debug('brfObj.Submit_Medical_Plan_s_for_MHP_Testing__c'+brfObj.Submit_Medical_Plan_s_for_MHP_Testing__c);
        displayerror = true;
        if(brfObj.Submit_Medical_Plan_s_for_MHP_Testing__c)
        displayConfirmation=true;
    }
    
     //Deprecated Production code
    /*
    public PageReference updateBRF(){
        
        displayerror= false;
        brfObj=null;
        PageReference pgref=null;
        brfId=ApexPages.currentPage().getParameters().get('id');
        System.debug('Received BRF id --->'+brfId);
        brfObj=[select id,AdjustmentRecordCount__c ,Request_Type__c,Status__c 
                                       FROM Benfit_Request_Form__c 
                                       WHERE id =:brfid];
       
        if(UserInfo.getUiThemeDisplayed() == 'Theme3'){
            Save();
            PageReference pageref = new PageReference('/' + brfObj.id);
            pageref.setRedirect(true);
            return pageref;
        }   
        return null;
    }
*/
}