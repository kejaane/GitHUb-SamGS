/*================================================================================================================================================
* Date       :  05/04/2016
* Developer  :  Sree Harsha Akkala
* Purpose    :  Proposed Product Class includes method which MHP updates the MHP Test result field on proposed product 
*                                       Update History
*=================================================================================================================================================
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================================================
* 05/04/2016 | Sree Harsha    |     | Initial Development
* 02/27/2017 | Goutham Rapolu |     | updateBRFMHPTestResult Method(): If the Proposal Request form form is created from BRF then the BRF MPH Test                                         
*                                     Result field will be updated Based on Proposal request Form.
*                                     validationForCustomCheck Mthod() : To check whether there is an AIA Document (Document Type =  "Marked 
*                                     Up Benefit Summary") attached to the Proposed Product, when the custom flag on the Proposed Product is true
* 11/29/2016 | Indira Das     | T01 | updated validationForCustomCheck Mthod() : To check whether there is an AIA Document (Document Type =  
*                                     "Marked Up Benefit Summary") attached to the Proposed Product, when the custom flag on the Proposed Product 
*                                     is true and related Plan HAs benefit Summary is False
* 03/10/2017 | Goutham Rapolu | T02 | Removed code as not required when MHP Test Result is null on the PP
*                                     MHP Test Result on BRF also will be null. 
* 03/06/2017 | Sree Harsha    |     | Added UpdateRelatedDrugPP method to update the fields in drug PP based on the related Medical PP
* 03/23/2017 | Bill Dodson    | T03 | Merge in adjustment summary code and flags.
* 03-24-2017 | Bill Dodson    | N/A | Uncomment out adjustment summary code that someone 
*                                     commented out.
* 03/20/2017 | Sree Harsha    | T05 | Added method call UpdateRelatedDrugPP to beforeInsert 
* 03/27/2017 | Sree Harsha    | T04 | Added method UpdateRelatedDrugPP_Insert to run for Drug PP Insert.
* 04/28/2017 | Bill Dodson    | T05 | Remove firstRun that surrounds adjustment summary code.
* 10/17/2017 | satya          | T06 | Added as a part of workplan tasks
** 4/4/2018  | Sajitha        | T07 | moved code fix for cloning issue 
* 09/04/2018 | Arshia	      |	T08 | Commented MHP Update for US-771
==================================================================================================================================================
*/
public class AIA_ProposedProductsHandler extends TriggerHandler {

    public AIA_ProposedProductsHandler(){}
    public static boolean firstRun=false;
    public static boolean afterInsert=false;
    public static boolean afterUpdate=false;
    @TestVisible private static Boolean adjustmentPreviouslyCalled = false; // T03
    private static Boolean otherTriggersRunning = false; // T03
     //T07- start
    public static boolean MHPran = false;
     //T07 - End
    public static Final String errorMsg = label.AIA_PP_Error_Msg;

