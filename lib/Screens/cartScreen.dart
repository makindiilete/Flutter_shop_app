import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Widgets/cartItem.dart';
import 'package:shop_app/providers/cartProvider.dart';
import 'package:shop_app/providers/ordersProvider.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart";
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final order = Provider.of<OrderProvider>(context);
    final nigeriaNaira =
        new NumberFormat.currency(locale: "en_NG", symbol: "₦");
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body:
//      if the cart is empty we want to render text center on the screen
          cart.getCartItems().length == 0
              ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).primaryColor,
                        size: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Shopping Cart Is Empty",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.all(15),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // ds space out our items equally on the row
                          children: <Widget>[
                            Text(
                              "Total",
                              style: TextStyle(fontSize: 20),
                            ),
                            Spacer(), //ds will push all d items on d right of ds widget to the far right
                            //chip - an element wt rounder corner like badge which we can use to display information.. it takes a label which will display the total sum of all items quantity in d cart
                            Chip(
                              label: Text(
                                "${nigeriaNaira.format(
                                  cart.getTotalAmount(),
                                )}",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .title
                                        .color),
                              ), // we call our totalAmount method to return d amount to show
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            FlatButton(
//                              on click of the ORDER NOW button, we call d addOrder button and pass list of our cart items and d total amount
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  // we try to place the order on the server
                                  try {
                                    await order.addOrder(cart.getCartItems(),
                                        cart.getTotalAmount());
                                    cart.clear(); // we clear our cart after placing the order
                                  }
                                  // if we get an error, we catch it and display notification
                                  catch (error) {
                                    await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text("An Error Occurred!"),
                                              content:
                                                  Text("Something Went Wrong!"),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text("Okay"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            ));
                                  }
                                  // whether we are successful or not, we reset the loading icon to false
                                   finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                child: _isLoading
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "ORDER NOW",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
//          Since we want to render a list inside a column, we wrap it in an expanded widget
                    Expanded(
                      child: ListView.builder(
                          itemBuilder: (context, index) => CartItem(
                                id: cart.getCartItems()[index].cartItemId,
                                title: cart.getCartItems()[index].cartItemTitle,
                                price: cart.getCartItems()[index].cartItemPrice,
                                quantity:
                                    cart.getCartItems()[index].cartItemQuantity,
                                imgUrl:
                                    cart.getCartItems()[index].cartItemImgUrl,
                              ),
                          itemCount: cart.getCartItems().length),
                    )
                  ],
                ),
    );
  }
}
