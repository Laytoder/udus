import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/helpers/nearbyVendorQueryHelper.dart';
import 'package:frute/AppState.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:location/location.dart';

class HomeBuilder extends StatefulWidget {
  AppState appState;
  String state;
  //LocationResult locationResult;
  HomeBuilder(this.appState, {this.state = 'normal'});
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
    setState(() {
      widget.state = 'normal';
    });
    return refreshCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: nearbyVendorQueryHelper.getNearbyVendors(context, widget.state),
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
            return HomePage(widget.appState, refreshVendors);
          }
        } else {
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: Color(0xffE0E5EC),
              body: Center(
                child: Image(
                  image: AssetImage('assets/loading.gif'),
                  height: 200,
                  width: 200,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
