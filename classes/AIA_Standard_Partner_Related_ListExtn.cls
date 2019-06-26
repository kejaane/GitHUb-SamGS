/*=================================================================================================
 * Date         : 08/27/2018
 * Developer    : Gayathri Palanisamy
 * Purpose      : This apex class is extension of VF page 'AIA_Standard_Partner_Related_List'
 *=================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date         Developer         Tag   Description
 *============+=================+=====+============================================================
 * 08/27/2018 + Gayathri P      +     + Initial version
 *============+=================+=====+============================================================ 
 */
public class AIA_Standard_Partner_Related_ListExtn {
    
    public List<Partner> partnerList{get; set;}
    public Map<Id,Partner> accPartnerMap{get;set;}
    public Boolean viewAllRec{get;set;}
    public string accName{get; set;}
    public Boolean enableTable{get;set;}
    public Integer partnerCount{get;set;}
    public String item{get;set;}
    public Id accntId;
    
     
    public AIA_Standard_Partner_Related_ListExtn(ApexPages.StandardController controller)
    {
        Account acc = (Account)controller.getRecord();
        accntId = acc.Id;
        accName = [Select Id,Name from Account where Id=:accntId limit 1].Name;
        partnerList= new List<Partner>();
        enableTable = true;
        item='items';
        viewAllRec = (Apexpages.currentPage().getParameters().get('viewAll') == 'true'?true:false);
        getPartners();
        
    }
    
    //Method to get the partners to display with respect to Account 
    public void getPartners()
    {
        String QueryPartner = 'SELECT Id,OpportunityId,Role,AccountFromId,AccountToId,'+
                       		  'Opportunity.Name,AccountTo.Name '+ 
                       		  'FROM Partner '+ 
                       	      'WHERE AccountFromId=:accntId';
        if(viewAllRec==false)
            QueryPartner = QueryPartner +' ORDER BY CreatedDate DESC LIMIT 5';
        system.debug('QueryPartner'+QueryPartner);
        accPartnerMap=new Map<Id,Partner>((List<Partner>)Database.query(QueryPartner));
        if(accPartnerMap.isEmpty())
        {
          enableTable = false;  
        }
        else
        {
            partnerCount = accPartnerMap.size();
            if(partnerCount==1)
            {
                item='item';
            }
        }
               
    }
    
    //Method to view all the data on click of View All Link from related list
    public PageReference enableAllRec()
    {
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        pageRef.getParameters().put('viewAll','true');
        return pageRef;
    }
    
    //Method to Go back to Account from View All Page
    public PageReference goToAccount()
    {
        return new PageReference('/'+accntId);
    }
    
    public void updateSortedBy()
    {
        getPartners();
    }
    
}