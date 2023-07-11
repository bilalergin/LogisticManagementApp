// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

 try{
            account acc=new account();
            acc.phone='233455666';
            //name eksik olduğundan hata verecek ve sistemin hatasını clasımız yakalayacak
            insert acc;
        }catch(exception ex){
            //datetime.now() today ve bugunun time veriyor...
            ErrorLogHelper.createErrorLog(datetime.now(),ex.getMessage());
              }