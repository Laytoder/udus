import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frute/DurationMatrixApi/DurationMatrixApiHelper.dart';
import 'package:frute/models/tripRoute.dart';
import 'package:frute/models/vendorInfo.dart';
import 'dart:math' as math;

class TspHelper {
  List<List<TripRoute>> _dp;
  List<List<int>> durationMatrix;
  List<int> homeDurationMatrix;
  List<VendorInfo> _vendors;
  static int _VISITED_ALL;
  static const int CONNECTION_ERROR = 0;

  Future<dynamic> getTripWithOptimalRoute(
      GeoPoint homeLocation, TripRoute tripRoute) async {
    DurationMatrixApiClient durationMatrixApiClient = DurationMatrixApiClient();
    dynamic res = await durationMatrixApiClient.getDurationMatrices(
        homeLocation, tripRoute.routeVendors);
    if (res == DurationMatrixApiClient.CONNECTION_ERROR)
      return CONNECTION_ERROR;
    else {
      _vendors = tripRoute.routeVendors;
      durationMatrix = res[0];
      homeDurationMatrix = res[1];
      int row = math.pow(2, _vendors.length);
      int col = _vendors.length;
      _dp = List.generate(row, (i) => List(col), growable: false);
      _VISITED_ALL = (1 << col) - 1;
      TripRoute tripWithOptimalRoute = _tsp(0, -1);
      tripRoute.routeVendors = tripWithOptimalRoute.routeVendors;
      tripRoute.duration = tripWithOptimalRoute.duration;
      return tripRoute;
    }
  }

  TripRoute _tsp(int mask, int pos) {
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
      tripRoute.duration = homeDurationMatrix[pos];
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
          int origin = pos;
          int destination = vendorIndex;
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
  }
}
