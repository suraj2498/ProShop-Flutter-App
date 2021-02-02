import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops_app/Providers/Auth.dart';

import '../screens/UserProductsScreen.dart';
import '../screens/OrdersScreen.dart';

class MainDrawer extends StatelessWidget {


  Widget drawerTile(String title, IconData icon, BuildContext ctx, String routeName){
    return ListTile(
      leading: Icon(icon, color: Colors.white,),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      onTap: (){
        Navigator.of(ctx).pushReplacementNamed(routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Users',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700
              ),
            ),
            SizedBox(height: 10),
            Divider(color: Colors.white30,thickness: 1.2, indent: 20, endIndent: 20),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                drawerTile(
                  'Go Shop',
                  Icons.shop,
                  context,
                  '/'
                ),
                drawerTile(
                  'My Orders',
                  Icons.payment,
                  context,
                  OrdersScreen.routeName
                ),
                drawerTile(
                  'Manage Products',
                  Icons.edit,
                  context,
                  UserProductsScreen.routeName
                ),
                SizedBox(height: 70,),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.white,),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                    Provider.of<Auth>(context, listen: false).logout();
                  },
                )            
              ],
            ),
          ],
        ),
      ),
    );
  }
}