import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/models/vegetable.dart';

import '../AppState.dart';

import 'package:frute/widgets/MinimalPageHeading.dart';
import 'package:frute/config/borderRadius.dart';
import 'package:frute/Pages/optimalRoutesPage.dart';
import 'package:frute/helpers/optimalTripRouteFinder.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  final AppState appState;

  CartPage({
    Key key,
    @required this.appState,
  }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double height;

  double width;

  bool loading = false;

  Widget buildCartBody(int extraindex) {
    if (widget.appState.order.isNotEmpty)
      return ListView.builder(
        shrinkWrap: true,
        primary: false,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: widget.appState.order.length % 2 == 0
            ? widget.appState.order.length ~/ 2
            : widget.appState.order.length ~/ 2 + 1,
        itemBuilder: (context, index) {
          extraindex += 2;
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 11,
                  bottom: 8,
                ),
                child: CartTiles(widget.appState.order[extraindex]),
              ),
              SizedBox(
                width: 6,
              ),
              extraindex + 1 < widget.appState.order.length
                  ? Padding(
                      padding: EdgeInsets.only(
                        right: 11,
                        bottom: 8,
                      ),
                      child: CartTiles(widget.appState.order[extraindex + 1]),
                    )
                  : SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ],
          );
        },
      );

    return Container(
      height: height * 0.52,
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: height * 0.1,
            ),
            Container(
              child: Image(
                image: AssetImage('assets/nocart.png'),
                height: 200,
                width: 200,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 30,
              ),
              child: Text(
                'Your cart is empty!',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff8c8c8c),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    int extraindex = -2;

    return Scaffold(
      body: loading
          ? Stack(
              children: <Widget>[
                Center(
                  child: Image(
                    image: AssetImage('assets/ripple.gif'),
                    height: 200,
                    width: 200,
                  ),
                ),
                Center(
                  child: CircleAvatar(
                    backgroundColor: Color(0xff111c21),
                    backgroundImage: AssetImage('assets/udus.png'),
                    radius: 50,
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MinimalPageHeading(heading: "Cart"),
                        buildCartBody(extraindex)
                      ],
                    ),
                  ),
                ),
                widget.appState.order.length != 0
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 55.0, right: 15),
                          child: FloatingActionButton(
                            child: Icon(Icons.check),
                            onPressed: () async {
                              print('ran');
                              List<VendorInfo> vendors = [];
                              for (String userId in widget.appState.userId) {
                                vendors.add(widget.appState.vendors[userId]);
                              }
                              OptimalTripRoutesFinder finder =
                                  OptimalTripRoutesFinder(
                                homeLocation: GeoPoint(
                                  widget.appState.userLocation.latitude,
                                  widget.appState.userLocation.longitude,
                                ),
                                order: widget.appState.order,
                                vendors: vendors,
                              );
                              print('figuring route');
                              setState(() => loading = true);
                              dynamic optimalRoute =
                                  await finder.getOptimalTripRoute();
                              /*await Future.delayed(
                                Duration(
                                  seconds: 5,
                                ),
                              );*/
                              /*if (optimalRoute ==
                                  OptimalTripRoutesFinder.NO_OPTIMAL_ORDER)
                                print(
                                    'NO OPTIMAL ORDER..................................');
                              else {
                                print(optimalRoute.toJson());
                                print(
                                    'computed route................................');
                              }*/
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OptimalRoutesPage(
                                    optimalTripRoute: optimalRoute,
                                  ),
                                ),
                              );
                              setState(() => loading = false);
                            },
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      ),
              ],
            ),
    );
  }
}

class CartTiles extends StatefulWidget {
  final Vegetable vegetable;
  CartTiles(this.vegetable);
  @override
  CartTilesState createState() => CartTilesState();
}

class CartTilesState extends State<CartTiles> {
  double height;

  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      height: ((width - 29) / 2),
      width: ((width - 29) / 2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Colors.grey[100],
          // border: Border(
          //     bottom: BorderSide(color: Colors.grey[100]),
          //     right: BorderSide(color: Colors.grey[100]))
        ),
        child: Column(
          children: [
            Row(
              textDirection: TextDirection.ltr,
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10.0,
                      top: 13.0,
                    ),
                    child: CircleAvatar(
                      //height: width / 4,
                      //width: width / 4,
                      radius: 40,
                      backgroundImage: AssetImage(widget.vegetable.imageUrl),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    //logic for adjusting text
                    widget.vegetable.name.contains(' ')
                        ? "${widget.vegetable.name.split(' ')[0]}\n${widget.vegetable.name.split(' ')[1]}"
                        : widget.vegetable.name.length > 8
                            ? "${widget.vegetable.name.substring(0, 8)}-\n-${widget.vegetable.name.substring(8)}"
                            : widget.vegetable.name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(widget.vegetable.dispQuantity),
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(icon: Icon(Icons.cancel_outlined), onPressed: () {}),
                IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Select your Quantity'),
                        actions: [
                          TextButton(
                            child: Text(
                              'CONFIRM',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                        content: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          spacing: 10,
                          runSpacing: 20,
                          children: [
                            QuantityDialog(),
                            QuantityDialog(),
                            QuantityDialog(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class QuantityDialog extends StatefulWidget {
  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  double height;

  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      child: Container(
        height: (50 / 820) * height,
        width: (60 / 411) * width,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            '250 g',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
