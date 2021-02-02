import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/products.dart';

class ProductDetails extends StatelessWidget {
  // final String title;
  // ProductDetails(this.title);

  static const routeName = 'product-details';

  @override
  Widget build(BuildContext context) {

    // use productID to query the global state of products
    final productId = ModalRoute.of(context).settings.arguments as String;

    // The widget wont rebuild everytime the global data changes, it is only used to get data from 
    // the storage but wont ever really require an update when app state changes
    final currentProduct = Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: currentProduct.id,
                child: Image.network(
                  currentProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              '${currentProduct.title} - \$${currentProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                currentProduct.description, 
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}