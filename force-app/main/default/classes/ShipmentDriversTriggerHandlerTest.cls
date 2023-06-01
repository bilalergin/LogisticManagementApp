@isTest
private class ShipmentDriversTriggerHandlerTest {
    @TestSetup
    static void prepareDate(){
        Dispatcher_Manager__c manager = new Dispatcher_Manager__c(name= 'Test Manager', Email__c = 'manager@gmail.com', Phone__c = '123654789');
        insert manager;

        Driver__c driver = new Driver__c(name= 'Test Driver', Email__c = 'driver@gmail.com', Phone__c = '234567891');
        insert driver;
        
        Shipment__c shipment = new Shipment__c(Dispatcher_Manager__c = manager.Id, Name__c = 'Test Shipment', Departure_Date_Time__c = datetime.now().addDays(1));
        insert shipment;

        Shipment_Drivers__c shipmentDriver = new Shipment_Drivers__c(Driver__c = driver.Id, Shipment__c = shipment.Id);
        insert shipmentDriver;
    }
    @IsTest
    static void testPozitive() {
        Shipment_Drivers__c systemRecord = [SELECT Driver__c, Shipment__c FROM Shipment_Drivers__c LIMIT 1];
        Test.startTest();
        try{
        insert new Shipment_Drivers__c(Driver__c = systemRecord.Driver__c, Shipment__c = systemRecord.Shipment__c);
        
        }catch(Exception exc){
            ErrorLogHelper.createErrorLog('error', exc.getMessage());
        }
        Test.stopTest();
        Integer systemCount = [SELECT COUNT()FROM Shipment_Drivers__c];
        Assert.areEqual(1, systemCount, 'Success');
        
    }

    @IsTest
    static void testNegative() {
        delete[SELECT Id FROM Shipment_Drivers__c];

        Driver__c driver = [SELECT Id FROM Driver__c LIMIT 1];
        Shipment__c shipment = [SELECT Id FROM Shipment__c LIMIT 1];

        Test.startTest();
        insert new Shipment_Drivers__c(Driver__c = driver.Id, Shipment__c = shipment.Id);
            
        Test.stopTest();
        Integer systemCount = [SELECT COUNT()FROM Shipment_Drivers__c];
        Assert.areEqual(1, systemCount, 'Success');
        
        
    }
    

}
