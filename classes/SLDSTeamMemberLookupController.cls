/*=========================================================================================
 * Date         : 04/23/2018
 * Developer    : Rajesh Pennam
 * Purpose      : This is the VF Component controller used for SLDSTeamMemberLookup
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer        Tag         Description
 *============================================================================================
   01/18/2018|Rajesh Pennam| T01   | Intial Developement
 *=========================================================================================
 
 */



public class SLDSTeamMemberLookupController {
    // public variables 
    public String objectName{get;
        set{
            if(objectName != value){
                objectName = value;
                objectLabelPlural = Schema.getGlobalDescribe().get(ObjectName).getDescribe(). getLabelPlural();
            }
        }
        
    }
    
    public String label{
        get;
        set{
            label = value;
            uniqueComponentId = label.replace(' ', '').toLowerCase();
        }
    }
    
    public String uniqueComponentId{get;set;}
    public String objectLabelPlural{get;set;}
    
    /**
     * Remote action method to send list of records
     * @param  searchText 
     * @return  List<Wrapper>
     */
    @RemoteAction
    public static List<Wrapper> search(String objectName, String displayFieldNames, String fieldsPattern, String photoValue, String searchText ,String userMap){
        List<Wrapper> results = new List<Wrapper>();
        System.debug('userMap**'+userMap);
        
        String value = userMap;
         String photoToDisplay;
        value = value.substring(1, value.length()-1);           //remove curly brackets
        String[] keyValuePairs = value.split(',');              //split the string to creat key-value pairs
        Map<String,String> membermap = new Map<String,String>();               
    
        for(String pair : keyValuePairs)                        //iterate over the pairs
        {
            String[] entry = pair.split('=');                   //split the pairs to get key and value 
            membermap.put(entry[0].trim(), entry[1].trim());          //add them to the hashmap and trim whitespaces
        }
        system.debug('membermap%%'+membermap);
        for(String strID : membermap.Keyset()){
            system.debug('strID**'+strID);
            //if(membermap.get(strID).contains(searchText)){
            if(membermap.get(strID).containsIgnoreCase(searchText)){
                results.add(new Wrapper(strID, membermap.get(strID),photoToDisplay));
            }
        }
        
        system.debug('results**'+results);
        
        
        return results;
    }
    
    
    /*************************************************************************
     ******************************* WRAPPER **************************************
     ****************************************************************************/
    public class Wrapper{
        public Id recordId{get;set;}
        public String displayValue{get;set;}
        public String photoUrl{get;set;}
        public Wrapper(Id recordId, String displayValue,string photoUrl){
            this.recordId = recordId;
            this.displayValue = displayValue;
            this.photoUrl = photoUrl;
        }
    }
    
    public void testnMethod(){
        system.debug('Testing***');
        
    }

}