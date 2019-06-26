/*=================================================================================================
* Date         : 09/20/2017
* Developer    : Debkanti,Raviteja
* Purpose      : US-60: To update the Products count 
                 (fields: "Drug # of Plans","Dental # of Plans","Vision # of Plans")
                 on Group Structure Request Form(GSRF) based on the Group structure product type.

*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+=============+=====+===================================================================
* 09/20/2017| Debkanti    |     | Initial Version
*===========+============+=====+===================================================================
*/

public class AIA_GSM_GSRFProductCount {
    public static void countofProduct (List<AIA_Group_Structure_Form_Product__c> listproduct) {
        Set<id> GSRFset =new Set<id>();
        List<AIA_Group_Structure_Form_Product__c> grouprodList=new List<AIA_Group_Structure_Form_Product__c>();
        Map<id,List<AIA_Group_Structure_Form_Product__c> > gsrfProdMap=new Map<id,List<AIA_Group_Structure_Form_Product__c> >();
        Map<id,AIA_Group_Structure_Form_Product__c> GSRFDentalMap=new  Map<id,AIA_Group_Structure_Form_Product__c>();
        Map<id,AIA_Group_Structure_Form_Product__c> GSRFVisionMap=new  Map<id,AIA_Group_Structure_Form_Product__c>();
        Map<id,AIA_Group_Structure_Form_Product__c> GSRFMedicalMap=new  Map<id,AIA_Group_Structure_Form_Product__c>();
        Map<id,AIA_Group_Structure_Form_Product__c> allGSRF;
        List<AIA_Group_Structure_Request_Form__c> gsrfs=new List<AIA_Group_Structure_Request_Form__c> ();
        Map<id,AIA_Group_Structure_Form_Product__c> GSRFDrugMap=new  Map<id,AIA_Group_Structure_Form_Product__c>();
        Map<ID,Schema.RecordTypeInfo> rt_Map = AIA_Group_Structure_Form_Product__c.sObjectType.getDescribe().getRecordTypeInfosById();
        system.debug('Recordtype: '+rt_Map);
        Map<id,AIA_Group_Structure_Request_Form__c> GSRFMap;
        for(AIA_Group_Structure_Form_Product__c thisGroup:listproduct){
            if(thisGroup.Group_Structure_Request_Form__c!=null){
                GSRFset.add(thisGroup.Group_Structure_Request_Form__c);
            }
        }
        if(!GSRFset.isEmpty()){
           
            map<id,List<AIA_Group_Structure_Form_Product__c>> GSRFGSDmap=new map<id,List<AIA_Group_Structure_Form_Product__c>>();
            map<id,List<AIA_Group_Structure_Form_Product__c>> GSRFGSVmap=new map<id,List<AIA_Group_Structure_Form_Product__c>>();
            map<id,List<AIA_Group_Structure_Form_Product__c>> GSRFGSDemap=new map<id,List<AIA_Group_Structure_Form_Product__c>>();
            map<id,List<AIA_Group_Structure_Form_Product__c>> GSRFGSMemap=new map<id,List<AIA_Group_Structure_Form_Product__c>>();
            Id dental=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
            Id drug=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
            Id vision=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Vision').getRecordTypeId();
            Id medical=Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get('Medical').getRecordTypeId();

            allGSRF=new Map<id,AIA_Group_Structure_Form_Product__c>([select id,Group_Structure_Request_Form__c,RecordTypeId from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c in:GSRFset]);
             for(AIA_Group_Structure_Form_Product__c thisGSRP:allGSRF.values()){
                if(rt_map.get(thisGSRP.recordTypeID).getName().containsIgnoreCase('Drug')){
                    GSRFDrugMap.put(thisGSRP.Id, thisGSRP);
                }
                else if(rt_map.get(thisGSRP.recordTypeID).getName().containsIgnoreCase('Dental')){
                    GSRFDentalMap.put(thisGSRP.Id, thisGSRP);
                }
                else if(rt_map.get(thisGSRP.recordTypeID).getName().containsIgnoreCase('Vision')){
                    GSRFVisionMap.put(thisGSRP.Id, thisGSRP);
                } 
                else if(rt_map.get(thisGSRP.recordTypeID).getName().containsIgnoreCase('Medical')){
                    GSRFMedicalMap.put(thisGSRP.Id, thisGSRP);
                }
                
            }
            
            
            for(AIA_Group_Structure_Form_Product__c thisGSP:GSRFMedicalMap.values()){
                if(GSRFGSMemap.containsKey(thisGSP.Group_Structure_Request_Form__c)){
                GSRFGSMemap.get(thisGSP.Group_Structure_Request_Form__c).add(thisGSP);
             }
             else{
                 GSRFGSMemap.put(thisGSP.Group_Structure_Request_Form__c,new List<AIA_Group_Structure_Form_Product__c>{thisGSP} );
             }   
            }
            for(AIA_Group_Structure_Form_Product__c thisGSP:GSRFDentalMap.values()){
                if(GSRFGSDemap.containsKey(thisGSP.Group_Structure_Request_Form__c)){
                GSRFGSDemap.get(thisGSP.Group_Structure_Request_Form__c).add(thisGSP);
             }
             else{
                 GSRFGSDemap.put(thisGSP.Group_Structure_Request_Form__c,new List<AIA_Group_Structure_Form_Product__c>{thisGSP} );
             }   
            }
            for(AIA_Group_Structure_Form_Product__c thisGSP:GSRFDrugMap.values()){
                if(GSRFGSDmap.containsKey(thisGSP.Group_Structure_Request_Form__c)){
                GSRFGSDmap.get(thisGSP.Group_Structure_Request_Form__c).add(thisGSP);
             }
             else{
                 GSRFGSDmap.put(thisGSP.Group_Structure_Request_Form__c,new List<AIA_Group_Structure_Form_Product__c>{thisGSP} );
             }   
            }
            for(AIA_Group_Structure_Form_Product__c thisGSP:GSRFVisionMap.values()){
                if(GSRFGSVmap.containsKey(thisGSP.Group_Structure_Request_Form__c)){
                GSRFGSVmap.get(thisGSP.Group_Structure_Request_Form__c).add(thisGSP);
             }
             else{
                 GSRFGSVmap.put(thisGSP.Group_Structure_Request_Form__c,new List<AIA_Group_Structure_Form_Product__c>{thisGSP} );
             }   
            }
            //gsrfs=[select id,Dental_of_Plans__c,Drug_of_Plans__c,Vision_of_Plans__c,Medical_of_Plans__c from AIA_Group_Structure_Request_Form__c where id in:GSRFset];commented by asif 11/22
            //system.debug('GSRFGSDemap'+GSRFGSDemap);
            //system.debug('gsrfss'+gsrfs);
            for(AIA_Group_Structure_Request_Form__c thisGsrf : [select id,Dental_of_Plans__c,Drug_of_Plans__c,Vision_of_Plans__c,Medical_of_Plans__c 
                                                                from AIA_Group_Structure_Request_Form__c 
                                                                where id in:GSRFset])
           {
                if(!GSRFGSDemap.isEmpty())
                thisGsrf.Dental_of_Plans__c=GSRFGSDemap.get(thisGsrf.id).size();
                if(!GSRFGSDmap.isEmpty())
                thisGsrf.Drug_of_Plans__c=GSRFGSDmap.get(thisGsrf.id).size();
                if(!GSRFGSVmap.isEmpty())
                thisGsrf.Vision_of_Plans__c=GSRFGSVmap.get(thisGsrf.id).size();
                if(!GSRFGSMemap.isEmpty())
                thisGsrf.Medical_of_Plans__c=GSRFGSMemap.get(thisGsrf.id).size();
                gsrfs.add(thisGsrf);
            }
            
        }
        system.debug('gsrf'+gsrfs);
        update gsrfs;
    }
    
}