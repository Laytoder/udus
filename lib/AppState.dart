import 'dart:async';

import 'models/vendorInfo.dart';
import 'models/trip.dart';
import 'package:google_directions_api/google_directions_api.dart';

class AppState {
  Map<String, VendorInfo> vendors;
  bool isPendingTripUpdated, active, isMessagingServiceStarted;
  List<String> userId;
  String messagingToken, clientName, phoneNumber, image;
  GeoCoord userLocation;
  Trip pendingTrip;
  StreamController<Map<String, dynamic>> messages;
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
      //this.rejectionMessages,
      //this.holdMessages,
      //this.ongoingMessages,
      //this.verificationMessages,
      this.messagingToken,
      //this.activeVendorId = '',
      this.clientName = '',
      this.phoneNumber = ''});
}
