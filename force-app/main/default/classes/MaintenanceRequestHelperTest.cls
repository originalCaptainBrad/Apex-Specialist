@isTest
private class MaintenanceRequestHelperTest {

    @TestVisible private static Integer num;
    @TestVisible private static List<Case> casesToUpdate = new List<Case>();
    @TestVisible private static List<Equipment_Maintenance_Item__c> equipmentItemsToUpdate = new List<Equipment_Maintenance_Item__c>();

    @TestSetup
    static void setup() {
        num = 10;
        TestDataFactory.generateMaintanceRequestdata(num);
    }

    @isTest
    static void testCreateWorkOrders() {

        Test.startTest();
        Integer counter = 0;
        for(Case req : [SELECT Id, Vehicle__c, Product__c, Type, Subject, Status, 
                    (SELECT Id, Maintenance_Request__c, Equipment__c,Equipment__r.Maintenance_Cycle__c, Quantity__c
                    FROM Equipment_Maintenance_Items__r) 
                    FROM Case]) {
                    req.Status = 'closed';
                    casesToUpdate.add(req);

                    for (Equipment_Maintenance_Item__c equipment : req.Equipment_Maintenance_Items__r) {
                        counter++;
                        equipment.Equipment__r.Maintenance_Cycle__c = 30 + counter;
                        equipmentItemsToUpdate.add(equipment);
                    }
                }

        update casesToUpdate;
        update equipmentItemsToUpdate;
        Test.stopTest();

        List<Case> newCases = [SELECT Id FROM Case WHERE Status = 'New'];
        List<Equipment_Maintenance_Item__c> itemRecords = [SELECT Id FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c = :newCases[0].Id];

        System.assertEquals(11, itemRecords.size());
        System.assertEquals(num, newCases.size());
        System.assertNotEquals(null, newCases.size());
    }
}
