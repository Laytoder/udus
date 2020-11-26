import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:frute/DurationMatrixApi/DurationMatrixApiHelper.dart';
import 'package:frute/helpers/tspHelper.dart';
import 'package:frute/models/tripRoute.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OptimalTripRoutesFinder {
  static const int MAX_VENDOR_COMBINATIONS = 3;
  static const int CONNECTION_ERROR = 0;
  static const int NO_OPTIMAL_ORDER = 1;
  GeoPoint homeLocation;
  List<VendorInfo> vendors;
  List<VendorInfo> filteredVendors;
  HashMap<String, int> vendorIndexMap;
  List<Vegetable> order;
  List<List<int>> durationMatrix;
  List<int> homeDurationMatrix;
  TspHelper tspHelper;

  OptimalTripRoutesFinder({
    @required this.homeLocation,
    @required this.vendors,
    @required this.order,
  });

  Future<dynamic> getOptimalTripRoute() async {
    //filter vendors having required vegetables
    filterVendorsWithRequiredVegetables(vendors, order); //n^2
    //print('filtered vendors');
    List<dynamic> durationMatrices =
        await getDurationMatrices(homeLocation, filteredVendors);
    //print('got duration matrix ${durationMatrix}');
    if (durationMatrices == null) return CONNECTION_ERROR;
    this.durationMatrix = durationMatrices[0];
    this.homeDurationMatrix = durationMatrices[1];
    initVendorIndexMap(filteredVendors);
    tspHelper = TspHelper(
      durationMatrix: durationMatrices[0],
      homeDurationMatrix: durationMatrices[1],
      orders: order,
      vendorIndexMap: vendorIndexMap,
    );
    //List<TripRoute> optimalRoutes = [];
    List<TripRoute> singleVendorOptimalRoutes = [];
    List<TripRoute> doubleVendorOptimalRoutes = [];
    List<TripRoute> tripleVendorOptimalRoutes = [];
    recOverRoutesAndMakeListOfOptimalOnes(singleVendorOptimalRoutes,
        doubleVendorOptimalRoutes, tripleVendorOptimalRoutes, [], 0);
    TripRoute cheapestSingleVendorRoute,
        cheapestDoubleVendorRoute,
        cheapestTripleVendorRoute;
    for (TripRoute route in singleVendorOptimalRoutes) {
      if (cheapestSingleVendorRoute == null)
        cheapestSingleVendorRoute = route;
      else if (route.price < cheapestSingleVendorRoute.price)
        cheapestSingleVendorRoute = route;
    }
    for (TripRoute route in doubleVendorOptimalRoutes) {
      if (cheapestDoubleVendorRoute == null)
        cheapestDoubleVendorRoute = route;
      else if (route.price < cheapestDoubleVendorRoute.price)
        cheapestDoubleVendorRoute = route;
    }
    for (TripRoute route in tripleVendorOptimalRoutes) {
      if (cheapestTripleVendorRoute == null)
        cheapestTripleVendorRoute = route;
      else if (route.price < cheapestTripleVendorRoute.price)
        cheapestTripleVendorRoute = route;
    }

    //print('Cheapest three vendors ${cheapestTripleVendorRoute.price}');
    //print('Cheapest two vendors ${cheapestDoubleVendorRoute.price}');
    //print('Cheapest one vendors ${cheapestSingleVendorRoute.price}');

    if (cheapestSingleVendorRoute == null)
      return NO_OPTIMAL_ORDER;
    else {
      if (cheapestDoubleVendorRoute == null)
        return cheapestSingleVendorRoute;
      else if (cheapestSingleVendorRoute.price <
          cheapestDoubleVendorRoute.price) {
        if (cheapestTripleVendorRoute == null ||
            cheapestSingleVendorRoute.price < cheapestTripleVendorRoute.price)
          return cheapestSingleVendorRoute;
        else {
          if (cheapestSingleVendorRoute.price -
                  cheapestTripleVendorRoute.price <=
              cheapestTripleVendorRoute.price * 0.05)
            return cheapestSingleVendorRoute;
          if (cheapestDoubleVendorRoute.price -
                  cheapestTripleVendorRoute.price <=
              cheapestTripleVendorRoute.price * 0.05)
            return cheapestDoubleVendorRoute;

          return cheapestTripleVendorRoute;
        }
      } else {
        if (cheapestTripleVendorRoute == null ||
            cheapestDoubleVendorRoute.price < cheapestTripleVendorRoute.price) {
          if (cheapestSingleVendorRoute.price -
                  cheapestDoubleVendorRoute.price <=
              cheapestDoubleVendorRoute.price * 0.05)
            return cheapestSingleVendorRoute;
          else
            return cheapestDoubleVendorRoute;
        } else {
          if (cheapestSingleVendorRoute.price -
                  cheapestTripleVendorRoute.price <=
              cheapestTripleVendorRoute.price * 0.05)
            return cheapestSingleVendorRoute;
          if (cheapestDoubleVendorRoute.price -
                  cheapestTripleVendorRoute.price <=
              cheapestTripleVendorRoute.price * 0.05)
            return cheapestDoubleVendorRoute;

          return cheapestTripleVendorRoute;
        }
      }
    }
    //return optimalRoutes;
  }

  recOverRoutesAndMakeListOfOptimalOnes(
    List<TripRoute> singleVendorOptimalRoutes,
    List<TripRoute> doubleVendorOptimalRoutes,
    List<TripRoute> tripleVendorOptimalRoutes,
    List<VendorInfo> currentSubset,
    int currentIndex,
  ) {
    //print('reccing ${currentSubset.length}');
    //base case
    if (currentIndex >= filteredVendors.length) {
      //apply tsp to find the optimal route
      TripRoute tripRoute = tspHelper.getOptimalTripRoutePerm(currentSubset);
      if (tripRoute != null) {
        switch (tripRoute.routeVendors.length) {
          case 1:
            singleVendorOptimalRoutes.add(tripRoute);
            break;

          case 2:
            doubleVendorOptimalRoutes.add(tripRoute);
            break;

          case 3:
            tripleVendorOptimalRoutes.add(tripRoute);
            break;
        }
      }
      return;
    } else if (currentSubset.length == MAX_VENDOR_COMBINATIONS) {
      //apply tsp to find the optimal route
      TripRoute tripRoute = tspHelper.getOptimalTripRoutePerm(currentSubset);
      if (tripRoute != null) {
        switch (tripRoute.routeVendors.length) {
          case 1:
            singleVendorOptimalRoutes.add(tripRoute);
            break;

          case 2:
            doubleVendorOptimalRoutes.add(tripRoute);
            break;

          case 3:
            tripleVendorOptimalRoutes.add(tripRoute);
            break;
        }
      }
      return;
    } else {
      //apply tsp to find the optimal route
      TripRoute tripRoute = tspHelper.getOptimalTripRoutePerm(currentSubset);
      if (tripRoute != null) {
        switch (tripRoute.routeVendors.length) {
          case 1:
            singleVendorOptimalRoutes.add(tripRoute);
            break;

          case 2:
            doubleVendorOptimalRoutes.add(tripRoute);
            break;

          case 3:
            tripleVendorOptimalRoutes.add(tripRoute);
            break;
        }
      }
      List<VendorInfo> temp = [];
      temp.addAll(currentSubset);
      for (int x = currentIndex; x < filteredVendors.length; x++) {
        currentSubset.add(filteredVendors[x]);
        recOverRoutesAndMakeListOfOptimalOnes(
            singleVendorOptimalRoutes,
            doubleVendorOptimalRoutes,
            tripleVendorOptimalRoutes,
            currentSubset,
            x + 1);
        currentSubset = [];
        currentSubset.addAll(temp);
      }
    }
  }

  Future<List<dynamic>> getDurationMatrices(
      GeoPoint homeLocation, List<VendorInfo> vendors) async {
    DurationMatrixApiClient matrixApiClient = DurationMatrixApiClient();
    dynamic response =
        await matrixApiClient.getDurationMatrices(homeLocation, vendors);
    if (response != DurationMatrixApiClient.CONNECTION_ERROR) {
      List<List<int>> durationMatrix = response[0];
      return [durationMatrix, response[1]];
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
