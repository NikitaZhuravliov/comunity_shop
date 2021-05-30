public with sharing class CategoryListController {

    @AuraEnabled
    public static  Map<String, Map<String, String>> getCategories() {
        Map<String, Map<String, String>> categoriesData = new Map<String, Map<String, String>>();

        try {
            List<Category__c> categoryList = new List<Category__c>();
            categoryList = [SELECT Id, Name FROM Category__c];

            for(Category__c category : categoryList) {
                Map<String, String> categories = new Map<String, String>();
                categories.put('categoryId', category.Id);
                categories.put('categoryName', category.Name);

                List<Product__c> products = new List<Product__c>();
                products = [SELECT Product_Quantity__c FROM Product__c WHERE Product_Category__c = :category.Id];

                Decimal productsCount = 0;
                for(Product__c product : products) {
                    productsCount = productsCount + product.Product_Quantity__c;
                }
                categories.put('productQuantity', String.valueOf(productsCount));

                categoriesData.put(category.Id, categories);
            }

            return categoriesData;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}