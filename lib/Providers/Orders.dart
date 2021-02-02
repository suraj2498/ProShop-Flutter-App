import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


import 'Cart.dart';

class OrderItem {

  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime timeOrdered;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.timeOrdered
  });

}

class Orders with ChangeNotifier{

  List<OrderItem> _orders;
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = '{API}';
    final List<OrderItem> loadedOrders = [];
    
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData?.forEach((orderId, orderData) {
        loadedOrders.insert(0, OrderItem(
          id: orderId,
          amount: orderData['amount'],
          timeOrdered: DateTime.parse(orderData['timeOrdered']),
          products: (orderData['products'] as List<dynamic>).map((item) => CartItem(
            id: item['id'],
            price: item['price'],
            quantity: item['quantity'],
            title: item['title']
          )).toList()
        ));
      });
      
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }

  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = '{API}';
    final currentTime = DateTime.now();

    try {
      // add an order to the orders collection
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'timeOrdered': currentTime.toIso8601String(),
          'products': cartProducts.map((cartProduct) => {
            'id': cartProduct.id,
            'title': cartProduct.title,
            'quantity': cartProduct.quantity,
            'price': cartProduct.price
          }).toList()
        })
      );

      _orders.insert(0, OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        timeOrdered: currentTime
      ));

      notifyListeners();

    } catch (error) {
      throw error;
    }
  }

}
