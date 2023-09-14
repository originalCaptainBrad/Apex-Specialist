global class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext context) {

        HttpResponse httpBody = makeCallout();
        String responseBody = httpBody.getBody();
        List<JSON2Apex> parseEquipment = JSON2Apex.parse(responseBody);
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

    public static List<Product2> parseNewInventory(List<JSON2Apex> parseItems){

        map<string,product2> productInventory = new map<string,product2>();

        for(product2 prodMap : [SELECT Id, Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, Warehouse_SKU__c FROM product2]){
            productInventory.put(prodMap.Warehouse_SKU__c, prodMap);
        }
        
        list<product2> lstInventoryToUpdate = new list<product2>();

        for(JSON2Apex inv : parseItems){

            product2 productToSku = productInventory.get(inv.sku);
            system.debug('Product is : '+prod);
            system.debug('productToSku is : '+productToSku);
            if(prod != null || productToSku != null){
                prod = updateProducts(prod, inv);

                lstInventoryToUpdate.add(prod);
            } else if(prod == null){
                product2 prod2 = new product2();
                    prod2.Name = inv.name;
                    prod2.Replacement_Part__c = inv.replacement;
                    prod2.Cost__c = inv.cost;
                    prod2.Current_Inventory__c = inv.quantity;
                    prod2.Lifespan_Months__c = inv.lifespan;
                    prod2.Maintenance_Cycle__c = inv.maintenanceperiod;
                	prod2.Warehouse_SKU__c = inv.sku;
                    lstInventoryToUpdate.add(prod2);
            }
        }
        return lstInventoryToUpdate;
    }
    
    public static Product2 updateProducts(Product2 prod, JSON2Apex inv){
                prod.Replacement_Part__c = inv.replacement;
                prod.Cost__c = inv.cost;
                prod.Current_Inventory__c = inv.quantity;
                prod.Lifespan_Months__c = inv.lifespan;
                prod.Maintenance_Cycle__c = inv.maintenanceperiod;
                return prod;
    }
}