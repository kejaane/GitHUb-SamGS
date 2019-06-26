/* =========================================================================================
 * Date         : 07/20/2016
 * Developer    : Ashish Ojha
 * Purpose      : This controller is being called from SBU_Member_Case visualforce page. This
 *                class calls the MSI_MemberSummaryRequest to get data based on subscriber id 
 *                entered by the user. 
 *                Upon entering the subscriber Id, a list of groups will be displayed in tabuler format
 *                upon selecting a group a list of subscribers will be shown in picklist format.
 *                upon selecting one of the members, a table of eligibility items will be displayed. user will be 
 *                allowed to select one of these items and these will be auto populated on case.
 *                This class also helps with redirecting based on the recordtype
 *                selected when creating a case. 
 *=========================================================================================
 * Update History
 *  ---------------
 * Date       Developer         Description
 *===========+============+================================================================
 * 07/20/16   |  Ashish  Ojha       | Initial Version 
 * 11/25/16   |  Ashish Ojha        | Updated  substantially 
 *                                     based on changes in what we get in response from Memeber Summary response class.
 * 12/27/2016 | Ashish Ojha         | updated for autopopulation of Id onto the lookup Group__c lookup field based on the 
 *                                     Group selected.
 * 01/15/2017 | Ashish Ojha         | updated setting up eligibility fields from integration response values 
 *                                     used flateligibility map instead of eligibility map because the new map stored 
 *                                    historical eligiblitiy data 
 * 3/21/17    | Laveen Kattela (LK)      | Update Member ID Card and To and From Date Related Code
 * 5/15/2017  | Ashish Ojha (AO)    | updated to comment out code piece for member Id card request and duplicate case  
 *===========+============+================================================================
*/
public With Sharing class SBU_Member_Case_Controller
{
    MSI_MemberSummaryRequest req = new MSI_MemberSummaryRequest ();
    public MSI_MemberSummaryResponse memSummary = new MSI_MemberSummaryResponse(req);
    public string selectMember                                        {get;set;}// property that will take the value from a class to page and vice versa
    public string selectGroup                                         {get;set;} 
    public string subsId                                              {get;set;}
    public boolean isTable                                            {get;set;}
    public boolean isGroup                                            {get;set;}
    public list<selectOption> lstWrap                                 {get;set;} // total list of data we are seeing 
    public list<selectOption> GroupOption                             {get;set;}
    public String val                                                 {get;set;} 
    public Integer planid                                              {get;set;}
    public case casRec                                                {get;set;}
    
    public boolean isEligibilityTable                                 {get;set;}
    public list<MSI_MemberSummaryResponse.Eligibility> lstEligibility {get;set;}
    public list<MSI_MemberSummaryResponse.Subscriber> lstSubscriber   {get;set;}
    private ApexPages.StandardController sc;
    public boolean showMemDetail                                      {get;set;}
    public boolean showMemberIdSection                                {get;set;}
    
    public SBU_Member_Case_controller(){  // constructor without parameter
        isTable = false;
        showMemDetail  = false;
        casRec = new case();

    }
    public PageReference MemberCardRequest() {
        //do nothing
       // System.debug('************'+casRec.Member_ID_Card__c);
        return null;
    }
    
    public string accId {get;set;}
    public SBU_Member_Case_Controller(ApexPages.StandardController controller) {
        casRec = new case();
       // sc = controller;
        this.casRec = (Case) controller.getRecord();
        casRec.ownerId = userInfo.getUserid();    
        
        // query the case record on edit
        try{
        casRec = [select ParentId , Group__c , Contact_Type__c, ContactId, Status, Broker_Agent__c, Broker_Agency__c, Broker_ID__c, FSPGP__c, FSP_GP_ID__c, Group_Name__c, Group_ID__c, New_Group_ID__c,
                     Priority, CaseNumber, SLA_Category__c, Subject, Broker_Service_Team__c, Facets_Subject__c, Origin, Routed_To__c, Facets_Category__c,Facets_case_ID__c,Facets_Status__c,
                     Broker_Status__c,LastModifiedByid, CreatedById, Received_Date__c, ClosedDate, Related_Relationships__c,GroupContrivedKey__c,MemberContrivedKey__c,
                    Routed_To_Description__c, Description, Resolution_Reason_Code__c, Reason__c, Resolution_Reason__c, E_description__c,ownerid,recordTypeid,SubscriberContrivedKey__c,E_Product_Category__c, 
                   Contact.phone, Broker_Agent__r.Email, Broker_Agent__r.Phone, contact.email, Market_Segment__c, M_First_Name__c ,M_last_Name__c,M_age__c,M_City__c ,E_Plan_ID__c,E_Plan_description__c,
                    E_Termination_date__c ,E_Effective_date__c, E_Product__c,M_Street__C,M_State__c,Subscriber_Id__c,M_Country__c,M_Relationship__c,
                    M_ID__c,M_Zip_Code__c,M_Date_of_Birth__c,M_Phone__c from Case where id = :casRec.id  ];
        //casRec.Effective_Date_Member_ID_Card__c = system.today();
        }catch(exception e){
        }
            casRec.recordTypeid = apexpages.currentpage().getparameters().get('RecordType');
            casRec.ownerId = userInfo.getUserid();// set case owner to logged in user
         //   casRec.Effective_Date_Member_ID_Card__c = system.today();
    }
       
    public void createCase(){
           memberpicklst();
           showMemDetail = true;
           isgroup = false;
           
        // Create a new case with soap data
        if(selectGroup!='None'){
           
           // setup case field value in vf page from integration response 
           
            casRec.GroupContrivedKey__c       = response.subscriberByGroupMap.get(selectGroup).groupContrivedKey;
            casRec.SubscriberContrivedKey__c  = response.subscriberByGroupMap.get(selectGroup).SubscriberContrivedKey;
             //AO changes 12/27/16
            String grp   =  response.subscriberByGroupMap.get(selectGroup).GroupID ;
       
       try{ // Try catch function is put so that if we are unable to find a group__c record with matching group id we want to leave this field blank
            casRec.Group__c = [select id from Group__c where group_id__c =: grp].id;  
           }catch(exception e){}
            
            
           }
        
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Select Valid Group'));
        }
        
    }
    
    public pagereference assignPlan(){ // LK changes - this is method that we used in the save action function. 
        Boolean isValid = true;
        Date effDate = system.today()+62;
        
   /* AO begin  05/15/17 this code will be commented until the integration of Member Id is ready will have to be uncommented later 
      if(casRec.Member_ID_Card__c)
        {
            if(casRec.Effective_Date_Member_ID_Card__c == null )
            {
                isValid = false;
                ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR, 'Please give Effective Date Member in Member Id Card section' ));
            }
            if(casRec.Effective_Date_Member_ID_Card__c > effDate )
            {
                isValid = false;
                ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR, 'Please enter a Effective Date which is not greater than 62 days in Future in Member Id Card section' ));
            }
            
            if(casRec.Type_of_Request__c == null )
            {
                isValid = false;
                ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR, 'Please enter Type in Member Id Card section' ));
            }
            if(casRec.Category__c== null )
            {
                isValid = false;
                ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR, 'Please enter Category in Member Id Card section' ));
            } 
            
        } 
        /*if(!casRec.Member_ID_Card__c){
            casRec.Effective_Date_Member_ID_Card__c = null;
            casRec.Type_of_Request__c = null;
            casRec.Category__c = null;
        }
        if(!isValid)
        return null;
    AO end 
     */   
      try{
        if(casrec.id != NULL ){
        
          update casrec; // update case record
        }
        else{ 
          insert casrec; // insert case record
        }
        
        // redirect page to standard case page
        pagereference pg = New pagereference('/'+ casrec.id);
        pg.setredirect(true);
        return pg;
    }
    
        catch(Exception ex){
        ApexPages.addMessages(ex);
        }
                return null;

     }
    
     MSI_MemberSummaryResponse response;
    // Method to create a wrapper of the soap call data
    public void callWithSubscriberId(){
     lstSubscriber = new list<MSI_MemberSummaryResponse.Subscriber>();
     isTable= false;
     isEligibilityTable =false;
     isGroup =false;
           if(casRec.Subscriber_Id__c == '' || casRec.Subscriber_Id__c  == null)
           {  
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Subscribe ID is mandatory')); // show error if subscriber ID is blank
               Return;
           }if(casRec.Subscriber_Id__c.length()!=9){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Subscriber ID Should be 9 characters long.')); // show error if subscriber id length is not equals to 9 digit
           }else{ 
                
                MSI_MemberSummaryRequest request = new MSI_MemberSummaryRequest();
                request.subscriberId = casRec.Subscriber_Id__c; // setting up subscriber id in request
                MSI_MemberService.isInitialized = true; // intiallizing http call request to true through this variable 
              //  response =  MSI_MemberService.getMemberDetails(request); // making call to external system with subscriber id.
                casRec.M_First_Name__c        = '';
                casRec.M_Last_Name__c         = '';
                casRec.MemberContrivedKey__c  = '';
                casRec.M_Relationship__c      = '';
                casRec.M_Street__c            = '';
                casRec.M_State__c             = '';
                casRec.M_City__c              = '';
                casRec.M_ID__c                = '';
                casRec.M_Zip_Code__c          = '';
                casRec.M_Phone__c             = '';
                casRec.M_Date_of_birth__c     = null;
                casRec.M_Age__c               = 0.0;
           if(test.isRunningTest()){
                MSI_MemberSummaryResponse res = new MSI_MemberSummaryResponse(request);
                MSI_MemberSummaryResponse.Eligibility resElg= new MSI_MemberSummaryResponse.Eligibility();
                MSI_MemberSummaryResponse.Member resMem=  new MSI_MemberSummaryResponse.Member();
                MSI_MemberSummaryResponse.Subscriber resSubs=  new MSI_MemberSummaryResponse.Subscriber();    
                    res.status = 'Sucess';
                    res.statusCode='Sucess';
                    res.statusDescription ='sucess';
                    resSubs.subscriberID ='678643765';
                    resSubs.subscriberContrivedKey='TEst';
                    resSubs.groupID='3438';
                    resSubs.groupName='Test';
                    resSubs.groupContrivedKey='test';
                    resSubs.subscriberLastName ='test';
                    resSubs.subscriberFirstName ='test';
                    resSubs.subscriberStreetAddress1='test';
                    resSubs.subscriberStreetAddress2='test';
                    resSubs.subscriberStreetAddress3='test'; 
                    resSubs.subscriberCity ='test';
                    resSubs.subscriberState='test';
                    resSubs.subscriberZip ='test';
                    resSubs.subOrgEffectiveDate ='3/4/2090';
                    resSubs.subEligibilityIndicator ='Y';
                    resSubs.subOriginalSubscriberID='';
                    resMem.firstName ='Test';
                    resMem.lastname='Test';
                    resMem.memberSuffix ='05';
                    resMem.relationshipCode ='04'; // Enum 01-09
                    resMem.relationshipCodeDesc='test';
                    resMem.relationship ='M';  // Enum M,W,D,S etc.
                    resMem.relationshipDescription ='test';
                    resMem.memberID ='test';
                    resMem.memberContrivedKey ='test';
                    resMem.dateOfBirth ='12/21/2001';
                    resMem.streetAddress1 ='test';
                    resMem.streetAddress2 ='test';
                    resMem.streetAddress3 ='test';
                    resMem.city='test';
                    resMem.state ='test';
                    resMem.zipCode ='test';
                    resMem.phone ='1232342332';
                    resElg.effectiveDate ='2/4/2013';
                    resElg.terminationDate ='2/4/3017';
                    resElg.seqDate ='2/4/2013';
                    resElg.typex  ='test';
                    resElg.typeDescription ='test';
                    resElg.productCategory ='test';
                    resElg.productCategoryDescription ='test';
                    resElg.productDesc ='test';
                    resElg.productID ='34314314';
                    resElg.classId ='243';
                    resElg.classplanId ='243';
                    resElg.planDescription  ='243';
                    resElg.familyID ='243';
                    resElg.reasonCode ='243';
                    resElg.classId ='243';
                    resMem.flatEligibilityMap.put(243,resElg);
                    resSubs.memberDetailsMap.put('test',resMem); 
                    res.subscriberByGroupMap.put('3438',resSubs);
                   //res.addMemberDetails(resMem);
                    response=res ;
               }else{
                response =  MSI_MemberService.getMemberDetails(request);
                system.debug('***response ****'+response );
               }
                system.debug('********* '+response);
                   
                
                // setting up a picklist option for group table if integration respone is not an error
                if(response.status != 'REMOTE_ERROR'){
                    if(response.subscriberByGroupMap.size() > 0){
                     isGroup = true;
                    } 
                    system.debug('***isGroup ****'+isGroup );
                    lstSubscriber.addAll(response.subscriberByGroupMap.values());
                    GroupOption = new list<selectOption>();
                    GroupOption.add(new SelectOption('None','-- None --'));
                    for(MSI_MemberSummaryResponse.Subscriber subs:response.subscriberByGroupMap.values())
                    {               
                          string grpPickVal = subs.GroupID+'-'+subs.groupName +' - '+subs.groupContrivedKey;
                        GroupOption.add(new SelectOption(subs.GroupID,grpPickVal));
                        system.debug('***GroupOption****'+GroupOption);
                    }
                  }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning, response.statusDescription));
                }
            
          }
    }
    //method to generate member picklist options
    public void memberpicklst(){
    system.debug('***232selectGroup  ****'+selectGroup);
    system.debug('***GroupOption****'+response.subscriberByGroupMap);
    // setting up a picklist option for member picklist if when group is selected
        if(selectGroup  !='None'){
            if(response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.size() > 0){
                     isTable = true;
            }
                    lstWrap = new list<selectOption>();
                    lstWrap.add(new SelectOption('None','-- None --'));
                    for(MSI_MemberSummaryResponse.Member member:response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.values())  
                        if(member.memberID!=null ){             
                    system.debug('Member id---->'+member.memberID);                  {               
                          string memPickVal = member.memberID+' '+member.firstName+' - '+member.lastName + '-'+ ' - '+member.relationship +' - ' + '0'+ member.memberSuffix;
                        lstWrap.add(new SelectOption(member.memberID,memPickVal));
                      } 
                    }
                     system.debug('***lstWrap****'+lstWrap);
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Select Valid Group'));
        }
    }
    
    // method to generate eligibility table 
    public void setEligibility(){
        isEligibilityTable = true;   
        getEligibiltyTable();
            //setting up member fields from integration response values
        if(selectMember!=null && selectMember!='' && selectmember != 'None'){
          
          
            casRec.M_First_Name__c            = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).firstName:'';
            casRec.M_Last_Name__c             = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).lastName :'';
            
           
            String Dstr   =  response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).dateOfBirth;
            list <string> dstrlist = new list<string>();
            
            //calculating age from date of birth field of member
            if(dstr != '' && dstr != Null){
                dstrlist = dstr.split(' ');
                casRec.M_Date_of_birth__c = date.parse(dstrlist[0]);
                casRec.M_Age__c = (casRec.M_Date_of_birth__c.monthsBetween(system.today()))/12;
            }
            
                   
            casRec.MemberContrivedKey__c      = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).memberContrivedKey :'';
            casRec.M_Relationship__c          = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?'0'+response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).memberSuffix :'';
            casRec.M_Street__c                = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).streetAddress1 :'';
            casRec.M_State__c                 = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).state :'';
            casRec.M_City__c                  = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).city:'';
            casRec.M_ID__c                    = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).memberID:'';
            casRec.M_Zip_Code__c              = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).zipCode:'';
            casRec.M_Phone__c                 = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).Phone:'';           
            
            
        
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Select Valid Member'));
        }
    }
    
    public void assignEligibility(){
        
        if(selectMember!='None' ){
            isEligibilityTable = False; // setting up boolean variable to false to hide eligibility table on page
            //AO changes begin 01/15/2017
            //setting up eligibility fields from integration response values
            casRec.E_Product_Category__c=response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.get(planid).productCategory  :'';
            casRec.E_description__c     = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.get(planid).memProcessEligIndDesc :'';
            casRec.E_Effective_date__c  = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?date.parse(response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.get(planid).effectiveDate):NULL;
            casRec.E_Product__c         = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.get(planid).productCategoryDescription:'';
            casRec.E_Plan_ID__c         = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.get(planid).classPlanID :'';
            casRec.E_Plan_Description__c= response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.get(planid).planDescription :'';
            
            list <String> strlist = New list<string>();
           
           
           string newstr = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.get(planid).terminationDate;
           //Setting up the formatting of termination date field comming  in integration response
            if (newstr != '' && newstr != Null){
                strlist = newstr.split('/');
                if (integer.valueof((strlist[2]))>2999){
                Date newDate = date.newInstance(2999, integer.valueof(strlist[0]), integer.valueof(strlist[1]));
                casRec.E_Termination_date__c  = newDate;
                }
                else{
                casRec.E_Termination_date__c  = response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containsKey(selectMember)?date.parse(response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.get(planid).terminationDate):NULL;
                 }
              }
              
        }else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Select Valid Eligibility'));
        }
       
            }
    
    public void getEligibiltyTable(){
        lstEligibility =  new list<MSI_MemberSummaryResponse.Eligibility>();
      //  memberpicklst();
       
          system.debug('response.selectMember***'+selectMember);      
       system.debug('----memberdetails map values-----' + response.subscriberByGroupMap.get(selectGroup));
       
      if(response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.containskey(selectMember)) {
                  

       if(response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.size() > 0){
          isEligibilityTable = true;
          system.debug('---------Flat Elig Map::' + response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.values());
          system.debug('---------Flat Elig Map size:::' + response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.size());

              system.debug('+++++selectedmem map values ---' +response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember));
              lstEligibility.addAll(response.subscriberByGroupMap.get(selectGroup).memberDetailsMap.get(selectMember).flatEligibilityMap.values());
             
          system.debug('+++++ELIGIBILITY TABLE ---' +lstEligibility); 
        
          }
       }
       else{
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Insufficiant Information Available'));
       }
    }
    // AO CHange end 01/15/2017
    // method to redirect case based on record type
    public PageReference getRedir() {
        // get sobject id prefix
        String prefix = Schema.getGlobalDescribe().get('AIA_Benefit_Design__c').getDescribe().getKeyPrefix();
        string idVal = null;
        String KeyVal = null;
        Map<String, String> params = ApexPages.currentPage().getParameters();
            for (String key : params.keySet()) {
                system.debug('params map --- key---'+key+'--value--'+params.get(key));
                  if (key.startsWith('CF') && key.endsWith('lkid')) { // to get the id of the field of the look up field dynamically from the url
                        String val = params.get(key);
                        if (val.startsWith(prefix)) {
                          idVal = key;                          // key refrences the object's field id
                          KeyVal = idval.substring(0,idVal.length()-5); // this references the objects field name
                  break;
            }
          }
        }


        //PageReference newPage;
        id accId = ApexPages.currentPage().getParameters().get('def_account_id'); // get account id
        id entId = ApexPages.currentPage().getParameters().get('def_entitlement_id'); // get Entitlement id
        id conId = ApexPages.currentPage().getParameters().get('def_contact_id'); // get Contact id
        
        string BDname = ApexPages.currentPage().getParameters().get(keyval); // get benifit design name
        id BDId = ApexPages.currentPage().getParameters().get(idVal); // get benifit design id
        system.debug('BDname==='+BDName);
        system.debug('BDId==='+BDid);

        id RecType = ApexPages.currentPage().getParameters().get('RecordType'); // get record type id
        
        String RecTypeName ='';
            if(RecType != null){
            
            // get recortype developer name
                  RecTypeName = [select Id, Name, DeveloperName
                                         from RecordType
                                         where Id = :RecType
                                         and SobjectType = 'Case'].DeveloperName ;
            }
         System.debug('recordtype name'+ RectypeName);
        
        //id MembRectypeId = querybase.getRecordtypeId('Case', 'SBU_Member_Case');
        
        if (RecTypeName == 'SBU_Member_Case' ) { // if record type is of member type show custom vf page           
           
           
               return null;
         
           
        }
        else 
        {// cover the page redirection of case when record type is other than member type
            
             pageReference nextPage = new pageReference('/500/e?nooverride=1');
             nextPage.getParameters().put('RecordType',RecType);
             
             // setting parameter when account id is available
             if(accId!=null)
             {
                 
                 nextPage.getParameters().put('def_account_id',accId);
                 
                 if(entId==null && conid==null)
                 {
                 
                     nextPage.getParameters().put('retURL',accid);
                 }
                 
             }
             
             
              // setting parameter when entitlement id is available
             if(entId!=null)
             {
             
                 nextPage.getParameters().put('def_entitlement_id',entId);
                 
                 if(entId==null)
                 {
                     nextPage.getParameters().put('retURL',entid);
                 
                 }
                 
            }
            
            // setting parameter when contact id is available
             if(conId!=null){
             
                 nextPage.getParameters().put('def_contact_id',conid);
                 nextPage.getParameters().put('retURL',conid);
                 
             }
            system.debug('BDid--'+BDid);
             if(BDid!=null){
             System.debug('benifit design field id '+ idVal); 
            System.debug('benifit design field name '+ keyVal);      

                 nextPage.getParameters().put(keyval,Bdname);
                 nextPage.getParameters().put(idVal,Bdid);
                 nextPage.getParameters().put('retURL',Bdid);
                 
             }
             
             nextPage.setRedirect(true);
            
            return nextPage;
            
        }
    }    
}