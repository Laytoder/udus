import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frute/helpers/directionApiHelper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;
import 'package:angles/angles.dart';

class Map extends StatefulWidget {
  DirectionApiHelper directionApiHelper;
  Map(this.directionApiHelper);
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> with SingleTickerProviderStateMixin {
  GoogleMapController _controller;
  Uint8List markerImg;
  Marker marker;
  LatLng currentPos;
  AnimationController carController;
  List<LatLng> polyLineList;

  intitMarkerImg() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load('assets/car_icon.png');
    markerImg = byteData.buffer.asUint8List();
  }

  updateMarkerImg(LatLng newPos) {
    setState(() {
      marker = Marker(
        markerId: MarkerId('home'),
        position: newPos,
        rotation: getBearing(currentPos, newPos),
        draggable: false,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(markerImg),
      );
      currentPos = newPos;
    });
  }

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();
    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude)
      return (Angle.fromRadians(Math.atan(lng / lat)).degrees);
    else if (begin.latitude >= end.latitude && begin.longitude < end.longitude)
      return ((90 - Angle.fromRadians(Math.atan(lng / lat)).degrees) + 90);
    else if (begin.latitude >= end.latitude && begin.longitude >= end.longitude)
      return (Angle.fromRadians(Math.atan(lng / lat)).degrees + 180);
    else if (begin.latitude < end.latitude && begin.longitude >= end.longitude)
      return ((90 - Angle.fromRadians(Math.atan(lng / lat)).degrees) + 270);
    return -1;
  }

  startCarAnimation(Animation<double> anim) async {

    await intitMarkerImg();
    int index = 0, next;
    Timer.periodic(Duration(milliseconds: 3000), (timer) {
      LatLng startPosition, endPosition;
      if (index < polyLineList.length - 1) {
        index++;
        next = index + 1;
      }
      if (index < polyLineList.length - 1) {
        startPosition = polyLineList[index];
        endPosition = polyLineList[next];
      }
      anim..removeListener(() {});
      carController.reset();
      if(index == polyLineList.length - 2) timer.cancel();
      anim..addListener(() {
        double v = anim.value;
        double lng =
            v * endPosition.longitude + (1 - v) * startPosition.longitude;
        double lat =
            v * endPosition.latitude + (1 - v) * startPosition.latitude;
        LatLng newPos = new LatLng(lat, lng);
        updateMarkerImg(newPos);
      });
      carController.forward();
    });
  }

  @override
  void initState() {
    super.initState();

    carController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );

    Animation<double> anim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(carController);
    polyLineList = widget.directionApiHelper.points;
    currentPos = polyLineList[0];
    anim.addListener(() {});

    startCarAnimation(anim);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        initialCameraPosition: CameraPosition(
          target: widget.directionApiHelper.initCamera,
          zoom: 17,
          //bearing: 30,
          //tilt: 45,
        ),
        //cameraTargetBounds:
        //CameraTargetBounds(widget.directionApiHelper.bounds),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          CameraUpdate u2 = CameraUpdate.newLatLngBounds(
              widget.directionApiHelper.bounds, 50);
          _controller.animateCamera(u2);
        },
        mapType: MapType.normal,
        markers: Set<Marker>.of(marker == null ? [] : [marker]),
        polylines: Set<Polyline>.of([
          Polyline(
            polylineId: PolylineId('poly'),
            color: Colors.grey,
            width: 5,
            points: polyLineList,
            jointType: JointType.round,
            startCap: Cap.squareCap,
            endCap: Cap.squareCap,
          )
        ]),
      ),
    );
  }
}
