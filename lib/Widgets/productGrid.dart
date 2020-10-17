import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Widgets/productItem.dart';
import 'package:shop_app/providers/productsProvider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorite;
  ProductsGrid({this.showFavorite});
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final loadedProducts = showFavorite
        ? productsData.favoriteItems()
        : productsData.getProducts();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 10, // 10px space btw d grids on the horizontal axis
          mainAxisSpacing: 10 //10px space btw d grids on the vertical axis
          ), // we will have 2 columns in reach grid on a row
      itemBuilder: (context, index) => ProductItem(
        title: loadedProducts[index].title,
        id: loadedProducts[index].id,
        imageUrl: loadedProducts[index].imageUrl,
        isFavorite: loadedProducts[index].isFavorite,
        price: loadedProducts[index].price,
      ), // itemBuilder takes a context and index and return a widget to be rendered for each item we want to have in the grid
      itemCount: loadedProducts
          .length, // d total length of the items dt d grid will render
      padding:
          EdgeInsets.all(10.0), // 10px padding at all direction of the grid
    );
  }
}
