
// public static void updateCases(){
//     list<Case> cases = [SELECT ID, Type, Status FROM Case];
// list<Case> casesToUpdate = new list<Case>();

// for(Case c : cases){

//     c.type = 'repair';
//     c.Status = 'Closed';
//     casesToUpdate.add(c);
// }
// update casesToUpdate;
// }

list<External_Equipment_Integration_mdt> mdtRecord = [SELECT Api_Endpoint__c, List_Of_Equipment__c FROM External_Equipment_Integration_mdt];
system.debug(mdtRecord);