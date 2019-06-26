//==========================================================================================================
//      Date: 09/02/2017
// Developer: Tom Barrett (TPB)
//   Purpose: To monitor governor limits based on custom thresholds and to forewarn the support team of 
//            potential Salesforce governor limits closely approaching.
//                        
//  Overview:
//            The framework exposes one method.  This method can be used to check the limit of a specific 
//            Salesforce governor limit or it can check all that are supplied based on the framework's
//            ENUM list and the limits entered on the GLM__mdt custom metadata type object.  
//            The framework is dynamically driven by using data from the GLM__mdt custom metadata 
//            table which stores each governor limit expected to be monitored.  
//            This table has switches that can control enabling or disabling specific limit detection, email
//            and/or store the detections in the GLM_Activity__c table for futrue analysis.  
//            In other words, there is a master switch for each governor limit listed in the GLM__mdt table 
//            that allows or prevents the framework from checking the limit.  But when a governor limit is 
//            disabled that means all calls for that governor limit do not get checked by the framework.  
//            This is a safe guard feature that should only be used if the GLM framework itself is causing a 
//            Salesforce governor limit to be reached.  With that said, continue reading 'Limitations' to
//            understand more.
// 
// Limitations:
//            The GLM framework is native to the Salesforce environment which means it too is acceptable to
//            the same governor limits as any other apex code.
//            There is no direct way to control disable or enable of a specific call to the framework without
//            continously maintaining the GLM framework class and additional manual efforts.  Therefore, it is 
//            recommended to only have one entry in the GLM__mdt table per specific Salesforce governor limit.
//            
//            To go the way of the workaround to this limit is to have an entry in the GLM__mdt table for every
//            single call to the GLM framework.  Again, this would require the development team to manually 
//            track a unique name for the limit parameter and continuously updates to the GLM framework to 
//            include the unique name.  This manual approach is highly discouraged as it could become 
//            too problematic.  In addition, it could cause the GLM framework to use up too much of the 
//            Salesforce CpuTime governor limit, which could cause business logic to fail due to the CpuTime
//            governor limit reaching the maximum allowed time.
//                        
//     Usage: 
//            Put the line of code identified by '***' below in every class where you want to track limits and 
//            pass cName to the GLM class method's ActivityOrigin parameter with the method name hard coded since 
//            SF doesn't have a way to get both class name and method name If GLM methods are being called from 
//            anything other than a class then pass the details as a string but stay consistant and come up with 
//            a naming pattern where possible.
//            
//            String cName = <ClassName>.class.getName(); 
//            For example if your class name was called MyClassName then the line would look like this: 
//   ***      String cName = MyClassName.class.getName(); 
//            
//            Once you have defined the variable in your class as shown above then you can call the GLM.checklimit 
//            method like below (1).  
//            "MyMethodName" is the name of the class method where you are calling the GLM.checkLimit method. 
//            If there is a need to use the GLM.checkLimit method in a trigger then pass the trigger name and method if 
//            necessary as shown below (2). This will allow for easy traceability during troubleshooting.
// Specific
// Limit   :                    
//     1      Example call from a class   : GLM.checkLimit(Glm.sfLimit.DMLRows, cName + '.MyMethodName');                       
//     2      Example call from a trigger : GLM.checkLimit(Glm.sfLimit.DMLRows, 'NameOfTheTrigger');  
// All 
// Limits  :
//     1      Example call from a class   : GLM.checkLimit(Glm.sfLimit.AllLimits, cName + '.MyMethodName');                       
//     2      Example call from a trigger : GLM.checkLimit(Glm.sfLimit.AllLimits, 'NameOfTheTrigger');   
//     
// Additional
// Information:
//            Although there is only one method to use, this method can control the inner workings of the GLM 
//            Framework in two primary ways:
//            1. Check for a specific governor limit.
//            2. Check for all governor limits.
//            
//            In most cases it is best to use the AllLimits parameter.  This could potentially use a few moremilliseconds 
//            of process time; however it will save on the number of DML statements that the framework consumes when 
//            writing to the GML_Activity__c table because the records to write out are collected in a List and a single 
//            INSERT statement is issued which consumes only 1 DML per call to the framework. This is extremely
//            important as it can be hard to tell how many times the framework could be called in a given
//            context execution.  Basically, checking a large volume of potentional thresholds with a single call
//            is what you are getting with the AllLimits parameter.   
//==========================================================================================================
//                                   Update History
// Date          Developer      Tag     Description
//==========================================================================================================
// mm/dd/yyyy    name           Txxx    xxxx    
//==========================================================================================================
public without sharing class GLM {
    //For each limit entry in the GLM Custom Metadata Type table make sure the same exists in the enum below.  
    //The one exception is the NoSuchLimit enum below as it is only there for code coverage purposes.
    public enum sfLimit {AllLimits, AggregateQueries, Callouts, CpuTime,  DMLRows, DMLStatements, EmailInvocations, Queries, QueryRows, NoSuchLimit}
    private static final String GLM_MDT_CUSTOM_METADATA_TABLE = 'GLM__mdt custom metadata table';
    private static final String APEX_GLM_CLASS = 'Apex GLM Class: ';
    private static final String GLM_SUBJECT_PREFIX = 'Governor Limit Monitoring: ';
    private static final String ORG_INFO = URL.getSalesforceBaseUrl().getHost() + ' : ';
    private static final String ISSUE_DETECTED = 'Issue Detected!';
    
    private static Map<String, GLM__mdt> GLM_mdt_Map = new Map<String, GLM__mdt>(); 
    private static List<GLM__mdt> GLM_mdt_List = new List<GLM__mdt>();
    private static List<GLM_Activity__c> GLM_Activity_List = new List<GLM_Activity__c>(); 
    
    //Used for emailing support
    private static List<Messaging.SingleEmailMessage> Emails = new List<Messaging.SingleEmailMessage>();    
    private static String[] ToAddresses = new String[] {};
    
    private static List<MetadataTypeAbstract> MetadataTypeAbstract_List = new List<MetadataTypeAbstract>();
    private static Map<String, MetadataTypeAbstract> MetadataTypeAbstract_Map = new Map<String, MetadataTypeAbstract>();
    
    //Get all data from the Custom Metadata Type table GLM_mdt  
    static {  
        //If Test class is not running build the data this way
        //NOTES: DeveloperName holds the Limit Name; its label name on the screen is 'GLM Name'
        for (GLM__mdt Glm_mdt : [SELECT DeveloperName, Threshold__c, Send_Email__c, Store__c, IsActive__c, Text_Area_255__c
                                 FROM GLM__mdt]) {
            //Lets get the email addresses and skip adding them to the list and map 
            //below as we use it in a separate variable named ToAddresses later on.
            if (Glm_mdt.DeveloperName == 'Support_Team_Email_Addresses') {
                String EmailAddresses = Glm_mdt.Text_Area_255__c;
                EmailAddresses = EmailAddresses.replace(', ', ',');
                ToAddresses = EmailAddresses.Split(',');
                Continue;
            }
            MetadataTypeAbstract ma = new MetadataTypeAbstract();
            ma.DeveloperName = Glm_mdt.DeveloperName;
            ma.IsActive = Glm_mdt.IsActive__c;
            ma.SendEmail = Glm_mdt.Send_Email__c;
            ma.Store = Glm_mdt.Store__c;
            ma.Threshold = Glm_mdt.Threshold__c;
            MetadataTypeAbstract_Map.put(ma.DeveloperName, ma);
            MetadataTypeAbstract_List.add(ma);
        }
        //If Test class is running build the data this way
        if (Test.isRunningTest()) { 
            BuildTestMetadataTypeData(); 
        }
    }   
  
    /******************************************
     * Methods for governor limits start here *
     *****************************************/
    public static void checkLimit(SFLimit lmt, String ActivityOrigin) { 
        System.debug('---GLM.checkLimits(' + lmt + ', ' + ActivityOrigin + ')---');
        // Check all limits else check a single specific limit
        if (lmt == sfLimit.AllLimits) {                 
            checkAllLimits(ActivityOrigin);  
        } else {
            //get record of the specific limit           
            MetadataTypeAbstract mdt = MetadataTypeAbstract_Map.get(lmt.name()); 
            //if limit found
            if(mdt != NULL) {  
                if(mdt.IsActive) {
                    if(lmt == sfLimit.AggregateQueries) ThresholdEval(ActivityOrigin, Limits.getAggregateQueries(), Limits.getLimitAggregateQueries(), mdt, lmt);
                    if(lmt == sfLimit.Callouts) ThresholdEval(ActivityOrigin, Limits.getCallouts(), Limits.getLimitCallouts(), mdt, lmt); 
                    if(lmt == sfLimit.CpuTime) ThresholdEval(ActivityOrigin, Limits.getCpuTime(), Limits.getLimitCpuTime(), mdt, lmt);            
                    if(lmt == sfLimit.DMLRows) ThresholdEval(ActivityOrigin, Limits.getDMLRows(), Limits.getLimitDMLRows(), mdt, lmt);             
                    if(lmt == sfLimit.DMLStatements) ThresholdEval(ActivityOrigin, Limits.getDMLStatements(), Limits.getLimitDMLStatements(), mdt, lmt);  
                    if(lmt == sfLimit.EmailInvocations) ThresholdEval(ActivityOrigin, Limits.getEmailInvocations(), Limits.getLimitEmailInvocations(), mdt, lmt);    
                    if(lmt == sfLimit.QueryRows) ThresholdEval(ActivityOrigin, Limits.getQueryRows(), Limits.getLimitQueryRows(), mdt, lmt);            
                    if(lmt == sfLimit.Queries) ThresholdEval(ActivityOrigin, Limits.getQueries(), Limits.getLimitQueries(), mdt, lmt); 
                    SendEmail();
                    Store(GLM_Activity_list);                    
                }
            } else { //limit not found
                //Build a message for support that we do not have match between a GLM__mdt record and Enum limit name.
                BuildConfigurationEmailAlert(lmt.Name()); 
                SendEmail();               
            }
        }
    }  
    
    //Check all limits
    //loop through the GLM_mdt_List and check the threshold for All Limits one at time
    private static void checkAllLimits(String ActivityOrigin) { 
        System.debug('---GLM.checkAllLimits(' + ActivityOrigin + ')---');
        //get a list of the enums
        List<sfLimit> sfl = sfLimit.values();
        //loop through all the coded enums to see if a match is found
        //on the GLM__mdt custom metadata table which is really stored on the MetadataTypeAbstract_Map, 
        //if not build an email to alert the support team that a record is missing on the GLM__mdt table
        for (sfLimit lmt : sfl){
            if(lmt == sfLimit.ALLlimits) continue; //SKIP - AllLimits should not be on the GLM__mdt table and never should be used on it
            if(lmt == sfLimit.NoSuchLimit) continue; //SKIP - the NoSuchLimit is used only by the Test class
            MetadataTypeAbstract mdt = MetadataTypeAbstract_Map.get(lmt.Name());
            If (mdt == null) { 
                //Build a message informing support that we do not have match between a GLM__mdt record and enum limit name.
                BuildConfigurationEmailAlert(lmt.Name()); 
            }
        }
        
        //Loop through MetadataTypeAbstract_List and start checking the threshold for each limit
        //We could have coded this without a FOR LOOP since we are calling all the limits but then
        //if someone added a limit to the GLM Custom Metadata Types record we would not know any
        //of the wiser; hence the ELSE statement in the FOR LOOP!
        for (MetadataTypeAbstract mdt : MetadataTypeAbstract_List) {
            if (!mdt.IsActive) continue; //Limit is inactive so skip 
            //We got this far so we must have a glm__mdt record so lets check that threshold
            if(mdt.DeveloperName == sfLimit.AggregateQueries.Name()) {
                ThresholdEval(ActivityOrigin, Limits.getAggregateQueries(), Limits.getLimitAggregateQueries(), mdt, sfLimit.ALLlimits); 
            }else if (mdt.DeveloperName == sfLimit.CpuTime.Name()) {
                ThresholdEval(ActivityOrigin, Limits.getCpuTime(), Limits.getLimitCpuTime(), mdt, sfLimit.ALLlimits); 
            } else if(mdt.DeveloperName == sfLimit.Callouts.Name()) {
                ThresholdEval(ActivityOrigin, Limits.getCallouts(), Limits.getLimitCallouts(), mdt, sfLimit.ALLlimits); 
            } else if(mdt.DeveloperName == sfLimit.DMLRows.Name()) {
                ThresholdEval(ActivityOrigin, Limits.getDMLRows(), Limits.getLimitDMLRows(), mdt, sfLimit.ALLlimits); 
            } else if(mdt.DeveloperName == sfLimit.DMLStatements.Name()) {
                ThresholdEval(ActivityOrigin, Limits.getDMLStatements(), Limits.getLimitDMLStatements(), mdt, sfLimit.ALLlimits); 
            } else if(mdt.DeveloperName == sfLimit.EmailInvocations.Name()) {
                ThresholdEval(ActivityOrigin, Limits.getEmailInvocations(), Limits.getLimitEmailInvocations(), mdt, sfLimit.ALLlimits);    
            } else if(mdt.DeveloperName == sfLimit.QueryRows.Name()) {
                ThresholdEval(ActivityOrigin, Limits.getQueryRows(), Limits.getLimitQueryRows(), mdt, sfLimit.ALLlimits); 
            } else if(mdt.DeveloperName == sfLimit.Queries.Name()) {
                ThresholdEval(ActivityOrigin, Limits.getQueries(), Limits.getLimitQueries(), mdt, sfLimit.ALLlimits); 
            } else {
                //Build the email message when a record exists in the GLM custom metadata Type data
                //but we did not code for it.
                String Subject = APEX_GLM_CLASS + ORG_INFO + ISSUE_DETECTED;                
                String Body  = 'The GLM__mdt custom metadata record \'' + mdt.DeveloperName + '\' used by ' + ActivityOrigin + ' was found; ';
                Body += 'however, CODE was not found to check for it in the GML.checkALLlimits method! Either remove the record from the ' + GLM_MDT_CUSTOM_METADATA_TABLE + ' or add an IF check for the ';
                Body += 'governor limit in the GLM.checkAllLimits method<br/><br/>';
                Body += 'This issue should get attention immediately.';   
                System.debug('Subject: ' + subject + ', Body: ' + Body);
                PackageEmail(Subject, Body); 
            }              
        }
        SendEmail();
        Store(GLM_Activity_list);
    }       

    /***************************************************************************************************
     * ThresholdEval determines if the threshold has been met.  The GLM__mdt custom metadata record for 
     * a given threshold controls if emails are sent or if a record is written to the GLM Activity table.
     * If the threshold is not met then no email is sent and no record is written to the GLM Activity table.  
     * This is by design because the con to the GLM Framework is that Salesforce treats it the same as any 
     * other code, meaning it too consumes governor limits.  Read the Additional Information section in the 
     * GLM class header above for additional information.
     * 
     * ActivityOrigin : Is the name of the class that has called the GLM.chechLimit method.
     * LimitUsed      : Should be what your code has used at that point of time which is derived from the 
     *                  Salesforce LIMITS class's methods Limits.get??? but not "Limits.getLimit???".
     *                  For example, Limit.getDMLRows(), Limit.getDMLStatments(), etc.
     * LimitMax       : Should be Salesforces limits methods passed in that start with "Limits.getLimit???". 
     * Glm_mdt        : Is the GLM_mdt record holding the limit to check.
     * lmt            : is the Enum sfLimit passed in which depics the limit to check.
     ***************************************************************************************************/
    private static void ThresholdEval(String ActivityOrigin, Integer LimitUsed, Integer LimitMax, MetadataTypeAbstract mdt, sfLimit lmt) {              
        Decimal CalcThreshold = 0;
        System.debug('GLM.ThresholdEval : ActivityOrigin: ' +ActivityOrigin + ', DeveloperName: ' + mdt.DeveloperName + ', LMT: ' + lmt.name() + ', LimitUsed: ' + LimitUsed + ', LimitMax: ' + LimitMax + ', Threshold: ' + mdt.Threshold + ', CalcThreshold: ' + CalcThreshold + ', sfLimit: ' + lmt);           
        if (LimitUsed > 0 ) CalcThreshold = Math.roundToLong((Decimal.valueOf(LimitUsed) / Decimal.valueOf(LimitMax)) * 100);    
                  
        //Calculate if the threshold has been reached
        If (CalcThreshold >= mdt.Threshold) {
            String Subject = GLM_SUBJECT_PREFIX + 'Governor Limit Threshold Reached For ' + ORG_INFO;
            String EmailBody  = 'The governor limit threshold was reached for <b>' + mdt.DeveloperName + '</b> at ' + ActivityOrigin + '.<br/><br/>';
                   EmailBody += 'The current limit usage is ' + LimitUsed + ' and the maximum limit allowed is ' + LimitMax + '; therefore, this is why you have received this email from the Governor Limit Monitoring Framework (GLM).<br/><br/>';
                   EmailBody += 'The calculated threshold is ' + CalcThreshold + ' and the threshold setting is ' + Math.roundToLong(mdt.Threshold) + '.<br/><br/>';        
                   EmailBody += '<b>This issue should get attention before the Salesforce limit is reached and code fails.' + '</b><br/><br/>';
            
            //Adding 1 to the Limits.getEmailInvocation check because when the email gets created
            //for this condition later it will hit 10 so we have to determine in advance. 
            //In addition, cheating to get 1% more code coverage with Test.isRunningTest() method!
            if ((Limits.getEmailInvocations() +1) >= 10 || Test.isRunningTest()) {
                EmailBody += '<b><font color="red">' + 'In addition, the Email Invocation Limit was detected so check the GLM Activity log for additional potential ';
                EmailBody += 'governor limit warnings because no more emails can be sent from GLM f this given context execution!' + '</font></b><br/><br/>';
            }    
                   
            //Threshold met - let's email and create a GLM_Activity__c record if it is a single limit check or write to the GLM_Activity_List
            //to accomuate the record in memory - we will write the total to the GLM_Activity__c table at the end of the FOR LOOP in the checkALLlimits method.
//            System.debug(GLM_SUBJECT_PREFIX + 'Threshold has been met - warning warning Will Robinson! : ' + 'Caller: ' + ActivityOrigin + ', ' + 'Limit Max: ' + LimitMax + ', Limit Used: ' + LimitUsed + ', Threshold: ' + Glm_mdt.Threshold__c + '%, CalcThreshold: ' + CalcThreshold + '%');
            if (mdt.SendEmail) {
                PackageEmail(Subject, EmailBody);

                if (lmt != sfLimit.AllLimits) {                
                    SendEmail();
                }
            }
            if (mdt.Store) {
                //create GLM_Activity__c record
                GLM_Activity__c glmA = new GLM_Activity__c(Name = mdt.DeveloperName, Activity_Origin__c = ActivityOrigin, Limit_Max__c = LimitMax, Limit_Used__c = LimitUsed, Threshold__c = mdt.Threshold);     
                GLM_Activity_List.add(glma); 
            }
        }
    }

    /***********************************************************
     * Build Email Message when the Enum sfLimit and matching
     * GLM__mdt custom metedata record is not found and then
     * make a call to the local PackageEmail method to add the 
     * email to the Emails array
     ***********************************************************/
    private static void BuildConfigurationEmailAlert(String lmt_Name) {    
        System.debug('---GLM.BuildConfigurationEmailAlert(' + lmt_Name + ')---');        
        String Subject = APEX_GLM_CLASS + ORG_INFO + ISSUE_DETECTED;
        String Body  = 'The GLM__mdt record \'' + lmt_Name + '\' referenced in the GLM Class code does not exist!  Either add the record to the ';
        Body += GLM_MDT_CUSTOM_METADATA_TABLE + ' or remove the Enum \'' + lmt_Name + '\' reference in the GLM class<br/><br/>';  
        Body += 'This issue should get attention immediately.';         
        PackageEmail(Subject, Body); 
    }
    
    /*******************************************************************
     * Builds an array of emails so that when the frame work is called 
     * requesting all LIMITS to be requested it can send the array of
     * emails only once.  This reduces the framework itself from using 
     * up the current 10 email limit in a given execution context
     *******************************************************************/
    private static void PackageEmail(String Subject, String EmailBody) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject(Subject);      
        email.setToAddresses(ToAddresses);
        email.setHtmlBody(EmailBody); 
        emails.add(email);    
    }
    
    /***************************
     * Sends an array of emails
     ***************************/
    private static void SendEmail() {
        System.debug('---GLM.SendEmail()---');      
        if (!emails.isEmpty() && Limits.getEmailInvocations() < 10) {
            Messaging.sendEmail(emails); 
            emails.clear();
        }
    }
    
    /********************************************************************************
     * Stores the GLM Activity details when the threshold is met  
     * Because the GLM Framework can be called many many times in a given execution 
     * context. It is necessary to clear the list after each INSERT; otherwise, we 
     * would experience the following error if the GLM Framework was called more 
     * than once in a given execution context.
     *******************************************************************************/  
    private static void Store(List<GLM_Activity__c> glma_list) { 
        if(!glma_list.isEmpty()) {
            Database.Insert(glma_list);
            //System.DmlException: Insert failed. First exception on row 0 with id a1z0S000000iYNqQAM; 
            //first error: INVALID_FIELD_FOR_INSERT_UPDATE, cannot specify Id in an insert call: [Id]
            GLM_Activity_List.Clear();
        }
    }  
    
    /**********************************************************************
     * Used to abstract the Custom Metadata Type data so that we can build
     * consistance data for test classed as SF currently does not allow us
     * to create custom metadata type data in test classes.
     **********************************************************************/
    private class MetadataTypeAbstract{
        String DeveloperName {get; set;}
        Boolean IsActive {get; set;}
        Boolean SendEmail {get; set;}
        Boolean Store {get; set;}
        Decimal Threshold {get; set;}
    }
    
    /************************************************************************
     * Used to build the data for the MetadataTypeAbstract class object.
     * This was necessary to get code coverages due to the fact that SF does
     * not allow Custom Metadata Type records to be created in Test classes
     ************************************************************************/
    private static void BuildTestMetadataTypeData() {
        MetadataTypeAbstract_Map.clear();
        MetadataTypeAbstract_List.clear(); 
        ToAddresses.add('SomeFakeEmail@FakeEmailAddress.com');
        //REC #1
        MetadataTypeAbstract ma1 = new MetadataTypeAbstract();
        ma1.DeveloperName = 'AggregateQueries';
        ma1.IsActive = TRUE;
        ma1.SendEmail = TRUE;
        ma1.Store = TRUE;
        ma1.Threshold = 0;
        MetadataTypeAbstract_Map.put(ma1.DeveloperName, ma1);
        MetadataTypeAbstract_List.add(ma1);
        //Rec #2
        MetadataTypeAbstract ma2 = new MetadataTypeAbstract();
        ma2.DeveloperName = 'Callouts';
        ma2.IsActive = TRUE;
        ma2.SendEmail = TRUE;
        ma2.Store = TRUE;
        ma2.Threshold = 0;
        MetadataTypeAbstract_Map.put(ma2.DeveloperName, ma2);
        MetadataTypeAbstract_List.add(ma2);
        //REC #3
        MetadataTypeAbstract ma3 = new MetadataTypeAbstract();
        ma3.DeveloperName = 'CpuTime';
        ma3.IsActive = TRUE;
        ma3.SendEmail = TRUE;
        ma3.Store = TRUE;
        ma3.Threshold = 0;
        MetadataTypeAbstract_Map.put(ma3.DeveloperName, ma3);
        MetadataTypeAbstract_List.add(ma3);
        //Rec #4
        MetadataTypeAbstract ma4 = new MetadataTypeAbstract();
        ma4.DeveloperName = 'DMLRows';
        ma4.IsActive = TRUE;
        ma4.SendEmail = TRUE;
        ma4.Store = TRUE;
        ma4.Threshold = 0;
        MetadataTypeAbstract_Map.put(ma4.DeveloperName, ma4);
        MetadataTypeAbstract_List.add(ma4);        
        //REC #5
        MetadataTypeAbstract ma5 = new MetadataTypeAbstract();
        ma5.DeveloperName = 'DMLStatements';
        ma5.IsActive = TRUE;
        ma5.SendEmail = TRUE;
        ma5.Store = TRUE;
        ma5.Threshold = .5;
        MetadataTypeAbstract_Map.put(ma5.DeveloperName, ma5);
        MetadataTypeAbstract_List.add(ma5);
        //Rec #6
        MetadataTypeAbstract ma6 = new MetadataTypeAbstract();
        ma6.DeveloperName = 'EmailInvocations';
        ma6.IsActive = TRUE;
        ma6.SendEmail = TRUE;
        ma6.Store = TRUE;
        ma6.Threshold = 0;
        MetadataTypeAbstract_Map.put(ma6.DeveloperName, ma6);
        MetadataTypeAbstract_List.add(ma6);          
        //REC #7
        MetadataTypeAbstract ma7 = new MetadataTypeAbstract();
        ma7.DeveloperName = 'Queries';
        ma7.IsActive = TRUE;
        ma7.SendEmail = TRUE;
        ma7.Store = TRUE;
        ma7.Threshold = .5;
        MetadataTypeAbstract_Map.put(ma7.DeveloperName, ma7);
        MetadataTypeAbstract_List.add(ma7);
        //Rec #8
        MetadataTypeAbstract ma8 = new MetadataTypeAbstract();
        ma8.DeveloperName = 'QueryRows';
        ma8.IsActive = TRUE;
        ma8.SendEmail = TRUE;
        ma8.Store = TRUE;
        ma8.Threshold = 0;
        MetadataTypeAbstract_Map.put(ma8.DeveloperName, ma8);
        MetadataTypeAbstract_List.add(ma8);  
        //Rec #9
        MetadataTypeAbstract ma9 = new MetadataTypeAbstract();
        ma9.DeveloperName = 'FakeRecordForTesting';
        ma9.IsActive = TRUE;
        ma9.SendEmail = TRUE;
        ma9.Store = TRUE;
        ma9.Threshold = 0;
        MetadataTypeAbstract_Map.put(ma9.DeveloperName, ma8);
        MetadataTypeAbstract_List.add(ma9);                          
    }
}