import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './helpers/customRoute.dart';
import './screens/SplashScreen.dart';
import './Providers/Auth.dart';
import './screens/AuthScreen.dart';
import './screens/EditProductScreen.dart';
import './screens/UserProductsScreen.dart';
import './screens/OrdersScreen.dart';
import './screens/CartScreen.dart';
import './Providers/Cart.dart';
import './Providers/products.dart';
import './screens/ProductDetails.dart';
import './screens/ProductsOverview.dart';
import './Providers/Orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // Material App and all of its children will now have access ot this instance of the Products class
  // Only widgets that listen will be rebuilt not the entire material app
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (_, authData, prevProducts) => Products(authData.token, authData.userId, prevProducts == null ? [] : prevProducts.items)
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (_, authData, prevOrders) => Orders(authData.token, authData.userId, prevOrders == null ? [] : prevOrders.orders)
        )
      ],
      child: Consumer<Auth>(
        builder:(ctx, authData, _){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ProShop',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              accentColor: Colors.white,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Poppins',
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(), 
                  TargetPlatform.iOS: CustomPageTransitionBuilder(), 
                }
              )
            ),
            home: authData.isAuth ? ProductsOverview() : FutureBuilder(
              future: authData.tryAutoLogin(),
              builder: (ctx, snapshot) => 
                snapshot.connectionState == ConnectionState.waiting ? 
                  SplashScreen() : AuthScreen()
            ),
            routes: {
              ProductDetails.routeName: (_) => ProductDetails(),
              CartScreen.routeName: (_) => CartScreen(),
              OrdersScreen.routeName: (_) => OrdersScreen(),
              UserProductsScreen.routeName: (_) => UserProductsScreen(),
              EditProductScreen.routeName: (_) => EditProductScreen()
            },
          );
        },
      ) 
    );
  }
}

