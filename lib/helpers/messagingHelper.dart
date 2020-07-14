import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/billPage.dart';
import 'package:frute/Pages/holdPage.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/models/bill.dart';
import 'package:frute/models/trip.dart';
import 'package:frute/models/vegetable.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:http/http.dart' as http;
import 'package:frute/tokens/fireMessagingServerToken.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frute/Pages/map.dart' as mapPage;
import 'package:shared_preferences/shared_preferences.dart';

class MessagingHelper {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();
  AppState appState;
  SharedPreferences preferences;

  sendMessage(String to, String from, GeoCoord coord, String clientName,
      String clientPhone) async {
    print('to in send message');
    print(to);
    print('from in send message');
    print(from);
    var res;
    do {
      res = await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'Request from $clientName',
              'title': 'Request Occured',
              'android': {
                'notification': {
                  'channel_id': 'hawferid',
                },
              }
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'message': <String, dynamic>{
                'from': from,
                'name': clientName,
                'phone': clientPhone,
                'lat': coord.latitude,
                'lon': coord.longitude
              },
              'status': 'done'
            },
            'to': to,
          },
        ),
      );
    } while (res.statusCode != 200);
    print('message sent');
  }

  /*Future<dynamic> getReply() async {
    final Completer<dynamic> completer = Completer<dynamic>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (message['data']['message'] == '')
          completer.complete('');
        else
          completer.complete(jsonDecode(message['data']['message']));
      },
      onLaunch: (Map<String, dynamic> message) async {
        if (message['data']['message'] == '')
          completer.complete('');
        else
          completer.complete(jsonDecode(message['data']['message']));
      },
      onResume: (Map<String, dynamic> message) async {
        if (message['data']['message'] == '')
          completer.complete('');
        else
          completer.complete(jsonDecode(message['data']['message']));
      },
    );
    return completer.future;
  }*/

  /*Future<Map<String, dynamic>> getReply() async {
    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
      onResume: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
    return completer.future;
  }*/

  /*startMessagingService(
      BuildContext context, String vendorId, AppState appState) {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('message occured');
        var bill = jsonDecode(message['data']['message']);
        print(bill);
        List<dynamic> jsonVegetables = bill['vegetables'];
        List<Vegetable> purchasedVegetables = [];
        for (dynamic jsonVegetable in jsonVegetables) {
          print(jsonVegetable);
          Vegetable vegetable = Vegetable.fromJson(jsonVegetable);
          print(vegetable);
          purchasedVegetables.add(vegetable);
        }
        double total = bill['total'];
        print(total);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BillPage(
              state: 'Verification',
              vegetables: purchasedVegetables,
              total: total,
              vendorId: vendorId,
              appState: appState,
            ),
          ),
        );
      },
      onResume: (Map<String, dynamic> message) async {
        print('message occured');
        var bill = jsonDecode(message['data']['message']);
        print(bill);
        List<dynamic> jsonVegetables = bill['vegetables'];
        List<Vegetable> purchasedVegetables = [];
        for (dynamic jsonVegetable in jsonVegetables) {
          print(jsonVegetable);
          Vegetable vegetable = Vegetable.fromJson(jsonVegetable);
          print(vegetable);
          purchasedVegetables.add(vegetable);
        }
        double total = bill['total'];
        print(total);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BillPage(
              state: 'Verification',
              vegetables: purchasedVegetables,
              total: total,
              vendorId: vendorId,
              appState: appState,
            ),
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('message occured');
        var bill = jsonDecode(message['data']['message']);
        print(bill);
        List<dynamic> jsonVegetables = bill['vegetables'];
        List<Vegetable> purchasedVegetables = [];
        for (dynamic jsonVegetable in jsonVegetables) {
          print(jsonVegetable);
          Vegetable vegetable = Vegetable.fromJson(jsonVegetable);
          print(vegetable);
          purchasedVegetables.add(vegetable);
        }
        double total = bill['total'];
        print(total);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BillPage(
              state: 'Verification',
              vegetables: purchasedVegetables,
              total: total,
              vendorId: vendorId,
              appState: appState,
            ),
          ),
        );
      },
    );
  }*/

  Future showNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'hawferid', 'hawfer name', 'hawfer description',
        importance: Importance.High, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: message['data']['message'],
    );
  }

  Future onSelectNotification(String payload) async {
    Map<String, dynamic> messageMap = jsonDecode(payload);
    String state = messageMap['state'];

    switch (state) {
      case 'hold':
        String eta = messageMap['eta'];
        /*List<Trip> pendingTrips = appState.pendingTrips;
        List<String> jsonTrips = [];
        for (Trip trip in pendingTrips) {
          if (trip.vendorId == id) {
            trip.state = state;
          }
          jsonTrips.add(jsonEncode(trip.toJson()));
        }
        preferences.setStringList('pendingTrips', jsonTrips);*/
        /*appState.pendingTrip.state = 'hold';
        appState.pendingTrip.eta = eta;
        appState.active = true;*/
        appState.active = true;
        navigatorkey.currentState.push(
          MaterialPageRoute(
            builder: (context) => HoldPage(
              eta: eta,
              vendorName: 'Ramu Kaka',
              preferences: preferences,
              appState: appState,
            ),
          ),
        );
        break;

      case 'ongoing':
        //GeoCoord origin = GeoCoord.fromJson(messageMap['origin']);
        //GeoCoord destination = GeoCoord.fromJson(messageMap['destination']);
        DirectionApiHelper directionApiHelper = DirectionApiHelper();
        directionApiHelper = appState.pendingTrip.directionApiHelper;
        //await directionApiHelper.populateData(origin, destination);
        /*List<Trip> pendingTrips = appState.pendingTrips;
        List<String> jsonTrips = [];
        for (Trip trip in pendingTrips) {
          if (trip.vendorId == id) {
            trip.directionApiHelper = directionApiHelper;
            trip.state = state;
            trip.origin = origin;
            trip.destination = destination;
          }
          jsonTrips.add(jsonEncode(trip.toJson()));
        }
        preferences.setStringList('pendingTrips', jsonTrips);
        appState.activeVendorId = id;*/
        /*appState.pendingTrip.state = 'ongoing';
        appState.pendingTrip.origin = origin;
        appState.pendingTrip.destination = destination;
        appState.pendingTrip.directionApiHelper = directionApiHelper;
        appState.active = true;
        preferences.setString(
          'directionsApiHelper',
          jsonEncode(directionApiHelper.toJson()),
        );*/
        appState.active = true;
        print('yaaa i am pushing');
        navigatorkey.currentState.push(
          MaterialPageRoute(
            builder: (context) => mapPage.Map(
              appState: appState,
              directionApiHelper: directionApiHelper,
            ),
          ),
        );
        break;

      case 'verification':
        /*List<dynamic> jsonVegetables = messageMap['vegetables'];
        List<Vegetable> purchasedVegetables = [];
        for (dynamic jsonVegetable in jsonVegetables) {
          Vegetable vegetable = Vegetable.fromJson(jsonVegetable);
          purchasedVegetables.add(vegetable);
        }
        double total = messageMap['total'];
        appState.pendingTrip.state = 'verification';
        appState.pendingTrip.verificationBill =
            Bill(purchasedVegetables, total, DateTime.now());*/
        List<Vegetable> purchasedVegetables =
            appState.pendingTrip.verificationBill.purchasedVegetables;
        double total = appState.pendingTrip.verificationBill.total;
        /*List<Trip> pendingTrips = appState.pendingTrips;
        List<String> jsonTrips = [];
        for (Trip trip in pendingTrips) {
          if (trip.vendorId == messageMap['id']) {
            trip.state = state;
            trip.verificationBill =
                Bill(purchasedVegetables, total, DateTime.now());
          }
          jsonTrips.add(jsonEncode(trip.toJson()));
        }
        preferences.setStringList('pendingTrips', jsonTrips);
        appState.activeVendorId = messageMap['id'];*/
        appState.active = true;
        print('yaa from here');
        navigatorkey.currentState.push(
          MaterialPageRoute(
            builder: (context) => BillPage(
              state: 'Verification',
              vegetables: purchasedVegetables,
              total: total,
              //vendorId: messageMap['id'],
              appState: appState,
            ),
          ),
        );
    }
  }

  Future<void> initializeLocalNotifications() async {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> createNotificationChannel(
      String id, String name, String description) async {
    var androidNotificationChannel = AndroidNotificationChannel(
      id,
      name,
      description,
      importance: Importance.High,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  startMessagingService(
      AppState appState, SharedPreferences preferences) async {
    this.preferences = preferences;
    this.appState = appState;
    await initializeLocalNotifications();
    await createNotificationChannel(
        'hawferid', 'hawfer name', 'hawfer description');
    appState.messages = StreamController();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message is the asshole');
        Map<String, dynamic> messageMap =
            jsonDecode(message['data']['message']);
        //String state = messageMap['state'];
        /*switch (state) {
          case 'rejected':
            if (messageMap['id'] != appState.activeVendorId) {
              //show notification with payload for launch
              showNotification(message);
            } else {
              appState.rejectionMessages
                  .add(jsonDecode(message['data']['message']));
            }
            break;

          case 'hold':
            if (messageMap['id'] != appState.activeVendorId) {
              //show notification with payload for launch
              showNotification(message);
            } else {
              appState.holdMessages.add(jsonDecode(message['data']['message']));
            }
            break;

          case 'ongoing':
            if (messageMap['id'] != appState.activeVendorId) {
              //show notification with payload for launch
              print('this is active vendorId ${appState.activeVendorId}');
              print('this is map vendor id ${messageMap['vendorId']}');
              showNotification(message);
            } else {
              appState.ongoingMessages
                  .add(jsonDecode(message['data']['message']));
            }
            break;

          case 'verification':
            if (messageMap['id'] != appState.activeVendorId) {
              //show notification with payload for launch
              showNotification(message);
            } else {
              appState.verificationMessages
                  .add(jsonDecode(message['data']['message']));
            }
            break;
        }*/
        if (appState.active) {
          appState.messages.add(messageMap);
        } else {
          String state = messageMap['state'];
          switch (state) {
            case 'hold':
              String eta = messageMap['eta'];
              appState.pendingTrip.state = 'hold';
              appState.pendingTrip.eta = eta;
              break;

            case 'ongoing':
              GeoCoord origin = GeoCoord.fromJson(messageMap['origin']);
              GeoCoord destination =
                  GeoCoord.fromJson(messageMap['destination']);
              DirectionApiHelper directionApiHelper = DirectionApiHelper();
              await directionApiHelper.populateData(origin, destination);
              appState.pendingTrip.state = 'ongoing';
              appState.pendingTrip.origin = origin;
              appState.pendingTrip.destination = destination;
              appState.pendingTrip.directionApiHelper = directionApiHelper;
              preferences.setString(
                'directionsApiHelper',
                jsonEncode(directionApiHelper.toJson()),
              );
              break;

            case 'verification':
              List<dynamic> jsonVegetables = messageMap['vegetables'];
              List<Vegetable> purchasedVegetables = [];
              for (dynamic jsonVegetable in jsonVegetables) {
                Vegetable vegetable = Vegetable.fromJson(jsonVegetable);
                purchasedVegetables.add(vegetable);
              }
              double total = messageMap['total'];
              appState.pendingTrip.state = 'verification';
              appState.pendingTrip.verificationBill =
                  Bill(purchasedVegetables, total, DateTime.now());
              break;
          }
          showNotification(message);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume is the asshole');
        Map<String, dynamic> messageMap =
            jsonDecode(message['data']['message']);
        String state = messageMap['state'];
        switch (state) {
          case 'hold':
            String eta = messageMap['eta'];
            appState.pendingTrip.state = 'hold';
            appState.pendingTrip.eta = eta;
            break;

          case 'ongoing':
            GeoCoord origin = GeoCoord.fromJson(messageMap['origin']);
            GeoCoord destination = GeoCoord.fromJson(messageMap['destination']);
            DirectionApiHelper directionApiHelper = DirectionApiHelper();
            await directionApiHelper.populateData(origin, destination);
            appState.pendingTrip.state = 'ongoing';
            appState.pendingTrip.origin = origin;
            appState.pendingTrip.destination = destination;
            appState.pendingTrip.directionApiHelper = directionApiHelper;
            preferences.setString(
              'directionsApiHelper',
              jsonEncode(directionApiHelper.toJson()),
            );
            break;

          case 'verification':
            List<dynamic> jsonVegetables = messageMap['vegetables'];
            List<Vegetable> purchasedVegetables = [];
            for (dynamic jsonVegetable in jsonVegetables) {
              Vegetable vegetable = Vegetable.fromJson(jsonVegetable);
              purchasedVegetables.add(vegetable);
            }
            double total = messageMap['total'];
            appState.pendingTrip.state = 'verification';
            appState.pendingTrip.verificationBill =
                Bill(purchasedVegetables, total, DateTime.now());
            break;
        }
        onSelectNotification(message['data']['message']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch is the asshole');
        Map<String, dynamic> messageMap =
            jsonDecode(message['data']['message']);
        String state = messageMap['state'];
        switch (state) {
          case 'hold':
            String eta = messageMap['eta'];
            appState.pendingTrip.state = 'hold';
            appState.pendingTrip.eta = eta;
            break;

          case 'ongoing':
            GeoCoord origin = GeoCoord.fromJson(messageMap['origin']);
            GeoCoord destination = GeoCoord.fromJson(messageMap['destination']);
            DirectionApiHelper directionApiHelper = DirectionApiHelper();
            await directionApiHelper.populateData(origin, destination);
            appState.pendingTrip.state = 'ongoing';
            appState.pendingTrip.origin = origin;
            appState.pendingTrip.destination = destination;
            appState.pendingTrip.directionApiHelper = directionApiHelper;
            preferences.setString(
              'directionsApiHelper',
              jsonEncode(directionApiHelper.toJson()),
            );
            break;

          case 'verification':
            List<dynamic> jsonVegetables = messageMap['vegetables'];
            List<Vegetable> purchasedVegetables = [];
            for (dynamic jsonVegetable in jsonVegetables) {
              Vegetable vegetable = Vegetable.fromJson(jsonVegetable);
              purchasedVegetables.add(vegetable);
            }
            double total = messageMap['total'];
            appState.pendingTrip.state = 'verification';
            appState.pendingTrip.verificationBill =
                Bill(purchasedVegetables, total, DateTime.now());
            break;
        }
        onSelectNotification(message['data']['message']);
      },
    );
  }
}
