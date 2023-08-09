@isTest
private class MaintenanceRequestHelperTest {

    @isTest
    static void testCreateWorkOrders() {
        // Create test data
        Case testCase = new Case(
            Type = 'Routine Maintenance',
            Status = 'New',
            Vehicle__c = 'Test Vehicle',
            Product__c = 'Test Product',
            Subject = 'Test Subject'
        );
        insert testCase;

        Equipment_Maintenance_Item__c testItem = new Equipment_Maintenance_Item__c(
            Maintenance_Request__c = testCase.Id,
            Equipment__c = 'Test Equipment'
        );
        insert testItem;

        Map<Id, Case> testRequests = new Map<Id, Case>{testCase.Id => testCase};

        // Test the trigger handler method
        Test.startTest();
        MaintenanceRequestHelper.createWorkOrders(testRequests);
        Test.stopTest();

        // Verify records are created
        List<Case> newCases = [SELECT Id FROM Case WHERE Vehicle__c = :testCase.Vehicle__c AND Product__c = :testCase.Product__c AND Type = 'Routine Maintenance' AND Status = 'New'];
        System.assertEquals(1, newCases.size());

        List<Equipment_Maintenance_Item__c> itemRecords = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c = :newCases[0].Id];
        System.assertEquals(1, itemRecords.size());
    }

    @isTest
    static void testGetMapRequestToItems() {
        Case testCase = new Case(Type = 'Routine Maintenance', Status = 'Closed');
        insert testCase;

        Equipment_Maintenance_Item__c testItem = new Equipment_Maintenance_Item__c(Maintenance_Request__c = testCase.Id);
        insert testItem;

        Set<Id> testRequestIds = new Set<Id>{testCase.Id};

        Test.startTest();
        Map<String, List<Equipment_Maintenance_Item__c>> resultMap = MaintenanceRequestHelper.getMapRequestToItems(testRequestIds);
        Test.stopTest();

        List<Equipment_Maintenance_Item__c> itemsList = resultMap.get(testCase.Id);
        System.assertNotEquals(null, itemsList);
        System.assertEquals(1, itemsList.size());
    }

    @isTest
    static void testCreateEquipmentItems() {
        Case testCase = new Case(Type = 'Routine Maintenance', Status = 'Closed');
        insert testCase;

        Equipment_Maintenance_Item__c testItem = new Equipment_Maintenance_Item__c(
            Maintenance_Request__c = testCase.Id,
            Equipment__c = 'Test Equipment',
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
