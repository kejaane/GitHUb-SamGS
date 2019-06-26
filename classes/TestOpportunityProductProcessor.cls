/**
 *  @Author: Acumen Solutions
 *  @Purpose: Test Class for OpportunityProcessorManager Class, OpportunityProductProcessor Trigger
 **/
@isTest
private class TestOpportunityProductProcessor {

   static testMethod void testOpportunityProductInsert() {
        
        List<OpportunityLineItem> oppProducts = new List<OpportunityLineItem>() ;
 
        Account acc = new Account();
        acc.Name = 'Test Account1';
        insert acc ;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(2012, 1, 1);
        testOpp.Name = 'Test Opportunity1';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';
        testOpp.CloseDate = closedDate;
        testOpp.GeneralProducer__c = 'Direct';
//TPB - 12/19/2013        
        Date effectiveDate = closedDate.addDays(60);        
        testOpp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = testOpp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp.Contract_End_Date__c = contractEndDate;           
        
        insert testOpp ;
                        
        PricebookEntry[] proceBookEntry = [ Select p.Name,  p.Id , p.IsActive From PricebookEntry p  where p.IsActive = true limit 3];

        OpportunityLineItem oppProduct1 = new OpportunityLineItem();
        oppProduct1.OpportunityId = testOpp.id;
        oppProduct1.PricebookEntryId = proceBookEntry[0].Id;
        oppProduct1.Product_Sold__c = false;
        oppProduct1.Quantity = 10.00 ;
        oppProduct1.TotalPrice = 100.00;
        oppProducts.add(oppProduct1) ;
        
        OpportunityLineItem oppProduct2 = new OpportunityLineItem();
        oppProduct2.OpportunityId = testOpp.id;
        oppProduct2.PricebookEntryId = proceBookEntry[1].Id;
        oppProduct2.Product_Sold__c = true;
        oppProduct2.Quantity = 10.00 ;
        oppProduct2.TotalPrice = 100.00;
        oppProducts.add(oppProduct2) ;
        
        OpportunityLineItem oppProduct3 = new OpportunityLineItem();
        oppProduct3.OpportunityId = testOpp.id;
        oppProduct3.PricebookEntryId = proceBookEntry[2].Id;
        oppProduct3.Product_Sold__c = true;
        oppProduct3.Quantity = 10.00 ;
        oppProduct3.TotalPrice = 100.00;
        oppProducts.add(oppProduct3) ;

        test.startTest();
        insert oppProducts;
        test.stopTest();
        
        Set<id> productCreated = new set<id>();
        for(OpportunityLineItem pro:oppProducts){
            productCreated.add(pro.id);
        }

        List<OpportunityLineItem> lineItems = [ select id , PricebookEntryId, OpportunityId, Product_Sold__c, Quantity ,TotalPrice 
                                                from OpportunityLineItem 
                                                where id in:productCreated ];
                                                                                            
        for (OpportunityLineItem lineItem:lineItems){
            System.assertEquals(lineItem.Quantity, 10.00);
            System.assertEquals(lineItem.TotalPrice, 100.00);
            if(lineItem.PricebookEntryId == proceBookEntry[0].Id){
                System.assertEquals(lineItem.Product_Sold__c , false);      
            }
            else{
                System.assertEquals(lineItem.Product_Sold__c , true);
            }
        }                                       
        
        Opportunity opp1 = [select id , name , 
                            Related_Products_Offered__c ,Related_Products_Offered_Quantity__c ,
                            Related_Products_Sold__c ,Related_Products_Sold_Quantity__c 
                            from Opportunity where id=: testOpp.id];
        
        system.assertNotEquals(opp1.Related_Products_Offered__c, null); 
        system.assertNotEquals(opp1.Related_Products_Offered_Quantity__c, null);    
        system.assertNotEquals(opp1.Related_Products_Sold__c, null);    
        system.assertNotEquals(opp1.Related_Products_Sold_Quantity__c, null);                   
                        
    }
    
