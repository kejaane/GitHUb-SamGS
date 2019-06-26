/*=============================================================================================================
 * Date         : 29/06/2017
 * Developer    : Rajesh Pennam
 * Purpose      : This class has the logic for population of Ancillary Products to Medical Product         
 *=============================================================================================================
 *                                 Update History
 *                                 ---------------
 * Date        | Developer      | Tag  | Description
 *============================================================================================================
 * 06/27/2017  | Rajesh Pennam  |  T01 | Added a method AIARelatedAncillaryProductDrawloop that is used for Drawloop 
                                         for auto population of Ancillary Prodcuts to Medical Product and 
                                         commented the unwanted logic                                                            
 *============================================================================================================
 */


public without sharing class AIARelatedAncillaryProductDrawloop {
    //This method will be executed when the Ancillary products are inserted for the related Medical Product
    public static void UpdateBDPFields(list<AIA_Benefit_Design_Product__c> BdList1){
        Map <id,list<AIA_Benefit_Design_Product__c>> BdpMap= new  Map<id,list<AIA_Benefit_Design_Product__c>>();
        map<id,list<string>> pwdmap=new map<id,list<string>>();
        map<id,AIA_Benefit_Design_Product__c> lstbdp=new map<id,AIA_Benefit_Design_Product__c>();
        
        system.debug('Values in BdList'+BdList1);
            if(BdList1 != Null){
                list<string> lstnam=new list<string>();
                for(AIA_Benefit_Design_Product__c bdp : BdList1 ){
                    if(bdp.Related_Medical_Product__c !=null){
                        system.debug('--Related_Medical_Product__c----');
                        if(pwdmap.containskey(bdp.Related_Medical_Product__c)){
                            lstnam=new list<string>();
                            system.debug('--key----');
                            if(pwdmap.containsKey(bdp.Related_Medical_Product__c)){
                                    lstnam=pwdmap.get(bdp.Related_Medical_Product__c);
                                    lstnam.add(bdp.name);
                                    pwdmap.put(bdp.Related_Medical_Product__c,lstnam);  
                            }
                        }else {
                            lstnam.add(bdp.name);
                            pwdmap.put(bdp.Related_Medical_Product__c,lstnam);
                        }
                                
                    }
                    system.debug('++lstnam++'+lstnam);
                                         
                }  system.debug('--pwdmap----'+pwdmap+'--pwdmap.key----'+pwdmap.keyset() +'------'+pwdmap.values());
                    for(AIA_Benefit_Design_Product__c dp:[select id,name,drawloop_product__c from AIA_Benefit_Design_Product__c  where id IN:pwdmap.keyset()]){
                        for(string nam:pwdmap.get(dp.id)){
                            if(dp.drawloop_product__c ==null){
                                dp.drawloop_product__c=nam;
                                lstbdp.put(dp.id,dp);
                            }else if(dp.drawloop_product__c !=null){
                            dp.drawloop_product__c = dp.drawloop_product__c+'\r\n'+nam;
                            lstbdp.put(dp.id,dp);
                            }
                        }
                    }
                    system.debug('--lstbdp----'+lstbdp+'----key---'+ lstbdp.keyset()+'--val---'+lstbdp.values());
                    if(!lstbdp.isEmpty()){
                        try{
                             AIA_AdjustmentSummaryUtils.disableAdjustmentSummary();   
                             update lstbdp.values();
                             AIA_AdjustmentSummaryUtils.enableAdjustmentSummary();
                        }catch(exception e){}
                            
                    }
                   
                }
            }
            
            //This method will execute for the delete functionality, when a anciallry product is deleted then the list in the related 
            //Medical product will be updated
            
        public static void deleteBDPFields(list<AIA_Benefit_Design_Product__c> BdList1){
        Map <id,list<AIA_Benefit_Design_Product__c>> BdpMap= new  Map<id,list<AIA_Benefit_Design_Product__c>>();
        map<id,list<string>> pwdmap=new map<id,list<string>>();
        list<AIA_Benefit_Design_Product__c> lstbdp=new list<AIA_Benefit_Design_Product__c>();
        
        system.debug('Values in BdList'+BdList1);
            if(BdList1 != Null){
                list<string> lstnam=new list<string>();
                for(AIA_Benefit_Design_Product__c bdp : BdList1 ){
                    if(bdp.Related_Medical_Product__c !=null){
                    
                        if(pwdmap.containskey(bdp.Related_Medical_Product__c)){
                        lstnam=new list<string>();
                            if(pwdmap.get(bdp.Related_Medical_Product__c) !=null){
                                    lstnam=pwdmap.get(bdp.Related_Medical_Product__c);
                                    lstnam.add(bdp.name);
                                pwdmap.put(bdp.Related_Medical_Product__c,lstnam);  
                            }
                        }else {
                            lstnam.add(bdp.name);
                            pwdmap.put(bdp.Related_Medical_Product__c,lstnam);
                        }
                                
                    }
                                         
                }
                    for(AIA_Benefit_Design_Product__c dp:[select id,name,drawloop_product__c from AIA_Benefit_Design_Product__c  where id IN:pwdmap.keyset()]){
                        for(string nam:pwdmap.get(dp.id)){
                           if(dp.drawloop_product__c !=null){
                               if(!string.isblank(nam)){
                                    dp.drawloop_product__c = dp.drawloop_product__c.remove(nam);
                                }
                            lstbdp.add(dp);
                            }
                        }
                    }
                    if(!lstbdp.isEmpty()){
                        try{
                            AIA_AdjustmentSummaryUtils.disableAdjustmentSummary(); 
                            update lstbdp;
                            AIA_AdjustmentSummaryUtils.enableAdjustmentSummary(); 
                        }catch(exception e){}
                        
                    }
                   
                }
            }
    }