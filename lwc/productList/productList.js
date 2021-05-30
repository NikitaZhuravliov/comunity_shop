import {LightningElement, wire} from 'lwc';
import getProducts from '@salesforce/apex/ProductListController.getProducts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ProductList extends LightningElement {
    categoryId;
    products;
    error;

    connectedCallback() {
        let param = 'category';
        this.categoryId = this.getUrlParamValue(window.location.href, param);

        this.loadProducts();
    }

    getUrlParamValue(url, key) {
        return new URL(url).searchParams.get(key);
    }

    loadProducts() {
        getProducts({category : this.categoryId})
            .then(result => {
                this.products = result;
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleSuccess(event) {
        const toastEvent = new ShowToastEvent({
            title: "The Product was added to the Basket.",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }

    handleError(event) {
        const toastEvent = new ShowToastEvent({
            title: "The Total Quantity is more then are available in the stock.",
            variant: "error"
        });
        this.dispatchEvent(toastEvent);
    }

}