/*=================================================================================================
* Date         : 11/06/2017
* Developer    : Raviteja
* Purpose      : US-234 This class function tocheck all alpha prefix fields in gsp and make the
                 alpha prefix field in GSRF field completed.

*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+=============+=====+===================================================================
* 11/06/2017| Raviteja    |     | initial creation
*
*===========+============+=====+===================================================================
*/
public class AIA_GSM_GSRFProductTriggerHelper {
    public static void checkAlphaPrefixMissing(List<AIA_Group_Structure_Form_Product__c> gsps){
        Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
        Id drug=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
        Id vision=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Vision').getRecordTypeId();
        Id medical=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();

        for(AIA_Group_Structure_Form_Product__c thisGSP:gsps){
            if(thisGSP.RecordTypeId==medical){
                //system.debug('Alpha_Prefix_check__c'+thisGSP.Alpha_Prefix__c);
                if(thisGSP.Alpha_Prefix__c!=null){
                    thisGSP.Alpha_Prefix_check__c=true;
                }
                else{
                    thisGSP.Alpha_Prefix_check__c=false;
                }
            }
            if((thisGSP.RecordTypeId==vision||thisGSP.RecordTypeId==drug||thisGSP.RecordTypeId==dental)
               && thisGSP.Related_Medical_Product__c!=null){
                thisGSP.Alpha_Prefix_check__c=true;
            }
            if((thisGSP.RecordTypeId==dental||thisGSP.RecordTypeId==vision)
               && thisGSP.Related_Medical_Product__c==null){
                    if(thisGSP.Alpha_Prefix__c!=null){
                    thisGSP.Alpha_Prefix_check__c=true;
                    }else{
                    thisGSP.Alpha_Prefix_check__c=false;
                    }
                
            }
            if( thisGSP.RecordTypeId==drug && thisGSP.Related_Medical_Product__c==null){
                //system.debug('rel'+thisGSP.Related_Medical_Product__c);
                 thisGSP.Alpha_Prefix_check__c=true;
            }
            
        }
    }
        
    
    public static void checkAlphaPrefixCompleted(List<AIA_Group_Structure_Form_Product__c> gsps){
        Map<id,List<AIA_Group_Structure_Form_Product__c>> mapGspGSRF=new Map<id,List<AIA_Group_Structure_Form_Product__c>>();
        Map<id,AIA_Group_Structure_Request_Form__c> mapGsrfrec;
        set<id> gsrfs=new set<id>();
        for(AIA_Group_Structure_Form_Product__c thisGsp:gsps){
            gsrfs.add(thisGsp.Group_Structure_Request_Form__c);
        }
        List<AIA_Group_Structure_Form_Product__c> allgsps=[select id,Group_Structure_Request_Form__c,Alpha_Prefix_check__c
                                                          from AIA_Group_Structure_Form_Product__c
                                                          where Group_Structure_Request_Form__c in:gsrfs];
        mapGsrfrec=new Map<id,AIA_Group_Structure_Request_Form__c>([select id,Alpha_Prefix_is_missing__c
                                                                          from AIA_Group_Structure_Request_Form__c
                                                                          where id in:gsrfs]);
        for(AIA_Group_Structure_Form_Product__c thisGSP:allgsps){
             if(mapGspGSRF.containsKey(thisGSP.Group_Structure_Request_Form__c)){
                mapGspGSRF.get(thisGSP.Group_Structure_Request_Form__c).add(thisGSP);
             }
             else{
                 mapGspGSRF.put(thisGSP.Group_Structure_Request_Form__c,new List<AIA_Group_Structure_Form_Product__c>{thisGSP} );
             }  
        }
        //system.debug('mapGspGSRF'+mapGspGSRF);
        //loop on all gsrfs
        for(AIA_Group_Structure_Request_Form__c thisGSRF:mapGsrfrec.values()){
            Boolean allAlphaPrefixcompleted=true;
            for(AIA_Group_Structure_Form_Product__c thisGSP:mapGspGSRF.get(thisGSRF.id)){
                if(!thisGSP.Alpha_Prefix_check__c){
                    allAlphaPrefixcompleted=false;
                }
            }
            system.debug('aplha'+allAlphaPrefixcompleted);
           thisGSRF.Alpha_Prefix_is_missing__c= allAlphaPrefixcompleted;
            
        }
        update mapGsrfrec.values();
        
    }
}