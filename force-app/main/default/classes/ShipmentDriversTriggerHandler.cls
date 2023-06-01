public class ShipmentDriversTriggerHandler {
    public static void validateShipmentDriver(List<Shipment_Drivers__c> newRecords) {
        Set<Id> driverIds = new Set<Id>();
        Set<Id> shipmentIds = new Set<Id>();
        Map<String, Shipment_Drivers__c> shipmentDriverMap = new Map<String, Shipment_Drivers__c>();
        for (Shipment_Drivers__c shipmentDriver : newRecords) {
            driverIds.add(shipmentDriver.Driver__c);
            shipmentIds.add(shipmentDriver.Shipment__c);

            String myKey = String.valueOf(shipmentDriver.Driver__c) + String.valueOf(shipmentDriver.Shipment__c);
            shipmentDriverMap.put(myKey, shipmentDriver);
        }
        System.debug('driverIds: ' + driverIds);
        System.debug('shipmentIds: ' + shipmentIds);

        for (Shipment_Drivers__c ship : [SELECT Id, Driver__c, Shipment__c FROM Shipment_Drivers__c WHERE Driver__c IN :driverIds and Shipment__c IN : shipmentIds]) {
            String systemKey = String.valueOf(ship.Driver__c) + String.valueOf(ship.Shipment__c);
            Shipment_Drivers__c toBeFailed = shipmentDriverMap.get(systemKey);
            if (toBeFailed != null) {
                toBeFailed.addError('Driver already has a shipment. Reject duplicate bookings. ' + String.valueOf(ship.Id));

            }
                            
        }
             
    }
}
