import 'dart:convert';

import 'package:frute/models/vegetable.dart';

class Bill {
  List<Vegetable> purchasedVegetables;
  double total;
  DateTime date;

  Bill(this.purchasedVegetables, this.total, this.date);

  Map toJson() {
    List<dynamic> jsonPurchasedVegs = [];
    for (Vegetable vegetable in purchasedVegetables) {
      jsonPurchasedVegs.add(vegetable.toJson());
    }
    return {
      'purchasedVegetables': jsonPurchasedVegs,
      'total': total,
      'date': date.toString(),
    };
  }

  Bill.fromJson(Map json) {
    List<dynamic> jsonPurchasedVegs = json['vegetables'];
    purchasedVegetables = [];
    print(json);
    for (dynamic jsonVeg in jsonPurchasedVegs)
      purchasedVegetables.add(Vegetable.fromJson(jsonVeg));
    //this.purchasedVegetables = purchasedVegetables;
    total = json['total'];
    date = DateTime.now();
    //print('reached');
  }
}
