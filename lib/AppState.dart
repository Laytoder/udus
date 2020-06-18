import 'models/vendorInfo.dart';
import 'package:google_directions_api/google_directions_api.dart';

class AppState {
  Map<String, VendorInfo> verdors;
  List<String> userId;
  String messagingToken, clientName;
  GeoCoord userLocation;

  AppState(
      {this.verdors,
      this.userId,
      this.userLocation,
      this.messagingToken,
      this.clientName = ''});
}
