import 'package:flutter/cupertino.dart';
import 'package:frute/models/client.dart';
import 'package:frute/models/vegetable.dart';

class Order {
  String id;
  String state;
  String to;
  Client client;
  List<Vegetable> purchasedVegetables;
  double total;
  bool responded;

  Order({
    this.state = 'unresponded',
    @required this.client,
    @required this.purchasedVegetables,
    @required this.total,
    @required this.to,
    this.responded = false,
  });

  Map toJson() {
    List<Map<String, dynamic>> jsonPurchasedVegs = [];
    for (Vegetable vegetable in purchasedVegetables) {
      jsonPurchasedVegs.add(vegetable.toJson());
    }
    return {
      'id': id,
      'state': state,
      'client': client.toJson(),
      'purchasedVegetables': jsonPurchasedVegs,
      'total': total,
      'responded': responded,
    };
  }

  Map<String, dynamic> toFireJson() {
    List<Map<String, dynamic>> jsonPurchasedVegs = [];
    for (Vegetable vegetable in purchasedVegetables) {
      jsonPurchasedVegs.add(vegetable.toJson());
    }
    return <String, dynamic>{
      'state': state,
      'client': client.toJson(),
      'purchasedVegetables': jsonPurchasedVegs,
      'total': total,
      'responded': responded,
    };
  }

  Order.fromJson(Map json) {
    List<Vegetable> purchasedVegetables = [];
    List<Map<String, dynamic>> jsonPurchasedVegs = json['purchasedVegetables'];

    for (Map<String, dynamic> jsonVeg in jsonPurchasedVegs) {
      purchasedVegetables.add(Vegetable.fromJson(jsonVeg));
    }

    this.id = json['id'];
    this.state = json['state'];
    this.client = Client.fromJson(json['client']);
    this.purchasedVegetables = purchasedVegetables;
    this.total = json['total'];
    this.responded = responded;
  }
}
