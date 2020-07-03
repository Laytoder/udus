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
}
