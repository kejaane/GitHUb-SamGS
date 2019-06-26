/*****************************************************************************************************
 *Date: 28-06-2017
 *Developer: Rajesh Pennam
 *Purpose: Used to test the AIARelatedAncillaryProductDrawloop class.
 *=========================================================================================
 * Update History
 * Date         Developer               Description
 *=========================================================================================
 * 28-06-2017   Rajesh Pennam   |   |  Initial Development
 * 01-18-2019 	Chaithra 		|T01| Created users for account team role as per US1702 and US1730
 *=========================================================================================

 *******************************************************************************************************/

@istest 
public class AIARelatedAncillaryProductDrawloopTest{
    public static testmethod void testproducts(){
    
   //TEst.StartTest();
//Create Account        
        Account acc = AIA_TestUtil.createAccount('TestOEMAcc');     
        Account childAcc1 = new Account(Name = 'Child', ParentId = acc.id);     
        insert childAcc1;       
             system.assertNotEquals(null,acc.id);  
        //Create Opportunity        
        Opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);       
                
         Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];       
                
        User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',       
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',       
        LocaleSidKey='en_US', ProfileId = pro.Id,       
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3335@testorg.com.test');        
        insert u4;      
        
        
        /*AccountTeamMember atm3 =//AIA_TestUtil.SD_CreateAccountTeamMember(acc.id, u4.id, 'Contract Tech');
        new AccountTeamMember ();      
        atm3.TeamMemberRole = 'Contract Tech';      
        atm3.AccountId = acc.id;        
        atm3.UserId = u4.id;        
        insert atm3;*/
        //Creating AccountMember Test Data  T01 starts
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        
        insert acctMbrList;
        //T01 ends
        
	TEst.StartTest();        
        Benfit_Request_Form__c nbrf1 =
        new Benfit_Request_Form__c();        
        nbrf1.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');      
        nbrf1.Contract_Count__c = 123;      
        nbrf1.Benefit_Effective_Date__c = system.today();       
        nbrf1.Account__c = acc.id;      
        nbrf1.ARC_Approval_Status__c = '';      
        nbrf1.Escalated_to_Senior_Management__c = true;     
        nbrf1.Status__c = 'new';        
        nbrf1.Opportunity__c = opp.id;      
        nbrf1.Jurisdiction__c = 'MD';       
        nbrf1.Enrollment_Type__c = 'Cafeteria';     
        insert nbrf1;   
        
        //Query for the Account record types        
        List<RecordType> rtypes = [Select Name, Id From RecordType          
                                   WHERE sObjectType='Proposed_Products__c' and isActive=true];         
        //Create a map between the Record Type Name and Id for easy retrieval       
        Map<String,String> ppRecordTypes = new Map<String,String>{};        
        for(RecordType rt: rtypes)      
        {       
            ppRecordTypes.put(rt.Name,rt.Id);       
        }       
                
        Proposed_Products__c aiaPP1 = new Proposed_Products__c();       
        aiaPP1.Benefit_Request_Form__c = nbrf1.id;      
        aiaPP1.Blue_Rewards__c = 'Standard';        
        aiaPP1.Custom__c = false;       
        aiaPP1.Cafeteria__c = true;     
        aiaPP1.RecordTypeId = ppRecordTypes.get('Medical Risk');     
        aiaPP1.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';        
        insert aiaPP1;      
                
        system.assertNotEquals(null,aiaPP1.id);        
         //Create Benefit Design        
        
        //AIA_Implementation__c Imp =AIA_TestUtil.CreateImp(opp.Id);
        
        // below code added for R1 risks issue start 
        //AIA_Implementation__c Imp =AIA_TestUtil.CreateImp(opp.Id);
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.Id;
        //Imp.Generate_Workplan_Stages__c = true; R1 Risk
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
        Imp.Account__c=acc.id;
        Imp.Benefit_Request_Form__c=nbrf1.id;
        //Imp.Risk_Type__c='Risk';
        insert Imp;
        
        
        // below code added for R1 riks issue end 
        
        /* new AIA_Implementation__c();        
        Imp.Name__c = 'testprf';        
        Imp.Opportunity__c = opp.Id;        
        Imp.Account__c = acc.Id;        
        Imp.Generate_Workplan_Stages__c = true;     
        Imp.Effective_Date__c = system.today();     
        Imp.Implementation_Plan_Timeline_Days__c = '60';        
        Imp.Risk_Type__c='ASO';     
        insert Imp;    
                   */
        AIA_Benefit_Design__c aiaBD1 =//AIA_TestUtil.createBenefitDesign(opp.Id,acc.Id);
        new AIA_Benefit_Design__c();     
        aiaBD1.Implementation__c = Imp.id;      
        aiaBD1.Account__c = acc.Id;     
        aiaBD1.Benefit_Request_Form__c = nbrf1.Id;      
        insert aiaBD1;  
       system.assertNotEquals(null,aiaBD1.id);  
            
             
       	AIA_Benefit_Design_Form__c aiaBDF1 =new AIA_Benefit_Design_Form__c();      
        aiaBDF1.Benefit_Design__c = aiaBD1.id;      
        aiaBDF1.Michelle_s_Law_4a__c = 'Yes';       
        aiaBDF1.Child_Dependents_Limit_Age_4a__c =26;       
        aiaBDF1.Michelle_s_Law_Waiver_4a__c = 'Yes';        
        aiaBDF1.Students_Limit_Age_4a__c = 26;      
        aiaBDF1.Child_Dependents_Removal_Method_4a__c = 'End of Calendar Month';        
        aiaBDF1.Students_Removal_Method_4a__c = 'End of Calendar Month';        
        aiaBDF1.Part_time_Students_with_Disabilities_4a__c ='No';                               
        insert aiaBDF1;         
        
		List<AIA_Benefit_Design_Product__c> bdpList1= new List<AIA_Benefit_Design_Product__c>();
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();        
        aiaBDP1.Benefit_Design__c = aiaBD1.id;      
        //insert aiaBDP1;     
         bdpList1.add(aiaBDP1);
         //AIA_Benefit_Design_Form__c aiaBDF1 =AIA_TestUtil.createBenefitDesignFormForBD(aiaBD1.id,'Admin',aiaBDP1.id);
                 
        AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();        
        aiaBDP2.Benefit_Design__c = aiaBD1.id;      
        //insert aiaBDP2;
          bdpList1.add(aiaBDP2);       
        AIA_Benefit_Design_Product__c aiaBDP112 = new AIA_Benefit_Design_Product__c();      
        aiaBDP112.Benefit_Design__c = aiaBD1.id;        
        aiaBDP112.Related_Medical_Product__c = aiaBDP1.id;              
        //insert aiaBDP112;       
        bdpList1.add(aiaBDP112); 
        AIA_Benefit_Design_Product__c aiaBDP21 = new AIA_Benefit_Design_Product__c();       
        aiaBDP21.Benefit_Design__c = aiaBD1.id;     
        aiaBDP21.Related_Medical_Product__c = aiaBDP1.id;               
        //insert aiaBDP21;
        bdpList1.add(aiaBDP21);
        AIA_Benefit_Design_Product__c aiaBDP23 = new AIA_Benefit_Design_Product__c();       
        aiaBDP23.Benefit_Design__c = aiaBD1.id;     
        aiaBDP23.Related_Medical_Product__c = aiaBDP2.id;               
        //insert aiaBDP23;
        bdpList1.add(aiaBDP23);
        insert bdpList1;
       system.assertNotEquals(null,aiaBDP23.id); 
        //Test.stopTest();  
       AIA_Benefit_Design_Product__c  addl=[select id from AIA_Benefit_Design_Product__c  where id =:aiaBDP21.id];
           try{
        delete  addl; 
        }catch(exception e){}
       delete  aiaBDP23;  
       
       
        AIA_Benefit_Design_Product__c aiaBDP71 = new AIA_Benefit_Design_Product__c();
        aiaBDP71.Benefit_Design__c = aiaBD1.id;
        insert aiaBDP71;  
        
        //System.debug('6.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        AIA_Benefit_Design_Product__c aiaBDP52 = new AIA_Benefit_Design_Product__c();
        aiaBDP52.Benefit_Design__c = aiaBD1.id;
        aiaBDP52.Related_Medical_Product__c = aiaBDP71.id;        
        insert aiaBDP52; 
          
          list<AIA_Benefit_Design_Product__c> lstrec=new list<AIA_Benefit_Design_Product__c>();
          lstrec.add(aiaBDP52);
          lstrec.add(aiaBDP23);
          lstrec.add(aiaBDP21);
          lstrec.add(aiaBDP112);
          
              AIARelatedAncillaryProductDrawloop.UpdateBDPFields(lstrec);
              AIARelatedAncillaryProductDrawloop.deleteBDPFields(lstrec);
        Test.stopTest();
       
     }
     
     
     public static testmethod void testproducts1(){
    
   
//Create Account        
        Account acc = AIA_TestUtil.createAccount('TestOEMAcc');     
        Account childAcc1 = new Account(Name = 'Child', ParentId = acc.id);     
        insert childAcc1;       
             system.assertNotEquals(null,acc.id);  
        //Create Opportunity        
        Opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);       
                
         Profile pro = [SELECT Id FROM Profile WHERE Name='AIA 200+ Standard User - Custom'];       
                
        User u4 = new User(Alias = 'TAlias25', Email='TestUserBRF35@testorg.com',       
        EmailEncodingKey='UTF-8', LastName='TestingUSer2', LanguageLocaleKey='en_US',       
        LocaleSidKey='en_US', ProfileId = pro.Id,       
        TimeZoneSidKey='America/Los_Angeles', UserName='TestingUserBRF3335@testorg.com.test');        
        insert u4; 
               
        /*AccountTeamMember atm3 =//AIA_TestUtil.SD_CreateAccountTeamMember(acc.id, u4.id, 'Contract Tech');
        new AccountTeamMember ();      
        atm3.TeamMemberRole = 'Contract Tech';      
        atm3.AccountId = acc.id;        
        atm3.UserId = u4.id;        
        insert atm3;*/
        //Creating AccountMember Test Data 
        //List<AccountTeamMember> acctMbrList = new List<AccountTeamMember>();
        List<Account_Team__c> acctMbrList = new List<Account_Team__c>();// Replaced standard AccountTeamMember with custom
        acctMbrList.add(AIA_TestUtil.SD_CreateAccountTeamMember(acc.Id,u4.id,'Contract Tech'));
        insert acctMbrList;
          TEst.StartTest();       
        Benfit_Request_Form__c nbrf1 =
        new Benfit_Request_Form__c();        
        nbrf1.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');      
        nbrf1.Contract_Count__c = 123;      
        nbrf1.Benefit_Effective_Date__c = system.today();       
        nbrf1.Account__c = acc.id;      
        nbrf1.ARC_Approval_Status__c = '';      
        nbrf1.Escalated_to_Senior_Management__c = true;     
        nbrf1.Status__c = 'new';        
        nbrf1.Opportunity__c = opp.id;      
        nbrf1.Jurisdiction__c = 'MD';       
        nbrf1.Enrollment_Type__c = 'Cafeteria';     
        insert nbrf1;   
        
        //Query for the Account record types        
        List<RecordType> rtypes = [Select Name, Id From RecordType          
                                   WHERE sObjectType='Proposed_Products__c' and isActive=true];         
        //Create a map between the Record Type Name and Id for easy retrieval       
        Map<String,String> ppRecordTypes = new Map<String,String>{};        
        for(RecordType rt: rtypes)      
        {       
            ppRecordTypes.put(rt.Name,rt.Id);       
        }       
                
        Proposed_Products__c aiaPP1 = new Proposed_Products__c();       
        aiaPP1.Benefit_Request_Form__c = nbrf1.id;      
        aiaPP1.Blue_Rewards__c = 'Standard';        
        aiaPP1.Custom__c = false;       
        aiaPP1.Cafeteria__c = true;     
        aiaPP1.RecordTypeId = ppRecordTypes.get('Medical Risk');     
        aiaPP1.rider__c = 'Family Planning Benefits Exclusion Rider (DC/VA/MD)';        
        insert aiaPP1;      
                
        system.assertNotEquals(null,aiaPP1.id);        
         //Create Benefit Design        
        //AIA_Implementation__c Imp =AIA_TestUtil.CreateImp(opp.Id);
        /* new AIA_Implementation__c();        
        Imp.Name__c = 'testprf';        
        Imp.Opportunity__c = opp.Id;        
        Imp.Account__c = acc.Id;        
        Imp.Generate_Workplan_Stages__c = true;     
        Imp.Effective_Date__c = system.today();     
        Imp.Implementation_Plan_Timeline_Days__c = '60';        
        Imp.Risk_Type__c='ASO';     
        insert Imp;    
                   */
                   
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.Id;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO'; 
    //Imp.Risk_Type__c='Risk';
        insert Imp;
        
        
        AIA_Benefit_Design__c aiaBD1 =//AIA_TestUtil.createBenefitDesign(opp.Id,acc.Id);
        new AIA_Benefit_Design__c();     
        aiaBD1.Implementation__c = Imp.id;      
        aiaBD1.Account__c = acc.Id;     
        aiaBD1.Benefit_Request_Form__c = nbrf1.Id;      
        insert aiaBD1;  
       system.assertNotEquals(null,aiaBD1.id);  
            
             //Test.stopTest();  
       AIA_Benefit_Design_Form__c aiaBDF1 =new AIA_Benefit_Design_Form__c();      
        aiaBDF1.Benefit_Design__c = aiaBD1.id;      
        aiaBDF1.Michelle_s_Law_4a__c = 'Yes';       
        aiaBDF1.Child_Dependents_Limit_Age_4a__c =26;       
        aiaBDF1.Michelle_s_Law_Waiver_4a__c = 'Yes';        
        aiaBDF1.Students_Limit_Age_4a__c = 26;      
        aiaBDF1.Child_Dependents_Removal_Method_4a__c = 'End of Calendar Month';        
        aiaBDF1.Students_Removal_Method_4a__c = 'End of Calendar Month';        
        aiaBDF1.Part_time_Students_with_Disabilities_4a__c ='No';                               
        insert aiaBDF1;         
        
        List<AIA_Benefit_Design_Product__c> bdpList = new List<AIA_Benefit_Design_Product__c>();  
        AIA_Benefit_Design_Product__c aiaBDP1 = new AIA_Benefit_Design_Product__c();        
        aiaBDP1.Benefit_Design__c = aiaBD1.id;      
        //insert aiaBDP1;     
         bdpList.add(aiaBDP1);        
         //AIA_Benefit_Design_Form__c aiaBDF1 =AIA_TestUtil.createBenefitDesignFormForBD(aiaBD1.id,'Admin',aiaBDP1.id);
             
        AIA_Benefit_Design_Product__c aiaBDP2 = new AIA_Benefit_Design_Product__c();        
        aiaBDP2.Benefit_Design__c = aiaBD1.id;      
        //insert aiaBDP2;
        bdpList.add(aiaBDP2);
                
        AIA_Benefit_Design_Product__c aiaBDP112 = new AIA_Benefit_Design_Product__c();      
        aiaBDP112.Benefit_Design__c = aiaBD1.id;        
        aiaBDP112.Related_Medical_Product__c = aiaBDP1.id;  
        aiaBDP112.drawloop_product__c ='BDP-10';        
        //insert aiaBDP112;       
        bdpList.add(aiaBDP112);
         
        AIA_Benefit_Design_Product__c aiaBDP21 = new AIA_Benefit_Design_Product__c();       
        aiaBDP21.Benefit_Design__c = aiaBD1.id;     
        aiaBDP21.Related_Medical_Product__c = aiaBDP1.id;               
        //insert aiaBDP21;
        bdpList.add(aiaBDP21);
        
        AIA_Benefit_Design_Product__c aiaBDP23 = new AIA_Benefit_Design_Product__c();       
        aiaBDP23.Benefit_Design__c = aiaBD1.id;     
        aiaBDP23.Related_Medical_Product__c = aiaBDP2.id; 
        aiaBDP23.drawloop_product__c ='BDP-10';     
        //insert aiaBDP23;
         bdpList.add(aiaBDP23);
         
       //system.assertNotEquals(null,aiaBDP23.id); 
         
       
       
        AIA_Benefit_Design_Product__c aiaBDP71 = new AIA_Benefit_Design_Product__c();
        aiaBDP71.Benefit_Design__c = aiaBD1.id;
        aiaBDP71.drawloop_product__c ='BDP-10'; 
        //insert aiaBDP71;
        bdpList.add(aiaBDP71);  
        //
        //System.debug('6.Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        AIA_Benefit_Design_Product__c aiaBDP52 = new AIA_Benefit_Design_Product__c();
        aiaBDP52.Benefit_Design__c = aiaBD1.id;
        aiaBDP52.Related_Medical_Product__c = aiaBDP71.id;   
         aiaBDP52.drawloop_product__c ='BDP-10';        
        //insert aiaBDP52; 
         bdpList.add(aiaBDP52); 
         insert bdpList;
         
          list<AIA_Benefit_Design_Product__c> lstrec=new list<AIA_Benefit_Design_Product__c>();
          lstrec.add(aiaBDP52);
          lstrec.add(aiaBDP23);
          lstrec.add(aiaBDP21);
          lstrec.add(aiaBDP112);
          
              AIARelatedAncillaryProductDrawloop.UpdateBDPFields(lstrec);
              AIARelatedAncillaryProductDrawloop.deleteBDPFields(lstrec);
         Test.stopTest(); 
       
     }
     
     
     
 }