    protected override void afterInsert() {
         // T07- Added check as part of cloning issue
        if(!afterInsert && MHPran == false && !test.isrunningtest())
        {
      //  updateMHPTest((list<Proposed_Products__c>) trigger.new,(Map<id,Proposed_Products__c>) trigger.oldMap);  //T08
      //  updateBRFMHPTestResult((list<Proposed_Products__c>) trigger.new,(Map<id,Proposed_Products__c>) trigger.oldMap);	//T08
        MHPran = true;
        afterInsert = true;
        }
        if(!firstRun){otherTriggersRunning = true; // T03  
        UpdateRelatedDrugPP((list<Proposed_Products__c>) trigger.new, (Map<id,Proposed_Products__c>) trigger.oldMap); //T05
        UpdateRelatedDrugPP_Insert(trigger.new); //T04
        updateBRFBlueRewards((List<Proposed_Products__c>) trigger.new);//Satya
        System.debug('In AIA_ProposedProductsHandler, at bottom of afterInsert'); // T03
        otherTriggersRunning = false; // T03
        afterInsert = true;
        }
    }
    protected override void afterUpdate() {
        // T03 begin
         // T07 - Added check as part of cloning issue
      if(afterUpdate == false && MHPran == false && !test.isrunningtest()) {
       // updateMHPTest((list<Proposed_Products__c>) trigger.new,(Map<id,Proposed_Products__c>) trigger.oldMap);	//T08
       // updateBRFMHPTestResult((list<Proposed_Products__c>) trigger.new,(Map<id,Proposed_Products__c>) trigger.oldMap);	//T08
        afterUpdate = true;MHPran = true;
        }
      if(!firstRun){ // T05, commented out
      
        otherTriggersRunning = true; // T03  
        
        UpdateRelatedDrugPP((list<Proposed_Products__c>) trigger.new,(Map<id,Proposed_Products__c>) trigger.oldMap);
        updateBRFBlueRewards((List<Proposed_Products__c>) trigger.new);//Satya
        otherTriggersRunning = false; // T03  
        System.debug('In AIA_ProposedProductsHandler, at bottom of afterUpdate'); // T03
        }
        System.debug('In AIA_ProposedProductsHandler, at top of afterUpdate');
        if(!otherTriggersRunning && !adjustmentPreviouslyCalled){
            populateAdjustmentSummary(trigger.new,trigger.oldMap);
            System.debug('In AIA_ProposedProductsHandler, returned from populateAdjustmentSummary');
            adjustmentPreviouslyCalled = true;
        }
        else {
            System.debug('In AIA_ProposedProductsHandler, otherTriggersRunning: ' + otherTriggersRunning +
                         ', adjustmentPreviouslyCalled: ' + adjustmentPreviouslyCalled);
        } 
       
        // T03 end
       afterUpdate = true;
        
    }
    protected override void beforeInsert() {
      if(!firstRun){  
        otherTriggersRunning = true; // T03 
        UpdateRelatedDrugPP((list<Proposed_Products__c>) trigger.new,(Map<id,Proposed_Products__c>) trigger.oldMap); 
        otherTriggersRunning = false; // T03  
        }
    }

    /**     
    * @Author: Sree Harsha      
    * @This Method is called from ProposedProducts and it updates       
    * @ MHP Test result field on proposed products.     
    * @param -  list<Proposed_Products__c>          
    * @param - Map<id,Proposed_Products__c>     
    * @Output - Updates MHP Test result field on proposed product       
    */ 
    // Updates the completed by and completed date on the proposed products when the MHP Test Result is updated
    public static void updateMHPTest(list<Proposed_Products__c> newPPList,Map<id,Proposed_Products__c> oldPPMap){
	//T08-Start
        /*
        // Get list of products if the BRF is MHP required
        list<Proposed_Products__c> ppList = [select id,name,MHP_Test_Result__c,Benefit_Request_Form__r.MHP_Required__c from Proposed_Products__c where id in:newPPList ];
        system.debug('@@ppList'+ppList);
        if(ppList.size()>0){
                   for(Proposed_Products__c pp: ppList){
                if(oldPPMap!=null){
                   //if(oldPPMap.get(pp.id).MHP_Test_Result__c!=null && pp.MHP_Test_Result__c!=null){
                    if(oldPPMap.get(pp.id).MHP_Test_Result__c!=pp.MHP_Test_Result__c){
                        pp.MHP_Test_Completed_Date__c = system.now();
                        pp.MHP_Test_Completed_By__c=userInfo.getUserId();  
                        system.debug('@@pp.MHP_Test_Completed_By__coldmap'+pp.MHP_Test_Completed_By__c);             
                    }
                    //}
                }
                else{
                    if(pp.MHP_Test_Result__c!=null){
                        pp.MHP_Test_Completed_Date__c = system.now();
                        pp.MHP_Test_Completed_By__c=userInfo.getUserId();
                        system.debug('@@pp.MHP_Test_Completed_By__cnewmap'+pp.MHP_Test_Completed_By__c);
                    }
                }
            }

            firstRun=true;
            // T07 - Start
            afterUpdate = true;
            afterInsert = true;
            MHPran = true;
             //T07 - End
            try{
                update ppList;
            }
            catch(exception e){}
        }
*/
        //T08-End
    }

