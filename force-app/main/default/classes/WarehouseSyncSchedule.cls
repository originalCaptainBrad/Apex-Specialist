global class WarehouseSyncSchedule implements schedulable {
    global void execute(SchedulableContext sc) {
        WarehouseCalloutService b = new WarehouseCalloutService(); 
        System.enqueueJob(b);
    }
}