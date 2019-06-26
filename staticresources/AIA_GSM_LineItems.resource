j$ = jQuery.noConflict();


		 //check error message for multi select and display it lower
         function checkerror(){
             j$( ".errorMsg" ).each(function() {
                  	var elem=j$(this).closest('.dataCell').find('.erroricon').parent();
                 	elem.removeClass();
                 	elem.addClass('requiredInput');
                    j$(this).closest('.dataCell').find('.erroricon').show();

            });
         }
         //iterate all dom elements and gettext into rows
         function getText(param,fromelem){
             var values='';
             if(fromelem=='loadtexts'){
                 j$(param).find("option").each(function(){   
                    values +=j$(this).text()+',<br>';
                 });
             }
             else{
                j$(param).find("option:selected").each(function(){   
                    values +=j$(this).text()+',<br>';
                }); 
             }
            values=values.slice(0,-5);
                if(j$(param).hasClass('employee')){   
               j$(param).closest('.dataCell').find('.selectedvalsemp').html('');    
               j$(param).closest('.dataCell').find('.selectedvalsemp').html(values); 
                } 
                else if(j$(param).hasClass('visionfield')){
                j$(param).closest('.dataCell').find('.selectedvalsvision').html('');    
                j$(param).closest('.dataCell').find('.selectedvalsvision').html(values);   
                 } 
             	else if(j$(param).hasClass('productdescfield')){
                j$(param).closest('.dataCell').find('.selectedvalspd').html('');    
                j$(param).closest('.dataCell').find('.selectedvalspd').html(values);   
                 } 
                else {
                j$(param).closest('.dataCell').find('.selectedvalsltd').html('');    
                j$(param).closest('.dataCell').find('.selectedvalsltd').html(values);    
               
                 }
        }
        function loadtexts(){
        j$( "select[title*='Chosen']" ).each(function() {
            //alert(j$(this).find("option:selected").val() );  
            getText(j$(this),'loadtexts');
                        
            });
        
        }
          j$(document).ready(function() {
            
            //j$('.emp').hide();
            j$(document).on('mouseover','.hidee,.hidec,.hidevision,.proddhidee',function( ){
                j$(this).hide();
                j$(this).parent().prev().show();
            });
            j$(document).on('mouseleave','.emp,.limitedcov,.vision,.productdesc',function( ){
                j$(this).next().children('label').show();
                j$(this).hide();
            });
              
            //make icon mandatory if limited is selected
              j$(document).on('change',"select[id*='coveragelevel']",function(){
                  if(j$(this).val()=='Limited'){
                      var elem=j$(this).closest('.dataCell').next().find('.conrequiredInput');
                      elem.removeClass();
                      elem.addClass('requiredInput');
                  }
                  else{
                      var elem=j$(this).closest('.dataCell').next().find('.requiredInput');
                      elem.removeClass();
                      elem.addClass('conrequiredInput');
                  }
                  
              });
              
              
              
        });