({
    fetchPickListVal: function(component, fieldName, elementId) {
        debugger;
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                if(fieldName == 'Broker_Consultant_Compensation__c' || fieldName == 'Contract_Period__c' || 
                   fieldName == 'Benefit_Period__c' || fieldName == 'FlexLink_Picklist__c'|| 
                   fieldName == 'EGWP_Picklist__c'|| fieldName == 'Grandfathered_Status__c' || 
                   fieldName == 'Grandfathered_PPACA_Status__c' || fieldName == 'Broker_Consultant_Amount__c' || 
                   fieldName == 'Enrollment_Type__c' || fieldName == 'Status__c' || fieldName == 'Funding_Arrangements__c'
                  || fieldName =='Identity_Protection__c'){
                }else{
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },
    fetchPicklistValues: function(component, controllerField, dependentField) {
        debugger;
        // call the server side function  
        var action = component.get("c.getDependentOptionsImpl");
        // pass paramerters [object name , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            "objApiName": component.get("v.NewobjInfo"),
            "contrfieldApiName": controllerField,
            "depfieldApiName": dependentField,
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap", StoreResponse);
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on ui field. 
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                //set the controller field value for ui:inputSelect  
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: "--- None ---"
                    });
                }
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push({
                        class: "optionClass",
                        label: listOfkeys[i],
                        value: listOfkeys[i]
                    });
                }
                // set the ControllerField variable values to country(controller picklist field)
                component.find('conCountry').set("v.options", ControllerField);
            }
        });
        $A.enqueueAction(action);
    },
    
    createBRF: function(component, newBRF) {
        debugger;
        //Save the Benefit Request Form and update the view
        this.upsertBRF(component, newBRF, function(a) {             
        });
    },
    upsertBRF : function(component, newBRF, callback) {
         debugger;
        var action = component.get("c.saveBRF");
        var brf;
        action.setParams({ 
            "NBRF": newBRF
        });
        //  debugger;
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                brf = response.getReturnValue();
                component.set("v.BRFURL", brf.Id);
                //  debugger;
                if(brf != undefined){
                    //sforce.one.navigateToSObject( brf.Id, "detail");
                    //T01 -- Start
                    this.goToBRF(brf.Id);
                    //T01 -- End
                }
            }
            //debugger;
            component.set("v.body", []);
            var msg = 'Error Has occured while saving the BRF: ';
            //debugger;
            if(response.getState() == "ERROR"){
                var errors = action.getError();
                //debugger;
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var message = errors[0].message;
                        var outputText = msg;
                        
                        var initialerror = message.split('\FIELD_CUSTOM_VALIDATION_EXCEPTION, ');
                        var finalerror;
                        var i;
                        var sParameterName;
                        var sParameterName2;
                        for (i = 0; i < initialerror.length; i++) {
                            sParameterName = initialerror[i];   
                        }
                        sParameterName = sParameterName.split('\: [');
                        for (i = 0; i < sParameterName.length; i++) {
                            sParameterName2 = sParameterName[0];   
                        }
                        var finalerror = sParameterName2+'.';
                        var msg = outputText+finalerror;
                        /*To display mandatory fields - error message*/ 
                        $A.createComponent(
                            "ui:message",
                            {
                                "title" : msg,
                                "severity" : "error",
                            },
                            function(uiMsgComp, status, errorMessage){
                                //Add the new button to the body array
                                if (status === "SUCCESS") {
                                    var body = component.get("v.body");
                                    body.push(uiMsgComp);
                                    component.set("v.body", body);
                                }
                                else if (status === "INCOMPLETE") {
                                    console.log("No response from server or client is offline.")
                                    // Show offline error
                                }
                                    else if (status === "ERROR") {
                                        console.log("Error: " + errorMessage);
                                        // Show error message
                                    }
                            }
                        );
                        /*To display mandatory fields - error message*/ 
                    }
                } 
                //debugger;
            }
            //debugger; 
        });
        $A.enqueueAction(action); 
    },
    
    getPRFvalue: function(component,PRFId){
        debugger;
        var action = component.get("c.getPRF");
        action.setParams({ 
            "PRF": PRFId
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var PRFValues = response.getReturnValue();
                component.set("v.PRFName",PRFValues.Name);
            }      
        });
        $A.enqueueAction(action);
    },
    getfieldValue: function(component, fieldName,fieldAPI){
         debugger;
        
        var action = component.get("c.getBRFFields");
        action.setParams({
            "fld": fieldAPI
        });
        //  debugger;
        action.setCallback(this, function(response) {
            // debugger;
            if (response.getState() == "SUCCESS") {
                
                var FieldValues = response.getReturnValue();
                component.set(fieldName,FieldValues);
                
            }      
        });
        $A.enqueueAction(action);
    },
    setDefaultvalues : function(component)
    {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        // alert(sURLVariables);
        var sParameterName;
        var i;
        var OPPId;
        var AccID;
        var PRFId;
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            if (sParameterName[0] === 'PRFid')
                PRFId = sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            if (sParameterName[0] === 'oppid') { //lets say you are looking for param name - firstName
                OPPId = sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            }
            else if (sParameterName[0] === 'Account__c') { //lets say you are looking for param name - firstName
                AccID = sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            }
        }
        console.log('OPPId Param name'+OPPId);
        console.log('AccID Param value'+AccID);
        console.log('AccID Param value'+PRFId);
        component.set("v.returnURL",OPPId);
        component.set("v.AccountId","/"+AccID);
        component.set("v.OpportunityId","/"+OPPId);
        component.set("v.PRFId","/"+PRFId);
        component.set("v.ParentAccID",AccID);
        if(PRFId != undefined)
            this.getPRFvalue(component,PRFId);
        
        var action = component.get("c.getOpp");
        action.setParams({ 
            "Oppid": OPPId
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var OppValues = response.getReturnValue();
                //alert(OppValues);
                component.set("v.AccountName",OppValues.Account_Name__c);
                component.set("v.OpportunityName",OppValues.Name);
                component.set("v.newBRF.Benefit_Effective_Date__c", OppValues.Effective_Date__c);
                if(OppValues.Risk_Non_Risk__c == "Non-Risk"){
                    component.set("v.newBRF.Funding_Arrangements__c","ASO" );
                }else{
                    component.set("v.newBRF.Funding_Arrangements__c",OppValues.Risk_Non_Risk__c );
                }
                component.set("v.newBRF.Account__c",OppValues.Account__c); 
                component.set("v.newBRF.Opportunity__c",OppValues.id); 
                if(OppValues.Market_Segment_New__c == "200-999"){
                    component.set("v.newBRF.Sales_Segment_Size__c","Commercial 200-999");
                }
                if(OppValues.Market_Segment_New__c == "1000+"){
                    component.set("v.newBRF.Sales_Segment_Size__c","Commercial 1,000+");
                }
               // debugger;
               // debugger;
                var newBRF = component.get("v.newBRF");
                newBRF.Broker_Consultant_Name__c = OppValues.Broker_Consultant_Name__c;
                var BCname = '';
                if(OppValues.Broker_Consultant_Name__c != undefined){
                    if(OppValues.Broker_Consultant_Name__r.FirstName != undefined){
                        BCname = OppValues.Broker_Consultant_Name__r.FirstName+' ';
                    }
                    if(OppValues.Broker_Consultant_Name__r.LastName != undefined){
                        BCname += OppValues.Broker_Consultant_Name__r.LastName;
                    }   
                }
                
                var BCid = "/"+OppValues.Broker_Consultant_Name__c;
                component.set("v.BCName",BCname);
              //  component.set("v.BCId",BCid);
                component.set("v.newBRF.Jurisdiction__c",OppValues.Account.Jurisdiction__c);
                var Controlplan=OppValues.Account.Control_Plan__c;
                var IDProtect = "Yes";
                if(OppValues.Account.Jurisdiction__c == "MD"){
                    if(Controlplan == null){
                        Controlplan = "690";   
                    }
                    if(OppValues.Risk_Non_Risk__c == "Risk"){
                        IDProtect = "No";     
                    }
                }else if(OppValues.Account.Jurisdiction__c == "DC" || OppValues.Account.Jurisdiction__c == "VA"){
                    if(Controlplan == null){
                        Controlplan = "580";      
                    }
                    IDProtect = "Yes";  
                }
                component.set("v.newBRF.Identity_Protection__c",IDProtect);
                component.set("v.newBRF.Control_Plan__c",Controlplan);
            }
        });
        $A.enqueueAction(action);
    },
    checkandCreateBRF : function(component)
    {
        // Validate form fields
        // Pass form data to a helper function
        var newBRF = component.get("v.newBRF");
        var  msg='';
        console.log('newBRF.Account__c Param value'+newBRF.Account__c);
        
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        var OPPId;
        var AccID;
        var PRFId;
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            if (sParameterName[0] === 'PRFid')
                PRFId = sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            if (sParameterName[0] === 'oppid') { //lets say you are looking for param name - firstName
                OPPId = sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            }
            else if (sParameterName[0] === 'Account__c') { //lets say you are looking for param name - firstName
                AccID = sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            }
        }
        console.log('OPPId Param name'+OPPId);
        console.log('AccID Param value'+AccID);
        //console.log('PRFId Param value'+PRFId);
        //var AccName = component.get("v.AccountId");
        // debugger;
        if(newBRF.Account__c == null ){newBRF.Account__c =  AccID;}
        if(newBRF.Opportunity__c == null ){newBRF.Opportunity__c = OPPId;  }  
        if(newBRF.Proposal_Request_Form__c == null && PRFId != 'undefined'){newBRF.Proposal_Request_Form__c = PRFId;  }  
        if(newBRF.Account__c == null)
        {
            msg+= 'Account,';       
        }
        if(newBRF.Opportunity__c == null)
        {
            msg+= 'Opportunity,';	       
        }
        if(newBRF.Request_Type__c == null || newBRF.Request_Type__c == "")  {		msg+= 'Request Type,';	  }    
        if(newBRF.Benefit_Effective_Date__c == null || newBRF.Benefit_Effective_Date__c == "")  {		msg+= 'Benefit Effective Date,';	  } 
        if(newBRF.Benefit_Period__c == null || newBRF.Benefit_Period__c == "")  {		msg+= 'Benefit Period,';	  }   
        if(newBRF.Control_Plan__c == null || newBRF.Control_Plan__c == "")  {		msg+= 'Control Plan,';	  }   
        if(newBRF.Sales_Segment_Size__c == null || newBRF.Sales_Segment_Size__c == "")  {		msg+= 'Sales Segment Size,';	  }   
        if(newBRF.EGWP_Picklist__c == null || newBRF.EGWP_Picklist__c == "")  {		msg+= 'EGWP,';	  }   
        if(newBRF.FlexLink_Picklist__c == null || newBRF.FlexLink_Picklist__c=="")  {		msg+= 'FlexLink,';	  }   
        if(newBRF.Grandfathered_Status__c == null || newBRF.Grandfathered_Status__c == "")  {		msg+= 'Grandfathered Status,';	  }   
        if(newBRF.Grandfathered_PPACA_Status__c == null || newBRF.Grandfathered_PPACA_Status__c =="")  {		msg+= 'PPACA Status,';	  }   
        if(newBRF.Broker_Consultant_Compensation__c == null || newBRF.Broker_Consultant_Compensation__c == "")  {		msg+= 'Broker/Consultant Compensation,';	  }   
        if(newBRF.Broker_Consultant_Amount__c == null || newBRF.Broker_Consultant_Amount__c == "")  {		msg+= 'Broker/Consultant Amount,';	  }   
        if(newBRF.Contract_Count__c == null || newBRF.Contract_Count__c == "")  {		msg+= 'Contract Count,';	  }   
        if(newBRF.Identity_Protection__c == null || newBRF.Identity_Protection__c == "")  {		msg+= 'Identity Protection,';	  }   
        if(newBRF.Enrollment_Type__c == null || newBRF.Enrollment_Type__c == "")  {		msg+= 'Enrollment Type,';	  }    
        if(msg != '')
        {
            console.log("Inside if line 359"+msg);
            component.set("v.body", []);
			//debugger;
            msg = 'These required fields must be completed: ' + msg;
            msg = msg.substring(0, msg.length - 1);
            /*To display mandatory fields - error message*/ 
			$A.createComponent(
            "ui:message",
            {
                "title" : msg,
                "severity" : "error",
            },
            function(uiMsgComp, status, errorMessage){
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(uiMsgComp);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );
          /*To display mandatory fields - error message*/ 
            return false;
        }
        else
        {
            this.createBRF(component, newBRF);
        }
    },
    //T01 -- Start
    //Method to go to BRF detail page after saving
    goToBRF:function(brfId)
    {
        console.log("inside got to brf");
        var navigateToBRF = $A.get("e.force:navigateToSObject");
    	navigateToBRF.setParams({
        	"recordId": brfId
    	})
    	navigateToBRF.fire();
    },
    
   	//Method to navigate to Opportunity page on click of cancel
    returnBRF:function(component,event)
    {
        console.log("return url")
    var returnToOpp = $A.get("e.force:navigateToSObject");
    	returnToOpp.setParams({
        	"recordId": component.get("v.returnURL")
    	})
    	returnToOpp.fire();
    
	}
    //T01 -- End
})