    /**
    * @Author: Goutham Rapolu
    * @This Method is called from Proposed Products trigger
    * @This method - If the Proposal Request form form is created from BRF then the BRF MPH Test Result field will be 
    *                updated Based on Proposal request Form
    * @param -  list<Proposed_Products__c> ,list<Proposed_Products__c>
    * @Output - Update the BRF based on PP's Records
    */

    public static void updateBRFMHPTestResult(list<Proposed_Products__c> newPPList,Map<id,Proposed_Products__c> oldPPMap){
//T08-Start
        /*
        Map<Id,boolean> failMapPP = new Map<Id,boolean>(); // To store Fail value from MHP_Test_Result__c fields
        Map<Id,boolean> passMapPP = new Map<Id,boolean>(); // To store pass value from MHP_Test_Result__c fields
        Map<Id,boolean> blankMapPP = new Map<Id,boolean>(); // To store blank value from MHP_Test_Result__c fields
        Map<Id,boolean> deferredMapPP = new Map<Id,boolean>(); // To store deferred value from MHP_Test_Result__c fields
        integer totalPP = 0; // to store all Proposed Products count
        integer totalPassPP = 0; // to store total pass Proposed Products count
        list<Proposed_Products__c> ppList = new list<Proposed_Products__c>();// to store Proposed Products records
        list<Benfit_Request_Form__c> brfList = new list<Benfit_Request_Form__c>(); // to store BRF records
        Set<String> BRFIds = new Set<String>();

        // Get record type for Medical
        Id rt_PP_Medical= QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical');

        // Get all Medical Proposed Products
        if(rt_PP_Medical != null)
            ppList = [select id,name,MHP_Test_Result__c,Benefit_Request_Form__r.Funding_Arrangements__c,
                             Benefit_Request_Form__r.MHP_Test_Result__c,Benefit_Request_Form__c 
                      from Proposed_Products__c 
                      where id in:newPPList and recordtypeId =: rt_PP_Medical];
        system.debug('@@MHP_Test_Result__c inside updateBRFMHPTestResult');
        system.debug('@@MHP_Test_Result__c ppList  '+ppList );
        if(ppList.size()>0){      
            for(Proposed_Products__c pp: ppList){
                boolean isUpdate = false;
                boolean isInsert = false;
                BRFIds.add(pp.Benefit_Request_Form__c);
                system.debug('pp.Benefit_Request_Form__c'+ pp.Benefit_Request_Form__c);
                if(oldPPMap == null){//insert
                    isInsert = true;
                    system.debug('@@MHP_Test_Result__c isInsert ');
                }
                else{if(oldPPMap.get(pp.id).MHP_Test_Result__c != pp.MHP_Test_Result__c || oldPPMap.get(pp.id).MHP_Test_Result__c != null){isUpdate = true;
                        system.debug('@@MHP_Test_Result__c isUpdate ');
                    }
                }

                if((isUpdate || isInsert) && pp.Benefit_Request_Form__r.Funding_Arrangements__c == 'ASO'){
                   system.debug('@@MHP_Test_Result__c ASO');
                    if(pp.MHP_Test_Result__c == 'Fail')
                        failMapPP.put(pp.Benefit_Request_Form__c,true); 
                    if(String.isBlank(pp.MHP_Test_Result__c))
                        blankMapPP.put(pp.Benefit_Request_Form__c,true);
                    if(pp.MHP_Test_Result__c == 'Deferred')
                        deferredMapPP.put(pp.Benefit_Request_Form__c,true); 
                    if(pp.MHP_Test_Result__c == 'Pass'){
                        passMapPP.put(pp.Benefit_Request_Form__c,true);
                        totalPassPP ++;
                    }

                }
                 if((isUpdate || isInsert) && (pp.Benefit_Request_Form__r.Funding_Arrangements__c == 'Risk' || pp.Benefit_Request_Form__r.Funding_Arrangements__c == 'Both' || pp.Benefit_Request_Form__r.Funding_Arrangements__c == 'Other')){
                   system.debug('@@MHP_Test_Result__c Not ASO');
                    if(pp.MHP_Test_Result__c == 'Fail')
                        failMapPP.put(pp.Benefit_Request_Form__c,true); 
                    if(String.isBlank(pp.MHP_Test_Result__c))
                        blankMapPP.put(pp.Benefit_Request_Form__c,true);
                    if(pp.MHP_Test_Result__c == 'Pass'){
                        passMapPP.put(pp.Benefit_Request_Form__c,true);
                        totalPassPP ++;
                    }

                }
                totalPP ++;
            }

        
//T02//
             if(BRFIds != null && BRFIds.size() > 0){
            for(Benfit_Request_Form__c BRF: [select id,Funding_Arrangements__c,MHP_Test_Result__c,MHP_Required__c from Benfit_Request_Form__c where id =: BRFIds]){
              system.debug('@@MHP_Test_Result__c BRF');
                if(failMapPP != null && failMapPP.size()>0){
                    BRF.MHP_Test_Result__c = 'Fail';
                    system.debug('@@MHP_Test_Result__c fail');
                }else if(blankMapPP != null && blankMapPP.size()>0){
                    BRF.MHP_Test_Result__c = 'Pending';
                    system.debug('@@MHP_Test_Result__c pending');
                }else if(blankMapPP != null && blankMapPP.size()>0){ BRF.MHP_Test_Result__c = null;  
                    system.debug('@@MHP_Test_Result__c null');  
                }else if(deferredMapPP != null && deferredMapPP.size()>0){
                    BRF.MHP_Test_Result__c = 'Deferred';
                    system.debug('@@MHP_Test_Result__c Deferred');
                }else if(passMapPP != null && passMapPP.size()>0){
                    if(totalPassPP == totalPP)
                    BRF.MHP_Test_Result__c = 'Pass';
                    system.debug('@@MHP_Test_Result__c pass');
                }else if(BRF.MHP_Required__c == 'No' || BRF.MHP_Required__c == null){ BRF.MHP_Test_Result__c = null;}brfList.add(BRF); //Added BRF.MHP_Required__c == 'No' 3/13/17 - T02
            }
          }
        }
        else{for(Benfit_Request_Form__c BRF: [select id,Funding_Arrangements__c,MHP_Test_Result__c from Benfit_Request_Form__c where id =: BRFIds]){BRF.MHP_Test_Result__c = '';}
      }
        //T07 - start
        afterUpdate = true;
        afterInsert = true;
        MHPran = true;
         //T07 - End
        try{ 
            if(brfList != null && brfList.size()>0){
                firstRun=true;
                update brfList;
            }
        }catch(Exception e){
        }
 */
        //T08-End
    }

