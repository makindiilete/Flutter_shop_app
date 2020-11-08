import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/model/httpException.dart'; // importing the http package as http

class AuthProvider with ChangeNotifier {
  // fields not final bcos they will change with time
  String _token;
  DateTime _expiryDate;
  String _userId;
  String userEmail;
  bool isAuthenticated = false;

  //Create a secured localStorage

  //checks if user is auth
  Future<bool> isAuth() async {
    // storage.delete(key: "token");
    final token = await getToken();
    print("Gotten token = $token");
    //if d getToken method does not return null
    if (token != null) {
      print("You are auth");
      return true;
    }
    print("You are not auth");
    return false;
  }

  Future<String> getUserEmail() async {
    var prefs = await SharedPreferences.getInstance();
    var data = json.decode(prefs.getString('userData')) as Map<String, Object>;
    var token = data['token'];
    //expiryDate : - firebase returns expiry in total seconds as string
    // var token = await storage.read(key: "token");
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken["email"];
  }

  Future<String> getUserId() async {
    //expiryDate : - firebase returns expiry in total seconds as string
    // var token = await storage.read(key: "token");
    var prefs = await SharedPreferences.getInstance();
    var data = json.decode(prefs.getString('userData')) as Map<String, Object>;
    var token = data['token'];
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken["user_id"];
  }

  //logout
  logOut() async {
    var prefs = await SharedPreferences.getInstance();
    // delete all tokens and userIds
    // var token = await storage.deleteAll();
    prefs.clear();
    notifyListeners();
  }

  //returns the token
  Future<String> getToken() async {
    //expiryDate : - firebase returns expiry in total seconds as string
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') != null) {
      var data =
          json.decode(prefs.getString('userData')) as Map<String, Object>;
      var token = data['token'];
      // var token = await storage.read(key: "token");
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print("Decoded token = $decodedToken");
      /* isExpired() - you can use this method to know if your token is already expired or not.
  An useful method when you have to handle sessions and you want the user
  to authenticate if has an expired token */
      bool isTokenExpired = JwtDecoder.isExpired(token);
      print("Token expired = $isTokenExpired");
      // if token is present and not expired, we return it
      if (token != null && !isTokenExpired) {
        return token;
      }
    }
    // else we return null
    return null;
  }

  //Register a user
  signUp(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBygXVgWNY_AqWrz4ad_RtF59Z89183Nf8";
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      final responseData = json.decode(response.body);
      //firebase error handler
      if (responseData['error'] != null) {
        //our custom error exception
        throw HttpException(responseData['error']['message']);
      }
      // if we get no error then we extract and store our token
      _token = responseData['idToken'];
      //userid
      _userId = responseData['localId'];
      //expiryDate : - firebase returns expiry in total seconds as string
      var firebaseExpiry = responseData['expiresIn'];
      // we convert it to int
      var expiryToInt = int.parse(firebaseExpiry);
      // we then add it to the current time so we get the future projection of the expiry
      _expiryDate = DateTime.now().add(Duration(seconds: expiryToInt));
      //store the token

      // storage.write(key: "token", value: _token);
      // var prefs = await SharedPreferences.getInstance();

      //store the user Id
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(responseData['idToken']);
      // storage.write(key: "userId", value: decodedToken["user_id"]);

      //store the tokenExpiry
      // storage.write(key: "tokenExpiry", value: firebaseExpiry);

      var prefs = await SharedPreferences.getInstance();
      var authDetails = json.encode({
        "token": _token,
        "userId": decodedToken["user_id"],
        "tokenExpiry": firebaseExpiry
      });
      prefs.setString("userData", authDetails);
      notifyListeners();
    }
    // other errors not from firebase e.g. network connection
    catch (error) {
      throw error;
    }
  }

  //login a user
  signIn(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBygXVgWNY_AqWrz4ad_RtF59Z89183Nf8";
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      //firebase error handler
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData['error']['message']);
        throw HttpException(responseData['error']['message']);
      }
      // if we get no error then we extract and store our token
      _token = responseData['idToken'];
      //userid
      _userId = responseData['localId'];
      //expiryDate : - firebase returns expiry in total seconds as string
      var firebaseExpiry = responseData['expiresIn'];
      // we convert it to int
      var expiryToInt = int.parse(firebaseExpiry);
      // we then add it to the current time so we get the future projection of the expiry
      _expiryDate = DateTime.now().add(Duration(seconds: expiryToInt));
      //store the token
      // storage.write(key: "token", value: _token);

      //store the user Id
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(responseData['idToken']);
      // storage.write(key: "userId", value: decodedToken["user_id"]);
      //store the tokenExpiry
      // storage.write(key: "tokenExpiry", value: firebaseExpiry);

      var prefs = await SharedPreferences.getInstance();
      var authDetails = json.encode({
        "token": _token,
        "userId": decodedToken["user_id"],
        "tokenExpiry": firebaseExpiry
      });
      prefs.setString("userData", authDetails);

      notifyListeners();
    }
    // other errors not from firebase e.g. network connection
    catch (error) {
      throw error;
    }
  }
}
