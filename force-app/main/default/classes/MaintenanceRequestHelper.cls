public with sharing class MaintenanceRequestHelper {

    public static void createWorkOrders(Map<Id, Case> mapMaintanceRequests) {
        set<Id> setRequests = mapMaintanceRequests.keySet();
        List<case> lstNewRequests = new List<Case>();
        Map<String,List<Equipment_Maintenance_Item__c>> mapMaintanceToItems = getMapRequestToItems(setRequests);
        Map<String, Case> mapOldToNewRequests = new Map<String, Case>();

        for(Case maintanceRequest : [
            SELECT Id, Vehicle__c, Product__c, Type, Subject, Status, 
            (SELECT Id, Maintenance_Request__c, Equipment__c,Equipment__r.Maintenance_Cycle__c, Quantity__c
            FROM Equipment_Maintenance_Items__r) 
            FROM Case 
            WHERE Id =:setRequests]){
                
            List<Equipment_Maintenance_Item__c> lstMaintenanceItems = maintanceRequest.Equipment_Maintenance_Items__r;
            Decimal dueDate;
            Integer i = 0;
            
            if(!lstMaintenanceItems.isEmpty()){
                do {
                    Decimal cycle = lstMaintenanceItems[i].Equipment__r.Maintenance_Cycle__c;
                    if(cycle != null && !lstMaintenanceItems.isEmpty()){
                        if(dueDate == null){
                            dueDate = cycle;
                        } else if(dueDate > cycle){
                            dueDate = cycle;
                        }
                    }                        
                        i++;
                    } while (i < lstMaintenanceItems.size());
            }

            if(maintanceRequest.Type.Contains('repair') || maintanceRequest.Type.Contains('Routine Maintenance') && maintanceRequest.Status == 'Closed'){

                Case newRequest = new Case(
                    Vehicle__c = maintanceRequest.Vehicle__c,
                    Product__c = maintanceRequest.Product__c,
                    Type = 'Routine Maintenance',
                    Subject = maintanceRequest.Subject,
                    Status = 'New'
                    );
                    Date today = System.today();
                    newRequest.Date_Due__c = today;
                    if(!lstMaintenanceItems.isEmpty()){
                        Date nextDueDate = today.addDays(Integer.valueOf(dueDate));
                        newRequest.Date_Due__c = nextDueDate;
                    }

                    lstNewRequests.add(newRequest);
                    mapOldToNewRequests.put(String.valueOf(maintanceRequest.Id), newRequest);  
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