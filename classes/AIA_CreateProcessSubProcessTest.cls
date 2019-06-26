/*=========================================================================================
 * Date         : 04/20/2018
 * Developer    : Laveen Kattela
 * Purpose      :  This Test class covers for AIA_WorkplanController,AIA_SubprocessController, AIA_OpportunityImplementation Controller component.
 *                
 *=========================================================================================
 *                                 Update History
 *                                 ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 04/20/2018 | Laveen    | Initial Version 
 *06/08/2018    raj kiran      T01       Added code for role updates
 *02/11/2019  | chaithra  | T02     Changes made as part of US6713
 *05/02/2019  | Satya     | T03   | Removed hardcoding of dates and added lists for insert operations
 *===========+============+================================================================
 */
@isTest
public class AIA_CreateProcessSubProcessTest {
    
     static User User1;
     static AIA_Implementation__c Imp;
     static Account TestAcc;
     static Opportunity opp;
     public static List<user> userList;
    public static Process_Type__c processtype;
    public static Process_Type__c processtype1;
    public static Sub_Process_Type__c subprocesstype;
    public static Sub_Process_Type__c subprocesstype1;
    public static Sub_Process_Type__c subprocesstype2;
    public static Sub_Process_Type__c subprocesstype3;
    public static Sub_Process_Type__c subprocesstype4;
    public static Sub_Process_Type__c subprocesstype5;
    public static Sub_Process_Type__c subprocesstype6;
    public static Sub_Process_Type__c subprocesstype7;
    public static Sub_Process_Type__c subprocesstype8;
    public static Sub_Process_Type__c subprocesstype9;
    public static Sub_Process_Type__c subprocesstype10;
    public static Sub_Process_Type__c subprocesstype11;
    public static Sub_Process_Type__c subprocesstype12;
    public static Sub_Process_Type__c subprocesstype13;
    public static Process__c process;
    Public static List<Sub_Process__c> subprocesstoupdate;
    public static Sub_Process__c subprocess;
    public static Sub_Process__c subprocess1; 
    public static Sub_Process__c subprocess2; 
    public static Workplan_Task__c workplantask;
    public static Workplan_Task__c workplantask1; 
     public static Workplan_Task__c workplantask2;
    public static Workplan_Task_Template__c workplan;
    public static Workplan_Task_Template__c workplan1;
    public static Workplan_Task_Template__c workplan2;
    
     static {
     User1 = new User() ;
     subprocesstoupdate = new List<Sub_Process__c>();
     Imp = new AIA_Implementation__c();
     TestAcc = new Account();
     opp = new Opportunity();
     userList = new list<user>();
     processtype = new Process_Type__c();
     processtype1 = new Process_Type__c();
        
       subprocesstype = new Sub_Process_Type__c();
       subprocesstype1 = new Sub_Process_Type__c();
       subprocesstype2 = new Sub_Process_Type__c();
       subprocesstype3 = new Sub_Process_Type__c();
       subprocesstype4 = new Sub_Process_Type__c();
       subprocesstype5 = new Sub_Process_Type__c();
       subprocesstype6 = new Sub_Process_Type__c();
       subprocesstype7 = new Sub_Process_Type__c();
       subprocesstype8 = new Sub_Process_Type__c();
       subprocesstype9 = new Sub_Process_Type__c();
       subprocesstype10 = new Sub_Process_Type__c();
       subprocesstype11 = new Sub_Process_Type__c();
       subprocesstype12 = new Sub_Process_Type__c();
         subprocesstype13 = new Sub_Process_Type__c();
       
        process = new Process__c();
       
        subprocess = new  Sub_Process__c();
        subprocess1 = new  Sub_Process__c();
        subprocess2 = new  Sub_Process__c();
       
         workplantask = new Workplan_Task__c();
         workplantask1 = new Workplan_Task__c();
         workplantask2 = new Workplan_Task__c();
       
        workplan = new Workplan_Task_Template__c();
        workplan1 = new Workplan_Task_Template__c();
        workplan2 = new Workplan_Task_Template__c();
      
       //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
       List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02
       List<Process_Type__c> processTypeList = new List<Process_Type__c>();
      
       Id oppid = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('200+').RecordTypeId;
       Id ppRecordTypeId = Schema.SObjectType.Proposed_Products__c.RecordTypeInfosByName.get('Medical Risk').RecordTypeId; // changes by raj R1E1
       Id ppDrugRecordTypeId = Schema.SObjectType.Proposed_Products__c.RecordTypeInfosByName.get('Drug').RecordTypeId;
       Id ppVisionRecordTypeId = Schema.SObjectType.Proposed_Products__c.RecordTypeInfosByName.get('Vision').RecordTypeId;
       Id ppDentalRecordTypeId = Schema.SObjectType.Proposed_Products__c.RecordTypeInfosByName.get('Dental').RecordTypeId;
       Id accountid = Schema.SObjectType.Account.RecordTypeInfosByName.get('51+').RecordTypeId; 

        User1 = AIA_TestUtil.AIA_createUser('TestAIA');
        insert User1;
       
        TestAcc.Name = 'test';
        TestAcc.Type = 'Customer';
        TestAcc.RecordTypeId = accountid;
        TestAcc.Account_Legal_Name__c = 'test';
        TestAcc.Performance_Guarantee_End_Date__c = null;
        TestAcc.Performance_Guarantee_Start_Date__c = system.today();
        insert TestAcc;
    
    
        //creating different user records 
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        user u7 = AIA_TestUtil.AIA_createUser('alias7');
        user u8 = AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u1); 
        userList.add(u2); 
        userList.add(u3); 
        userList.add(u4); 
        userList.add(u5); 
        userList.add(u6); 
        userList.add(u7); 
        userList.add(u8); 
        insert userList;
       
