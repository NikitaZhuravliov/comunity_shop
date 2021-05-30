public with sharing class BasketController {
    @AuraEnabled
    public static Map<String, Map<String, String>> getBasketList() {
        Map<String, Map<String, String>> baskets = new Map<String, Map<String, String>>();
        Id userId = UserInfo.getUserId();

        List<Basket__c> basketList = new List<Basket__c>();
        basketList = [SELECT Id, Product__r.Id, Product__r.Name, Product__r.Product_Price__c, Product__r.Product_Category__c, Total_Quantity__c
            FROM Basket__c
            WHERE CreatedById = :userId
        ];

        if(basketList.size() != 0) {
            for(Basket__c basketItem : basketList) {
                Map<String, String> basket = new Map<String, String>();
                basket.put('productName', basketItem.Product__r.Name);
                List<Category__c> categories = new List<Category__c>();
                categories = [SELECT Name FROM Category__c WHERE Id = :basketItem.Product__r.Product_Category__c];
                for(Category__c category : categories) {
                    basket.put('productCategory', category.Name);
                }
                basket.put('totalQuantity', String.valueOf(basketItem.Total_Quantity__c.format()));
                Decimal totalPrice = basketItem.Product__r.Product_Price__c * basketItem.Total_Quantity__c;
                basket.put('totalPrice', String.valueOf(totalPrice.format()));
                basket.put('basketId', basketItem.Id);
                basket.put('productId', basketItem.Product__r.Id);


                baskets.put(basketItem.Id, basket);
            }
        }

        return baskets;
    }

    @AuraEnabled
    public static void deleteBasketById(Id basketId) {
        // We know that we have only one record with the same Id.
        delete [SELECT Id FROM Basket__c WHERE Id = :basketId];
    }

    // Get basket data by Id.
    public static Map<String, String> getBasketDataById(Id basketId) {
        List<Basket__c> basketList = new List<Basket__c>();
        basketList = [SELECT Id, Product__r.Id, Product__r.Name, Product__r.Product_Price__c, Product__r.Product_Category__c, Total_Quantity__c
            FROM Basket__c
            WHERE Id = :basketId
        ];

        Map<String, String> basketData = new Map<String, String>();

        // We know that we have only one record with the same Id.
        for(Basket__c basket : basketList) {
            basketData.put('basketId', basket.Id);
            basketData.put('productId', basket.Product__r.Id);
            basketData.put('totalQuantity', String.valueOf(basket.Total_Quantity__c));
            basketData.put('productPrice', String.valueOf(basket.Product__r.Product_Price__c));
        }

        return basketData;
    }
}