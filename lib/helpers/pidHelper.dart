import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;
import 'package:google_directions_api/google_directions_api.dart';

class PIDHelper {
  static const double KP = 100.0;
  static const double KI = 10.0;
  static const double KD = 10.0;
  static const double dt = 5.0;
  static const double UPPER_BOUND = 1000000;
  static const double LOWER_BOUND = 2000;
  double p, i = 0, d, prevErr = 0;
  final List<LatLng> polyLineList;
  final List<Step> stepList;

  PIDHelper(this.polyLineList, this.stepList);

  double getUpdatedDuration(LatLng newPos, LatLng currentPos, double duration) {
    newPos = snapToRoad(newPos);
    //err is in meters
    double err = getErr(newPos, currentPos);
    p = err * KP;
    i = ((i + err) * dt) * KI;
    d = ((err - prevErr) / dt) * KD;
    prevErr = err;
    double total = p;
    //print('p is $p i is $i d is $d');
    //thresholds of 200 meters
    print('this is total $total');
    if(total >= 200) return LOWER_BOUND;
    if(total <= -200) return UPPER_BOUND;
    //normal duration adjustment
    duration = duration - total;
    duration = constrain(duration, LOWER_BOUND, UPPER_BOUND);

    return duration;
  }

  double constrain(double value, double lowerBound, double upperBound) {
    if (value > upperBound) return upperBound;
    if (value < lowerBound) return lowerBound;
    return value;
  }

  double distance(LatLng pos1, LatLng pos2) {
    return Math.sqrt(Math.pow((pos1.latitude - pos2.latitude), 2) +
        Math.pow((pos1.longitude - pos2.longitude), 2));
  }

  double getErr(LatLng newPos, LatLng currentPos) {
    int startIndex;
    double mindist, startDist1, startDist2;

    if (stepList.length == 0) return 0;

    for (int i = 0; i <= stepList.length - 1; i++) {
      LatLng point1 = LatLng(stepList[i].startLocation.latitude,
          stepList[i].startLocation.longitude);
      LatLng point2 = LatLng(
          stepList[i].endLocation.latitude, stepList[i].endLocation.longitude);
      double dist1 = distance(currentPos, point1);
      double dist2 = distance(currentPos, point2);
      double dist = dist1 + dist2;
      if (mindist == null) {
        mindist = dist;
        startDist1 = dist1;
        startDist2 = dist2;
        startIndex = i;
        continue;
      }
      if (dist < mindist) {
        mindist = dist;
        startDist1 = dist1;
        startDist2 = dist2;
        startIndex = i;
      }
    }

    int endIndex;
    mindist = null;
    double endDist1, endDist2;

    for (int i = 0; i <= stepList.length - 1; i++) {
      LatLng point1 = LatLng(stepList[i].startLocation.latitude,
          stepList[i].startLocation.longitude);
      LatLng point2 = LatLng(
          stepList[i].endLocation.latitude, stepList[i].endLocation.longitude);
      double dist1 = distance(newPos, point1);
      double dist2 = distance(newPos, point2);
      double dist = dist1 + dist2;
      if (mindist == null) {
        mindist = dist;
        endDist1 = dist1;
        endDist2 = dist2;
        endIndex = i;
        continue;
      }
      if (dist < mindist) {
        mindist = dist;
        endDist1 = dist1;
        endDist2 = dist2;
        endIndex = i;
      }
    }

    print('this is endIndex $endIndex');
    print('this is startIndex $startIndex');

    //positive err case
    //when ending index is ahead
    if (endIndex > startIndex) {
      //dist is in meters
      double dist = (startDist2 / (startDist1 + startDist2)) *
          stepList[startIndex].distance.value;
      for (int i = (startIndex + 1); i < endIndex; i++) {
        dist = dist + stepList[i].distance.value;
      }
      dist = dist +
          (endDist1 / (endDist1 + endDist2)) *
              stepList[endIndex].distance.value;
      return dist;
    }

    //negative err case
    //when starting index is ahead
    if (startIndex > endIndex) {
      //dist is in meters
      double dist = (endDist2 / (endDist1 + endDist2)) *
          stepList[endIndex].distance.value;
      for (int i = (endIndex + 1); i < startIndex; i++) {
        dist = dist + stepList[i].distance.value;
      }
      dist = dist +
          (startDist1 / (startDist1 + startDist2)) *
              stepList[startIndex].distance.value;
      return dist * (-1);
    }

    //when no step displacement just return the err difference
    return ((endDist1 - startDist1) / (endDist1 + endDist2)) *
        stepList[endIndex].distance.value;
  }

  LatLng snapToRoad(LatLng pos) {
    LatLng min1, min2;
    double mindist = 100000000, mindist1, mindist2;

    for (int i = 0; i < polyLineList.length - 1; i++) {
      LatLng point1 = polyLineList[i];
      LatLng point2 = polyLineList[i + 1];
      double dist1 = distance(pos, point1);
      double dist2 = distance(pos, point2);
      double dist = dist1 + dist2;
      if (dist < mindist) {
        mindist = dist;
        mindist1 = dist1;
        mindist2 = dist2;
        min1 = point1;
        min2 = point2;
      }
    }

    double m =
        (min1.latitude - min2.latitude) / (min1.longitude - min2.longitude);
    double m1 =
        (pos.latitude - min1.latitude) / (pos.longitude - min1.longitude);
    double m2 =
        (pos.latitude - min2.latitude) / (pos.longitude - min2.longitude);
    double x1 = (m1 - m) / (1 + m1 * m);
    double x2 = (m2 - m) / (1 + m2 * m);
    double cos1 = Math.sqrt(1 / (1 + x1 * x1));
    double cos2 = Math.sqrt(1 / (1 + x2 * x2));
    double k = (mindist1 * cos1) / (mindist2 * cos2);
    double longitude = ((k * min2.longitude + min1.longitude) / (k + 1));
    double latitude = ((k * min2.latitude + min1.latitude) / (k + 1));

    return LatLng(latitude, longitude);
  }
}