        //Account should have below three account team roles for opp to create process, sub process and tasks    
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(TestAcc.Id,u1.id,'Account Executive')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(TestAcc.Id,u2.id,'Proposal Specialist')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(TestAcc.Id,u3.id,'Account Manager')); 
       
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(TestAcc.Id,u4.id,'Underwriter')); //T01
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(TestAcc.Id,u5.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(TestAcc.Id,u6.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(TestAcc.Id,u7.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(TestAcc.Id,u8.id,'MAST Tech')); 
       
        insert acctMbrList;
        
        list<Process_Type__c> proces = new list<Process_Type__c>();
        //creating prcoess template records for pre-sales  
        processtype.Active__c = true;
        processtype.Used_For__c = 'Pre-Sales';
        processtype.Process_Name__c = 'Open Enrollment, Materials, & Support';
        processtype.Stage__c = 'Proposal';
        processtype.Sequence_Number__c = 1;
        //insert processtype; T03
        proces.add(processtype);//T03
        
        //creating prcoess template records for post-sales 
        processtype1.Active__c = true;
        processtype1.Used_For__c = 'Post-Sales';
        processtype1.Process_Name__c = 'Open Enrollment, Materials, & Support';
        processtype1.Stage__c = 'Proposal';
        processtype1.Sequence_Number__c = 1;   
        //insert processtype1;T03
        proces.add(processtype1);
        insert proces;
        
        list<Sub_Process_Type__c> sproces = new list<Sub_Process_Type__c>();
        //creating sub process template records    
        subprocesstype.Active__c = true;
        subprocesstype.Used_For__c = 'Pre-Sales';
        subprocesstype.Process_Type__c = processtype.Id;
        subprocesstype.Stage__c = 'Group Structure';
        //insert subprocesstype;T03
        sproces.add(subprocesstype);//T03
            
        subprocesstype1.Active__c = true;
        subprocesstype1.Used_For__c = 'Post-Sales';
        subprocesstype1.Process_Type__c = processtype1.Id;
        subprocesstype1.Stage__c = AIA_CONSTANTS.GROUP_STRUCTURE;//'Group Structure';
        //insert subprocesstype1;t03
        sproces.add(subprocesstype1);//T03
    
        subprocesstype2.Active__c = true;
        subprocesstype2.Used_For__c = 'Post-Sales';
        subprocesstype2.Process_Type__c = processtype1.Id;
        subprocesstype2.Stage__c = AIA_CONSTANTS.SEARCHLIGHT_HEALTHCHECK;//'Group Structure';
        //insert subprocesstype2;T03
        sproces.add(subprocesstype2);//T03
       
        subprocesstype3.Active__c = true;
        subprocesstype3.Used_For__c = 'Post-Sales';
        subprocesstype3.Process_Type__c = processtype1.Id;
        subprocesstype3.Stage__c = AIA_CONSTANTS.ACCOUNT_KICK_OFF_MEETING;//'Account Kick-off Meeting';
        //insert subprocesstype3;T03
        sproces.add(subprocesstype3);//T03
       
        subprocesstype4.Active__c = true;
        subprocesstype4.Used_For__c = 'Post-Sales';
        subprocesstype4.Process_Type__c = processtype1.Id;
        subprocesstype4.Stage__c = AIA_CONSTANTS.ACCM_CNT_SVCS;//'Accm Cnt Svcs';
        //insert subprocesstype4;T03
        sproces.add(subprocesstype4);//T03
        
        subprocesstype5.Active__c = true;
        subprocesstype5.Used_For__c = 'Post-Sales';
        subprocesstype5.Process_Type__c = processtype1.Id;
        subprocesstype5.Stage__c = AIA_CONSTANTS.PERF_GUARANTEE;//'Perf Guarantee';
        //insert subprocesstype5;T03
        sproces.add(subprocesstype5);//T03
       
       subprocesstype6.Active__c = true;
        subprocesstype6.Used_For__c = 'Post-Sales';
        subprocesstype6.Process_Type__c = processtype1.Id;
        subprocesstype6.Stage__c = AIA_CONSTANTS.BAA;//'BAA';
        //insert subprocesstype6;T03
        sproces.add(subprocesstype6);//T03
       
       subprocesstype7.Active__c = true;
        subprocesstype7.Used_For__c = 'Post-Sales';
        subprocesstype7.Process_Type__c = processtype1.Id;
        subprocesstype7.Stage__c = AIA_CONSTANTS.BR_WELLNESS;//'BR Wellness';
        //insert subprocesstype7;T03
        sproces.add(subprocesstype7);//T03
        
       subprocesstype8.Active__c = true;
        subprocesstype8.Used_For__c = 'Post-Sales';
        subprocesstype8.Process_Type__c = processtype1.Id;
        subprocesstype8.Stage__c = AIA_CONSTANTS.PP_CFL;//'PP CFL';
        //insert subprocesstype8;T03
        sproces.add(subprocesstype8);//T03
       
          subprocesstype9.Active__c = true;
        subprocesstype9.Used_For__c = 'Post-Sales';
        subprocesstype9.Process_Type__c = processtype1.Id;
        subprocesstype9.Stage__c = AIA_CONSTANTS.SETUP_CVS;
        //insert subprocesstype9;T03
        sproces.add(subprocesstype9);//T03

          subprocesstype10.Active__c = true;
        subprocesstype10.Used_For__c = 'Post-Sales';
        subprocesstype10.Process_Type__c = processtype1.Id;
        subprocesstype10.Stage__c = AIA_CONSTANTS.SETUP_DAVIS;
        //insert subprocesstype10;T03
        sproces.add(subprocesstype10);//T03

          subprocesstype11.Active__c = true;
        subprocesstype11.Used_For__c = 'Post-Sales';
        subprocesstype11.Process_Type__c = processtype1.Id;
        subprocesstype11.Stage__c = AIA_CONSTANTS.SETUP_FACETS_DENTAL;
        //insert subprocesstype11;T03
        sproces.add(subprocesstype11);//T03

          subprocesstype12.Active__c = true;
        subprocesstype12.Used_For__c = 'Post-Sales';
        subprocesstype12.Process_Type__c = processtype1.Id;
        subprocesstype12.Stage__c = AIA_CONSTANTS.BLUEFUND;
        //insert subprocesstype12;T03
        sproces.add(subprocesstype12);//T03
         
          subprocesstype13.Active__c = true;
        subprocesstype13.Used_For__c = 'Post-Sales';
        subprocesstype13.Process_Type__c = processtype1.Id;
        subprocesstype13.Stage__c = AIA_CONSTANTS.CARVE_OUT_RX;
        //insert subprocesstype13;T03
        sproces.add(subprocesstype13);//T03
        
        insert sproces;//T03

       /*  
        //Assiging process record to opp for creating the process record
        process.implementation__c = Imp.Id;
        process.Used_For__c ='Post-Sales';
        process.Process_Type__c = processtype1.Id; 
        insert process;
       
        //Runtime sub process records and assigning process records to subprocess in post sales
        subprocess.Process__c = process.Id;
        subprocess.Active__c  = true;
        subprocess.status__c = AIA_SubProcessController.Status_Not_Started;
        subprocess.Used_For__c ='Post-Sales';
        insert subprocess;
    
        subprocess1.Process__c = process.Id;
        subprocess1.Active__c  = true;
        subprocess1.status__c = AIA_SubProcessController.Status_Not_Started;
        subprocess1.Used_For__c ='Post-Sales';
        insert subprocess1;
        
        subprocess2.Process__c = process.Id;
        subprocess2.Active__c  = true;
        subprocess2.status__c = AIA_SubProcessController.Status_In_Progress;
        subprocess2.Used_For__c ='Post-Sales';
         subprocess2.Sub_Process_Type__c = subprocesstype8.id;
        insert subprocess2;
        
        //Assigning Workplantask records values
        workplantask.Sub_Process__c = subprocess.Id;
        workplantask.Used_For__c ='Post-Sales';
        
        workplantask.status__c =AIA_SubProcessController.Status_Not_Started;
        insert workplantask;
    
        workplantask1.Sub_Process__c = subprocess1.Id;
        workplantask1.Used_For__c ='Post-Sales';
        workplantask1.status__c =AIA_SubProcessController.Status_Not_Required;
        insert workplantask1;
        
        workplantask2.Sub_Process__c = subprocess2.Id;
        workplantask2.Used_For__c ='Post-Sales';  
        workplantask2.status__c =AIA_SubProcessController.Status_In_Progress;
        insert workplantask2;
            
        //Assigning workplan template record values for pre-sales    
        workplan.Task_Type__c ='Manual';
        workplan.Sub_Process_Type__c = subprocesstype.Id;
        workplan.Used_For__c = 'Pre-Sales';
        insert workplan; 
        
        //Assigning workplan template record values for post-sales    
        workplan1.Task_Type__c ='Manual';
        workplan1.Sub_Process_Type__c = subprocesstype8.Id;
        workplan1.Used_For__c = 'Post-Sales';
        workplan1.Description__c = 'Complete implementation';
        workplan1.Related_Object_API_Name__c = 'AIA_Implementation__c';
        workplan1.Status__c = 'Not-Started';
        workplan1.Task_Completion_Events__c = 'Update';
        workplan1.Task_Completion_Expression__c = '2';
        workplan1.Task_Creation_Criteria_Expression__c = '';
        workplan1.Task_Creation_Events__c = 'Insert';
        workplan1.Task_Owner__c = '';
        workplan1.Task_Owner_Type__c = 'Account Team Role';
        workplan1.Task_Type__c = 'Manual / SF should auto close this task';
        insert workplan1; 

        workplan2.Task_Type__c ='Manual';
        workplan2.Sub_Process_Type__c = subprocesstype2.Id;
        workplan2.Used_For__c = 'Post-Sales';
        insert workplan2; */   
        
        //Opp creation with neccessary values 
        opp.Name = 'CreateProcessSubProcessTest';
        opp.AccountId = TestAcc.Id;
        opp.SBU__c = 'Small/Medium';
        opp.Market_Segment_New__c = '2-50';
        opp.Division__c = '51-199 Renewals';
        opp.Business_Type__c = 'New';//'Prospect/New';
        opp.CloseDate = Date.today();
        //opp.Effective_Date__c = Date.newInstance(2019,5,1);//t03
       // opp.Contract_End_Date__c = Date.newInstance(2019,5,31);
        opp.Effective_Date__c = Date.newInstance(System.Today().year(),System.Today().month()+2, 1 );//t03
        opp.Contract_End_Date__c = Date.newInstance(System.Today().year(),System.Today().month()+3, 1 ) -1;//t03
        opp.StageName = 'RFP';
        opp.Type = 'Dental Only';
        opp.Legal_Account_Name_Verified__c = true; 
        opp.System__c = 'NASCO';
        opp.Underwriting_Entity__c = 'MD';
        opp.Risk_Non_Risk__c = 'Risk';
        opp.RecordTypeId = oppid;
        insert opp;
        
    
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        nbrf.Account__c = TestAcc.Id;
        nbrf.Opportunity__c = opp.id;
        nbrf.Request_Type__c = 'Prospect/New'; 
        //nbrf.Request_Type__c = 'Renew As-is';
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Accommodation__c = 'Emergency Contraception Accommodation';
        nbrf.Benefit_Period__c = 'Calendar';
        nbrf.Control_Plan__c = '580';
        nbrf.Sales_Segment_Size__c = 'Commercial 200-999';
        nbrf.Funding_Arrangements__c = AIA_Constants.BOTH;//'BOTH';
        nbrf.Contract_Period__c = 'Standard - 12 Months';
        nbrf.EGWP_Picklist__c = 'Yes';
        nbrf.FlexLink_Picklist__c =  'Yes';
        nbrf.Grandfathered_Status__c = 'Grandfathered';
        nbrf.Grandfathered_PPACA_Status__c = 'Yes';
        nbrf.Stop_Loss__c = 'CareFirst';
        nbrf.Enrollment_Type__c = 'Parallel';
        nbrf.Broker_Consultant_Compensation__c = 'Commission (%)';
        nbrf.Broker_Consultant_Amount__c = 20;
        nbrf.Contract_Count__c = 1;
        nbrf.Identity_Protection__c = 'Yes';
        insert nbrf;
        
        List<Proposed_Products__c> lstPP = new List<Proposed_Products__c>(); 
        Proposed_Products__c PP = new Proposed_Products__c();
        pp.Benefit_Request_Form__c =  nbrf.id;
        pp.Rider__c = 'Hearing Aid Rider (DC)';
        pp.CDH__c = 'Yes';
        pp.CDH_Fund_Type__c = 'BlueFund';
        pp.Deductible__c = 'Stacked';
        pp.Grandfathered_PPACA_Status__c = 'Yes';
        //pp.Account__c  = TestAcc.Id;
        pp.Out_of_Pocket_Max__c = 'Stacked';
        pp.Three_Month_Deductible__c = 'Yes';
        pp.CDH_Fund_Type__c = 'BlueFund';
        pp.CDH_Type__c = 'HSA';
        pp.RecordTypeId = ppRecordTypeId;
        pp.Funding_Arrangement__c = 'ASO';
        //pp.Blue_Rewards__c = 'Standard';
        //insert PP;
        lstPP.add(PP);
                
        Proposed_Products__c PPDrug = new Proposed_Products__c();
        PPDrug.Benefit_Request_Form__c =  nbrf.id;
        PPDrug.Rider__c = 'Hearing Aid Rider (DC)';
        PPDrug.CDH__c = 'Yes';
        PPDrug.CDH_Fund_Type__c = 'BlueFund';
        PPDrug.Deductible__c = 'Stacked';
        PPDrug.Grandfathered_PPACA_Status__c = 'Yes';
        PPDrug.Out_of_Pocket_Max__c = 'Stacked';
        PPDrug.Three_Month_Deductible__c = 'Yes';
        PPDrug.CDH_Fund_Type__c = 'BlueFund';
        PPDrug.CDH_Type__c = 'HSA';
        PPDrug.RecordTypeId = ppDrugRecordTypeId;
        PPDrug.Funding_Arrangement__c = 'ASO';
        //insert PPDrug;
         lstPP.add(PPDrug);

         Proposed_Products__c PPDental = new Proposed_Products__c();
        PPDental.Benefit_Request_Form__c =  nbrf.id;
        PPDental.Rider__c = 'Hearing Aid Rider (DC)';
        PPDental.CDH__c = 'Yes';
        PPDental.CDH_Fund_Type__c = 'BlueFund';
        PPDental.Deductible__c = 'Stacked';
        PPDental.Grandfathered_PPACA_Status__c = 'Yes';
        PPDental.Out_of_Pocket_Max__c = 'Stacked';
        PPDental.Three_Month_Deductible__c = 'Yes';
        PPDental.CDH_Fund_Type__c = 'BlueFund';
        PPDental.CDH_Type__c = 'HSA';
        PPDental.RecordTypeId = ppDentalRecordTypeId;
        PPDental.Funding_Arrangement__c = 'ASO';
        //insert PPDental;
         lstPP.add(PPDental);
      
         Proposed_Products__c PPVision = new Proposed_Products__c();
        PPVision.Benefit_Request_Form__c =  nbrf.id;
        PPVision.Rider__c = 'Hearing Aid Rider (DC)';
        PPVision.CDH__c = 'Yes';
        PPVision.CDH_Fund_Type__c = 'BlueFund';
        PPVision.Deductible__c = 'Stacked';
        PPVision.Grandfathered_PPACA_Status__c = 'Yes';
        PPVision.Out_of_Pocket_Max__c = 'Stacked';
        PPVision.Three_Month_Deductible__c = 'Yes';
        PPVision.CDH_Fund_Type__c = 'BlueFund';
        PPVision.CDH_Type__c = 'HSA';
        PPVision.RecordTypeId = ppVisionRecordTypeId;
        PPVision.Funding_Arrangement__c = 'ASO';
         PPVision.Integrated_Carved_Out_Vendor__c = 'ESI';
         PPVision.Custom_Wellness__c = true;
         PPVision.Custom_Core_DM_Wellness__c = true;
         
        //insert PPVision;
         lstPP.add(PPVision);
         insert lstPP;
      
        Imp.Name__c = 'testprf';
        Imp.Benefit_Request_Form__c = nbrf.Id;
         Imp.Account__c = TestAcc.Id;
        Imp.Opportunity__c = opp.Id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Risk_Type__c='ASO';
        insert Imp;
        
        Test.startTest();
         
        process__c p1 = new process__C();
        p1.Active__c = true;
        p1.Used_for__c = 'Post-sales';
        p1.Implementation__c = Imp.id;
          p1.Process_Type__c = processtype1.Id; 
        insert p1;
        
        list<Sub_Process__c>  sp = new list<Sub_Process__c>();
        Sub_Process__c sp1 = new Sub_Process__c();
        sp1.process__c = p1.id;
        sp1.Implementation__c = imp.id;
        sp1.status__c = 'In-Progress';
        sp1.used_for__c = 'Post-Sales';
        sp1.Sub_Process_Type__c=subprocesstype8.id;
        //insert sp1;t03
        sp.add(sp1);//T03
         
         Sub_Process__c sp2 = new Sub_Process__c();
        sp2.process__c = p1.id;
        sp2.Implementation__c = imp.id;
        sp2.status__c = 'Not Required';
        sp2.used_for__c = 'Post-Sales';
        sp2.Sub_Process_Type__c=subprocesstype8.id;
        //insert sp2;t03
        sp.add(sp2);//T03
        
        insert sp;//T03
       
        Workplan_Task__c wp1 = new Workplan_Task__c();
        wp1.sub_process__c = sp1.id;
        wp1.status__c = 'In Progress';
        wp1.Implementation__c = imp.id;
        wp1.used_for__c = 'Post-Sales';
        wp1.Task_Owner__c = 'Account Executive';
        insert wp1;
       
        List<Workplan_Task_Template__c> WTTList = new List<Workplan_Task_Template__c>();
         Workplan_Task_Template__c WTT50 = new Workplan_Task_Template__c();
        WTT50.Description__c = 'Complete implementation';
        WTT50.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT50.Status__c = 'Not-Started';
        WTT50.Task_Completion_Events__c = 'Update';
        WTT50.Task_Completion_Expression__c = '2';
         WTT50.Task_Creation_Criteria_Expression__c = 'AIA_Implementation__c';
         WTT50.Task_Generation_Criteria_Expression__c='test';
        //WTT4.Task_Completion_Expression__c ='(1 OR 1)';
        WTT50.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
        WTT50.Task_Creation_Events__c = 'Insert';
        WTT50.Task_Owner__c = '';
        WTT50.Task_Owner_Type__c = 'Account Team Role';
        WTT50.Task_Type__c = 'Manual / SF should auto close this task';
         WTT50.Used_For__c='Post-Sales';
         WTT50.Sub_Process_Type__c = subprocesstype8.id;
        WTTList.add(WTT50); 
         
       Workplan_Task_Template__c WTT51 = new Workplan_Task_Template__c();
        WTT51.Description__c = 'Complete implementation';
        WTT51.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT51.Status__c = 'Not-Started';
        WTT51.Task_Completion_Events__c = 'Update';
       WTT51.Task_Creation_Criteria_Expression__c = 'AIA_Implementation__c';
        //WTT4.Task_Completion_Expression__c ='(1 OR 1)';
        WTT51.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
        WTT51.Task_Creation_Events__c = 'Insert';
        WTT51.Task_Owner__c = '';
        WTT51.Task_Owner_Type__c = 'Account Team Role';
        WTT51.Task_Type__c = 'Manual / SF should auto close this task';
         WTT51.Used_For__c='Post-Sales';
WTT51.Sub_Process_Type__c = subprocesstype8.id;
        WTTList.add(WTT51); 
         insert WTTList;
         List<Workplan_Task_Rules__c> WTRList = new List<Workplan_Task_Rules__c>();
        
        Workplan_Task_Rules__c WTR6 = new Workplan_Task_Rules__c();
        WTR6.Field_API_Name__c = 'Status__c';
        WTR6.Object_API_Name__c = 'AIA_Implementation__c';
        WTR6.Object_DML_Event__c = 'Insert';
        WTR6.Operation__c = 'Equal To';
        WTR6.Rule_Number__c = 2;
        WTR6.Value__c = 'In-Progress';
        WTR6.Workplan_Task_Template__c = WTT50.id;
        WTR6.Criteria_Type__c = 'Task Completion Criteria';
        
        WTRList.add(WTR6);
        
        Workplan_Task_Rules__c WTR7 = new Workplan_Task_Rules__c();
        WTR7.Field_API_Name__c = 'Status__c';
        WTR7.Object_API_Name__c = 'AIA_Implementation__c';
        WTR7.Object_DML_Event__c = 'Update';
        WTR7.Operation__c = 'Equal To';
        WTR7.Rule_Number__c = 2;
        WTR7.Value__c = 'In-Progress';
        WTR7.Workplan_Task_Template__c = WTT50.id;
        WTR7.Criteria_Type__c = 'Task Creation Criteria';
        
        WTRList.add(WTR7);
        
        insert WTRList;
       }
    
    //Method to test the workpantask status updates 
    public static testmethod void updateWorkPlanTaskStatusTest()
  {
      List<Process__c> processList =new List<Process__c>();
      List<Sub_Process__c> subprocessList =new List<Sub_Process__c>();
      List<Workplan_Task__c> workplanlist = new List<Workplan_Task__c>();
      processList = [SELECT id,Implementation__c,Opportunity__c,Process_Type__c  from Process__c ];  
      
      system.runAs(User1)
       {
      subprocess.Status__c = AIA_SubProcessController.Status_Not_Required;
      subprocess1.Status__c = AIA_SubProcessController.Status_In_Progress;
     // processList.add(p1);    
      subprocessList.add(subprocess);
      subprocessList.add(subprocess1);
      //update subprocessList;
      
      List<Sub_Process_Type__c> subpt = [select Id,Name,Active__c,All_Tasks_Must_Be_Completed__c,External_ID__c,Parent_Process_Type_Name__c,
                                            Process_Type__c,Sequence_Number__c,Stage__c,Sub_Process_Name__c,Used_For__c,Status__c
                                            from Sub_Process_Type__c 
                                            where Process_Type__c =: processList[0].Process_Type__c AND Active__c = true];
      //system.assertEquals('Not Required', workplantask1.Status__c);
      //system.assertEquals('Not Started',  workplantask.Status__c);
           List<Process__c> procList;
           AIA_SubProcessController.createSubProcess(processList,true);
           
           Sub_Process__c sbp = [select status__c from Sub_Process__c where Status__c = :AIA_SubProcessController.Status_Not_Required limit 1];
           System.Debug('sbp.status__c'+sbp.status__c);
           sbp.status__c = AIA_SubProcessController.Status_In_Progress;
           update sbp;
           
           Sub_Process__c sb = [select status__c from Sub_Process__c where Status__c = :AIA_SubProcessController.Status_In_Progress limit 1];
           System.Debug('sb.status__c'+sb.status__c);
           sb.status__c = AIA_SubProcessController.Status_Not_Required;
           update sb;
            
           
         Test.StopTest();
       }
      
  }

  //Methos to test creation Process,subprocessandTask on opp creation and IMP records goes to IN Progress   
  public static testmethod void createPrePostSalesProcessSubProcessWorkPlanTest()
  {
       List<Workplan_Task__c> workplanlisttoupdate = new List<Workplan_Task__c>();
      Map<Id,Workplan_Task__c> workplanmap = new Map<Id,Workplan_Task__c>();
       system.runAs(User1)
      {

      Imp.Status__c = 'In-Progress';
      update imp;
     }
      for(Sub_Process__c sb : [select status__c from Sub_Process__c where Implementation__c =:imp.Id])
      {
      sb.status__c = 'Completed';
        sb.Sub_Process_Type__c=subprocesstype8.id;
      subprocesstoupdate.add(sb);
      }
      
      if(!subprocesstoupdate.isempty())
      {
          subprocesstoupdate[0].SLA_Day_Type__c='Calendar';
          subprocesstoupdate[0].AIA_Sub_Process_Start_date__c=Date.today().addDays(-1);
          subprocesstoupdate[0].AIA_Sub_Process_End_Date__c=Date.today();
          update subprocesstoupdate;
      }
      
      
      
      List<Workplan_Task__c> workplanList = [select id,Sub_Process__r.Id, Sub_Process__r.Process__r.Id  from Workplan_Task__c where Opportunity__c =:opp.Id];
      system.assertequals(0,workplanList.size()); 
     
      List<Workplan_Task__c> workplanList1 = [select id,Sub_Process__r.Id, status__c, Sub_Process__r.Process__r.Id from Workplan_Task__c where Implementation__c =:imp.Id];
      //system.assertequals(2,workplanList1.size()); 
       
      For(Workplan_Task__c wt   : workplanList1)
       {
       workplanmap.put(wt.Id,wt);    
       wt.status__C = 'completed';
       workplanlisttoupdate.add(wt);
      }
     update workplanlisttoupdate  ;
     system.debug('workplanlisttoupdate@@@'+workplanlisttoupdate);
        
      
      Test.StopTest();      
   }
    
   public static testmethod void createWorkplanTaskTest()
   {
      Process_type__c processtype1 = new Process_type__c();
        processtype1.Active__c = true;
        processtype1.Used_For__c = 'Post-Sales';
        processtype1.Process_Name__c = 'Open Enrollment, Materials, & Support';
        processtype1.Stage__c = 'Proposal';
        processtype1.Sequence_Number__c = 1;   
        insert processtype1;
        
        Sub_Process_Type__c subprocesstype2 = new Sub_Process_Type__c();
        subprocesstype2.Active__c = true;
        subprocesstype2.Used_For__c = 'Post-Sales';
        subprocesstype2.Process_Type__c = processtype1.Id;
        subprocesstype2.Stage__c = AIA_CONSTANTS.SEARCHLIGHT_HEALTHCHECK;//'Group Structure';
        insert subprocesstype2;
      
        Workplan_Task_Template__c WTT50 = new Workplan_Task_Template__c();
        WTT50.Description__c = 'Complete implementation';
        WTT50.Related_Object_API_Name__c = 'AIA_Implementation__c';
        WTT50.Status__c = 'Not-Started';
        WTT50.Task_Creation_Criteria_Expression__c = '1';
        WTT50.Task_Creation_Events__c = 'Update';
        WTT50.Task_Owner__c = '';
        WTT50.Task_Owner_Type__c = 'Account Team Role';
        WTT50.Task_Type__c = 'Manual / SF should auto close this task';
        WTT50.Acc_Team_Role_for_New_Business__c = 'Proposal Specialist';
        WTT50.Acc_Team_Role_for_Renewal_Business__c = 'Proposal Specialist';
        WTT50.Sub_Process_Type__c = subprocesstype2.id;
        insert WTT50;
      
        Workplan_Task_Rules__c WTR53 = new Workplan_Task_Rules__c();
        WTR53.Field_API_Name__c = 'Status__c';
        WTR53.Object_API_Name__c = 'AIA_Implementation__c';
        WTR53.Object_DML_Event__c = 'Update';
        WTR53.Operation__c = 'Not Equal To';
        WTR53.Rule_Number__c = 1;
        WTR53.Value__c = 'Not Started';
        WTR53.Workplan_Task_Template__c = WTT50.id;
        WTR53.Criteria_Type__c = 'Task Creation Criteria';
        insert WTR53;
      
        process__c p1 = new process__C();
        p1.Active__c = true;
            p1.Used_for__c = 'Post-sales';
            p1.Implementation__c = Imp.id;
            p1.Process_Type__c = processtype1.Id; 
            p1.Status__c='Completed';
            p1.Stage__c = 'Proposal';
      insert p1;
      
      Sub_Process__c sp1 = new Sub_Process__c();
            sp1.process__c = p1.id;
            sp1.Implementation__c = imp.id;
            sp1.status__c = 'Not Started';
            sp1.used_for__c = 'Post-Sales';
            sp1.Sub_Process_Type__c = subprocesstype2.Id;
            insert sp1;
      List<Sub_Process__c> subprocessList =  new List<Sub_Process__c>();
      subprocessList.add(sp1);
        
    AIA_WorkPlanController.createWorkPlantask(subprocessList,true);
    Test.StopTest();  
   }
    
    
    //Methos to test creation Process,subprocessandTask on opp creation and IMP records goes to IN Progress   
  
   public static testmethod void updatePrePostSalesProcessSubProcessWorkPlanTest()
  {
       List<Workplan_Task__c> workplanlisttoupdate = new List<Workplan_Task__c>();
      Map<Id,Workplan_Task__c> workplanmap = new Map<Id,Workplan_Task__c>();
       system.runAs(User1)
      {

      Imp.Status__c = 'In-Progress';
      update imp;
     }
      subprocesstoupdate.clear();
      for(Sub_Process__c sb : [select status__c from Sub_Process__c where Implementation__c =:imp.Id])
      {
          System.Debug('sb.status__c'+sb.status__c);
      sb.status__c = 'In-Progress';
      subprocesstoupdate.add(sb);
      }
      
      if(!subprocesstoupdate.isempty())
      {
          subprocesstoupdate[0].SLA_Day_Type__c='Calendar';
          subprocesstoupdate[0].AIA_Sub_Process_Start_date__c=Date.today().addDays(-1);
          subprocesstoupdate[0].AIA_Sub_Process_End_Date__c=Date.today();
          update subprocesstoupdate;
      }
      
      workplanlisttoupdate.clear();
      
      List<Workplan_Task__c> workplanList = [select id,Sub_Process__r.Id, Sub_Process__r.Process__r.Id  from Workplan_Task__c where Opportunity__c =:opp.Id];
      system.assertequals(0,workplanList.size()); 
     
      List<Workplan_Task__c> workplanList1 = [select id,Sub_Process__r.Id, status__c, Sub_Process__r.Process__r.Id from Workplan_Task__c where Implementation__c =:imp.Id];
      //system.assertequals(2,workplanList1.size()); 
       
      For(Workplan_Task__c wt   : workplanList1)
       {
       workplanmap.put(wt.Id,wt);    
       wt.status__C = 'In-Progress';
       workplanlisttoupdate.add(wt);
      }
     update workplanlisttoupdate  ;
     system.debug('workplanlisttoupdate@@@'+workplanlisttoupdate);   
    
      
      Test.StopTest();      
   }
   
     public static testMethod void ChangeStatusTest()
    {

        ApexPages.CurrentPage().getparameters().put('id', imp.id);
       ApexPages.StandardController sc = new ApexPages.StandardController(imp);
       AIA_StartImplementationController si = new AIA_StartImplementationController(sc);
       
     //  si.ChangeStatus();
        Test.stopTest();
      }
    
    static testMethod void Test7() {
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        insert u1;
        system.runas(u1){
            Account a=new Account();
            a.NAme='Test';
            a.Account_Legal_Name__c='Test';
            insert a;
            
            //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
            List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u1.id,'Implementation Manager')); 
            /*R1 added teammember*/
            //List<user> userList = new list<user>();
            
            user u10 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u10);
            user u11 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u11);
            user u2 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u2);
            user u3= AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u3);
            user u4 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u4);
            user u14 = AIA_TestUtil.AIA_createUser('alias144');
            userList.add(u14);
            user u15 = AIA_TestUtil.AIA_createUser('alias145');
            userList.add(u15);
            
            insert userlist;
            
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u10.id,'NASCO Benefit Coder'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u11.id,'Underwriter'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u2.id,'BeneFact Coder'));
            //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u3.id,'Ancillary Analyst'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u4.id,'MAST Tech'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u14.id,'Account Executive'));
            acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(a.Id,u15.id,'Account Manager'));
            insert acctMbrList;
            /*R1 added teammember*/
            
            
            Opportunity o = AIA_TestUtil.AIA_createopportunity1(a.Id);
            
            
            list<Process_Type__c> ptype = new list<Process_Type__c>();
            Process_Type__c processtype2 = new Process_Type__c();
            processtype2.Active__c = true;
            processtype2.Used_For__c = 'Post-Sales';
            processtype2.Process_Name__c = 'Group Structure & Admin Setup';
            processtype2.Stage__c = 'Group Structure & Admin Setup';
            processtype2.Sequence_Number__c = 1;   
            //insert processtype2;t03
            ptype.add(processtype2);
            
            Process_Type__c processtype21 = new Process_Type__c();
            processtype21.Active__c = true;
            processtype21.Used_For__c = 'Post-Sales';
            processtype21.Process_Name__c = 'Account & Member Tools';
            processtype21.Stage__c = 'Account & Member Tools';
            processtype21.Sequence_Number__c = 1;   
            //insert processtype21; t03
            ptype.add(processtype21);
            
            insert ptype;
            
            list<Sub_Process_Type__c> sptype = new list<Sub_Process_Type__c>();
            Sub_Process_Type__c subprocesstype3 = new Sub_Process_Type__c();
            subprocesstype3.Active__c = true;
            subprocesstype3.Used_For__c = 'Post-Sales';
            subprocesstype3.Process_Type__c = processtype2.Id;
            subprocesstype3.Stage__c = 'Group Structure';
            //insert subprocesstype3; t03
            sptype.add(subprocesstype3);
            
            Sub_Process_Type__c subprocesstype31 = new Sub_Process_Type__c();
            subprocesstype31.Active__c = true;
            subprocesstype31.Used_For__c = 'Post-Sales';
            subprocesstype31.Process_Type__c = processtype21.Id;
            subprocesstype31.Stage__c = 'MyAccount';
            //insert subprocesstype31; T03
            sptype.add(subprocesstype31);
            
            insert sptype;
            
            list<Workplan_Task_Template__c> WTlst = new list<Workplan_Task_Template__c>();
            Workplan_Task_Template__c WTT4 = new Workplan_Task_Template__c();
            WTT4.Description__c = 'Complete Settlements Review/Approval';
            WTT4.Related_Object_API_Name__c = 'AIA_Implementation__c';
            WTT4.Status__c = 'Not-Started';
            WTT4.Task_Creation_Events__c = 'Insert';
            WTT4.Task_Completion_Events__c = 'Update';
            WTT4.Task_Creation_Criteria_Expression__c = '';
            WTT4.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
            WTT4.Task_Owner_Type__c = 'Account Team Role';
            WTT4.Task_Owner__c = 'Ancillary Analyst';
            WTT4.Task_Type__c = 'Automated recording of this event';
            WTT4.Acc_Team_Role_for_Renewal_Business__c='Ancillary Analyst';
            WTT4.Acc_Team_Role_for_New_Business__c = 'Ancillary Analyst';
            //insert WTT4; t03
            WTlst.add(WTT4);
            
            Workplan_Task_Template__c WTT41 = new Workplan_Task_Template__c();
            WTT41.Description__c = 'Send notification to My Account team to set-up the account';
            WTT41.Related_Object_API_Name__c = 'AIA_Implementation__c';
            WTT41.Status__c = 'Not-Started';
            WTT41.Task_Creation_Events__c = 'Insert';
            WTT41.Task_Completion_Events__c = 'Update';
            WTT41.Task_Creation_Criteria_Expression__c = '';
            WTT41.Task_Completion_Expression__c ='(1 AND 2 AND 3)';
            WTT41.Task_Owner_Type__c = 'Account Team Role';
            WTT41.Task_Owner__c = 'Ancillary Analyst';
            WTT41.Task_Type__c = 'Automated recording of this event';
            WTT41.Acc_Team_Role_for_Renewal_Business__c='Ancillary Analyst';
            WTT41.Acc_Team_Role_for_New_Business__c = 'Ancillary Analyst';
            //insert WTT41; t03
            WTlst.add(WTT41);
            
            insert WTlst;
            
            Workplan_Task_Rules__c WTR = new Workplan_Task_Rules__c();
            
            WTR.Field_API_Name__c = 'Status__c';
            WTR.Object_API_Name__c = 'AIA_Implementation__c';
            WTR.Object_DML_Event__c = 'Update';
            WTR.Operation__c = 'Equal To';
            WTR.Rule_Number__c = 1;
            WTR.Value__c = 'In-Progress';
            WTR.Workplan_Task_Template__c = WTT4.id;
            WTR.Criteria_Type__c = 'Task Completion Criteria';
            
            insert WTR;
            
            Workplan_Task_Rules__c WTR1 = new Workplan_Task_Rules__c();
            
            WTR1.Field_API_Name__c = 'Status__c';
            WTR1.Object_API_Name__c = 'AIA_Implementation__c';
            WTR1.Object_DML_Event__c = 'Update';
            WTR1.Operation__c = 'Equal To';
            WTR1.Rule_Number__c = 1;
            WTR1.Value__c = 'In-Progress';
            WTR1.Workplan_Task_Template__c = WTT41.id;
            WTR1.Criteria_Type__c = 'Task Completion Criteria';
            
            insert WTR1;
            Dependent_Workplan_Task__c DWT = new Dependent_Workplan_Task__c();
            DWT.Dependent_Task__c = WTT4.id;
            DWT.Primary_Task__c = WTT4.id;
            
            insert DWT;
            
            Benfit_Request_Form__c brf = new Benfit_Request_Form__c();
            
            brf.Contract_Count__c = 123;
            brf.Benefit_Effective_Date__c = system.today();
            
            brf.Escalated_to_Senior_Management__c = true;
            brf.Status__c = 'new';
            brf.Account__c = a.Id;
            brf.Opportunity__c = o.id;
            brf.Jurisdiction__c = 'MD';
            insert brf;
            
            List<AIA_Implementation__c > ailist=new List<AIA_Implementation__c >();
            AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.id;
            Imp.Account__c = a.id;
            Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='Risk';
            Imp.Benefit_Request_Form__c = brf.id;
            Imp.Status__c = 'Not Started';
            ailist.add(Imp);
            insert ailist;
            
            //Test.StopTest();
            Imp.Status__c = 'In-Progress';
            Update Imp;
            List<Process__c> procLst = [SELECT Id, Stage__c, Implementation__c, Implementation__r.BRF_Funding_Arrangement__c, 
                                                (Select id, Description__c, Status__c from Workplan_Tasks__r where 
                                                Status__c != 'Completed' and Status__c != 'Not Required') 
                                                FROM Process__c WHERE Implementation__c=:imp.id AND Status__c != 'Completed'];
            for(Process__c proc:procLst)
            {
                proc.status__c = 'Completed';
            }
            update procLst;
            
            List<Workplan_Task__c> wpLst = [Select Id,Status__c from Workplan_Task__c where status__c !='Not Required' And status__c != 'Completed'];
            for(Workplan_Task__c wp:wpLst)
            {
                wp.status__c = 'Completed';
            }
            update wpLst;
            list<process__c> plst = new list<process__C>();
            process__c p1 = new process__C();
            p1.Active__c = true;
            p1.Used_for__c = 'Post-sales';
            p1.Implementation__c = Imp.id;
            p1.Process_Type__c = processtype2.Id; 
            p1.Status__c='In-Progress';
            p1.Stage__c = 'Group Structure & Admin Setup';
            //insert p1;t03
            plst.add(p1);//T03
            
            process__c p11 = new process__C();
            p11.Active__c = true;
            p11.Used_for__c = 'Post-sales';
            p11.Implementation__c = Imp.id;
            p11.Process_Type__c = processtype21.Id; 
            p11.Status__c='In-Progress';
            p11.Stage__c = 'Account & Member Tools';
            //insert p11;t03
            plst.add(p11);//T03
            
            insert plst;//T03
            
            list<Sub_Process__c> splst = new list<Sub_Process__c>();
            Sub_Process__c sp2 = new Sub_Process__c();
            sp2.process__c = p1.id;
            sp2.Implementation__c = imp.id;
            sp2.status__c = 'In-Progress';
            sp2.used_for__c = 'Post-Sales';
            sp2.Sub_Process_Type__c = subprocesstype3.Id;
            //insert sp2;t03
            splst.add(sp2);//T03
            
            Sub_Process__c sp21 = new Sub_Process__c();
            sp21.process__c = p11.id;
            sp21.Implementation__c = imp.id;
            sp21.status__c = 'Completed';
            sp21.used_for__c = 'Post-Sales';
            sp21.Sub_Process_Type__c = subprocesstype31.Id;
            //insert sp21;t03
            splst.add(sp21);//T03
            
            insert splst;//T03
            
            list<Workplan_Task__c> WTasklst = new list<Workplan_Task__c>();
            Workplan_Task__c WT = new Workplan_Task__c();
            WT.AccountID__c = a.Id;
            WT.Description__c = 'Complete Account Implementation Review/Approval';
            WT.Opportunity__c = o.id;
            WT.RelatedObjectId__c = imp.id;
            WT.Status__c = 'In Progress';
            WT.Description__c='Complete Account Implementation Review/Approval';
            WT.Task_Owner__c = 'Ancillary Analyst';
            WT.Task_Owner_Type__c = 'Account Team Role';
            WT.Workplan_Task_Template__c = WTT4.id;
            WT.Process__c=p1.id;
            WT.Sub_Process__c =sp2.id;
            //insert WT;t03
            WTasklst.add(WT);//T03
            
            Workplan_Task__c WT1 = new Workplan_Task__c();
            WT1.AccountID__c = a.Id;
            WT1.Description__c = 'Verify Account Legal Name';
            WT1.Opportunity__c = o.id;
            WT1.RelatedObjectId__c = imp.id;
            WT1.Status__c = 'Completed';
            WT1.Description__c='Send notification to My Account team to set-up the account';
            WT1.Task_Owner__c = 'Ancillary Analyst';
            WT1.Task_Owner_Type__c = 'Account Team Role';
            WT1.Workplan_Task_Template__c = WTT41.id;
            WT.Process__c=p11.id;
            WT1.Sub_Process__c =sp21.id;
            //insert WT1;t03
            WTasklst.add(WT1);//T03
            
            insert WTasklst;//T03
            
            p11.Status__c = 'Completed';
            update p11;
            
            List<Process__c> processLst1 = [SELECT Id, Stage__c, Implementation__c, Implementation__r.BRF_Funding_Arrangement__c, 
                                                (Select id, Description__c, Status__c from Workplan_Tasks__r where 
                                                Status__c != 'Completed' and Status__c != 'Not Required') 
                                                FROM Process__c WHERE Implementation__c =:imp.id AND Status__c != 'Completed'];
                
            //system.assertEquals(processLst1[0].Workplan_Tasks__r,null);
            List<Process__c> processLst = new List<Process__c>{p1,p11};
            AIA_ProcessTriggerHelper helper = new AIA_ProcessTriggerHelper();
            helper.finalTaskCloseUpdate(processLst);

        }
        Test.StopTest();
    }
   

}