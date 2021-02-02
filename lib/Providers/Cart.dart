import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  // Map to associate products with the cart items
  Map<String, CartItem> _items = {};

  // get all items
  Map<String, CartItem> get items {
    return {..._items};
  }

  // get total item counts
  int get itemCount {
    var count = 0;
    _items?.forEach((key, value) {
      count += value.quantity;
    });

    return count;
  }

  // Get total price for all items
  double get totalPrice {
    var sum = 0.0;
    _items.forEach((key, value) {
      sum += value.price * value.quantity;  
    });

    return sum;
  }

  // add a new item
  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      // change thee quantity
      _items.update( productId, (oldCartItem) => CartItem(
          id: oldCartItem.id, 
          title: oldCartItem.title, 
          quantity: oldCartItem.quantity + 1, 
          price: oldCartItem.price
        )
      );
    } else {
      // add new entry
      _items.putIfAbsent( productId, () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1
        )
      );
    }

    notifyListeners();
  }

  // remove an Item from the cart
  void removeItem(String productId){
    _items.remove(productId);

    notifyListeners();
  }

  // Clear all items from the cart
  void clearCart() {
    _items = {};
    notifyListeners();
  }

}
