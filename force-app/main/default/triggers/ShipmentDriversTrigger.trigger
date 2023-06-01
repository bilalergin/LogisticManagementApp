trigger ShipmentDriversTrigger on Shipment_Drivers__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            
        }
        ShipmentDriversTriggerHandler.validateShipmentDriver(Trigger.new);
        }
    }

