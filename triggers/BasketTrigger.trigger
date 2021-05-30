trigger BasketTrigger on Basket__c (before insert) {
    for(Basket__c basket : Trigger.new) {
        Id productId = basket.Product__c;
        Product__c product = [SELECT Product_Quantity__c FROM Product__c WHERE Id = :productId LIMIT 1];
        Decimal basketTotalProductQuantity = basket.Total_Quantity__c;

        if(basketTotalProductQuantity > product.Product_Quantity__c) {
            basket.addError('The Total Quantity is more then are available in the stock');
        }
    }
}
