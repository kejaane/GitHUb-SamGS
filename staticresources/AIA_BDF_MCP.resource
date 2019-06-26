j$ = jQuery.noConflict();
    j$(document).ready(function() {
         getbdp();
        j$('.otherphone,.othervendor').prop("disabled", true);   
        setsmartproducts('{!fundArg}','{!jurisdiction}', '{!pname}','{!dmwellness}','{!standalonemgnt}','{!standalonewellness}','{!customwellness}');
            var getUrlParameter = function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};
        var bdid = getUrlParameter('CF00N60000002jAke');
	    var bdidbackend = getUrlParameter('CF00N60000002jAke_lkid');
        var bdpid = getUrlParameter('CF00N60000002jAm4');
        var bdpval = bdpid.replace("+", " ");
        var bdpidbackend = getUrlParameter('CF00N60000002jAm4_lkid');
       if((bdid!=undefined&&bdid!=''&&bdid!='null')&&(bdidbackend!=undefined&&bdidbackend!=''&&bdidbackend!='null')){
        document.getElementById('pg:fm:pb:pbs1:bdval').value=bdid;
           alert(bdid);
        document.getElementById('pg:fm:pb:pbs1:bdval_lkid').value=bdidbackend;
         getbdp();
        }
        if((bdpid!=undefined&&bdpid!=''&&bdpid!='null')&&(bdpidbackend!=undefined&&bdpidbackend!=''&&bdpidbackend!='null')){
        document.getElementById('pg:fm:pb:pbs1:bdpval').value=bdpval;
        document.getElementById('pg:fm:pb:pbs1:bdpval_lkid').value=bdpidbackend;
        getbdp();   
        }
   });     
    
   function getbdps(){
      
        var val = document.getElementById('pg:fm:pb:pbs1:bdval_lkid').value;
        //CallApexMethod1(val);
    }
   function penaltyInfo() {
        window.open('/apex/AIA_MCP_PenaltyInformation');
       

    }
	function getfunding() {
        var fundar = document.getElementById('pg:fm:pb:pbs1:fundar').value;
         CallApexMethod(fundar);
    }
function setfunding(fundArg){
       alert(fundArg);
		if (fundArg=='Risk'){
            alert(fundArg);
           document.getElementById('pg:fm:pb:pbs3:hhc').value  = 'Yes';
             alert('Test');
           document.getElementById('pg:fm:pb:pbs3:hhc').disabled = "true";
           document.getElementById('pg:fm:pb:pbs3:ct').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:ct').disabled = "true";
           document.getElementById('pg:fm:pb:pbs3:hc').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:hc').disabled = "true";
           document.getElementById('pg:fm:pb:pbs3:hsc').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:hsc').disabled = "true";;
           document.getElementById('pg:fm:pb:pbs3:ai').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:ai').disabled = "true";
           document.getElementById('pg:fm:pb:pbs3:ivf').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:ivf').disabled = "true";
           document.getElementById('pg:fm:pb:pbs3:gad').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:gad').disabled = "true";
           document.getElementById('pg:fm:pb:pbs4:pcm').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs4:pcm').disabled = "true";
           document.getElementById('pg:fm:pb:pbs5:tcci').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs5:tcci').disabled = "true";
        }
        if( fundArg=='ASO'){
           document.getElementById('pg:fm:pb:pbs4:pcm').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs5:tcci').value  = 'Yes';
        }
        //CallApexMethod(fundar);
		
    }
  function popitup(url) {
    newwindow=window.open(url,'name','height=400,width=650');
    if (window.focus) 
    {
        newwindow.focus()
    }
    return false;
}
    function getbdp(){
        var val = document.getElementById('pg:fm:pb:pbs1:bdpval').value;
       // CallApexMethod(val);
    }
    // Method to Populate OutPatient Authorization Program based on Funding Arrangement ,Jurisdiction Values
   function setsmartproducts(fundArg,jurisdiction,pname,dmwellness,standalonemgnt,standalonewellness,customwellness){
       
       
        document.getElementById('pg:fm:pb:pbs1:fundar').value = fundArg;
        document.getElementById('pg:fm:pb:pbs1:fundar').disabled = "true";
        
        if (fundArg=='Risk'){
           document.getElementById('pg:fm:pb:pbs3:hhc').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:hhc').disabled = "true";
           document.getElementById('pg:fm:pb:pbs3:ct').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:ct').disabled = "true";
           document.getElementById('pg:fm:pb:pbs3:hc').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:hc').disabled = "true";
           document.getElementById('pg:fm:pb:pbs3:hsc').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:hsc').disabled = "true";;
           document.getElementById('pg:fm:pb:pbs3:ai').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:ai').disabled = "true";
           document.getElementById('pg:fm:pb:pbs3:ivf').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:ivf').disabled = "true";
           document.getElementById('pg:fm:pb:pbs3:gad').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs3:gad').disabled = "true";
           if (pname.includes("Smart Selections")){
                document.getElementById('pg:fm:pb:pbs3:ass').value  = 'Yes';
                document.getElementById('pg:fm:pb:pbs3:ass').disabled = "true";
            }else{
                document.getElementById('pg:fm:pb:pbs3:ass').value  = 'No';
                document.getElementById('pg:fm:pb:pbs3:ass').disabled = "true";
            }
           
           document.getElementById('pg:fm:pb:pbs4:pcm').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs4:pcm').disabled = "true";
           document.getElementById('pg:fm:pb:pbs5:tcci').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs5:tcci').disabled = "true";
       }
        if( fundArg=='ASO'){
           document.getElementById('pg:fm:pb:pbs4:pcm').value  = 'Yes';
           document.getElementById('pg:fm:pb:pbs5:tcci').value  = 'Yes';
          }
        if (jurisdiction=='VA'){
                document.getElementById('pg:fm:pb:pbs3:eis').value  = 'Yes';
                document.getElementById('pg:fm:pb:pbs3:eis').disabled = "true";
            }
            if (jurisdiction=='VA' || jurisdiction=='MD'){
                document.getElementById('pg:fm:pb:pbs3:aba').value  = 'Yes';
                document.getElementById('pg:fm:pb:pbs3:aba').disabled = "true";
            }
       
        document.getElementById('pg:fm:pb:pbs6:dw').value =dmwellness;
        document.getElementById('pg:fm:pb:pbs6:dw').disabled = "true";
        document.getElementById('pg:fm:pb:pbs6:sad').value =standalonemgnt;
        document.getElementById('pg:fm:pb:pbs6:sad').disabled = "true";
        document.getElementById('pg:fm:pb:pbs6:saw').value =standalonewellness;
        document.getElementById('pg:fm:pb:pbs6:saw').disabled = "true";
        document.getElementById('pg:fm:pb:pbs6:cws').value =customwellness;
        document.getElementById('pg:fm:pb:pbs6:cws').disabled = "true";
        }
  

  j$(document).on('click','.radio', function() {
      if(!j$(this).prop("checked")){
          j$('.radio').prop("checked",false);
 			j$(this).prop("checked",false);
      }else{
          j$('.radio').prop("checked",false);
          j$(this).prop("checked",true);
      }
  if(j$(this).hasClass('other')){
              j$('.otherphone,.othervendor').prop("disabled", false); 
              j$('.otherphone,.othervendor').attr("required", true);
   }else{
              j$('.otherphone,.othervendor').val("");
              j$('.otherphone,.othervendor').prop("disabled", true);
       
       }
});

j$(document).ready(function() {
    j$(document).on('change','.selectbdp',function(){
        if (j$(this).is(":checked")){
            j$(this).next().show();
        }   
        else{
           j$(this).next().hide();
        }
  });
});