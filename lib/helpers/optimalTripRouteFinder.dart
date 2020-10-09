import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:frute/DurationMatrixApi/DurationMatrixApiHelper.dart';
import 'package:frute/helpers/tspHelper.dart';
import 'package:frute/models/tripRoute.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:frute/models/vegetable.dart';

class OptimalTripRoutesFinder {
  static const int MAX_VENDOR_COMBINATIONS = 3;
  static const int CONNECTION_ERROR = 0;
  List<VendorInfo> vendors;
  List<VendorInfo> filteredVendors;
  HashMap<String, int> vendorIndexMap;
  List<Vegetable> order;
  List<List<double>> durationMatrix;
  TspHelper tspHelper;

  OptimalTripRoutesFinder({
    @required this.vendors,
    @required this.order,
  });

  Future<dynamic> getOptimalTripRoutes() async {
    //filter vendors having required vegetables
    filterVendorsWithRequiredVegetables(vendors, order); //n^2
    dynamic durationMatrix = getDurationMatrix(filteredVendors);
    if (durationMatrix == null) return CONNECTION_ERROR;
    this.durationMatrix = durationMatrix;
    initVendorIndexMap(filteredVendors);
    tspHelper = TspHelper(
      durationMatrix: durationMatrix,
      orders: order,
      vendorIndexMap: vendorIndexMap,
    );
    List<TripRoute> optimalRoutes = [];
    recOverRoutesAndMakeListOfOptimalOnes(optimalRoutes, [], 0);

    return optimalRoutes;
  }

  recOverRoutesAndMakeListOfOptimalOnes(
    List<TripRoute> optimalRoutes,
    List<VendorInfo> currentSubset,
    int currentIndex,
  ) {
    //base case
    if (currentIndex >= vendors.length) {
      //apply tsp to find the optimal route
      TripRoute tripRoute = tspHelper.getOptimalTripRoutePerm(currentSubset);
      if (tripRoute != null) optimalRoutes.add(tripRoute);
      return;
    } else if (currentSubset.length == MAX_VENDOR_COMBINATIONS) {
      //apply tsp to find the optimal route
      TripRoute tripRoute = tspHelper.getOptimalTripRoutePerm(currentSubset);
      if (tripRoute != null) optimalRoutes.add(tripRoute);
      return;
    } else {
      //apply tsp to find the optimal route
      TripRoute tripRoute = tspHelper.getOptimalTripRoutePerm(currentSubset);
      if (tripRoute != null) optimalRoutes.add(tripRoute);
      List<VendorInfo> temp = [];
      temp.addAll(currentSubset);
      for (int x = currentIndex; x < vendors.length; x++) {
        currentSubset.add(vendors[x]);
        recOverRoutesAndMakeListOfOptimalOnes(optimalRoutes, vendors, x + 1);
        currentSubset = temp;
      }
    }
  }

  Future<List<List<double>>> getDurationMatrix(List<VendorInfo> vendors) async {
    DurationMatrixApiClient matrixApiClient = DurationMatrixApiClient();
    dynamic response = await matrixApiClient.getDurationMatrix(vendors);
    if (response != DurationMatrixApiClient.CONNECTION_ERROR) {
      List<List<double>> distMatrix = response;
      return distMatrix;
    }
    return null;
  }

  initVendorIndexMap(List<VendorInfo> vendors) {
    vendorIndexMap = HashMap<String, int>();
    for (int i = 0; i < vendors.length; i++) {
      vendorIndexMap[vendors[i].id] = i;
    }

    return vendorIndexMap;
  }

  filterVendorsWithRequiredVegetables(
      List<VendorInfo> vendors, List<Vegetable> orders) {
    filteredVendors = [];

    for (VendorInfo vendor in vendors) {
      HashMap<String, double> vegMap = vendor.vegMap;
      for (Vegetable order in orders) {
        String orderVegName = order.name;
        if (vegMap.containsKey(orderVegName)) {
          filteredVendors.add(vendor);
          break;
        }
      }
    }

    return filteredVendors;
  }
}
