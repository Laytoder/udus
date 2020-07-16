import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/helpers/nearbyVendorQueryHelper.dart';
import 'package:frute/AppState.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:location/location.dart';

class HomeBuilder extends StatefulWidget {
  AppState appState;
  //LocationResult locationResult;
  HomeBuilder(this.appState);
  @override
  _HomeBuilderState createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
  bool loading = false;
  NearbyVendorQueryHelper nearbyVendorQueryHelper;
  Completer refreshCompleter;

  @override
  void initState() {
    super.initState();
    nearbyVendorQueryHelper =
        NearbyVendorQueryHelper(appState: widget.appState);
    refreshCompleter = Completer();
    //print('location result ${widget.locationResult}');
  }

  refreshVendors() {
    refreshCompleter = Completer();
    setState(() {});
    return refreshCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: nearbyVendorQueryHelper.getNearbyVendors(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //refreshCompleter.complete();
          if (snapshot.data ==
              NearbyVendorQueryHelper.LOCATION_SERVICE_DISABLED) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                body: Center(
                  child: Text('Enable Location Service'),
                ),
              ),
            );
          } else if (snapshot.data ==
              NearbyVendorQueryHelper.PERMISSION_DENIED) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                body: Center(
                  child: Text('Enable Location Permission'),
                ),
              ),
            );
          } else if (snapshot.data ==
              NearbyVendorQueryHelper.NO_NEARBY_VENDORS) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                body: Center(
                  child: Text('Sorry, There Are No Nearby Vendors'),
                ),
              ),
            );
          } else {
            return HomePage(snapshot.data, refreshVendors);
          }
        } else {
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}
