import 'dart:async';

import 'package:frute/AppState.dart';
/*
Future<Map<String, dynamic>> getFirstReply(AppState appState) {
  Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();

  appState.holdMessages.stream.listen((Map<String, dynamic> message) {
    completer.complete(message);
  });

  appState.rejectionMessages.stream.listen((Map<String, dynamic> message) {
    completer.complete(message);
  });

  appState.ongoingMessages.stream.listen((Map<String, dynamic> message) {
    completer.complete(message);
  });

  return completer.future;
}

Future<Map<String, dynamic>> getOngoingReply(AppState appState) {
  Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();

  appState.ongoingMessages.stream.listen((Map<String, dynamic> message) {
    completer.complete(message);
  });

  return completer.future;
}

Future<Map<String, dynamic>> getVerificationReply(AppState appState) {
  Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();

  appState.verificationMessages.stream.listen((Map<String, dynamic> message) {
    completer.complete(message);
  });

  return completer.future;
}*/

Future<Map<String, dynamic>> getReply(AppState appState) async {
  /*final Completer<Map<String, dynamic>> completer =
      Completer<Map<String, dynamic>>();

  appState.messages.stream.listen((message) {
    completer.complete(message);
  });
  return completer.future;*/
  Map<String, dynamic> message = await appState.messages.stream.first;
  appState.messages = StreamController();
  return message;
}
