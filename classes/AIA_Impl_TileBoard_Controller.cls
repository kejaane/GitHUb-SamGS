/*====================================================================================================================
* Date       : 05/20/2018
* Developer  : Asif Kutagulla
* Purpose    : Controller for Visualforce component AIA_Impl_TileBoard to show list of Sub Processes associated with  
*              a process on the Implementation dashboard. This component is called from Dashboard VF page on the
*              Implementation record. Story:US463
*              This controller is also called from the visualforce component AIA_Implementation_Dashboard_Donut to
*              retrieve the percentage completion for a Process & dashboard donut colors.
*                               ========[Update History]=======
*                     -----------------------------------------------------
* Date         Developer    Tag         Description
*====================================================================================================================
* 05/20/2018 | Asif K     |     | Initial version
* 06/07/2018 | Raviteja V | T01 | Changes for adding Process completion percentage. 
* 08/17/2018 | Arshia G   | T02 | Updated for Subprocess color change US3856
*====================================================================================================================*/
public without sharing class AIA_Impl_TileBoard_Controller {
    
    public list<Sub_Process__c> lstSubProcesses {get; set;}
    public list<String> lstTileColors {get; set;}

    //T01 - start
    public String donutPercentage {get; set;}
    public list<String> lstName {get; set;}
    public list<String> lstTileColorsforDonut {get; set;}
    public String lstNames {get; set;}
    public String lstTileColorsforDonuts {get; set;}
    //T01 - end
    public Integer ShowMoreLinkSize {get; set;}
    public boolean displayShowMoreLink {get; set;}
    public boolean displayTaskListModal {get; set;}
    public String clickedSubProcessID {get; set;}

    public Integer FullTaskListSize {get; set;}
    public Integer PendingTaskListSize {get; set;}
    
    static final Integer DEFAULT_DISPLAY_SIZE = 5;  
    static final Integer FULL_DISPLAY_SIZE = 50000; /**Assuming full display size will not exceed 50000 records**/
    
    /** Variables for setting the SubProcess Tile colors on the Dashboard UI **/
    static final String SUBPROC_CMPLTE_CLR = '#98fb98';
    static final String SUBPROC_NOT_REQ_CLR = '#98fb98';
    static final String SUBPROC_IN_PROG_CLR = '#DCF1F8';
    static final String SUBPROC_BREACH_CLR = '#FBBA6B';
    public map<String,String> subProcTileColors_Status {get; set;}

    /**Code for re-assigning the value to attribute-Start**/
            /** When a visualforce component is called from visualforce page and an assignTo attribute is used: **
             ** the constructor of component is evaluated before assignTo attribute & getters & setters of the  **
             ** component. so the value passed from visualforce page using assignTo attribute is always null,   **
             ** if data population methods are called from component constructor. To avoid this issue, calling  **
             ** initial data population methods inside the setter attribute of assignTo variable.               **/
    public Boolean getterSetterFlag = true;
    public String processID; 
    public void setprocessID (String s) {
        processID = s;
        if(getterSetterFlag) {
            system.debug(processID); //objectName will not be null here
            getterSetterFlag = false;
            
            populateSubProcTileColors();
            
            lstSubProcesses = new list<Sub_Process__c>();
            displayShowMoreLink = False;
            displayTaskListModal = False;
            ShowMoreLinkSize = 0;
            InitializeColorList();
            getListOfTiles(DEFAULT_DISPLAY_SIZE);
        }
    }
    public String getprocessID() {
        return processID;
    }
    /**Code for re-assigning the value to attribute-End**/
    
    /** Constructor **/
    public AIA_Impl_TileBoard_Controller()
    {
        system.debug('processID in AIA_Impl_TileBoard_Controller normal constructor---'+processID);
    }
    
    /** Method called when dashboard page loads & this shows the Sub Processes associated a Process **/
    public void getListOfTiles(Integer SubProcListSize)
    {
        list<Sub_Process__c> fullSubProcList = new list<Sub_Process__c>();
        fullSubProcList = [SELECT Name, Process__c, Active__c, Stage__c, Sub_Process_Type__c, Parent_Process_Stage__c,
                                  (SELECT Id, SLA_Broken__c, SLA_Indicator__c, Stage__c, Status__c, Task_Type__c, Used_For__c 
                                   FROM Workplan_Tasks__r), Percent_Complete__c,Status__c, Process__r.Percent_Complete__c,
                                   Total_Task_Count__c, AIA_Number_of_Completed_tasks__c, AIA_Number_of_Not_Required_Tasks__c,
                                   Number_of_Blocked_Tasks__c, Number_of_Not_Started_Tasks__c, Number_of_In_Progress_Tasks__c,
                                   Number_of_Tasks_SLA_Broken__c
                          FROM Sub_Process__c
                          WHERE Process__c = :processID
                          ORDER BY Sequence_Number__c ASC NULLS LAST];
                                               
        //Setting the booleans to show the Show More link and associated value
        if(!fullSubProcList.isEmpty()) {
            ShowMoreLinkSize = fullSubProcList.size() - DEFAULT_DISPLAY_SIZE;
            displayShowMoreLink = (ShowMoreLinkSize > 0)?True:False;
            
            //If check for showing default number sub processes on initial load else show full list
            if(SubProcListSize == DEFAULT_DISPLAY_SIZE) {
                for(Integer i=0;i<DEFAULT_DISPLAY_SIZE && i<fullSubProcList.size();i++) {
                    lstSubProcesses.add(fullSubProcList[i]);
                }
            }
            else {
                lstSubProcesses.addAll(fullSubProcList);
            }
            donutPercentage=String.valueOf(fullSubProcList[0].Process__r.Percent_Complete__c);
            
            //T01 adding percentage complete to list
            lstName=new List<String>();
            for(Sub_Process__c thisSub:fullSubProcList){
                lstName.add(String.escapeSingleQuotes(thisSub.Name));
            }
            lstNames = JSON.serialize(lstName);
            //T01 end
        }//end if list size check
    }//end method getListOfTiles
    
    /** Method called when Show More link is clicked to view all the Sub Processes associated a Process **/
    public void getFullListOfTiles()
    {
        lstSubProcesses.clear();
        //T01 start
        lstName.clear();
        lstNames='';
        //T01 End
        getListOfTiles(FULL_DISPLAY_SIZE);
        displayShowMoreLink = False;
    }
    
    public void displayTaskListModalSetter() {
        system.debug('inside displayTaskListModalSetter--'+clickedSubProcessID);
        displayTaskListModal = True;
        //return NULL;
    }
    
    public void closeTaskListModal() {
        system.debug('inside closeTaskListModal--');
        displayTaskListModal = False;
        //return NULL;
    }
    
    /** Method to set the border colors to be displayed on the dashboard tiles(Sub Processes) **/
    public void InitializeColorList()
    {
        lstTileColors = new list<String>();
        lstTileColors.add('#33cccc');
        lstTileColors.add('#9999ff');
        lstTileColors.add('#9966cc');
        lstTileColors.add('#6699cc');
        lstTileColors.add('#cc99ff');
        lstTileColors.add('#0099ff');
        lstTileColors.add('#cc66cc');
        lstTileColors.add('#6633cc');  
        lstTileColorsforDonuts = JSON.serialize(lstTileColors);
        
    }
    
    /** Method to set the color to be displayed on the dashboard tiles(Sub Processes) based on Sub Process Status **/
    public void populateSubProcTileColors() {
        subProcTileColors_Status = new map<String,String>();
        subProcTileColors_Status.put('Completed','#98fb98');
        subProcTileColors_Status.put('Not Required','#D3D3D3');  	// T02
        subProcTileColors_Status.put('In-Progress','#DCF1F8');
        subProcTileColors_Status.put('In Progress','#DCF1F8');
        subProcTileColors_Status.put('SLA Breached','#FBBA6B');
        subProcTileColors_Status.put('Not Started','');
        subProcTileColors_Status.put('Blocked','');


    }
}