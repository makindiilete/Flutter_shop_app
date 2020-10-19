import 'package:flutter/material.dart';
import 'package:shop_app/model/cart.dart';

class CartProvider with ChangeNotifier {
  List<Cart> _items = [];

  // ds method returns all items available in the cart
  List<Cart> getCartItems() {
    return _items;
  }

  //ds method return the total quantity of products in the cart
  int getTotalCartItemCount() {
    var count = 0;
    _items.forEach((cartItem) => count += cartItem.cartItemQuantity);
    return count;
  }

  // ds method return the total sum of all items quantity in the cart
  double getTotalAmount() {
    var total = 0.0;
//    we loop tru all items in d cart and multiple their price by their quantity to get the total cost of d items in d cart
    _items.forEach((cartItem) =>
        total += cartItem.cartItemPrice * cartItem.cartItemQuantity);
    return total;
  }

  //ds method is used to add a product to the cart
  void addProductToCart(String productId, double productPrice,
      String productTitle, String imgUrl) {
    if (_items.length == 0) {
      // if there are no products in the cart at all, add the product
      _items.add(Cart(
        cartItemImgUrl: imgUrl,
        cartItemId: productId,
        cartItemTitle: productTitle,
        cartItemQuantity: 1,
        cartItemPrice: productPrice,
      ));
    }
    // else if there are products in the cart,
    else {
      //return the first product in the cart with the 'productId', if no product is found with the id, return null
      var cartItem = _items.firstWhere((item) => item.cartItemId == productId,
          orElse: () => null);
      //if the product in question does not match any product in the cart then add it to the cart
      if (cartItem == null) {
        _items.add(Cart(
            cartItemImgUrl: imgUrl,
            cartItemId: productId,
            cartItemTitle: productTitle,
            cartItemQuantity: 1,
            cartItemPrice: productPrice));
      } else {
        //If a matching product is found in the cart, increment its quantity
        cartItem.cartItemQuantity = cartItem.cartItemQuantity + 1;
      }
    }
    //notify all subscribers
    notifyListeners();
  }

  //ds method remove the item with a given id from the cart
  void removeItem(String productId) {
    _items.removeWhere((item) => item.cartItemId == productId);
    notifyListeners();
  }

  // ds method is called to remove the recently added item from cart, we cannot use the removeItem() above bcos we want to be able to first see if we can reduce quantity and not just remove d item in total
  void undoItemCartAddition(String productId) {
    var itemToRemove =
        _items.firstWhere((item) => item.cartItemId == productId);
    // if the item to be removed is not in cart, we return doing nothing
    if (!_items.contains(itemToRemove)) {
      return;
    }
    // else if the item is present but the quantity is more than one, we reduce the quantity
    else if (itemToRemove.cartItemQuantity > 1) {
      itemToRemove.cartItemQuantity = itemToRemove.cartItemQuantity - 1;
    }
    // if the quantity is not more than one, we remove the item in total
    else {
      _items.removeWhere((item) => item.cartItemId == productId);
    }
    notifyListeners();
  }

  //ds method will be called to clear all items in the cart when we click on the order button to place an order
  void clear() {
    _items = [];
    notifyListeners();
  }
}
