/*==========================================================================================================
* Date         : 03/20/2017 
* Developer    : Sree Harsha
* Purpose      : This class is for calculating Approval Response in Days depending on Approval Start Date 
*                and Approval response date, in Business Days excluding Holidays.
*===========================================================================================================
*                                 Update History
*                                 ---------------
* Date      | Developer  | Tag  | Description
*===========+============+======+===========================================================================
* 03/20/2017| Sree Harsha|      | Initial Version                                         
* 09/18/2017| Asif K     | T01  | Adding constructor to move the query outside method CalculateWorkingDays
* 10/13/2017| Satya      | T02  | Added method that will be called from AIA_SLANotification_Batch class to
*                                 get the working day date after adding expected SLA to workplan start date.
* 05/15/2018| Gayathri P | T03  | Added the query before for loop to avoid too many SOQL
* 11/28/2018| Gayathri P | T04  | Replaced NASCO Benefit Coder in BD with Benefit Tester and Benefit Coder - US1730
* 12/05/2018| Chaithra   | T05  | Replaced Ancillary analyst with Vision analyst/Pharmacy Operations roles as paert pf US1702
* 04/15/2019| Satya      | T06  | Commented out the System.debug statements inside for loops
*===========+============+======+===========================================================================
*/

public without sharing class AIA_CalculateDaysDiffExcludingHoliday {
    public static List<Holiday> holidayList = new List<Holiday>();
    
    /** T01 - Start **/
    public AIA_CalculateDaysDiffExcludingHoliday()
    {
        //Fetch all holiday list from the organization           
        //holidayList = [SELECT StartTimeInMinutes, Name, ActivityDate FROM Holiday WHERE ActivityDate = THIS_YEAR];   
    }
    /** T01 - End **/
    //TO3  - START
    static{
     holidayList = [SELECT StartTimeInMinutes, Name, ActivityDate FROM Holiday WHERE ActivityDate = THIS_YEAR];
    }
    //T03 - END
    /*
    * @Author: Sree Harsha 
    * This method calculates the difference between 
    * approval start dates and response dates in 
    * Business Days excluding Holidays.
    * @param -  Date 
    * @Output - Calculates the difference between Approval Start 
    * and end days in Business Days.
    */
    @TestVisible   
    public static integer CalculateWorkingDays(date startdt, Date enddt){
        Integer allWorkingDays = 0;
       
        //holidayList = [SELECT StartTimeInMinutes, Name, ActivityDate FROM Holiday WHERE ActivityDate = THIS_YEAR];  
        
        if(startdt != NULL && enddt != NULL) {
            // to include both start and end date in calculation, add 1 with days //difference
            Integer allDaysBetween = startdt.daysBetween(enddt);
           // system.debug('**allDaysBetween'+allDaysBetween);//t06
            //system.debug('holidayList>>>'+holidayList);//t06
            //If start date and end date are same, then check is this date not fall in holiday or weekoff
            if(startdt == enddt){
               // system.debug('**startdt'+startdt+'enddt'+enddt);
                boolean isHoliday= false;
                //For excluding weekoff- week starts with Monday,As my week starts with sunday subtract 1 from weekstart. 
                Date weekStart = startdt.toStartofWeek();
               // system.debug('**weekStart12345'+weekStart);
                for(Holiday hDay:holidayList){
                    if(startdt.daysBetween(hDay.ActivityDate) == 0){
                        isHoliday= true;
                    }
                }
               // system.debug('@@ weekStart.daysBetween(startdt)'+weekStart.daysBetween(startdt));
                if(weekStart.daysBetween(startdt) == 7 || weekStart.daysBetween(startdt) == 6){
                    isHoliday= true;
                }
               // system.debug('**isHoliday'+isHoliday);
                if(isHoliday == false){
                    allWorkingDays = 0;
                }
            }
            else{//start date and end date are not same, so need to loop with all dates to exclude weekoff and holiday list
                for(Integer k=0;k<allDaysBetween ;k++ ){
                    //system.debug('startdt.addDays(k)'+startdt.addDays(k));//t06
                    if(checkWorkingDay(startdt.addDays(k),holidayList)){
                        //system.debug('**working day:'+startdt.addDays(k));//t06
                        allWorkingDays++; //increment working date for each working date.
                    } 
                }
            }
        }
        return allWorkingDays;
    }

    /*
    * @Author: Sree Harsha 
    * This Method is used to calculate the working days.
    * @param -  Date, List<Holiday>
    * @Output - Returns whether particular day is working day or not.
    */
    public static boolean checkWorkingDay(Date currentDate,List<Holiday> lstHoliday){
        //system.debug('**currentDate'+currentDate);
        //T03 -- Start
        //holidayList = [SELECT StartTimeInMinutes, Name, ActivityDate FROM Holiday WHERE ActivityDate = THIS_YEAR];  
        //T03 -- End
        //Date weekStart = currentDate.toStartofWeek().addDays(-1);
        Date weekStart = currentDate.toStartofWeek();
        //system.debug('**weekStart'+weekStart);
       // system.debug('**holidayList'+holidayList);
        if(holidayList != null && holidayList.size()>0){
            for(Holiday hDay:lstHoliday){
                //if date fall inholiday then return false.
                //system.debug('**holidayList ActivityDate'+hDay.ActivityDate);//t06
                if(currentDate.daysBetween(hDay.ActivityDate) == 0){
                    //system.debug('@@ in holiday currentDate.daysBetween(hDay.ActivityDate)'+currentDate.daysBetween(hDay.ActivityDate));
                    return false;
                }
            }
        }
        //system.debug('@@ weekStart daysBetween in checkWorkingDay'+weekStart.daysBetween(currentDate));
        //if date fall in weekend return false 
        IF(weekStart.daysBetween(currentDate) == 0 || weekStart.daysBetween(currentDate) == 6){
            //system.debug('@@ weekoff weekStart.daysBetween(currentDate)'+weekStart.daysBetween(currentDate));
            return false;
        } 
        else{
            //if date is not in holiday list and not in weekoff, return true to indicate as working date.
            return true;
        }
    }
    

    /*
    * @Author: Sree Harsha 
    * This Method is called from AIA_BenefitDesignTriggerHandler
    * during updation of Benefit Design to calculate Response Days.
    * @param -  list<AIA_Benefit_Design__c> 
    * @Output - Updates the Response Days field after calculating difference.
    */
    public static void calApprovalResponseDay(list<AIA_Benefit_Design__c> BDlist){
        integer days;
        //system.debug('calApprovalResponseDay');
        //system.debug('BDlist'+BDlist);
        if(BDlist != null && BDlist.size()>0){
            for(AIA_Benefit_Design__c bd: BDlist){
                /* T05 Start 
                if(bd.Approver_Ancillary_Analyst__c != null){
                    system.debug('bd.Approver_Ancillary_Analyst__c' +bd.Approver_Ancillary_Analyst__c );
                    if(bd.Ancillary_Tech_Approval_Start_Date__c != Null && bd.Ancillary_Tech_Response_Date__c != Null){
                        system.debug('bd.Ancillary_Tech_Approval_Start_Date__c'+bd.Ancillary_Tech_Approval_Start_Date__c+'bd.Ancillary_Tech_Response_Date__c'+bd.Ancillary_Tech_Response_Date__c);
                      
                        days = CalculateWorkingDays(bd.Ancillary_Tech_Approval_Start_Date__c,bd.Ancillary_Tech_Response_Date__c);
                        bd.Ancillary_Tech_Response_Days__c = string.valueOf(days);
                    }
                    system.debug('Ancillary_Tech_Response_Days__c>>>>'+bd.Ancillary_Tech_Response_Days__c); 
                }else{
                    bd.Ancillary_Tech_Response_Days__c ='NA';
                }
                T05 ends*/
                //T05 Start
                if(bd.Approver_Vision_Analyst__c != null){
                    
                    if(bd.Vision_Analyst_Approval_Start_Date__c != Null && bd.Vision_Analyst_Response_Date__c != Null){
                       // system.debug('bd.Vision_Analyst_Approval_Start_Date__c'+bd.Vision_Analyst_Approval_Start_Date__c+'bd.Vision_Analyst_Response_Date__c'+bd.Vision_Analyst_Response_Date__c);
                      
                        days = CalculateWorkingDays(bd.Vision_Analyst_Approval_Start_Date__c,bd.Vision_Analyst_Response_Date__c);
                        bd.Vision_Analyst_Response_Days__c = string.valueOf(days);
                    }
                    //system.debug('Vision_Analyst_Response_Days__c>>>>'+bd.Vision_Analyst_Response_Days__c); 
                }else{
                    bd.Vision_Analyst_Response_Days__c ='NA';
                }
                if(bd.Approver_Pharmacy_Operations__c != null){
                    //system.debug('bd.Approver_Pharmacy_Operations__c' +bd.Approver_Pharmacy_Operations__c );
                    if(bd.Pharmacy_Operations_Approval_Start_Date__c != Null && bd.Pharmacy_Operations_Response_Date__c != Null){
                        //system.debug('bd.Pharmacy_Operations_Approval_Start_Date__c'+bd.Pharmacy_Operations_Approval_Start_Date__c+'bd.Pharmacy_Operations_Response_Date__c'+bd.Pharmacy_Operations_Response_Date__c);
                      
                        days = CalculateWorkingDays(bd.Pharmacy_Operations_Approval_Start_Date__c,bd.Pharmacy_Operations_Response_Date__c);
                        bd.Pharmacy_Operations_Response_Days__c = string.valueOf(days);
                    }
                    //system.debug('Pharmacy_Operations_Response_Days__c>>>>'+bd.Pharmacy_Operations_Response_Days__c); 
                }else{
                    bd.Pharmacy_Operations_Response_Days__c ='NA';
                }
                 
                //T05 Ends
                if(bd.Approver_Contract_Tech__c != null){
                    if(bd.Contract_Tech_Approval_Start_Date__c != Null && bd.Contract_Tech_Response_Date__c != Null){
                     
                        days = CalculateWorkingDays(bd.Contract_Tech_Approval_Start_Date__c,bd.Contract_Tech_Response_Date__c);
                        bd.Contract_Tech_Response_Days__c = string.valueOf(days);
                    }   
                }else{
                    bd.Contract_Tech_Response_Days__c ='NA';
                }
                //T04 -- Start
                /*if(bd.Approver_Benefit_Coder__c != null){
                    if(bd.NASCO_Benefit_Coder_Approval_Start_Date__c != Null && bd.NASCO_Benefit_Coder_Response_Date__c != Null){
                      
                        days = CalculateWorkingDays(bd.NASCO_Benefit_Coder_Approval_Start_Date__c,bd.NASCO_Benefit_Coder_Response_Date__c);
                        bd.NASCO_Benefit_Coder_Response_Days__c = string.valueOf(days);
                    }   
                }else{
                    bd.NASCO_Benefit_Coder_Response_Days__c ='NA';
                }
*/
                if(bd.AIA_Approver_Benefit_Tester__c != null){
                    if(bd.AIA_Benefit_Tester_Approval_Start_Date__c != Null && bd.AIA_Benefit_Tester_Response_Date__c != Null){
                      
                        days = CalculateWorkingDays(bd.AIA_Benefit_Tester_Approval_Start_Date__c,bd.AIA_Benefit_Tester_Response_Date__c);
                        bd.AIA_Benefit_Tester_Response_Days__c = string.valueOf(days);
                    }   
                }else{
                    bd.AIA_Benefit_Tester_Response_Days__c ='NA';
                }
                
                if(bd.AIA_Approver_Benefit_Coder__c != null){
                    if(bd.AIA_Benefit_Coder_Approval_Start_Date__c != Null && bd.AIA_Benefit_Coder_Response_Date__c != Null){
                      
                        days = CalculateWorkingDays(bd.AIA_Benefit_Coder_Approval_Start_Date__c,bd.AIA_Benefit_Coder_Response_Date__c);
                        bd.AIA_Benefit_Coder_Response_Days__c = string.valueOf(days);
                    }   
                }else{
                    bd.AIA_Benefit_Coder_Response_Days__c ='NA';
                }
                
                //T04 -- End
                if(bd.AIA_Approver_Benefact_Coder__c != null){
                    if(bd.Benefact_Coder_Approval_Start_Date__c != Null && bd.Benefact_Coder_Response_Date__c != Null){
                      
                        days = CalculateWorkingDays(bd.Benefact_Coder_Approval_Start_Date__c,bd.Benefact_Coder_Response_Date__c);
                        bd.Benefact_Coder_Response_Days__c = string.valueOf(days);
                    }   
                }else{
                    bd.Benefact_Coder_Response_Days__c ='NA';
                } 
                if(bd.AIA_Approver_MAST_Tech__c != null){
                    if(bd.MAST_Tech_Approval_Start_Date__c != Null && bd.MAST_Tech_Response_Date__c != Null){
                    
                        days = CalculateWorkingDays(bd.Benefact_Coder_Approval_Start_Date__c,bd.MAST_Tech_Response_Date__c);
                        bd.MAST_Tech_Response_Days__c = string.valueOf(days);
                    }   
                }else{
                    bd.MAST_Tech_Response_Days__c ='NA';
                }
            }   
        }
    }
    
    
    
    /*
    * @Author: Sree Harsha 
    * This Method is used to calculate the working days.
    * @param -  Date, List<Holiday>
    * @Output - Returns whether particular day is working day or not.
    */
    public boolean checkWorkingDays(Date currentDate,List<Holiday> lstHoliday){
        //system.debug('**currentDate'+currentDate);
        //holidayList = [SELECT StartTimeInMinutes, Name, ActivityDate FROM Holiday WHERE ActivityDate = THIS_YEAR];  
        //Date weekStart = currentDate.toStartofWeek().addDays(-1);
        Date weekStart = currentDate.toStartofWeek();
        //system.debug('**weekStart'+weekStart);
       // system.debug('**holidayList'+holidayList);
        if(holidayList != null && holidayList.size()>0){
            for(Holiday hDay:lstHoliday){
                //if date fall inholiday then return false.
                //system.debug('**holidayList ActivityDate'+hDay.ActivityDate);//t06
                if(currentDate.daysBetween(hDay.ActivityDate) == 0){
                    //system.debug('@@ in holiday currentDate.daysBetween(hDay.ActivityDate)'+currentDate.daysBetween(hDay.ActivityDate));//t06
                    return false;
                }
            }
        }
        //system.debug('@@ weekStart daysBetween in checkWorkingDay'+weekStart.daysBetween(currentDate));
        //if date fall in weekend return false 
        IF(weekStart.daysBetween(currentDate) == 0 || weekStart.daysBetween(currentDate) == 6){
           // system.debug('@@ weekoff weekStart.daysBetween(currentDate)'+weekStart.daysBetween(currentDate));
            return false;
        } 
        else{
            //if date is not in holiday list and not in weekoff, return true to indicate as working date.
            return true;
        }
    }
    
    //This method will be called from AIA_SLANotification_Batch class. This method takes start date and SLA days as input(from batch class) and 
    //  calculates the number of Working days
    public Date addBussinessDays(Date currentDate, Integer iDays){
        Integer businessDaysAdded = 0; 
        /*if(iDays < 0)
            iDays = iDays*-1; */
        while (businessDaysAdded < iDays) {
            currentDate = currentDate.addDays(1);
            if(checkWorkingDays(currentDate,holidayList)){
                businessDaysAdded = businessDaysAdded + 1;
            } 
        }
        //system.debug('@@currentdate--'+currentDate );       
        return currentDate;
        
    }
}