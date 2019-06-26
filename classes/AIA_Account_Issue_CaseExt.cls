/*=================================================================================================================
* Date         : 07/23/2018
* Developer    : Arshia Gulati
* Purpose      : The purpose of this class is to create Account Issue Case from Benefit Design
*=================================================================================================================
*                                 Update History
*                                 ---------------
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 07/23/2018 | Gayathri       |     | Initial Development. 
*=================================================================================================================
*/

public class AIA_Account_Issue_CaseExt {
    
    public string sObjectType;
    public boolean isClassic {get;set;} // This is used to render page to have lightning view
    Public Case accountCase {set;get;}
    public string implementationName {set;get;}
    public string implementationId {set;get;}
    public static string IMPLEMENTATION = 'AIA_Implementation__c';
    public static string BENEFIT_DESIGN = 'AIA_Benefit_Design__c';
    public static string ACCOUNT_ISSUE = 'AIA Account Issue';
    public boolean isAssignmentRule{get;set;}
    
    public Boolean getIsClassic() {
        return (isClassic = AIA_Utils.isClassic());
    }   
    
    
    public AIA_Account_Issue_CaseExt(ApexPages.StandardSetController controller) {
        
        Id recId = ApexPages.currentPage().getParameters().get('id');
        sobjectType = recId.getSObjectType().getDescribe().getName();
        implementationName='';
        implementationId='';
        accountCase = new case();
        if(sobjectType==IMPLEMENTATION)
        {
            implementationName=[select Name from AIA_Implementation__c where Id=:recId].Name;
            accountCase.Implementation__c = recId;
            implementationId = recId;
        }
        else if(sobjectType==BENEFIT_DESIGN)
        {
            AIA_Benefit_Design__c bdRec = [Select Implementation__c,Implementation__r.Name from AIA_Benefit_Design__c where Id=:recId];
            if(bdRec.Implementation__c!=null)
            {
                accountCase.Implementation__c = bdRec.Implementation__c;
                accountCase.AIA_Benefit_Design__c = recId;
                implementationName = bdRec.Implementation__r.Name;
                implementationId = bdRec.Implementation__c;
            }
        }
        else if(sobjectType=='Account')
        {
            accountCase.AccountId = recId; 
        }
        accountCase.OwnerId = Userinfo.getUserId();
        accountCase.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get(ACCOUNT_ISSUE).getRecordTypeId();
        
    }
    
    public PageReference save()
    {
        try{
            system.debug('select check box'+isAssignmentRule);
            if(isAssignmentRule)
            {
                AssignmentRule ar = new AssignmentRule();
                ar = [select id from AssignmentRule where SobjectType = 'Case' and Active = true];
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.assignmentRuleId= ar.id;
                accountCase.setOptions(dmlOpts);
            }
            insert accountCase;
            return new PageReference('/'+accountCase.id); 
        }
        catch(Exception exp)
        {
            String S1 = exp.getMessage();
            if(S1.containsIgnoreCase('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
                S1 = S1.substringBetween('FIELD_CUSTOM_VALIDATION_EXCEPTION, ' , ': [');    
            }
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,S1); 
            ApexPages.addMessage(Msg);
            return null; 
        }
        
    }
    
    // This method is used for classic, URL hacking where it redirects to standard Case Page and autopopulates Opportunity
    public PageReference pageNavigation(){
        
        PageReference pg;
        String recId = ApexPages.currentPage().getParameters().get('id');
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(ACCOUNT_ISSUE).getRecordTypeId();
        
        if(getIsClassic()){
            string url='/500/e?nooverride=1&RecordType='+devRecordTypeId;
            if(implementationId!='')
            {
                url=url+'&CF00N600000030dy0_lkid='+implementationId+'&CF00N600000030dy0='+implementationName;
            }
            pg = new PageReference(url);
            return pg;
        }
        return null;
    }
    
    public PageReference cancelFun(){
        String recId = ApexPages.currentPage().getParameters().get('id');
        PageReference pg;
        pg = new PageReference('/'+recId);
        return pg;
    }
    
}