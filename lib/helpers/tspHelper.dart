import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:frute/models/tripRoute.dart';
import 'dart:math' as math;

class TspHelper {
  List<List<TripRoute>> _dp;
  List<List<double>> durationMatrix;
  HashMap<String, int> vendorIndexMap;
  List<VendorInfo> _vendors;
  List<Vegetable> orders;
  static int _VISITED_ALL;

  TspHelper({
    @required this.durationMatrix,
    @required this.vendorIndexMap,
    @required this.orders,
  });

  TripRoute getOptimalTripRoutePerm(List<VendorInfo> vendors) {
    _vendors = vendors;
    int row = math.pow(2, _vendors.length);
    int col = _vendors.length;
    _dp = List.generate(row, (i) => List(col), growable: false);
    _VISITED_ALL = (1 << col) - 1;

    //get tripRoute with orders data
    TripRoute tripRouteWithOrderData =
        _getTripRouteWithOrderData();

    if (tripRouteWithOrderData == null) return null;

    //get tripRoute without total price
    TripRoute tripRouteWithPrice = _tsp(0, -1);
    if (tripRouteWithPrice.duration > 2100) // 2100 secs is 35 mins
      return null;

    TripRoute tripRoute = TripRoute();
    //order data
    tripRoute.orders = tripRouteWithOrderData.orders;
    tripRoute.price = tripRouteWithOrderData.price;
    //routing data(tsp)
    tripRoute.routeVendors = tripRouteWithPrice.routeVendors;
    tripRoute.duration = tripRouteWithPrice.duration;

    return tripRoute;
  }

  TripRoute _getTripRouteWithOrderData() {
    double tripPrice = 0.0;
    TripRoute tripRoute = TripRoute();
    List<bool> selections =
        List.generate(_vendors.length, (index) => false, growable: false);
    for (Vegetable order in orders) {
      String orderVegName = order.name;
      double leastPrice;
      VendorInfo leastPriceVendor;
      int vendorIndex;
      for (vendorIndex = 0; vendorIndex < _vendors.length; vendorIndex++) {
        HashMap<String, double> vegMap = _vendors[vendorIndex].vegMap;
        double price = vegMap[orderVegName];
        //if does not contain order
        if (price == null) continue;
        if (leastPrice == null) {
          leastPrice = price;
          leastPriceVendor = _vendors[vendorIndex];
        } else if (price < leastPrice) {
          leastPrice = price;
          leastPriceVendor = _vendors[vendorIndex];
        }
      }
      //if order is not with any vendor
      if (leastPriceVendor == null) return null;
      selections[vendorIndex] = true;
      tripPrice = tripPrice + (leastPrice * order.quantity);
      if (tripRoute.orders.containsKey(leastPriceVendor.id)) {
        tripRoute.orders[leastPriceVendor.id].add(order);
      } else {
        tripRoute.orders[leastPriceVendor.id] = [];
        tripRoute.orders[leastPriceVendor.id].add(order);
      }
    }
    tripRoute.price = tripPrice;

    for (bool selection in selections) {
      if (!selection) return null;
    }

    return tripRoute;
  }

  TripRoute _tsp(int mask, int pos) {
    //base case
    if (mask == _VISITED_ALL) {
      TripRoute tripRoute = TripRoute();
      int origin = vendorIndexMap[_vendors[pos].id];
      int destination = vendorIndexMap[_vendors[_vendors.length - 1].id];
      tripRoute.duration = durationMatrix[origin][destination];
      tripRoute.routeVendors.add(_vendors[pos]);
      return tripRoute;
    }
    if (pos != -1 && _dp[mask][pos] != null) {
      return _dp[mask][pos];
    }

    double newDurationFromCurrentVendor = 0.0;
    TripRoute optimalRouteFromCurrentVendor = TripRoute();
    optimalRouteFromCurrentVendor.duration = double.infinity;

    for (int vendorIndex = 0; vendorIndex < _vendors.length; vendorIndex++) {
      if ((mask & (1 << vendorIndex)) == 0) {
        TripRoute optimalSubRoute = _tsp(mask | (1 << vendorIndex), vendorIndex);
        if (pos != -1) {
          int origin = vendorIndexMap[_vendors[pos].id];
          int destination = vendorIndexMap[_vendors[vendorIndex].id];
          newDurationFromCurrentVendor =
              durationMatrix[origin][destination] + optimalSubRoute.duration;
        } else {
          newDurationFromCurrentVendor = optimalSubRoute.duration;
        }
        if (newDurationFromCurrentVendor <
            optimalRouteFromCurrentVendor.duration) {
          optimalRouteFromCurrentVendor.duration = newDurationFromCurrentVendor;
          optimalRouteFromCurrentVendor.routeVendors = [_vendors[pos]];
          optimalRouteFromCurrentVendor.routeVendors
              .addAll(optimalSubRoute.routeVendors);
        }
      }
    }

    _dp[mask][pos] = optimalRouteFromCurrentVendor;

    return optimalRouteFromCurrentVendor;
  }
}
