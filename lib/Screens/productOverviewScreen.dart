import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/cartScreen.dart';
import 'package:shop_app/Widgets/appDrawer.dart';
import 'package:shop_app/Widgets/badge.dart';
import 'package:shop_app/Widgets/productGrid.dart';
import 'package:shop_app/providers/cartProvider.dart';

// we create an enum to create a label for our favorite and all
enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorite = false; // our state with a boolean property
  @override
  Widget build(BuildContext context) {
//    final product = Provider.of<ProductsProvider>(context, listen: false);
    //access to cartProvider/cart store
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
//        title: Text("SLOT"),
        title: Image.network(
          "https://slot.ng/wp-content/uploads/2019/04/logo-icon.png", // d image link
          fit: BoxFit.cover, // we make our image have css cover attribute
          color: Colors.white,
          width: 70,
        ),
        actions: <Widget>[
          //we display a popup menu modal that shows list of links on tapped
          PopupMenuButton(
            // ds function is called when we click on one of the links in d pop up menu modal.. we get d value of d link and we can then do anything base on dt value
            onSelected: (FilterOptions value) {
              // We call setState to update the state so we can pass updated value to ProductGrid()
              setState(() {
                if (value == FilterOptions.All) {
                  _showOnlyFavorite = false;
                  // return all products
//                product.toggleShowFavoriteOnly(false);
//                product.getProducts();
                } else if (value == FilterOptions.Favorites) {
                  _showOnlyFavorite = true;
                  // return only fav products
//                product.toggleShowFavoriteOnly(true);
//                product.getProducts();
                }
              });
            },
            itemBuilder: (context) => [
              // first link with a text to show only favorites products
              PopupMenuItem(
                child: Text("Only Favorite"),
                value: FilterOptions.Favorites,
              ),
              // second menu to show all products
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              )
            ],
            icon: Icon(Icons.more_vert),
          ),
          //Next to the PopUpMenuButton on the appbar, we want to render a badge to display total products in the cart
          Badge(
              child:
                  //ds return the widget/icon to render in the badge
                  IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      //a function to call when it is tapped
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      }), // a cart icon we tap to navigate to the cart screen
              //d value to show in the badge (total product in the cart)
              value: cart.getTotalCartItemCount().toString())
        ],
      ),
      drawer:
          AppDrawer(), // we make the drawer accessible to the overview screen
      body: ProductsGrid(
        showFavorite: _showOnlyFavorite,
      ), // we pass the _showOnlyFav property to ProductsGrid so it can use it to filter the products depending on the boolean value of the props
    );
  }
}
