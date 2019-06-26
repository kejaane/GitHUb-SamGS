/*=================================================================================================
* Date         : 08/28/2017
* Developer    : Raviteja
* Purpose      : US-60: This class Creates Group structure products on Group structure from creation
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 08/28/2017| Raviteja    |     | Initial Version                                         
* 10/23/2017| Raviteja    | T01 | Code for related medical Group Structure product    
* 09/14/2018| Asif K      | T02 | Modified as part of US771 to default GSP recordtype as Medical,
*							      when Proposed Product recordtype is Medical Risk or Medical ASO
*===========+============+=====+===================================================================
*/
public class AIA_GroupStructureFormTriggerHelper {
    public Static Boolean beforeupdateRecursive=false;
    //Method to create the Parents GS products with the parent product name for the list of group structure and assocaited brfid.
    public static void createGSParentProducts (List<AIA_Group_Structure_Request_Form__c>  lstAIAGSRF){
        Set<Id> BRFIds = new Set<Id>();
        Map<ID,ID> impGsrf = new Map<ID,ID>();
        //T01 start
        Map<id,id> ppGsp=new Map<id,id>();
        Map<id,id> ppRelatedmedical=new Map<id,id>(); 
        List<AIA_Group_Structure_Form_Product__c> gspsCreated=new List<AIA_Group_Structure_Form_Product__c>();
        //T01 end
        try{
            //Map t0 store the BRF and the related products
            Map<string, List<Proposed_Products__c>> mapBRFProducts =new  Map<string, List<Proposed_Products__c>>();
            //Map to store the Parent product and related proposed products
            Map<string, List<Proposed_Products__c>> mapParentProductsPP =new  Map<string, List<Proposed_Products__c>>();
            // List of GSP to create for the GS 
            List<AIA_Group_Structure_Form_Product__c> createGSProductsList= new List<AIA_Group_Structure_Form_Product__c>();
            //System.debug('ImpID1: '+impId);
            List<AIA_Implementation__c> implementations = new List<AIA_Implementation__c>();
            map<id,List<id>> brfimpmap = new map<id,List<id>>();
            //loop through the GS
            for (AIA_Group_Structure_Request_Form__c gs : lstAIAGSRF)
            {
                impGsrf.put(gs.Implementation__c,gs.id);
                
            }
            //fetching implementation related to group structure request form
            implementations =[SELECT Benefit_Request_Form__c FROM AIA_Implementation__c where id in :impGsrf.keySet()];
            for(AIA_Implementation__c imp :implementations){
                
               if(brfimpmap.containsKey(imp.Benefit_Request_Form__c)){
                    brfimpmap.get(imp.Benefit_Request_Form__c).add(imp.id);
                 }
                 else{
                     brfimpmap.put(imp.Benefit_Request_Form__c,new List<id>{imp.id} );
                 }
               // brfimpmap.put(imp.Benefit_Request_Form__c,imp.id);
            }
            List<Proposed_Products__c> proposedProducts=new List<Proposed_Products__c>();
            //Fatching proposed product related to benefit request form
            proposedProducts=[SELECT id,Related_Medical_Product__c,Benefit_Request_Form__c,Deductible__c,Plan_Name__c,  Product_Line__c,Product_Category__c,Funding_Arrangement__c,BRF_Account__r.BillingState,BRF_Account__r.Billing_County_Code__c,Account_Specified_Product_Name__c,recordtype.name FROM Proposed_Products__c where Recordtype.name!='CareFirst Private exchange' and Benefit_Request_Form__c in :brfimpmap.keySet()];
            //Iterating over proposed product and creating group structure form poduct
          
            for(Proposed_Products__c prop :proposedProducts){
                ppRelatedmedical.put(prop.id, prop.Related_Medical_Product__c);
                //Id gsrf=impGsrf.get((brfimpmap.get(prop.Benefit_Request_Form__c)));
                List<id> impids=brfimpmap.get(prop.Benefit_Request_Form__c);
                for(Id thisImpid:impids){
                    Id ppRecordTypeId;
                    Id gsrf=impGsrf.get(thisImpid);
                    Id propId=prop.id;
                    AIA_Group_Structure_Form_Product__c gsfp = new AIA_Group_Structure_Form_Product__c();
                    gsfp.Group_Structure_Request_Form__c =gsrf;
                    gsfp.Proposed_Products__c = propId;
                    //Schema.RecordTypeInfo s=String.valueOf(Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get(prop.recordtype.name));
                    //if(prop.recordtype.name!='CareFirst Private exchange') 
                    
                    /** T02 - Modified as part of US771 - Start **/
                    String gsrfRecTypeName;
                    if(prop.RecordType.Name == 'Medical ASO' || prop.RecordType.Name == 'Medical Risk') {
                        gsrfRecTypeName = 'Medical';
                    }
                    else {
                        gsrfRecTypeName = prop.RecordType.Name;
                    }
                    
                    if(String.isNotBlank(gsrfRecTypeName)) {
                    	ppRecordTypeId = Schema.SObjectType.AIA_Group_Structure_Form_Product__c.getRecordTypeInfosByName().get(gsrfRecTypeName).getRecordTypeId();
                        gsfp.RecordTypeId = ppRecordTypeId;
                    }
                    /** T02 - Modified as part of US771 - End **/
                                        
                    //gsfp.Deductible__c = prop.Deductible__c;
                    //gsfp.Product_Name__c=prop.Plan_Name__c;
                    //gsfp.Product_Line__c = prop.Product_Line__c;
                    createGSProductsList.add(gsfp);
                }
            }
            //Inserting group structure form product
            system.debug('createGSProducts--'+createGSProductsList.size());
            if (!createGSProductsList.isEmpty())  {
                insert createGSProductsList;
                //T01 start
                //query all gsps
                gspsCreated=[select Proposed_Products__c,Related_Medical_Product__c from AIA_Group_Structure_Form_Product__c 
                             where id in:createGSProductsList];
                //create map for pp and related gsp
                for(AIA_Group_Structure_Form_Product__c gsp:gspsCreated){
                    ppGsp.put(gsp.Proposed_Products__c, gsp.id);
                }  
                for(AIA_Group_Structure_Form_Product__c gsp:gspsCreated){
                   gsp.Related_Medical_Product__c=ppGsp.get(ppRelatedmedical.get(gsp.Proposed_Products__c));
                }
                update gspsCreated;
                //T01 end
            }
            
        }
        //Exception handle
        catch(Exception e){
            AIA_Utils errLogExp = new AIA_Utils();
            errLogExp.logException(e);
            system.debug('Error occured'+e.getLineNumber());
            lstAIAGSRF[0].adderror('something went wrong :- '+e.getMessage());
        }
        
    }
}