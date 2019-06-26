//=========================================================================================
//     Date: 02/04/2015
//Developer: Tom Barrett
//  Purpose: This class clears all exsting rankings and then begins setting the new rankings
//           by reading the Enrollment__c object for the current year's January month.
//           For example, Rpt_Dt__c = '201401'.  This code performs several aggregate queries
//           on Contract and Group counts. These values are stored in maps.
//           One map is used to hold the account (Ranking and AG, GP, FSP) updates and another 
//           for the contacts (SB) and eventually stored at the Account and Contact objects
//           respectively.
//           This code should be executed only once a year after the January enrollment data
//           is loaded but before February data load.  
//           However, if it was executed in any other month it would still gather
//           the January data of the current calendar year so it is not harpful if it is 
//           executed multiple times just that the users expect to see the data before the 
//           February data load.
//
//    Usage: Enrollment_SetRanking sr = new Enrollment_SetRanking();
//          
//=========================================================================================
//                                 Update History
// Date       Developer        Tag    Description
//=========================================================================================
// 03/26/2016 Tom Barrett             Made changes to handle a new custom setting field that will allow for 
//                                    muliple email addresses to be entered dynamically without changing code  
// 03/13/2017 Tom Barrett      TPB    Made significant changes where code was reading the Enrollment__c
//                                    object to get the latest Rpt_Dt__c date value.
//                                    The replacement is to read the Enrollent_Import_2_50__c object instead. 
// 04/13/2017 Rajesh Pennam    T01    Updated the class with @isvisible                  
// 09/05/2017 Arshia Gulati    T02    Include Ranking Updates for new Entity Type - PDB   
//=========================================================================================

public class Enrollment_SetRanking {
    private Map<id, Account> AccMap = new Map<id, Account>();    
    private Map<id, Contact> ConMap = new Map<id, Contact>();
    private String BeginYear = '';
    private Static Final integer qLimit = 50;
    private Static Final String rt_2_50 = '2-50';
    private String EmailSubject = 'Enrollment_SetRanking Completed';
    private String EmailBody = 'The Enrollment_SetRanking process completed without errors; therefore, you should be able to contact the appropriate group informing them that Ranking is ready for the new year!';
    
    {        
        this.BeginYear = GetBeginYear();
        Savepoint sp = Database.setSavepoint();  
        ClearAccountRankings();     
        ClearContactRankings();
        SetAG();
        SetGP();
        SetFSP();
        SetSB();
        SetPDB(); // T02 - Set Ranking for new Entity Type - PDB
        System.debug('AccMap.size: ' + AccMap.size());
        System.debug('ConMap.size: ' + ConMap.size());
                
        /* DML Updates for Accounts and Contacts */
        try {
            Database.Update(AccMap.values());
			Database.Update(ConMap.values());
            
        } catch ( System.DmlException e ) {  
            Database.rollback(sp);
            System.debug(LoggingLevel.ERROR, 'DML Exception in Enrollment_SetRanking: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
            EmailSubject = 'DML Exception in Enrollment_SetRanking: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage();
            EmailBody = EmailSubject;
        } catch ( System.Exception e ) {
            Database.rollback(sp);
            System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_SetRanking: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());
            EmailSubject = 'Exception in Enrollment_SetRanking: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage();
            EmailBody = EmailSubject;
        } finally {
            SendEmail();
            PostToChatter(EmailBody);           
        }
    }
    
    
    /***************************
     * BEGIN CLEARING RANKINGS *
     ***************************/      
    @testVisible    //T01
    private void ClearAccountRankings() {
        List<Account> acc = [ SELECT AG_Contracts_for_Year__c, AG_Groups_for_Year__c, AG_Rank__c, FSP_Contracts_for_year__c,
                                     FSP_Groups_for_Year__c,GP_Contracts_for_Year__c,GP_Groups_for_Year__c,PDB_Contracts_for_Year__c,PDB_Groups_for_Year__c  // T02 - Added new PDB fields 
                              FROM Account 
                              WHERE (AG_Contracts_for_Year__c != NULL OR AG_Groups_for_Year__c != NULL OR AG_Rank__c != NULL OR
                                    FSP_Contracts_for_year__c != NULL OR FSP_Groups_for_Year__c != NULL OR
                                    GP_Contracts_for_Year__c != NULL OR GP_Groups_for_Year__c != NULL OR
                                    PDB_Contracts_for_Year__c != NULL OR PDB_Groups_for_Year__c != NULL) AND    //T02 - Added PDB conditions
                                    RecordType.Name = :rt_2_50 ];
        for( Account a : acc ) {
            a.AG_Contracts_for_Year__c = NULL;
            a.AG_Groups_for_Year__c = NULL;
            a.AG_Rank__c = NULL;
            a.FSP_Contracts_for_year__c = NULL;
            a.FSP_Groups_for_Year__c = NULL;
            a.GP_Contracts_for_Year__c = NULL;
            a.GP_Groups_for_Year__c = NULL;
        //Start-T02
            a.PDB_Contracts_for_year__c = NULL;
            a.PDB_Groups_for_Year__c = NULL;
         //End-T02
        }
        Database.update(acc);  
        System.debug('Accounts Cleared: ' + acc.size());
    }
    
