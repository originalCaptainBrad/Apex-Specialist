global class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext context) {

        HttpResponse httpBody = makeCallout();

        String responseBody = httpBody.getBody();

        List<ParseEquipment> parseEquipment = ParseEquipment.parse(responseBody);
        
        List<Product2> inventoriesToUpdate = parseNewInventory(parseEquipment);

        upsert inventoriesToUpdate;
    }

        public static HttpResponse makeCallout() {

            list<External_Equipment_Integration__mdt> mdtRecord = [
            SELECT Api_Endpoint__c, List_Of_Equipment__c 
            FROM External_Equipment_Integration__mdt];

            string endpoint = string.valueOf(mdtRecord[0].Api_Endpoint__c);
            string body;
            HttpResponse response;
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            Http http = new Http();
            response = http.send(request);
            String responseBody = response.getBody();

        return response;
    }

    public static List<Product2> parseNewInventory(List<ParseEquipment> parseItems){

        map<string,product2> productInventory = new map<string,product2>();

        for(product2 prodMap : [SELECT Id, Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, Warehouse_SKU__c FROM product2]){
            productInventory.put(prodMap.Warehouse_SKU__c, prodMap);
        }
        
        list<product2> lstInventoryToUpdate = new list<product2>();

        for(ParseEquipment equipment : parseItems){
            system.debug('Inventory = '+equipment);
            product2 productToSku = productInventory.get(equipment.sku);
            system.debug('productToSku is : '+productToSku);
            if(productToSku != null){
                productToSku.Replacement_Part__c = equipment.replacement;
                productToSku.Cost__c = equipment.cost;
                productToSku.Current_Inventory__c = equipment.quantity;
                productToSku.Lifespan_Months__c = equipment.lifespan;
                productToSku.Maintenance_Cycle__c = equipment.maintenanceperiod;

                lstInventoryToUpdate.add(productToSku);
            } else if(productToSku == null){
                product2 prod2 = new product2();
                    prod2.Name = equipment.name;
                    prod2.Replacement_Part__c = equipment.replacement;
                    prod2.Cost__c = equipment.cost;
                    prod2.Current_Inventory__c = equipment.quantity;
                    prod2.Lifespan_Months__c = equipment.lifespan;
                    prod2.Maintenance_Cycle__c = equipment.maintenanceperiod;
                	prod2.Warehouse_SKU__c = equipment.sku;
                    lstInventoryToUpdate.add(prod2);
            }
        }
        return lstInventoryToUpdate;
    }
    
    public static Product2 updateProducts(Product2 product, ParseEquipment equipment){
                product.Replacement_Part__c = equipment.replacement;
                product.Cost__c = equipment.cost;
                product.Current_Inventory__c = equipment.quantity;
                product.Lifespan_Months__c = equipment.lifespan;
                product.Maintenance_Cycle__c = equipment.maintenanceperiod;
                return product;
    }
}