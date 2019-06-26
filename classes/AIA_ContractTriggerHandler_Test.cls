/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================

*06/08/2018    raj kiran      T01       Added code for role updates
*02/08/2019     Chaithra     |T02|      Replaced std object AccountTeamMember with custom obj Account_Team__c as part of US6713
*==================================================================================

*******************************************************************************************************/


@isTest
private class AIA_ContractTriggerHandler_Test{


   @testSetup static void CreateUserData(){
      //Create Account
        Account acc =AIA_TestUtil.createAccount('TestOEMAcc');
        //Create Opportunity
        Opportunity opp =AIA_TestUtil.AIA_createopportunity(acc.id);     
        //Create testusers
        List<user> userList = new list<user>();
        user u1 = AIA_TestUtil.AIA_createUser('alias1');
        userList.add(u1);
        user u2 = AIA_TestUtil.AIA_createUser('alias2');
        userList.add(u2);        
        user u3 = AIA_TestUtil.AIA_createUser('alias3');
        userList.add(u3);        
        user u4 = AIA_TestUtil.AIA_createUser('alias4');
        userList.add(u4);        
        user u5 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u5); 
        user u6 = AIA_TestUtil.AIA_createUser('alias66');
        userList.add(u6);
        user u7 = AIA_TestUtil.AIA_createUser('alias5');
        userList.add(u7);
        insert userList;       
        
        //Create Account teams for all the relevant roles
        AIA_TestUtil.AIA_createAccountTeamMember(acc.Id, u1.id, 'Auditor'); //t06
        //AIA_createAccountTeamMember(acc.Id, u2.id, 'C&C Contact');
        AIA_TestUtil.AIA_createAccountTeamMember(acc.Id, u3.id, 'Contract Manager');
        AIA_TestUtil.AIA_createAccountTeamMember(acc.Id, u4.id, 'Legal');
        //AIA_createAccountTeamMember(acc.Id, u5.id, 'Sales Service Rep');   
        AIA_TestUtil.AIA_createAccountTeamMember(acc.Id, u6.id, 'Benefit Contract Specialist');  
        AIA_TestUtil.AIA_createAccountTeamMember(acc.Id, u7.id, 'Account Manager');
        
    /*
        AIA_createAccountTeamMember(acc.Id, u1.id, 'Ancillary Analyst');
        AIA_createAccountTeamMember(acc.Id, u2.id,  'Benefact Coder');
        AIA_createAccountTeamMember(acc.Id, u3.id,  'Contract Tech');
        AIA_createAccountTeamMember(acc.Id, u4.id,  'QA Auditor');
        AIA_createAccountTeamMember(acc.Id, u5.id,  'Ancillary Analyst');        
    */
        test.startTest();
        Benfit_Request_Form__c nbrf = new Benfit_Request_Form__c();
        nbrf.recordTypeId=QueryBase.getRecordtypeId('Benfit_Request_Form__c', 'ASO');
        nbrf.Contract_Count__c = 123;
        nbrf.Benefit_Effective_Date__c = system.today();
        nbrf.Account__c = acc.id;
        nbrf.ARC_Approval_Status__c = 'Approved by Committee';
        nbrf.Escalated_to_Senior_Management__c = true;
        nbrf.Status__c = 'new';
        nbrf.Opportunity__c = opp.id;
        nbrf.Jurisdiction__c = 'MD';
        
        insert nbrf;    
        
        //Create an Implementation
        AIA_Implementation__c Imp = new AIA_Implementation__c();
        Imp.Name__c = 'testprf';
        Imp.Opportunity__c = opp.Id;
        Imp.account__c = acc.id;
      /*R1 changes to false*/  
      //Imp.Generate_Workplan_Stages__c = false;
        Imp.Effective_Date__c = system.today();
        Imp.Implementation_Plan_Timeline_Days__c = '60';
        Imp.Risk_Type__c='ASO';
         Imp.Benefit_Request_Form__c = nbrf.id;
      
        insert Imp;
        
        //Create the contract
        contract contractRec = new contract();
        contractRec.accountId=acc.Id;
        contractRec.StartDate=system.today();
        contractRec.ContractTerm=3;
        contractRec.Implementation__c=imp.id;
        insert contractRec;
   