    /**
    * @Author: Goutham Rapolu
    * @This Method is called from Proposed Products trigger
    * @This method - To check whether there is an AIA Document (Document Type = "Marked Up Benefit Summary") attached 
    *             to the Proposed Product, when the custom flag on the Proposed Product is true
    * @param -  list<Proposed_Products__c> ,Map<id,Proposed_Products__c>
    * @Output - Through an error if condition is not meet 
    */

  /*  public static void validationForCustomCheck(list<Proposed_Products__c> newPPList,Map<id,Proposed_Products__c> oldPPMap){
        //T01 ---Start
        map<id,Proposed_Products__c> ppMap = new map<id,Proposed_Products__c>([SELECT Custom_new__c,Id,Plan_Name__r.Has_Benefit_Summary__c,Has_Benefit_Details__c ,
                                                                               (select id, Document_Type__c from File_Net_Documents__r
                                                                                where Document_Type__c ='Marked Up Benefit Summary') ,(select id ,name from PPGrouper__r)
                                                                               FROM Proposed_Products__c where id in:newPPList]);
        system.debug('errorMsg---'+errorMsg);
        //T01 ---END
        system.debug('ppMap'+ ppMap);
        if(ppMap != null && ppMap.size()>0){
            for(Proposed_Products__c pp: newPPList){
                system.debug('pp.Custom_New__c'+ pp.Custom_New__c +'----pp.Plan_Name__r.Has_Benefit_Summary__c---'+pp.Plan_Name__r.Has_Benefit_Summary__c);
                //T01 ---Start
                if(pp.Custom_New__c == 'Custom' && pp.Cloned_From__c == null && ((oldPPMap!=null && (oldPPMap.get(pp.id).Custom_new__c!=pp.Custom_new__c || oldPPMap.get(pp.id).Plan_Name__c!=pp.Plan_Name__c)) || oldPPMap==null)
                   && (ppMap.get(pp.id).Plan_Name__r.Has_Benefit_Summary__c ==false 
                       || (ppMap.get(pp.id).Plan_Name__r.Has_Benefit_Summary__c ==true && ppMap.get(pp.Id).PPGrouper__r.size()<1))) //T01 ---End
                {  
                    system.debug('ppMap.get(pp.Id).File_Net_Documents__r.size()'+  ppMap.get(pp.Id).File_Net_Documents__r.size());
                    if(ppMap.containsKey(pp.Id) && ppMap.get(pp.Id).File_Net_Documents__r.size() == 0){
                        pp.adderror(errorMsg);
                    }
                }
            }
        }
    } */

