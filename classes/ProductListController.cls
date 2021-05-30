public with sharing class ProductListController {

    @AuraEnabled
    public static List<Product__c> getProducts(Id category) {
        try {
            List<Product__c> productList = new List<Product__c>();
            productList = [SELECT Id, Name, Product_Description__c, Product_Picture_URL__c, Product_Price__c, Product_Quantity__c
                FROM Product__c
                WHERE Product_Category__c = :category
            ];

            return productList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Update product quantity after creating an order.
    public static void updateProduct(String productId, Decimal basketTotalQuantity) {
        Product__c product = [SELECT Product_Quantity__c FROM Product__c WHERE Id = :productId LIMIT 1];
        Decimal totalProductQuantity = product.Product_Quantity__c;
        totalProductQuantity = totalProductQuantity - basketTotalQuantity;
        if(totalProductQuantity < 3) {
            totalProductQuantity = totalProductQuantity + 5;
        }
        product.Product_Quantity__c = totalProductQuantity;

        update product;
    }
}