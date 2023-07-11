//ErrorLogHelper.newErrorLog(Datetime.now(), 'Problem Solving', 'Process Name');


account ac = new Account();
try {
    insert ac;
    
} catch (Exception ex) {
    ErrorLogHelper.newErrorLog(Datetime.now(), ex.getMessage(), 'Hello Test');
    
}
