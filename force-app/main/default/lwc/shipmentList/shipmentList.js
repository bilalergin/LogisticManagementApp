import { LightningElement, track } from 'lwc';

import upcomingShipments from "@salesforce/apex/ShipmentDetailService.upcomingShipments";
import searchByKeyword from "@salesforce/apex/ShipmentDetailService.searchByKeyword";


const COLUMNS = [
    {
    label: "View",
    fieldName: "detailsPage",
    type: "url",
    wrapText :"true",
    typeAttributes: {
        label: {
            fieldName: "Name__c"
    },
    target: "_self"
}
},
{
    label: "Name",
    fieldName: "Name__c",
    wrapText :"true",
    cellAttributes:{
        iconName:"custom:custom98",
        iconPosition: "left"
        }
    },  

{
    label: "Dispatcher Manager",
    fieldName: "manager",
    wrapText :"true",
    cellAttributes:{
        iconName:"standard:user",
        iconPosition: "left"
        }
    },
    {
        label: "Location",
        fieldName: "location",
        wrapText :"true",
        type:"text",
        cellAttributes:{
            iconName:"utility:location",
            iconPosition: "left"
            }
        }
];


export default class ShipmentList extends LightningElement {
    
    columnsList = COLUMNS;   
    error;
    depertureDateTime;
    @track recordsToDisplay;
    @track result;

    connectedCallback(){
        this.upcomingShipmentsFromApex();
    }

    upcomingShipmentsFromApex(){
        upcomingShipments()
        .then((data) => {
            console.log("Apexten gelen data: " + JSON.stringify(data));
            data.forEach((record) => {
                record.detailsPage = "https://" + window.location.host + "/" + record.Id;
                record.manager = record.Dispatcher_Manager__c.Name;
                //record.Location = record.LOCATION__c ? record.LOCATION__r.Name: "This is virtual shipment"; 
                if(record.LOCATION__c){
                    record.location = record.LOCATION__r.Name;
                }else {
                    record.location = "This is virtual shipment";
                } //* buranın yerine üstteki satırı yazdık
                
            });
            this.result = data;
            this.recordsToDisplay = data;
            this.error = undefined;
        })
        .catch((err) => {
            console.error("ERROR: " + JSON.stringify(err));
            this.error = JSON.stringify(err);
            this.result = undefined;
        });
    }

    handleSearch(event){
        let keyword = event.detail.value;
        if(keyword && keyword.length >=2){
            searchByKeyword({
                name: keyword
            })
            .then((data) => {
                console.log("Apexten gelen data: " + JSON.stringify(data));
                data.forEach((record) => {
                    record.detailsPage = "https://" + window.location.host + "/" + record.Id;
                    record.manager = record.Dispatcher_Manager__c.Name;
                    record.Location = record.LOCATION__c ? record.LOCATION__r.Name: "This is virtual shipment"; 
                    /*if(record.LOCATION__c){
                        record.location = record.LOCATION__r.Name;
                    }else {
                        record.location = "This is virtual shipment";
                    }*/ //* buranın yerine üstteki satırı yazdık
                    
                });
                this.result = data;
                this.recordsToDisplay = data;
                this.error = undefined;
            })
            .catch((err) => {
                console.error("ERROR: " + JSON.stringify(err));
                this.error = JSON.stringify(err);
                this.result = undefined;
            });
        } 
    }
    handleDepDate(event){
        let valuedatetime = event.target.value;
        console.log("selectDate:" + valuedatetime);

        let filteredEvents = this.result.filter((record, index, arrayobject) => {
            return record.Departure_Date_Time__c >=valuedatetime;

        });
        this.recordsToDisplay = filteredEvents;
    }

    handleLocationSearch(event){
        let keyword = event.detail.value;

        let filteredEvents = this.result.filter((record,index,arrayobject) => {
            return record.Location.toLowerCase().includes(keyword.toLowerCase);
        });
        if(keyword && keyword.length >=2) {
            this.recordsToDisplay = filteredEvents;

        } else {
            this.recordsToDisplay = this.result;
        }
    }
}
