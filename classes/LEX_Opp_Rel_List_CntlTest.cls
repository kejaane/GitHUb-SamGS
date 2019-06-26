/*****************************************************************************************************

*=========================================================================================
* Update History
* Date         Developer       Tag          Description
*==================================================================================
* 9/25/2018   |     Paritosh          |     Initial Creation
*==================================================================================

*******************************************************************************************************/

@isTest
public class LEX_Opp_Rel_List_CntlTest {
    
    @testSetup
    public static void testSetup(){
        //create account
        Account acc = AIA_TestUtil.AIA_createAccount();
        //create opportunity
        Opportunity opp = AIA_TestUtil.AIA_createopportunity(acc.id);
    }
	
    public static testmethod void test_getOppIdforFSPGP(){
        
        Opportunity opp = [SELECT id FROM opportunity LIMIT 1];
        //create fspgp
        FSP_GP__c fspgp = new FSP_GP__c();
        fspgp.Opportunity__c = opp.Id;                
        insert fspgp;
        
        LEX_Opp_Rel_List_Cntl.getOppIdforFSPGP(fspgp.id);
    }
    
    public static testmethod void test_getOppIdforContactRole(){
        
        Opportunity opp = [SELECT id FROM opportunity LIMIT 1];
        //create opportunity contact role
        Opportunity_Contact_Role__c ocr = new Opportunity_Contact_Role__c(Opportunity__c=opp.id);
        insert ocr;
        
        LEX_Opp_Rel_List_Cntl.getOppIdforContactRole(ocr.id);
    }
    
    public static testmethod void test_getOppIdforPartner(){
        
        Opportunity opp = [SELECT id FROM opportunity LIMIT 1];
        //create partner
        Partner__c partner = new Partner__c(Opportunity__c=opp.id);
        insert partner;
        LEX_Opp_Rel_List_Cntl.getOppIdforPartner(partner.id);
        
    }
    	
}