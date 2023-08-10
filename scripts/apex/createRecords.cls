
public static void updateCases(){
    list<Case> cases = [SELECT ID, Type, Status FROM Case];
list<Case> casesToUpdate = new list<Case>();

for(Case c : cases){

    c.type = 'repair';
    c.Status = 'Closed';
    casesToUpdate.add(c);
}
update casesToUpdate;
}

