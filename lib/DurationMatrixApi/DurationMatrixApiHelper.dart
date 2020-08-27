import 'package:http/http.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DurationMatrixApiClient {
  final String apiUrl =
      'https://maps.googleapis.com/maps/api/distancematrix/json?';
  static const int CONNECTION_ERROR = 0;

  dynamic getDurationMatrix(List<LatLng> coordinates) async {
    String requestUrl = getRequestUrl(coordinates);
    Response response = await get(requestUrl);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<List<double>> durationMatrix;
      List<String> jsonStringMatrixRows = body['rows'];
      for (int i = 0; i < jsonStringMatrixRows.length; i++) {
        Map<String, dynamic> jsonMatrixRow = jsonDecode(jsonStringMatrixRows[i]);
        List<String> jsonStringElements = jsonMatrixRow['elements'];
        for(String jsonStringElement in jsonStringElements) {
          Map<String, dynamic> jsonElement = jsonDecode(jsonStringElement);
          durationMatrix[i].add(jsonDecode(jsonElement['duration']).value);
        }
      }
      return durationMatrix;
    } else {
      return CONNECTION_ERROR;
    }
  }

  String getRequestUrl(List<LatLng> coordinates) {
    String origin_or_destination = '';
    for (int i = 0; i < coordinates.length; i++) {
      origin_or_destination = origin_or_destination +
          coordinates[i].latitude.toString() +
          ',' +
          coordinates[i].longitude.toString() +
          (i == (coordinates.length - 1) ? '' : '|');
    }
    String requestUrl = apiUrl +
        'origin=' +
        origin_or_destination +
        'destination=' +
        origin_or_destination;

    return requestUrl;
  }
}
