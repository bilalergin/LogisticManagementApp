@IsTest
private class DailyPurgeScheduableShipmentTest {
    @IsTest
    static void tester() {
       Dispatcher_Manager__c manager = new Dispatcher_Manager__c(name= 'Test Manager', 
                                                                 Email__c = 'manager@gmail.com', 
                                                                 Phone__c = '123654789');
        insert manager;

        // Create test data
        
           Shipment__c ship1 = new Shipment__c(Dispatcher_Manager__c = manager.Id,
                Name__c = 'Test Shipment 1',
                Status__c = 'Loading',
                Departure_Date_Time__c	= Datetime.now().addDays(-14),
                Arrival_Date_Time__c = DateTime.now().addDays(14),
                Live__c = true
            );

            Shipment__c ship2 = new Shipment__c(Dispatcher_Manager__c = manager.Id,
                Name__c = 'Test Shipment 2',
                Status__c = 'On the way',
                Departure_Date_Time__c	= Datetime.now().addMonths(-3),
                Arrival_Date_Time__c = DateTime.now().addMonths(-3).addDays(14),
                Live__c = false
            );
        
        insert new List<Shipment__c>{ship1, ship2};
        
        Test.startTest();
        
        // Schedule the batch job
        DailyPurgeScheduableShipment obj = new DailyPurgeScheduableShipment();
        obj.execute(null);      
        Test.stopTest();

        Integer shipmentCount =[SELECT COUNT() FROM Shipment__c];
        System.assertEquals(1, shipmentCount);
        
       
    }
}