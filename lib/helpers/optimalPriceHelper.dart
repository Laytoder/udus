import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:frute/models/tripRoute.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/models/vendorInfo.dart';

class OptimalPriceHelper {
  //List<List<TripRoute>> _dp;
  //List<List<int>> durationMatrix;
  //List<int> homeDurationMatrix;
  //HashMap<String, int> vendorIndexMap;
  List<VendorInfo> _vendors;
  List<Vegetable> orders;
  //static int _VISITED_ALL;

  OptimalPriceHelper({
    //@required this.durationMatrix,
    //@required this.homeDurationMatrix,
    //@required this.vendorIndexMap,
    @required this.orders,
  });

  TripRoute getTripWithOptimalPrice(List<VendorInfo> vendors) {
    //print('getOptimalTripRoutePerm called');
    _vendors = vendors;
    //int row = math.pow(2, _vendors.length);
    //int col = _vendors.length;
    //_dp = List.generate(row, (i) => List(col), growable: false);
    //_VISITED_ALL = (1 << col) - 1;

    //get tripRoute with orders data
    /*if (_vendors.length == 3)
      print(
          'vendors: [${_vendors[0].name}, ${_vendors[1].name}, ${_vendors[2].name}]');*/
    TripRoute tripRouteWithOrderData = _getTripRouteWithOrderData();

    if (tripRouteWithOrderData == null) return null;

    tripRouteWithOrderData.routeVendors.addAll(_vendors);

    return tripRouteWithOrderData;

    //get tripRoute without total price
    /*TripRoute tripRouteWithPrice = _tsp(0, -1);
    //Give buffer for time to reach the first vendor
    tripRouteWithPrice.duration = tripRouteWithPrice.duration + 300;
    //print('duration in tspHelper ${tripRouteWithPrice.duration}');
    if (tripRouteWithPrice.duration > 2100) // 2100 secs is 35 mins
      return null;*/

    /*TripRoute tripRoute = TripRoute();
    //order data
    tripRoute.orders = tripRouteWithOrderData.orders;
    tripRoute.price = tripRouteWithOrderData.price;
    //routing data(tsp)
    /*tripRoute.routeVendors = tripRouteWithPrice.routeVendors;
    tripRoute.duration = tripRouteWithPrice.duration;*/

    return tripRoute;*/
  }

  TripRoute _getTripRouteWithOrderData() {
    bool breaking = false; //for debugging
    if (_vendors.length == 3) {
      if (_vendors[0].name == 'HKW_01' &&
          _vendors[1].name == 'HKW_04' &&
          _vendors[2].name == 'HKW_11') {
        breaking = true;
      }
    } //creating breaking point
    double tripPrice = 0.0;
    TripRoute tripRoute = TripRoute();
    List<bool> selections =
        List.generate(_vendors.length, (index) => false, growable: false);
    //print('length of selections ${selections.length}');
    //print('length of _vendors ${_vendors.length}');
    for (Vegetable order in orders) {
      String orderVegName = order.name;
      if (breaking) print('Breaking point: orderVegName:- $orderVegName');
      double leastPrice;
      VendorInfo leastPriceVendor;
      int leastPriceVendorIndex;
      for (int vendorIndex = 0; vendorIndex < _vendors.length; vendorIndex++) {
        HashMap<String, double> vegMap = _vendors[vendorIndex].vegMap;
        if (breaking) {
          print('Breaking point: vendorIndex:- $vendorIndex');
          print('Breaking point: vegMap:- $vegMap');
        }
        double price = vegMap[orderVegName];
        //if does not contain order
        if (price == null) continue;
        if (leastPrice == null) {
          if (breaking)
            print('Breaking point: no initialization problem for least price');
          leastPrice = price;
          leastPriceVendor = _vendors[vendorIndex];
          leastPriceVendorIndex = vendorIndex;
        } else if (price < leastPrice) {
          leastPrice = price;
          leastPriceVendor = _vendors[vendorIndex];
          leastPriceVendorIndex = vendorIndex;
        }
      }
      //if order is not with any vendor
      if (leastPriceVendor == null) {
        if (breaking)
          print('Breaking: yes the leastPriceVendor is null somehow');
        return null;
      }
      selections[leastPriceVendorIndex] = true;
      tripPrice = tripPrice + (leastPrice * order.quantity);
      if (tripRoute.orders.containsKey(leastPriceVendor.id)) {
        tripRoute.orders[leastPriceVendor.id].add(order);
      } else {
        tripRoute.orders[leastPriceVendor.id] = [];
        tripRoute.orders[leastPriceVendor.id].add(order);
      }
    }
    tripRoute.price = tripPrice;

    if (breaking) print('Breaking point: Calculated Price = $tripPrice');

    for (bool selection in selections) {
      if (!selection) {
        if (breaking)
          print('Breaking point: it is the selections problem somehow');
        return null;
      }
    }

    return tripRoute;
  }

  /*TripRoute _tsp(int mask, int pos) {
    //print('reccing _tsp(${mask.toRadixString(2)}, $pos)');
    //print('Vendors lenght ${_vendors.length}');
    //print('VISITED_ALL ${_VISITED_ALL.toRadixString(2)}');
    //base case
    if (mask == _VISITED_ALL) {
      TripRoute tripRoute = TripRoute();
      //add distance till home implementation
      /*int origin = vendorIndexMap[_vendors[pos].id];
      int destination = vendorIndexMap[_vendors[_vendors.length - 1].id];
      tripRoute.duration = durationMatrix[origin][destination];*/
      //distance till home implementation
      tripRoute.duration = homeDurationMatrix[vendorIndexMap[_vendors[pos].id]];
      tripRoute.routeVendors.add(_vendors[pos]);
      //print('returning tripRoute');
      return tripRoute;
    }
    if (pos != -1 && _dp[mask][pos] != null) {
      return _dp[mask][pos];
    }

    int newDurationFromCurrentVendor = 0;
    TripRoute optimalRouteFromCurrentVendor = TripRoute();
    optimalRouteFromCurrentVendor.duration = 36000;

    for (int vendorIndex = 0; vendorIndex < _vendors.length; vendorIndex++) {
      if ((mask & (1 << vendorIndex)) == 0) {
        TripRoute optimalSubRoute =
            _tsp(mask | (1 << vendorIndex), vendorIndex);
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
          optimalRouteFromCurrentVendor.routeVendors =
              pos != -1 ? [_vendors[pos]] : [];
          optimalRouteFromCurrentVendor.routeVendors
              .addAll(optimalSubRoute.routeVendors);
        }
      }
    }

    if (pos != -1) {
      _dp[mask][pos] = optimalRouteFromCurrentVendor;
    }

    return optimalRouteFromCurrentVendor;
  }*/
}
