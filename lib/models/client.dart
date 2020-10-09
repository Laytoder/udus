import 'package:flutter/cupertino.dart';

class Client {
  String name, phone, token;

  Client({
    @required this.name,
    @required this.phone,
    @required this.token,
  });

  Map toJson() {
    return {
      'name': name,
      'phone': phone,
      'token': token,
    };
  }

  Client.fromJson(Map json) {
    this.name = json['name'];
    this.phone = json['phone'];
    this.token = json['token'];
  }
}