    /**
    * @Author: Satya
    * @This Method is called from ProposedProducts
    * @This method - This method is to Create AdjustmentRecord when any ProposedProducts field is updated
    * @param -  list<Proposed_Products__c>  
    * @param - Map<id,Proposed_Products__c>
    * @Output -
    */
    public static void populateAdjustmentSummary(List<sObject> lstPP,Map<id,sObject> PPOldMap)
    {
        AIA_AdjustmentSummaryUtils.populateAdjustmentSummary(lstPP, PPOldMap);
        firstRun=true;
    }


    /**
    * @Author: Sree Harsha 
    * @This Method is called from ProposedProducts
    * @This method - Updates Drug PP's fields based on related Medical PP's fields
    * @param -  list<Proposed_Products__c>  
    * @param - Map<id,Proposed_Products__c>
    * @Output - Updates out of pocket and deductible options fields
    */  
    public static void UpdateRelatedDrugPP(list<Proposed_Products__c> newPPList,Map<id,Proposed_Products__c> oldPPMap){
 
        list<Proposed_Products__c> ppListMedical = new list<Proposed_Products__c>();// to store Proposed Products records
        list<Proposed_Products__c> ppListDrug = new list<Proposed_Products__c>();

        // Get record type for Medical
        Id rt_PP_Medical= QueryBase.getRecordtypeId('Proposed_Products__c', 'Medical_Risk');	//T08
        
        // Get all Medical Proposed Products
        if(rt_PP_Medical != null){
            ppListMedical = [select id, Integrated_Non_Integrated__c, Deductible__c, Out_of_Pocket_Max__c from Proposed_Products__c where id in:newPPList and recordtypeId =: rt_PP_Medical];
        }
        
        Id rt_PP_Drug= QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
        
        system.debug('newPPList---'+newPPList);
        system.debug('ppListMedical---'+ppListMedical);
        
        if(rt_PP_Drug != null){
            ppListDrug = [select id, Related_Medical_Product__r.Deductible__c,Related_Medical_Product__r.Out_of_Pocket_Max__c,Integrated_Non_Integrated__c, Deductible__c, 
            Related_Medical_Product__r.Integrated_Non_Integrated__c,Out_of_Pocket_Max__c from Proposed_Products__c where Related_Medical_Product__r.id in:ppListMedical and recordtypeId =: rt_PP_Drug];
        }
          if(ppListDrug.size()>0){
            for(Proposed_Products__c pp: ppListDrug){
                if(pp.Related_Medical_Product__r.Integrated_Non_Integrated__c == 'Integrated' || pp.Related_Medical_Product__r.Integrated_Non_Integrated__c == 'Integrated - Carved-Out'){
                    pp.Deductible__c = pp.Related_Medical_Product__r.Deductible__c;
                    pp.Out_of_Pocket_Max__c = pp.Related_Medical_Product__r.Out_of_Pocket_Max__c;
                   }
                }
        }
        firstRun=true;
            try{
                update ppListDrug;
            }
            catch(exception e){}
        }    


