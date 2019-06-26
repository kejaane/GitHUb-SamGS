/*****************************************************************************************************
 *Date: 09-16-2016 
 *Developer: Indira Das
 *Purpose: Helper class for Limitation trigger helper. 
 *This is used to merge all teh comment codes and max rows and tier rows and update the benefit
 *=========================================================================================
 * Update History
 * Date         Developer               Description
 *==================================================================================
 *09-16-2016    Indira Das  |   |  Initial Development
 *09-22-2016    Indira Das  |T01|  Changes to update the islimitationmodified field on benefitfor B-03356
 *03-27-2017    Bill Dodson |T02|  Deleted adjustment summary code no longer used.
 *05-03-2017    Rajesh Pennam|T03| Commented the code related to  T01
 *07-24-2017    satya       |T04|  Added conditions to make Benefit non-standard when ranges are NA.
 *03-12-2018    Satya       |T05|  Added as a part of defect 38940
 *==================================================================================

 *******************************************************************************************************/


public class AIA_BenefitCommentCodeTRiggerHelper {


    Public static void  concatenateBenefitCommentsCode(Map<id,Limitations__c> commentsCodeMap,Map<id,Limitations__c> oldcommentsCodeMap){

        Map<id,Limitations__c> comentmap=new Map<id,Limitations__c>();
        Set<Id> benefitIDs= new Set<ID>();
        Set<Id> benefitIDCSset = new Set<ID>();
        Map<id,Boolean> comentmapChk=new Map<id,Boolean>();
        for( Limitations__c c: commentsCodeMap.values()){
            if(oldcommentsCodeMap!=null){
                comentmapChk.put(c.id,true);
                Limitations__c oldLimit=new Limitations__c();
                oldLimit=oldcommentsCodeMap.get(c.id);
                if(c.IsSelected__c !=oldLimit.IsSelected__c || c.MaxRow_Value__c!=oldLimit.MaxRow_Value__c || c.comment_codes__c!=oldLimit.comment_codes__c || c.MaxDuration__c !=oldLimit.MaxDuration__c || c.MaxValue__c != oldLimit.MaxValue__c){
                    comentmap.put(c.id, c);
                    system.debug('old data--'+c);
                    if(!benefitIDs.contains(c.Benefit__c))
                        benefitIDs.add(c.Benefit__c);
                }
                
            }
            else{
                comentmapChk.put(c.id,false);
                if(((c.comment_codes__c!=null && c.comment_codes__c!='') || (c.MaxRow_Value__c!='' && c.MaxRow_Value__c!=null)) && c.IsSelected__c==true){
                    system.debug('old data--'+c);
                    comentmap.put(c.id, c);
                    if(!benefitIDs.contains(c.Benefit__c))
                        benefitIDs.add(c.Benefit__c);
                }
            }

        }
        if(benefitIDs.size()>0)   {
            List<Limitations__c> benefitCommentCodes= [ select id,name,Benefit__c,comment_codes__c,IsSelected__c,Type__c ,MaxRow_Value__c,IsCustom__c,MaxDuration__c,MaxDuration_Low__c,MaxDuration_High__c,MaxValue__c,MaxValue_High__c,MaxValue_Low__c,MaxDuration_Increment__c,MaxValue_Increment__c  
                                                        from Limitations__c
                                                        where Benefit__c in :benefitIDs 
                                                        order by Benefit__c ];
            Map<id,AIA_Benefits__c> benfitdata=new Map<id,AIA_Benefits__c> ([select id,name,Modified__c,Benefit_Summary_Comment__c,Benefit_Custom__c,CommentCode_Custom__c,CommentCode_NonStandard__c,Benefit_Non_Standard__c from AIA_Benefits__c where id in :benefitIDs ]);

            List<AIA_Benefits__c> updateBenefitsList= new   List<AIA_Benefits__c> ();
            Map<id, List<Limitations__c>> benefitCommentsMap= new Map<id, List<Limitations__c>>();
            Map<id, List<String>> benefitCommentsStrigMap= new Map<id, List<String>>();
            Map<id, Boolean> benefitCommentsIsCustomMap= new Map<id, Boolean>();
            Map<id, Integer> benefitCommentsNonStandardCountMap = new Map<id, Integer>();
            Map<id, Integer> benefitCommentsCustomCountMap = new Map<id, Integer>();

            for(Limitations__c c:benefitCommentCodes){   
                                        
                system.debug('update comment data--'+c);
                List<Limitations__c> commentList= new List<Limitations__c>();
                List<String> commentListString= new List<String>();
                if(benefitCommentsMap.containsKey(c.Benefit__c )){
                    commentList=benefitCommentsMap.get(c.Benefit__c);
                    commentListString=benefitCommentsStrigMap.get(c.Benefit__c);
                }  
                if((c.Type__c=='MaxRow' || c.Type__c=='TierLimit' ) && (c.MaxRow_Value__c!=null && c.MaxRow_Value__c!='') && c.IsSelected__c==true){
                    commentList.add(c);
                   
                    commentListString.add(c.MaxRow_Value__c) ;
                }
                else if(c.comment_codes__c!=null && c.comment_codes__c!='' && c.IsSelected__c==true){
                    commentListString.add(c.comment_codes__c);
                    commentList.add(c);
                }
                /********************T01 change Start ***************/
                //<T03>if(c.IsCustom__c=='Yes') 
                //<T03>    benefitCommentsIsCustomMap.put(c.Benefit__c, true);
                /********************T01 change End ***************/
                benefitCommentsMap.put(c.Benefit__c, commentList);
                benefitCommentsStrigMap.put(c.Benefit__c, commentListString);
                //} 
                system.debug('c0--'+c);
                //T04 Changes
                //Check maxDuration value,ranges and update benefit to custom or non standard type.
                if(c.MaxDuration__c != null && string.ValueOf(c.MaxDuration__c) != '0'  && comentmapChk.get(c.id) == true && string.ValueOf(c.MaxDuration__c) !='' && oldcommentsCodeMap.get(c.id).MaxDuration__c != c.MaxDuration__c ){
                    system.debug('MaxDuration__c --'+c.MaxDuration__c );
                    system.debug('c--'+c);
                    if(comentmapChk.get(c.id) == true && (c.MaxDuration_Low__c == 'NA' || c.MaxDuration_High__c == 'NA' || isInRange(c.MaxDuration__c,c.MaxDuration_Increment__c,c.MaxDuration_High__c,c.MaxDuration_Low__c))){
                        if(!benefitCommentsNonStandardCountMap.containsKey(c.Benefit__c)){
                            benefitCommentsNonStandardCountMap.put(c.Benefit__c, 1);
                        }else{                      
                            benefitCommentsNonStandardCountMap.put(c.Benefit__c, benefitCommentsNonStandardCountMap.get(c.Benefit__c)+1);
                        }
                    }else if( (c.MaxDuration_Low__c != 'NA' && c.MaxDuration_High__c != 'NA'&& c.MaxDuration_Low__c!='' && c.MaxDuration_High__c!='' && String.isNotBlank(c.MaxDuration_Low__c) && String.isNotBlank(c.MaxDuration_High__c)) ||  !isInRange2(comentmapChk.get(c.id),c.MaxDuration__c,c.MaxDuration_Increment__c,c.MaxDuration_High__c,c.MaxDuration_Low__c)){
                        system.debug('benefitCommentsCustomCountMap.containsKey(c.Benefit__c)>>>'+benefitCommentsCustomCountMap.containsKey(c.Benefit__c));
                        if(!benefitCommentsCustomCountMap.containsKey(c.Benefit__c)){
                            benefitCommentsCustomCountMap.put(c.Benefit__c, 1);
                        }else{                      
                            benefitCommentsCustomCountMap.put(c.Benefit__c, benefitCommentsCustomCountMap.get(c.Benefit__c)+1);
                        }
                    }
                }
                //Check MaxValue value,ranges and update benefit to custom or non standard type.
                if(c.MaxValue__c != null && comentmapChk.get(c.id) == true && string.ValueOf(c.MaxValue__c) != '0' && string.ValueOf(c.MaxValue__c) !='' && oldcommentsCodeMap.get(c.id).MaxValue__c != c.MaxValue__c){
                    system.debug('MaxValue__c--'+c.MaxValue__c);
                    if(comentmapChk.get(c.id) == true && (c.MaxValue_Low__c == 'NA' || c.MaxValue_High__c == 'NA' || isInRange(c.MaxValue__c,c.MaxValue_Increment__c,c.MaxValue_High__c,c.MaxValue_Low__c))){
                        if(!benefitCommentsNonStandardCountMap.containsKey(c.Benefit__c)){
                            benefitCommentsNonStandardCountMap.put(c.Benefit__c, 1);
                        }else{                      
                            benefitCommentsNonStandardCountMap.put(c.Benefit__c, benefitCommentsNonStandardCountMap.get(c.Benefit__c)+1);
                        }
                    }else if( (c.MaxValue_Low__c != 'NA' && c.MaxValue_High__c != 'NA' && c.MaxValue_Low__c!='' && c.MaxValue_High__c!='' && String.isNotBlank(c.MaxValue_High__c) && String.isNotBlank(c.MaxValue_Low__c)) || !isInRange2(comentmapChk.get(c.id),c.MaxDuration__c,c.MaxValue_Increment__c,c.MaxDuration_High__c,c.MaxDuration_Low__c)){
                        if(!benefitCommentsCustomCountMap.containsKey(c.Benefit__c)){
                            benefitCommentsCustomCountMap.put(c.Benefit__c, 1);
                        }else{                      
                            benefitCommentsCustomCountMap.put(c.Benefit__c, benefitCommentsCustomCountMap.get(c.Benefit__c)+1);
                        }
                    }
                }

            }
            //T04 changes end
            

            for(id b:benefitCommentsStrigMap.keySet() ){

                List<String> commentList=benefitCommentsStrigMap.get(b);
                String AllCommentCodes='';
                List<String> commentList2 = new List<String>();
                if(commentList.size()>0) {
                //T05 changes start
                for(string a:commentList){
                  a=  (a.contains('<br>')?a.replace('<br>','\n- '):a);
                  commentList2.add(a);
                }
                //T05 changes end
                    AllCommentCodes='- '+string.join(commentList2,'\n- ');
                    }

                AIA_Benefits__c ben=new AIA_Benefits__c();
                if(benfitdata.containsKey(b) ) {
                    ben=benfitdata.get(b);
                    if(ben.Benefit_Summary_Comment__c!=AllCommentCodes){
                        ben.Benefit_Summary_Comment__c=AllCommentCodes;
                    }
                    /********************T01 change Start ***************/
                    if(benefitCommentsIsCustomMap.containsKey(b))
                        ben.Modified__c=true;
                    else
                        ben.Modified__c=false;
                    /*********************T01 change end ******************/
                    updateBenefitsList.add(ben);

                }
            }
            
            //T04 changes start
            //check if map is empty or not. If not, check if the benefit is in map keyset and its value is grater than zero, update product type accordingly
            if(!benefitCommentsCustomCountMap.isEmpty()){
                for(id bn : benefitCommentsCustomCountMap.keySet()){
                    if(benefitCommentsCustomCountMap.get(bn) > 0){
                        AIA_Benefits__c ben=new AIA_Benefits__c();
                        if(benfitdata.containsKey(bn) ) {
                            ben = benfitdata.get(bn);
                            for(AIA_Benefits__c benft : updateBenefitsList){
                                if(ben.id == benft.id){
                                    //AIA_BenefitTriggerHandler.UpdatecustomizedProperties=false;
                                    benft.CommentCode_Custom__c = true;
                                    benft.CommentCode_NonStandard__c = false;
                                }
                            }
                            
                        }
                    }   
                }
            }else if(!benefitCommentsNonStandardCountMap.isEmpty()){
                for(id bn : benefitCommentsNonStandardCountMap.keySet()){
                    if(benefitCommentsNonStandardCountMap.get(bn) > 0){
                        AIA_Benefits__c ben=new AIA_Benefits__c();
                        if(benfitdata.containsKey(bn) ) {
                            ben=benfitdata.get(bn);
                            for(AIA_Benefits__c benft : updateBenefitsList){
                                if(ben.id == benft.id){
                                    //benft.Benefit_Custom__c = false;
                                    //benft.Benefit_Non_Standard__c = true;
                                    //AIA_BenefitTriggerHandler.UpdatecustomizedProperties=false;
                                    benft.CommentCode_Custom__c = false;
                                    benft.CommentCode_NonStandard__c = true;
                                }
                               
                            }
                        }
                    }   
                }
            }
            
            system.debug('uupdate lis--'+updateBenefitsList.size());
            if(updateBenefitsList.size()>0)
                update updateBenefitsList;
        }

    }
    
