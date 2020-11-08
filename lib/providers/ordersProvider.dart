import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http; // importing the http package as http
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/model/cart.dart';
import 'package:shop_app/model/order.dart';

class OrderProvider with ChangeNotifier {
  //Create a secured localStorage
  List<Order> _orders = [];

  //ds method return complete list of all orders placed
  List<Order> getOrders() {
    return _orders;
  }

  //GET
  fetchAndSetOrders() async {
    var prefs = await SharedPreferences.getInstance();
    var data = json.decode(prefs.getString('userData')) as Map<String, Object>;
    var token = data['token'];
    var userId = data['userId'];
    // final url = "https://fluttershopapp-b1ed5.firebaseio.com/orders.json?auth=$token";

    // we want to fetch orders only by logged in user
    final url =
        "https://fluttershopapp-b1ed5.firebaseio.com/orders/$userId.json?auth=$token";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Order> loadedOrders = [];
      // we using '?' to safely access forEach only if the list is not null
      extractedData?.forEach((orderId, orderData) {
        loadedOrders.add(Order(
            id: orderId,
            amount: orderData['amount'],
            // we map our products objects from the server to our Cart model as list
            products: (orderData['products'] as List<dynamic>)
                .map((product) => Cart(
                    cartItemId: product['id'],
                    cartItemPrice: product['price'],
                    cartItemQuantity: product['quantity'],
                    cartItemTitle: product['title'],
                    cartItemImgUrl: product['imageUrl']))
                .toList(),
//            dateTime: orderData['dateTime']));
            dateTime: DateTime.parse(orderData['dateTime'])));
      });
      _orders = loadedOrders.reversed
          .toList(); // to sort the orders in descending order (d latest orders ontop)
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //POST
  // ds method will get a list of cart items and the total amount and then insert it at the beginning of the orders list so recent orders appear first..
  addOrder(List<Cart> cartProducts, double totalAmount) async {
    var prefs = await SharedPreferences.getInstance();
    var data = json.decode(prefs.getString('userData')) as Map<String, Object>;
    var token = data['token'];
    var userId = data['userId'];
    //Configuring http post request (firebase)
    final url =
        "https://fluttershopapp-b1ed5.firebaseio.com/orders/$userId.json?auth=$token"; // adding a new order, we add it under the logged in userId
    //we setting the date time here so there will not be any difference btw the time the order is placed on the server and local..
    final timeOrderWasPlaced = DateTime.now();
    try {
      //we store the order on the server
      final response = await http.post(url,
          body: json.encode({
            "amount": totalAmount,
            "dateTime": timeOrderWasPlaced.toIso8601String(),
//            we map our cartProducts to an object extracting key/value pairs to be stored in the server
            "products": cartProducts
//            we map each products fields to a list of objects so we can store it on the server as [{}, {}]
                .map((product) => {
                      "id": product.cartItemId,
                      "title": product.cartItemTitle,
                      "imageUrl": product.cartItemImgUrl,
                      "price": product.cartItemPrice,
                      "quantity": product.cartItemQuantity
                    })
                .toList(),
          }));
      print(json.decode(response.body));
      // we store the order locally...
      _orders.insert(
          0,
          Order(
              id: json.decode(response.body)['name'],
              amount: totalAmount,
              products: cartProducts,
              dateTime: timeOrderWasPlaced));
      notifyListeners(); //we notify our listeners
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
