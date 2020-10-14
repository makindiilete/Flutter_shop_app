import 'package:flutter/material.dart';
import 'package:shop_app/Screens/productDetailsScreen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      // GridTile is used in combination with GridView which gives us a kind of card with footer and header
      child: GridTile(
        child: GestureDetector(
          // On tap of our product image, we navigate to the product detail screen, we push the product detail on top of the product item screen
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
              icon: Icon(
                Icons.favorite,
                color: Theme.of(context).accentColor,
              ),
              onPressed: null), // widget to display b4 the footer title/text
          title: Text(
            title,
            textAlign: TextAlign.center,
          ), // text to display as the footer title
          trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: null), // widget to display after the title tet
        ),
      ),
    );
  }
}
