import 'dart:convert';

import 'package:frute/models/vendorInfo.dart';
import 'package:frute/tokens/googleMapsApiKey.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DurationMatrixApiClient {
  final String apiUrl =
      'https://maps.googleapis.com/maps/api/distancematrix/json?';
  static const int CONNECTION_ERROR = 0;

  dynamic getDurationMatrices(
      GeoPoint homeLocation, List<VendorInfo> vendors) async {
    try {
      if (vendors.length == 1) {
        dynamic res = await getDurationMatrixForHome(homeLocation, vendors);
        return [
          [
            [0]
          ],
          res
        ];
      } else {
        List<dynamic> res = await Future.wait([
          getDurationMatrix(vendors),
          getDurationMatrixForHome(homeLocation, vendors),
        ]);
        return [res[0], res[1]];
      }
    } catch (e) {
      return CONNECTION_ERROR;
    }
  }

  dynamic getDurationMatrixForHome(
      GeoPoint homeLocation, List<VendorInfo> vendors) async {
    String requestUrl = getRequestUrlForHome(homeLocation, vendors);
    Response response = await get(requestUrl);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      /*List<List<int>> durationMatrix =
          List.generate(sub1.length, (i) => [], growable: true);*/
      List<int> durationMatrix = [];
      //List<List<int>> durationMatrix = [];
      List<dynamic> jsonMatrixRows = body['rows'];
      List<dynamic> jsonElements = jsonMatrixRows[0]['elements'];
      for (dynamic jsonElement in jsonElements) {
        durationMatrix.add(jsonElement['duration_in_traffic']['value']);
      }
      return durationMatrix;
    } else {
      throw 'connection err';
    }
  }

  dynamic getDurationMatrix(List<VendorInfo> vendors) async {
    String requestUrl = getRequestUrl(vendors);
    Response response = await get(requestUrl);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<List<int>> durationMatrix =
          List.generate(vendors.length, (i) => [], growable: true);
      //List<List<int>> durationMatrix = [];
      List<dynamic> jsonMatrixRows = body['rows'];
      for (int i = 0; i < jsonMatrixRows.length; i++) {
        List<dynamic> jsonElements = jsonMatrixRows[i]['elements'];
        for (dynamic jsonElement in jsonElements) {
          durationMatrix[i].add(jsonElement['duration_in_traffic']['value']);
        }
      }
      return durationMatrix;
    } else {
      throw 'connection err';
    }
  }

  String getRequestUrlForHome(GeoPoint homeLocation, List<VendorInfo> vendors) {
    String origins_str = '', destinations_str = '';
    origins_str = origins_str +
        homeLocation.latitude.toString() +
        ',' +
        homeLocation.longitude.toString();
    for (int i = 0; i < vendors.length; i++) {
      if (i < vendors.length) {
        destinations_str = destinations_str +
            vendors[i].coords.latitude.toString() +
            ',' +
            vendors[i].coords.longitude.toString() +
            (i == (vendors.length - 1) ? '' : '|');
      }
    }
    String requestUrl = apiUrl +
        'origins=' +
        origins_str +
        '&destinations=' +
        destinations_str +
        '&departure_time=now&key=' +
        gmapsApiKey;

    return requestUrl;
  }

  String getRequestUrl(List<VendorInfo> vendors) {
    String origin_or_destination = '';
    for (int i = 0; i < vendors.length; i++) {
      origin_or_destination = origin_or_destination +
          vendors[i].coords.latitude.toString() +
          ',' +
          vendors[i].coords.longitude.toString() +
          (i == (vendors.length - 1) ? '' : '|');
    }
    String requestUrl = apiUrl +
        'origins=' +
        origin_or_destination +
        '&destinations=' +
        origin_or_destination +
        '&departure_time=now&key=' +
        gmapsApiKey;

    return requestUrl;
  }
}
