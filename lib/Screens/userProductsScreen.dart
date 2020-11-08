import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screens/addEditProductScreen.dart';
import 'package:shop_app/Widgets/appDrawer.dart';
import 'package:shop_app/Widgets/productList.dart';
import 'package:shop_app/providers/productsProvider.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = "/user-products";

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  bool _isInit = true;
  final product = [];
  _refreshProducts(BuildContext context) async {
    // we pass 'true' to fetch only products created by the logged in user on the edit product screen
    await Provider.of<ProductsProvider>(context).fetchAndSetProducts(true);
  }

  @override
  Future didChangeDependencies() async {
    //if the component just loaded, we want to fetch authentication status of the user
    if (_isInit) {
      await Provider.of<ProductsProvider>(context).fetchAndSetProducts(true);
      setState(() {
        _isInit = true;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var product;
    //access to ProductsProvider/ product store
    if (!_isInit) {
      product = Provider.of<ProductsProvider>(context);
    }
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
        child: _isInit
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
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
