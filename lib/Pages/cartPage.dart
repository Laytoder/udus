import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/models/vegetable.dart';

import '../AppState.dart';

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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    int extraindex = -2;

    if (widget.appState.order.isNotEmpty)
      return ListView(
        shrinkWrap: true,
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: (100 / 678) * height,
          ),
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            physics: NeverScrollableScrollPhysics(),
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
                      left: 8,
                      bottom: 8,
                    ),
                    child: Cart_Tiles(widget.appState.order[extraindex]),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  extraindex + 1 < widget.appState.order.length
                      ? Padding(
                          padding: EdgeInsets.only(
                            right: 8,
                            bottom: 8,
                          ),
                          child:
                              Cart_Tiles(widget.appState.order[extraindex + 1]),
                        )
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),
                ],
              );
            },
          ),
        ],
      );

    return Center(child: Text("No items in cart"));
  }
}

class Cart_Tiles extends StatefulWidget {
  Vegetable vegetable;
  Cart_Tiles(this.vegetable);
  @override
  _Cart_TilesState createState() => _Cart_TilesState();
}

class _Cart_TilesState extends State<Cart_Tiles> {
  double height;

  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
      height: ((width - 24) / 2),
      width: ((width - 24) / 2),
      child: Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          depth: 2,
          border: NeumorphicBorder(color: Colors.white, width: 0.5),
          shape: NeumorphicShape.convex,
          lightSource: LightSource.topLeft,
          shadowDarkColor: Color(0xffA3B1C6),
          shadowLightColor: Colors.white,
          //intensity: 1.0,
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              textDirection: TextDirection.ltr,
              children: [
                FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: width / 4,
                    width: width / 4,
                    child: Image.asset(widget.vegetable.imageUrl),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.vegetable.name,
                    style: TextStyle(
                      fontSize: 15,
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
                  child: Text(widget.vegetable.quantity.toString()),
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
      child: Neumorphic(
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          depth: 8,
          lightSource: LightSource.topLeft,
          color: Color(0xffEAEAEA),
        ),
        child: Container(
          height: (50 / 820) * height,
          width: (60 / 411) * width,
          child: Center(
            child: Text('250 g'),
          ),
        ),
      ),
    );
  }
}
