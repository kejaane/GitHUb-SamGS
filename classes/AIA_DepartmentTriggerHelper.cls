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
public class AIA_DepartmentTriggerHelper {
 public static void updateGroupCount(List<AIA_Department__c> listdeps) {
		Set<ID> gsrfids=new Set<ID>();
        Map<id,List<AIA_Department__c>> gspsdeps=new Map<id,List<AIA_Department__c>>();
        for(AIA_Department__c thisdep:listdeps){
            gsrfids.add(thisdep.Group_Structure_Request_Form__c);
        }
        Map<id,AIA_Group_Structure_Form_Product__c> GSPMap=new Map<id,AIA_Group_Structure_Form_Product__c>([select id,Groups_count__c,Deps_Count__c,packages_count__c from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c in:gsrfids]);
        List<AIA_Department__c> alldepssgsps=[select id,Group_Structure_Request_Form_Product__c 
                                    from AIA_Department__c 
                                    where Group_Structure_Request_Form_Product__c in:GSPMap.keySet()];
    	//create map of all gsps and packages
        for(AIA_Department__c thisdep:alldepssgsps){
             if(gspsdeps.containsKey(thisdep.Group_Structure_Request_Form_Product__c)){
                gspsdeps.get(thisdep.Group_Structure_Request_Form_Product__c).add(thisdep);
            }
            else{
                gspsdeps.put(thisdep.Group_Structure_Request_Form_Product__c,new List<AIA_Department__c>{thisdep} );
            }
        }
        system.debug('map'+gspsdeps);
		 if(GSPMap!=null){
                //Iterate GSRF and related groups
                for(AIA_Group_Structure_Form_Product__c thisgsp:GSPMap.values()){
                    Integer depcount;
                    if(!gspsdeps.containsKey(thisgsp.id)){
                        depcount=0;
                    }
                    else{
                    depcount=gspsdeps.get(thisgsp.id).size();
                    }
                    //update gsp count if there are no line items
                    thisgsp.Deps_Count__c=String.valueOf(depcount);
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