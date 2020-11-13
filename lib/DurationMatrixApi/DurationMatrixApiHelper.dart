import 'package:frute/models/vendorInfo.dart';
import 'package:frute/tokens/googleMapsApiKey.dart';
import 'package:http/http.dart';
import 'dart:convert';

class DurationMatrixApiClient {
  final String apiUrl =
      'https://maps.googleapis.com/maps/api/distancematrix/json?';
  static const int CONNECTION_ERROR = 0;
  static const int VENDORS_LIMIT_EXCEEDED = 0;

  //only when vendors <= 30
  dynamic getDurationMatrix(List<VendorInfo> vendors) async {
    if (vendors.length > 30) return VENDORS_LIMIT_EXCEEDED;

    try {
      List<List<double>> durationMatrix = [];
      if (vendors.length > 10) {
        List<VendorInfo> sub1 = vendors.sublist(0, 10);
        if (vendors.length > 20) {
          List<VendorInfo> sub2 = vendors.sublist(10, 20);
          List<VendorInfo> sub3 = vendors.sublist(20);
          List<dynamic> res = await Future.wait([
            getDurationMatrixFromTenVendors(sub1, sub1),
            getDurationMatrixFromTenVendors(sub1, sub2),
            getDurationMatrixFromTenVendors(sub1, sub3),
            getDurationMatrixFromTenVendors(sub2, sub1),
            getDurationMatrixFromTenVendors(sub2, sub2),
            getDurationMatrixFromTenVendors(sub2, sub3),
            getDurationMatrixFromTenVendors(sub3, sub1),
            getDurationMatrixFromTenVendors(sub3, sub2),
            getDurationMatrixFromTenVendors(sub3, sub3),
          ]);
          for (int x = 0; x < 9; x = x + 3) {
            List<List<double>> subMatrix1 = res[x];
            List<List<double>> subMatrix2 = res[x + 1];
            List<List<double>> subMatrix3 = res[x + 2];
            for (int i = 0; i < subMatrix1.length; i++) {
              subMatrix1[i].addAll(subMatrix2[i]);
              subMatrix1[i].addAll(subMatrix3[i]);
            }
            durationMatrix.addAll(subMatrix1);
          }
          return durationMatrix;
        } else {
          List<VendorInfo> sub2 = vendors.sublist(10);
          List<dynamic> res = await Future.wait([
            getDurationMatrixFromTenVendors(sub1, sub1),
            getDurationMatrixFromTenVendors(sub1, sub2),
            getDurationMatrixFromTenVendors(sub2, sub1),
            getDurationMatrixFromTenVendors(sub2, sub2),
          ]);
          for (int x = 0; x < 4; x = x + 2) {
            List<List<double>> subMatrix1 = res[x];
            List<List<double>> subMatrix2 = res[x + 1];
            for (int i = 0; i < subMatrix1.length; i++) {
              subMatrix1[i].addAll(subMatrix2[i]);
            }
            durationMatrix.addAll(subMatrix1);
          }
          return durationMatrix;
        }
      } else {
        durationMatrix =
            await getDurationMatrixFromTenVendors(vendors, vendors);
        return durationMatrix;
      }
    } catch (e) {
      return CONNECTION_ERROR;
    }
  }

  dynamic getDurationMatrixFromTenVendors(
      List<VendorInfo> sub1, List<VendorInfo> sub2) async {
    String requestUrl = getRequestUrl(sub1, sub2);
    Response response = await get(requestUrl);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<List<double>> durationMatrix =
          List.generate(sub1.length, (i) => List(sub2.length), growable: true);
      List<String> jsonStringMatrixRows = body['rows'];
      for (int i = 0; i < jsonStringMatrixRows.length; i++) {
        Map<String, dynamic> jsonMatrixRow =
            jsonDecode(jsonStringMatrixRows[i]);
        List<String> jsonStringElements = jsonMatrixRow['elements'];
        for (String jsonStringElement in jsonStringElements) {
          Map<String, dynamic> jsonElement = jsonDecode(jsonStringElement);
          durationMatrix[i]
              .add(jsonDecode(jsonElement['duration_in_traffic'])['value']);
        }
      }
      return durationMatrix;
    } else {
      throw 'connection err';
    }
  }

  String getRequestUrl(
      List<VendorInfo> origins, List<VendorInfo> destinations) {
    //https://maps.googleapis.com/maps/api/distancematrix/json?origins=26.4326758,80.3264685|26.5236758,80.5164685&destinations=26.4326758,80.3264685|26.5236758,80.5164685&key=AIzaSyDBaaEbP86zHKvqNPe5HRXBY41ELjwWN5U
    //40.6655101,-73.89188969999998
    String origins_str = '', destinations_str = '';
    int len = origins.length >= destinations.length
        ? origins.length
        : destinations.length;
    for (int i = 0; i < len; i++) {
      if (i < origins.length) {
        origins_str = origins_str +
            origins[i].coords.latitude.toString() +
            ',' +
            origins[i].coords.longitude.toString() +
            (i == (origins.length - 1) ? '' : '|');
      }

      if (i < destinations.length) {
        destinations_str = destinations_str +
            destinations[i].coords.latitude.toString() +
            ',' +
            destinations[i].coords.longitude.toString() +
            (i == (destinations.length - 1) ? '' : '|');
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
}