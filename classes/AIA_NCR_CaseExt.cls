/*=================================================================================================================
 * Date         : 02/11/2018
 * Developer    : Rajesh Pennam
 * Purpose      : The purpose of this class is to create NCR Case from Opportunity and Pre-Populate opportunity in
 *                Case creation
 *=================================================================================================================
 *                                 Update History
 *                                 ---------------
 *   Date        Developer       Tag   Description
 *============+================+=====+=============================================================================
 * 01/22/2018 | Rajesh Pennam  | T01 | Intial Development. Added Opportunity Name to Pre-Populate in NCR Case Creation 
 * 07/24/2018 | Gayathri	   | T02 | Added changes to use this button in  Implementation-Defect 39745.
 *=================================================================================================================
 */



   public with sharing class AIA_NCR_CaseExt {

   public string ContactName {set;get;}
   public string OpportunityName {set;get;}
   public boolean isClassic {get;set;} // This is used to render page to have lightning view
   //T02 -- Start
   public string sObjectType;
   public string OpportunityId {set;get;}
   public static string OPPORTUNITY = 'Opportunity';
   public static string IMPLEMENTATION = 'AIA_Implementation__c';
   //T02 -- End  
    
   public Boolean getIsClassic() {
        return (isClassic = AIA_Utils.isClassic());
    }   
    
     
    public AIA_NCR_CaseExt(ApexPages.StandardSetController controller) {
       //T02 -- Start
       Id recId = ApexPages.currentPage().getParameters().get('id');
       sobjectType = recId.getSObjectType().getDescribe().getName();
        OpportunityName='';
        OpportunityId = '';
        NCRCase = new Case();
        if(sobjectType==OPPORTUNITY){
          OpportunityName = [Select Name From Opportunity Where id =:recId].Name; // This query to get opportunity Name with the ID from URL
       	  OpportunityId = recId;
          NCRCase.Opportunity__c  = ApexPages.currentPage().getParameters().get('id'); // This is used to get the opportunity Id and assign that to field for auto population
		}
        else if(sobjectType==IMPLEMENTATION)
        {
           AIA_Implementation__c impRec = [Select Opportunity__c,Opportunity__r.Name from AIA_Implementation__c where Id=:recId]; 
           OpportunityName = impRec.Opportunity__r.Name;
           OpportunityId = impRec.Opportunity__c;
           NCRCase.Opportunity__c  = impRec.Opportunity__c;
           NCRCase.Implementation__c = recId;
        }
       //T02 -- End
       NCRCase.OwnerId = Userinfo.getUserId();
       //NCRCase.recordtypeid = apexpages.currentpage().getparameters().get('RecordType');
       NCRCase.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA NCR Cases').getRecordTypeId();
       
    
    }


   Public Case NCRCase {set;get;}

    
    
   public PageReference save()
    {
        try{
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA NCR Cases').getRecordTypeId(); 
       NCRCase.RecordtypeId = caseRecordTypeId;
        insert NCRCase;
        
        return new PageReference('/'+NCRCase.id);
        }
        catch(Exception exp)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,exp.getMessage()));return null; 
        }
    }

     /*  public PageReference quicksave(){
     
       Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA NCR Cases').getRecordTypeId(); 
       NCRCase.RecordtypeId = caseRecordTypeId;
        insert NCRCase;
       NCRCase = new Case();

        return new PageReference('/apex/AIA_NCR_Case_Creation');
    }
    
     public PageReference QuickClose(){
     
       Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA NCR Cases').getRecordTypeId(); 
       NCRCase.RecordtypeId = caseRecordTypeId;
       NCRCase.status ='Closed';
        insert NCRCase;
       NCRCase = new Case();

        return new PageReference('/'+NCRCase.id);
    }
    
    
     */
     
     // This method is used for classic, URL hacking where it redirects to standard Case Page and autopopulates Opportunity
     public PageReference pageNavigation(){
         
        string CaseOppty1;
        string CaseOppty2;
        PageReference pg;
        
        String oppId = ApexPages.currentPage().getParameters().get('id');
        Id devRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIA NCR Cases').getRecordTypeId();
        System.debug('******devRecordTypeId ****'+devRecordTypeId);
       if(getIsClassic()){
            
            For(AIA_Configurations__mdt DName :[Select id,DeveloperName,Parameter_Value__c from AIA_Configurations__mdt where (DeveloperName ='CaseOpptyFieldValue1' OR DeveloperName ='CaseOpptyFieldValue2' )]){
            if(DName.DeveloperName == 'CaseOpptyFieldValue1'){CaseOppty1 = DName.Parameter_Value__c ;}
            if(DName.DeveloperName == 'CaseOpptyFieldValue2'){CaseOppty2 = DName.Parameter_Value__c;}
        }
			//T02 -- Start
           pg = new PageReference('/500/e?nooverride=1&RecordType='+devRecordTypeId+'&'+CaseOppty1+ '='+OpportunityId+'&'+CaseOppty2+ '='+OpportunityName);
		   //T02 -- End 
           return pg;
       }
        
        return null;
    }
       
       public PageReference cancelFun(){
        String oppId = ApexPages.currentPage().getParameters().get('id');
        PageReference pg;
        pg = new PageReference('/'+oppId);
        return pg;
         }
   
   
   

}