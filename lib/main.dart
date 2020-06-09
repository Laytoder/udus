import 'package:flutter/material.dart';
import 'package:frute/models/vendorInfo.dart';
import 'helpers/nearbyVendorQueryHelper.dart';
import 'AppState.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppState appState = AppState(
      verdors: Map<String, VendorInfo>(), userId: [], messagingToken: '');

  NearbyVendorQueryHelper nearbyVendorQueryHelper;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  SharedPreferences preferences;
  static const String MESSAGING_TOKEN = 'firbase_messaging_token';
  String messagingToken;

  @override
  void initState() {
    super.initState();

    initializeMessagingToken();
    nearbyVendorQueryHelper = NearbyVendorQueryHelper(appState);
  }

  initializeMessagingToken() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //scaffoldBackgroundColor: Color(0xffff8d27),
        scaffoldBackgroundColor: Color(0xffffb300),
        primaryColor: Colors.white,
        accentColor: Color(0xffffb300),
        canvasColor: Colors.transparent,
      ),
      home: FutureBuilder(
        future: nearbyVendorQueryHelper.getNearbyVendors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data ==
                NearbyVendorQueryHelper.LOCATION_SERVICE_DISABLED) {
              return Scaffold(
                body: Center(
                  child: Text('Enable Location Service'),
                ),
              );
            } else if (snapshot.data ==
                NearbyVendorQueryHelper.PERMISSION_DENIED) {
              return Scaffold(
                body: Center(
                  child: Text('Enable Location Permission'),
                ),
              );
            } else if (snapshot.data ==
                NearbyVendorQueryHelper.NO_NEARBY_VENDORS) {
              return Scaffold(
                body: Center(
                  child: Text('Sorry, There Are No Nearby Vendors'),
                ),
              );
            } else {
              return HomePage(snapshot.data);
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
