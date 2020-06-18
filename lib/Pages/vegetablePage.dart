import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/models/vendorInfo.dart';
import 'dart:io';

class VegetablePage extends StatefulWidget {
  AppState appState;
  String userId;
  VegetablePage(this.appState, this.userId);
  @override
  _VegetablePageState createState() => _VegetablePageState();
}

class _VegetablePageState extends State<VegetablePage> {
  List<Vegetable> vegetables = [];

  @override
  void initState() {
    super.initState();

    AppState appState = widget.appState;
    String userId = widget.userId;
    List<Vegetable> normal = [], special = [];
    VendorInfo vendor = appState.verdors[userId];
    normal.addAll(vendor.normalVegetables);
    special.addAll(vendor.specialVegetables);
    normal.addAll(special);
    vegetables = normal;
  }

  selectImageType(String link) {
    if (link.startsWith('https'))
      return NetworkImage(link);
    else
      return AssetImage(link);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: vegetables.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: selectImageType(vegetables[index].imageUrl),
          ),
          title: Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              Text(vegetables[index].name),
            ],
          ),
          subtitle: Text(vegetables[index].quantity.toString() + '/kg'),
          trailing: Text('\u20B9' + vegetables[index].price.toString()),
        );
      },
    );
  }
}
