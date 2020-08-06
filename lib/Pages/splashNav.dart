import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/GettingStarted.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/Pages/namePage.dart';
import 'package:frute/Pages/pendingTripBuilder.dart';
import 'package:frute/Pages/splashScreen.dart';
import 'package:frute/helpers/authService.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/holePainter.dart';
import 'package:frute/models/bill.dart';
import 'package:frute/models/trip.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:google_directions_api/google_directions_api.dart';

class SplashNav extends StatefulWidget {
  AppState appState;
  SplashNav({
    @required this.appState,
  });

  @override
  _SplashNavState createState() => _SplashNavState();
}

class _SplashNavState extends State<SplashNav> {
  //GlobalKey<SplashScreenState> globalKey = GlobalKey();

  getPendingTripWithLatestData(
      String pendingTripVendorId, String phoneNumber) async {
    final firestoreInstance = Firestore.instance;
    Trip trip = Trip(state: 'requested');
    DocumentSnapshot document = await firestoreInstance
        .collection('vendor_live_data')
        .document(pendingTripVendorId)
        .get();
    List<dynamic> jsonTrips = document.data['pendingTrips'];
    print('this is jsonTrip $jsonTrips');
    //print('reached');
    //when there are no jsonTrips means the state is still requested
    if (jsonTrips == null) return trip;
    for (dynamic jsonTrip in jsonTrips) {
      //print('reached');
      String uid = jsonTrip['uid'];
      if (phoneNumber == uid) {
        trip.state = jsonTrip['state'];
        if (jsonTrip['origin'] != null)
          trip.origin = GeoCoord.fromJson(jsonTrip['origin']);
        if (jsonTrip['destination'] != null)
          trip.destination = GeoCoord.fromJson(jsonTrip['destination']);
        print('reached before bills');
        if (jsonTrip['jsonBill'] != null)
          trip.verificationBill = Bill.fromJson(jsonTrip['jsonBill']);
        print('reached after bills');
        trip.eta = jsonTrip['eta'];
      }
    }
    //print('reached');
    if (trip.state == 'ongoing') {
      String jsonDirectionsApiHelper =
          widget.appState.preferences.getString('directionsApiHelper');
      if (jsonDirectionsApiHelper == null) {
        DirectionApiHelper directionApiHelper = DirectionApiHelper();
        await directionApiHelper.populateData(trip.origin, trip.destination);
        trip.directionApiHelper = directionApiHelper;
        widget.appState.preferences.setString(
          'directionsApiHelper',
          jsonEncode(directionApiHelper.toJson()),
        );
      } else {
        DirectionApiHelper directionApiHelper = DirectionApiHelper();
        dynamic json = jsonDecode(jsonDirectionsApiHelper);
        directionApiHelper.populateWithJson(
            json, trip.origin, trip.destination);
        trip.directionApiHelper = directionApiHelper;
      }
    }
    //print('reached');
    trip.vendorId = pendingTripVendorId;
    print('this is the got trip ${trip.toJson()}');
    //if (trip.state == 'rejected') return null;
    return trip;
  }

  updatePendingTrip(pendingTripVendorId) async {
    if (!widget.appState.isPendingTripUpdated) {
      //List<String> jsonTrips = preferences.getStringList('pendingTrips');
      //String pendingTripVendorId = preferences.getString('pendingTripVendorId');
      /*if (jsonTrips != null && jsonTrips.length != 0) {
        for (String json in jsonTrips) {
          if (json != null) trips.add(Trip.fromJson(jsonDecode(json)));
        }
      }
      if (trips.length != 0) updateTripsWithLatestData(trips);
      appState.pendingTrips = trips;
      appState.isPendingTripsUpdated = true;
    }*/
      //if (pendingTripVendorId != null)
      widget.appState.pendingTrip = await getPendingTripWithLatestData(
          pendingTripVendorId, widget.appState.phoneNumber);
      //print('this is pendingTrip ${appState.pendingTrip}');
      widget.appState.isPendingTripUpdated = true;
    }
    return 'done';
  }

  Future<bool> checkSignedStateWithDelay() async {
    print('called');
    final stopwatch = Stopwatch()..start();
    bool result = await AuthService().isSignedIn();
    int milli = stopwatch.elapsedMilliseconds;
    if (milli >= 3000) {
      return result;
    } else {
      await Future.delayed(
        Duration(
          milliseconds: (3000 - milli),
        ),
      );
      return result;
    }
  }

  performNav() {
    String pendingTripVendorId =
        widget.appState.preferences.getString('pendingTripVendorId');
    if (pendingTripVendorId != null) {
      //retreiving pendingTripVendorInfo
      widget.appState.vendors = Map<String, VendorInfo>();
      widget.appState.userId = [];
      widget.appState.userId.add(pendingTripVendorId);
      VendorInfo pendingTripVendorInfo = VendorInfo.fromJson(
        jsonDecode(
          widget.appState.preferences.getString('pendingTripVendorInfo'),
        ),
      );
      widget.appState.vendors[pendingTripVendorId] = pendingTripVendorInfo;
      return FutureBuilder(
        future: updatePendingTrip(pendingTripVendorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == 'done') {
              return PendingTripBuilder(
                widget.appState.pendingTrip,
                widget.appState,
                widget.appState.preferences,
              );
            } else
              return Scaffold(
                backgroundColor: Color(0xffE0E5EC),
                body: Center(
                  child: Image(
                    height: 200,
                    width: 200,
                    image: AssetImage('assets/loading.gif'),
                  ),
                ),
              );
          } else
            return Scaffold(
              backgroundColor: Color(0xffE0E5EC),
              body: Center(
                child: Image(
                  height: 200,
                  width: 200,
                  image: AssetImage('assets/loading.gif'),
                ),
              ),
            );
        },
      );
    } else {
      widget.appState.vendors = Map<String, VendorInfo>();
      widget.appState.userId = [];
      return HomeBuilder(widget.appState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        !widget.appState.active
            ? FutureBuilder(
                //future: AuthService().isSignedIn(),
                future: checkSignedStateWithDelay(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    //globalKey.currentState.endSplash();
                    if (snapshot.data) {
                      return performNav();
                    } else {
                      //return NamePage(widget.appState);
                      return GettingStarted(
                        appState: widget.appState,
                      );
                    }
                  } else {
                    return Scaffold(
                      backgroundColor: Color(0xffE0E5EC),
                      body: Center(
                        child: Image(
                          image: AssetImage('assets/HL.png'),
                          height: 200,
                          width: 200,
                        ),
                      ),
                    );
                  }
                },
              )
            : Builder(
                builder: (context) => performNav(),
              ),
        /*!widget.appState.active
            ? SplashScreen(
                key: globalKey,
              )
            : SizedBox(
                height: 0,
                width: 0,
                child: Container(),
              ),*/
      ],
    );
  }
}
