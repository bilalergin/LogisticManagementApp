@RestResource(urlMapping = '/shipment-details/*')
global with sharing class WsShipmentDetails {
    @HttpGet

    global static List<ShipmentDetail> getShipmentDetails() {
        List<ShipmentDetail> details = new List<ShipmentDetail>();
        for (Shipment__c ship : [ SELECT Id, Name__c, Live__c, LOCATION__c, Departure_Date_Time__c, Arrival_Date_Time__c FROM Shipment__c WHERE Live__c = true AND Departure_Date_Time__c >:Date.today() WITH SECURITY_ENFORCED]
        ) {
            details.add(new ShipmentDetail(ship));
            
        }
        return details;
         
        
    }
    global class ShipmentDetail{
        public String shipmentId;
        public String name;
        public Boolean live;
        public String location;
        public String depertureDate; 
        public String arrivalDate;

        public ShipmentDetail(Shipment__c ship){
            this.shipmentId = ship.Id;
            this.name =ship.Name__c;
            this.live = ship.Live__c;
            this.location = ship.LOCATION__c;
            this.depertureDate = ship.Departure_Date_Time__c?.format('yyyy-MM-dd hh:MM');
            this.arrivalDate = ship.Arrival_Date_Time__c?.format('yyyy-MM-dd hh:MM');
        }
    }

}