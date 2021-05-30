import { LightningElement, track } from 'lwc';
import getBasketList from '@salesforce/apex/BasketController.getBasketList';
import deleteBasketById from '@salesforce/apex/BasketController.deleteBasketById';
import createOrder from '@salesforce/apex/OrderController.createOrder';

export default class BasketList extends LightningElement {
    @track mapData= [];
    error;

    connectedCallback() {
        this.loadBaskets();
    }

    loadBaskets() {
        getBasketList()
            .then(result => {
                let map1 = result; // {1 === {totalPrice=3000, ...}}
                for (let key1 in map1) {
                    let map2 = map1[key1]; // {totalPrice=3000, ...}

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

    clearBasket(event) {
        let basketId = event.target.value;
        deleteBasketById({ basketId : basketId });
        location.reload();
    }

    createOrder(event) {
        let basketId = event.target.value;
        createOrder({ basketId : basketId });
        location.reload();
    }
}