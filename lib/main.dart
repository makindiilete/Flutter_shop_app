import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shop_app/Screens/cartScreen.dart';
import 'package:shop_app/Screens/orderScreen.dart';
import 'package:shop_app/Screens/productDetailsScreen.dart';
import 'package:shop_app/Screens/productOverviewScreen.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/ordersProvider.dart';
import 'package:shop_app/providers/productsProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // We wrap our MaterialApp widget with multiple providers (cart and product provider)
    return MultiProvider(
      providers: [
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SLOT',
        theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.redAccent,
            fontFamily: "Lato"),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrderScreen.routeName: (context) => OrderScreen(),
        },
      ),
    );
  }
}
