public class ErrorLogHelper {
    public static void newErrorLog(Datetime dtime,string details, string processName) {
        Error_Log__c errorlog = new Error_Log__c();
        errorLog.Log_Date_Time__c = dTime;
        errorlog.Log_Details__c = Details;
        errorlog.Process_Name__c = processName;

        insert errorlog;

    }
}