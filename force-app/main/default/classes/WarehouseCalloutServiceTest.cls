@isTest
private class WarehouseCalloutServiceTest {

    @isTest
    static void testExecute() {

        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'Warehouse_Callout_Mock' LIMIT 1];
        String mockResponse = '[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"Cooling Fan","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"},{"_id":"55d66226726b611100aaf743","replacement":true,"quantity":143,"name":"Fuse 20A","maintenanceperiod":0,"lifespan":0,"cost":22,"sku":"100005"},{"_id":"55d66226726b611100aaf744","replacement":false,"quantity":5,"name":"Generator 2000 kw","maintenanceperiod":365,"lifespan":120,"cost":6000,"sku":"100006"},{"_id":"55d66226726b611100aaf745","replacement":true,"quantity":142,"name":"Fuse 25A","maintenanceperiod":0,"lifespan":0,"cost":28,"sku":"100007"},{"_id":"55d66226726b611100aaf746","replacement":true,"quantity":122,"name":"Fuse 13A","maintenanceperiod":0,"lifespan":0,"cost":10,"sku":"100008"},{"_id":"55d66226726b611100aaf747","replacement":true,"quantity":90,"name":"Ball Valve 10 cm","maintenanceperiod":0,"lifespan":0,"cost":50,"sku":"100009"}]';
        // Create a test record for External_Equipment_Integration__mdt
        External_Equipment_Integration__mdt mdtRecord =
            [SELECT Api_Endpoint__c, List_Of_Equipment__c 
             FROM External_Equipment_Integration__mdt 
             LIMIT 1];

        mdtRecord.List_Of_Equipment__c = mockResponse;
 
        TestDataFactory.generateMaintanceRequestdata(10);


        // Create an instance of the Queueable class
        WarehouseCalloutService calloutService = new WarehouseCalloutService();

        // Enqueue the Queueable job
        Test.startTest();
        System.enqueueJob(calloutService);
        Test.stopTest();

        // // Verify that the product2 record was updated
        // Product2 updatedProduct = [SELECT Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c FROM Product2 WHERE Id = :product.Id];
        // System.assertEquals('Replacement Part 1', updatedProduct.Replacement_Part__c);
        // System.assertEquals(50, updatedProduct.Cost__c);
        // System.assertEquals(100, updatedProduct.Current_Inventory__c);
        // System.assertEquals(24, updatedProduct.Lifespan_Months__c);
        // System.assertEquals(6, updatedProduct.Maintenance_Cycle__c);
    }

    @isTest
    static void testMakeCallout(){

         String mockResponses = '[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"Cooling Fan","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"},{"_id":"55d66226726b611100aaf743","replacement":true,"quantity":143,"name":"Fuse 20A","maintenanceperiod":0,"lifespan":0,"cost":22,"sku":"100005"},{"_id":"55d66226726b611100aaf744","replacement":false,"quantity":5,"name":"Generator 2000 kw","maintenanceperiod":365,"lifespan":120,"cost":6000,"sku":"100006"},{"_id":"55d66226726b611100aaf745","replacement":true,"quantity":142,"name":"Fuse 25A","maintenanceperiod":0,"lifespan":0,"cost":28,"sku":"100007"},{"_id":"55d66226726b611100aaf746","replacement":true,"quantity":122,"name":"Fuse 13A","maintenanceperiod":0,"lifespan":0,"cost":10,"sku":"100008"},{"_id":"55d66226726b611100aaf747","replacement":true,"quantity":90,"name":"Ball Valve 10 cm","maintenanceperiod":0,"lifespan":0,"cost":50,"sku":"100009"}]';
        // Create a test record for External_Equipment_Integration__mdt
        External_Equipment_Integration__mdt mdtRecord =
            [SELECT Api_Endpoint__c, List_Of_Equipment__c 
             FROM External_Equipment_Integration__mdt 
             LIMIT 1];

        mdtRecord.List_Of_Equipment__c = mockResponses;

        Test.startTest();
        HttpResponse httpBody = WarehouseCalloutService.makeCallout();
        Test.stopTest();

        String responseBody = httpBody.getBody();

        Boolean responseFlag = false;

        if(responseBody == mockResponses){
            responseFlag = true; 
        }

        
    }

    @isTest
    static void testParseNewInventory(){
                 String mockResponses = '[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"Cooling Fan","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"},{"_id":"55d66226726b611100aaf743","replacement":true,"quantity":143,"name":"Fuse 20A","maintenanceperiod":0,"lifespan":0,"cost":22,"sku":"100005"},{"_id":"55d66226726b611100aaf744","replacement":false,"quantity":5,"name":"Generator 2000 kw","maintenanceperiod":365,"lifespan":120,"cost":6000,"sku":"100006"},{"_id":"55d66226726b611100aaf745","replacement":true,"quantity":142,"name":"Fuse 25A","maintenanceperiod":0,"lifespan":0,"cost":28,"sku":"100007"},{"_id":"55d66226726b611100aaf746","replacement":true,"quantity":122,"name":"Fuse 13A","maintenanceperiod":0,"lifespan":0,"cost":10,"sku":"100008"},{"_id":"55d66226726b611100aaf747","replacement":true,"quantity":90,"name":"Ball Valve 10 cm","maintenanceperiod":0,"lifespan":0,"cost":50,"sku":"100009"}]';


        List<JSON2Apex> parseEquipment = JSON2Apex.parse(mockResponses);
        list<product2> products = WarehouseCalloutService.parseNewInventory(parseEquipment);
        upsert products;

        Test.startTest();
        list<product2> lstproducts = WarehouseCalloutService.parseNewInventory(parseEquipment);
        Test.stopTest();
    }
}
