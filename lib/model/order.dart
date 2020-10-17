import 'package:flutter/foundation.dart';
import 'package:shop_app/model/cart.dart';

class Order {
  final String id;
  final double amount; // total amount of the total
  final List<Cart> products;
  final DateTime dateTime;

  Order(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}
