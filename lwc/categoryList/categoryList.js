import {LightningElement, track} from 'lwc';
import getCategories from '@salesforce/apex/CategoryListController.getCategories';

export default class categoryList extends LightningElement {
    @track mapData= [];
    error;

    connectedCallback() {
        this.loadCategories();
    }

    loadCategories() {
        console.log('hello');
        getCategories()
            .then(result => {
                let map1 = result; // {'a015e00000B7VqaAAF' === {categoryId='a015e00000B7VqaAAF',...}}
                for (let key1 in map1) {
                    let map2 = map1[key1]; // {categoryId='a015e00000B7VqaAAF', ...}

                    let categoriesQuantity = '';
                    for (let key2 in map2) {
                        if(key2 === 'categoryName') {
                            categoriesQuantity = categoriesQuantity + map2[key2];
                        }

                        if(key2 === 'productQuantity' && categoriesQuantity !== '') {
                            categoriesQuantity = categoriesQuantity + ' (' + map2[key2] + ')';
                        }
                    }

                    this.mapData.push({
                        value: categoriesQuantity,
                        key: key1
                    });

                }
            })
            .catch(error => {
                this.error = error;
            });
    }

    handleClick(event) {
        let categoryId = event.target.value;
        window.location.href = "/s/products?category=" + categoryId;
    }
}