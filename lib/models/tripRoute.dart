import 'dart:collection';

import 'package:frute/models/vegetable.dart';
import 'package:frute/models/vendorInfo.dart';

class TripRoute {
  int duration; // in secs
  double price;
  List<VendorInfo> routeVendors = [];
  HashMap<String, List<Vegetable>> orders = HashMap<String, List<Vegetable>>();

  Map toJson() {
    dynamic jsonRouteVendors = [];
    for (VendorInfo vendor in routeVendors) {
      jsonRouteVendors.add(vendor.toJson());
    }

    dynamic jsonOrders = [];
    for (String vendorName in orders.keys) {
      dynamic vendorVegs = [];
      for (Vegetable vegetable in orders[vendorName]) {
        vendorVegs.add(vegetable.toJson());
      }
      jsonOrders.add({
        'VendorName': vendorName,
        'vegetables': vendorVegs,
      });
    }
    return {
      'duration': duration,
      'price': price,
      'routeVendors': jsonRouteVendors,
      'orders': jsonOrders,
    };
  }
}
