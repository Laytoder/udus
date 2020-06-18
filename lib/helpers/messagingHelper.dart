import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/billPage.dart';
import 'package:frute/models/vegetable.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:http/http.dart' as http;
import 'package:frute/tokens/fireMessagingServerToken.dart';

class MessagingHelper {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  sendMessage(String to, String from, GeoCoord coord, String clientName) async {
    print('to in send message');
    print(to);
    print('from in send message');
    print(from);
    var res = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Request from $clientName',
            'title': 'Request Occured'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'message': <String, dynamic>{
              'from': from,
              'name': clientName,
              'lat': coord.latitude,
              'lon': coord.longitude
            },
            'status': 'done'
          },
          'to': to,
        },
      ),
    );
    print(res.statusCode);
    print('message sent');
  }

  Future<dynamic> getReply() async {
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
    );
    return completer.future;
  }

  startMessagingService(
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
              builder: (context) =>
                  BillPage(purchasedVegetables, total, vendorId, appState)),
        );
      },
      onResume: (Map<String, dynamic> message) async {
        var bill = jsonDecode(message['data']['message']);
        List<dynamic> jsonVegetables = bill['vegetables'];
        List<Vegetable> purchasedVegetables;
        for (dynamic jsonVegetable in jsonVegetables) {
          Vegetable vegetable = Vegetable.fromJson(jsonDecode(jsonVegetable));
          purchasedVegetables.add(vegetable);
        }
        double total = bill['total'];
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BillPage(purchasedVegetables, total, vendorId, appState)),
        );
      },
    );
  }
}
