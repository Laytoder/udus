import 'dart:collection';

import 'package:frute/models/tripRoute.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:frute/models/vegetable.dart';

class OptimalTripRoutesFinder {
  static const int MAX_VENDOR_COMBINATIONS = 5;

  List<TripRoute> getOptimalTripRoutes(
      List<VendorInfo> vendors, List<Vegetable> vegetables) {
    //filter vendors having required vegetables
    List<VendorInfo> filteredVendors =
        filterVendorsWithRequiredVegetables(vendors, vegetables);
  }

  recOverRoutesAndMakeListOfOptimalOnes(
      List<TripRoute> optimalRoutes,
      List<VendorInfo> vendors,
      List<VendorInfo> currentSubset,
      int currentIndex,
      List<Vegetable> order) {
    //base case
    if (currentIndex >= vendors.length) {
      if(checkIfVendorsSatisfyNeed(currentSubset, order)) {
        //apply tsp and add to optimal routes
      }
      return;
    } else if (currentSubset.length == MAX_VENDOR_COMBINATIONS) {
      if(checkIfVendorsSatisfyNeed(currentSubset, order)) {
        //apply tsp and add to optimal routes
      }
      return;
    } else {
      if(checkIfVendorsSatisfyNeed(currentSubset, order)) {
        //apply tsp and add to optimal routes
      }
      List<VendorInfo> temp = [];
      temp.addAll(currentSubset);
      for (int x = currentIndex; x < vendors.length; x++) {
        currentSubset.add(vendors[x]);
        recOverRoutesAndMakeListOfOptimalOnes(
            optimalRoutes, vendors, currentSubset, x + 1, order);
        currentSubset = temp;
      }
    }
  }

  checkIfVendorsSatisfyNeed(List<VendorInfo> vendors, List<Vegetable> order) {
    HashMap<String, double> vegMap;
    for (VendorInfo vendor in vendors) {
      List<Vegetable> vegs = vendor.vegetables;
      for (Vegetable vegetable in vegs) {
        if (vegMap.containsKey(vegetable.name))
          vegMap[vegetable.name] = vegMap[vegetable.name] + vegetable.quantity;
        else
          vegMap[vegetable.name] = vegetable.quantity;
      }
    }

    bool doesSatisfyNeed = true;
    for (Vegetable vegetable in order) {
      if (vegMap.containsKey(vegetable.name)) {
        if (vegMap[vegetable.name] < vegetable.quantity) {
          doesSatisfyNeed = false;
          break;
        }
      }
    }

    return doesSatisfyNeed;
  }

  List<VendorInfo> filterVendorsWithRequiredVegetables(
      List<VendorInfo> vendors, List<Vegetable> vegetables) {
    List<VendorInfo> filteredVendors = [];

    for (VendorInfo vendor in vendors) {
      List<Vegetable> vendorVegs = vendor.vegetables;
      for (Vegetable vegetable in vendorVegs) {
        if (vegetables.contains(vegetable)) {
          filteredVendors.add(vendor);
          break;
        }
      }
    }

    return filteredVendors;
  }
}
