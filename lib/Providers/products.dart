// Products provider
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './Product.dart';

class Products with ChangeNotifier {

  final String authToken;
  final String userId;
  List<Product> _items;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id){
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    
    String url;

    if(filterByUser){
      url = 'https://shop-app-b2c74-default-rtdb.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
    }
    else{
      url = 'https://shop-app-b2c74-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    }

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      
      if(extractedData == null) return;

      url = 'https://shop-app-b2c74-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      extractedData.forEach((productId, productData) {
        loadedProducts.insert(
          0, 
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite: favoriteData == null ? false : favoriteData[productId] ?? false
          )
        );
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addProduct(Product product) async {

    // async auto returns a future
    final url = 'https://shop-app-b2c74-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        url, 
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId
        })
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl
      );

      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
    
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = 'https://shop-app-b2c74-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final itemIndex = _items.indexWhere((element) => element.id == id);

    try {
      if(itemIndex >= 0){
        await http.patch(
          url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          })
        );

        _items[itemIndex] = newProduct;
        notifyListeners();
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    // optimistic updating 
    final url = 'https://shop-app-b2c74-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);

    try {
      await http.delete(url);
      existingProduct = null;
      notifyListeners();  
    } catch (error) {
      // if the delete fails
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();  
      throw error;
    }
  }

}