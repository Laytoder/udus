import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'vegetable.dart';

class VendorInfo {
  String name, location, token, imageUrl, phoneNumber;
  GeoPoint coords;
  List<Vegetable> vegetables;
  double distance, eta, rating;

  VendorInfo(
      {this.name = '',
      this.location = '',
      @required this.phoneNumber,
      this.coords,
      this.vegetables,
      this.distance = 0.0,
      this.eta = 0.0,
      this.rating = 0.0,
      this.imageUrl = '',
      this.token});

  Map toJson() {
    List<dynamic> jsonVegs = [];
    for (Vegetable vegetable in vegetables) {
      jsonVegs.add(jsonEncode(vegetable.toJson()));
    }
    return {
      'name': name,
      'location': location,
      'token': token,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
      'coords': coords == null ? null : coords.toJson(),
      'vegetables': jsonVegs,
      'distance': distance,
      'eta': eta,
      'rating': rating,
    };
  }

  VendorInfo.fromJson(Map json) {
    name = json['name'];
    location = json['location'];
    token = json['token'];
    imageUrl = json['imageUrl'];
    phoneNumber = json['phoneNumber'];
    coords = json['coords'] == null
        ? null
        : GeoPoint.fromJson(
            json['coords'],
          );
    distance = json['distance'];
    eta = json['eta'];
    rating = json['rating'];
    vegetables = [];
    List<dynamic> jsonVegs = json['vegetables'];
    for (dynamic jsonVeg in jsonVegs) {
      vegetables.add(
        Vegetable.fromJson(
          jsonDecode(jsonVeg),
        ),
      );
    }
  }
}
