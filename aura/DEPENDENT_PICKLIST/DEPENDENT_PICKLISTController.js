({
	doInit: function(component, event, helper) {
        var parentPicklistApiname = component.get("v.parentPicklistApiname");
        var dependentPicklistApiname = component.get("v.dependentPicklistApiname");
        console.log('parentPicklistApiname=='+parentPicklistApiname);
        console.log('dependentPicklistApiname=='+dependentPicklistApiname);
        helper.fetchPicklistValues(component, parentPicklistApiname, dependentPicklistApiname);
       
    },
     // function call on change tha controller field  
   onControllerFieldChange: function(component, event, helper) {
      //alert(event.getSource().get("v.value"));
      // get the selected value
      debugger;
      var controllerValueKey = event.getSource().get("v.value");
 		
        component.set("v.parentPicklistvalue", event.getSource().get("v.value")); 
        
      // get the map values   
      var Map = component.get("v.depnedentFieldMap");
 
      // check if selected value is not equal to None then call the helper function.
      // if controller field value is none then make dependent field value is none and disable field
      if (controllerValueKey != '--- None ---') {
 
         // get dependent values for controller field by using map[key].  
         // for i.e "India" is controllerValueKey so in the map give key Name for get map values like 
         // map['India'] = its return all dependent picklist values.
         var ListOfDependentFields = Map[controllerValueKey];
         helper.fetchDepValues(component, ListOfDependentFields);
 
      } else {
         var defaultVal = [{
            class: "optionClass",
            label: '--- None ---',
            value: '--- None ---'
         }];
         component.find('conState').set("v.options", defaultVal);
         component.set("v.isDependentDisable", true);
      }
   },
    // function call on change tha Dependent field    
   onDependentFieldChange: function(component, event, helper) {
         component.set("v.dependentPicklistvalue", event.getSource().get("v.value"));
       //alert(event.getSource().get("v.value"));
   }
})