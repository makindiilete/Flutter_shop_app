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

  @override
  Widget build(BuildContext context) {
    return
//      ds will b an expandable card dt we can tap to reveal more content below it and hide again
        AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded
          ? min(widget.purchasedOrder.products.length * 20.0 + 110, 200)
          : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("\u20A6${widget.purchasedOrder.amount}"),
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
            // ds calculation ensures we do not av a too long expanded list for just an item and also not an infinity height for list of many items so if the first calc result is bigger than d item, it use it else for larger items, it uses 180 height
            AnimatedContainer(
                duration: Duration(milliseconds: 300),
                /*
                min(widget.purchasedOrder.products.length * 21.0 + 10, 100) : - d height of the card will not be longer than 100px... if the result of the operation (product length * 21 + 10) is less than 100, we use the value as the height (it means we do not have much product on the list) else we use 100px so we scroll the hidden part on the screen
                */
                height: _expanded
                    ? min(
                        widget.purchasedOrder.products.length * 21.0 + 10, 100)
                    : 0,
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
                                ),
                                softWrap: true,
                              ),
                              Text(
                                "\u20A6${widget.purchasedOrder.products[index].cartItemPrice}/ x${widget.purchasedOrder.products[index].cartItemQuantity}",
                                softWrap: true,
                              )
                            ],
                          ),
                        ),
                    itemCount: widget.purchasedOrder.products.length))
          ],
        ),
      ),
    );
  }
}
