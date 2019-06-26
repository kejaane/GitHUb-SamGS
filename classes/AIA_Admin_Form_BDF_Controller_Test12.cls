/*************************************************************************************************************************************************
*  Class            : AIA_Admin_Form_BDF_Controller_Test
*  Author           : Rajesh Pennam
*  Version History  : 1.0
*  Creation         : 07/27/2017
*  Description      : This class is ffor the code coverage for AIA_Admin_Form_Contorller
*
*  Modification Log:
* ----------------------------------------------------------------------------------------------------------------------------------------------
*  Author          Date-Modified      Tag      	Description of Change
* ----------------------------------------------------------------------------------------------------------------------------------------------
* Rajesh Pennam     07/27/2017               	Initial Development
* Chaithra 			01-18-2019		|T01| 		Created users for account team role as per US1702 and US1730
* Chaithra			02/05/2019		|T02|		Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*************************************************************************************************************************************************/

@istest
public class AIA_Admin_Form_BDF_Controller_Test12{
    @testSetup Static void testdata() {
    
        //Create Test Accounts
        Account acc = new Account();
        acc.Name = 'TestAccount1';
        acc.Type = 'Customer';
        acc.RecordTypeId = QueryBase.getRecordtypeId('Account', 'X51');       
        acc.Renewal_Anniversary_Month__c='Jan';
        acc.Jurisdiction__c = 'MD';
        acc.Account_Legal_Name__c= 'test Account';
        insert acc;
                
        //Commenting as part of US 210
        /*
        //Creating WorkPlan Type Test Data 
        AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c(); 
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        */
        
        AIA_Field_ID_List__c aia = new AIA_Field_ID_List__c();
        aia.name = 'BDFobject.BDP';
        aia.Field_ID__c = 'CF00N60000002jAm4';
        insert aia;
        
        
        //Create Users to insert in Account Team Roles
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias21');
        userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias71');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias81');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias31');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias41');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias51');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias61');
        userList.add(u6);
        user u9 = AIA_TestUtil.AIA_createUser('alias91');
        userList.add(u9);
        user u = AIA_TestUtil.AIA_createUser('alias0');
        userList.add(u);
        user u10 = AIA_TestUtil.AIA_createUser('alias10');
        userList.add(u10);
        //Creating User Test Data T01 starts
        user u17 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u17);
        user u18 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u18);
        user u19 = AIA_TestUtil.AIA_createUser('alias17');
        userList.add(u19);
        user u20 = AIA_TestUtil.AIA_createUser('alias18');
        userList.add(u20);
		//T01 ends
        insert userList;
        
        //Create Account Team
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>(); T02
        List<Account_Team__c> acctMbrList= new List<Account_Team__c>();//T02
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u1.id,'Underwriter')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u10.id,'Proposal Specialist'));
        //Creating AccountMember Test Data T01 starts
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u17.id,'Benefit Coder'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u18.id,'Benefit Tester'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u19.id,'Vision Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u20.id,'Pharmacy Operations'));
		//T01 ends
        insert acctMbrList;
        
        //Create Test Opportunity
        Opportunity o = new opportunity();
        o.RecordTypeId = QueryBase.getRecordtypeId('Opportunity', 'AIA_200');    
        o.AccountId = acc.id;
        o.name = 'Test Opportunity';
        o.SBU__c = 'Large';
        o.Market_Segment_New__c = '1000+';
        o.Division__c = 'Commercial Business';
        o.Business_Type__c = 'New';
        o.Effective_Date__c =  Date.newInstance(2014,10,1);
        o.CloseDate = o.Effective_Date__c.addDays(-11);
        o.Legal_Account_Name_Verified__c = true;
        o.AE_Name__c = 'Test AE Name';
        o.AM_Name__c = 'Test AM Name';
        o.Contract_End_Date__c = o.Effective_Date__c.addMonths(1);
        o.Contract_End_Date__c = o.Contract_End_Date__c.addDays(-1);
        o.type = 'Medical Only';
        o.System__c = 'Facets';
        o.Underwriting_Entity__c = 'NCAS';
        o.Risk_Non_Risk__c = 'Non-Risk';
        o.StageName = 'RFP';
        o.FullServiceProducer__c = 'Direct';
        //o.Jurisdiction__c = 'MD';
        insert o;
        
         Benfit_Request_Form__c brf = new Benfit_Request_Form__c();    
        brf.Contract_Count__c = 123;
        brf.Benefit_Effective_Date__c = system.today();
        //brf.ARC_Approval_Status__c = 'Approved by Committee';
        brf.Escalated_to_Senior_Management__c = true;
        brf.Status__c = 'new';
        brf.Account__c = acc.id;
        brf.Opportunity__c = o.id;
        brf.Jurisdiction__c = 'MD';
        brf.Funding_Arrangements__c = 'ASO';
        brf.EGWP_Picklist__c = 'No';
        brf.FlexLink_Picklist__c = 'No';
        brf.Request_Type__c = 'RFP';
        brf.Benefit_Period__c= 'Contract';
        brf.Stop_Loss__c ='CareFirst';
        brf.Control_Plan__c= '690';
        brf.Sales_Segment_Size__c = 'Labor';
        brf.Contract_Period__c = 'Standard - 12 Months';
        brf.Grandfathered_Status__c = 'Mixed';
        brf.Grandfathered_PPACA_Status__c = 'Yes';
        brf.Broker_Consultant_Compensation__c = 'Commission (%)';
        brf.Broker_Consultant_Amount__c = 
        brf.Contract_Count__c =5;
        brf.Identity_Protection__c= 'Yes';
        brf.Enrollment_Type__c = 'Parallel';
        brf.Implementation_Manager_Account_Team__c=u9.id;
        brf.Account_Executive_Account_Team__c=u10.id;
        insert brf;
        system.assertNOTEquals(brf,Null);
        
        
        //Create BD Data
        AIA_Benefit_Design__c aiabd = new AIA_Benefit_Design__c();
        aiabd.Account__c = acc.id;
        aiabd.Benefit_Request_Form__c = brf.Id;
        aiabd.Compatible_Checker__c = true;
        insert aiabd;
    }
    
    private static testMethod void Test1(){

        PageReference pageRef = Page.AIA_BDF_Admin_Form;
        Test.SetCurrentPage(PageRef);
        account acc = [Select Id From account  limit 1];
        AIA_Benefit_Design__c bd = [select id,name from AIA_Benefit_Design__c limit 1];
        Id RecordTypeIdAdmin = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        system.debug('RecordTypeIdAdmin****'+RecordTypeIdAdmin);
        //Insert BDF Admin
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bd.id;
        bdf.Legal_Entity__c = 'CFMI';
        bdf.Add_Vendor__c  = 'Compatible';
        bdf.Vendor_CDH_Type__c = 'HSA';
        bdf.Michelle_s_Law_4a__c = 'Yes';
        bdf.Unmarried_Dep_Child_on_Family_Cont_Type__c  = 'MD';
        bdf.Subrogation__c = 'Yes';
        bdf.Child_Dependent_Mandates__c = 'Maryland';
        bdf.recordtypeid = RecordTypeIdAdmin;
        insert bdf;
        
        //Id RecordTypeIdAdmin = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c where id=:bd.Id and name !=null limit 1];

        system.debug('--------bdid.Name'+bd.Name+'-------------BD ID-----'+bdid);

         AIA_Field_ID_List__c bd1=new AIA_Field_ID_List__c();
         bd1.name='BDFobject.Benefit_Design__c';
         bd1.Field_ID__c='CF00N60000002jAke';
         insert bd1;
         
         PageReference pageRef1 =Page.AIA_BDF_Admin_Form;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentPage().getParameters().put('retURL',bd.id);
        system.debug('This is BDF1 >>>>>'+bdf);
        ApexPages.standardController stdCon1=new  ApexPages.standardController(bdf);
        system.debug('This is BDF2 >>>>>'+bdf);
        AIA_Admin_Form_BDF_Controller bdfsave1=new AIA_Admin_Form_BDF_Controller(stdCon1);
        system.debug('bd.Name------'+bd);
        ApexPages.currentPage().getParameters().put('node',bdid.Name );
        ApexPages.currentPage().getParameters().put('id',bdf.id);
        ApexPages.currentPage().getParameters().put('RecordType',RecordTypeIdAdmin );
        
        //bdfsave1.constructer2(bdid.name);
        //bdfsave1.subrogationupdate();
        system.debug('This is BDF3 >>>>>'+bdf);
        bdfsave1.prepopulatesec();
        bdfsave1.saverec();
        bdfsave1.cancel();
     // bdfsave1.clone1();
        bdfsave1.BDFAdmin(bdid.name);
        bdfsave1.pageRedirect();
        bdfsave1.quicksave();
        bdfsave1.Edit();
        bdfsave1.exportAdmin();

        //bdfsave1.cancel();
             
    }
    
    private static testMethod void Test2(){
        try{
            Test.startTest();
            PageReference pageRef =Page.AIA_BDF_Admin_Form;
            Test.setCurrentPage(pageRef);
            Benfit_Request_Form__c brfObj = [Select Id From Benfit_Request_Form__c  limit 1];
            account acc = [Select Id From account  limit 1];
            AIA_Benefit_Design__c bd = [select id,name from AIA_Benefit_Design__c limit 1];
            AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
            bdf.Benefit_Design__c=bd.id;
            
            insert bdf;
            /*Id RecordTypeIdAdmin = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
            AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c  limit 1];
           
            ApexPages.standardController stdCon=new  ApexPages.standardController(bdf);
            AIA_Admin_Form_BDF_Controller bdfsave=new AIA_Admin_Form_BDF_Controller(stdCon);
            Id RecordTypeId = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
            //ApexPages.currentPage().getParameters().put('node',bdp.Name );
            ApexPages.currentPage().getParameters().put('RecordType',RecordTypeId );
            //ApexPages.currentPage().getParameters().put('retURL',bdp.id);
            //bdfsave.getplan();
            //bdfsave.save();*/
            //bdfsave.cancel();
       }
        catch(Exception e){
            system.debug('for catch coverage');
        
    }
    }
    
     private static testMethod void Test3(){
        Test.StartTest();
        PageReference pageRef = Page.AIA_BDF_Admin_Form;
        Test.SetCurrentPage(PageRef);
        account acc = [Select Id From account  limit 1];
        AIA_Benefit_Design__c bd = [select id,name from AIA_Benefit_Design__c limit 1];
        
        //Insert BDF Admin
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bd.id;
        bdf.Legal_Entity__c = 'CFMI';
        bdf.Add_Vendor__c  = 'Compatible';
        bdf.Vendor_CDH_Type__c = 'HSA';
        bdf.Michelle_s_Law_4a__c = 'Yes';
        bdf.Unmarried_Dep_Child_on_Family_Cont_Type__c  = 'MD';
        bdf.Subrogation__c = 'Yes';
        bdf.Child_Dependent_Mandates__c = 'Maryland';
        insert bdf;
        
        Id RecordTypeIdAdmin = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c where id=:bd.Id and name !=null limit 1];

        system.debug('--------bdid.Name'+bd.Name+'-------------BD ID-----'+bdid);

         AIA_Field_ID_List__c bd1=new AIA_Field_ID_List__c();
         bd1.name='BDFobject.Benefit_Design__c';
         bd1.Field_ID__c='CF00N60000002jAke';
         insert bd1;
         
         PageReference pageRef1 =Page.AIA_BDF_Admin_Form;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentPage().getParameters().put('retURL',bd.id);
        Id RecordTypeId1 = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
       
        ApexPages.currentPage().getParameters().put('node',bdid.Name );
        ApexPages.currentPage().getParameters().put('id',bdf.id);
        ApexPages.currentPage().getParameters().put('RecordType',RecordTypeId1 );
        system.debug('This is BDF1 >>>>>'+bdf);
        ApexPages.standardController stdCon1=new  ApexPages.standardController(bdf);
        system.debug('This is BDF2 >>>>>'+bdf);
        AIA_Admin_Form_BDF_Controller bdfsave1=new AIA_Admin_Form_BDF_Controller(stdCon1);
       
        system.debug('This is BDF3 >>>>>'+bdf);
        bdfsave1.prepopulatesec();
        bdfsave1.saverec();
        bdfsave1.cancel();
        bdfsave1.clone1();
        bdfsave1.BDFAdmin(bdid.name);
        bdfsave1.pageRedirect();
        //bdfsave1.cancel();
          
             
    }
    
    
     private static testMethod void Test4(){
        Test.StartTest();
        PageReference pageRef = Page.AIA_BDF_Admin_Form;
        Test.SetCurrentPage(PageRef);
        account acc = [Select Id From account  limit 1];
        AIA_Benefit_Design__c bd = [select id,name from AIA_Benefit_Design__c limit 1];
        
        //Insert BDF Admin
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bd.id;
        bdf.Legal_Entity__c = 'CFMI';
        bdf.Add_Vendor__c  = 'Compatible';
        bdf.Vendor_CDH_Type__c = 'HSA';
        bdf.Michelle_s_Law_4a__c = 'Yes';
        bdf.Unmarried_Dep_Child_on_Family_Cont_Type__c  = 'DC/VA';
        bdf.Subrogation__c = 'Yes';
        bdf.Child_Dependent_Mandates__c = 'Maryland';
        insert bdf;
        
        Id RecordTypeIdAdmin = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c where id=:bd.Id and name !=null limit 1];

        system.debug('--------bdid.Name'+bd.Name+'-------------BD ID-----'+bdid);

         AIA_Field_ID_List__c bd1=new AIA_Field_ID_List__c();
         bd1.name='BDFobject.Benefit_Design__c';
         bd1.Field_ID__c='CF00N60000002jAke';
         insert bd1;
         
         PageReference pageRef1 =Page.AIA_BDF_Admin_Form;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentPage().getParameters().put('retURL',bd.id);
        Id RecordTypeId1 = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
       
        ApexPages.currentPage().getParameters().put('node',bdid.Name );
        ApexPages.currentPage().getParameters().put('id',bdf.id);
        ApexPages.currentPage().getParameters().put('RecordType',RecordTypeId1 );
        system.debug('This is BDF1 >>>>>'+bdf);
        ApexPages.standardController stdCon1=new  ApexPages.standardController(bdf);
        system.debug('This is BDF2 >>>>>'+bdf);
        AIA_Admin_Form_BDF_Controller bdfsave1=new AIA_Admin_Form_BDF_Controller(stdCon1);
        
        system.debug('This is BDF3 >>>>>'+bdf);
        bdfsave1.prepopulatesec();
        bdfsave1.saverec();
        bdfsave1.cancel();
        bdfsave1.clone1();
        bdfsave1.BDFAdmin(bdid.name);
        bdfsave1.pageRedirect();
        //bdfsave1.cancel();
          
             
    }
        
        
        private static testMethod void Test5(){
        Test.StartTest();
        PageReference pageRef = Page.AIA_BDF_Admin_Form;
        Test.SetCurrentPage(PageRef);
        account acc = [Select Id From account  limit 1];
        AIA_Benefit_Design__c bd = [select id,name from AIA_Benefit_Design__c limit 1];
        
        //Insert BDF Admin
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bd.id;
        bdf.Legal_Entity__c = 'CFMI';
        bdf.Add_Vendor__c  = 'Compatible';
        bdf.Vendor_CDH_Type__c = 'HSA';
        bdf.Michelle_s_Law_4a__c = 'Yes';
        bdf.Unmarried_Dep_Child_on_Family_Cont_Type__c  = 'Custom';
        bdf.Subrogation__c = 'Yes';
        bdf.Child_Dependent_Mandates__c = 'Maryland';
        insert bdf;
        
        Id RecordTypeIdAdmin = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
        AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c where id=:bd.Id and name !=null limit 1];

        system.debug('--------bdid.Name'+bd.Name+'-------------BD ID-----'+bdid);

         AIA_Field_ID_List__c bd1=new AIA_Field_ID_List__c();
         bd1.name='BDFobject.Benefit_Design__c';
         bd1.Field_ID__c='CF00N60000002jAke';
         insert bd1;
         
         PageReference pageRef1 =Page.AIA_BDF_Admin_Form;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentPage().getParameters().put('retURL',bd.id);
        Id RecordTypeId1 = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
       
        ApexPages.currentPage().getParameters().put('node',bdid.Name );
        ApexPages.currentPage().getParameters().put('id',bdf.id);
        ApexPages.currentPage().getParameters().put('RecordType',RecordTypeId1 );
        system.debug('This is BDF1 >>>>>'+bdf);
        ApexPages.standardController stdCon1=new  ApexPages.standardController(bdf);
        system.debug('This is BDF2 >>>>>'+bdf);
        AIA_Admin_Form_BDF_Controller bdfsave1=new AIA_Admin_Form_BDF_Controller(stdCon1);
        
        system.debug('This is BDF3 >>>>>'+bdf);
        bdfsave1.prepopulatesec();
        bdfsave1.saverec();
        bdfsave1.cancel();
        bdfsave1.clone1();
        bdfsave1.BDFAdmin(bdid.name);
        bdfsave1.pageRedirect();
        //bdfsave1.cancel();
    
    }
    
    private static testMethod void Test6(){
        Test.StartTest();
        Account acc = [select id,Jurisdiction__c from account limit 1];
        acc.Jurisdiction__c = 'DC';
        Update acc;
        
            
        Benfit_Request_Form__c bdr = [select id,Funding_Arrangements__c from Benfit_Request_Form__c limit 1];
        bdr.Funding_Arrangements__c = 'Risk';
        bdr.Jurisdiction__c = 'DC';
        update bdr;
        
        
        AIA_Benefit_Design__c bdid = [Select Id,name From AIA_Benefit_Design__c limit 1];

        
         AIA_Field_ID_List__c bd1=new AIA_Field_ID_List__c();
         bd1.name='BDFobject.Benefit_Design__c';
         bd1.Field_ID__c='CF00N60000002jAke';
         insert bd1;
        Id RecordTypeId1 = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
       
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bdid.id;
        bdf.Legal_Entity__c = 'CFMI';
        bdf.Add_Vendor__c  = 'Compatible';
        bdf.Vendor_CDH_Type__c = 'HSA';
        bdf.Michelle_s_Law_4a__c = 'Yes';
        //bdf.Unmarried_Dep_Child_on_Family_Cont_Type__c  = 'MD';
        bdf.Subrogation__c = 'Yes';
        bdf.Child_Dependent_Mandates__c = 'Maryland';
        bdf.recordtypeid = RecordTypeId1;
        insert bdf;
        

        PageReference pageRef1 =Page.AIA_BDF_Admin_Form;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentPage().getParameters().put('retURL',bdid.id);
        
        ApexPages.currentPage().getParameters().put('node',bdid.Name );
       // ApexPages.currentPage().getParameters().put('id',bdf.id);
        ApexPages.currentPage().getParameters().put('RecordType',RecordTypeId1 );
        system.debug('This is BDF1 >>>>>'+bdf);
        ApexPages.standardController stdCon1=new  ApexPages.standardController(bdf);
        system.debug('This is BDF2 >>>>>'+bdf);
        AIA_Admin_Form_BDF_Controller bdfsave1=new AIA_Admin_Form_BDF_Controller(stdCon1);

        system.debug('This is BDF3 >>>>>'+bdf);
        bdfsave1.BDFAdmin(bdid.name);
       
    }
    
        
    private static testMethod void Test8(){
        Test.StartTest();
        Account acc = [select id,Jurisdiction__c from account limit 1];
        acc.Jurisdiction__c = 'MD';
        Update acc;
        
            
        Benfit_Request_Form__c brf = [select id,Funding_Arrangements__c,FirstHelp_For_Sold_BRF__c from Benfit_Request_Form__c limit 1];
        brf.Funding_Arrangements__c = 'Risk';
        brf.Jurisdiction__c = 'MD';
        brf.FirstHelp_For_Sold_BRF__c = 'Yes';
        update brf;
        
        
        AIA_Benefit_Design__c bdid = [Select Id,name,Both_Checker__c From AIA_Benefit_Design__c limit 1];
        bdid.Both_Checker__c = true;
        update bdid;
        
         AIA_Field_ID_List__c bd1=new AIA_Field_ID_List__c();
         bd1.name='BDFobject.Benefit_Design__c';
         bd1.Field_ID__c='CF00N60000002jAke';
         insert bd1;
        Id RecordTypeId1 = Schema.SObjectType.AIA_Benefit_Design_Form__c.getRecordTypeInfosByName().get('Admin').getRecordTypeId();
       
        AIA_Benefit_Design_Form__c bdf=new AIA_Benefit_Design_Form__c();
        bdf.Benefit_Design__c=bdid.id;
        bdf.Legal_Entity__c = 'CFMI';
        bdf.Add_Vendor__c  = 'Compatible';
        bdf.Vendor_CDH_Type__c = 'HSA';
        bdf.Michelle_s_Law_4a__c = 'Yes';
        //bdf.Unmarried_Dep_Child_on_Family_Cont_Type__c  = 'MD';
        bdf.Subrogation__c = 'Yes';
        bdf.Child_Dependent_Mandates__c = 'Maryland';
        bdf.recordtypeid = RecordTypeId1;
        bdf.FirstHelp__c = 'Yes';
        insert bdf;
        

        PageReference pageRef1 =Page.AIA_BDF_Admin_Form;
        Test.setCurrentPage(pageRef1);
        
        ApexPages.currentPage().getParameters().put('retURL',bdid.id);
        
        ApexPages.currentPage().getParameters().put('node',bdid.Name );
       // ApexPages.currentPage().getParameters().put('id',bdf.id);
        ApexPages.currentPage().getParameters().put('RecordType',RecordTypeId1 );
        system.debug('This is BDF1 >>>>>'+bdf);
        ApexPages.standardController stdCon2=new  ApexPages.standardController(bdf);
        system.debug('This is BDF2 >>>>>'+bdf);
        AIA_Admin_Form_BDF_Controller bdfsave2=new AIA_Admin_Form_BDF_Controller(stdCon2);

        system.debug('This is BDF3 >>>>>'+bdf);
        bdfsave2.BDFAdmin(bdid.name);
       
    }
    
    
    
    
    
}