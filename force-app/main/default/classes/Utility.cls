global class Utility {

    public class DetailRecords{
        public string x_id;
        public boolean replacement;
        public integer quantity;
        public string name;
        public integer maintenanceperiod;
        public integer lifespan;
        public integer cost;
        public string sku;
        // public id Id
        // public boolean Replacement_Part__c
        // public number Cost__c
        // public number Current_Inventory__c
        // public number Lifespan_Months__c
        // public number Maintenance_Cycle__c
        // public string Warehouse_SKU__c

    }

    public static Utility parse(String json) {
		return (Utility) System.JSON.deserialize(json, Utility.class);
	}
}