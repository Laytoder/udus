import 'models/vendorInfo.dart';

class AppState {

  Map<String, VendorInfo> verdors;
  List<String> userId;
  String messagingToken;

  AppState({this.verdors, this.userId, this.messagingToken});
}