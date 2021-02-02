import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/Cart.dart';

class SingleCartItem extends StatelessWidget {

  final String id;
  final double price;
  final String title;
  final int quantity;
  final String productId;

  SingleCartItem(
    this.id,
    this.title,
    this.price,
    this.quantity,
    this.productId
  );

  @override
  Widget build(BuildContext context) {

    final cartContainer = Provider.of<Cart>(context, listen: false);

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure you want to remove this item'),
            content: Text('Remove $title from the cart'),
            actions: [
              FlatButton(
                child: Text('No'),
                onPressed: (){
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: (){
                  Navigator.of(ctx).pop(true);
                },
              )
            ],
          )
        );
      },
      background: Container(
        child: Icon(
          Icons.delete_forever, 
          color: Colors.white,
          size: 40,
        ),
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 30)
      ),
      onDismissed: (direction){
        cartContainer.removeItem(productId);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: EdgeInsets.all(8),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black54.withOpacity(0.1),
        //       offset: Offset(0,0),
        //       blurRadius: 10
        //     ),
        //   ],
        //   borderRadius: BorderRadius.circular(10)
        // ),
        child: ListTile(
          leading: Chip(
            label: Text('\$${price.toStringAsFixed(2)}', style: TextStyle(color: Colors.white),),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          title: Text(title),
          subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
          trailing: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Text('x $quantity'),
          ),
        )
      ),
    );
  }
}