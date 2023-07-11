@IsTest
private class ShipmentDeleteBatchHandlerTest {
    @IsTest
    static void testBatchExecution() {
        // Create test user
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User testUser = new User(
            ProfileId = profile.Id,
            Username = 'testuser@example.com' + System.currentTimeMillis(), // Add unique identifier to the username
            Email = 'testuser@example.com',
            Alias = 'testuser',
            CommunityNickname = 'testuser',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            FirstName = 'User',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        // Create test data
        List<Shipment__c> shipments = new List<Shipment__c>();
        for (Integer i = 0; i < 199; i++) {
            shipments.add(new Shipment__c(
                Name__c = 'Test Shipment ' + i,
                Dispatcher_Manager__c = 'a01Do00001Gwh0iIAB', // Set the Dispatcher Manager Id
                Departure_Date_Time__c = DateTime.now().addMonths(-3),
                Arrival_Date_Time__c = DateTime.now().addMonths(-3).addDays(1),
                Live__c = false
            ));
        }
        insert shipments;
        
        Test.startTest();
        
        // Schedule the batch job
        ShipmentDeleteBatchHandler batchHandler = new ShipmentDeleteBatchHandler();
        Database.executeBatch(batchHandler, 200);
        
        Test.stopTest();
        
        // Verify the batch job execution
        System.assertEquals(1, [SELECT count() FROM AsyncApexJob WHERE JobType = 'BatchApex' AND Status = 'Completed']);
        
        // Verify that shipments are deleted
        System.assertEquals(0, [SELECT count() FROM Shipment__c]);
    }
}