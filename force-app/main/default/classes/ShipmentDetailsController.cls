public with sharing class ShipmentDetailsController {
   @AuraEnabled
   public static List<Shipment_Drivers__c> getDrivers(String shipmentId){
    return [SELECT id, Name, Driver__c, Driver__r.Name, Driver__r.Phone__c, Driver__r.Email__c, Driver__r.Company__c, Driver__r.Profile__c, Driver__r.AboutMe__c 
            FROM Shipment_Drivers__c 
            WHERE Shipment__c =:shipmentId 
            WITH SECURITY_ENFORCED];
   }

   @AuraEnabled
   public static Shipment__c getLocationDetails(String shipmentId){
    return [SELECT Id, Name, LOCATION__c, LOCATION__r.Name, LOCATION__r.City__c, LOCATION__r.Country__c, LOCATION__r.Land_Mark__c, LOCATION__r.Postal_Code__c, LOCATION__r.State__c, LOCATION__r.Street__c 
            FROM Shipment__c 
            WHERE  Id=:shipmentId 
            WITH SECURITY_ENFORCED];
   }
   @AuraEnabled
   public static List<Shipment_Client__c> getClients(String shipmentId){
    return [SELECT Id, Name, Client__c, Client__r.Name, Client__r.Phone__c, Client__r.Email__c, Client__r.Company_Name__c, Client__r.LOCATION__c, Client__r.LOCATION__r.Name 
            FROM Shipment_Client__c 
            WHERE Shipment__c =:shipmentId 
            WITH SECURITY_ENFORCED];
   }
}
