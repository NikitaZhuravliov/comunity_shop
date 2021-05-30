public with sharing class OrderController {
    @AuraEnabled
    public static void createOrder(Id basketId) {
        Map<String, String> basketData = BasketController.getBasketDataById(basketId);

        if(basketData.size() > 0) {
            Decimal totalPrice = Decimal.valueOf(basketData.get('productPrice')) * Decimal.valueOf(basketData.get('totalQuantity'));

            try {
                Order__c order = new Order__c(
                        Total_Quantity__c = Decimal.valueOf(basketData.get('totalQuantity')),
                        Product__c = Id.valueOf(basketData.get('productId')),
                        Total_Price__c = totalPrice);

                insert order;

                // Update product quantity after creating an order.
                ProductListController.updateProduct(basketData.get('productId'), Decimal.valueOf(basketData.get('totalQuantity')));

                // Delete record from basket once order is created.
                BasketController.deleteBasketById(basketData.get('basketId'));

            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
    }

    @AuraEnabled
    public static Map<String, Map<String, String>> getOrderList(){
        Id userId = UserInfo.getUserId();
        String userEmail = UserInfo.getUserEmail();

        Map<String, Map<String, String>> orders = new Map<String, Map<String, String>>();

        try {
            List<Order__c> orderList = new List<Order__c>();
            orderList = [SELECT Id, Product__r.Name, Total_Quantity__c, Total_Price__c FROM Order__c WHERE CreatedById = :userId];

            if(orderList.size() != 0) {
                for(Order__c orderItem : orderList) {
                    Map<String, String> order = new Map<String, String>();
                    order.put('orderId', orderItem.Id);
                    order.put('productName', orderItem.Product__r.Name);
                    order.put('totalQuantity', String.valueOf(orderItem.Total_Quantity__c));
                    order.put('totalPrice', String.valueOf(orderItem.Total_Price__c));
                    order.put('orderedBy', userEmail);

                    orders.put(orderItem.Id, order);
                }
            }

            return orders;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteAllOrders() {
        Id userId = UserInfo.getUserId();

        try {
            List<Order__c> orderList = new List<Order__c>();
            orderList = [SELECT Id, Product__r.Name, Total_Quantity__c, Total_Price__c FROM Order__c WHERE CreatedById = :userId];

            delete orderList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}