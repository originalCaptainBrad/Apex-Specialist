@isTest
public class WarehouseSyncScheduleTest {

    @isTest
    public static void testExecute() {
        Test.startTest();
        WarehouseSyncSchedule wsSchedule = new WarehouseSyncSchedule();
        SchedulableContext sc = null;
        wsSchedule.execute(sc);
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM AsyncApexJob WHERE JobType = 'ScheduledApex']);
    }
}
