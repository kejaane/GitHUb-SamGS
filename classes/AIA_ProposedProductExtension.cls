/*===============================================================================================================
* Date         : 08/08/2016
* Developer    : Sandeep S
* Purpose      : Extension for Customized Proposed Product VisualForce page.
*================================================================================================================
*                                 Update History
*                                 ---------------
* Date       | Developer      | Tag  |      Description
*============+================+======================================================================================
* 08/08/2016 | Sandeep S      |      | Initial Version                                         
* 12/08/2016 | Asif K         | T01  | Added braces for if-else statement & catch block for handling DMLException
* 12/12/2016 | Indira Das     | T02  | updated class to handled blanl pp id/brfid/planid
* 01/18/2017 | Asif K         | T03  | Auto-default field values from PCS operation 1 data in plan object for Drug.
* 03/02/2017 | Asif K         | T04  | Auto Populate BRF_Account__c from associated BRF 
* 03/05/2017 | Rajesh Pennam  | T05  | Added Conditions to auto-populate default values for Identity Protection 
*                                    Mandate field. Story B-03750
* 04/13/2017 | Asif K         | T06  | Removed references of T05 as part of Story B-03894
* 04/16/2017 | Ramakrishna    | T07  | Added dental related fields to copy from plan to PP.
* 06/26/2017 | Satya          | T08  | Added Medical related f ields as part of B-05109 US
* 11/15/2017 | Raviteja       | T09  | Added logic to handle dental,vision for medical related products
* 11/30/2017 | Goutham Rapolu | T10 | Added logic to default field to N/A as per US 265.
* 1/24/2017  | Raviteja       | T11 | Added SLDS getter property
* 7/2/2018   | Satya          | T12 | Defaluted the formulary value to 3 when tier count is 5 for Drug products.
* 09/5/2017  | Arshia G       | T13 |  Updated MHP section for US771
*============+============+======+===============================================================================
*/
public with sharing class AIA_ProposedProductExtension {
    
    public Boolean isMedical{get;set;}
    public Boolean isDental{get;set;}
    public Boolean isVision{get;set;}
    public Boolean isDrug{get;set;}
    public Boolean isPrivateExchange{get;set;}
    public Proposed_Products__c ppc{get;set;}
    public ApexPages.StandardController ctler{get; set;}
    public boolean hasBnefitSummary {get;set;}   
    public boolean skeletonplan {get;set;}  
    public boolean Drugrisk {get;set;}   
    public boolean DrugASO {get;set;}
    public boolean BRFASO {get;set;}
    public boolean IsGrandfathered {get;set;}
    String brfId=Apexpages.currentPage().getParameters().get('brfId');
   
    
    public AIA_ProposedProductExtension(ApexPages.StandardController controller){
        String pid=ApexPages.currentPage().getParameters().get('id');        
        string brf=ApexPages.currentPage().getParameters().get('brfid');
        ctler=controller;
        hasBnefitSummary = false;
        IsGrandfathered = false;
        //System.debug('pid------->'+pid);
         //system.debug('----brfId------'+brf);
        String recordType='';
        if(String.isBlank(pid)){
            String planId=ApexPages.currentPage().getParameters().get('planid');
            String brfId=ApexPages.currentPage().getParameters().get('brfId');
            //System.debug('Inside Extension--->'+planId);
            ppc=(Proposed_Products__c)controller.getRecord();
            Schema.DescribeSObjectResult R = Proposed_Products__c.SObjectType.getDescribe();
            List<Schema.RecordTypeInfo> rtList = R.getRecordTypeInfos();
            String recordTypeId=''; 
            //T02 - Star
            
            if(!String.isBlank(brfId)){
                string exclusiveNetwork=''; 
                string rebatesWithheld = '';
                string prdFinanceArrangement = '';
                string maintChoice = '';
                ppc.Benefit_Request_Form__c=Id.valueOf(brfId);
                String queryString1=QueryBase2.getSobjectAllFieldsSOQL( 'Benfit_Request_Form__c',  'id=:brfId');
                
                List<Benfit_Request_Form__c> brfList=database.query(queryString1);
                Benfit_Request_Form__c brf1 = [select id, name,Jurisdiction__c, RecordType.Name,Account__c,funding_arrangements__c, Grandfathered_status__c
                                              from Benfit_Request_Form__c 
                                              where id=:brfId];
                //system.debug('--brf1 ---'+brf1 );
                if(brfList.size()>0){
                    Benfit_Request_Form__c b=brfList.get(0);
                    if(brf1.Grandfathered_status__c == 'Non-Grandfathered' || brf1.Grandfathered_status__c == 'Grandfathered'){
                        IsGrandfathered = True;
                        ppc.Grandfathered_status__c = brf1.Grandfathered_status__c;
                    }
                   if(brf1.RecordType.Name== 'ASO'){
                        BRFASO = true;
                        ppc.FirstHelp__c = 'Yes';
                   }
                    Drugrisk = b.Risk__c;
                    DrugASO = b.ASO__C;
                    exclusiveNetwork = b.Exclusive_Specialty_Provider_Network__c;
                    rebatesWithheld = b.Rebates_Withheld_by_CareFirst__c ;
                    prdFinanceArrangement = b.Funding_Arrangements__c;
                    maintChoice = b.Maintenance_Choice__c;
                    if(b.Funding_Arrangements__c=='ASO' || b.Funding_Arrangements__c=='Risk'){
                        ppc.Funding_Arrangement__c = b.Funding_Arrangements__c ;  
                    }
                    //T13-Start
                   // else		
	                //    {		
	                 //       ppc.Funding_Arrangement__c = 'ASO' ; 		
	                 //   }
                    //T13-End
                    ppc.BRF_Account__c = b.Account__c;//T04
                }     
                
                if(!String.isBlank(planId)){
                    //T02 - End
                    ppc.Plan_Name__c=Id.valueOf(planId);    
                    String queryString=QueryBase2.getSobjectAllFieldsSOQL( 'AIA_Plan__c',  'id=:planId');
                    List<AIA_Plan__c> planList=database.query(queryString);
                    if(planList.size()>0){
                        AIA_Plan__c p=planList.get(0);
                        hasBnefitSummary = p.Has_Benefit_Summary__c;
                        skeletonplan = p.Skeleton_Plan__c;
                        
                        //T01 - Start
                        if(String.valueOf(p.Product_Category__c)!='Pharmacy' && String.valueOf(p.Product_Category__c)!='Medical') {	//T12
                            recordType=String.valueOf(p.Product_Category__c);
                        }
                        //T13-Start
                        else if(String.valueOf(p.Product_Category__c)=='Medical' ){
                            system.debug('recordtype1'+ppc.Funding_Arrangement__c);
                            //T13-Start
                            if (ppc.Funding_Arrangement__c == 'Risk')
                            	recordType= String.valueOf(p.Product_Category__c)+' Risk';
                            else
                             	recordType= String.valueOf(p.Product_Category__c)+' ASO';
                            //T13-End
                        }
                        //T13-End
                        else { 
                            recordType='Drug';   
                        }
                        //T01 - End
                        //RG Update
                        ppc.Integrated_OOP_Integration__c = p.Integrated_OOP_Indicator__c;
                       // ppc.Integrated_Deductibles__c = p.
                        ppc.Integrated_Deductible_Integrator__c = p.Integrated_DedIndicator__c;
                    //    ppc.Prior_Carrier_Ded_Credit__c = p.PriorCarrierDedCred__c;
                    //    ppc.Prescription_Covered_Arrangement_comment__c = p.PrescriptionComments__c;
                    //    ppc.Prescription_Covered_Arrangement__c = p.PrescriptionCovrdArrngmnt__c;  
                        
                        
                        
                        if((recordType=='Medical Risk') || (recordType=='Medical ASO')){//T12 
                            ppc.CDH__c=p.CDH__c;
                            ppc.CDH_Fund_Type__c=p.CDH_Fund_Type__c;
                            ppc.CDH_Type__c=p.CDH_Type__c;
                       //     ppc.Product_Line__c=p.Product_Line__c;            // available at T07
                            ppc.Deductible__c=p.DeductibleAccumulatorMethod__c;
                        //    ppc.Product_Category__c=p.Product_Category__c;    // available at T07
                            ppc.Product_Name__c=p.Plan_Name__c;
                        //    ppc.Product_Option__c=p.Option__c;                // available at T07
                        //    ppc.Integrated_Non_Integrated__c = p.Integrated_DedIndicator__c;      // available at T07
                        //    ppc.RX_OOP_Max_Integration__c = p.Integrated_OOP_Indicator__c;        // available at T07
                            ppc.Out_of_Pocket_Max__c=p.OOPAccumulatorMethod__c;
                            ppc.Network_Levels__c=p.Network_Levels__c;
                            //T08 Chnages
                            ppc.INN_OON_Ded_Contribute_To_Each_Other__c=p.INN_OON_Ded_Contribute_To_Each_Other__c;
                            ppc.INN_and_OON_OOP_Contribute_To_Each_Other__c=p.INN_and_OON_OOP_Contribute_To_Each_Other__c;
                            // T08 Chnages End
                            ppc.INN_and_OON_Annual_Maximum_combined__c = p.INN_and_OON_Annual_Maximum_combined__c;
                            ppc.INN_and_OON_Lifetime_Maximum_combined__c=p.INN_and_OON_Lifetime_Maximum_combined__c;
                            ppc.Product_Financial_Arrangement__c = prdFinanceArrangement;
                            //T13-Start
                            /*
                            if(ppc.Funding_Arrangement__c == 'ASO'){
                                ppc.MHP_Test_Result__c = 'Deferred';
                            }
                            if(ppc.Funding_Arrangement__c == 'Risk'){
                                ppc.MHP_Test_Result__c = 'Pass'; 
                            }
							*/
                            //T13-End
                        }
                        if(recordType=='Drug'){
                            ppc.Exclusive_Specialty_Provider_Network__c = exclusiveNetwork;
                            ppc.Product_Name__c=p.Plan_Name__c;
                            ppc.Maintenance_Choice__c = maintChoice;
                            ppc.Rebates_Withheld_by_CareFirst__c=rebatesWithheld;
                            ppc.Product_Financial_Arrangement__c = prdFinanceArrangement;
                            ppc.DiabeticSuppMandateApply__c=p.DiabeticSuppMandateApply__c;
                            ppc.Deductible__c=p.DeductibleAccumulatorMethod__c;
                       //     ppc.Product_Category__c=p.Product_Category__c;                           // available at T07
                       //     ppc.Integrated_Non_Integrated__c = p.Integrated_DedIndicator__c;         // available at T07
                       //     ppc.RX_OOP_Max_Integration__c = p.Integrated_OOP_Indicator__c;           // available at T07    
                            ppc.Tiers1__c=String.valueof(p.TierCount__c);
                            if(String.valueof(p.TierCount__c) == '5'){
                                ppc.Formulary_Picklist__c = '3'; // T12 Changes
                            }
                            ppc.Integrated_Deductibles_and_OOPs__c=p.Integrated_DedIndicator__c +' & '+ p.Integrated_OOP_Indicator__c;
                            ppc.Network__c=p.network__c;
                            ppc.Prior_Authorization__c=p.PriorAuth__c=='Yes'?TRUE:FALSE;
                            ppc.Preventive_Drugs_Affordable_Care_Act__c=p.RetDispnsMaintDaysSupp__c;
                            ppc.Generic_Drugs_Tier_1__c=p.RetDispnsMaintDaysSupp__c;
                            ppc.Preferred_Brand_Drugs_Tier_2__c=p.RetDispnsMaintDaysSupp__c;
                            ppc.Self_administered_Injectable_Tier_4__c=p.RetDispnsMaintDaysSupp__c;
                            ppc.Maintenance_Drugs__c=p.RetDispnsMaintDaysSupp__c;
                            ppc.Generic_Step_Therapy__c=p.GenStepTherapy__c;
                            ppc.Generic_Dispensing__c=p.GenDispsng__c;
                            //T03 - Start - Auto-default field values from PCS operation 1 data in plan object for Drug
                            ppc.DeductibleAccumulatorMethod__c = p.DeductibleAccumulatorMethod__c;
                            ppc.Out_of_Pocket_Accumulator_Method__c = p.OOPAccumulatorMethod__c;
                            ppc.AllergySerums__c = p.AllergySerums__c;
                            ppc.Allergy_Serums_Limitation_Others__c = p.AllergySerumsComment__c;
                            ppc.DiabeticSuppCopayApply__c = p.DiabeticSuppCopayApply__c;
                            ppc.DiabeticSuppDedApply__c = p.DiabeticSuppDedApply__c;
                            ppc.ErectileDysfunc_c__c = p.ErectileDysfunc__c;
                            ppc.Erectile_Dysfunction_Limitation_Others__c = p.ErectileDysfuncComment__c;
                            ppc.FertilityAgents__c = p.FertilityAgents__c;
                            ppc.Fertility_Agents_Limitation_Others__c = p.FertilityAgentsComment__c;
                            ppc.GrowthHormone__c = p.GrowthHormone__c;
                            ppc.HBSelectGeneric__c = p.HBSelectGeneric__c;
                            ppc.MailOrderAllDrugs__c = p.MailOrderAllDrugs__c;
                            ppc.MailOrdDispnsMaintDaysSupp__c = p.MailOrdDispnsMaintDaysSupp__c;
                            ppc.MailOrdDispnsNMaintDaysSupp__c = p.MailOrdDispnsNMaintDaysSupp__c;
                            ppc.OralChemoCopayApply__c = p.OralChemoCopayApply__c;
                            ppc.OralChemoDedApply__c = p.OralChemoDedApply__c;
                            ppc.OralChemoMandateApply__c = p.OralChemoMandateApply__c;
                            ppc.OTCCovered__c = p.OTCCovered__c;
                            ppc.Prescribed_Oral_Contraceptives_Devic__c = p.PrscrbdOrlContrcptvAndDevc__c;
                            ppc.PrevntvCovrd__c = p.PrevntvCovrd__c;
                            ppc.PrevntvDrugCopayAmount__c = p.PrevntvDrugCopayAmount__c;
                            ppc.PriorAuth__c = p.PriorAuth__c;
                            ppc.RetDispnsMaintDaysSupp__c = p.RetDispnsMaintDaysSupp__c;
                            ppc.RetDispnsMaintDaysSupp__c = p.RetDispnsNMaintDaysSupp__c;
                            ppc.RxFundamentalApply__c = p.RxFundamentalApply__c;
                            ppc.RxFundamentalDedCopayRule__c = p.RxFundamentalDedCopayRule__c;
                            ppc.TierCount__c = p.TierCount__c;
                            ppc.Other_Requirements__c = p.Other_Requirements__c;
                            ppc.Notes__c = p.Notes__c;
                       //     ppc.Integrated_Non_Integrated__c = p.Integrated_DedIndicator__c;         // available at T07
                       //     ppc.RX_OOP_Max_Integration__c = p.Integrated_OOP_Indicator__c;           // available at T07
                            //T03 - End - Auto-default field values from PCS operation 1 data in plan object for Drug
                        }
                        if(recordType=='Vision'){
                            ppc.Vision_Product_Name__c=p.Plan_Name__c;
                            ppc.Vision_Product_Options__c=p.Option__c;
                            ppc.X05_Options__c = p.X05Options__c;
                            ppc.X06_Renewal_Period__c = p.X06RenewalPeriod__c;
                            ppc.X07_Benefit_Renews__c = p.X07BenefitRenews__c;
                            ppc.X08_Renewal_Type__c = p.X08RenewalType__c;
                            
                        }
                        //T07 start
                    //    if(recordType=='Dental'){
                            ppc.Dental_Product_Name__c = p.Plan_Name__c;
                            ppc.Product_Option__c=p.Option__c;
                            ppc.Product_Category__c=p.Product_Category__c;
                            ppc.Product_Line__c=p.Product_Line__c;
                            ppc.Integrated_Non_Integrated__c = p.Integrated_DedIndicator__c;
                            ppc.RX_OOP_Max_Integration__c = p.Integrated_OOP_Indicator__c;
                            ppc.All_Market_Segments__c = p.All_Market_Segments__c;//added part of defect # 35628
                            ppc.X01_Program__c = p.X01_Program__c;      //added part of defect # 35628  
                            ppc.INN_OON_Ded_Contribute_To_Each_Other__c=p.INN_OON_Ded_Contribute_To_Each_Other__c;//T08
                            ppc.INN_and_OON_OOP_Contribute_To_Each_Other__c=p.INN_and_OON_OOP_Contribute_To_Each_Other__c;  //T08 
                            ppc.INN_and_OON_Annual_Maximum_combined__c = p.INN_and_OON_Annual_Maximum_combined__c;//T08
                            ppc.INN_and_OON_Lifetime_Maximum_combined__c=p.INN_and_OON_Lifetime_Maximum_combined__c;//T08   
                            ppc.Three_Month_Deductible__c = p.Three_Month_Deductible_Carryover__c;   
                            ppc.INN_OON_Ded_Contribute_To_Each_Other__c = p.INN_OON_Ded_Contribute_To_Each_Other__c;    
                            //T10 Start
                            if(p.Count_of_Networks__c == 1 && ppc.product_category__c == 'Medical'){
                               ppc.INN_OON_Ded_Contribute_To_Each_Other__c = 'N/A';
                            }else{
                               ppc.INN_OON_Ded_Contribute_To_Each_Other__c = p.INN_OON_Ded_Contribute_To_Each_Other__c; 
                            }
                            //T10 End      
                   //     }  
                        //T07 End
                    }
                }
            }
            for(Schema.RecordTypeInfo rtInfo:rtList){
                if(rtInfo.getName()==recordType){
                    recordTypeId=rtInfo.getRecordTypeId();
                    ppc.recordtypeid=recordTypeId;
                    
                }
            }
            enableRecordType(recordType);
        }else{
            //T02 - Start
            ppc =[select id,recordtype.name from Proposed_Products__c where id=:pid];
            recordType=ppc.recordtype.name;
            enableRecordType(recordType);
            //T02 - End
        }
    }
    //T11   -   Start
    public Boolean getIsClassic() {
        return (UserInfo.getUiThemeDisplayed() == 'Theme3');
    }
    //T11   -   End
    public void enableRecordType(String recordType){
        //System.debug('RecordType is--->'+recordType);
         if((recordType=='Medical Risk') || (recordType=='Medical ASO')){//T13
            isMedical=true;
        }else if(recordType=='Drug'){
            isDrug=true;
        }else if(recordType=='Dental'){
            isDental=true;  
        }else if(recordType=='Vision'){
            isVision=true; 
        }else if(recordType=='CareFirst Private Exchange'){
            isPrivateExchange=true;  
        }
    }
    
    public PageReference cancel(){
        String planId=Apexpages.currentPage().getParameters().get('planId');
        String brfId=Apexpages.currentPage().getParameters().get('brfId');
        String pppid=Apexpages.currentPage().getParameters().get('id');
        PageReference pg=null; 
        //System.debug('PlanId---->'+planId);
        //System.debug('brfId---->'+brfId);
        if(String.isNotBlank(planId) && String.isNotBlank(brfId)){
            //System.debug('inside if condition');
            pg=new PageReference('/apex/AIA_ProductSearchFiltering');
            pg.getParameters().put('brfId',brfId);
        }else if(String.isNotBlank(pppid)){
            pg=new PageReference('/'+pppid);
        }
        return pg;
    }
    public PageReference saveandGetBenefits(){
        PageReference saveMethodPgRef = save();
        //system.debug('ppc'+ppc);
        // system.debug('ppc'+ppc.id);
        if(String.isNotBlank(ppc.id))
        {
            PageReference pgRef = new pageReference('/apex/AIA_ProposedProd_Summary?scontrolCaching=1&id='+ppc.id);
            pgRef.setRedirect(true);
            return pgRef;
        }
        else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Proposed Product Record could not be added. Please contact Admin.');
            ApexPages.addMessage(myMsg);
            return null;
        }
       // return saveMethodPgRef;
    }
    
    public PageReference save(){
        System.debug('Inside save method');
        PageReference pageRef=null;
        String planId=Apexpages.currentPage().getParameters().get('planId');
        String brfId=Apexpages.currentPage().getParameters().get('brfId');
        String pppid=Apexpages.currentPage().getParameters().get('id');
        String parentppid=Apexpages.currentPage().getParameters().get('ppid');
        try{
            System.debug('AG:ppc'+ppc);
            if(String.isNotBlank(planId) && String.isNotBlank(brfId)){
                if(ppc!=null){
                   System.debug('AG:ppc NOT NULL'+Schema.SObjectType.Proposed_Products__c.getRecordTypeInfosByName());
                    //T13-Start
                    if (ppc.Funding_Arrangement__c=='Risk' && ppc.Product_Category__c == 'Medical'){
                        ppc.RecordTypeId = Schema.SObjectType.Proposed_Products__c.getRecordTypeInfosByName().get('Medical Risk').getRecordTypeId();
                    }
                    else  if (ppc.Funding_Arrangement__c=='ASO' && ppc.Product_Category__c == 'Medical'){
                        ppc.RecordTypeId = Schema.SObjectType.Proposed_Products__c.getRecordTypeInfosByName().get('Medical ASO').getRecordTypeId();
                    }
                    //T13-End
                    System.debug('AG:ppc.RecordTypeId'+ppc.RecordTypeId);
                    //T02 - Start
                    Schema.DescribeSObjectResult d = Schema.SObjectType.Proposed_Products__c; 
                    //T02 - End
                    Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();    
                    Schema.RecordTypeInfo rtById =  rtMapById.get(ppc.RecordTypeId);
                    String errorMessage='';
                    Benfit_Request_Form__c currentBRF = [select id,recordTypeId,Jurisdiction__c from Benfit_Request_Form__c where id =:brfId ];
                    Id riskRTypeId = Schema.SObjectType.Benfit_Request_Form__c.getRecordTypeInfosByName().get('Risk').getRecordTypeId();
                    Id asoRTypeId = Schema.SObjectType.Benfit_Request_Form__c.getRecordTypeInfosByName().get('ASO').getRecordTypeId();
                    Id drugRTypeId = Schema.SObjectType.Proposed_Products__c.getRecordTypeInfosByName().get('Drug').getRecordTypeId();
                    //T09 - Start
                    Id dentalRTypeId = Schema.SObjectType.Proposed_Products__c.getRecordTypeInfosByName().get('Dental').getRecordTypeId();
                    Id visionRTypeId = Schema.SObjectType.Proposed_Products__c.getRecordTypeInfosByName().get('Vision').getRecordTypeId();
                    //T09 - End
                    //system.debug('*****Drugrecordtype' +drugRTypeId);
                    //Validation for Exclusive Speciality Provider Network
                    if(rtById.getName()=='Drug'){
                        if(currentBRF.recordTypeId==riskRTypeId){
                            if((currentBRF.Jurisdiction__c=='VA' && ppc.Exclusive_Specialty_Provider_Network__c!='No - Requires Approval') && (ppc.recordTypeId==drugRTypeId)){
                                errorMessage='EPP019 : Exclusive Speciality Provider Network can only be NO when Jurisdiction is VA for Risk type';
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
                                ApexPages.addMessage(myMsg);
                                return null;
                            }
                        if(((currentBRF.Jurisdiction__c=='MD' || currentBRF.Jurisdiction__c=='DC')  && ppc.Exclusive_Specialty_Provider_Network__c!='Yes') && (ppc.recordTypeId==drugRTypeId)){
                                errorMessage='EPP019 : Exclusive Speciality Provider Network can only be Yes when Jurisdiction is MD/DC for Risk type';
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
                                ApexPages.addMessage(myMsg);
                                return null;
                            }                                               
                        }
                        //Validation for ExtraCare Health Care Card
                        if(currentBRF.recordTypeId==riskRTypeId && ppc.ExtraCare_Health_Care_Card__c!='No'){
                            errorMessage='EPP018 : ExtraCare Health Care Card can only be NO';
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
                            ApexPages.addMessage(myMsg);
                            return null;
                        }  
                        //Validation for Network
                        if(currentBRF.recordTypeId==asoRTypeId && ppc.recordTypeId==drugRTypeId && !(ppc.Network__c=='National' || ppc.Network__c=='RX Choice' ) ){
                            errorMessage='EPP018 : Network can only be National/Rx Choice for ASO type';
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
                            ApexPages.addMessage(myMsg);
                            return null;
                        }
                        if(currentBRF.recordTypeId==riskRTypeId && ppc.Network__c!='National'){
                            errorMessage='EPP018 : Network can only be National for Risk type';
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
                            ApexPages.addMessage(myMsg);
                            return null;
                        }  
                        //Validation for Rebates Withheld by CareFirst
                        
                        if(String.isNotBlank(parentppid)){
                            ppc.Related_Medical_Product__c=parentppid;    
                        } 
                        
                    }
                    //T09 - Start
                    else if( rtById.getName()=='Dental' || rtById.getName()=='Vision'){
                        if(String.isNotBlank(parentppid)){
                            ppc.Related_Medical_Product__c=parentppid;    
                        } 
                    }
                    //T09 - End
                    List<Benfit_Request_Form__c> brfList=[select id,Funding_Arrangements__c,Send_to_Actuarial_Team__c  from Benfit_Request_Form__c where id=:brfId];
                    
                     if(rtById!=null && (rtById.getName()=='Medical ASO'||rtById.getName()=='Medical Risk' || rtById.getName()=='CareFirst Private Exchange')) {  //T13
                        if((String.isNotBlank(ppc.Funding_Arrangement__c) && ppc.Funding_Arrangement__c=='ASO') || (brfList!=null && brfList.size()>0 && brfList.get(0).Funding_Arrangements__c=='ASO')){
                            if(String.isBlank(ppc.Blue_Rewards__c)){
                                errorMessage='EPP017 : If Funding Arrangements of BRF is "ASO" then Blue Rewards field cannot be blank';
                                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errorMessage);
                                ApexPages.addMessage(myMsg);
                                return null;
                            }
                        }
                    }
                    //T13-Start
                    /* 
                   boolean updatebrf = false;
                   if(ppc.MHP_Test_Result__c == 'Deferred'){
                       brflist[0].Send_to_Actuarial_Team__c = True;
                       updatebrf = true;
                   }
                   if(ppc.MHP_Test_Result__c == 'Pass'){
                       ppc.MHP_Test_Completed_Date__c = system.today();
                       ppc.MHP_Test_Completed_By__c = UserInfo.getUserId();
                   } 
					*/
                    //T13-End
                    System.debug('AG:ppc'+ppc);                
                    upsert ppc;
                    // if(updatebrf == true){update brflist;}  //T13
          
                    pageRef=new PageReference('/'+ppc.id);
                }
            }else if(String.isNotBlank(pppid)){
                System.debug('inside else if');
                System.debug('PPC record--->'+ppc);
                List<Proposed_Products__c> proposedProdList=new List<Proposed_Products__c>();
                proposedProdList.add(ppc);
                
                ctler.save();
                pageRef=new PageReference('/'+pppid);
                
            }
        }
        catch(DMLException dmlex) {//T01 Start
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,dmlex.getDmlMessage(0));
            System.debug('AG:e.getMessage()'+ dmlex.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }//T01 End
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            System.debug('AG:e.getMessage()'+e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        return pageRef;
    } 
    
    
}