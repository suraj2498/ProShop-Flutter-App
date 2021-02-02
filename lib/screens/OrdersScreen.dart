import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/MainDrawer.dart';
import '../Providers/Orders.dart' show Orders;
import '../widgets/OrderItem.dart';

class OrdersScreen extends StatefulWidget {

  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  
    _isLoading = true;

    Provider.of<Orders>(context, listen: false).fetchOrders()
      .then((_){
        setState(() {
          _isLoading = false;
        });
      });
  }

  @override
  Widget build(BuildContext context) {

    final ordersContainer = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders')
      ),
      drawer: MainDrawer(),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor
        ),
      ) : (ordersContainer.orders.length > 0 ? ListView.builder(
        itemBuilder: (ctx, index) => OrderItem(ordersContainer.orders[index]),
        itemCount: ordersContainer.orders.length,
      ) : Center(
        child: Text(
          'No Order History to Show',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20
          ),
        ),
      )),
    );
  }
}