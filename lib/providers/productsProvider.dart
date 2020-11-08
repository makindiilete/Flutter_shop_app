import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http; // importing the http package as http
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/model/httpException.dart';
import 'package:shop_app/model/product.dart';

//ProductsProvider extends ChangeNotifier
class ProductsProvider with ChangeNotifier {
  //Create a secured localStorage

  List<Product> _items = [
    /* Product(
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
        isFavorite: false),*/
  ];

//  bool _showFavoriteOnly = false;

  //GET
  fetchAndSetProducts([bool filterByUser = false]) async {
    var prefs = await SharedPreferences.getInstance();
    var data = json.decode(prefs.getString('userData')) as Map<String, Object>;
    var token = data['token'];
    var userId = data['userId'];

    //if the filterByUser is set to true, we attach the filter product by id params to the url
    var filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://fluttershopapp-b1ed5.firebaseio.com/products.json?auth=$token&$filterString'; // ds url is specific to firebase, it fetched product by the given userId ( order the product by creatorId and return only products where the creatorId is equal to the userId)
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body)
          as Map<String, dynamic>; // ds returns an array of objects
      if (extractedData == null) {
        return;
      }
      // we make a second http request to fetch the products added to favorite table for the logged in user
      url =
          "https://fluttershopapp-b1ed5.firebaseio.com/userFavorites/$userId.json?auth=$token";
      final favProductResponse = await http.get(url);
      // we decode our returned response to an object.. ds will return our product id and favorite value
      final favoriteProductData = json.decode(favProductResponse.body);
      final List<Product> loadedProducts =
          []; // we init an empty list which will store our returned products later
      //for each object returned, we map the id as our product id and each respective fields
      // we using '?' to safely access forEach only if the list is not null
      extractedData?.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageurl'],
            price: prodData['price'],
            // d isFavorite status comes from the api call to userFavorites table and it contains key/value pair of the product id (prodId) and d boolean value so we can map it using 'favoriteProductData[prodId]'
            // we check if the user has not added any product to favorite and set all product to false, else we set the defined boolean value in d db as the isFavorite status of each product.. also if prodId is null we set to false
            isFavorite: favoriteProductData == null
                ? false
                : favoriteProductData[prodId] ?? false));
      });
      // we now set our _items list to the mapped fetched products
      _items = loadedProducts;
      print("Products response = $extractedData");
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  // CREATE
  //Re-writing our http request with async..await & try..catch block
  addProduct(Product product) async {
    var prefs = await SharedPreferences.getInstance();
    var data = json.decode(prefs.getString('userData')) as Map<String, Object>;
    var token = data['token'];
    var userId = data['userId'];
    //Configuring http post request (firebase)
    final url =
        "https://fluttershopapp-b1ed5.firebaseio.com/products.json?auth=$token"; // base url + '/products' (ds creates a product table/object)
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageurl': product.imageUrl,
            'price': product.price,
            'creatorId': userId // id of the logged in user dt creates d product
          }));
      print(json.decode(response
          .body)); // ds prints an object  {name: -MKfrdpAK5GEoxYwSFRW}, so we can extract the value using the name key and use it as our id
      // we then add the product locally
      final newProduct = Product(
          price: product.price,
          imageUrl: product.imageUrl,
          description: product.description,
          title: product.title,
          id: json.decode(response.body)[
              'name']); // we extract d value of the name key and use it as our id
      _items.add(product); // we add d product here (adds to the end)
      //  _items.insert(0, product); // add the product to the beginning of the list
      fetchAndSetProducts();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error; // we throw the error so we can catch and use it inside our widget
    }
  }

  //PATCH => Update the product with the given id
  // ds method updates an existing product
  updateProduct(String id, Product newProduct) async {
    //find d index of d product with the given id
    var productIndex = _items.indexWhere((product) => product.id == id);
    // if the product cannot be found then its index will be -1
    if (productIndex >= 0) {
      var prefs = await SharedPreferences.getInstance();
      var data =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      var token = data['token'];
      final url =
          "https://fluttershopapp-b1ed5.firebaseio.com/products/$id.json?auth=$token"; // d firebase url for a given product id
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageurl': newProduct.imageUrl,
            'price': newProduct.price,
//              'isFavorite': newProduct.isFavorite // we dont edit the isFavorite status when we edit an existing product so firebase will not touch this as we are not sending it
          }));
      fetchAndSetProducts();
      notifyListeners();
    } else {
      print("Product not found");
    }
  }

  //DELETE
  //ds method delete a product from the list and on the server
  deleteProduct(String id) async {
    var prefs = await SharedPreferences.getInstance();
    var data = json.decode(prefs.getString('userData')) as Map<String, Object>;
    var token = data['token'];
    final url =
        "https://fluttershopapp-b1ed5.firebaseio.com/products/$id.json?auth=$token";
    // we copy the index of the product to be deleted
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    // we use the index to reference the product in the _items list
    var existingProduct = _items[existingProductIndex];
    //we delete the product locally (optimistic update)
    _items.removeAt(existingProductIndex);
    notifyListeners();
    // we then try to delete the product from the server
    final response = await http.delete(url);
    // if the deletion fails, we check d status code if its in d range of 400 and throw our custom exception so we make it to the catchError block...
    if (response.statusCode >= 400) {
      print("Error catch block entered");
      // if the server deletion fails, we revert the product
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could Not Delete Product!");
    }
    existingProduct = null;
  }

  //ds method toggle the favorite property of a product
  toggleFavoriteStatus(String id) async {
    // index of the product
    var existingProductIndex = _items.indexWhere((product) => product.id == id);
    // d product itself
    var existingProduct = _items[existingProductIndex];
    // existing isFavorite value
    var existingProductFavoriteStatus = existingProduct.isFavorite;
    print(
        "existingProductIndex = $existingProductIndex -- existingProduct = $existingProduct -- existingProductFavoriteStatus = $existingProductFavoriteStatus ");
    // if 'isFavorite' is true, set it to false, else set it to true
    existingProduct.isFavorite = !existingProduct.isFavorite;
    // notify all subscribers of the change
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    var data = json.decode(prefs.getString('userData')) as Map<String, Object>;
    var token = data['token'];
    var userId = data['userId'];
    // final url = "https://fluttershopapp-b1ed5.firebaseio.com/products/$id.json?auth=$token";
    // we change the url of id to a new one dt includes d id of the authenticated user so each user will have unique api for favorites products

    /*
    "https://fluttershopapp-b1ed5.firebaseio.com/userFavorites/$userId/$id.json : - creates a 'userFavorites' object/table, inside the object, create a another object with the userId, the object contains the product user has added to favorite (the product id as property and the value passed to this request
    */

    final url =
        "https://fluttershopapp-b1ed5.firebaseio.com/userFavorites/$userId/$id.json?auth=$token";
    var response =
        await http.put(url, body: json.encode(existingProduct.isFavorite));
    // var response = await http.patch(url, body: json.encode({'isFavorite': !existingProductFavoriteStatus}));
    notifyListeners();
    if (response.statusCode >= 400) {
      // if the server deletion fails, we revert the isFavorite status of the product
      existingProduct.isFavorite = existingProductFavoriteStatus;
      notifyListeners();
      throw HttpException("Could Not Set As Favorite");
    }
    existingProduct = null;
  }

  // This method is a getter that we call to retrieve list of products in the store
  List<Product> getProducts() {
    return _items;
  }

  // return only favorite products
  List<Product> favoriteItems() {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  //ds method return the product with the given id
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