    private static boolean isMultipleofActual (integer currentvalue,Integer Increment)
    {
      //checking if the selected value is a Increment or Out od range
        while ( currentvalue > 0 )
            currentvalue = currentvalue - Increment;
        
        if ( currentvalue == 0 )
            return true;
        
        return false;
    }
    
    //T04 changes end
    private static boolean isInRange(Decimal currentvalue,String Increment,String maxValue,String minValuse)
    {
        system.debug('currentvalue:'+currentvalue+'; Increment'+Increment+'; maxValue'+maxValue+'; minValuse'+minValuse);
        if(currentvalue != null && Increment != 'NA' && String.isNotBlank(Increment) && maxValue != 'NA' && String.isNotBlank(maxValue) && minValuse != 'NA' && String.isNotBlank(minValuse)){
            system.debug('currentvalue:'+currentvalue);
            if(Integer.valueOf(currentvalue) >= Integer.valueOf(minValuse) && Integer.valueOf(currentvalue) <= Integer.valueOf(maxValue) && isMultipleofActual (Integer.valueOf(currentvalue),Integer.valueOf(Increment))) {
               system.debug('minValuse:'+minValuse);
                return true;
            }
        }   
        
        return false;
    }
    public static boolean isInRange2(Boolean isUpate,Decimal currentvalue,String Increment,String maxValue,String minValuse)
    {
        system.debug('currentvalue:'+currentvalue+'; Increment'+Increment+'; maxValue'+maxValue+'; minValuse'+minValuse);
        if(isUpate){
            if(currentvalue != null && Increment != 'NA' && String.isNotBlank(Increment) && maxValue != 'NA' && String.isNotBlank(maxValue) && minValuse != 'NA' && String.isNotBlank(minValuse)){
                system.debug('currentvalue:'+currentvalue);
                if(Integer.valueOf(currentvalue) >= Integer.valueOf(minValuse) && Integer.valueOf(currentvalue) <= Integer.valueOf(maxValue) && isMultipleofActual (Integer.valueOf(currentvalue),Integer.valueOf(Increment))) {
                   system.debug('minValuse:'+minValuse);
                    return true;
                }
            }   
            
            return false;
        }else{
            return true;
        }   
    }
    // T02 Bill, Deleted adjustement summary code no longer used.    
    
}