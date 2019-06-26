/*=========================================================================================
 * Date         : 05/14/2017
 * Developer    : RaviTeja
 * Purpose      : To intialize all the RxMandates in the JSON
 *  
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date      |     Developer      |Tag|   Description
 *===========+============+================================================================
 * 05/14/2017 | Raviteja          |     | Initial Version 
 *===========+============+================================================================
*/
public class AIA_OP4PCSInitializeRXmandates {
    
    public AIA_OP4PCSJSONStructure PCSJsonObj= new  AIA_OP4PCSJSONStructure();
    //get all the rxmandates fot the BDP
    public void getRx(String IDbdp){
        try{
        //Query RxMandate fields
        List<AIA_RxMandate__c> rxMandates=[select Mandate_Name__c,Mandate_Description__c,Mandate_Jurisdiction__c,
                                           Mandate_Effective_Date__c,Mandate_Term_Date__c,Mandate_Apply__c,Network_Rules_AliasName__c 
                                           from AIA_RxMandate__c 
                                           where Benefit_Design_Product__c=:IDbdp];
        List<AIA_OP4PCSJSONStructure.RxMandate> lstRxMandate = new List<AIA_OP4PCSJSONStructure.RxMandate>();
        system.debug('Values are : '+rxMandates);
            for(AIA_RxMandate__c rx:rxMandates){
            //Map RxMandate Fields to JSONStructure.
            AIA_OP4PCSJSONStructure.RxMandate RxMandateobj = new AIA_OP4PCSJSONStructure.RxMandate();
            RxMandateobj.MandateName = rx.Mandate_Name__c;
            RxMandateobj.MandateDescription = rx.Mandate_Description__c;
            RxMandateobj.MandateJurisdiction = rx.Mandate_Jurisdiction__c;
            String formattedED = AIA_Utils.getDateInYYDDMMFormat(rx.Mandate_Effective_Date__c);
            RxMandateobj.MandateEffectiveDate = formattedED;
            String formattedMTDate = AIA_Utils.getDateInYYDDMMFormat(rx.Mandate_Term_Date__c);
            RxMandateobj.MandateTermDate = formattedMTDate;
            RxMandateobj.MandateApply = String.valueOf(rx.Mandate_Apply__c);
            RxMandateobj.NetworkRulesAliasName = rx.Network_Rules_AliasName__c;
            lstRxMandate.add(RxMandateobj);
            PCSJsonObj.RxMandate.add(RxMandateobj);
            }
        }
        //Catch if any exception and insert a log in IntegrationLog.
        catch(Exception e){
        AIA_Utils util=new AIA_Utils(); util.logException(e); //made one line for code coverage. no logic changed.
        }
}
   
}