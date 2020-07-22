import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:frute/models/bill.dart';
import 'package:google_directions_api/google_directions_api.dart';

class Trip {
  String state, eta, vendorId;
  GeoCoord origin, destination;
  DirectionApiHelper directionApiHelper;
  Bill verificationBill;

  Trip(
      {@required this.state,
      //@required this.vendorId,
      this.origin,
      this.destination,
      this.vendorId,
      this.eta = '',
      this.directionApiHelper,
      this.verificationBill});

  Map toJson() {
    return <String, dynamic>{
      'state': state,
      'eta': eta,
      //'vendorId': vendorId,
      //'uid': uid,
      'origin': origin == null ? '' : origin.toJson(),
      'destination': destination == null ? '' : destination.toJson(),
      'directionApiHelper':
          directionApiHelper == null ? '' : directionApiHelper.toJson(),
      'verificationBill':
          verificationBill == null ? '' : verificationBill.toJson(),
    };
  }
/*
  Trip.fromJson(Map json) {
    state = json['state'];
    eta = json['eta'];
    uid = json['uid'];
    //vendorId = json['vendorId'];
    origin = json['origin'] == '' ? null : GeoCoord.fromJson(json['origin']);
    destination = json['destination'] == ''
        ? null
        : GeoCoord.fromJson(json['destination']);
    DirectionApiHelper helper;
    if (json['directionApiHelper'] == '') {
      helper = null;
    } else {
      helper = DirectionApiHelper();
      helper.populateWithJson(json['directionApiHelper'], origin, destination);
    }
    directionApiHelper = helper;
    verificationBill = json['verificationBill'] == ''
        ? null
        : Bill.fromJson(jsonDecode(json['verificationBill']));
  }*/
}
