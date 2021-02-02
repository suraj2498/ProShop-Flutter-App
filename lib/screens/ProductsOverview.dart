import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/products.dart';
import '../widgets/MainDrawer.dart';
import '../screens/CartScreen.dart';
import '../Providers/Cart.dart';
import '../widgets/ProductsGrid.dart';
import '../widgets/badge.dart';

enum FilterOptions { Favorites, All }

class ProductsOverview extends StatefulWidget {
  @override
  _ProductsOverviewState createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  var _showOnlyFavorites = false;

  Future<void> _refreshProducts() async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('My Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('All Items'),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
              color: Colors.red,
            ),
            // so the IconButton doesnt rebuild
            child: IconButton(
              icon: Icon(Icons.shopping_bag),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        // Good for use in widgets where the only reason we need state is to do initial fetching
        child: FutureBuilder(
          future: Provider.of<Products>(context, listen: false).fetchProducts(),
          builder: (ctx, dataSnapshot){
            if(dataSnapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,),
              );
            else {
              if(dataSnapshot.error != null){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Something went wrong fetching your products. Please try again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                  ),
                );
              }
              else {
                return ProductsGrid(_showOnlyFavorites);
              }
            }
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
