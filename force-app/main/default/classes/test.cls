public with sharing class MaintenanceRequestHelper {
    public static void createWorkOrders(Map<Id, Case> mapMaintanceRequests) {

        set<Id> setRequests = mapMaintanceRequests.keySet();
        List<case> lstNewRequests = new List<Case>();
        Map<String,List<Equipment_Maintenance_Item__c>> mapMaintanceToItems = getMapRequestToItems(setRequests);
        Map<String, Case> mapOldToNewRequests = new Map<String, Case>();

        for(Case maintanceRequest : [
            Select Id, Vehicle__c, Product__c, Type, Subject, Status, 
            (SELECT Id, Maintenance_Request__c, Equipment__c, Quantity__c
            FROM Equipment_Maintenance_Items__r) 
            FROM Case 
            WHERE Id =:setRequests]){


            Decimal maxValue = 0;
            // for(Integer i = 0; i < Equipment_Maintenance_Item__c.size();i++){
            //     maxValue = Equipment_Maintenance_Item__c[i].Equipment__r.Maintenance_Cycle__c;
            //     if()
            // }
            Integer i = 0;
            do {
                Equipment_Maintenance_Item__c cycle = maintanceRequest.Equipment_Maintenance_Item__c[i];
                if(i == 0){
                    maxValue = cycle.Equipment__r.Maintenance_Cycle__c;
                } else if (maxValue < cycle.Equipment__r.Maintenance_Cycle__c) {
                    maxValue = cycle.Equipment__r.Maintenance_Cycle__c;
                }
            
                System.debug('maxValue' + maxValue);
            
                i++;
            } while (i < lstItems.size());
            // for(Equipment_Maintenance_Item__c cycle : lstItems){
            //     system.debug('cycle.Equipment__r.Maintenance_Cycle__c = '+cycle.Equipment__r.Maintenance_Cycle__c);
                
            //     if(  maxValue < cycle.Equipment__r.Maintenance_Cycle__c){
            //         maxValue = cycle.Equipment__r.Maintenance_Cycle__c;
            //     }

            System.debug('maxValue'+maxValue);
            }
            if(maintanceRequest.Type.Contains('repair') || maintanceRequest.Type.Contains('Routine Maintenance') && maintanceRequest.Status == 'Closed'){

                Case newRequest = new Case(
                    Vehicle__c = maintanceRequest.Vehicle__c,
                    Product__c = maintanceRequest.Product__c,
                    Type = 'Routine Maintenance',
                    Subject = maintanceRequest.Subject,
                    Status = 'New'
                     );

                     newRequest.Date_Due__c = today();
                     lstNewRequests.add(newRequest);
                     mapOldToNewRequests.put(maintanceRequest, newRequest);  
            }
            
        }
        Insert lstNewRequests;
        List<Equipment_Maintenance_Item__c> lstMaintenanceItemsToUpdate = createEquipmentItems(mapOldToNewRequests,mapMaintanceToItems);
        Insert lstMaintenanceItemsToUpdate;
    }

    Public Static Map<String,List<Equipment_Maintenance_Item__c>> getMapRequestToItems(Set<Id> requests){
        Map<Id, Case> maintanceRequest = new Map<Id, Case>([
            Select Id, Vehicle__c, Product__c, Type, Subject, Status, 
            (SELECT Id, Maintenance_Request__c, Equipment__c,Equipment__r.Maintenance_Cycle__c, Quantity__c
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

    public static List<Equipment_Maintenance_Item__c> createEquipmentItems(Map<String, Case> mapOldToNewRequests, Map<String,List<Equipment_Maintenance_Item__c>> mapMaintanceToItems){

        List<Equipment_Maintenance_Item__c> newMaintenanceItems = new List<Equipment_Maintenance_Item__c>();

        for(String oldCase : mapOldToNewRequests.keyset()){
            List<Equipment_Maintenance_Item__c> oldMaintenanceItems = mapMaintanceToItems.get(oldCase);

            if(!oldMaintenanceItems.isEmpty()){
                for(Equipment_Maintenance_Item__c item : oldMaintenanceItems){
                   Case newCase = mapOldToNewRequests.get(oldCase);
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