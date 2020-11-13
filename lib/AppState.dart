import 'dart:async';

import 'package:frute/helpers/messagingHelper.dart';
import 'package:frute/helpers/vendorServiceHelper.dart';
import 'package:frute/models/client.dart';
import 'package:frute/models/vegetable.dart';

import 'models/order.dart';
import 'models/vendorInfo.dart';
import 'models/trip.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  Map<String, VendorInfo> vendors;
  bool isPendingTripUpdated, active, isMessagingServiceStarted;
  List<String> userId;
  String messagingToken, clientName, phoneNumber, image;
  GeoCoord userLocation;
  Trip pendingTrip;
  SharedPreferences preferences;
  StreamController<Map<String, dynamic>> messages;
  VendorServiceHelper serviceHelper = VendorServiceHelper();
  MessagingHelper messagingHelper = MessagingHelper();
  List<Vegetable> avlVegs = [];
  Order order;

  /*StreamController<Map<String, dynamic>> rejectionMessages,
      holdMessages,
      ongoingMessages,
      verificationMessages;*/

  AppState(
      {this.vendors,
      this.userId,
      this.isPendingTripUpdated = false,
      this.active = false,
      this.isMessagingServiceStarted = false,
      this.userLocation,
      this.pendingTrip,
      this.messages,
      this.preferences,
      //this.rejectionMessages,
      //this.holdMessages,
      //this.ongoingMessages,
      //this.verificationMessages,
      this.messagingToken,
      //this.activeVendorId = '',
      this.clientName = '',
      this.phoneNumber = ''
      });
}