    @testVisible //T01
    private void ClearContactRankings() {
        List<Contact> con = [ SELECT SB_Rank__c, Contracts_for_Year__c, Groups_for_Year__c 
                              FROM Contact 
                              WHERE (SB_Rank__C != NULL OR Contracts_for_Year__c != NULL OR Groups_for_Year__c != NULL) AND RecordType.Name = :rt_2_50 ];
        for( Contact c : con ) {            
            c.SB_Rank__c = NULL;
            c.Contracts_for_Year__c = NULL;
            c.Groups_for_Year__c = NULL;
        }
        Database.update(con);
        System.debug('Contacts Cleared: ' + con.size());
    }
    /***************************
     * END CLEARING RANKINGS *
     ***************************/    
        
    
    /********************
     * START AG PROCESS *
     ********************/
    
    /* Stores the AG Ranking and AG Contracts in a map */
    @testVisible //T01
    private void SetAG() { 
        Integer Rank = 1;         
        for( AggregateResult q: [ SELECT AG__c, SUM(Contracts__c) TotCon, SUM(Groups_Medical__c) TotGrp
                                  FROM Enrollment__c
                                  WHERE Rpt_Dt__c = :this.BeginYear AND Processed_Type__c = 'M' AND AG__c != NULL AND Status__c = 'Active' AND RecordType.Name = :rt_2_50
                                  GROUP BY AG__c
                                  ORDER BY SUM(Contracts__c) DESC
                                  LIMIT :qLimit ] ) {
            
            Account AccRec = new Account();  
            AccRec.Id = (id)q.get('AG__c'); 
            AccRec.AG_Rank__c = Rank;
            AccRec.AG_Contracts_For_Year__c = (Decimal)q.get('TotCon');
            AccRec.AG_Groups_for_Year__c = (Decimal)q.get('TotGrp');
            AccMap.put(AccRec.id, AccRec); 
            Rank++;                  
        }
    }  
    /******************
     * END AG PROCESS *
     ******************/

/***********************************************************************************************************/   
    
    /********************
     * START GP PROCESS *
     ********************/ 
    /* Stores GP Contracts for the year in a map */
    @testVisible //T01
    private void SetGP() {              
        for( AggregateResult q: [ SELECT GP__c, SUM(Contracts__c) TotCon, SUM(Groups_Medical__c) TotGrp
                                  FROM Enrollment__c
                                  WHERE Rpt_Dt__c = :this.BeginYear AND Processed_Type__c = 'M' AND GP__c != NULL AND Status__c = 'Active' AND RecordType.Name = :rt_2_50
                                  GROUP BY GP__c
                                  ORDER BY SUM(Contracts__c) DESC
                                  LIMIT :qLimit ] ) {
            
            Account AccRec = new Account();
            AccRec.Id = (id)q.get('GP__c');                                       
            AccRec.GP_Contracts_For_Year__c = (Decimal)q.get('TotCon');
            AccRec.GP_Groups_for_Year__c = (Decimal)q.get('TotGrp');                                      
            Account accTemp = new Account();
            accTemp = AccMap.get(AccRec.Id);
            if ( accTemp == NULL ) {              
                // ok we didn't have a matching account as AG so we can add the AG record
                AccMap.put(AccRec.id, AccRec); 
            } else {
                // Ok this account already touched from previous method(s) above so lets update it
                AccTemp.GP_Contracts_For_Year__c = (Decimal)q.get('TotCon');
                AccTemp.GP_Groups_For_Year__c = (Decimal)q.get('TotGrp');
                AccMap.put(AccRec.id, AccTemp);                
            }                
        }
    }
    /******************
     * END GP PROCESS *
     ******************/        
     
