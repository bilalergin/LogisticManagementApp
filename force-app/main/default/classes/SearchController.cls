public with sharing class SearchController {
    @AuraEnabled
    public static String searchRecords(String objName, String fieldName, String searchKey) {
        String searchKeyword = searchKey + '*';
        String returningQuery = objName + ' (Id, ' + fieldName + ')';
        System.debug(returningQuery);

        String query = 'FIND :searchKeyword IN ALL FIELDS RETURNING ' + returningQuery + 'LIMIT 2000';
        System.debug(query);
        List<List<SObject>> records = Search.query(query);
        System.debug(JSON.serialize(records));
        return JSON.serialize(records);
    }
}