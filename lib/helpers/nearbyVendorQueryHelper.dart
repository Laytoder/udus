import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frute/AppState.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/models/vendorInfo.dart';
import 'package:frute/tokens/googleMapsApiKey.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'locationHelper.dart';

class NearbyVendorQueryHelper {
  final firestoreInstance = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  AppState appState;
  LocationHelper locationHelper = LocationHelper();
  static const int LOCATION_SERVICE_DISABLED = 0;
  static const int PERMISSION_DENIED = 1;
  static const int NO_NEARBY_VENDORS = 2;

  NearbyVendorQueryHelper({this.appState});

  Future<dynamic> pickLocation(BuildContext context, String state) async {
    try {
      await locationHelper.enableLocationService();
    } catch (e) {
      return LOCATION_SERVICE_DISABLED;
    }
    if (await locationHelper.requestLocationPermission() ==
        LocationHelper.PERMISSION_GRANTED) {
      LatLng location;
      if (state == 'normal') {
        print(appState.userLocation);
        if (appState.userLocation == null &&
            appState.pendingTrip == null &&
            state != 'tripJustEnded') {
          LocationData locationData = await locationHelper.getLocation();
          LatLng initLocation =
              LatLng(locationData.latitude, locationData.longitude);
          location = (await showLocationPicker(
            context,
            gmapsApiKey,
            resultCardPadding: EdgeInsets.all(0.0),
            searchHeight: 60,
            searchWidth: 360,
            searchPadding: 20,
            initialCenter: initLocation,
            title: null,
            markerIcon: Container(
              child: SvgPicture.asset(
                'assets/marker.svg',
                height: 42,
                width: 42,
              ),
            ),
            hintText: 'Enter delivery location',
            appBarColor: Colors.transparent,
            myLocationButtonEnabled: false,
            automaticallyImplyLeading: false,
            automaticallyAnimateToCurrentLocation: false,
          ))
              .latLng;
          print('reached after map');
          appState.userLocation =
              GeoCoord(location.latitude, location.longitude);
        } else {
          location = LatLng(
            appState.userLocation.latitude,
            appState.userLocation.longitude,
          );
        }
      } else {
        location = LatLng(
          appState.userLocation.latitude,
          appState.userLocation.longitude,
        );
        LocationResult locationResult = await showLocationPicker(
          context,
          gmapsApiKey,
          resultCardPadding: EdgeInsets.all(0.0),
          searchHeight: 50,
          initialCenter: location,
          searchWidth: 360,
          searchPadding: 20,
          markerIcon: Container(
            child: SvgPicture.asset(
              'assets/marker.svg',
              height: 42,
              width: 42,
            ),
          ),
          hintText: 'Search Location',
          appBarColor: Colors.transparent,
          myLocationButtonEnabled: false,
          automaticallyImplyLeading: true,
          automaticallyAnimateToCurrentLocation: false,
        );
        if (locationResult != null) {
          double lat = locationResult.latLng.latitude;
          double lon = locationResult.latLng.longitude;
          GeoCoord newLoc = GeoCoord(lat, lon);
          appState.userLocation = newLoc;
          location = locationResult.latLng;
        }
      }
      return location;
    } else {
      return PERMISSION_DENIED;
    }
  }

  Future<dynamic> getNearbyVendors(
      BuildContext context, LatLng location) async {
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
  }

  AppState getAppState(List<DocumentSnapshot> documents) {
    List<Vegetable> avlVegs = [];
    appState.isVegSelectedMap = HashMap<String, bool>();
    for (DocumentSnapshot document in documents) {
      GeoPoint location = document['position']['geopoint'];
      String name = document['username'];
      String token = document['token'];
      String imageUrl = document['image'];
      String phoneNumber = document['phone'];
      String userId = document.documentID;
      List<dynamic> jsonNormalVegetables = document['normalVegetables'];
      List<Vegetable> vegetables = [];
      for (dynamic jsonNormalVegetable in jsonNormalVegetables) {
        vegetables.add(Vegetable.fromJson(jsonNormalVegetable));
      }
      //create a vegMap
      HashMap<String, double> vegMap = HashMap<String, double>();
      HashMap<String, String> dispPriceMap = HashMap<String, String>();
      for (Vegetable vegetable in vegetables) {
        String name = vegetable.name;
        double price = vegetable.price;
        vegMap[name] = price;
        dispPriceMap[name] = vegetable.dispPrice;
        if (!appState.isVegSelectedMap.containsKey(name)) {
          Vegetable newAvlVeg = Vegetable(
            vegetable.name,
            imageUrl: vegetable.imageUrl,
            commonNames: vegetable.commonNames,
            price: null,
            quantity: null,
            dispPrice: vegetable.dispPrice,
          );
          avlVegs.add(newAvlVeg);
          appState.isVegSelectedMap[name] = false;
        }
      }
      VendorInfo vendorInfo = VendorInfo(
        coords: location,
        name: name,
        phoneNumber: phoneNumber,
        imageUrl: imageUrl,
        vegetables: vegetables,
        token: token,
        id: userId,
        vegMap: vegMap,
        dispPriceMap: dispPriceMap,
      );

      if (!appState.vendors.containsKey(userId)) {
        appState.userId.add(userId);
      }
      appState.vendors[userId] = vendorInfo;
    }
    appState.avlVegs = avlVegs;
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
