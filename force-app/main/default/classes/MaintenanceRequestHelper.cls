public with sharing class MaintenanceRequestHelper {
    public static void createWorkOrders(Map<Id, Case> mapMaintanceRequests) {

        set<Id> setRequests = mapMaintanceRequests.keySet();
        List<case> lstNewCases = new List<Case>();
        List<Equipment_Maintenance_Item__c> lstRelatedItems = new List<Equipment_Maintenance_Item__c>();
        Map<String,List<Equipment_Maintenance_Item__c>> mapMaintanceToItems = getMapRequestToItems(setRequests);
        Map<String, Case> mapOldToNewCases = new Map<String, Case>();

        
        for(String maintanceRequest : mapMaintanceToItems.keyset()){

            Case request = mapMaintanceRequests.get(maintanceRequest);
            List<Equipment_Maintenance_Item__c> lstItems = mapMaintanceToItems.get(maintanceRequest);
            if(request.Type.Contains('repair') || request.Type.Contains('Routine Maintenance') && request.Status == 'Closed'){

                Case newCase = new Case(
                    Vehicle__c = request.Vehicle__c,
                    Product__c = request.Product__c,
                    Type = 'Routine Maintenance',
                    Subject = request.Subject,
                    Status = 'New'
                     );
                     lstNewCases.add(newCase);
                     mapOldToNewCases.put(maintanceRequest, newCase);  
            }
            
        }
        Insert lstNewCases;
        List<Equipment_Maintenance_Item__c> lstMaintenanceItemsToUpdate = createEquipmentItems(mapOldToNewCases,mapMaintanceToItems);
        Insert lstMaintenanceItemsToUpdate;
    }

    Public Static Map<String,List<Equipment_Maintenance_Item__c>> getMapRequestToItems(Set<Id> requests){
        Map<Id, Case> maintanceRequest = new Map<Id, Case>([
            Select Id, Vehicle__c, Product__c, Type, Subject, Status, 
            (SELECT Id, Maintenance_Request__c, Equipment__c, Quantity__c
            FROM Equipment_Maintenance_Items__r) 
            FROM Case 
            WHERE Id =:requests]);

        Map<String,List<Equipment_Maintenance_Item__c>> mapCaseToItems = new Map<String,List<Equipment_Maintenance_Item__c>>();
        for(String key : maintanceRequest.keyset()){

        Case nestedCaseItems = maintanceRequest.get(key);
        List<Equipment_Maintenance_Item__c> lstItems = nestedCaseItems.Equipment_Maintenance_Items__r;
        mapCaseToItems.put(key,lstItems);
        }
        return  mapCaseToItems;
    }

    public static List<Equipment_Maintenance_Item__c> createEquipmentItems(Map<String, Case> mapOldToNewCases, Map<String,List<Equipment_Maintenance_Item__c>> mapMaintanceToItems){

        List<Equipment_Maintenance_Item__c> newMaintenanceItems = new List<Equipment_Maintenance_Item__c>();

        for(String oldCase : mapOldToNewCases.keyset()){
            List<Equipment_Maintenance_Item__c> oldMaintenanceItems = mapMaintanceToItems.get(oldCase);

            if(!oldMaintenanceItems.isEmpty()){
                for(Equipment_Maintenance_Item__c item : oldMaintenanceItems){
                   Case newCase = mapOldToNewCases.get(oldCase);
                    Equipment_Maintenance_Item__c newItem = new Equipment_Maintenance_Item__c(
                        Maintenance_Request__c = newCase.id,
                        Equipment__c = item.Equipment__c,
                        Quantity__c = item.Quantity__c
                    );
                    newMaintenanceItems.add(newItem);
                }
            }
        }
      return newMaintenanceItems;  
    }
}