    /**
    * @Author: Sree Harsha 
    * @This Method is called from ProposedProducts on insert
    * @ and it updates couple of fields from the from medical 
    * @ to associated drug proposed products
    * @param -  list<Proposed_Products__c>  
    * @Output - Updates out of pocket and deductible options fields
    */      
        public void UpdateRelatedDrugPP_Insert(list<Proposed_Products__c> newPPList){
            list<Proposed_Products__c> ppListDrug = new list<Proposed_Products__c>();
            Id rt_PP_Drug= QueryBase.getRecordtypeId('Proposed_Products__c', 'Drug');
            if(rt_PP_Drug != null){
                ppListDrug = [select id, Related_Medical_Product__r.Deductible__c,Related_Medical_Product__r.Out_of_Pocket_Max__c,Integrated_Non_Integrated__c, Deductible__c, 
            Related_Medical_Product__r.Integrated_Non_Integrated__c,Out_of_Pocket_Max__c from Proposed_Products__c where id in:newPPList and recordtypeId =: rt_PP_Drug];
            }
            for(Proposed_Products__c pp : ppListDrug){                  
                if(pp.Related_Medical_Product__r.Integrated_Non_Integrated__c == 'Integrated' || pp.Related_Medical_Product__r.Integrated_Non_Integrated__c == 'Integrated - Carved-Out'){
                    pp.Deductible__c = pp.Related_Medical_Product__r.Deductible__c;
                    pp.Out_of_Pocket_Max__c = pp.Related_Medical_Product__r.Out_of_Pocket_Max__c;                                                            
                }                   
            }
           firstRun=true;
              try{
                update ppListDrug;
            }
            catch(exception e){}
                
        }

    /**
    * @Author: Satya 
    * @This Method is called from Proposed Products trigger
    * @This method - Update Blue_Rewards_Drawloop__c in BRF value form proposed product
    * @param -  list<Proposed_Products__c> ,list<Proposed_Products__c>
    * @Output - Update the BRF based on PP's Records
    */

