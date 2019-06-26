@isTest
public class AIA_BenefitDesignCaseOwnerTest {
public Static TestMethod void AIA_BenefitDesignCaseOwnerTest(){
     
        Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];
        User u = new User(Alias = 'TAlias', Email='TestUserBRF@testorg.com',
        EmailEncodingKey='UTF-8', LastName='TestingUSer', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pro.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF@testorg.com.test');
        insert u;
    	Id AIACase = QueryBase.getRecordtypeId('Case','AIA_BD_Cases');   
    //Commenting as part of US210
    /*AIA_Workplan_Type__c wpt = new AIA_Workplan_Type__c();
        wpt.Used_For__c ='Pre-Sales';
        wpt.Workplan_Type__c = 'New';
        wpt.Active__c=true;
     insert wpt;*/
        
 Account acc = AIA_TestUtil.CreateAccount('Test Account');
            system.assertNotEquals(null,acc.id);
 
              Account_Team__c atmRole = new Account_Team__c ();
            atmRole.TeamMemberRole__c = 'Contract Tech';
            atmRole.AccountId__c =acc.id;
            atmRole.UserId__c = u.id;
            insert atmRole;
            system.assertNotEquals(null,atmRole.id);
      
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
           //o.Workplan_Type__c = wpt.id;//Commenting as part of US210
           o.StageName = 'RFP';
           o.FullServiceProducer__c = 'Direct';
       insert o;
       
        
      Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
            nbrf.Contract_Count__c = 123;
            nbrf.Benefit_Effective_Date__c = system.today();
            nbrf.Account__c = acc.id;
            nbrf.ARC_Approval_Status__c = 'Approved by Committee';
            nbrf.Escalated_to_Senior_Management__c = true;
            nbrf.Status__c = 'new';
            nbrf.Opportunity__c = o.id;
            
      insert nbrf;
       
       
        AIA_Implementation__c Imp = new AIA_Implementation__c();
            Imp.Name__c = 'testprf';
            Imp.Opportunity__c = o.Id;
            Imp.Account__c = acc.Id;
            //Imp.Generate_Workplan_Stages__c = true;
            Imp.Effective_Date__c = system.today();
            Imp.Implementation_Plan_Timeline_Days__c = '60';
            Imp.Risk_Type__c='ASO';
        insert Imp;
         
         
         AIA_Benefit_Design__c aiaBD = new AIA_Benefit_Design__c();
                aiaBD.Implementation__c = Imp.id;
                aiaBD.Account__c=Acc.id;
                aiaBD.Benefit_Request_Form__c=nbrf.id;
            
        insert aiaBD;
    Test.starttest();    
            Case ca = new Case();
             ca.RecordTypeId = AIACase; 
                 ca.Subject = 'Hi';
                 ca.Description = 'Desc';
                 ca.Origin = 'Web';
                 ca.Status = 'Open';
                 ca.AIA_Benefit_Design__c = aiaBD.id;
                 insert ca;
        Test.stopTest();
        }
        }