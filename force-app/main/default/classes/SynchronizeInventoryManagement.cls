global class SynchronizeInventoryManagement implements Database.Batchable<sObject> {

    public final string response = Utility.getInventoryStatus().getBody();
    // list<Object> lstProducts = Utility.getInventoryStatus().getBody();
    public final string Query = 'SELECT Id, Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, Warehouse_SKU__c FROM product2';

        public SynchronizeInventoryManagement(String q){
            
           Query=q; 
           //Entity=e; Field=f;Value=v;
        }

        public Database.QueryLocator start(Database.BatchableContext BC){
            return Database.getQueryLocator(query);
         }

         public void execute(Database.BatchableContext BC, List<sObject> scope){


            for(sobject s : scope){
            // s.put(Field,Value); 
            }
            update scope;
           }
       
          public void finish(Database.BatchableContext BC){
          }

       

        list<product2> lstEquipment = [SELECT Replacement_Part__c, Cost__c, Current_Inventory__c, Lifespan_Months__c, Maintenance_Cycle__c, Warehouse_SKU__c FROM product2];

        // return null;
    }


