import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/helpers/nearbyVendorQueryHelper.dart';

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
      future: nearbyVendorQueryHelper.pickLocation(context, widget.state),
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
          }
          /*else if (snapshot.data ==
              NearbyVendorQueryHelper.NO_NEARBY_VENDORS) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                body: Center(
                  child: Text(
                    "Sorry no Vendors Nearby !",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            );
          }*/
          else {
            print('returned from here');
            return FutureBuilder(
              future: nearbyVendorQueryHelper.getNearbyVendors(
                  context, snapshot.data),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data ==
                      NearbyVendorQueryHelper.NO_NEARBY_VENDORS) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: Scaffold(
                        body: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 120,
                                left: 50,
                                right: 50,
                                bottom: 50,
                              ),
                              child: Center(
                                child: Image.asset('assets/novendor.png'),
                              ),
                            ),
                            Text(
                              'Sorry, There Are No Nearby Vendors',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
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
                      body: Stack(
                        children: <Widget>[
                          Center(
                            child: Image(
                              image: AssetImage('assets/ripple.gif'),
                              height: 200,
                              width: 200,
                            ),
                          ),
                          Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage('assets/HL.png'),
                              radius: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
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
