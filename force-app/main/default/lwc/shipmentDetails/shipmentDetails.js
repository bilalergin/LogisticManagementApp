import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getDrivers from "@salesforce/apex/ShipmentDetailsController.getDrivers";
import getLocationDetails from "@salesforce/apex/ShipmentDetailsController.getLocationDetails";
import getClients from "@salesforce/apex/ShipmentDetailsController.getClients";

import id from '@salesforce/user/Id';
import Profile from '@salesforce/schema/User.Profile.Name';
import { NavigationMixin } from 'lightning/navigation'; 
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

const COLUMNS = [
    {
    label: 'Name',
    fieldName: 'Name',
    cellAttributes: {
        iconName: 'standard:user',
        iconPosition: 'left'
    }
},
{
    label: 'Email',
    fieldName: 'Email',
    type: 'email',
},
{
    label: 'Company Name',
    fieldName: 'CompanyName',  
},
{
    label: 'Location',
    fieldName: 'Location',
    cellAttributes: {
        iconName: 'utility:location',
        iconPosition: 'left',
}
}
];

export default class ShipmentDetails extends NavigationMixin (LightningElement) {
    @api recordId;
    @track driverList;
    @track shipmentRec;
    @track clientList;
    @track isAdmin = false;

    userId = id;

    columnsList = COLUMNS;   
    @wire(getRecord, { recordId: '$userId', fields: [Profile] })
    wiredMethod({ error,data }){
        if (data) {
           // window.console.log("userRecord:",JSON.stringify(data));
            let userProfileName = data.fields.Profile.displayValue;
           // console.log("userProfileName:" + userProfileName);
            this.isAdmin = userProfileName === "System Administrator";
            
        } if (error) {
            console.log("Error occured:",JSON.stringify(error));
        }
    }

    createDriver() {
    const defaultValues = encodeDefaultFieldValues({ 
   Shipment__c: this.recordId 
   }); 
this[NavigationMixin.Navigate]({ 
   type: 'standard__objectPage', 
   attributes: { 
   objectApiName: 'Shipment_Drivers__c', 
   actionName: 'new' 
   }, 
   state: { 
   defaultFieldValues: defaultValues 
   } 
   });     
}
handleDriverActive(){
    getDrivers({
        shipmentId : this.recordId
    })
    .then((result) => {
        result.forEach((driver) => {
            driver.Name = driver.Driver__r.Name;
            driver.Email = "**********@gmail.com";
            driver.Phone = driver.Driver__r.Phone__c;
            driver.Profile__c = driver.Driver__r.Profile__c;
            driver.AboutMe__c = driver.Driver__r.AboutMe__c;
            driver.CompanyName = driver.Driver__r.Company__c;
        });
        this.driverList = result;
        window.console.log("result", JSON.stringify(this.result));
        this.errors = undefined;
    })
    .catch((err)=>{
        this.errors = err;
        this.driverList = undefined;
        window.console.log("ERR.", this.errors);
    });

}
handleLocationDetails(){
    getLocationDetails({
        shipmentId:this.recordId
    })
    .then((result) =>{
        if(result.LOCATION__c){
            this.shipmentRec = result;
        }else {
            this.shipmentRec = undefined;
        }
        this.errors = undefined;
    })
    .catch((err) =>{
        this.errors = err;
        this.shipmentRec = undefined;
    })

}
handleClient(){
    getClients({
        shipmentId: this.recordId
    })
    .then((result) =>{
        result.forEach((client) =>{
            client.Name = client.Client__r.Name;
            client.Email = "**********@gmail.com";
            client.CompanyName = client.Client__r.Company_Name__c;

            if(client.Client__r.LOCATION__c){

            }else{
                client.Location = "Preferred not to say";
            }
        });
        this.clientList = result;
        this.errors = undefined;
    })
    .catch((err) => {
        this.errors = err;
        this.clientList = undefined;
    })
}
createClient() {
    const defaultValues = encodeDefaultFieldValues({ 
   Shipment__c: this.recordId 
   }); 
this[NavigationMixin.Navigate]({ 
   type: 'standard__objectPage', 
   attributes: { 
   objectApiName: 'Shipment_Client__c', 
   actionName: 'new' 
   }, 
   state: { 
   defaultFieldValues: defaultValues 
   } 
   });     
}
}