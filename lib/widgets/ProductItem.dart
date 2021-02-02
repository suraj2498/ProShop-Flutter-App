import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';

import '../Providers/Auth.dart';
import '../Providers/Cart.dart';
import '../screens/ProductDetails.dart';
import '../Providers/Product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context, listen: false);
    final cartContainer = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: Offset(0,0),
            blurRadius: 10
          )
        ]
      ),
      child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: Container(
            child: GestureDetector(
              child: Hero(
                tag: productData.id,
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/product-placeholder.png'),
                  image: NetworkImage(productData.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              onTap: (){
                Navigator.of(context).pushNamed(
                  ProductDetails.routeName,
                  arguments: productData.id
                );
              },
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.blueGrey.withOpacity(0.8),
            leading:Container(
              width: 30,
              child: Consumer<Product>(
                  builder: (ctx, product, child) => IconButton(
                    color: productData.isFavorite ? Colors.red : Colors.white,
                    icon: Icon(
                      productData.isFavorite ? Icons.favorite : Icons.favorite_border_rounded
                    ),
                    padding: EdgeInsets.all(0),
                    iconSize: 26,
                    onPressed: () async {
                      try {
                        await product.toggleFavoriteStatus(authData.token, authData.userId);
                      } catch (_) {
                        Flushbar(
                          message: "Something went wrong",
                          icon: Icon(
                            Icons.cancel_outlined,
                            size: 28.0,
                            color: Colors.white,
                          ),
                          borderRadius: 8,
                          backgroundColor: Colors.red,
                          margin: EdgeInsets.all(8),
                          duration: Duration(seconds: 2),
                        ).show(context);
                      }
                    },
                  ),
              ),
            ),
            title: Text(
              productData.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16
              )
            ),
            trailing: Container(
              width: 30,
              child: IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(Icons.shopping_bag),
                padding: EdgeInsets.all(0),
                iconSize: 26,
                onPressed: (){
                  cartContainer.addItem(productData.id, productData.title, productData.price);
                  Flushbar(
                    message: "${productData.title} added to cart",
                    icon: Icon(
                      Icons.check,
                      size: 28.0,
                      color: Colors.white,
                    ),
                    borderRadius: 8,
                    backgroundColor: Colors.green,
                    margin: EdgeInsets.all(8),
                    duration: Duration(seconds: 2),
                  ).show(context);
                },
              ),
            ),
              
          ),
        ),
      ),
    );
  }
}
