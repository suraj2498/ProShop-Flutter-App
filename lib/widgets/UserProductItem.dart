import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

import '../screens/EditProductScreen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function deleteProduct;

  UserProductItem(
    this.id,
    this.title,
    this.imageUrl,
    this.deleteProduct
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.1),
            offset: Offset(0,0),
            blurRadius: 7
          )
        ]
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18
          ),
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          minRadius: 25,
          maxRadius: 25,
        ),
        trailing: Container(
          width: 100,
          child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                  onPressed: (){
                    Navigator.of(context).pushNamed(
                      EditProductScreen.routeName,
                      arguments: id
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red,),
                  onPressed: () async {
                    try {
                      await deleteProduct(id);
                    } catch(e) {
                      Flushbar(
                        message: "Product was not deleted please try again",
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
                )
              ],
            ),
        ),
        
      ),
    );
  }
}