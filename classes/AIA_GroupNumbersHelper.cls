/*===================================================================================================================
* Date       : 06/10/2017
* Developer  : Sajitha Y
* Purpose    : Drawloop: Class updates Group Name on GSRF Record US-87
*                                 Update History
*                                 ---------------
* Date       |     Developer        | Tag |   Description
*============+============+=========================================================================================
* 06/10/2017 |     Sajitha Y        |     | Initial Version
*============+============+=========================================================================================
*/
public class AIA_GroupNumbersHelper {
    public static void UpadteGroupNumbers(List<AIA_Group__c> listGroup,String event) {
        Map<id,List<AIA_Group__c> > GSRFGmap =new Map<id,List<AIA_Group__c> >();
        List<AIA_Group__c> groupList=new List<AIA_Group__c>();
        //map holding GSRFid and Groups
        Map<id,List<AIA_Group__c> > gsrfGroupMap=new Map<id,List<AIA_Group__c> >();
        Map<id,AIA_Group_Structure_Request_Form__c> GSRFMap;
        set<string> gsrfids = new set<string>();
        // Add the gsrfids to set
        for(AIA_Group__c grpnums :listGroup){
            gsrfids.add(grpnums.Group_Structure_Request_Form__c);
        }
        
        if(!gsrfids.isEmpty()){
            //fetch and create map of gsrfId and Gsrf record
            //indented to cover code. no logic change.
            GSRFMap=new Map<id,AIA_Group_Structure_Request_Form__c>([select id,Group_Numbers_Drawloop__c 
                                                                     from AIA_Group_Structure_Request_Form__c where id in:gsrfids]);
            //fetch all the related Groups related to GSRF
            groupList=[select id,name,Group_Structure_Request_Form__c,Group_Structure_Request_Form__r.Group_Numbers_Drawloop__c 
                       from AIA_Group__c where Group_Structure_Request_Form__c in:GSRFMap.keySet()];
            //Create map of Group records
            for(AIA_Group__c grps:groupList){
                if(gsrfGroupMap.containsKey(grps.Group_Structure_Request_Form__c)){
                    gsrfGroupMap.get(grps.Group_Structure_Request_Form__c).add(grps);
                }
                else{
                    gsrfGroupMap.put(grps.Group_Structure_Request_Form__c,new List<AIA_Group__c>{grps} );
                }
            }
            
            if(!gsrfGroupMap.isEmpty()){
                //Iterate GSRF and related groups
                for(Id gsrfid:gsrfGroupMap.keySet()){
                    String groupnumbers='';
                    List<AIA_Group__c> groupsList=gsrfGroupMap.get(gsrfid);
                    for(AIA_Group__c grp:groupsList){
                        groupnumbers+=grp.name+',';
                    }
                    groupnumbers=groupnumbers.removeEnd(',');
                    GSRFMap.get(gsrfid).Group_Numbers_Drawloop__c=groupnumbers;
                }     
            }
            
        }
        try{
            update GSRFMap.values();  
        }
        catch(Exception e){
            AIA_Utils errLogExp = new AIA_Utils();
            errLogExp.logException(e);
        }
        
    }
}