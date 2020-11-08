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
    final scaffold = Scaffold.of(context);
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
          child:
              // we will b using the image for hero animation on d product detail page so we wrap d image with hero and gv it a tag (a unique id selector we can use to select it from d other component)
              Hero(
            tag: id,
            child: FadeInImage(
              placeholder: AssetImage("lib/assets/images/loader.gif"),
              image: NetworkImage(imageUrl),
              /* child: Image.network(
                imageUrl, // d image link
                fit: BoxFit.cover, // we make our image have css cover attribute
              ),*/
            ),
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
              onPressed: () async {
                try {
                  await product.toggleFavoriteStatus(id);
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(SnackBar(
                    content: Text(
                      "Favorite Status Updated!",
                      textAlign: TextAlign.center,
                    ), // d widget we want to show in the popup
                    duration: Duration(
                        seconds: 2), //how long d popup will show b4 dismiss
                  ));
                } catch (error) {
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(SnackBar(
                    content: Text(
                      "Something Went Wrong!",
                      textAlign: TextAlign.center,
                    ), // d widget we want to show in the popup
                    duration: Duration(
                        seconds: 2), //how long d popup will show b4 dismiss
                  ));
                }
              }), // widget to display b4 the footer title/text
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
//                using scaffold ds way, we establish connection to d nearest scaffold widget dt controls d page we are seeing which is the product overview scaffold where we r calling d product item. (even though ds productItem immediate parent is productGrid bt there is no scaffold widget inside productGrid so we go higher to d overall parent which is productOverviewScreen)..
                // ds remove the previous snackBar in other to quickly show the next one in case we are adding products rapidly
                Scaffold.of(context).hideCurrentSnackBar();
                //if we have a scaffold already dt is creating a screen inside ds widget then ds will not work
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Item Added To Cart!",
                    textAlign: TextAlign.center,
                  ), // d widget we want to show in the popup
                  duration: Duration(
                      seconds: 2), //how long d popup will show b4 dismiss
                  action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () => cart.undoItemCartAddition(
                          id)), //we can also offer user an action like UNDO to undo the action
                )); // we can call d 'Scaffold.of(context).openDrawer();' onCLick of d cart icon if the nearest scaffold do av a drawer and product overview does
              }), // widget to display after the title tet
        ),
      ),
    );
  }
}