     static testMethod void testOpportunityProductDelete() {
        
        List<OpportunityLineItem> oppProducts = new List<OpportunityLineItem>() ;
 
        Account acc = new Account();
        acc.Name = 'Test Account2';
        insert acc ;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(2012, 1, 1);
        testOpp.Name = 'Test Opportunity2';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';
        testOpp.CloseDate = closedDate;
        testOpp.GeneralProducer__c = 'Direct';
//TPB - 12/19/2013        
        Date effectiveDate = closedDate.addDays(60);        
        testOpp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = testOpp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp.Contract_End_Date__c = contractEndDate;           
        
        insert testOpp ;
                        
        PricebookEntry[] proceBookEntry = [ Select p.Name,  p.Id , p.IsActive From PricebookEntry p  where p.IsActive = true limit 3];

        
        OpportunityLineItem oppProduct1 = new OpportunityLineItem();
        oppProduct1.OpportunityId = testOpp.id;
        oppProduct1.PricebookEntryId = proceBookEntry[0].Id;
        oppProduct1.Product_Sold__c = false;
        oppProduct1.Quantity = 10.00 ;
        oppProduct1.TotalPrice = 100.00;
        oppProducts.add(oppProduct1) ;
        
        OpportunityLineItem oppProduct2 = new OpportunityLineItem();
        oppProduct2.OpportunityId = testOpp.id;
        oppProduct2.PricebookEntryId = proceBookEntry[1].Id;
        oppProduct2.Product_Sold__c = true;
        oppProduct2.Quantity = 10.00 ;
        oppProduct2.TotalPrice = 100.00;
        oppProducts.add(oppProduct2) ;
        
        OpportunityLineItem oppProduct3 = new OpportunityLineItem();
        oppProduct3.OpportunityId = testOpp.id;
        oppProduct3.PricebookEntryId = proceBookEntry[2].Id;
        oppProduct3.Product_Sold__c = true;
        oppProduct3.Quantity = 10.00 ;
        oppProduct3.TotalPrice = 100.00;
        oppProducts.add(oppProduct3) ;

        insert oppProducts;
          
        Set<id> productCreated = new set<id>();
        for(OpportunityLineItem pro:oppProducts){
            productCreated.add(pro.id);
        }

        List<OpportunityLineItem> lineItems = [ select id , PricebookEntryId, OpportunityId, Product_Sold__c, Quantity ,TotalPrice 
                                                from OpportunityLineItem 
                                                where id in:productCreated ];
                                                                                            
        for (OpportunityLineItem lineItem:lineItems){
            System.assertEquals(lineItem.Quantity, 10.00);
            System.assertEquals(lineItem.TotalPrice, 100.00);
            if(lineItem.PricebookEntryId == proceBookEntry[0].Id){
                System.assertEquals(lineItem.Product_Sold__c , false);      
            }
            else{
                System.assertEquals(lineItem.Product_Sold__c , true);
            }
        }                                        
       test.startTest();
       delete oppProduct1;
       test.stopTest();
        
        Opportunity opp2 = [select id , name , 
                            Related_Products_Offered__c ,Related_Products_Offered_Quantity__c ,
                            Related_Products_Sold__c ,Related_Products_Sold_Quantity__c 
                            from Opportunity where id=: testOpp.id];
        
        system.assertNotEquals(opp2.Related_Products_Offered__c, null);    
        system.assertNotEquals(opp2.Related_Products_Offered_Quantity__c, null);   
        system.assertNotEquals(opp2.Related_Products_Sold__c, null);    
        system.assertNotEquals(opp2.Related_Products_Sold_Quantity__c, null);
        
    }
    
