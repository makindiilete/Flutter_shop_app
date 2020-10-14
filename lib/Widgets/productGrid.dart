import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Widgets/productItem.dart';
import 'package:shop_app/providers/productsProvider.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(
        context); // here we setup a listener to the store
    final loadedProducts = productsData
        .getProducts(); // now dt we have access to the store, we can call the method to retrieve all products
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10, // 10px space btw d grids on the horizontal axis
          mainAxisSpacing: 10 //10px space btw d grids on the vertical axis
          ), // we will have 2 columns in reach grid on a row
      itemBuilder: (context, index) => ProductItem(
        title: loadedProducts[index].title,
        id: loadedProducts[index].id,
        imageUrl: loadedProducts[index].imageUrl,
      ), // itemBuilder takes a context and index and return a widget to be rendered for each item we want to have in the grid
      itemCount: loadedProducts
          .length, // d total length of the items dt d grid will render
      padding:
          EdgeInsets.all(10.0), // 10px padding at all direction of the grid
    );
  }
}
