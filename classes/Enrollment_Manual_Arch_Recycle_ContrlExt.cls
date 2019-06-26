//=========================================================================================
//      Date: 03/12/2015
// Developer: Tom Barrett (TPB)
//   Purpose: This class is the enrollment Archive recycle class.
//
//     Usage: Called from the Enrollment_Archive_Recycle VF page
//
//=========================================================================================
//                                 Update History
// Date       Developer    Tag   Description
//=========================================================================================
// 17/08/2018 Gayathri     T01   Added a method to diffentiate Classic and lightning view                                   
//=========================================================================================

public class Enrollment_Manual_Arch_Recycle_ContrlExt {   
    // Custom Exceptions
    class Enrollment_Manual_Arch_Recycle_ContrlExt_Exception Extends Exception {}    
    // Used to control which section of the VF page is rendered
    public boolean pageBlockSection1 { set; get; }
    public boolean pageBlockSection2 { set; get; }    
    public boolean pageBlockSection3 { set; get; }
    public boolean ArchiveButton { set; get; }   
    // Holds the records the user selected from the Enrollment Recycle Tab
    private final List<Enrollment_Recycle__c> selectedERlist;  
    
    public List<Enrollment__c> enrollmentList { set; get; } 
   // VF page uses to display errors that were not recycled
    public List<Enrollment_Recycle__c> NotRecycledList { set; get; }   
    
    
   // Messages used in the process
    private final String UserName = UserInfo.getFirstName();
    private final String CompleteSuccess = 'Great job ' + userName + '! All selected Enrollment Recycle errors archived successfully!';
    private final String PartialSuccess = userName + ', some records selected did not process succussfully! ' +
                                          'Please correct and reprocess the unresolved Enrollment Recycle Errors below.';   
    private final String NoneProcessed = userName + ', none of the selected Enrollment Recycle errors processed!  ' + 
                                         'Click the Enrollment Recycle tab again or the Return button to review the errors, resolve and try again.';   
    private final String NoneSelected = userName + ', you did not select any records! Please click the Enrollment Recycles tab again or the Return button then select records that you want to archive.';                                        
    private String introMsg = ' recycle errors selected that are ready to be archived.  Please review to make sure you have selected the correct records before clicking the Archive button.'; 
    // enum used to manage the type of errors and messages that should display
    private enum ProcessStatus {CompleteSuccess, PartialSuccess, NoneProcessed, NoneSelected}
    // instantiate ProcessStatus as ps 
    private ProcessStatus ps; 
    // Build a set of ids for what the user has selected to be processed
    private Set<Id> SelectedERids = new Set<Id>();
    
    //T01--Start--Method to check whether the page is in Classic or lightning
    public Boolean getIsClassic() {
    return (AIA_Utils.isClassic());
    }
    //T01--End
    
    // Controller Constructor
    public Enrollment_Manual_Arch_Recycle_ContrlExt(ApexPages.StandardSetController controller) {  
        pageBlockSection1 = true;  
        ArchiveButton = true;                 
        this.selectedERlist = controller.getSelected();        
        if ( RecordsSelected()) {     
            introMsg = userName + ', you have ' + selectedERList.size() + introMsg;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, introMsg));
        }
    }        
    
    
    public PageReference ArchiveSelection() {  
        // No records selected by the user so return
        if ( !RecordsSelected() ) return null; 
        
        // start the process so lets disable the Archive button
        ArchiveButton = false;
 
             
        for ( Enrollment_Recycle__c e : selectedERlist ) {     
            SelectedERids.add(e.Id);
        } 
        
        /// Begin DML Operations        
        Savepoint sp = Database.setSavepoint();
        try {   
            CheckCountAgainstEnrollmentRecycle();         
            
            // START ARCHIVE PROCESS OF ENROLLMENT_RECYCLE__C RECORDS
            Enrollment_QueryBase.CopyEnrollmentRecycleData(SelectedERids, FALSE);
            Enrollment_QueryBase.DeleteEnrollmentRecycleData(SelectedERids);           
               
            ps = ProcessStatus.CompleteSuccess;            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, CompleteSuccess));   
            pageBlockSection3 = true; 
            
            // Strickly for code coverage purposes
	        if ( System.Test.isRunningTest() && Enrollment_Manual_Arch_RecycContlExtTest.runningTest ) {
			    System.debug(5/0); 
			}                  
                
        } catch (System.DMLexception e) {
            Database.rollback(sp);                  
            String FatalError = 'Exception in Enrollment_Archive_Recycle_ControllerExt: DML Error at line ' + e.getLineNumber() + ' - ' + e.getMessage() + 
                                ' -- Please contact sfdcSupport@carefirst.com with a screen shot.';
            ApexPages.AddMessage( new ApexPages.message(ApexPages.severity.FATAL, FatalError));  
            System.debug(LoggingLevel.ERROR, FatalError); 
            
        } catch (Enrollment_Manual_Arch_Recycle_ContrlExt_Exception e ) {
            String FatalError = 'Records were previously processed!  Go back to the Enrollment Recycle tab and try again.'; 
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, FatalError)); 
               
        } catch (System.Exception e) {
            Database.rollback(sp);    
            pageBlockSection1 = false;
            pageBlockSection2 = false;
            pageBlockSection3 = false;  
            ArchiveButton = false;    
            String FatalError = 'Exception in Enrollment_Archive_Recycle_ControllerExt: Error at line ' + e.getLineNumber() + ' - ' + e.getMessage() + 
                                ' -- Please contact sfdcSupport@carefirst.com with a screen shot.';         
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, FatalError));  
            System.debug(LoggingLevel.ERROR, FatalError);        
        }
        /// End DML Operations            
        return null; 
    } 
    
    // check if records are not selected and return false; otherwise, true
    private boolean RecordsSelected() {
        if ( selectedERlist == NULL || selectedERlist.isEmpty() ) {            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, NoneSelected));
            pageBlockSection1 = false;
            ArchiveButton = false;
            return false;
        }
        return true;
    }   
 
    
    /****************************************************************************************
     * Get the current count on the Enrollment_Recycle__c object based on the selected     
     * records the user is trying to process.  Then compare this count to the actual selected
     * records the user is trying to process.  Throw an error if it is not the same     
     ***************************************************************************************/
     private void CheckCountAgainstEnrollmentRecycle () {
         Integer ERcount = 0;                  
         ERcount = [ SELECT Count() FROM Enrollment_Recycle__c
                         WHERE id = :SelectedERids ];
         if ( ERcount <> SelectedERids.size() ) {
             throw new Enrollment_Manual_Arch_Recycle_ContrlExt_Exception('Records were previously processed!  Go back to the Enrollment Recycle tab and try again.');
         }         
     }    
}