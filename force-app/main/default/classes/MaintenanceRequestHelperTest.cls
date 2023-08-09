@isTest
private class MaintenanceRequestHelperTest {

    @isTest
    static void testCreateWorkOrders() {
        // Create test data

        Vehicle__c testVehicle = new Vehicle__c(
            name='Test Car'
        );

        insert testVehicle;

        Case testRequest = new Case(
            Type = 'Routine Maintenance',
            Status = 'New',
            Vehicle__c = testVehicle.Id,
            Product__c = 'Test Product',
            Subject = 'Test Subject'
        );
        insert testRequest;

        Product2 equipment = new Product2(
            Name ='Test Equipment',
            Replacement_Part__c = true
        );
        insert equipment;

        Equipment_Maintenance_Item__c testItem = new Equipment_Maintenance_Item__c(
            Maintenance_Request__c = testRequest.Id,
            Equipment__c = equipment.Id
        );
        insert testItem;

        // Test the trigger handler method
        Test.startTest();
        testRequest.Status = 'Closed';
        update testRequest;
        Test.stopTest();

        // Verify records are created
        List<Case> newCases = [SELECT Id FROM Case WHERE Vehicle__c = :testRequest.Vehicle__c AND Product__c = :testRequest.Product__c AND Type = 'Routine Maintenance' AND Status = 'New'];
        System.assertEquals(1, newCases.size());

        List<Equipment_Maintenance_Item__c> itemRecords = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c = :newCases[0].Id];
        System.assertEquals(1, itemRecords.size());
    }

    @isTest
    static void testGetMapRequestToItems() {
        Case testRequest = new Case(Type = 'Routine Maintenance', Status = 'Closed');
        insert testRequest;

        Equipment_Maintenance_Item__c testItem = new Equipment_Maintenance_Item__c(Maintenance_Request__c = testRequest.Id);
        insert testItem;

        Set<Id> testRequestIds = new Set<Id>{testRequest.Id};

        Test.startTest();
        Map<String, List<Equipment_Maintenance_Item__c>> resultMap = MaintenanceRequestHelper.getMapRequestToItems(testRequestIds);
        Test.stopTest();

        List<Equipment_Maintenance_Item__c> itemsList = resultMap.get(testRequest.Id);
        System.assertNotEquals(null, itemsList);
        System.assertEquals(1, itemsList.size());
    }

    @isTest
    static void testCreateEquipmentItems() {
        Case testCase = new Case(Type = 'Routine Maintenance', Status = 'Closed');
        insert testCase;

        Product2 equipment = new Product2(
            Name ='Test Equipment',
            Replacement_Part__c = true
        );
        insert equipment;

        Equipment_Maintenance_Item__c testItem = new Equipment_Maintenance_Item__c(
            Maintenance_Request__c = testCase.Id,
            Equipment__c = equipment.Id,
            Quantity__c = 2
        );
        insert testItem;

        Map<String, Case> oldToNewCaseMap = new Map<String, Case>{testCase.Id => testCase};
        Map<String, List<Equipment_Maintenance_Item__c>> requestToItemsMap = new Map<String, List<Equipment_Maintenance_Item__c>>{testCase.Id => new List<Equipment_Maintenance_Item__c>{testItem}};

        Test.startTest();
        List<Equipment_Maintenance_Item__c> newItemList = MaintenanceRequestHelper.createEquipmentItems(oldToNewCaseMap, requestToItemsMap);
        Test.stopTest();

        System.assertEquals(1, newItemList.size());
        Equipment_Maintenance_Item__c newItem = newItemList[0];
        System.assertEquals(testCase.Id, newItem.Maintenance_Request__c);
        System.assertEquals(testItem.Equipment__c, newItem.Equipment__c);
        System.assertEquals(testItem.Quantity__c, newItem.Quantity__c);
    }
}
