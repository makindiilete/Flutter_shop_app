import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shop_app/Screens/addEditProductScreen.dart';
import 'package:shop_app/Screens/cartScreen.dart';
import 'package:shop_app/Screens/orderScreen.dart';
import 'package:shop_app/Screens/productDetailsScreen.dart';
import 'package:shop_app/Screens/productOverviewScreen.dart';
import 'package:shop_app/Screens/userProductsScreen.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/authProvider.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/ordersProvider.dart';
import 'package:shop_app/providers/productsProvider.dart';

import 'Screens/authScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // We wrap our MaterialApp widget with multiple providers (cart and product provider)
    return MultiProvider(
      providers: [
        //Auth provider
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        //product provider
        ChangeNotifierProvider.value(
          value: ProductsProvider(),
        ),
        //cart provider
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
        ChangeNotifierProvider.value(
          value: OrderProvider(),
        )
      ],
      child: new MaterialWidget(),
    );
  }
}

class MaterialWidget extends StatefulWidget {
  @override
  _MaterialWidgetState createState() => _MaterialWidgetState();
}

class _MaterialWidgetState extends State<MaterialWidget> {
  bool _isAuth;
  bool _isInit = true;

  @override
  Future didChangeDependencies() async {
    super.didChangeDependencies();
    //if the component just loaded, we want to fetch authentication status of the user
    if (_isInit) {
      final response = await Provider.of<AuthProvider>(context).isAuth();
      setState(() {
        _isAuth = response;
        _isInit = true;
      });
    }
    _isInit = false; //after the component is loaded, we set ds to false
  }

  @override
  Widget build(BuildContext context) {
    // print("_isInit = $_isInit And _isAuth = $_isAuth");
    final authStatus = Provider.of<AuthProvider>(context).isAuthenticated;
    print("auth status from main = $authStatus");
    // verifyAuth(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SLOT',
      theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.redAccent,
          fontFamily: "Roboto",
          // ds setup a our custom route config as default.. U can use different custom route config for different OS
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          })),
      home:
          //if d user is authenticated we return d shop screen
          authStatus
              ? ProductsOverviewScreen()
              : AuthScreen(), // we make our authScreen our home...
      routes: {
        ProductsOverviewScreen.routeName: (context) => ProductsOverviewScreen(),
        AuthScreen.routeName: (context) => AuthScreen(),
        ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        CartScreen.routeName: (context) => CartScreen(),
        OrderScreen.routeName: (context) => OrderScreen(),
        UserProductsScreen.routeName: (context) => UserProductsScreen(),
        AddEditProductScreen.routeName: (context) => AddEditProductScreen(),
      },
    );
  }
}
