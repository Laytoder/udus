import 'package:cloud_firestore/cloud_firestore.dart';
import 'vegetable.dart';

class VendorInfo {
  String name, location, token;
  GeoPoint coords;
  List<Vegetable> normalVegetables, specialVegetables;
  double distance, eta, rating;

  VendorInfo(
      {this.name = '',
      this.location = '',
      this.coords,
      this.normalVegetables,
      this.specialVegetables,
      this.distance = 0.0,
      this.eta = 0.0,
      this.rating = 0.0,
      this.token});
}