     static testMethod void testOpportunityProductUpdate() {
        List<OpportunityLineItem> oppProducts = new List<OpportunityLineItem>() ;
 
        Account acc = new Account();
        acc.Name = 'Test Account3';
        insert acc ;
        
        Opportunity testOpp = new Opportunity();
        Date closedDate = date.newinstance(2012, 1, 1);
        testOpp.Name = 'Test Opportunity3';
        testOpp.AccountId = acc.Id ;
        testOpp.StageName ='Proposal';
        testOpp.CloseDate = closedDate;
        testOpp.GeneralProducer__c = 'Direct';
//TPB - 12/19/2013        
        Date effectiveDate = closedDate.addDays(60);        
        testOpp.Effective_Date__c = Date.newInstance(effectiveDate.Year(), effectiveDate.Month(),1);
        Date contractEndDate = testOpp.Effective_Date__c+365;
        contractEndDate = Date.newInstance(contractEndDate.Year(), contractEndDate.Month(), 1);
        contractEndDate = contractEndDate.addDays(-1);
        testOpp.Contract_End_Date__c = contractEndDate;           
        
        insert testOpp ;
                        
        PricebookEntry[] proceBookEntry = [ Select p.Name,  p.Id , p.IsActive From PricebookEntry p  where p.IsActive = true limit 3];
        
        OpportunityLineItem oppProduct1 = new OpportunityLineItem();
        oppProduct1.OpportunityId = testOpp.id;
        oppProduct1.PricebookEntryId = proceBookEntry[0].Id;
        oppProduct1.Product_Sold__c = false;
        oppProduct1.Quantity = 10.00 ;
        oppProduct1.TotalPrice = 100.00;
        oppProducts.add(oppProduct1) ;
        
        OpportunityLineItem oppProduct2 = new OpportunityLineItem();
        oppProduct2.OpportunityId = testOpp.id;
        oppProduct2.PricebookEntryId = proceBookEntry[1].Id;
        oppProduct2.Product_Sold__c = true;
        oppProduct2.Quantity = 10.00 ;
        oppProduct2.TotalPrice = 100.00;
        oppProducts.add(oppProduct2) ;
        
        OpportunityLineItem oppProduct3 = new OpportunityLineItem();
        oppProduct3.OpportunityId = testOpp.id;
        oppProduct3.PricebookEntryId = proceBookEntry[2].Id;
        oppProduct3.Product_Sold__c = true;
        oppProduct3.Quantity = 10.00 ;
        oppProduct3.TotalPrice = 100.00;
        oppProducts.add(oppProduct3) ;

        insert oppProducts;
        
        Set<id> productCreated = new set<id>();
        for(OpportunityLineItem pro:oppProducts){
            productCreated.add(pro.id);
        }

        List<OpportunityLineItem> lineItems = [ select id , PricebookEntryId, OpportunityId, Product_Sold__c, Quantity ,TotalPrice 
                                                from OpportunityLineItem 
                                                where id in:productCreated ];
                                                                                            
        for (OpportunityLineItem lineItem:lineItems){
            System.assertEquals(lineItem.Quantity, 10.00);
            System.assertEquals(lineItem.TotalPrice, 100.00);
            if(lineItem.PricebookEntryId == proceBookEntry[0].Id){
                System.assertEquals(lineItem.Product_Sold__c , false);      
            }
            else{
                System.assertEquals(lineItem.Product_Sold__c , true);
            }
        }                                       
         oppProduct2.Product_Sold__c = false;
        
       test.startTest();
       update oppProduct2 ;
       test.stopTest();
       
        
        Opportunity opp3 = [select id , name , 
                            Related_Products_Offered__c ,Related_Products_Offered_Quantity__c ,
                            Related_Products_Sold__c ,Related_Products_Sold_Quantity__c 
                            from Opportunity where id=: testOpp.id];
                            
        system.assertNotEquals(opp3.Related_Products_Offered__c, null); 
        system.assertNotEquals(opp3.Related_Products_Offered_Quantity__c, null);    
        system.assertNotEquals(opp3.Related_Products_Sold__c, null);    
        system.assertNotEquals(opp3.Related_Products_Sold_Quantity__c, null);
            
     }
    
}