import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionApiHelper {
  final directionsService = DirectionsService();
  List<LatLng> points;
  List<Step> steps;
  LatLngBounds bounds;
  LatLng initCamera;
  DirectionsDuration duration;
  Distance distance;
  poly.PolylinePoints polylinePoints = poly.PolylinePoints();
  Map<String, dynamic> mapResult;

  Map toJson() {
    return mapResult;
  }

  populateWithJson(Map json, GeoCoord origin, GeoCoord destination) {
    print('this is json $json');
    DirectionsResult response = DirectionsResult.fromMap(json);
    initCamera = LatLng((origin.latitude + destination.latitude) / 2,
        (origin.longitude + destination.longitude) / 2);
    List<poly.PointLatLng> poly_points = polylinePoints
        .decodePolyline(response.routes[0].overviewPolyline.points);
    List<LatLng> points = [];
    for (poly.PointLatLng point in poly_points) {
      points.add(LatLng(point.latitude, point.longitude));
    }
    this.points = points;
    GeoCoordBounds gbounds = response.routes[0].bounds;
    bounds = LatLngBounds(
        northeast:
            LatLng(gbounds.northeast.latitude, gbounds.northeast.longitude),
        southwest:
            LatLng(gbounds.southwest.latitude, gbounds.southwest.longitude));
    steps = response.routes[0].legs[0].steps;
    duration = response.routes[0].legs[0].duration;
    distance = response.routes[0].legs[0].distance;
  }

  populateData(GeoCoord origin, GeoCoord destination) async {
    var request = DirectionsRequest(
      origin: origin,
      destination: destination,
      travelMode: TravelMode.driving,
      alternatives: false,
    );
    initCamera = LatLng((origin.latitude + destination.latitude) / 2,
        (origin.longitude + destination.longitude) / 2);
    await directionsService.route(request,
        (DirectionsResult response, DirectionsStatus status) {
      if (status == DirectionsStatus.ok) {
        List<poly.PointLatLng> poly_points = polylinePoints
            .decodePolyline(response.routes[0].overviewPolyline.points);
        List<LatLng> points = [];
        for (poly.PointLatLng point in poly_points) {
          points.add(LatLng(point.latitude, point.longitude));
        }
        this.points = points;
        GeoCoordBounds gbounds = response.routes[0].bounds;
        bounds = LatLngBounds(
            northeast:
                LatLng(gbounds.northeast.latitude, gbounds.northeast.longitude),
            southwest: LatLng(
                gbounds.southwest.latitude, gbounds.southwest.longitude));
        steps = response.routes[0].legs[0].steps;
        duration = response.routes[0].legs[0].duration;
        distance = response.routes[0].legs[0].distance;
        mapResult = response.mapResult;
      } else {
        print(status);
      }
    });
  }
}
