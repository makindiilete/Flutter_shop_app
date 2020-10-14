import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:shop_app/Screens/productDetailsScreen.dart';
import 'package:shop_app/Screens/productOverviewScreen.dart';
import 'package:shop_app/providers/productsProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // We wrap our MaterialApp widget with our ChangeNotifierProvider so we can attach the store to ds component
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          ProductsProvider(), // we call d create method from which we return our store/Provider class so now we can setup a listener in another widget and from there access the store
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato"),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen()
        },
      ),
    );
  }
}
