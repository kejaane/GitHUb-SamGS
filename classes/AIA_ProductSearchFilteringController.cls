/**********************************************************************************************************************************
 * Class            : AIA_ProductSearchFilteringController
 * Author           : Goutham Rapolu
 * Version History  : 1.0
 * Creation         : 08/10/2016
 * Description      : Controller for AIA_ProductSearchFiltering Visualforce page.
 *                    This class will have the logic for filtering the Plan Products based on implicit filters from BRF
 *                    and user selected filters from the Visualforce page and redirect to the Proposed product.
 * MODIFICATION LOG:
 * --------------------------------------------------------------------------------------------------------------------------------
 *     AUTHOR          DATE      TAG    DESCRIPTION OF CHANGE                                    
 * --------------------------------------------------------------------------------------------------------------------------------
 * Goutham Rapolu  11/06/2016           Implement pagination for search results
 * Asif Kutagulla  11/08/2016    T01    Include logic to display only Related DRUG Plans when product being searched for is a 
 *                                      medical plan
 * Raviteja v      11/15/2016    T02    removed filter in soql for type__c='Drug' 
 * Goutham Rapolu  12/05/2017    T03    If Product is Risk & Non-Grandfathered then show only 5Tier for Drug.
 * Raviteja        01/24/2018    T04    Added SLDS getter property
 * Raviteja        02/07/2018    T05    Added redirection to lightning page on selection of Carefirst private exchange
 * Rajesh Pennam   02/07/2018    T06    Added SLDS ISCLASSIC function
 *********************************************************************************************************************************/

