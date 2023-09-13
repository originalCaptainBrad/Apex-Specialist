public without sharing class TestDataFactory {

    public static void generateMaintanceRequestdata(Integer testRecords){

        List<Vehicle__c> vehicles = new List<Vehicle__c>();
        List<Case> requests = new List<Case>();
        List<Product2> lstEquipment = new List<Product2>();

        for(Integer I = 0; i < testRecords; i++){
            Vehicle__c vehicle = new Vehicle__c(
                name='Test Car'+i);
                vehicles.add(vehicle);
        }
        insert vehicles;

        for(Integer I = 0; i < testRecords; i++){
            Case request = new Case(
                Type = 'Routine Maintenance',
                Status = 'New',
                Vehicle__c = vehicles[i].Id,
                Product__c = 'Test Product',
                Subject = 'Test Subject'
            );
            requests.add(request);
        }
        insert requests;

        for(Integer I = 0; i < testRecords; i++){
                Product2 equipment = new Product2(
            Name ='Test Equipment',
            Replacement_Part__c = true,
            Maintenance_Cycle__c = 30-i
            );
            lstEquipment.add(equipment);
        }
        insert lstEquipment;

        List<Equipment_Maintenance_Item__c> lstmaintanceItem = new List<Equipment_Maintenance_Item__c>();

        for(Integer i = 0; i < requests.size()-1; i++){

            for(Integer j = 0; j < lstEquipment.size(); j++){
            Equipment_Maintenance_Item__c maintanceItem = new Equipment_Maintenance_Item__c(
                Maintenance_Request__c = requests[i].Id,
                Equipment__c = lstEquipment[j].Id
            );

            lstmaintanceItem.add(maintanceItem);
            }
        }
        insert lstmaintanceItem;
    }
}