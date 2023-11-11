public with sharing class ShipmentDetailService {

   @AuraEnabled
   public static List<Shipment__c> upcomingShipments (){
         return [SELECT Id, Name, Name__c, Shipment_Detail__c,LOCATION__c,LOCATION__r.Name, Dispatcher_Manager__c,Departure_Date_Time__c,Dispatcher_Manager__r.Name
        FROM Shipment__c
        WHERE Departure_Date_Time__c >=TODAY
        AND Live__c = true 
        WITH SECURITY_ENFORCED];
   
   }

   @AuraEnabled
   public static List<Shipment__c> searchByKeyword ( String name){
    String nameLike = '%' + name + '%';

        return [SELECT Id, Name, Name__c, Shipment_Detail__c,LOCATION__c,LOCATION__r.Name, Dispatcher_Manager__c,Departure_Date_Time__c,Dispatcher_Manager__r.Name
        FROM Shipment__c
        WHERE Departure_Date_Time__c >=TODAY
        AND Live__c = true 
        AND Name__c LIKE : nameLike WITH SECURITY_ENFORCED];
   
   }
}