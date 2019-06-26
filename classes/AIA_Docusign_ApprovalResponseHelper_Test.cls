/*=================================================================================================
* Date         : 11/23/2017
* Developer    : satya
* Purpose      : This class function is to test the AIA_Docusign_ApprovalResponseHelper.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 11/23/2017|  Satya    |     | Initial Version                                         
* 06/08/2018    raj kiran      T01       Added code for role updates
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_Docusign_ApprovalResponseHelper_Test {
    @testSetup static void testdata() {
        //Creating Account Test Data 
                 
            
         Account accnt = AIA_TestUtil.acc();
        
        //Creating User Test Data 
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        /**/  userList.add(u1); 
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        /**/  userList.add(u2);
        user u7 =AIA_TestUtil.AIA_createUser('alias7');
        userList.add(u7);
        user u8 =AIA_TestUtil.AIA_createUser('alias8');
        userList.add(u8);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias6');
        userList.add(u6);
        user u9 = AIA_TestUtil.AIA_createUser('alias9');
        userList.add(u9);
        user u10 = AIA_TestUtil.AIA_createUser('alias10');
        userList.add(u10);
        user u11 = AIA_TestUtil.AIA_createUser('alias11');
        userList.add(u11); 
        user u12 = AIA_TestUtil.AIA_createUser('alias12');
        userList.add(u12);
        user u13 = AIA_TestUtil.AIA_createUser('alias13');
        userList.add(u13);
        user u14 = AIA_TestUtil.AIA_createUser('alias14');
        userList.add(u14);
        user u15 = AIA_TestUtil.AIA_createUser('alias15');
        userList.add(u15);
        insert userList;
        
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();//T02
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u4.id,'Contract Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u13.id,'Implementation Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u14.id,'Account Executive'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u15.id,'Proposal Specialist'));
        insert acctMbrList;
        
        //Commenting as part of US210
        /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
        insert wpt;
        system.assertNOTEquals(wpt,Null);*/
        
        //Creating Opportunity Test Data   
        Opportunity o = AIA_TestUtil.opp(accnt.Id);//Updating as part of US210


        //Creating benefit Request Form Test Data 
        Benfit_Request_Form__c brf = AIA_TestUtil.benForm(accnt.Id,o.id);
        brf.Implementation_Manager_Account_Team__c=u13.id;
        brf.Account_Executive_Account_Team__c=u14.id;
        update brf;
        //Creating AIA Plan Test Data 
        AIA_Plan__c aiapln = AIA_TestUtil.CreateGSMPlan('Medical','Test');
        //Creating Proposed Plan Test Data 
        Proposed_Products__c proPrd = AIA_TestUtil.proposedProduct(
            brf.id,aiapln.id);
        //Creating Benefit Design Test Data  
        //AIA_Benefit_Design__c bd=AIA_TestUtil.cCreateBenefitDesignWImpFromBrf(accnt.id,o.id,brf.id);
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = o.id;
        Imp.Account__c = accnt.id;
        Imp.Generate_Workplan_Stages__c = true;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Benefit_Request_Form__c=brf.id;
        Imp.Risk_Type__c='ASO';
        
        insert Imp;
        
        AIA_Document__c aiaDoc = new AIA_Document__c();
        aiaDoc.Document_Status__c = 'Complete';
        aiaDoc.Document_Type__c = 'Send for BAA Approval';
        aiaDoc.Active__c = True;
        aiaDoc.Start_Date__c = System.today();
        aiaDoc.End_Date__c = System.today()+10;
        aiaDoc.Approval_Status__c = 'Pending';
        insert aiaDoc;
        
        
        list<AIA_Docusign_Approval_Response__c> lstDAR = new list<AIA_Docusign_Approval_Response__c>();
        AIA_Docusign_Approval_Response__c AR = new AIA_Docusign_Approval_Response__c();
        AR.AIA_Document__c = AIAdOC.Id;
        AR.OwnerId = U1.id;
        AR.Business_Area_to_be_Approved__c = 'BAA Approval';
        AR.Response__c = 'Pending';
        AR.Comments__c = '';
        lstDAR.add(AR);
        
        AIA_Docusign_Approval_Response__c AR1 = new AIA_Docusign_Approval_Response__c();
        AR1.AIA_Document__c = AIAdOC.Id;
        AR1.OwnerId = U2.id;
        AR1.Response__c = 'Pending';
        AR1.Business_Area_to_be_Approved__c = 'BAA Approval';
        AR1.Comments__c = '';
        lstDAR.add(AR1);
        
        AIA_Docusign_Approval_Response__c AR2 = new AIA_Docusign_Approval_Response__c();
        AR2.AIA_Document__c = AIAdOC.Id;
        AR2.OwnerId = U3.id;
        AR2.Business_Area_to_be_Approved__c = 'BAA Approval';
        AR2.Response__c = 'Pending';
        AR2.Comments__c = '';
        lstDAR.add(AR2);
        
        AIA_Docusign_Approval_Response__c AR3 = new AIA_Docusign_Approval_Response__c();
        AR3.AIA_Document__c = AIAdOC.Id;
        AR3.OwnerId = U4.id;
        AR3.Business_Area_to_be_Approved__c = 'BAA Approval';
        AR3.Response__c = 'Pending';
        AR3.Comments__c = '';
        lstDAR.add(AR3);
        
        insert lstDAR;
        
        
    }
    
    public static testMethod void testMethod1()
    {
         test.startTest();
        AIA_Document__c doc = [select id,Document_Status__c,Document_Type__c ,Approval_Status__c from AIA_Document__c limit 1];
       /* AIA_Docusign_Approval_Response__c rec = [select id,AIA_Document__c,Business_Area_to_be_Approved__c, Response__c,Comments__c from AIA_Docusign_Approval_Response__c limit 1];
        rec.Response__c = 'Accept';
        update rec;*/
        
        List<AIA_Docusign_Approval_Response__c> DRlst = [select id,AIA_Document__r.approval_size__c,Business_Area_to_be_Approved__c, Response__c,Comments__c from AIA_Docusign_Approval_Response__c];
        system.debug('DRlst>>'+DRlst);
        
        DRlst[0].Response__c = 'Accept';
        update DRlst[0];
        
        DRlst[1].Response__c = 'Accept';
        update DRlst[1];
        
        DRlst[2].Response__c = 'Accept';
        update DRlst[2];
        
        DRlst[3].Response__c = 'Accept';
        update DRlst[3];
        
        DRlst[0].Response__c = 'Pending';
        update DRlst[0];
                    
        test.stopTest(); 
        
    }
    
    
    
    public static testMethod void testMethod2()
    {
         test.startTest();
        
            
        AIA_Document__c doc = [select id,Document_Status__c,approval_size__c,Document_Type__c ,Approval_Status__c from AIA_Document__c limit 1];
        
        List<AIA_Docusign_Approval_Response__c> lstTOUpdat = new List<AIA_Docusign_Approval_Response__c>();
        
        List<AIA_Docusign_Approval_Response__c> DRlst = [select id,AIA_Document__r.approval_size__c,Business_Area_to_be_Approved__c, Response__c,Comments__c from AIA_Docusign_Approval_Response__c];
        system.debug('DRlst>>'+DRlst);
        
        DRlst[0].Response__c = 'Reject';
        DRlst[0].Comments__c = 'Not according to standards';
        if(string.valueof(DRlst[0].AIA_Document__r.approval_size__c) == '' || DRlst[0].AIA_Document__r.approval_size__c == 0 ||DRlst[0].AIA_Document__r.approval_size__c==null ){
               DRlst[0].AIA_Document__r.approval_size__c= 1;}
         update DRlst[0];
         
         DRlst[1].Response__c = 'Reject';
        DRlst[1].Comments__c = 'Not according to standards';
        DRlst[1].AIA_Document__r.approval_size__c= 2;
         update DRlst[1];
         
         DRlst[2].Response__c = 'Reject';
        DRlst[2].Comments__c = 'Not according to standards';
        DRlst[2].AIA_Document__r.approval_size__c= 3;
         update DRlst[2];
         
         DRlst[3].Response__c = 'Reject';
        DRlst[3].Comments__c = 'Not according to standards';
        DRlst[3].AIA_Document__r.approval_size__c= 4;
         update DRlst[3];
         
         
        
        /*for(AIA_Docusign_Approval_Response__c d :DRlst){
            d.Response__c = 'Reject';
            if(string.valueof(d.AIA_Document__r.approval_size__c) == '' || d.AIA_Document__r.approval_size__c == 0 ||d.AIA_Document__r.approval_size__c==null ){
               d.AIA_Document__r.approval_size__c= 3;}
               d.Comments__c = 'Not according to standards';
            lstTOUpdat.add(d);
        }
        system.debug('lstTOUpdat>>'+lstTOUpdat);
        update lstTOUpdat;*/
        
        
        
        test.stopTest(); 
        
    }
    
    
    
}