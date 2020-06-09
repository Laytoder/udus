import 'package:location/location.dart';

class LocationHelper {
  Location _location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  static const int PERMISSION_DENIED = 0;
  static const int PERMISSION_GRANTED = 1;

  enableLocationService() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        throw 'service enabling error';
      }
    }
  }

  requestLocationPermission() async {
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return PERMISSION_DENIED;
      }
    }
    return PERMISSION_GRANTED;
  }

  getLocation() async {
    _locationData = await _location.getLocation();
    return _locationData;
  }

}
