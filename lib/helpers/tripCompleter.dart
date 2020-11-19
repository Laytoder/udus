import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frute/AppState.dart';
import 'package:frute/models/bill.dart';
import 'package:frute/models/vegetable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripCompleter {
  final firestoreInstance = Firestore.instance;

  completeTrip(List<Vegetable> purchasedVegetables, double total,
      String vendorId, AppState appState) async {
    final postRef =
        firestoreInstance.collection('vendor_live_data').document(vendorId);

    appState.active = false;

    SharedPreferences preferences = await SharedPreferences.getInstance();

    //remove pending trip from appState and prefernces
    /*List<Trip> pendingTrips = [];
    List<String> jsonTrips = [];
    for (Trip trip in appState.pendingTrips) {
      if (trip.vendorId != vendorId) {
        pendingTrips.add(trip);
        jsonTrips.add(jsonEncode(trip.toJson()));
      }
    }*/
    appState.pendingTrip = null;
    /*preferences.setStringList(
        'pendingTrips', jsonTrips.length == 0 ? null : jsonTrips);*/
    preferences.setString('directionsApiHelper', null);
    preferences.setString('pendingTripVendorId', null);

    //save bill to shared preferences
    List<dynamic> bills = preferences.getStringList('bills');
    if (bills == null || bills.length == 0) {
      print(jsonEncode(
          Bill(purchasedVegetables, total, DateTime.now()).toJson()));
      preferences.setStringList('bills', [
        jsonEncode(Bill(purchasedVegetables, total, DateTime.now()).toJson())
      ]);
    } else {
      print(jsonEncode(
          Bill(purchasedVegetables, total, DateTime.now()).toJson()));
      bills.add(jsonEncode(
          Bill(purchasedVegetables, total, DateTime.now()).toJson()));
      preferences.setStringList('bills', bills);
      print('saved bill');
    }

    /*await firestoreInstance.runTransaction((Transaction tx) async {
      await doTransaction(
          tx, postRef, purchasedVegetables, appState, vendorId, total);
    }).timeout(Duration(seconds: 60));*/

    DocumentSnapshot postSnapshot = await postRef.get();
    if (postSnapshot.exists) {
      print('post exists');
      Map<String, dynamic> data = postSnapshot.data;
      List<dynamic> njsonVegetables = data['normalVegetables'];
      List<dynamic> sjsonVegetables = data['specialVegetables'];
      List<Vegetable> currentNVegs = [], currentSVegs = [];
      for (dynamic jsonVeg in njsonVegetables) {
        currentNVegs.add(Vegetable.fromJson(jsonVeg));
      }
      for (dynamic jsonVeg in sjsonVegetables) {
        currentSVegs.add(Vegetable.fromJson(jsonVeg));
      }
      for (Vegetable veg1 in currentNVegs) {
        for (Vegetable veg2 in purchasedVegetables) {
          if (veg1.name == veg2.name)
            veg1.quantity = veg1.quantity - veg2.quantity;
        }
      }
      for (Vegetable veg1 in currentSVegs) {
        for (Vegetable veg2 in purchasedVegetables) {
          if (veg1.name == veg2.name)
            veg1.quantity = veg1.quantity - veg2.quantity;
        }
      }
      List<dynamic> updatedNVegJson = [];
      for (Vegetable updatedVeg in currentNVegs) {
        updatedNVegJson.add(updatedVeg.toJson());
      }
      List<dynamic> updatedSVegJson = [];
      for (Vegetable updatedVeg in currentSVegs) {
        updatedSVegJson.add(updatedVeg.toJson());
      }
      List<dynamic> jsonTrips = data['pendingTrips'];
      List<dynamic> pendingTrips = [];
      for (dynamic jsonTrip in jsonTrips) {
        if (jsonTrip['uid'] != appState.phoneNumber) pendingTrips.add(jsonTrip);
      }
      double turnover = 0;
      if (data.containsKey('turnover')) turnover = data['turnover'];
      turnover = turnover + total;
      int completedTrips = 0;
      if (data.containsKey('trips')) completedTrips = data['trips'];
      completedTrips = completedTrips + 1;

      print('reached to the point of updating in transaction');
      await postRef.updateData(<String, dynamic>{
        'normalVegetables': updatedNVegJson,
        'specialVegetables': updatedSVegJson,
        'turnover': turnover,
        'pendingTrips': pendingTrips,
        'completedTrips': completedTrips,
        'active': true
      });
    }
  }

  doTransaction(Transaction tx, postRef, purchasedVegetables, appState,
      vendorId, total) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    print(postRef.toString());
    print(postSnapshot.toString());
    if (postSnapshot.exists) {
      print('post exists');
      Map<String, dynamic> data = postSnapshot.data;
      List<dynamic> njsonVegetables = data['normalVegetables'];
      List<dynamic> sjsonVegetables = data['specialVegetables'];
      List<Vegetable> currentNVegs = [], currentSVegs = [];
      for (dynamic jsonVeg in njsonVegetables) {
        currentNVegs.add(Vegetable.fromJson(jsonVeg));
      }
      for (dynamic jsonVeg in sjsonVegetables) {
        currentSVegs.add(Vegetable.fromJson(jsonVeg));
      }
      for (Vegetable veg1 in currentNVegs) {
        for (Vegetable veg2 in purchasedVegetables) {
          if (veg1.name == veg2.name)
            veg1.quantity = veg1.quantity - veg2.quantity;
        }
      }
      for (Vegetable veg1 in currentSVegs) {
        for (Vegetable veg2 in purchasedVegetables) {
          if (veg1.name == veg2.name)
            veg1.quantity = veg1.quantity - veg2.quantity;
        }
      }
      List<dynamic> updatedNVegJson = [];
      for (Vegetable updatedVeg in currentNVegs) {
        updatedNVegJson.add(updatedVeg.toJson());
      }
      List<dynamic> updatedSVegJson = [];
      for (Vegetable updatedVeg in currentSVegs) {
        updatedSVegJson.add(updatedVeg.toJson());
      }
      List<dynamic> jsonTrips = data['pendingTrips'];
      List<dynamic> pendingTrips = [];
      for (dynamic jsonTrip in jsonTrips) {
        if (jsonTrip['uid'] != appState.phoneNumber) pendingTrips.add(jsonTrip);
      }
      double turnover = 0;
      if (data.containsKey('turnover')) turnover = data['turnover'];
      turnover = turnover + total;
      int completedTrips = 0;
      if (data.containsKey('trips')) completedTrips = data['trips'];
      completedTrips = completedTrips + 1;

      print('reached to the point of updating in transaction');
      await tx.update(postRef, <String, dynamic>{
        'normalVegetables': updatedNVegJson,
        'specialVegetables': updatedSVegJson,
        'turnover': turnover,
        'pendingTrips': pendingTrips,
        'completedTrips': completedTrips,
        'active': true
      });
    }
  }
}
