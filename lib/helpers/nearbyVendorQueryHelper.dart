import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/tokens/googleMapsApiKey.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'locationHelper.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:google_directions_api/google_directions_api.dart';

class NearbyVendorQueryHelper {
  final firestoreInstance = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  AppState appState;
  LocationHelper locationHelper = LocationHelper();
  static const int LOCATION_SERVICE_DISABLED = 0;
  static const int PERMISSION_DENIED = 1;
  static const int NO_NEARBY_VENDORS = 2;

  NearbyVendorQueryHelper({this.appState});

  Future<dynamic> getNearbyVendors(BuildContext context, String state) async {
    try {
      await locationHelper.enableLocationService();
    } catch (e) {
      return LOCATION_SERVICE_DISABLED;
    }
    if (await locationHelper.requestLocationPermission() ==
        LocationHelper.PERMISSION_GRANTED) {
      //location = await locationHelper.getLocation();
      //print('updated user location');
      LatLng location;
      if (state == 'normal') {
        if (appState.userLocation == null && appState.pendingTrip == null) {
          location = (await showLocationPicker(
            context,
            gmapsApiKey,
            appBarColor: Colors.white,
            myLocationButtonEnabled: true,
            automaticallyImplyLeading: false,
            automaticallyAnimateToCurrentLocation: true,
          ))
              .latLng;
          appState.userLocation =
              GeoCoord(location.latitude, location.longitude);
        } else {
          /*LocationData newLocation = await locationHelper.getLocation();
          location = LatLng(newLocation.latitude, newLocation.longitude);*/
          location = LatLng(
            appState.userLocation.latitude,
            appState.userLocation.longitude,
          );
        }
        //appState.userLocation = GeoCoord(location.latitude, location.longitude);
      } else {
        location = LatLng(
          appState.userLocation.latitude,
          appState.userLocation.longitude,
        );
        LocationResult locationResult = await showLocationPicker(
          context,
          gmapsApiKey,
          appBarColor: Colors.white,
          myLocationButtonEnabled: true,
          automaticallyImplyLeading: true,
          automaticallyAnimateToCurrentLocation: false,
          initialCenter: location,
        );
        if (locationResult != null) {
          double lat = locationResult.latLng.latitude;
          double lon = locationResult.latLng.longitude;
          GeoCoord newLoc = GeoCoord(lat, lon);
          appState.userLocation = newLoc;
          location = locationResult.latLng;
        }
      }
      /*LatLng location;
    if (locationResult != null) {
      location = locationResult.latLng;
      appState.userLocation = GeoCoord(location.latitude, location.longitude);
    } else {
      location = LatLng(
          appState.userLocation.latitude, appState.userLocation.longitude);
    }*/
      GeoFirePoint center =
          geo.point(latitude: location.latitude, longitude: location.longitude);
      var fireRef = firestoreInstance
          .collection('vendor_live_data')
          .where('active', isEqualTo: true);
      List<DocumentSnapshot> vendorDocs = await geo
          .collection(collectionRef: fireRef)
          .within(
            center: center,
            radius: 10.0,
            field: 'position',
            strictMode: true,
          )
          .first;
      if (vendorDocs == null || vendorDocs.length == 0) {
        return NO_NEARBY_VENDORS;
      }
      return getAppState(vendorDocs);
    } else {
      return PERMISSION_DENIED;
    }
  }

  AppState getAppState(List<DocumentSnapshot> documents) {
    for (DocumentSnapshot document in documents) {
      GeoPoint location = document['position']['geopoint'];
      String name = document['username'];
      String token = document['token'];
      String imageUrl = document['image'];
      String phoneNumber = document['phone'];
      print('real to');
      print(token);
      String userId = document.documentID;
      List<dynamic> jsonNormalVegetables = document['normalVegetables'];
      List<dynamic> jsonSpecialVegetables = document['specialVegetables'];
      List<Vegetable> vegetables = [];
      for (dynamic jsonNormalVegetable in jsonNormalVegetables) {
        vegetables.add(Vegetable.fromJson(jsonNormalVegetable));
      }
      for (dynamic jsonSpecialVegetable in jsonSpecialVegetables) {
        vegetables.add(Vegetable.fromJson(jsonSpecialVegetable));
      }
      print('this is image url $imageUrl');
      VendorInfo vendorInfo = VendorInfo(
          coords: location,
          name: name,
          phoneNumber: phoneNumber,
          imageUrl: imageUrl,
          vegetables: vegetables,
          token: token);

      if (!appState.vendors.containsKey(userId)) appState.userId.add(userId);
      appState.vendors[userId] = vendorInfo;
    }
    return appState;
  }

  Stream<LatLng> getVendorLocationStream(String id) {
    print(id);
    Stream<LatLng> stream = firestoreInstance
        .collection('vendor_live_data')
        .document(id)
        .snapshots()
        .map((document) => LatLng(document['position']['geopoint'].latitude,
            document['position']['geopoint'].longitude));
    return stream;
  }
}
