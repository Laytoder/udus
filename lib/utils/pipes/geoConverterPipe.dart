import 'package:google_directions_api/google_directions_api.dart';

class GeoConverterPipe {
  static Map toJson(GeoCoord geolocation) {
    return {
      'lat': geolocation.latitude ?? 0.0,
      'lon': geolocation.longitude ?? 0.0
    };
  }

  static GeoCoord fromJson(Map json) {
    return GeoCoord(json['lat'], json['lon']);
  }
}
