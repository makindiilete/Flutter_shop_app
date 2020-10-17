import 'package:flutter/material.dart';
import 'package:shop_app/model/cart.dart';
import 'package:shop_app/model/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  //ds method return complete list of all orders placed
  List<Order> getOrders() {
    return _orders;
  }

  // ds method will get a list of cart items and the total amount and then insert it at the beginning of the orders list so recent orders appear first..
  void addOrder(List<Cart> cartProducts, double totalAmount) {
    _orders.insert(
        0,
        Order(
            id: DateTime.now().toString(),
            amount: totalAmount,
            products: cartProducts,
            dateTime: DateTime.now()));
    notifyListeners(); //we notify our listeners
  }
}
