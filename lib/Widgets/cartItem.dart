import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cartProvider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String imgUrl;

  CartItem({this.id, this.price, this.quantity, this.title, this.imgUrl});
  @override
  Widget build(BuildContext context) {
    final nigeriaNaira =
        new NumberFormat.currency(locale: "en_NG", symbol: "₦");
    return
//      Dismissible widget make our a widget render on screen removable via swipe
        Dismissible(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            //cart item price
            leading: Image.network(
              imgUrl, // d image link
              fit: BoxFit.cover, // we make our image have css cover attribute
              width: 50,
            ),
            /*            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text("\$$price")),
              ),*/

//          cart item title
            title: Text(title),

//          cart item total price
            subtitle: Column(
              children: <Widget>[
                Text(
                  "Price: ${nigeriaNaira.format(price)}",
                ),
                Text(
                  "Total: ${nigeriaNaira.format(price * quantity)}",
                ),
              ],
            ),
//          cart item quantity
            trailing: Text("$quantity x"),
          ),
        ),
      ),
      // ds key will be used to track the items getting deleted
      key: ValueKey(id),
      // ds define the background color for the dismiss action
      background: Container(
        color: Theme.of(context).errorColor,
// We render a delete icon so the user can know what the swipe does
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight, // ds center the icon vertically right
        padding: EdgeInsets.only(
            right:
                20), //ds 20px padding to the right of the dismissible background
        margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical:
                4), // ds add margin to make sure the d background does not cover the card fully at the back
      ),
      direction: DismissDirection
          .endToStart, // ds ensure we cant swipe on both edge to delete but only from right to left
      // we call d onDismissed method to remove the product from the list when we swipe right to left
      onDismissed: (direction) {
//        if(direction == DismissDirection.endToStart){} // u can check for d direction user swipes if swiping from both direction is possible
        final cart = Provider.of<CartProvider>(context);
        cart.removeItem(id);
      },
    );
  }
}
