import 'package:flutter/material.dart';

class Cart {
  final String cartItemId;
  final String cartItemTitle;
  final String cartItemImgUrl;
  int cartItemQuantity;
  final double cartItemPrice;

  Cart(
      {this.cartItemImgUrl,
      @required this.cartItemId,
      @required this.cartItemTitle,
      @required this.cartItemQuantity,
      @required this.cartItemPrice});
}
