import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:frute/tokens/fireMessagingServerToken.dart';

class MessagingHelper {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  sendMessage(String to, String from) async {
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
            'body': 'this is body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'message': from,
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
        print('message occured');
        completer.complete(jsonDecode(message['data']['message']));
      },
    );
    return completer.future;
  }
}
