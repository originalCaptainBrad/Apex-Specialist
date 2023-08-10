global without sharing class Utility {

    global static HttpResponse getInventoryStatus(){

        list<External_Equipment_Integration__mdt> mdtRecord = [
            SELECT Api_Endpoint__c, List_Of_Equipment__c 
            FROM External_Equipment_Integration__mdt];

            string endpoint = string.valueOf(External_Equipment_Integration__mdt.Inventory_Status.Api_Endpoint__c);
            string body = string.valueOf(External_Equipment_Integration__mdt.Inventory_Status.List_Of_Equipment__c);

            // Create an HTTP request
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
    
            // Create an HTTP instance
            Http http = new Http();
    
            // Send the request and get the response
            HttpResponse response = http.send(request);
    
            // Parse and process the response
            if (response.getStatusCode() == 200) { // Successful response
                String responseBody = response.getBody();
                // Process the responseBody as needed
                System.debug('Response: ' + responseBody);
            } else {
                System.debug('Callout failed with status code: ' + response.getStatusCode());
                System.debug('Response: ' + response.getBody());
            }
            string responseBody = response.getBody();
            list<Object> parsedProducts = parse(responseBody);
            return response;
    }

    public class DetailRecords{
        public id id;
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

    public static list<Object> parse(string jsonInput){
		Map<String,Object> mapBody = (Map<String,Object>) json.deserializeUntyped(jsonInput);
		List<Object> lstDetailRecords = (List<Object>) mapBody.get('DetailRecords');
        return lstDetailRecords;
    }
}