   test.stopTest();
   
   }

    static testMethod void testValidateContract(){
        test.startTest();
        try{
        //AIA_TestUtil.createContract(); 
        //AccountTeamMember atm = [select id,TeamMemberRole from accountteammember where TeamMemberRole  = 'Auditor' limit 1]; //T01//T02 commented
        Account_Team__c atm = [select id,TeamMemberRole__c from Account_Team__c where TeamMemberRole__c  = 'Auditor' limit 1]; //T02
        delete atm;
        contract c = [select id,ContractTerm from contract limit 1];
        c.ContractTerm=4;
        AIA_ContractTriggerHandler.firstrun=false;        
        update c;
        
        }
        catch(exception e){}
        test.stopTest();
    }
    
    static testmethod void testValidateContract2(){
         test.startTest();
        try{
        //AIA_TestUtil.createContract();
       //accountteammember atm = [select id,TeamMemberRole from accountteammember where TeamMemberRole  = 'Benefit Contract Specialist' limit 1];//T02
       Account_Team__c atm= [select id,TeamMemberRole__c from Account_Team__c where TeamMemberRole__c  = 'Benefit Contract Specialist' limit 1]; //T02
        delete atm;
        contract c = [select id,ContractTerm from contract limit 1];
        c.ContractTerm=4;
        AIA_ContractTriggerHandler.firstrun=false;
        update c;
        }
        catch(exception e){}
        test.stopTest();
    }
    static testmethod void testValidateContract3(){
         test.startTest();
        try{
        //AIA_TestUtil.createContract();
       //accountteammember atm = [select id,TeamMemberRole from accountteammember where TeamMemberRole  = 'Contract Manager' limit 1];T02
       Account_Team__c atm= [select id,TeamMemberRole__c from Account_Team__c where TeamMemberRole__c  = 'Contract Manager' limit 1]; //T02
        delete atm;
        contract c = [select id,ContractTerm from contract limit 1];
        c.ContractTerm=4;
        AIA_ContractTriggerHandler.firstrun=false;
        update c;
        }
        catch(exception e){}
        test.stopTest();
    }
    
    static testmethod void testValidateContract4(){
         test.startTest();
        try{
        //AIA_TestUtil.createContract();
       //accountteammember atm = [select id,TeamMemberRole from accountteammember where TeamMemberRole  = 'Legal' limit 1];T02
       Account_Team__c atm= [select id,TeamMemberRole__c from Account_Team__c where TeamMemberRole__c  = 'Legal' limit 1]; //T02
        delete atm;
        contract c = [select id,ContractTerm from contract limit 1];
        c.ContractTerm=4;
        AIA_ContractTriggerHandler.firstrun=false;
        update c;
        }
        catch(exception e){}
        test.stopTest();
    }
    
    static testmethod void testValidateContract5(){
         test.startTest();
        try{
        //AIA_TestUtil.createContract();
       //accountteammember atm = [select id,TeamMemberRole from accountteammember where TeamMemberRole  = 'Account Manager' limit 1];T02
       Account_Team__c atm= [select id,TeamMemberRole__c from Account_Team__c where TeamMemberRole__c  = 'Account Manager' limit 1]; //T02
        delete atm;
        contract c = [select id,ContractTerm from contract limit 1];
        c.ContractTerm=4;
        AIA_ContractTriggerHandler.firstrun=false;
        update c;
        }
        catch(exception e){}
        test.stopTest();
    }
    static testmethod void testValidateContract6(){
        test.startTest();
        try{
            //AIA_TestUtil.createContract();
            account acc = [select id from account limit 1];
            /*User uT6 = AIA_TestUtil.AIA_createUser('aliasT6');
            insert uT6;
            AIA_TestUtil.AIA_createAccountTeamMember(acc.Id, uT6.id, 'Auditor'); //T01*/
            Account_Team__c atm = [select id,TeamMemberRole__c from Account_Team__c where TeamMemberRole__c  = 'Auditor' limit 1];
            contract c = [select id,ContractTerm from contract limit 1];
            c.ContractTerm=4;
            AIA_ContractTriggerHandler.firstrun=false;
            update c;
        }
        catch(exception e){}
        test.stopTest();            
    }
        
    static testmethod void testValidateContract7(){
        test.startTest();
        try{
           // AIA_TestUtil.createContract();
            account acc = [select id from account limit 1];
            /*User u6 = AIA_TestUtil.AIA_createUser('alias6');
            insert u6;
            AIA_TestUtil.AIA_createAccountTeamMember(acc.Id, u6.id, 'Benefit Contract Specialist');*/
            Account_Team__c atm = [select id,TeamMemberRole__c from Account_Team__c where TeamMemberRole__c  = 'Benefit Contract Specialist' limit 1];
            contract c = [select id,ContractTerm from contract limit 1];
            c.ContractTerm=4;
            AIA_ContractTriggerHandler.firstrun=false;
            update c;
        }
        catch(exception e){}
        test.stopTest();                
    }   
    static testmethod void testValidateContract8(){
        test.startTest();
        try{
            //AIA_TestUtil.createContract();
            account acc = [select id from account limit 1];
            /*User u6 = AIA_TestUtil.AIA_createUser('alias6');
            insert u6;
            AIA_TestUtil.AIA_createAccountTeamMember(acc.Id, u6.id, 'Contract Manager');*/
            Account_Team__c atm = [select id,TeamMemberRole__c from Account_Team__c where TeamMemberRole__c  = 'Contract Manager' limit 1];
            contract c = [select id,ContractTerm from contract limit 1];
            c.ContractTerm=4;
            AIA_ContractTriggerHandler.firstrun=false;
            update c;
        }
        catch(exception e){}
        test.stopTest();                
    }
    static testmethod void testValidateContract9(){
        test.startTest();
        try{
           // AIA_TestUtil.createContract();
            account acc = [select id from account limit 1];
            /*User u6 = AIA_TestUtil.AIA_createUser('alias6');
            insert u6;
            AIA_TestUtil.AIA_createAccountTeamMember(acc.Id, u6.id, 'Legal');*/
            Account_Team__c atm = [select id,TeamMemberRole__c from Account_Team__c where TeamMemberRole__c  = 'Legal' limit 1];
            contract c = [select id,ContractTerm from contract limit 1];
            c.ContractTerm=4;
            AIA_ContractTriggerHandler.firstrun=false;
            update c;
        }
        catch(exception e){}
        test.stopTest();                
    }
    static testmethod void testValidateContract10(){
        test.startTest();
        try{
            //AIA_TestUtil.createContract();
            account acc = [select id from account limit 1];
            /*User u6 = AIA_TestUtil.AIA_createUser('alias6');
            insert u6;
            AIA_TestUtil.AIA_createAccountTeamMember(acc.Id, u6.id, 'Account Manager');*/
            Account_Team__c atm = [select id,TeamMemberRole__c from Account_Team__c where TeamMemberRole__c  = 'Account Manager' limit 1];
            contract c = [select id,ContractTerm from contract limit 1];
            c.ContractTerm=4;
            AIA_ContractTriggerHandler.firstrun=false;
            update c;
        }
        catch(exception e){}
        test.stopTest();                
    }
    
}