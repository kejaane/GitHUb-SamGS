// T01- Change for MHP US771
({
    doInit: function(component, event, helper) {
        debugger;
        helper.fetchPickListVal(component, 'Request_Type__c', 'BRFRequestType');
        helper.fetchPickListVal(component, 'Benefit_Period__c', 'BRFBenPeriod');
        helper.fetchPickListVal(component, 'Control_Plan__c', 'BRFCtrlPlan');
        helper.fetchPickListVal(component, 'Status__c', 'BRFStatus');
        helper.fetchPickListVal(component, 'Jurisdiction__c', 'BRFJur');
        helper.fetchPickListVal(component, 'Sales_Segment_Size__c', 'BRFSSSize');
        helper.fetchPickListVal(component, 'Contract_Period__c', 'BRFContractPeriod');
        helper.fetchPickListVal(component, 'EGWP_Picklist__c', 'BRFEGWP');
        helper.fetchPickListVal(component, 'FlexLink_Picklist__c', 'BRFFlexLink');
        helper.fetchPickListVal(component, 'Accommodation__c', 'BRFRegAcc');
        helper.fetchPickListVal(component, 'Funding_Arrangements__c', 'BRFFundingArr');
        helper.fetchPickListVal(component, 'Alternate_Funding__c', 'BRFAtlfunding');
        helper.fetchPickListVal(component, 'Credits__c', 'BRFCredit');
        helper.fetchPickListVal(component, 'Broker_Consultant_Compensation__c', 'BRFBrokerCC');
        helper.fetchPickListVal(component, 'Identity_Protection__c', 'BRFIDProtect');
        helper.fetchPickListVal(component, 'Enrollment_Type__c', 'BRFEnrollType');
        helper.fetchPickListVal(component, 'Enrollment_Option__c', 'BRFEnrollOption');
        helper.fetchPickListVal(component, 'ARC_Approval_Status__c', 'BRFARCStatus');
        helper.fetchPickListVal(component, 'Sales__c', 'BRFSalesmgmt');
        helper.fetchPickListVal(component, 'Zip_Code_Validation__c', 'BRFZipCodeValid');
       console.log("Inside Doinit 23");
        //GetFieldPermission
        helper.getfieldValue(component,'v.BenEffDateDisabled','Benefit_Effective_Date__c');
        helper.getfieldValue(component,'v.BRFRequestTypeDisabled','Request_Type__c');
        helper.getfieldValue(component,'v.BRFBenPeriodDisabled','Benefit_Period__c');
        helper.getfieldValue(component,'v.BRFCtrlPlanDisabled','Control_Plan__c');
        helper.getfieldValue(component,'v.BRFStatusDisabled','Status__c');
        helper.getfieldValue(component,'v.BRFJurDisabled','Jurisdiction__c');
        helper.getfieldValue(component,'v.BRFSSSizeDisabled','Sales_Segment_Size__c');
        helper.getfieldValue(component,'v.BRFContractPeriodDisabled','Contract_Period__c');
        helper.getfieldValue(component,'v.NoOfContractPeriodDisabled','Number_of_Months_for_Contract_Period__c');
        helper.getfieldValue(component,'v.BRFEGWPDisabled','EGWP_Picklist__c');
        helper.getfieldValue(component,'v.BRFFlexLinkDisabled','FlexLink_Picklist__c');
        helper.getfieldValue(component,'v.ReligExemDisabled','Exemption__c');
        helper.getfieldValue(component,'v.BRFRegAccDisabled','Accommodation__c');
        //helper.getfieldValue(component,'v.MHPTestResDisabled','MHP_Test_Result__c'); //T01
        helper.getfieldValue(component,'v.MHPTestResDisabled','Submit_Medical_Plan_s_for_MHP_Testing__c');
        helper.getfieldValue(component,'v.BRFFundingArrDisabled','Funding_Arrangements__c');
        helper.getfieldValue(component,'v.BRFAtlfundingDisabled','Alternate_Funding__c');
        helper.getfieldValue(component,'v.BRFCreditDisabled','Credits__c');
        helper.getfieldValue(component,'v.CreditRecommDisabled','Credit_Recommendation__c');
        helper.getfieldValue(component,'v.BRFBrokerCCDisabled','Broker_Consultant_Compensation__c');
        helper.getfieldValue(component,'v.BrokerConAmountDisabled','Broker_Consultant_Amount__c');
        helper.getfieldValue(component,'v.ContractCountDisabled','Contract_Count__c');
        helper.getfieldValue(component,'v.EmpConAmountDisabled','Employer_Contribution_Amount__c');
        helper.getfieldValue(component,'v.AltNetReqDisabled','Alternate_Networks_Requested__c');
        helper.getfieldValue(component,'v.CommToUWDisabled','Underwriting_Comments__c');
        helper.getfieldValue(component,'v.BRFIDProtectDisabled','Identity_Protection__c');
        helper.getfieldValue(component,'v.BRFEnrollTypeDisabled','Enrollment_Type__c');
        helper.getfieldValue(component,'v.BRFEnrollOptionDisabled','Enrollment_Option__c');
        helper.getfieldValue(component,'v.OtherEnrollOptionDisabled','Other_Enrollment_Option__c');
        helper.getfieldValue(component,'v.EnrollVendorDisabled','Enrollment_Vendor__c');
        helper.getfieldValue(component,'v.BRFARCStatusDisabled','ARC_Approval_Status__c');
        helper.getfieldValue(component,'v.ARCCommDisabled','ARC_Comments__c');
        helper.getfieldValue(component,'v.EscSRMgmgtDisabled','Escalated_to_Senior_Management__c');
        helper.getfieldValue(component,'v.SrMgmtCommDisabled','Senior_Management_Comments__c');
        helper.getfieldValue(component,'v.BRFSalesmgmtDisabled','Sales__c');
        helper.getfieldValue(component,'v.SalesMgmtStausCommDisabled','Comments__c');
        helper.getfieldValue(component,'v.ValidCedeUploadedDisabled','Valid_Cede_Document_Uploaded__c');
        helper.getfieldValue(component,'v.RequestCedeUploadedDisabled','Request_Cede_Document__c');
        helper.getfieldValue(component,'v.BRFZipCodeValidDisabled','Zip_Code_Validation__c');
        helper.getfieldValue(component,'v.BRFAEDisabled','Account_Executive_Account_Team__c');
        helper.getfieldValue(component,'v.BRFAMDisabled','Account_Manager_Account_Team__c');
        helper.getfieldValue(component,'v.BRFSalesSegmentDisabled','Sales_Management_Approval__c');
        console.log("Inside Doinit 65");
        helper.setDefaultvalues(component);
       // debugger;
        console.log("Inside Doinit 69");
        
        //debugger;
    },
    
    createBRF : function(component, event, helper) {
        debugger;
       helper.checkandCreateBRF(component);
    },
    //T01 Start Method to return to Opportunity page after clicking cancel
    returnURL : function(component,event,helper){
        helper.returnBRF(component,event);
    },
    //T01 End
})