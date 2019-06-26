/*=================================================================================================================
 * Date         : 04/26/2018
 * Developer    : Gayathri Palanisamy
 * Purpose      : This class is used in AIA_NewTaskNotification_Batch to get the manager details as part of US197.
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 *===========+=================+=====+=============================================================================
 */
public class AIA_GetAreaManager {

    /** Method to the Manager Is's with respect to the owner Id of the Task based on Area Mapping**/
    public static Map<Id,Set<Id>> getManagerId(Set<Id> userId)
    {
        //Getting Area Mapping for the users
		List<AIA_Area_Manager__c> areaLst = [select id,name,Area_Manager__c,Area_Belong_to__c from AIA_Area_Manager__c where Area_Manager__c IN : userId];
		Map<Id,Set<Id>> userManagerMap = new Map<Id,Set<Id>>();
		Map<Id,String> areaMap = new Map<Id,String>();
		//Iterating the area mapping list to map the area belong the user
        for(AIA_Area_Manager__c area:areaLst)
		{
  		if(area.Area_Belong_to__c != null)
            areaMap.put(area.Area_Manager__c,area.Area_Belong_to__c);  
		}
		List<String> strLst = new List<String>();
		String areaManaged='';
		for(String s:areaMap.Values())
		{
    		strLst.addall(s.split(';'));
 		}
		for(String st : strLst)
		{
 			areaManaged = areaManaged + '\''+st+'\',' ;  
		}
        if(areaManaged.length() > 0)
        {
         areaManaged = areaManaged.subString(0,areaManaged.length()-1);
		
		String query = 'select id,name,Area_Manager__c,Area_Belong_to__c,Areas__c from AIA_Area_Manager__c where Areas__c INCLUDES (';
		query+= areaManaged+')';
		//Querying the area mapping with respect to area belong to
        List<AIA_Area_Manager__c> areaLst1 =(List<AIA_Area_Manager__c>)Database.query(query);
		Map<String,Set<ID>> areamngdMap = new Map<String,Set<ID>>();
		//Iterating to map the manager Id with reapect to area
        for(AIA_Area_Manager__c area1:areaLst1)
		{
        	List<String> areaMngLst = new List<String>(); 
    		areaMngLst.addall(area1.Areas__c.split(';'));
    		for(String s: areaMngLst)
    		{
      			if(areamngdMap.containsKey(s))
      			{
        			Set<Id> mngId = new Set<Id>();
        			mngId = areamngdMap.get(s);
        			mngId.add(area1.Area_Manager__c);
        			areamngdMap.put(s,mngId);
      			}
        		else{
          			Set<Id> mngId = new Set<Id>();
          			mngId.add(area1.Area_Manager__c);
          			areamngdMap.put(s,mngId);  
        		}
    		}
		}
		//Iterating to map the user Id and corresponding Manager Id
		for(Id usrmng:userId)
		{
    		List<String> areaBelongs = new List<String>();
            if(areaMap.get(usrmng) != null)
    			areaBelongs.addall(areaMap.get(usrmng).split(';')) ;
    		for(String s : areaBelongs)
    			{
      			if(userManagerMap.containsKey(usrmng))
      			{
        			Set<Id> mngId = new Set<Id>();
        			mngId = userManagerMap.get(usrmng);
          			if(areamngdMap.get(s) != null)
                    {
                    mngId.addall(areamngdMap.get(s));
        			userManagerMap.put(usrmng,mngId);
                    }
      			}
        		else{
          			Set<Id> mngId = new Set<Id>();
                    if(areamngdMap.get(s) != null)
                    {
          			mngId.addall(areamngdMap.get(s));
          			userManagerMap.put(usrmng,mngId);
                    }
        		}  
    	}
    
		}
        
		
    }
        return userManagerMap;
    }
    
    
}