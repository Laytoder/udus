import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/helpers/confirmationDialog.dart';
import 'package:frute/widgets/inputModal.dart';

import '../AppState.dart';

class CartPage extends StatefulWidget {
  AppState appState;

  CartPage({
    @required this.appState,
  });

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE0E5EC),
        body: Column(children: [
          SizedBox(height: 60),
          Text(
            "Cart",
            style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                decoration: TextDecoration.none),
          ),
          SizedBox(height: 20),
          Expanded(
              child: ListView.separated(
            itemCount: widget.appState.order.purchasedVegetables.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
              height: 7,
              thickness: 1.2,
              indent: 75,
              endIndent: 75,
            ),
            itemBuilder: (context, index) => Neumorphic(
                style: NeumorphicStyle(
                  border: NeumorphicBorder(
                    color: Color(0xffE0E5EC),
                    width: 2,
                  ),
                  depth: 8,
                ),
                child: Dismissible(
                    key: Key(
                        '${widget.appState.order.purchasedVegetables[index].name}'),
                    confirmDismiss: (direction) => showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Remove item from cart ?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Remove")),
                                FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("Cancel"),
                                ),
                              ],
                            );
                          },
                        ),
                    onDismissed: (direction) {
                      setState(() {
                        widget.appState.order.purchasedVegetables
                            .removeAt(index);
                      });
                    },
                    child: InkWell(
                        onTap: () async {
                          double quantity = await showDialog(
                              context: context,
                              builder: (context) {
                                return InputModal();
                              });
                          if (quantity == null) return;
                          setState(() {
                            widget.appState.order.purchasedVegetables[index]
                                .quantity = quantity;
                          });
                        },
                        child: Container(
                            height: 100,
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                SizedBox(width: 20),
                                Image.asset(
                                    widget.appState.order
                                        .purchasedVegetables[index].imageUrl,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.contain),
                                SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        '${widget.appState.order.purchasedVegetables[index].name}',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 24.0,
                                            decoration: TextDecoration.none)),
                                    SizedBox(height: 5),
                                    Text(
                                        '${widget.appState.order.purchasedVegetables[index].quantity} gm',
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 18.0,
                                            decoration: TextDecoration.none)),
                                  ],
                                )
                              ],
                            ))))),
          ))
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if ((await getSurity(context))) {

            }
          },
        ));
  }
}
