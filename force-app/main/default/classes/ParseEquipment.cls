public class ParseEquipment {

	public String x_id {get;set;}
	public Boolean replacement {get;set;} 
	public Integer quantity {get;set;} 
	public String name {get;set;} 
	public Integer maintenanceperiod {get;set;} 
	public Integer lifespan {get;set;} 
	public Integer cost {get;set;} 
	public String sku {get;set;} 

	public ParseEquipment(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == '_id') {
						x_id = parser.getText();
					} else if (text == 'replacement') {
						replacement = parser.getBooleanValue();
					} else if (text == 'quantity') {
						quantity = parser.getIntegerValue();
					} else if (text == 'name') {
						name = parser.getText();
					} else if (text == 'maintenanceperiod') {
						maintenanceperiod = parser.getIntegerValue();
					} else if (text == 'lifespan') {
						lifespan = parser.getIntegerValue();
					} else if (text == 'cost') {
						cost = parser.getIntegerValue();
					} else if (text == 'sku') {
						sku = parser.getText();
					}
				}
			}
		}
	}

	public static List<ParseEquipment> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfEquipment(parser);
	}

    private static List<ParseEquipment> arrayOfEquipment(System.JSONParser p) {
        List<ParseEquipment> res = new List<ParseEquipment>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ParseEquipment(p));
        }
        return res;
    }
}