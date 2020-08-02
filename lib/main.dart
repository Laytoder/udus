import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frute/Pages/homebuilder.dart';
import 'package:frute/Pages/namePage.dart';
import 'package:frute/Pages/splashNav.dart';
import 'package:frute/helpers/messagingHelper.dart';
import 'package:frute/holePainter.dart';
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
import 'Pages/pendingTripBuilder.dart';

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
  AppState appState;
  MyApp({this.appState});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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
    if (widget.appState != null) {
      appState = widget.appState;
    }
    initializeAppStateAndStartMessagingService();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('onResume called');
      if (appState.active) {
        messagingHelper.cancelNotifications();
        //setState(() {
        appState.isPendingTripUpdated = false;
        //});
        //messagingHelper.navigatorkey.currentState.pop();
        messagingHelper.navigatorkey.currentState.pushReplacement(
          MaterialPageRoute(
            builder: (context) => MyApp(
              appState: appState,
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  initializeAppStateAndStartMessagingService() async {
    preferences = await SharedPreferences.getInstance();
    appState.preferences = preferences;
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
      home: SplashNav(
        appState: appState,
      ),
      //home: HomeBuilder(appState),
      debugShowCheckedModeBanner: false,
    );
  }
}
