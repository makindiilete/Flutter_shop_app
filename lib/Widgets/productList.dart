import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/addEditProductScreen.dart';
import 'package:shop_app/providers/productsProvider.dart';

class ProductList extends StatelessWidget {
  final String id; // we now expect an id
  final String title;
  final String imageUrl;

  ProductList({this.title, this.imageUrl, this.id});
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final navigator = Navigator.of(context);
    final dialogWidget = Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text(
              "Are you sure?",
              textAlign: TextAlign.center,
            ),
            content: Text("Do you want to remove the product from the cart?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () async {
                  try {
                    await Provider.of<ProductsProvider>(context)
                        .deleteProduct(id);
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(SnackBar(
                      content: Text(
                        "Product Successfully Deleted",
                        textAlign: TextAlign.center,
                      ), // d widget we want to show in the popup
                      duration: Duration(
                          seconds: 2), //how long d popup will show b4 dismiss
                    ));
                    navigator.pop();
                  } catch (error) {
                    //here we will no longer have access to the "Scaffold.of(context) & Navigator.of(context)" so we need to use the declared variables on line 17 & 18
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(SnackBar(
                      content: Text(
                        "Deleting Failed!",
                        textAlign: TextAlign.center,
                      ), // d widget we want to show in the popup
                      duration: Duration(
                          seconds: 2), //how long d popup will show b4 dismiss
                    ));
                    navigator.pop();
                  }
                },
                child: Text("Yes"),
              )
            ],
          )
        : AlertDialog(
            title: Text("Are you sure?"),
            content: Text("Do you want to remove the item from the cart?"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No"),
              ),
              FlatButton(
                onPressed: () async {
                  try {
                    await Provider.of<ProductsProvider>(context)
                        .deleteProduct(id);
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(SnackBar(
                      content: Text(
                        "Product Successfully Deleted",
                        textAlign: TextAlign.center,
                      ), // d widget we want to show in the popup
                      duration: Duration(
                          seconds: 2), //how long d popup will show b4 dismiss
                    ));
                    navigator.pop();
                  } catch (error) {
                    //here we will no longer have access to the "Scaffold.of(context) & Navigator.of(context)" so we need to use the declared variables on line 17 & 18
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(SnackBar(
                      content: Text(
                        "Deleting Failed!",
                        textAlign: TextAlign.center,
                      ), // d widget we want to show in the popup
                      duration: Duration(
                          seconds: 2), //how long d popup will show b4 dismiss
                    ));
                    navigator.pop();
                  }
                },
                child: Text("Yes"),
              )
            ],
          );
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            imageUrl), // U can also use AssetImage() if d image is stored locally
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
//              on press of the edit icon, we navigate to the AddEditProductScreen passing in the id of the product we want to edit
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddEditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              // on press of the delete icon, we show a dialog to confirm if the user truly want to delete
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => dialogWidget);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
