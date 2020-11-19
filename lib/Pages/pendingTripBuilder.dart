import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/VendorPage.dart';
import 'package:frute/Pages/billPage.dart';
import 'package:frute/Pages/holdPage.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/Pages/map.dart' as map;
import 'package:frute/models/bill.dart';
import 'package:frute/models/trip.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingTripBuilder extends StatelessWidget {
  Trip pendingTrip;
  AppState appState;
  SharedPreferences preferences;

  PendingTripBuilder(
    this.pendingTrip,
    this.appState,
    this.preferences,
  );

  @override
  Widget build(BuildContext context) {
    print('appState $appState');
    String state = pendingTrip.state;
    switch (state) {
      case 'hold':
        String eta = pendingTrip.eta;
        return HoldPage(
          eta: eta,
          vendorName: 'Ramu Kaka',
          appState: appState,
          preferences: preferences,
        );
        break;

      case 'ongoing':
        //GeoCoord origin = pendingTrip.origin;
        //GeoCoord destination = pendingTrip.destination;
        /*if (pendingTrip.directionApiHelper == null) {
          DirectionApiHelper directionApiHelper = DirectionApiHelper();
          directionApiHelper.populateData(origin, destination);
          pendingTrip.directionApiHelper = directionApiHelper;
          preferences.setString(
              'directionsApiHelper', jsonEncode(directionApiHelper.toJson()));
        }*/
        return map.Map(
          appState: appState,
          directionApiHelper: pendingTrip.directionApiHelper,
        );
        break;

      case 'reached':
        String vendorId = appState.pendingTrip.vendorId;
        VendorInfo vendor = appState.vendors[vendorId];
        return VendorPage(
          vendor,
          appState,
        );
        break;

      case 'verification':
        Bill bill = pendingTrip.verificationBill;
        return BillPage(
          state: 'Verification',
          total: bill.total,
          vegetables: bill.purchasedVegetables,
          appState: appState,
        );
        break;
    }
    return HomeBuilder(appState);
  }
}
