/*=================================================================================================================
 * Date         : 07/23/2018
 * Developer    : Arshia Gulati
 * Purpose      : The purpose of this class is to create BD Case from Benefit Design
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 07/23/2018 | AG  | T01 | Intial Development. 
 *=================================================================================================================
 */



   public with sharing class AIA_BD_Case {

   public string BDName {set;get;}
   public boolean isClassic {get;set;} // This is used to render page to have lightning view
    
    
   public Boolean getIsClassic() {
        system.debug('Theme of '+UserInfo.getUiThemeDisplayed());
        return (isClassic = AIA_Utils.isClassic());
    }   
    
     
    public AIA_BD_Case(ApexPages.StandardSetController controller) {
        system.debug('****$$$'+ApexPages.currentPage().getParameters().get('id'));
       BDName = [Select Name From AIA_Benefit_Design__c Where id =:ApexPages.currentPage().getParameters().get('id')].Name; // This query to get opportunity Name with the ID from URL
       BDCase = new Case();
       BDCase.OwnerId = Userinfo.getUserId();
       BDCase.AIA_Benefit_Design__c  = ApexPages.currentPage().getParameters().get('id'); // This is used to get the opportunity Id and assign that to field for auto population
       BDCase.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA Benefit Design Cases').getRecordTypeId();
       
    }
   Public Case BDCase {set;get;}

   public PageReference save()
    {
        try{
           Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA Benefit Design Cases').getRecordTypeId(); 
       BDCase.RecordtypeId = caseRecordTypeId;
        insert BDCase;
        return new PageReference('/'+BDCase.id); 
        }
        catch(Exception exp)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,exp.getMessage()));return null; 
        }
    }

     public PageReference pageNavigation(){
         PageReference pg;
        String BDId = ApexPages.currentPage().getParameters().get('id');
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA Benefit Design Cases').getRecordTypeId();
        System.debug('******devRecordTypeId ****'+devRecordTypeId);
       if(getIsClassic()){
            pg = new PageReference('/500/e?nooverride=1&RecordType='+devRecordTypeId+'&CF00N60000002jB0d_lkid='+BDId+'&CF00N60000002jB0d='+BDName);
            return pg;
       }
        return null;
    }
       
       public PageReference cancelFun(){
         String BDId = ApexPages.currentPage().getParameters().get('id');
        PageReference pg;
         pg = new PageReference('/'+BDId);
            return pg;
         }
   
   
   

}