import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppState.dart';

class CartPage extends StatelessWidget {
  AppState appState;

  CartPage({
    @required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white70,
        child: ListView.separated(
          itemCount: appState.order.purchasedVegetables.length,
          separatorBuilder: (context, index) =>
              Divider(
                color: Colors.black12,
                height: 5,
                thickness: 1.2,
                indent: 75,
                endIndent: 75,
              ),
          itemBuilder: (context, index) =>
              Container(
                  height: 100,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                          appState.order.purchasedVegetables[index].imageUrl,
                          height: 100, width: 100, fit: BoxFit.contain),
                      Text('${appState.order.purchasedVegetables[index].name}',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 24.0,
                              decoration: TextDecoration.none),
                          maxLines: 1,
                          textDirection: TextDirection.ltr),
                    ],
                  )),
        )
    );
  }
}
