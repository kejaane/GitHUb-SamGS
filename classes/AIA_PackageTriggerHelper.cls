/*=================================================================================================
* Date         : 11/17/2017
* Developer    : Raviteja
* Purpose      : Drawloop This class function is to check count of all line items and update in gsp
*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 11/17/2017| Raviteja    |     | Initial Version                                         
*===========+============+=====+===================================================================
*/
public class AIA_PackageTriggerHelper {
public static void updateGroupCount(List<AIA_Package__c> listpckgs) {
		Set<ID> gsrfids=new Set<ID>();
        Map<id,List<AIA_Package__c>> gspspckgs=new Map<id,List<AIA_Package__c>>();
        for(AIA_Package__c thisp:listpckgs){
            gsrfids.add(thisp.Group_Structure_Request_Form__c);
        }
        Map<id,AIA_Group_Structure_Form_Product__c> GSPMap=new Map<id,AIA_Group_Structure_Form_Product__c>([select id,Groups_count__c,Deps_Count__c,packages_count__c from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c in:gsrfids]);
        List<AIA_Package__c> allpckgsgsps=[select id,Group_Structure_Request_Form_Product__c 
                                    from AIA_Package__c 
                                    where Group_Structure_Request_Form_Product__c in:GSPMap.keySet()];
    	//create map of all gsps and packages
        for(AIA_Package__c thisp:allpckgsgsps){
             if(gspspckgs.containsKey(thisp.Group_Structure_Request_Form_Product__c)){
                gspspckgs.get(thisp.Group_Structure_Request_Form_Product__c).add(thisp);
            }
            else{
                gspspckgs.put(thisp.Group_Structure_Request_Form_Product__c,new List<AIA_Package__c>{thisp} );
            }
        }
        system.debug('map'+gspspckgs);
		 if(GSPMap!=null){
                //Iterate GSRF and related groups
                for(AIA_Group_Structure_Form_Product__c thisgsp:GSPMap.values()){
                    Integer packagecount;
                    if(!gspspckgs.containsKey(thisgsp.id)){
                        packagecount=0;
                    }
                    else{
                    packagecount=gspspckgs.get(thisgsp.id).size();
                    }
                    
                    //update gsp count if there are no line items
                    thisgsp.packages_count__c=String.valueOf(packagecount);
                    if(thisgsp.Deps_Count__c=='0' && thisgsp.packages_count__c=='0' && thisgsp.Groups_count__c=='0'){
                        thisgsp.total_count__c='true';
                    }else{
                        thisgsp.total_count__c='false';
                    }
                }
            update GSPMap.values();
         }
        
    }
}