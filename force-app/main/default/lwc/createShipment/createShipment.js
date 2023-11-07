import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';

import SHIPMENT_OBJECT from '@salesforce/schema/Shipment__c';
import NAME from '@salesforce/schema/Shipment__c.Name__c';
import Dispatcher_Manager__c from '@salesforce/schema/Shipment__c.Dispatcher_Manager__c';
import Departure_Date_Time__c from '@salesforce/schema/Shipment__c.Departure_Date_Time__c';
import Arrival_Date_Time__c from '@salesforce/schema/Shipment__c.Arrival_Date_Time__c';
import LOCATION__c from '@salesforce/schema/Shipment__c.LOCATION__c';
import Shipment_Detail__c from '@salesforce/schema/Shipment__c.Shipment_Detail__c';
import Status__c from '@salesforce/schema/Shipment__c.Status__c';

import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreateShipment extends NavigationMixin(LightningElement) {
    @track shipmentRecord = {
        Name__c: '',
        Dispatcher_Manager__c: '',
        Departure_Date_Time__c: null,
        Arrival_Date_Time__c: null,
        LOCATION__c: '',
        Shipment_Detail__c: ''
    }
    @track errors;
    handleChange(event){
        let value =event.target.value;
        let name = event.target.name;
        this.shipmentRecord[name] = value;
    }
    handleLookup(event){
        let selectedRecId = event.detail.selectedRecordId;
        let parentField=event.detail.parentfield;
        this.shipmentRecord[parentField] = selectedRecId;
    }
    handleClick(){
        const fields= {};
        fields[NAME.fieldApiName] = this.shipmentRecord.Name__c;
        fields[Dispatcher_Manager__c.fieldApiName] = this.shipmentRecord.Dispatcher_Manager__c;
        fields[Departure_Date_Time__c.fieldApiName] = this.shipmentRecord.Departure_Date_Time__c;
        fields[Arrival_Date_Time__c.fieldApiName] = this.shipmentRecord.Arrival_Date_Time__c;
        fields[LOCATION__c.fieldApiName] = this.shipmentRecord.LOCATION__c;
        fields[Shipment_Detail__c.fieldApiName] = this.shipmentRecord.Shipment_Detail__c;
        fields[Status__c.fieldApiName] = "Loading";

        const shipmentRecord = {
            apiName: SHIPMENT_OBJECT.objectApiName,
            fields
        };

        createRecord(shipmentRecord)
        .then((shipmentRec) => {
            this.dispatchEvent(new ShowToastEvent({ 
                title: "Record Saved",
                message: "Shipment draft is ready",
                variant: "success"
             }));
             this[NavigationMixin.Navigate]({
                type:'standard__recordPage',
                attributes:{
                    actionName:"view",
                    recordId: shipmentRec.id
                }
             });
        
        }).catch((error) => {
            this.errors = JSON.stringify(error);
            this.dispatchEvent(new ShowToastEvent({
                title: "Error Occured",
                message: this.errors,
                variant: "error"
            }));
        });    

    }


    handleCancel(){
        this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes: {
                actionName: "home",
                objectApiName:"Shipment__c"
            }
        });
    }
    }
