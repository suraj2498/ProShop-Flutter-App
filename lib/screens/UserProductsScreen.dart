import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/EditProductScreen.dart';
import '../widgets/MainDrawer.dart';
import '../widgets/UserProductItem.dart';
import '../Providers/products.dart';

class UserProductsScreen extends StatelessWidget {

  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    
    // final productsContainer = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ? 
        Center(child: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor,))
        :
        RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          backgroundColor: Theme.of(context).primaryColor,
          child: Consumer<Products>(
            builder: (ctx, productsContainer, child) => productsContainer.items.length == 0 ? Center(
              child: Text(
                'No Products to show',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20
                ),
              ),
            ) : Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemBuilder: (_, index) => UserProductItem(
                  productsContainer.items[index].id,
                  productsContainer.items[index].title, 
                  productsContainer.items[index].imageUrl,
                  productsContainer.deleteProduct
                ),
                itemCount: productsContainer.items.length,
              )
            ),
          ),
        ),
      ),
    );
  }
}