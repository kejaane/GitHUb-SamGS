/*=================================================================================================
* Date         : 09/18/2017
* Developer    : Raviteja
* Purpose      : Drawloop This class function is to check count of all line items and update in gsp.
*                Restricting Maintech role while updating Groups data.
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 09/18/2017| Raviteja    |     | Initial Version                                         
* 10/06/2017| Raviteja    |  T01 | commented as per us 234 changes
*===========+============+=====+===================================================================
*/
public class AIA_GroupHelper {
    /*Method to check if there are any Alpha prefixes  */
    /*T01 start
    public static void checkAlphaPrefixMissing(List<AIA_Group__c> listGroup,String event) {
        Map<id,List<AIA_Group__c> > GSRFGmap =new Map<id,List<AIA_Group__c> >();
        List<AIA_Group__c> groupList=new List<AIA_Group__c>();
        //map holding GSRFid and Groups
        Map<id,List<AIA_Group__c> > gsrfGroupMap=new Map<id,List<AIA_Group__c> >();
        Map<id,AIA_Group_Structure_Request_Form__c> GSRFMap;
        for(AIA_Group__c thisGroup:listGroup){
            
             if(GSRFGmap.containsKey(thisGroup.Group_Structure_Request_Form__c)){
                GSRFGmap.get(thisGroup.Group_Structure_Request_Form__c).add(thisGroup);
             }
             else{
                 GSRFGmap.put(thisGroup.Group_Structure_Request_Form__c,new List<AIA_Group__c>{thisGroup} );
             }
        }
        if(!GSRFGmap.isEmpty()){
        //fetch and create map of gsrfId and Gsrf record
        GSRFMap=new Map<id,AIA_Group_Structure_Request_Form__c>([select id,Alpha_Prefix_is_missing__c from AIA_Group_Structure_Request_Form__c where id in:GSRFGmap.keySet()]);
        
        //fetch all the related Groups related to GSRF
        groupList=[select id,Alpha_Prefix__c,Group_Structure_Request_Form__c from AIA_Group__c where Group_Structure_Request_Form__c in:GSRFGmap.keySet()];
        //map holding GSRFid and Groups
        for(AIA_Group__c thisGroup:groupList){
            if(gsrfGroupMap.containsKey(thisGroup.Group_Structure_Request_Form__c)){
                gsrfGroupMap.get(thisGroup.Group_Structure_Request_Form__c).add(thisGroup);
             }
             else{
                 gsrfGroupMap.put(thisGroup.Group_Structure_Request_Form__c,new List<AIA_Group__c>{thisGroup} );
             }
            
        }
      //iterate through GSRF Map and find if there is alpha prefix for respective groups or not
        if(!gsrfGroupMap.isEmpty()){
        for(Id thisGSRF:gsrfGroupMap.keySet()){
            List<AIA_Group__c> groupsList=gsrfGroupMap.get(thisGSRF);
            Boolean AlphaPrefixmissing=true;
            //system.debug('groupsList.size()'+groupsList.size());
            for(AIA_Group__c thisGroup:groupsList){
                if(thisGroup.Alpha_Prefix__c==''||thisGroup.Alpha_Prefix__c==null){
                    AlphaPrefixmissing=false;
                    break;
                }
               
            }
            GSRFMap.get(thisGSRF).Alpha_Prefix_is_missing__c=AlphaPrefixmissing;
        }
            
       }
       
       }
        for(Id thisGSRF:GSRFGmap.keySet()){
                List<AIA_Group__c> groupsList=GSRFGmap.get(thisGSRF);
                if(!gsrfGroupMap.containsKey(thisGSRF)&&groupsList.size()==1)   {
                    GSRFMap.get(thisGSRF).Alpha_Prefix_is_missing__c=false;
                }             
            }
            try{
                update GSRFMap.values();   
            }
            catch(Exception e){
                AIA_Utils errLogExp = new AIA_Utils();
                System.debug('Error occurred--->'+e.getMessage());
                errLogExp.logException(e);
            }
    }
    */
    //Method to avoid Maintech to edit any other field other than Alpha prefix
    public static void checkMaintech(map<id,Sobject> listGroup,map<id,Sobject> oldlistGroup){
       /* Map<id,List<AIA_Group__c> > GSRFGmap =new Map<id,List<AIA_Group__c> >();
        Map<id,id> impMainmap=new Map<id,id>();
        map<id,id> gsrfimp=new map<id,id>();
        final string mainrole='MAIN Tech';
        set<string> impset = new set<string>();
        map<string,set<AccountTeamMember>> teammemmap = new map<string,set<AccountTeamMember>>();
        List<AIA_Group_Structure_Request_Form__c> gsrfList=new List<AIA_Group_Structure_Request_Form__c>();
        for(AIA_Group__c thisGroup:(List<AIA_Group__c>)listGroup.values()){
            //if(thisGroup.Group_Structure_Request_Form__c!=null){
            //    GSRFset.add(thisGroup.Group_Structure_Request_Form__c);
            //}
             if(GSRFGmap.containsKey(thisGroup.Group_Structure_Request_Form__c)){
                GSRFGmap.get(thisGroup.Group_Structure_Request_Form__c).add(thisGroup);
             }
             else{
                 GSRFGmap.put(thisGroup.Group_Structure_Request_Form__c,new List<AIA_Group__c>{thisGroup} );
             }
        }
        //create impset from gsrf list
        for(AIA_Group_Structure_Request_Form__c gsrf:[select id,Implementation__c 
                                                      from AIA_Group_Structure_Request_Form__c
                                                      where id in:GSRFGmap.keySet()]){
                impset.add(gsrf.Implementation__c);
                gsrfimp.put(gsrf.id,gsrf.Implementation__c);                                          
        }
         if(!impset.isEmpty()){
            //get all account team members related to this implementations set
            teammemmap = AIA_GSM_GSRFHelperClass.accountteammembers(impset);
            //system.debug('teammemmap'+teammemmap);
        }
        if(!teammemmap.isEmpty()){
            for(Id thisImp:impset){
               Id memid;
               //system.debug('teammemmap.get(thisImp)'+teammemmap.get(thisImp));
               //repeat all roles
                for(AccountTeamMember thisMem:teammemmap.get(thisImp) ) {
                   //if teammem is maintech,capture his userid
                    if(thisMem.TeamMemberRole==mainrole){
                        memid=thisMem.UserId;
                    } 
                }
                impMainmap.put(thisImp, memid);
                
            }
        }
        Map<String,Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get('AIA_Group__c');
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {                    
                  
            for(AIA_Group__c thisGroup:(List<AIA_Group__c>)listGroup.values()){
                Id loggedinUser=UserInfo.getUserId();
                Id thisgroupsmain=impMainmap.get(gsrfimp.get(thisGroup.Group_Structure_Request_Form__c));
                if(loggedinUser==thisgroupsmain){
                    //system.debug('can change only alpha prefix');
                    //system.debug('oldlistGroup.get(thisGroup.id).get(fieldName)'+oldlistGroup.get(thisGroup.id).get(fieldName));
                   if(oldlistGroup.get(thisGroup.id).get(fieldName)!=Trigger.newMap.get(thisGroup.id).get(fieldName) 
                      && fieldName!='Alpha_Prefix__c' ){ 
                         // system.debug('in if');
                              //thisGroup.addError('MAIN tech can only edit Alpha prefix value.');
                              thisGroup.addError('MAIN tech cannot edit.');
                   }
               }
                
            }
            
        }*/
        
    }
    public static void updateGroupCount(List<AIA_Group__c> listGroup) {
        Set<ID> gsrfids=new Set<ID>();
        Map<id,List<AIA_Group__c>> gspsgrps=new Map<id,List<AIA_Group__c>>();
        for(AIA_Group__c thisgrp:listGroup){
            gsrfids.add(thisgrp.Group_Structure_Request_Form__c);
        }
        Map<id,AIA_Group_Structure_Form_Product__c> GSPMap=new Map<id,AIA_Group_Structure_Form_Product__c>([select id,Groups_count__c,Deps_Count__c,packages_count__c from AIA_Group_Structure_Form_Product__c where Group_Structure_Request_Form__c in:gsrfids]);
        List<AIA_Group__c> allgrpsgsps=[select id,Group_Structure_Request_Form_Product__c 
                                    from AIA_Group__c 
                                    where Group_Structure_Request_Form_Product__c in:GSPMap.keySet()];
        //create map of all gsps and groups
        for(AIA_Group__c thisgrp:allgrpsgsps){
             if(gspsgrps.containsKey(thisgrp.Group_Structure_Request_Form_Product__c)){
                gspsgrps.get(thisgrp.Group_Structure_Request_Form_Product__c).add(thisgrp);
            }
            else{
                gspsgrps.put(thisgrp.Group_Structure_Request_Form_Product__c,new List<AIA_Group__c>{thisgrp} );
            }
        }
        //system.debug('map'+gspsgrps);
         if(GSPMap!=null){
                //Iterate GSRF and related groups
                for(AIA_Group_Structure_Form_Product__c thisgsp:GSPMap.values()){
                    Integer grpcount;
                    if(!gspsgrps.containsKey(thisgsp.id)){
                        grpcount=0;
                    }
                    else{
                    grpcount=gspsgrps.get(thisgsp.id).size();
                    }
                    //update gsp count if there are no line items
                    thisgsp.Groups_count__c=String.valueOf(grpcount);
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