/*=================================================================================================================
* Date         : 09/21/2017
* Developer    : Satya Tirumalasetti
* Purpose      : This class is used to check the conditions/rules for task creation and will be called from 
*                AIA_Workplan_Task_Management class
*============+================+=====+=============================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 09/21/2017 | Satya          |     | Initial Version
* 04/15/2019 | Satya          |T01  | Commented the system.debug statements inside for loops
*===========+============+========================================================================================
*/

public with sharing class AIA_WorkplanTask_RulesCriteria
{
        
    Private Integer Count;
    public AIA_WorkplanTask_RulesCriteria()
    {
        Count = 100;  
    }
    
    public Boolean checkCritetia(Map<String,Boolean> ruleMap,String strCondition)
    {
        Boolean result = false;
        List<String> lstConditionswithinBrackets = new List<String>();
        if(strCondition.Contains(' AND ') || strCondition.Contains(' OR '))
        {
            
            Pattern p = Pattern.compile('\\((.*?)\\)');
            Matcher m = p.matcher(strCondition);
            while (m.find()) {
              //system.debug('==============' + m.group(1)); //T01
              lstConditionswithinBrackets.add(m.group(1));  
            }
             //System.debug('###lstConditionswithinBrackets : '+lstConditionswithinBrackets);//T01
             //system.debug('strConditionBefore========' +strCondition );//T01
            for(String strWithInBrack:lstConditionswithinBrackets)
            {
                Boolean tmpResult = getResult(strWithInBrack,ruleMap);
                ruleMap.put(String.ValueOf(Count),tmpResult);
                string tmpStr = '(' + strWithInBrack + ')';
                 //system.debug('tmpStr ========' +tmpStr );//T01
                strCondition = strCondition.replace(tmpStr ,String.ValueOf(Count));
                 //system.debug('strConditionInside========' +strCondition );//T01
                Count = Count+1;
            }
            //system.debug('strCondition ========' +strCondition );//T01
            result = getResult(strCondition,ruleMap);
            //system.debug('FinallResult========' +result );//T01
        }
        else{
            //system.debug('SingleValaue========' +strCondition );//T01
            result = ruleMap.get(strCondition.trim());
            //system.debug('SingleValaueresult========' +result );//T01
        }
        return result ;
    }
    
    public boolean getResult(String strCondition,Map<String,Boolean> ruleMap)
    {
        boolean finalResult = false;
        List<String> lstANDValues = new List<String>();
        string tmpString = strCondition;
        Pattern p = Pattern.compile('(?:\\S+\\s)?\\S*AND\\S*(?:\\s\\S+)?'); //Pattern to check AND condition

        Matcher m = p.matcher(strCondition);
        while (m.find()) {
                lstANDValues.add(m.group());
            tmpString = tmpString.replace(m.group(),'');
               // System.debug('###lstANDValues : '+lstANDValues);
        }
        //System.debug('###tmpString : '+tmpString);//T01
        
        Boolean finalANDResult = false;
        
        //loop through all the AND values list
        for(String strAndvalue:lstANDValues)
        {
            List<String> srsplit = strAndvalue.split('AND');
            //system.debug('ruleMap========' + ruleMap); //T01
            if(srsplit.size()>0 )
            {
                //system.debug('finalANDResult========' + srsplit);//T01
                //system.debug('srsplit[0]========' + srsplit[0].trim());//T01
                // system.debug('srsplit[1]========' + srsplit[1].trim());//T01
                if(srsplit.size() == 1)
                {
                //system.debug('inside ==1 ');//T01
                    if(lstANDValues.size() > 1){
                   // system.debug('inside ==1 and >1');//T01
                        finalANDResult = (finalANDResult && ruleMap.get(srsplit[0].trim()));
                    }else
                        finalANDResult = ruleMap.get(srsplit[0].trim());
                }
                else if(srsplit.size() > 1 && srsplit[0].trim() == '')
                {
               // system.debug('inside == ');//T01
                    if(lstANDValues.size() > 1){
                   // system.debug('inside ==;; and >1');//T01
                        finalANDResult = (finalANDResult && ruleMap.get(srsplit[1].trim()));
                   } else
                        finalANDResult = ruleMap.get(srsplit[1].trim());
                }
                else if(srsplit.size()>1)
                {
                //system.debug('ruleMap--'+ruleMap);//T01
               // system.debug('srsplit[0].trim()'+srsplit[0].trim());//T01
                //system.debug('srsplit[1].trim()'+srsplit[1].trim());//T01
                    if(lstANDValues.size() > 1){
                        finalANDResult = (finalANDResult || (ruleMap.get(srsplit[0].trim()) && ruleMap.get(srsplit[1].trim())));
                         //system.debug('entered if');
                    }else{
                    
                        finalANDResult = (ruleMap.get(srsplit[0].trim()) && ruleMap.get(srsplit[1].trim()));
                        //system.debug('entered else');//T01
                        }
                       // system.debug('finalANDResult========' + finalANDResult);//T01
                }
                
            }
            
        }
        //system.debug('finalANDResult========' + finalANDResult); 
        List<String> lstORValues = new List<String>();
        Pattern pOR = Pattern.compile('(?:\\S+\\s)?\\S*OR\\S*(?:\\s\\S+)?'); //Pattern to check OR condition

        Matcher mOR = pOR.matcher(tmpString);
        while (mOR.find()) {
                //System.debug('###lstORValues : '+mOR.group());//T01
                lstORValues.add(mOR.group()); 
        }
        Boolean finalORResult = false;
        for(String strOrvalue:lstORValues)
        {
            List<String> srsplit = strOrvalue.split('OR');
            if(srsplit.size()>0 )
            {
                 //system.debug('finalORResult========' + srsplit);
                //system.debug('ORsrsplit[0]========' + srsplit[0]);
                // system.debug('ORsrsplit[1]========' + srsplit[1]);
            
                               
                if(srsplit.size() == 1)
                {
               // system.debug('inside ==1 ');//T01
                    if(lstORValues.size() > 1)
                        finalORResult = (finalORResult || ruleMap.get(srsplit[0].trim()));
                    else
                        finalORResult = ruleMap.get(srsplit[0].trim());
                }
                else if(srsplit.size() > 1 && srsplit[0].trim() == '')
                {
               // system.debug('inside == ');//T01
                    if(lstORValues.size() > 1)
                        finalORResult = (finalORResult || ruleMap.get(srsplit[1].trim()));
                    else
                        finalORResult = ruleMap.get(srsplit[1].trim());
                }
                else if(srsplit.size()>1)
                {
               // system.debug('inside ==>1 ');//T01
                    if(lstORValues.size() > 1)                        
                        finalORResult = (finalORResult || (ruleMap.get(srsplit[0].trim()) || ruleMap.get(srsplit[1].trim())));
                    else
                        finalORResult = (ruleMap.get(srsplit[0].trim()) || ruleMap.get(srsplit[1].trim()));
                    
                }
                    
            }
            
        }
        //system.debug('finalORResult========' + finalORResult); //T01
        finalResult  = (finalANDResult || finalORResult);

       // system.debug('finalResult  ========' + finalResult  );//T01 
                return finalResult ;
    }
}