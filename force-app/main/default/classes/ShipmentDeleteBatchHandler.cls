//  class for the batch
public class ShipmentDeleteBatchHandler implements Database.Batchable<sObject>, Schedulable {
    public void execute(SchedulableContext sc){
        Database.executeBatch(new ShipmentDeleteBatchHandler());
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query for shipments that are more than 2 months old and not live
        
        return Database.getQueryLocator([
            SELECT Id
            FROM Shipment__c
            WHERE Arrival_Date_Time__c <= :Datetime.now().addMonths(-2)
            AND Live__c = false
        ]);
    } 
    
    public void execute(Database.BatchableContext bc, List<Shipment__c> scope) {
        // Delete the shipment records
        delete scope;
    }
    
    public void finish(Database.BatchableContext bc) {
        // Send email to the "Daily Job" Public Group
        Set<Id> userIds = new Set<Id>();
        for (GroupMember gm : [SELECT UserOrGroupId FROM GroupMember WHERE Group.Name = 'Daily Job']) {
            userIds.add(gm.UserOrGroupId);
            
        }

        Set<String> emailAddresses = new Set<String>();
        for (User us : [SELECT Email FROM User WHERE IsActive = true AND Id IN: userIds]) {
            emailAddresses.add(us.Email);
            
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Batch Execution Completed');
        mail.setSenderDisplayName('SI Salesforce Robot ');
        mail.setPlainTextBody('The batch process has been executed successfully.');
        mail.setHtmlBody('<p>Job is completed. You can check Setup --> Apex Jobs</p>');
        mail.setToAddresses(new List<String>(emailAddresses));



        Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
    }
    
    
}