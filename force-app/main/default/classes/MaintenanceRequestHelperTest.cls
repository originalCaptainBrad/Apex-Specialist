@isTest
private class MaintenanceRequestHelperTest {

    @TestVisible private static Vehicle__c vehicle = new Vehicle__c();
    @TestVisible private static Case request = new Case();
    @TestVisible private static Map<Id,Case> requestMap = new Map<Id,Case>();
    @TestVisible private static Product2 equipment = new Product2();
    @TestVisible private static Equipment_Maintenance_Item__c maintanceItem = new Equipment_Maintenance_Item__c();
    @TestVisible private static Integer num = 0;

    @TestSetup
    static void setup(){
        num = 10;
        TestDataFactory.generateMaintanceRequestdata(num);
    }

    @isTest
    static void testCreateWorkOrders() {

        Test.startTest();
        Integer counter = 0;
        for(Case req : [Select Id, Vehicle__c, Product__c, Type, Subject, Status, 
                (SELECT Id, Maintenance_Request__c, Equipment__c,Equipment__r.Maintenance_Cycle__c, Quantity__c
                FROM Equipment_Maintenance_Items__r) 
                FROM Case ]){
            req.status = 'closed';
            for(Equipment_Maintenance_Item__c Equipment : req.Equipment_Maintenance_Items__r){
                counter++;
                Equipment.Equipment__r.Maintenance_Cycle__c = 30+counter;
                update Equipment;
            }
            update req;
        }
        Test.stopTest();

        List<Case> newCases = [SELECT Id FROM Case WHERE Status = 'New'];
        List<Equipment_Maintenance_Item__c> itemRecords = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c = :newCases[0].Id];
        System.assertEquals(11, itemRecords.size());
        System.assertEquals(num, newCases.size());
        System.assertNotEquals(null, newCases.size());
    }

    @isTest
    static void testGetMapRequestToItems() {

        Set<Id> requestIds = new Set<Id>();
        for(Case req : [Select Id FROM Case ]){
                requestIds.add(req.Id);
                }

        Test.startTest();
        Map<String, List<Equipment_Maintenance_Item__c>> resultMap = MaintenanceRequestHelper.getMapRequestToItems(requestIds);
        Test.stopTest();

        List<Equipment_Maintenance_Item__c> itemsList = resultMap.get(request.Id);
        System.assertNotEquals(null, itemsList);
        System.assertEquals(1, itemsList.size());
    }

    @isTest
    static void testCreateEquipmentItems() {


        Map<String, Case> oldToNewCaseMap = new Map<String, Case>{testCase.Id => testCase};
        Map<String, List<Equipment_Maintenance_Item__c>> requestToItemsMap = new Map<String, List<Equipment_Maintenance_Item__c>>{testCase.Id => new List<Equipment_Maintenance_Item__c>{maintanceItem}};

        Test.startTest();
        List<Equipment_Maintenance_Item__c> newItemList = MaintenanceRequestHelper.createEquipmentItems(oldToNewCaseMap, requestToItemsMap);
        Test.stopTest();

        System.assertEquals(1, newItemList.size());
        Equipment_Maintenance_Item__c newItem = newItemList[0];
        System.assertEquals(testCase.Id, newItem.Maintenance_Request__c);
        System.assertEquals(maintanceItem.Equipment__c, newItem.Equipment__c);
        System.assertEquals(maintanceItem.Quantity__c, newItem.Quantity__c);
    }
}
