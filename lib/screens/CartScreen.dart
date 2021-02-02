import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';

import '../widgets/SingleCartItem.dart';
import '../Providers/Cart.dart';
import '../Providers/Orders.dart';

class CartScreen extends StatelessWidget {

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {

    final cartContainer = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: Text('My Bag')),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 30,
              left: 15, 
              right: 15, 
              bottom: 20
            ),
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54.withOpacity(0.15),
                  offset: Offset(0,0),
                  blurRadius: 10
                )
              ]
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                      Text(
                        '\$ ${cartContainer.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Taxes',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                      Text(
                        '\$ ${(cartContainer.totalPrice * 0.08).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(thickness: 1, indent: 10, endIndent: 10,),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    Chip(
                      label: Text(
                        '\$ ${(cartContainer.totalPrice + cartContainer.totalPrice * 0.08).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        )
                      ),
                      backgroundColor: Theme.of(context).primaryColor
                    )
                  ],
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: OrderButton(cartContainer: cartContainer),
                )
              ],
            )
          ),
          Expanded(
            child: cartContainer.items.length > 0 ? ListView.builder(
              itemBuilder: (ctx, index) => SingleCartItem(
                cartContainer.items.values.toList()[index].id,
                cartContainer.items.values.toList()[index].title,
                cartContainer.items.values.toList()[index].price,
                cartContainer.items.values.toList()[index].quantity,
                cartContainer.items.keys.toList()[index]
              ),
              itemCount: cartContainer.items.length,
            ) : Center(
              child: Text('No Items in the Cart'),
            )
          )
        ],
      ),
    );
  }
}



class OrderButton extends StatefulWidget {
  const OrderButton({
    @required this.cartContainer,
  });

  final Cart cartContainer;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: _isLoading ? Container(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          strokeWidth: 2,
        ),
      ) : Text('Order Now'),
      textColor: Colors.white,
      color: Colors.blueGrey[400],
      onPressed: (widget.cartContainer.totalPrice > 0 && !_isLoading) ? () async {
        
        setState(() {
          _isLoading = true;
        });

        try {
          await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cartContainer.items.values.toList(),
            widget.cartContainer.totalPrice
          );

          setState(() {
            _isLoading = false;
          });

          widget.cartContainer.clearCart();  
          Flushbar(
            message: "Order Placed Successfully",
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
        } catch (e) {
          Flushbar(
            message: "Something went wrong when placing your order",
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
        
      } : null,
    );
  }
}