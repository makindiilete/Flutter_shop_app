import 'package:flutter/material.dart';
import 'package:shop_app/Screens/orderScreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Hello Friend!"),
            automaticallyImplyLeading:
                false, // ds is added so that when we open the menu, we do not have another menu icon on the sidebar
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            //on tap of the icon, we want to go home
            onTap: () => Navigator.of(context).pushReplacementNamed("/"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            //on tap of the icon, we navigate to the orders page
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrderScreen.routeName),
          )
        ],
      ),
    );
  }
}