    public static void updateBRFBlueRewards(list<Proposed_Products__c> newPPList){
        Set<Id> brfIdSet = new Set<Id>();
        for(Proposed_Products__c pp : newPPList){
            brfIdSet.add(pp.Benefit_Request_Form__c);           
        }
        
        Map<id,Integer> standrdCountMap = new Map<id,Integer>();        
        Map<id,Integer> customCountMap = new Map<id,Integer>();
        Map<id,Integer> noCountMap = new Map<id,Integer>();
        Map<id,Integer> fsaBlueFundMap = new Map<id,Integer>();        
        Map<id,Integer> CDHMap = new Map<id,Integer>();
        Map<id,Integer> CDHTypeMap = new Map<id,Integer>();
        Map<id,Integer> CustomWellnessMap = new Map<id,Integer>();
        Map<id,Integer> CustomCoreDMWellnessMap = new Map<id,Integer>();
        Map<id,Integer> BlueRewardsMap = new Map<id,Integer>();
        Map<id,Integer> IntegratedNonIntegratedMap = new Map<id,Integer>();
        List<Proposed_Products__c> ppList = [Select Id,Benefit_Request_Form__c,Blue_Rewards__c,Product_Category__c,FSA_BlueFund__c,CDH__c,CDH_Type__c,Custom_Wellness__c,Custom_Core_DM_Wellness__c,Integrated_Non_Integrated__c from Proposed_Products__c where Benefit_Request_Form__c in : brfIdSet];
        
        for(Proposed_Products__c pp : ppList){
            If(pp.Product_Category__c == 'Medical'){
                if(pp.Blue_Rewards__c == 'Standard'){
                    if(!standrdCountMap.containsKey(pp.Benefit_Request_Form__c)){
                        standrdCountMap.put(pp.Benefit_Request_Form__c,1);
                        BlueRewardsMap.put(pp.Benefit_Request_Form__c,1);
                    }else{standrdCountMap.put(pp.Benefit_Request_Form__c,standrdCountMap.get(pp.Benefit_Request_Form__c)+1);
                    }   
                }else if(pp.Blue_Rewards__c == 'Custom'){
                    if(!customCountMap.containsKey(pp.Benefit_Request_Form__c)){
                        customCountMap.put(pp.Benefit_Request_Form__c,1);
                        BlueRewardsMap.put(pp.Benefit_Request_Form__c,1);
                    }else{customCountMap.put(pp.Benefit_Request_Form__c,customCountMap.get(pp.Benefit_Request_Form__c)+1);}
                }else if(pp.Blue_Rewards__c == 'No'){
                    if(!noCountMap.containsKey(pp.Benefit_Request_Form__c)){
                        noCountMap.put(pp.Benefit_Request_Form__c,1);
                    }else{noCountMap.put(pp.Benefit_Request_Form__c,noCountMap.get(pp.Benefit_Request_Form__c)+1);}
                }
                //t06 changes start
                if(pp.FSA_BlueFund__c == true){
                    if(!fsaBlueFundMap.containsKey(pp.Benefit_Request_Form__c)){
                        fsaBlueFundMap.put(pp.Benefit_Request_Form__c,1);
                    }
                }
                if(pp.CDH__c == 'Yes'){
                    if(!CDHMap.containsKey(pp.Benefit_Request_Form__c)){
                        CDHMap.put(pp.Benefit_Request_Form__c,1);
                    }
                }
                if(pp.CDH_Type__c == 'HRA Integrated'){
                    if(!CDHTypeMap.containsKey(pp.Benefit_Request_Form__c)){
                        CDHTypeMap.put(pp.Benefit_Request_Form__c,1);
                    }
                }
                if(pp.Custom_Wellness__c == true){
                    if(!CustomWellnessMap.containsKey(pp.Benefit_Request_Form__c)){
                        CustomWellnessMap.put(pp.Benefit_Request_Form__c,1);
                    }
                }
                if(pp.Custom_Core_DM_Wellness__c == true){
                    if(!CustomCoreDMWellnessMap.containsKey(pp.Benefit_Request_Form__c)){
                        CustomCoreDMWellnessMap.put(pp.Benefit_Request_Form__c,1);
                    }
                }               
                if(pp.Integrated_Non_Integrated__c == 'Integrated - Carved-Out'){
                    if(!IntegratedNonIntegratedMap.containsKey(pp.Benefit_Request_Form__c)){
                        IntegratedNonIntegratedMap.put(pp.Benefit_Request_Form__c,1);
                    } //t06 ends
                }
            }
        }
        
        //List<Benfit_Request_Form__c> brfList = [Select Id,Blue_Rewards_Drawloop__c from Benfit_Request_Form__c where id in : brfIdSet];
        Benfit_Request_Form__c brfToUpdate;
        list<Benfit_Request_Form__c> brfList = new list<Benfit_Request_Form__c>();
        for(Id brfid : brfIdSet){
            brfToUpdate = new Benfit_Request_Form__c(Id = brfid);
            if(customCountMap.containsKey(brfid)){
                brfToUpdate.Blue_Rewards_Drawloop__c = 'Custom';
            }else if(standrdCountMap.containsKey(brfid) && !customCountMap.containsKey(brfid)){
                brfToUpdate.Blue_Rewards_Drawloop__c = 'Standard';
            }else if(noCountMap.containsKey(brfid) && !customCountMap.containsKey(brfid) && !standrdCountMap.containsKey(brfid)){
                brfToUpdate.Blue_Rewards_Drawloop__c = 'No';
            }
            //T06 changes start
            if(fsaBlueFundMap.containsKey(brfid)){
                brfToUpdate.PP_FSA_BlueFund__c = true;
            }
            if(CDHMap.containsKey(brfid)){
                brfToUpdate.PP_CDH__c = true;
            }
            if(CDHTypeMap.containsKey(brfid)){
                brfToUpdate.PP_CDH_Type__c = true;
            }
            if(CustomWellnessMap.containsKey(brfid)){
                brfToUpdate.PP_Custom_Wellness__c = true;
            }
            if(CustomCoreDMWellnessMap.containsKey(brfid)){
                brfToUpdate.PP_Integrated_DM_Wellness__c = true;
            }
            if(BlueRewardsMap.containsKey(brfid)){
                brfToUpdate.PP_Blue_Rewards__c = true;
            }
            if(IntegratedNonIntegratedMap.containsKey(brfid)){
                brfToUpdate.PP_Rx_Integration__c = true;
            }
            //T06 ends
            brfList.add(brfToUpdate);
        }
        if(!brfList.isEmpty()) { update brfList; }
        firstRun=true;
    }
        
        
}