 /****************************************************************************************************/ 
    
    /*********************
     * START FSP UPDATES *
     *********************/ 
    /* Stores GP Contracts for the year in a map */
    @testVisible //T01
    private void SetFSP() {          
        for( AggregateResult q: [ SELECT FSP__c, SUM(Contracts__c) TotCon, SUM(Groups_Medical__c) TotGrp
                                  FROM Enrollment__c
                                  WHERE Rpt_Dt__c = :this.BeginYear AND Processed_Type__c = 'M' AND FSP__c != NULL AND Status__c = 'Active' AND RecordType.Name = :rt_2_50
                                  GROUP BY FSP__c
                                  ORDER BY SUM(Contracts__c) DESC
                                  LIMIT :qLimit ] ) {
            
            Account AccRec = new Account();                             
            AccRec.Id = (id)q.get('FSP__c'); 
            AccRec.FSP_Contracts_For_Year__c = (Decimal)q.get('TotCon');
            AccRec.FSP_Groups_for_Year__c = (Decimal)q.get('TotGrp');
            Account accTemp = new Account();                                      
            accTemp = AccMap.get(AccRec.Id);
            if ( accTemp == NULL ) {
                // ok we didn't have a matching account as AG so we can add the AG record
                AccMap.put(AccRec.id, AccRec); 
            } else {
                // Ok this account already touched from previous method(s) above so lets update it
                AccTemp.FSP_Contracts_For_Year__c = (Decimal)q.get('TotCon');
                AccTemp.FSP_Groups_For_Year__c = (Decimal)q.get('TotGrp');
                AccMap.put(AccRec.id, AccTemp);                
            }                
        }
    } 
    /*******************
     * END FSP PROCESS *
     *******************/    

 /****************************************************************************************************/ 
    
    /********************
     * START SB PROCESS *
     ********************/ 
    /* Stores the SB Ranking and SB Contracts in a map */
    @testVisible //T01
    private void SetSB() { 
        Integer Rank = 1;
        for( AggregateResult q: [ SELECT SB__c, SUM(Contracts__c) TotCon, SUM(Groups_Medical__c) TotGrp
                                  FROM Enrollment__c
                                  WHERE Rpt_Dt__c = :this.BeginYear AND Processed_Type__c = 'M' AND SB__c != NULL AND Status__c = 'Active' AND RecordType.Name = :rt_2_50
                                  GROUP BY SB__c
                                  ORDER BY SUM(Contracts__c) DESC
                                  LIMIT :qLimit ] ) {
            
            Contact ConRec = new Contact();                             
            ConRec.Id = (id)q.get('SB__c'); 
            ConRec.SB_Rank__c = Rank;
            ConRec.Contracts_For_Year__c = (Decimal)q.get('TotCon');
            ConRec.Groups_For_YEar__c = (Decimal)q.get('TotGrp');
            ConMap.put(ConRec.id, ConRec); 
            Rank++;               
        }
    }
    /******************
     * END SB PROCESS *
     ******************/       
  
   /****************************************************************************************************/ 
    
