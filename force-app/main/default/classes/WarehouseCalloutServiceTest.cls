@isTest
private class WarehouseCalloutServiceTest {

        @isTest
        static void testExecute() {
        String mockResponse = '[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"},{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"Cooling Fan","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"100004"},{"_id":"55d66226726b611100aaf743","replacement":true,"quantity":143,"name":"Fuse 20A","maintenanceperiod":0,"lifespan":0,"cost":22,"sku":"100005"},{"_id":"55d66226726b611100aaf744","replacement":false,"quantity":5,"name":"Generator 2000 kw","maintenanceperiod":365,"lifespan":120,"cost":6000,"sku":"100006"},{"_id":"55d66226726b611100aaf745","replacement":true,"quantity":142,"name":"Fuse 25A","maintenanceperiod":0,"lifespan":0,"cost":28,"sku":"100007"},{"_id":"55d66226726b611100aaf746","replacement":true,"quantity":122,"name":"Fuse 13A","maintenanceperiod":0,"lifespan":0,"cost":10,"sku":"100008"},{"_id":"55d66226726b611100aaf747","replacement":true,"quantity":90,"name":"Ball Valve 10 cm","maintenanceperiod":0,"lifespan":0,"cost":50,"sku":"100009"}]';

    
        TestDataFactory.generateMaintanceRequestdata(1);
        External_Equipment_Integration__mdt mdtRecord =
            [SELECT Api_Endpoint__c, List_Of_Equipment__c 
             FROM External_Equipment_Integration__mdt 
             LIMIT 1];

        // Create a test product2 record
        Product2 product = new Product2(
            Name = 'Test Product',
            Warehouse_SKU__c = '123',
            Replacement_Part__c = true,
            Cost__c = 100,
            Current_Inventory__c = 50,
            Lifespan_Months__c = 12,
            Maintenance_Cycle__c = 3
        );
        insert product;

        List<parseEquipment> parseEquipment = parseEquipment.parse(mockResponse);
        List<Product2> inventoriesToUpdate = WarehouseCalloutService.parseNewInventory(parseEquipment);
        for(Integer i = 0; i < 1; i++ ){
            Product2 prod = WarehouseCalloutService.updateProducts(inventoriesToUpdate[i], parseEquipment[i]);
        }
        upsert inventoriesToUpdate;

        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock(mockResponse));

        WarehouseCalloutService calloutService = new WarehouseCalloutService();

        Test.startTest();
        System.enqueueJob(calloutService);
        Test.stopTest();

        map<string,product2> productInventory = new map<string,product2>();
                for(product2 prodMap : [SELECT Id, Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, Warehouse_SKU__c FROM product2]){
            productInventory.put(prodMap.Warehouse_SKU__c, prodMap);
        }

        Product2 updatedProduct = [SELECT Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c FROM Product2 WHERE Id = :product.Id];
        System.assertEquals(true, updatedProduct.Replacement_Part__c);
        System.assertEquals(50, updatedProduct.Cost__c);
        System.assertEquals(100, updatedProduct.Current_Inventory__c);
        System.assertEquals(24, updatedProduct.Lifespan_Months__c);
        System.assertEquals(6, updatedProduct.Maintenance_Cycle__c);
    }
}
