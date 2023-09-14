@IsTest
public class ParseEquipmentTest {
	
	static testMethod void testParse() {
		StaticResource fakeResponse = [SELECT Id, SystemModStamp, Body
                                  FROM StaticResource 
                                  WHERE Name = 'Warehouse_Callout_Mock'
                                  LIMIT 1];

		String stringResponse =  string.valueOf(fakeResponse.Body);
		List<ParseEquipment> r = ParseEquipment.parse(stringResponse);
		System.assert(r != null);

		stringResponse = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ParseEquipment ParseEquipmentList = new ParseEquipment(System.JSON.createParser(stringResponse));
		System.assert(ParseEquipmentList != null);
		System.assert(ParseEquipmentList.x_id == null);
		System.assert(ParseEquipmentList.replacement == null);
		System.assert(ParseEquipmentList.quantity == null);
		System.assert(ParseEquipmentList.name == null);
		System.assert(ParseEquipmentList.maintenanceperiod == null);
		System.assert(ParseEquipmentList.lifespan == null);
		System.assert(ParseEquipmentList.cost == null);
		System.assert(ParseEquipmentList.sku == null);
	}
}