import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/orderScreen.dart';
import 'package:shop_app/Screens/userProductsScreen.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/authProvider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _userEmail = "";
  bool _isInit = true;

  @override
  Future didChangeDependencies() async {
    //if the component just loaded, we want to fetch authentication status of the user
    if (_isInit) {
      final response = await Provider.of<AuthProvider>(context).getUserEmail();
      setState(() {
        _userEmail = response;
        _isInit = true;
      });
    }
    _isInit = false; //after the component is loaded, we set ds to false
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(_userEmail),
            automaticallyImplyLeading:
                false, // ds is added so that when we open the menu, we do not have another menu icon on the sidebar
          ),
//          Divider(),
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
              onTap: () {
                /*Navigator.of(context)
                  .pushReplacementNamed(OrderScreen.routeName);*/
                //Using our custom route with our set animation
                Navigator.of(context).pushReplacement(
                    CustomRoute(builder: (context) => OrderScreen()));
              }),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            //on tap of the icon, we navigate to the userProductsScreen page
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              //on tap of the icon, we navigate to the userProductsScreen page
              onTap: () async {
                await Provider.of<AuthProvider>(context).logOut();
                Navigator.of(context).pushNamed("/auth");
              })
        ],
      ),
    );
  }
}
