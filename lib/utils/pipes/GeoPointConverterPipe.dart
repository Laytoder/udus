import 'package:cloud_firestore/cloud_firestore.dart';

class GeoPointConverterPipe {

  static Map toJson(GeoPoint geolocation) {
    return {
      'latitude': geolocation.latitude ?? 0.0,
      'longitude': geolocation.longitude ?? 0.0
    };
  }

  static GeoPoint fromJson(Map json) {
    return GeoPoint(json['latitude'], json['longitude']);
  }
}