import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/helpers/messageGetters.dart';
import 'package:frute/helpers/messagingHelper.dart';
import 'package:frute/models/trip.dart';
import 'package:frute/routes/fadeRoute.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map.dart' as map;

class HoldPage extends StatelessWidget {
  String eta, vendorName;
  AppState appState;
  MessagingHelper messagingHelper = MessagingHelper();
  SharedPreferences preferences;
  HoldPage({
    @required this.eta,
    @required this.vendorName,
    @required this.appState,
    @required this.preferences,
  });

  launchOnReply(BuildContext context) async {
    /*Map<String, dynamic> reply = await messagingHelper.getReply();
    DirectionApiHelper directionApiHelper = DirectionApiHelper();
    GeoCoord destination = GeoCoord.fromJson(jsonDecode(reply['destination']));
    GeoCoord origin = GeoCoord.fromJson(jsonDecode(reply['origin']));
    await directionApiHelper.populateData(origin, destination);
    List<Trip> trips = [];
    for (Trip trip in appState.pendingTrips) {
      if (trip.vendorId == appState.activeVendorId) {
        trip.state = reply['state'];
        trip.directionApiHelper = directionApiHelper;
        trip.origin = origin;
        trip.destination = destination;
      }
      trips.add(trip);
    }
    appState.pendingTrips = trips;
    List<String> jsonTrips = [];
    for (Trip trip in trips) jsonTrips.add(jsonEncode(trip.toJson()));
    preferences.setStringList('pendingTrips', jsonTrips);
    Navigator.push(
      context,
      FadeRoute(
        page: map.Map(
          directionApiHelper: directionApiHelper,
          appState: appState,
        ),
      ),
    );*/
    Map<String, dynamic> reply = await getReply(appState);
    DirectionApiHelper directionApiHelper = DirectionApiHelper();
    appState.pendingTrip.state = 'ongoing';
    GeoCoord destination = GeoCoord.fromJson(reply['destination']);
    GeoCoord origin = GeoCoord.fromJson(reply['origin']);
    appState.pendingTrip.origin = origin;
    appState.pendingTrip.destination = destination;
    await directionApiHelper.populateData(origin, destination);
    appState.pendingTrip.directionApiHelper = directionApiHelper;
    preferences.setString(
      'directionsApiHelper',
      jsonEncode(directionApiHelper.toJson()),
    );
    Navigator.pushReplacement(
      context,
      FadeRoute(
        page: map.Map(
          directionApiHelper: directionApiHelper,
          appState: appState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    launchOnReply(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Container(
              child: SvgPicture.asset(
                'assets/home.svg',
                height: 25,
                width: 25,
                color: Color(0xff58f8f8f),
              ),
            ),
            onPressed: () {
              appState.active = false;
              appState.messages = StreamController();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeBuilder(appState),
                ),
              );
            },
          ),
        ),
        body: Center(
          child: Text(
              '$vendorName is on another trip\nWill take approx $eta to start your trip'),
        ),
      ),
    );
  }
}
