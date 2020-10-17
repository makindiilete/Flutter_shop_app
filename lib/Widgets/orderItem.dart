import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/model/order.dart';

class OrderItem extends StatefulWidget {
  final Order purchasedOrder;

  OrderItem({this.purchasedOrder});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  final nigeriaNaira = new NumberFormat.currency(locale: "en_NG", symbol: "₦");

  @override
  Widget build(BuildContext context) {
    return
//      ds will b an expandable card dt we can tap to reveal more content below it and hide again
        Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("${nigeriaNaira.format(widget.purchasedOrder.amount)}"),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                .format(widget.purchasedOrder.dateTime)),
            trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                // on click of the expand_more icon, we toggle the value of the boolean field so we can open and close it..
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
          ),
          //if we expand the card, then we render this container of scrolling list
          // ignore: sdk_version_ui_as_code
          if (_expanded)
            // ds calculation ensures we do not av a too long expanded list for just an item and also not an infinity height for list of many items so if the first calc result is bigger than d item, it use it else for larger items, it uses 180 height
            Container(
                color: Colors.black54,
                height:
                    min(widget.purchasedOrder.products.length * 20.0 + 50, 100),
                child: ListView.builder(
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.purchasedOrder.products[index]
                                    .cartItemTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                softWrap: true,
                              ),
                              Text(
                                "${nigeriaNaira.format(widget.purchasedOrder.products[index].cartItemPrice)}/ x${widget.purchasedOrder.products[index].cartItemQuantity}",
                                style: TextStyle(color: Colors.white),
                                softWrap: true,
                              )
                            ],
                          ),
                        ),
                    itemCount: widget.purchasedOrder.products.length))
        ],
      ),
    );
  }
}
