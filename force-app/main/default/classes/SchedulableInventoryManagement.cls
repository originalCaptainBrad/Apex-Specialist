global class SchedulableInventoryManagement implements schedulable {

    global void execute(SchedulableContext sc){
        SynchronizeInventoryManagement e = new SynchronizeInventoryManagement();
        Database.executeBatch(e);

    }


}