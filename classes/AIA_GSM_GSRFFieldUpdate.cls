/*=================================================================================================
* Date         : 09/18/2017
* Developer    : Debkanti,Raviteja
* Purpose      : US-61 This class function to update the Processing_Type__c field on the Group Structure Request Form if the account
is renewal type and the benefit request form of account is not 'Prospect/New'

*                           
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 09/18/2017| Debkanti    |     | Initial Version
*===========+============+=====+===================================================================
*/
public class AIA_GSM_GSRFFieldUpdate {
    public static void updateProcessingType(list<AIA_Group_Structure_Request_Form__c> aiaGsrflst){
        map<id,id> impGsrf = new map<id,id>();
        //map<id,List<AIA_Group_Structure_Request_Form__c>> impGsrfold = new map<id,list<AIA_Group_Structure_Request_Form__c>>();
        map<id,id> accimpmap = new map<id,id>();
        //map<id,id> brfMap = new map<id,id>();
        map<id,id> impmap = new Map<id,id>();
        map<id,Benfit_Request_Form__c> benMap;
        map<id,AIA_Implementation__c> impMapn;
        map<id,id> impBRFmap=new Map<id,id>();
        Map<id,id> impAccmap=new Map<id,id>();
        List<AIA_Implementation__c> implementations = new List<AIA_Implementation__c>();
        //List<AIA_Implementation__c> accImpl = new List<AIA_Implementation__c>();
        List<AIA_Group_Structure_Request_Form__c> gsrfImpl = new List<AIA_Group_Structure_Request_Form__c>();
        //map<id,list<AIA_Group_Structure_Request_Form__c>> accGrp = new map<id,list<AIA_Group_Structure_Request_Form__c>>();
        //List<AIA_Group_Structure_Request_Form__c> gsrfImpl1 = new List<AIA_Group_Structure_Request_Form__c>();
        //list<id> accountId = new list<id>();
        map<id,AIA_Group_Structure_Request_Form__c> gsrfidrec= new map<id,AIA_Group_Structure_Request_Form__c>();
        
        //Iterating over new group structure request form to create map of implementation and gsrf.
        for(AIA_Group_Structure_Request_Form__c gsrf : aiaGsrflst){
            impGsrf.put(gsrf.Implementation__c, gsrf.id);
            gsrfidrec.put(gsrf.id, gsrf);
            System.debug('hhhhhh: '+impGsrf);
            System.debug('yyyyyy: '+gsrfidrec);
        }
        //Fetching the account from implementation to create map of account and gsrf
        if(!impGsrf.isEmpty()){
            implementations =[SELECT id,Account__c,Benefit_Request_Form__c FROM AIA_Implementation__c where id in :impGsrf.keySet()];
            For(AIA_Implementation__c imp :implementations ){
                accimpmap.put(imp.Account__c,impGsrf.get(imp.Id));
                impmap.put(impGsrf.get(imp.Id), imp.Account__c);
                //brfMap.put(imp.Benefit_Request_Form__c, impGsrf.get(imp.Id));
                System.debug('hhhhhh1: '+accimpmap);
                system.debug('hhhhhhh11: '+impmap);
            }
        }
        //Fetching the benefit request forms under the account and creating map of id and benefit request form values
        if(!accimpmap.isEmpty()){
            benMap = new map<id,Benfit_Request_Form__c>([SELECT id,Account__c,Status__c,Request_Type__c from Benfit_Request_Form__c where Account__c in : accimpmap.keySet()]);
            System.debug('hhhhhh2: '+benMap);
            system.debug('Ben map: '+benMap.keySet());
            
        }
        //Fetching the all implementation under the benefit request forms and creating map of id and implementation values
        //and implementation and benefit request form
        if(benMap!=null&&!benMap.isEmpty()){
            impMapn = new map<id,AIA_Implementation__c>([SELECT id,Account__c,Benefit_Request_Form__c from AIA_Implementation__c where Benefit_Request_Form__c in :benMap.keySet()]);
            System.debug('hhhhhh3: '+impMapn);
            for(AIA_Implementation__c thisImp:impMapn.values()){
                impAccmap.put(thisImp.id, thisImp.Account__c);
                impBRFmap.put(thisImp.id,thisImp.Benefit_Request_Form__c);
            }
            
        }
        //Fetching the all group structure request form  under the implementation and creating map of id and GSRF values
        //and iterating over GSRF and creating map of account and GSRF
        if(impMapn!=null &&!impMapn.isEmpty()){
            gsrfImpl = [SELECT id,Processing_Type__c,Implementation__c From AIA_Group_Structure_Request_Form__c where Implementation__c in : impMapn.keySet() ORDER BY CreatedDate ASC];
            System.debug('hhhhhh4: '+gsrfImpl);
            map<id,AIA_Group_Structure_Request_Form__c> accidgsrfMap=new map<id,AIA_Group_Structure_Request_Form__c>();        
            for(AIA_Group_Structure_Request_Form__c gsrfn : gsrfImpl){
                system.debug('hhhhhh5: '+gsrfn);
                if(!gsrfidrec.containsKey(gsrfn.Id)){
                    if(accidgsrfMap.get(gsrfn.Implementation__c)!=null){
                        //accidgsrfMap.get(impAccmap.get(gsrfn.Implementation__c)).add(gsrfn);
                        continue;
                    }
                    else{
                        accidgsrfMap.put(impAccmap.get(gsrfn.Implementation__c),gsrfn );
                    }
                }
            }
            //system.debug('account with latest gsrf'+accidgsrfMap);
            system.debug(aiaGsrflst);
            //Iterating over the GSRF and updating the field Processing Type baesd on the criteria form the latest created 
            // group structure request form
            List<AIA_Group_Structure_Request_Form__c> updategsrf=new List<AIA_Group_Structure_Request_Form__c>();
            for(AIA_Group_Structure_Request_Form__c gsrfne : aiaGsrflst){
                system.debug('ani 11'+gsrfne);
                if(impBRFmap.containsKey(gsrfne.Implementation__c) && impAccmap.containsKey(gsrfne.Implementation__c) && benMap.containsKey(impBRFmap.get(gsrfne.Implementation__c)) && accidgsrfMap.containsKey(impAccmap.get(gsrfne.Implementation__c))){
                    /*system.debug('-----SMSL--->'+benMap.get(impBRFmap.get(gsrfne.Implementation__c)).Request_Type__c);
                    system.debug('-----SMSL--->'+benMap.get(impBRFmap.get(gsrfne.Implementation__c)).Request_Type__c);
                    system.debug('-----SMSL--->'+accidgsrfMap.get(impAccmap.get(gsrfne.Implementation__c))!=null);
                    */
                    if( benMap.get(impBRFmap.get(gsrfne.Implementation__c)).Request_Type__c!='Prospect/New' && accidgsrfMap.get(impAccmap.get(gsrfne.Implementation__c))!=null){
                        system.debug('ani 22 ');
                        AIA_Group_Structure_Request_Form__c gsrftobeupdated=new AIA_Group_Structure_Request_Form__c();
                        gsrftobeupdated.id=gsrfne.id    ;
                        gsrftobeupdated.Processing_Type__c=accidgsrfMap.get(impAccmap.get(gsrfne.Implementation__c)).Processing_Type__c;
                        updategsrf.add(gsrftobeupdated);
                    }
                }
            }
            try{
                update updategsrf;   
            }
            catch(Exception e){
                AIA_Utils errLogExp = new AIA_Utils();
                System.debug('Error occurred--->'+e.getMessage());
                errLogExp.logException(e);
            }
        }
    }
    
}