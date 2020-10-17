import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Widgets/appDrawer.dart';
import 'package:shop_app/Widgets/orderItem.dart';
import 'package:shop_app/providers/ordersProvider.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/orders"; // ds is the route path for ds component
  @override
  Widget build(BuildContext context) {
    //inject the orderProvider
    final order = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer:
          AppDrawer(), // we make the drawer available to the orderScreen as well
      //map the list of all orders to an OrderItem widget
      body: order.getOrders().length == 0
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
                    "Oops! You have no order right now..",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: order.getOrders().length,
              itemBuilder: (context, index) => OrderItem(
                    purchasedOrder: order.getOrders()[index],
                  )),
    );
  }
}
