import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/productsProvider.dart';

class ProductDetailScreen extends StatelessWidget {
//  final String title;
//
//  ProductDetailScreen({@required this.title});
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    // we extract d route args (product id) passed to ds screen from productItem which is a string.
    final productId = ModalRoute.of(context).settings.arguments as String;
    // We use dt id to find the first product dt matches d given id in the provider store and store it inside our 'loadedProduct; variable
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(
            productId); // 'listen: false' is added in other to tell ds component not to listen to any product change, because we definitely have nothing inside the details screen we will want to change when the product details screen is rendered, so make it stop listening to the store change, default is 'true' which is not required if its true

    final nigeriaNaira =
        new NumberFormat.currency(locale: "en_NG", symbol: "₦");

    final Currency naira =
        Currency.create('NGN', 0, symbol: '₦', pattern: 'S0');
    Money nairaPrice = Money.fromInt(1099, naira);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct
            .title), // from d 'loadedProduct' we can now get the title of the tapped product and render it in d appBar of the productDetailScreen
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double
                  .infinity, // d container sud take the full available width
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
//            Text("$Money.from(loadedProduct.price, naira)",
            Text(
              "${Money.from(loadedProduct.price, naira)}",
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                "${loadedProduct.description}",
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
