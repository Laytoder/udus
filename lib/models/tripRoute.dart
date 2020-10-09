import 'dart:collection';

import 'package:frute/models/order.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/models/vendorInfo.dart';

class TripRoute {
  double duration, price;
  List<VendorInfo> routeVendors = [];
  HashMap<String, List<Vegetable>> orders = HashMap<String, List<Vegetable>>();
}
