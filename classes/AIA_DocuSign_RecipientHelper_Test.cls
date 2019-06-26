/*=================================================================================================
* Date         : 11/08/2017
* Developer    : satya
* Purpose      : This class function is to test the AIA_DocuSign_RecipientHelper.
*                           
*
*==================================================================================================
*                                 Update History
*                                 ---------------
* Date        Developer    Tag     Description
*===========+============+=====+===================================================================
* 11/24/2017|  Satya    |     | Initial Version                                         
* 06/08/2018    raj kiran      T01       Added code for role updates
*===========+============+=====+===================================================================
*/
@isTest
public class AIA_DocuSign_RecipientHelper_Test {
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
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();//T02
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u7.id,'NASCO Benefit Coder')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u8.id,'BeneFact Coder')); 
        //acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u3.id,'Ancillary Analyst')); 
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u5.id,'MAST Tech'));   
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u1.id,'Underwriter')); //T01
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u2.id,'QA Auditor'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u9.id,'Account Manager'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u10.id,'Billing Tech'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u11.id,'Settlements Analyst'));
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(accnt.Id,u12.id,'Automated Enrollment Tech')); //t01
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
        Imp.Docusign_Document_sending_user__c = UserInfo.getUserEmail();
        Imp.Benefit_Request_Form__c=brf.id;
        Imp.Risk_Type__c='ASO';
        
        insert Imp;
        
        AIA_Document__c aiaDoc = AIA_TestUtil.createAIADocument();
        aiaDoc.Implementation__c= Imp.Id;
        update aiaDoc;
        
        
        list<dsfs__DocuSign_Status__c> DSList = new list<dsfs__DocuSign_Status__c>();
        dsfs__DocuSign_Status__c DS = new dsfs__DocuSign_Status__c();
        DS.Implementation__c = Imp.id;
        DS.dsfs__Subject__c = 'Business Associate Agreement (BAA)';
        DS.dsfs__Sender__c = UserInfo.getName();
        DS.dsfs__Sender_Email__c = UserInfo.getUserEmail();
        DS.dsfs__Envelope_Status__c = 'sent';
        DSList.add(DS);
        
        dsfs__DocuSign_Status__c DS1 = new dsfs__DocuSign_Status__c();
        DS1.AIA_Document__c = aiaDoc.id;
        DS1.dsfs__Subject__c = 'Business Associate Agreement (BAA)';
        DS1.dsfs__Sender__c = UserInfo.getName();
        DS1.dsfs__Sender_Email__c = UserInfo.getUserEmail();
        DS1.dsfs__Envelope_Status__c = 'sent';
        DSList.add(DS1);
        
        insert DSList;
        
        
        
        
        
    }
    
    
    public static testMethod void testMethod1()
    {
        Test.startTest();
        AIA_Implementation__c imp = [select id from AIA_Implementation__c limit 1];
        AIA_Document__c aiaDoc = [select id,Implementation__c from AIA_Document__c limit 1 ];
        dsfs__DocuSign_Status__c DSrec = [select id,Implementation__c,dsfs__Sender__c,dsfs__Sender_Email__c from dsfs__DocuSign_Status__c where Implementation__c !=''limit 1  ];
        dsfs__DocuSign_Status__c DSrec1 = [select id,AIA_Document__c ,dsfs__Sender__c,dsfs__Sender_Email__c from dsfs__DocuSign_Status__c where AIA_Document__c !='' limit 1 ];
        User u = [select Id,email,Name from User limit 1];
        
        list<dsfs__DocuSign_Recipient_Status__c> rlist = new list<dsfs__DocuSign_Recipient_Status__c>();
        list<dsfs__DocuSign_Recipient_Status__c> updaterlist = new list<dsfs__DocuSign_Recipient_Status__c>();
        dsfs__DocuSign_Recipient_Status__c dsr = new dsfs__DocuSign_Recipient_Status__c();
        dsr.dsfs__Parent_Status_Record__c = DSrec.id;
        dsr.dsfs__DocuSign_Recipient_Email__c = 'test@gmail.com';
        dsr.Name = 'test';
        dsr.dsfs__Recipient_Status__c = 'Sent';
        dsr.dsfs__DocuSign_Routing_Order__c = 1;
        dsr.dsfs__DocuSign_Recipient_Id__c = 'DFF8F175-8B17-4E38-B966-7A4139DA1319';
         rlist.add(dsr);
        
        dsfs__DocuSign_Recipient_Status__c dsr1 = new dsfs__DocuSign_Recipient_Status__c();        
        dsr1.dsfs__Parent_Status_Record__c = DSrec1.id;
        dsr1.dsfs__DocuSign_Recipient_Email__c = 'test@gmail.com';
        dsr1.Name = 'test';
        dsr1.dsfs__Recipient_Status__c = 'Sent';
        dsr1.dsfs__DocuSign_Routing_Order__c = 1;
        dsr1.dsfs__DocuSign_Recipient_Id__c = 'DFF8F175-8B17-4E38-B966-7A4139DA1319';
        rlist.add(dsr1);
        
        insert rlist;
        system.assertNOTEquals(rlist.size(),Null); 
        
        dsr.dsfs__Recipient_Status__c = 'completed';
        dsr.dsfs__DocuSign_Routing_Order__c = 3;
        updaterlist.add(dsr);
        
        dsr1.dsfs__Recipient_Status__c = 'completed';
        updaterlist.add(dsr1);
        
        update updaterlist;
        system.assertNOTEquals(updaterlist.size(),Null); 
        
        
        Test.stopTest();
        
        
    }
    
    
    
}