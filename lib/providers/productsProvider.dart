import 'package:flutter/material.dart';
import 'package:shop_app/model/product.dart';

//ProductsProvider extends ChangeNotifier
class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Samsung Galaxy Z Fold 2',
        description: 'A mind-blending glass screen that folds like a book.',
        price: 895000,
        imageUrl: 'https://slot.ng/wp-content/uploads/2020/09/Z-flip-2.jpg',
        isFavorite: false),
    Product(
        id: 'p2',
        title: 'APPLE MACBOOK PRO',
        description:
            'Macbook pro 15, 2019 edition, Intel Core I9, 16gb RAM 512gb ROM.',
        price: 1050000,
        imageUrl: 'https://slot.ng/wp-content/uploads/2020/10/macbook-pro.jpg',
        isFavorite: false),
    Product(
        id: 'p3',
        title: '128GB SD Card',
        description: '128GB SD Card',
        price: 13000,
        imageUrl: 'https://slot.ng/wp-content/uploads/2019/09/64GB.png',
        isFavorite: false),
    Product(
        id: 'p4',
        title: 'APPLE AIRPODS PRO',
        description: 'Active noise cancellation for immersive sound',
        price: 120000,
        imageUrl: 'https://slot.ng/wp-content/uploads/2020/03/airpod-pro.jpg',
        isFavorite: false),
  ];

//  bool _showFavoriteOnly = false;

  // This method is a getter that we call to retrieve list of products in the store
  List<Product> getProducts() {
    // if showFac=vOnly has been toggle to false, we show only favorite products
//    if (_showFavoriteOnly) {
//      return _items.where((item) => item.isFavorite).toList();
//    }
    // else we return all products
    return _items;
  }

  //ds method set the showFavoriteOnly property to true/false
/*  void toggleShowFavoriteOnly(bool value) {
    _showFavoriteOnly = value;
    notifyListeners();
  }*/

  // return only favorite products
  List<Product> favoriteItems() {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  //ds method return the product with the given id
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // we call ds method to add a new product we receive outside
  void addProduct(Product product) {
    final newProduct = Product(
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
        title: product.title,
        isFavorite: false,
        id: DateTime.now().toString());
    _items.add(product); // we add d product here (adds to the end)
    //  _items.insert(0, product); // add the product to the beginning of the list
    notifyListeners(); // we then notify all components connected to ds provider (store) of the new change so they can rebuild their list
  }

//ds method toggle the favorite property of a product
  void toggleFavoriteStatus(String id) {
    //find d product with the given id
    var favorite = _items.firstWhere((product) => product.id == id);
    // if 'isFavorite' is true, set it to false, else set it to true
    favorite.isFavorite = !favorite.isFavorite;
    // notify all subscribers of the change
    notifyListeners();
  }

  // ds method updates an existing product
  void updateProduct(String id, Product newProduct) {
    //find d index of d product with the given id
    var productIndex = _items.indexWhere((product) => product.id == id);
    // if the product cannot be found then its index will be -1
    if (productIndex >= 0) {
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print("Product not found");
    }
  }

  //ds method delete a product from the list
  void deleteProduct(String id) {
    //find the product with the given id
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
