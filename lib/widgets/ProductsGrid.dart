import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './ProductItem.dart';
import '../Providers/products.dart';

class ProductsGrid extends StatelessWidget {

  final bool showFavorites;
  ProductsGrid(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    // Since this widget listens only this widget and its children will rebuild
    final productsData = Provider.of<Products>(context);
    final products = showFavorites ? productsData.favoriteItems : productsData.items;

    return products.length == 0 ?
    Center(child: Text(
      'No Items To Show',
      style: TextStyle(
        fontSize: 20,
        color: Colors.grey
      ),
    )) 
    :
    GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2/2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15
      ), 
      itemCount: products.length,

      // the value constructor is the same thing just an alternative syntax if we 
      // dont care about the create context, if we provide data on single list items then we should use the
      // value constructor to avoid issues since flutter recylces the widget off screen and to make sure 
      // the provider keeps up with any data changes
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        // the provider is now a single instance of the current Product class -> Product()
        value: products[index],
        child: ProductItem(),
      ),
    );
  }
}