    //Start - T02
    /*********************
     * START PDB UPDATES *
     *********************/ 
    /* Stores PDB Contracts for the year in a map */
    @testVisible //T01
    private void SetPDB() {   
        Integer pdbRank = 1;  
        System.Debug('beginyear: ' + this.BeginYear);                                
        for( AggregateResult q: [ SELECT PDB__c, SUM(Contracts__c) TotCon, SUM(Groups_Medical__c) TotGrp
                                  FROM Enrollment__c
                                  WHERE Rpt_Dt__c = :this.BeginYear AND Processed_Type__c = 'M' AND PDB__c != NULL AND Status__c = 'Active' AND RecordType.Name = :rt_2_50
                                  GROUP BY PDB__c
                                  ORDER BY SUM(Contracts__c) DESC
                                  LIMIT :qLimit ] ) {                
                                                
            Account AccRec = new Account();                                       
            AccRec.Id = (id)q.get('PDB__c'); 
            AccRec.PDB_Rank__c = pdbRank;
            AccRec.PDB_Contracts_For_Year__c = (Decimal)q.get('TotCon');
            AccRec.PDB_Groups_for_Year__c = (Decimal)q.get('TotGrp');                                      
            Account accTemp = new Account();                                       
            accTemp = AccMap.get(AccRec.Id);
            if ( accTemp == NULL ) {
                // ok we didn't have a matching account as AG so we can add the PDB record
                AccMap.put(AccRec.id, AccRec); 
            } else {
                // Ok this account already touched from previous method(s) above so lets update it
                AccTemp.PDB_Rank__c = pdbRank;
                AccTemp.PDB_Contracts_For_Year__c = (Decimal)q.get('TotCon');
                AccTemp.PDB_Groups_For_Year__c = (Decimal)q.get('TotGrp');
                AccMap.put(AccRec.id, AccTemp);                
            } 
            pdbRank++;            
        }
    } 
    /*******************
     * END PDB PROCESS *
     *******************/    
    //End - T02
    
    //BEGIN DEPRECATED TPB 03/13/2017  
    //REPLACED By Method Below  
    /*****************************************************
     * Gets the latest Rpt_Dt__c value and adjust so that
     * it returns 'yyyy01' (January).
     ****************************************************/
    /*
    private String GetBeginYear() {
        String BeginYear = ''; 
        BeginYear = [ SELECT Rpt_Dt__c 
                      FROM Enrollment__c 
                      WHERE RecordType.Name = :rt_2_50
                      ORDER BY Rpt_Dt__c DESC LIMIT 1 ].Rpt_Dt__c; 
        // Replace the end month with '01' even if it already is '01' this way we don't need an if statement
        BeginYear = BeginYear.Left(4) + '01';
        System.debug('GetBeginYear.RetVal: ' +  BeginYear);  
        return BeginYear;    
    }    
    */ 
    //END DEPRECATED TPB 03/13/2017 
     
    /*************************************************************
     * Gets the Rpt_Dt__c value from the Enrollment_Import_2_50__c 
     * object and adjust so that it returns 'yyyy01' (January).
     *************************************************************/
    @testVisible //T01
    private String GetBeginYear() {
        String BeginYear = ''; 
        BeginYear = Enrollment_QueryBase.GetLatestEnrlRunDt2_50();
        // Replace the end month with '01' even if it already is '01' this way we don't need an if statement
        BeginYear = BeginYear.Left(4) + '01';     
        System.debug('GetBeginYear.RetVal: ' +  BeginYear);  
        return BeginYear;
    } 

    /*****************************************************
     * Email the SFDCSupport Team
     ****************************************************/    
    @testVisible //T01
    private void SendEmail() {
        Utils.EmailUtil email = new Utils.EmailUtil();
        //email.toAddresses(new List<String>{'sfdcTeam@carefirst.com'});
        
        // BEGIN CHANGE TPB 03/26/2016
        //email.toAddresses(new List<String>{UserInfo.getUserEmail()});
        DynamicCodeDataStore__c cs = DynamicCodeDataStore__c.getInstance('EmailSupportTeams');        
        String[] toAddresses = cs.Text_255__c.Split(',');      
        email.toAddresses(toAddresses);
        
        // END CHANGE TPB 03/26/2016
        
        email.subject(EmailSubject);
        email.replyTo('sfdcTeam@carefirst.com');
        email.htmlBody(EmailBody);
        email.sendEmail();          
    }  
    
    /*****************************************************
     * Post to the Chatter SFDC Support Group
     ****************************************************/   
   // @TestVisible //T01
    private void PostToChatter(String EmailBody) {
        String GrpName = 'SFDC Processes';        
            GrpName = 'SFDC ProcessesX';            
        
        try {
            Id ParentId = [ SELECT Id 
                            FROM CollaborationGroup
                            WHERE Name = :GrpName LIMIT 1 ].Id;   

            FeedItem fi = new FeedItem();
            fi.Title = 'Enrollment_SetRanking';
            fi.ParentId = ParentId;
            fi.Body = EmailBody;
            insert fi; 
        } catch ( System.Exception e ) {
            System.debug(LoggingLevel.ERROR, 'Exception in Enrollment_SetRanking.PostToChatter: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage());    
        }
    }
}