public with sharing class AIA_ProductSearchFilteringController {
 
    //public String contacts { get; set; }
    public AIA_Plan__c plans {get;set;}
    public List<AIA_Plan__c> planList { get; set; }
    public String productName {get; set;}
    public String productCategory {get; set;}
    public String productLine {get; set;}
    public Date effectiveDate{get;set;}
    public Date termDate{get;set;}
    private string brfId {get;set;} 
    private Benfit_Request_Form__c BRF {get;set;}
    public String CDHfundType {get; set;}
    public String CDHType {get; set;}
    public String CDH {get; set;}
    public integer index = 0;
    public integer blockSize = 5;
    public integer totalRecs = 0;    
    public Integer size{get;set;} 
    public List<String> strOption {get; set;} 
    public boolean IsRiskNonGrandfathered{get;set;}//T03
    public boolean IsGrandfathered{get;set;}
    list<Id> lstRelatedPlans = new list<Id>();//T01
    map<String,String> mapQueryStrParams = new map<String,String>(); //T01
    
    
    // the soql without the order and limit
    private String soql {get;set;}
    
    //constructor
    public AIA_ProductSearchFilteringController(){
        IsRiskNonGrandfathered = false;//T03
        mapQueryStrParams = Apexpages.currentPage().getParameters();//T01
        String RelatedMedicalPlanID = mapQueryStrParams.containsKey('planId')?mapQueryStrParams.get('planId'):''; //T01
        soql = 'select Id, createdDate, Skeleton_Plan__c, Full_Plan_Name__c,plan_name__c, Option__c, Jurisdiction__c from AIA_Plan__c where Product_Status__c = \'Active\'';
        brfId = Apexpages.currentPage().getParameters().get('brfId'); 
        list<Benfit_Request_Form__c> brfList = [Select Id,Name,Account__c, Funding_Arrangements__c, Benefit_Effective_Date__c,Jurisdiction__c,Grandfathered_Status__c,
                                                Opportunity__r.Effective_Date__c   
                                                from Benfit_Request_Form__c 
                                                where Id =:brfId];
        if(brfList != NULL && brfList.size() > 0){
            BRF = brfList[0];
            //T03 Start
            if(BRF.Funding_Arrangements__c == 'Risk' && BRF.Grandfathered_Status__c=='Non-Grandfathered'){
                IsRiskNonGrandfathered = True;
                system.debug('@@IsRiskNonGrandfathered@@'+IsRiskNonGrandfathered);
            }
            if(BRF.Grandfathered_Status__c=='Grandfathered'){
                IsGrandfathered = True;
            }//T03 END
        }

        //T01 - Start
        if(String.isNotEmpty(RelatedMedicalPlanID))
        {
            //T02 - Start 
            for(AIA_Related_Plans__c arp : [SELECT Related_Plan__c 
                                            FROM AIA_Related_Plans__c 
                                            WHERE Plan__c = :RelatedMedicalPlanID AND 
                                                  (Type__c = 'Drug' or Type__c = 'Dental' or Type__c = 'Vision') ])
            {
                lstRelatedPlans.add(arp.Related_Plan__c);
            }
            //T02 - End
        }
        //T01 - End
        
        system.debug('BRF:: '+BRF);
        planList = new List<AIA_Plan__c>();
       // if(BRF != NULL && BRF.Funding_Arrangements__c == 'ASO'){
            runQuery();
       // }    
    }
    //T04 - start
    public Boolean getIsClassic() {
        return AIA_Utils.isClassic();
    }
    //T04 - End
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon != null){
                size = 1;
                //setCon = new ApexPages.StandardSetController(Database.getQueryLocator('Select ' + Query+ ' where Allotted__c != true order by CreatedDate '));
                System.debug('+++++++++setCon='+setCon);
                setCon.setPageSize(20);
            }
            return setCon;
        }set;
    }
    public Boolean hasNext {
        get {
            if(setCon!=null)
            return setCon.getHasNext();
            else
            return false;
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            System.debug('++++==stcon===='+setcon);
            if(setCon != null)
            return setCon.getHasPrevious();
            else
            return false;
            
            
        }
        set;
    }
 
   
     public Integer pageNumber {
            get {
                return setCon.getPageNumber();
            }
            set;
     }   
     
     public Integer noOfRecords {
            get {
                return setCon.getResultSize();
            }
            set;
     } 
    
    public Integer pageNumberTotal {
        get {
            Integer modResult = Math.mod(setCon.getresultSize(), setCon.getPageSize());            
            if(modResult > 0)
            return Math.abs(setCon.getresultSize()/setCon.getPageSize()) + 1;
            else
            return Math.abs(setCon.getresultSize()/setCon.getPageSize());            
        }
        set;
    } 
 
    public void first() {
        setCon.first();
        queryCtrls();
    }
 
    public void last() {
        setCon.last();
       queryCtrls();
    }
 
    public void previous() {
        setCon.previous();
       queryCtrls();
    }
 
    public void next() {
    
      setCon.next();
      queryCtrls();
      /* Id careFistRecordTypeId = Schema.SObjectType.Proposed_Products__c.getRecordTypeInfosByName().get('CareFirst Private Exchange').getRecordTypeId();
       String productCategory = Apexpages.currentPage().getParameters().get('productCategory');
       if(productCategory.equals('CareFirst Private Exchange')){
            PageReference pg= new PageReference('/a0r/e?RecordType='+careFistRecordTypeId).setRedirect(True); //+'&brfid='+brf.id);
       } */
    }

  //Options for the Product Category  
       public List<string> getProdCategoryItems() {
            List<string> options = new List<string>(); 
            Schema.DescribeFieldResult field = AIA_Plan__c.Product_Category__c.getDescribe();
            for (Schema.PicklistEntry f : field.getPicklistValues()){
                options.add(f.getLabel());
            }
            return options;
       }
      
    
  //Options for the Product Line    
    public List<string> getProdLine() {
        String productCategory = Apexpages.currentPage().getParameters().get('productCategory');
        String productLine = Apexpages.currentPage().getParameters().get('productLine');
        List<string> options;
   // if(productLine=='' || productLine==null){
         options = new List<string>();
        Schema.DescribeFieldResult field = AIA_Plan__c.Product_Line__c.getDescribe();
      if(productCategory=='Medical'){
               options.add('HMO');
               options.add('POS');
               options.add('PPO');
         }
         if(productCategory=='Dental'){
             options.add('Dental');
         }
         if(productCategory=='Vision'){
             options.add('Vision');
         }
        if(productCategory=='Drug'){
             options.add('Pharmacy');
         }
        /*for (Schema.PicklistEntry f : field.getPicklistValues()){
            options.add(f.getLabel());
        } */
      // }
        return options;
    }
   //Pull picklist values for CDH    
    public List<string> getCDHitems() {
        List<string> options = new List<string>(); 
        Schema.DescribeFieldResult field = AIA_Plan__c.CDH__c.getDescribe();
        for (Schema.PicklistEntry f : field.getPicklistValues()){
            options.add(f.getLabel());
        }
        return options;
    }
    //Pull picklist values for CDH Type   
    public List<string> getCDHtypeItems() {
        List<string> options = new List<string>(); 
        Schema.DescribeFieldResult field = AIA_Plan__c.CDH_Type__c.getDescribe();
        for (Schema.PicklistEntry f : field.getPicklistValues()){
            options.add(f.getLabel());
        }
        return options;
    }
   //Pull picklist values for CDH Fund Type    
    public List<string> getCDHfundTypeItems() {
        List<string> options = new List<string>(); 
        Schema.DescribeFieldResult field = AIA_Plan__c.CDH_Fund_Type__c.getDescribe();
        for (Schema.PicklistEntry f : field.getPicklistValues()){
            options.add(f.getLabel());
        }
        return options;
    }
    
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }

    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if (sortField == null) {sortField = 'Full_Plan_Name__c'; } return sortField;  }
        set;
    }

    // format the soql for display on the visualforce page
    public String debugSoql {
        get { return soql; }
        set;
    }

    public PageReference toggleSort() {
        return null;
    }
    
    // runs the actual query
    public void runQuery() {

        try {
         planList = new List<AIA_Plan__c>();
          String effectiveDate ='';
          String proStatus = 'Active';
          if(brf.Benefit_Effective_Date__c  != null)
              effectiveDate = String.valueOf(brf.Benefit_Effective_Date__c);
          //planList = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
          if (!effectiveDate.equals(''))
              soql = soql + ' and Effective_Date__c <= '+ String.escapeSingleQuotes(effectiveDate);
              //soql += 'Jurisdiction__c =' +String.escapeSingleQuotes(brf.Jurisdiction__c)+' order by ' + sortField + ' ' + sortDir + ' limit 20'; 
              // Harsha added coded to have filter for CEDE 
          if(brf.Jurisdiction__c != null){
              if(brf.Jurisdiction__c == 'CEDE'){
                  string tempJurisdiction = 'MD';
                  soql += ' and Jurisdiction__c = ' + '\'' +String.escapeSingleQuotes(tempJurisdiction)+ '\'';      
              }else{
                  soql += ' and Jurisdiction__c = ' + '\'' +String.escapeSingleQuotes(brf.Jurisdiction__c)+ '\'';  
              }
          }
          //T03 START
          Date NewBenefitEffectiveDate = brf.Benefit_Effective_Date__c;
          Date OppEffDate = brf.Opportunity__r.Effective_Date__c;
          Date tierdate = date.parse('01/01/2018');
          if(IsRiskNonGrandfathered == True && OppEffDate >= tierdate && NewBenefitEffectiveDate >= OppEffDate){
              soql += ' and TierCount__c <> \'3\' and TierCount__c <> \'4\'';
          }else if(IsRiskNonGrandfathered == True && OppEffDate >= tierdate && NewBenefitEffectiveDate < OppEffDate){
              soql += ' and TierCount__c <> \'5\'';
          }
          if(IsGrandfathered == True || OppEffDate < tierdate ){ //IsRiskNonGrandfathered == True &&
              soql += ' and TierCount__c <> \'5\'';
          }
          /*if(IsGrandfathered == True){
              soql += ' and TierCount__c <> \'5\'';
          }*/
          //T03 END
          /*if(brf.Jurisdiction__c != null)  
              soql += ' and Jurisdiction__c = ' + '\'' +String.escapeSingleQuotes(brf.Jurisdiction__c)+ '\'';*/      
          soql +=  ' order by ' + sortField + ' ' + sortDir ;  //+ ' LIMIT ' + blockSize  + ' OFFSET ' + index
          system.debug('soql===' + soql);
          //planList = Database.query(soql);
          setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
          System.debug('+++setcon+++'+setcon);
          setCon.setPageSize(20);
            queryCtrls();
          
          System.debug('+++lstData+++'+planList);
          System.debug('Retrieved result size-->'+planList.size());
        } catch (Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
        }

    }
     
     public void queryCtrls(){
           planList = new List<AIA_Plan__c>();
          for(AIA_Plan__c r: (List<AIA_Plan__c>)setCon.getRecords()){
            planList.add(r);
           }
          
     
     }
      // runs the search with parameters passed via Javascript
      public PageReference runSearch() {
        Id careFistRecordTypeId = Schema.SObjectType.Proposed_Products__c.getRecordTypeInfosByName().get('CareFirst Private Exchange').getRecordTypeId();

        String productName = Apexpages.currentPage().getParameters().get('productName');
        String productCategory = Apexpages.currentPage().getParameters().get('productCategory');
        String productLine = Apexpages.currentPage().getParameters().get('productLine');
        String thisCDH = Apexpages.currentPage().getParameters().get('CDH');
        String thisCDHtype = Apexpages.currentPage().getParameters().get('CDHtype');
        String thisCDHfundType = Apexpages.currentPage().getParameters().get('CDHfundType');
        String termDate = Apexpages.currentPage().getParameters().get('termDate');
       if(productCategory.equals('CareFirst Private Exchange')){
          //  return new PageReference('/a0r/e?RecordType='+careFistRecordTypeId +'&brfId=%2F'+brf.id+'&retURL=%2F'+brf.id);
           if(getIsClassic() || Test.isRunningTest()){
           return new PageReference('/a0r/e?CF00N600000030UBh='+brf.name+'&CF00N600000030UBh_lkid='+BRF.id+'&RecordType='+careFistRecordTypeId);
           }
        //T-05 start
           //Added code for lightning page redirection to populate fields as URL hacking will not work in lightning
           return new PageReference('/apex/AIA_ProposedProductCPE?brfname='+brf.name+'&brfid='+BRF.id+'&accid='+BRF.Account__c+'&fundingArrangement='+BRF.Funding_Arrangements__c+'&RecordType='+careFistRecordTypeId);
        //T-05 End
        }
        else{ 
        //soql = 'select firstname, lastname, account.name, interested_technologies__c from AIA_Plan__c';
        //soql = productName + productCategory + productLine + jurisdiction;
        //soql = 'select Id, createdDate, Full_Plan_Name__c, plan_name__c,Option__c, Jurisdiction__c from AIA_Plan__c where plan_id__c != null ';
         
             soql = 'select Id, createdDate, Full_Plan_Name__c, plan_name__c,Option__c, Skeleton_Plan__c,Jurisdiction__c from AIA_Plan__c where Product_Status__c = \'Active\' ';
        
          //if(BRF != NULL && !(BRF.Funding_Arrangements__c == 'ASO')){
          if (!productName.equals('')) {
              soql += ' and Full_Plan_Name__c LIKE \'' +String.escapeSingleQuotes(productName)+'%\'';
          }
          if (!productCategory.equals('')) {
              soql += ' and product_category__c LIKE \''+String.escapeSingleQuotes(productCategory)+'%\'';
          }
          if (!productLine.equals('')) {
              soql += ' and product_line__c LIKE \''+String.escapeSingleQuotes(productLine)+'%\'';   
          }
          if (!thisCDH.equals('')) {
              soql += ' and CDH__c LIKE \''+String.escapeSingleQuotes(thisCDH)+'%\'';   
          }
          if (!thisCDHtype.equals('')) {
              soql += ' and CDH_Type__c LIKE \''+String.escapeSingleQuotes(thisCDHtype)+'%\'';   
          }
          if (!thisCDHfundType.equals('')) {
              soql += ' and CDH_Fund_Type__c LIKE \''+String.escapeSingleQuotes(thisCDHfundType)+'%\''; 
          }
          //T01 - Start
          /**if mapQueryStrParams contains key planId then it means that this page is redirected from AddRelatedPlan button**/
          if (mapQueryStrParams.containsKey('planId')) {
              system.debug('lstRelatedPlans--'+String.join(lstRelatedPlans,'---'));
              soql += 'and Id IN :lstRelatedPlans'; 
          }
          //T01 - End
          //}
         system.debug('soql********' + soql);
        // run the query again
        runQuery();
    
        return null;
        }
      }
    

 
 //Cancel action to Return to Benefit request Form    
    public PageReference cancelButton()
    {
        PageReference  pg = new PageReference('/'+brf.id);
        pg.setRedirect(true);
        return pg;
    }
}