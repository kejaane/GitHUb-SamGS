/*=========================================================================================
 * Date         : 06/14/2017
 * Developer    : Sajitha Yalamanchili
 * Purpose      : This Class is used to send BDP Id to AIA_PCSIntializeGroupersLimitations
 *                and to get valid JSON Response
 *                      
 *                                  Update History
 *                                 ---------------
 * Date      |     Developer        | Tag |  Description
 *===========+============+================================================================
 *06/14/2017 | Sajitha Yalamanchili |     | Initial Version
 *06/14/2017| Ravi Teja Vadapalli  | T02 | Serializing PCSJsonObj to get valid return response
 *===========+============+================================================================
*/
public with sharing class AIA_OP4PCSJSONGenerator {
    public String getBDP(String bpdid){
        //Initialize AIA_PCSIntializeGroupersLimitations and send BDP Id to generateJSONContentForBPD method
        AIA_OP4PCSIntializeGroupersLimitations populatedata = new AIA_OP4PCSIntializeGroupersLimitations();
        populatedata.generateJSONContentForBPD(bpdid); 
        //populate the pcsjsonobj from the other classes. 
        AIA_OP4PCSJSONStructure pcsJsonObj=populatedata.pcsJsonObj;
        // T02-Start
        string jstring = JSON.serializePretty(pcsJsonObj, true);
        jstring=JSON.serialize(JSON.deserializeUntyped(jstring));
        jstring.remove('\\');
        system.debug(jstring);
        return jstring;//T02-End
    }
}