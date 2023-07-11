//  class for the batch
public class DailyPurgeScheduableShipment implements Database.Batchable<sObject>, Schedulable {
       
    //Schedule functionality
    public void execute(SchedulableContext sc){
        //Database.executeBatch(new DailyPurgeScheduableShipment());//default 200 erli kayıt gönderir.
        Database.executeBatch(new DailyPurgeScheduableShipment(),1); //birer birer çalışsın dedik
    }

    //Batch records query
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Query for shipments that are more than 2 months old and not live
        
        return Database.getQueryLocator([
            SELECT Id
            FROM Shipment__c
            WHERE Arrival_Date_Time__c <= :Datetime.now().addMonths(-2)
            AND Live__c = false
        ]);
    } 
    
    //The real 'What to do'
    public void execute(Database.BatchableContext bc, List<Shipment__c> shipments) {
        // Delete the shipment records
        //1K/200=5 Jobs 100 tane kaydı 5 kere de getirir
        try {
            delete shipments;
        } catch (Exception exc) {
            ErrorLogHelper.createErrorLog('DailyPurgeScheduableShipment', Datetime.now(), exc.getMessage(), 'execute');
        }
    }

    //Send email    
    public void finish(Database.BatchableContext bc) {
        //find public group members
        Set<Id> userIds = new Set<Id>();
        for (GroupMember gm : [SELECT UserOrGroupId FROM GroupMember WHERE Group.Name = 'Daily Job']) {
            userIds.add(gm.UserOrGroupId);
            
        }
       
        //find unique email public group
        Set<String> emailAddresses = new Set<String>();
        for (User us : [SELECT Email FROM User WHERE IsActive = true AND Id IN: userIds  ]) {
            emailAddresses.add(us.Email);
            
        }

         // Send email to the "Daily Job" Public Group
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Daily Purge Shipment Job Completed');
        mail.setSenderDisplayName('SI Salesforce Robot ');
        mail.setPlainTextBody('Daily Purge Shipment Job Completed. You can check Setup --> Apex Jobs');
        mail.setHtmlBody('<p>Job is completed. You can check Setup --> Apex Jobs</p>');
        mail.setToAddresses(new List<String>(emailAddresses));


        try {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
        } catch (Exception e) {
            ErrorLogHelper.createErrorLog('DailyPurgeScheduableShipment', Datetime.now(), e.getMessage(), 'sendEmail');
        }
    }
    
    
}