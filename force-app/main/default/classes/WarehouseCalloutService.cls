global class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext context) {

        list<product2> lstInventoryToUpdate = new list<product2>();
        list<External_Equipment_Integration__mdt> mdtRecord = [
            SELECT Api_Endpoint__c, List_Of_Equipment__c 
            FROM External_Equipment_Integration__mdt];

            string endpoint = string.valueOf(mdtRecord[0].Api_Endpoint__c);
            string body;

            HttpResponse res;
            map<string,product2> productInventory = new map<string,product2>();

            for(product2 prodMap : [SELECT Id, Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, Warehouse_SKU__c FROM product2]){
                productInventory.put(prodMap.Warehouse_SKU__c, prodMap);
            }

            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
    
            Http http = new Http();
    
            System.debug('request = '+request);

                res = http.send(request);
                String responseBody = res.getBody();
                system.debug(res);
                system.debug(responseBody);

                List<JSON2Apex> parseEquipment = JSON2Apex.parse(responseBody);

                system.debug(parseEquipment);

                for(JSON2Apex inv : parseEquipment){

                    product2 prod = productInventory.get(inv.x_id);
                    if(prod != null){
                        //product2 prod = product[0];
                        prod.Replacement_Part__c = inv.replacement;
                        prod.Cost__c = inv.cost;
                        prod.Current_Inventory__c = inv.quantity;
                        prod.Lifespan_Months__c = inv.lifespan;
                        prod.Maintenance_Cycle__c = inv.maintenanceperiod;
    
                        lstInventoryToUpdate.add(prod);
                    } else if(prod == null){
                        product2 prod2 = new product2();
                            prod2.Name = inv.name;
                            prod2.Replacement_Part__c = inv.replacement;
                            prod2.Cost__c = inv.cost;
                            prod2.Current_Inventory__c = inv.quantity;
                            prod2.Lifespan_Months__c = inv.lifespan;
                            prod2.Maintenance_Cycle__c = inv.maintenanceperiod;
                            lstInventoryToUpdate.add(prod2);
                    }
                }

                System.debug(lstInventoryToUpdate);
                upsert lstInventoryToUpdate;
    }
}