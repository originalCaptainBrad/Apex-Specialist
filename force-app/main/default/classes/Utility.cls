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
    }

    public static Utility parse(String json) {
		return (Utility) System.JSON.deserialize(json, Utility.class);
	}
}