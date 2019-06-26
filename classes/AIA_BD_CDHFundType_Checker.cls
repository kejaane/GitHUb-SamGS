/*************************************************************************************************************************************************
*  Class            : AIA_BD_CDHFundType_Checker
*  Author           : Rajesh Pennam
*  Version History  : 1.0
*  Creation         : 07/27/2017
*  Description      : This class is used to check the CDHFundType in associated Meical PP for BRF and update the checkbox in BD
*
*  Modification Log:
* ----------------------------------------------------------------------------------------------------------------------------------------------
*  Author          Date-Modified      Tag      Description of Change
* ----------------------------------------------------------------------------------------------------------------------------------------------
* Rajesh Pennam     07/27/2017               Initial Development

*************************************************************************************************************************************************/
Public class AIA_BD_CDHFundType_Checker{

    public static void updateBDCheck(list<AIA_Benefit_Design__c> lstabd){
    
        Id rt_PP_Medical= QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');
        //This map is used to store the BRF and BD, key = BRF and value = BD
        map<id,AIA_Benefit_Design__c> mapbrfbd=new map<id,AIA_Benefit_Design__c>();
        for(AIA_Benefit_Design__c bb: lstabd){
            mapbrfbd.put(bb.Benefit_Request_Form__c,bb);
             system.debug('-1--mapbrfbd-----'+mapbrfbd);
        }
        if(!mapbrfbd.isEmpty()){
         system.debug('-12--mapbrfbd-----'+mapbrfbd);
         //Below query to get the Medical PP for the the associated BRF
            for(Benfit_Request_Form__c brf :[select id,name,(select id,name,Benefit_Request_Form__c,CDH_Fund_Type__c from Proposed_Products__r where recordtypeid=:rt_PP_Medical) from Benfit_Request_Form__c where id IN:mapbrfbd.keyset() and Status__c='Sold']){
                system.debug('-13--mapbrfbd---size--'+brf.Proposed_Products__r.size());
                //if(brf.Proposed_Products__r.size()==1){
                 system.debug('-13--mapbrfbd-----'+mapbrfbd);
                 //If PP for the associated BRF has CDHType as 'BlueFund' then BlueFund Checkbox in BD will be marked
                    for(Proposed_Products__c pp:brf.Proposed_Products__r){
                        if(pp.CDH_Fund_Type__c=='BlueFund'){
                         system.debug('-14--mapbrfbd-----'+mapbrfbd);
                            mapbrfbd.get(pp.Benefit_Request_Form__c).BlueFund_Checkbox__c=true;  
                             system.debug('-15--mapbrfbd-----'+mapbrfbd);  
                        }
                        //If PP for the associated BRF has CDHType as 'Compatible' then Compatible Checkbox in BD will be marked
                         if(pp.CDH_Fund_Type__c=='Compatible'){
                         system.debug('-14--mapbrfbd-----'+mapbrfbd);
                            mapbrfbd.get(pp.Benefit_Request_Form__c).Compatible_Checker__c=true;  
                             system.debug('-15--mapbrfbd-----'+mapbrfbd);  
                        }
                    ////If PP for the associated BRF has CDHType as 'BlueFund' and 'Compatible' then Both Checkbox in BD will be marked
                    if(mapbrfbd.get(pp.Benefit_Request_Form__c).BlueFund_Checkbox__c==true && mapbrfbd.get(pp.Benefit_Request_Form__c).Compatible_Checker__c==true){
                        mapbrfbd.get(pp.Benefit_Request_Form__c).BlueFund_Checkbox__c=false;
                        mapbrfbd.get(pp.Benefit_Request_Form__c).Compatible_Checker__c=false;
                        mapbrfbd.get(pp.Benefit_Request_Form__c).Both_Checker__c=true;
                        system.debug('-15--mapbrfbd-----'+mapbrfbd);  
                    }
                }    
            }
            
            
            }
        }
        
        
        
        
    
}