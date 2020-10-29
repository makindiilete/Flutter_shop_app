import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/addEditProductScreen.dart';
import 'package:shop_app/Widgets/appDrawer.dart';
import 'package:shop_app/Widgets/productList.dart';
import 'package:shop_app/providers/productsProvider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  // ds is async function dt is called when we pull to refresh
  _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    //access to ProductsProvider/ product store
    final product = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          //we add a plus icon to the navbar and onclick navigate us to the AddEditProductScreen
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.of(context)
                  .pushNamed(AddEditProductScreen.routeName))
        ],
      ),
      drawer: AppDrawer(),
      body:
          // we wrap our widget with RefreshIndicator() dt gives us pull to refresh
          RefreshIndicator(
        // onRefresh calls an async function defined in the providers class dt fetch all products
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (context, index) => Column(
              children: <Widget>[
                ProductList(
                  title: product.getProducts()[index].title,
                  imageUrl: product.getProducts()[index].imageUrl,
                  id: product.getProducts()[index].id,
                ),
                Divider()
              ],
            ),
            itemCount: product.getProducts().length,
          ),
        ),
      ),
    );
  }
}
