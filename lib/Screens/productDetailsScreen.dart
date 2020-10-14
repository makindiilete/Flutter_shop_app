import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
//  final String title;
//
//  ProductDetailScreen({@required this.title});
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    // we extract d route args (product id) passed to ds screen from productItem which is a string.
    final productId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
    );
  }
}
