trigger MaintenanceRequest on Case (before update, after update) {
    // if(trigger.isBefore && trigger.isUpdate){
    // MaintenanceRequestHelper.createWorkOrders(Trigger.newMap);
    // }
    if(trigger.isAfter && trigger.isUpdate){
        MaintenanceRequestHelper.createWorkOrders(Trigger.newMap);
    }
}