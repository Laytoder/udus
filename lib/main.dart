import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/Pages/namePage.dart';
import 'package:frute/helpers/messagingHelper.dart';
import 'package:frute/models/bill.dart';
import 'package:frute/models/vendorInfo.dart';
import 'AppState.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'tokens/googleMapsApiKey.dart';
import 'helpers/authService.dart';
import 'models/trip.dart';
import 'dart:convert';
import 'helpers/directionApiHelper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DirectionsService.init(gmapsApiKey);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppState appState = AppState(
      vendors: Map<String, VendorInfo>(), userId: [], messagingToken: '');

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  SharedPreferences preferences;
  static const String MESSAGING_TOKEN = 'firbase_messaging_token';
  String messagingToken;
  MessagingHelper messagingHelper = MessagingHelper();

  @override
  void initState() {
    super.initState();

    initializeAppStateAndStartMessagingService();
  }

  getPendingTripWithLatestData(
      String pendingTripVendorId, String phoneNumber) async {
    final firestoreInstance = Firestore.instance;
    Trip trip = Trip(state: 'requested');
    DocumentSnapshot document = await firestoreInstance
        .collection('vendor_live_data')
        .document(pendingTripVendorId)
        .get();
    List<dynamic> jsonTrips = document.data['pendingTrips'];
    if (jsonTrips == null) return null;
    for (dynamic jsonTrip in jsonTrips) {
      String uid = jsonTrip['uid'];
      if (phoneNumber == uid) {
        trip.state = jsonTrip['state'];
        if (jsonTrip['origin'] != null)
          trip.origin = GeoCoord.fromJson(jsonTrip['origin']);
        if (jsonTrip['destination'] != null)
          trip.destination = GeoCoord.fromJson(jsonTrip['destination']);
        if (jsonTrip['jsonBill'] != null)
          trip.verificationBill = Bill.fromJson(jsonTrip['jsonBill']);
        trip.eta = jsonTrip['eta'];
      }
    }
    if (trip.state == 'ongoing') {
      String jsonDirectionsApiHelper =
          preferences.getString('directionsApiHelper');
      if (jsonDirectionsApiHelper == null) {
        DirectionApiHelper directionApiHelper = DirectionApiHelper();
        directionApiHelper.populateData(trip.origin, trip.destination);
        trip.directionApiHelper = directionApiHelper;
        preferences.setString(
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
    trip.vendorId = pendingTripVendorId;
    if (trip.state == 'rejected') return null;
    return trip;
  }

  initializeAppStateAndStartMessagingService() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.getString(MESSAGING_TOKEN) != null) {
      messagingToken = preferences.getString(MESSAGING_TOKEN);
    } else {
      String genToken = await firebaseMessaging.getToken();
      messagingToken = genToken;
      print(genToken);
      preferences.setString(MESSAGING_TOKEN, genToken);
    }
    appState.messagingToken = messagingToken;
    if (preferences.getString('clientName') != null)
      appState.clientName = preferences.getString('clientName');
    if (preferences.getString('phoneNumber') != null)
      appState.phoneNumber = preferences.getString('phoneNumber');
    if (preferences.getString('image') != null)
      appState.image = preferences.getString('image');
    if (!appState.isPendingTripUpdated) {
      //List<String> jsonTrips = preferences.getStringList('pendingTrips');
      String pendingTripVendorId = preferences.getString('pendingTripVendorId');
      /*if (jsonTrips != null && jsonTrips.length != 0) {
        for (String json in jsonTrips) {
          if (json != null) trips.add(Trip.fromJson(jsonDecode(json)));
        }
      }
      if (trips.length != 0) updateTripsWithLatestData(trips);
      appState.pendingTrips = trips;
      appState.isPendingTripsUpdated = true;
    }*/
      if (pendingTripVendorId != null)
        appState.pendingTrip = await getPendingTripWithLatestData(
            pendingTripVendorId, appState.phoneNumber);
      appState.isPendingTripUpdated = true;
    }
    if (!appState.isMessagingServiceStarted) {
      print('starting messagign service');
      messagingHelper.startMessagingService(appState, preferences);
      appState.isMessagingServiceStarted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //scaffoldBackgroundColor: Color(0xffff8d27),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        accentColor: Colors.white,
        canvasColor: Colors.transparent,
        fontFamily: 'Ubuntu',
      ),
      navigatorKey: messagingHelper.navigatorkey,
      //home: AuthService().handleAuth(appState),
      /* home: FutureBuilder(
        future: AuthService().isSignedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data) {
              return HomeBuilder(appState);
            } else {
              return NamePage(appState);
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),*/
      home: HomeBuilder(appState),
      debugShowCheckedModeBanner: false,
    );
  }
}
