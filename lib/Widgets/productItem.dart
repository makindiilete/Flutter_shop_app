import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/productDetailsScreen.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/productsProvider.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final bool isFavorite;
  final double price;

  ProductItem(
      {this.id, this.title, this.imageUrl, this.isFavorite, this.price});

  @override
  Widget build(BuildContext context) {
    //access to ProductsProvider/ product store
    final product = Provider.of<ProductsProvider>(context);
    //access to cartProvider/cart store
    final cart = Provider.of<CartProvider>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      // GridTile is used in combination with GridView which gives us a kind of card with footer and header
      child: GridTile(
        child: GestureDetector(
          // On tap of our product image, we navigate to the product detail screen sending along the id of the product we tapped, we push the product detail on top of the product item screen
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailScreen.routeName, arguments: id);
          },
          child: Image.network(
            imageUrl, // d image link
            fit: BoxFit.cover, // we make our image have css cover attribute
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87, // d background color of the footer
          leading: IconButton(
              // check if the isFavorite field of the specific product is true then render a full heart, else render a border heart
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              // onPress, toggle the state of the icon
              onPressed: () => product.toggleFavoriteStatus(
                  id)), // widget to display b4 the footer title/text
          title: Text(
            title,
            textAlign: TextAlign.center,
          ), // text to display as the footer title
          trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addProductToCart(id, price, title, imageUrl);
              }), // widget to display after the title tet
        ),
      ),
    );
  }
}
