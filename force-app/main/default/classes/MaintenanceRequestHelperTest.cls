@isTest
private class MaintenanceRequestHelperTest {

    @TestVisible private static Integer num;

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
}