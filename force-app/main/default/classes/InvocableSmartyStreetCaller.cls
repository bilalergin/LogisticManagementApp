public class InvocableSmartyStreetCaller {

        @InvocableMethod(label='SmartyStreesAPI' description='Makes an HTTP GET to Smarty.com' category='Location__c')
        public static void methodName(List<Id> locationIds) {
            makeCallout(locationIds[0]);    
        }
    
        @future(callout=true)
        private static void makeCallout(Id locId){
        try{
    
            Location__c lc = [SELECT City__c, Postal_Code__c, State__c, Street__c FROM Location__c WHERE Id=:locId];
    
            SmartyStreetCreds__c setting = SmartyStreetCreds__c.getOrgDefaults();
            
            string path = '/street-address'
            +'?auth-id='+setting.Auth_Id__c
            +'&auth-token='+setting.Auth_Token__c
            +'&candidates=10'
            +'&street='+EncodingUtil.urlEncode(lc.Street__c,'UTF-8')
            +'&city='+EncodingUtil.urlEncode(lc.City__c,'UTF-8')
            +'&state='+EncodingUtil.urlEncode(lc.State__c,'UTF-8')
            +'&zipcode='+lc.Postal_Code__c
            +'&match=enhanced';
    
            // &license=us-rooftop-geocoding-cloud
    
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:SmartyStreetAPI'+path);
            request.setMethod('GET');
    
            Http http = new Http();
    
            HttpResponse response = http.send(request);
    
            if(response.getStatusCode()==200){
                string jsonBody = response.getBody();
                update new Location__c (Id=locId, Verified__c = true);
    
            } else {
                update new Location__c (Id=locId, Verified__c = false);
    
            }
    
            // update new Location__c(Id=locId, 
            //                       Verified__c = (response.getStatusCode()== 200)
            //                       );
            
        }catch(Exception ex){
            string msg ='EXC: '+ ex.getMessage() + ' line: '+ ex.getLineNumber();
            system.debug(msg);
            ErrorLogHelper.createErrorLog('AddressVerification','makeCallout',msg);
        }
    
           
        }
        
    }