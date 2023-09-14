@isTest
public class WarehouseSyncScheduleTest {

    @isTest
    public static void testExecute() {
        Test.startTest();
        WarehouseSyncSchedule scheduleMaintenance = new WarehouseSyncSchedule();
        SchedulableContext sc = null;
        scheduleMaintenance.execute(sc);
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM AsyncApexJob WHERE JobType = 'ScheduledApex']);
    }
}
