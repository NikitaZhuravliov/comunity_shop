import {LightningElement, track} from 'lwc';
import getOrderList from '@salesforce/apex/OrderController.getOrderList';
import deleteAllOrders from '@salesforce/apex/OrderController.deleteAllOrders';

export default class OrderList extends LightningElement {
    @track mapData= [];
    error;

    connectedCallback() {
        this.loadOrders();
    }

    loadOrders() {
        getOrderList()
            .then(result => {
                let map1 = result; // {1 === {orderId='...'}}
                for (let key1 in map1) {
                    let map2 = map1[key1]; // {orderId='...', ...}

                    let newMap = [];
                    for (let key2 in map2) {
                        if (key2 !== 'basketId' && key2 !== 'productId') {
                            newMap.push({
                                value: map2[key2],
                                key: key2
                            })
                        }
                    }

                    this.mapData.push({
                        value: newMap,
                        key: key1
                    });

                }
            })
            .catch(error => {
                this.error = error;
            });
    }

    deleteAllOrders(event) {
        deleteAllOrders();
        location.reload();
    }
}